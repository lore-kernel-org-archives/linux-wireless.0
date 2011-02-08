Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44138 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab1BHXcZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 18:32:25 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, lrodriguez@atheros.com, m.sujith@gmail.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [RFC v2 1/2] mac80211: add a function for setting the TIM bit for a specific station
Date: Wed,  9 Feb 2011 00:32:16 +0100
Message-Id: <1297207937-88528-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a driver wants to buffer some frames internally without feeding them
back to mac80211, this allows it to still wake up the station

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h  |   14 ++++++++++++++
 net/mac80211/sta_info.c |    8 ++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8fcd169..9a0babe 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2194,6 +2194,20 @@ static inline int ieee80211_sta_ps_transition_ni(struct ieee80211_sta *sta,
 #define IEEE80211_TX_STATUS_HEADROOM	13
 
 /**
+ * ieee80211_sta_set_tim - set the TIM bit for a sleeping station
+ *
+ * If a driver buffers frames for a powersave station instead of passing
+ * them back to mac80211 for retransmission, the station needs to be told
+ * to wake up using the TIM bitmap in the beacon.
+ *
+ * This function sets the station's TIM bit - it will be cleared automatically
+ * either when the station wakes up (and mac80211 has flushed out its
+ * buffered frames), or if all remaining buffered frames in mac80211 have
+ * timed out.
+ */
+void ieee80211_sta_set_tim(struct ieee80211_sta *sta);
+
+/**
  * ieee80211_tx_status - transmit status callback
  *
  * Call this function for all transmitted frames after they have been
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 5a11078..3458091 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -991,3 +991,11 @@ void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
 		ieee80211_queue_work(hw, &sta->drv_unblock_wk);
 }
 EXPORT_SYMBOL(ieee80211_sta_block_awake);
+
+void ieee80211_sta_set_tim(struct ieee80211_sta *pubsta)
+{
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+
+	sta_info_set_tim_bit(sta);
+}
+EXPORT_SYMBOL(ieee80211_sta_set_tim);
-- 
1.7.3.2

