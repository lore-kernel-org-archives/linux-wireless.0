Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56136 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932267Ab0KKCfN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 21:35:13 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 3/5] ath9k: remove the tx info padding byte abuse
Date: Thu, 11 Nov 2010 03:18:36 +0100
Message-Id: <1289441918-94905-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1289441918-94905-2-git-send-email-nbd@openwrt.org>
References: <1289441918-94905-1-git-send-email-nbd@openwrt.org>
 <1289441918-94905-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |    3 ++-
 drivers/net/wireless/ath/ath9k/rc.h      |    3 ---
 drivers/net/wireless/ath/ath9k/virtual.c |    5 ++---
 drivers/net/wireless/ath/ath9k/xmit.c    |   21 ++++++---------------
 4 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index b318093..5ec99eb 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -229,6 +229,7 @@ struct ath_buf_state {
 	unsigned long bfs_paprd_timestamp;
 	u32 bfs_keyix;
 	enum ath9k_key_type bfs_keytype;
+	enum ath9k_internal_frame_type bfs_ftype;
 };
 
 struct ath_buf {
@@ -712,7 +713,7 @@ void ath9k_ps_restore(struct ath_softc *sc);
 void ath9k_set_bssid_mask(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 int ath9k_wiphy_add(struct ath_softc *sc);
 int ath9k_wiphy_del(struct ath_wiphy *aphy);
-void ath9k_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb);
+void ath9k_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb, int ftype);
 int ath9k_wiphy_pause(struct ath_wiphy *aphy);
 int ath9k_wiphy_unpause(struct ath_wiphy *aphy);
 int ath9k_wiphy_select(struct ath_wiphy *aphy);
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index a96f5eb..31a004c 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -224,9 +224,6 @@ struct ath_rate_priv {
 	struct ath_rc_stats rcstats[RATE_TABLE_SIZE];
 };
 
-#define ATH_TX_INFO_FRAME_TYPE_INTERNAL	(1 << 0)
-#define ATH_TX_INFO_FRAME_TYPE_PAUSE	(1 << 1)
-
 enum ath9k_internal_frame_type {
 	ATH9K_IFT_NOT_INTERNAL,
 	ATH9K_IFT_PAUSE,
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index 4008f51..d5442c3 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -305,13 +305,12 @@ void ath9k_wiphy_chan_work(struct work_struct *work)
  * ath9k version of ieee80211_tx_status() for TX frames that are generated
  * internally in the driver.
  */
-void ath9k_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
+void ath9k_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb, int ftype)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 
-	if ((tx_info->pad[0] & ATH_TX_INFO_FRAME_TYPE_PAUSE) &&
-	    aphy->state == ATH_WIPHY_PAUSING) {
+	if (ftype == ATH9K_IFT_PAUSE && aphy->state == ATH_WIPHY_PAUSING) {
 		if (!(tx_info->flags & IEEE80211_TX_STAT_ACK)) {
 			printk(KERN_DEBUG "ath9k: %s: no ACK for pause "
 			       "frame\n", wiphy_name(hw->wiphy));
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 8785ec3..32e2267 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1580,17 +1580,6 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 	int padpos, padsize;
 	bool use_ldpc = false;
 
-	tx_info->pad[0] = 0;
-	switch (txctl->frame_type) {
-	case ATH9K_IFT_NOT_INTERNAL:
-		break;
-	case ATH9K_IFT_PAUSE:
-		tx_info->pad[0] |= ATH_TX_INFO_FRAME_TYPE_PAUSE;
-		/* fall through */
-	case ATH9K_IFT_UNPAUSE:
-		tx_info->pad[0] |= ATH_TX_INFO_FRAME_TYPE_INTERNAL;
-		break;
-	}
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 	fc = hdr->frame_control;
 
@@ -1711,6 +1700,7 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 					      tid, &bf_head);
 		}
 	} else {
+		bf->bf_state.bfs_ftype = txctl->frame_type;
 		ath_tx_send_normal(sc, txctl->txq, &bf_head);
 	}
 
@@ -1828,7 +1818,7 @@ exit:
 /*****************/
 
 static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
-			    struct ath_wiphy *aphy, int tx_flags,
+			    struct ath_wiphy *aphy, int tx_flags, int ftype,
 			    struct ath_txq *txq)
 {
 	struct ieee80211_hw *hw = sc->hw;
@@ -1872,8 +1862,8 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 					PS_WAIT_FOR_TX_ACK));
 	}
 
-	if (unlikely(tx_info->pad[0] & ATH_TX_INFO_FRAME_TYPE_INTERNAL))
-		ath9k_tx_status(hw, skb);
+	if (unlikely(ftype))
+		ath9k_tx_status(hw, skb, ftype);
 	else {
 		q = skb_get_queue_mapping(skb);
 		if (txq == sc->tx.txq_map[q]) {
@@ -1917,7 +1907,8 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 			complete(&sc->paprd_complete);
 	} else {
 		ath_debug_stat_tx(sc, bf, ts);
-		ath_tx_complete(sc, skb, bf->aphy, tx_flags, txq);
+		ath_tx_complete(sc, skb, bf->aphy, tx_flags,
+				bf->bf_state.bfs_ftype, txq);
 	}
 	/* At this point, skb (bf->bf_mpdu) is consumed...make sure we don't
 	 * accidentally reference it later.
-- 
1.7.2.2

