Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33035 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757449Ab0DOVjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:47 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v3 91/97] ath9k: Add Tx EDMA support
Date: Thu, 15 Apr 2010 17:39:36 -0400
Message-Id: <1271367582-992-92-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    6 +
 drivers/net/wireless/ath/ath9k/main.c  |    8 +-
 drivers/net/wireless/ath/ath9k/xmit.c  |  264 +++++++++++++++++++++++++-------
 3 files changed, 218 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 2d3e42a..fbb7dec 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -190,6 +190,7 @@ enum ATH_AGGR_STATUS {
 	ATH_AGGR_LIMITED,
 };
 
+#define ATH_TXFIFO_DEPTH 8
 struct ath_txq {
 	u32 axq_qnum;
 	u32 *axq_link;
@@ -199,6 +200,10 @@ struct ath_txq {
 	bool stopped;
 	bool axq_tx_inprogress;
 	struct list_head axq_acq;
+	struct list_head txq_fifo[ATH_TXFIFO_DEPTH];
+	struct list_head txq_fifo_pending;
+	u8 txq_headidx;
+	u8 txq_tailidx;
 };
 
 #define AGGR_CLEANUP         BIT(1)
@@ -268,6 +273,7 @@ int ath_txq_update(struct ath_softc *sc, int qnum,
 int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		 struct ath_tx_control *txctl);
 void ath_tx_tasklet(struct ath_softc *sc);
+void ath_tx_edma_tasklet(struct ath_softc *sc);
 void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb);
 bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno);
 void ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 92f6fdc..1f4ea74 100644
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
index f9f7445..c2b4503 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -92,7 +92,6 @@ static int ath_max_4ms_framelen[3][16] = {
 	}
 };
 
-
 /*********************/
 /* Aggregation logic */
 /*********************/
@@ -379,7 +378,8 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			}
 		}
 
-		if (bf_next == NULL) {
+		if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) &&
+		    bf_next == NULL) {
 			/*
 			 * Make sure the last desc is reclaimed if it
 			 * not a holding desc.
@@ -413,36 +413,43 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				!txfail, sendbar);
 		} else {
 			/* retry the un-acked ones */
-			if (bf->bf_next == NULL && bf_last->bf_stale) {
-				struct ath_buf *tbf;
-
-				tbf = ath_clone_txbuf(sc, bf_last);
-				/*
-				 * Update tx baw and complete the frame with
-				 * failed status if we run out of tx buf
-				 */
-				if (!tbf) {
-					spin_lock_bh(&txq->axq_lock);
-					ath_tx_update_baw(sc, tid,
-							  bf->bf_seqno);
-					spin_unlock_bh(&txq->axq_lock);
-
-					bf->bf_state.bf_type |= BUF_XRETRY;
-					ath_tx_rc_status(bf, ts, nbad,
-							 0, false);
-					ath_tx_complete_buf(sc, bf, txq,
-							    &bf_head, ts, 0, 0);
-					break;
+			if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)) {
+				if (bf->bf_next == NULL && bf_last->bf_stale) {
+					struct ath_buf *tbf;
+
+					tbf = ath_clone_txbuf(sc, bf_last);
+					/*
+					 * Update tx baw and complete the
+					 * frame with failed status if we
+					 * run out of tx buf.
+					 */
+					if (!tbf) {
+						spin_lock_bh(&txq->axq_lock);
+						ath_tx_update_baw(sc, tid,
+								bf->bf_seqno);
+						spin_unlock_bh(&txq->axq_lock);
+
+						bf->bf_state.bf_type |=
+							BUF_XRETRY;
+						ath_tx_rc_status(bf, ts, nbad,
+								0, false);
+						ath_tx_complete_buf(sc, bf, txq,
+								    &bf_head,
+								    ts, 0, 0);
+						break;
+					}
+
+					ath9k_hw_cleartxdesc(sc->sc_ah,
+							     tbf->bf_desc);
+					list_add_tail(&tbf->list, &bf_head);
+				} else {
+					/*
+					 * Clear descriptor status words for
+					 * software retry
+					 */
+					ath9k_hw_cleartxdesc(sc->sc_ah,
+							     bf->bf_desc);
 				}
-
-				ath9k_hw_cleartxdesc(sc->sc_ah, tbf->bf_desc);
-				list_add_tail(&tbf->list, &bf_head);
-			} else {
-				/*
-				 * Clear descriptor status words for
-				 * software retry
-				 */
-				ath9k_hw_cleartxdesc(sc->sc_ah, bf->bf_desc);
 			}
 
 			/*
@@ -855,7 +862,7 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_tx_queue_info qi;
-	int qnum;
+	int qnum, i;
 
 	memset(&qi, 0, sizeof(qi));
 	qi.tqi_subtype = subtype;
@@ -910,6 +917,11 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 		txq->axq_depth = 0;
 		txq->axq_tx_inprogress = false;
 		sc->tx.txqsetup |= 1<<qnum;
+
+		txq->txq_headidx = txq->txq_tailidx = 0;
+		for (i = 0; i < ATH_TXFIFO_DEPTH; i++)
+			INIT_LIST_HEAD(&txq->txq_fifo[i]);
+		INIT_LIST_HEAD(&txq->txq_fifo_pending);
 	}
 	return &sc->tx.txq[qnum];
 }
@@ -1042,30 +1054,49 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
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
+			} else {
+				bf = list_first_entry(&txq->txq_fifo[txq->txq_tailidx],
+						      struct ath_buf, list);
+			}
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
 		if (!retry_tx)
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
+
 		txq->axq_depth--;
 
 		spin_unlock_bh(&txq->axq_lock);
@@ -1088,6 +1119,27 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 			spin_unlock_bh(&txq->axq_lock);
 		}
 	}
+
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
+		spin_lock_bh(&txq->axq_lock);
+		while (!list_empty(&txq->txq_fifo_pending)) {
+			bf = list_first_entry(&txq->txq_fifo_pending,
+					      struct ath_buf, list);
+			list_cut_position(&bf_head,
+					  &txq->txq_fifo_pending,
+					  &bf->bf_lastbf->list);
+			spin_unlock_bh(&txq->axq_lock);
+
+			if (bf_isampdu(bf))
+				ath_tx_complete_aggr(sc, txq, bf, &bf_head,
+						     &ts, 0);
+			else
+				ath_tx_complete_buf(sc, bf, txq, &bf_head,
+						    &ts, 0, 0);
+			spin_lock_bh(&txq->axq_lock);
+		}
+		spin_unlock_bh(&txq->axq_lock);
+	}
 }
 
 void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
@@ -1225,25 +1277,47 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 
 	bf = list_first_entry(head, struct ath_buf, list);
 
-	list_splice_tail_init(head, &txq->axq_q);
-	txq->axq_depth++;
-
 	ath_print(common, ATH_DBG_QUEUE,
 		  "qnum: %d, txq depth: %d\n", txq->axq_qnum, txq->axq_depth);
 
-	if (txq->axq_link == NULL) {
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
+		if (txq->axq_depth >= ATH_TXFIFO_DEPTH) {
+			list_splice_tail_init(head, &txq->txq_fifo_pending);
+			return;
+		}
+		if (!list_empty(&txq->txq_fifo[txq->txq_headidx]))
+			ath_print(common, ATH_DBG_XMIT,
+				  "Initializing tx fifo %d which "
+				  "is non-empty\n",
+				  txq->txq_headidx);
+		INIT_LIST_HEAD(&txq->txq_fifo[txq->txq_headidx]);
+		list_splice_init(head, &txq->txq_fifo[txq->txq_headidx]);
+		INCR(txq->txq_headidx, ATH_TXFIFO_DEPTH);
 		ath9k_hw_puttxbuf(ah, txq->axq_qnum, bf->bf_daddr);
 		ath_print(common, ATH_DBG_XMIT,
 			  "TXDP[%u] = %llx (%p)\n",
 			  txq->axq_qnum, ito64(bf->bf_daddr), bf->bf_desc);
 	} else {
-		*txq->axq_link = bf->bf_daddr;
-		ath_print(common, ATH_DBG_XMIT, "link[%u] (%p)=%llx (%p)\n",
-			  txq->axq_qnum, txq->axq_link,
-			  ito64(bf->bf_daddr), bf->bf_desc);
+		list_splice_tail_init(head, &txq->axq_q);
+
+		if (txq->axq_link == NULL) {
+			ath9k_hw_puttxbuf(ah, txq->axq_qnum, bf->bf_daddr);
+			ath_print(common, ATH_DBG_XMIT,
+					"TXDP[%u] = %llx (%p)\n",
+					txq->axq_qnum, ito64(bf->bf_daddr),
+					bf->bf_desc);
+		} else {
+			*txq->axq_link = bf->bf_daddr;
+			ath_print(common, ATH_DBG_XMIT,
+					"link[%u] (%p)=%llx (%p)\n",
+					txq->axq_qnum, txq->axq_link,
+					ito64(bf->bf_daddr), bf->bf_desc);
+		}
+		ath9k_hw_get_desc_link(ah, bf->bf_lastbf->bf_desc,
+				       &txq->axq_link);
+		ath9k_hw_txstart(ah, txq->axq_qnum);
 	}
-	ath9k_hw_get_desc_link(ah, bf->bf_lastbf->bf_desc, &txq->axq_link);
-	ath9k_hw_txstart(ah, txq->axq_qnum);
+	txq->axq_depth++;
 }
 
 static struct ath_buf *ath_tx_get_buffer(struct ath_softc *sc)
@@ -2140,6 +2214,80 @@ void ath_tx_tasklet(struct ath_softc *sc)
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
+		if (!list_empty(&txq->txq_fifo_pending)) {
+			INIT_LIST_HEAD(&bf_head);
+			bf = list_first_entry(&txq->txq_fifo_pending,
+				struct ath_buf, list);
+			list_cut_position(&bf_head, &txq->txq_fifo_pending,
+				&bf->bf_lastbf->list);
+			ath_tx_txqaddbuf(sc, txq, &bf_head);
+		} else if (sc->sc_flags & SC_OP_TXAGGR)
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

