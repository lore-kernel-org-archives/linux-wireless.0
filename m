Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40399 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaAVKvo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 05:51:44 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: [PATCH] mac80211_hwsim: add channel switch support
Date: Wed, 22 Jan 2014 11:51:39 +0100
Message-Id: <1390387899-28972-1-git-send-email-johannes@sipsolutions.net> (sfid-20140122_115147_378608_159CA734)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Advertise to mac80211 that we can do channel switch both
for STA and AP/GO.
After each beacon transmission check if CSA is done and
call ieee80211_csa_finish if needed.

Change-Id: I1cb34c04f533275522236381ae14b624bec35418
Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 4950359..5268ede 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1307,6 +1307,9 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 
 	mac80211_hwsim_tx_frame(hw, skb,
 				rcu_dereference(vif->chanctx_conf)->def.chan);
+
+	if (vif->csa_active && ieee80211_csa_is_complete(vif))
+		ieee80211_csa_finish(vif);
 }
 
 static enum hrtimer_restart
@@ -2109,13 +2112,15 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 		    IEEE80211_HW_AMPDU_AGGREGATION |
 		    IEEE80211_HW_WANT_MONITOR_VIF |
 		    IEEE80211_HW_QUEUE_CONTROL |
-		    IEEE80211_HW_SUPPORTS_HT_CCK_RATES;
+		    IEEE80211_HW_SUPPORTS_HT_CCK_RATES |
+		    IEEE80211_HW_CHANCTX_STA_CSA;
 	if (rctbl)
 		hw->flags |= IEEE80211_HW_SUPPORTS_RC_TABLE;
 
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
 			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
-			    WIPHY_FLAG_AP_UAPSD;
+			    WIPHY_FLAG_AP_UAPSD |
+			    WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 	hw->wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
 
 	/* ask mac80211 to reserve space for magic */
-- 
1.8.5.1

