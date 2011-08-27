Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46054 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab1H0Wcg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 18:32:36 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 4/5] ath9k: move seqno allocation in the tx path to ath_tx_setup_buffer
Date: Sun, 28 Aug 2011 00:32:24 +0200
Message-Id: <1314484345-7018-4-git-send-email-nbd@openwrt.org> (sfid-20110828_003244_620445_06E01A25)
In-Reply-To: <1314484345-7018-3-git-send-email-nbd@openwrt.org>
References: <1314484345-7018-1-git-send-email-nbd@openwrt.org>
 <1314484345-7018-2-git-send-email-nbd@openwrt.org>
 <1314484345-7018-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   42 ++++++++++++++++++---------------
 1 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index b7f7198..00e9191 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1714,17 +1714,19 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
 
 }
 
-static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
+static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 					   struct ath_txq *txq,
+					   struct ath_atx_tid *tid,
 					   struct sk_buff *skb)
 {
-	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_frame_info *fi = get_frame_info(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ath_buf *bf;
 	struct ath_desc *ds;
 	int frm_type;
+	u16 seqno;
 
 	bf = ath_tx_get_buffer(sc);
 	if (!bf) {
@@ -1734,6 +1736,13 @@ static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
 
 	ATH_TXBUF_RESET(bf);
 
+	if (tid) {
+		seqno = tid->seq_next;
+		hdr->seq_ctrl = cpu_to_le16(tid->seq_next << IEEE80211_SEQ_SEQ_SHIFT);
+		INCR(tid->seq_next, IEEE80211_SEQ_MAX);
+		bf->bf_state.seqno = seqno;
+	}
+
 	bf->bf_flags = setup_tx_flags(skb);
 	bf->bf_mpdu = skb;
 
@@ -1770,15 +1779,15 @@ static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
 }
 
 /* FIXME: tx power */
-static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
+static int ath_tx_start_dma(struct ath_softc *sc, struct sk_buff *skb,
 			     struct ath_tx_control *txctl)
 {
-	struct sk_buff *skb = bf->bf_mpdu;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct list_head bf_head;
 	struct ath_atx_tid *tid = NULL;
-	u16 seqno;
+	struct ath_buf *bf;
+	int ret = 0;
 	u8 tidno;
 
 	spin_lock_bh(&txctl->txq->axq_lock);
@@ -1788,15 +1797,15 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 			IEEE80211_QOS_CTL_TID_MASK;
 		tid = ATH_AN_2_TID(txctl->an, tidno);
 
-		seqno = tid->seq_next;
-		hdr->seq_ctrl = cpu_to_le16(tid->seq_next << IEEE80211_SEQ_SEQ_SHIFT);
-		INCR(tid->seq_next, IEEE80211_SEQ_MAX);
-
-		bf->bf_state.seqno = seqno;
-
 		WARN_ON(tid->ac->txq != txctl->txq);
 	}
 
+	bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
+	if (unlikely(!bf)) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && tid) {
 		/*
 		 * Try aggregation if it's a unicast data frame
@@ -1822,7 +1831,9 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 		ath_tx_send_normal(sc, txctl->txq, tid, &bf_head);
 	}
 
+out:
 	spin_unlock_bh(&txctl->txq->axq_lock);
+	return ret;
 }
 
 /* Upon failure caller should free skb */
@@ -1835,7 +1846,6 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ieee80211_vif *vif = info->control.vif;
 	struct ath_softc *sc = hw->priv;
 	struct ath_txq *txq = txctl->txq;
-	struct ath_buf *bf;
 	int padpos, padsize;
 	int frmlen = skb->len + FCS_LEN;
 	int q;
@@ -1882,10 +1892,6 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * info are no longer valid (overwritten by the ath_frame_info data.
 	 */
 
-	bf = ath_tx_setup_buffer(hw, txctl->txq, skb);
-	if (unlikely(!bf))
-		return -ENOMEM;
-
 	q = skb_get_queue_mapping(skb);
 	spin_lock_bh(&txq->axq_lock);
 	if (txq == sc->tx.txq_map[q] &&
@@ -1895,9 +1901,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	}
 	spin_unlock_bh(&txq->axq_lock);
 
-	ath_tx_start_dma(sc, bf, txctl);
-
-	return 0;
+	return ath_tx_start_dma(sc, skb, txctl);
 }
 
 /*****************/
-- 
1.7.3.2

