Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48045 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755626Ab0KNOUU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 09:20:20 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 07/13] ath9k: remove bfs_nframes from struct ath_buf_state
Date: Sun, 14 Nov 2010 15:20:07 +0100
Message-Id: <1289744413-20789-7-git-send-email-nbd@openwrt.org>
In-Reply-To: <1289744413-20789-6-git-send-email-nbd@openwrt.org>
References: <1289744413-20789-1-git-send-email-nbd@openwrt.org>
 <1289744413-20789-2-git-send-email-nbd@openwrt.org>
 <1289744413-20789-3-git-send-email-nbd@openwrt.org>
 <1289744413-20789-4-git-send-email-nbd@openwrt.org>
 <1289744413-20789-5-git-send-email-nbd@openwrt.org>
 <1289744413-20789-6-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 -
 drivers/net/wireless/ath/ath9k/xmit.c  |   97 +++++++++++++++----------------
 2 files changed, 47 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index d1c714a..ddfddbb 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -101,7 +101,6 @@ enum buffer_type {
 	BUF_XRETRY		= BIT(5),
 };
 
-#define bf_nframes      	bf_state.bfs_nframes
 #define bf_frmlen       	bf_state.bfs_frmlen
 #define bf_retries      	bf_state.bfs_retries
 #define bf_isht(bf)		(bf->bf_state.bf_type & BUF_HT)
@@ -213,7 +212,6 @@ struct ath_atx_ac {
 };
 
 struct ath_buf_state {
-	int bfs_nframes;
 	int bfs_retries;
 	u8 bf_type;
 	u8 bfs_paprd;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 88efcc1..87b79ef 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -57,10 +57,8 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 			     struct list_head *head);
 static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len);
-static int ath_tx_num_badfrms(struct ath_softc *sc, struct ath_buf *bf,
-			      struct ath_tx_status *ts, int txok);
 static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
-			     int nbad, int txok, bool update_rc);
+			     int nframes, int nbad, int txok, bool update_rc);
 static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
 			      int seqno);
 
@@ -303,6 +301,39 @@ static struct ath_buf* ath_clone_txbuf(struct ath_softc *sc, struct ath_buf *bf)
 	return tbf;
 }
 
+static void ath_tx_count_frames(struct ath_softc *sc, struct ath_buf *bf,
+			        struct ath_tx_status *ts, int txok,
+			        int *nframes, int *nbad)
+{
+	u16 seq_st = 0;
+	u32 ba[WME_BA_BMP_SIZE >> 5];
+	int ba_index;
+	int isaggr = 0;
+
+	*nbad = 0;
+	*nframes = 0;
+
+	if (bf->bf_lastbf->bf_tx_aborted)
+		return;
+
+	isaggr = bf_isaggr(bf);
+	if (isaggr) {
+		seq_st = ts->ts_seqnum;
+		memcpy(ba, &ts->ba_low, WME_BA_BMP_SIZE >> 3);
+	}
+
+	while (bf) {
+		ba_index = ATH_BA_INDEX(seq_st, ath_frame_seqno(bf->bf_mpdu));
+
+		(*nframes)++;
+		if (!txok || (isaggr && !ATH_BA_ISSET(ba, ba_index)))
+			(*nbad)++;
+
+		bf = bf->bf_next;
+	}
+}
+
+
 static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				 struct ath_buf *bf, struct list_head *bf_q,
 				 struct ath_tx_status *ts, int txok)
@@ -332,7 +363,6 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	hw = bf->aphy->hw;
 
 	memcpy(rates, tx_info->control.rates, sizeof(rates));
-	nframes = bf->bf_nframes;
 
 	rcu_read_lock();
 
@@ -349,7 +379,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			    !bf->bf_stale || bf_next != NULL)
 				list_move_tail(&bf->list, &bf_head);
 
-			ath_tx_rc_status(bf, ts, 1, 0, false);
+			ath_tx_rc_status(bf, ts, 1, 1, 0, false);
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, ts,
 				0, 0);
 
@@ -393,7 +423,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	INIT_LIST_HEAD(&bf_pending);
 	INIT_LIST_HEAD(&bf_head);
 
-	nbad = ath_tx_num_badfrms(sc, bf, ts, txok);
+	ath_tx_count_frames(sc, bf, ts, txok, &nframes, &nbad);
 	while (bf) {
 		txfail = txpending = 0;
 		bf_next = bf->bf_next;
@@ -456,11 +486,10 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 			if (rc_update && (acked_cnt == 1 || txfail_cnt == 1)) {
 				memcpy(tx_info->control.rates, rates, sizeof(rates));
-				bf->bf_nframes = nframes;
-				ath_tx_rc_status(bf, ts, nbad, txok, true);
+				ath_tx_rc_status(bf, ts, nframes, nbad, txok, true);
 				rc_update = false;
 			} else {
-				ath_tx_rc_status(bf, ts, nbad, txok, false);
+				ath_tx_rc_status(bf, ts, nframes, nbad, txok, false);
 			}
 
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, ts,
@@ -485,8 +514,8 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 						bf->bf_state.bf_type |=
 							BUF_XRETRY;
-						ath_tx_rc_status(bf, ts, nbad,
-								0, false);
+						ath_tx_rc_status(bf, ts, nframes,
+								nbad, 0, false);
 						ath_tx_complete_buf(sc, bf, txq,
 								    &bf_head,
 								    ts, 0, 0);
@@ -752,7 +781,6 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 	} while (!list_empty(&tid->buf_q));
 
 	*aggr_len = al;
-	bf_first->bf_nframes = nframes;
 
 	return status;
 #undef PADBYTES
@@ -785,7 +813,7 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		bf->bf_lastbf = list_entry(bf_q.prev, struct ath_buf, list);
 
 		/* if only one frame, send as non-aggregate */
-		if (bf->bf_nframes == 1) {
+		if (bf == bf->bf_lastbf) {
 			bf->bf_state.bf_type &= ~BUF_AGGR;
 			ath9k_hw_clr11n_aggr(sc->sc_ah, bf->bf_desc);
 			ath_buf_set_rate(sc, bf, bf->bf_frmlen);
@@ -1333,7 +1361,6 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 		ath_tx_addto_baw(sc, tid, bf_seqno);
 
 	/* Queue to h/w without aggregation */
-	bf->bf_nframes = 1;
 	bf->bf_lastbf = bf;
 	ath_buf_set_rate(sc, bf, bf->bf_frmlen);
 	ath_tx_txqaddbuf(sc, txctl->txq, bf_head);
@@ -1352,7 +1379,6 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 	if (tid)
 		INCR(tid->seq_start, IEEE80211_SEQ_MAX);
 
-	bf->bf_nframes = 1;
 	bf->bf_lastbf = bf;
 	ath_buf_set_rate(sc, bf, bf->bf_frmlen);
 	ath_tx_txqaddbuf(sc, txq, bf_head);
@@ -1895,37 +1921,8 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 	spin_unlock_irqrestore(&sc->tx.txbuflock, flags);
 }
 
-static int ath_tx_num_badfrms(struct ath_softc *sc, struct ath_buf *bf,
-			      struct ath_tx_status *ts, int txok)
-{
-	u16 seq_st = 0;
-	u32 ba[WME_BA_BMP_SIZE >> 5];
-	int ba_index;
-	int nbad = 0;
-	int isaggr = 0;
-
-	if (bf->bf_lastbf->bf_tx_aborted)
-		return 0;
-
-	isaggr = bf_isaggr(bf);
-	if (isaggr) {
-		seq_st = ts->ts_seqnum;
-		memcpy(ba, &ts->ba_low, WME_BA_BMP_SIZE >> 3);
-	}
-
-	while (bf) {
-		ba_index = ATH_BA_INDEX(seq_st, ath_frame_seqno(bf->bf_mpdu));
-		if (!txok || (isaggr && !ATH_BA_ISSET(ba, ba_index)))
-			nbad++;
-
-		bf = bf->bf_next;
-	}
-
-	return nbad;
-}
-
 static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
-			     int nbad, int txok, bool update_rc)
+			     int nframes, int nbad, int txok, bool update_rc)
 {
 	struct sk_buff *skb = bf->bf_mpdu;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -1946,10 +1943,10 @@ static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
 	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && update_rc) {
 		tx_info->flags |= IEEE80211_TX_STAT_AMPDU;
 
-		BUG_ON(nbad > bf->bf_nframes);
+		BUG_ON(nbad > nframes);
 
-		tx_info->status.ampdu_len = bf->bf_nframes;
-		tx_info->status.ampdu_ack_len = bf->bf_nframes - nbad;
+		tx_info->status.ampdu_len = nframes;
+		tx_info->status.ampdu_ack_len = nframes - nbad;
 	}
 
 	if ((ts->ts_status & ATH9K_TXERR_FILT) == 0 &&
@@ -2078,7 +2075,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 			 */
 			if (ts.ts_status & ATH9K_TXERR_XRETRY)
 				bf->bf_state.bf_type |= BUF_XRETRY;
-			ath_tx_rc_status(bf, &ts, txok ? 0 : 1, txok, true);
+			ath_tx_rc_status(bf, &ts, 1, txok ? 0 : 1, txok, true);
 		}
 
 		qnum = skb_get_queue_mapping(bf->bf_mpdu);
@@ -2200,7 +2197,7 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 		if (!bf_isampdu(bf)) {
 			if (txs.ts_status & ATH9K_TXERR_XRETRY)
 				bf->bf_state.bf_type |= BUF_XRETRY;
-			ath_tx_rc_status(bf, &txs, txok ? 0 : 1, txok, true);
+			ath_tx_rc_status(bf, &txs, 1, txok ? 0 : 1, txok, true);
 		}
 
 		qnum = skb_get_queue_mapping(bf->bf_mpdu);
-- 
1.7.3.2

