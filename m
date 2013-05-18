Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56755 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab3ERT23 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 15:28:29 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3.10] ath9k: prevent aggregation session deadlocks
Date: Sat, 18 May 2013 21:28:15 +0200
Message-Id: <1368905295-51440-1-git-send-email-nbd@openwrt.org> (sfid-20130518_212844_582722_1996DF41)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Waiting for all subframes of an existing aggregation session to drain
before allowing mac80211 to start a new one is fragile and deadlocks
caused by this behavior have been observed.

Since mac80211 has proper synchronization for aggregation session
start/stop handling, a better approach to session handling is to simply
allow mac80211 to start a new session at any time. This requires
changing the code to discard any packets outside of the BlockAck window
in the A-MPDU software retry code.

This patch implements the above and also simplifies the code.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  14 +---
 drivers/net/wireless/ath/ath9k/main.c  |   3 +-
 drivers/net/wireless/ath/ath9k/rc.c    |   5 +-
 drivers/net/wireless/ath/ath9k/xmit.c  | 138 ++++++++++-----------------------
 4 files changed, 46 insertions(+), 114 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 366002f..42b03dc 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -251,10 +251,9 @@ struct ath_atx_tid {
 	int tidno;
 	int baw_head;   /* first un-acked tx buffer */
 	int baw_tail;   /* next unused tx buffer slot */
-	int sched;
-	int paused;
-	u8 state;
-	bool stop_cb;
+	bool sched;
+	bool paused;
+	bool active;
 };
 
 struct ath_node {
@@ -275,10 +274,6 @@ struct ath_node {
 #endif
 };
 
-#define AGGR_CLEANUP         BIT(1)
-#define AGGR_ADDBA_COMPLETE  BIT(2)
-#define AGGR_ADDBA_PROGRESS  BIT(3)
-
 struct ath_tx_control {
 	struct ath_txq *txq;
 	struct ath_node *an;
@@ -352,8 +347,7 @@ void ath_tx_tasklet(struct ath_softc *sc);
 void ath_tx_edma_tasklet(struct ath_softc *sc);
 int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 		      u16 tid, u16 *ssn);
-bool ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid,
-		      bool flush);
+void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
 void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
 
 void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 2382d12..5092eca 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1709,7 +1709,8 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 		flush = true;
 	case IEEE80211_AMPDU_TX_STOP_CONT:
 		ath9k_ps_wakeup(sc);
-		if (ath_tx_aggr_stop(sc, sta, tid, flush))
+		ath_tx_aggr_stop(sc, sta, tid);
+		if (!flush)
 			ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		ath9k_ps_restore(sc);
 		break;
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index aa4d368..7eb1f4b 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1227,10 +1227,7 @@ static bool ath_tx_aggr_check(struct ath_softc *sc, struct ieee80211_sta *sta,
 		return false;
 
 	txtid = ATH_AN_2_TID(an, tidno);
-
-	if (!(txtid->state & (AGGR_ADDBA_COMPLETE | AGGR_ADDBA_PROGRESS)))
-			return true;
-	return false;
+	return !txtid->active;
 }
 
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 14bb335..1c9b1ba 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -125,24 +125,6 @@ static void ath_tx_queue_tid(struct ath_txq *txq, struct ath_atx_tid *tid)
 	list_add_tail(&ac->list, &txq->axq_acq);
 }
 
-static void ath_tx_resume_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
-{
-	struct ath_txq *txq = tid->ac->txq;
-
-	WARN_ON(!tid->paused);
-
-	ath_txq_lock(sc, txq);
-	tid->paused = false;
-
-	if (skb_queue_empty(&tid->buf_q))
-		goto unlock;
-
-	ath_tx_queue_tid(txq, tid);
-	ath_txq_schedule(sc, txq);
-unlock:
-	ath_txq_unlock_complete(sc, txq);
-}
-
 static struct ath_frame_info *get_frame_info(struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
@@ -164,20 +146,7 @@ static void ath_set_rates(struct ieee80211_vif *vif, struct ieee80211_sta *sta,
 			       ARRAY_SIZE(bf->rates));
 }
 
-static void ath_tx_clear_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
-{
-	tid->state &= ~AGGR_ADDBA_COMPLETE;
-	tid->state &= ~AGGR_CLEANUP;
-	if (!tid->stop_cb)
-		return;
-
-	ieee80211_start_tx_ba_cb_irqsafe(tid->an->vif, tid->an->sta->addr,
-					 tid->tidno);
-	tid->stop_cb = false;
-}
-
-static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid,
-			     bool flush_packets)
+static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 {
 	struct ath_txq *txq = tid->ac->txq;
 	struct sk_buff *skb;
@@ -194,15 +163,16 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid,
 	while ((skb = __skb_dequeue(&tid->buf_q))) {
 		fi = get_frame_info(skb);
 		bf = fi->bf;
-		if (!bf && !flush_packets)
-			bf = ath_tx_setup_buffer(sc, txq, tid, skb);
 
 		if (!bf) {
-			ieee80211_free_txskb(sc->hw, skb);
-			continue;
+			bf = ath_tx_setup_buffer(sc, txq, tid, skb);
+			if (!bf) {
+				ieee80211_free_txskb(sc->hw, skb);
+				continue;
+			}
 		}
 
-		if (fi->retries || flush_packets) {
+		if (fi->retries) {
 			list_add_tail(&bf->list, &bf_head);
 			ath_tx_update_baw(sc, tid, bf->bf_state.seqno);
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0);
@@ -213,10 +183,7 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid,
 		}
 	}
 
-	if (tid->baw_head == tid->baw_tail)
-		ath_tx_clear_tid(sc, tid);
-
-	if (sendbar && !flush_packets) {
+	if (sendbar) {
 		ath_txq_unlock(sc, txq);
 		ath_send_bar(tid, tid->seq_start);
 		ath_txq_lock(sc, txq);
@@ -499,19 +466,19 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		tx_info = IEEE80211_SKB_CB(skb);
 		fi = get_frame_info(skb);
 
-		if (ATH_BA_ISSET(ba, ATH_BA_INDEX(seq_st, seqno))) {
+		if (!BAW_WITHIN(tid->seq_start, tid->baw_size, seqno)) {
+			/*
+			 * Outside of the current BlockAck window,
+			 * maybe part of a previous session
+			 */
+			txfail = 1;
+		} else if (ATH_BA_ISSET(ba, ATH_BA_INDEX(seq_st, seqno))) {
 			/* transmit completion, subframe is
 			 * acked by block ack */
 			acked_cnt++;
 		} else if (!isaggr && txok) {
 			/* transmit completion */
 			acked_cnt++;
-		} else if (tid->state & AGGR_CLEANUP) {
-			/*
-			 * cleanup in progress, just fail
-			 * the un-acked sub-frames
-			 */
-			txfail = 1;
 		} else if (flush) {
 			txpending = 1;
 		} else if (fi->retries < ATH_MAX_SW_RETRIES) {
@@ -535,7 +502,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		if (bf_next != NULL || !bf_last->bf_stale)
 			list_move_tail(&bf->list, &bf_head);
 
-		if (!txpending || (tid->state & AGGR_CLEANUP)) {
+		if (!txpending) {
 			/*
 			 * complete the acked-ones/xretried ones; update
 			 * block-ack window
@@ -609,9 +576,6 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		ath_txq_lock(sc, txq);
 	}
 
-	if (tid->state & AGGR_CLEANUP)
-		ath_tx_flush_tid(sc, tid, false);
-
 	rcu_read_unlock();
 
 	if (needreset)
@@ -1244,9 +1208,6 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 	an = (struct ath_node *)sta->drv_priv;
 	txtid = ATH_AN_2_TID(an, tid);
 
-	if (txtid->state & (AGGR_CLEANUP | AGGR_ADDBA_COMPLETE))
-		return -EAGAIN;
-
 	/* update ampdu factor/density, they may have changed. This may happen
 	 * in HT IBSS when a beacon with HT-info is received after the station
 	 * has already been added.
@@ -1258,7 +1219,7 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 		an->mpdudensity = density;
 	}
 
-	txtid->state |= AGGR_ADDBA_PROGRESS;
+	txtid->active = true;
 	txtid->paused = true;
 	*ssn = txtid->seq_start = txtid->seq_next;
 	txtid->bar_index = -1;
@@ -1269,45 +1230,17 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 	return 0;
 }
 
-bool ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid,
-		      bool flush)
+void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 {
 	struct ath_node *an = (struct ath_node *)sta->drv_priv;
 	struct ath_atx_tid *txtid = ATH_AN_2_TID(an, tid);
 	struct ath_txq *txq = txtid->ac->txq;
-	bool ret = !flush;
-
-	if (flush)
-		txtid->stop_cb = false;
-
-	if (txtid->state & AGGR_CLEANUP)
-		return false;
-
-	if (!(txtid->state & AGGR_ADDBA_COMPLETE)) {
-		txtid->state &= ~AGGR_ADDBA_PROGRESS;
-		return ret;
-	}
 
 	ath_txq_lock(sc, txq);
+	txtid->active = false;
 	txtid->paused = true;
-
-	/*
-	 * If frames are still being transmitted for this TID, they will be
-	 * cleaned up during tx completion. To prevent race conditions, this
-	 * TID can only be reused after all in-progress subframes have been
-	 * completed.
-	 */
-	if (txtid->baw_head != txtid->baw_tail) {
-		txtid->state |= AGGR_CLEANUP;
-		ret = false;
-		txtid->stop_cb = !flush;
-	} else {
-		txtid->state &= ~AGGR_ADDBA_COMPLETE;
-	}
-
-	ath_tx_flush_tid(sc, txtid, flush);
+	ath_tx_flush_tid(sc, txtid);
 	ath_txq_unlock_complete(sc, txq);
-	return ret;
 }
 
 void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
@@ -1371,18 +1304,28 @@ void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an)
 	}
 }
 
-void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
+void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta,
+			u16 tidno)
 {
-	struct ath_atx_tid *txtid;
+	struct ath_atx_tid *tid;
 	struct ath_node *an;
+	struct ath_txq *txq;
 
 	an = (struct ath_node *)sta->drv_priv;
+	tid = ATH_AN_2_TID(an, tidno);
+	txq = tid->ac->txq;
 
-	txtid = ATH_AN_2_TID(an, tid);
-	txtid->baw_size = IEEE80211_MIN_AMPDU_BUF << sta->ht_cap.ampdu_factor;
-	txtid->state |= AGGR_ADDBA_COMPLETE;
-	txtid->state &= ~AGGR_ADDBA_PROGRESS;
-	ath_tx_resume_tid(sc, txtid);
+	ath_txq_lock(sc, txq);
+
+	tid->baw_size = IEEE80211_MIN_AMPDU_BUF << sta->ht_cap.ampdu_factor;
+	tid->paused = false;
+
+	if (!skb_queue_empty(&tid->buf_q)) {
+		ath_tx_queue_tid(txq, tid);
+		ath_txq_schedule(sc, txq);
+	}
+
+	ath_txq_unlock_complete(sc, txq);
 }
 
 /********************/
@@ -2431,13 +2374,10 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 		tid->baw_head  = tid->baw_tail = 0;
 		tid->sched     = false;
 		tid->paused    = false;
-		tid->state &= ~AGGR_CLEANUP;
+		tid->active	   = false;
 		__skb_queue_head_init(&tid->buf_q);
 		acno = TID_TO_WME_AC(tidno);
 		tid->ac = &an->ac[acno];
-		tid->state &= ~AGGR_ADDBA_COMPLETE;
-		tid->state &= ~AGGR_ADDBA_PROGRESS;
-		tid->stop_cb = false;
 	}
 
 	for (acno = 0, ac = &an->ac[acno];
@@ -2474,7 +2414,7 @@ void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 		}
 
 		ath_tid_drain(sc, txq, tid);
-		ath_tx_clear_tid(sc, tid);
+		tid->active = false;
 
 		ath_txq_unlock(sc, txq);
 	}
-- 
1.8.0.2

