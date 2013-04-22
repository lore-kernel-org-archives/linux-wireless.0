Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41210 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab3DVVLx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 17:11:53 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 1/2] ath9k: merge ath_tx_start_dma into ath_tx_start
Date: Mon, 22 Apr 2013 23:11:43 +0200
Message-Id: <1366665104-28737-1-git-send-email-nbd@openwrt.org> (sfid-20130422_231157_355842_AE8462AD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The split makes no sense and merging the functions makes further changes
easier to implement

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 80 ++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 5bc5802..108fe5f 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1892,49 +1892,6 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 	return bf;
 }
 
-/* FIXME: tx power */
-static void ath_tx_start_dma(struct ath_softc *sc, struct sk_buff *skb,
-			     struct ath_tx_control *txctl)
-{
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct ath_atx_tid *tid = NULL;
-	struct ath_buf *bf;
-	u8 tidno;
-
-	if (txctl->an && ieee80211_is_data_qos(hdr->frame_control)) {
-		tidno = ieee80211_get_qos_ctl(hdr)[0] &
-			IEEE80211_QOS_CTL_TID_MASK;
-		tid = ATH_AN_2_TID(txctl->an, tidno);
-
-		WARN_ON(tid->ac->txq != txctl->txq);
-	}
-
-	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && tid) {
-		/*
-		 * Try aggregation if it's a unicast data frame
-		 * and the destination is HT capable.
-		 */
-		ath_tx_send_ampdu(sc, tid, skb, txctl);
-	} else {
-		bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
-		if (!bf) {
-			if (txctl->paprd)
-				dev_kfree_skb_any(skb);
-			else
-				ieee80211_free_txskb(sc->hw, skb);
-			return;
-		}
-
-		bf->bf_state.bfs_paprd = txctl->paprd;
-
-		if (txctl->paprd)
-			bf->bf_state.bfs_paprd_timestamp = jiffies;
-
-		ath_tx_send_normal(sc, txctl->txq, tid, skb);
-	}
-}
-
 /* Upon failure caller should free skb */
 int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		 struct ath_tx_control *txctl)
@@ -1945,8 +1902,11 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ieee80211_vif *vif = info->control.vif;
 	struct ath_softc *sc = hw->priv;
 	struct ath_txq *txq = txctl->txq;
+	struct ath_atx_tid *tid = NULL;
+	struct ath_buf *bf;
 	int padpos, padsize;
 	int frmlen = skb->len + FCS_LEN;
+	u8 tidno;
 	int q;
 
 	/* NOTE:  sta can be NULL according to net/mac80211.h */
@@ -2002,8 +1962,40 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		txq->stopped = true;
 	}
 
-	ath_tx_start_dma(sc, skb, txctl);
+	if (txctl->an && ieee80211_is_data_qos(hdr->frame_control)) {
+		tidno = ieee80211_get_qos_ctl(hdr)[0] &
+			IEEE80211_QOS_CTL_TID_MASK;
+		tid = ATH_AN_2_TID(txctl->an, tidno);
+
+		WARN_ON(tid->ac->txq != txctl->txq);
+	}
+
+	if ((info->flags & IEEE80211_TX_CTL_AMPDU) && tid) {
+		/*
+		 * Try aggregation if it's a unicast data frame
+		 * and the destination is HT capable.
+		 */
+		ath_tx_send_ampdu(sc, tid, skb, txctl);
+		goto out;
+	}
+
+	bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
+	if (!bf) {
+		if (txctl->paprd)
+			dev_kfree_skb_any(skb);
+		else
+			ieee80211_free_txskb(sc->hw, skb);
+		goto out;
+	}
+
+	bf->bf_state.bfs_paprd = txctl->paprd;
+
+	if (txctl->paprd)
+		bf->bf_state.bfs_paprd_timestamp = jiffies;
+
+	ath_tx_send_normal(sc, txctl->txq, tid, skb);
 
+out:
 	ath_txq_unlock(sc, txq);
 
 	return 0;
-- 
1.8.0.2

