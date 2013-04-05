Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:33557 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161564Ab3DEG0p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 02:26:45 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 5/6] rt2x00: rt2800pci: use the rt2x00mmio_* routines
Date: Fri,  5 Apr 2013 08:27:04 +0200
Message-Id: <1365143225-24532-6-git-send-email-juhosg@openwrt.org> (sfid-20130405_082658_381572_A5392552)
In-Reply-To: <1365143225-24532-1-git-send-email-juhosg@openwrt.org>
References: <1365143225-24532-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the recently introduced rt2x00mmio_* routines
instead of the rt2x00pci_* variants.

The patch contains no functional changes.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |  241 ++++++++++++++++---------------
 1 file changed, 123 insertions(+), 118 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 565a80d..def357e 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -72,7 +72,7 @@ static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
 		return;
 
 	for (i = 0; i < 200; i++) {
-		rt2x00pci_register_read(rt2x00dev, H2M_MAILBOX_CID, &reg);
+		rt2x00mmio_register_read(rt2x00dev, H2M_MAILBOX_CID, &reg);
 
 		if ((rt2x00_get_field32(reg, H2M_MAILBOX_CID_CMD0) == token) ||
 		    (rt2x00_get_field32(reg, H2M_MAILBOX_CID_CMD1) == token) ||
@@ -86,8 +86,8 @@ static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
 	if (i == 200)
 		ERROR(rt2x00dev, "MCU request failed, no response from hardware\n");
 
-	rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
-	rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
+	rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
+	rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
 }
 
 #if defined(CONFIG_SOC_RT288X) || defined(CONFIG_SOC_RT305X)
@@ -116,7 +116,7 @@ static void rt2800pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
 	struct rt2x00_dev *rt2x00dev = eeprom->data;
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, E2PROM_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, E2PROM_CSR, &reg);
 
 	eeprom->reg_data_in = !!rt2x00_get_field32(reg, E2PROM_CSR_DATA_IN);
 	eeprom->reg_data_out = !!rt2x00_get_field32(reg, E2PROM_CSR_DATA_OUT);
@@ -138,7 +138,7 @@ static void rt2800pci_eepromregister_write(struct eeprom_93cx6 *eeprom)
 	rt2x00_set_field32(&reg, E2PROM_CSR_CHIP_SELECT,
 			   !!eeprom->reg_chip_select);
 
-	rt2x00pci_register_write(rt2x00dev, E2PROM_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, E2PROM_CSR, reg);
 }
 
 static int rt2800pci_read_eeprom_pci(struct rt2x00_dev *rt2x00dev)
@@ -146,7 +146,7 @@ static int rt2800pci_read_eeprom_pci(struct rt2x00_dev *rt2x00dev)
 	struct eeprom_93cx6 eeprom;
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, E2PROM_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, E2PROM_CSR, &reg);
 
 	eeprom.data = rt2x00dev;
 	eeprom.register_read = rt2800pci_eepromregister_read;
@@ -210,20 +210,20 @@ static void rt2800pci_start_queue(struct data_queue *queue)
 
 	switch (queue->qid) {
 	case QID_RX:
-		rt2x00pci_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+		rt2x00mmio_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
 		rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 1);
-		rt2x00pci_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+		rt2x00mmio_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 		break;
 	case QID_BEACON:
-		rt2x00pci_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+		rt2x00mmio_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 1);
-		rt2x00pci_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+		rt2x00mmio_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
-		rt2x00pci_register_read(rt2x00dev, INT_TIMER_EN, &reg);
+		rt2x00mmio_register_read(rt2x00dev, INT_TIMER_EN, &reg);
 		rt2x00_set_field32(&reg, INT_TIMER_EN_PRE_TBTT_TIMER, 1);
-		rt2x00pci_register_write(rt2x00dev, INT_TIMER_EN, reg);
+		rt2x00mmio_register_write(rt2x00dev, INT_TIMER_EN, reg);
 		break;
 	default:
 		break;
@@ -241,13 +241,13 @@ static void rt2800pci_kick_queue(struct data_queue *queue)
 	case QID_AC_BE:
 	case QID_AC_BK:
 		entry = rt2x00queue_get_entry(queue, Q_INDEX);
-		rt2x00pci_register_write(rt2x00dev, TX_CTX_IDX(queue->qid),
-					 entry->entry_idx);
+		rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX(queue->qid),
+					  entry->entry_idx);
 		break;
 	case QID_MGMT:
 		entry = rt2x00queue_get_entry(queue, Q_INDEX);
-		rt2x00pci_register_write(rt2x00dev, TX_CTX_IDX(5),
-					 entry->entry_idx);
+		rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX(5),
+					  entry->entry_idx);
 		break;
 	default:
 		break;
@@ -261,20 +261,20 @@ static void rt2800pci_stop_queue(struct data_queue *queue)
 
 	switch (queue->qid) {
 	case QID_RX:
-		rt2x00pci_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+		rt2x00mmio_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
 		rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 0);
-		rt2x00pci_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+		rt2x00mmio_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 		break;
 	case QID_BEACON:
-		rt2x00pci_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+		rt2x00mmio_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 0);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 0);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
-		rt2x00pci_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+		rt2x00mmio_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
-		rt2x00pci_register_read(rt2x00dev, INT_TIMER_EN, &reg);
+		rt2x00mmio_register_read(rt2x00dev, INT_TIMER_EN, &reg);
 		rt2x00_set_field32(&reg, INT_TIMER_EN_PRE_TBTT_TIMER, 0);
-		rt2x00pci_register_write(rt2x00dev, INT_TIMER_EN, reg);
+		rt2x00mmio_register_write(rt2x00dev, INT_TIMER_EN, reg);
 
 		/*
 		 * Wait for current invocation to finish. The tasklet
@@ -314,19 +314,19 @@ static int rt2800pci_write_firmware(struct rt2x00_dev *rt2x00dev,
 	 */
 	reg = 0;
 	rt2x00_set_field32(&reg, PBF_SYS_CTRL_HOST_RAM_WRITE, 1);
-	rt2x00pci_register_write(rt2x00dev, PBF_SYS_CTRL, reg);
+	rt2x00mmio_register_write(rt2x00dev, PBF_SYS_CTRL, reg);
 
 	/*
 	 * Write firmware to device.
 	 */
-	rt2x00pci_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE,
-				      data, len);
+	rt2x00mmio_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE,
+				       data, len);
 
-	rt2x00pci_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000);
-	rt2x00pci_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00001);
+	rt2x00mmio_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000);
+	rt2x00mmio_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00001);
 
-	rt2x00pci_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
-	rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	rt2x00mmio_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
+	rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
 
 	return 0;
 }
@@ -336,7 +336,7 @@ static int rt2800pci_write_firmware(struct rt2x00_dev *rt2x00dev,
  */
 static bool rt2800pci_get_entry_state(struct queue_entry *entry)
 {
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	u32 word;
 
 	if (entry->queue->qid == QID_RX) {
@@ -352,7 +352,7 @@ static bool rt2800pci_get_entry_state(struct queue_entry *entry)
 
 static void rt2800pci_clear_entry(struct queue_entry *entry)
 {
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	u32 word;
@@ -370,8 +370,8 @@ static void rt2800pci_clear_entry(struct queue_entry *entry)
 		 * Set RX IDX in register to inform hardware that we have
 		 * handled this entry and it is available for reuse again.
 		 */
-		rt2x00pci_register_write(rt2x00dev, RX_CRX_IDX,
-				      entry->entry_idx);
+		rt2x00mmio_register_write(rt2x00dev, RX_CRX_IDX,
+					  entry->entry_idx);
 	} else {
 		rt2x00_desc_read(entry_priv->desc, 1, &word);
 		rt2x00_set_field32(&word, TXD_W1_DMA_DONE, 1);
@@ -381,60 +381,65 @@ static void rt2800pci_clear_entry(struct queue_entry *entry)
 
 static int rt2800pci_init_queues(struct rt2x00_dev *rt2x00dev)
 {
-	struct queue_entry_priv_pci *entry_priv;
+	struct queue_entry_priv_mmio *entry_priv;
 
 	/*
 	 * Initialize registers.
 	 */
 	entry_priv = rt2x00dev->tx[0].entries[0].priv_data;
-	rt2x00pci_register_write(rt2x00dev, TX_BASE_PTR0, entry_priv->desc_dma);
-	rt2x00pci_register_write(rt2x00dev, TX_MAX_CNT0,
-				 rt2x00dev->tx[0].limit);
-	rt2x00pci_register_write(rt2x00dev, TX_CTX_IDX0, 0);
-	rt2x00pci_register_write(rt2x00dev, TX_DTX_IDX0, 0);
+	rt2x00mmio_register_write(rt2x00dev, TX_BASE_PTR0,
+				  entry_priv->desc_dma);
+	rt2x00mmio_register_write(rt2x00dev, TX_MAX_CNT0,
+				  rt2x00dev->tx[0].limit);
+	rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX0, 0);
+	rt2x00mmio_register_write(rt2x00dev, TX_DTX_IDX0, 0);
 
 	entry_priv = rt2x00dev->tx[1].entries[0].priv_data;
-	rt2x00pci_register_write(rt2x00dev, TX_BASE_PTR1, entry_priv->desc_dma);
-	rt2x00pci_register_write(rt2x00dev, TX_MAX_CNT1,
-				 rt2x00dev->tx[1].limit);
-	rt2x00pci_register_write(rt2x00dev, TX_CTX_IDX1, 0);
-	rt2x00pci_register_write(rt2x00dev, TX_DTX_IDX1, 0);
+	rt2x00mmio_register_write(rt2x00dev, TX_BASE_PTR1,
+				  entry_priv->desc_dma);
+	rt2x00mmio_register_write(rt2x00dev, TX_MAX_CNT1,
+				  rt2x00dev->tx[1].limit);
+	rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX1, 0);
+	rt2x00mmio_register_write(rt2x00dev, TX_DTX_IDX1, 0);
 
 	entry_priv = rt2x00dev->tx[2].entries[0].priv_data;
-	rt2x00pci_register_write(rt2x00dev, TX_BASE_PTR2, entry_priv->desc_dma);
-	rt2x00pci_register_write(rt2x00dev, TX_MAX_CNT2,
-				 rt2x00dev->tx[2].limit);
-	rt2x00pci_register_write(rt2x00dev, TX_CTX_IDX2, 0);
-	rt2x00pci_register_write(rt2x00dev, TX_DTX_IDX2, 0);
+	rt2x00mmio_register_write(rt2x00dev, TX_BASE_PTR2,
+				  entry_priv->desc_dma);
+	rt2x00mmio_register_write(rt2x00dev, TX_MAX_CNT2,
+				  rt2x00dev->tx[2].limit);
+	rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX2, 0);
+	rt2x00mmio_register_write(rt2x00dev, TX_DTX_IDX2, 0);
 
 	entry_priv = rt2x00dev->tx[3].entries[0].priv_data;
-	rt2x00pci_register_write(rt2x00dev, TX_BASE_PTR3, entry_priv->desc_dma);
-	rt2x00pci_register_write(rt2x00dev, TX_MAX_CNT3,
-				 rt2x00dev->tx[3].limit);
-	rt2x00pci_register_write(rt2x00dev, TX_CTX_IDX3, 0);
-	rt2x00pci_register_write(rt2x00dev, TX_DTX_IDX3, 0);
-
-	rt2x00pci_register_write(rt2x00dev, TX_BASE_PTR4, 0);
-	rt2x00pci_register_write(rt2x00dev, TX_MAX_CNT4, 0);
-	rt2x00pci_register_write(rt2x00dev, TX_CTX_IDX4, 0);
-	rt2x00pci_register_write(rt2x00dev, TX_DTX_IDX4, 0);
-
-	rt2x00pci_register_write(rt2x00dev, TX_BASE_PTR5, 0);
-	rt2x00pci_register_write(rt2x00dev, TX_MAX_CNT5, 0);
-	rt2x00pci_register_write(rt2x00dev, TX_CTX_IDX5, 0);
-	rt2x00pci_register_write(rt2x00dev, TX_DTX_IDX5, 0);
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
 
 	entry_priv = rt2x00dev->rx->entries[0].priv_data;
-	rt2x00pci_register_write(rt2x00dev, RX_BASE_PTR, entry_priv->desc_dma);
-	rt2x00pci_register_write(rt2x00dev, RX_MAX_CNT,
-				 rt2x00dev->rx[0].limit);
-	rt2x00pci_register_write(rt2x00dev, RX_CRX_IDX,
-				 rt2x00dev->rx[0].limit - 1);
-	rt2x00pci_register_write(rt2x00dev, RX_DRX_IDX, 0);
+	rt2x00mmio_register_write(rt2x00dev, RX_BASE_PTR,
+				  entry_priv->desc_dma);
+	rt2x00mmio_register_write(rt2x00dev, RX_MAX_CNT,
+				  rt2x00dev->rx[0].limit);
+	rt2x00mmio_register_write(rt2x00dev, RX_CRX_IDX,
+				  rt2x00dev->rx[0].limit - 1);
+	rt2x00mmio_register_write(rt2x00dev, RX_DRX_IDX, 0);
 
 	rt2800_disable_wpdma(rt2x00dev);
 
-	rt2x00pci_register_write(rt2x00dev, DELAY_INT_CFG, 0);
+	rt2x00mmio_register_write(rt2x00dev, DELAY_INT_CFG, 0);
 
 	return 0;
 }
@@ -453,8 +458,8 @@ static void rt2800pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	 * should clear the register to assure a clean state.
 	 */
 	if (state == STATE_RADIO_IRQ_ON) {
-		rt2x00pci_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
-		rt2x00pci_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
+		rt2x00mmio_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
+		rt2x00mmio_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
 	}
 
 	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
@@ -466,7 +471,7 @@ static void rt2800pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, INT_MASK_CSR_TX_FIFO_STATUS, 1);
 		rt2x00_set_field32(&reg, INT_MASK_CSR_AUTO_WAKEUP, 1);
 	}
-	rt2x00pci_register_write(rt2x00dev, INT_MASK_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, INT_MASK_CSR, reg);
 	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
 
 	if (state == STATE_RADIO_IRQ_OFF) {
@@ -488,7 +493,7 @@ static int rt2800pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Reset DMA indexes
 	 */
-	rt2x00pci_register_read(rt2x00dev, WPDMA_RST_IDX, &reg);
+	rt2x00mmio_register_read(rt2x00dev, WPDMA_RST_IDX, &reg);
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX0, 1);
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX1, 1);
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX2, 1);
@@ -496,29 +501,29 @@ static int rt2800pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX4, 1);
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX5, 1);
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DRX_IDX0, 1);
-	rt2x00pci_register_write(rt2x00dev, WPDMA_RST_IDX, reg);
+	rt2x00mmio_register_write(rt2x00dev, WPDMA_RST_IDX, reg);
 
-	rt2x00pci_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e1f);
-	rt2x00pci_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
+	rt2x00mmio_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e1f);
+	rt2x00mmio_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
 
 	if (rt2x00_is_pcie(rt2x00dev) &&
 	    (rt2x00_rt(rt2x00dev, RT3572) ||
 	     rt2x00_rt(rt2x00dev, RT5390) ||
 	     rt2x00_rt(rt2x00dev, RT5392))) {
-		rt2x00pci_register_read(rt2x00dev, AUX_CTRL, &reg);
+		rt2x00mmio_register_read(rt2x00dev, AUX_CTRL, &reg);
 		rt2x00_set_field32(&reg, AUX_CTRL_FORCE_PCIE_CLK, 1);
 		rt2x00_set_field32(&reg, AUX_CTRL_WAKE_PCIE_EN, 1);
-		rt2x00pci_register_write(rt2x00dev, AUX_CTRL, reg);
+		rt2x00mmio_register_write(rt2x00dev, AUX_CTRL, reg);
 	}
 
-	rt2x00pci_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
+	rt2x00mmio_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
 
 	reg = 0;
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 1);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_BBP, 1);
-	rt2x00pci_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+	rt2x00mmio_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 
-	rt2x00pci_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
+	rt2x00mmio_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
 
 	return 0;
 }
@@ -538,8 +543,8 @@ static int rt2800pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 		return retval;
 
 	/* After resume MCU_BOOT_SIGNAL will trash these. */
-	rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
-	rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
+	rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
+	rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
 
 	rt2800_mcu_request(rt2x00dev, MCU_SLEEP, TOKEN_RADIO_OFF, 0xff, 0x02);
 	rt2800pci_mcu_status(rt2x00dev, TOKEN_RADIO_OFF);
@@ -554,8 +559,8 @@ static void rt2800pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	if (rt2x00_is_soc(rt2x00dev)) {
 		rt2800_disable_radio(rt2x00dev);
-		rt2x00pci_register_write(rt2x00dev, PWR_PIN_CFG, 0);
-		rt2x00pci_register_write(rt2x00dev, TX_PIN_CFG, 0);
+		rt2x00mmio_register_write(rt2x00dev, PWR_PIN_CFG, 0);
+		rt2x00mmio_register_write(rt2x00dev, TX_PIN_CFG, 0);
 	}
 }
 
@@ -567,10 +572,10 @@ static int rt2800pci_set_state(struct rt2x00_dev *rt2x00dev,
 				   0, 0x02);
 		rt2800pci_mcu_status(rt2x00dev, TOKEN_WAKEUP);
 	} else if (state == STATE_SLEEP) {
-		rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_STATUS,
-					 0xffffffff);
-		rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CID,
-					 0xffffffff);
+		rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_STATUS,
+					  0xffffffff);
+		rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_CID,
+					  0xffffffff);
 		rt2800_mcu_request(rt2x00dev, MCU_SLEEP, TOKEN_SLEEP,
 				   0xff, 0x01);
 	}
@@ -629,7 +634,7 @@ static void rt2800pci_write_tx_desc(struct queue_entry *entry,
 				    struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	__le32 *txd = entry_priv->desc;
 	u32 word;
 
@@ -683,7 +688,7 @@ static void rt2800pci_write_tx_desc(struct queue_entry *entry,
 static void rt2800pci_fill_rxdone(struct queue_entry *entry,
 				  struct rxdone_entry_desc *rxdesc)
 {
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	__le32 *rxd = entry_priv->desc;
 	u32 word;
 
@@ -914,9 +919,9 @@ static inline void rt2800pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
 	 * access needs locking.
 	 */
 	spin_lock_irq(&rt2x00dev->irqmask_lock);
-	rt2x00pci_register_read(rt2x00dev, INT_MASK_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, INT_MASK_CSR, &reg);
 	rt2x00_set_field32(&reg, irq_field, 1);
-	rt2x00pci_register_write(rt2x00dev, INT_MASK_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, INT_MASK_CSR, reg);
 	spin_unlock_irq(&rt2x00dev->irqmask_lock);
 }
 
@@ -957,15 +962,15 @@ static void rt2800pci_tbtt_tasklet(unsigned long data)
 		 * interval every 64 beacons by 64us to mitigate this effect.
 		 */
 		if (drv_data->tbtt_tick == (BCN_TBTT_OFFSET - 2)) {
-			rt2x00pci_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+			rt2x00mmio_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
 			rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL,
 					   (rt2x00dev->beacon_int * 16) - 1);
-			rt2x00pci_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+			rt2x00mmio_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 		} else if (drv_data->tbtt_tick == (BCN_TBTT_OFFSET - 1)) {
-			rt2x00pci_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+			rt2x00mmio_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
 			rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL,
 					   (rt2x00dev->beacon_int * 16));
-			rt2x00pci_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+			rt2x00mmio_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 		}
 		drv_data->tbtt_tick++;
 		drv_data->tbtt_tick %= BCN_TBTT_OFFSET;
@@ -978,7 +983,7 @@ static void rt2800pci_tbtt_tasklet(unsigned long data)
 static void rt2800pci_rxdone_tasklet(unsigned long data)
 {
 	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-	if (rt2x00pci_rxdone(rt2x00dev))
+	if (rt2x00mmio_rxdone(rt2x00dev))
 		tasklet_schedule(&rt2x00dev->rxdone_tasklet);
 	else if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		rt2800pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_RX_DONE);
@@ -1016,7 +1021,7 @@ static void rt2800pci_txstatus_interrupt(struct rt2x00_dev *rt2x00dev)
 	 * need to lock the kfifo.
 	 */
 	for (i = 0; i < rt2x00dev->ops->tx->entry_num; i++) {
-		rt2x00pci_register_read(rt2x00dev, TX_STA_FIFO, &status);
+		rt2x00mmio_register_read(rt2x00dev, TX_STA_FIFO, &status);
 
 		if (!rt2x00_get_field32(status, TX_STA_FIFO_VALID))
 			break;
@@ -1038,8 +1043,8 @@ static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
 	u32 reg, mask;
 
 	/* Read status and ACK all interrupts */
-	rt2x00pci_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
-	rt2x00pci_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
+	rt2x00mmio_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
+	rt2x00mmio_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
 
 	if (!reg)
 		return IRQ_NONE;
@@ -1079,9 +1084,9 @@ static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
 	 * the tasklet will reenable the appropriate interrupts.
 	 */
 	spin_lock(&rt2x00dev->irqmask_lock);
-	rt2x00pci_register_read(rt2x00dev, INT_MASK_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, INT_MASK_CSR, &reg);
 	reg &= mask;
-	rt2x00pci_register_write(rt2x00dev, INT_MASK_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, INT_MASK_CSR, reg);
 	spin_unlock(&rt2x00dev->irqmask_lock);
 
 	return IRQ_HANDLED;
@@ -1132,13 +1137,13 @@ static const struct ieee80211_ops rt2800pci_mac80211_ops = {
 };
 
 static const struct rt2800_ops rt2800pci_rt2800_ops = {
-	.register_read		= rt2x00pci_register_read,
-	.register_read_lock	= rt2x00pci_register_read, /* same for PCI */
-	.register_write		= rt2x00pci_register_write,
-	.register_write_lock	= rt2x00pci_register_write, /* same for PCI */
-	.register_multiread	= rt2x00pci_register_multiread,
-	.register_multiwrite	= rt2x00pci_register_multiwrite,
-	.regbusy_read		= rt2x00pci_regbusy_read,
+	.register_read		= rt2x00mmio_register_read,
+	.register_read_lock	= rt2x00mmio_register_read, /* same for PCI */
+	.register_write		= rt2x00mmio_register_write,
+	.register_write_lock	= rt2x00mmio_register_write, /* same for PCI */
+	.register_multiread	= rt2x00mmio_register_multiread,
+	.register_multiwrite	= rt2x00mmio_register_multiwrite,
+	.regbusy_read		= rt2x00mmio_regbusy_read,
 	.read_eeprom		= rt2800pci_read_eeprom,
 	.hwcrypt_disabled	= rt2800pci_hwcrypt_disabled,
 	.drv_write_firmware	= rt2800pci_write_firmware,
@@ -1157,8 +1162,8 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.get_firmware_name	= rt2800pci_get_firmware_name,
 	.check_firmware		= rt2800_check_firmware,
 	.load_firmware		= rt2800_load_firmware,
-	.initialize		= rt2x00pci_initialize,
-	.uninitialize		= rt2x00pci_uninitialize,
+	.initialize		= rt2x00mmio_initialize,
+	.uninitialize		= rt2x00mmio_uninitialize,
 	.get_entry_state	= rt2800pci_get_entry_state,
 	.clear_entry		= rt2800pci_clear_entry,
 	.set_device_state	= rt2800pci_set_device_state,
@@ -1171,7 +1176,7 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.start_queue		= rt2800pci_start_queue,
 	.kick_queue		= rt2800pci_kick_queue,
 	.stop_queue		= rt2800pci_stop_queue,
-	.flush_queue		= rt2x00pci_flush_queue,
+	.flush_queue		= rt2x00mmio_flush_queue,
 	.write_tx_desc		= rt2800pci_write_tx_desc,
 	.write_tx_data		= rt2800_write_tx_data,
 	.write_beacon		= rt2800_write_beacon,
@@ -1192,21 +1197,21 @@ static const struct data_queue_desc rt2800pci_queue_rx = {
 	.entry_num		= 128,
 	.data_size		= AGGREGATION_SIZE,
 	.desc_size		= RXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci),
+	.priv_size		= sizeof(struct queue_entry_priv_mmio),
 };
 
 static const struct data_queue_desc rt2800pci_queue_tx = {
 	.entry_num		= 64,
 	.data_size		= AGGREGATION_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci),
+	.priv_size		= sizeof(struct queue_entry_priv_mmio),
 };
 
 static const struct data_queue_desc rt2800pci_queue_bcn = {
 	.entry_num		= 8,
 	.data_size		= 0, /* No DMA required for beacons */
 	.desc_size		= TXWI_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci),
+	.priv_size		= sizeof(struct queue_entry_priv_mmio),
 };
 
 static const struct rt2x00_ops rt2800pci_ops = {
-- 
1.7.10

