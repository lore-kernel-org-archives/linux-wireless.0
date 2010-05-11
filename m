Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:3245 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580Ab0EKVvx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 17:51:53 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 4/9] rt2x00: Simplify TXD handling of beacons.
Date: Tue, 11 May 2010 23:51:40 +0200
Message-Id: <1273614705-25118-5-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>
References: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The handling of tx descriptors for beacons can be simplified by updating
write_tx_desc implementations of each driver to write directly to the
queue entry descriptor instead of to a provided memory area.
This is also a preparation for further clean ups where descriptors are
properly reserved in the skb instead of fiddling with the skb data
pointer.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |   21 +++++++++------------
 drivers/net/wireless/rt2x00/rt2500pci.c   |   21 +++++++++------------
 drivers/net/wireless/rt2x00/rt2500usb.c   |   21 ++++++++++++---------
 drivers/net/wireless/rt2x00/rt2800pci.c   |   14 ++++++++++----
 drivers/net/wireless/rt2x00/rt2800usb.c   |    8 +++++++-
 drivers/net/wireless/rt2x00/rt2x00pci.c   |    9 ---------
 drivers/net/wireless/rt2x00/rt2x00queue.c |   10 ----------
 drivers/net/wireless/rt2x00/rt2x00usb.c   |    8 --------
 drivers/net/wireless/rt2x00/rt61pci.c     |   20 +++++++++++++-------
 drivers/net/wireless/rt2x00/rt73usb.c     |   21 ++++++++++++---------
 10 files changed, 72 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 1eff6ec..def3fa4 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1006,15 +1006,15 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
 	struct queue_entry_priv_pci *entry_priv = skbdesc->entry->priv_data;
-	__le32 *txd = skbdesc->desc;
+	__le32 *txd = entry_priv->desc;
 	u32 word;
 
 	/*
 	 * Start writing the descriptor words.
 	 */
-	rt2x00_desc_read(entry_priv->desc, 1, &word);
+	rt2x00_desc_read(txd, 1, &word);
 	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, skbdesc->skb_dma);
-	rt2x00_desc_write(entry_priv->desc, 1, word);
+	rt2x00_desc_write(txd, 1, word);
 
 	rt2x00_desc_read(txd, 2, &word);
 	rt2x00_set_field32(&word, TXD_W2_BUFFER_LENGTH, txdesc->length);
@@ -1059,6 +1059,12 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
 			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
 	rt2x00_desc_write(txd, 0, word);
+
+	/*
+	 * Register descriptor details in skb frame descriptor.
+	 */
+	skbdesc->desc = txd;
+	skbdesc->desc_len = TXD_DESC_SIZE;
 }
 
 /*
@@ -1081,15 +1087,6 @@ static void rt2400pci_write_beacon(struct queue_entry *entry,
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 
-	/*
-	 * Replace rt2x00lib allocated descriptor with the
-	 * pointer to the _real_ hardware descriptor.
-	 * After that, map the beacon to DMA and update the
-	 * descriptor.
-	 */
-	memcpy(entry_priv->desc, skbdesc->desc, skbdesc->desc_len);
-	skbdesc->desc = entry_priv->desc;
-
 	rt2x00queue_map_txskb(rt2x00dev, entry->skb);
 
 	rt2x00_desc_read(entry_priv->desc, 1, &word);
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 8d3e95e..070c23e 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1164,15 +1164,15 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
 	struct queue_entry_priv_pci *entry_priv = skbdesc->entry->priv_data;
-	__le32 *txd = skbdesc->desc;
+	__le32 *txd = entry_priv->desc;
 	u32 word;
 
 	/*
 	 * Start writing the descriptor words.
 	 */
-	rt2x00_desc_read(entry_priv->desc, 1, &word);
+	rt2x00_desc_read(txd, 1, &word);
 	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, skbdesc->skb_dma);
-	rt2x00_desc_write(entry_priv->desc, 1, word);
+	rt2x00_desc_write(txd, 1, word);
 
 	rt2x00_desc_read(txd, 2, &word);
 	rt2x00_set_field32(&word, TXD_W2_IV_OFFSET, IEEE80211_HEADER);
@@ -1216,6 +1216,12 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, txdesc->length);
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, CIPHER_NONE);
 	rt2x00_desc_write(txd, 0, word);
+
+	/*
+	 * Register descriptor details in skb frame descriptor.
+	 */
+	skbdesc->desc = txd;
+	skbdesc->desc_len = TXD_DESC_SIZE;
 }
 
 /*
@@ -1238,15 +1244,6 @@ static void rt2500pci_write_beacon(struct queue_entry *entry,
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 
-	/*
-	 * Replace rt2x00lib allocated descriptor with the
-	 * pointer to the _real_ hardware descriptor.
-	 * After that, map the beacon to DMA and update the
-	 * descriptor.
-	 */
-	memcpy(entry_priv->desc, skbdesc->desc, skbdesc->desc_len);
-	skbdesc->desc = entry_priv->desc;
-
 	rt2x00queue_map_txskb(rt2x00dev, entry->skb);
 
 	rt2x00_desc_read(entry_priv->desc, 1, &word);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 9a915be..b985d8f 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1033,7 +1033,7 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	__le32 *txd = skbdesc->desc;
+	__le32 *txd = (__le32 *)(skb->data - TXD_DESC_SIZE);
 	u32 word;
 
 	/*
@@ -1075,6 +1075,12 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 		_rt2x00_desc_write(txd, 3, skbdesc->iv[0]);
 		_rt2x00_desc_write(txd, 4, skbdesc->iv[1]);
 	}
+
+	/*
+	 * Register descriptor details in skb frame descriptor.
+	 */
+	skbdesc->desc = txd;
+	skbdesc->desc_len = TXD_DESC_SIZE;
 }
 
 /*
@@ -1088,19 +1094,11 @@ static void rt2500usb_write_beacon(struct queue_entry *entry,
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
 	struct queue_entry_priv_usb_bcn *bcn_priv = entry->priv_data;
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	int pipe = usb_sndbulkpipe(usb_dev, entry->queue->usb_endpoint);
 	int length;
 	u16 reg, reg0;
 
 	/*
-	 * Add the descriptor in front of the skb.
-	 */
-	skb_push(entry->skb, entry->queue->desc_size);
-	memcpy(entry->skb->data, skbdesc->desc, skbdesc->desc_len);
-	skbdesc->desc = entry->skb->data;
-
-	/*
 	 * Disable beaconing while we are reloading the beacon data,
 	 * otherwise we might be sending out invalid data.
 	 */
@@ -1109,6 +1107,11 @@ static void rt2500usb_write_beacon(struct queue_entry *entry,
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
 
 	/*
+	 * Take the descriptor in front of the skb into account.
+	 */
+	skb_push(entry->skb, TXD_DESC_SIZE);
+
+	/*
 	 * USB devices cannot blindly pass the skb->len as the
 	 * length of the data to usb_fill_bulk_urb. Pass the skb
 	 * to the driver to determine what the length should be.
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 7d4778d..b2f2327 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -633,7 +633,8 @@ static void rt2800pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	__le32 *txd = skbdesc->desc;
+	struct queue_entry_priv_pci *entry_priv = skbdesc->entry->priv_data;
+	__le32 *txd = entry_priv->desc;
 	u32 word;
 
 	/*
@@ -657,15 +658,14 @@ static void rt2800pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			   !test_bit(ENTRY_TXD_MORE_FRAG, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W1_BURST,
 			   test_bit(ENTRY_TXD_BURST, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W1_SD_LEN0,
-			   rt2x00dev->ops->extra_tx_headroom);
+	rt2x00_set_field32(&word, TXD_W1_SD_LEN0, TXWI_DESC_SIZE);
 	rt2x00_set_field32(&word, TXD_W1_LAST_SEC0, 0);
 	rt2x00_set_field32(&word, TXD_W1_DMA_DONE, 0);
 	rt2x00_desc_write(txd, 1, word);
 
 	rt2x00_desc_read(txd, 2, &word);
 	rt2x00_set_field32(&word, TXD_W2_SD_PTR1,
-			   skbdesc->skb_dma + rt2x00dev->ops->extra_tx_headroom);
+			   skbdesc->skb_dma + TXWI_DESC_SIZE);
 	rt2x00_desc_write(txd, 2, word);
 
 	rt2x00_desc_read(txd, 3, &word);
@@ -673,6 +673,12 @@ static void rt2800pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			   !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W3_QSEL, 2);
 	rt2x00_desc_write(txd, 3, word);
+
+	/*
+	 * Register descriptor details in skb frame descriptor.
+	 */
+	skbdesc->desc = txd;
+	skbdesc->desc_len = TXD_DESC_SIZE;
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index d48d705..1b87daa 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -400,7 +400,7 @@ static void rt2800usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	__le32 *txi = skbdesc->desc;
+	__le32 *txi = (__le32 *)(skb->data - TXWI_DESC_SIZE - TXINFO_DESC_SIZE);
 	u32 word;
 
 	/*
@@ -422,6 +422,12 @@ static void rt2800usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXINFO_W0_USB_DMA_TX_BURST,
 			   test_bit(ENTRY_TXD_BURST, &txdesc->flags));
 	rt2x00_desc_write(txi, 0, word);
+
+	/*
+	 * Register descriptor details in skb frame descriptor.
+	 */
+	skbdesc->desc = txi;
+	skbdesc->desc_len = TXINFO_DESC_SIZE + TXWI_DESC_SIZE;
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 2fe9f29..ff80ef7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -66,8 +66,6 @@ int rt2x00pci_write_tx_data(struct queue_entry *entry,
 			    struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
-	struct skb_frame_desc *skbdesc;
 
 	/*
 	 * This should not happen, we already checked the entry
@@ -82,13 +80,6 @@ int rt2x00pci_write_tx_data(struct queue_entry *entry,
 		return -EINVAL;
 	}
 
-	/*
-	 * Fill in skb descriptor
-	 */
-	skbdesc = get_skb_frame_desc(entry->skb);
-	skbdesc->desc = entry_priv->desc;
-	skbdesc->desc_len = entry->queue->desc_size;
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_write_tx_data);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 97b2c76..891d5f7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -552,7 +552,6 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 	struct rt2x00_intf *intf = vif_to_intf(vif);
 	struct skb_frame_desc *skbdesc;
 	struct txentry_desc txdesc;
-	__le32 desc[16];
 
 	if (unlikely(!intf->beacon))
 		return -ENOBUFS;
@@ -585,19 +584,10 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc);
 
 	/*
-	 * For the descriptor we use a local array from where the
-	 * driver can move it to the correct location required for
-	 * the hardware.
-	 */
-	memset(desc, 0, sizeof(desc));
-
-	/*
 	 * Fill in skb descriptor
 	 */
 	skbdesc = get_skb_frame_desc(intf->beacon->skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->desc = desc;
-	skbdesc->desc_len = intf->beacon->queue->desc_size;
 	skbdesc->entry = intf->beacon;
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index acf3282..a4f0551 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -221,7 +221,6 @@ int rt2x00usb_write_tx_data(struct queue_entry *entry,
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
-	struct skb_frame_desc *skbdesc;
 	u32 length;
 
 	/*
@@ -231,13 +230,6 @@ int rt2x00usb_write_tx_data(struct queue_entry *entry,
 	memset(entry->skb->data, 0, entry->queue->desc_size);
 
 	/*
-	 * Fill in skb descriptor
-	 */
-	skbdesc = get_skb_frame_desc(entry->skb);
-	skbdesc->desc = entry->skb->data;
-	skbdesc->desc_len = entry->queue->desc_size;
-
-	/*
 	 * USB devices cannot blindly pass the skb->len as the
 	 * length of the data to usb_fill_bulk_urb. Pass the skb
 	 * to the driver to determine what the length should be.
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 55aa010..1be1d7d 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1763,7 +1763,8 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				  struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	__le32 *txd = skbdesc->desc;
+	struct queue_entry_priv_pci *entry_priv = skbdesc->entry->priv_data;
+	__le32 *txd = entry_priv->desc;
 	u32 word;
 
 	/*
@@ -1842,6 +1843,13 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			   test_bit(ENTRY_TXD_BURST, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, txdesc->cipher);
 	rt2x00_desc_write(txd, 0, word);
+
+	/*
+	 * Register descriptor details in skb frame descriptor.
+	 */
+	skbdesc->desc = txd;
+	skbdesc->desc_len =
+		(txdesc->queue == QID_BEACON) ?  TXINFO_SIZE : TXD_DESC_SIZE;
 }
 
 /*
@@ -1851,7 +1859,7 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 				 struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
 	unsigned int beacon_base;
 	u32 reg;
 
@@ -1867,11 +1875,9 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 	 * Write entire beacon with descriptor to register.
 	 */
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
-	rt2x00pci_register_multiwrite(rt2x00dev,
-				      beacon_base,
-				      skbdesc->desc, skbdesc->desc_len);
-	rt2x00pci_register_multiwrite(rt2x00dev,
-				      beacon_base + skbdesc->desc_len,
+	rt2x00pci_register_multiwrite(rt2x00dev, beacon_base,
+				      entry_priv->desc, TXINFO_SIZE);
+	rt2x00pci_register_multiwrite(rt2x00dev, beacon_base + TXINFO_SIZE,
 				      entry->skb->data, entry->skb->len);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index fa40d43..fca661c 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1440,7 +1440,7 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				  struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	__le32 *txd = skbdesc->desc;
+	__le32 *txd = (__le32 *)(skb->data - TXD_DESC_SIZE);
 	u32 word;
 
 	/*
@@ -1499,6 +1499,12 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			   TXPOWER_TO_DEV(rt2x00dev->tx_power));
 	rt2x00_set_field32(&word, TXD_W5_WAITING_DMA_DONE_INT, 1);
 	rt2x00_desc_write(txd, 5, word);
+
+	/*
+	 * Register descriptor details in skb frame descriptor.
+	 */
+	skbdesc->desc = txd;
+	skbdesc->desc_len = TXD_DESC_SIZE;
 }
 
 /*
@@ -1508,18 +1514,10 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
 				 struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	unsigned int beacon_base;
 	u32 reg;
 
 	/*
-	 * Add the descriptor in front of the skb.
-	 */
-	skb_push(entry->skb, entry->queue->desc_size);
-	memcpy(entry->skb->data, skbdesc->desc, skbdesc->desc_len);
-	skbdesc->desc = entry->skb->data;
-
-	/*
 	 * Disable beaconing while we are reloading the beacon data,
 	 * otherwise we might be sending out invalid data.
 	 */
@@ -1528,6 +1526,11 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
 	rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
 
 	/*
+	 * Take the descriptor in front of the skb into account.
+	 */
+	skb_push(entry->skb, TXD_DESC_SIZE);
+
+	/*
 	 * Write entire beacon with descriptor to register.
 	 */
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
-- 
1.7.1

