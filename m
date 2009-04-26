Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:53985 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbZDZONX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Apr 2009 10:13:23 -0400
Received: by ewy24 with SMTP id 24so1732510ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 26 Apr 2009 07:13:22 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/5] rt2x00: Add support for L2 padding during TX/RX
Date: Sun, 26 Apr 2009 16:08:50 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
References: <200904261608.30384.IvDoorn@gmail.com>
In-Reply-To: <200904261608.30384.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200904261608.50411.IvDoorn@gmail.com> (sfid-20090426_161333_907661_C2DE2380)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some hardware require L2 padding between header and payload
because both must be aligned to a 4-byte boundary. This hardware
also is easier during the RX path since we no longer need to
move the entire payload but rather only the header to remove
the padding (mac80211 only wants the payload to be 4-byte aligned).

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h       |   10 ++++
 drivers/net/wireless/rt2x00/rt2x00crypto.c |   68 +++++++++++++++++-----------
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   33 +++++++------
 drivers/net/wireless/rt2x00/rt2x00lib.h    |   27 +++++++++--
 drivers/net/wireless/rt2x00/rt2x00queue.c  |   39 ++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00queue.h  |   14 +++++-
 6 files changed, 143 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index e03d699..676fb7d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -103,6 +103,15 @@
 #define GET_DURATION_RES(__size, __rate)(((__size) * 8 * 10) % (__rate))
 
 /*
+ * Determine the alignment requirement,
+ * to make sure the 802.11 payload is padded to a 4-byte boundrary
+ * we must determine the address of the payload and calculate the
+ * amount of bytes needed to move the data.
+ */
+#define ALIGN_SIZE(__skb, __header) \
+	(  ((unsigned long)((__skb)->data + (__header))) & 3 )
+
+/*
  * Standard timing and size defines.
  * These values should follow the ieee80211 specifications.
  */
@@ -590,6 +599,7 @@ enum rt2x00_flags {
 	DRIVER_REQUIRE_SCHEDULED,
 	DRIVER_REQUIRE_DMA,
 	DRIVER_REQUIRE_COPY_IV,
+	DRIVER_REQUIRE_L2PAD,
 
 	/*
 	 * Driver features
diff --git a/drivers/net/wireless/rt2x00/rt2x00crypto.c b/drivers/net/wireless/rt2x00/rt2x00crypto.c
index ae31581..57ab42c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00crypto.c
+++ b/drivers/net/wireless/rt2x00/rt2x00crypto.c
@@ -65,7 +65,7 @@ void rt2x00crypto_create_tx_descriptor(struct queue_entry *entry,
 		__set_bit(ENTRY_TXD_ENCRYPT_PAIRWISE, &txdesc->flags);
 
 	txdesc->key_idx = hw_key->hw_key_idx;
-	txdesc->iv_offset = ieee80211_get_hdrlen_from_skb(entry->skb);
+	txdesc->iv_offset = txdesc->header_length;
 	txdesc->iv_len = hw_key->iv_len;
 
 	if (!(hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV))
@@ -132,17 +132,16 @@ void rt2x00crypto_tx_remove_iv(struct sk_buff *skb, struct txentry_desc *txdesc)
 	skb_pull(skb, txdesc->iv_len);
 
 	/* IV/EIV data has officially be stripped */
-	skbdesc->flags |= FRAME_DESC_IV_STRIPPED;
+	skbdesc->flags |= SKBDESC_IV_STRIPPED;
 }
 
-void rt2x00crypto_tx_insert_iv(struct sk_buff *skb)
+void rt2x00crypto_tx_insert_iv(struct sk_buff *skb, unsigned int header_length)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	unsigned int header_length = ieee80211_get_hdrlen_from_skb(skb);
 	const unsigned int iv_len =
 	    ((!!(skbdesc->iv[0])) * 4) + ((!!(skbdesc->iv[1])) * 4);
 
-	if (!(skbdesc->flags & FRAME_DESC_IV_STRIPPED))
+	if (!(skbdesc->flags & SKBDESC_IV_STRIPPED))
 		return;
 
 	skb_push(skb, iv_len);
@@ -154,14 +153,15 @@ void rt2x00crypto_tx_insert_iv(struct sk_buff *skb)
 	memcpy(skb->data + header_length, skbdesc->iv, iv_len);
 
 	/* IV/EIV data has returned into the frame */
-	skbdesc->flags &= ~FRAME_DESC_IV_STRIPPED;
+	skbdesc->flags &= ~SKBDESC_IV_STRIPPED;
 }
 
-void rt2x00crypto_rx_insert_iv(struct sk_buff *skb, unsigned int align,
+void rt2x00crypto_rx_insert_iv(struct sk_buff *skb, bool l2pad,
 			       unsigned int header_length,
 			       struct rxdone_entry_desc *rxdesc)
 {
 	unsigned int payload_len = rxdesc->size - header_length;
+	unsigned int align = ALIGN_SIZE(skb, header_length);
 	unsigned int iv_len;
 	unsigned int icv_len;
 	unsigned int transfer = 0;
@@ -191,32 +191,48 @@ void rt2x00crypto_rx_insert_iv(struct sk_buff *skb, unsigned int align,
 	}
 
 	/*
-	 * Make room for new data, note that we increase both
-	 * headsize and tailsize when required. The tailsize is
-	 * only needed when ICV data needs to be inserted and
-	 * the padding is smaller than the ICV data.
-	 * When alignment requirements is greater than the
-	 * ICV data we must trim the skb to the correct size
-	 * because we need to remove the extra bytes.
+	 * Make room for new data. There are 2 possibilities
+	 * either the alignment is already present between
+	 * the 802.11 header and payload. In that case we
+	 * we have to move the header less then the iv_len
+	 * since we can use the already available l2pad bytes
+	 * for the iv data.
+	 * When the alignment must be added manually we must
+	 * move the header more then iv_len since we must
+	 * make room for the payload move as well.
 	 */
-	skb_push(skb, iv_len + align);
-	if (align < icv_len)
-		skb_put(skb, icv_len - align);
-	else if (align > icv_len)
-		skb_trim(skb, rxdesc->size + iv_len + icv_len);
+	if (l2pad) {
+		skb_push(skb, iv_len - align);
+		skb_put(skb, icv_len);
 
-	/* Move ieee80211 header */
-	memmove(skb->data + transfer,
-		skb->data + transfer + iv_len + align,
-		header_length);
-	transfer += header_length;
+		/* Move ieee80211 header */
+		memmove(skb->data + transfer,
+			skb->data + transfer + (iv_len - align),
+			header_length);
+		transfer += header_length;
+	} else {
+		skb_push(skb, iv_len + align);
+		if (align < icv_len)
+			skb_put(skb, icv_len - align);
+		else if (align > icv_len)
+			skb_trim(skb, rxdesc->size + iv_len + icv_len);
+
+		/* Move ieee80211 header */
+		memmove(skb->data + transfer,
+			skb->data + transfer + iv_len + align,
+			header_length);
+		transfer += header_length;
+	}
 
 	/* Copy IV/EIV data */
 	memcpy(skb->data + transfer, rxdesc->iv, iv_len);
 	transfer += iv_len;
 
-	/* Move payload */
-	if (align) {
+	/*
+	 * Move payload for alignment purposes. Note that
+	 * this is only needed when no l2 padding is present.
+	 */
+	if (!l2pad) {
 		memmove(skb->data + transfer,
 			skb->data + transfer + align,
 			payload_len);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 5752aaa..e15086a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -227,6 +227,7 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	enum data_queue_qid qid = skb_get_queue_mapping(entry->skb);
+	unsigned int header_length = ieee80211_get_hdrlen_from_skb(entry->skb);
 	u8 rate_idx, rate_flags;
 
 	/*
@@ -235,13 +236,19 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	rt2x00queue_unmap_skb(rt2x00dev, entry->skb);
 
 	/*
+	 * Remove L2 padding which was added during
+	 */
+	if (test_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags))
+		rt2x00queue_payload_align(entry->skb, true, header_length);
+
+	/*
 	 * If the IV/EIV data was stripped from the frame before it was
 	 * passed to the hardware, we should now reinsert it again because
 	 * mac80211 will expect the the same data to be present it the
 	 * frame as it was passed to us.
 	 */
 	if (test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags))
-		rt2x00crypto_tx_insert_iv(entry->skb);
+		rt2x00crypto_tx_insert_iv(entry->skb, header_length);
 
 	/*
 	 * Send frame to debugfs immediately, after this call is completed
@@ -325,7 +332,7 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 	struct ieee80211_supported_band *sband;
 	const struct rt2x00_rate *rate;
 	unsigned int header_length;
-	unsigned int align;
+	bool l2pad;
 	unsigned int i;
 	int idx = -1;
 
@@ -348,12 +355,15 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 	memset(&rxdesc, 0, sizeof(rxdesc));
 	rt2x00dev->ops->lib->fill_rxdone(entry, &rxdesc);
 
+	/* Trim buffer to correct size */
+	skb_trim(entry->skb, rxdesc.size);
+
 	/*
 	 * The data behind the ieee80211 header must be
 	 * aligned on a 4 byte boundary.
 	 */
 	header_length = ieee80211_get_hdrlen_from_skb(entry->skb);
-	align = ((unsigned long)(entry->skb->data + header_length)) & 3;
+	l2pad = !!(rxdesc.dev_flags & RXDONE_L2PAD);
 
 	/*
 	 * Hardware might have stripped the IV/EIV/ICV data,
@@ -362,18 +372,11 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 	 * in which case we should reinsert the data into the frame.
 	 */
 	if ((rxdesc.dev_flags & RXDONE_CRYPTO_IV) &&
-	    (rxdesc.flags & RX_FLAG_IV_STRIPPED)) {
-		rt2x00crypto_rx_insert_iv(entry->skb, align,
-					  header_length, &rxdesc);
-	} else if (align) {
-		skb_push(entry->skb, align);
-		/* Move entire frame in 1 command */
-		memmove(entry->skb->data, entry->skb->data + align,
-			rxdesc.size);
-	}
-
-	/* Update data pointers, trim buffer to correct size */
-	skb_trim(entry->skb, rxdesc.size);
+	    (rxdesc.flags & RX_FLAG_IV_STRIPPED))
+		rt2x00crypto_rx_insert_iv(entry->skb, l2pad, header_length,
+					  &rxdesc);
+	else
+		rt2x00queue_payload_align(entry->skb, l2pad, header_length);
 
 	/*
 	 * Update RX statistics.
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index af3c47b..aa284e4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -113,6 +113,23 @@ void rt2x00queue_unmap_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
 void rt2x00queue_free_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
 
 /**
+ * rt2x00queue_payload_align - Align 802.11 payload to 4-byte boundary
+ * @skb: The skb to align
+ * @l2pad: Should L2 padding be used
+ * @header_length: Length of 802.11 header
+ *
+ * This function prepares the @skb to be send to the device or mac80211.
+ * If @l2pad is set to true padding will occur between the 802.11 header
+ * and payload. Otherwise the padding will be done in front of the 802.11
+ * header.
+ * When @l2pad is set the function will check for the &SKBDESC_L2_PADDED
+ * flag in &skb_frame_desc. If that flag is set, the padding is removed
+ * and the flag cleared. Otherwise the padding is added and the flag is set.
+ */
+void rt2x00queue_payload_align(struct sk_buff *skb,
+			       bool l2pad, unsigned int header_length);
+
+/**
  * rt2x00queue_write_tx_frame - Write TX frame to hardware
  * @queue: Queue over which the frame should be send
  * @skb: The skb to send
@@ -299,8 +316,8 @@ void rt2x00crypto_tx_copy_iv(struct sk_buff *skb,
 			     struct txentry_desc *txdesc);
 void rt2x00crypto_tx_remove_iv(struct sk_buff *skb,
 			       struct txentry_desc *txdesc);
-void rt2x00crypto_tx_insert_iv(struct sk_buff *skb);
-void rt2x00crypto_rx_insert_iv(struct sk_buff *skb, unsigned int align,
+void rt2x00crypto_tx_insert_iv(struct sk_buff *skb, unsigned int header_length);
+void rt2x00crypto_rx_insert_iv(struct sk_buff *skb, bool l2pad,
 			       unsigned int header_length,
 			       struct rxdone_entry_desc *rxdesc);
 #else
@@ -330,12 +347,12 @@ static inline void rt2x00crypto_tx_remove_iv(struct sk_buff *skb,
 {
 }
 
-static inline void rt2x00crypto_tx_insert_iv(struct sk_buff *skb)
+static inline void rt2x00crypto_tx_insert_iv(struct sk_buff *skb,
+					     unsigned int header_length)
 {
 }
 
-static inline void rt2x00crypto_rx_insert_iv(struct sk_buff *skb,
-					     unsigned int align,
+static inline void rt2x00crypto_rx_insert_iv(struct sk_buff *skb, bool l2pad,
 					     unsigned int header_length,
 					     struct rxdone_entry_desc *rxdesc)
 {
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 6f78915..bc1742c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -148,6 +148,35 @@ void rt2x00queue_free_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 	dev_kfree_skb_any(skb);
 }
 
+void rt2x00queue_payload_align(struct sk_buff *skb,
+			       bool l2pad, unsigned int header_length)
+{
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
+	unsigned int frame_length = skb->len;
+	unsigned int align = ALIGN_SIZE(skb, header_length);
+
+	if (!align)
+		return;
+
+	if (l2pad) {
+		if (skbdesc->flags & SKBDESC_L2_PADDED) {
+			/* Remove L2 padding */
+			memmove(skb->data + align, skb->data, header_length);
+			skb_pull(skb, align);
+			skbdesc->flags &= ~SKBDESC_L2_PADDED;
+		} else {
+			/* Add L2 padding */
+			skb_push(skb, align);
+			memmove(skb->data, skb->data + align, header_length);
+			skbdesc->flags |= SKBDESC_L2_PADDED;
+		}
+	} else {
+		/* Generic payload alignment to 4-byte boundary */
+		skb_push(skb, align);
+		memmove(skb->data, skb->data + align, frame_length);
+	}
+}
+
 static void rt2x00queue_create_tx_descriptor_seq(struct queue_entry *entry,
 						 struct txentry_desc *txdesc)
 {
@@ -259,6 +288,12 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	txdesc->aifs = entry->queue->aifs;
 
 	/*
+	 * Header and alignment information.
+	 */
+	txdesc->header_length = ieee80211_get_hdrlen_from_skb(entry->skb);
+	txdesc->l2pad = ALIGN_SIZE(entry->skb, txdesc->header_length);
+
+	/*
 	 * Check whether this frame is to be acked.
 	 */
 	if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK))
@@ -416,6 +451,10 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb)
 			rt2x00crypto_tx_remove_iv(skb, &txdesc);
 	}
 
+	if (test_bit(DRIVER_REQUIRE_L2PAD, &queue->rt2x00dev->flags))
+		rt2x00queue_payload_align(entry->skb, true,
+					  txdesc.header_length);
+
 	/*
 	 * It could be possible that the queue was corrupted and this
 	 * call failed. Since we always return NETDEV_TX_OK to mac80211,
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index e3bfd73..13e0ece 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -87,13 +87,16 @@ enum data_queue_qid {
  *
  * @SKBDESC_DMA_MAPPED_RX: &skb_dma field has been mapped for RX
  * @SKBDESC_DMA_MAPPED_TX: &skb_dma field has been mapped for TX
- * @FRAME_DESC_IV_STRIPPED: Frame contained a IV/EIV provided by
+ * @SKBDESC_IV_STRIPPED: Frame contained a IV/EIV provided by
  *	mac80211 but was stripped for processing by the driver.
+ * @SKBDESC_L2_PADDED: Payload has been padded for 4-byte alignment,
+ *	the padded bytes are located between header and payload.
  */
 enum skb_frame_desc_flags {
 	SKBDESC_DMA_MAPPED_RX = 1 << 0,
 	SKBDESC_DMA_MAPPED_TX = 1 << 1,
-	FRAME_DESC_IV_STRIPPED = 1 << 2,
+	SKBDESC_IV_STRIPPED = 1 << 2,
+	SKBDESC_L2_PADDED = 1 << 3
 };
 
 /**
@@ -148,6 +151,7 @@ static inline struct skb_frame_desc* get_skb_frame_desc(struct sk_buff *skb)
  * @RXDONE_MY_BSS: Does this frame originate from device's BSS.
  * @RXDONE_CRYPTO_IV: Driver provided IV/EIV data.
  * @RXDONE_CRYPTO_ICV: Driver provided ICV data.
+ * @RXDONE_L2PAD: 802.11 payload has been padded to 4-byte boundary.
  */
 enum rxdone_entry_desc_flags {
 	RXDONE_SIGNAL_PLCP = 1 << 0,
@@ -155,6 +159,7 @@ enum rxdone_entry_desc_flags {
 	RXDONE_MY_BSS = 1 << 2,
 	RXDONE_CRYPTO_IV = 1 << 3,
 	RXDONE_CRYPTO_ICV = 1 << 4,
+	RXDONE_L2PAD = 1 << 5,
 };
 
 /**
@@ -267,6 +272,8 @@ enum txentry_desc_flags {
  *
  * @flags: Descriptor flags (See &enum queue_entry_flags).
  * @queue: Queue identification (See &enum data_queue_qid).
+ * @header_length: Length of 802.11 header.
+ * @l2pad: Amount of padding to align 802.11 payload to 4-byte boundrary.
  * @length_high: PLCP length high word.
  * @length_low: PLCP length low word.
  * @signal: PLCP signal.
@@ -287,6 +294,9 @@ struct txentry_desc {
 
 	enum data_queue_qid queue;
 
+	u16 header_length;
+	u16 l2pad;
+
 	u16 length_high;
 	u16 length_low;
 	u16 signal;
-- 
1.6.2.3

