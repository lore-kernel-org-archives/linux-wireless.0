Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:48611 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451AbXB1OHU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:20 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562551nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:19 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 17/28] rt2x00: Make USB work in interrupt context
Date: Wed, 28 Feb 2007 15:07:10 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.10408.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

USB devices will no longer schedule their interrupt tasks to a later
time. Instead the interrupt handlers will be called immediately when
an interrupt is being raised.
For PCI devices this is only done for beacondone handling, (although
the other interrupts are also under consideration...).
Also the interrupt handlers should make use of rt2x00lib for the
statistics updating.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index 18e615c..c50cd80 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -824,7 +824,7 @@ static int rt2400pci_set_state(struct rt2x00_dev *rt2x00dev,
  * Initialization functions.
  */
 static int rt2400pci_alloc_dma_ring(struct rt2x00_dev *rt2x00dev,
-	enum ring_index ring_type, void (*handler)(struct work_struct *),
+	enum ring_index ring_type, work_func_t handler,
 	const u16 max_entries, const u16 data_size, const u16 desc_size)
 {
 	struct data_ring *ring = &rt2x00dev->ring[ring_type];
@@ -908,8 +908,7 @@ static int rt2400pci_allocate_dma_rings(struct rt2x00_dev *rt2x00dev)
 		rt2400pci_txdone, TX_ENTRIES, DATA_FRAME_SIZE,
 		TXD_DESC_SIZE) ||
 	    rt2400pci_alloc_dma_ring(rt2x00dev, RING_BEACON,
-		rt2400pci_beacondone, BEACON_ENTRIES, MGMT_FRAME_SIZE,
-		TXD_DESC_SIZE)) {
+		NULL, BEACON_ENTRIES, MGMT_FRAME_SIZE, TXD_DESC_SIZE)) {
 		return -ENOMEM;
 	}
 
@@ -1624,11 +1623,9 @@ static void rt2400pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev, int queue)
 /*
  * Interrupt functions.
  */
-static void rt2400pci_beacondone(struct work_struct *work)
+static void rt2400pci_beacondone(struct rt2x00_dev *rt2x00dev)
 {
-	struct data_ring *ring =
-		container_of(work, struct data_ring, irq_work);
-	struct rt2x00_dev *rt2x00dev = ring->rt2x00dev;
+	struct data_ring *ring = &rt2x00dev->ring[RING_BEACON];
 	struct data_entry *entry = rt2x00_get_data_entry(ring);
 	struct sk_buff *skb;
 
@@ -1637,7 +1634,8 @@ static void rt2400pci_beacondone(struct work_struct *work)
 	if (!skb)
 		return;
 
-	rt2400pci_beacon_update(rt2x00dev->hw, skb, &entry->tx_status.control);
+	rt2x00dev->hw_ops->beacon_update(rt2x00dev->hw, skb,
+		&entry->tx_status.control);
 
 	dev_kfree_skb_any(skb);
 }
@@ -1652,11 +1650,13 @@ static void rt2400pci_rxdone(struct work_struct *work)
 	struct data_desc *rxd;
 	u32 word0;
 	u32 word2;
+	int signal;
+	int rssi;
 	u16 size;
 
 	while (1) {
 		entry = rt2x00_get_data_entry(ring);
-		rxd = rt2x00_desc_addr(entry);
+		rxd = entry->priv;
 		rt2x00_desc_read(rxd, 0, &word0);
 		rt2x00_desc_read(rxd, 2, &word2);
 
@@ -1669,29 +1669,25 @@ static void rt2400pci_rxdone(struct work_struct *work)
 		 * TODO: Don't we need to keep statistics
 		 * updated about events like CRC and physical errors?
 		 */
-		if (!rt2x00_get_field32(word0, RXD_W0_CRC) &&
-		    !rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR)) {
-			skb = dev_alloc_skb(size + NET_IP_ALIGN);
-			if (!skb)
-				break;
+		if (rt2x00_get_field32(word0, RXD_W0_CRC) ||
+		    rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR))
+			goto skip_entry;
 
-			skb_reserve(skb, NET_IP_ALIGN);
+		skb = dev_alloc_skb(size + NET_IP_ALIGN);
+		if (!skb)
+			break;
 
-			memcpy(skb_put(skb, size), rt2x00_data_addr(entry),
-				size);
+		skb_reserve(skb, NET_IP_ALIGN);
 
-			rt2x00dev->rx_status.rate = device_signal_to_rate(
-				&rt2x00dev->hwmodes[0],
-				rt2x00_get_field32(word2, RXD_W2_SIGNAL),
-				0);
+		memcpy(skb_put(skb, size), entry->data_addr, size);
 
-			rt2x00dev->rx_status.ssi =
-				rt2x00_get_field32(word2, RXD_W2_RSSI);
+		signal = rt2x00_get_field32(word2, RXD_W2_SIGNAL);
+		rssi = rt2x00_get_field32(word2, RXD_W2_RSSI);
+		rt2x00lib_update_rx_stats(rt2x00dev, signal, rssi, 0);
 
-			__ieee80211_rx(rt2x00dev->hw,
-				skb, &rt2x00dev->rx_status);
-		}
+		__ieee80211_rx(rt2x00dev->hw, skb, &rt2x00dev->rx_status);
 
+skip_entry:
 		rt2x00_set_field32(&word0, RXD_W0_OWNER_NIC, 1);
 		rt2x00_desc_write(rxd, 0, word0);
 		rt2x00_ring_index_inc(ring);
@@ -1712,46 +1708,29 @@ static void rt2400pci_txdone(struct work_struct *work)
 	struct data_desc *txd;
 	u32 word;
 	int tx_status;
+	int retry;
 	int ack;
-	int rts;
 
 	while (!rt2x00_ring_empty(ring)) {
 		entry = rt2x00_get_data_entry_done(ring);
-		txd = rt2x00_desc_addr(entry);
+		txd = entry->priv;
 		rt2x00_desc_read(txd, 0, &word);
 
 		if (rt2x00_get_field32(word, TXD_W0_OWNER_NIC) ||
 		    !rt2x00_get_field32(word, TXD_W0_VALID))
 			break;
 
-		entry->tx_status.flags = 0;
-		entry->tx_status.queue_length = ring->stats.limit;
-		entry->tx_status.queue_number = entry->tx_status.control.queue;
-
-		/*
-		 * The TXD_W0_RESULT field will only be set when
-		 * we had requested an ACK. So we have received an
-		 * ACK response when ACK was requested and status
-		 * was succesfull.
-		 */
 		ack = rt2x00_get_field32(word, TXD_W0_ACK);
-		rts = GET_FLAG(entry, ENTRY_RTS_CTS_FRAME);
 		tx_status = rt2x00_get_field32(word, TXD_W0_RESULT);
-		rt2x00_update_tx_stats(rt2x00dev, &entry->tx_status, tx_status,
-			ack, rts);
-
-		rt2x00_bbp_read(rt2x00dev, 32,
-			(u8*)&entry->tx_status.ack_signal);
-
-		entry->tx_status.retry_count = rt2x00_get_field32(
-			word, TXD_W0_RETRY_COUNT);
+		retry = rt2x00_get_field32(word, TXD_W0_RETRY_COUNT);
+		rt2x00lib_update_tx_stats(entry, tx_status, ack, retry);
 
 		/*
 		 * If this is not an RTS frame send the tx_status to mac80211,
 		 * that method also cleans up the skb structure. When this
 		 * is a RTS frame, that it is our job to clean this structure up.
 		 */
-		if (!rts)
+		if (!GET_FLAG(entry, ENTRY_RTS_CTS_FRAME))
 			ieee80211_tx_status(rt2x00dev->hw,
 				entry->skb, &entry->tx_status);
 		else
@@ -1759,9 +1738,10 @@ static void rt2400pci_txdone(struct work_struct *work)
 
 		rt2x00_set_field32(&word, TXD_W0_VALID, 0);
 		rt2x00_desc_write(txd, 0, word);
-		CLEAR_FLAG(entry, ENTRY_RTS_CTS_FRAME);
 		entry->skb = NULL;
 
+		CLEAR_FLAG(entry, ENTRY_RTS_CTS_FRAME);
+
 		rt2x00_ring_index_done_inc(ring);
 	}
 
@@ -1814,8 +1794,7 @@ static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
 	 * 1 - Beacon timer expired interrupt.
 	 */
 	if (rt2x00_get_field32(reg, CSR7_TBCN_EXPIRE))
-		queue_work(rt2x00dev->workqueue,
-			&rt2x00dev->ring[RING_BEACON].irq_work);
+		rt2400pci_beacondone(rt2x00dev);
 
 	/*
 	 * 2 - Rx ring done interrupt.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
index 489877c..49b9a51 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
@@ -956,7 +956,6 @@ static void rt2400pci_disable_radio(struct rt2x00_dev *rt2x00dev);
 /*
  * Interrupt functions.
  */
-static void rt2400pci_beacondone(struct work_struct *work);
 static void rt2400pci_rxdone(struct work_struct *work);
 static void rt2400pci_txdone(struct work_struct *work);
 static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 09b2ff2..b0790c9 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -915,7 +915,7 @@ static int rt2500pci_set_state(struct rt2x00_dev *rt2x00dev,
  * Initialization functions.
  */
 static int rt2500pci_alloc_dma_ring(struct rt2x00_dev *rt2x00dev,
-	enum ring_index ring_type, void (*handler)(struct work_struct *),
+	enum ring_index ring_type, work_func_t handler,
 	const u16 max_entries, const u16 data_size, const u16 desc_size)
 {
 	struct data_ring *ring = &rt2x00dev->ring[ring_type];
@@ -999,8 +999,7 @@ static int rt2500pci_allocate_dma_rings(struct rt2x00_dev *rt2x00dev)
 		rt2500pci_txdone, TX_ENTRIES, DATA_FRAME_SIZE,
 		TXD_DESC_SIZE) ||
 	    rt2500pci_alloc_dma_ring(rt2x00dev, RING_BEACON,
-		rt2500pci_beacondone, BEACON_ENTRIES, MGMT_FRAME_SIZE,
-		TXD_DESC_SIZE)) {
+		NULL, BEACON_ENTRIES, MGMT_FRAME_SIZE, TXD_DESC_SIZE)) {
 		return -ENOMEM;
 	}
 
@@ -1779,11 +1778,9 @@ static void rt2500pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev, int queue)
 /*
  * Interrupt functions.
  */
-static void rt2500pci_beacondone(struct work_struct *work)
+static void rt2500pci_beacondone(struct rt2x00_dev *rt2x00dev)
 {
-	struct data_ring *ring =
-		container_of(work, struct data_ring, irq_work);
-	struct rt2x00_dev *rt2x00dev = ring->rt2x00dev;
+	struct data_ring *ring = &rt2x00dev->ring[RING_BEACON];
 	struct data_entry *entry = rt2x00_get_data_entry(ring);
 	struct sk_buff *skb;
 
@@ -1792,7 +1789,8 @@ static void rt2500pci_beacondone(struct work_struct *work)
 	if (!skb)
 		return;
 
-	rt2500pci_beacon_update(rt2x00dev->hw, skb, &entry->tx_status.control);
+	rt2x00dev->hw_ops->beacon_update(rt2x00dev->hw, skb,
+		&entry->tx_status.control);
 
 	dev_kfree_skb_any(skb);
 }
@@ -1807,11 +1805,14 @@ static void rt2500pci_rxdone(struct work_struct *work)
 	struct data_desc *rxd;
 	u32 word0;
 	u32 word2;
+	int signal;
+	int rssi;
+	int ofdm;
 	u16 size;
 
 	while (1) {
 		entry = rt2x00_get_data_entry(ring);
-		rxd = rt2x00_desc_addr(entry);
+		rxd = entry->priv;
 		rt2x00_desc_read(rxd, 0, &word0);
 		rt2x00_desc_read(rxd, 2, &word2);
 
@@ -1824,36 +1825,32 @@ static void rt2500pci_rxdone(struct work_struct *work)
 		 * TODO: Don't we need to keep statistics
 		 * updated about events like CRC and physical errors?
 		 */
-		if (!rt2x00_get_field32(word0, RXD_W0_CRC) &&
-		    !rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR)) {
-			skb = dev_alloc_skb(size + NET_IP_ALIGN);
-			if (!skb)
-				break;
-
-			skb_reserve(skb, NET_IP_ALIGN);
-
-			memcpy(skb_put(skb, size), rt2x00_data_addr(entry),
-				size);
-
-			rt2x00dev->rx_status.rate = device_signal_to_rate(
-				&rt2x00dev->hwmodes[0],
-				rt2x00_get_field32(word2, RXD_W2_SIGNAL),
-				rt2x00_get_field32(word0, RXD_W0_OFDM));
-
-			rt2x00dev->rx_status.ssi =
-				rt2x00_get_field32(word2, RXD_W2_RSSI);
-			rt2x00dev->rx_status.noise =
-				rt2x00_get_link_noise(&rt2x00dev->link);
-
-			__ieee80211_rx(rt2x00dev->hw,
-				skb, &rt2x00dev->rx_status);
-
-			/*
-			 * Update link statistics
-			 */
-			rt2x00_update_link_rssi(&rt2x00dev->link,
-				rt2x00dev->rx_status.ssi);
-		}
+		if (rt2x00_get_field32(word0, RXD_W0_CRC) ||
+		    rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR))
+			goto skip_entry;
+
+		skb = dev_alloc_skb(size + NET_IP_ALIGN);
+		if (!skb)
+			break;
+
+		skb_reserve(skb, NET_IP_ALIGN);
+
+		memcpy(skb_put(skb, size), entry->data_addr, size);
+
+		signal = rt2x00_get_field32(word2, RXD_W2_SIGNAL);
+		rssi = rt2x00_get_field32(word2, RXD_W2_RSSI);
+		ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
+		rt2x00lib_update_rx_stats(rt2x00dev, signal, rssi, ofdm);
+
+		__ieee80211_rx(rt2x00dev->hw, skb, &rt2x00dev->rx_status);
+
+		/*
+		 * Update link statistics
+		 */
+		rt2x00_update_link_rssi(&rt2x00dev->link,
+			rt2x00dev->rx_status.ssi);
+
+skip_entry:
 		rt2x00_set_field32(&word0, RXD_W0_OWNER_NIC, 1);
 		rt2x00_desc_write(rxd, 0, word0);
 		rt2x00_ring_index_inc(ring);
@@ -1874,46 +1871,29 @@ static void rt2500pci_txdone(struct work_struct *work)
 	struct data_desc *txd;
 	u32 word;
 	int tx_status;
+	int retry;
 	int ack;
-	int rts;
 
 	while (!rt2x00_ring_empty(ring)) {
 		entry = rt2x00_get_data_entry_done(ring);
-		txd = rt2x00_desc_addr(entry);
+		txd = entry->priv;
 		rt2x00_desc_read(txd, 0, &word);
 
 		if (rt2x00_get_field32(word, TXD_W0_OWNER_NIC) ||
 		    !rt2x00_get_field32(word, TXD_W0_VALID))
 			break;
 
-		entry->tx_status.flags = 0;
-		entry->tx_status.queue_length = ring->stats.limit;
-		entry->tx_status.queue_number = entry->tx_status.control.queue;
-
-		/*
-		 * The TXD_W0_RESULT field will only be set when
-		 * we had requested an ACK. So we have received an
-		 * ACK response when ACK was requested and status
-		 * was succesfull.
-		 */
 		ack = rt2x00_get_field32(word, TXD_W0_ACK);
-		rts = GET_FLAG(entry, ENTRY_RTS_CTS_FRAME);
 		tx_status = rt2x00_get_field32(word, TXD_W0_RESULT);
-		rt2x00_update_tx_stats(rt2x00dev, &entry->tx_status, tx_status,
-			ack, rts);
-
-		rt2x00_bbp_read(rt2x00dev, 32,
-			(u8*)&entry->tx_status.ack_signal);
-
-		entry->tx_status.retry_count = rt2x00_get_field32(
-			word, TXD_W0_RETRY_COUNT);
+		retry = rt2x00_get_field32(word, TXD_W0_RETRY_COUNT);
+		rt2x00lib_update_tx_stats(entry, tx_status, ack, retry);
 
 		/*
 		 * If this is not an RTS frame send the tx_status to mac80211,
 		 * that method also cleans up the skb structure. When this
 		 * is a RTS frame, that it is our job to clean this structure up.
 		 */
-		if (!rts)
+		if (!GET_FLAG(entry, ENTRY_RTS_CTS_FRAME))
 			ieee80211_tx_status(rt2x00dev->hw,
 				entry->skb, &entry->tx_status);
 		else
@@ -1921,9 +1901,10 @@ static void rt2500pci_txdone(struct work_struct *work)
 
 		rt2x00_set_field32(&word, TXD_W0_VALID, 0);
 		rt2x00_desc_write(txd, 0, word);
-		CLEAR_FLAG(entry, ENTRY_RTS_CTS_FRAME);
 		entry->skb = NULL;
 
+		CLEAR_FLAG(entry, ENTRY_RTS_CTS_FRAME);
+
 		rt2x00_ring_index_done_inc(ring);
 	}
 
@@ -1976,8 +1957,7 @@ static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
 	 * 1 - Beacon timer expired interrupt.
 	 */
 	if (rt2x00_get_field32(reg, CSR7_TBCN_EXPIRE))
-		queue_work(rt2x00dev->workqueue,
-			&rt2x00dev->ring[RING_BEACON].irq_work);
+		rt2500pci_beacondone(rt2x00dev);
 
 	/*
 	 * 2 - Rx ring done interrupt.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
index faa1953..84f0cfd 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
@@ -1223,7 +1223,6 @@ static void rt2500pci_disable_radio(struct rt2x00_dev *rt2x00dev);
 /*
  * Interrupt functions.
  */
-static void rt2500pci_beacondone(struct work_struct *work);
 static void rt2500pci_rxdone(struct work_struct *work);
 static void rt2500pci_txdone(struct work_struct *work);
 static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 77c60d0..259787a 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -889,18 +889,6 @@ static void rt2500usb_disable_led(struct rt2x00_dev *rt2x00dev)
 	rt2x00_register_write(rt2x00dev, MAC_CSR20, reg);
 }
 
-static void rt2500usb_activity_led(struct rt2x00_dev *rt2x00dev, char activity)
-{
-	u16 reg;
-
-	if (rt2x00dev->led_mode != LED_MODE_TXRX_ACTIVITY)
-		return;
-
-	rt2x00_register_read(rt2x00dev, MAC_CSR20, &reg);
-	rt2x00_set_field16(&reg, MAC_CSR20_ACTIVITY, activity);
-	rt2x00_register_write(rt2x00dev, MAC_CSR20, reg);
-}
-
 /*
  * Device state switch.
  * This will put the device to sleep, or awake it.
@@ -951,17 +939,12 @@ static int rt2500usb_set_state(struct rt2x00_dev *rt2x00dev,
  * Initialization functions.
  */
 static int rt2500usb_alloc_dma_ring(struct rt2x00_dev *rt2x00dev,
-	enum ring_index ring_type, void (*handler)(struct work_struct *),
-	const u16 max_entries, const u16 data_size, const u16 desc_size)
+	enum ring_index ring_type, const u16 max_entries,
+	const u16 data_size, const u16 desc_size)
 {
 	struct data_ring *ring = &rt2x00dev->ring[ring_type];
 	unsigned int i;
 
-	/*
-	 * Initialize work structure for deferred work.
-	 */
-	INIT_WORK(&ring->irq_work, handler);
-
 	ring->stats.limit = max_entries;
 	ring->data_size = data_size;
 	ring->desc_size = desc_size;
@@ -1023,20 +1006,15 @@ static void rt2500usb_free_ring(struct rt2x00_dev *rt2x00dev,
 static int rt2500usb_allocate_dma_rings(struct rt2x00_dev *rt2x00dev)
 {
 	if (rt2500usb_alloc_dma_ring(rt2x00dev, RING_RX,
-		&rt2500usb_rxdone, RX_ENTRIES, DATA_FRAME_SIZE,
-		RXD_DESC_SIZE) ||
+		RX_ENTRIES, DATA_FRAME_SIZE, RXD_DESC_SIZE) ||
 	    rt2500usb_alloc_dma_ring(rt2x00dev, RING_TX,
-		&rt2500usb_txdone, TX_ENTRIES, DATA_FRAME_SIZE,
-		TXD_DESC_SIZE) ||
+		TX_ENTRIES, DATA_FRAME_SIZE, TXD_DESC_SIZE) ||
 	    rt2500usb_alloc_dma_ring(rt2x00dev, RING_ATIM,
-		&rt2500usb_txdone, ATIM_ENTRIES, DATA_FRAME_SIZE,
-		TXD_DESC_SIZE) ||
+		ATIM_ENTRIES, DATA_FRAME_SIZE, TXD_DESC_SIZE) ||
 	    rt2500usb_alloc_dma_ring(rt2x00dev, RING_PRIO,
-		&rt2500usb_txdone, TX_ENTRIES, DATA_FRAME_SIZE,
-		TXD_DESC_SIZE) ||
+		TX_ENTRIES, DATA_FRAME_SIZE, TXD_DESC_SIZE) ||
 	    rt2500usb_alloc_dma_ring(rt2x00dev, RING_BEACON,
-		&rt2500usb_beacondone, BEACON_ENTRIES, MGMT_FRAME_SIZE,
-		TXD_DESC_SIZE)) {
+		BEACON_ENTRIES, MGMT_FRAME_SIZE, TXD_DESC_SIZE)) {
 		return -ENOMEM;
 	}
 
@@ -1069,7 +1047,7 @@ static void rt2500usb_init_rxring(struct rt2x00_dev *rt2x00dev,
 			usb_rcvbulkpipe(usb_dev, 1),
 			ring->entry[i].skb->data,
 			ring->entry[i].skb->len,
-			rt2500usb_interrupt,
+			rt2500usb_interrupt_rxdone,
 			&ring->entry[i]);
 	}
 
@@ -1687,7 +1665,7 @@ static int rt2500usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 		usb_sndbulkpipe(usb_dev, 1),
 		skb->data,
 		length,
-		rt2500usb_interrupt,
+		rt2500usb_interrupt_txdone,
 		entry);
 	usb_submit_urb(entry->priv, GFP_ATOMIC);
 
@@ -1702,11 +1680,10 @@ static int rt2500usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 /*
  * Interrupt functions.
  */
-static void rt2500usb_beacondone(struct work_struct *work)
+static void rt2500usb_interrupt_beacondone(struct urb *urb)
 {
-	struct data_ring *ring =
-		container_of(work, struct data_ring, irq_work);
-	struct data_entry *entry;
+	struct data_entry *entry = (struct data_entry*)urb->context;
+	struct data_ring *ring = entry->ring;
 
 	if (!GET_FLAG(ring->rt2x00dev, DEVICE_ENABLED_RADIO))
 		return;
@@ -1732,162 +1709,136 @@ static void rt2500usb_beacondone(struct work_struct *work)
 	}
 }
 
-static void rt2500usb_rxdone(struct work_struct *work)
+static void rt2500usb_interrupt_rxdone(struct urb *urb)
 {
-	struct data_ring *ring =
-		container_of(work, struct data_ring, irq_work);
+	struct data_entry *entry = (struct data_entry*)urb->context;
+	struct data_ring *ring = entry->ring;
 	struct rt2x00_dev *rt2x00dev = ring->rt2x00dev;
-	struct data_entry *entry;
+	struct data_desc *rxd = (struct data_desc*)
+		(entry->skb->data + urb->actual_length - ring->desc_size);
 	struct sk_buff *skb;
-	struct data_desc *rxd;
-	struct urb *urb;
 	u32 word0;
 	u32 word1;
+	int signal;
+	int rssi;
+	int ofdm;
 	u16 size;
 
-	while (1) {
-		entry = rt2x00_get_data_entry(ring);
-		rxd = (struct data_desc*)
-			(entry->skb->data + urb->actual_length - ring->desc_size);
-		urb = entry->priv;
-		rt2x00_desc_read(rxd, 0, &word0);
-		rt2x00_desc_read(rxd, 1, &word1);
+	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO) ||
+	    !GET_FLAG(entry, ENTRY_OWNER_NIC))
+		return;
 
-		if (GET_FLAG(entry, ENTRY_OWNER_NIC))
-			break;
+	CLEAR_FLAG(entry, ENTRY_OWNER_NIC);
 
-		/*
-		 * There has been a problem. Ignore packet.
-		 */
-		if (urb->status) {
-			SET_FLAG(entry, ENTRY_OWNER_NIC);
-			usb_submit_urb(urb, GFP_ATOMIC);
-			rt2x00_ring_index_inc(ring);
-			continue;
-		}
+	/*
+	 * Check if the received data is simply too small
+	 * to be actually valid, or if the urb is signaling
+	 * a problem.
+	 */
+	if (urb->actual_length < entry->ring->desc_size || urb->status)
+		goto skip_entry;
 
-		/*
-		 * Received USB packets have 4 bytes of extra data.
-		 */
-		size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
-		size -= 4;
+	rt2x00_desc_read(rxd, 0, &word0);
+	rt2x00_desc_read(rxd, 1, &word1);
 
-		/*
-		 * TODO: Don't we need to keep statistics
-		 * updated about events like CRC and physical errors?
-		 */
-		if (!rt2x00_get_field32(word0, RXD_W0_CRC) &&
-		    !rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR)) {
-			skb = dev_alloc_skb(size + NET_IP_ALIGN);
-			if (!skb)
-				break;
-
-			skb_reserve(skb, NET_IP_ALIGN);
-			skb_put(skb, ring->data_size + ring->desc_size);
-
-			urb->transfer_buffer = skb->data;
-			urb->transfer_buffer_length = skb->len;
-
-			rt2x00dev->rx_status.rate = device_signal_to_rate(
-				&rt2x00dev->hwmodes[0],
-				rt2x00_get_field32(word1, RXD_W1_SIGNAL),
-				rt2x00_get_field32(word0, RXD_W0_OFDM));
-
-			rt2x00dev->rx_status.ssi =
-				rt2x00_get_field32(word1, RXD_W1_RSSI);
-			rt2x00dev->rx_status.noise =
-				rt2x00_get_link_noise(&rt2x00dev->link);
-
-			/*
-			 * Received USB packets have 4 bytes of extra data,
-			 * Trim the skb_buffer to only contain the valid
-			 * frame data (so ignore the device's descriptor).
-			 */
-			size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
-			size -= FCS_LEN;
-			skb_trim(entry->skb, size);
-
-			__ieee80211_rx(rt2x00dev->hw,
-				entry->skb, &rt2x00dev->rx_status);
-			entry->skb = skb;
-
-			/*
-			 * Update link statistics
-			 */
-			rt2x00_update_link_rssi(&rt2x00dev->link,
-				rt2x00dev->rx_status.ssi);
-		}
+	/*
+	 * TODO: Don't we need to keep statistics
+	 * updated about events like CRC and physical errors?
+	 */
+	if (rt2x00_get_field32(word0, RXD_W0_CRC) ||
+	    rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR))
+		goto skip_entry;
+
+	/*
+	 * Allocate a new sk_buffer to replace the sk_buffer
+	 * that has been filled in by the device.
+	 */
+	skb = dev_alloc_skb(NET_IP_ALIGN + ring->data_size + ring->desc_size);
+	if (!skb)
+		return;
 
-		SET_FLAG(entry, ENTRY_OWNER_NIC);
-		usb_submit_urb(urb, GFP_ATOMIC);
+	skb_reserve(skb, NET_IP_ALIGN);
+	skb_put(skb, ring->data_size + ring->desc_size);
 
-		rt2x00_ring_index_inc(ring);
-	}
+	urb->transfer_buffer = skb->data;
+	urb->transfer_buffer_length = skb->len;
+
+	signal = rt2x00_get_field32(word1, RXD_W1_SIGNAL);
+	rssi = rt2x00_get_field32(word1, RXD_W1_RSSI);
+	ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
+	rt2x00lib_update_rx_stats(rt2x00dev, signal, rssi, ofdm);
+
+	/*
+	 * Received USB packets have 4 bytes of extra data,
+	 * Trim the skb_buffer to only contain the valid
+	 * frame data (so ignore the device's descriptor).
+	 */
+	size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
+	size -= FCS_LEN;
+	skb_trim(entry->skb, size);
 
 	/*
-	 * Update LED.
+	 * Send frame to stack, and set the new sk_buffer
+	 * in its place to be able to receive new frames
+	 * in the new buffer.
 	 */
-	rt2500usb_activity_led(rt2x00dev, 0);
+	ieee80211_rx_irqsafe(rt2x00dev->hw, entry->skb, &rt2x00dev->rx_status);
+	entry->skb = skb;
+
+	/*
+	 * Update link statistics
+	 */
+	rt2x00_update_link_rssi(&rt2x00dev->link, rt2x00dev->rx_status.ssi);
+
+skip_entry:
+	if (!GET_FLAG(ring->rt2x00dev, DEVICE_ENABLED_RADIO))
+		return;
+
+	SET_FLAG(entry, ENTRY_OWNER_NIC);
+	usb_submit_urb(urb, GFP_ATOMIC);
+	rt2x00_ring_index_inc(ring);
 }
 
-static void rt2500usb_txdone(struct work_struct *work)
+static void rt2500usb_interrupt_txdone(struct urb *urb)
 {
-	struct data_ring *ring =
-		container_of(work, struct data_ring, irq_work);
+	struct data_entry *entry = (struct data_entry*)urb->context;
+	struct data_ring *ring = entry->ring;
 	struct rt2x00_dev *rt2x00dev = ring->rt2x00dev;
-	struct data_entry *entry;
-	struct data_desc *txd;
-	struct urb *urb;
+	struct data_desc *txd = (struct data_desc *)entry->skb->data;
 	u32 word;
 	int tx_status;
 	int ack;
-	int rts;
 
-	 while (!rt2x00_ring_empty(ring)) {
-		entry = rt2x00_get_data_entry_done(ring);
-		txd = (struct data_desc *)entry->skb->data;
-		urb = entry->priv;
-		rt2x00_desc_read(txd, 0, &word);
+	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO) ||
+	    !GET_FLAG(entry, ENTRY_OWNER_NIC))
+		return;
 
-		if (GET_FLAG(entry, ENTRY_OWNER_NIC))
-			break;
+	CLEAR_FLAG(entry, ENTRY_OWNER_NIC);
 
-		entry->tx_status.flags = 0;
-		entry->tx_status.queue_length = entry->ring->stats.limit;
-		entry->tx_status.queue_number = entry->tx_status.control.queue;
+	rt2x00_desc_read(txd, 0, &word);
 
-		/*
-		 * Check if we have received an
-		 * ACK response when ACK was requested and status
-		 * was succesfull.
-		 */
-		ack = rt2x00_get_field32(word, TXD_W0_ACK);
-		rts = GET_FLAG(entry, ENTRY_RTS_CTS_FRAME);
-		tx_status = !urb->status ? TX_SUCCESS : TX_FAIL_RETRY;
-		rt2x00_update_tx_stats(rt2x00dev, &entry->tx_status, tx_status,
-			ack, rts);
+	ack = rt2x00_get_field32(word, TXD_W0_ACK);
+	tx_status = !urb->status ? TX_SUCCESS : TX_FAIL_RETRY;
+	rt2x00lib_update_tx_stats(entry, tx_status, ack, 0);
 
-		rt2x00_bbp_read(rt2x00dev, 0,
-			(u8*)&entry->tx_status.ack_signal);
+	skb_pull(entry->skb, ring->desc_size);
 
-		skb_pull(entry->skb, ring->desc_size);
+	/*
+	 * If this is not an RTS frame send the tx_status to mac80211,
+	 * that method also cleans up the skb structure. When this
+	 * is a RTS frame, that it is our job to clean this structure up.
+	 */
+	if (!GET_FLAG(entry, ENTRY_RTS_CTS_FRAME))
+		ieee80211_tx_status_irqsafe(rt2x00dev->hw,
+			entry->skb, &entry->tx_status);
+	else
+		dev_kfree_skb(entry->skb);
 
-		/*
-		 * If this is not an RTS frame send the tx_status to mac80211,
-		 * that method also cleans up the skb structure. When this
-		 * is a RTS frame, that it is our job to clean this structure up.
-		 */
-		if (!rts)
-			ieee80211_tx_status(rt2x00dev->hw,
-				entry->skb, &entry->tx_status);
-		else
-			dev_kfree_skb(entry->skb);
+	entry->skb = NULL;
 
-		CLEAR_FLAG(entry, ENTRY_RTS_CTS_FRAME);
-		entry->skb = NULL;
+	CLEAR_FLAG(entry, ENTRY_RTS_CTS_FRAME);
 
-		rt2x00_ring_index_done_inc(entry->ring);
-	}
+	rt2x00_ring_index_done_inc(entry->ring);
 
 	/*
 	 * Check if we are waiting on an empty queue
@@ -1904,31 +1855,11 @@ static void rt2500usb_txdone(struct work_struct *work)
 	 * we must make sure the packet queue in the mac80211 stack
 	 * is reenabled when the txdone handler has finished.
 	 */
-	entry = ring->entry;
 	if (!rt2x00_ring_full(ring))
 		ieee80211_wake_queue(rt2x00dev->hw,
 			entry->tx_status.control.queue);
 }
 
-static void rt2500usb_interrupt(struct urb *urb)
-{
-	struct data_entry *entry = (struct data_entry*)urb->context;
-	struct rt2x00_dev *rt2x00dev = entry->ring->rt2x00dev;
-
-	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
-		return;
-
-	CLEAR_FLAG(entry, ENTRY_OWNER_NIC);
-
-	if (urb->status)
-		return;
-
-	if (entry->ring->type == RING_RX)
-		rt2500usb_activity_led(rt2x00dev, 1);
-
-	queue_work(rt2x00dev->workqueue, &entry->ring->irq_work);
-}
-
 /*
  * IEEE80211 stack callback functions.
  */
@@ -2427,7 +2358,7 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 		usb_sndbulkpipe(usb_dev, 1),
 		skb->data,
 		length,
-		rt2500usb_interrupt,
+		rt2500usb_interrupt_beacondone,
 		beacon);
 
 	beacon->skb = skb;
@@ -2444,7 +2375,7 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 		usb_sndbulkpipe(usb_dev, 1),
 		&guardian->reg,
 		1,
-		rt2500usb_interrupt,
+		rt2500usb_interrupt_beacondone,
 		guardian);
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
index 316bf3a..a94b03e 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
@@ -716,8 +716,6 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
  */
 static void rt2500usb_enable_led(struct rt2x00_dev *rt2x00dev);
 static void rt2500usb_disable_led(struct rt2x00_dev *rt2x00dev);
-static void rt2500usb_activity_led(struct rt2x00_dev *rt2x00dev,
-	char activity);
 
 /*
  * Radio control functions.
@@ -728,9 +726,8 @@ static void rt2500usb_disable_radio(struct rt2x00_dev *rt2x00dev);
 /*
  * Interrupt functions.
  */
-static void rt2500usb_beacondone(struct work_struct *work);
-static void rt2500usb_rxdone(struct work_struct *work);
-static void rt2500usb_txdone(struct work_struct *work);
-static void rt2500usb_interrupt(struct urb *urb);
+static void rt2500usb_interrupt_beacondone(struct urb *urb);
+static void rt2500usb_interrupt_rxdone(struct urb *urb);
+static void rt2500usb_interrupt_txdone(struct urb *urb);
 
 #endif /* RT2500USB_H */
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 17f3076..85e6377 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -1340,7 +1340,7 @@ static int rt61pci_init_firmware(struct rt2x00_dev *rt2x00dev)
 }
 
 static int rt61pci_alloc_dma_ring(struct rt2x00_dev *rt2x00dev,
-	enum ring_index ring_type, void (*handler)(struct work_struct *work),
+	enum ring_index ring_type, work_func_t handler,
 	const u16 max_entries, const u16 data_size, const u16 desc_size)
 {
 	struct data_ring *ring = &rt2x00dev->ring[ring_type];
@@ -1430,8 +1430,7 @@ static int rt61pci_allocate_dma_rings(struct rt2x00_dev *rt2x00dev)
 		rt61pci_txdone, TX_ENTRIES, DATA_FRAME_SIZE,
 		TXD_DESC_SIZE) ||
 	    rt61pci_alloc_dma_ring(rt2x00dev, RING_BEACON,
-		rt61pci_beacondone, BEACON_ENTRIES, MGMT_FRAME_SIZE,
-		TXD_DESC_SIZE) ) {
+		NULL, BEACON_ENTRIES, MGMT_FRAME_SIZE, TXD_DESC_SIZE) ) {
 		return -ENOMEM;
 	}
 
@@ -2245,11 +2244,9 @@ static void rt61pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev, int queue)
 /*
  * Interrupt functions.
  */
-static void rt61pci_beacondone(struct work_struct *work)
+static void rt61pci_beacondone(struct rt2x00_dev *rt2x00dev)
 {
-	struct data_ring *ring =
-		container_of(work, struct data_ring, irq_work);
-	struct rt2x00_dev *rt2x00dev = ring->rt2x00dev;
+	struct data_ring *ring = &rt2x00dev->ring[RING_BEACON];
 	struct data_entry *entry = rt2x00_get_data_entry(ring);
 	struct sk_buff *skb;
 
@@ -2258,7 +2255,8 @@ static void rt61pci_beacondone(struct work_struct *work)
 	if (!skb)
 		return;
 
-	rt61pci_beacon_update(rt2x00dev->hw, skb, &entry->tx_status.control);
+	rt2x00dev->hw_ops->beacon_update(rt2x00dev->hw, skb,
+		&entry->tx_status.control);
 
 	dev_kfree_skb_any(skb);
 }
@@ -2273,11 +2271,14 @@ static void rt61pci_rxdone(struct work_struct *work)
 	struct data_desc *rxd;
 	u32 word0;
 	u32 word1;
+	int signal;
+	int rssi;
+	int ofdm;
 	u16 size;
 
 	while (1) {
 		entry = rt2x00_get_data_entry(ring);
-		rxd = rt2x00_desc_addr(entry);
+		rxd = entry->priv;
 		rt2x00_desc_read(rxd, 0, &word0);
 		rt2x00_desc_read(rxd, 1, &word1);
 
@@ -2290,35 +2291,31 @@ static void rt61pci_rxdone(struct work_struct *work)
 		 * TODO: Don't we need to keep statistics
 		 * updated about events like CRC and physical errors?
 		 */
-		if (!rt2x00_get_field32(word0, RXD_W0_CRC)) {
-			skb = dev_alloc_skb(size + NET_IP_ALIGN);
-			if (!skb)
-				return;
+		if (rt2x00_get_field32(word0, RXD_W0_CRC))
+			goto skip_entry;
 
-			skb_reserve(skb, NET_IP_ALIGN);
+		skb = dev_alloc_skb(size + NET_IP_ALIGN);
+		if (!skb)
+			return;
 
-			memcpy(skb_put(skb, size), rt2x00_data_addr(entry),
-				size);
+		skb_reserve(skb, NET_IP_ALIGN);
 
-			rt2x00dev->rx_status.rate = device_signal_to_rate(
-				&rt2x00dev->hwmodes[0],
-				rt2x00_get_field32(word1, RXD_W1_SIGNAL),
-				rt2x00_get_field32(word0, RXD_W0_OFDM));
+		memcpy(skb_put(skb, size), entry->data_addr, size);
 
-			rt2x00dev->rx_status.ssi =
-				rt2x00_get_field32(word1, RXD_W1_RSSI);
-			rt2x00dev->rx_status.noise =
-				rt2x00_get_link_noise(&rt2x00dev->link);
+		signal = rt2x00_get_field32(word1, RXD_W1_SIGNAL);
+		rssi = rt2x00_get_field32(word1, RXD_W1_RSSI);
+		ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
+		rt2x00lib_update_rx_stats(rt2x00dev, signal, rssi, ofdm);
 
-			__ieee80211_rx(rt2x00dev->hw,
-				skb, &rt2x00dev->rx_status);
+		__ieee80211_rx(rt2x00dev->hw, skb, &rt2x00dev->rx_status);
 
-			/*
-			 * Update link statistics
-			 */
-			rt2x00_update_link_rssi(&rt2x00dev->link,
-				rt2x00dev->rx_status.ssi);
-		}
+		/*
+		 * Update link statistics
+		 */
+		rt2x00_update_link_rssi(&rt2x00dev->link,
+			rt2x00dev->rx_status.ssi);
+
+skip_entry:
 		rt2x00_set_field32(&word0, RXD_W0_OWNER_NIC, 1);
 		rt2x00_desc_write(rxd, 0, word0);
 		rt2x00_ring_index_inc(ring);
@@ -2336,7 +2333,6 @@ static void rt61pci_txdone(struct work_struct *work)
 	int tx_status;
 	int retry;
 	int ack;
-	int rts;
 
 	while (!rt2x00_ring_empty(ring)) {
 		entry = rt2x00_get_data_entry_done(ring);
@@ -2349,12 +2345,9 @@ static void rt61pci_txdone(struct work_struct *work)
 			return;
 
 		ack = rt2x00_get_field32(word, TXD_W0_ACK);
-		rts = GET_FLAG(entry, ENTRY_RTS_CTS_FRAME);
 		tx_status = rt2x00_get_field32(entry->reg, STA_CSR4_TX_RESULT);
 		retry = rt2x00_get_field32(entry->reg, STA_CSR4_RETRY_COUNT);
-
-		rt2x00_update_tx_stats(rt2x00dev, &entry->tx_status, tx_status,
-			ack, rts);
+		rt2x00lib_update_tx_stats(entry, tx_status, ack, retry);
 
 		/*
 		 * If this is not an RTS frame send the tx_status to mac80211,
@@ -2388,6 +2381,16 @@ static void rt61pci_txdone(struct work_struct *work)
 	    rt2x00_ring_empty(&rt2x00dev->ring[RING_AC_BK]) &&
 	    rt2x00_ring_empty(&rt2x00dev->ring[RING_PRIO]))
 		rt2x00_signal_scan(rt2x00dev->scan, SCANNING_READY);
+
+	/*
+	 * If the data ring was full before the txdone handler
+	 * we must make sure the packet queue in the mac80211 stack
+	 * is reenabled when the txdone handler has finished.
+	 */
+	entry = ring->entry;
+	if (!rt2x00_ring_full(ring))
+		ieee80211_wake_queue(rt2x00dev->hw,
+			entry->tx_status.control.queue);
 }
 
 static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
@@ -2423,8 +2426,7 @@ static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 	 * 1 - Beacon timer expired interrupt.
 	 */
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_BEACON_DONE))
-		queue_work(rt2x00dev->workqueue,
-			&rt2x00dev->ring[RING_BEACON].irq_work);
+		rt61pci_beacondone(rt2x00dev);
 
 	/*
 	 * 2 - Rx ring done interrupt.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.h b/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
index a030e90..a8a1df4 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
@@ -1385,7 +1385,6 @@ static void rt61pci_disable_radio(struct rt2x00_dev *rt2x00dev);
 /*
  * Interrupt functions.
  */
-static void rt61pci_beacondone(struct work_struct *work);
 static void rt61pci_rxdone(struct work_struct *work);
 static void rt61pci_txdone(struct work_struct *work);
 static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index a1f7c91..467ab4c 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -1183,17 +1183,12 @@ static int rt73usb_init_firmware(struct rt2x00_dev *rt2x00dev)
 }
 
 static int rt73usb_alloc_dma_ring(struct rt2x00_dev *rt2x00dev,
-	enum ring_index ring_type, void (*handler)(struct work_struct *work),
-	const u16 max_entries, const u16 data_size, const u16 desc_size)
+	enum ring_index ring_type, const u16 max_entries,
+	const u16 data_size, const u16 desc_size)
 {
 	struct data_ring *ring = &rt2x00dev->ring[ring_type];
 	unsigned int i;
 
-	/*
-	 * Initialize work structure for deferred work.
-	 */
-	INIT_WORK(&ring->irq_work, handler);
-
 	ring->stats.limit = max_entries;
 	ring->data_size = data_size;
 	ring->desc_size = desc_size;
@@ -1255,26 +1250,19 @@ static void rt73usb_free_ring(struct rt2x00_dev *rt2x00dev,
 static int rt73usb_allocate_dma_rings(struct rt2x00_dev *rt2x00dev)
 {
 	if (rt73usb_alloc_dma_ring(rt2x00dev, RING_RX,
-		rt73usb_rxdone, RX_ENTRIES, DATA_FRAME_SIZE,
-		RXD_DESC_SIZE) ||
+		RX_ENTRIES, DATA_FRAME_SIZE, RXD_DESC_SIZE) ||
 	    rt73usb_alloc_dma_ring(rt2x00dev, RING_AC_VO,
-		rt73usb_txdone, TX_ENTRIES, DATA_FRAME_SIZE,
-		TXD_DESC_SIZE) ||
+		TX_ENTRIES, DATA_FRAME_SIZE, TXD_DESC_SIZE) ||
 	    rt73usb_alloc_dma_ring(rt2x00dev, RING_AC_VI,
-		rt73usb_txdone, TX_ENTRIES, DATA_FRAME_SIZE,
-		TXD_DESC_SIZE) ||
+		TX_ENTRIES, DATA_FRAME_SIZE, TXD_DESC_SIZE) ||
 	    rt73usb_alloc_dma_ring(rt2x00dev, RING_AC_BE,
-		rt73usb_txdone, TX_ENTRIES, DATA_FRAME_SIZE,
-		TXD_DESC_SIZE) ||
+		TX_ENTRIES, DATA_FRAME_SIZE, TXD_DESC_SIZE) ||
 	    rt73usb_alloc_dma_ring(rt2x00dev, RING_AC_BK,
-		rt73usb_txdone, TX_ENTRIES, DATA_FRAME_SIZE,
-		TXD_DESC_SIZE) ||
+		TX_ENTRIES, DATA_FRAME_SIZE, TXD_DESC_SIZE) ||
 	    rt73usb_alloc_dma_ring(rt2x00dev, RING_PRIO,
-		rt73usb_txdone, TX_ENTRIES, DATA_FRAME_SIZE,
-		TXD_DESC_SIZE) ||
+		TX_ENTRIES, DATA_FRAME_SIZE, TXD_DESC_SIZE) ||
 	    rt73usb_alloc_dma_ring(rt2x00dev, RING_BEACON,
-		rt73usb_beacondone, BEACON_ENTRIES, MGMT_FRAME_SIZE,
-		TXD_DESC_SIZE)) {
+		BEACON_ENTRIES, MGMT_FRAME_SIZE, TXD_DESC_SIZE)) {
 		return -ENOMEM;
 	}
 
@@ -1309,7 +1297,7 @@ static void rt73usb_init_rxring(struct rt2x00_dev *rt2x00dev,
 			usb_rcvbulkpipe(usb_dev, 1),
 			ring->entry[i].skb->data,
 			ring->entry[i].skb->len,
-			rt73usb_interrupt,
+			rt73usb_interrupt_rxdone,
 			&ring->entry[i]);
 	}
 
@@ -1961,7 +1949,7 @@ static int rt73usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 		usb_sndbulkpipe(usb_dev, 1),
 		skb->data,
 		length,
-		rt73usb_interrupt,
+		rt73usb_interrupt_txdone,
 		entry);
 	usb_submit_urb(entry->priv, GFP_ATOMIC);
 
@@ -1976,11 +1964,10 @@ static int rt73usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 /*
  * Interrupt functions.
  */
-static void rt73usb_beacondone(struct work_struct *work)
+static void rt73usb_interrupt_beacondone(struct urb *urb)
 {
-	struct data_ring *ring =
-		container_of(work, struct data_ring, irq_work);
-	struct data_entry *entry;
+	struct data_entry *entry = (struct data_entry*)urb->context;
+	struct data_ring *ring = entry->ring;
 
 	if (!GET_FLAG(ring->rt2x00dev, DEVICE_ENABLED_RADIO))
 		return;
@@ -2006,151 +1993,134 @@ static void rt73usb_beacondone(struct work_struct *work)
 	}
 }
 
-static void rt73usb_rxdone(struct work_struct *work)
+static void rt73usb_interrupt_rxdone(struct urb *urb)
 {
-	struct data_ring *ring =
-		container_of(work, struct data_ring, irq_work);
+	struct data_entry *entry = (struct data_entry*)urb->context;
+	struct data_ring *ring = entry->ring;
 	struct rt2x00_dev *rt2x00dev = ring->rt2x00dev;
-	struct data_entry *entry;
+	struct data_desc *rxd = (struct data_desc*)entry->skb->data;
 	struct sk_buff *skb;
-	struct data_desc *rxd;
-	struct urb *urb;
 	u32 word0;
 	u32 word1;
+	int signal;
+	int rssi;
+	int ofdm;
 	u16 size;
 
-	while (1) {
-		entry = rt2x00_get_data_entry(ring);
-		rxd = (struct data_desc*)entry->skb->data;
-		urb = entry->priv;
-		rt2x00_desc_read(rxd, 0, &word0);
-		rt2x00_desc_read(rxd, 1, &word1);
+	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO) ||
+	    !GET_FLAG(entry, ENTRY_OWNER_NIC))
+		return;
 
-		if (GET_FLAG(entry, ENTRY_OWNER_NIC))
-			break;
+	CLEAR_FLAG(entry, ENTRY_OWNER_NIC);
 
-		/*
-		 * There has been a problem. Ignore packet.
-		 */
-		if (urb->status) {
-			SET_FLAG(entry, ENTRY_OWNER_NIC);
-			usb_submit_urb(urb, GFP_ATOMIC);
-			rt2x00_ring_index_inc(ring);
-			continue;
-		}
+	/*
+	 * Check if the received data is simply too small
+	 * to be actually valid, or if the urb is signaling
+	 * a problem.
+	 */
+	if (urb->actual_length < entry->ring->desc_size || urb->status)
+		goto skip_entry;
 
-		size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
+	rt2x00_desc_read(rxd, 0, &word0);
+	rt2x00_desc_read(rxd, 1, &word1);
 
-		/*
-		 * TODO: Don't we need to keep statistics
-		 * updated about events like CRC and physical errors?
-		 */
-		if (!rt2x00_get_field32(word0, RXD_W0_CRC) &&
-		    !rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR)) {
-			skb = dev_alloc_skb(size + NET_IP_ALIGN);
-			if (!skb)
-				break;
+	/*
+	 * TODO: Don't we need to keep statistics
+	 * updated about events like CRC and physical errors?
+	 */
+	if (rt2x00_get_field32(word0, RXD_W0_CRC) ||
+	    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR))
+		goto skip_entry;
 
-			skb_reserve(skb, NET_IP_ALIGN);
-			skb_put(skb, ring->data_size + ring->desc_size);
-
-			urb->transfer_buffer = skb->data;
-			urb->transfer_buffer_length = skb->len;
-
-			rt2x00dev->rx_status.rate = device_signal_to_rate(
-				&rt2x00dev->hwmodes[0],
-				rt2x00_get_field32(word1, RXD_W1_SIGNAL),
-				rt2x00_get_field32(word0, RXD_W0_OFDM));
-
-			rt2x00dev->rx_status.ssi =
-				rt2x00_get_field32(word1, RXD_W1_RSSI);
-			rt2x00dev->rx_status.noise =
-				rt2x00_get_link_noise(&rt2x00dev->link);
-
-			/*
-			 * Trim the skb_buffer to only contain the valid
-			 * frame data (so ignore the device's descriptor).
-			 */
-			size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
-			skb_pull(entry->skb, ring->desc_size);
-			skb_trim(entry->skb, size);
-
-			__ieee80211_rx(rt2x00dev->hw,
-				entry->skb, &rt2x00dev->rx_status);
-			entry->skb = skb;
-
-			/*
-			 * Update link statistics
-			 */
-			rt2x00_update_link_rssi(&rt2x00dev->link,
-				rt2x00dev->rx_status.ssi);
-		}
+	/*
+	 * Allocate a new sk_buffer to replace the sk_buffer
+	 * that has been filled in by the device.
+	 */
+	skb = dev_alloc_skb(NET_IP_ALIGN + ring->data_size + ring->desc_size);
+	if (!skb)
+		return;
 
-		SET_FLAG(entry, ENTRY_OWNER_NIC);
-		usb_submit_urb(urb, GFP_ATOMIC);
+	skb_reserve(skb, NET_IP_ALIGN);
+	skb_put(skb, ring->data_size + ring->desc_size);
 
-		rt2x00_ring_index_inc(ring);
-	}
+	urb->transfer_buffer = skb->data;
+	urb->transfer_buffer_length = skb->len;
+
+	signal = rt2x00_get_field32(word1, RXD_W1_SIGNAL);
+	rssi = rt2x00_get_field32(word1, RXD_W1_RSSI);
+	ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
+	rt2x00lib_update_rx_stats(rt2x00dev, signal, rssi, ofdm);
+
+	/*
+	 * Trim the skb_buffer to only contain the valid
+	 * frame data (so ignore the device's descriptor).
+	 */
+	size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
+	skb_pull(entry->skb, ring->desc_size);
+	skb_trim(entry->skb, size);
+
+	/*
+	 * Send frame to stack, and set the new sk_buffer
+	 * in its place to be able to receive new frames
+	 * in the new buffer.
+	 */
+	ieee80211_rx_irqsafe(rt2x00dev->hw, entry->skb, &rt2x00dev->rx_status);
+	entry->skb = skb;
+
+	/*
+	 * Update link statistics
+	 */
+	rt2x00_update_link_rssi(&rt2x00dev->link, rt2x00dev->rx_status.ssi);
+
+skip_entry:
+	if (!GET_FLAG(ring->rt2x00dev, DEVICE_ENABLED_RADIO))
+		return;
+
+	SET_FLAG(entry, ENTRY_OWNER_NIC);
+	usb_submit_urb(urb, GFP_ATOMIC);
+	rt2x00_ring_index_inc(ring);
 }
 
-static void rt73usb_txdone(struct work_struct *work)
+static void rt73usb_interrupt_txdone(struct urb *urb)
 {
-	struct data_ring *ring =
-		container_of(work, struct data_ring, irq_work);
+	struct data_entry *entry = (struct data_entry*)urb->context;
+	struct data_ring *ring = entry->ring;
 	struct rt2x00_dev *rt2x00dev = ring->rt2x00dev;
-	struct data_entry *entry;
-	struct data_desc *txd;
-	struct urb *urb;
+	struct data_desc *txd = (struct data_desc *)entry->skb->data;
 	u32 word;
 	int tx_status;
 	int ack;
-	int rts;
 
-	while (!rt2x00_ring_empty(ring)) {
-		entry = rt2x00_get_data_entry_done(ring);
-		txd = (struct data_desc *)entry->skb->data;
-		urb = entry->priv;
-		rt2x00_desc_read(txd, 0, &word);
+	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO) ||
+	    !GET_FLAG(entry, ENTRY_OWNER_NIC))
+		return;
 
-		if (GET_FLAG(entry, ENTRY_OWNER_NIC))
-			break;
+	CLEAR_FLAG(entry, ENTRY_OWNER_NIC);
 
-		entry->tx_status.flags = 0;
-		entry->tx_status.queue_length = entry->ring->stats.limit;
-		entry->tx_status.queue_number = entry->tx_status.control.queue;
+	rt2x00_desc_read(txd, 0, &word);
 
-		/*
-		 * Check if we have received an
-		 * ACK response when ACK was requested and status
-		 * was succesfull.
-		 */
-		ack = rt2x00_get_field32(word, TXD_W0_ACK);
-		rts = GET_FLAG(entry, ENTRY_RTS_CTS_FRAME);
-		tx_status = !urb->status ? TX_SUCCESS : TX_FAIL_RETRY;
-		rt2x00_update_tx_stats(rt2x00dev, &entry->tx_status, tx_status,
-			ack, rts);
+	ack = rt2x00_get_field32(word, TXD_W0_ACK);
+	tx_status = !urb->status ? TX_SUCCESS : TX_FAIL_RETRY;
+	rt2x00lib_update_tx_stats(entry, tx_status, ack, 0);
 
-		rt2x00_bbp_read(rt2x00dev, 32,
-			(u8*)&entry->tx_status.ack_signal);
+	skb_pull(entry->skb, ring->desc_size);
 
-		skb_pull(entry->skb, ring->desc_size);
+	/*
+	 * If this is not an RTS frame send the tx_status to mac80211,
+	 * that method also cleans up the skb structure. When this
+	 * is a RTS frame, that it is our job to clean this structure up.
+	 */
+	if (!GET_FLAG(entry, ENTRY_RTS_CTS_FRAME))
+		ieee80211_tx_status_irqsafe(rt2x00dev->hw,
+			entry->skb, &entry->tx_status);
+	else
+		dev_kfree_skb(entry->skb);
 
-		/*
-		 * If this is not an RTS frame send the tx_status to mac80211,
-		 * that method also cleans up the skb structure. When this
-		 * is a RTS frame, that it is our job to clean this structure up.
-		 */
-		if (!rts)
-			ieee80211_tx_status(rt2x00dev->hw,
-				entry->skb, &entry->tx_status);
-		else
-			dev_kfree_skb(entry->skb);
+	entry->skb = NULL;
 
-		CLEAR_FLAG(entry, ENTRY_RTS_CTS_FRAME);
-		entry->skb = NULL;
+	CLEAR_FLAG(entry, ENTRY_RTS_CTS_FRAME);
 
-		rt2x00_ring_index_done_inc(entry->ring);
-	}
+	rt2x00_ring_index_done_inc(entry->ring);
 
 	/*
 	 * Check if we are waiting on an empty queue
@@ -2169,28 +2139,11 @@ static void rt73usb_txdone(struct work_struct *work)
 	 * we must make sure the packet queue in the mac80211 stack
 	 * is reenabled when the txdone handler has finished.
 	 */
-	entry = ring->entry;
 	if (!rt2x00_ring_full(ring))
 		ieee80211_wake_queue(rt2x00dev->hw,
 			entry->tx_status.control.queue);
 }
 
-static void rt73usb_interrupt(struct urb *urb)
-{
-	struct data_entry *entry = (struct data_entry*)urb->context;
-	struct rt2x00_dev *rt2x00dev = entry->ring->rt2x00dev;
-
-	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
-		return;
-
-	CLEAR_FLAG(entry, ENTRY_OWNER_NIC);
-
-	if (urb->status)
-		return;
-
-	queue_work(rt2x00dev->workqueue, &entry->ring->irq_work);
-}
-
 /*
  * IEEE80211 stack callback functions.
  */
@@ -2734,7 +2687,7 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw,
 		usb_sndbulkpipe(usb_dev, 1),
 		skb->data,
 		length,
-		rt73usb_interrupt,
+		rt73usb_interrupt_beacondone,
 		beacon);
 
 	beacon->skb = skb;
@@ -2751,7 +2704,7 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw,
 		usb_sndbulkpipe(usb_dev, 1),
 		&guardian->reg,
 		1,
-		rt73usb_interrupt,
+		rt73usb_interrupt_beacondone,
 		guardian);
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.h b/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
index dd32800..2a976c0 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
@@ -969,9 +969,8 @@ static void rt73usb_disable_radio(struct rt2x00_dev *rt2x00dev);
 /*
  * Interrupt functions.
  */
-static void rt73usb_beacondone(struct work_struct *work);
-static void rt73usb_rxdone(struct work_struct *work);
-static void rt73usb_txdone(struct work_struct *work);
-static void rt73usb_interrupt(struct urb *urb);
+static void rt73usb_interrupt_beacondone(struct urb *urb);
+static void rt73usb_interrupt_rxdone(struct urb *urb);
+static void rt73usb_interrupt_txdone(struct urb *urb);
 
 #endif /* RT73USB_H */
