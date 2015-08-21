Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40901 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbbHUMIq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2015 08:08:46 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	lorenzo.bianconi83@gmail.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix VHT MCS mask array overrun
Date: Fri, 21 Aug 2015 14:08:41 +0200
Message-Id: <1440158921-6612-1-git-send-email-johannes@sipsolutions.net> (sfid-20150821_140850_490949_B5258C33)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The HT MCS mask has 9 bytes, the VHT one only has 8 streams.
Split the loops to handle this correctly.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 685ec13ed7c2..f4ed256c2d8e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2514,15 +2514,17 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 			continue;
 
 		for (j = 0; j < IEEE80211_HT_MCS_MASK_LEN; j++) {
-			if (~sdata->rc_rateidx_mcs_mask[i][j])
+			if (~sdata->rc_rateidx_mcs_mask[i][j]) {
 				sdata->rc_has_mcs_mask[i] = true;
+				break;
+			}
+		}
 
-			if (~sdata->rc_rateidx_vht_mcs_mask[i][j])
+		for (j = 0; j < NL80211_VHT_NSS_MAX; j++) {
+			if (~sdata->rc_rateidx_vht_mcs_mask[i][j]) {
 				sdata->rc_has_vht_mcs_mask[i] = true;
-
-			if (sdata->rc_has_mcs_mask[i] &&
-			    sdata->rc_has_vht_mcs_mask[i])
 				break;
+			}
 		}
 	}
 
-- 
2.1.4

