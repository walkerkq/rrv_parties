# data from data http://rrrdc.com/dispatch-logs/ pulled 3.21.16

# read in the data set
party <- read.csv("rrv_loudparty.csv", stringsAsFactors=FALSE)
# format date
party$Date.Time <- as.Date(party$Date.Time, format="%m/%d/%y")
# assign a state to the location name
for(u in seq_along(party[,1])){
     if(party$Location[u] %in% c("Fargo", "West Fargo", "Casselton", 
                                 "Horace", "Mapleton", "Amenia", "Harwood")){
          party$Location[u] <- paste(party$Location[u], ", ND", sep="")
     } else {  party$Location[u] <- paste(party$Location[u], ", MN", sep="") }
}
# remove "BLK", create address line (300 BLK 32 AVE becomes 300 32 AVE for easier geocoding)
party$Full.Address <- toupper(paste(gsub("BLK ", "", party$Address), party$Location))
# aggregate by addresss
party2 <- data.frame(table(party$Full.Address))
# sort for highest frequencies
party2 <- party2[order(-party2$Freq), ]
# geocode addresses
party2$Geo <- geocode(as.character(party2$Var1))
# save lat and lon
party2$Lon <- party2$Geo$lon
party2$Lat <- party2$Geo$lat
party2$Geo <- NULL
colnames(party2) <- c("Address", "Number", "Lon", "Lat")
# write out the file
# write.csv(party2, "rrv_loudparty_geocoded.csv", row.names=FALSE)

