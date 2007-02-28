Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:48635 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485AbXB1OHb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:31 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562562nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:30 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 12/28] rt2x00: USB don't need preallocated DMA
Date: Wed, 28 Feb 2007 15:07:15 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.15450.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using a preallocated DMA buffer for USB devices,
it is sufficient to provide sk_buffs to it and let the USB
layer handle the rest. This makes the USB transfers a bit
simpler for us.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 1ea6696..c7ef5f8 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -256,32 +256,6 @@ static void rt2x00_eeprom_write(const struct rt2x00_dev *rt2x00dev,
 /*
  * TX/RX Descriptor access functions.
  */
-static inline struct urb* rt2x00_urb(struct data_entry *entry)
-{
-	return (struct urb*)entry->priv;
-}
-
-static inline void* rt2x00_rxdata_addr(struct data_entry *entry)
-{
-	return entry->data_addr;
-}
-
-static inline struct data_desc* rt2x00_rxdesc_addr(struct data_entry *entry)
-{
-	return entry->data_addr +
-		(rt2x00_urb(entry)->actual_length - entry->ring->desc_size);
-}
-
-static inline void* rt2x00_txdata_addr(struct data_entry *entry)
-{
-	return entry->data_addr + entry->ring->desc_size;
-}
-
-static inline struct data_desc* rt2x00_txdesc_addr(struct data_entry *entry)
-{
-	return entry->data_addr;
-}
-
 static inline void rt2x00_desc_read(struct data_desc *desc,
 	const u8 word, u32 *value)
 {
@@ -974,7 +948,6 @@ static int rt2500usb_alloc_dma_ring(struct rt2x00_dev *rt2x00dev,
 {
 	struct data_ring *ring = &rt2x00dev->ring[ring_type];
 	unsigned int i;
-	int status;
 
 	/*
 	 * Initialize work structure for deferred work.
@@ -994,38 +967,29 @@ static int rt2500usb_alloc_dma_ring(struct rt2x00_dev *rt2x00dev,
 		return -ENOMEM;
 
 	/*
-	 * Allocate DMA memory for descriptor and buffer.
-	 */
-	ring->data_addr = usb_buffer_alloc(
-		interface_to_usbdev(rt2x00dev_usb(rt2x00dev)),
-		rt2x00_get_ring_size(ring), GFP_KERNEL, &ring->data_dma);
-	if (!ring->data_addr) {
-		kfree(ring->entry);
-		return -ENOMEM;
-	}
-
-	/*
 	 * Initialize all ring entries to contain valid
 	 * addresses.
 	 */
-	status = 0;
 	for (i = 0; i < ring->stats.limit; i++) {
 		ring->entry[i].flags = 0;
 		ring->entry[i].ring = ring;
-		ring->entry[i].priv =
-			(!status) ? usb_alloc_urb(0, GFP_KERNEL) : NULL;
+		ring->entry[i].priv = usb_alloc_urb(0, GFP_KERNEL);
 		if (!ring->entry[i].priv)
-			status = -ENOMEM;
-		ring->entry[i].skb = NULL;
-		ring->entry[i].data_addr = ring->data_addr
-			+ (i * ring->desc_size)
-			+ (i * ring->data_size);
-		ring->entry[i].data_dma = ring->data_dma
-			+ (i * ring->desc_size)
-			+ (i * ring->data_size);
+			return -ENOMEM;
+
+		if (ring_type == RING_RX) {
+			ring->entry[i].skb = dev_alloc_skb(NET_IP_ALIGN +
+				ring->data_size + ring->desc_size);
+			if (!ring->entry[i].skb)
+				return -ENOMEM;
+
+			skb_reserve(ring->entry[i].skb, NET_IP_ALIGN);
+			skb_put(ring->entry[i].skb,
+				ring->data_size + ring->desc_size);
+		}
 	}
 
-	return status;
+	return 0;
 }
 
 static void rt2500usb_free_ring(struct rt2x00_dev *rt2x00dev,
@@ -1035,23 +999,17 @@ static void rt2500usb_free_ring(struct rt2x00_dev *rt2x00dev,
 	unsigned int i;
 
 	if (!ring->entry)
-		goto exit;
+		return;
 
 	for (i = 0; i < ring->stats.limit; i++) {
-		usb_kill_urb(rt2x00_urb(&ring->entry[i]));
-		usb_free_urb(rt2x00_urb(&ring->entry[i]));
+		usb_kill_urb(ring->entry[i].priv);
+		usb_free_urb(ring->entry[i].priv);
+		if (ring_type == RING_RX)
+			kfree_skb(ring->entry[i].skb);
 	}
 
 	kfree(ring->entry);
 	ring->entry = NULL;
-
-exit:
-	if (ring->data_addr)
-		usb_buffer_free(
-			interface_to_usbdev(rt2x00dev_usb(rt2x00dev)),
-			rt2x00_get_ring_size(ring), ring->data_addr,
-			ring->data_dma);
-	ring->data_addr = NULL;
 }
 
 static int rt2500usb_allocate_dma_rings(struct rt2x00_dev *rt2x00dev)
@@ -1092,22 +1050,17 @@ static void rt2500usb_init_rxring(struct rt2x00_dev *rt2x00dev,
 	struct data_ring *ring = &rt2x00dev->ring[ring_type];
 	struct usb_device *usb_dev =
 		interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
-	struct urb *urb;
 	unsigned int i;
 
 	ring->type = ring_type;
 
 	for (i = 0; i < ring->stats.limit; i++) {
-		urb = rt2x00_urb(&ring->entry[i]);
-
-		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
-		urb->transfer_dma = ring->entry[i].data_dma;
 		usb_fill_bulk_urb(
-			urb,
+			ring->entry[i].priv,
 			usb_dev,
 			usb_rcvbulkpipe(usb_dev, 1),
-			ring->entry[i].data_addr,
-			ring->data_size + ring->desc_size,
+			ring->entry[i].skb->data,
+			ring->entry[i].skb->len,
 			rt2500usb_interrupt,
 			&ring->entry[i]);
 	}
@@ -1119,18 +1072,12 @@ static void rt2500usb_init_txring(struct rt2x00_dev *rt2x00dev,
 	enum ring_index ring_type)
 {
 	struct data_ring *ring = &rt2x00dev->ring[ring_type];
-	struct urb *urb;
 	unsigned int i;
 
 	ring->type = ring_type;
 
-	for (i = 0; i < ring->stats.limit; i++) {
-		urb = rt2x00_urb(&ring->entry[i]);
-
-		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
-		urb->transfer_dma = ring->entry[i].data_dma;
+	for (i = 0; i < ring->stats.limit; i++)
 		CLEAR_FLAGS(&ring->entry[i]);
-	}
 
 	rt2x00_ring_index_clear(ring);
 }
@@ -1434,7 +1381,7 @@ static int rt2500usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 	ring = &rt2x00dev->ring[RING_RX];
 	for (i = 0; i < ring->stats.limit; i++) {
 		SET_FLAG(&ring->entry[i], ENTRY_OWNER_NIC);
-		usb_submit_urb(rt2x00_urb(&ring->entry[i]), GFP_ATOMIC);
+		usb_submit_urb(ring->entry[i].priv, GFP_ATOMIC);
 	}
 
 	/*
@@ -1488,23 +1435,23 @@ static void rt2500usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 
 	ring = &rt2x00dev->ring[RING_RX];
 	for (i = 0; i < ring->stats.limit; i++)
-		usb_kill_urb(rt2x00_urb(&ring->entry[i]));
+		usb_kill_urb(ring->entry[i].priv);
 
 	ring = &rt2x00dev->ring[RING_TX];
 	for (i = 0; i < ring->stats.limit; i++)
-		usb_kill_urb(rt2x00_urb(&ring->entry[i]));
+		usb_kill_urb(ring->entry[i].priv);
 
 	ring = &rt2x00dev->ring[RING_ATIM];
 	for (i = 0; i < ring->stats.limit; i++)
-		usb_kill_urb(rt2x00_urb(&ring->entry[i]));
+		usb_kill_urb(ring->entry[i].priv);
 
 	ring = &rt2x00dev->ring[RING_PRIO];
 	for (i = 0; i < ring->stats.limit; i++)
-		usb_kill_urb(rt2x00_urb(&ring->entry[i]));
+		usb_kill_urb(ring->entry[i].priv);
 
 	ring = &rt2x00dev->ring[RING_BEACON];
 	for (i = 0; i < ring->stats.limit; i++)
-		usb_kill_urb(rt2x00_urb(&ring->entry[i]));
+		usb_kill_urb(ring->entry[i].priv);
 }
 
 /*
@@ -1792,8 +1739,9 @@ static void rt2500usb_rxdone(struct work_struct *work)
 
 	while (1) {
 		entry = rt2x00_get_data_entry(ring);
-		rxd = rt2x00_rxdesc_addr(entry);
-		urb = rt2x00_urb(entry);
+		rxd = (struct data_desc*)
+			(entry->skb->data + urb->actual_length - ring->desc_size);
+		urb = entry->priv;
 		rt2x00_desc_read(rxd, 0, &word0);
 		rt2x00_desc_read(rxd, 1, &word1);
 
@@ -1827,9 +1775,10 @@ static void rt2500usb_rxdone(struct work_struct *work)
 				break;
 
 			skb_reserve(skb, NET_IP_ALIGN);
+			skb_put(skb, ring->data_size + ring->desc_size);
 
-			memcpy(skb_put(skb, size),
-				rt2x00_rxdata_addr(entry), size);
+			urb->transfer_buffer = skb->data;
+			urb->transfer_buffer_length = skb->len;
 
 			rt2x00dev->rx_status.rate = device_signal_to_rate(
 				&rt2x00dev->hwmodes[0],
@@ -1841,8 +1790,18 @@ static void rt2500usb_rxdone(struct work_struct *work)
 			rt2x00dev->rx_status.noise =
 				rt2x00_get_link_noise(&rt2x00dev->link);
 
+			/*
+			 * Received USB packets have 4 bytes of extra data,
+			 * Trim the skb_buffer to only contain the valid
+			 * frame data (so ignore the device's descriptor).
+			 */
+			size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
+			size -= FCS_LEN;
+			skb_trim(entry->skb, size);
+
 			__ieee80211_rx(rt2x00dev->hw,
-				skb, &rt2x00dev->rx_status);
+				entry->skb, &rt2x00dev->rx_status);
+			entry->skb = skb;
 
 			/*
 			 * Update link statistics
@@ -1878,8 +1837,8 @@ static void rt2500usb_txdone(struct work_struct *work)
 
 	 while (!rt2x00_ring_empty(ring)) {
 		entry = rt2x00_get_data_entry_done(ring);
-		txd = rt2x00_txdesc_addr(entry);
-		urb = rt2x00_urb(entry);
+		txd = (struct data_desc *)entry->skb->data;
+		urb = entry->priv;
 		rt2x00_desc_read(txd, 0, &word);
 
 		if (GET_FLAG(entry, ENTRY_OWNER_NIC))
@@ -1903,6 +1862,8 @@ static void rt2500usb_txdone(struct work_struct *work)
 		rt2x00_bbp_read(rt2x00dev, 0,
 			(u8*)&entry->tx_status.ack_signal);
 
+		skb_pull(entry->skb, ring->desc_size);
+
 		/*
 		 * If this is not an RTS frame send the tx_status to mac80211,
 		 * that method also cleans up the skb structure. When this
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 2285a64..98f6595 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -252,21 +252,6 @@ static void rt2x00_eeprom_write(const struct rt2x00_dev *rt2x00dev,
 /*
  * TX/RX Descriptor access functions.
  */
-static inline struct urb* rt2x00_urb(struct data_entry *entry)
-{
-	return (struct urb*)entry->priv;
-}
-
-static inline void* rt2x00_data_addr(struct data_entry *entry)
-{
-	return entry->data_addr + entry->ring->desc_size;
-}
-
-static inline struct data_desc* rt2x00_desc_addr(struct data_entry *entry)
-{
-	return entry->data_addr;
-}
-
 static inline void rt2x00_desc_read(struct data_desc *desc,
 	const u8 word, u32 *value)
 {
@@ -1204,7 +1189,6 @@ static int rt73usb_alloc_dma_ring(struct rt2x00_dev *rt2x00dev,
 {
 	struct data_ring *ring = &rt2x00dev->ring[ring_type];
 	unsigned int i;
-	int status;
 
 	/*
 	 * Initialize work structure for deferred work.
@@ -1224,38 +1208,29 @@ static int rt73usb_alloc_dma_ring(struct rt2x00_dev *rt2x00dev,
 		return -ENOMEM;
 
 	/*
-	 * Allocate DMA memory for descriptor and buffer.
-	 */
-	ring->data_addr = usb_buffer_alloc(
-		interface_to_usbdev(rt2x00dev_usb(rt2x00dev)),
-		rt2x00_get_ring_size(ring), GFP_KERNEL, &ring->data_dma);
-	if (!ring->data_addr) {
-		kfree(ring->entry);
-		return -ENOMEM;
-	}
-
-	/*
 	 * Initialize all ring entries to contain valid
 	 * addresses.
 	 */
-	status = 0;
 	for (i = 0; i < ring->stats.limit; i++) {
 		ring->entry[i].flags = 0;
 		ring->entry[i].ring = ring;
-		ring->entry[i].priv =
-			(!status) ? usb_alloc_urb(0, GFP_KERNEL) :  NULL;
+		ring->entry[i].priv = usb_alloc_urb(0, GFP_KERNEL);
 		if (!ring->entry[i].priv)
-			status = -ENOMEM;
-		ring->entry[i].skb = NULL;
-		ring->entry[i].data_addr = ring->data_addr
-			+ (i * ring->desc_size)
-			+ (i * ring->data_size);
-		ring->entry[i].data_dma = ring->data_dma
-			+ (i * ring->desc_size)
-			+ (i * ring->data_size);
+			return -ENOMEM;
+
+		if (ring_type == RING_RX) {
+			ring->entry[i].skb = dev_alloc_skb(NET_IP_ALIGN +
+				ring->data_size + ring->desc_size);
+			if (!ring->entry[i].skb)
+				return -ENOMEM;
+
+			skb_reserve(ring->entry[i].skb, NET_IP_ALIGN);
+			skb_put(ring->entry[i].skb,
+				ring->data_size + ring->desc_size);
+		}
 	}
 
-	return status;
+	return 0;
 }
 
 static void rt73usb_free_ring(struct rt2x00_dev *rt2x00dev,
@@ -1265,23 +1240,17 @@ static void rt73usb_free_ring(struct rt2x00_dev *rt2x00dev,
 	unsigned int i;
 
 	if (!ring->entry)
-		goto exit;
+		return;
 
 	for (i = 0; i < ring->stats.limit; i++) {
-		usb_kill_urb(rt2x00_urb(&ring->entry[i]));
-		usb_free_urb(rt2x00_urb(&ring->entry[i]));
+		usb_kill_urb(ring->entry[i].priv);
+		usb_free_urb(ring->entry[i].priv);
+		if (ring_type == RING_RX)
+			kfree_skb(ring->entry[i].skb);
 	}
 
 	kfree(ring->entry);
 	ring->entry = NULL;
-
-exit:
-	if (ring->data_addr)
-		usb_buffer_free(
-			interface_to_usbdev(rt2x00dev_usb(rt2x00dev)),
-			rt2x00_get_ring_size(ring), ring->data_addr,
-			ring->data_dma);
-	ring->data_addr = NULL;
 }
 
 static int rt73usb_allocate_dma_rings(struct rt2x00_dev *rt2x00dev)
@@ -1330,22 +1299,17 @@ static void rt73usb_init_rxring(struct rt2x00_dev *rt2x00dev,
 	struct data_ring *ring = &rt2x00dev->ring[ring_type];
 	struct usb_device *usb_dev =
 		interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
-	struct urb *urb;
 	unsigned int i;
 
 	ring->type = ring_type;
 
 	for (i = 0; i < ring->stats.limit; i++) {
-		urb = rt2x00_urb(&ring->entry[i]);
-
-		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
-		urb->transfer_dma = ring->entry[i].data_dma;
 		usb_fill_bulk_urb(
-			urb,
+			ring->entry[i].priv,
 			usb_dev,
 			usb_rcvbulkpipe(usb_dev, 1),
-			ring->entry[i].data_addr,
-			ring->data_size + ring->desc_size,
+			ring->entry[i].skb->data,
+			ring->entry[i].skb->len,
 			rt73usb_interrupt,
 			&ring->entry[i]);
 	}
@@ -1357,18 +1321,12 @@ static void rt73usb_init_txring(struct rt2x00_dev *rt2x00dev,
 	enum ring_index ring_type)
 {
 	struct data_ring *ring = &rt2x00dev->ring[ring_type];
-	struct urb *urb;
 	unsigned int i;
 
 	ring->type = ring_type;
 
-	for (i = 0; i < ring->stats.limit; i++) {
-		urb = rt2x00_urb(&ring->entry[i]);
-
-		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
-		urb->transfer_dma = ring->entry[i].data_dma;
+	for (i = 0; i < ring->stats.limit; i++)
 		CLEAR_FLAGS(&ring->entry[i]);
-	}
 
 	rt2x00_ring_index_clear(ring);
 }
@@ -1688,7 +1646,7 @@ static int rt73usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 	ring = &rt2x00dev->ring[RING_RX];
 	for (i = 0; i < ring->stats.limit; i++) {
 		SET_FLAG(&ring->entry[i], ENTRY_OWNER_NIC);
-		usb_submit_urb(rt2x00_urb(&ring->entry[i]), GFP_ATOMIC);
+		usb_submit_urb(ring->entry[i].priv, GFP_ATOMIC);
 	}
 
 	/*
@@ -1741,31 +1699,31 @@ static void rt73usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 
 	ring = &rt2x00dev->ring[RING_RX];
 	for (i = 0; i < ring->stats.limit; i++)
-		usb_kill_urb(rt2x00_urb(&ring->entry[i]));
+		usb_kill_urb(ring->entry[i].priv);
 
 	ring = &rt2x00dev->ring[RING_AC_VO];
 	for (i = 0; i < ring->stats.limit; i++)
-		usb_kill_urb(rt2x00_urb(&ring->entry[i]));
+		usb_kill_urb(ring->entry[i].priv);
 
 	ring = &rt2x00dev->ring[RING_AC_VI];
 	for (i = 0; i < ring->stats.limit; i++)
-		usb_kill_urb(rt2x00_urb(&ring->entry[i]));
+		usb_kill_urb(ring->entry[i].priv);
 
 	ring = &rt2x00dev->ring[RING_AC_BE];
 	for (i = 0; i < ring->stats.limit; i++)
-		usb_kill_urb(rt2x00_urb(&ring->entry[i]));
+		usb_kill_urb(ring->entry[i].priv);
 
 	ring = &rt2x00dev->ring[RING_AC_BK];
 	for (i = 0; i < ring->stats.limit; i++)
-		usb_kill_urb(rt2x00_urb(&ring->entry[i]));
+		usb_kill_urb(ring->entry[i].priv);
 
 	ring = &rt2x00dev->ring[RING_PRIO];
 	for (i = 0; i < ring->stats.limit; i++)
-		usb_kill_urb(rt2x00_urb(&ring->entry[i]));
+		usb_kill_urb(ring->entry[i].priv);
 
 	ring = &rt2x00dev->ring[RING_BEACON];
 	for (i = 0; i < ring->stats.limit; i++)
-		usb_kill_urb(rt2x00_urb(&ring->entry[i]));
+		usb_kill_urb(ring->entry[i].priv);
 }
 
 /*
@@ -2064,8 +2022,8 @@ static void rt73usb_rxdone(struct work_struct *work)
 
 	while (1) {
 		entry = rt2x00_get_data_entry(ring);
-		rxd = rt2x00_desc_addr(entry);
-		urb = rt2x00_urb(entry);
+		rxd = (struct data_desc*)entry->skb->data;
+		urb = entry->priv;
 		rt2x00_desc_read(rxd, 0, &word0);
 		rt2x00_desc_read(rxd, 1, &word1);
 
@@ -2095,9 +2053,10 @@ static void rt73usb_rxdone(struct work_struct *work)
 				break;
 
 			skb_reserve(skb, NET_IP_ALIGN);
+			skb_put(skb, ring->data_size + ring->desc_size);
 
-			memcpy(skb_put(skb, size),
-				rt2x00_data_addr(entry), size);
+			urb->transfer_buffer = skb->data;
+			urb->transfer_buffer_length = skb->len;
 
 			rt2x00dev->rx_status.rate = device_signal_to_rate(
 				&rt2x00dev->hwmodes[0],
@@ -2109,8 +2068,17 @@ static void rt73usb_rxdone(struct work_struct *work)
 			rt2x00dev->rx_status.noise =
 				rt2x00_get_link_noise(&rt2x00dev->link);
 
+			/*
+			 * Trim the skb_buffer to only contain the valid
+			 * frame data (so ignore the device's descriptor).
+			 */
+			size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
+			skb_pull(entry->skb, ring->desc_size);
+			skb_trim(entry->skb, size);
+
 			__ieee80211_rx(rt2x00dev->hw,
-				skb, &rt2x00dev->rx_status);
+				entry->skb, &rt2x00dev->rx_status);
+			entry->skb = skb;
 
 			/*
 			 * Update link statistics
@@ -2141,8 +2109,8 @@ static void rt73usb_txdone(struct work_struct *work)
 
 	while (!rt2x00_ring_empty(ring)) {
 		entry = rt2x00_get_data_entry_done(ring);
-		txd = rt2x00_desc_addr(entry);
-		urb = rt2x00_urb(entry);
+		txd = (struct data_desc *)entry->skb->data;
+		urb = entry->priv;
 		rt2x00_desc_read(txd, 0, &word);
 
 		if (GET_FLAG(entry, ENTRY_OWNER_NIC))
@@ -2166,6 +2134,8 @@ static void rt73usb_txdone(struct work_struct *work)
 		rt2x00_bbp_read(rt2x00dev, 32,
 			(u8*)&entry->tx_status.ack_signal);
 
+		skb_pull(entry->skb, ring->desc_size);
+
 		/*
 		 * If this is not an RTS frame send the tx_status to mac80211,
 		 * that method also cleans up the skb structure. When this
