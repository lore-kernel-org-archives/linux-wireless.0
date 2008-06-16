Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:44224 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352AbYFPRot (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 13:44:49 -0400
Received: by py-out-1112.google.com with SMTP id p76so2084597pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2008 10:44:49 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 5/9] rt2x00: Replace statically allocated DMA buffers with mapped skb's.
Date: Mon, 16 Jun 2008 19:56:31 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200806161954.04241.IvDoorn@gmail.com> <200806161955.43378.IvDoorn@gmail.com> <200806161956.08169.IvDoorn@gmail.com>
In-Reply-To: <200806161956.08169.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806161956.31465.IvDoorn@gmail.com> (sfid-20080616_194502_270637_AC05BA0D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>

The current PCI drivers require a lot of pre-allocated DMA buffers. Reduce this
by using dynamically mapped skb's (using pci_map_single) instead of the pre-
allocated DMA buffers that are allocated at device start-up time.

At the same time move common RX path code into rt2x00lib from rt2x00pci and
rt2x00usb, as the RX paths now are now almost the same.

Signed-off-by: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |   13 ++--
 drivers/net/wireless/rt2x00/rt2500pci.c   |   10 ++-
 drivers/net/wireless/rt2x00/rt2x00.h      |   28 +++++-
 drivers/net/wireless/rt2x00/rt2x00dev.c   |   64 ++++++++++-----
 drivers/net/wireless/rt2x00/rt2x00pci.c   |  125 ++++++++---------------------
 drivers/net/wireless/rt2x00/rt2x00pci.h   |    3 -
 drivers/net/wireless/rt2x00/rt2x00queue.c |   85 +++++++++++++++++---
 drivers/net/wireless/rt2x00/rt2x00queue.h |   16 ++--
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   27 +-----
 drivers/net/wireless/rt2x00/rt61pci.c     |    9 +-
 10 files changed, 204 insertions(+), 176 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 76ec151..de2dd33 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -632,15 +632,15 @@ static void rt2400pci_init_rxentry(struct rt2x00_dev *rt2x00dev,
 				   struct queue_entry *entry)
 {
 	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	u32 word;
 
 	rt2x00_desc_read(entry_priv->desc, 2, &word);
-	rt2x00_set_field32(&word, RXD_W2_BUFFER_LENGTH,
-			   entry->queue->data_size);
+	rt2x00_set_field32(&word, RXD_W2_BUFFER_LENGTH, entry->skb->len);
 	rt2x00_desc_write(entry_priv->desc, 2, word);
 
 	rt2x00_desc_read(entry_priv->desc, 1, &word);
-	rt2x00_set_field32(&word, RXD_W1_BUFFER_ADDRESS, entry_priv->data_dma);
+	rt2x00_set_field32(&word, RXD_W1_BUFFER_ADDRESS, skbdesc->skb_dma);
 	rt2x00_desc_write(entry_priv->desc, 1, word);
 
 	rt2x00_desc_read(entry_priv->desc, 0, &word);
@@ -1012,7 +1012,7 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 * Start writing the descriptor words.
 	 */
 	rt2x00_desc_read(entry_priv->desc, 1, &word);
-	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, entry_priv->data_dma);
+	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, skbdesc->skb_dma);
 	rt2x00_desc_write(entry_priv->desc, 1, word);
 
 	rt2x00_desc_read(txd, 2, &word);
@@ -1412,9 +1412,10 @@ static int rt2400pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	rt2400pci_probe_hw_mode(rt2x00dev);
 
 	/*
-	 * This device requires the atim queue
+	 * This device requires the atim queue and DMA-mapped skbs.
 	 */
 	__set_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags);
+	__set_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
@@ -1526,7 +1527,7 @@ static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * Write entire beacon with descriptor to register,
 	 * and kick the beacon generator.
 	 */
-	memcpy(entry_priv->data, skb->data, skb->len);
+	rt2x00queue_map_txskb(rt2x00dev, intf->beacon->skb);
 	rt2x00queue_write_tx_descriptor(intf->beacon, &txdesc);
 	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, QID_BEACON);
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 5f0117f..5077b62 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -727,10 +727,11 @@ static void rt2500pci_init_rxentry(struct rt2x00_dev *rt2x00dev,
 				   struct queue_entry *entry)
 {
 	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	u32 word;
 
 	rt2x00_desc_read(entry_priv->desc, 1, &word);
-	rt2x00_set_field32(&word, RXD_W1_BUFFER_ADDRESS, entry_priv->data_dma);
+	rt2x00_set_field32(&word, RXD_W1_BUFFER_ADDRESS, skbdesc->skb_dma);
 	rt2x00_desc_write(entry_priv->desc, 1, word);
 
 	rt2x00_desc_read(entry_priv->desc, 0, &word);
@@ -1171,7 +1172,7 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 * Start writing the descriptor words.
 	 */
 	rt2x00_desc_read(entry_priv->desc, 1, &word);
-	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, entry_priv->data_dma);
+	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, skbdesc->skb_dma);
 	rt2x00_desc_write(entry_priv->desc, 1, word);
 
 	rt2x00_desc_read(txd, 2, &word);
@@ -1752,9 +1753,10 @@ static int rt2500pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	rt2500pci_probe_hw_mode(rt2x00dev);
 
 	/*
-	 * This device requires the atim queue
+	 * This device requires the atim queue and DMA-mapped skbs.
 	 */
 	__set_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags);
+	__set_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
@@ -1842,7 +1844,7 @@ static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * Write entire beacon with descriptor to register,
 	 * and kick the beacon generator.
 	 */
-	memcpy(entry_priv->data, skb->data, skb->len);
+	rt2x00queue_map_txskb(rt2x00dev, intf->beacon->skb);
 	rt2x00queue_write_tx_descriptor(intf->beacon, &txdesc);
 	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, QID_BEACON);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 08e8b0a..28c9026 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -601,6 +601,7 @@ enum rt2x00_flags {
 	DRIVER_REQUIRE_BEACON_GUARD,
 	DRIVER_REQUIRE_ATIM_QUEUE,
 	DRIVER_REQUIRE_SCHEDULED,
+	DRIVER_REQUIRE_DMA,
 
 	/*
 	 * Driver configuration
@@ -899,16 +900,33 @@ static inline u16 get_duration_res(const unsigned int size, const u8 rate)
 }
 
 /**
- * rt2x00queue_alloc_skb - allocate a skb.
+ * rt2x00queue_alloc_rxskb - allocate a skb for RX purposes.
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
  * @queue: The queue for which the skb will be applicable.
  */
-struct sk_buff *rt2x00queue_alloc_skb(struct data_queue *queue);
+struct sk_buff *rt2x00queue_alloc_rxskb(struct rt2x00_dev *rt2x00dev,
+					struct queue_entry *entry);
+
+/**
+ * rt2x00queue_map_txskb - Map a skb into DMA for TX purposes.
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ * @skb: The skb to map.
+ */
+void rt2x00queue_map_txskb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
+
+/**
+ * rt2x00queue_unmap_skb - Unmap a skb from DMA.
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ * @skb: The skb to unmap.
+ */
+void rt2x00queue_unmap_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
 
 /**
  * rt2x00queue_free_skb - free a skb
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
  * @skb: The skb to free.
  */
-void rt2x00queue_free_skb(struct sk_buff *skb);
+void rt2x00queue_free_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
 
 /**
  * rt2x00queue_create_tx_descriptor - Create TX descriptor from mac80211 input
@@ -977,8 +995,8 @@ void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index);
 void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev);
 void rt2x00lib_txdone(struct queue_entry *entry,
 		      struct txdone_entry_desc *txdesc);
-void rt2x00lib_rxdone(struct queue_entry *entry,
-		      struct rxdone_entry_desc *rxdesc);
+void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
+		      struct queue_entry *entry);
 
 /*
  * mac80211 handlers.
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index b8e0c4c..99b14ba 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -468,6 +468,7 @@ static void rt2x00lib_intf_scheduled(struct work_struct *work)
 static void rt2x00lib_beacondone_iter(void *data, u8 *mac,
 				      struct ieee80211_vif *vif)
 {
+	struct rt2x00_dev *rt2x00dev = data;
 	struct rt2x00_intf *intf = vif_to_intf(vif);
 
 	if (vif->type != IEEE80211_IF_TYPE_AP &&
@@ -477,7 +478,7 @@ static void rt2x00lib_beacondone_iter(void *data, u8 *mac,
 	/*
 	 * Clean up the beacon skb.
 	 */
-	dev_kfree_skb_irq(intf->beacon->skb);
+	rt2x00queue_free_skb(rt2x00dev, intf->beacon->skb);
 	intf->beacon->skb = NULL;
 
 	spin_lock(&intf->lock);
@@ -555,34 +556,55 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_txdone);
 
-void rt2x00lib_rxdone(struct queue_entry *entry,
-		      struct rxdone_entry_desc *rxdesc)
+void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
+		      struct queue_entry *entry)
 {
-	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct rxdone_entry_desc rxdesc;
+	struct sk_buff *skb;
 	struct ieee80211_rx_status *rx_status = &rt2x00dev->rx_status;
-	unsigned int header_size = ieee80211_get_hdrlen_from_skb(entry->skb);
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_hdr *hdr;
 	const struct rt2x00_rate *rate;
+	unsigned int header_size;
 	unsigned int align;
 	unsigned int i;
 	int idx = -1;
 
 	/*
+	 * Allocate a new sk_buffer. If no new buffer available, drop the
+	 * received frame and reuse the existing buffer.
+	 */
+	skb = rt2x00queue_alloc_rxskb(rt2x00dev, entry);
+	if (!skb)
+		return;
+
+	/*
+	 * Unmap the skb.
+	 */
+	rt2x00queue_unmap_skb(rt2x00dev, entry->skb);
+
+	/*
+	 * Extract the RXD details.
+	 */
+	memset(&rxdesc, 0, sizeof(rxdesc));
+	rt2x00dev->ops->lib->fill_rxdone(entry, &rxdesc);
+
+	/*
 	 * The data behind the ieee80211 header must be
 	 * aligned on a 4 byte boundary.
 	 */
+	header_size = ieee80211_get_hdrlen_from_skb(entry->skb);
 	align = ((unsigned long)(entry->skb->data + header_size)) & 3;
 
 	if (align) {
 		skb_push(entry->skb, align);
 		/* Move entire frame in 1 command */
 		memmove(entry->skb->data, entry->skb->data + align,
-			rxdesc->size);
+			rxdesc.size);
 	}
 
 	/* Update data pointers, trim buffer to correct size */
-	skb_trim(entry->skb, rxdesc->size);
+	skb_trim(entry->skb, rxdesc.size);
 
 	/*
 	 * Update RX statistics.
@@ -591,10 +613,10 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 	for (i = 0; i < sband->n_bitrates; i++) {
 		rate = rt2x00_get_rate(sband->bitrates[i].hw_value);
 
-		if (((rxdesc->dev_flags & RXDONE_SIGNAL_PLCP) &&
-		     (rate->plcp == rxdesc->signal)) ||
-		    (!(rxdesc->dev_flags & RXDONE_SIGNAL_PLCP) &&
-		      (rate->bitrate == rxdesc->signal))) {
+		if (((rxdesc.dev_flags & RXDONE_SIGNAL_PLCP) &&
+		     (rate->plcp == rxdesc.signal)) ||
+		    (!(rxdesc.dev_flags & RXDONE_SIGNAL_PLCP) &&
+		      (rate->bitrate == rxdesc.signal))) {
 			idx = i;
 			break;
 		}
@@ -602,8 +624,8 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 
 	if (idx < 0) {
 		WARNING(rt2x00dev, "Frame received with unrecognized signal,"
-			"signal=0x%.2x, plcp=%d.\n", rxdesc->signal,
-			!!(rxdesc->dev_flags & RXDONE_SIGNAL_PLCP));
+			"signal=0x%.2x, plcp=%d.\n", rxdesc.signal,
+			!!(rxdesc.dev_flags & RXDONE_SIGNAL_PLCP));
 		idx = 0;
 	}
 
@@ -612,16 +634,16 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 	 */
 	hdr = (struct ieee80211_hdr *)entry->skb->data;
 	if (ieee80211_is_beacon(hdr->frame_control) &&
-	    (rxdesc->dev_flags & RXDONE_MY_BSS))
-		rt2x00lib_update_link_stats(&rt2x00dev->link, rxdesc->rssi);
+	    (rxdesc.dev_flags & RXDONE_MY_BSS))
+		rt2x00lib_update_link_stats(&rt2x00dev->link, rxdesc.rssi);
 
 	rt2x00dev->link.qual.rx_success++;
 
 	rx_status->rate_idx = idx;
 	rx_status->qual =
-	    rt2x00lib_calculate_link_signal(rt2x00dev, rxdesc->rssi);
-	rx_status->signal = rxdesc->rssi;
-	rx_status->flag = rxdesc->flags;
+	    rt2x00lib_calculate_link_signal(rt2x00dev, rxdesc.rssi);
+	rx_status->signal = rxdesc.rssi;
+	rx_status->flag = rxdesc.flags;
 	rx_status->antenna = rt2x00dev->link.ant.active.rx;
 
 	/*
@@ -630,7 +652,11 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 	 */
 	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_RXDONE, entry->skb);
 	ieee80211_rx_irqsafe(rt2x00dev->hw, entry->skb, rx_status);
-	entry->skb = NULL;
+
+	/*
+	 * Replace the skb with the freshly allocated one.
+	 */
+	entry->skb = skb;
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_rxdone);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index e7e3a45..f9d0d76 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -65,7 +65,7 @@ int rt2x00pci_write_tx_data(struct queue_entry *entry)
 	skbdesc->desc_len = entry->queue->desc_size;
 	skbdesc->entry = entry;
 
-	memcpy(entry_priv->data, entry->skb->data, entry->skb->len);
+	rt2x00queue_map_txskb(entry->queue->rt2x00dev, entry->skb);
 
 	return 0;
 }
@@ -74,59 +74,12 @@ EXPORT_SYMBOL_GPL(rt2x00pci_write_tx_data);
 /*
  * TX/RX data handlers.
  */
-static void rt2x00pci_rxdone_entry(struct rt2x00_dev *rt2x00dev,
-				   struct queue_entry *entry)
-{
-	struct sk_buff *skb;
-	struct skb_frame_desc *skbdesc;
-	struct rxdone_entry_desc rxdesc;
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
-
-	/*
-	 * Allocate a new sk_buffer. If no new buffer available, drop the
-	 * received frame and reuse the existing buffer.
-	 */
-	skb = rt2x00queue_alloc_skb(entry->queue);
-	if (!skb)
-		return;
-
-	/*
-	 * Extract the RXD details.
-	 */
-	memset(&rxdesc, 0, sizeof(rxdesc));
-	rt2x00dev->ops->lib->fill_rxdone(entry, &rxdesc);
-
-	/*
-	 * Copy the received data to the entries' skb.
-	 */
-	memcpy(entry->skb->data, entry_priv->data, rxdesc.size);
-	skb_trim(entry->skb, rxdesc.size);
-
-	/*
-	 * Fill in skb descriptor
-	 */
-	skbdesc = get_skb_frame_desc(entry->skb);
-	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->desc = entry_priv->desc;
-	skbdesc->desc_len = entry->queue->desc_size;
-	skbdesc->entry = entry;
-
-	/*
-	 * Send the frame to rt2x00lib for further processing.
-	 */
-	rt2x00lib_rxdone(entry, &rxdesc);
-
-	/*
-	 * Replace the entries' skb with the newly allocated one.
-	 */
-	entry->skb = skb;
-}
-
 void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue = rt2x00dev->rx;
 	struct queue_entry *entry;
 	struct queue_entry_priv_pci *entry_priv;
+	struct skb_frame_desc *skbdesc;
 	u32 word;
 
 	while (1) {
@@ -137,12 +90,22 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 		if (rt2x00_get_field32(word, RXD_ENTRY_OWNER_NIC))
 			break;
 
-		rt2x00pci_rxdone_entry(rt2x00dev, entry);
+		/*
+		 * Fill in desc fields of the skb descriptor
+		 */
+		skbdesc = get_skb_frame_desc(entry->skb);
+		skbdesc->desc = entry_priv->desc;
+		skbdesc->desc_len = entry->queue->desc_size;
+
+		/*
+		 * Send the frame to rt2x00lib for further processing.
+		 */
+		rt2x00lib_rxdone(rt2x00dev, entry);
 
-		if (test_bit(DEVICE_ENABLED_RADIO, &queue->rt2x00dev->flags)) {
-			rt2x00_set_field32(&word, RXD_ENTRY_OWNER_NIC, 1);
-			rt2x00_desc_write(entry_priv->desc, 0, word);
-		}
+		/*
+		 * Reset the RXD for this entry.
+		 */
+		rt2x00dev->ops->lib->init_rxentry(rt2x00dev, entry);
 
 		rt2x00queue_index_inc(queue, Q_INDEX);
 	}
@@ -156,6 +119,11 @@ void rt2x00pci_txdone(struct rt2x00_dev *rt2x00dev, struct queue_entry *entry,
 	enum data_queue_qid qid = skb_get_queue_mapping(entry->skb);
 	u32 word;
 
+	/*
+	 * Unmap the skb.
+	 */
+	rt2x00queue_unmap_skb(rt2x00dev, entry->skb);
+
 	rt2x00lib_txdone(entry, txdesc);
 
 	/*
@@ -185,33 +153,6 @@ EXPORT_SYMBOL_GPL(rt2x00pci_txdone);
 /*
  * Device initialization handlers.
  */
-#define desc_size(__queue)			\
-({						\
-	 ((__queue)->limit * (__queue)->desc_size);\
-})
-
-#define data_size(__queue)			\
-({						\
-	 ((__queue)->limit * (__queue)->data_size);\
-})
-
-#define dma_size(__queue)			\
-({						\
-	data_size(__queue) + desc_size(__queue);\
-})
-
-#define desc_offset(__queue, __base, __i)	\
-({						\
-	(__base) + data_size(__queue) + 	\
-	    ((__i) * (__queue)->desc_size);	\
-})
-
-#define data_offset(__queue, __base, __i)	\
-({						\
-	(__base) +				\
-	    ((__i) * (__queue)->data_size);	\
-})
-
 static int rt2x00pci_alloc_queue_dma(struct rt2x00_dev *rt2x00dev,
 				     struct data_queue *queue)
 {
@@ -223,22 +164,21 @@ static int rt2x00pci_alloc_queue_dma(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Allocate DMA memory for descriptor and buffer.
 	 */
-	addr = dma_alloc_coherent(rt2x00dev->dev, dma_size(queue), &dma,
-				  GFP_KERNEL | GFP_DMA);
+	addr = dma_alloc_coherent(rt2x00dev->dev,
+				  queue->limit * queue->desc_size,
+				  &dma, GFP_KERNEL | GFP_DMA);
 	if (!addr)
 		return -ENOMEM;
 
-	memset(addr, 0, dma_size(queue));
+	memset(addr, 0, queue->limit * queue->desc_size);
 
 	/*
 	 * Initialize all queue entries to contain valid addresses.
 	 */
 	for (i = 0; i < queue->limit; i++) {
 		entry_priv = queue->entries[i].priv_data;
-		entry_priv->desc = desc_offset(queue, addr, i);
-		entry_priv->desc_dma = desc_offset(queue, dma, i);
-		entry_priv->data = data_offset(queue, addr, i);
-		entry_priv->data_dma = data_offset(queue, dma, i);
+		entry_priv->desc = addr + i * queue->desc_size;
+		entry_priv->desc_dma = dma + i * queue->desc_size;
 	}
 
 	return 0;
@@ -250,10 +190,11 @@ static void rt2x00pci_free_queue_dma(struct rt2x00_dev *rt2x00dev,
 	struct queue_entry_priv_pci *entry_priv =
 	    queue->entries[0].priv_data;
 
-	if (entry_priv->data)
-		dma_free_coherent(rt2x00dev->dev, dma_size(queue),
-				  entry_priv->data, entry_priv->data_dma);
-	entry_priv->data = NULL;
+	if (entry_priv->desc)
+		dma_free_coherent(rt2x00dev->dev,
+				  queue->limit * queue->desc_size,
+				  entry_priv->desc, entry_priv->desc_dma);
+	entry_priv->desc = NULL;
 }
 
 int rt2x00pci_initialize(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 87c4a0c..7e5708d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -107,9 +107,6 @@ int rt2x00pci_write_tx_data(struct queue_entry *entry);
 struct queue_entry_priv_pci {
 	__le32 *desc;
 	dma_addr_t desc_dma;
-
-	void *data;
-	dma_addr_t data_dma;
 };
 
 /**
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 278f1a1..29d2b91 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -25,21 +25,24 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/dma-mapping.h>
 
 #include "rt2x00.h"
 #include "rt2x00lib.h"
 
-struct sk_buff *rt2x00queue_alloc_skb(struct data_queue *queue)
+struct sk_buff *rt2x00queue_alloc_rxskb(struct rt2x00_dev *rt2x00dev,
+					struct queue_entry *entry)
 {
-	struct sk_buff *skb;
 	unsigned int frame_size;
 	unsigned int reserved_size;
+	struct sk_buff *skb;
+	struct skb_frame_desc *skbdesc;
 
 	/*
 	 * The frame size includes descriptor size, because the
 	 * hardware directly receive the frame into the skbuffer.
 	 */
-	frame_size = queue->data_size + queue->desc_size;
+	frame_size = entry->queue->data_size + entry->queue->desc_size;
 
 	/*
 	 * Reserve a few bytes extra headroom to allow drivers some moving
@@ -57,12 +60,67 @@ struct sk_buff *rt2x00queue_alloc_skb(struct data_queue *queue)
 	skb_reserve(skb, reserved_size);
 	skb_put(skb, frame_size);
 
+	/*
+	 * Populate skbdesc.
+	 */
+	skbdesc = get_skb_frame_desc(skb);
+	memset(skbdesc, 0, sizeof(*skbdesc));
+	skbdesc->entry = entry;
+
+	if (test_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags)) {
+		skbdesc->skb_dma = dma_map_single(rt2x00dev->dev,
+						  skb->data,
+						  skb->len,
+						  DMA_FROM_DEVICE);
+		skbdesc->flags |= SKBDESC_DMA_MAPPED_RX;
+	}
+
 	return skb;
 }
-EXPORT_SYMBOL_GPL(rt2x00queue_alloc_skb);
+EXPORT_SYMBOL_GPL(rt2x00queue_alloc_rxskb);
 
-void rt2x00queue_free_skb(struct sk_buff *skb)
+void rt2x00queue_map_txskb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 {
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
+
+	skbdesc->skb_dma = dma_map_single(rt2x00dev->dev, skb->data, skb->len,
+					  DMA_TO_DEVICE);
+	skbdesc->flags |= SKBDESC_DMA_MAPPED_TX;
+}
+EXPORT_SYMBOL_GPL(rt2x00queue_map_txskb);
+
+void rt2x00queue_unmap_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
+{
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
+
+	if (skbdesc->flags & SKBDESC_DMA_MAPPED_RX) {
+		dma_unmap_single(rt2x00dev->dev, skbdesc->skb_dma, skb->len,
+				 DMA_FROM_DEVICE);
+		skbdesc->flags &= ~SKBDESC_DMA_MAPPED_RX;
+	}
+
+	if (skbdesc->flags & SKBDESC_DMA_MAPPED_TX) {
+		dma_unmap_single(rt2x00dev->dev, skbdesc->skb_dma, skb->len,
+				 DMA_TO_DEVICE);
+		skbdesc->flags &= ~SKBDESC_DMA_MAPPED_TX;
+	}
+}
+EXPORT_SYMBOL_GPL(rt2x00queue_unmap_skb);
+
+void rt2x00queue_free_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
+{
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
+
+	if (skbdesc->flags & SKBDESC_DMA_MAPPED_RX) {
+		dma_unmap_single(rt2x00dev->dev, skbdesc->skb_dma, skb->len,
+				 DMA_FROM_DEVICE);
+	}
+
+	if (skbdesc->flags & SKBDESC_DMA_MAPPED_TX) {
+		dma_unmap_single(rt2x00dev->dev, skbdesc->skb_dma, skb->len,
+				 DMA_TO_DEVICE);
+	}
+
 	dev_kfree_skb_any(skb);
 }
 EXPORT_SYMBOL_GPL(rt2x00queue_free_skb);
@@ -421,7 +479,8 @@ static int rt2x00queue_alloc_entries(struct data_queue *queue,
 	return 0;
 }
 
-static void rt2x00queue_free_skbs(struct data_queue *queue)
+static void rt2x00queue_free_skbs(struct rt2x00_dev *rt2x00dev,
+				  struct data_queue *queue)
 {
 	unsigned int i;
 
@@ -430,27 +489,27 @@ static void rt2x00queue_free_skbs(struct data_queue *queue)
 
 	for (i = 0; i < queue->limit; i++) {
 		if (queue->entries[i].skb)
-			rt2x00queue_free_skb(queue->entries[i].skb);
+			rt2x00queue_free_skb(rt2x00dev, queue->entries[i].skb);
 	}
 }
 
-static int rt2x00queue_alloc_skbs(struct data_queue *queue)
+static int rt2x00queue_alloc_rxskbs(struct rt2x00_dev *rt2x00dev,
+				    struct data_queue *queue)
 {
 	unsigned int i;
 	struct sk_buff *skb;
 
 	for (i = 0; i < queue->limit; i++) {
-		skb = rt2x00queue_alloc_skb(queue);
+		skb = rt2x00queue_alloc_rxskb(rt2x00dev, &queue->entries[i]);
 		if (!skb)
 			goto exit;
-
 		queue->entries[i].skb = skb;
 	}
 
 	return 0;
 
 exit:
-	rt2x00queue_free_skbs(queue);
+	rt2x00queue_free_skbs(rt2x00dev, queue);
 
 	return -ENOMEM;
 }
@@ -481,7 +540,7 @@ int rt2x00queue_initialize(struct rt2x00_dev *rt2x00dev)
 			goto exit;
 	}
 
-	status = rt2x00queue_alloc_skbs(rt2x00dev->rx);
+	status = rt2x00queue_alloc_rxskbs(rt2x00dev, rt2x00dev->rx);
 	if (status)
 		goto exit;
 
@@ -499,7 +558,7 @@ void rt2x00queue_uninitialize(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
 
-	rt2x00queue_free_skbs(rt2x00dev->rx);
+	rt2x00queue_free_skbs(rt2x00dev, rt2x00dev->rx);
 
 	queue_for_each(rt2x00dev, queue) {
 		kfree(queue->entries);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index fcf5252..192b6e7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -83,9 +83,10 @@ enum data_queue_qid {
  * enum skb_frame_desc_flags: Flags for &struct skb_frame_desc
  *
  */
-//enum skb_frame_desc_flags {
-//	TEMPORARILY EMPTY
-//};
+enum skb_frame_desc_flags {
+	SKBDESC_DMA_MAPPED_RX = (1 << 0),
+	SKBDESC_DMA_MAPPED_TX = (1 << 1),
+};
 
 /**
  * struct skb_frame_desc: Descriptor information for the skb buffer
@@ -94,19 +95,20 @@ enum data_queue_qid {
  * this structure should not exceed the size of that array (40 bytes).
  *
  * @flags: Frame flags, see &enum skb_frame_desc_flags.
- * @data: Pointer to data part of frame (Start of ieee80211 header).
+ * @desc_len: Length of the frame descriptor.
  * @desc: Pointer to descriptor part of the frame.
  *	Note that this pointer could point to something outside
  *	of the scope of the skb->data pointer.
- * @data_len: Length of the frame data.
- * @desc_len: Length of the frame descriptor.
+ * @skb_dma: (PCI-only) the DMA address associated with the sk buffer.
  * @entry: The entry to which this sk buffer belongs.
  */
 struct skb_frame_desc {
 	unsigned int flags;
 
-	void *desc;
 	unsigned int desc_len;
+	void *desc;
+
+	dma_addr_t skb_dma;
 
 	struct queue_entry *entry;
 };
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 29dba86..552f0e9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -266,9 +266,7 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 {
 	struct queue_entry *entry = (struct queue_entry *)urb->context;
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct sk_buff *skb;
-	struct skb_frame_desc *skbdesc;
-	struct rxdone_entry_desc rxdesc;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	u8 rxd[32];
 
 	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags) ||
@@ -284,36 +282,19 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 		goto skip_entry;
 
 	/*
-	 * Fill in skb descriptor
+	 * Fill in desc fields of the skb descriptor
 	 */
-	skbdesc = get_skb_frame_desc(entry->skb);
-	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->entry = entry;
 	skbdesc->desc = rxd;
 	skbdesc->desc_len = entry->queue->desc_size;
 
-	memset(&rxdesc, 0, sizeof(rxdesc));
-	rt2x00dev->ops->lib->fill_rxdone(entry, &rxdesc);
-
-	/*
-	 * Allocate a new sk buffer to replace the current one.
-	 * If allocation fails, we should drop the current frame
-	 * so we can recycle the existing sk buffer for the new frame.
-	 */
-	skb = rt2x00queue_alloc_skb(entry->queue);
-	if (!skb)
-		goto skip_entry;
-
 	/*
 	 * Send the frame to rt2x00lib for further processing.
 	 */
-	rt2x00lib_rxdone(entry, &rxdesc);
+	rt2x00lib_rxdone(rt2x00dev, entry);
 
 	/*
-	 * Replace current entry's skb with the newly allocated one,
-	 * and reinitialize the urb.
+	 * Reinitialize the urb.
 	 */
-	entry->skb = skb;
 	urb->transfer_buffer = entry->skb->data;
 	urb->transfer_buffer_length = entry->skb->len;
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 2a7f306..c9f6d48 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1030,11 +1030,12 @@ static void rt61pci_init_rxentry(struct rt2x00_dev *rt2x00dev,
 				 struct queue_entry *entry)
 {
 	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	u32 word;
 
 	rt2x00_desc_read(entry_priv->desc, 5, &word);
 	rt2x00_set_field32(&word, RXD_W5_BUFFER_PHYSICAL_ADDRESS,
-			   entry_priv->data_dma);
+			   skbdesc->skb_dma);
 	rt2x00_desc_write(entry_priv->desc, 5, word);
 
 	rt2x00_desc_read(entry_priv->desc, 0, &word);
@@ -1522,7 +1523,6 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	struct queue_entry_priv_pci *entry_priv = skbdesc->entry->priv_data;
 	__le32 *txd = skbdesc->desc;
 	u32 word;
 
@@ -1557,7 +1557,7 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00_desc_read(txd, 6, &word);
 	rt2x00_set_field32(&word, TXD_W6_BUFFER_PHYSICAL_ADDRESS,
-			   entry_priv->data_dma);
+			   skbdesc->skb_dma);
 	rt2x00_desc_write(txd, 6, word);
 
 	if (skbdesc->desc_len > TXINFO_SIZE) {
@@ -2302,9 +2302,10 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	rt61pci_probe_hw_mode(rt2x00dev);
 
 	/*
-	 * This device requires firmware.
+	 * This device requires firmware and DMA mapped skbs.
 	 */
 	__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
+	__set_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
-- 
1.5.5.4

