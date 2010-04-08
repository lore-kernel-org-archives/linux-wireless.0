Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47045 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933315Ab0DHT1x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 100/102] ath9k: Handle Tx interrupt for EDMA
Date: Thu,  8 Apr 2010 15:27:36 -0400
Message-Id: <1270754858-26266-101-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

This also takes care of draining txq for EDMA.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |    8 ++-
 drivers/net/wireless/ath/ath9k/xmit.c  |  152 +++++++++++++++++++++++++++-----
 3 files changed, 138 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index dd0f9c4..d96633d 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -272,6 +272,7 @@ int ath_txq_update(struct ath_softc *sc, int qnum,
 int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		 struct ath_tx_control *txctl);
 void ath_tx_tasklet(struct ath_softc *sc);
+void ath_tx_edma_tasklet(struct ath_softc *sc);
 void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb);
 bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno);
 void ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 75d3afa..dd2896f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -429,8 +429,12 @@ void ath9k_tasklet(unsigned long data)
 		spin_unlock_bh(&sc->rx.rxflushlock);
 	}
 
-	if (status & ATH9K_INT_TX)
-		ath_tx_tasklet(sc);
+	if (status & ATH9K_INT_TX) {
+		if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
+			ath_tx_edma_tasklet(sc);
+		else
+			ath_tx_tasklet(sc);
+	}
 
 	if ((status & ATH9K_INT_TSFOOR) && sc->ps_enabled) {
 		/*
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index c5e74bb..b05514c 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -91,6 +91,21 @@ static int ath_max_4ms_framelen[3][16] = {
 	}
 };
 
+static bool ath9k_can_add_buf(struct ath_softc *sc, struct ath_txq *txq)
+{
+	if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA))
+		return true;
+
+	if (txq->axq_depth >= ATH_TXFIFO_DEPTH) {
+		ath_print(ath9k_hw_common(sc->sc_ah),
+			  ATH_DBG_XMIT,
+			  "TX FIFO on queue #%d is full\n",
+			  txq->axq_qnum);
+		return false;
+	}
+
+	return true;
+}
 
 /*********************/
 /* Aggregation logic */
@@ -377,7 +392,8 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			}
 		}
 
-		if (bf_next == NULL) {
+		if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) &&
+		    bf_next == NULL) {
 			/*
 			 * Make sure the last desc is reclaimed if it
 			 * not a holding desc.
@@ -411,7 +427,8 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				!txfail, sendbar);
 		} else {
 			/* retry the un-acked ones */
-			if (bf->bf_next == NULL && bf_last->bf_stale) {
+			if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) &&
+			    bf->bf_next == NULL && bf_last->bf_stale) {
 				struct ath_buf *tbf;
 
 				tbf = ath_clone_txbuf(sc, bf_last);
@@ -682,6 +699,14 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 	bf_first->bf_al = al;
 	bf_first->bf_nframes = nframes;
 
+	if (!ath9k_can_add_buf(sc, txq)) {
+		list_splice_tail_init(bf_q, &tid->buf_q);
+		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_XMIT,
+			  "Rescheduling aggregate...\n");
+		/* XXX: Doesn't matter what we return for now, clean up later */
+		return ATH_AGGR_LIMITED;
+	}
+
 	return status;
 #undef PADBYTES
 }
@@ -1049,22 +1074,32 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 	for (;;) {
 		spin_lock_bh(&txq->axq_lock);
 
-		if (list_empty(&txq->axq_q)) {
-			txq->axq_link = NULL;
-			spin_unlock_bh(&txq->axq_lock);
-			break;
-		}
-
-		bf = list_first_entry(&txq->axq_q, struct ath_buf, list);
+		if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
+			if (list_empty(&txq->txq_fifo[txq->txq_tailidx])) {
+				txq->txq_headidx = txq->txq_tailidx = 0;
+				spin_unlock_bh(&txq->axq_lock);
+				break;
+			}
+			bf = list_first_entry(&txq->txq_fifo[txq->txq_tailidx],
+					      struct ath_buf, list);
+		} else {
+			if (list_empty(&txq->axq_q)) {
+				txq->axq_link = NULL;
+				spin_unlock_bh(&txq->axq_lock);
+				break;
+			}
+			bf = list_first_entry(&txq->axq_q, struct ath_buf,
+					      list);
 
-		if (bf->bf_stale) {
-			list_del(&bf->list);
-			spin_unlock_bh(&txq->axq_lock);
+			if (bf->bf_stale) {
+				list_del(&bf->list);
+				spin_unlock_bh(&txq->axq_lock);
 
-			spin_lock_bh(&sc->tx.txbuflock);
-			list_add_tail(&bf->list, &sc->tx.txbuf);
-			spin_unlock_bh(&sc->tx.txbuflock);
-			continue;
+				spin_lock_bh(&sc->tx.txbuflock);
+				list_add_tail(&bf->list, &sc->tx.txbuf);
+				spin_unlock_bh(&sc->tx.txbuflock);
+				continue;
+			}
 		}
 
 		lastbf = bf->bf_lastbf;
@@ -1072,8 +1107,15 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 			lastbf->bf_tx_aborted = true;
 
 
-		/* remove ath_buf's of the same mpdu from txq */
-		list_cut_position(&bf_head, &txq->axq_q, &lastbf->list);
+		if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
+			list_cut_position(&bf_head,
+					  &txq->txq_fifo[txq->txq_tailidx],
+					  &lastbf->list);
+			INCR(txq->txq_tailidx, ATH_TXFIFO_DEPTH);
+		} else {
+			/* remove ath_buf's of the same mpdu from txq */
+			list_cut_position(&bf_head, &txq->axq_q, &lastbf->list);
+		}
 		txq->axq_depth--;
 
 		spin_unlock_bh(&txq->axq_lock);
@@ -1237,10 +1279,8 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 		  "qnum: %d, txq depth: %d\n", txq->axq_qnum, txq->axq_depth);
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
-		if (txq->axq_depth >= ATH_TXFIFO_DEPTH) {
-			ath_print(common, ATH_DBG_XMIT, "Tx fifo is full\n");
+		if (WARN_ON(!ath9k_can_add_buf(sc, txq)))
 			return;
-		}
 		if (!list_empty(&txq->txq_fifo[txq->txq_headidx]))
 			ath_print(common, ATH_DBG_XMIT,
 				  "Initializing tx fifo %d which is non-empty\n",
@@ -1782,6 +1822,9 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		return r;
 	}
 
+	if (!ath9k_can_add_buf(sc, txctl->txq))
+		return -1;
+
 	ath_tx_start_dma(sc, bf, txctl);
 
 	return 0;
@@ -2175,6 +2218,73 @@ void ath_tx_tasklet(struct ath_softc *sc)
 	}
 }
 
+void ath_tx_edma_tasklet(struct ath_softc *sc)
+{
+	struct ath_tx_status txs;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_txq *txq;
+	struct ath_buf *bf, *lastbf;
+	struct list_head bf_head;
+	int status;
+	int txok;
+
+	for (;;) {
+		status = ath9k_hw_txprocdesc(ah, NULL, (void *)&txs);
+		if (status == -EINPROGRESS)
+			break;
+		if (status == -EIO) {
+			ath_print(common, ATH_DBG_XMIT,
+				  "Error processing tx status\n");
+			break;
+		}
+
+		/* Skip beacon completions */
+		if (txs.qid == sc->beacon.beaconq)
+			continue;
+
+		txq = &sc->tx.txq[txs.qid];
+
+		spin_lock_bh(&txq->axq_lock);
+		if (list_empty(&txq->txq_fifo[txq->txq_tailidx])) {
+			spin_unlock_bh(&txq->axq_lock);
+			return;
+		}
+
+		bf = list_first_entry(&txq->txq_fifo[txq->txq_tailidx],
+				      struct ath_buf, list);
+		lastbf = bf->bf_lastbf;
+
+		INIT_LIST_HEAD(&bf_head);
+		list_cut_position(&bf_head, &txq->txq_fifo[txq->txq_tailidx],
+				  &lastbf->list);
+		INCR(txq->txq_tailidx, ATH_TXFIFO_DEPTH);
+		txq->axq_depth--;
+		txq->axq_tx_inprogress = false;
+		spin_unlock_bh(&txq->axq_lock);
+
+		txok = !(txs.ts_status & ATH9K_TXERR_MASK);
+
+		if (!bf_isampdu(bf)) {
+			bf->bf_retries = txs.ts_longretry;
+			if (txs.ts_status & ATH9K_TXERR_XRETRY)
+				bf->bf_state.bf_type |= BUF_XRETRY;
+			ath_tx_rc_status(bf, &txs, 0, txok, true);
+		}
+
+		if (bf_isampdu(bf))
+			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &txs, txok);
+		else
+			ath_tx_complete_buf(sc, bf, txq, &bf_head,
+					    &txs, txok, 0);
+
+		spin_lock_bh(&txq->axq_lock);
+		if (sc->sc_flags & SC_OP_TXAGGR)
+			ath_txq_schedule(sc, txq);
+		spin_unlock_bh(&txq->axq_lock);
+	}
+}
+
 /*****************/
 /* Init, Cleanup */
 /*****************/
-- 
1.6.3.3

