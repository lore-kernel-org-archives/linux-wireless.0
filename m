Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51632 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab2JBSag (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2012 14:30:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [RFC] rt2x00: check return from dma_map_single
Date: Tue,  2 Oct 2012 14:21:19 -0400
Message-Id: <1349202079-14115-1-git-send-email-linville@tuxdriver.com> (sfid-20121002_203041_944312_49771F00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>

dma_map_single can fail, so it's return value needs to be checked and
handled accordingly.  Failure to do so is akin to failing to check the
return from a kmalloc.

http://linuxdriverproject.org/mediawiki/index.php/DMA_Mapping_Error_Analysis

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
Compile tested only...can the experts take a look at how the failures
are handled?

 drivers/net/wireless/rt2x00/rt2400pci.c   | 11 ++++++++---
 drivers/net/wireless/rt2x00/rt2500pci.c   | 11 ++++++++---
 drivers/net/wireless/rt2x00/rt2500usb.c   |  4 +++-
 drivers/net/wireless/rt2x00/rt2800lib.c   |  6 ++++--
 drivers/net/wireless/rt2x00/rt2800lib.h   |  2 +-
 drivers/net/wireless/rt2x00/rt2x00.h      |  6 +++---
 drivers/net/wireless/rt2x00/rt2x00queue.c | 16 ++++++++++++++--
 drivers/net/wireless/rt2x00/rt61pci.c     |  8 +++++---
 drivers/net/wireless/rt2x00/rt73usb.c     |  8 +++++---
 9 files changed, 51 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index e3a2d90..e79ada9 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1171,11 +1171,12 @@ static void rt2400pci_write_tx_desc(struct queue_entry *entry,
 /*
  * TX data initialization
  */
-static void rt2400pci_write_beacon(struct queue_entry *entry,
-				   struct txentry_desc *txdesc)
+static int rt2400pci_write_beacon(struct queue_entry *entry,
+				  struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	u32 reg;
+	int err;
 
 	/*
 	 * Disable beaconing while we are reloading the beacon data,
@@ -1185,7 +1186,9 @@ static void rt2400pci_write_beacon(struct queue_entry *entry,
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 
-	rt2x00queue_map_txskb(entry);
+	err = rt2x00queue_map_txskb(entry);
+	if (err)
+		return err;
 
 	/*
 	 * Write the TX descriptor for the beacon.
@@ -1202,6 +1205,8 @@ static void rt2400pci_write_beacon(struct queue_entry *entry,
 	 */
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
+
+	return 0;
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 479d756..988b38e 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1324,11 +1324,12 @@ static void rt2500pci_write_tx_desc(struct queue_entry *entry,
 /*
  * TX data initialization
  */
-static void rt2500pci_write_beacon(struct queue_entry *entry,
-				   struct txentry_desc *txdesc)
+static int rt2500pci_write_beacon(struct queue_entry *entry,
+				  struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	u32 reg;
+	int err;
 
 	/*
 	 * Disable beaconing while we are reloading the beacon data,
@@ -1338,7 +1339,9 @@ static void rt2500pci_write_beacon(struct queue_entry *entry,
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 
-	rt2x00queue_map_txskb(entry);
+	err = rt2x00queue_map_txskb(entry);
+	if (err)
+		return err;
 
 	/*
 	 * Write the TX descriptor for the beacon.
@@ -1355,6 +1358,8 @@ static void rt2500pci_write_beacon(struct queue_entry *entry,
 	 */
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
+
+	return 0;
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index a12e84f..c476129 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1140,7 +1140,7 @@ static void rt2500usb_write_tx_desc(struct queue_entry *entry,
  */
 static void rt2500usb_beacondone(struct urb *urb);
 
-static void rt2500usb_write_beacon(struct queue_entry *entry,
+static int rt2500usb_write_beacon(struct queue_entry *entry,
 				   struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
@@ -1219,6 +1219,8 @@ static void rt2500usb_write_beacon(struct queue_entry *entry,
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg0);
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
+
+	return 0;
 }
 
 static int rt2500usb_get_tx_data_len(struct queue_entry *entry)
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 540c94f..31ae4c3 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -762,7 +762,7 @@ void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi)
 }
 EXPORT_SYMBOL_GPL(rt2800_txdone_entry);
 
-void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
+int rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
@@ -810,7 +810,7 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 		/* skb freed by skb_pad() on failure */
 		entry->skb = NULL;
 		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, orig_reg);
-		return;
+		return 0; /* still use old beacon info */
 	}
 
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
@@ -828,6 +828,8 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 	 */
 	dev_kfree_skb_any(entry->skb);
 	entry->skb = NULL;
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2800_write_beacon);
 
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index a128cea..ad766bd 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -171,7 +171,7 @@ void rt2800_process_rxwi(struct queue_entry *entry, struct rxdone_entry_desc *tx
 
 void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32* txwi);
 
-void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc);
+int rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc);
 void rt2800_clear_beacon(struct queue_entry *entry);
 
 extern const struct rt2x00debug rt2800_rt2x00debug;
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 0751b35..50ff18d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -605,8 +605,8 @@ struct rt2x00lib_ops {
 			       struct txentry_desc *txdesc);
 	void (*write_tx_data) (struct queue_entry *entry,
 			       struct txentry_desc *txdesc);
-	void (*write_beacon) (struct queue_entry *entry,
-			      struct txentry_desc *txdesc);
+	int (*write_beacon) (struct queue_entry *entry,
+			     struct txentry_desc *txdesc);
 	void (*clear_beacon) (struct queue_entry *entry);
 	int (*get_tx_data_len) (struct queue_entry *entry);
 
@@ -1152,7 +1152,7 @@ static inline bool rt2x00_is_soc(struct rt2x00_dev *rt2x00dev)
  * rt2x00queue_map_txskb - Map a skb into DMA for TX purposes.
  * @entry: Pointer to &struct queue_entry
  */
-void rt2x00queue_map_txskb(struct queue_entry *entry);
+int rt2x00queue_map_txskb(struct queue_entry *entry);
 
 /**
  * rt2x00queue_unmap_skb - Unmap a skb from DMA.
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index e488b94..75b233e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -91,20 +91,32 @@ struct sk_buff *rt2x00queue_alloc_rxskb(struct queue_entry *entry, gfp_t gfp)
 						  skb->data,
 						  skb->len,
 						  DMA_FROM_DEVICE);
+		if (dma_mapping_error(rt2x00dev->dev, skbdesc->skb_dma)) {
+			dev_kfree_skb_any(skb);
+			return NULL;
+		}
 		skbdesc->flags |= SKBDESC_DMA_MAPPED_RX;
 	}
 
 	return skb;
 }
 
-void rt2x00queue_map_txskb(struct queue_entry *entry)
+int rt2x00queue_map_txskb(struct queue_entry *entry)
 {
 	struct device *dev = entry->queue->rt2x00dev->dev;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 
 	skbdesc->skb_dma =
 	    dma_map_single(dev, entry->skb->data, entry->skb->len, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, skbdesc->skb_dma)) {
+		ERROR(entry->queue->rt2x00dev,
+		      "rt2x00queue_map_txskb(): can't map skb\n");
+		return -EIO;
+	}
+
 	skbdesc->flags |= SKBDESC_DMA_MAPPED_TX;
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00queue_map_txskb);
 
@@ -546,7 +558,7 @@ static int rt2x00queue_write_tx_data(struct queue_entry *entry,
 	 * Map the skb to DMA.
 	 */
 	if (test_bit(REQUIRE_DMA, &rt2x00dev->cap_flags))
-		rt2x00queue_map_txskb(entry);
+		return rt2x00queue_map_txskb(entry);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index d6582a2..45f2b2a 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1962,8 +1962,8 @@ static void rt61pci_write_tx_desc(struct queue_entry *entry,
 /*
  * TX data initialization
  */
-static void rt61pci_write_beacon(struct queue_entry *entry,
-				 struct txentry_desc *txdesc)
+static int rt61pci_write_beacon(struct queue_entry *entry,
+				struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
@@ -1999,7 +1999,7 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 		/* skb freed by skb_pad() on failure */
 		entry->skb = NULL;
 		rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, orig_reg);
-		return;
+		return 0; /* still use old beacon info */
 	}
 
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
@@ -2025,6 +2025,8 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 	 */
 	dev_kfree_skb_any(entry->skb);
 	entry->skb = NULL;
+
+	return 0;
 }
 
 static void rt61pci_clear_beacon(struct queue_entry *entry)
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index e5eb43b..97612061 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1529,8 +1529,8 @@ static void rt73usb_write_tx_desc(struct queue_entry *entry,
 /*
  * TX data initialization
  */
-static void rt73usb_write_beacon(struct queue_entry *entry,
-				 struct txentry_desc *txdesc)
+static int rt73usb_write_beacon(struct queue_entry *entry,
+				struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	unsigned int beacon_base;
@@ -1571,7 +1571,7 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
 		/* skb freed by skb_pad() on failure */
 		entry->skb = NULL;
 		rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, orig_reg);
-		return;
+		return 0; /* still use old beacon info */
 	}
 
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
@@ -1594,6 +1594,8 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
 	 */
 	dev_kfree_skb(entry->skb);
 	entry->skb = NULL;
+
+	return 0;
 }
 
 static void rt73usb_clear_beacon(struct queue_entry *entry)
-- 
1.7.11.4

