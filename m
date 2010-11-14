Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48072 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755836Ab0KNOUX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 09:20:23 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 10/13] ath9k: clean up code duplication around ath_tx_start
Date: Sun, 14 Nov 2010 15:20:10 +0100
Message-Id: <1289744413-20789-10-git-send-email-nbd@openwrt.org>
In-Reply-To: <1289744413-20789-9-git-send-email-nbd@openwrt.org>
References: <1289744413-20789-1-git-send-email-nbd@openwrt.org>
 <1289744413-20789-2-git-send-email-nbd@openwrt.org>
 <1289744413-20789-3-git-send-email-nbd@openwrt.org>
 <1289744413-20789-4-git-send-email-nbd@openwrt.org>
 <1289744413-20789-5-git-send-email-nbd@openwrt.org>
 <1289744413-20789-6-git-send-email-nbd@openwrt.org>
 <1289744413-20789-7-git-send-email-nbd@openwrt.org>
 <1289744413-20789-8-git-send-email-nbd@openwrt.org>
 <1289744413-20789-9-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Merge initial processing for the CAB queue and regular tx.
Also move ath_tx_cabq() to beacon.c and make it static.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    1 -
 drivers/net/wireless/ath/ath9k/beacon.c |   19 +++++++++
 drivers/net/wireless/ath/ath9k/main.c   |   25 -----------
 drivers/net/wireless/ath/ath9k/xmit.c   |   67 +++++++++---------------------
 4 files changed, 39 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 224df29..a403fca 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -323,7 +323,6 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		 struct ath_tx_control *txctl);
 void ath_tx_tasklet(struct ath_softc *sc);
 void ath_tx_edma_tasklet(struct ath_softc *sc);
-void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb);
 int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 		      u16 tid, u16 *ssn);
 void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 2377376..30724a4 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -109,6 +109,25 @@ static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
 				     series, 4, 0);
 }
 
+static void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_tx_control txctl;
+
+	memset(&txctl, 0, sizeof(struct ath_tx_control));
+	txctl.txq = sc->beacon.cabq;
+
+	ath_print(common, ATH_DBG_XMIT,
+		  "transmitting CABQ packet, skb: %p\n", skb);
+
+	if (ath_tx_start(hw, skb, &txctl) != 0) {
+		ath_print(common, ATH_DBG_XMIT, "CABQ TX failed\n");
+		dev_kfree_skb_any(skb);
+	}
+}
+
 static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 					   struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 611797a..8464ca3 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1195,12 +1195,10 @@ mutex_unlock:
 static int ath9k_tx(struct ieee80211_hw *hw,
 		    struct sk_buff *skb)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_tx_control txctl;
-	int padpos, padsize;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 
 	if (aphy->state != ATH_WIPHY_ACTIVE && aphy->state != ATH_WIPHY_SCAN) {
@@ -1251,29 +1249,6 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 	}
 
 	memset(&txctl, 0, sizeof(struct ath_tx_control));
-
-	/*
-	 * As a temporary workaround, assign seq# here; this will likely need
-	 * to be cleaned up to work better with Beacon transmission and virtual
-	 * BSSes.
-	 */
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
-		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
-			sc->tx.seq_no += 0x10;
-		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
-		hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
-	}
-
-	/* Add the padding after the header if this is not already done */
-	padpos = ath9k_cmn_padpos(hdr->frame_control);
-	padsize = padpos & 3;
-	if (padsize && skb->len>padpos) {
-		if (skb_headroom(skb) < padsize)
-			return -1;
-		skb_push(skb, padsize);
-		memmove(skb->data, skb->data + padsize, padpos);
-	}
-
 	txctl.txq = sc->tx.txq_map[skb_get_queue_mapping(skb)];
 
 	ath_print(common, ATH_DBG_XMIT, "transmitting packet, skb: %p\n", skb);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index c35033f..f3f0d1c 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1742,41 +1742,14 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		 struct ath_tx_control *txctl)
 {
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	struct ath_txq *txq = txctl->txq;
 	struct ath_buf *bf;
-	int q;
-
-	bf = ath_tx_setup_buffer(hw, skb);
-	if (unlikely(!bf))
-		return -ENOMEM;
-
-	q = skb_get_queue_mapping(skb);
-	spin_lock_bh(&txq->axq_lock);
-	if (txq == sc->tx.txq_map[q] &&
-	    ++txq->pending_frames > ATH_MAX_QDEPTH && !txq->stopped) {
-		ath_mac80211_stop_queue(sc, q);
-		txq->stopped = 1;
-	}
-	spin_unlock_bh(&txq->axq_lock);
-
-	ath_tx_start_dma(sc, bf, txctl);
-
-	return 0;
-}
-
-void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
-{
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	int padpos, padsize;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ath_tx_control txctl;
-
-	memset(&txctl, 0, sizeof(struct ath_tx_control));
+	int q;
 
 	/*
 	 * As a temporary workaround, assign seq# here; this will likely need
@@ -1793,30 +1766,30 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
 	/* Add the padding after the header if this is not already done */
 	padpos = ath9k_cmn_padpos(hdr->frame_control);
 	padsize = padpos & 3;
-	if (padsize && skb->len>padpos) {
-		if (skb_headroom(skb) < padsize) {
-			ath_print(common, ATH_DBG_XMIT,
-				  "TX CABQ padding failed\n");
-			dev_kfree_skb_any(skb);
-			return;
-		}
+	if (padsize && skb->len > padpos) {
+		if (skb_headroom(skb) < padsize)
+			return -ENOMEM;
+
 		skb_push(skb, padsize);
 		memmove(skb->data, skb->data + padsize, padpos);
 	}
 
-	txctl.txq = sc->beacon.cabq;
-
-	ath_print(common, ATH_DBG_XMIT,
-		  "transmitting CABQ packet, skb: %p\n", skb);
+	bf = ath_tx_setup_buffer(hw, skb);
+	if (unlikely(!bf))
+		return -ENOMEM;
 
-	if (ath_tx_start(hw, skb, &txctl) != 0) {
-		ath_print(common, ATH_DBG_XMIT, "CABQ TX failed\n");
-		goto exit;
+	q = skb_get_queue_mapping(skb);
+	spin_lock_bh(&txq->axq_lock);
+	if (txq == sc->tx.txq_map[q] &&
+	    ++txq->pending_frames > ATH_MAX_QDEPTH && !txq->stopped) {
+		ath_mac80211_stop_queue(sc, q);
+		txq->stopped = 1;
 	}
+	spin_unlock_bh(&txq->axq_lock);
 
-	return;
-exit:
-	dev_kfree_skb_any(skb);
+	ath_tx_start_dma(sc, bf, txctl);
+
+	return 0;
 }
 
 /*****************/
-- 
1.7.3.2

