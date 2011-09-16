Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56122 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab1IPJln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 05:41:43 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC] mac80211: Fix regression on queue stop during 2040 bss change
Date: Fri, 16 Sep 2011 15:12:19 +0530
Message-ID: <1316166139-5809-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110916_114147_512624_A050CBA0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "mac80211: stop tx before doing hw config and
rate update" stops the tx queue and call drv_flush so frequently
whenever a beacon got received with 11n htcap. This leads to
massive "Failed to stop TX DMA" logspam on embedded hw. So the
queue stop and flush should be called if and only if there is a
change in the channel type.

Reported-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/mlme.c |   43 ++++++++++++++++++++++++-------------------
 1 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2f92ae2..1a59fb6 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -160,7 +160,8 @@ static int ecw2cw(int ecw)
  */
 static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 			       struct ieee80211_ht_info *hti,
-			       const u8 *bssid, u16 ap_ht_cap_flags)
+			       const u8 *bssid, u16 ap_ht_cap_flags,
+			       bool beacon_htcap_ie)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
@@ -232,6 +233,21 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		WARN_ON(!ieee80211_set_channel_type(local, sdata, channel_type));
 	}
 
+	if (beacon_htcap_ie && (prev_chantype != channel_type)) {
+		/*
+		 * Whenever the AP announces the HT mode change that can be
+		 * 40MHz intolerant or etc., it would be safer to stop tx
+		 * queues before doing hw config to avoid buffer overflow.
+		 */
+		ieee80211_stop_queues_by_reason(&sdata->local->hw,
+				IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);
+
+		/* flush out all packets */
+		synchronize_net();
+
+		drv_flush(local, false);
+	}
+
 	/* channel_type change automatically detected */
 	ieee80211_hw_config(local, 0);
 
@@ -243,6 +259,10 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 						 IEEE80211_RC_HT_CHANGED,
 						 channel_type);
 		rcu_read_unlock();
+
+		if (beacon_htcap_ie)
+			ieee80211_wake_queues_by_reason(&sdata->local->hw,
+				IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);
 	}
 
 	ht_opmode = le16_to_cpu(hti->operation_mode);
@@ -1588,7 +1608,8 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 	    (sdata->local->hw.queues >= 4) &&
 	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
 		changed |= ieee80211_enable_ht(sdata, elems.ht_info_elem,
-					       cbss->bssid, ap_ht_cap_flags);
+					       cbss->bssid, ap_ht_cap_flags,
+					       false);
 
 	/* set AID and assoc capability,
 	 * ieee80211_set_associated() will tell the driver */
@@ -1921,24 +1942,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 		rcu_read_unlock();
 
-		/*
-		 * Whenever the AP announces the HT mode change that can be
-		 * 40MHz intolerant or etc., it would be safer to stop tx
-		 * queues before doing hw config to avoid buffer overflow.
-		 */
-		ieee80211_stop_queues_by_reason(&sdata->local->hw,
-				IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);
-
-		/* flush out all packets */
-		synchronize_net();
-
-		drv_flush(local, false);
-
 		changed |= ieee80211_enable_ht(sdata, elems.ht_info_elem,
-					       bssid, ap_ht_cap_flags);
-
-		ieee80211_wake_queues_by_reason(&sdata->local->hw,
-				IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);
+					       bssid, ap_ht_cap_flags, true);
 	}
 
 	/* Note: country IE parsing is done for us by cfg80211 */
-- 
1.7.6.1

