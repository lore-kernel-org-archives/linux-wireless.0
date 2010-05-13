Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:1227 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758045Ab0EMJhH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 05:37:07 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH v2 08/10] rt2x00: Push beacon TX descriptor writing to drivers.
Date: Thu, 13 May 2010 11:36:56 +0200
Message-Id: <1273743418-28383-9-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1273743418-28383-1-git-send-email-gwingerde@gmail.com>
References: <1273743418-28383-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not all the devices require a TX descriptor to be written (i.e. rt2800
device don't require them). Push down the creation of the TX descriptor
to the device drivers so that they can decide for themselves whether
a TX descriptor is to be created.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |   15 +++++++++------
 drivers/net/wireless/rt2x00/rt2500pci.c   |   15 +++++++++------
 drivers/net/wireless/rt2x00/rt2500usb.c   |   10 ++++++++++
 drivers/net/wireless/rt2x00/rt2800pci.c   |   16 ++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800usb.c   |   16 ++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00queue.c |   10 +---------
 drivers/net/wireless/rt2x00/rt61pci.c     |   10 ++++++++++
 drivers/net/wireless/rt2x00/rt73usb.c     |   10 ++++++++++
 8 files changed, 81 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index def3fa4..66cff04 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1074,9 +1074,6 @@ static void rt2400pci_write_beacon(struct queue_entry *entry,
 				   struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
-	u32 word;
 	u32 reg;
 
 	/*
@@ -1089,9 +1086,15 @@ static void rt2400pci_write_beacon(struct queue_entry *entry,
 
 	rt2x00queue_map_txskb(rt2x00dev, entry->skb);
 
-	rt2x00_desc_read(entry_priv->desc, 1, &word);
-	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, skbdesc->skb_dma);
-	rt2x00_desc_write(entry_priv->desc, 1, word);
+	/*
+	 * Write the TX descriptor for the beacon.
+	 */
+	rt2400pci_write_tx_desc(rt2x00dev, entry->skb, txdesc);
+
+	/*
+	 * Dump beacon to userspace through debugfs.
+	 */
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
 
 	/*
 	 * Enable beaconing again.
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 070c23e..d30811c 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1231,9 +1231,6 @@ static void rt2500pci_write_beacon(struct queue_entry *entry,
 				   struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
-	u32 word;
 	u32 reg;
 
 	/*
@@ -1246,9 +1243,15 @@ static void rt2500pci_write_beacon(struct queue_entry *entry,
 
 	rt2x00queue_map_txskb(rt2x00dev, entry->skb);
 
-	rt2x00_desc_read(entry_priv->desc, 1, &word);
-	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, skbdesc->skb_dma);
-	rt2x00_desc_write(entry_priv->desc, 1, word);
+	/*
+	 * Write the TX descriptor for the beacon.
+	 */
+	rt2500pci_write_tx_desc(rt2x00dev, entry->skb, txdesc);
+
+	/*
+	 * Dump beacon to userspace through debugfs.
+	 */
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
 
 	/*
 	 * Enable beaconing again.
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index b985d8f..dfaa948 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1107,6 +1107,16 @@ static void rt2500usb_write_beacon(struct queue_entry *entry,
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
 
 	/*
+	 * Write the TX descriptor for the beacon.
+	 */
+	rt2500usb_write_tx_desc(rt2x00dev, entry->skb, txdesc);
+
+	/*
+	 * Dump beacon to userspace through debugfs.
+	 */
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
+
+	/*
 	 * Take the descriptor in front of the skb into account.
 	 */
 	skb_push(entry->skb, TXD_DESC_SIZE);
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index b2f2327..88dba7f 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -688,6 +688,7 @@ static void rt2800pci_write_beacon(struct queue_entry *entry,
 				   struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	unsigned int beacon_base;
 	u32 reg;
 
@@ -700,9 +701,24 @@ static void rt2800pci_write_beacon(struct queue_entry *entry,
 	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
 	/*
+	 * Register descriptor details in skb frame descriptor.
+	 */
+	skbdesc->desc = entry->skb->data - TXWI_DESC_SIZE;
+	skbdesc->desc_len = TXWI_DESC_SIZE;
+
+	/*
 	 * Add the TXWI for the beacon to the skb.
 	 */
 	rt2800_write_txwi(entry->skb, txdesc);
+
+	/*
+	 * Dump beacon to userspace through debugfs.
+	 */
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
+
+	/*
+	 * Adjust skb to take TXWI into account.
+	 */
 	skb_push(entry->skb, TXWI_DESC_SIZE);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 1b87daa..2ac1386 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -437,6 +437,7 @@ static void rt2800usb_write_beacon(struct queue_entry *entry,
 				   struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	unsigned int beacon_base;
 	u32 reg;
 
@@ -449,9 +450,24 @@ static void rt2800usb_write_beacon(struct queue_entry *entry,
 	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
 	/*
+	 * Register descriptor details in skb frame descriptor.
+	 */
+	skbdesc->desc = entry->skb->data - TXWI_DESC_SIZE;
+	skbdesc->desc_len = TXWI_DESC_SIZE;
+
+	/*
 	 * Add the TXWI for the beacon to the skb.
 	 */
 	rt2800_write_txwi(entry->skb, txdesc);
+
+	/*
+	 * Dump beacon to userspace through debugfs.
+	 */
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
+
+	/*
+	 * Adjust skb to take TXWI into account.
+	 */
 	skb_push(entry->skb, TXWI_DESC_SIZE);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index c68bf32..9e48bbc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -420,7 +420,6 @@ static void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
 {
 	struct data_queue *queue = entry->queue;
 	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
-	enum rt2x00_dump_type dump_type;
 
 	rt2x00dev->ops->lib->write_tx_desc(rt2x00dev, entry->skb, txdesc);
 
@@ -428,9 +427,7 @@ static void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
 	 * All processing on the frame has been completed, this means
 	 * it is now ready to be dumped to userspace through debugfs.
 	 */
-	dump_type = (txdesc->queue == QID_BEACON) ?
-					DUMP_FRAME_BEACON : DUMP_FRAME_TX;
-	rt2x00debug_dump_frame(rt2x00dev, dump_type, entry->skb);
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_TX, entry->skb);
 }
 
 static void rt2x00queue_kick_tx_queue(struct queue_entry *entry,
@@ -594,11 +591,6 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 	skbdesc->entry = intf->beacon;
 
 	/*
-	 * Write TX descriptor into reserved room in front of the beacon.
-	 */
-	rt2x00queue_write_tx_descriptor(intf->beacon, &txdesc);
-
-	/*
 	 * Send beacon to hardware and enable beacon genaration..
 	 */
 	rt2x00dev->ops->lib->write_beacon(intf->beacon, &txdesc);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 1be1d7d..643202f 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1872,6 +1872,16 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
 
 	/*
+	 * Write the TX descriptor for the beacon.
+	 */
+	rt61pci_write_tx_desc(rt2x00dev, entry->skb, txdesc);
+
+	/*
+	 * Dump beacon to userspace through debugfs.
+	 */
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
+
+	/*
 	 * Write entire beacon with descriptor to register.
 	 */
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index fca661c..dcc46a2 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1526,6 +1526,16 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
 	rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
 
 	/*
+	 * Write the TX descriptor for the beacon.
+	 */
+	rt73usb_write_tx_desc(rt2x00dev, entry->skb, txdesc);
+
+	/*
+	 * Dump beacon to userspace through debugfs.
+	 */
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
+
+	/*
 	 * Take the descriptor in front of the skb into account.
 	 */
 	skb_push(entry->skb, TXD_DESC_SIZE);
-- 
1.7.1

