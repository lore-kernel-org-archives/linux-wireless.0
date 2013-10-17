Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48766 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab3JQHms (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:48 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 11/21] rt2x00: rt2800pci: move initialization functions to the rt2800mmio module
Date: Thu, 17 Oct 2013 09:42:25 +0200
Message-Id: <1381995755-16471-12-git-send-email-juhosg@openwrt.org> (sfid-20131017_094301_298555_E813AD8B)
In-Reply-To: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
References: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the functions into a separate module, in order
to make those usable from other modules.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800mmio.c |  163 ++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800mmio.h |    6 ++
 drivers/net/wireless/rt2x00/rt2800pci.c  |  159 -----------------------------
 3 files changed, 169 insertions(+), 159 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800mmio.c b/drivers/net/wireless/rt2x00/rt2800mmio.c
index c42bea5..7e8c224 100644
--- a/drivers/net/wireless/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/rt2x00/rt2800mmio.c
@@ -689,6 +689,169 @@ void rt2800mmio_queue_init(struct data_queue *queue)
 }
 EXPORT_SYMBOL_GPL(rt2800mmio_queue_init);
 
+/*
+ * Initialization functions.
+ */
+bool rt2800mmio_get_entry_state(struct queue_entry *entry)
+{
+	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
+	u32 word;
+
+	if (entry->queue->qid == QID_RX) {
+		rt2x00_desc_read(entry_priv->desc, 1, &word);
+
+		return (!rt2x00_get_field32(word, RXD_W1_DMA_DONE));
+	} else {
+		rt2x00_desc_read(entry_priv->desc, 1, &word);
+
+		return (!rt2x00_get_field32(word, TXD_W1_DMA_DONE));
+	}
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_get_entry_state);
+
+void rt2800mmio_clear_entry(struct queue_entry *entry)
+{
+	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	u32 word;
+
+	if (entry->queue->qid == QID_RX) {
+		rt2x00_desc_read(entry_priv->desc, 0, &word);
+		rt2x00_set_field32(&word, RXD_W0_SDP0, skbdesc->skb_dma);
+		rt2x00_desc_write(entry_priv->desc, 0, word);
+
+		rt2x00_desc_read(entry_priv->desc, 1, &word);
+		rt2x00_set_field32(&word, RXD_W1_DMA_DONE, 0);
+		rt2x00_desc_write(entry_priv->desc, 1, word);
+
+		/*
+		 * Set RX IDX in register to inform hardware that we have
+		 * handled this entry and it is available for reuse again.
+		 */
+		rt2x00mmio_register_write(rt2x00dev, RX_CRX_IDX,
+					  entry->entry_idx);
+	} else {
+		rt2x00_desc_read(entry_priv->desc, 1, &word);
+		rt2x00_set_field32(&word, TXD_W1_DMA_DONE, 1);
+		rt2x00_desc_write(entry_priv->desc, 1, word);
+	}
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_clear_entry);
+
+int rt2800mmio_init_queues(struct rt2x00_dev *rt2x00dev)
+{
+	struct queue_entry_priv_mmio *entry_priv;
+
+	/*
+	 * Initialize registers.
+	 */
+	entry_priv = rt2x00dev->tx[0].entries[0].priv_data;
+	rt2x00mmio_register_write(rt2x00dev, TX_BASE_PTR0,
+				  entry_priv->desc_dma);
+	rt2x00mmio_register_write(rt2x00dev, TX_MAX_CNT0,
+				  rt2x00dev->tx[0].limit);
+	rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX0, 0);
+	rt2x00mmio_register_write(rt2x00dev, TX_DTX_IDX0, 0);
+
+	entry_priv = rt2x00dev->tx[1].entries[0].priv_data;
+	rt2x00mmio_register_write(rt2x00dev, TX_BASE_PTR1,
+				  entry_priv->desc_dma);
+	rt2x00mmio_register_write(rt2x00dev, TX_MAX_CNT1,
+				  rt2x00dev->tx[1].limit);
+	rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX1, 0);
+	rt2x00mmio_register_write(rt2x00dev, TX_DTX_IDX1, 0);
+
+	entry_priv = rt2x00dev->tx[2].entries[0].priv_data;
+	rt2x00mmio_register_write(rt2x00dev, TX_BASE_PTR2,
+				  entry_priv->desc_dma);
+	rt2x00mmio_register_write(rt2x00dev, TX_MAX_CNT2,
+				  rt2x00dev->tx[2].limit);
+	rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX2, 0);
+	rt2x00mmio_register_write(rt2x00dev, TX_DTX_IDX2, 0);
+
+	entry_priv = rt2x00dev->tx[3].entries[0].priv_data;
+	rt2x00mmio_register_write(rt2x00dev, TX_BASE_PTR3,
+				  entry_priv->desc_dma);
+	rt2x00mmio_register_write(rt2x00dev, TX_MAX_CNT3,
+				  rt2x00dev->tx[3].limit);
+	rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX3, 0);
+	rt2x00mmio_register_write(rt2x00dev, TX_DTX_IDX3, 0);
+
+	rt2x00mmio_register_write(rt2x00dev, TX_BASE_PTR4, 0);
+	rt2x00mmio_register_write(rt2x00dev, TX_MAX_CNT4, 0);
+	rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX4, 0);
+	rt2x00mmio_register_write(rt2x00dev, TX_DTX_IDX4, 0);
+
+	rt2x00mmio_register_write(rt2x00dev, TX_BASE_PTR5, 0);
+	rt2x00mmio_register_write(rt2x00dev, TX_MAX_CNT5, 0);
+	rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX5, 0);
+	rt2x00mmio_register_write(rt2x00dev, TX_DTX_IDX5, 0);
+
+	entry_priv = rt2x00dev->rx->entries[0].priv_data;
+	rt2x00mmio_register_write(rt2x00dev, RX_BASE_PTR,
+				  entry_priv->desc_dma);
+	rt2x00mmio_register_write(rt2x00dev, RX_MAX_CNT,
+				  rt2x00dev->rx[0].limit);
+	rt2x00mmio_register_write(rt2x00dev, RX_CRX_IDX,
+				  rt2x00dev->rx[0].limit - 1);
+	rt2x00mmio_register_write(rt2x00dev, RX_DRX_IDX, 0);
+
+	rt2800_disable_wpdma(rt2x00dev);
+
+	rt2x00mmio_register_write(rt2x00dev, DELAY_INT_CFG, 0);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_init_queues);
+
+int rt2800mmio_init_registers(struct rt2x00_dev *rt2x00dev)
+{
+	u32 reg;
+
+	/*
+	 * Reset DMA indexes
+	 */
+	rt2x00mmio_register_read(rt2x00dev, WPDMA_RST_IDX, &reg);
+	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX0, 1);
+	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX1, 1);
+	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX2, 1);
+	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX3, 1);
+	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX4, 1);
+	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX5, 1);
+	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DRX_IDX0, 1);
+	rt2x00mmio_register_write(rt2x00dev, WPDMA_RST_IDX, reg);
+
+	rt2x00mmio_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e1f);
+	rt2x00mmio_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
+
+	if (rt2x00_is_pcie(rt2x00dev) &&
+	    (rt2x00_rt(rt2x00dev, RT3090) ||
+	     rt2x00_rt(rt2x00dev, RT3390) ||
+	     rt2x00_rt(rt2x00dev, RT3572) ||
+	     rt2x00_rt(rt2x00dev, RT3593) ||
+	     rt2x00_rt(rt2x00dev, RT5390) ||
+	     rt2x00_rt(rt2x00dev, RT5392) ||
+	     rt2x00_rt(rt2x00dev, RT5592))) {
+		rt2x00mmio_register_read(rt2x00dev, AUX_CTRL, &reg);
+		rt2x00_set_field32(&reg, AUX_CTRL_FORCE_PCIE_CLK, 1);
+		rt2x00_set_field32(&reg, AUX_CTRL_WAKE_PCIE_EN, 1);
+		rt2x00mmio_register_write(rt2x00dev, AUX_CTRL, reg);
+	}
+
+	rt2x00mmio_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
+
+	reg = 0;
+	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 1);
+	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_BBP, 1);
+	rt2x00mmio_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+
+	rt2x00mmio_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_init_registers);
+
 MODULE_AUTHOR(DRV_PROJECT);
 MODULE_VERSION(DRV_VERSION);
 MODULE_DESCRIPTION("rt2800 MMIO library");
diff --git a/drivers/net/wireless/rt2x00/rt2800mmio.h b/drivers/net/wireless/rt2x00/rt2800mmio.h
index 676df2e..392895a 100644
--- a/drivers/net/wireless/rt2x00/rt2800mmio.h
+++ b/drivers/net/wireless/rt2x00/rt2800mmio.h
@@ -153,4 +153,10 @@ void rt2800mmio_kick_queue(struct data_queue *queue);
 void rt2800mmio_stop_queue(struct data_queue *queue);
 void rt2800mmio_queue_init(struct data_queue *queue);
 
+/* Initialization functions */
+bool rt2800mmio_get_entry_state(struct queue_entry *entry);
+void rt2800mmio_clear_entry(struct queue_entry *entry);
+int rt2800mmio_init_queues(struct rt2x00_dev *rt2x00dev);
+int rt2800mmio_init_registers(struct rt2x00_dev *rt2x00dev);
+
 #endif /* RT2800MMIO_H */
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 7770471..5ae90df6 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -243,167 +243,8 @@ static int rt2800pci_write_firmware(struct rt2x00_dev *rt2x00dev,
 }
 
 /*
- * Initialization functions.
- */
-static bool rt2800mmio_get_entry_state(struct queue_entry *entry)
-{
-	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
-	u32 word;
-
-	if (entry->queue->qid == QID_RX) {
-		rt2x00_desc_read(entry_priv->desc, 1, &word);
-
-		return (!rt2x00_get_field32(word, RXD_W1_DMA_DONE));
-	} else {
-		rt2x00_desc_read(entry_priv->desc, 1, &word);
-
-		return (!rt2x00_get_field32(word, TXD_W1_DMA_DONE));
-	}
-}
-
-static void rt2800mmio_clear_entry(struct queue_entry *entry)
-{
-	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
-	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	u32 word;
-
-	if (entry->queue->qid == QID_RX) {
-		rt2x00_desc_read(entry_priv->desc, 0, &word);
-		rt2x00_set_field32(&word, RXD_W0_SDP0, skbdesc->skb_dma);
-		rt2x00_desc_write(entry_priv->desc, 0, word);
-
-		rt2x00_desc_read(entry_priv->desc, 1, &word);
-		rt2x00_set_field32(&word, RXD_W1_DMA_DONE, 0);
-		rt2x00_desc_write(entry_priv->desc, 1, word);
-
-		/*
-		 * Set RX IDX in register to inform hardware that we have
-		 * handled this entry and it is available for reuse again.
-		 */
-		rt2x00mmio_register_write(rt2x00dev, RX_CRX_IDX,
-					  entry->entry_idx);
-	} else {
-		rt2x00_desc_read(entry_priv->desc, 1, &word);
-		rt2x00_set_field32(&word, TXD_W1_DMA_DONE, 1);
-		rt2x00_desc_write(entry_priv->desc, 1, word);
-	}
-}
-
-static int rt2800mmio_init_queues(struct rt2x00_dev *rt2x00dev)
-{
-	struct queue_entry_priv_mmio *entry_priv;
-
-	/*
-	 * Initialize registers.
-	 */
-	entry_priv = rt2x00dev->tx[0].entries[0].priv_data;
-	rt2x00mmio_register_write(rt2x00dev, TX_BASE_PTR0,
-				  entry_priv->desc_dma);
-	rt2x00mmio_register_write(rt2x00dev, TX_MAX_CNT0,
-				  rt2x00dev->tx[0].limit);
-	rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX0, 0);
-	rt2x00mmio_register_write(rt2x00dev, TX_DTX_IDX0, 0);
-
-	entry_priv = rt2x00dev->tx[1].entries[0].priv_data;
-	rt2x00mmio_register_write(rt2x00dev, TX_BASE_PTR1,
-				  entry_priv->desc_dma);
-	rt2x00mmio_register_write(rt2x00dev, TX_MAX_CNT1,
-				  rt2x00dev->tx[1].limit);
-	rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX1, 0);
-	rt2x00mmio_register_write(rt2x00dev, TX_DTX_IDX1, 0);
-
-	entry_priv = rt2x00dev->tx[2].entries[0].priv_data;
-	rt2x00mmio_register_write(rt2x00dev, TX_BASE_PTR2,
-				  entry_priv->desc_dma);
-	rt2x00mmio_register_write(rt2x00dev, TX_MAX_CNT2,
-				  rt2x00dev->tx[2].limit);
-	rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX2, 0);
-	rt2x00mmio_register_write(rt2x00dev, TX_DTX_IDX2, 0);
-
-	entry_priv = rt2x00dev->tx[3].entries[0].priv_data;
-	rt2x00mmio_register_write(rt2x00dev, TX_BASE_PTR3,
-				  entry_priv->desc_dma);
-	rt2x00mmio_register_write(rt2x00dev, TX_MAX_CNT3,
-				  rt2x00dev->tx[3].limit);
-	rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX3, 0);
-	rt2x00mmio_register_write(rt2x00dev, TX_DTX_IDX3, 0);
-
-	rt2x00mmio_register_write(rt2x00dev, TX_BASE_PTR4, 0);
-	rt2x00mmio_register_write(rt2x00dev, TX_MAX_CNT4, 0);
-	rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX4, 0);
-	rt2x00mmio_register_write(rt2x00dev, TX_DTX_IDX4, 0);
-
-	rt2x00mmio_register_write(rt2x00dev, TX_BASE_PTR5, 0);
-	rt2x00mmio_register_write(rt2x00dev, TX_MAX_CNT5, 0);
-	rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX5, 0);
-	rt2x00mmio_register_write(rt2x00dev, TX_DTX_IDX5, 0);
-
-	entry_priv = rt2x00dev->rx->entries[0].priv_data;
-	rt2x00mmio_register_write(rt2x00dev, RX_BASE_PTR,
-				  entry_priv->desc_dma);
-	rt2x00mmio_register_write(rt2x00dev, RX_MAX_CNT,
-				  rt2x00dev->rx[0].limit);
-	rt2x00mmio_register_write(rt2x00dev, RX_CRX_IDX,
-				  rt2x00dev->rx[0].limit - 1);
-	rt2x00mmio_register_write(rt2x00dev, RX_DRX_IDX, 0);
-
-	rt2800_disable_wpdma(rt2x00dev);
-
-	rt2x00mmio_register_write(rt2x00dev, DELAY_INT_CFG, 0);
-
-	return 0;
-}
-
-/*
  * Device state switch handlers.
  */
-static int rt2800mmio_init_registers(struct rt2x00_dev *rt2x00dev)
-{
-	u32 reg;
-
-	/*
-	 * Reset DMA indexes
-	 */
-	rt2x00mmio_register_read(rt2x00dev, WPDMA_RST_IDX, &reg);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX0, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX1, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX2, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX3, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX4, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX5, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DRX_IDX0, 1);
-	rt2x00mmio_register_write(rt2x00dev, WPDMA_RST_IDX, reg);
-
-	rt2x00mmio_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e1f);
-	rt2x00mmio_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
-
-	if (rt2x00_is_pcie(rt2x00dev) &&
-	    (rt2x00_rt(rt2x00dev, RT3090) ||
-	     rt2x00_rt(rt2x00dev, RT3390) ||
-	     rt2x00_rt(rt2x00dev, RT3572) ||
-	     rt2x00_rt(rt2x00dev, RT3593) ||
-	     rt2x00_rt(rt2x00dev, RT5390) ||
-	     rt2x00_rt(rt2x00dev, RT5392) ||
-	     rt2x00_rt(rt2x00dev, RT5592))) {
-		rt2x00mmio_register_read(rt2x00dev, AUX_CTRL, &reg);
-		rt2x00_set_field32(&reg, AUX_CTRL_FORCE_PCIE_CLK, 1);
-		rt2x00_set_field32(&reg, AUX_CTRL_WAKE_PCIE_EN, 1);
-		rt2x00mmio_register_write(rt2x00dev, AUX_CTRL, reg);
-	}
-
-	rt2x00mmio_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
-
-	reg = 0;
-	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 1);
-	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_BBP, 1);
-	rt2x00mmio_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
-
-	rt2x00mmio_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
-
-	return 0;
-}
-
 static int rt2800pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
-- 
1.7.10
