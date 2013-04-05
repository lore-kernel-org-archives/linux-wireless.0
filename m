Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:33539 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161633Ab3DEG0o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 02:26:44 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/6] rt2x00: rt2x00mmio: use rt2x00mmio prefix in function names
Date: Fri,  5 Apr 2013 08:27:00 +0200
Message-Id: <1365143225-24532-2-git-send-email-juhosg@openwrt.org> (sfid-20130405_082701_019391_44FAC50E)
In-Reply-To: <1365143225-24532-1-git-send-email-juhosg@openwrt.org>
References: <1365143225-24532-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The functions in the rt2x00mmio module has been
moved from the rt2x00pci module. Each function
uses the rt2x00pci prefix which is a bit confusing.
Use the r2x000mmio prefix for each function to make
it consistent with the module name.

The renamed functions are used by several modules,
and updating the names in all of them would result
in a big patch. In order to keep the patch simple,
add compatibility defines for the old function
names. This allows to update the names in each
module separately. After each module is updated,
the defines can be removed.

The patch contains no functional changes.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2x00mmio.c |   48 +++++++++++------------
 drivers/net/wireless/rt2x00/rt2x00mmio.h |   63 ++++++++++++++++++------------
 2 files changed, 61 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mmio.c b/drivers/net/wireless/rt2x00/rt2x00mmio.c
index d84a680..06c7669 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mmio.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mmio.c
@@ -34,10 +34,10 @@
 /*
  * Register access.
  */
-int rt2x00pci_regbusy_read(struct rt2x00_dev *rt2x00dev,
-			   const unsigned int offset,
-			   const struct rt2x00_field32 field,
-			   u32 *reg)
+int rt2x00mmio_regbusy_read(struct rt2x00_dev *rt2x00dev,
+			    const unsigned int offset,
+			    const struct rt2x00_field32 field,
+			    u32 *reg)
 {
 	unsigned int i;
 
@@ -45,7 +45,7 @@ int rt2x00pci_regbusy_read(struct rt2x00_dev *rt2x00dev,
 		return 0;
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2x00pci_register_read(rt2x00dev, offset, reg);
+		rt2x00mmio_register_read(rt2x00dev, offset, reg);
 		if (!rt2x00_get_field32(*reg, field))
 			return 1;
 		udelay(REGISTER_BUSY_DELAY);
@@ -57,13 +57,13 @@ int rt2x00pci_regbusy_read(struct rt2x00_dev *rt2x00dev,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(rt2x00pci_regbusy_read);
+EXPORT_SYMBOL_GPL(rt2x00mmio_regbusy_read);
 
-bool rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
+bool rt2x00mmio_rxdone(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue = rt2x00dev->rx;
 	struct queue_entry *entry;
-	struct queue_entry_priv_pci *entry_priv;
+	struct queue_entry_priv_mmio *entry_priv;
 	struct skb_frame_desc *skbdesc;
 	int max_rx = 16;
 
@@ -96,24 +96,24 @@ bool rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 
 	return !max_rx;
 }
-EXPORT_SYMBOL_GPL(rt2x00pci_rxdone);
+EXPORT_SYMBOL_GPL(rt2x00mmio_rxdone);
 
-void rt2x00pci_flush_queue(struct data_queue *queue, bool drop)
+void rt2x00mmio_flush_queue(struct data_queue *queue, bool drop)
 {
 	unsigned int i;
 
 	for (i = 0; !rt2x00queue_empty(queue) && i < 10; i++)
 		msleep(10);
 }
-EXPORT_SYMBOL_GPL(rt2x00pci_flush_queue);
+EXPORT_SYMBOL_GPL(rt2x00mmio_flush_queue);
 
 /*
  * Device initialization handlers.
  */
-static int rt2x00pci_alloc_queue_dma(struct rt2x00_dev *rt2x00dev,
-				     struct data_queue *queue)
+static int rt2x00mmio_alloc_queue_dma(struct rt2x00_dev *rt2x00dev,
+				      struct data_queue *queue)
 {
-	struct queue_entry_priv_pci *entry_priv;
+	struct queue_entry_priv_mmio *entry_priv;
 	void *addr;
 	dma_addr_t dma;
 	unsigned int i;
@@ -141,10 +141,10 @@ static int rt2x00pci_alloc_queue_dma(struct rt2x00_dev *rt2x00dev,
 	return 0;
 }
 
-static void rt2x00pci_free_queue_dma(struct rt2x00_dev *rt2x00dev,
-				     struct data_queue *queue)
+static void rt2x00mmio_free_queue_dma(struct rt2x00_dev *rt2x00dev,
+				      struct data_queue *queue)
 {
-	struct queue_entry_priv_pci *entry_priv =
+	struct queue_entry_priv_mmio *entry_priv =
 	    queue->entries[0].priv_data;
 
 	if (entry_priv->desc)
@@ -154,7 +154,7 @@ static void rt2x00pci_free_queue_dma(struct rt2x00_dev *rt2x00dev,
 	entry_priv->desc = NULL;
 }
 
-int rt2x00pci_initialize(struct rt2x00_dev *rt2x00dev)
+int rt2x00mmio_initialize(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
 	int status;
@@ -163,7 +163,7 @@ int rt2x00pci_initialize(struct rt2x00_dev *rt2x00dev)
 	 * Allocate DMA
 	 */
 	queue_for_each(rt2x00dev, queue) {
-		status = rt2x00pci_alloc_queue_dma(rt2x00dev, queue);
+		status = rt2x00mmio_alloc_queue_dma(rt2x00dev, queue);
 		if (status)
 			goto exit;
 	}
@@ -184,13 +184,13 @@ int rt2x00pci_initialize(struct rt2x00_dev *rt2x00dev)
 
 exit:
 	queue_for_each(rt2x00dev, queue)
-		rt2x00pci_free_queue_dma(rt2x00dev, queue);
+		rt2x00mmio_free_queue_dma(rt2x00dev, queue);
 
 	return status;
 }
-EXPORT_SYMBOL_GPL(rt2x00pci_initialize);
+EXPORT_SYMBOL_GPL(rt2x00mmio_initialize);
 
-void rt2x00pci_uninitialize(struct rt2x00_dev *rt2x00dev)
+void rt2x00mmio_uninitialize(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
 
@@ -203,9 +203,9 @@ void rt2x00pci_uninitialize(struct rt2x00_dev *rt2x00dev)
 	 * Free DMA
 	 */
 	queue_for_each(rt2x00dev, queue)
-		rt2x00pci_free_queue_dma(rt2x00dev, queue);
+		rt2x00mmio_free_queue_dma(rt2x00dev, queue);
 }
-EXPORT_SYMBOL_GPL(rt2x00pci_uninitialize);
+EXPORT_SYMBOL_GPL(rt2x00mmio_uninitialize);
 
 /*
  * rt2x00mmio module information.
diff --git a/drivers/net/wireless/rt2x00/rt2x00mmio.h b/drivers/net/wireless/rt2x00/rt2x00mmio.h
index 4ecaf60..b0396ca 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mmio.h
+++ b/drivers/net/wireless/rt2x00/rt2x00mmio.h
@@ -31,37 +31,41 @@
 /*
  * Register access.
  */
-static inline void rt2x00pci_register_read(struct rt2x00_dev *rt2x00dev,
-					   const unsigned int offset,
-					   u32 *value)
+static inline void rt2x00mmio_register_read(struct rt2x00_dev *rt2x00dev,
+					    const unsigned int offset,
+					    u32 *value)
 {
 	*value = readl(rt2x00dev->csr.base + offset);
 }
+#define rt2x00pci_register_read rt2x00mmio_register_read
 
-static inline void rt2x00pci_register_multiread(struct rt2x00_dev *rt2x00dev,
-						const unsigned int offset,
-						void *value, const u32 length)
+static inline void rt2x00mmio_register_multiread(struct rt2x00_dev *rt2x00dev,
+						 const unsigned int offset,
+						 void *value, const u32 length)
 {
 	memcpy_fromio(value, rt2x00dev->csr.base + offset, length);
 }
+#define rt2x00pci_register_multiread rt2x00mmio_register_multiread
 
-static inline void rt2x00pci_register_write(struct rt2x00_dev *rt2x00dev,
-					    const unsigned int offset,
-					    u32 value)
+static inline void rt2x00mmio_register_write(struct rt2x00_dev *rt2x00dev,
+					     const unsigned int offset,
+					     u32 value)
 {
 	writel(value, rt2x00dev->csr.base + offset);
 }
+#define rt2x00pci_register_write rt2x00mmio_register_write
 
-static inline void rt2x00pci_register_multiwrite(struct rt2x00_dev *rt2x00dev,
-						 const unsigned int offset,
-						 const void *value,
-						 const u32 length)
+static inline void rt2x00mmio_register_multiwrite(struct rt2x00_dev *rt2x00dev,
+						  const unsigned int offset,
+						  const void *value,
+						  const u32 length)
 {
 	__iowrite32_copy(rt2x00dev->csr.base + offset, value, length >> 2);
 }
+#define rt2x00pci_register_multiwrite rt2x00mmio_register_multiwrite
 
 /**
- * rt2x00pci_regbusy_read - Read from register with busy check
+ * rt2x00mmio_regbusy_read - Read from register with busy check
  * @rt2x00dev: Device pointer, see &struct rt2x00_dev.
  * @offset: Register offset
  * @field: Field to check if register is busy
@@ -73,47 +77,54 @@ static inline void rt2x00pci_register_multiwrite(struct rt2x00_dev *rt2x00dev,
  * is not read after a certain timeout, this function will return
  * FALSE.
  */
-int rt2x00pci_regbusy_read(struct rt2x00_dev *rt2x00dev,
-			   const unsigned int offset,
-			   const struct rt2x00_field32 field,
-			   u32 *reg);
+int rt2x00mmio_regbusy_read(struct rt2x00_dev *rt2x00dev,
+			    const unsigned int offset,
+			    const struct rt2x00_field32 field,
+			    u32 *reg);
+#define rt2x00pci_regbusy_read rt2x00mmio_regbusy_read
 
 /**
- * struct queue_entry_priv_pci: Per entry PCI specific information
+ * struct queue_entry_priv_mmio: Per entry PCI specific information
  *
  * @desc: Pointer to device descriptor
  * @desc_dma: DMA pointer to &desc.
  * @data: Pointer to device's entry memory.
  * @data_dma: DMA pointer to &data.
  */
-struct queue_entry_priv_pci {
+struct queue_entry_priv_mmio {
 	__le32 *desc;
 	dma_addr_t desc_dma;
 };
+#define queue_entry_priv_pci queue_entry_priv_mmio
 
 /**
- * rt2x00pci_rxdone - Handle RX done events
+ * rt2x00mmio_rxdone - Handle RX done events
  * @rt2x00dev: Device pointer, see &struct rt2x00_dev.
  *
  * Returns true if there are still rx frames pending and false if all
  * pending rx frames were processed.
  */
-bool rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev);
+bool rt2x00mmio_rxdone(struct rt2x00_dev *rt2x00dev);
+#define rt2x00pci_rxdone rt2x00mmio_rxdone
 
 /**
- * rt2x00pci_flush_queue - Flush data queue
+ * rt2x00mmio_flush_queue - Flush data queue
  * @queue: Data queue to stop
  * @drop: True to drop all pending frames.
  *
  * This will wait for a maximum of 100ms, waiting for the queues
  * to become empty.
  */
-void rt2x00pci_flush_queue(struct data_queue *queue, bool drop);
+void rt2x00mmio_flush_queue(struct data_queue *queue, bool drop);
+#define rt2x00pci_flush_queue rt2x00mmio_flush_queue
 
 /*
  * Device initialization handlers.
  */
-int rt2x00pci_initialize(struct rt2x00_dev *rt2x00dev);
-void rt2x00pci_uninitialize(struct rt2x00_dev *rt2x00dev);
+int rt2x00mmio_initialize(struct rt2x00_dev *rt2x00dev);
+#define rt2x00pci_initialize rt2x00mmio_initialize
+
+void rt2x00mmio_uninitialize(struct rt2x00_dev *rt2x00dev);
+#define rt2x00pci_uninitialize rt2x00mmio_uninitialize
 
 #endif /* RT2X00MMIO_H */
-- 
1.7.10

