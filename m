Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758487Ab3BMN1R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 08:27:17 -0500
Date: Wed, 13 Feb 2013 14:27:05 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH] rt2x00: check for dma mappings errors
Message-ID: <20130213132704.GB1912@redhat.com> (sfid-20130213_142720_398098_F4EC9CCD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check output of dma_map_single functions which nowadays can fail (when
IOMMU is used). On write_beacon callbacks just print error, similar
like padding error is handled by rt2800_write_beacon. 

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   | 12 +++++++++---
 drivers/net/wireless/rt2x00/rt2500pci.c   |  7 +++++--
 drivers/net/wireless/rt2x00/rt2x00.h      |  4 +++-
 drivers/net/wireless/rt2x00/rt2x00queue.c | 26 +++++++++++++++++++-------
 4 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index a2d2bc2..221beaa 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1185,8 +1185,14 @@ static void rt2400pci_write_beacon(struct queue_entry *entry,
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 
-	rt2x00queue_map_txskb(entry);
-
+	if (rt2x00queue_map_txskb(entry)) {
+		ERROR(rt2x00dev, "Fail to map beacon, aborting\n");
+		goto out;
+	}
+	/*
+	 * Enable beaconing again.
+	 */
+	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
 	/*
 	 * Write the TX descriptor for the beacon.
 	 */
@@ -1196,7 +1202,7 @@ static void rt2400pci_write_beacon(struct queue_entry *entry,
 	 * Dump beacon to userspace through debugfs.
 	 */
 	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
-
+out:
 	/*
 	 * Enable beaconing again.
 	 */
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 9bea10f..39edc59 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1338,7 +1338,10 @@ static void rt2500pci_write_beacon(struct queue_entry *entry,
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 
-	rt2x00queue_map_txskb(entry);
+	if (rt2x00queue_map_txskb(entry)) {
+		ERROR(rt2x00dev, "Fail to map beacon, aborting\n");
+		goto out;
+	}
 
 	/*
 	 * Write the TX descriptor for the beacon.
@@ -1349,7 +1352,7 @@ static void rt2500pci_write_beacon(struct queue_entry *entry,
 	 * Dump beacon to userspace through debugfs.
 	 */
 	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
-
+out:
 	/*
 	 * Enable beaconing again.
 	 */
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 9a3f31a..086abb4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1169,8 +1169,10 @@ static inline bool rt2x00_is_soc(struct rt2x00_dev *rt2x00dev)
 /**
  * rt2x00queue_map_txskb - Map a skb into DMA for TX purposes.
  * @entry: Pointer to &struct queue_entry
+ *
+ * Returns -ENOMEM if mapping fail, 0 otherwise.
  */
-void rt2x00queue_map_txskb(struct queue_entry *entry);
+int rt2x00queue_map_txskb(struct queue_entry *entry);
 
 /**
  * rt2x00queue_unmap_skb - Unmap a skb from DMA.
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index f35d85a..e26ec9d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -87,24 +87,35 @@ struct sk_buff *rt2x00queue_alloc_rxskb(struct queue_entry *entry, gfp_t gfp)
 	skbdesc->entry = entry;
 
 	if (test_bit(REQUIRE_DMA, &rt2x00dev->cap_flags)) {
-		skbdesc->skb_dma = dma_map_single(rt2x00dev->dev,
-						  skb->data,
-						  skb->len,
-						  DMA_FROM_DEVICE);
+		dma_addr_t skb_dma;
+
+		skb_dma = dma_map_single(rt2x00dev->dev, skb->data, skb->len,
+					 DMA_FROM_DEVICE);
+		if (unlikely(dma_mapping_error(rt2x00dev->dev, skb_dma))) {
+			dev_kfree_skb_any(skb);
+			return NULL;
+		}
+
+		skbdesc->skb_dma = skb_dma;
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
+
+	if (unlikely(dma_mapping_error(dev, skbdesc->skb_dma)))
+		return -ENOMEM;
+
 	skbdesc->flags |= SKBDESC_DMA_MAPPED_TX;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00queue_map_txskb);
 
@@ -545,8 +556,9 @@ static int rt2x00queue_write_tx_data(struct queue_entry *entry,
 	/*
 	 * Map the skb to DMA.
 	 */
-	if (test_bit(REQUIRE_DMA, &rt2x00dev->cap_flags))
-		rt2x00queue_map_txskb(entry);
+	if (test_bit(REQUIRE_DMA, &rt2x00dev->cap_flags) &&
+	    rt2x00queue_map_txskb(entry))
+		return -ENOMEM;
 
 	return 0;
 }
-- 
1.7.11.7

