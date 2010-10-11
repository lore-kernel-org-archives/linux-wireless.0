Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62576 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab0JKNkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 09:40:23 -0400
Received: by ewy20 with SMTP id 20so574157ewy.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Oct 2010 06:40:21 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/7] rt2x00: Simplify Queue function arguments
Date: Mon, 11 Oct 2010 15:37:25 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010111537.26584.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A lot of functions accept a struct rt2x00_dev combined with
either a struct queue_entry or struct data_queue argument.
This can be simplified by only passing on the queue/entry
argument.

In cases where rt2x00_dev and a sk_buff are send together,
we can send the queue_entry instead.

rt2x00usb_alloc_urb and rt2x00usb_free_urb have a bit
of vague naming. Instead they allocate all the data which
belongs to a rt2x00 data queue entry.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00.h      |   13 +++-----
 drivers/net/wireless/rt2x00/rt2x00dev.c   |   10 +++---
 drivers/net/wireless/rt2x00/rt2x00lib.h   |   11 ++----
 drivers/net/wireless/rt2x00/rt2x00pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c |   49 ++++++++++++++---------------
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   18 +++++-----
 8 files changed, 50 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 4b88909..095cb69 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1104,7 +1104,7 @@ static void rt2400pci_write_beacon(struct queue_entry *entry,
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 
-	rt2x00queue_map_txskb(rt2x00dev, entry->skb);
+	rt2x00queue_map_txskb(entry);
 
 	/*
 	 * Write the TX descriptor for the beacon.
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 46ef692..7d85bf9 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1258,7 +1258,7 @@ static void rt2500pci_write_beacon(struct queue_entry *entry,
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 
-	rt2x00queue_map_txskb(rt2x00dev, entry->skb);
+	rt2x00queue_map_txskb(entry);
 
 	/*
 	 * Write the TX descriptor for the beacon.
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 75ac662..2322c84 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1036,17 +1036,15 @@ static inline bool rt2x00_is_soc(struct rt2x00_dev *rt2x00dev)
 
 /**
  * rt2x00queue_map_txskb - Map a skb into DMA for TX purposes.
- * @rt2x00dev: Pointer to &struct rt2x00_dev.
- * @skb: The skb to map.
+ * @entry: Pointer to &struct queue_entry
  */
-void rt2x00queue_map_txskb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
+void rt2x00queue_map_txskb(struct queue_entry *entry);
 
 /**
  * rt2x00queue_unmap_skb - Unmap a skb from DMA.
- * @rt2x00dev: Pointer to &struct rt2x00_dev.
- * @skb: The skb to unmap.
+ * @entry: Pointer to &struct queue_entry
  */
-void rt2x00queue_unmap_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
+void rt2x00queue_unmap_skb(struct queue_entry *entry);
 
 /**
  * rt2x00queue_get_queue - Convert queue index to queue pointer
@@ -1093,8 +1091,7 @@ void rt2x00lib_dmadone(struct queue_entry *entry);
 void rt2x00lib_txdone(struct queue_entry *entry,
 		      struct txdone_entry_desc *txdesc);
 void rt2x00lib_txdone_noinfo(struct queue_entry *entry, u32 status);
-void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
-		      struct queue_entry *entry);
+void rt2x00lib_rxdone(struct queue_entry *entry);
 
 /*
  * mac80211 handlers.
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 6f442b0..9b745fa 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -273,7 +273,7 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	/*
 	 * Unmap the skb.
 	 */
-	rt2x00queue_unmap_skb(rt2x00dev, entry->skb);
+	rt2x00queue_unmap_skb(entry);
 
 	/*
 	 * Remove the extra tx headroom from the skb.
@@ -465,9 +465,9 @@ static int rt2x00lib_rxdone_read_signal(struct rt2x00_dev *rt2x00dev,
 	return 0;
 }
 
-void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
-		      struct queue_entry *entry)
+void rt2x00lib_rxdone(struct queue_entry *entry)
 {
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct rxdone_entry_desc rxdesc;
 	struct sk_buff *skb;
 	struct ieee80211_rx_status *rx_status;
@@ -481,14 +481,14 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 	 * Allocate a new sk_buffer. If no new buffer available, drop the
 	 * received frame and reuse the existing buffer.
 	 */
-	skb = rt2x00queue_alloc_rxskb(rt2x00dev, entry);
+	skb = rt2x00queue_alloc_rxskb(entry);
 	if (!skb)
 		return;
 
 	/*
 	 * Unmap the skb.
 	 */
-	rt2x00queue_unmap_skb(rt2x00dev, entry->skb);
+	rt2x00queue_unmap_skb(entry);
 
 	/*
 	 * Extract the RXD details.
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 70c85ac..619da23 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -100,18 +100,15 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 
 /**
  * rt2x00queue_alloc_rxskb - allocate a skb for RX purposes.
- * @rt2x00dev: Pointer to &struct rt2x00_dev.
- * @queue: The queue for which the skb will be applicable.
+ * @entry: The entry for which the skb will be applicable.
  */
-struct sk_buff *rt2x00queue_alloc_rxskb(struct rt2x00_dev *rt2x00dev,
-					struct queue_entry *entry);
+struct sk_buff *rt2x00queue_alloc_rxskb(struct queue_entry *entry);
 
 /**
  * rt2x00queue_free_skb - free a skb
- * @rt2x00dev: Pointer to &struct rt2x00_dev.
- * @skb: The skb to free.
+ * @entry: The entry for which the skb will be applicable.
  */
-void rt2x00queue_free_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
+void rt2x00queue_free_skb(struct queue_entry *entry);
 
 /**
  * rt2x00queue_align_frame - Align 802.11 frame to 4-byte boundary
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 63c2cc4..2449d78 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -84,7 +84,7 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 		/*
 		 * Send the frame to rt2x00lib for further processing.
 		 */
-		rt2x00lib_rxdone(rt2x00dev, entry);
+		rt2x00lib_rxdone(entry);
 	}
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_rxdone);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 83630f1..7e30144 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -33,9 +33,9 @@
 #include "rt2x00.h"
 #include "rt2x00lib.h"
 
-struct sk_buff *rt2x00queue_alloc_rxskb(struct rt2x00_dev *rt2x00dev,
-					struct queue_entry *entry)
+struct sk_buff *rt2x00queue_alloc_rxskb(struct queue_entry *entry)
 {
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct sk_buff *skb;
 	struct skb_frame_desc *skbdesc;
 	unsigned int frame_size;
@@ -97,39 +97,42 @@ struct sk_buff *rt2x00queue_alloc_rxskb(struct rt2x00_dev *rt2x00dev,
 	return skb;
 }
 
-void rt2x00queue_map_txskb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
+void rt2x00queue_map_txskb(struct queue_entry *entry)
 {
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
+	struct device *dev = entry->queue->rt2x00dev->dev;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 
 	skbdesc->skb_dma =
-	    dma_map_single(rt2x00dev->dev, skb->data, skb->len, DMA_TO_DEVICE);
+	    dma_map_single(dev, entry->skb->data, entry->skb->len, DMA_TO_DEVICE);
 	skbdesc->flags |= SKBDESC_DMA_MAPPED_TX;
 }
 EXPORT_SYMBOL_GPL(rt2x00queue_map_txskb);
 
-void rt2x00queue_unmap_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
+void rt2x00queue_unmap_skb(struct queue_entry *entry)
 {
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
+	struct device *dev = entry->queue->rt2x00dev->dev;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 
 	if (skbdesc->flags & SKBDESC_DMA_MAPPED_RX) {
-		dma_unmap_single(rt2x00dev->dev, skbdesc->skb_dma, skb->len,
+		dma_unmap_single(dev, skbdesc->skb_dma, entry->skb->len,
 				 DMA_FROM_DEVICE);
 		skbdesc->flags &= ~SKBDESC_DMA_MAPPED_RX;
 	} else if (skbdesc->flags & SKBDESC_DMA_MAPPED_TX) {
-		dma_unmap_single(rt2x00dev->dev, skbdesc->skb_dma, skb->len,
+		dma_unmap_single(dev, skbdesc->skb_dma, entry->skb->len,
 				 DMA_TO_DEVICE);
 		skbdesc->flags &= ~SKBDESC_DMA_MAPPED_TX;
 	}
 }
 EXPORT_SYMBOL_GPL(rt2x00queue_unmap_skb);
 
-void rt2x00queue_free_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
+void rt2x00queue_free_skb(struct queue_entry *entry)
 {
-	if (!skb)
+	if (!entry->skb)
 		return;
 
-	rt2x00queue_unmap_skb(rt2x00dev, skb);
-	dev_kfree_skb_any(skb);
+	rt2x00queue_unmap_skb(entry);
+	dev_kfree_skb_any(entry->skb);
+	entry->skb = NULL;
 }
 
 void rt2x00queue_align_frame(struct sk_buff *skb)
@@ -438,7 +441,7 @@ static int rt2x00queue_write_tx_data(struct queue_entry *entry,
 	 * Map the skb to DMA.
 	 */
 	if (test_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags))
-		rt2x00queue_map_txskb(rt2x00dev, entry->skb);
+		rt2x00queue_map_txskb(entry);
 
 	return 0;
 }
@@ -585,8 +588,7 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Clean up the beacon skb.
 	 */
-	rt2x00queue_free_skb(rt2x00dev, intf->beacon->skb);
-	intf->beacon->skb = NULL;
+	rt2x00queue_free_skb(intf->beacon);
 
 	if (!enable_beacon) {
 		rt2x00dev->ops->lib->kill_tx_queue(intf->beacon->queue);
@@ -827,8 +829,7 @@ static int rt2x00queue_alloc_entries(struct data_queue *queue,
 	return 0;
 }
 
-static void rt2x00queue_free_skbs(struct rt2x00_dev *rt2x00dev,
-				  struct data_queue *queue)
+static void rt2x00queue_free_skbs(struct data_queue *queue)
 {
 	unsigned int i;
 
@@ -836,19 +837,17 @@ static void rt2x00queue_free_skbs(struct rt2x00_dev *rt2x00dev,
 		return;
 
 	for (i = 0; i < queue->limit; i++) {
-		if (queue->entries[i].skb)
-			rt2x00queue_free_skb(rt2x00dev, queue->entries[i].skb);
+		rt2x00queue_free_skb(&queue->entries[i]);
 	}
 }
 
-static int rt2x00queue_alloc_rxskbs(struct rt2x00_dev *rt2x00dev,
-				    struct data_queue *queue)
+static int rt2x00queue_alloc_rxskbs(struct data_queue *queue)
 {
 	unsigned int i;
 	struct sk_buff *skb;
 
 	for (i = 0; i < queue->limit; i++) {
-		skb = rt2x00queue_alloc_rxskb(rt2x00dev, &queue->entries[i]);
+		skb = rt2x00queue_alloc_rxskb(&queue->entries[i]);
 		if (!skb)
 			return -ENOMEM;
 		queue->entries[i].skb = skb;
@@ -883,7 +882,7 @@ int rt2x00queue_initialize(struct rt2x00_dev *rt2x00dev)
 			goto exit;
 	}
 
-	status = rt2x00queue_alloc_rxskbs(rt2x00dev, rt2x00dev->rx);
+	status = rt2x00queue_alloc_rxskbs(rt2x00dev->rx);
 	if (status)
 		goto exit;
 
@@ -901,7 +900,7 @@ void rt2x00queue_uninitialize(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
 
-	rt2x00queue_free_skbs(rt2x00dev, rt2x00dev->rx);
+	rt2x00queue_free_skbs(rt2x00dev->rx);
 
 	queue_for_each(rt2x00dev, queue) {
 		kfree(queue->entries);
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 4c5ae3d..451d637 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -398,7 +398,7 @@ static void rt2x00usb_work_rxdone(struct work_struct *work)
 		/*
 		 * Send the frame to rt2x00lib for further processing.
 		 */
-		rt2x00lib_rxdone(rt2x00dev, entry);
+		rt2x00lib_rxdone(entry);
 	}
 }
 
@@ -542,9 +542,9 @@ static int rt2x00usb_find_endpoints(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
-static int rt2x00usb_alloc_urb(struct rt2x00_dev *rt2x00dev,
-			       struct data_queue *queue)
+static int rt2x00usb_alloc_entries(struct data_queue *queue)
 {
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
 	struct queue_entry_priv_usb *entry_priv;
 	struct queue_entry_priv_usb_bcn *bcn_priv;
 	unsigned int i;
@@ -561,7 +561,7 @@ static int rt2x00usb_alloc_urb(struct rt2x00_dev *rt2x00dev,
 	 * no guardian byte was required for the beacon,
 	 * then we are done.
 	 */
-	if (rt2x00dev->bcn != queue ||
+	if (queue->qid != QID_BEACON ||
 	    !test_bit(DRIVER_REQUIRE_BEACON_GUARD, &rt2x00dev->flags))
 		return 0;
 
@@ -575,9 +575,9 @@ static int rt2x00usb_alloc_urb(struct rt2x00_dev *rt2x00dev,
 	return 0;
 }
 
-static void rt2x00usb_free_urb(struct rt2x00_dev *rt2x00dev,
-			       struct data_queue *queue)
+static void rt2x00usb_free_entries(struct data_queue *queue)
 {
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
 	struct queue_entry_priv_usb *entry_priv;
 	struct queue_entry_priv_usb_bcn *bcn_priv;
 	unsigned int i;
@@ -596,7 +596,7 @@ static void rt2x00usb_free_urb(struct rt2x00_dev *rt2x00dev,
 	 * no guardian byte was required for the beacon,
 	 * then we are done.
 	 */
-	if (rt2x00dev->bcn != queue ||
+	if (queue->qid != QID_BEACON ||
 	    !test_bit(DRIVER_REQUIRE_BEACON_GUARD, &rt2x00dev->flags))
 		return;
 
@@ -623,7 +623,7 @@ int rt2x00usb_initialize(struct rt2x00_dev *rt2x00dev)
 	 * Allocate DMA
 	 */
 	queue_for_each(rt2x00dev, queue) {
-		status = rt2x00usb_alloc_urb(rt2x00dev, queue);
+		status = rt2x00usb_alloc_entries(queue);
 		if (status)
 			goto exit;
 	}
@@ -642,7 +642,7 @@ void rt2x00usb_uninitialize(struct rt2x00_dev *rt2x00dev)
 	struct data_queue *queue;
 
 	queue_for_each(rt2x00dev, queue)
-		rt2x00usb_free_urb(rt2x00dev, queue);
+		rt2x00usb_free_entries(queue);
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_uninitialize);
 
-- 
1.7.2.3

