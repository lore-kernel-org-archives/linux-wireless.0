Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39192 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab1I1MMs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 08:12:48 -0400
Message-Id: <20110928121128.616742159@sipsolutions.net> (sfid-20110928_141257_810924_18CA65AF)
Date: Wed, 28 Sep 2011 14:08:50 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 01/15] mac80211: let drivers inform it about per TID
 buffered frames
References: <20110928120849.882884360@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For uAPSD implementation, it is necessary to know on
which ACs frames are buffered. mac80211 obviously
knows about the frames it has buffered itself, but
with aggregation many drivers buffer frames. Thus,
mac80211 needs to be informed about this.

For now, since we don't have APSD in any form, this
will unconditionally set the TIM bit for the station
but later with uAPSD only some ACs might cause the
TIM bit to be set.

ath9k is the only driver using this API and I only
modify it in the most basic way, it won't be able
to implement uAPSD with this yet. But it can't do
that anyway since there's no way to selectively
release frames to the peer yet.

Since drivers will buffer frames per TID, let them
inform mac80211 on a per TID basis, mac80211 will
then sort out the AC mapping itself.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    3 ++-
 drivers/net/wireless/ath/ath9k/main.c  |    3 +--
 drivers/net/wireless/ath/ath9k/xmit.c  |   14 +++++++-------
 include/net/mac80211.h                 |   30 ++++++++++++++++++++++++------
 net/mac80211/sta_info.c                |    8 ++++++--
 5 files changed, 40 insertions(+), 18 deletions(-)

--- a/include/net/mac80211.h	2011-09-28 13:18:05.000000000 +0200
+++ b/include/net/mac80211.h	2011-09-28 13:18:28.000000000 +0200
@@ -2361,17 +2361,35 @@ static inline int ieee80211_sta_ps_trans
 #define IEEE80211_TX_STATUS_HEADROOM	13
 
 /**
- * ieee80211_sta_set_tim - set the TIM bit for a sleeping station
+ * ieee80211_sta_set_buffered - inform mac80211 about driver-buffered frames
  * @sta: &struct ieee80211_sta pointer for the sleeping station
+ * @tid: the TID that has buffered frames
+ * @buffered: indicates whether or not frames are buffered for this TID
  *
  * If a driver buffers frames for a powersave station instead of passing
- * them back to mac80211 for retransmission, the station needs to be told
- * to wake up using the TIM bitmap in the beacon.
+ * them back to mac80211 for retransmission, the station may still need
+ * to be told that there are buffered frames via the TIM bit.
  *
- * This function sets the station's TIM bit - it will be cleared when the
- * station wakes up.
+ * This function informs mac80211 whether or not there are frames that are
+ * buffered in the driver for a given TID; mac80211 can then use this data
+ * to set the TIM bit (NOTE: This may call back into the driver's set_tim
+ * call! Beware of the locking!)
+ *
+ * If all frames are released to the station (due to PS-poll or uAPSD)
+ * then the driver needs to inform mac80211 that there no longer are
+ * frames buffered. However, when the station wakes up mac80211 assumes
+ * that all buffered frames will be transmitted and clears this data,
+ * drivers need to make sure they inform mac80211 about all buffered
+ * frames on the sleep transition (sta_notify() with %STA_NOTIFY_SLEEP).
+ *
+ * Note that technically mac80211 only needs to know this per AC, not per
+ * TID, but since driver buffering will inevitably happen per TID (since
+ * it is related to aggregation) it is easier to make mac80211 map the
+ * TID to the AC as required instead of keeping track in all drivers that
+ * use this API.
  */
-void ieee80211_sta_set_tim(struct ieee80211_sta *sta);
+void ieee80211_sta_set_buffered(struct ieee80211_sta *sta,
+				u8 tid, bool buffered);
 
 /**
  * ieee80211_tx_status - transmit status callback
--- a/net/mac80211/sta_info.c	2011-09-28 11:39:20.000000000 +0200
+++ b/net/mac80211/sta_info.c	2011-09-28 13:18:28.000000000 +0200
@@ -1117,11 +1117,15 @@ void ieee80211_sta_block_awake(struct ie
 }
 EXPORT_SYMBOL(ieee80211_sta_block_awake);
 
-void ieee80211_sta_set_tim(struct ieee80211_sta *pubsta)
+void ieee80211_sta_set_buffered(struct ieee80211_sta *pubsta,
+				u8 tid, bool buffered)
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 
+	if (!buffered)
+		return;
+
 	set_sta_flags(sta, WLAN_STA_PS_DRIVER_BUF);
 	sta_info_set_tim_bit(sta);
 }
-EXPORT_SYMBOL(ieee80211_sta_set_tim);
+EXPORT_SYMBOL(ieee80211_sta_set_buffered);
--- a/drivers/net/wireless/ath/ath9k/ath9k.h	2011-09-28 11:39:20.000000000 +0200
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h	2011-09-28 13:18:28.000000000 +0200
@@ -340,7 +340,8 @@ void ath_tx_aggr_stop(struct ath_softc *
 void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
 
 void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an);
-bool ath_tx_aggr_sleep(struct ath_softc *sc, struct ath_node *an);
+void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
+		       struct ath_node *an);
 
 /********/
 /* VIFs */
--- a/drivers/net/wireless/ath/ath9k/main.c	2011-09-28 11:44:04.000000000 +0200
+++ b/drivers/net/wireless/ath/ath9k/main.c	2011-09-28 13:18:28.000000000 +0200
@@ -1833,8 +1833,7 @@ static void ath9k_sta_notify(struct ieee
 	switch (cmd) {
 	case STA_NOTIFY_SLEEP:
 		an->sleeping = true;
-		if (ath_tx_aggr_sleep(sc, an))
-			ieee80211_sta_set_tim(sta);
+		ath_tx_aggr_sleep(sta, sc, an);
 		break;
 	case STA_NOTIFY_AWAKE:
 		an->sleeping = false;
--- a/drivers/net/wireless/ath/ath9k/xmit.c	2011-09-28 11:39:20.000000000 +0200
+++ b/drivers/net/wireless/ath/ath9k/xmit.c	2011-09-28 13:18:28.000000000 +0200
@@ -542,7 +542,7 @@ static void ath_tx_complete_aggr(struct
 	/* prepend un-acked frames to the beginning of the pending frame queue */
 	if (!skb_queue_empty(&bf_pending)) {
 		if (an->sleeping)
-			ieee80211_sta_set_tim(sta);
+			ieee80211_sta_set_buffered(sta, tid->tidno, true);
 
 		spin_lock_bh(&txq->axq_lock);
 		if (clear_filter)
@@ -1153,12 +1153,13 @@ void ath_tx_aggr_stop(struct ath_softc *
 	ath_tx_flush_tid(sc, txtid);
 }
 
-bool ath_tx_aggr_sleep(struct ath_softc *sc, struct ath_node *an)
+void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
+		       struct ath_node *an)
 {
 	struct ath_atx_tid *tid;
 	struct ath_atx_ac *ac;
 	struct ath_txq *txq;
-	bool buffered = false;
+	bool buffered;
 	int tidno;
 
 	for (tidno = 0, tid = &an->tid[tidno];
@@ -1172,8 +1173,7 @@ bool ath_tx_aggr_sleep(struct ath_softc
 
 		spin_lock_bh(&txq->axq_lock);
 
-		if (!skb_queue_empty(&tid->buf_q))
-			buffered = true;
+		buffered = !skb_queue_empty(&tid->buf_q);
 
 		tid->sched = false;
 		list_del(&tid->list);
@@ -1184,9 +1184,9 @@ bool ath_tx_aggr_sleep(struct ath_softc
 		}
 
 		spin_unlock_bh(&txq->axq_lock);
-	}
 
-	return buffered;
+		ieee80211_sta_set_buffered(sta, tidno, buffered);
+	}
 }
 
 void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an)


