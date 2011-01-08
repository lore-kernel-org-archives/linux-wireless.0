Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46952 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab1AHA1l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 19:27:41 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [RFC] ath9k:  Try all queues when looking for next packet to send.
Date: Fri,  7 Jan 2011 16:27:35 -0800
Message-Id: <1294446455-19806-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

There can be multiple struct ath_atx_ac entries for each
txq, so if the first one doesn't have any packets to send
now, try the rest of them.  This should help keep xmit
going when using multiple stations, especially with AMPDU
enabled.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 e63de71... a7a8f8f... M	drivers/net/wireless/ath/ath9k/xmit.c
 drivers/net/wireless/ath/ath9k/xmit.c |   99 ++++++++++++++++++++-------------
 1 files changed, 60 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index e63de71..a7a8f8f 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -54,8 +54,8 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 				struct ath_txq *txq, struct list_head *bf_q,
 				struct ath_tx_status *ts, int txok, int sendbar);
-static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
-			     struct list_head *head);
+static int ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
+			    struct list_head *head);
 static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len);
 static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
 			     int nframes, int nbad, int txok, bool update_rc);
@@ -789,18 +789,21 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 #undef PADBYTES
 }
 
-static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
-			      struct ath_atx_tid *tid)
+/* Return number of buffers set up for transmit. */
+static int ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
+			     struct ath_atx_tid *tid)
 {
 	struct ath_buf *bf;
 	enum ATH_AGGR_STATUS status;
 	struct ath_frame_info *fi;
 	struct list_head bf_q;
 	int aggr_len;
+	int cnt = 0;
+	int rv;
 
 	do {
 		if (list_empty(&tid->buf_q))
-			return;
+			return cnt;
 
 		INIT_LIST_HEAD(&bf_q);
 
@@ -811,7 +814,7 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		 * block-ack window is not open.
 		 */
 		if (list_empty(&bf_q))
-			break;
+			return cnt;
 
 		bf = list_first_entry(&bf_q, struct ath_buf, list);
 		bf->bf_lastbf = list_entry(bf_q.prev, struct ath_buf, list);
@@ -823,7 +826,11 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			bf->bf_state.bf_type &= ~BUF_AGGR;
 			ath9k_hw_clr11n_aggr(sc->sc_ah, bf->bf_desc);
 			ath_buf_set_rate(sc, bf, fi->framelen);
-			ath_tx_txqaddbuf(sc, txq, &bf_q);
+			rv = ath_tx_txqaddbuf(sc, txq, &bf_q);
+			if (rv > 0) {
+				TX_STAT_INC(txq->axq_qnum, a_aggr);
+				cnt += rv;
+			}
 			continue;
 		}
 
@@ -835,11 +842,15 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		/* anchor last desc of aggregate */
 		ath9k_hw_set11n_aggr_last(sc->sc_ah, bf->bf_lastbf->bf_desc);
 
-		ath_tx_txqaddbuf(sc, txq, &bf_q);
-		TX_STAT_INC(txq->axq_qnum, a_aggr);
+		rv = ath_tx_txqaddbuf(sc, txq, &bf_q);
+		if (rv > 0) {
+			TX_STAT_INC(txq->axq_qnum, a_aggr);
+			cnt += rv;
+		}
 
 	} while (txq->axq_ampdu_depth < ATH_AGGR_MIN_QDEPTH &&
 		 status != ATH_AGGR_BAW_CLOSED);
+	return rv;
 }
 
 int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
@@ -1218,46 +1229,54 @@ void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq)
 	sc->tx.txqsetup &= ~(1<<txq->axq_qnum);
 }
 
+/** For each axq_acq entry, for each tid, if we can transmit
+ * one, do so and break out.
+ */
 void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 {
-	struct ath_atx_ac *ac;
+	struct ath_atx_ac *ac, *ac_tmp, *last;
 	struct ath_atx_tid *tid;
+	bool did_one = false;
 
 	if (list_empty(&txq->axq_acq))
 		return;
+	
+	last = list_entry(txq->axq_acq.prev, struct ath_atx_ac, list);
+	list_for_each_entry_safe(ac, ac_tmp, &txq->axq_acq, list) {
+		list_del(&ac->list);
+		ac->sched = false;
 
-	ac = list_first_entry(&txq->axq_acq, struct ath_atx_ac, list);
-	list_del(&ac->list);
-	ac->sched = false;
-
-	do {
-		if (list_empty(&ac->tid_q))
-			return;
+		while (!list_empty(&ac->tid_q)) {
 
-		tid = list_first_entry(&ac->tid_q, struct ath_atx_tid, list);
-		list_del(&tid->list);
-		tid->sched = false;
+			tid = list_first_entry(&ac->tid_q, struct ath_atx_tid, list);
+			list_del(&tid->list);
+			tid->sched = false;
 
-		if (tid->paused)
-			continue;
+			if (tid->paused)
+				continue;
 
-		ath_tx_sched_aggr(sc, txq, tid);
+			if (ath_tx_sched_aggr(sc, txq, tid) > 0)
+				did_one = true;
 
-		/*
-		 * add tid to round-robin queue if more frames
-		 * are pending for the tid
-		 */
-		if (!list_empty(&tid->buf_q))
-			ath_tx_queue_tid(txq, tid);
+			/*
+			 * add tid to round-robin queue if more frames
+			 * are pending for the tid
+			 */
+			if (!list_empty(&tid->buf_q))
+				ath_tx_queue_tid(txq, tid);
 
-		break;
-	} while (!list_empty(&ac->tid_q));
+			break;
+		}
 
-	if (!list_empty(&ac->tid_q)) {
-		if (!ac->sched) {
-			ac->sched = true;
-			list_add_tail(&ac->list, &txq->axq_acq);
+		if (!list_empty(&ac->tid_q)) {
+			if (!ac->sched) {
+				ac->sched = true;
+				list_add_tail(&ac->list, &txq->axq_acq);
+			}
 		}
+
+		if (did_one || (ac == last))
+			return;
 	}
 }
 
@@ -1268,9 +1287,10 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 /*
  * Insert a chain of ath_buf (descriptors) on a txq and
  * assume the descriptors are already chained together by caller.
+ * Return number of buffers sent to DMA.
  */
-static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
-			     struct list_head *head)
+static int ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
+			    struct list_head *head)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -1282,7 +1302,7 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 	 */
 
 	if (list_empty(head))
-		return;
+		return 0;
 
 	bf = list_first_entry(head, struct ath_buf, list);
 
@@ -1292,7 +1312,7 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
 		if (txq->axq_depth >= ATH_TXFIFO_DEPTH) {
 			list_splice_tail_init(head, &txq->txq_fifo_pending);
-			return;
+			return 0;
 		}
 		if (!list_empty(&txq->txq_fifo[txq->txq_headidx]))
 			ath_dbg(common, ATH_DBG_XMIT,
@@ -1326,6 +1346,7 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 	txq->axq_depth++;
 	if (bf_is_ampdu_not_probing(bf))
 		txq->axq_ampdu_depth++;
+	return 1;
 }
 
 static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
-- 
1.7.2.3

