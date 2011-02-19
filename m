Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:37671 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab1BSJNq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 04:13:46 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 19 Feb 2011 01:13:25 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Implement op_flush()
Date: Sat, 19 Feb 2011 01:13:42 -0800
Message-ID: <1298106822-9411-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When op_flush() is called with no drop (drop=false), the driver
tries to tx as many frames as possible in about 100ms on every
hw queue. During this time period frames from sw queue are also
scheduled on to respective hw queue.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |   71 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/xmit.c  |   27 +++++++-----
 3 files changed, 88 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a224c56..f9f0389 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -189,6 +189,7 @@ struct ath_txq {
 	u32 axq_ampdu_depth;
 	bool stopped;
 	bool axq_tx_inprogress;
+	bool txq_flush_inprogress;
 	struct list_head axq_acq;
 	struct list_head txq_fifo[ATH_TXFIFO_DEPTH];
 	struct list_head txq_fifo_pending;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1d2c7c3..a715500 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/nl80211.h>
+#include <linux/delay.h>
 #include "ath9k.h"
 #include "btcoex.h"
 
@@ -53,6 +54,21 @@ static u8 parse_mpdudensity(u8 mpdudensity)
 	}
 }
 
+static bool ath9k_has_pending_frames(struct ath_softc *sc, struct ath_txq *txq)
+{
+	bool pending = false;
+
+	spin_lock_bh(&txq->axq_lock);
+
+	if (txq->axq_depth || !list_empty(&txq->axq_acq))
+		pending = true;
+	else if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
+		pending = !list_empty(&txq->txq_fifo_pending);
+
+	spin_unlock_bh(&txq->axq_lock);
+	return pending;
+}
+
 bool ath9k_setpower(struct ath_softc *sc, enum ath9k_power_mode mode)
 {
 	unsigned long flags;
@@ -2111,6 +2127,60 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 	mutex_unlock(&sc->mutex);
 }
 
+static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
+{
+#define ATH_FLUSH_TIMEOUT	60 /* ms */
+	struct ath_softc *sc = hw->priv;
+	struct ath_txq *txq;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	int i, j, npend = 0;
+
+	mutex_lock(&sc->mutex);
+
+	cancel_delayed_work_sync(&sc->tx_complete_work);
+
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
+		if (!ATH_TXQ_SETUP(sc, i))
+			continue;
+		txq = &sc->tx.txq[i];
+
+		if (!drop) {
+			for (j = 0; j < ATH_FLUSH_TIMEOUT; j++) {
+				if (!ath9k_has_pending_frames(sc, txq))
+					break;
+				usleep_range(1000, 2000);
+			}
+		}
+
+		if (drop || ath9k_has_pending_frames(sc, txq)) {
+			ath_dbg(common, ATH_DBG_QUEUE, "Drop frames from hw queue:%d\n",
+				txq->axq_qnum);
+			spin_lock_bh(&txq->axq_lock);
+			txq->txq_flush_inprogress = true;
+			spin_unlock_bh(&txq->axq_lock);
+
+			ath9k_ps_wakeup(sc);
+			ath9k_hw_stoptxdma(ah, txq->axq_qnum);
+			npend = ath9k_hw_numtxpending(ah, txq->axq_qnum);
+			ath9k_ps_restore(sc);
+			if (npend)
+				break;
+
+			ath_draintxq(sc, txq, false);
+			txq->txq_flush_inprogress = false;
+		}
+	}
+
+	if (npend) {
+		ath_reset(sc, false);
+		txq->txq_flush_inprogress = false;
+	}
+
+	ieee80211_queue_delayed_work(hw, &sc->tx_complete_work, 0);
+	mutex_unlock(&sc->mutex);
+}
+
 struct ieee80211_ops ath9k_ops = {
 	.tx 		    = ath9k_tx,
 	.start 		    = ath9k_start,
@@ -2132,4 +2202,5 @@ struct ieee80211_ops ath9k_ops = {
 	.get_survey	    = ath9k_get_survey,
 	.rfkill_poll        = ath9k_rfkill_poll_state,
 	.set_coverage_class = ath9k_set_coverage_class,
+	.flush		    = ath9k_flush,
 };
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index bc614ac..e16136d 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2014,7 +2014,8 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		spin_lock_bh(&txq->axq_lock);
 		if (list_empty(&txq->axq_q)) {
 			txq->axq_link = NULL;
-			if (sc->sc_flags & SC_OP_TXAGGR)
+			if (sc->sc_flags & SC_OP_TXAGGR &&
+			    !txq->txq_flush_inprogress)
 				ath_txq_schedule(sc, txq);
 			spin_unlock_bh(&txq->axq_lock);
 			break;
@@ -2071,6 +2072,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 
 		if (bf_is_ampdu_not_probing(bf))
 			txq->axq_ampdu_depth--;
+
 		spin_unlock_bh(&txq->axq_lock);
 
 		if (bf_held)
@@ -2094,7 +2096,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 
 		spin_lock_bh(&txq->axq_lock);
 
-		if (sc->sc_flags & SC_OP_TXAGGR)
+		if (sc->sc_flags & SC_OP_TXAGGR && !txq->txq_flush_inprogress)
 			ath_txq_schedule(sc, txq);
 		spin_unlock_bh(&txq->axq_lock);
 	}
@@ -2265,15 +2267,18 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 
 		spin_lock_bh(&txq->axq_lock);
 
-		if (!list_empty(&txq->txq_fifo_pending)) {
-			INIT_LIST_HEAD(&bf_head);
-			bf = list_first_entry(&txq->txq_fifo_pending,
-				struct ath_buf, list);
-			list_cut_position(&bf_head, &txq->txq_fifo_pending,
-				&bf->bf_lastbf->list);
-			ath_tx_txqaddbuf(sc, txq, &bf_head);
-		} else if (sc->sc_flags & SC_OP_TXAGGR)
-			ath_txq_schedule(sc, txq);
+		if (!txq->txq_flush_inprogress) {
+			if (!list_empty(&txq->txq_fifo_pending)) {
+				INIT_LIST_HEAD(&bf_head);
+				bf = list_first_entry(&txq->txq_fifo_pending,
+						      struct ath_buf, list);
+				list_cut_position(&bf_head,
+						  &txq->txq_fifo_pending,
+						  &bf->bf_lastbf->list);
+				ath_tx_txqaddbuf(sc, txq, &bf_head);
+			} else if (sc->sc_flags & SC_OP_TXAGGR)
+				ath_txq_schedule(sc, txq);
+		}
 		spin_unlock_bh(&txq->axq_lock);
 	}
 }
-- 
1.7.0.4

