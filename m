Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53680 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388030AbeGWRFM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 13:05:12 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 7/9] ath9k: fix block-ack window tracking issues
Date: Mon, 23 Jul 2018 18:02:58 +0200
Message-Id: <20180723160300.58024-7-nbd@nbd.name> (sfid-20180723_180322_581169_2808318A)
In-Reply-To: <20180723160300.58024-1-nbd@nbd.name>
References: <20180723160300.58024-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ensure that a buffer gets tracked as part of the block-ack window as
soon as it's dequeued from the tid for the first time. Ensure that
double calls to ath_tx_addto_baw (e.g. on retransmission) don't cause
any issues.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 29 +++++++++++++++++----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index d366170f01cf..bae0f6c045e1 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -62,7 +62,7 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 			     struct ath_tx_status *ts, int nframes, int nbad,
 			     int txok);
 static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
-			      int seqno);
+			      struct ath_buf *bf);
 static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 					   struct ath_txq *txq,
 					   struct ath_atx_tid *tid,
@@ -296,7 +296,7 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 		}
 
 		if (fi->baw_tracked) {
-			ath_tx_update_baw(sc, tid, bf->bf_state.seqno);
+			ath_tx_update_baw(sc, tid, bf);
 			sendbar = true;
 		}
 
@@ -312,10 +312,15 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 }
 
 static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
-			      int seqno)
+			      struct ath_buf *bf)
 {
+	struct ath_frame_info *fi = get_frame_info(bf->bf_mpdu);
+	u16 seqno = bf->bf_state.seqno;
 	int index, cindex;
 
+	if (!fi->baw_tracked)
+		return;
+
 	index  = ATH_BA_INDEX(tid->seq_start, seqno);
 	cindex = (tid->baw_head + index) & (ATH_TID_MAX_BUFS - 1);
 
@@ -336,6 +341,9 @@ static void ath_tx_addto_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
 	u16 seqno = bf->bf_state.seqno;
 	int index, cindex;
 
+	if (fi->baw_tracked)
+		return;
+
 	index  = ATH_BA_INDEX(tid->seq_start, seqno);
 	cindex = (tid->baw_head + index) & (ATH_TID_MAX_BUFS - 1);
 	__set_bit(cindex, tid->tx_buf);
@@ -612,7 +620,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			 * complete the acked-ones/xretried ones; update
 			 * block-ack window
 			 */
-			ath_tx_update_baw(sc, tid, seqno);
+			ath_tx_update_baw(sc, tid, bf);
 
 			if (rc_update && (acked_cnt == 1 || txfail_cnt == 1)) {
 				memcpy(tx_info->control.rates, rates, sizeof(rates));
@@ -642,7 +650,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				 * run out of tx buf.
 				 */
 				if (!tbf) {
-					ath_tx_update_baw(sc, tid, seqno);
+					ath_tx_update_baw(sc, tid, bf);
 
 					ath_tx_complete_buf(sc, bf, txq,
 							    &bf_head, NULL, ts,
@@ -1011,11 +1019,14 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
 
 			INIT_LIST_HEAD(&bf_head);
 			list_add(&bf->list, &bf_head);
-			ath_tx_update_baw(sc, tid, seqno);
+			ath_tx_update_baw(sc, tid, bf);
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, NULL, &ts, 0);
 			continue;
 		}
 
+		if (bf_isampdu(bf))
+			ath_tx_addto_baw(sc, tid, bf);
+
 		return bf;
 	}
 
@@ -1073,8 +1084,6 @@ ath_tx_form_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		bf->bf_next = NULL;
 
 		/* link buffers of this frame to the aggregate */
-		if (!fi->baw_tracked)
-			ath_tx_addto_baw(sc, tid, bf);
 		bf->bf_state.ndelim = ndelim;
 
 		list_add_tail(&bf->list, bf_q);
@@ -1710,10 +1719,8 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 			ath9k_set_moredata(sc, bf, true);
 			list_add_tail(&bf->list, &bf_q);
 			ath_set_rates(tid->an->vif, tid->an->sta, bf);
-			if (bf_isampdu(bf)) {
-				ath_tx_addto_baw(sc, tid, bf);
+			if (bf_isampdu(bf))
 				bf->bf_state.bf_type &= ~BUF_AGGR;
-			}
 			if (bf_tail)
 				bf_tail->bf_next = bf;
 
-- 
2.17.0
