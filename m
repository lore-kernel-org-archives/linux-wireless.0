Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48763 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab3JQHmr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:47 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 09/21] rt2x00: rt2800pci: move queue functions to the rt2800mmio module
Date: Thu, 17 Oct 2013 09:42:23 +0200
Message-Id: <1381995755-16471-10-git-send-email-juhosg@openwrt.org> (sfid-20131017_094251_033943_D06BFA70)
In-Reply-To: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
References: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the functions into a separate module, in order
to make those usable from other modules. Also move
the queue register offset macros from rt2800pci.h
into rt2800mmio.h.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800mmio.c |  137 ++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800mmio.h |   15 ++++
 drivers/net/wireless/rt2x00/rt2800pci.c  |  133 -----------------------------
 drivers/net/wireless/rt2x00/rt2800pci.h  |    9 --
 4 files changed, 152 insertions(+), 142 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800mmio.c b/drivers/net/wireless/rt2x00/rt2800mmio.c
index bfae4f0..c42bea5 100644
--- a/drivers/net/wireless/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/rt2x00/rt2800mmio.c
@@ -552,6 +552,143 @@ void rt2800mmio_toggle_irq(struct rt2x00_dev *rt2x00dev,
 }
 EXPORT_SYMBOL_GPL(rt2800mmio_toggle_irq);
 
+/*
+ * Queue handlers.
+ */
+void rt2800mmio_start_queue(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u32 reg;
+
+	switch (queue->qid) {
+	case QID_RX:
+		rt2x00mmio_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+		rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 1);
+		rt2x00mmio_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+		break;
+	case QID_BEACON:
+		rt2x00mmio_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 1);
+		rt2x00mmio_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+
+		rt2x00mmio_register_read(rt2x00dev, INT_TIMER_EN, &reg);
+		rt2x00_set_field32(&reg, INT_TIMER_EN_PRE_TBTT_TIMER, 1);
+		rt2x00mmio_register_write(rt2x00dev, INT_TIMER_EN, reg);
+		break;
+	default:
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_start_queue);
+
+void rt2800mmio_kick_queue(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	struct queue_entry *entry;
+
+	switch (queue->qid) {
+	case QID_AC_VO:
+	case QID_AC_VI:
+	case QID_AC_BE:
+	case QID_AC_BK:
+		entry = rt2x00queue_get_entry(queue, Q_INDEX);
+		rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX(queue->qid),
+					  entry->entry_idx);
+		break;
+	case QID_MGMT:
+		entry = rt2x00queue_get_entry(queue, Q_INDEX);
+		rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX(5),
+					  entry->entry_idx);
+		break;
+	default:
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_kick_queue);
+
+void rt2800mmio_stop_queue(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u32 reg;
+
+	switch (queue->qid) {
+	case QID_RX:
+		rt2x00mmio_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+		rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 0);
+		rt2x00mmio_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+		break;
+	case QID_BEACON:
+		rt2x00mmio_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 0);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 0);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
+		rt2x00mmio_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+
+		rt2x00mmio_register_read(rt2x00dev, INT_TIMER_EN, &reg);
+		rt2x00_set_field32(&reg, INT_TIMER_EN_PRE_TBTT_TIMER, 0);
+		rt2x00mmio_register_write(rt2x00dev, INT_TIMER_EN, reg);
+
+		/*
+		 * Wait for current invocation to finish. The tasklet
+		 * won't be scheduled anymore afterwards since we disabled
+		 * the TBTT and PRE TBTT timer.
+		 */
+		tasklet_kill(&rt2x00dev->tbtt_tasklet);
+		tasklet_kill(&rt2x00dev->pretbtt_tasklet);
+
+		break;
+	default:
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_stop_queue);
+
+void rt2800mmio_queue_init(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	unsigned short txwi_size, rxwi_size;
+
+	rt2800_get_txwi_rxwi_size(rt2x00dev, &txwi_size, &rxwi_size);
+
+	switch (queue->qid) {
+	case QID_RX:
+		queue->limit = 128;
+		queue->data_size = AGGREGATION_SIZE;
+		queue->desc_size = RXD_DESC_SIZE;
+		queue->winfo_size = rxwi_size;
+		queue->priv_size = sizeof(struct queue_entry_priv_mmio);
+		break;
+
+	case QID_AC_VO:
+	case QID_AC_VI:
+	case QID_AC_BE:
+	case QID_AC_BK:
+		queue->limit = 64;
+		queue->data_size = AGGREGATION_SIZE;
+		queue->desc_size = TXD_DESC_SIZE;
+		queue->winfo_size = txwi_size;
+		queue->priv_size = sizeof(struct queue_entry_priv_mmio);
+		break;
+
+	case QID_BEACON:
+		queue->limit = 8;
+		queue->data_size = 0; /* No DMA required for beacons */
+		queue->desc_size = TXD_DESC_SIZE;
+		queue->winfo_size = txwi_size;
+		queue->priv_size = sizeof(struct queue_entry_priv_mmio);
+		break;
+
+	case QID_ATIM:
+		/* fallthrough */
+	default:
+		BUG();
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_queue_init);
+
 MODULE_AUTHOR(DRV_PROJECT);
 MODULE_VERSION(DRV_VERSION);
 MODULE_DESCRIPTION("rt2800 MMIO library");
diff --git a/drivers/net/wireless/rt2x00/rt2800mmio.h b/drivers/net/wireless/rt2x00/rt2800mmio.h
index 30e66ab..676df2e 100644
--- a/drivers/net/wireless/rt2x00/rt2800mmio.h
+++ b/drivers/net/wireless/rt2x00/rt2800mmio.h
@@ -32,6 +32,15 @@
 #define RT2800MMIO_H
 
 /*
+ * Queue register offset macros
+ */
+#define TX_QUEUE_REG_OFFSET	0x10
+#define TX_BASE_PTR(__x)	(TX_BASE_PTR0 + ((__x) * TX_QUEUE_REG_OFFSET))
+#define TX_MAX_CNT(__x)		(TX_MAX_CNT0 + ((__x) * TX_QUEUE_REG_OFFSET))
+#define TX_CTX_IDX(__x)		(TX_CTX_IDX0 + ((__x) * TX_QUEUE_REG_OFFSET))
+#define TX_DTX_IDX(__x)		(TX_DTX_IDX0 + ((__x) * TX_QUEUE_REG_OFFSET))
+
+/*
  * DMA descriptor defines.
  */
 #define TXD_DESC_SIZE			(4 * sizeof(__le32))
@@ -138,4 +147,10 @@ irqreturn_t rt2800mmio_interrupt(int irq, void *dev_instance);
 void rt2800mmio_toggle_irq(struct rt2x00_dev *rt2x00dev,
 			   enum dev_state state);
 
+/* Queue handlers */
+void rt2800mmio_start_queue(struct data_queue *queue);
+void rt2800mmio_kick_queue(struct data_queue *queue);
+void rt2800mmio_stop_queue(struct data_queue *queue);
+void rt2800mmio_queue_init(struct data_queue *queue);
+
 #endif /* RT2800MMIO_H */
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 118f2d5..d0e4ec5 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -202,96 +202,6 @@ static inline int rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
 #endif /* CONFIG_PCI */
 
 /*
- * Queue handlers.
- */
-static void rt2800mmio_start_queue(struct data_queue *queue)
-{
-	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
-	u32 reg;
-
-	switch (queue->qid) {
-	case QID_RX:
-		rt2x00mmio_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
-		rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 1);
-		rt2x00mmio_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
-		break;
-	case QID_BEACON:
-		rt2x00mmio_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
-		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
-		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
-		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 1);
-		rt2x00mmio_register_write(rt2x00dev, BCN_TIME_CFG, reg);
-
-		rt2x00mmio_register_read(rt2x00dev, INT_TIMER_EN, &reg);
-		rt2x00_set_field32(&reg, INT_TIMER_EN_PRE_TBTT_TIMER, 1);
-		rt2x00mmio_register_write(rt2x00dev, INT_TIMER_EN, reg);
-		break;
-	default:
-		break;
-	}
-}
-
-static void rt2800mmio_kick_queue(struct data_queue *queue)
-{
-	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
-	struct queue_entry *entry;
-
-	switch (queue->qid) {
-	case QID_AC_VO:
-	case QID_AC_VI:
-	case QID_AC_BE:
-	case QID_AC_BK:
-		entry = rt2x00queue_get_entry(queue, Q_INDEX);
-		rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX(queue->qid),
-					  entry->entry_idx);
-		break;
-	case QID_MGMT:
-		entry = rt2x00queue_get_entry(queue, Q_INDEX);
-		rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX(5),
-					  entry->entry_idx);
-		break;
-	default:
-		break;
-	}
-}
-
-static void rt2800mmio_stop_queue(struct data_queue *queue)
-{
-	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
-	u32 reg;
-
-	switch (queue->qid) {
-	case QID_RX:
-		rt2x00mmio_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
-		rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 0);
-		rt2x00mmio_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
-		break;
-	case QID_BEACON:
-		rt2x00mmio_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
-		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 0);
-		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 0);
-		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
-		rt2x00mmio_register_write(rt2x00dev, BCN_TIME_CFG, reg);
-
-		rt2x00mmio_register_read(rt2x00dev, INT_TIMER_EN, &reg);
-		rt2x00_set_field32(&reg, INT_TIMER_EN_PRE_TBTT_TIMER, 0);
-		rt2x00mmio_register_write(rt2x00dev, INT_TIMER_EN, reg);
-
-		/*
-		 * Wait for current invocation to finish. The tasklet
-		 * won't be scheduled anymore afterwards since we disabled
-		 * the TBTT and PRE TBTT timer.
-		 */
-		tasklet_kill(&rt2x00dev->tbtt_tasklet);
-		tasklet_kill(&rt2x00dev->pretbtt_tasklet);
-
-		break;
-	default:
-		break;
-	}
-}
-
-/*
  * Firmware functions
  */
 static char *rt2800pci_get_firmware_name(struct rt2x00_dev *rt2x00dev)
@@ -689,49 +599,6 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.sta_remove		= rt2800_sta_remove,
 };
 
-static void rt2800mmio_queue_init(struct data_queue *queue)
-{
-	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
-	unsigned short txwi_size, rxwi_size;
-
-	rt2800_get_txwi_rxwi_size(rt2x00dev, &txwi_size, &rxwi_size);
-
-	switch (queue->qid) {
-	case QID_RX:
-		queue->limit = 128;
-		queue->data_size = AGGREGATION_SIZE;
-		queue->desc_size = RXD_DESC_SIZE;
-		queue->winfo_size = rxwi_size;
-		queue->priv_size = sizeof(struct queue_entry_priv_mmio);
-		break;
-
-	case QID_AC_VO:
-	case QID_AC_VI:
-	case QID_AC_BE:
-	case QID_AC_BK:
-		queue->limit = 64;
-		queue->data_size = AGGREGATION_SIZE;
-		queue->desc_size = TXD_DESC_SIZE;
-		queue->winfo_size = txwi_size;
-		queue->priv_size = sizeof(struct queue_entry_priv_mmio);
-		break;
-
-	case QID_BEACON:
-		queue->limit = 8;
-		queue->data_size = 0; /* No DMA required for beacons */
-		queue->desc_size = TXD_DESC_SIZE;
-		queue->winfo_size = txwi_size;
-		queue->priv_size = sizeof(struct queue_entry_priv_mmio);
-		break;
-
-	case QID_ATIM:
-		/* fallthrough */
-	default:
-		BUG();
-		break;
-	}
-}
-
 static const struct rt2x00_ops rt2800pci_ops = {
 	.name			= KBUILD_MODNAME,
 	.drv_data_size		= sizeof(struct rt2800_drv_data),
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.h b/drivers/net/wireless/rt2x00/rt2800pci.h
index 0e55159..a81c9ee 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.h
+++ b/drivers/net/wireless/rt2x00/rt2800pci.h
@@ -35,15 +35,6 @@
 #define RT2800PCI_H
 
 /*
- * Queue register offset macros
- */
-#define TX_QUEUE_REG_OFFSET		0x10
-#define TX_BASE_PTR(__x)		(TX_BASE_PTR0 + ((__x) * TX_QUEUE_REG_OFFSET))
-#define TX_MAX_CNT(__x)			(TX_MAX_CNT0 + ((__x) * TX_QUEUE_REG_OFFSET))
-#define TX_CTX_IDX(__x)			(TX_CTX_IDX0 + ((__x) * TX_QUEUE_REG_OFFSET))
-#define TX_DTX_IDX(__x)			(TX_DTX_IDX0 + ((__x) * TX_QUEUE_REG_OFFSET))
-
-/*
  * 8051 firmware image.
  */
 #define FIRMWARE_RT2860			"rt2860.bin"
-- 
1.7.10
