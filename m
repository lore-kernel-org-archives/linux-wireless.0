Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:30801 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759AbYAFWm5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 17:42:57 -0500
Received: by ug-out-1314.google.com with SMTP id z38so3071365ugc.16
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2008 14:42:56 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/12] rt2x00: Move init_txring and init_rxring into rt2x00lib
Date: Sun, 6 Jan 2008 23:41:45 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200801062337.35904.IvDoorn@gmail.com>
In-Reply-To: <200801062337.35904.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801062341.45402.IvDoorn@gmail.com> (sfid-20080106_224302_858296_C8387673)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prior to enabling the radio rt2x00lib should go through all
rings and for each entry should call the callback function
init_txentry() and init_rxentry().

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |   83 +++++++++-------------------
 drivers/net/wireless/rt2x00/rt2500pci.c |   69 +++++++-----------------
 drivers/net/wireless/rt2x00/rt2500usb.c |    4 +-
 drivers/net/wireless/rt2x00/rt2x00.h    |    8 +++
 drivers/net/wireless/rt2x00/rt2x00dev.c |   46 ++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00usb.c |   60 ++++++++-------------
 drivers/net/wireless/rt2x00/rt2x00usb.h |    5 ++-
 drivers/net/wireless/rt2x00/rt61pci.c   |   88 +++++++++++--------------------
 drivers/net/wireless/rt2x00/rt73usb.c   |    4 +-
 9 files changed, 163 insertions(+), 204 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 95db2cc..f4d0c77 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -592,65 +592,43 @@ static void rt2400pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 /*
  * Initialization functions.
  */
-static void rt2400pci_init_rxring(struct rt2x00_dev *rt2x00dev)
+static void rt2400pci_init_rxentry(struct rt2x00_dev *rt2x00dev,
+				   struct data_entry *entry)
 {
-	struct data_ring *ring = rt2x00dev->rx;
-	__le32 *rxd;
-	unsigned int i;
+	__le32 *rxd = entry->priv;
 	u32 word;
 
-	memset(ring->data_addr, 0x00, rt2x00_get_ring_size(ring));
-
-	for (i = 0; i < ring->stats.limit; i++) {
-		rxd = ring->entry[i].priv;
+	rt2x00_desc_read(rxd, 2, &word);
+	rt2x00_set_field32(&word, RXD_W2_BUFFER_LENGTH, entry->ring->data_size);
+	rt2x00_desc_write(rxd, 2, word);
 
-		rt2x00_desc_read(rxd, 2, &word);
-		rt2x00_set_field32(&word, RXD_W2_BUFFER_LENGTH,
-				   ring->data_size);
-		rt2x00_desc_write(rxd, 2, word);
-
-		rt2x00_desc_read(rxd, 1, &word);
-		rt2x00_set_field32(&word, RXD_W1_BUFFER_ADDRESS,
-				   ring->entry[i].data_dma);
-		rt2x00_desc_write(rxd, 1, word);
-
-		rt2x00_desc_read(rxd, 0, &word);
-		rt2x00_set_field32(&word, RXD_W0_OWNER_NIC, 1);
-		rt2x00_desc_write(rxd, 0, word);
-	}
+	rt2x00_desc_read(rxd, 1, &word);
+	rt2x00_set_field32(&word, RXD_W1_BUFFER_ADDRESS, entry->data_dma);
+	rt2x00_desc_write(rxd, 1, word);
 
-	rt2x00_ring_index_clear(rt2x00dev->rx);
+	rt2x00_desc_read(rxd, 0, &word);
+	rt2x00_set_field32(&word, RXD_W0_OWNER_NIC, 1);
+	rt2x00_desc_write(rxd, 0, word);
 }
 
-static void rt2400pci_init_txring(struct rt2x00_dev *rt2x00dev, const int queue)
+static void rt2400pci_init_txentry(struct rt2x00_dev *rt2x00dev,
+				   struct data_entry *entry)
 {
-	struct data_ring *ring = rt2x00lib_get_ring(rt2x00dev, queue);
-	__le32 *txd;
-	unsigned int i;
+	__le32 *txd = entry->priv;
 	u32 word;
 
-	memset(ring->data_addr, 0x00, rt2x00_get_ring_size(ring));
-
-	for (i = 0; i < ring->stats.limit; i++) {
-		txd = ring->entry[i].priv;
-
-		rt2x00_desc_read(txd, 1, &word);
-		rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS,
-				   ring->entry[i].data_dma);
-		rt2x00_desc_write(txd, 1, word);
+	rt2x00_desc_read(txd, 1, &word);
+	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, entry->data_dma);
+	rt2x00_desc_write(txd, 1, word);
 
-		rt2x00_desc_read(txd, 2, &word);
-		rt2x00_set_field32(&word, TXD_W2_BUFFER_LENGTH,
-				   ring->data_size);
-		rt2x00_desc_write(txd, 2, word);
-
-		rt2x00_desc_read(txd, 0, &word);
-		rt2x00_set_field32(&word, TXD_W0_VALID, 0);
-		rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 0);
-		rt2x00_desc_write(txd, 0, word);
-	}
+	rt2x00_desc_read(txd, 2, &word);
+	rt2x00_set_field32(&word, TXD_W2_BUFFER_LENGTH, entry->ring->data_size);
+	rt2x00_desc_write(txd, 2, word);
 
-	rt2x00_ring_index_clear(ring);
+	rt2x00_desc_read(txd, 0, &word);
+	rt2x00_set_field32(&word, TXD_W0_VALID, 0);
+	rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 0);
+	rt2x00_desc_write(txd, 0, word);
 }
 
 static int rt2400pci_init_rings(struct rt2x00_dev *rt2x00dev)
@@ -658,15 +636,6 @@ static int rt2400pci_init_rings(struct rt2x00_dev *rt2x00dev)
 	u32 reg;
 
 	/*
-	 * Initialize rings.
-	 */
-	rt2400pci_init_rxring(rt2x00dev);
-	rt2400pci_init_txring(rt2x00dev, IEEE80211_TX_QUEUE_DATA0);
-	rt2400pci_init_txring(rt2x00dev, IEEE80211_TX_QUEUE_DATA1);
-	rt2400pci_init_txring(rt2x00dev, IEEE80211_TX_QUEUE_AFTER_BEACON);
-	rt2400pci_init_txring(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
-
-	/*
 	 * Initialize registers.
 	 */
 	rt2x00pci_register_read(rt2x00dev, TXCSR2, &reg);
@@ -1569,6 +1538,8 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 	.probe_hw		= rt2400pci_probe_hw,
 	.initialize		= rt2x00pci_initialize,
 	.uninitialize		= rt2x00pci_uninitialize,
+	.init_rxentry		= rt2400pci_init_rxentry,
+	.init_txentry		= rt2400pci_init_txentry,
 	.set_device_state	= rt2400pci_set_device_state,
 	.rfkill_poll		= rt2400pci_rfkill_poll,
 	.link_stats		= rt2400pci_link_stats,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 133967e..206b50f 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -683,55 +683,35 @@ dynamic_cca_tune:
 /*
  * Initialization functions.
  */
-static void rt2500pci_init_rxring(struct rt2x00_dev *rt2x00dev)
+static void rt2500pci_init_rxentry(struct rt2x00_dev *rt2x00dev,
+				   struct data_entry *entry)
 {
-	struct data_ring *ring = rt2x00dev->rx;
-	__le32 *rxd;
-	unsigned int i;
+	__le32 *rxd = entry->priv;
 	u32 word;
 
-	memset(ring->data_addr, 0x00, rt2x00_get_ring_size(ring));
-
-	for (i = 0; i < ring->stats.limit; i++) {
-		rxd = ring->entry[i].priv;
-
-		rt2x00_desc_read(rxd, 1, &word);
-		rt2x00_set_field32(&word, RXD_W1_BUFFER_ADDRESS,
-				   ring->entry[i].data_dma);
-		rt2x00_desc_write(rxd, 1, word);
-
-		rt2x00_desc_read(rxd, 0, &word);
-		rt2x00_set_field32(&word, RXD_W0_OWNER_NIC, 1);
-		rt2x00_desc_write(rxd, 0, word);
-	}
+	rt2x00_desc_read(rxd, 1, &word);
+	rt2x00_set_field32(&word, RXD_W1_BUFFER_ADDRESS, entry->data_dma);
+	rt2x00_desc_write(rxd, 1, word);
 
-	rt2x00_ring_index_clear(rt2x00dev->rx);
+	rt2x00_desc_read(rxd, 0, &word);
+	rt2x00_set_field32(&word, RXD_W0_OWNER_NIC, 1);
+	rt2x00_desc_write(rxd, 0, word);
 }
 
-static void rt2500pci_init_txring(struct rt2x00_dev *rt2x00dev, const int queue)
+static void rt2500pci_init_txentry(struct rt2x00_dev *rt2x00dev,
+				   struct data_entry *entry)
 {
-	struct data_ring *ring = rt2x00lib_get_ring(rt2x00dev, queue);
-	__le32 *txd;
-	unsigned int i;
+	__le32 *txd = entry->priv;
 	u32 word;
 
-	memset(ring->data_addr, 0x00, rt2x00_get_ring_size(ring));
-
-	for (i = 0; i < ring->stats.limit; i++) {
-		txd = ring->entry[i].priv;
+	rt2x00_desc_read(txd, 1, &word);
+	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, entry->data_dma);
+	rt2x00_desc_write(txd, 1, word);
 
-		rt2x00_desc_read(txd, 1, &word);
-		rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS,
-				   ring->entry[i].data_dma);
-		rt2x00_desc_write(txd, 1, word);
-
-		rt2x00_desc_read(txd, 0, &word);
-		rt2x00_set_field32(&word, TXD_W0_VALID, 0);
-		rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 0);
-		rt2x00_desc_write(txd, 0, word);
-	}
-
-	rt2x00_ring_index_clear(ring);
+	rt2x00_desc_read(txd, 0, &word);
+	rt2x00_set_field32(&word, TXD_W0_VALID, 0);
+	rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 0);
+	rt2x00_desc_write(txd, 0, word);
 }
 
 static int rt2500pci_init_rings(struct rt2x00_dev *rt2x00dev)
@@ -739,15 +719,6 @@ static int rt2500pci_init_rings(struct rt2x00_dev *rt2x00dev)
 	u32 reg;
 
 	/*
-	 * Initialize rings.
-	 */
-	rt2500pci_init_rxring(rt2x00dev);
-	rt2500pci_init_txring(rt2x00dev, IEEE80211_TX_QUEUE_DATA0);
-	rt2500pci_init_txring(rt2x00dev, IEEE80211_TX_QUEUE_DATA1);
-	rt2500pci_init_txring(rt2x00dev, IEEE80211_TX_QUEUE_AFTER_BEACON);
-	rt2500pci_init_txring(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
-
-	/*
 	 * Initialize registers.
 	 */
 	rt2x00pci_register_read(rt2x00dev, TXCSR2, &reg);
@@ -1878,6 +1849,8 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 	.probe_hw		= rt2500pci_probe_hw,
 	.initialize		= rt2x00pci_initialize,
 	.uninitialize		= rt2x00pci_uninitialize,
+	.init_rxentry		= rt2500pci_init_rxentry,
+	.init_txentry		= rt2500pci_init_txentry,
 	.set_device_state	= rt2500pci_set_device_state,
 	.rfkill_poll		= rt2500pci_rfkill_poll,
 	.link_stats		= rt2500pci_link_stats,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 2a4e939..1b05b8a 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -920,8 +920,6 @@ static int rt2500usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 		return -EIO;
 	}
 
-	rt2x00usb_enable_radio(rt2x00dev);
-
 	/*
 	 * Enable LED
 	 */
@@ -1776,6 +1774,8 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.probe_hw		= rt2500usb_probe_hw,
 	.initialize		= rt2x00usb_initialize,
 	.uninitialize		= rt2x00usb_uninitialize,
+	.init_rxentry		= rt2x00usb_init_rxentry,
+	.init_txentry		= rt2x00usb_init_txentry,
 	.set_device_state	= rt2500usb_set_device_state,
 	.link_stats		= rt2500usb_link_stats,
 	.reset_tuner		= rt2500usb_reset_tuner,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 0795332..d8585a0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -474,6 +474,14 @@ struct rt2x00lib_ops {
 	void (*uninitialize) (struct rt2x00_dev *rt2x00dev);
 
 	/*
+	 * Ring initialization handlers
+	 */
+	void (*init_rxentry) (struct rt2x00_dev *rt2x00dev,
+			      struct data_entry *entry);
+	void (*init_txentry) (struct rt2x00_dev *rt2x00dev,
+			      struct data_entry *entry);
+
+	/*
 	 * Radio control handlers.
 	 */
 	int (*set_device_state) (struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index a114212..b26c634 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -103,6 +103,46 @@ void rt2x00lib_reset_link_tuner(struct rt2x00_dev *rt2x00dev)
 }
 
 /*
+ * Ring initialization
+ */
+static void rt2x00lib_init_rxrings(struct rt2x00_dev *rt2x00dev)
+{
+	struct data_ring *ring = rt2x00dev->rx;
+	unsigned int i;
+
+	if (!rt2x00dev->ops->lib->init_rxentry)
+		return;
+
+	if (ring->data_addr)
+		memset(ring->data_addr, 0, rt2x00_get_ring_size(ring));
+
+	for (i = 0; i < ring->stats.limit; i++)
+		rt2x00dev->ops->lib->init_rxentry(rt2x00dev, &ring->entry[i]);
+
+	rt2x00_ring_index_clear(ring);
+}
+
+static void rt2x00lib_init_txrings(struct rt2x00_dev *rt2x00dev)
+{
+	struct data_ring *ring;
+	unsigned int i;
+
+	if (!rt2x00dev->ops->lib->init_txentry)
+		return;
+
+	txringall_for_each(rt2x00dev, ring) {
+		if (ring->data_addr)
+			memset(ring->data_addr, 0, rt2x00_get_ring_size(ring));
+
+		for (i = 0; i < ring->stats.limit; i++)
+			rt2x00dev->ops->lib->init_txentry(rt2x00dev,
+							  &ring->entry[i]);
+
+		rt2x00_ring_index_clear(ring);
+	}
+}
+
+/*
  * Radio control handlers.
  */
 int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
@@ -118,6 +158,12 @@ int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
 		return 0;
 
 	/*
+	 * Initialize all data rings.
+	 */
+	rt2x00lib_init_rxrings(rt2x00dev);
+	rt2x00lib_init_txrings(rt2x00dev);
+
+	/*
 	 * Enable radio.
 	 */
 	status = rt2x00dev->ops->lib->set_device_state(rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 8a6218f..d15d469 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -326,43 +326,6 @@ skip_entry:
 /*
  * Radio handlers
  */
-void rt2x00usb_enable_radio(struct rt2x00_dev *rt2x00dev)
-{
-	struct usb_device *usb_dev =
-	    interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
-	struct data_ring *ring;
-	struct data_entry *entry;
-	unsigned int i;
-
-	/*
-	 * Initialize the TX rings
-	 */
-	txringall_for_each(rt2x00dev, ring) {
-		for (i = 0; i < ring->stats.limit; i++)
-			ring->entry[i].flags = 0;
-
-		rt2x00_ring_index_clear(ring);
-	}
-
-	/*
-	 * Initialize and start the RX ring.
-	 */
-	rt2x00_ring_index_clear(rt2x00dev->rx);
-
-	for (i = 0; i < rt2x00dev->rx->stats.limit; i++) {
-		entry = &rt2x00dev->rx->entry[i];
-
-		usb_fill_bulk_urb(entry->priv, usb_dev,
-				  usb_rcvbulkpipe(usb_dev, 1),
-				  entry->skb->data, entry->skb->len,
-				  rt2x00usb_interrupt_rxdone, entry);
-
-		__set_bit(ENTRY_OWNER_NIC, &entry->flags);
-		usb_submit_urb(entry->priv, GFP_ATOMIC);
-	}
-}
-EXPORT_SYMBOL_GPL(rt2x00usb_enable_radio);
-
 void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_ring *ring;
@@ -384,6 +347,29 @@ EXPORT_SYMBOL_GPL(rt2x00usb_disable_radio);
 /*
  * Device initialization handlers.
  */
+void rt2x00usb_init_rxentry(struct rt2x00_dev *rt2x00dev,
+			    struct data_entry *entry)
+{
+	struct usb_device *usb_dev =
+	     interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
+
+	usb_fill_bulk_urb(entry->priv, usb_dev,
+			  usb_rcvbulkpipe(usb_dev, 1),
+			  entry->skb->data, entry->skb->len,
+			  rt2x00usb_interrupt_rxdone, entry);
+
+	__set_bit(ENTRY_OWNER_NIC, &entry->flags);
+	usb_submit_urb(entry->priv, GFP_ATOMIC);
+}
+EXPORT_SYMBOL_GPL(rt2x00usb_init_rxentry);
+
+void rt2x00usb_init_txentry(struct rt2x00_dev *rt2x00dev,
+			    struct data_entry *entry)
+{
+	entry->flags = 0;
+}
+EXPORT_SYMBOL_GPL(rt2x00usb_init_txentry);
+
 static int rt2x00usb_alloc_urb(struct rt2x00_dev *rt2x00dev,
 			       struct data_ring *ring)
 {
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 2fa45c5..e40df40 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -154,7 +154,6 @@ static inline int rt2x00usb_eeprom_read(struct rt2x00_dev *rt2x00dev,
 /*
  * Radio handlers
  */
-void rt2x00usb_enable_radio(struct rt2x00_dev *rt2x00dev);
 void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev);
 
 /*
@@ -167,6 +166,10 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 /*
  * Device initialization handlers.
  */
+void rt2x00usb_init_rxentry(struct rt2x00_dev *rt2x00dev,
+			    struct data_entry *entry);
+void rt2x00usb_init_txentry(struct rt2x00_dev *rt2x00dev,
+			    struct data_entry *entry);
 int rt2x00usb_initialize(struct rt2x00_dev *rt2x00dev);
 void rt2x00usb_uninitialize(struct rt2x00_dev *rt2x00dev);
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 47b7430..b2dde4d 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -989,66 +989,46 @@ static int rt61pci_load_firmware(struct rt2x00_dev *rt2x00dev, void *data,
 	return 0;
 }
 
-static void rt61pci_init_rxring(struct rt2x00_dev *rt2x00dev)
+static void rt61pci_init_rxentry(struct rt2x00_dev *rt2x00dev,
+				 struct data_entry *entry)
 {
-	struct data_ring *ring = rt2x00dev->rx;
-	__le32 *rxd;
-	unsigned int i;
+	__le32 *rxd = entry->priv;
 	u32 word;
 
-	memset(ring->data_addr, 0x00, rt2x00_get_ring_size(ring));
-
-	for (i = 0; i < ring->stats.limit; i++) {
-		rxd = ring->entry[i].priv;
-
-		rt2x00_desc_read(rxd, 5, &word);
-		rt2x00_set_field32(&word, RXD_W5_BUFFER_PHYSICAL_ADDRESS,
-				   ring->entry[i].data_dma);
-		rt2x00_desc_write(rxd, 5, word);
-
-		rt2x00_desc_read(rxd, 0, &word);
-		rt2x00_set_field32(&word, RXD_W0_OWNER_NIC, 1);
-		rt2x00_desc_write(rxd, 0, word);
-	}
+	rt2x00_desc_read(rxd, 5, &word);
+	rt2x00_set_field32(&word, RXD_W5_BUFFER_PHYSICAL_ADDRESS,
+			   entry->data_dma);
+	rt2x00_desc_write(rxd, 5, word);
 
-	rt2x00_ring_index_clear(rt2x00dev->rx);
+	rt2x00_desc_read(rxd, 0, &word);
+	rt2x00_set_field32(&word, RXD_W0_OWNER_NIC, 1);
+	rt2x00_desc_write(rxd, 0, word);
 }
 
-static void rt61pci_init_txring(struct rt2x00_dev *rt2x00dev, const int queue)
+static void rt61pci_init_txentry(struct rt2x00_dev *rt2x00dev,
+				 struct data_entry *entry)
 {
-	struct data_ring *ring = rt2x00lib_get_ring(rt2x00dev, queue);
-	__le32 *txd;
-	unsigned int i;
+	__le32 *txd = entry->priv;
 	u32 word;
 
-	memset(ring->data_addr, 0x00, rt2x00_get_ring_size(ring));
-
-	for (i = 0; i < ring->stats.limit; i++) {
-		txd = ring->entry[i].priv;
-
-		rt2x00_desc_read(txd, 1, &word);
-		rt2x00_set_field32(&word, TXD_W1_BUFFER_COUNT, 1);
-		rt2x00_desc_write(txd, 1, word);
-
-		rt2x00_desc_read(txd, 5, &word);
-		rt2x00_set_field32(&word, TXD_W5_PID_TYPE,
-				   ring->queue_idx);
-		rt2x00_set_field32(&word, TXD_W5_PID_SUBTYPE,
-				   ring->entry[i].entry_idx);
-		rt2x00_desc_write(txd, 5, word);
+	rt2x00_desc_read(txd, 1, &word);
+	rt2x00_set_field32(&word, TXD_W1_BUFFER_COUNT, 1);
+	rt2x00_desc_write(txd, 1, word);
 
-		rt2x00_desc_read(txd, 6, &word);
-		rt2x00_set_field32(&word, TXD_W6_BUFFER_PHYSICAL_ADDRESS,
-				   ring->entry[i].data_dma);
-		rt2x00_desc_write(txd, 6, word);
+	rt2x00_desc_read(txd, 5, &word);
+	rt2x00_set_field32(&word, TXD_W5_PID_TYPE, entry->ring->queue_idx);
+	rt2x00_set_field32(&word, TXD_W5_PID_SUBTYPE, entry->entry_idx);
+	rt2x00_desc_write(txd, 5, word);
 
-		rt2x00_desc_read(txd, 0, &word);
-		rt2x00_set_field32(&word, TXD_W0_VALID, 0);
-		rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 0);
-		rt2x00_desc_write(txd, 0, word);
-	}
+	rt2x00_desc_read(txd, 6, &word);
+	rt2x00_set_field32(&word, TXD_W6_BUFFER_PHYSICAL_ADDRESS,
+			   entry->data_dma);
+	rt2x00_desc_write(txd, 6, word);
 
-	rt2x00_ring_index_clear(ring);
+	rt2x00_desc_read(txd, 0, &word);
+	rt2x00_set_field32(&word, TXD_W0_VALID, 0);
+	rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 0);
+	rt2x00_desc_write(txd, 0, word);
 }
 
 static int rt61pci_init_rings(struct rt2x00_dev *rt2x00dev)
@@ -1056,16 +1036,6 @@ static int rt61pci_init_rings(struct rt2x00_dev *rt2x00dev)
 	u32 reg;
 
 	/*
-	 * Initialize rings.
-	 */
-	rt61pci_init_rxring(rt2x00dev);
-	rt61pci_init_txring(rt2x00dev, IEEE80211_TX_QUEUE_DATA0);
-	rt61pci_init_txring(rt2x00dev, IEEE80211_TX_QUEUE_DATA1);
-	rt61pci_init_txring(rt2x00dev, IEEE80211_TX_QUEUE_DATA2);
-	rt61pci_init_txring(rt2x00dev, IEEE80211_TX_QUEUE_DATA3);
-	rt61pci_init_txring(rt2x00dev, IEEE80211_TX_QUEUE_DATA4);
-
-	/*
 	 * Initialize registers.
 	 */
 	rt2x00pci_register_read(rt2x00dev, TX_RING_CSR0, &reg);
@@ -2487,6 +2457,8 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.load_firmware		= rt61pci_load_firmware,
 	.initialize		= rt2x00pci_initialize,
 	.uninitialize		= rt2x00pci_uninitialize,
+	.init_rxentry		= rt61pci_init_rxentry,
+	.init_txentry		= rt61pci_init_txentry,
 	.set_device_state	= rt61pci_set_device_state,
 	.rfkill_poll		= rt61pci_rfkill_poll,
 	.link_stats		= rt61pci_link_stats,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index beaa264..78217dc 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1136,8 +1136,6 @@ static int rt73usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 		return -EIO;
 	}
 
-	rt2x00usb_enable_radio(rt2x00dev);
-
 	/*
 	 * Enable LED
 	 */
@@ -2033,6 +2031,8 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.load_firmware		= rt73usb_load_firmware,
 	.initialize		= rt2x00usb_initialize,
 	.uninitialize		= rt2x00usb_uninitialize,
+	.init_rxentry		= rt2x00usb_init_rxentry,
+	.init_txentry		= rt2x00usb_init_txentry,
 	.set_device_state	= rt73usb_set_device_state,
 	.link_stats		= rt73usb_link_stats,
 	.reset_tuner		= rt73usb_reset_tuner,
-- 
1.5.3.7

