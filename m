Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40389 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051Ab1CKUiX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 15:38:23 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	vasanth@atheros.com, mark@moxienet.com
Subject: [PATCH v4 3/4] ath9k: fix the .flush driver op implementation
Date: Fri, 11 Mar 2011 21:38:19 +0100
Message-Id: <1299875900-3180-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1299875900-3180-2-git-send-email-nbd@openwrt.org>
References: <1299875900-3180-1-git-send-email-nbd@openwrt.org>
 <1299875900-3180-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch simplifies the flush op and reuses ath_drain_all_txq for
flushing out pending frames if necessary. It also uses a global timeout
of 200ms instead of the per-queue 60ms timeout.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/main.c  |   56 ++++++++++++--------------------
 drivers/net/wireless/ath/ath9k/xmit.c  |   28 +++++++--------
 3 files changed, 34 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index c718ab5..099bd41 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -189,7 +189,6 @@ struct ath_txq {
 	u32 axq_ampdu_depth;
 	bool stopped;
 	bool axq_tx_inprogress;
-	bool txq_flush_inprogress;
 	struct list_head axq_acq;
 	struct list_head txq_fifo[ATH_TXFIFO_DEPTH];
 	struct list_head txq_fifo_pending;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 2e228aa..115f162 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2128,56 +2128,42 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 
 static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
 {
-#define ATH_FLUSH_TIMEOUT	60 /* ms */
 	struct ath_softc *sc = hw->priv;
-	struct ath_txq *txq = NULL;
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	int i, j, npend = 0;
+	int timeout = 200; /* ms */
+	int i, j;
 
+	ath9k_ps_wakeup(sc);
 	mutex_lock(&sc->mutex);
 
 	cancel_delayed_work_sync(&sc->tx_complete_work);
 
-	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-		if (!ATH_TXQ_SETUP(sc, i))
-			continue;
-		txq = &sc->tx.txq[i];
+	if (drop)
+		timeout = 1;
 
-		if (!drop) {
-			for (j = 0; j < ATH_FLUSH_TIMEOUT; j++) {
-				if (!ath9k_has_pending_frames(sc, txq))
-					break;
-				usleep_range(1000, 2000);
-			}
-		}
+	for (j = 0; j < timeout; j++) {
+		int npend = 0;
+
+		if (j)
+			usleep_range(1000, 2000);
 
-		if (drop || ath9k_has_pending_frames(sc, txq)) {
-			ath_dbg(common, ATH_DBG_QUEUE, "Drop frames from hw queue:%d\n",
-				txq->axq_qnum);
-			spin_lock_bh(&txq->axq_lock);
-			txq->txq_flush_inprogress = true;
-			spin_unlock_bh(&txq->axq_lock);
-
-			ath9k_ps_wakeup(sc);
-			ath9k_hw_stoptxdma(ah, txq->axq_qnum);
-			npend = ath9k_hw_numtxpending(ah, txq->axq_qnum);
-			ath9k_ps_restore(sc);
-			if (npend)
-				break;
-
-			ath_draintxq(sc, txq, false);
-			txq->txq_flush_inprogress = false;
+		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
+			if (!ATH_TXQ_SETUP(sc, i))
+				continue;
+
+			npend += ath9k_has_pending_frames(sc, &sc->tx.txq[i]);
 		}
+
+		if (!npend)
+		    goto out;
 	}
 
-	if (npend) {
+	if (!ath_drain_all_txq(sc, false))
 		ath_reset(sc, false);
-		txq->txq_flush_inprogress = false;
-	}
 
+out:
 	ieee80211_queue_delayed_work(hw, &sc->tx_complete_work, 0);
 	mutex_unlock(&sc->mutex);
+	ath9k_ps_restore(sc);
 }
 
 struct ieee80211_ops ath9k_ops = {
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index bb1d29e..f977f80 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2012,8 +2012,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		spin_lock_bh(&txq->axq_lock);
 		if (list_empty(&txq->axq_q)) {
 			txq->axq_link = NULL;
-			if (sc->sc_flags & SC_OP_TXAGGR &&
-			    !txq->txq_flush_inprogress)
+			if (sc->sc_flags & SC_OP_TXAGGR)
 				ath_txq_schedule(sc, txq);
 			spin_unlock_bh(&txq->axq_lock);
 			break;
@@ -2094,7 +2093,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 
 		spin_lock_bh(&txq->axq_lock);
 
-		if (sc->sc_flags & SC_OP_TXAGGR && !txq->txq_flush_inprogress)
+		if (sc->sc_flags & SC_OP_TXAGGR)
 			ath_txq_schedule(sc, txq);
 		spin_unlock_bh(&txq->axq_lock);
 	}
@@ -2265,18 +2264,17 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 
 		spin_lock_bh(&txq->axq_lock);
 
-		if (!txq->txq_flush_inprogress) {
-			if (!list_empty(&txq->txq_fifo_pending)) {
-				INIT_LIST_HEAD(&bf_head);
-				bf = list_first_entry(&txq->txq_fifo_pending,
-						      struct ath_buf, list);
-				list_cut_position(&bf_head,
-						  &txq->txq_fifo_pending,
-						  &bf->bf_lastbf->list);
-				ath_tx_txqaddbuf(sc, txq, &bf_head);
-			} else if (sc->sc_flags & SC_OP_TXAGGR)
-				ath_txq_schedule(sc, txq);
-		}
+		if (!list_empty(&txq->txq_fifo_pending)) {
+			INIT_LIST_HEAD(&bf_head);
+			bf = list_first_entry(&txq->txq_fifo_pending,
+					      struct ath_buf, list);
+			list_cut_position(&bf_head,
+					  &txq->txq_fifo_pending,
+					  &bf->bf_lastbf->list);
+			ath_tx_txqaddbuf(sc, txq, &bf_head);
+		} else if (sc->sc_flags & SC_OP_TXAGGR)
+			ath_txq_schedule(sc, txq);
+
 		spin_unlock_bh(&txq->axq_lock);
 	}
 }
-- 
1.7.3.2

