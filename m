Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:1892 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132AbYFPRov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 13:44:51 -0400
Received: by wa-out-1112.google.com with SMTP id j37so4408775waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2008 10:44:51 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 6/9] rt2x00: Cleanup symbol exports
Date: Mon, 16 Jun 2008 19:56:54 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200806161954.04241.IvDoorn@gmail.com> <200806161956.08169.IvDoorn@gmail.com> <200806161956.31465.IvDoorn@gmail.com>
In-Reply-To: <200806161956.31465.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200806161956.54342.IvDoorn@gmail.com> (sfid-20080616_194504_350940_5BFA9490)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With a bit of code moving to rt2x00lib within the
TX and RX paths we can now remove a lot of EXPORT_SYMBOL_GPL()
statements. This cleans up the interface between rt2x00lib
and the drivers and has the additional benefit that rt2x00pci
and rt2x00usb are trimmed down in size as well since they
have less to do.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00.h      |   34 -------------------
 drivers/net/wireless/rt2x00/rt2x00dev.c   |   29 ++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00lib.h   |   51 +++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2x00pci.c   |   49 ---------------------------
 drivers/net/wireless/rt2x00/rt2x00pci.h   |    9 -----
 drivers/net/wireless/rt2x00/rt2x00queue.c |   15 ++++++--
 drivers/net/wireless/rt2x00/rt2x00queue.h |    2 +
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   42 ++++--------------------
 drivers/net/wireless/rt2x00/rt61pci.c     |    4 +-
 11 files changed, 102 insertions(+), 137 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index de2dd33..b3dffcf 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1154,7 +1154,7 @@ static void rt2400pci_txdone(struct rt2x00_dev *rt2x00dev,
 		}
 		txdesc.retry = rt2x00_get_field32(word, TXD_W0_RETRY_COUNT);
 
-		rt2x00pci_txdone(rt2x00dev, entry, &txdesc);
+		rt2x00lib_txdone(entry, &txdesc);
 	}
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 5077b62..0423c25 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1312,7 +1312,7 @@ static void rt2500pci_txdone(struct rt2x00_dev *rt2x00dev,
 		}
 		txdesc.retry = rt2x00_get_field32(word, TXD_W0_RETRY_COUNT);
 
-		rt2x00pci_txdone(rt2x00dev, entry, &txdesc);
+		rt2x00lib_txdone(entry, &txdesc);
 	}
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 28c9026..94b7c9b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -900,14 +900,6 @@ static inline u16 get_duration_res(const unsigned int size, const u8 rate)
 }
 
 /**
- * rt2x00queue_alloc_rxskb - allocate a skb for RX purposes.
- * @rt2x00dev: Pointer to &struct rt2x00_dev.
- * @queue: The queue for which the skb will be applicable.
- */
-struct sk_buff *rt2x00queue_alloc_rxskb(struct rt2x00_dev *rt2x00dev,
-					struct queue_entry *entry);
-
-/**
  * rt2x00queue_map_txskb - Map a skb into DMA for TX purposes.
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
  * @skb: The skb to map.
@@ -915,20 +907,6 @@ struct sk_buff *rt2x00queue_alloc_rxskb(struct rt2x00_dev *rt2x00dev,
 void rt2x00queue_map_txskb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
 
 /**
- * rt2x00queue_unmap_skb - Unmap a skb from DMA.
- * @rt2x00dev: Pointer to &struct rt2x00_dev.
- * @skb: The skb to unmap.
- */
-void rt2x00queue_unmap_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
-
-/**
- * rt2x00queue_free_skb - free a skb
- * @rt2x00dev: Pointer to &struct rt2x00_dev.
- * @skb: The skb to free.
- */
-void rt2x00queue_free_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
-
-/**
  * rt2x00queue_create_tx_descriptor - Create TX descriptor from mac80211 input
  * @entry: The entry which will be used to transfer the TX frame.
  * @txdesc: rt2x00 TX descriptor which will be initialized by this function.
@@ -977,18 +955,6 @@ struct data_queue *rt2x00queue_get_queue(struct rt2x00_dev *rt2x00dev,
 struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
 					  enum queue_index index);
 
-/**
- * rt2x00queue_index_inc - Index incrementation function
- * @queue: Queue (&struct data_queue) to perform the action on.
- * @index: Index type (&enum queue_index) to perform the action on.
- *
- * This function will increase the requested index on the queue,
- * it will grab the appropriate locks and handle queue overflow events by
- * resetting the index to the start of the queue.
- */
-void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index);
-
-
 /*
  * Interrupt context handlers.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 99b14ba..2a63a7b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -504,6 +504,12 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
+	enum data_queue_qid qid = skb_get_queue_mapping(entry->skb);
+
+	/*
+	 * Unmap the skb.
+	 */
+	rt2x00queue_unmap_skb(rt2x00dev, entry->skb);
 
 	/*
 	 * Send frame to debugfs immediately, after this call is completed
@@ -552,7 +558,25 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 		ieee80211_tx_status_irqsafe(rt2x00dev->hw, entry->skb);
 	else
 		dev_kfree_skb_irq(entry->skb);
+
+	/*
+	 * Make this entry available for reuse.
+	 */
 	entry->skb = NULL;
+	entry->flags = 0;
+
+	rt2x00dev->ops->lib->init_txentry(rt2x00dev, entry);
+
+	__clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
+	rt2x00queue_index_inc(entry->queue, Q_INDEX_DONE);
+
+	/*
+	 * If the data queue was below the threshold before the txdone
+	 * handler we must make sure the packet queue in the mac80211 stack
+	 * is reenabled when the txdone handler has finished.
+	 */
+	if (!rt2x00queue_threshold(entry->queue))
+		ieee80211_wake_queue(rt2x00dev->hw, qid);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_txdone);
 
@@ -657,6 +681,11 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 	 * Replace the skb with the freshly allocated one.
 	 */
 	entry->skb = skb;
+	entry->flags = 0;
+
+	rt2x00dev->ops->lib->init_rxentry(rt2x00dev, entry);
+
+	rt2x00queue_index_inc(entry->queue, Q_INDEX);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_rxdone);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 558f45b..1d1f074 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -98,10 +98,57 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 		      struct ieee80211_conf *conf, const int force_config);
 
-/*
- * Queue handlers.
+/**
+ * DOC: Queue handlers
+ */
+
+/**
+ * rt2x00queue_alloc_rxskb - allocate a skb for RX purposes.
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ * @queue: The queue for which the skb will be applicable.
+ */
+struct sk_buff *rt2x00queue_alloc_rxskb(struct rt2x00_dev *rt2x00dev,
+					struct queue_entry *entry);
+
+/**
+ * rt2x00queue_unmap_skb - Unmap a skb from DMA.
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ * @skb: The skb to unmap.
+ */
+void rt2x00queue_unmap_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
+
+/**
+ * rt2x00queue_free_skb - free a skb
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ * @skb: The skb to free.
+ */
+void rt2x00queue_free_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
+
+/**
+ * rt2x00queue_free_skb - free a skb
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ * @skb: The skb to free.
+ */
+void rt2x00queue_free_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
+
+/**
+ * rt2x00queue_write_tx_frame - Write TX frame to hardware
+ * @queue: Queue over which the frame should be send
+ * @skb: The skb to send
  */
 int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb);
+
+/**
+ * rt2x00queue_index_inc - Index incrementation function
+ * @queue: Queue (&struct data_queue) to perform the action on.
+ * @index: Index type (&enum queue_index) to perform the action on.
+ *
+ * This function will increase the requested index on the queue,
+ * it will grab the appropriate locks and handle queue overflow events by
+ * resetting the index to the start of the queue.
+ */
+void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index);
+
 void rt2x00queue_init_rx(struct rt2x00_dev *rt2x00dev);
 void rt2x00queue_init_tx(struct rt2x00_dev *rt2x00dev);
 int rt2x00queue_initialize(struct rt2x00_dev *rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index f9d0d76..adf2876 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -60,12 +60,8 @@ int rt2x00pci_write_tx_data(struct queue_entry *entry)
 	 * Fill in skb descriptor
 	 */
 	skbdesc = get_skb_frame_desc(entry->skb);
-	memset(skbdesc, 0, sizeof(*skbdesc));
 	skbdesc->desc = entry_priv->desc;
 	skbdesc->desc_len = entry->queue->desc_size;
-	skbdesc->entry = entry;
-
-	rt2x00queue_map_txskb(entry->queue->rt2x00dev, entry->skb);
 
 	return 0;
 }
@@ -101,55 +97,10 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 		 * Send the frame to rt2x00lib for further processing.
 		 */
 		rt2x00lib_rxdone(rt2x00dev, entry);
-
-		/*
-		 * Reset the RXD for this entry.
-		 */
-		rt2x00dev->ops->lib->init_rxentry(rt2x00dev, entry);
-
-		rt2x00queue_index_inc(queue, Q_INDEX);
 	}
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_rxdone);
 
-void rt2x00pci_txdone(struct rt2x00_dev *rt2x00dev, struct queue_entry *entry,
-		      struct txdone_entry_desc *txdesc)
-{
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
-	enum data_queue_qid qid = skb_get_queue_mapping(entry->skb);
-	u32 word;
-
-	/*
-	 * Unmap the skb.
-	 */
-	rt2x00queue_unmap_skb(rt2x00dev, entry->skb);
-
-	rt2x00lib_txdone(entry, txdesc);
-
-	/*
-	 * Make this entry available for reuse.
-	 */
-	entry->flags = 0;
-
-	rt2x00_desc_read(entry_priv->desc, 0, &word);
-	rt2x00_set_field32(&word, TXD_ENTRY_OWNER_NIC, 0);
-	rt2x00_set_field32(&word, TXD_ENTRY_VALID, 0);
-	rt2x00_desc_write(entry_priv->desc, 0, word);
-
-	__clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
-	rt2x00queue_index_inc(entry->queue, Q_INDEX_DONE);
-
-	/*
-	 * If the data queue was below the threshold before the txdone
-	 * handler we must make sure the packet queue in the mac80211 stack
-	 * is reenabled when the txdone handler has finished.
-	 */
-	if (!rt2x00queue_threshold(entry->queue))
-		ieee80211_wake_queue(rt2x00dev->hw, qid);
-
-}
-EXPORT_SYMBOL_GPL(rt2x00pci_txdone);
-
 /*
  * Device initialization handlers.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 7e5708d..50c6df4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -115,15 +115,6 @@ struct queue_entry_priv_pci {
  */
 void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev);
 
-/**
- * rt2x00pci_txdone - Handle TX done events
- * @rt2x00dev: Device pointer, see &struct rt2x00_dev.
- * @entry: Entry which has completed the transmission of a frame.
- * @desc: TX done descriptor
- */
-void rt2x00pci_txdone(struct rt2x00_dev *rt2x00dev, struct queue_entry *entry,
-		      struct txdone_entry_desc *desc);
-
 /*
  * Device initialization handlers.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 29d2b91..49d3bb8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -77,7 +77,6 @@ struct sk_buff *rt2x00queue_alloc_rxskb(struct rt2x00_dev *rt2x00dev,
 
 	return skb;
 }
-EXPORT_SYMBOL_GPL(rt2x00queue_alloc_rxskb);
 
 void rt2x00queue_map_txskb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 {
@@ -105,7 +104,6 @@ void rt2x00queue_unmap_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 		skbdesc->flags &= ~SKBDESC_DMA_MAPPED_TX;
 	}
 }
-EXPORT_SYMBOL_GPL(rt2x00queue_unmap_skb);
 
 void rt2x00queue_free_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 {
@@ -123,7 +121,6 @@ void rt2x00queue_free_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 
 	dev_kfree_skb_any(skb);
 }
-EXPORT_SYMBOL_GPL(rt2x00queue_free_skb);
 
 void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 				      struct txentry_desc *txdesc)
@@ -289,6 +286,7 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb)
 {
 	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
 	struct txentry_desc txdesc;
+	struct skb_frame_desc *skbdesc;
 
 	if (unlikely(rt2x00queue_full(queue)))
 		return -EINVAL;
@@ -309,11 +307,21 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb)
 	entry->skb = skb;
 	rt2x00queue_create_tx_descriptor(entry, &txdesc);
 
+	/*
+	 * skb->cb array is now ours and we are free to use it.
+	 */
+	skbdesc = get_skb_frame_desc(entry->skb);
+	memset(skbdesc, 0, sizeof(*skbdesc));
+	skbdesc->entry = entry;
+
 	if (unlikely(queue->rt2x00dev->ops->lib->write_tx_data(entry))) {
 		__clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
 		return -EIO;
 	}
 
+	if (test_bit(DRIVER_REQUIRE_DMA, &queue->rt2x00dev->flags))
+		rt2x00queue_map_txskb(queue->rt2x00dev, skb);
+
 	__set_bit(ENTRY_DATA_PENDING, &entry->flags);
 
 	rt2x00queue_index_inc(queue, Q_INDEX);
@@ -389,7 +397,6 @@ void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index)
 
 	spin_unlock_irqrestore(&queue->lock, irqflags);
 }
-EXPORT_SYMBOL_GPL(rt2x00queue_index_inc);
 
 static void rt2x00queue_reset(struct data_queue *queue)
 {
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 192b6e7..14ce8d4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -82,6 +82,8 @@ enum data_queue_qid {
 /**
  * enum skb_frame_desc_flags: Flags for &struct skb_frame_desc
  *
+ * @SKBDESC_DMA_MAPPED_RX: &skb_dma field has been mapped for RX
+ * @SKBDESC_DMA_MAPPED_TX: &skb_dma field has been mapped for TX
  */
 enum skb_frame_desc_flags {
 	SKBDESC_DMA_MAPPED_RX = (1 << 0),
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 552f0e9..b94c461 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -131,10 +131,9 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	struct queue_entry *entry = (struct queue_entry *)urb->context;
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct txdone_entry_desc txdesc;
-	enum data_queue_qid qid = skb_get_queue_mapping(entry->skb);
 
 	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags) ||
-	    !__test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+	    !test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
 		return;
 
 	/*
@@ -158,20 +157,6 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	txdesc.retry = 0;
 
 	rt2x00lib_txdone(entry, &txdesc);
-
-	/*
-	 * Make this entry available for reuse.
-	 */
-	entry->flags = 0;
-	rt2x00queue_index_inc(entry->queue, Q_INDEX_DONE);
-
-	/*
-	 * If the data queue was below the threshold before the txdone
-	 * handler we must make sure the packet queue in the mac80211 stack
-	 * is reenabled when the txdone handler has finished.
-	 */
-	if (!rt2x00queue_threshold(entry->queue))
-		ieee80211_wake_queue(rt2x00dev->hw, qid);
 }
 
 int rt2x00usb_write_tx_data(struct queue_entry *entry)
@@ -193,10 +178,8 @@ int rt2x00usb_write_tx_data(struct queue_entry *entry)
 	 * Fill in skb descriptor
 	 */
 	skbdesc = get_skb_frame_desc(entry->skb);
-	memset(skbdesc, 0, sizeof(*skbdesc));
 	skbdesc->desc = entry->skb->data;
 	skbdesc->desc_len = entry->queue->desc_size;
-	skbdesc->entry = entry;
 
 	/*
 	 * USB devices cannot blindly pass the skb->len as the
@@ -270,7 +253,7 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	u8 rxd[32];
 
 	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags) ||
-	    !test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+	    !test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
 		return;
 
 	/*
@@ -278,8 +261,11 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	 * to be actually valid, or if the urb is signaling
 	 * a problem.
 	 */
-	if (urb->actual_length < entry->queue->desc_size || urb->status)
-		goto skip_entry;
+	if (urb->actual_length < entry->queue->desc_size || urb->status) {
+		__set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
+		usb_submit_urb(urb, GFP_ATOMIC);
+		return;
+	}
 
 	/*
 	 * Fill in desc fields of the skb descriptor
@@ -291,20 +277,6 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	 * Send the frame to rt2x00lib for further processing.
 	 */
 	rt2x00lib_rxdone(rt2x00dev, entry);
-
-	/*
-	 * Reinitialize the urb.
-	 */
-	urb->transfer_buffer = entry->skb->data;
-	urb->transfer_buffer_length = entry->skb->len;
-
-skip_entry:
-	if (test_bit(DEVICE_ENABLED_RADIO, &entry->queue->rt2x00dev->flags)) {
-		__set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
-		usb_submit_urb(urb, GFP_ATOMIC);
-	}
-
-	rt2x00queue_index_inc(entry->queue, Q_INDEX);
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index c9f6d48..bbf1048 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1767,7 +1767,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 			__set_bit(TXDONE_UNKNOWN, &txdesc.flags);
 			txdesc.retry = 0;
 
-			rt2x00pci_txdone(rt2x00dev, entry_done, &txdesc);
+			rt2x00lib_txdone(entry_done, &txdesc);
 			entry_done = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
 		}
 
@@ -1787,7 +1787,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 		}
 		txdesc.retry = rt2x00_get_field32(reg, STA_CSR4_RETRY_COUNT);
 
-		rt2x00pci_txdone(rt2x00dev, entry, &txdesc);
+		rt2x00lib_txdone(entry, &txdesc);
 	}
 }
 
-- 
1.5.5.4

