Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48044 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755693Ab0KNOUU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 09:20:20 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 12/13] ath9k: more tx setup cleanups
Date: Sun, 14 Nov 2010 15:20:12 +0100
Message-Id: <1289744413-20789-12-git-send-email-nbd@openwrt.org>
In-Reply-To: <1289744413-20789-11-git-send-email-nbd@openwrt.org>
References: <1289744413-20789-1-git-send-email-nbd@openwrt.org>
 <1289744413-20789-2-git-send-email-nbd@openwrt.org>
 <1289744413-20789-3-git-send-email-nbd@openwrt.org>
 <1289744413-20789-4-git-send-email-nbd@openwrt.org>
 <1289744413-20789-5-git-send-email-nbd@openwrt.org>
 <1289744413-20789-6-git-send-email-nbd@openwrt.org>
 <1289744413-20789-7-git-send-email-nbd@openwrt.org>
 <1289744413-20789-8-git-send-email-nbd@openwrt.org>
 <1289744413-20789-9-git-send-email-nbd@openwrt.org>
 <1289744413-20789-10-git-send-email-nbd@openwrt.org>
 <1289744413-20789-11-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- remove the BUF_HT flag, and instead check for IEEE80211_TX_CTL_AMPDU
  before calling ath_tx_send_ampdu.
- remove a few unused variables
- calculate frame length before adding the frame padding
- merge the misnamed ath_tx_start_dma function into ath_tx_start
- remove an unused argument for assign_aggr_tid_seqno

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    4 +-
 drivers/net/wireless/ath/ath9k/xmit.c  |  129 ++++++++++++++-----------------
 2 files changed, 59 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a403fca..ae876f9 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -86,7 +86,6 @@ struct ath_config {
 /**
  * enum buffer_type - Buffer type flags
  *
- * @BUF_HT: Send this buffer using HT capabilities
  * @BUF_AMPDU: This buffer is an ampdu, as part of an aggregate (during TX)
  * @BUF_AGGR: Indicates whether the buffer can be aggregated
  *	(used in aggregation scheduling)
@@ -94,7 +93,6 @@ struct ath_config {
  * @BUF_XRETRY: To denote excessive retries of the buffer
  */
 enum buffer_type {
-	BUF_HT			= BIT(1),
 	BUF_AMPDU		= BIT(2),
 	BUF_AGGR		= BIT(3),
 	BUF_RETRY		= BIT(4),
@@ -102,7 +100,6 @@ enum buffer_type {
 };
 
 #define bf_retries      	bf_state.bfs_retries
-#define bf_isht(bf)		(bf->bf_state.bf_type & BUF_HT)
 #define bf_isampdu(bf)		(bf->bf_state.bf_type & BUF_AMPDU)
 #define bf_isaggr(bf)		(bf->bf_state.bf_type & BUF_AGGR)
 #define bf_isretried(bf)	(bf->bf_state.bf_type & BUF_RETRY)
@@ -265,6 +262,7 @@ struct ath_tx_control {
 	struct ath_txq *txq;
 	int if_id;
 	enum ath9k_internal_frame_type frame_type;
+	int frmlen;
 	u8 paprd;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index f3f0d1c..5eeffae 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1344,13 +1344,11 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 }
 
 static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
-			      struct list_head *bf_head,
-			      struct ath_tx_control *txctl, int frmlen)
+			      struct ath_buf *bf, struct ath_tx_control *txctl)
 {
-	struct ath_buf *bf;
+	struct list_head bf_head;
 	u16 bf_seqno;
 
-	bf = list_first_entry(bf_head, struct ath_buf, list);
 	bf->bf_state.bf_type |= BUF_AMPDU;
 	TX_STAT_INC(txctl->txq->axq_qnum, a_queued);
 	bf_seqno = ath_frame_seqno(bf->bf_mpdu);
@@ -1369,19 +1367,22 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 		 * Add this frame to software queue for scheduling later
 		 * for aggregation.
 		 */
-		list_move_tail(&bf->list, &tid->buf_q);
+		list_add_tail(&bf->list, &tid->buf_q);
 		ath_tx_queue_tid(txctl->txq, tid);
 		return;
 	}
 
+	INIT_LIST_HEAD(&bf_head);
+	list_add(&bf->list, &bf_head);
+
 	/* Add sub-frame to BAW */
 	if (!bf_isretried(bf))
 		ath_tx_addto_baw(sc, tid, bf_seqno);
 
 	/* Queue to h/w without aggregation */
 	bf->bf_lastbf = bf;
-	ath_buf_set_rate(sc, bf, frmlen);
-	ath_tx_txqaddbuf(sc, txctl->txq, bf_head);
+	ath_buf_set_rate(sc, bf, txctl->frmlen);
+	ath_tx_txqaddbuf(sc, txctl->txq, &bf_head);
 }
 
 static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
@@ -1426,8 +1427,7 @@ static enum ath9k_pkt_type get_hw_packet_type(struct sk_buff *skb)
 	return htype;
 }
 
-static void assign_aggr_tid_seqno(struct sk_buff *skb,
-				  struct ath_buf *bf)
+static void assign_aggr_tid_seqno(struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr;
@@ -1608,15 +1608,20 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
 }
 
 static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
-					   struct sk_buff *skb)
+					   struct ath_txq *txq,
+					   struct sk_buff *skb, int frmlen)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
+	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb;
 	struct ath_buf *bf;
-	int hdrlen;
-	__le16 fc;
+	struct ath_desc *ds;
+	enum ath9k_key_type keytype;
+	u32 keyix;
+	int frm_type;
 
 	bf = ath_tx_get_buffer(sc);
 	if (!bf) {
@@ -1624,21 +1629,14 @@ static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
 		return NULL;
 	}
 
-	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	fc = hdr->frame_control;
-
 	ATH_TXBUF_RESET(bf);
 
-	bf->aphy = aphy;
-
-	if (ieee80211_is_data_qos(fc) && conf_is_ht(&hw->conf)) {
-		bf->bf_state.bf_type |= BUF_HT;
-		if (sc->sc_flags & SC_OP_TXAGGR)
-			assign_aggr_tid_seqno(skb, bf);
-	}
+	if (ieee80211_is_data_qos(hdr->frame_control) &&
+		conf_is_ht(&hw->conf) && (sc->sc_flags & SC_OP_TXAGGR))
+			assign_aggr_tid_seqno(skb);
 
+	bf->aphy = aphy;
 	bf->bf_flags = setup_tx_flags(skb);
-
 	bf->bf_mpdu = skb;
 
 	bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
@@ -1652,33 +1650,7 @@ static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
 		return NULL;
 	}
 
-	return bf;
-}
-
-/* FIXME: tx power */
-static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
-			     struct ath_tx_control *txctl)
-{
-	struct sk_buff *skb = bf->bf_mpdu;
-	struct ieee80211_tx_info *tx_info =  IEEE80211_SKB_CB(skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct ath_node *an = NULL;
-	struct list_head bf_head;
-	struct ath_desc *ds;
-	struct ath_atx_tid *tid;
-	struct ath_hw *ah = sc->sc_ah;
-	enum ath9k_key_type keytype;
-	u32 keyix;
-	int frm_type;
-	__le16 fc;
-	u8 tidno;
-	int frmlen;
-
 	frm_type = get_hw_packet_type(skb);
-	fc = hdr->frame_control;
-
-	INIT_LIST_HEAD(&bf_head);
-	list_add_tail(&bf->list, &bf_head);
 
 	ds = bf->bf_desc;
 	ath9k_hw_set_desc_link(ah, ds, 0);
@@ -1689,7 +1661,6 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 	else
 		keyix = ATH9K_TXKEYIX_INVALID;
 
-	frmlen = ath_frame_len(bf->bf_mpdu);
 	ath9k_hw_set11n_txdesc(ah, ds, frmlen, frm_type, MAX_RATE_POWER,
 			       keyix, keytype, bf->bf_flags);
 
@@ -1699,40 +1670,50 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 			    true,	/* last segment */
 			    ds,		/* first descriptor */
 			    bf->bf_buf_addr,
-			    txctl->txq->axq_qnum);
+			    txq->axq_qnum);
+
+
+	return bf;
+}
+
+/* FIXME: tx power */
+static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
+			     struct ath_tx_control *txctl)
+{
+	struct sk_buff *skb = bf->bf_mpdu;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ath_node *an = NULL;
+	struct list_head bf_head;
+	struct ath_atx_tid *tid;
+	u8 tidno;
 
 	spin_lock_bh(&txctl->txq->axq_lock);
 
-	if (bf_isht(bf) && (sc->sc_flags & SC_OP_TXAGGR) &&
-	    tx_info->control.sta) {
+	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && tx_info->control.sta) {
 		an = (struct ath_node *)tx_info->control.sta->drv_priv;
 		tidno = ieee80211_get_qos_ctl(hdr)[0] &
 			IEEE80211_QOS_CTL_TID_MASK;
 		tid = ATH_AN_2_TID(an, tidno);
 
-
 		WARN_ON(tid->ac->txq != txctl->txq);
-		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
-			/*
-			 * Try aggregation if it's a unicast data frame
-			 * and the destination is HT capable.
-			 */
-			ath_tx_send_ampdu(sc, tid, &bf_head, txctl, frmlen);
-		} else {
-			/*
-			 * Send this frame as regular when ADDBA
-			 * exchange is neither complete nor pending.
-			 */
-			ath_tx_send_normal(sc, txctl->txq, tid, &bf_head, frmlen);
-		}
+		/*
+		 * Try aggregation if it's a unicast data frame
+		 * and the destination is HT capable.
+		 */
+		ath_tx_send_ampdu(sc, tid, bf, txctl);
 	} else {
+		INIT_LIST_HEAD(&bf_head);
+		list_add_tail(&bf->list, &bf_head);
+
 		bf->bf_state.bfs_ftype = txctl->frame_type;
 		bf->bf_state.bfs_paprd = txctl->paprd;
 
 		if (bf->bf_state.bfs_paprd)
-			ar9003_hw_set_paprd_txdesc(ah, ds, bf->bf_state.bfs_paprd);
+			ar9003_hw_set_paprd_txdesc(sc->sc_ah, bf->bf_desc,
+						   bf->bf_state.bfs_paprd);
 
-		ath_tx_send_normal(sc, txctl->txq, NULL, &bf_head, frmlen);
+		ath_tx_send_normal(sc, txctl->txq, NULL, &bf_head, txctl->frmlen);
 	}
 
 	spin_unlock_bh(&txctl->txq->axq_lock);
@@ -1749,8 +1730,14 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ath_txq *txq = txctl->txq;
 	struct ath_buf *bf;
 	int padpos, padsize;
+	int frmlen = skb->len + FCS_LEN;
 	int q;
 
+	if (info->control.hw_key)
+		frmlen += info->control.hw_key->icv_len;
+
+	txctl->frmlen = frmlen;
+
 	/*
 	 * As a temporary workaround, assign seq# here; this will likely need
 	 * to be cleaned up to work better with Beacon transmission and virtual
@@ -1774,7 +1761,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		memmove(skb->data, skb->data + padsize, padpos);
 	}
 
-	bf = ath_tx_setup_buffer(hw, skb);
+	bf = ath_tx_setup_buffer(hw, txctl->txq, skb, frmlen);
 	if (unlikely(!bf))
 		return -ENOMEM;
 
-- 
1.7.3.2

