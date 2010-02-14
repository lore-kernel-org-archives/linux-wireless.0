Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:55637 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457Ab0BNXg2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 18:36:28 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: jirislaby@gmail.com, mickflemm@gmail.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH] ath5k: Fix TX/RX padding for all frames
Date: Mon, 15 Feb 2010 00:36:17 +0100
Message-Id: <1266190577-2423-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of computing the padding size based on the IEEE 802.11 header length,
we directly compute the padding position first and then the padding size next.
We have changed some functions to pass them the padding size directly. It has
been tested using a monitor interface in TX and RX against a different chipset
(zd1211rw to name it)

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    9 +---
 drivers/net/wireless/ath/ath5k/base.c  |   70 +++++++++++++++++++++++---------
 drivers/net/wireless/ath/ath5k/desc.c  |   10 +++--
 3 files changed, 59 insertions(+), 30 deletions(-)

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
index 421ef33..d154fb9 100644
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
@@ -1806,6 +1806,25 @@ ath5k_check_ibss_tsf(struct ath5k_softc *sc, struct sk_buff *skb,
 	}
 }
 
+/*
+ * Compute padding position. skb must contains an IEEE 802.11 frame
+ */
+static int ath5k_cmn_padpos(struct sk_buff *skb)
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
 static void
 ath5k_tasklet_rx(unsigned long data)
 {
@@ -1819,8 +1838,7 @@ ath5k_tasklet_rx(unsigned long data)
 	struct ath5k_buf *bf;
 	struct ath5k_desc *ds;
 	int ret;
-	int hdrlen;
-	int padsize;
+	int padpos, padsize;
 	int rx_flag;
 
 	spin_lock(&sc->rxbuflock);
@@ -1905,10 +1923,10 @@ accept:
 		 * bytes and we can optimize this a bit. In addition, we must
 		 * not try to remove padding from short control frames that do
 		 * not have payload. */
-		hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-		padsize = ath5k_pad_size(hdrlen);
-		if (padsize) {
-			memmove(skb->data + padsize, skb->data, hdrlen);
+		padpos = ath5k_cmn_padpos(skb);
+		padsize = padpos & 3;
+		if (padsize && skb->len>=padpos+padsize) {
+			memmove(skb->data + padsize, skb->data, padpos);
 			skb_pull(skb, padsize);
 		}
 		rxs = IEEE80211_SKB_RXCB(skb);
@@ -1983,6 +2001,7 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *info;
 	int i, ret;
+	int padpos, padsize;
 
 	spin_lock(&txq->lock);
 	list_for_each_entry_safe(bf, bf0, &txq->q, list) {
@@ -2030,6 +2049,17 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 			info->status.ack_signal = ts.ts_rssi;
 		}
 
+		/*
+		 * Remove MAC header padding before giving the frame
+		 * back to mac80211.
+		 */
+		padpos = ath5k_cmn_padpos(skb);
+		padsize = padpos & 3;
+		if (padsize && skb->len>=padpos+padsize) {
+			memmove(skb->data + padsize, skb->data, padpos);
+			skb_pull(skb, padsize);
+		}
+
 		ieee80211_tx_status(sc->hw, skb);
 
 		spin_lock(&sc->txbuflock);
@@ -2073,6 +2103,7 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	int ret = 0;
 	u8 antenna;
 	u32 flags;
+	const int padsize = 0;
 
 	bf->skbaddr = pci_map_single(sc->pdev, skb->data, skb->len,
 			PCI_DMA_TODEVICE);
@@ -2120,7 +2151,7 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	 * from tx power (value is in dB units already) */
 	ds->ds_data = bf->skbaddr;
 	ret = ah->ah_setup_tx_desc(ah, ds, skb->len,
-			ieee80211_get_hdrlen_from_skb(skb),
+			ieee80211_get_hdrlen_from_skb(skb), padsize,
 			AR5K_PKT_TYPE_BEACON, (sc->power_level * 2),
 			ieee80211_get_tx_rate(sc->hw, info)->hw_value,
 			1, AR5K_TXKEYIX_INVALID,
@@ -2680,8 +2711,7 @@ static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_buf *bf;
 	unsigned long flags;
-	int hdrlen;
-	int padsize;
+	int padpos, padsize;
 
 	ath5k_debug_dump_skb(sc, skb, "TX  ", 1);
 
@@ -2692,17 +2722,19 @@ static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * the hardware expects the header padded to 4 byte boundaries
 	 * if this is not the case we add the padding after the header
 	 */
-	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	padsize = ath5k_pad_size(hdrlen);
-	if (padsize) {
-
+	padpos = ath5k_cmn_padpos(skb);
+	padsize = padpos & 3;
+	if (padsize && skb->len>padpos) {
+		
 		if (skb_headroom(skb) < padsize) {
 			ATH5K_ERR(sc, "tx hdrlen not %%4: %d not enough"
-				  " headroom to pad %d\n", hdrlen, padsize);
+				  " headroom to pad %d\n", padpos, padsize);
 			goto drop_packet;
 		}
 		skb_push(skb, padsize);
-		memmove(skb->data, skb->data+padsize, hdrlen);
+		memmove(skb->data, skb->data+padsize, padpos);
+	} else {
+		padsize = 0;
 	}
 
 	spin_lock_irqsave(&sc->txbuflock, flags);
@@ -2721,7 +2753,7 @@ static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 
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

