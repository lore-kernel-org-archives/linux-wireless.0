Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:1117 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757646Ab0EMJhH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 05:37:07 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH v2 10/10] rt2x00: Properly reserve room for descriptors in skbs.
Date: Thu, 13 May 2010 11:36:58 +0200
Message-Id: <1273743418-28383-11-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1273743418-28383-1-git-send-email-gwingerde@gmail.com>
References: <1273743418-28383-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of fiddling with the skb->data pointer and thereby risking
out of bounds accesses, properly reserve the space needed in an
skb for descriptors.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c   |   14 ++++++----
 drivers/net/wireless/rt2x00/rt2800lib.c   |    3 +-
 drivers/net/wireless/rt2x00/rt2800lib.h   |    2 +-
 drivers/net/wireless/rt2x00/rt2800pci.c   |   23 ++++++++--------
 drivers/net/wireless/rt2x00/rt2800usb.c   |   22 +++++++++------
 drivers/net/wireless/rt2x00/rt2x00.h      |    7 +++++
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    5 ---
 drivers/net/wireless/rt2x00/rt2x00lib.h   |    7 -----
 drivers/net/wireless/rt2x00/rt2x00pci.c   |   40 +++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00pci.h   |    8 ++++++
 drivers/net/wireless/rt2x00/rt2x00queue.c |   24 +----------------
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   11 +++----
 drivers/net/wireless/rt2x00/rt61pci.c     |    4 +-
 drivers/net/wireless/rt2x00/rt73usb.c     |   14 ++++++----
 16 files changed, 109 insertions(+), 79 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 66cff04..641459b 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1227,7 +1227,7 @@ static void rt2400pci_txdone(struct rt2x00_dev *rt2x00dev,
 		}
 		txdesc.retry = rt2x00_get_field32(word, TXD_W0_RETRY_COUNT);
 
-		rt2x00lib_txdone(entry, &txdesc);
+		rt2x00pci_txdone(entry, &txdesc);
 	}
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index d30811c..c8363bc 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1363,7 +1363,7 @@ static void rt2500pci_txdone(struct rt2x00_dev *rt2x00dev,
 		}
 		txdesc.retry = rt2x00_get_field32(word, TXD_W0_RETRY_COUNT);
 
-		rt2x00lib_txdone(entry, &txdesc);
+		rt2x00pci_txdone(entry, &txdesc);
 	}
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index dfaa948..eb99934 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1033,7 +1033,7 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	__le32 *txd = (__le32 *)(skb->data - TXD_DESC_SIZE);
+	__le32 *txd = (__le32 *) skb->data;
 	u32 word;
 
 	/*
@@ -1079,6 +1079,7 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Register descriptor details in skb frame descriptor.
 	 */
+	skbdesc->flags |= SKBDESC_DESC_IN_SKB;
 	skbdesc->desc = txd;
 	skbdesc->desc_len = TXD_DESC_SIZE;
 }
@@ -1107,6 +1108,12 @@ static void rt2500usb_write_beacon(struct queue_entry *entry,
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
 
 	/*
+	 * Add space for the descriptor in front of the skb.
+	 */
+	skb_push(entry->skb, TXD_DESC_SIZE);
+	memset(entry->skb->data, 0, TXD_DESC_SIZE);
+
+	/*
 	 * Write the TX descriptor for the beacon.
 	 */
 	rt2500usb_write_tx_desc(rt2x00dev, entry->skb, txdesc);
@@ -1117,11 +1124,6 @@ static void rt2500usb_write_beacon(struct queue_entry *entry,
 	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
 
 	/*
-	 * Take the descriptor in front of the skb into account.
-	 */
-	skb_push(entry->skb, TXD_DESC_SIZE);
-
-	/*
 	 * USB devices cannot blindly pass the skb->len as the
 	 * length of the data to usb_fill_bulk_urb. Pass the skb
 	 * to the driver to determine what the length should be.
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 7410ac1..53a3257 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -281,9 +281,8 @@ int rt2800_wait_wpdma_ready(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2800_wait_wpdma_ready);
 
-void rt2800_write_txwi(struct sk_buff *skb, struct txentry_desc *txdesc)
+void rt2800_write_txwi(__le32 *txwi, struct txentry_desc *txdesc)
 {
-	__le32 *txwi = (__le32 *)(skb->data - TXWI_DESC_SIZE);
 	u32 word;
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 94de999..0f0a13c 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -111,7 +111,7 @@ void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
 			const u8 command, const u8 token,
 			const u8 arg0, const u8 arg1);
 
-void rt2800_write_txwi(struct sk_buff *skb, struct txentry_desc *txdesc);
+void rt2800_write_txwi(__le32 *txwi, struct txentry_desc *txdesc);
 void rt2800_process_rxwi(struct sk_buff *skb, struct rxdone_entry_desc *txdesc);
 
 extern const struct rt2x00debug rt2800_rt2x00debug;
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 72e4f29..db61a78 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -616,7 +616,7 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 static void rt2800pci_write_tx_datadesc(struct queue_entry* entry,
 					 struct txentry_desc *txdesc)
 {
-	rt2800_write_txwi(entry->skb, txdesc);
+	rt2800_write_txwi((__le32 *) entry->skb->data, txdesc);
 }
 
 
@@ -693,15 +693,22 @@ static void rt2800pci_write_beacon(struct queue_entry *entry,
 	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
 	/*
+	 * Add space for the TXWI in front of the skb.
+	 */
+	skb_push(entry->skb, TXWI_DESC_SIZE);
+	memset(entry->skb, 0, TXWI_DESC_SIZE);
+
+	/*
 	 * Register descriptor details in skb frame descriptor.
 	 */
-	skbdesc->desc = entry->skb->data - TXWI_DESC_SIZE;
+	skbdesc->flags |= SKBDESC_DESC_IN_SKB;
+	skbdesc->desc = entry->skb->data;
 	skbdesc->desc_len = TXWI_DESC_SIZE;
 
 	/*
 	 * Add the TXWI for the beacon to the skb.
 	 */
-	rt2800_write_txwi(entry->skb, txdesc);
+	rt2800_write_txwi((__le32 *)entry->skb->data, txdesc);
 
 	/*
 	 * Dump beacon to userspace through debugfs.
@@ -709,11 +716,6 @@ static void rt2800pci_write_beacon(struct queue_entry *entry,
 	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
 
 	/*
-	 * Adjust skb to take TXWI into account.
-	 */
-	skb_push(entry->skb, TXWI_DESC_SIZE);
-
-	/*
 	 * Write entire beacon with TXWI to register.
 	 */
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
@@ -888,8 +890,7 @@ static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 
 		/* Check if we got a match by looking at WCID/ACK/PID
 		 * fields */
-		txwi = (__le32 *)(entry->skb->data -
-				  rt2x00dev->ops->extra_tx_headroom);
+		txwi = (__le32 *) entry->skb->data;
 
 		rt2x00_desc_read(txwi, 1, &word);
 		tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
@@ -934,7 +935,7 @@ static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 		__set_bit(TXDONE_FALLBACK, &txdesc.flags);
 
 
-		rt2x00lib_txdone(entry, &txdesc);
+		rt2x00pci_txdone(entry, &txdesc);
 	}
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 2ac1386..33d7ac9 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -400,13 +400,14 @@ static void rt2800usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	__le32 *txi = (__le32 *)(skb->data - TXWI_DESC_SIZE - TXINFO_DESC_SIZE);
+	__le32 *txi = (__le32 *) skb->data;
+	__le32 *txwi = (__le32 *) (skb->data + TXINFO_DESC_SIZE);
 	u32 word;
 
 	/*
 	 * Initialize TXWI descriptor
 	 */
-	rt2800_write_txwi(skb, txdesc);
+	rt2800_write_txwi(txwi, txdesc);
 
 	/*
 	 * Initialize TXINFO descriptor
@@ -426,6 +427,7 @@ static void rt2800usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Register descriptor details in skb frame descriptor.
 	 */
+	skbdesc->flags |= SKBDESC_DESC_IN_SKB;
 	skbdesc->desc = txi;
 	skbdesc->desc_len = TXINFO_DESC_SIZE + TXWI_DESC_SIZE;
 }
@@ -450,15 +452,22 @@ static void rt2800usb_write_beacon(struct queue_entry *entry,
 	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
 	/*
+	 * Add space for the TXWI in front of the skb.
+	 */
+	skb_push(entry->skb, TXWI_DESC_SIZE);
+	memset(entry->skb, 0, TXWI_DESC_SIZE);
+
+	/*
 	 * Register descriptor details in skb frame descriptor.
 	 */
-	skbdesc->desc = entry->skb->data - TXWI_DESC_SIZE;
+	skbdesc->flags |= SKBDESC_DESC_IN_SKB;
+	skbdesc->desc = entry->skb->data;
 	skbdesc->desc_len = TXWI_DESC_SIZE;
 
 	/*
 	 * Add the TXWI for the beacon to the skb.
 	 */
-	rt2800_write_txwi(entry->skb, txdesc);
+	rt2800_write_txwi((__le32 *) entry->skb->data, txdesc);
 
 	/*
 	 * Dump beacon to userspace through debugfs.
@@ -466,11 +475,6 @@ static void rt2800usb_write_beacon(struct queue_entry *entry,
 	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
 
 	/*
-	 * Adjust skb to take TXWI into account.
-	 */
-	skb_push(entry->skb, TXWI_DESC_SIZE);
-
-	/*
 	 * Write entire beacon with descriptor to register.
 	 */
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index d27127a..ae0aa07 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1001,6 +1001,13 @@ static inline bool rt2x00_is_soc(struct rt2x00_dev *rt2x00dev)
 void rt2x00queue_map_txskb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
 
 /**
+ * rt2x00queue_unmap_skb - Unmap a skb from DMA.
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ * @skb: The skb to unmap.
+ */
+void rt2x00queue_unmap_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
+
+/**
  * rt2x00queue_get_queue - Convert queue index to queue pointer
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
  * @queue: rt2x00 queue index (see &enum data_queue_qid).
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 33c2f5f..6790441 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -210,11 +210,6 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	bool success;
 
 	/*
-	 * Unmap the skb.
-	 */
-	rt2x00queue_unmap_skb(rt2x00dev, entry->skb);
-
-	/*
 	 * Remove L2 padding which was added during
 	 */
 	if (test_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags))
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 0ca40e1..822affc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -105,13 +105,6 @@ struct sk_buff *rt2x00queue_alloc_rxskb(struct rt2x00_dev *rt2x00dev,
 					struct queue_entry *entry);
 
 /**
- * rt2x00queue_unmap_skb - Unmap a skb from DMA.
- * @rt2x00dev: Pointer to &struct rt2x00_dev.
- * @skb: The skb to unmap.
- */
-void rt2x00queue_unmap_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
-
-/**
  * rt2x00queue_free_skb - free a skb
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
  * @skb: The skb to free.
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 714c982..19b8683 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -81,11 +81,23 @@ int rt2x00pci_write_tx_data(struct queue_entry *entry,
 	}
 
 	/*
+	 * Add the requested extra tx headroom in front of the skb.
+	 */
+	skb_push(entry->skb, rt2x00dev->ops->extra_tx_headroom);
+	memset(entry->skb->data, 0, rt2x00dev->ops->extra_tx_headroom);
+
+	/*
 	 * Call the driver's write_tx_datadesc function, if it exists.
 	 */
 	if (rt2x00dev->ops->lib->write_tx_datadesc)
 		rt2x00dev->ops->lib->write_tx_datadesc(entry, txdesc);
 
+	/*
+	 * Map the skb to DMA.
+	 */
+	if (test_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags))
+		rt2x00queue_map_txskb(rt2x00dev, entry->skb);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_write_tx_data);
@@ -93,6 +105,34 @@ EXPORT_SYMBOL_GPL(rt2x00pci_write_tx_data);
 /*
  * TX/RX data handlers.
  */
+void rt2x00pci_txdone(struct queue_entry *entry,
+		      struct txdone_entry_desc *txdesc)
+{
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+
+	/*
+	 * Unmap the skb.
+	 */
+	rt2x00queue_unmap_skb(rt2x00dev, entry->skb);
+
+	/*
+	 * Remove the extra tx headroom from the skb.
+	 */
+	skb_pull(entry->skb, rt2x00dev->ops->extra_tx_headroom);
+
+	/*
+	 * Signal that the TX descriptor is no longer in the skb.
+	 */
+	skbdesc->flags &= ~SKBDESC_DESC_IN_SKB;
+
+	/*
+	 * Pass on to rt2x00lib.
+	 */
+	rt2x00lib_txdone(entry, txdesc);
+}
+EXPORT_SYMBOL_GPL(rt2x00pci_txdone);
+
 void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue = rt2x00dev->rx;
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 51bcef3..00528b8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -109,6 +109,14 @@ struct queue_entry_priv_pci {
 };
 
 /**
+ * rt2x00pci_txdone - Handle TX done events.
+ * @entry: The queue entry for which a TX done event was received.
+ * @txdesc: The TX done descriptor for the entry.
+ */
+void rt2x00pci_txdone(struct queue_entry *entry,
+		      struct txdone_entry_desc *txdesc);
+
+/**
  * rt2x00pci_rxdone - Handle RX done events
  * @rt2x00dev: Device pointer, see &struct rt2x00_dev.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 9e48bbc..bcdbf95 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -99,21 +99,8 @@ void rt2x00queue_map_txskb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
 
-	/*
-	 * If device has requested headroom, we should make sure that
-	 * is also mapped to the DMA so it can be used for transfering
-	 * additional descriptor information to the hardware.
-	 */
-	skb_push(skb, rt2x00dev->ops->extra_tx_headroom);
-
 	skbdesc->skb_dma =
 	    dma_map_single(rt2x00dev->dev, skb->data, skb->len, DMA_TO_DEVICE);
-
-	/*
-	 * Restore data pointer to original location again.
-	 */
-	skb_pull(skb, rt2x00dev->ops->extra_tx_headroom);
-
 	skbdesc->flags |= SKBDESC_DMA_MAPPED_TX;
 }
 EXPORT_SYMBOL_GPL(rt2x00queue_map_txskb);
@@ -129,16 +116,12 @@ void rt2x00queue_unmap_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 	}
 
 	if (skbdesc->flags & SKBDESC_DMA_MAPPED_TX) {
-		/*
-		 * Add headroom to the skb length, it has been removed
-		 * by the driver, but it was actually mapped to DMA.
-		 */
-		dma_unmap_single(rt2x00dev->dev, skbdesc->skb_dma,
-				 skb->len + rt2x00dev->ops->extra_tx_headroom,
+		dma_unmap_single(rt2x00dev->dev, skbdesc->skb_dma, skb->len,
 				 DMA_TO_DEVICE);
 		skbdesc->flags &= ~SKBDESC_DMA_MAPPED_TX;
 	}
 }
+EXPORT_SYMBOL_GPL(rt2x00queue_unmap_skb);
 
 void rt2x00queue_free_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 {
@@ -533,9 +516,6 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 		return -EIO;
 	}
 
-	if (test_bit(DRIVER_REQUIRE_DMA, &queue->rt2x00dev->flags))
-		rt2x00queue_map_txskb(queue->rt2x00dev, skb);
-
 	set_bit(ENTRY_DATA_PENDING, &entry->flags);
 
 	rt2x00queue_index_inc(queue, Q_INDEX);
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index bcc9483..1f72c59 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -197,6 +197,11 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 		return;
 
 	/*
+	 * Remove the descriptor from the front of the skb.
+	 */
+	skb_pull(entry->skb, entry->queue->desc_size);
+
+	/*
 	 * Obtain the status about this packet.
 	 * Note that when the status is 0 it does not mean the
 	 * frame was send out correctly. It only means the frame
@@ -242,12 +247,6 @@ int rt2x00usb_write_tx_data(struct queue_entry *entry,
 			  rt2x00usb_interrupt_txdone, entry);
 
 	/*
-	 * Make sure the skb->data pointer points to the frame, not the
-	 * descriptor.
-	 */
-	skb_pull(entry->skb, entry->queue->desc_size);
-
-	/*
 	 * Call the driver's write_tx_datadesc function, if it exists.
 	 */
 	if (rt2x00dev->ops->lib->write_tx_datadesc)
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 643202f..9ac2f5c 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2108,7 +2108,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 			__set_bit(TXDONE_UNKNOWN, &txdesc.flags);
 			txdesc.retry = 0;
 
-			rt2x00lib_txdone(entry_done, &txdesc);
+			rt2x00pci_txdone(entry_done, &txdesc);
 			entry_done = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
 		}
 
@@ -2128,7 +2128,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 		}
 		txdesc.retry = rt2x00_get_field32(reg, STA_CSR4_RETRY_COUNT);
 
-		rt2x00lib_txdone(entry, &txdesc);
+		rt2x00pci_txdone(entry, &txdesc);
 	}
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index dcc46a2..a9738ee 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1440,7 +1440,7 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				  struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	__le32 *txd = (__le32 *)(skb->data - TXD_DESC_SIZE);
+	__le32 *txd = (__le32 *) skb->data;
 	u32 word;
 
 	/*
@@ -1503,6 +1503,7 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Register descriptor details in skb frame descriptor.
 	 */
+	skbdesc->flags |= SKBDESC_DESC_IN_SKB;
 	skbdesc->desc = txd;
 	skbdesc->desc_len = TXD_DESC_SIZE;
 }
@@ -1526,6 +1527,12 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
 	rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
 
 	/*
+	 * Add space for the descriptor in front of the skb.
+	 */
+	skb_push(entry->skb, TXD_DESC_SIZE);
+	memset(entry->skb->data, 0, TXD_DESC_SIZE);
+
+	/*
 	 * Write the TX descriptor for the beacon.
 	 */
 	rt73usb_write_tx_desc(rt2x00dev, entry->skb, txdesc);
@@ -1536,11 +1543,6 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
 	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
 
 	/*
-	 * Take the descriptor in front of the skb into account.
-	 */
-	skb_push(entry->skb, TXD_DESC_SIZE);
-
-	/*
 	 * Write entire beacon with descriptor to register.
 	 */
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
-- 
1.7.1

