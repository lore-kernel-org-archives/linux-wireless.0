Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:37603 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZH2Sar (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Aug 2009 14:30:47 -0400
Received: by ewy2 with SMTP id 2so2966009ewy.17
        for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2009 11:30:48 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Reorganize padding & L2 padding
Date: Sat, 29 Aug 2009 20:30:45 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908292030.45659.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The old function rt2x00queue_payload_align() handled
both adding and removing L2 padding and some basic
frame alignment. The entire function was being abused
because it had multiple functions and the header length
argument was somtimes used to align the header instead
of the payload.

Additionally there was a bug when inserting L2 padding
that only the payload was aligned but not the header. This
happens when the header wasn't aligned properly by mac80211,
but rt2x00lib only moves the payload.

A secondary problem was that when removing L2 padding during
TXdone or RX the skb wasn't resized to the proper size.

Split the function into seperate functions each handling
its task as it should.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00crypto.c |    6 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   10 ++--
 drivers/net/wireless/rt2x00/rt2x00lib.h    |   45 +++++++++----
 drivers/net/wireless/rt2x00/rt2x00queue.c  |   99 +++++++++++++++++++++-------
 4 files changed, 116 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00crypto.c b/drivers/net/wireless/rt2x00/rt2x00crypto.c
index 30fbd3b..de36837 100644
--- a/drivers/net/wireless/rt2x00/rt2x00crypto.c
+++ b/drivers/net/wireless/rt2x00/rt2x00crypto.c
@@ -154,7 +154,7 @@ void rt2x00crypto_tx_insert_iv(struct sk_buff *skb, unsigned int header_length)
 	skbdesc->flags &= ~SKBDESC_IV_STRIPPED;
 }
 
-void rt2x00crypto_rx_insert_iv(struct sk_buff *skb, bool l2pad,
+void rt2x00crypto_rx_insert_iv(struct sk_buff *skb,
 			       unsigned int header_length,
 			       struct rxdone_entry_desc *rxdesc)
 {
@@ -199,7 +199,7 @@ void rt2x00crypto_rx_insert_iv(struct sk_buff *skb, bool l2pad,
 	 * move the header more then iv_len since we must
 	 * make room for the payload move as well.
 	 */
-	if (l2pad) {
+	if (rxdesc->dev_flags & RXDONE_L2PAD) {
 		skb_push(skb, iv_len - align);
 		skb_put(skb, icv_len);
 
@@ -230,7 +230,7 @@ void rt2x00crypto_rx_insert_iv(struct sk_buff *skb, bool l2pad,
 	 * Move payload for alignment purposes. Note that
 	 * this is only needed when no l2 padding is present.
 	 */
-	if (!l2pad) {
+	if (!(rxdesc->dev_flags & RXDONE_L2PAD)) {
 		memmove(skb->data + transfer,
 			skb->data + transfer + align,
 			payload_len);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 3f8c70e..5db613f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -216,7 +216,7 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	 * Remove L2 padding which was added during
 	 */
 	if (test_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags))
-		rt2x00queue_payload_align(entry->skb, true, header_length);
+		rt2x00queue_remove_l2pad(entry->skb, header_length);
 
 	/*
 	 * If the IV/EIV data was stripped from the frame before it was
@@ -360,7 +360,6 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 	struct sk_buff *skb;
 	struct ieee80211_rx_status *rx_status = &rt2x00dev->rx_status;
 	unsigned int header_length;
-	bool l2pad;
 	int rate_idx;
 	/*
 	 * Allocate a new sk_buffer. If no new buffer available, drop the
@@ -389,7 +388,6 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 	 * aligned on a 4 byte boundary.
 	 */
 	header_length = ieee80211_get_hdrlen_from_skb(entry->skb);
-	l2pad = !!(rxdesc.dev_flags & RXDONE_L2PAD);
 
 	/*
 	 * Hardware might have stripped the IV/EIV/ICV data,
@@ -399,10 +397,12 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 	 */
 	if ((rxdesc.dev_flags & RXDONE_CRYPTO_IV) &&
 	    (rxdesc.flags & RX_FLAG_IV_STRIPPED))
-		rt2x00crypto_rx_insert_iv(entry->skb, l2pad, header_length,
+		rt2x00crypto_rx_insert_iv(entry->skb, header_length,
 					  &rxdesc);
+	else if (rxdesc.dev_flags & RXDONE_L2PAD)
+		rt2x00queue_remove_l2pad(entry->skb, header_length);
 	else
-		rt2x00queue_payload_align(entry->skb, l2pad, header_length);
+		rt2x00queue_align_payload(entry->skb, header_length);
 
 	/*
 	 * Check if the frame was received using HT. In that case,
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index eeb2881..5462cb5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -120,21 +120,42 @@ void rt2x00queue_unmap_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
 void rt2x00queue_free_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
 
 /**
- * rt2x00queue_payload_align - Align 802.11 payload to 4-byte boundary
+ * rt2x00queue_align_frame - Align 802.11 frame to 4-byte boundary
+ * @skb: The skb to align
+ *
+ * Align the start of the 802.11 frame to a 4-byte boundary, this could
+ * mean the payload is not aligned properly though.
+ */
+void rt2x00queue_align_frame(struct sk_buff *skb);
+
+/**
+ * rt2x00queue_align_payload - Align 802.11 payload to 4-byte boundary
+ * @skb: The skb to align
+ * @header_length: Length of 802.11 header
+ *
+ * Align the 802.11 payload to a 4-byte boundary, this could
+ * mean the header is not aligned properly though.
+ */
+void rt2x00queue_align_payload(struct sk_buff *skb, unsigned int header_length);
+
+/**
+ * rt2x00queue_insert_l2pad - Align 802.11 header & payload to 4-byte boundary
+ * @skb: The skb to align
+ * @header_length: Length of 802.11 header
+ *
+ * Apply L2 padding to align both header and payload to 4-byte boundary
+ */
+void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length);
+
+/**
+ * rt2x00queue_insert_l2pad - Remove L2 padding from 802.11 frame
  * @skb: The skb to align
- * @l2pad: Should L2 padding be used
  * @header_length: Length of 802.11 header
  *
- * This function prepares the @skb to be send to the device or mac80211.
- * If @l2pad is set to true padding will occur between the 802.11 header
- * and payload. Otherwise the padding will be done in front of the 802.11
- * header.
- * When @l2pad is set the function will check for the &SKBDESC_L2_PADDED
- * flag in &skb_frame_desc. If that flag is set, the padding is removed
- * and the flag cleared. Otherwise the padding is added and the flag is set.
+ * Remove L2 padding used to align both header and payload to 4-byte boundary,
+ * by removing the L2 padding the header will no longer be 4-byte aligned.
  */
-void rt2x00queue_payload_align(struct sk_buff *skb,
-			       bool l2pad, unsigned int header_length);
+void rt2x00queue_remove_l2pad(struct sk_buff *skb, unsigned int header_length);
 
 /**
  * rt2x00queue_write_tx_frame - Write TX frame to hardware
@@ -324,7 +345,7 @@ void rt2x00crypto_tx_copy_iv(struct sk_buff *skb,
 void rt2x00crypto_tx_remove_iv(struct sk_buff *skb,
 			       struct txentry_desc *txdesc);
 void rt2x00crypto_tx_insert_iv(struct sk_buff *skb, unsigned int header_length);
-void rt2x00crypto_rx_insert_iv(struct sk_buff *skb, bool l2pad,
+void rt2x00crypto_rx_insert_iv(struct sk_buff *skb,
 			       unsigned int header_length,
 			       struct rxdone_entry_desc *rxdesc);
 #else
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 06af823..577029e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -148,35 +148,89 @@ void rt2x00queue_free_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 	dev_kfree_skb_any(skb);
 }
 
-void rt2x00queue_payload_align(struct sk_buff *skb,
-			       bool l2pad, unsigned int header_length)
+void rt2x00queue_align_frame(struct sk_buff *skb)
 {
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
 	unsigned int frame_length = skb->len;
-	unsigned int align = ALIGN_SIZE(skb, header_length);
+	unsigned int align = ALIGN_SIZE(skb, 0);
 
 	if (!align)
 		return;
 
-	if (l2pad) {
-		if (skbdesc->flags & SKBDESC_L2_PADDED) {
-			/* Remove L2 padding */
-			memmove(skb->data + align, skb->data, header_length);
-			skb_pull(skb, align);
-			skbdesc->flags &= ~SKBDESC_L2_PADDED;
-		} else {
-			/* Add L2 padding */
-			skb_push(skb, align);
-			memmove(skb->data, skb->data + align, header_length);
-			skbdesc->flags |= SKBDESC_L2_PADDED;
-		}
+	skb_push(skb, align);
+	memmove(skb->data, skb->data + align, frame_length);
+	skb_trim(skb, frame_length);
+}
+
+void rt2x00queue_align_payload(struct sk_buff *skb, unsigned int header_lengt)
+{
+	unsigned int frame_length = skb->len;
+	unsigned int align = ALIGN_SIZE(skb, header_lengt);
+
+	if (!align)
+		return;
+
+	skb_push(skb, align);
+	memmove(skb->data, skb->data + align, frame_length);
+	skb_trim(skb, frame_length);
+}
+
+void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
+{
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
+	unsigned int frame_length = skb->len;
+	unsigned int header_align = ALIGN_SIZE(skb, 0);
+	unsigned int payload_align = ALIGN_SIZE(skb, header_length);
+	unsigned int l2pad = 4 - (payload_align - header_align);
+
+	if (header_align == payload_align) {
+		/*
+		 * Both header and payload must be moved the same
+		 * amount of bytes to align them properly. This means
+		 * we don't use the L2 padding but just move the entire
+		 * frame.
+		 */
+		rt2x00queue_align_frame(skb);
+	} else if (!payload_align) {
+		/*
+		 * Simple L2 padding, only the header needs to be moved,
+		 * the payload is already properly aligned.
+		 */
+		skb_push(skb, header_align);
+		memmove(skb->data, skb->data + header_align, frame_length);
+		skbdesc->flags |= SKBDESC_L2_PADDED;
 	} else {
-		/* Generic payload alignment to 4-byte boundary */
-		skb_push(skb, align);
-		memmove(skb->data, skb->data + align, frame_length);
+		/*
+		 *
+		 * Complicated L2 padding, both header and payload need
+		 * to be moved. By default we only move to the start
+		 * of the buffer, so our header alignment needs to be
+		 * increased if there is not enough room for the header
+		 * to be moved.
+		 */
+		if (payload_align > header_align)
+			header_align += 4;
+
+		skb_push(skb, header_align);
+		memmove(skb->data, skb->data + header_align, header_length);
+		memmove(skb->data + header_length + l2pad,
+			skb->data + header_length + l2pad + header_align,
+			frame_length - header_length);
+		skbdesc->flags |= SKBDESC_L2_PADDED;
 	}
 }
 
+void rt2x00queue_remove_l2pad(struct sk_buff *skb, unsigned int header_length)
+{
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
+	unsigned int l2pad = 4 - (header_length & 3);
+
+	if (!l2pad || (skbdesc->flags & SKBDESC_L2_PADDED))
+		return;
+
+	memmove(skb->data + l2pad, skb->data, header_length);
+	skb_pull(skb, l2pad);
+}
+
 static void rt2x00queue_create_tx_descriptor_seq(struct queue_entry *entry,
 						 struct txentry_desc *txdesc)
 {
@@ -456,18 +510,15 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb)
 	/*
 	 * When DMA allocation is required we should guarentee to the
 	 * driver that the DMA is aligned to a 4-byte boundary.
-	 * Aligning the header to this boundary can be done by calling
-	 * rt2x00queue_payload_align with the header length of 0.
 	 * However some drivers require L2 padding to pad the payload
 	 * rather then the header. This could be a requirement for
 	 * PCI and USB devices, while header alignment only is valid
 	 * for PCI devices.
 	 */
 	if (test_bit(DRIVER_REQUIRE_L2PAD, &queue->rt2x00dev->flags))
-		rt2x00queue_payload_align(entry->skb, true,
-					  txdesc.header_length);
+		rt2x00queue_insert_l2pad(entry->skb, txdesc.header_length);
 	else if (test_bit(DRIVER_REQUIRE_DMA, &queue->rt2x00dev->flags))
-		rt2x00queue_payload_align(entry->skb, false, 0);
+		rt2x00queue_align_frame(entry->skb);
 
 	/*
 	 * It could be possible that the queue was corrupted and this
-- 
1.6.4.1

