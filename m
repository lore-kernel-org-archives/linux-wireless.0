Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34553 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab1LSPqH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 10:46:07 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	mohammed@qca.qualcomm.com
Subject: [PATCH] ath9k: fix tx locking issues
Date: Mon, 19 Dec 2011 16:45:54 +0100
Message-Id: <1324309554-78839-1-git-send-email-nbd@openwrt.org> (sfid-20111219_164611_964860_B05B6425)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "ath9k: simplify tx locking" introduced a soft lockup triggered
by mac80211 sending a BAR frame triggered by a driver call to
ieee80211_tx_send_bar or ieee80211_tx_status.
Fix these issues by queueing processed tx status skbs and submitting them
to mac80211 outside of the lock.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/xmit.c  |   96 +++++++++++++++++++++-----------
 2 files changed, 65 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 130e5db..95276e9 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -196,6 +196,7 @@ struct ath_txq {
 	u8 txq_headidx;
 	u8 txq_tailidx;
 	int pending_frames;
+	struct sk_buff_head complete_q;
 };
 
 struct ath_atx_ac {
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 23e80e6..60d372b 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -104,6 +104,29 @@ static int ath_max_4ms_framelen[4][32] = {
 /* Aggregation logic */
 /*********************/
 
+static void ath_txq_lock(struct ath_softc *sc, struct ath_txq *txq)
+{
+	spin_lock_bh(&txq->axq_lock);
+}
+
+static void ath_txq_unlock(struct ath_softc *sc, struct ath_txq *txq)
+{
+	spin_unlock_bh(&txq->axq_lock);
+}
+
+static void ath_txq_unlock_complete(struct ath_softc *sc, struct ath_txq *txq)
+{
+	struct sk_buff_head q;
+	struct sk_buff *skb;
+
+	__skb_queue_head_init(&q);
+	skb_queue_splice_init(&txq->complete_q, &q);
+	spin_unlock_bh(&txq->axq_lock);
+
+	while ((skb = __skb_dequeue(&q)))
+		ieee80211_tx_status(sc->hw, skb);
+}
+
 static void ath_tx_queue_tid(struct ath_txq *txq, struct ath_atx_tid *tid)
 {
 	struct ath_atx_ac *ac = tid->ac;
@@ -130,7 +153,7 @@ static void ath_tx_resume_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 
 	WARN_ON(!tid->paused);
 
-	spin_lock_bh(&txq->axq_lock);
+	ath_txq_lock(sc, txq);
 	tid->paused = false;
 
 	if (skb_queue_empty(&tid->buf_q))
@@ -139,7 +162,7 @@ static void ath_tx_resume_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 	ath_tx_queue_tid(txq, tid);
 	ath_txq_schedule(sc, txq);
 unlock:
-	spin_unlock_bh(&txq->axq_lock);
+	ath_txq_unlock_complete(sc, txq);
 }
 
 static struct ath_frame_info *get_frame_info(struct sk_buff *skb)
@@ -189,8 +212,11 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 		tid->state &= ~AGGR_CLEANUP;
 	}
 
-	if (sendbar)
+	if (sendbar) {
+		ath_txq_unlock(sc, txq);
 		ath_send_bar(tid, tid->seq_start);
+		ath_txq_lock(sc, txq);
+	}
 }
 
 static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
@@ -554,13 +580,6 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		bf = bf_next;
 	}
 
-	if (bar_index >= 0) {
-		u16 bar_seq = ATH_BA_INDEX2SEQ(seq_first, bar_index);
-		ath_send_bar(tid, ATH_BA_INDEX2SEQ(seq_first, bar_index + 1));
-		if (BAW_WITHIN(tid->seq_start, tid->baw_size, bar_seq))
-			tid->bar_index = ATH_BA_INDEX(tid->seq_start, bar_seq);
-	}
-
 	/* prepend un-acked frames to the beginning of the pending frame queue */
 	if (!skb_queue_empty(&bf_pending)) {
 		if (an->sleeping)
@@ -575,6 +594,17 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		}
 	}
 
+	if (bar_index >= 0) {
+		u16 bar_seq = ATH_BA_INDEX2SEQ(seq_first, bar_index);
+
+		if (BAW_WITHIN(tid->seq_start, tid->baw_size, bar_seq))
+			tid->bar_index = ATH_BA_INDEX(tid->seq_start, bar_seq);
+
+		ath_txq_unlock(sc, txq);
+		ath_send_bar(tid, ATH_BA_INDEX2SEQ(seq_first, bar_index + 1));
+		ath_txq_lock(sc, txq);
+	}
+
 	if (tid->state & AGGR_CLEANUP)
 		ath_tx_flush_tid(sc, tid);
 
@@ -1172,7 +1202,7 @@ void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 		return;
 	}
 
-	spin_lock_bh(&txq->axq_lock);
+	ath_txq_lock(sc, txq);
 	txtid->paused = true;
 
 	/*
@@ -1187,7 +1217,7 @@ void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 		txtid->state &= ~AGGR_ADDBA_COMPLETE;
 
 	ath_tx_flush_tid(sc, txtid);
-	spin_unlock_bh(&txq->axq_lock);
+	ath_txq_unlock_complete(sc, txq);
 }
 
 void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
@@ -1208,7 +1238,7 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 		ac = tid->ac;
 		txq = ac->txq;
 
-		spin_lock_bh(&txq->axq_lock);
+		ath_txq_lock(sc, txq);
 
 		buffered = !skb_queue_empty(&tid->buf_q);
 
@@ -1220,7 +1250,7 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 			list_del(&ac->list);
 		}
 
-		spin_unlock_bh(&txq->axq_lock);
+		ath_txq_unlock(sc, txq);
 
 		ieee80211_sta_set_buffered(sta, tidno, buffered);
 	}
@@ -1239,7 +1269,7 @@ void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an)
 		ac = tid->ac;
 		txq = ac->txq;
 
-		spin_lock_bh(&txq->axq_lock);
+		ath_txq_lock(sc, txq);
 		ac->clear_ps_filter = true;
 
 		if (!skb_queue_empty(&tid->buf_q) && !tid->paused) {
@@ -1247,7 +1277,7 @@ void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an)
 			ath_txq_schedule(sc, txq);
 		}
 
-		spin_unlock_bh(&txq->axq_lock);
+		ath_txq_unlock_complete(sc, txq);
 	}
 }
 
@@ -1347,6 +1377,7 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 		txq->axq_qnum = axq_qnum;
 		txq->mac80211_qnum = -1;
 		txq->axq_link = NULL;
+		__skb_queue_head_init(&txq->complete_q);
 		INIT_LIST_HEAD(&txq->axq_q);
 		INIT_LIST_HEAD(&txq->axq_acq);
 		spin_lock_init(&txq->axq_lock);
@@ -1471,7 +1502,8 @@ static void ath_drain_txq_list(struct ath_softc *sc, struct ath_txq *txq,
  */
 void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 {
-	spin_lock_bh(&txq->axq_lock);
+	ath_txq_lock(sc, txq);
+
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
 		int idx = txq->txq_tailidx;
 
@@ -1492,7 +1524,7 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 	if ((sc->sc_flags & SC_OP_TXAGGR) && !retry_tx)
 		ath_txq_drain_pending_buffers(sc, txq);
 
-	spin_unlock_bh(&txq->axq_lock);
+	ath_txq_unlock_complete(sc, txq);
 }
 
 bool ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
@@ -1925,7 +1957,8 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 */
 
 	q = skb_get_queue_mapping(skb);
-	spin_lock_bh(&txq->axq_lock);
+
+	ath_txq_lock(sc, txq);
 	if (txq == sc->tx.txq_map[q] &&
 	    ++txq->pending_frames > ATH_MAX_QDEPTH && !txq->stopped) {
 		ieee80211_stop_queue(sc->hw, q);
@@ -1934,7 +1967,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 	ath_tx_start_dma(sc, skb, txctl);
 
-	spin_unlock_bh(&txq->axq_lock);
+	ath_txq_unlock(sc, txq);
 
 	return 0;
 }
@@ -1946,7 +1979,6 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 			    int tx_flags, struct ath_txq *txq)
 {
-	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ieee80211_hdr * hdr = (struct ieee80211_hdr *)skb->data;
@@ -1990,7 +2022,7 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 		}
 	}
 
-	ieee80211_tx_status(hw, skb);
+	__skb_queue_tail(&txq->complete_q, skb);
 }
 
 static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
@@ -2126,7 +2158,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		txq->axq_qnum, ath9k_hw_gettxbuf(sc->sc_ah, txq->axq_qnum),
 		txq->axq_link);
 
-	spin_lock_bh(&txq->axq_lock);
+	ath_txq_lock(sc, txq);
 	for (;;) {
 		if (work_pending(&sc->hw_reset_work))
 			break;
@@ -2185,7 +2217,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 
 		ath_tx_process_buffer(sc, txq, &ts, bf, &bf_head);
 	}
-	spin_unlock_bh(&txq->axq_lock);
+	ath_txq_unlock_complete(sc, txq);
 }
 
 static void ath_tx_complete_poll_work(struct work_struct *work)
@@ -2202,17 +2234,17 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
 		if (ATH_TXQ_SETUP(sc, i)) {
 			txq = &sc->tx.txq[i];
-			spin_lock_bh(&txq->axq_lock);
+			ath_txq_lock(sc, txq);
 			if (txq->axq_depth) {
 				if (txq->axq_tx_inprogress) {
 					needreset = true;
-					spin_unlock_bh(&txq->axq_lock);
+					ath_txq_unlock(sc, txq);
 					break;
 				} else {
 					txq->axq_tx_inprogress = true;
 				}
 			}
-			spin_unlock_bh(&txq->axq_lock);
+			ath_txq_unlock_complete(sc, txq);
 		}
 
 	if (needreset) {
@@ -2270,10 +2302,10 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 
 		txq = &sc->tx.txq[ts.qid];
 
-		spin_lock_bh(&txq->axq_lock);
+		ath_txq_lock(sc, txq);
 
 		if (list_empty(&txq->txq_fifo[txq->txq_tailidx])) {
-			spin_unlock_bh(&txq->axq_lock);
+			ath_txq_unlock(sc, txq);
 			return;
 		}
 
@@ -2299,7 +2331,7 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 		}
 
 		ath_tx_process_buffer(sc, txq, &ts, bf, &bf_head);
-		spin_unlock_bh(&txq->axq_lock);
+		ath_txq_unlock_complete(sc, txq);
 	}
 }
 
@@ -2437,7 +2469,7 @@ void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 		ac = tid->ac;
 		txq = ac->txq;
 
-		spin_lock_bh(&txq->axq_lock);
+		ath_txq_lock(sc, txq);
 
 		if (tid->sched) {
 			list_del(&tid->list);
@@ -2453,6 +2485,6 @@ void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 		tid->state &= ~AGGR_ADDBA_COMPLETE;
 		tid->state &= ~AGGR_CLEANUP;
 
-		spin_unlock_bh(&txq->axq_lock);
+		ath_txq_unlock(sc, txq);
 	}
 }
-- 
1.7.3.2

