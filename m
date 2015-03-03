Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57746 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbbCCVcp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 16:32:45 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: fix beacon timers
Date: Tue,  3 Mar 2015 22:32:41 +0100
Message-Id: <1425418361-4116-1-git-send-email-johannes@sipsolutions.net> (sfid-20150303_223248_772820_65081709)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Jouni reported that certain combinations of hwsim test cases failed,
and we found that beaconing was erroneously enabled too early on any
channel switch, which lead to the BI of 2000 TU from the first test
case to leak into the second one, which then didn't beacon properly.

To fix this, set data->beacon_int to zero when all stop beaconing so
that beaconing cannot be started (which was intended as 'restarted')
elsewhere.

Additionally, Jouni found that due to this 'restart' and the beacon
interval handling station interfaces would also have a needlessly
running beacon timer all the time, of course not doing anything.

To also fix the latter case only use the beacon interval when it's
actually needed, i.e. when beaconing gets enabled.

Reported-by: Jouni Malinen <j@w1.fi>
Tested-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 32bd2f02c164..941925991476 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1595,21 +1595,16 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 		vp->aid = info->aid;
 	}
 
-	if (changed & BSS_CHANGED_BEACON_INT) {
-		wiphy_debug(hw->wiphy, "  BCNINT: %d\n", info->beacon_int);
-		data->beacon_int = info->beacon_int * 1024;
-	}
-
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
-		wiphy_debug(hw->wiphy, "  BCN EN: %d\n", info->enable_beacon);
+		wiphy_debug(hw->wiphy, "  BCN EN: %d (BI=%u)\n",
+			    info->enable_beacon, info->beacon_int);
 		vp->bcn_en = info->enable_beacon;
 		if (data->started &&
 		    !hrtimer_is_queued(&data->beacon_timer.timer) &&
 		    info->enable_beacon) {
 			u64 tsf, until_tbtt;
 			u32 bcn_int;
-			if (WARN_ON(!data->beacon_int))
-				data->beacon_int = 1000 * 1024;
+			data->beacon_int = info->beacon_int * 1024;
 			tsf = mac80211_hwsim_get_tsf(hw, vif);
 			bcn_int = data->beacon_int;
 			until_tbtt = bcn_int - do_div(tsf, bcn_int);
@@ -1623,8 +1618,10 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 				mac80211_hwsim_bcn_en_iter, &count);
 			wiphy_debug(hw->wiphy, "  beaconing vifs remaining: %u",
 				    count);
-			if (count == 0)
+			if (count == 0) {
 				tasklet_hrtimer_cancel(&data->beacon_timer);
+				data->beacon_int = 0;
+			}
 		}
 	}
 
-- 
2.1.4

