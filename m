Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:45416 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129AbYFHVhj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 17:37:39 -0400
Received: by ug-out-1314.google.com with SMTP id h2so1022998ugf.16
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2008 14:37:39 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/10] rt2x00: Centralize RX packet alignment handling in rt2x00lib.
Date: Sun, 8 Jun 2008 23:45:03 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200806082341.58616.IvDoorn@gmail.com> <200806082343.56928.IvDoorn@gmail.com> <200806082344.28110.IvDoorn@gmail.com>
In-Reply-To: <200806082344.28110.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806082345.04002.IvDoorn@gmail.com> (sfid-20080608_233743_576030_8C07FDC7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>

When rt2x00pci will be switched over to dynamically mapped skb's instead of statically
allocated DMA buffers, it no longer can handle alignment of RX packets in a copy step,
and needs to implement the same scheme as rt2x00usb does.

In order to make the patch on dynamically mapped skb's smaller, already centralize the
alignment handling into rt2x00lib. This allows us to move more code in rt2x00lib, and
thus remove code duplication between rt2x00usb and rt2x00pci.

Signed-off-by: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h      |    6 +++
 drivers/net/wireless/rt2x00/rt2x00dev.c   |   22 ++++++++++
 drivers/net/wireless/rt2x00/rt2x00pci.c   |   23 ++---------
 drivers/net/wireless/rt2x00/rt2x00queue.c |   39 ++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   63 +---------------------------
 5 files changed, 74 insertions(+), 79 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 938d375..0da8f97 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -930,6 +930,12 @@ static inline u16 get_duration_res(const unsigned int size, const u8 rate)
 }
 
 /**
+ * rt2x00queue_alloc_rxskb - allocate a skb for RX purposes.
+ * @queue: The queue for which the skb will be applicable.
+ */
+struct sk_buff *rt2x00queue_alloc_rxskb(struct data_queue *queue);
+
+/**
  * rt2x00queue_create_tx_descriptor - Create TX descriptor from mac80211 input
  * @entry: The entry which will be used to transfer the TX frame.
  * @txdesc: rt2x00 TX descriptor which will be initialized by this function.
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 48f4aec..ce1f7bb 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -554,14 +554,36 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct ieee80211_rx_status *rx_status = &rt2x00dev->rx_status;
+	unsigned int header_size = ieee80211_get_hdrlen_from_skb(entry->skb);
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_hdr *hdr;
 	const struct rt2x00_rate *rate;
+	unsigned int align;
 	unsigned int i;
 	int idx = -1;
 	u16 fc;
 
 	/*
+	 * The data behind the ieee80211 header must be
+	 * aligned on a 4 byte boundary. We already reserved
+	 * 2 bytes for header_size % 4 == 2 optimization.
+	 * To determine the number of bytes which the data
+	 * should be moved to the left, we must add these
+	 * 2 bytes to the header_size.
+	 */
+	align = (header_size + 2) % 4;
+
+	if (align) {
+		skb_push(entry->skb, align);
+		/* Move entire frame in 1 command */
+		memmove(entry->skb->data, entry->skb->data + align,
+			rxdesc->size);
+	}
+
+	/* Update data pointers, trim buffer to correct size */
+	skb_trim(entry->skb, rxdesc->size);
+
+	/*
 	 * Update RX statistics.
 	 */
 	sband = &rt2x00dev->bands[rt2x00dev->curr_band];
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 8712238..8d6ad18 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -79,11 +79,8 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 	struct data_queue *queue = rt2x00dev->rx;
 	struct queue_entry *entry;
 	struct queue_entry_priv_pci *entry_priv;
-	struct ieee80211_hdr *hdr;
 	struct skb_frame_desc *skbdesc;
 	struct rxdone_entry_desc rxdesc;
-	int header_size;
-	int align;
 	u32 word;
 
 	while (1) {
@@ -97,27 +94,15 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 		memset(&rxdesc, 0, sizeof(rxdesc));
 		rt2x00dev->ops->lib->fill_rxdone(entry, &rxdesc);
 
-		hdr = (struct ieee80211_hdr *)entry_priv->data;
-		header_size =
-		    ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control));
-
-		/*
-		 * The data behind the ieee80211 header must be
-		 * aligned on a 4 byte boundary.
-		 */
-		align = header_size % 4;
-
 		/*
-		 * Allocate the sk_buffer, initialize it and copy
-		 * all data into it.
+		 * Allocate the sk_buffer and copy all data into it.
 		 */
-		entry->skb = dev_alloc_skb(rxdesc.size + align);
+		entry->skb = rt2x00queue_alloc_rxskb(queue);
 		if (!entry->skb)
 			return;
 
-		skb_reserve(entry->skb, align);
-		memcpy(skb_put(entry->skb, rxdesc.size),
-		       entry_priv->data, rxdesc.size);
+		memcpy(entry->skb->data, entry_priv->data, rxdesc.size);
+		skb_trim(entry->skb, rxdesc.size);
 
 		/*
 		 * Fill in skb descriptor
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 4930665..2f3dd1d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -29,6 +29,45 @@
 #include "rt2x00.h"
 #include "rt2x00lib.h"
 
+struct sk_buff *rt2x00queue_alloc_rxskb(struct data_queue *queue)
+{
+	struct sk_buff *skb;
+	unsigned int frame_size;
+	unsigned int reserved_size;
+
+	/*
+	 * The frame size includes descriptor size, because the
+	 * hardware directly receive the frame into the skbuffer.
+	 */
+	frame_size = queue->data_size + queue->desc_size;
+
+	/*
+	 * For the allocation we should keep a few things in mind:
+	 * 1) 4byte alignment of 802.11 payload
+	 *
+	 * For (1) we need at most 4 bytes to guarentee the correct
+	 * alignment. We are going to optimize the fact that the chance
+	 * that the 802.11 header_size % 4 == 2 is much bigger then
+	 * anything else. However since we need to move the frame up
+	 * to 3 bytes to the front, which means we need to preallocate
+	 * 6 bytes.
+	 */
+	reserved_size = 6;
+
+	/*
+	 * Allocate skbuffer.
+	 */
+	skb = dev_alloc_skb(frame_size + reserved_size);
+	if (!skb)
+		return NULL;
+
+	skb_reserve(skb, reserved_size);
+	skb_put(skb, frame_size);
+
+	return skb;
+}
+EXPORT_SYMBOL_GPL(rt2x00queue_alloc_rxskb);
+
 void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 				      struct txentry_desc *txdesc)
 {
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 20c3ce8..6e22036 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -260,44 +260,6 @@ EXPORT_SYMBOL_GPL(rt2x00usb_kick_tx_queue);
 /*
  * RX data handlers.
  */
-static struct sk_buff* rt2x00usb_alloc_rxskb(struct data_queue *queue)
-{
-	struct sk_buff *skb;
-	unsigned int frame_size;
-	unsigned int reserved_size;
-
-	/*
-	 * The frame size includes descriptor size, because the
-	 * hardware directly receive the frame into the skbuffer.
-	 */
-	frame_size = queue->data_size + queue->desc_size;
-
-	/*
-	 * For the allocation we should keep a few things in mind:
-	 * 1) 4byte alignment of 802.11 payload
-	 *
-	 * For (1) we need at most 4 bytes to guarentee the correct
-	 * alignment. We are going to optimize the fact that the chance
-	 * that the 802.11 header_size % 4 == 2 is much bigger then
-	 * anything else. However since we need to move the frame up
-	 * to 3 bytes to the front, which means we need to preallocate
-	 * 6 bytes.
-	 */
-	reserved_size = 6;
-
-	/*
-	 * Allocate skbuffer.
-	 */
-	skb = dev_alloc_skb(frame_size + reserved_size);
-	if (!skb)
-		return NULL;
-
-	skb_reserve(skb, reserved_size);
-	skb_put(skb, frame_size);
-
-	return skb;
-}
-
 static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 {
 	struct queue_entry *entry = (struct queue_entry *)urb->context;
@@ -305,8 +267,6 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	struct sk_buff *skb;
 	struct skb_frame_desc *skbdesc;
 	struct rxdone_entry_desc rxdesc;
-	unsigned int header_size;
-	unsigned int align;
 
 	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags) ||
 	    !test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
@@ -330,26 +290,9 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	memset(&rxdesc, 0, sizeof(rxdesc));
 	rt2x00dev->ops->lib->fill_rxdone(entry, &rxdesc);
 
-	header_size = ieee80211_get_hdrlen_from_skb(entry->skb);
-
 	/*
-	 * The data behind the ieee80211 header must be
-	 * aligned on a 4 byte boundary. We already reserved
-	 * 2 bytes for header_size % 4 == 2 optimization.
-	 * To determine the number of bytes which the data
-	 * should be moved to the left, we must add these
-	 * 2 bytes to the header_size.
+	 * Trim the skb to the correct size.
 	 */
-	align = (header_size + 2) % 4;
-
-	if (align) {
-		skb_push(entry->skb, align);
-		/* Move entire frame in 1 command */
-		memmove(entry->skb->data, entry->skb->data + align,
-			rxdesc.size);
-	}
-
-	/* Update data pointers, trim buffer to correct size */
 	skb_trim(entry->skb, rxdesc.size);
 
 	/*
@@ -357,7 +300,7 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	 * If allocation fails, we should drop the current frame
 	 * so we can recycle the existing sk buffer for the new frame.
 	 */
-	skb = rt2x00usb_alloc_rxskb(entry->queue);
+	skb = rt2x00queue_alloc_rxskb(entry->queue);
 	if (!skb)
 		goto skip_entry;
 
@@ -532,7 +475,7 @@ int rt2x00usb_initialize(struct rt2x00_dev *rt2x00dev)
 	 */
 	entry_size = rt2x00dev->rx->data_size + rt2x00dev->rx->desc_size;
 	for (i = 0; i < rt2x00dev->rx->limit; i++) {
-		skb = rt2x00usb_alloc_rxskb(rt2x00dev->rx);
+		skb = rt2x00queue_alloc_rxskb(rt2x00dev->rx);
 		if (!skb)
 			goto exit;
 
-- 
1.5.5.3

