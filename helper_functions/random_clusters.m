function [out] = random_clusters(dummy);
% function [out] = random_clusters(dummy);
% This assumes Cortical_MNI_coords.csv file is in same directory as the
% function

% Set these parameters to roughly match the parameters of the real dataset
% (i.e. about 500 samples within networks, rest our of network, with about 12
% within nextwork clusters
num_clusters=13;
radius=20;
dis_btw_clus=40; % at least twice the radius to make sure points are non-overlapping

coords=load('Cortical_MNI_coords.csv');
num_pts=size(coords,1);

for c=1:num_clusters,
    % here check to make sure the new point is far enough 
    % from all previous points
    if c > 1
        for p=1:size(clus_centers,1)      
            ind=floor(rand(1)*num_pts);
            dd=euc_dis(coords(ind,:),clus_centers(p,:));
            if dd > dis_btw_clus
                disp('Ok found a new sphere center')
                clus_centers(c,:)=coords(ind,:);
            end
        end
    else
        % This for the first point
        ind=floor(rand(1)*num_pts);
        clus_centers(c,:)=coords(ind,:); 
    end
    
    % now find all points within a radius of this point
    cn=1;
    for x=1:size(coords,1)
        dd=euc_dis(clus_centers(c,:),coords(x,:));
        if dd<radius
            cluster{c}(cn)=x;
            cn=cn+1;
        end       
    end
end

% Now get the rest of the indeces that aren't in the above
all_wi=[];
for c=1:length(cluster)
    all_wi=[all_wi cluster{c}];
end
[ZrestofBrain]=setdiff([1:size(coords,1)],all_wi);

% Here make the final cell array which will replace the 
% ind.W_all cell array in the real analysis. 
% ZrestofBrain should be the 9th array in the cell
out=[cluster(1:8) ZrestofBrain cluster(9:end)];


