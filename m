Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57813 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395Ab3HFMSZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 08:18:25 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, sujith@msujith.org
Subject: [PATCH v2 01/12] ath9k: add utility functions for accessing tid queues
Date: Tue,  6 Aug 2013 14:18:02 +0200
Message-Id: <1375791493-83971-1-git-send-email-nbd@openwrt.org> (sfid-20130806_141833_933254_6D095057)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Useful for further fixes / cleanups

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 51 ++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 52cd521..eaa9eaf 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -168,6 +168,16 @@ static void ath_txq_skb_done(struct ath_softc *sc, struct ath_txq *txq,
 	}
 }
 
+static bool ath_tid_has_buffered(struct ath_atx_tid *tid)
+{
+	return !skb_queue_empty(&tid->buf_q);
+}
+
+static struct sk_buff *ath_tid_dequeue(struct ath_atx_tid *tid)
+{
+	return __skb_dequeue(&tid->buf_q);
+}
+
 static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 {
 	struct ath_txq *txq = tid->ac->txq;
@@ -182,7 +192,7 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 
 	memset(&ts, 0, sizeof(ts));
 
-	while ((skb = __skb_dequeue(&tid->buf_q))) {
+	while ((skb = ath_tid_dequeue(tid))) {
 		fi = get_frame_info(skb);
 		bf = fi->bf;
 
@@ -266,7 +276,7 @@ static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 	memset(&ts, 0, sizeof(ts));
 	INIT_LIST_HEAD(&bf_head);
 
-	while ((skb = __skb_dequeue(&tid->buf_q))) {
+	while ((skb = ath_tid_dequeue(tid))) {
 		fi = get_frame_info(skb);
 		bf = fi->bf;
 
@@ -815,7 +825,7 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 
 static struct ath_buf *
 ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
-			struct ath_atx_tid *tid)
+			struct ath_atx_tid *tid, struct sk_buff_head **q)
 {
 	struct ath_frame_info *fi;
 	struct sk_buff *skb;
@@ -823,7 +833,8 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
 	u16 seqno;
 
 	while (1) {
-		skb = skb_peek(&tid->buf_q);
+		*q = &tid->buf_q;
+		skb = skb_peek(*q);
 		if (!skb)
 			break;
 
@@ -833,7 +844,7 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
 			bf = ath_tx_setup_buffer(sc, txq, tid, skb);
 
 		if (!bf) {
-			__skb_unlink(skb, &tid->buf_q);
+			__skb_unlink(skb, *q);
 			ath_txq_skb_done(sc, txq, skb);
 			ieee80211_free_txskb(sc->hw, skb);
 			continue;
@@ -852,7 +863,7 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
 
 			INIT_LIST_HEAD(&bf_head);
 			list_add(&bf->list, &bf_head);
-			__skb_unlink(skb, &tid->buf_q);
+			__skb_unlink(skb, *q);
 			ath_tx_update_baw(sc, tid, seqno);
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0);
 			continue;
@@ -881,9 +892,10 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 	struct ieee80211_tx_info *tx_info;
 	struct ath_frame_info *fi;
 	struct sk_buff *skb;
+	struct sk_buff_head *tid_q;
 
 	do {
-		bf = ath_tx_get_tid_subframe(sc, txq, tid);
+		bf = ath_tx_get_tid_subframe(sc, txq, tid, &tid_q);
 		if (!bf) {
 			status = ATH_AGGR_BAW_CLOSED;
 			break;
@@ -940,14 +952,14 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 			ath_tx_addto_baw(sc, tid, bf->bf_state.seqno);
 		bf->bf_state.ndelim = ndelim;
 
-		__skb_unlink(skb, &tid->buf_q);
+		__skb_unlink(skb, tid_q);
 		list_add_tail(&bf->list, bf_q);
 		if (bf_prev)
 			bf_prev->bf_next = bf;
 
 		bf_prev = bf;
 
-	} while (!skb_queue_empty(&tid->buf_q));
+	} while (ath_tid_has_buffered(tid));
 
 	*aggr_len = al;
 
@@ -1250,7 +1262,7 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	int aggr_len;
 
 	do {
-		if (skb_queue_empty(&tid->buf_q))
+		if (!ath_tid_has_buffered(tid))
 			return;
 
 		INIT_LIST_HEAD(&bf_q);
@@ -1354,7 +1366,7 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 
 		ath_txq_lock(sc, txq);
 
-		buffered = !skb_queue_empty(&tid->buf_q);
+		buffered = ath_tid_has_buffered(tid);
 
 		tid->sched = false;
 		list_del(&tid->list);
@@ -1386,7 +1398,7 @@ void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an)
 		ath_txq_lock(sc, txq);
 		ac->clear_ps_filter = true;
 
-		if (!skb_queue_empty(&tid->buf_q) && !tid->paused) {
+		if (!tid->paused && ath_tid_has_buffered(tid)) {
 			ath_tx_queue_tid(txq, tid);
 			ath_txq_schedule(sc, txq);
 		}
@@ -1411,7 +1423,7 @@ void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta,
 	tid->baw_size = IEEE80211_MIN_AMPDU_BUF << sta->ht_cap.ampdu_factor;
 	tid->paused = false;
 
-	if (!skb_queue_empty(&tid->buf_q)) {
+	if (ath_tid_has_buffered(tid)) {
 		ath_tx_queue_tid(txq, tid);
 		ath_txq_schedule(sc, txq);
 	}
@@ -1431,6 +1443,7 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 	struct ieee80211_tx_info *info;
 	struct list_head bf_q;
 	struct ath_buf *bf_tail = NULL, *bf;
+	struct sk_buff_head *tid_q;
 	int sent = 0;
 	int i;
 
@@ -1446,12 +1459,12 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 			continue;
 
 		ath_txq_lock(sc, tid->ac->txq);
-		while (!skb_queue_empty(&tid->buf_q) && nframes > 0) {
-			bf = ath_tx_get_tid_subframe(sc, sc->tx.uapsdq, tid);
+		while (nframes > 0) {
+			bf = ath_tx_get_tid_subframe(sc, sc->tx.uapsdq, tid, &tid_q);
 			if (!bf)
 				break;
 
-			__skb_unlink(bf->bf_mpdu, &tid->buf_q);
+			__skb_unlink(bf->bf_mpdu, tid_q);
 			list_add_tail(&bf->list, &bf_q);
 			ath_set_rates(tid->an->vif, tid->an->sta, bf);
 			ath_tx_addto_baw(sc, tid, bf->bf_state.seqno);
@@ -1464,7 +1477,7 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 			sent++;
 			TX_STAT_INC(txq->axq_qnum, a_queued_hw);
 
-			if (skb_queue_empty(&tid->buf_q))
+			if (!ath_tid_has_buffered(tid))
 				ieee80211_sta_set_buffered(an->sta, i, false);
 		}
 		ath_txq_unlock_complete(sc, tid->ac->txq);
@@ -1750,7 +1763,7 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 			 * add tid to round-robin queue if more frames
 			 * are pending for the tid
 			 */
-			if (!skb_queue_empty(&tid->buf_q))
+			if (ath_tid_has_buffered(tid))
 				ath_tx_queue_tid(txq, tid);
 
 			if (tid == last_tid ||
@@ -1859,7 +1872,7 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_txq *txq,
 	 * - seqno is not within block-ack window
 	 * - h/w queue depth exceeds low water mark
 	 */
-	if ((!skb_queue_empty(&tid->buf_q) || tid->paused ||
+	if ((ath_tid_has_buffered(tid) || tid->paused ||
 	     !BAW_WITHIN(tid->seq_start, tid->baw_size, tid->seq_next) ||
 	     txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH) &&
 	    txq != sc->tx.uapsdq) {
-- 
1.8.0.2

