Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:1892 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbYFPRoq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 13:44:46 -0400
Received: by wa-out-1112.google.com with SMTP id j37so4408775waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2008 10:44:45 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/9] rt2x00: Centralize allocation of RX skbs.
Date: Mon, 16 Jun 2008 19:56:08 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200806161954.04241.IvDoorn@gmail.com> <200806161955.18775.IvDoorn@gmail.com> <200806161955.43378.IvDoorn@gmail.com>
In-Reply-To: <200806161955.43378.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806161956.08169.IvDoorn@gmail.com> (sfid-20080616_194501_927199_68E2C92E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>

In preparation of replacing the statically allocated DMA buffers with
dynamically mapped skbs, centralize the allocation of RX skbs to rt2x00queue.c
and let rt2x00pci already use them.

Signed-off-by: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h      |   10 +++-
 drivers/net/wireless/rt2x00/rt2x00pci.c   |   77 ++++++++++++++++++----------
 drivers/net/wireless/rt2x00/rt2x00queue.c |   71 ++++++++++++++++++++------
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   21 +-------
 4 files changed, 113 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 8d45235..08e8b0a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -899,10 +899,16 @@ static inline u16 get_duration_res(const unsigned int size, const u8 rate)
 }
 
 /**
- * rt2x00queue_alloc_rxskb - allocate a skb for RX purposes.
+ * rt2x00queue_alloc_skb - allocate a skb.
  * @queue: The queue for which the skb will be applicable.
  */
-struct sk_buff *rt2x00queue_alloc_rxskb(struct data_queue *queue);
+struct sk_buff *rt2x00queue_alloc_skb(struct data_queue *queue);
+
+/**
+ * rt2x00queue_free_skb - free a skb
+ * @skb: The skb to free.
+ */
+void rt2x00queue_free_skb(struct sk_buff *skb);
 
 /**
  * rt2x00queue_create_tx_descriptor - Create TX descriptor from mac80211 input
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index d613838..e7e3a45 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -74,13 +74,59 @@ EXPORT_SYMBOL_GPL(rt2x00pci_write_tx_data);
 /*
  * TX/RX data handlers.
  */
+static void rt2x00pci_rxdone_entry(struct rt2x00_dev *rt2x00dev,
+				   struct queue_entry *entry)
+{
+	struct sk_buff *skb;
+	struct skb_frame_desc *skbdesc;
+	struct rxdone_entry_desc rxdesc;
+	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+
+	/*
+	 * Allocate a new sk_buffer. If no new buffer available, drop the
+	 * received frame and reuse the existing buffer.
+	 */
+	skb = rt2x00queue_alloc_skb(entry->queue);
+	if (!skb)
+		return;
+
+	/*
+	 * Extract the RXD details.
+	 */
+	memset(&rxdesc, 0, sizeof(rxdesc));
+	rt2x00dev->ops->lib->fill_rxdone(entry, &rxdesc);
+
+	/*
+	 * Copy the received data to the entries' skb.
+	 */
+	memcpy(entry->skb->data, entry_priv->data, rxdesc.size);
+	skb_trim(entry->skb, rxdesc.size);
+
+	/*
+	 * Fill in skb descriptor
+	 */
+	skbdesc = get_skb_frame_desc(entry->skb);
+	memset(skbdesc, 0, sizeof(*skbdesc));
+	skbdesc->desc = entry_priv->desc;
+	skbdesc->desc_len = entry->queue->desc_size;
+	skbdesc->entry = entry;
+
+	/*
+	 * Send the frame to rt2x00lib for further processing.
+	 */
+	rt2x00lib_rxdone(entry, &rxdesc);
+
+	/*
+	 * Replace the entries' skb with the newly allocated one.
+	 */
+	entry->skb = skb;
+}
+
 void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue = rt2x00dev->rx;
 	struct queue_entry *entry;
 	struct queue_entry_priv_pci *entry_priv;
-	struct skb_frame_desc *skbdesc;
-	struct rxdone_entry_desc rxdesc;
 	u32 word;
 
 	while (1) {
@@ -91,32 +137,7 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 		if (rt2x00_get_field32(word, RXD_ENTRY_OWNER_NIC))
 			break;
 
-		memset(&rxdesc, 0, sizeof(rxdesc));
-		rt2x00dev->ops->lib->fill_rxdone(entry, &rxdesc);
-
-		/*
-		 * Allocate the sk_buffer and copy all data into it.
-		 */
-		entry->skb = rt2x00queue_alloc_rxskb(queue);
-		if (!entry->skb)
-			return;
-
-		memcpy(entry->skb->data, entry_priv->data, rxdesc.size);
-		skb_trim(entry->skb, rxdesc.size);
-
-		/*
-		 * Fill in skb descriptor
-		 */
-		skbdesc = get_skb_frame_desc(entry->skb);
-		memset(skbdesc, 0, sizeof(*skbdesc));
-		skbdesc->desc = entry_priv->desc;
-		skbdesc->desc_len = queue->desc_size;
-		skbdesc->entry = entry;
-
-		/*
-		 * Send the frame to rt2x00lib for further processing.
-		 */
-		rt2x00lib_rxdone(entry, &rxdesc);
+		rt2x00pci_rxdone_entry(rt2x00dev, entry);
 
 		if (test_bit(DEVICE_ENABLED_RADIO, &queue->rt2x00dev->flags)) {
 			rt2x00_set_field32(&word, RXD_ENTRY_OWNER_NIC, 1);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 15660b5..278f1a1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -29,7 +29,7 @@
 #include "rt2x00.h"
 #include "rt2x00lib.h"
 
-struct sk_buff *rt2x00queue_alloc_rxskb(struct data_queue *queue)
+struct sk_buff *rt2x00queue_alloc_skb(struct data_queue *queue)
 {
 	struct sk_buff *skb;
 	unsigned int frame_size;
@@ -42,17 +42,10 @@ struct sk_buff *rt2x00queue_alloc_rxskb(struct data_queue *queue)
 	frame_size = queue->data_size + queue->desc_size;
 
 	/*
-	 * For the allocation we should keep a few things in mind:
-	 * 1) 4byte alignment of 802.11 payload
-	 *
-	 * For (1) we need at most 4 bytes to guarentee the correct
-	 * alignment. We are going to optimize the fact that the chance
-	 * that the 802.11 header_size % 4 == 2 is much bigger then
-	 * anything else. However since we need to move the frame up
-	 * to 3 bytes to the front, which means we need to preallocate
-	 * 6 bytes.
+	 * Reserve a few bytes extra headroom to allow drivers some moving
+	 * space (e.g. for alignment), while keeping the skb aligned.
 	 */
-	reserved_size = 6;
+	reserved_size = 8;
 
 	/*
 	 * Allocate skbuffer.
@@ -66,7 +59,13 @@ struct sk_buff *rt2x00queue_alloc_rxskb(struct data_queue *queue)
 
 	return skb;
 }
-EXPORT_SYMBOL_GPL(rt2x00queue_alloc_rxskb);
+EXPORT_SYMBOL_GPL(rt2x00queue_alloc_skb);
+
+void rt2x00queue_free_skb(struct sk_buff *skb)
+{
+	dev_kfree_skb_any(skb);
+}
+EXPORT_SYMBOL_GPL(rt2x00queue_free_skb);
 
 void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 				      struct txentry_desc *txdesc)
@@ -422,12 +421,45 @@ static int rt2x00queue_alloc_entries(struct data_queue *queue,
 	return 0;
 }
 
+static void rt2x00queue_free_skbs(struct data_queue *queue)
+{
+	unsigned int i;
+
+	if (!queue->entries)
+		return;
+
+	for (i = 0; i < queue->limit; i++) {
+		if (queue->entries[i].skb)
+			rt2x00queue_free_skb(queue->entries[i].skb);
+	}
+}
+
+static int rt2x00queue_alloc_skbs(struct data_queue *queue)
+{
+	unsigned int i;
+	struct sk_buff *skb;
+
+	for (i = 0; i < queue->limit; i++) {
+		skb = rt2x00queue_alloc_skb(queue);
+		if (!skb)
+			goto exit;
+
+		queue->entries[i].skb = skb;
+	}
+
+	return 0;
+
+exit:
+	rt2x00queue_free_skbs(queue);
+
+	return -ENOMEM;
+}
+
 int rt2x00queue_initialize(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
 	int status;
 
-
 	status = rt2x00queue_alloc_entries(rt2x00dev->rx, rt2x00dev->ops->rx);
 	if (status)
 		goto exit;
@@ -442,11 +474,14 @@ int rt2x00queue_initialize(struct rt2x00_dev *rt2x00dev)
 	if (status)
 		goto exit;
 
-	if (!test_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags))
-		return 0;
+	if (test_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags)) {
+		status = rt2x00queue_alloc_entries(&rt2x00dev->bcn[1],
+						   rt2x00dev->ops->atim);
+		if (status)
+			goto exit;
+	}
 
-	status = rt2x00queue_alloc_entries(&rt2x00dev->bcn[1],
-					   rt2x00dev->ops->atim);
+	status = rt2x00queue_alloc_skbs(rt2x00dev->rx);
 	if (status)
 		goto exit;
 
@@ -464,6 +499,8 @@ void rt2x00queue_uninitialize(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
 
+	rt2x00queue_free_skbs(rt2x00dev->rx);
+
 	queue_for_each(rt2x00dev, queue) {
 		kfree(queue->entries);
 		queue->entries = NULL;
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index f91901f..29dba86 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -300,7 +300,7 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	 * If allocation fails, we should drop the current frame
 	 * so we can recycle the existing sk buffer for the new frame.
 	 */
-	skb = rt2x00queue_alloc_rxskb(entry->queue);
+	skb = rt2x00queue_alloc_skb(entry->queue);
 	if (!skb)
 		goto skip_entry;
 
@@ -434,8 +434,6 @@ static void rt2x00usb_free_urb(struct rt2x00_dev *rt2x00dev,
 		entry_priv = queue->entries[i].priv_data;
 		usb_kill_urb(entry_priv->urb);
 		usb_free_urb(entry_priv->urb);
-		if (queue->entries[i].skb)
-			kfree_skb(queue->entries[i].skb);
 	}
 
 	/*
@@ -457,10 +455,7 @@ static void rt2x00usb_free_urb(struct rt2x00_dev *rt2x00dev,
 int rt2x00usb_initialize(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
-	struct sk_buff *skb;
-	unsigned int entry_size;
-	unsigned int i;
-	int uninitialized_var(status);
+	int status;
 
 	/*
 	 * Allocate DMA
@@ -471,18 +466,6 @@ int rt2x00usb_initialize(struct rt2x00_dev *rt2x00dev)
 			goto exit;
 	}
 
-	/*
-	 * For the RX queue, skb's should be allocated.
-	 */
-	entry_size = rt2x00dev->rx->data_size + rt2x00dev->rx->desc_size;
-	for (i = 0; i < rt2x00dev->rx->limit; i++) {
-		skb = rt2x00queue_alloc_rxskb(rt2x00dev->rx);
-		if (!skb)
-			goto exit;
-
-		rt2x00dev->rx->entries[i].skb = skb;
-	}
-
 	return 0;
 
 exit:
-- 
1.5.5.4

