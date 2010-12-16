Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36138 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180Ab0LPX5U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 18:57:20 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 1/2] ath9k: fix queue depth check for forming new aggregates
Date: Fri, 17 Dec 2010 00:57:00 +0100
Message-Id: <1292543821-95686-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To improve aggregation length, there should not be more than two fully formed
A-MPDU frames in the hardware queue. To ensure this, the code checks the tx
queue length before forming new A-MPDUs. This can reduce the throughput (or
maybe even starve out A-MPDU traffic) when too many non-aggregated frames are
in the queue.
Fix this by keeping track of pending A-MPDU frames (even when they're sent out
as single frames), but exclude rate control probing frames to improve
performance.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/xmit.c  |   21 ++++++++++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index b0b1216..9fd9519 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -189,6 +189,7 @@ struct ath_txq {
 	struct list_head axq_q;
 	spinlock_t axq_lock;
 	u32 axq_depth;
+	u32 axq_ampdu_depth;
 	bool stopped;
 	bool axq_tx_inprogress;
 	struct list_head axq_acq;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 96623695..332d1fe 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -838,7 +838,7 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		ath_tx_txqaddbuf(sc, txq, &bf_q);
 		TX_STAT_INC(txq->axq_qnum, a_aggr);
 
-	} while (txq->axq_depth < ATH_AGGR_MIN_QDEPTH &&
+	} while (txq->axq_ampdu_depth < ATH_AGGR_MIN_QDEPTH &&
 		 status != ATH_AGGR_BAW_CLOSED);
 }
 
@@ -999,6 +999,7 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 		INIT_LIST_HEAD(&txq->axq_acq);
 		spin_lock_init(&txq->axq_lock);
 		txq->axq_depth = 0;
+		txq->axq_ampdu_depth = 0;
 		txq->axq_tx_inprogress = false;
 		sc->tx.txqsetup |= 1<<qnum;
 
@@ -1068,6 +1069,12 @@ int ath_cabq_update(struct ath_softc *sc)
 	return 0;
 }
 
+static bool bf_is_ampdu_not_probing(struct ath_buf *bf)
+{
+    struct ieee80211_tx_info *info = IEEE80211_SKB_CB(bf->bf_mpdu);
+    return bf_isampdu(bf) && !(info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE);
+}
+
 /*
  * Drain a given TX queue (could be Beacon or Data)
  *
@@ -1126,7 +1133,8 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 		}
 
 		txq->axq_depth--;
-
+		if (bf_is_ampdu_not_probing(bf))
+			txq->axq_ampdu_depth--;
 		spin_unlock_bh(&txq->axq_lock);
 
 		if (bf_isampdu(bf))
@@ -1316,6 +1324,8 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 		ath9k_hw_txstart(ah, txq->axq_qnum);
 	}
 	txq->axq_depth++;
+	if (bf_is_ampdu_not_probing(bf))
+		txq->axq_ampdu_depth++;
 }
 
 static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
@@ -1336,7 +1346,7 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 	 */
 	if (!list_empty(&tid->buf_q) || tid->paused ||
 	    !BAW_WITHIN(tid->seq_start, tid->baw_size, fi->seqno) ||
-	    txctl->txq->axq_depth >= ATH_AGGR_MIN_QDEPTH) {
+	    txctl->txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH) {
 		/*
 		 * Add this frame to software queue for scheduling later
 		 * for aggregation.
@@ -2040,6 +2050,9 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		txq->axq_tx_inprogress = false;
 		if (bf_held)
 			list_del(&bf_held->list);
+
+		if (bf_is_ampdu_not_probing(bf))
+			txq->axq_ampdu_depth--;
 		spin_unlock_bh(&txq->axq_lock);
 
 		if (bf_held)
@@ -2168,6 +2181,8 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 		INCR(txq->txq_tailidx, ATH_TXFIFO_DEPTH);
 		txq->axq_depth--;
 		txq->axq_tx_inprogress = false;
+		if (bf_is_ampdu_not_probing(bf))
+			txq->axq_ampdu_depth--;
 		spin_unlock_bh(&txq->axq_lock);
 
 		txok = !(txs.ts_status & ATH9K_TXERR_MASK);
-- 
1.7.3.2

