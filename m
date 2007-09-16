Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:52973 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbXIPMH4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:07:56 -0400
Received: by an-out-0708.google.com with SMTP id d31so189208and
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:07:55 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 5/24] rt2x00: Fix rt61pci and rt73usb beacon handling
Date: Sun, 16 Sep 2007 14:18:10 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161418.12460.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Beacon handling in rt61pci and rt73usb is completely
different compared to older chipsets.
These devices have 4 slots for Beacons to which
the beacon should be written. The entire beacon
including the decsriptor needs to be written to
a particular slot and beacon generator needs to
be kicked afterwards.

Because the CSR cache size is limited (8 bytes),
we cannot use it to write the beacon to the device.
Because of that we need to use rt2x00usb_vendor_request()
instead of rt73usb_register_multiwrite() to bybass the cache usage.
This should be safe, since skb->data is allocated using
kmalloc() or friend.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |  109 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2x00usb.c |  107 ------------------------------
 drivers/net/wireless/rt2x00/rt2x00usb.h |    6 --
 drivers/net/wireless/rt2x00/rt61pci.c   |   77 +++++++++++++++++++---
 drivers/net/wireless/rt2x00/rt73usb.c   |   57 ++++++++++++++++-
 5 files changed, 230 insertions(+), 126 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index dc247c4..06219ce 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1139,6 +1139,38 @@ static int rt2500usb_fill_rxdone(struct data_entry *entry,
 }
 
 /*
+ * Interrupt functions.
+ */
+static void rt2500usb_beacondone(struct urb *urb)
+{
+	struct data_entry *entry = (struct data_entry *)urb->context;
+	struct data_ring *ring = entry->ring;
+
+	if (!test_bit(DEVICE_ENABLED_RADIO, &ring->rt2x00dev->flags))
+		return;
+
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
+}
+
+/*
  * Device probe functions.
  */
 static int rt2500usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
@@ -1556,6 +1588,81 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * IEEE80211 stack callback functions.
  */
+static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
+				   struct sk_buff *skb,
+				   struct ieee80211_tx_control *control)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct usb_device *usb_dev =
+	    interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
+	struct data_ring *ring =
+	    rt2x00lib_get_ring(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
+	struct data_entry *beacon;
+	struct data_entry *guardian;
+	int length;
+
+	/*
+	 * Just in case the ieee80211 doesn't set this,
+	 * but we need this queue set for the descriptor
+	 * initialization.
+	 */
+	control->queue = IEEE80211_TX_QUEUE_BEACON;
+
+	/*
+	 * Obtain 2 entries, one for the guardian byte,
+	 * the second for the actual beacon.
+	 */
+	guardian = rt2x00_get_data_entry(ring);
+	rt2x00_ring_index_inc(ring);
+	beacon = rt2x00_get_data_entry(ring);
+
+	/*
+	 * First we create the beacon.
+	 */
+	skb_push(skb, ring->desc_size);
+	rt2x00lib_write_tx_desc(rt2x00dev, beacon,
+				(struct data_desc *)skb->data,
+				(struct ieee80211_hdr *)(skb->data +
+							 ring->desc_size),
+				skb->len - ring->desc_size, control);
+
+	/*
+	 * Length passed to usb_fill_urb cannot be an odd number,
+	 * so add 1 byte to make it even.
+	 */
+	length = skb->len;
+	if (length % 2)
+		length++;
+
+	usb_fill_bulk_urb(beacon->priv, usb_dev,
+			  usb_sndbulkpipe(usb_dev, 1),
+			  skb->data, length, rt2500usb_beacondone, beacon);
+
+	beacon->skb = skb;
+
+	/*
+	 * Second we need to create the guardian byte.
+	 * We only need a single byte, so lets recycle
+	 * the 'flags' field we are not using for beacons.
+	 */
+	guardian->flags = 0;
+	usb_fill_bulk_urb(guardian->priv, usb_dev,
+			  usb_sndbulkpipe(usb_dev, 1),
+			  &guardian->flags, 1, rt2500usb_beacondone, guardian);
+
+	/*
+	 * Send out the guardian byte.
+	 */
+	usb_submit_urb(guardian->priv, GFP_ATOMIC);
+
+	/*
+	 * Enable beacon generation.
+	 */
+	rt2500usb_kick_tx_queue(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
+
+	return 0;
+}
+
 static const struct ieee80211_ops rt2500usb_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
 	.add_interface		= rt2x00mac_add_interface,
@@ -1566,7 +1673,7 @@ static const struct ieee80211_ops rt2500usb_mac80211_ops = {
 	.get_stats		= rt2x00mac_get_stats,
 	.conf_tx		= rt2x00mac_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
-	.beacon_update		= rt2x00usb_beacon_update,
+	.beacon_update		= rt2500usb_beacon_update,
 };
 
 static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 31ef87a..246ba93 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -108,113 +108,6 @@ int rt2x00usb_vendor_request_buff(const struct rt2x00_dev *rt2x00dev,
 EXPORT_SYMBOL_GPL(rt2x00usb_vendor_request_buff);
 
 /*
- * Beacon handlers.
- */
-static void rt2x00usb_beacondone(struct urb *urb)
-{
-	struct data_entry *entry = (struct data_entry *)urb->context;
-	struct data_ring *ring = entry->ring;
-
-	if (!test_bit(DEVICE_ENABLED_RADIO, &ring->rt2x00dev->flags))
-		return;
-
-	/*
-	 * Check if this was the guardian beacon,
-	 * if that was the case we need to send the real beacon now.
-	 * Otherwise we should free the sk_buffer, the device
-	 * should be doing the rest of the work now.
-	 */
-	if (ring->index == 1) {
-		rt2x00_ring_index_done_inc(ring);
-		entry = rt2x00_get_data_entry(ring);
-		usb_submit_urb(entry->priv, GFP_ATOMIC);
-		rt2x00_ring_index_inc(ring);
-	} else if (ring->index_done == 1) {
-		entry = rt2x00_get_data_entry_done(ring);
-		if (entry->skb) {
-			dev_kfree_skb(entry->skb);
-			entry->skb = NULL;
-		}
-		rt2x00_ring_index_done_inc(ring);
-	}
-}
-
-int rt2x00usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
-			    struct ieee80211_tx_control *control)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct usb_device *usb_dev =
-	    interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
-	struct data_ring *ring =
-	    rt2x00lib_get_ring(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
-	struct data_entry *beacon;
-	struct data_entry *guardian;
-	int length;
-
-	/*
-	 * Just in case the ieee80211 doesn't set this,
-	 * but we need this queue set for the descriptor
-	 * initialization.
-	 */
-	control->queue = IEEE80211_TX_QUEUE_BEACON;
-
-	/*
-	 * Obtain 2 entries, one for the guardian byte,
-	 * the second for the actual beacon.
-	 */
-	guardian = rt2x00_get_data_entry(ring);
-	rt2x00_ring_index_inc(ring);
-	beacon = rt2x00_get_data_entry(ring);
-
-	/*
-	 * First we create the beacon.
-	 */
-	skb_push(skb, ring->desc_size);
-	rt2x00lib_write_tx_desc(rt2x00dev, beacon,
-				(struct data_desc *)skb->data,
-				(struct ieee80211_hdr *)(skb->data +
-							 ring->desc_size),
-				skb->len - ring->desc_size, control);
-
-	/*
-	 * Length passed to usb_fill_urb cannot be an odd number,
-	 * so add 1 byte to make it even.
-	 */
-	length = skb->len;
-	if (length % 2)
-		length++;
-
-	usb_fill_bulk_urb(beacon->priv, usb_dev,
-			  usb_sndbulkpipe(usb_dev, 1),
-			  skb->data, length, rt2x00usb_beacondone, beacon);
-
-	beacon->skb = skb;
-
-	/*
-	 * Second we need to create the guardian byte.
-	 * We only need a single byte, so lets recycle
-	 * the 'flags' field we are not using for beacons.
-	 */
-	guardian->flags = 0;
-	usb_fill_bulk_urb(guardian->priv, usb_dev,
-			  usb_sndbulkpipe(usb_dev, 1),
-			  &guardian->flags, 1, rt2x00usb_beacondone, guardian);
-
-	/*
-	 * Send out the guardian byte.
-	 */
-	usb_submit_urb(guardian->priv, GFP_ATOMIC);
-
-	/*
-	 * Enable beacon generation.
-	 */
-	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, control->queue);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(rt2x00usb_beacon_update);
-
-/*
  * TX data handlers.
  */
 static void rt2x00usb_interrupt_txdone(struct urb *urb)
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index eb410d2..f3be092 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -151,12 +151,6 @@ void rt2x00usb_enable_radio(struct rt2x00_dev *rt2x00dev);
 void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev);
 
 /*
- * Beacon handlers.
- */
-int rt2x00usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
-			    struct ieee80211_tx_control *control);
-
-/*
  * TX data handlers.
  */
 int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 7a0ba33..fe9edb9 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -331,7 +331,17 @@ static void rt61pci_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 {
 	u32 reg;
 
+	/*
+	 * Clear current synchronisation setup.
+	 * For the Beacon base registers we only need to clear
+	 * the first byte since that byte contains the VALID and OWNER
+	 * bits which (when set to 0) will invalidate the entire beacon.
+	 */
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, 0);
+	rt2x00pci_register_write(rt2x00dev, HW_BEACON_BASE0, 0);
+	rt2x00pci_register_write(rt2x00dev, HW_BEACON_BASE1, 0);
+	rt2x00pci_register_write(rt2x00dev, HW_BEACON_BASE2, 0);
+	rt2x00pci_register_write(rt2x00dev, HW_BEACON_BASE3, 0);
 
 	/*
 	 * Apply hardware packet filter.
@@ -1332,7 +1342,6 @@ static void rt61pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	rt2x00pci_register_read(rt2x00dev, INT_MASK_CSR, &reg);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_TXDONE, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_RXDONE, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_BEACON_DONE, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_ENABLE_MITIGATION, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_MITIGATION_PERIOD, 0xff);
 	rt2x00pci_register_write(rt2x00dev, INT_MASK_CSR, reg);
@@ -1550,6 +1559,12 @@ static void rt61pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 
 	if (queue == IEEE80211_TX_QUEUE_BEACON) {
+		/*
+		 * For Wi-Fi faily generated beacons between participating
+		 * stations. Set TBTT phase adaptive adjustment step to 8us.
+		 */
+		rt2x00pci_register_write(rt2x00dev, TXRX_CSR10, 0x00001008);
+
 		rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
 		if (!rt2x00_get_field32(reg, TXRX_CSR9_BEACON_GEN)) {
 			rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
@@ -1743,25 +1758,19 @@ static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 	 */
 
 	/*
-	 * 1 - Beacon timer expired interrupt.
-	 */
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_BEACON_DONE))
-		rt2x00lib_beacondone(rt2x00dev);
-
-	/*
-	 * 2 - Rx ring done interrupt.
+	 * 1 - Rx ring done interrupt.
 	 */
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_RXDONE))
 		rt2x00pci_rxdone(rt2x00dev);
 
 	/*
-	 * 3 - Tx ring done interrupt.
+	 * 2 - Tx ring done interrupt.
 	 */
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TXDONE))
 		rt61pci_txdone(rt2x00dev);
 
 	/*
-	 * 4 - Handle MCU command done.
+	 * 3 - Handle MCU command done.
 	 */
 	if (reg_mcu)
 		rt2x00pci_register_write(rt2x00dev,
@@ -2119,6 +2128,7 @@ static void rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags =
+	    IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_MONITOR_DURING_OPER |
 	    IEEE80211_HW_NO_PROBE_FILTERING;
@@ -2241,6 +2251,51 @@ static void rt61pci_reset_tsf(struct ieee80211_hw *hw)
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR13, 0);
 }
 
+int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
+			  struct ieee80211_tx_control *control)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct data_ring *ring =
+	    rt2x00lib_get_ring(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
+
+	/*
+	 * Just in case the ieee80211 doesn't set this,
+	 * but we need this queue set for the descriptor
+	 * initialization.
+	 */
+	control->queue = IEEE80211_TX_QUEUE_BEACON;
+
+	/*
+	 * We need to append the descriptor in front of the
+	 * beacon frame.
+	 */
+	if (skb_headroom(skb) < ring->desc_size) {
+		if (pskb_expand_head(skb, ring->desc_size, 0, GFP_ATOMIC)) {
+			dev_kfree_skb(skb);
+			return -ENOMEM;
+		}
+	}
+
+	/*
+	 * First we create the beacon.
+	 */
+	skb_push(skb, ring->desc_size);
+	rt2x00lib_write_tx_desc(rt2x00dev, ring->entry,
+				(struct data_desc *)skb->data,
+				(struct ieee80211_hdr *)(skb->data +
+							 ring->desc_size),
+				skb->len - ring->desc_size, control);
+
+	/*
+	 * Write entire beacon with descriptor to register,
+	 * and kick the beacon generator.
+	 */
+	rt2x00pci_register_multiwrite(rt2x00dev, HW_BEACON_BASE0, skb->data, skb->len);
+	rt61pci_kick_tx_queue(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
+
+	return 0;
+}
+
 static const struct ieee80211_ops rt61pci_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
 	.add_interface		= rt2x00mac_add_interface,
@@ -2254,7 +2309,7 @@ static const struct ieee80211_ops rt61pci_mac80211_ops = {
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt61pci_get_tsf,
 	.reset_tsf		= rt61pci_reset_tsf,
-	.beacon_update		= rt2x00pci_beacon_update,
+	.beacon_update		= rt61pci_beacon_update,
 };
 
 static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 9a08d49..78c15f4 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -312,7 +312,17 @@ static void rt73usb_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 {
 	u32 reg;
 
+	/*
+	 * Clear current synchronisation setup.
+	 * For the Beacon base registers we only need to clear
+	 * the first byte since that byte contains the VALID and OWNER
+	 * bits which (when set to 0) will invalidate the entire beacon.
+	 */
 	rt73usb_register_write(rt2x00dev, TXRX_CSR9, 0);
+	rt73usb_register_write(rt2x00dev, HW_BEACON_BASE0, 0);
+	rt73usb_register_write(rt2x00dev, HW_BEACON_BASE1, 0);
+	rt73usb_register_write(rt2x00dev, HW_BEACON_BASE2, 0);
+	rt73usb_register_write(rt2x00dev, HW_BEACON_BASE3, 0);
 
 	/*
 	 * Apply hardware packet filter.
@@ -1289,6 +1299,12 @@ static void rt73usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 	if (queue != IEEE80211_TX_QUEUE_BEACON)
 		return;
 
+	/*
+	 * For Wi-Fi faily generated beacons between participating stations.
+	 * Set TBTT phase adaptive adjustment step to 8us (default 16us)
+	 */
+	rt73usb_register_write(rt2x00dev, TXRX_CSR10, 0x00001008);
+
 	rt73usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
 	if (!rt2x00_get_field32(reg, TXRX_CSR9_BEACON_GEN)) {
 		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
@@ -1850,6 +1866,45 @@ static void rt73usb_reset_tsf(struct ieee80211_hw *hw)
 	rt73usb_register_write(rt2x00dev, TXRX_CSR13, 0);
 }
 
+int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
+			  struct ieee80211_tx_control *control)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct data_ring *ring =
+	    rt2x00lib_get_ring(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
+	int timeout;
+
+	/*
+	 * Just in case the ieee80211 doesn't set this,
+	 * but we need this queue set for the descriptor
+	 * initialization.
+	 */
+	control->queue = IEEE80211_TX_QUEUE_BEACON;
+
+	/*
+	 * First we create the beacon.
+	 */
+	skb_push(skb, ring->desc_size);
+	rt2x00lib_write_tx_desc(rt2x00dev, ring->entry,
+				(struct data_desc *)skb->data,
+				(struct ieee80211_hdr *)(skb->data +
+							 ring->desc_size),
+				skb->len - ring->desc_size, control);
+
+	/*
+	 * Write entire beacon with descriptor to register,
+	 * and kick the beacon generator.
+	 */
+	timeout = REGISTER_TIMEOUT * (skb->len / sizeof(u32));
+	rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_WRITE,
+				 USB_VENDOR_REQUEST_OUT,
+				 HW_BEACON_BASE0, 0x0000,
+				 skb->data, skb->len, timeout);
+	rt73usb_kick_tx_queue(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
+
+	return 0;
+}
+
 static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
 	.add_interface		= rt2x00mac_add_interface,
@@ -1868,7 +1923,7 @@ static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.get_tsf		= rt73usb_get_tsf,
 #endif
 	.reset_tsf		= rt73usb_reset_tsf,
-	.beacon_update		= rt2x00usb_beacon_update,
+	.beacon_update		= rt73usb_beacon_update,
 };
 
 static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
-- 
1.5.3
