Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:45416 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108AbYFHVhc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 17:37:32 -0400
Received: by ug-out-1314.google.com with SMTP id h2so1022998ugf.16
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2008 14:37:31 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/10] rt2x00: Move generic TX frame writing code into rt2x00queue
Date: Sun, 8 Jun 2008 23:43:17 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200806082341.58616.IvDoorn@gmail.com> <200806082342.40422.IvDoorn@gmail.com>
In-Reply-To: <200806082342.40422.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806082343.17344.IvDoorn@gmail.com> (sfid-20080608_233735_110643_05C3F7B4)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The write_tx_data functions in rt2x00pci and rt2x00usb have
a lot in common. This moves that duplicate code into
rt2x00queue_write_tx_frame().

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h      |    3 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h   |    1 +
 drivers/net/wireless/rt2x00/rt2x00mac.c   |    7 +---
 drivers/net/wireless/rt2x00/rt2x00pci.c   |   43 ++++++++--------------
 drivers/net/wireless/rt2x00/rt2x00pci.h   |   11 ++++--
 drivers/net/wireless/rt2x00/rt2x00queue.c |   37 +++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   57 +++++++----------------------
 drivers/net/wireless/rt2x00/rt2x00usb.h   |   11 ++++--
 8 files changed, 85 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 2f79336..c7da3c2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -546,8 +546,7 @@ struct rt2x00lib_ops {
 	void (*write_tx_desc) (struct rt2x00_dev *rt2x00dev,
 			       struct sk_buff *skb,
 			       struct txentry_desc *txdesc);
-	int (*write_tx_data) (struct rt2x00_dev *rt2x00dev,
-			      struct data_queue *queue, struct sk_buff *skb);
+	int (*write_tx_data) (struct queue_entry *entry);
 	int (*get_tx_data_len) (struct rt2x00_dev *rt2x00dev,
 				struct sk_buff *skb);
 	void (*kick_tx_queue) (struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index c4ce534..558f45b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -101,6 +101,7 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 /*
  * Queue handlers.
  */
+int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb);
 void rt2x00queue_init_rx(struct rt2x00_dev *rt2x00dev);
 void rt2x00queue_init_tx(struct rt2x00_dev *rt2x00dev);
 int rt2x00queue_initialize(struct rt2x00_dev *rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 97d9095..e7f544c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -89,7 +89,7 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 	memset(skbdesc, 0, sizeof(*skbdesc));
 	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
 
-	if (rt2x00dev->ops->lib->write_tx_data(rt2x00dev, queue, skb)) {
+	if (rt2x00queue_write_tx_frame(queue, skb)) {
 		WARNING(rt2x00dev, "Failed to send RTS/CTS frame.\n");
 		return NETDEV_TX_BUSY;
 	}
@@ -158,7 +158,7 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		}
 	}
 
-	if (rt2x00dev->ops->lib->write_tx_data(rt2x00dev, queue, skb)) {
+	if (rt2x00queue_write_tx_frame(queue, skb)) {
 		ieee80211_stop_queue(rt2x00dev->hw, qid);
 		return NETDEV_TX_BUSY;
 	}
@@ -166,9 +166,6 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (rt2x00queue_full(queue))
 		ieee80211_stop_queue(rt2x00dev->hw, qid);
 
-	if (rt2x00dev->ops->lib->kick_tx_queue)
-		rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, qid);
-
 	return NETDEV_TX_OK;
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_tx);
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index d508c80..83a35b1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -34,52 +34,40 @@
 /*
  * TX data handlers.
  */
-int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
-			    struct data_queue *queue, struct sk_buff *skb)
+int rt2x00pci_write_tx_data(struct queue_entry *entry)
 {
-	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
 	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
 	struct skb_frame_desc *skbdesc;
-	struct txentry_desc txdesc;
 	u32 word;
 
-	if (rt2x00queue_full(queue))
-		return -EINVAL;
-
 	rt2x00_desc_read(entry_priv->desc, 0, &word);
 
-	if (rt2x00_get_field32(word, TXD_ENTRY_OWNER_NIC) ||
-	    rt2x00_get_field32(word, TXD_ENTRY_VALID)) {
-		ERROR(rt2x00dev,
-		      "Arrived at non-free entry in the non-full queue %d.\n"
+	/*
+	 * This should not happen, we already checked the entry
+	 * was ours. When the hardware disagrees there has been
+	 * a queue corruption!
+	 */
+	if (unlikely(rt2x00_get_field32(word, TXD_ENTRY_OWNER_NIC) ||
+		     rt2x00_get_field32(word, TXD_ENTRY_VALID))) {
+		ERROR(entry->queue->rt2x00dev,
+		      "Corrupt queue %d, accessing entry which is not ours.\n"
 		      "Please file bug report to %s.\n",
 		      entry->queue->qid, DRV_PROJECT);
 		return -EINVAL;
 	}
 
 	/*
-	 * Copy all TX descriptor information into txdesc,
-	 * after that we are free to use the skb->cb array
-	 * for our information.
-	 */
-	entry->skb = skb;
-	rt2x00queue_create_tx_descriptor(entry, &txdesc);
-
-	/*
 	 * Fill in skb descriptor
 	 */
-	skbdesc = get_skb_frame_desc(skb);
+	skbdesc = get_skb_frame_desc(entry->skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->data = skb->data;
-	skbdesc->data_len = skb->len;
+	skbdesc->data = entry->skb->data;
+	skbdesc->data_len = entry->skb->len;
 	skbdesc->desc = entry_priv->desc;
-	skbdesc->desc_len = queue->desc_size;
+	skbdesc->desc_len = entry->queue->desc_size;
 	skbdesc->entry = entry;
 
-	memcpy(entry_priv->data, skb->data, skb->len);
-
-	rt2x00queue_write_tx_descriptor(entry, &txdesc);
-	rt2x00queue_index_inc(queue, Q_INDEX);
+	memcpy(entry_priv->data, entry->skb->data, entry->skb->len);
 
 	return 0;
 }
@@ -178,6 +166,7 @@ void rt2x00pci_txdone(struct rt2x00_dev *rt2x00dev, struct queue_entry *entry,
 	rt2x00_set_field32(&word, TXD_ENTRY_VALID, 0);
 	rt2x00_desc_write(entry_priv->desc, 0, word);
 
+	__clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
 	rt2x00queue_index_inc(entry->queue, Q_INDEX_DONE);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 37c851e..87c4a0c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -87,11 +87,14 @@ rt2x00pci_register_multiwrite(struct rt2x00_dev *rt2x00dev,
 	memcpy_toio(rt2x00dev->csr.base + offset, value, length);
 }
 
-/*
- * TX data handlers.
+/**
+ * rt2x00pci_write_tx_data - Initialize data for TX operation
+ * @entry: The entry where the frame is located
+ *
+ * This function will initialize the DMA and skb descriptor
+ * to prepare the entry for the actual TX operation.
  */
-int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
-			    struct data_queue *queue, struct sk_buff *skb);
+int rt2x00pci_write_tx_data(struct queue_entry *entry);
 
 /**
  * struct queue_entry_priv_pci: Per entry PCI specific information
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 6f3aa0f..f875b7a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -188,6 +188,43 @@ void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
 }
 EXPORT_SYMBOL_GPL(rt2x00queue_write_tx_descriptor);
 
+int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb)
+{
+	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
+	struct txentry_desc txdesc;
+
+	if (unlikely(rt2x00queue_full(queue)))
+		return -EINVAL;
+
+	if (__test_and_set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags)) {
+		ERROR(queue->rt2x00dev,
+		      "Arrived at non-free entry in the non-full queue %d.\n"
+		      "Please file bug report to %s.\n",
+		      queue->qid, DRV_PROJECT);
+		return -EINVAL;
+	}
+
+	/*
+	 * Copy all TX descriptor information into txdesc,
+	 * after that we are free to use the skb->cb array
+	 * for our information.
+	 */
+	entry->skb = skb;
+	rt2x00queue_create_tx_descriptor(entry, &txdesc);
+
+	if (unlikely(queue->rt2x00dev->ops->lib->write_tx_data(entry))) {
+		__clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
+		return -EIO;
+	}
+
+	__set_bit(ENTRY_DATA_PENDING, &entry->flags);
+
+	rt2x00queue_index_inc(queue, Q_INDEX);
+	rt2x00queue_write_tx_descriptor(entry, &txdesc);
+
+	return 0;
+}
+
 struct data_queue *rt2x00queue_get_queue(struct rt2x00_dev *rt2x00dev,
 					 const enum data_queue_qid queue)
 {
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index eff10b9..0d1be58 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -173,71 +173,42 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 		ieee80211_wake_queue(rt2x00dev->hw, qid);
 }
 
-int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
-			    struct data_queue *queue, struct sk_buff *skb)
+int rt2x00usb_write_tx_data(struct queue_entry *entry)
 {
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct usb_device *usb_dev = rt2x00dev_usb_dev(rt2x00dev);
-	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 	struct skb_frame_desc *skbdesc;
-	struct txentry_desc txdesc;
 	u32 length;
 
-	if (rt2x00queue_full(queue))
-		return -EINVAL;
-
-	if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags)) {
-		ERROR(rt2x00dev,
-		      "Arrived at non-free entry in the non-full queue %d.\n"
-		      "Please file bug report to %s.\n",
-		      entry->queue->qid, DRV_PROJECT);
-		return -EINVAL;
-	}
-
-	/*
-	 * Copy all TX descriptor information into txdesc,
-	 * after that we are free to use the skb->cb array
-	 * for our information.
-	 */
-	entry->skb = skb;
-	rt2x00queue_create_tx_descriptor(entry, &txdesc);
-
 	/*
 	 * Add the descriptor in front of the skb.
 	 */
-	skb_push(skb, queue->desc_size);
-	memset(skb->data, 0, queue->desc_size);
+	skb_push(entry->skb, entry->queue->desc_size);
+	memset(entry->skb->data, 0, entry->queue->desc_size);
 
 	/*
 	 * Fill in skb descriptor
 	 */
-	skbdesc = get_skb_frame_desc(skb);
+	skbdesc = get_skb_frame_desc(entry->skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->data = skb->data + queue->desc_size;
-	skbdesc->data_len = skb->len - queue->desc_size;
-	skbdesc->desc = skb->data;
-	skbdesc->desc_len = queue->desc_size;
+	skbdesc->data = entry->skb->data + entry->queue->desc_size;
+	skbdesc->data_len = entry->skb->len - entry->queue->desc_size;
+	skbdesc->desc = entry->skb->data;
+	skbdesc->desc_len = entry->queue->desc_size;
 	skbdesc->entry = entry;
 
-	rt2x00queue_write_tx_descriptor(entry, &txdesc);
-
 	/*
 	 * USB devices cannot blindly pass the skb->len as the
 	 * length of the data to usb_fill_bulk_urb. Pass the skb
 	 * to the driver to determine what the length should be.
 	 */
-	length = rt2x00dev->ops->lib->get_tx_data_len(rt2x00dev, skb);
-
-	/*
-	 * Initialize URB and send the frame to the device.
-	 */
-	__set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
-	__set_bit(ENTRY_DATA_PENDING, &entry->flags);
+	length = rt2x00dev->ops->lib->get_tx_data_len(rt2x00dev, entry->skb);
 
-	usb_fill_bulk_urb(entry_priv->urb, usb_dev, usb_sndbulkpipe(usb_dev, 1),
-			  skb->data, length, rt2x00usb_interrupt_txdone, entry);
-
-	rt2x00queue_index_inc(queue, Q_INDEX);
+	usb_fill_bulk_urb(entry_priv->urb, usb_dev,
+			  usb_sndbulkpipe(usb_dev, 1),
+			  entry->skb->data, length,
+			  rt2x00usb_interrupt_txdone, entry);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 460d32c..b1187c8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -212,11 +212,14 @@ static inline int rt2x00usb_eeprom_read(struct rt2x00_dev *rt2x00dev,
  */
 void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev);
 
-/*
- * TX data handlers.
+/**
+ * rt2x00usb_write_tx_data - Initialize URB for TX operation
+ * @entry: The entry where the frame is located
+ *
+ * This function will initialize the URB and skb descriptor
+ * to prepare the entry for the actual TX operation.
  */
-int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
-			    struct data_queue *queue, struct sk_buff *skb);
+int rt2x00usb_write_tx_data(struct queue_entry *entry);
 
 /**
  * struct queue_entry_priv_usb: Per entry USB specific information
-- 
1.5.5.3

