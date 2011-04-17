Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43853 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840Ab1DQPpR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Apr 2011 11:45:17 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH] mac80211: add a function for setting the TIM bit for a specific station
Date: Sun, 17 Apr 2011 17:45:00 +0200
Message-Id: <1303055100-38307-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows a driver to buffer frames for a PS station and tell mac80211
to wake it up even though mac80211 does not have any buffered frames for
it.
This is necessary for properly handling aggregation related buffering,
in ath9k, because the driver needs to keep its frames in order to keep
track of the Block-ACK window.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h  |   12 ++++++++++++
 net/mac80211/sta_info.c |   13 ++++++++++++-
 net/mac80211/sta_info.h |    3 +++
 3 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6c9c4e9..d23dd6c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2227,6 +2227,18 @@ static inline int ieee80211_sta_ps_transition_ni(struct ieee80211_sta *sta,
 #define IEEE80211_TX_STATUS_HEADROOM	13
 
 /**
+ * ieee80211_sta_set_tim - set the TIM bit for a sleeping station
+ *
+ * If a driver buffers frames for a powersave station instead of passing
+ * them back to mac80211 for retransmission, the station needs to be told
+ * to wake up using the TIM bitmap in the beacon.
+ *
+ * This function sets the station's TIM bit - it will be cleared when the
+ * station wakes up.
+ */
+void ieee80211_sta_set_tim(struct ieee80211_sta *sta);
+
+/**
  * ieee80211_tx_status - transmit status callback
  *
  * Call this function for all transmitted frames after they have been
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 9421760..a03d8a3 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -612,7 +612,8 @@ static bool sta_info_cleanup_expire_buffered(struct ieee80211_local *local,
 #endif
 		dev_kfree_skb(skb);
 
-		if (skb_queue_empty(&sta->ps_tx_buf))
+		if (skb_queue_empty(&sta->ps_tx_buf) &&
+		    !test_sta_flags(sta, WLAN_STA_PS_DRIVER_BUF))
 			sta_info_clear_tim_bit(sta);
 	}
 
@@ -896,6 +897,7 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	struct ieee80211_local *local = sdata->local;
 	int sent, buffered;
 
+	clear_sta_flags(sta, WLAN_STA_PS_DRIVER_BUF);
 	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS))
 		drv_sta_notify(local, sdata, STA_NOTIFY_AWAKE, &sta->sta);
 
@@ -988,3 +990,12 @@ void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
 		ieee80211_queue_work(hw, &sta->drv_unblock_wk);
 }
 EXPORT_SYMBOL(ieee80211_sta_block_awake);
+
+void ieee80211_sta_set_tim(struct ieee80211_sta *pubsta)
+{
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+
+	set_sta_flags(sta, WLAN_STA_PS_DRIVER_BUF);
+	sta_info_set_tim_bit(sta);
+}
+EXPORT_SYMBOL(ieee80211_sta_set_tim);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 3415136..aa0adcb 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -43,6 +43,8 @@
  *	be in the queues
  * @WLAN_STA_PSPOLL: Station sent PS-poll while driver was keeping
  *	station in power-save mode, reply when the driver unblocks.
+ * @WLAN_STA_PS_DRIVER_BUF: Station has frames pending in driver internal
+ *	buffers. Automatically cleared on station wake-up.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH		= 1<<0,
@@ -58,6 +60,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_BLOCK_BA	= 1<<11,
 	WLAN_STA_PS_DRIVER	= 1<<12,
 	WLAN_STA_PSPOLL		= 1<<13,
+	WLAN_STA_PS_DRIVER_BUF	= 1<<14,
 };
 
 #define STA_TID_NUM 16
-- 
1.7.3.2

