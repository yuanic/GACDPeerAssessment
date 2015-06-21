# Merge Train & Test Data to get one data set (1)
train.data <- read.table("UCI HAR Dataset/train/X_train.txt")
test.data <- read.table("UCI HAR Dataset/test/X_test.txt")
complete_data <- rbind(train.data,test.data)


# Get Mean and standard deviation measures only (2)
feature.names <- read.table("UCI HAR Dataset/features.txt")
selected.features <- grep("std|mean", feature.names$V2)
selected.data <- complete_data[,selected.features]


#  descriptive activity names to name the activities in the data set (3)
## Activities
train.activities <- read.table("UCI HAR Dataset/train/y_train.txt")
test.activities <- read.table("UCI HAR Dataset/test/y_test.txt")
total.activities <- rbind(train.activities, test.activities)
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt")
total.activities$activity <- factor(total.activities$V1, levels = activity.labels$V1, labels = activity.labels$V2)
## Subjects
train.subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
test.subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
total.subjects <- rbind(train.subjects, test.subjects)
## Activites & Subjects combined
subjects.and.activities <- cbind(total.subjects, total.activities$activity)


# Appropriately labels the data set with descriptive variable names (4)
colnames(selected.data) <- feature.names[selected.features, 2]
colnames(subjects.and.activities) <- c("subject.id", "activity")
tidy.data <- cbind(subjects.and.activities, selected.data)
	
write.table(tidy.data,"GACD_PeerAssessment/tidydata.csv",sep=";",row.names = FALSE)

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject (5)
result.frame <- aggregate(tidy.data[,3:81], by = list(tidy.data$subject.id, tidy.data$activity), FUN = mean)
colnames(result.frame)[1:2] <- c("subject.id", "activity")
write.table(result.frame, file="GACD_PeerAssessment/mean_measures.txt", row.names = FALSE)