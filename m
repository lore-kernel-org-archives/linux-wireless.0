Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47034 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933211Ab0DHT1w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:52 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 095/102] ath9k: Add frame onto hw tx fifo for edma
Date: Thu,  8 Apr 2010 15:27:31 -0400
Message-Id: <1270754858-26266-96-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    4 +++
 drivers/net/wireless/ath/ath9k/xmit.c  |   47 ++++++++++++++++++++++++-------
 2 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 2d3e42a..dd0f9c4 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -190,6 +190,7 @@ enum ATH_AGGR_STATUS {
 	ATH_AGGR_LIMITED,
 };
 
+#define ATH_TXFIFO_DEPTH 8
 struct ath_txq {
 	u32 axq_qnum;
 	u32 *axq_link;
@@ -199,6 +200,9 @@ struct ath_txq {
 	bool stopped;
 	bool axq_tx_inprogress;
 	struct list_head axq_acq;
+	struct list_head txq_fifo[ATH_TXFIFO_DEPTH];
+	u8 txq_headidx;
+	u8 txq_tailidx;
 };
 
 #define AGGR_CLEANUP         BIT(1)
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 375b2e6..473be84 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -853,7 +853,7 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_tx_queue_info qi;
-	int qnum;
+	int qnum, i;
 
 	memset(&qi, 0, sizeof(qi));
 	qi.tqi_subtype = subtype;
@@ -908,6 +908,10 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 		txq->axq_depth = 0;
 		txq->axq_tx_inprogress = false;
 		sc->tx.txqsetup |= 1<<qnum;
+
+		txq->txq_headidx = txq->txq_tailidx = 0;
+		for (i = 0; i < ATH_TXFIFO_DEPTH; i++)
+			INIT_LIST_HEAD(&txq->txq_fifo[i]);
 	}
 	return &sc->tx.txq[qnum];
 }
@@ -1224,25 +1228,46 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 
 	bf = list_first_entry(head, struct ath_buf, list);
 
-	list_splice_tail_init(head, &txq->axq_q);
-	txq->axq_depth++;
-
 	ath_print(common, ATH_DBG_QUEUE,
 		  "qnum: %d, txq depth: %d\n", txq->axq_qnum, txq->axq_depth);
 
-	if (txq->axq_link == NULL) {
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
+		if (txq->axq_depth >= ATH_TXFIFO_DEPTH) {
+			ath_print(common, ATH_DBG_XMIT, "Tx fifo is full\n");
+			return;
+		}
+		if (!list_empty(&txq->txq_fifo[txq->txq_headidx]))
+			ath_print(common, ATH_DBG_XMIT,
+				  "Initializing tx fifo %d which is non-empty\n",
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
-- 
1.6.3.3

