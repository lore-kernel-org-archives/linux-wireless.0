Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:45369 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbXK0TwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 14:52:20 -0500
Received: by mu-out-0910.google.com with SMTP id i10so1400196mue
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 11:52:17 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/11] rt2x00: Add skb descriptor
Date: Tue, 27 Nov 2007 21:49:05 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200711272146.53518.IvDoorn@gmail.com>
In-Reply-To: <200711272146.53518.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711272149.05680.IvDoorn@gmail.com> (sfid-20071127_211138_571394_D3227139)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the skb->cb field to add a frame description that can be used
to transfer information passed each rt2x00 layer. This reduces the
required arguments for rt2x00lib_write_tx_desc().

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c  |   30 +++++++++++-----
 drivers/net/wireless/rt2x00/rt2x00.h     |    4 +--
 drivers/net/wireless/rt2x00/rt2x00dev.c  |   47 ++++++++++++--------------
 drivers/net/wireless/rt2x00/rt2x00pci.c  |   54 ++++++++++++++++++++++-------
 drivers/net/wireless/rt2x00/rt2x00ring.h |   22 ++++++++++++
 drivers/net/wireless/rt2x00/rt2x00usb.c  |   36 +++++++++++++++-----
 drivers/net/wireless/rt2x00/rt61pci.c    |   27 +++++++++++----
 drivers/net/wireless/rt2x00/rt73usb.c    |   27 +++++++++++----
 8 files changed, 174 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index f56f3ef..2ba8eda 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1686,8 +1686,8 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct usb_device *usb_dev =
 	    interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
-	struct data_ring *ring =
-	    rt2x00lib_get_ring(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
+	struct skb_desc *desc;
+	struct data_ring *ring;
 	struct data_entry *beacon;
 	struct data_entry *guardian;
 	int pipe = usb_sndbulkpipe(usb_dev, 1);
@@ -1699,6 +1699,7 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	 * initialization.
 	 */
 	control->queue = IEEE80211_TX_QUEUE_BEACON;
+	ring = rt2x00lib_get_ring(rt2x00dev, control->queue);
 
 	/*
 	 * Obtain 2 entries, one for the guardian byte,
@@ -1709,23 +1710,34 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	beacon = rt2x00_get_data_entry(ring);
 
 	/*
-	 * First we create the beacon.
+	 * Add the descriptor in front of the skb.
 	 */
 	skb_push(skb, ring->desc_size);
 	memset(skb->data, 0, ring->desc_size);
 
-	rt2x00lib_write_tx_desc(rt2x00dev, (__le32 *)skb->data,
-				(struct ieee80211_hdr *)(skb->data +
-							 ring->desc_size),
-				skb->len - ring->desc_size, control);
+	/*
+	 * Fill in skb descriptor
+	 */
+	desc = get_skb_desc(skb);
+	desc->desc_len = ring->desc_size;
+	desc->data_len = skb->len - ring->desc_size;
+	desc->desc = skb->data;
+	desc->data = skb->data + ring->desc_size;
+	desc->ring = ring;
+	desc->entry = beacon;
+
+	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
 
+	/*
+	 * USB devices cannot blindly pass the skb->len as the
+	 * length of the data to usb_fill_bulk_urb. Pass the skb
+	 * to the driver to determine what the length should be.
+	 */
 	length = rt2500usb_get_tx_data_len(rt2x00dev, skb);
 
 	usb_fill_bulk_urb(beacon->priv, usb_dev, pipe,
 			  skb->data, length, rt2500usb_beacondone, beacon);
 
-	beacon->skb = skb;
-
 	/*
 	 * Second we need to create the guardian byte.
 	 * We only need a single byte, so lets recycle
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index b2283ce..31e48c2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -901,9 +901,7 @@ void rt2x00lib_rxdone(struct data_entry *entry, struct sk_buff *skb,
  * TX descriptor initializer
  */
 void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-			     __le32 *txd,
-			     struct ieee80211_hdr *ieee80211hdr,
-			     unsigned int length,
+			     struct sk_buff *skb,
 			     struct ieee80211_tx_control *control);
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index e894978..4f32ee8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -573,36 +573,26 @@ EXPORT_SYMBOL_GPL(rt2x00lib_rxdone);
  * TX descriptor initializer
  */
 void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-			     __le32 *txd,
-			     struct ieee80211_hdr *ieee80211hdr,
-			     unsigned int length,
+			     struct sk_buff *skb,
 			     struct ieee80211_tx_control *control)
 {
 	struct txdata_entry_desc desc;
-	struct data_ring *ring;
+	struct skb_desc *skbdesc = get_skb_desc(skb);
+	struct ieee80211_hdr *ieee80211hdr = skbdesc->data;
+	__le32 *txd = skbdesc->desc;
 	int tx_rate;
 	int bitrate;
+	int length;
 	int duration;
 	int residual;
 	u16 frame_control;
 	u16 seq_ctrl;
 
-	/*
-	 * Make sure the descriptor is properly cleared.
-	 */
-	memset(&desc, 0x00, sizeof(desc));
+	memset(&desc, 0, sizeof(desc));
 
-	/*
-	 * Get ring pointer, if we fail to obtain the
-	 * correct ring, then use the first TX ring.
-	 */
-	ring = rt2x00lib_get_ring(rt2x00dev, control->queue);
-	if (!ring)
-		ring = rt2x00lib_get_ring(rt2x00dev, IEEE80211_TX_QUEUE_DATA0);
-
-	desc.cw_min = ring->tx_params.cw_min;
-	desc.cw_max = ring->tx_params.cw_max;
-	desc.aifs = ring->tx_params.aifs;
+	desc.cw_min = skbdesc->ring->tx_params.cw_min;
+	desc.cw_max = skbdesc->ring->tx_params.cw_max;
+	desc.aifs = skbdesc->ring->tx_params.aifs;
 
 	/*
 	 * Identify queue
@@ -683,17 +673,18 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	desc.signal = DEVICE_GET_RATE_FIELD(tx_rate, PLCP);
 	desc.service = 0x04;
 
+	length = skbdesc->data_len + FCS_LEN;
 	if (test_bit(ENTRY_TXD_OFDM_RATE, &desc.flags)) {
-		desc.length_high = ((length + FCS_LEN) >> 6) & 0x3f;
-		desc.length_low = ((length + FCS_LEN) & 0x3f);
+		desc.length_high = (length >> 6) & 0x3f;
+		desc.length_low = length & 0x3f;
 	} else {
 		bitrate = DEVICE_GET_RATE_FIELD(tx_rate, RATE);
 
 		/*
 		 * Convert length to microseconds.
 		 */
-		residual = get_duration_res(length + FCS_LEN, bitrate);
-		duration = get_duration(length + FCS_LEN, bitrate);
+		residual = get_duration_res(length, bitrate);
+		duration = get_duration(length, bitrate);
 
 		if (residual != 0) {
 			duration++;
@@ -716,8 +707,14 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			desc.signal |= 0x08;
 	}
 
-	rt2x00dev->ops->lib->write_tx_desc(rt2x00dev, txd, &desc,
-					   ieee80211hdr, length, control);
+	rt2x00dev->ops->lib->write_tx_desc(rt2x00dev, txd, &desc, ieee80211hdr,
+					   skbdesc->data_len, control);
+
+	/*
+	 * Update ring entry.
+	 */
+	skbdesc->entry->skb = skb;
+	memcpy(&skbdesc->entry->tx_status.control, control, sizeof(*control));
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_write_tx_desc);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index e654568..9b11c6d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -38,9 +38,9 @@ int rt2x00pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 			    struct ieee80211_tx_control *control)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct data_ring *ring =
-	    rt2x00lib_get_ring(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
-	struct data_entry *entry = rt2x00_get_data_entry(ring);
+	struct skb_desc *desc;
+	struct data_ring *ring;
+	struct data_entry *entry;
 
 	/*
 	 * Just in case mac80211 doesn't set this correctly,
@@ -48,14 +48,22 @@ int rt2x00pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * initialization.
 	 */
 	control->queue = IEEE80211_TX_QUEUE_BEACON;
+	ring = rt2x00lib_get_ring(rt2x00dev, control->queue);
+	entry = rt2x00_get_data_entry(ring);
 
 	/*
-	 * Update the beacon entry.
+	 * Fill in skb descriptor
 	 */
+	desc = get_skb_desc(skb);
+	desc->desc_len = ring->desc_size;
+	desc->data_len = skb->len;
+	desc->desc = entry->priv;
+	desc->data = skb->data;
+	desc->ring = ring;
+	desc->entry = entry;
+
 	memcpy(entry->data_addr, skb->data, skb->len);
-	rt2x00lib_write_tx_desc(rt2x00dev, entry->priv,
-				(struct ieee80211_hdr *)skb->data,
-				skb->len, control);
+	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
 
 	/*
 	 * Enable beacon generation.
@@ -73,9 +81,9 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 			    struct data_ring *ring, struct sk_buff *skb,
 			    struct ieee80211_tx_control *control)
 {
-	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
 	struct data_entry *entry = rt2x00_get_data_entry(ring);
 	__le32 *txd = entry->priv;
+	struct skb_desc *desc;
 	u32 word;
 
 	if (rt2x00_ring_full(ring)) {
@@ -95,11 +103,19 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 		return -EINVAL;
 	}
 
-	entry->skb = skb;
-	memcpy(&entry->tx_status.control, control, sizeof(*control));
+	/*
+	 * Fill in skb descriptor
+	 */
+	desc = get_skb_desc(skb);
+	desc->desc_len = ring->desc_size;
+	desc->data_len = skb->len;
+	desc->desc = entry->priv;
+	desc->data = skb->data;
+	desc->ring = ring;
+	desc->entry = entry;
+
 	memcpy(entry->data_addr, skb->data, skb->len);
-	rt2x00lib_write_tx_desc(rt2x00dev, txd, ieee80211hdr,
-				skb->len, control);
+	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
 
 	rt2x00_ring_index_inc(ring);
 
@@ -118,6 +134,7 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 	struct data_ring *ring = rt2x00dev->rx;
 	struct data_entry *entry;
 	struct sk_buff *skb;
+	struct skb_desc *skbdesc;
 	struct rxdata_entry_desc desc;
 	__le32 *rxd;
 	u32 word;
@@ -130,7 +147,7 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 		if (rt2x00_get_field32(word, RXD_ENTRY_OWNER_NIC))
 			break;
 
-		memset(&desc, 0x00, sizeof(desc));
+		memset(&desc, 0, sizeof(desc));
 		rt2x00dev->ops->lib->fill_rxdone(entry, &desc);
 
 		/*
@@ -146,6 +163,17 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 		memcpy(skb->data, entry->data_addr, desc.size);
 
 		/*
+		 * Fill in skb descriptor
+		 */
+		skbdesc = get_skb_desc(skb);
+		skbdesc->desc_len = desc.size;
+		skbdesc->data_len = entry->ring->desc_size;
+		skbdesc->desc = entry->priv;
+		skbdesc->data = skb->data;
+		skbdesc->ring = ring;
+		skbdesc->entry = entry;
+
+		/*
 		 * Send the frame to rt2x00lib for further processing.
 		 */
 		rt2x00lib_rxdone(entry, skb, &desc);
diff --git a/drivers/net/wireless/rt2x00/rt2x00ring.h b/drivers/net/wireless/rt2x00/rt2x00ring.h
index 5b871ad..5b32f3e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00ring.h
+++ b/drivers/net/wireless/rt2x00/rt2x00ring.h
@@ -27,6 +27,28 @@
 #define RT2X00RING_H
 
 /*
+ * skb_desc
+ * Descriptor information for the skb buffer
+ */
+struct skb_desc {
+	unsigned int frame_type;
+
+	unsigned int desc_len;
+	unsigned int data_len;
+
+	void *desc;
+	void *data;
+
+	struct data_ring *ring;
+	struct data_entry *entry;
+};
+
+static inline struct skb_desc* get_skb_desc(struct sk_buff *skb)
+{
+	return (struct skb_desc*)&skb->cb[0];
+}
+
+/*
  * rxdata_entry_desc
  * Summary of information that has been read from the
  * RX frame descriptor.
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 152058f..f1282c6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -176,7 +176,7 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	struct usb_device *usb_dev =
 	    interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
 	struct data_entry *entry = rt2x00_get_data_entry(ring);
-	int pipe = usb_sndbulkpipe(usb_dev, 1);
+	struct skb_desc *desc;
 	u32 length;
 
 	if (rt2x00_ring_full(ring)) {
@@ -199,12 +199,18 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	skb_push(skb, ring->desc_size);
 	memset(skb->data, 0, ring->desc_size);
 
-	rt2x00lib_write_tx_desc(rt2x00dev, (__le32 *)skb->data,
-				(struct ieee80211_hdr *)(skb->data +
-							 ring->desc_size),
-				skb->len - ring->desc_size, control);
-	memcpy(&entry->tx_status.control, control, sizeof(*control));
-	entry->skb = skb;
+	/*
+	 * Fill in skb descriptor
+	 */
+	desc = get_skb_desc(skb);
+	desc->desc_len = ring->desc_size;
+	desc->data_len = skb->len - ring->desc_size;
+	desc->desc = skb->data;
+	desc->data = skb->data + ring->desc_size;
+	desc->ring = ring;
+	desc->entry = entry;
+
+	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
 
 	/*
 	 * USB devices cannot blindly pass the skb->len as the
@@ -217,7 +223,7 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	 * Initialize URB and send the frame to the device.
 	 */
 	__set_bit(ENTRY_OWNER_NIC, &entry->flags);
-	usb_fill_bulk_urb(entry->priv, usb_dev, pipe,
+	usb_fill_bulk_urb(entry->priv, usb_dev, usb_sndbulkpipe(usb_dev, 1),
 			  skb->data, length, rt2x00usb_interrupt_txdone, entry);
 	usb_submit_urb(entry->priv, GFP_ATOMIC);
 
@@ -239,6 +245,7 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	struct data_ring *ring = entry->ring;
 	struct rt2x00_dev *rt2x00dev = ring->rt2x00dev;
 	struct sk_buff *skb;
+	struct skb_desc *skbdesc;
 	struct rxdata_entry_desc desc;
 	int frame_size;
 
@@ -254,7 +261,7 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	if (urb->actual_length < entry->ring->desc_size || urb->status)
 		goto skip_entry;
 
-	memset(&desc, 0x00, sizeof(desc));
+	memset(&desc, 0, sizeof(desc));
 	rt2x00dev->ops->lib->fill_rxdone(entry, &desc);
 
 	/*
@@ -277,6 +284,17 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	skb_trim(entry->skb, desc.size);
 
 	/*
+	 * Fill in skb descriptor
+	 */
+	skbdesc = get_skb_desc(entry->skb);
+	skbdesc->desc_len = desc.size;
+	skbdesc->data_len = entry->ring->desc_size;
+	skbdesc->desc = entry->skb->data + desc.size;
+	skbdesc->data = entry->skb->data;
+	skbdesc->ring = ring;
+	skbdesc->entry = entry;
+
+	/*
 	 * Send the frame to rt2x00lib for further processing.
 	 */
 	rt2x00lib_rxdone(entry, entry->skb, &desc);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 924f415..13c8086 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2409,6 +2409,9 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 			  struct ieee80211_tx_control *control)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct skb_desc *desc;
+	struct data_ring *ring;
+	struct data_entry *entry;
 
 	/*
 	 * Just in case the ieee80211 doesn't set this,
@@ -2416,6 +2419,8 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * initialization.
 	 */
 	control->queue = IEEE80211_TX_QUEUE_BEACON;
+	ring = rt2x00lib_get_ring(rt2x00dev, control->queue);
+	entry = rt2x00_get_data_entry(ring);
 
 	/*
 	 * We need to append the descriptor in front of the
@@ -2429,15 +2434,23 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	}
 
 	/*
-	 * First we create the beacon.
+	 * Add the descriptor in front of the skb.
+	 */
+	skb_push(skb, ring->desc_size);
+	memset(skb->data, 0, ring->desc_size);
+
+	/*
+	 * Fill in skb descriptor
 	 */
-	skb_push(skb, TXD_DESC_SIZE);
-	memset(skb->data, 0, TXD_DESC_SIZE);
+	desc = get_skb_desc(skb);
+	desc->desc_len = ring->desc_size;
+	desc->data_len = skb->len - ring->desc_size;
+	desc->desc = skb->data;
+	desc->data = skb->data + ring->desc_size;
+	desc->ring = ring;
+	desc->entry = entry;
 
-	rt2x00lib_write_tx_desc(rt2x00dev, (__le32 *)skb->data,
-				(struct ieee80211_hdr *)(skb->data +
-							 TXD_DESC_SIZE),
-				skb->len - TXD_DESC_SIZE, control);
+	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
 
 	/*
 	 * Write entire beacon with descriptor to register,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 49180de..8093a4d 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1965,6 +1965,9 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 			  struct ieee80211_tx_control *control)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct skb_desc *desc;
+	struct data_ring *ring;
+	struct data_entry *entry;
 	int timeout;
 
 	/*
@@ -1973,17 +1976,27 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * initialization.
 	 */
 	control->queue = IEEE80211_TX_QUEUE_BEACON;
+	ring = rt2x00lib_get_ring(rt2x00dev, control->queue);
+	entry = rt2x00_get_data_entry(ring);
 
 	/*
-	 * First we create the beacon.
+	 * Add the descriptor in front of the skb.
 	 */
-	skb_push(skb, TXD_DESC_SIZE);
-	memset(skb->data, 0, TXD_DESC_SIZE);
+	skb_push(skb, ring->desc_size);
+	memset(skb->data, 0, ring->desc_size);
 
-	rt2x00lib_write_tx_desc(rt2x00dev, (__le32 *)skb->data,
-				(struct ieee80211_hdr *)(skb->data +
-							 TXD_DESC_SIZE),
-				skb->len - TXD_DESC_SIZE, control);
+	/*
+	 * Fill in skb descriptor
+	 */
+	desc = get_skb_desc(skb);
+	desc->desc_len = ring->desc_size;
+	desc->data_len = skb->len - ring->desc_size;
+	desc->desc = skb->data;
+	desc->data = skb->data + ring->desc_size;
+	desc->ring = ring;
+	desc->entry = entry;
+
+	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
 
 	/*
 	 * Write entire beacon with descriptor to register,
-- 
1.5.3.6

