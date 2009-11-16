Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:33462 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbZKPGKO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 01:10:14 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 15 Nov 2009 22:10:20 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19200.60651.860637.124820@gargle.gargle.HOWL>
Date: Mon, 16 Nov 2009 11:40:51 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] ath9k: Remove a few unused variables
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

axq_linkbuf, axq_aggr_depth, axq_lastdsWithCTS and
axq_gatingds are unused.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |   10 ----------
 drivers/net/wireless/ath/ath9k/xmit.c  |   13 -------------
 2 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index d9bcc3a..2a40fa2 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -198,18 +198,8 @@ struct ath_txq {
 	struct list_head axq_q;
 	spinlock_t axq_lock;
 	u32 axq_depth;
-	u8 axq_aggr_depth;
 	bool stopped;
 	bool axq_tx_inprogress;
-	struct ath_buf *axq_linkbuf;
-
-	/* first desc of the last descriptor that contains CTS */
-	struct ath_desc *axq_lastdsWithCTS;
-
-	/* final desc of the gating desc that determines whether
-	   lastdsWithCTS has been DMA'ed or not */
-	struct ath_desc *axq_gatingds;
-
 	struct list_head axq_acq;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 86b54dd..e2a4769 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -702,7 +702,6 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		/* anchor last desc of aggregate */
 		ath9k_hw_set11n_aggr_last(sc->sc_ah, bf->bf_lastbf->bf_desc);
 
-		txq->axq_aggr_depth++;
 		ath_tx_txqaddbuf(sc, txq, &bf_q);
 		TX_STAT_INC(txq->axq_qnum, a_aggr);
 
@@ -878,8 +877,6 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 		INIT_LIST_HEAD(&txq->axq_acq);
 		spin_lock_init(&txq->axq_lock);
 		txq->axq_depth = 0;
-		txq->axq_aggr_depth = 0;
-		txq->axq_linkbuf = NULL;
 		txq->axq_tx_inprogress = false;
 		sc->tx.txqsetup |= 1<<qnum;
 	}
@@ -1014,7 +1011,6 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 
 		if (list_empty(&txq->axq_q)) {
 			txq->axq_link = NULL;
-			txq->axq_linkbuf = NULL;
 			spin_unlock_bh(&txq->axq_lock);
 			break;
 		}
@@ -1199,7 +1195,6 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 
 	list_splice_tail_init(head, &txq->axq_q);
 	txq->axq_depth++;
-	txq->axq_linkbuf = list_entry(txq->axq_q.prev, struct ath_buf, list);
 
 	ath_print(common, ATH_DBG_QUEUE,
 		  "qnum: %d, txq depth: %d\n", txq->axq_qnum, txq->axq_depth);
@@ -1971,7 +1966,6 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		spin_lock_bh(&txq->axq_lock);
 		if (list_empty(&txq->axq_q)) {
 			txq->axq_link = NULL;
-			txq->axq_linkbuf = NULL;
 			spin_unlock_bh(&txq->axq_lock);
 			break;
 		}
@@ -2005,10 +1999,6 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 			spin_unlock_bh(&txq->axq_lock);
 			break;
 		}
-		if (bf->bf_desc == txq->axq_lastdsWithCTS)
-			txq->axq_lastdsWithCTS = NULL;
-		if (ds == txq->axq_gatingds)
-			txq->axq_gatingds = NULL;
 
 		/*
 		 * Remove ath_buf's of the same transmit unit from txq,
@@ -2022,9 +2012,6 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 				&txq->axq_q, lastbf->list.prev);
 
 		txq->axq_depth--;
-		if (bf_isaggr(bf))
-			txq->axq_aggr_depth--;
-
 		txok = (ds->ds_txstat.ts_status == 0);
 		txq->axq_tx_inprogress = false;
 		spin_unlock_bh(&txq->axq_lock);
-- 
1.6.5.2

