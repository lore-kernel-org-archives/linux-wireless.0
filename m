Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58784 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934403Ab3DGWEY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Apr 2013 18:04:24 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3/7] ath9k_common: remove ath9k_cmn_padpos
Date: Mon,  8 Apr 2013 00:04:09 +0200
Message-Id: <1365372253-32782-3-git-send-email-nbd@openwrt.org> (sfid-20130408_000427_862981_54C48A69)
In-Reply-To: <1365372253-32782-2-git-send-email-nbd@openwrt.org>
References: <1365372253-32782-1-git-send-email-nbd@openwrt.org>
 <1365372253-32782-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is equivalent to ieee80211_hdrlen

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/common.c         | 14 --------------
 drivers/net/wireless/ath/ath9k/common.h         |  1 -
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |  2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |  2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   | 10 ++++------
 drivers/net/wireless/ath/ath9k/recv.c           |  2 +-
 drivers/net/wireless/ath/ath9k/xmit.c           |  4 ++--
 7 files changed, 9 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 905f1b3..27f1eaf 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -27,20 +27,6 @@ MODULE_AUTHOR("Atheros Communications");
 MODULE_DESCRIPTION("Shared library for Atheros wireless 802.11n LAN cards.");
 MODULE_LICENSE("Dual BSD/GPL");
 
-int ath9k_cmn_padpos(__le16 frame_control)
-{
-	int padpos = 24;
-	if (ieee80211_has_a4(frame_control)) {
-		padpos += ETH_ALEN;
-	}
-	if (ieee80211_is_data_qos(frame_control)) {
-		padpos += IEEE80211_QOS_CTL_LEN;
-	}
-
-	return padpos;
-}
-EXPORT_SYMBOL(ath9k_cmn_padpos);
-
 int ath9k_cmn_get_hw_crypto_keytype(struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 6102476..207d069 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -42,7 +42,6 @@
 #define ATH_EP_RND(x, mul) 						\
 	(((x) + ((mul)/2)) / (mul))
 
-int ath9k_cmn_padpos(__le16 frame_control);
 int ath9k_cmn_get_hw_crypto_keytype(struct sk_buff *skb);
 void ath9k_cmn_update_ichannel(struct ath9k_channel *ichan,
 			       struct ieee80211_channel *chan,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index d0ce1f5..f13f458 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -308,7 +308,7 @@ static void ath9k_htc_send_buffered(struct ath9k_htc_priv *priv,
 	while(skb) {
 		hdr = (struct ieee80211_hdr *) skb->data;
 
-		padpos = ath9k_cmn_padpos(hdr->frame_control);
+		padpos = ieee80211_hdrlen(hdr->frame_control);
 		padsize = padpos & 3;
 		if (padsize && skb->len > padpos) {
 			if (skb_headroom(skb) < padsize) {
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index a8016d7..3381939 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -866,7 +866,7 @@ static void ath9k_htc_tx(struct ieee80211_hw *hw,
 	hdr = (struct ieee80211_hdr *) skb->data;
 
 	/* Add the padding after the header if this is not already done */
-	padpos = ath9k_cmn_padpos(hdr->frame_control);
+	padpos = ieee80211_hdrlen(hdr->frame_control);
 	padsize = padpos & 3;
 	if (padsize && skb->len > padpos) {
 		if (skb_headroom(skb) < padsize) {
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index bd8251c..5c33a46 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -966,7 +966,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	struct sk_buff *skb = rxbuf->skb;
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ath_htc_rx_status *rxstatus;
-	int hdrlen, padpos, padsize;
+	int hdrlen, padsize;
 	int last_rssi = ATH_RSSI_DUMMY_MARKER;
 	__le16 fc;
 
@@ -996,11 +996,9 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	fc = hdr->frame_control;
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 
-	padpos = ath9k_cmn_padpos(fc);
-
-	padsize = padpos & 3;
-	if (padsize && skb->len >= padpos+padsize+FCS_LEN) {
-		memmove(skb->data + padsize, skb->data, padpos);
+	padsize = hdrlen & 3;
+	if (padsize && skb->len >= hdrlen+padsize+FCS_LEN) {
+		memmove(skb->data + padsize, skb->data, hdrlen);
 		skb_pull(skb, padsize);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ee156e5..a617ef9 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -981,7 +981,7 @@ static void ath9k_rx_skb_postprocess(struct ath_common *common,
 	hdr = (struct ieee80211_hdr *) skb->data;
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 	fc = hdr->frame_control;
-	padpos = ath9k_cmn_padpos(hdr->frame_control);
+	padpos = ieee80211_hdrlen(fc);
 
 	/* The MAC header is padded to have 32-bit boundary if the
 	 * packet payload is non-zero. The general calculation for
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 89a6441..94b2ee1 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1971,7 +1971,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	}
 
 	/* Add the padding after the header if this is not already done */
-	padpos = ath9k_cmn_padpos(hdr->frame_control);
+	padpos = ieee80211_hdrlen(hdr->frame_control);
 	padsize = padpos & 3;
 	if (padsize && skb->len > padpos) {
 		if (skb_headroom(skb) < padsize)
@@ -2033,7 +2033,7 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 		/* Frame was ACKed */
 		tx_info->flags |= IEEE80211_TX_STAT_ACK;
 
-	padpos = ath9k_cmn_padpos(hdr->frame_control);
+	padpos = ieee80211_hdrlen(hdr->frame_control);
 	padsize = padpos & 3;
 	if (padsize && skb->len>padpos+padsize) {
 		/*
-- 
1.8.0.2

