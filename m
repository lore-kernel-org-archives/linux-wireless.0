Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from LNeuilly-152-21-11-6.w193-253.abo.wanadoo.fr ([193.253.42.6]:48699
	"EHLO luceor-laptop" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751595AbYLOOfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 09:35:07 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Benoit PAPILLAULT <benoit.papillault@free.fr>
Subject: [PATCH] ath5k: Updated padding stuff for the RX and TX side. TX side has been 100%
Date: Mon, 15 Dec 2008 15:34:58 +0100
Message-Id: <1229351698-21116-1-git-send-email-benoit.papillault@free.fr> (sfid-20081215_153514_690697_D25E6962)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benoit PAPILLAULT <benoit.papillault@free.fr>

This patch is close to the original code except that
ieee80211_get_hdrlen_from_skb() has been replaced by
ath5k_hw_get_hdrlen_from_skb() which is specific to Atheros hardware. The same
probably applies to ath9k as well.

Sign-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 drivers/net/wireless/ath5k/base.c |   33 ++++++++++++++++-----------------
 drivers/net/wireless/ath5k/base.h |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 9d2c597..ac17960 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1192,7 +1192,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 		pktlen += info->control.hw_key->icv_len;
 	}
 	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
-		ieee80211_get_hdrlen_from_skb(skb), AR5K_PKT_TYPE_NORMAL,
+		ath5k_hw_get_hdrlen_from_skb(skb), AR5K_PKT_TYPE_NORMAL,
 		(sc->power_level * 2),
 		ieee80211_get_tx_rate(sc->hw, info)->hw_value,
 		info->control.rates[0].count, keyidx, 0, flags, 0, 0);
@@ -1667,7 +1667,7 @@ ath5k_tasklet_rx(unsigned long data)
 	struct ath5k_desc *ds;
 	int ret;
 	int hdrlen;
-	int padsize;
+	int pad;
 
 	spin_lock(&sc->rxbuflock);
 	if (list_empty(&sc->rxbuf)) {
@@ -1760,11 +1760,11 @@ accept:
 		 * bytes and we can optimize this a bit. In addition, we must
 		 * not try to remove padding from short control frames that do
 		 * not have payload. */
-		hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-		padsize = hdrlen & 3;
-		if (padsize && hdrlen >= 24) {
-			memmove(skb->data + padsize, skb->data, hdrlen);
-			skb_pull(skb, padsize);
+		hdrlen = ath5k_hw_get_hdrlen_from_skb(skb);
+		if (hdrlen & 3) {
+			pad = hdrlen & 3;
+			memmove(skb->data + pad, skb->data, hdrlen);
+			skb_pull(skb, pad);
 		}
 
 		/*
@@ -1965,7 +1965,7 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 
 	ds->ds_data = bf->skbaddr;
 	ret = ah->ah_setup_tx_desc(ah, ds, skb->len,
-			ieee80211_get_hdrlen_from_skb(skb),
+			ath5k_hw_get_hdrlen_from_skb(skb),
 			AR5K_PKT_TYPE_BEACON, (sc->power_level * 2),
 			ieee80211_get_tx_rate(sc->hw, info)->hw_value,
 			1, AR5K_TXKEYIX_INVALID,
@@ -2625,7 +2625,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct ath5k_buf *bf;
 	unsigned long flags;
 	int hdrlen;
-	int padsize;
+	int pad;
 
 	ath5k_debug_dump_skb(sc, skb, "TX  ", 1);
 
@@ -2636,17 +2636,16 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * the hardware expects the header padded to 4 byte boundaries
 	 * if this is not the case we add the padding after the header
 	 */
-	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	padsize = hdrlen & 3;
-	if (padsize && hdrlen >= 24) {
-
-		if (skb_headroom(skb) < padsize) {
+	hdrlen = ath5k_hw_get_hdrlen_from_skb(skb);
+	if (hdrlen & 3) {
+		pad = hdrlen & 3;
+		if (skb_headroom(skb) < pad) {
 			ATH5K_ERR(sc, "tx hdrlen not %%4: %d not enough"
-				  " headroom to pad %d\n", hdrlen, padsize);
+				" headroom to pad %d\n", hdrlen, pad);
 			return -1;
 		}
-		skb_push(skb, padsize);
-		memmove(skb->data, skb->data+padsize, hdrlen);
+		skb_push(skb, pad);
+		memmove(skb->data, skb->data+pad, hdrlen);
 	}
 
 	spin_lock_irqsave(&sc->txbuflock, flags);
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index facc60d..85ff036 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -187,4 +187,38 @@ struct ath5k_softc {
 #define ath5k_hw_hasveol(_ah) \
 	(ath5k_hw_get_capability(_ah, AR5K_CAP_VEOL, 0, NULL) == 0)
 
+/* This formula returns the header length and is specific to Atheros hardware
+ * and differs from 802.11 standards. It has been tested using an AR5212
+ * hardware. */
+
+static inline unsigned int ath5k_hw_get_hdrlen_from_skb(
+	const struct sk_buff *skb)
+{
+	const struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	unsigned int hdrlen;
+
+	/* Since we need to read Frame Control field, we first check that the
+	 * frames contains at least 2 bytes */
+	if (unlikely(skb->len < 2))
+		return 0;
+
+	hdrlen = 24;
+
+	/* ToDS=1 FromDS=1 frames have an additionnal Address4 field */
+	if (ieee80211_has_a4(hdr->frame_control)) {
+		hdrlen += 6; /* IEEE80211_ADDR_LEN */
+	}
+	
+	/* QoS data frames have an additionnal QoS Control field */
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
+		hdrlen += IEEE80211_QOS_CTL_LEN;
+	}
+
+	/* check that skb already contains at least hdrlen bytes */
+	if (unlikely(hdrlen > skb->len))
+		return 0;
+
+	return hdrlen;
+}
+
 #endif
-- 
1.5.6.5

