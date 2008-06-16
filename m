Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:1892 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbYFPRon (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 13:44:43 -0400
Received: by wa-out-1112.google.com with SMTP id j37so4408775waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2008 10:44:43 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/9] rt2x00: Convert rt2x00 to use generic DMA-mapping API
Date: Mon, 16 Jun 2008 19:55:43 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200806161954.04241.IvDoorn@gmail.com> <200806161954.34838.IvDoorn@gmail.com> <200806161955.18775.IvDoorn@gmail.com>
In-Reply-To: <200806161955.18775.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806161955.43378.IvDoorn@gmail.com> (sfid-20080616_194501_545479_682A63BA)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>

At the same time clean up the device administration a bit, by storing a pointer
to struct device instead of a void pointer that is dependent on the type of
device. The normal PCI and USB subsystem provided macros can be used to convert
the device pointer to the right type.
This makes the rt2x00 driver a bit more type-safe.

Signed-off-by: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c |    5 +++--
 drivers/net/wireless/rt2x00/rt2x00.h    |    6 +-----
 drivers/net/wireless/rt2x00/rt2x00pci.c |   19 +++++++++----------
 drivers/net/wireless/rt2x00/rt2x00usb.c |   11 +++++++----
 drivers/net/wireless/rt2x00/rt61pci.c   |    4 ++--
 drivers/net/wireless/rt2x00/rt73usb.c   |    2 +-
 8 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index bb3d835..76ec151 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1366,7 +1366,7 @@ static void rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 			       IEEE80211_HW_SIGNAL_DBM;
 	rt2x00dev->hw->extra_tx_headroom = 0;
 
-	SET_IEEE80211_DEV(rt2x00dev->hw, &rt2x00dev_pci(rt2x00dev)->dev);
+	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
 				rt2x00_eeprom_addr(rt2x00dev,
 						   EEPROM_MAC_ADDR_0));
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 3c956b9..5f0117f 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1688,7 +1688,7 @@ static void rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 
 	rt2x00dev->hw->extra_tx_headroom = 0;
 
-	SET_IEEE80211_DEV(rt2x00dev->hw, &rt2x00dev_pci(rt2x00dev)->dev);
+	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
 				rt2x00_eeprom_addr(rt2x00dev,
 						   EEPROM_MAC_ADDR_0));
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 9851cef..6b6e7b9 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1588,7 +1588,7 @@ static void rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 
 	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
 
-	SET_IEEE80211_DEV(rt2x00dev->hw, &rt2x00dev_usb(rt2x00dev)->dev);
+	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
 				rt2x00_eeprom_addr(rt2x00dev,
 						   EEPROM_MAC_ADDR_0));
@@ -1672,7 +1672,8 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 static int rt2500usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct usb_device *usb_dev = rt2x00dev_usb_dev(rt2x00dev);
+	struct usb_device *usb_dev =
+		interface_to_usbdev(to_usb_interface(rt2x00dev->dev));
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
 	struct queue_entry_priv_usb_bcn *bcn_priv;
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 21fd9b4..8d45235 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -625,11 +625,7 @@ struct rt2x00_dev {
 	 * When accessing this variable, the rt2x00dev_{pci,usb}
 	 * macro's should be used for correct typecasting.
 	 */
-	void *dev;
-#define rt2x00dev_pci(__dev)	( (struct pci_dev *)(__dev)->dev )
-#define rt2x00dev_usb(__dev)	( (struct usb_interface *)(__dev)->dev )
-#define rt2x00dev_usb_dev(__dev)\
-	( (struct usb_device *)interface_to_usbdev(rt2x00dev_usb(__dev)) )
+	struct device *dev;
 
 	/*
 	 * Callback functions.
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 8d6ad18..d613838 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -194,7 +194,6 @@ EXPORT_SYMBOL_GPL(rt2x00pci_txdone);
 static int rt2x00pci_alloc_queue_dma(struct rt2x00_dev *rt2x00dev,
 				     struct data_queue *queue)
 {
-	struct pci_dev *pci_dev = rt2x00dev_pci(rt2x00dev);
 	struct queue_entry_priv_pci *entry_priv;
 	void *addr;
 	dma_addr_t dma;
@@ -203,7 +202,8 @@ static int rt2x00pci_alloc_queue_dma(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Allocate DMA memory for descriptor and buffer.
 	 */
-	addr = pci_alloc_consistent(pci_dev, dma_size(queue), &dma);
+	addr = dma_alloc_coherent(rt2x00dev->dev, dma_size(queue), &dma,
+				  GFP_KERNEL | GFP_DMA);
 	if (!addr)
 		return -ENOMEM;
 
@@ -226,19 +226,18 @@ static int rt2x00pci_alloc_queue_dma(struct rt2x00_dev *rt2x00dev,
 static void rt2x00pci_free_queue_dma(struct rt2x00_dev *rt2x00dev,
 				     struct data_queue *queue)
 {
-	struct pci_dev *pci_dev = rt2x00dev_pci(rt2x00dev);
 	struct queue_entry_priv_pci *entry_priv =
 	    queue->entries[0].priv_data;
 
 	if (entry_priv->data)
-		pci_free_consistent(pci_dev, dma_size(queue),
-				    entry_priv->data, entry_priv->data_dma);
+		dma_free_coherent(rt2x00dev->dev, dma_size(queue),
+				  entry_priv->data, entry_priv->data_dma);
 	entry_priv->data = NULL;
 }
 
 int rt2x00pci_initialize(struct rt2x00_dev *rt2x00dev)
 {
-	struct pci_dev *pci_dev = rt2x00dev_pci(rt2x00dev);
+	struct pci_dev *pci_dev = to_pci_dev(rt2x00dev->dev);
 	struct data_queue *queue;
 	int status;
 
@@ -279,7 +278,7 @@ void rt2x00pci_uninitialize(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Free irq line.
 	 */
-	free_irq(rt2x00dev_pci(rt2x00dev)->irq, rt2x00dev);
+	free_irq(to_pci_dev(rt2x00dev->dev)->irq, rt2x00dev);
 
 	/*
 	 * Free DMA
@@ -308,7 +307,7 @@ static void rt2x00pci_free_reg(struct rt2x00_dev *rt2x00dev)
 
 static int rt2x00pci_alloc_reg(struct rt2x00_dev *rt2x00dev)
 {
-	struct pci_dev *pci_dev = rt2x00dev_pci(rt2x00dev);
+	struct pci_dev *pci_dev = to_pci_dev(rt2x00dev->dev);
 
 	rt2x00dev->csr.base = ioremap(pci_resource_start(pci_dev, 0),
 				      pci_resource_len(pci_dev, 0));
@@ -357,7 +356,7 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	if (pci_set_mwi(pci_dev))
 		ERROR_PROBE("MWI not available.\n");
 
-	if (pci_set_dma_mask(pci_dev, DMA_32BIT_MASK)) {
+	if (dma_set_mask(&pci_dev->dev, DMA_32BIT_MASK)) {
 		ERROR_PROBE("PCI DMA not supported.\n");
 		retval = -EIO;
 		goto exit_disable_device;
@@ -373,7 +372,7 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	pci_set_drvdata(pci_dev, hw);
 
 	rt2x00dev = hw->priv;
-	rt2x00dev->dev = pci_dev;
+	rt2x00dev->dev = &pci_dev->dev;
 	rt2x00dev->ops = ops;
 	rt2x00dev->hw = hw;
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 3080969..f91901f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -40,7 +40,8 @@ int rt2x00usb_vendor_request(struct rt2x00_dev *rt2x00dev,
 			     void *buffer, const u16 buffer_length,
 			     const int timeout)
 {
-	struct usb_device *usb_dev = rt2x00dev_usb_dev(rt2x00dev);
+	struct usb_device *usb_dev =
+		interface_to_usbdev(to_usb_interface(rt2x00dev->dev));
 	int status;
 	unsigned int i;
 	unsigned int pipe =
@@ -176,7 +177,8 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 int rt2x00usb_write_tx_data(struct queue_entry *entry)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct usb_device *usb_dev = rt2x00dev_usb_dev(rt2x00dev);
+	struct usb_device *usb_dev =
+		interface_to_usbdev(to_usb_interface(rt2x00dev->dev));
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 	struct skb_frame_desc *skbdesc;
 	u32 length;
@@ -364,7 +366,8 @@ EXPORT_SYMBOL_GPL(rt2x00usb_disable_radio);
 void rt2x00usb_init_rxentry(struct rt2x00_dev *rt2x00dev,
 			    struct queue_entry *entry)
 {
-	struct usb_device *usb_dev = rt2x00dev_usb_dev(rt2x00dev);
+	struct usb_device *usb_dev =
+		interface_to_usbdev(to_usb_interface(rt2x00dev->dev));
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 
 	usb_fill_bulk_urb(entry_priv->urb, usb_dev,
@@ -558,7 +561,7 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 	usb_set_intfdata(usb_intf, hw);
 
 	rt2x00dev = hw->priv;
-	rt2x00dev->dev = usb_intf;
+	rt2x00dev->dev = &usb_intf->dev;
 	rt2x00dev->ops = ops;
 	rt2x00dev->hw = hw;
 	mutex_init(&rt2x00dev->usb_cache_mutex);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 27f30ae..2a7f306 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1973,7 +1973,7 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * To determine the RT chip we have to read the
 	 * PCI header of the device.
 	 */
-	pci_read_config_word(rt2x00dev_pci(rt2x00dev),
+	pci_read_config_word(to_pci_dev(rt2x00dev->dev),
 			     PCI_CONFIG_HEADER_DEVICE, &device);
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
 	rt2x00pci_register_read(rt2x00dev, MAC_CSR0, &reg);
@@ -2239,7 +2239,7 @@ static void rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_SIGNAL_DBM;
 	rt2x00dev->hw->extra_tx_headroom = 0;
 
-	SET_IEEE80211_DEV(rt2x00dev->hw, &rt2x00dev_pci(rt2x00dev)->dev);
+	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
 				rt2x00_eeprom_addr(rt2x00dev,
 						   EEPROM_MAC_ADDR_0));
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 42b7e98..ead6db0 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1821,7 +1821,7 @@ static void rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_SIGNAL_DBM;
 	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
 
-	SET_IEEE80211_DEV(rt2x00dev->hw, &rt2x00dev_usb(rt2x00dev)->dev);
+	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
 				rt2x00_eeprom_addr(rt2x00dev,
 						   EEPROM_MAC_ADDR_0));
-- 
1.5.5.4

