Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:60956 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936314Ab0B0WFh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 17:05:37 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: jirislaby@gmail.com, mickflemm@gmail.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH] ath5k: Fix TX/RX padding for all frames
Date: Sat, 27 Feb 2010 23:05:26 +0100
Message-Id: <1267308326-25159-1-git-send-email-benoit.papillault@free.fr>
In-Reply-To: <4B898773.1060202@free.fr>
References: <4B898773.1060202@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, the padding position is based on
ieee80211_get_hdrlen_from_skb(). This is not correct since the HW does
padding on RX (and expect the same padding to be present on TX) at the
following position :

- management : 24 + 6 if 4-addr format
- control    : 24 + 6 if 4-addr format
- data       : 24 + 6 if 4-addr format + 2 if QoS
- invalid    : 24 + 6 if 4-addr format

whereas ieee80211_get_hdrlen_from_skb() is :

- management : 24
- control    : 16 except for ACK/CTS where it is 10
- data       : 24 + 6 if 4-addr format + 2 if QoS + 2 if QoS & order
- invalid    : 24

So, correct frames are not affected : management frames do not use
4-addr format, control frames have no body and invalid frames are ...
not valid by definition. However, in order to use monitor interface for
debugging purpose, one must be able to send/receive any frames, be it
correct or not. Such frames are affected by incorrect padding.

Moreover, since padding is added on TX, we need to remove it before
calling ieee80211_tx_status. This affect TX packets received by monitor
interfaces.

It has been tested between an ath5k based card (AR5212) and an ar9170usb
based card (netgear WNDA3100) using a frame generator and a monitor
interface for each card.

v2: Added ath5k_add_padding / ath5k_remove_padding

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    9 +--
 drivers/net/wireless/ath/ath5k/base.c  |  105 ++++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath5k/desc.c  |   10 ++-
 3 files changed, 88 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index ac67f02..23543d4 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1141,9 +1141,9 @@ struct ath5k_hw {
 	int (*ah_setup_rx_desc)(struct ath5k_hw *ah, struct ath5k_desc *desc,
 				u32 size, unsigned int flags);
 	int (*ah_setup_tx_desc)(struct ath5k_hw *, struct ath5k_desc *,
-		unsigned int, unsigned int, enum ath5k_pkt_type, unsigned int,
+		unsigned int, unsigned int, int, enum ath5k_pkt_type,
 		unsigned int, unsigned int, unsigned int, unsigned int,
-		unsigned int, unsigned int, unsigned int);
+		unsigned int, unsigned int, unsigned int, unsigned int);
 	int (*ah_setup_mrr_tx_desc)(struct ath5k_hw *, struct ath5k_desc *,
 		unsigned int, unsigned int, unsigned int, unsigned int,
 		unsigned int, unsigned int);
@@ -1370,9 +1370,4 @@ static inline u32 ath5k_hw_bitswap(u32 val, unsigned int bits)
 	return retval;
 }
 
-static inline int ath5k_pad_size(int hdrlen)
-{
-	return (hdrlen < 24) ? 0 : hdrlen & 3;
-}
-
 #endif
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 421ef33..46e5e6e 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -307,7 +307,7 @@ static int 	ath5k_rxbuf_setup(struct ath5k_softc *sc,
 				struct ath5k_buf *bf);
 static int 	ath5k_txbuf_setup(struct ath5k_softc *sc,
 				struct ath5k_buf *bf,
-				struct ath5k_txq *txq);
+				struct ath5k_txq *txq, int padsize);
 static inline void ath5k_txbuf_free(struct ath5k_softc *sc,
 				struct ath5k_buf *bf)
 {
@@ -1272,7 +1272,7 @@ static enum ath5k_pkt_type get_hw_packet_type(struct sk_buff *skb)
 
 static int
 ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
-		  struct ath5k_txq *txq)
+		  struct ath5k_txq *txq, int padsize)
 {
 	struct ath5k_hw *ah = sc->ah;
 	struct ath5k_desc *ds = bf->desc;
@@ -1324,7 +1324,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 			sc->vif, pktlen, info));
 	}
 	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
-		ieee80211_get_hdrlen_from_skb(skb),
+		ieee80211_get_hdrlen_from_skb(skb), padsize,
 		get_hw_packet_type(skb),
 		(sc->power_level * 2),
 		hw_rate,
@@ -1806,6 +1806,67 @@ ath5k_check_ibss_tsf(struct ath5k_softc *sc, struct sk_buff *skb,
 	}
 }
 
+/*
+ * Compute padding position. skb must contains an IEEE 802.11 frame
+ */
+static int ath5k_common_padpos(struct sk_buff *skb)
+{
+	struct ieee80211_hdr * hdr = (struct ieee80211_hdr *)skb->data;
+	__le16 frame_control = hdr->frame_control;
+	int padpos = 24;
+
+	if (ieee80211_has_a4(frame_control)) {
+		padpos += ETH_ALEN;
+	}
+	if (ieee80211_is_data_qos(frame_control)) {
+		padpos += IEEE80211_QOS_CTL_LEN;
+	}
+
+	return padpos;
+}
+
+/*
+ * This function expects a 802.11 frame and returns the number of
+ * bytes added, or -1 if we don't have enought header room.
+ */
+
+static int ath5k_add_padding(struct sk_buff *skb)
+{
+	int padpos = ath5k_common_padpos(skb);
+	int padsize = padpos & 3;
+
+	if (padsize && skb->len>padpos) {
+		
+		if (skb_headroom(skb) < padsize)
+			return -1;
+
+		skb_push(skb, padsize);
+		memmove(skb->data, skb->data+padsize, padpos);
+		return padsize;
+	}
+
+	return 0;
+}
+
+/*
+ * This function expects a 802.11 frame and returns the number of
+ * bytes removed
+ */
+
+static int ath5k_remove_padding(struct sk_buff *skb)
+{
+	int padpos = ath5k_common_padpos(skb);
+	int padsize = padpos & 3;
+
+	if (padsize && skb->len>=padpos+padsize) {
+		memmove(skb->data + padsize, skb->data, padpos);
+		skb_pull(skb, padsize);
+		return padsize;
+	}
+
+	return 0;
+}
+
 static void
 ath5k_tasklet_rx(unsigned long data)
 {
@@ -1819,8 +1880,6 @@ ath5k_tasklet_rx(unsigned long data)
 	struct ath5k_buf *bf;
 	struct ath5k_desc *ds;
 	int ret;
-	int hdrlen;
-	int padsize;
 	int rx_flag;
 
 	spin_lock(&sc->rxbuflock);
@@ -1905,12 +1964,8 @@ accept:
 		 * bytes and we can optimize this a bit. In addition, we must
 		 * not try to remove padding from short control frames that do
 		 * not have payload. */
-		hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-		padsize = ath5k_pad_size(hdrlen);
-		if (padsize) {
-			memmove(skb->data + padsize, skb->data, hdrlen);
-			skb_pull(skb, padsize);
-		}
+		ath5k_remove_padding(skb);
+
 		rxs = IEEE80211_SKB_RXCB(skb);
 
 		/*
@@ -2030,6 +2085,12 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 			info->status.ack_signal = ts.ts_rssi;
 		}
 
+		/*
+		 * Remove MAC header padding before giving the frame
+		 * back to mac80211.
+		 */
+		ath5k_remove_padding(skb);
+
 		ieee80211_tx_status(sc->hw, skb);
 
 		spin_lock(&sc->txbuflock);
@@ -2073,6 +2134,7 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	int ret = 0;
 	u8 antenna;
 	u32 flags;
+	const int padsize = 0;
 
 	bf->skbaddr = pci_map_single(sc->pdev, skb->data, skb->len,
 			PCI_DMA_TODEVICE);
@@ -2120,7 +2182,7 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	 * from tx power (value is in dB units already) */
 	ds->ds_data = bf->skbaddr;
 	ret = ah->ah_setup_tx_desc(ah, ds, skb->len,
-			ieee80211_get_hdrlen_from_skb(skb),
+			ieee80211_get_hdrlen_from_skb(skb), padsize,
 			AR5K_PKT_TYPE_BEACON, (sc->power_level * 2),
 			ieee80211_get_tx_rate(sc->hw, info)->hw_value,
 			1, AR5K_TXKEYIX_INVALID,
@@ -2680,7 +2742,6 @@ static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_buf *bf;
 	unsigned long flags;
-	int hdrlen;
 	int padsize;
 
 	ath5k_debug_dump_skb(sc, skb, "TX  ", 1);
@@ -2692,17 +2753,11 @@ static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * the hardware expects the header padded to 4 byte boundaries
 	 * if this is not the case we add the padding after the header
 	 */
-	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	padsize = ath5k_pad_size(hdrlen);
-	if (padsize) {
-
-		if (skb_headroom(skb) < padsize) {
-			ATH5K_ERR(sc, "tx hdrlen not %%4: %d not enough"
-				  " headroom to pad %d\n", hdrlen, padsize);
-			goto drop_packet;
-		}
-		skb_push(skb, padsize);
-		memmove(skb->data, skb->data+padsize, hdrlen);
+	padsize = ath5k_add_padding(skb);
+	if (padsize < 0) {
+		ATH5K_ERR(sc, "tx hdrlen not %%4: not enough"
+			  " headroom to pad");
+		goto drop_packet;
 	}
 
 	spin_lock_irqsave(&sc->txbuflock, flags);
@@ -2721,7 +2776,7 @@ static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 	bf->skb = skb;
 
-	if (ath5k_txbuf_setup(sc, bf, txq)) {
+	if (ath5k_txbuf_setup(sc, bf, txq, padsize)) {
 		bf->skb = NULL;
 		spin_lock_irqsave(&sc->txbuflock, flags);
 		list_add_tail(&bf->list, &sc->txbuf);
diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
index dc30a2b..d26126b 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -35,7 +35,8 @@
  */
 static int
 ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
-	unsigned int pkt_len, unsigned int hdr_len, enum ath5k_pkt_type type,
+	unsigned int pkt_len, unsigned int hdr_len, int padsize,
+	enum ath5k_pkt_type type,
 	unsigned int tx_power, unsigned int tx_rate0, unsigned int tx_tries0,
 	unsigned int key_index, unsigned int antenna_mode, unsigned int flags,
 	unsigned int rtscts_rate, unsigned int rtscts_duration)
@@ -71,7 +72,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	/* Verify and set frame length */
 
 	/* remove padding we might have added before */
-	frame_len = pkt_len - ath5k_pad_size(hdr_len) + FCS_LEN;
+	frame_len = pkt_len - padsize + FCS_LEN;
 
 	if (frame_len & ~AR5K_2W_TX_DESC_CTL0_FRAME_LEN)
 		return -EINVAL;
@@ -100,7 +101,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 			AR5K_REG_SM(hdr_len, AR5K_2W_TX_DESC_CTL0_HEADER_LEN);
 	}
 
-	/*Diferences between 5210-5211*/
+	/*Differences between 5210-5211*/
 	if (ah->ah_version == AR5K_AR5210) {
 		switch (type) {
 		case AR5K_PKT_TYPE_BEACON:
@@ -165,6 +166,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
  */
 static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 	struct ath5k_desc *desc, unsigned int pkt_len, unsigned int hdr_len,
+	int padsize,
 	enum ath5k_pkt_type type, unsigned int tx_power, unsigned int tx_rate0,
 	unsigned int tx_tries0, unsigned int key_index,
 	unsigned int antenna_mode, unsigned int flags,
@@ -206,7 +208,7 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 	/* Verify and set frame length */
 
 	/* remove padding we might have added before */
-	frame_len = pkt_len - ath5k_pad_size(hdr_len) + FCS_LEN;
+	frame_len = pkt_len - padsize + FCS_LEN;
 
 	if (frame_len & ~AR5K_4W_TX_DESC_CTL0_FRAME_LEN)
 		return -EINVAL;
-- 
1.5.6.5

