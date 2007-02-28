Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:48611 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427AbXB1OHd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:33 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562551nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:33 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 11/28] rt2x00: Add guardian byte for beacons
Date: Wed, 28 Feb 2007 15:07:16 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.16827.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

USB devices need a second entry in the beacon ring,
the second entry is intended for the beacon data,
but the first is a guardian byte that needs to be send
first. Without that, there will be no beacon generation.
And after the beacon generation has started, there is no
need to update the beacon anymore the device will handle
everything.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 49e70ca..1ea6696 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -1751,18 +1751,30 @@ static void rt2500usb_beacondone(struct work_struct *work)
 {
 	struct data_ring *ring =
 		container_of(work, struct data_ring, irq_work);
-	struct rt2x00_dev *rt2x00dev = ring->rt2x00dev;
-	struct data_entry *entry = rt2x00_get_data_entry(ring);
-	struct sk_buff *skb;
+	struct data_entry *entry;
 
-	skb = ieee80211_beacon_get(rt2x00dev->hw,
-		rt2x00dev->interface.id, &entry->tx_status.control);
-	if (!skb)
+	if (!GET_FLAG(ring->rt2x00dev, DEVICE_ENABLED_RADIO))
 		return;
 
-	rt2500usb_beacon_update(rt2x00dev->hw, skb, &entry->tx_status.control);
-
-	dev_kfree_skb_any(skb);
+	/*
+	 * Check if this was the guardian beacon,
+	 * if that was the case we need to send the real beacon now.
+	 * Otherwise we should free the sk_buffer, the device
+	 * should be doing the rest of the work now.
+	 */
+	if (ring->index == 1) {
+		rt2x00_ring_index_done_inc(ring);
+		entry = rt2x00_get_data_entry(ring);
+		usb_submit_urb(entry->priv, GFP_ATOMIC);
+		rt2x00_ring_index_inc(ring);
+	} else if (ring->index_done == 1) {
+		entry = rt2x00_get_data_entry_done(ring);
+		if (entry->skb) {
+			dev_kfree_skb(entry->skb);
+			entry->skb = NULL;
+		}
+		rt2x00_ring_index_done_inc(ring);
+	}
 }
 
 static void rt2500usb_rxdone(struct work_struct *work)
@@ -2401,9 +2413,11 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct usb_device *usb_dev =
 		interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
-	struct data_entry *entry;
-
-	entry = rt2x00_get_data_entry(&rt2x00dev->ring[RING_BEACON]);
+	struct data_ring *ring = &rt2x00dev->ring[RING_BEACON];
+	struct data_entry *beacon;
+	struct data_entry *guardian;
+	int length;
+	u16 reg;
 
 	/*
 	 * Just in case the ieee80211 doesn't set this,
@@ -2413,22 +2427,79 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	control->queue = IEEE80211_TX_QUEUE_BEACON;
 
 	/*
-	 * Update the beacon entry.
+	 * Obtain 2 entries, one for the guardian byte,
+	 * the second for the actual beacon.
 	 */
-	memcpy(rt2x00_txdata_addr(entry), skb->data, skb->len);
-	rt2500usb_write_tx_desc(rt2x00dev, rt2x00_txdesc_addr(entry),
-		(struct ieee80211_hdr *)skb->data, skb->len, control);
+	guardian = rt2x00_get_data_entry(ring);
+	rt2x00_ring_index_inc(ring);
+	beacon = rt2x00_get_data_entry(ring);
+
+	/*
+	 * First we create the beacon.
+	 */
+	skb_push(skb, ring->desc_size);
+	rt2500usb_write_tx_desc(rt2x00dev,
+		(struct data_desc*)skb->data,
+		(struct ieee80211_hdr*)(skb->data + ring->desc_size),
+		skb->len - ring->desc_size,
+		control);
+
+	/*
+	 * Length passed to usb_fill_urb cannot be an odd number,
+	 * so add 1 byte to make it even.
+	 */
+	length = skb->len;
+	if (length % 2)
+		length++;
 
-	SET_FLAG(entry, ENTRY_OWNER_NIC);
 	usb_fill_bulk_urb(
-		rt2x00_urb(entry),
+		beacon->priv,
 		usb_dev,
 		usb_sndbulkpipe(usb_dev, 1),
-		entry->data_addr,
-		skb->len + rt2x00dev->ring[RING_BEACON].desc_size,
+		skb->data,
+		length,
 		rt2500usb_interrupt,
-		entry);
-	usb_submit_urb(rt2x00_urb(entry), GFP_ATOMIC);
+		beacon);
+
+	beacon->skb = skb;
+
+	/*
+	 * Second we need to create the guardian byte.
+	 * We only need a single byte, so lets recycle
+	 * the 'flags' field we are not using for beacons.
+	 */
+	guardian->reg = 0;
+	usb_fill_bulk_urb(
+		guardian->priv,
+		usb_dev,
+		usb_sndbulkpipe(usb_dev, 1),
+		&guardian->reg,
+		1,
+		rt2500usb_interrupt,
+		guardian);
+
+	/*
+	 * Send out the guardian byte.
+	 */
+	usb_submit_urb(guardian->priv, GFP_ATOMIC);
+
+	/*
+	 * Enable beacon generation.
+	 */
+	rt2x00_register_read(rt2x00dev, TXRX_CSR19, &reg);
+	if (!rt2x00_get_field16(reg, TXRX_CSR19_BEACON_GEN)) {
+		rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 1);
+		/*
+		 * Beacon generation will fail initially.
+		 * To prevent this we need to register the TXRX_CSR19
+		 * register several times.
+		 */
+		rt2x00_register_write(rt2x00dev, TXRX_CSR19, reg);
+		rt2x00_register_write(rt2x00dev, TXRX_CSR19, 0);
+		rt2x00_register_write(rt2x00dev, TXRX_CSR19, reg);
+		rt2x00_register_write(rt2x00dev, TXRX_CSR19, 0);
+		rt2x00_register_write(rt2x00dev, TXRX_CSR19, reg);
+	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
index d6e968c..b79f860 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
@@ -525,6 +525,11 @@ struct data_entry {
 #define ENTRY_RTS_CTS_FRAME	0x00000002
 
 	/*
+	 * extra register field
+	 */
+	unsigned int reg;
+
+	/*
 	 * Ring we belong to.
 	 */
 	struct data_ring *ring;
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00usb.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00usb.h
index a0dc726..b4f2961 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00usb.h
@@ -78,4 +78,10 @@
  */
 #define LINK_TUNE_INTERVAL	( 1 * HZ )
 
+/*
+ * USB devices need an additional Beacon (guardian beacon) to be generated.
+ */
+#undef BEACON_ENTRIES
+#define BEACON_ENTRIES 2
+
 #endif /* RT2X00USB_H */
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 43a07dc..2285a64 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -2023,19 +2023,30 @@ static void rt73usb_beacondone(struct work_struct *work)
 {
 	struct data_ring *ring =
 		container_of(work, struct data_ring, irq_work);
-	struct rt2x00_dev *rt2x00dev = ring->rt2x00dev;
-	struct data_entry *entry = rt2x00_get_data_entry(
-		&rt2x00dev->ring[RING_BEACON]);
-	struct sk_buff *skb;
+	struct data_entry *entry;
 
-	skb = ieee80211_beacon_get(rt2x00dev->hw,
-		rt2x00dev->interface.id, &entry->tx_status.control);
-	if (!skb)
+	if (!GET_FLAG(ring->rt2x00dev, DEVICE_ENABLED_RADIO))
 		return;
 
-	rt73usb_beacon_update(rt2x00dev->hw, skb, &entry->tx_status.control);
-
-	dev_kfree_skb_any(skb);
+	/*
+	 * Check if this was the guardian beacon,
+	 * if that was the case we need to send the real beacon now.
+	 * Otherwise we should free the sk_buffer, the device
+	 * should be doing the rest of the work now.
+	 */
+	if (ring->index == 1) {
+		rt2x00_ring_index_done_inc(ring);
+		entry = rt2x00_get_data_entry(ring);
+		usb_submit_urb(entry->priv, GFP_ATOMIC);
+		rt2x00_ring_index_inc(ring);
+	} else if (ring->index_done == 1) {
+		entry = rt2x00_get_data_entry_done(ring);
+		if (entry->skb) {
+			dev_kfree_skb(entry->skb);
+			entry->skb = NULL;
+		}
+		rt2x00_ring_index_done_inc(ring);
+	}
 }
 
 static void rt73usb_rxdone(struct work_struct *work)
@@ -2709,9 +2720,11 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw,
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct usb_device *usb_dev =
 		interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
-	struct data_entry *entry;
-
-	entry = rt2x00_get_data_entry(&rt2x00dev->ring[RING_BEACON]);
+	struct data_ring *ring = &rt2x00dev->ring[RING_BEACON];
+	struct data_entry *beacon;
+	struct data_entry *guardian;
+	int length;
+	u32 reg;
 
 	/*
 	 * Just in case the ieee80211 doesn't set this,
@@ -2721,22 +2734,70 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw,
 	control->queue = IEEE80211_TX_QUEUE_BEACON;
 
 	/*
-	 * Update the beacon entry.
+	 * Obtain 2 entries, one for the guardian byte,
+	 * the second for the actual beacon.
 	 */
-	memcpy(rt2x00_data_addr(entry), skb->data, skb->len);
-	rt73usb_write_tx_desc(rt2x00dev, rt2x00_desc_addr(entry),
-		(struct ieee80211_hdr *)skb->data, skb->len, control);
+	guardian = rt2x00_get_data_entry(ring);
+	rt2x00_ring_index_inc(ring);
+	beacon = rt2x00_get_data_entry(ring);
+
+	/*
+	 * First we create the beacon.
+	 */
+	skb_push(skb, ring->desc_size);
+	rt73usb_write_tx_desc(rt2x00dev,
+		(struct data_desc*)skb->data,
+		(struct ieee80211_hdr*)(skb->data + ring->desc_size),
+		skb->len - ring->desc_size,
+		control);
+
+	/*
+	 * Length passed to usb_fill_urb cannot be an odd number,
+	 * so add 1 byte to make it even.
+	 */
+	length = skb->len;
+	if (length % 2)
+		length++;
 
-	SET_FLAG(entry, ENTRY_OWNER_NIC);
 	usb_fill_bulk_urb(
-		rt2x00_urb(entry),
+		beacon->priv,
 		usb_dev,
 		usb_sndbulkpipe(usb_dev, 1),
-		entry->data_addr,
-		skb->len + rt2x00dev->ring[RING_BEACON].desc_size,
+		skb->data,
+		length,
 		rt73usb_interrupt,
-		entry);
-	usb_submit_urb(rt2x00_urb(entry), GFP_ATOMIC);
+		beacon);
+
+	beacon->skb = skb;
+
+	/*
+	 * Second we need to create the guardian byte.
+	 * We only need a single byte, so lets recycle
+	 * the 'flags' field we are not using for beacons.
+	 */
+	guardian->reg = 0;
+	usb_fill_bulk_urb(
+		guardian->priv,
+		usb_dev,
+		usb_sndbulkpipe(usb_dev, 1),
+		&guardian->reg,
+		1,
+		rt73usb_interrupt,
+		guardian);
+
+	/*
+	 * Send out the guardian byte.
+	 */
+	usb_submit_urb(guardian->priv, GFP_ATOMIC);
+
+	/*
+	 * Enable beacon generation.
+	 */
+	rt2x00_register_read(rt2x00dev, TXRX_CSR9, &reg);
+	if (!rt2x00_get_field32(reg, TXRX_CSR9_BEACON_GEN)) {
+		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
+		rt2x00_register_write(rt2x00dev, TXRX_CSR9, reg);
+	}
 
 	return 0;
 }
