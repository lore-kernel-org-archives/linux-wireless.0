Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49456 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754354AbdEDFwO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 May 2017 01:52:14 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: improve warnings in VHT rate calculation
Date: Thu,  4 May 2017 07:52:10 +0200
Message-Id: <20170504055210.4088-1-johannes@sipsolutions.net> (sfid-20170504_075309_187677_C994C48B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Linus reported hitting the bandwidth warning, but it is indeed
pretty useless - improve it by printing the rate configuration
and make it only warn once, for both warnings here.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/util.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 7198373e2920..a10d5c7bdf63 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1217,8 +1217,8 @@ static u32 cfg80211_calculate_bitrate_vht(struct rate_info *rate)
 	u32 bitrate;
 	int idx;
 
-	if (WARN_ON_ONCE(rate->mcs > 9))
-		return 0;
+	if (rate->mcs > 9)
+		goto warn;
 
 	switch (rate->bw) {
 	case RATE_INFO_BW_160:
@@ -1233,8 +1233,7 @@ static u32 cfg80211_calculate_bitrate_vht(struct rate_info *rate)
 	case RATE_INFO_BW_5:
 	case RATE_INFO_BW_10:
 	default:
-		WARN_ON(1);
-		/* fall through */
+		goto warn;
 	case RATE_INFO_BW_20:
 		idx = 0;
 	}
@@ -1247,6 +1246,10 @@ static u32 cfg80211_calculate_bitrate_vht(struct rate_info *rate)
 
 	/* do NOT round down here */
 	return (bitrate + 50000) / 100000;
+ warn:
+	WARN_ONCE(1, "invalid rate bw=%d, mcs=%d, nss=%d\n",
+		  rate->bw, rate->mcs, rate->nss);
+	return 0;
 }
 
 u32 cfg80211_calculate_bitrate(struct rate_info *rate)
-- 
2.11.0
