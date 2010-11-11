Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54587 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932227Ab0KKCdv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 21:33:51 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 4/5] ath9k: clean up tx buffer setup
Date: Thu, 11 Nov 2010 03:18:37 +0100
Message-Id: <1289441918-94905-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1289441918-94905-3-git-send-email-nbd@openwrt.org>
References: <1289441918-94905-1-git-send-email-nbd@openwrt.org>
 <1289441918-94905-2-git-send-email-nbd@openwrt.org>
 <1289441918-94905-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Merge ath_tx_send_normal and ath_tx_send_ht_normal.
Move the paprd state initialization and sequence number assignment
to reduce the number of redundant checks.

This not only simplifies buffer allocation error handling, but also
removes a small inconsistency in the buffer HT flag.
This flag should only be set if the frame is also a QoS data frame.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |  117 +++++++++++----------------------
 1 files changed, 39 insertions(+), 78 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 32e2267..8ba0e2d 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -48,9 +48,9 @@ static u16 bits_per_symbol[][2] = {
 
 #define IS_HT_RATE(_rate)     ((_rate) & 0x80)
 
-static void ath_tx_send_ht_normal(struct ath_softc *sc, struct ath_txq *txq,
-				  struct ath_atx_tid *tid,
-				  struct list_head *bf_head);
+static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
+			       struct ath_atx_tid *tid,
+			       struct list_head *bf_head);
 static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 				struct ath_txq *txq, struct list_head *bf_q,
 				struct ath_tx_status *ts, int txok, int sendbar);
@@ -160,7 +160,7 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 			ath_tx_update_baw(sc, tid, bf->bf_seqno);
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 0);
 		} else {
-			ath_tx_send_ht_normal(sc, txq, tid, &bf_head);
+			ath_tx_send_normal(sc, txq, tid, &bf_head);
 		}
 	}
 
@@ -1322,9 +1322,9 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 	ath_tx_txqaddbuf(sc, txctl->txq, bf_head);
 }
 
-static void ath_tx_send_ht_normal(struct ath_softc *sc, struct ath_txq *txq,
-				  struct ath_atx_tid *tid,
-				  struct list_head *bf_head)
+static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
+			       struct ath_atx_tid *tid,
+			       struct list_head *bf_head)
 {
 	struct ath_buf *bf;
 
@@ -1332,7 +1332,8 @@ static void ath_tx_send_ht_normal(struct ath_softc *sc, struct ath_txq *txq,
 	bf->bf_state.bf_type &= ~BUF_AMPDU;
 
 	/* update starting sequence number for subsequent ADDBA request */
-	INCR(tid->seq_start, IEEE80211_SEQ_MAX);
+	if (tid)
+		INCR(tid->seq_start, IEEE80211_SEQ_MAX);
 
 	bf->bf_nframes = 1;
 	bf->bf_lastbf = bf;
@@ -1341,20 +1342,6 @@ static void ath_tx_send_ht_normal(struct ath_softc *sc, struct ath_txq *txq,
 	TX_STAT_INC(txq->axq_qnum, queued);
 }
 
-static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
-			       struct list_head *bf_head)
-{
-	struct ath_buf *bf;
-
-	bf = list_first_entry(bf_head, struct ath_buf, list);
-
-	bf->bf_lastbf = bf;
-	bf->bf_nframes = 1;
-	ath_buf_set_rate(sc, bf);
-	ath_tx_txqaddbuf(sc, txq, bf_head);
-	TX_STAT_INC(txq->axq_qnum, queued);
-}
-
 static enum ath9k_pkt_type get_hw_packet_type(struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr;
@@ -1411,7 +1398,7 @@ static void assign_aggr_tid_seqno(struct sk_buff *skb,
 	INCR(tid->seq_next, IEEE80211_SEQ_MAX);
 }
 
-static int setup_tx_flags(struct sk_buff *skb, bool use_ldpc)
+static int setup_tx_flags(struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	int flags = 0;
@@ -1422,7 +1409,7 @@ static int setup_tx_flags(struct sk_buff *skb, bool use_ldpc)
 	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK)
 		flags |= ATH9K_TXDESC_NOACK;
 
-	if (use_ldpc)
+	if (tx_info->flags & IEEE80211_TX_CTL_LDPC)
 		flags |= ATH9K_TXDESC_LDPC;
 
 	return flags;
@@ -1567,18 +1554,24 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 		ath9k_hw_set11n_burstduration(sc->sc_ah, bf->bf_desc, 8192);
 }
 
-static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
-				struct sk_buff *skb,
-				struct ath_tx_control *txctl)
+static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
+					   struct sk_buff *skb)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ath_buf *bf;
 	int hdrlen;
 	__le16 fc;
 	int padpos, padsize;
-	bool use_ldpc = false;
+
+	bf = ath_tx_get_buffer(sc);
+	if (!bf) {
+		ath_print(common, ATH_DBG_XMIT, "TX buffers are full\n");
+		return NULL;
+	}
 
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 	fc = hdr->frame_control;
@@ -1594,16 +1587,13 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 		bf->bf_frmlen -= padsize;
 	}
 
-	if (!txctl->paprd && conf_is_ht(&hw->conf)) {
+	if (ieee80211_is_data_qos(fc) && conf_is_ht(&hw->conf)) {
 		bf->bf_state.bf_type |= BUF_HT;
-		if (tx_info->flags & IEEE80211_TX_CTL_LDPC)
-			use_ldpc = true;
+		if (sc->sc_flags & SC_OP_TXAGGR)
+			assign_aggr_tid_seqno(skb, bf);
 	}
 
-	bf->bf_state.bfs_paprd = txctl->paprd;
-	if (txctl->paprd)
-		bf->bf_state.bfs_paprd_timestamp = jiffies;
-	bf->bf_flags = setup_tx_flags(skb, use_ldpc);
+	bf->bf_flags = setup_tx_flags(skb);
 
 	bf->bf_keytype = ath9k_cmn_get_hw_crypto_keytype(skb);
 	if (bf->bf_keytype != ATH9K_KEY_TYPE_CLEAR) {
@@ -1613,10 +1603,6 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 		bf->bf_keyix = ATH9K_TXKEYIX_INVALID;
 	}
 
-	if (ieee80211_is_data_qos(fc) && bf_isht(bf) &&
-	    (sc->sc_flags & SC_OP_TXAGGR))
-		assign_aggr_tid_seqno(skb, bf);
-
 	bf->bf_mpdu = skb;
 
 	bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
@@ -1626,12 +1612,13 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 		bf->bf_buf_addr = 0;
 		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
 			  "dma_mapping_error() on TX\n");
-		return -ENOMEM;
+		ath_tx_return_buffer(sc, bf);
+		return NULL;
 	}
 
 	bf->bf_tx_aborted = false;
 
-	return 0;
+	return bf;
 }
 
 /* FIXME: tx power */
@@ -1679,11 +1666,6 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 		an = (struct ath_node *)tx_info->control.sta->drv_priv;
 		tid = ATH_AN_2_TID(an, bf->bf_tidno);
 
-		if (!ieee80211_is_data_qos(fc)) {
-			ath_tx_send_normal(sc, txctl->txq, &bf_head);
-			goto tx_done;
-		}
-
 		WARN_ON(tid->ac->txq != txctl->txq);
 		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
 			/*
@@ -1696,15 +1678,18 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 			 * Send this frame as regular when ADDBA
 			 * exchange is neither complete nor pending.
 			 */
-			ath_tx_send_ht_normal(sc, txctl->txq,
-					      tid, &bf_head);
+			ath_tx_send_normal(sc, txctl->txq, tid, &bf_head);
 		}
 	} else {
 		bf->bf_state.bfs_ftype = txctl->frame_type;
-		ath_tx_send_normal(sc, txctl->txq, &bf_head);
+		bf->bf_state.bfs_paprd = txctl->paprd;
+
+		if (txctl->paprd)
+			bf->bf_state.bfs_paprd_timestamp = jiffies;
+
+		ath_tx_send_normal(sc, txctl->txq, NULL, &bf_head);
 	}
 
-tx_done:
 	spin_unlock_bh(&txctl->txq->axq_lock);
 }
 
@@ -1714,39 +1699,15 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_txq *txq = txctl->txq;
 	struct ath_buf *bf;
-	int q, r;
+	int q;
 
-	bf = ath_tx_get_buffer(sc);
-	if (!bf) {
-		ath_print(common, ATH_DBG_XMIT, "TX buffers are full\n");
-		return -1;
-	}
+	bf = ath_tx_setup_buffer(hw, skb);
+	if (unlikely(!bf))
+		return -ENOMEM;
 
 	q = skb_get_queue_mapping(skb);
-	r = ath_tx_setup_buffer(hw, bf, skb, txctl);
-	if (unlikely(r)) {
-		ath_print(common, ATH_DBG_FATAL, "TX mem alloc failure\n");
-
-		/* upon ath_tx_processq() this TX queue will be resumed, we
-		 * guarantee this will happen by knowing beforehand that
-		 * we will at least have to run TX completionon one buffer
-		 * on the queue */
-		spin_lock_bh(&txq->axq_lock);
-		if (txq == sc->tx.txq_map[q] && !txq->stopped &&
-		    txq->axq_depth > 1) {
-			ath_mac80211_stop_queue(sc, q);
-			txq->stopped = 1;
-		}
-		spin_unlock_bh(&txq->axq_lock);
-
-		ath_tx_return_buffer(sc, bf);
-
-		return r;
-	}
-
 	spin_lock_bh(&txq->axq_lock);
 	if (txq == sc->tx.txq_map[q] &&
 	    ++txq->pending_frames > ATH_MAX_QDEPTH && !txq->stopped) {
-- 
1.7.2.2

