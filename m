Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25545 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757243AbZEVRzQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 13:55:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/10] iwlcore: support ICT interrupt
Date: Fri, 22 May 2009 11:01:50 -0700
Message-Id: <1243015315-13848-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1243015315-13848-5-git-send-email-reinette.chatre@intel.com>
References: <1243015315-13848-1-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-2-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-3-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-4-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

 Add ICT interrupt handler support, ICT should improve CPU utilization
 since it does not require target read which is very expensive. This
 interrupt handler only added to 5000 cards and newer. Device will write
 interrupts to ICT shared table to inform driver about its interrupts.

These patches will not touch 3945 and 4965 interrupt handlers and tasklet.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    7 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  190 +++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-core.c     |  266 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-core.h     |   10 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h      |    6 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    8 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 +-
 9 files changed, 483 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 8bed044..fd65e1c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2838,6 +2838,7 @@ static struct iwl_lib_ops iwl3945_lib = {
 	.send_tx_power	= iwl3945_send_tx_power,
 	.is_valid_rtc_data_addr = iwl3945_hw_valid_rtc_data_addr,
 	.post_associate = iwl3945_post_associate,
+	.isr = iwl_isr_legacy,
 	.config_ap = iwl3945_config_ap,
 };
 
@@ -2871,7 +2872,8 @@ static struct iwl_cfg iwl3945_bg_cfg = {
 	.eeprom_size = IWL3945_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_3945_EEPROM_VERSION,
 	.ops = &iwl3945_ops,
-	.mod_params = &iwl3945_mod_params
+	.mod_params = &iwl3945_mod_params,
+	.use_isr_legacy = true
 };
 
 static struct iwl_cfg iwl3945_abg_cfg = {
@@ -2883,7 +2885,8 @@ static struct iwl_cfg iwl3945_abg_cfg = {
 	.eeprom_size = IWL3945_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_3945_EEPROM_VERSION,
 	.ops = &iwl3945_ops,
-	.mod_params = &iwl3945_mod_params
+	.mod_params = &iwl3945_mod_params,
+	.use_isr_legacy = true
 };
 
 struct pci_device_id iwl3945_hw_card_ids[] = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 7df4116..a0b2941 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2286,6 +2286,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.update_chain_flags = iwl_update_chain_flags,
 	.post_associate = iwl_post_associate,
 	.config_ap = iwl_config_ap,
+	.isr = iwl_isr_legacy,
 	.temp_ops = {
 		.temperature = iwl4965_temperature_calib,
 		.set_ct_kill = iwl4965_set_ct_threshold,
@@ -2310,6 +2311,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.eeprom_calib_ver = EEPROM_4965_TX_POWER_VERSION,
 	.ops = &iwl4965_ops,
 	.mod_params = &iwl4965_mod_params,
+	.use_isr_legacy = true
 };
 
 /* Module firmware */
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 96ba1d2..ab29aab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1487,6 +1487,7 @@ struct iwl_lib_ops iwl5000_lib = {
 		.query_addr = iwl5000_eeprom_query_addr,
 	},
 	.post_associate = iwl_post_associate,
+	.isr = iwl_isr_ict,
 	.config_ap = iwl_config_ap,
 	.temp_ops = {
 		.temperature = iwl5000_temperature,
@@ -1536,6 +1537,7 @@ static struct iwl_lib_ops iwl5150_lib = {
 		.query_addr = iwl5000_eeprom_query_addr,
 	},
 	.post_associate = iwl_post_associate,
+	.isr = iwl_isr_ict,
 	.config_ap = iwl_config_ap,
 	.temp_ops = {
 		.temperature = iwl5150_temperature,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4e41038..fa24b01 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -937,7 +937,7 @@ static inline void iwl_synchronize_irq(struct iwl_priv *priv)
 	tasklet_kill(&priv->irq_tasklet);
 }
 
-static void iwl_irq_tasklet(struct iwl_priv *priv)
+static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 {
 	u32 inta, handled = 0;
 	u32 inta_fh;
@@ -1121,6 +1121,174 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
+/* tasklet for iwlagn interrupt */
+static void iwl_irq_tasklet(struct iwl_priv *priv)
+{
+	u32 inta = 0;
+	u32 handled = 0;
+	unsigned long flags;
+#ifdef CONFIG_IWLWIFI_DEBUG
+	u32 inta_mask;
+#endif
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	/* Ack/clear/reset pending uCode interrupts.
+	 * Note:  Some bits in CSR_INT are "OR" of bits in CSR_FH_INT_STATUS,
+	 */
+	iwl_write32(priv, CSR_INT, priv->inta);
+
+	inta = priv->inta;
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (priv->debug_level & IWL_DL_ISR) {
+		/* just for debug */
+		inta_mask = iwl_read32(priv, CSR_INT_MASK);
+		IWL_DEBUG_ISR(priv, "inta 0x%08x, enabled 0x%08x\n ",
+				inta, inta_mask);
+	}
+#endif
+	/* saved interrupt in inta variable now we can reset priv->inta */
+	priv->inta = 0;
+
+	/* Now service all interrupt bits discovered above. */
+	if (inta & CSR_INT_BIT_HW_ERR) {
+		IWL_ERR(priv, "Microcode HW error detected.  Restarting.\n");
+
+		/* Tell the device to stop sending interrupts */
+		iwl_disable_interrupts(priv);
+
+		priv->isr_stats.hw++;
+		iwl_irq_handle_error(priv);
+
+		handled |= CSR_INT_BIT_HW_ERR;
+
+		spin_unlock_irqrestore(&priv->lock, flags);
+
+		return;
+	}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (priv->debug_level & (IWL_DL_ISR)) {
+		/* NIC fires this, but we don't use it, redundant with WAKEUP */
+		if (inta & CSR_INT_BIT_SCD) {
+			IWL_DEBUG_ISR(priv, "Scheduler finished to transmit "
+				      "the frame/frames.\n");
+			priv->isr_stats.sch++;
+		}
+
+		/* Alive notification via Rx interrupt will do the real work */
+		if (inta & CSR_INT_BIT_ALIVE) {
+			IWL_DEBUG_ISR(priv, "Alive interrupt\n");
+			priv->isr_stats.alive++;
+		}
+	}
+#endif
+	/* Safely ignore these bits for debug checks below */
+	inta &= ~(CSR_INT_BIT_SCD | CSR_INT_BIT_ALIVE);
+
+	/* HW RF KILL switch toggled */
+	if (inta & CSR_INT_BIT_RF_KILL) {
+		int hw_rf_kill = 0;
+		if (!(iwl_read32(priv, CSR_GP_CNTRL) &
+				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
+			hw_rf_kill = 1;
+
+		IWL_DEBUG_RF_KILL(priv, "RF_KILL bit toggled to %s.\n",
+				hw_rf_kill ? "disable radio" : "enable radio");
+
+		priv->isr_stats.rfkill++;
+
+		/* driver only loads ucode once setting the interface up.
+		 * the driver allows loading the ucode even if the radio
+		 * is killed. Hence update the killswitch state here. The
+		 * rfkill handler will care about restarting if needed.
+		 */
+		if (!test_bit(STATUS_ALIVE, &priv->status)) {
+			if (hw_rf_kill)
+				set_bit(STATUS_RF_KILL_HW, &priv->status);
+			else
+				clear_bit(STATUS_RF_KILL_HW, &priv->status);
+			queue_work(priv->workqueue, &priv->rf_kill);
+		}
+
+		handled |= CSR_INT_BIT_RF_KILL;
+	}
+
+	/* Chip got too hot and stopped itself */
+	if (inta & CSR_INT_BIT_CT_KILL) {
+		IWL_ERR(priv, "Microcode CT kill error detected.\n");
+		priv->isr_stats.ctkill++;
+		handled |= CSR_INT_BIT_CT_KILL;
+	}
+
+	/* Error detected by uCode */
+	if (inta & CSR_INT_BIT_SW_ERR) {
+		IWL_ERR(priv, "Microcode SW error detected. "
+			" Restarting 0x%X.\n", inta);
+		priv->isr_stats.sw++;
+		priv->isr_stats.sw_err = inta;
+		iwl_irq_handle_error(priv);
+		handled |= CSR_INT_BIT_SW_ERR;
+	}
+
+	/* uCode wakes up after power-down sleep */
+	if (inta & CSR_INT_BIT_WAKEUP) {
+		IWL_DEBUG_ISR(priv, "Wakeup interrupt\n");
+		iwl_rx_queue_update_write_ptr(priv, &priv->rxq);
+		iwl_txq_update_write_ptr(priv, &priv->txq[0]);
+		iwl_txq_update_write_ptr(priv, &priv->txq[1]);
+		iwl_txq_update_write_ptr(priv, &priv->txq[2]);
+		iwl_txq_update_write_ptr(priv, &priv->txq[3]);
+		iwl_txq_update_write_ptr(priv, &priv->txq[4]);
+		iwl_txq_update_write_ptr(priv, &priv->txq[5]);
+
+		priv->isr_stats.wakeup++;
+
+		handled |= CSR_INT_BIT_WAKEUP;
+	}
+
+	/* All uCode command responses, including Tx command responses,
+	 * Rx "responses" (frame-received notification), and other
+	 * notifications from uCode come through here*/
+	if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX)) {
+		IWL_DEBUG_ISR(priv, "Rx interrupt\n");
+		iwl_write32(priv, CSR_FH_INT_STATUS, CSR49_FH_INT_RX_MASK);
+		iwl_rx_handle(priv);
+		priv->isr_stats.rx++;
+		handled |= (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX);
+	}
+
+	if (inta & CSR_INT_BIT_FH_TX) {
+		iwl_write32(priv, CSR_FH_INT_STATUS, CSR49_FH_INT_TX_MASK);
+		IWL_DEBUG_ISR(priv, "Tx interrupt\n");
+		priv->isr_stats.tx++;
+		handled |= CSR_INT_BIT_FH_TX;
+		/* FH finished to write, send event */
+		priv->ucode_write_complete = 1;
+		wake_up_interruptible(&priv->wait_command_queue);
+	}
+
+	if (inta & ~handled) {
+		IWL_ERR(priv, "Unhandled INTA bits 0x%08x\n", inta & ~handled);
+		priv->isr_stats.unhandled++;
+	}
+
+	if (inta & ~CSR_INI_SET_MASK) {
+		IWL_WARN(priv, "Disabled INTA bits 0x%08x were pending\n",
+			 inta & ~CSR_INI_SET_MASK);
+	}
+
+
+	/* Re-enable all interrupts */
+	/* only Re-enable if diabled by irq */
+	if (test_bit(STATUS_INT_ENABLED, &priv->status))
+		iwl_enable_interrupts(priv);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+}
+
 
 /******************************************************************************
  *
@@ -1550,6 +1718,8 @@ static void __iwl_down(struct iwl_priv *priv)
 		       test_bit(STATUS_EXIT_PENDING, &priv->status) <<
 				STATUS_EXIT_PENDING;
 
+	/* device going down, Stop using ICT table */
+	iwl_disable_ict(priv);
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl_clear_bit(priv, CSR_GP_CNTRL,
 			 CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
@@ -1633,6 +1803,8 @@ static int __iwl_up(struct iwl_priv *priv)
 
 	/* clear (again), then enable host interrupts */
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
+	/* enable dram interrupt */
+	iwl_reset_ict(priv);
 	iwl_enable_interrupts(priv);
 
 	/* really make sure rfkill handshake bits are cleared */
@@ -2533,8 +2705,12 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	priv->statistics_periodic.data = (unsigned long)priv;
 	priv->statistics_periodic.function = iwl_bg_statistics_periodic;
 
-	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
-		     iwl_irq_tasklet, (unsigned long)priv);
+	if (!priv->cfg->use_isr_legacy)
+		tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
+			iwl_irq_tasklet, (unsigned long)priv);
+	else
+		tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
+			iwl_irq_tasklet_legacy, (unsigned long)priv);
 }
 
 static void iwl_cancel_deferred_work(struct iwl_priv *priv)
@@ -2735,8 +2911,9 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_enable_msi(priv->pci_dev);
 
-	err = request_irq(priv->pci_dev->irq, iwl_isr, IRQF_SHARED,
-			  DRV_NAME, priv);
+	iwl_alloc_isr_ict(priv);
+	err = request_irq(priv->pci_dev->irq, priv->cfg->ops->lib->isr,
+			  IRQF_SHARED, DRV_NAME, priv);
 	if (err) {
 		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->pci_dev->irq);
 		goto out_disable_msi;
@@ -2793,6 +2970,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	sysfs_remove_group(&pdev->dev.kobj, &iwl_attribute_group);
  out_free_irq:
 	free_irq(priv->pci_dev->irq, priv);
+	iwl_free_isr_ict(priv);
  out_disable_msi:
 	pci_disable_msi(priv->pci_dev);
 	iwl_uninit_drv(priv);
@@ -2874,6 +3052,8 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 
 	iwl_uninit_drv(priv);
 
+	iwl_free_isr_ict(priv);
+
 	if (priv->ibss_beacon)
 		dev_kfree_skb(priv->ibss_beacon);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index a15f795..12f0183 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -39,6 +39,7 @@
 #include "iwl-rfkill.h"
 #include "iwl-power.h"
 #include "iwl-sta.h"
+#include "iwl-helpers.h"
 
 
 MODULE_DESCRIPTION("iwl core");
@@ -59,6 +60,8 @@ MODULE_LICENSE("GPL");
 				    IWL_RATE_##pp##M_INDEX,    \
 				    IWL_RATE_##np##M_INDEX }
 
+static irqreturn_t iwl_isr(int irq, void *data);
+
 /*
  * Parameter order:
  *   rate, ht rate, prev rate, next rate, prev tgg rate, next tgg rate
@@ -1501,7 +1504,266 @@ void iwl_enable_interrupts(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_enable_interrupts);
 
-irqreturn_t iwl_isr(int irq, void *data)
+
+#define ICT_COUNT (PAGE_SIZE/sizeof(u32))
+
+/* Free dram table */
+void iwl_free_isr_ict(struct iwl_priv *priv)
+{
+	if (priv->ict_tbl_vir) {
+		pci_free_consistent(priv->pci_dev, (sizeof(u32) * ICT_COUNT) +
+					PAGE_SIZE, priv->ict_tbl_vir,
+					priv->ict_tbl_dma);
+		priv->ict_tbl_vir = NULL;
+	}
+}
+EXPORT_SYMBOL(iwl_free_isr_ict);
+
+
+/* allocate dram shared table it is a PAGE_SIZE aligned
+ * also reset all data related to ICT table interrupt.
+ */
+int iwl_alloc_isr_ict(struct iwl_priv *priv)
+{
+
+	if (priv->cfg->use_isr_legacy)
+		return 0;
+	/* allocate shrared data table */
+	priv->ict_tbl_vir = pci_alloc_consistent(priv->pci_dev, (sizeof(u32) *
+						  ICT_COUNT) + PAGE_SIZE,
+						  &priv->ict_tbl_dma);
+	if (!priv->ict_tbl_vir)
+		return -ENOMEM;
+
+	/* align table to PAGE_SIZE boundry */
+	priv->aligned_ict_tbl_dma = ALIGN(priv->ict_tbl_dma, PAGE_SIZE);
+
+	IWL_DEBUG_ISR(priv, "ict dma addr %Lx dma aligned %Lx diff %d\n",
+			     (unsigned long long)priv->ict_tbl_dma,
+			     (unsigned long long)priv->aligned_ict_tbl_dma,
+			(int)(priv->aligned_ict_tbl_dma - priv->ict_tbl_dma));
+
+	priv->ict_tbl =  priv->ict_tbl_vir +
+			  (priv->aligned_ict_tbl_dma - priv->ict_tbl_dma);
+
+	IWL_DEBUG_ISR(priv, "ict vir addr %p vir aligned %p diff %d\n",
+			     priv->ict_tbl, priv->ict_tbl_vir,
+			(int)(priv->aligned_ict_tbl_dma - priv->ict_tbl_dma));
+
+	/* reset table and index to all 0 */
+	memset(priv->ict_tbl_vir,0, (sizeof(u32) * ICT_COUNT) + PAGE_SIZE);
+	priv->ict_index = 0;
+
+	return 0;
+}
+EXPORT_SYMBOL(iwl_alloc_isr_ict);
+
+/* Device is going up inform it about using ICT interrupt table,
+ * also we need to tell the driver to start using ICT interrupt.
+ */
+int iwl_reset_ict(struct iwl_priv *priv)
+{
+	u32 val;
+	unsigned long flags;
+
+	if (!priv->ict_tbl_vir)
+		return 0;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	iwl_disable_interrupts(priv);
+
+	memset(&priv->ict_tbl[0],0, sizeof(u32) * ICT_COUNT);
+
+	val = priv->aligned_ict_tbl_dma >> PAGE_SHIFT;
+
+	val |= CSR_DRAM_INT_TBL_ENABLE;
+	val |= CSR_DRAM_INIT_TBL_WRAP_CHECK;
+
+	IWL_DEBUG_ISR(priv, "CSR_DRAM_INT_TBL_REG =0x%X "
+			"aligned dma address %Lx\n",
+			val, (unsigned long long)priv->aligned_ict_tbl_dma);
+
+	iwl_write32(priv, CSR_DRAM_INT_TBL_REG, val);
+	priv->use_ict = true;
+	priv->ict_index = 0;
+	iwl_write32(priv, CSR_INT, CSR_INI_SET_MASK);
+	iwl_enable_interrupts(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(iwl_reset_ict);
+
+/* Device is going down disable ict interrupt usage */
+void iwl_disable_ict(struct iwl_priv *priv)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	priv->use_ict = false;
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+EXPORT_SYMBOL(iwl_disable_ict);
+
+/* interrupt handler using ict table, with this interrupt driver will
+ * stop using INTA register to get device's interrupt, reading this register
+ * is expensive, device will write interrupts in ICT dram table, increment
+ * index then will fire interrupt to driver, driver will OR all ICT table
+ * entries from current index up to table entry with 0 value. the result is
+ * the interrupt we need to service, driver will set the entries back to 0 and
+ * set index.
+ */
+irqreturn_t iwl_isr_ict(int irq, void *data)
+{
+	struct iwl_priv *priv = data;
+	u32 inta, inta_mask;
+	u32 val = 0;
+
+	if (!priv)
+		return IRQ_NONE;
+
+	/* dram interrupt table not set yet,
+	 * use legacy interrupt.
+	 */
+	if (!priv->use_ict)
+		return iwl_isr(irq, data);
+
+	spin_lock(&priv->lock);
+
+	/* Disable (but don't clear!) interrupts here to avoid
+	 * back-to-back ISRs and sporadic interrupts from our NIC.
+	 * If we have something to service, the tasklet will re-enable ints.
+	 * If we *don't* have something, we'll re-enable before leaving here.
+	 */
+	inta_mask = iwl_read32(priv, CSR_INT_MASK);  /* just for debug */
+	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
+
+
+	/* Ignore interrupt if there's nothing in NIC to service.
+	 * This may be due to IRQ shared with another device,
+	 * or due to sporadic interrupts thrown from our NIC. */
+	if (!priv->ict_tbl[priv->ict_index]) {
+		IWL_DEBUG_ISR(priv, "Ignore interrupt, inta == 0\n");
+		goto none;
+	}
+
+	/* read all entries that not 0 start with ict_index */
+	while (priv->ict_tbl[priv->ict_index]) {
+
+		val |= priv->ict_tbl[priv->ict_index];
+		IWL_DEBUG_ISR(priv, "ICT index %d value 0x%08X\n",
+					priv->ict_index,
+					priv->ict_tbl[priv->ict_index]);
+		priv->ict_tbl[priv->ict_index] = 0;
+		priv->ict_index = iwl_queue_inc_wrap(priv->ict_index,
+								ICT_COUNT);
+
+	}
+
+	/* We should not get this value, just ignore it. */
+	if (val == 0xffffffff)
+		val = 0;
+
+	inta = (0xff & val) | ((0xff00 & val) << 16);
+	IWL_DEBUG_ISR(priv, "ISR inta 0x%08x, enabled 0x%08x ict 0x%08x\n",
+			inta, inta_mask, val);
+
+	inta &= CSR_INI_SET_MASK;
+	priv->inta |= inta;
+
+	/* iwl_irq_tasklet() will service interrupts and re-enable them */
+	if (likely(inta))
+		tasklet_schedule(&priv->irq_tasklet);
+	else if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->inta) {
+		/* Allow interrupt if was disabled by this handler and
+		 * no tasklet was schedules, We should not enable interrupt,
+		 * tasklet will enable it.
+		 */
+		iwl_enable_interrupts(priv);
+	}
+
+	spin_unlock(&priv->lock);
+	return IRQ_HANDLED;
+
+ none:
+	/* re-enable interrupts here since we don't have anything to service.
+	 * only Re-enable if disabled by irq.
+	 */
+	if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->inta)
+		iwl_enable_interrupts(priv);
+
+	spin_unlock(&priv->lock);
+	return IRQ_NONE;
+}
+EXPORT_SYMBOL(iwl_isr_ict);
+
+
+static irqreturn_t iwl_isr(int irq, void *data)
+{
+	struct iwl_priv *priv = data;
+	u32 inta, inta_mask;
+	u32 inta_fh;
+
+	if (!priv)
+		return IRQ_NONE;
+
+	spin_lock(&priv->lock);
+
+	/* Disable (but don't clear!) interrupts here to avoid
+	 *    back-to-back ISRs and sporadic interrupts from our NIC.
+	 * If we have something to service, the tasklet will re-enable ints.
+	 * If we *don't* have something, we'll re-enable before leaving here. */
+	inta_mask = iwl_read32(priv, CSR_INT_MASK);  /* just for debug */
+	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
+
+	/* Discover which interrupts are active/pending */
+	inta = iwl_read32(priv, CSR_INT);
+
+	/* Ignore interrupt if there's nothing in NIC to service.
+	 * This may be due to IRQ shared with another device,
+	 * or due to sporadic interrupts thrown from our NIC. */
+	if (!inta) {
+		IWL_DEBUG_ISR(priv, "Ignore interrupt, inta == 0\n");
+		goto none;
+	}
+
+	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
+		/* Hardware disappeared. It might have already raised
+		 * an interrupt */
+		IWL_WARN(priv, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
+		goto unplugged;
+	}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (priv->debug_level & (IWL_DL_ISR)) {
+		inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
+		IWL_DEBUG_ISR(priv, "ISR inta 0x%08x, enabled 0x%08x, "
+			      "fh 0x%08x\n", inta, inta_mask, inta_fh);
+	}
+#endif
+
+	priv->inta |= inta;
+	/* iwl_irq_tasklet() will service interrupts and re-enable them */
+	if (likely(inta))
+		tasklet_schedule(&priv->irq_tasklet);
+	else if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->inta)
+		iwl_enable_interrupts(priv);
+
+ unplugged:
+	spin_unlock(&priv->lock);
+	return IRQ_HANDLED;
+
+ none:
+	/* re-enable interrupts here since we don't have anything to service. */
+	/* only Re-enable if diabled by irq  and no schedules tasklet. */
+	if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->inta)
+		iwl_enable_interrupts(priv);
+
+	spin_unlock(&priv->lock);
+	return IRQ_NONE;
+}
+
+irqreturn_t iwl_isr_legacy(int irq, void *data)
 {
 	struct iwl_priv *priv = data;
 	u32 inta, inta_mask;
@@ -1558,7 +1820,7 @@ irqreturn_t iwl_isr(int irq, void *data)
 	spin_unlock(&priv->lock);
 	return IRQ_NONE;
 }
-EXPORT_SYMBOL(iwl_isr);
+EXPORT_SYMBOL(iwl_isr_legacy);
 
 int iwl_send_bt_config(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index a0ed415..cbd87af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -170,6 +170,7 @@ struct iwl_lib_ops {
 	void (*update_chain_flags)(struct iwl_priv *priv);
 	void (*post_associate) (struct iwl_priv *priv);
 	void (*config_ap) (struct iwl_priv *priv);
+	irqreturn_t (*isr) (int irq, void *data);
 
 	/* eeprom operations (as defined in iwl-eeprom.h) */
 	struct iwl_eeprom_ops eeprom_ops;
@@ -239,6 +240,7 @@ struct iwl_cfg {
 	u8   valid_tx_ant;
 	u8   valid_rx_ant;
 	bool need_pll_cfg;
+	bool use_isr_legacy;
 };
 
 /***************************
@@ -466,7 +468,13 @@ int iwl_send_card_state(struct iwl_priv *priv, u32 flags,
  *****************************************************/
 void iwl_disable_interrupts(struct iwl_priv *priv);
 void iwl_enable_interrupts(struct iwl_priv *priv);
-irqreturn_t iwl_isr(int irq, void *data);
+irqreturn_t iwl_isr_legacy(int irq, void *data);
+int iwl_reset_ict(struct iwl_priv *priv);
+void iwl_disable_ict(struct iwl_priv *priv);
+int iwl_alloc_isr_ict(struct iwl_priv *priv);
+void iwl_free_isr_ict(struct iwl_priv *priv);
+irqreturn_t iwl_isr_ict(int irq, void *data);
+
 static inline u16 iwl_pcie_link_ctl(struct iwl_priv *priv)
 {
 	int pos;
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 3d50ef9..34c123e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -97,6 +97,7 @@
 #define CSR_UCODE_DRV_GP1_CLR   (CSR_BASE+0x05c)
 #define CSR_UCODE_DRV_GP2       (CSR_BASE+0x060)
 #define CSR_LED_REG             (CSR_BASE+0x094)
+#define CSR_DRAM_INT_TBL_REG	(CSR_BASE+0x0A0)
 #define CSR_GIO_CHICKEN_BITS    (CSR_BASE+0x100)
 
 /* Analog phase-lock-loop configuration  */
@@ -256,6 +257,11 @@
 
 /* HPET MEM debug */
 #define CSR_DBG_HPET_MEM_REG_VAL	(0xFFFF0000)
+
+/* DRAM INT TABLE */
+#define CSR_DRAM_INT_TBL_ENABLE		(1 << 31)
+#define CSR_DRAM_INIT_TBL_WRAP_CHECK	(1 << 27)
+
 /*=== HBUS (Host-side Bus) ===*/
 #define HBUS_BASE	(0x400)
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 1310c41..2076742 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1048,6 +1048,14 @@ struct iwl_priv {
 	/*End*/
 	struct iwl_hw_params hw_params;
 
+	/* INT ICT Table */
+	u32 *ict_tbl;
+	dma_addr_t ict_tbl_dma;
+	dma_addr_t aligned_ict_tbl_dma;
+	int ict_index;
+	void *ict_tbl_vir;
+	u32 inta;
+	bool use_ict;
 
 	/* Current association information needed to configure the
 	 * hardware */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 2e25cb2..f0256bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4292,8 +4292,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	pci_enable_msi(priv->pci_dev);
 
-	err = request_irq(priv->pci_dev->irq, iwl_isr, IRQF_SHARED,
-			  DRV_NAME, priv);
+	err = request_irq(priv->pci_dev->irq, priv->cfg->ops->lib->isr,
+			  IRQF_SHARED, DRV_NAME, priv);
 	if (err) {
 		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->pci_dev->irq);
 		goto out_disable_msi;
-- 
1.5.6.3

