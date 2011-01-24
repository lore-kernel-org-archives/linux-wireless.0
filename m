Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35353 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971Ab1AXSXX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 13:23:23 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH v4 1/5] ath9k: clean up the code that wakes the mac80211 queues
Date: Mon, 24 Jan 2011 19:23:14 +0100
Message-Id: <1295893398-5124-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of spreading ath_wake_mac80211_queue() calls over multiple places
in the tx path that process the tx queue for completion, call it only
where the pending frames counter gets decremented, eliminating some
redundant checks.
To prevent queue draining from waking the queues prematurely (e.g. during
a hardware reset), reset the queue stop state when draining all queues,
as the caller in main.c will run ieee80211_wake_queues(hw) anyway.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 +
 drivers/net/wireless/ath/ath9k/xmit.c |   39 +++++++++++++-------------------
 2 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index facff10..7d7b48f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -295,6 +295,8 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	}
 
  ps_restore:
+	ieee80211_wake_queues(hw);
+
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
 	ath9k_ps_restore(sc);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index adec862..10eaaf9 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1209,8 +1209,17 @@ bool ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 		ath_err(common, "Failed to stop TX DMA!\n");
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-		if (ATH_TXQ_SETUP(sc, i))
-			ath_draintxq(sc, &sc->tx.txq[i], retry_tx);
+		if (!ATH_TXQ_SETUP(sc, i))
+			continue;
+
+		/*
+		 * The caller will resume queues with ieee80211_wake_queues.
+		 * Mark the queue as not stopped to prevent ath_tx_complete
+		 * from waking the queue too early.
+		 */
+		txq = &sc->tx.txq[i];
+		txq->stopped = false;
+		ath_draintxq(sc, txq, retry_tx);
 	}
 
 	return !npend;
@@ -1878,6 +1887,11 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 			spin_lock_bh(&txq->axq_lock);
 			if (WARN_ON(--txq->pending_frames < 0))
 				txq->pending_frames = 0;
+
+			if (txq->stopped && txq->pending_frames < ATH_MAX_QDEPTH) {
+				if (ath_mac80211_start_queue(sc, q))
+					txq->stopped = 0;
+			}
 			spin_unlock_bh(&txq->axq_lock);
 		}
 
@@ -1987,18 +2001,6 @@ static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
 	tx_info->status.rates[tx_rateindex].count = ts->ts_longretry + 1;
 }
 
-/* Has no locking.  Must hold spin_lock_bh(&txq->axq_lock)
- * before calling this.
- */
-static void __ath_wake_mac80211_queue(struct ath_softc *sc, struct ath_txq *txq)
-{
-	if (txq->mac80211_qnum >= 0 &&
-	    txq->stopped && txq->pending_frames < ATH_MAX_QDEPTH) {
-		if (ath_mac80211_start_queue(sc, txq->mac80211_qnum))
-			txq->stopped = 0;
-	}
-}
-
 static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -2009,7 +2011,6 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 	struct ath_tx_status ts;
 	int txok;
 	int status;
-	int qnum;
 
 	ath_dbg(common, ATH_DBG_QUEUE, "tx queue %d (%x), link %p\n",
 		txq->axq_qnum, ath9k_hw_gettxbuf(sc->sc_ah, txq->axq_qnum),
@@ -2091,8 +2092,6 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 			ath_tx_rc_status(bf, &ts, 1, txok ? 0 : 1, txok, true);
 		}
 
-		qnum = skb_get_queue_mapping(bf->bf_mpdu);
-
 		if (bf_isampdu(bf))
 			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &ts, txok,
 					     true);
@@ -2100,7 +2099,6 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, txok, 0);
 
 		spin_lock_bh(&txq->axq_lock);
-		__ath_wake_mac80211_queue(sc, txq);
 
 		if (sc->sc_flags & SC_OP_TXAGGR)
 			ath_txq_schedule(sc, txq);
@@ -2156,7 +2154,6 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 						txq->pending_frames,
 						list_empty(&txq->axq_acq),
 						txq->stopped);
-					__ath_wake_mac80211_queue(sc, txq);
 					ath_txq_schedule(sc, txq);
 				}
 			}
@@ -2198,7 +2195,6 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 	struct list_head bf_head;
 	int status;
 	int txok;
-	int qnum;
 
 	for (;;) {
 		status = ath9k_hw_txprocdesc(ah, NULL, (void *)&txs);
@@ -2244,8 +2240,6 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 			ath_tx_rc_status(bf, &txs, 1, txok ? 0 : 1, txok, true);
 		}
 
-		qnum = skb_get_queue_mapping(bf->bf_mpdu);
-
 		if (bf_isampdu(bf))
 			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &txs,
 					     txok, true);
@@ -2254,7 +2248,6 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 					    &txs, txok, 0);
 
 		spin_lock_bh(&txq->axq_lock);
-		__ath_wake_mac80211_queue(sc, txq);
 
 		if (!list_empty(&txq->txq_fifo_pending)) {
 			INIT_LIST_HEAD(&bf_head);
-- 
1.7.3.2

