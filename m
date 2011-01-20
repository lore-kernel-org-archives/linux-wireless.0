Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43697 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab1ATU5j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 15:57:39 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/2] ath9k: clean up the code that wakes the mac80211 queues
Date: Thu, 20 Jan 2011 21:57:31 +0100
Message-Id: <1295557051-64138-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1295557051-64138-1-git-send-email-nbd@openwrt.org>
References: <1295557051-64138-1-git-send-email-nbd@openwrt.org>
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
 drivers/net/wireless/ath/ath9k/xmit.c |   43 ++++++++++++--------------------
 2 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c03184e..bee1db1 100644
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
index ad569e1..4695abc 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1208,8 +1208,17 @@ bool ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
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
@@ -1863,6 +1872,11 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
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
 
@@ -1972,19 +1986,6 @@ static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
 	tx_info->status.rates[tx_rateindex].count = ts->ts_longretry + 1;
 }
 
-static void ath_wake_mac80211_queue(struct ath_softc *sc, int qnum)
-{
-	struct ath_txq *txq;
-
-	txq = sc->tx.txq_map[qnum];
-	spin_lock_bh(&txq->axq_lock);
-	if (txq->stopped && txq->pending_frames < ATH_MAX_QDEPTH) {
-		if (ath_mac80211_start_queue(sc, qnum))
-			txq->stopped = 0;
-	}
-	spin_unlock_bh(&txq->axq_lock);
-}
-
 static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -1995,7 +1996,6 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 	struct ath_tx_status ts;
 	int txok;
 	int status;
-	int qnum;
 
 	ath_dbg(common, ATH_DBG_QUEUE, "tx queue %d (%x), link %p\n",
 		txq->axq_qnum, ath9k_hw_gettxbuf(sc->sc_ah, txq->axq_qnum),
@@ -2074,17 +2074,12 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 			ath_tx_rc_status(bf, &ts, 1, txok ? 0 : 1, txok, true);
 		}
 
-		qnum = skb_get_queue_mapping(bf->bf_mpdu);
-
 		if (bf_isampdu(bf))
 			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &ts, txok,
 					     true);
 		else
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, txok, 0);
 
-		if (txq == sc->tx.txq_map[qnum])
-			ath_wake_mac80211_queue(sc, qnum);
-
 		spin_lock_bh(&txq->axq_lock);
 		if (sc->sc_flags & SC_OP_TXAGGR)
 			ath_txq_schedule(sc, txq);
@@ -2153,7 +2148,6 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 	struct list_head bf_head;
 	int status;
 	int txok;
-	int qnum;
 
 	for (;;) {
 		status = ath9k_hw_txprocdesc(ah, NULL, (void *)&txs);
@@ -2199,8 +2193,6 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 			ath_tx_rc_status(bf, &txs, 1, txok ? 0 : 1, txok, true);
 		}
 
-		qnum = skb_get_queue_mapping(bf->bf_mpdu);
-
 		if (bf_isampdu(bf))
 			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &txs,
 					     txok, true);
@@ -2208,9 +2200,6 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 			ath_tx_complete_buf(sc, bf, txq, &bf_head,
 					    &txs, txok, 0);
 
-		if (txq == sc->tx.txq_map[qnum])
-			ath_wake_mac80211_queue(sc, qnum);
-
 		spin_lock_bh(&txq->axq_lock);
 		if (!list_empty(&txq->txq_fifo_pending)) {
 			INIT_LIST_HEAD(&bf_head);
-- 
1.7.3.2

