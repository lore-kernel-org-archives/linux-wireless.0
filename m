Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48073 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755851Ab0KNOUX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 09:20:23 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 08/13] ath9k: remove bfs_frmlen from struct ath_buf_state
Date: Sun, 14 Nov 2010 15:20:08 +0100
Message-Id: <1289744413-20789-8-git-send-email-nbd@openwrt.org>
In-Reply-To: <1289744413-20789-7-git-send-email-nbd@openwrt.org>
References: <1289744413-20789-1-git-send-email-nbd@openwrt.org>
 <1289744413-20789-2-git-send-email-nbd@openwrt.org>
 <1289744413-20789-3-git-send-email-nbd@openwrt.org>
 <1289744413-20789-4-git-send-email-nbd@openwrt.org>
 <1289744413-20789-5-git-send-email-nbd@openwrt.org>
 <1289744413-20789-6-git-send-email-nbd@openwrt.org>
 <1289744413-20789-7-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 -
 drivers/net/wireless/ath/ath9k/xmit.c  |   63 +++++++++++++++++++-------------
 2 files changed, 38 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index ddfddbb..944505c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -101,7 +101,6 @@ enum buffer_type {
 	BUF_XRETRY		= BIT(5),
 };
 
-#define bf_frmlen       	bf_state.bfs_frmlen
 #define bf_retries      	bf_state.bfs_retries
 #define bf_isht(bf)		(bf->bf_state.bf_type & BUF_HT)
 #define bf_isampdu(bf)		(bf->bf_state.bf_type & BUF_AMPDU)
@@ -215,7 +214,6 @@ struct ath_buf_state {
 	int bfs_retries;
 	u8 bf_type;
 	u8 bfs_paprd;
-	u16 bfs_frmlen;
 	enum ath9k_internal_frame_type bfs_ftype;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 87b79ef..527151e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -50,7 +50,7 @@ static u16 bits_per_symbol[][2] = {
 
 static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 			       struct ath_atx_tid *tid,
-			       struct list_head *bf_head);
+			       struct list_head *bf_head, int frmlen);
 static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 				struct ath_txq *txq, struct list_head *bf_q,
 				struct ath_tx_status *ts, int txok, int sendbar);
@@ -144,6 +144,26 @@ static u16 ath_frame_seqno(struct sk_buff *skb)
 	return le16_to_cpu(hdr->seq_ctrl) >> IEEE80211_SEQ_SEQ_SHIFT;
 }
 
+static int ath_frame_len(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	int frmlen = skb->len + FCS_LEN;
+	int padpos, padsize;
+
+	/* Remove the padding size, if any */
+	padpos = ath9k_cmn_padpos(hdr->frame_control);
+	padsize = padpos & 3;
+
+	if (padsize && skb->len > padpos + padsize)
+		frmlen -= padsize;
+
+	if (tx_info->control.hw_key)
+		frmlen += tx_info->control.hw_key->icv_len;
+
+	return frmlen;
+}
+
 static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 {
 	struct ath_txq *txq = tid->ac->txq;
@@ -164,7 +184,8 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 			ath_tx_update_baw(sc, tid, ath_frame_seqno(bf->bf_mpdu));
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 0);
 		} else {
-			ath_tx_send_normal(sc, txq, tid, &bf_head);
+			ath_tx_send_normal(sc, txq, tid, &bf_head,
+					   ath_frame_len(bf->bf_mpdu));
 		}
 	}
 
@@ -713,6 +734,7 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		al_delta, h_baw = tid->baw_size / 2;
 	enum ATH_AGGR_STATUS status = ATH_AGGR_DONE;
 	struct ieee80211_tx_info *tx_info;
+	int frmlen;
 	u16 bf_seqno;
 
 	bf_first = list_first_entry(&tid->buf_q, struct ath_buf, list);
@@ -733,7 +755,8 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		}
 
 		/* do not exceed aggregation limit */
-		al_delta = ATH_AGGR_DELIM_SZ + bf->bf_frmlen;
+		frmlen = ath_frame_len(bf->bf_mpdu);
+		al_delta = ATH_AGGR_DELIM_SZ + frmlen;
 
 		if (nframes &&
 		    (aggr_limit < (al + bpad + al_delta + prev_al))) {
@@ -760,7 +783,7 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		 * Get the delimiters needed to meet the MPDU
 		 * density for this node.
 		 */
-		ndelim = ath_compute_num_delims(sc, tid, bf_first, bf->bf_frmlen);
+		ndelim = ath_compute_num_delims(sc, tid, bf_first, frmlen);
 		bpad = PADBYTES(al_delta) + (ndelim << 2);
 
 		bf->bf_next = NULL;
@@ -816,7 +839,7 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		if (bf == bf->bf_lastbf) {
 			bf->bf_state.bf_type &= ~BUF_AGGR;
 			ath9k_hw_clr11n_aggr(sc->sc_ah, bf->bf_desc);
-			ath_buf_set_rate(sc, bf, bf->bf_frmlen);
+			ath_buf_set_rate(sc, bf, ath_frame_len(bf->bf_mpdu));
 			ath_tx_txqaddbuf(sc, txq, &bf_q);
 			continue;
 		}
@@ -1327,7 +1350,7 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 
 static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 			      struct list_head *bf_head,
-			      struct ath_tx_control *txctl)
+			      struct ath_tx_control *txctl, int frmlen)
 {
 	struct ath_buf *bf;
 	u16 bf_seqno;
@@ -1362,13 +1385,13 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 
 	/* Queue to h/w without aggregation */
 	bf->bf_lastbf = bf;
-	ath_buf_set_rate(sc, bf, bf->bf_frmlen);
+	ath_buf_set_rate(sc, bf, frmlen);
 	ath_tx_txqaddbuf(sc, txctl->txq, bf_head);
 }
 
 static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 			       struct ath_atx_tid *tid,
-			       struct list_head *bf_head)
+			       struct list_head *bf_head, int frmlen)
 {
 	struct ath_buf *bf;
 
@@ -1380,7 +1403,7 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 		INCR(tid->seq_start, IEEE80211_SEQ_MAX);
 
 	bf->bf_lastbf = bf;
-	ath_buf_set_rate(sc, bf, bf->bf_frmlen);
+	ath_buf_set_rate(sc, bf, frmlen);
 	ath_tx_txqaddbuf(sc, txq, bf_head);
 	TX_STAT_INC(txq->axq_qnum, queued);
 }
@@ -1595,12 +1618,10 @@ static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ath_buf *bf;
 	int hdrlen;
 	__le16 fc;
-	int padpos, padsize;
 
 	bf = ath_tx_get_buffer(sc);
 	if (!bf) {
@@ -1614,13 +1635,6 @@ static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
 	ATH_TXBUF_RESET(bf);
 
 	bf->aphy = aphy;
-	bf->bf_frmlen = skb->len + FCS_LEN;
-	/* Remove the padding size from bf_frmlen, if any */
-	padpos = ath9k_cmn_padpos(hdr->frame_control);
-	padsize = padpos & 3;
-	if (padsize && skb->len>padpos+padsize) {
-		bf->bf_frmlen -= padsize;
-	}
 
 	if (ieee80211_is_data_qos(fc) && conf_is_ht(&hw->conf)) {
 		bf->bf_state.bf_type |= BUF_HT;
@@ -1630,9 +1644,6 @@ static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
 
 	bf->bf_flags = setup_tx_flags(skb);
 
-	if (tx_info->control.hw_key)
-		bf->bf_frmlen += tx_info->control.hw_key->icv_len;
-
 	bf->bf_mpdu = skb;
 
 	bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
@@ -1668,6 +1679,7 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 	int frm_type;
 	__le16 fc;
 	u8 tidno;
+	int frmlen;
 
 	frm_type = get_hw_packet_type(skb);
 	fc = hdr->frame_control;
@@ -1684,7 +1696,8 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 	else
 		keyix = ATH9K_TXKEYIX_INVALID;
 
-	ath9k_hw_set11n_txdesc(ah, ds, bf->bf_frmlen, frm_type, MAX_RATE_POWER,
+	frmlen = ath_frame_len(bf->bf_mpdu);
+	ath9k_hw_set11n_txdesc(ah, ds, frmlen, frm_type, MAX_RATE_POWER,
 			       keyix, keytype, bf->bf_flags);
 
 	ath9k_hw_filltxdesc(ah, ds,
@@ -1711,13 +1724,13 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 			 * Try aggregation if it's a unicast data frame
 			 * and the destination is HT capable.
 			 */
-			ath_tx_send_ampdu(sc, tid, &bf_head, txctl);
+			ath_tx_send_ampdu(sc, tid, &bf_head, txctl, frmlen);
 		} else {
 			/*
 			 * Send this frame as regular when ADDBA
 			 * exchange is neither complete nor pending.
 			 */
-			ath_tx_send_normal(sc, txctl->txq, tid, &bf_head);
+			ath_tx_send_normal(sc, txctl->txq, tid, &bf_head, frmlen);
 		}
 	} else {
 		bf->bf_state.bfs_ftype = txctl->frame_type;
@@ -1726,7 +1739,7 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 		if (bf->bf_state.bfs_paprd)
 			ar9003_hw_set_paprd_txdesc(ah, ds, bf->bf_state.bfs_paprd);
 
-		ath_tx_send_normal(sc, txctl->txq, NULL, &bf_head);
+		ath_tx_send_normal(sc, txctl->txq, NULL, &bf_head, frmlen);
 	}
 
 	spin_unlock_bh(&txctl->txq->axq_lock);
-- 
1.7.3.2

