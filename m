Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58778 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934403Ab3DGWES (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Apr 2013 18:04:18 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 7/7] ath9k: implement buffer holding handling for EDMA FIFO
Date: Mon,  8 Apr 2013 00:04:13 +0200
Message-Id: <1365372253-32782-7-git-send-email-nbd@openwrt.org> (sfid-20130408_000427_104537_C152703D)
In-Reply-To: <1365372253-32782-6-git-send-email-nbd@openwrt.org>
References: <1365372253-32782-1-git-send-email-nbd@openwrt.org>
 <1365372253-32782-2-git-send-email-nbd@openwrt.org>
 <1365372253-32782-3-git-send-email-nbd@openwrt.org>
 <1365372253-32782-4-git-send-email-nbd@openwrt.org>
 <1365372253-32782-5-git-send-email-nbd@openwrt.org>
 <1365372253-32782-6-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Inside one FIFO slot queue, EDMA chipsets have the same link pointer
re-read race condition as older chipsets, so the same buffer holding
logic needs to be used in order to avoid use-after-free bugs.
Unlike on older chips, it can be skipped for the end of the queue.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 94b2ee1..5bc5802 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -516,8 +516,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		 * not a holding desc.
 		 */
 		INIT_LIST_HEAD(&bf_head);
-		if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) ||
-		    bf_next != NULL || !bf_last->bf_stale)
+		if (bf_next != NULL || !bf_last->bf_stale)
 			list_move_tail(&bf->list, &bf_head);
 
 		if (!txpending || (tid->state & AGGR_CLEANUP)) {
@@ -537,8 +536,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				!txfail);
 		} else {
 			/* retry the un-acked ones */
-			if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) &&
-			    bf->bf_next == NULL && bf_last->bf_stale) {
+			if (bf->bf_next == NULL && bf_last->bf_stale) {
 				struct ath_buf *tbf;
 
 				tbf = ath_clone_txbuf(sc, bf_last);
@@ -2264,6 +2262,7 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 	struct ath_txq *txq;
 	struct ath_buf *bf, *lastbf;
 	struct list_head bf_head;
+	struct list_head *fifo_list;
 	int status;
 
 	for (;;) {
@@ -2291,20 +2290,24 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 
 		TX_STAT_INC(txq->axq_qnum, txprocdesc);
 
-		if (list_empty(&txq->txq_fifo[txq->txq_tailidx])) {
+		fifo_list = &txq->txq_fifo[txq->txq_tailidx];
+		if (list_empty(fifo_list)) {
 			ath_txq_unlock(sc, txq);
 			return;
 		}
 
-		bf = list_first_entry(&txq->txq_fifo[txq->txq_tailidx],
-				      struct ath_buf, list);
+		bf = list_first_entry(fifo_list, struct ath_buf, list);
+		if (bf->bf_stale) {
+			list_del(&bf->list);
+			ath_tx_return_buffer(sc, bf);
+			bf = list_first_entry(fifo_list, struct ath_buf, list);
+		}
+
 		lastbf = bf->bf_lastbf;
 
 		INIT_LIST_HEAD(&bf_head);
-		list_cut_position(&bf_head, &txq->txq_fifo[txq->txq_tailidx],
-				  &lastbf->list);
-
-		if (list_empty(&txq->txq_fifo[txq->txq_tailidx])) {
+		if (list_is_last(&lastbf->list, fifo_list)) {
+			list_splice_tail_init(fifo_list, &bf_head);
 			INCR(txq->txq_tailidx, ATH_TXFIFO_DEPTH);
 
 			if (!list_empty(&txq->axq_q)) {
@@ -2315,6 +2318,11 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 				list_splice_tail_init(&txq->axq_q, &bf_q);
 				ath_tx_txqaddbuf(sc, txq, &bf_q, true);
 			}
+		} else {
+			lastbf->bf_stale = true;
+			if (bf != lastbf)
+				list_cut_position(&bf_head, fifo_list,
+						  lastbf->list.prev);
 		}
 
 		ath_tx_process_buffer(sc, txq, &ts, bf, &bf_head);
-- 
1.8.0.2

