Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41798 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab1FRQF1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:27 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/25] iwlagn: move PCI related operations from probe and remove to PCI layer
Date: Sat, 18 Jun 2011 08:34:15 -0700
Message-Id: <1308411271-26093-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180606_087260_9FA903AE)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since we have now a PCI layer, all the init and deinit code that is PCI
related should move to there.

Also move the IO functions: read8/read32/write32. They need hw_base which
is killed from priv.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   87 +++---------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h |    9 ++-
 drivers/net/wireless/iwlwifi/iwl-io.h  |    6 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c |  113 +++++++++++++++++++++++++++++++-
 4 files changed, 131 insertions(+), 84 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 0098245..72db1a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3486,7 +3486,7 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	int err = 0;
 	struct iwl_priv *priv;
 	struct ieee80211_hw *hw;
-	u16 pci_cmd, num_mac;
+	u16 num_mac;
 	u32 hw_rev;
 
 	/************************
@@ -3532,49 +3532,6 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	if (iwl_alloc_traffic_mem(priv))
 		IWL_ERR(priv, "Not enough memory to generate traffic log\n");
 
-	/**************************
-	 * 2. Initializing PCI bus
-	 **************************/
-	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
-				PCIE_LINK_STATE_CLKPM);
-
-	if (pci_enable_device(pdev)) {
-		err = -ENODEV;
-		goto out_ieee80211_free_hw;
-	}
-
-	pci_set_master(pdev);
-
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(36));
-	if (!err)
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(36));
-	if (err) {
-		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-		if (!err)
-			err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
-		/* both attempts failed: */
-		if (err) {
-			IWL_WARN(priv, "No suitable DMA available.\n");
-			goto out_pci_disable_device;
-		}
-	}
-
-	err = pci_request_regions(pdev, DRV_NAME);
-	if (err)
-		goto out_pci_disable_device;
-
-	/***********************
-	 * 3. Read REV register
-	 ***********************/
-	priv->hw_base = pci_iomap(pdev, 0, 0);
-	if (!priv->hw_base) {
-		err = -ENODEV;
-		goto out_pci_release_regions;
-	}
-
-	IWL_DEBUG_INFO(priv, "pci_resource_len = 0x%08llx\n",
-		(unsigned long long) pci_resource_len(pdev, 0));
-	IWL_DEBUG_INFO(priv, "pci_resource_base = %p\n", priv->hw_base);
 
 	/* these spin locks will be used in apm_ops.init and EEPROM access
 	 * we should init now
@@ -3589,17 +3546,16 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	 */
 	iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
+	/***********************
+	 * 3. Read REV register
+	 ***********************/
 	hw_rev = iwl_hw_detect(priv);
 	IWL_INFO(priv, "Detected %s, REV=0x%X\n",
 		priv->cfg->name, hw_rev);
 
-	/* We disable the RETRY_TIMEOUT register (0x41) to keep
-	 * PCI Tx retries from interfering with C3 CPU state */
-	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
-
 	if (iwl_prepare_card_hw(priv)) {
 		IWL_WARN(priv, "Failed, HW not ready\n");
-		goto out_iounmap;
+		goto out_free_traffic_mem;
 	}
 
 	/*****************
@@ -3609,7 +3565,7 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	err = iwl_eeprom_init(priv, hw_rev);
 	if (err) {
 		IWL_ERR(priv, "Unable to init EEPROM\n");
-		goto out_iounmap;
+		goto out_free_traffic_mem;
 	}
 	err = iwl_eeprom_check_version(priv);
 	if (err)
@@ -3639,6 +3595,7 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	 * 5. Setup HW constants
 	 ************************/
 	if (iwl_set_hw_params(priv)) {
+		err = -ENOENT;
 		IWL_ERR(priv, "failed to set hw parameters\n");
 		goto out_free_eeprom;
 	}
@@ -3655,15 +3612,13 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	/********************
 	 * 7. Setup services
 	 ********************/
-	pci_enable_msi(priv->pci_dev);
-
 	iwl_alloc_isr_ict(priv);
 
 	err = request_irq(priv->pci_dev->irq, iwl_isr_ict,
 			  IRQF_SHARED, DRV_NAME, priv);
 	if (err) {
 		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->pci_dev->irq);
-		goto out_disable_msi;
+		goto out_uninit_drv;
 	}
 
 	iwl_setup_deferred_work(priv);
@@ -3671,16 +3626,9 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	iwl_testmode_init(priv);
 
 	/*********************************************
-	 * 8. Enable interrupts and read RFKILL state
+	 * 8. Enable interrupts
 	 *********************************************/
 
-	/* enable rfkill interrupt: hw bug w/a */
-	pci_read_config_word(priv->pci_dev, PCI_COMMAND, &pci_cmd);
-	if (pci_cmd & PCI_COMMAND_INTX_DISABLE) {
-		pci_cmd &= ~PCI_COMMAND_INTX_DISABLE;
-		pci_write_config_word(priv->pci_dev, PCI_COMMAND, pci_cmd);
-	}
-
 	iwl_enable_rfkill_int(priv);
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
@@ -3707,20 +3655,12 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
 	free_irq(priv->pci_dev->irq, priv);
- out_disable_msi:
 	iwl_free_isr_ict(priv);
-	pci_disable_msi(priv->pci_dev);
+ out_uninit_drv:
 	iwl_uninit_drv(priv);
  out_free_eeprom:
 	iwl_eeprom_free(priv);
- out_iounmap:
-	pci_iounmap(pdev, priv->hw_base);
- out_pci_release_regions:
-	priv->bus.ops->set_drv_data(&priv->bus, NULL);
-	pci_release_regions(pdev);
- out_pci_disable_device:
-	pci_disable_device(pdev);
- out_ieee80211_free_hw:
+ out_free_traffic_mem:
 	iwl_free_traffic_mem(priv);
 	ieee80211_free_hw(priv->hw);
  out:
@@ -3729,7 +3669,6 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 
 void __devexit iwl_remove(struct iwl_priv * priv)
 {
-	struct pci_dev *pdev = priv->pci_dev;
 	unsigned long flags;
 
 	wait_for_completion(&priv->_agn.firmware_loading_complete);
@@ -3788,10 +3727,6 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	iwl_free_traffic_mem(priv);
 
 	free_irq(priv->pci_dev->irq, priv);
-	pci_disable_msi(priv->pci_dev);
-	pci_iounmap(pdev, priv->hw_base);
-	pci_release_regions(pdev);
-	pci_disable_device(pdev);
 	priv->bus.ops->set_drv_data(&priv->bus, NULL);
 
 	iwl_uninit_drv(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 49e6c68..700e9f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1195,10 +1195,16 @@ struct iwl_bus;
  * struct iwl_bus_ops - bus specific operations
  * @set_drv_data: set the priv pointer to the bus layer
  * @get_dev: returns the device struct
+ * @write8: write a byte to register at offset ofs
+ * @write32: write a dword to register at offset ofs
+ * @wread32: read a dword at register at offset ofs
  */
 struct iwl_bus_ops {
 	void (*set_drv_data)(struct iwl_bus *bus, void *priv);
 	struct device *(*get_dev)(const struct iwl_bus *bus);
+	void (*write8)(struct iwl_bus *bus, u32 ofs, u8 val);
+	void (*write32)(struct iwl_bus *bus, u32 ofs, u32 val);
+	u32 (*read32)(struct iwl_bus *bus, u32 ofs);
 };
 
 struct iwl_bus {
@@ -1282,9 +1288,6 @@ struct iwl_priv {
 	/* basic pci-network driver stuff */
 	struct pci_dev *pci_dev;
 
-	/* pci hardware address support */
-	void __iomem *hw_base;
-
 	struct iwl_bus bus;	/* bus specific data */
 
 	/* microcode/device supports multiple contexts */
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 869edc5..c56eae7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -38,18 +38,18 @@
 static inline void iwl_write8(struct iwl_priv *priv, u32 ofs, u8 val)
 {
 	trace_iwlwifi_dev_iowrite8(priv, ofs, val);
-	iowrite8(val, priv->hw_base + ofs);
+	priv->bus.ops->write8(&priv->bus, ofs, val);
 }
 
 static inline void iwl_write32(struct iwl_priv *priv, u32 ofs, u32 val)
 {
 	trace_iwlwifi_dev_iowrite32(priv, ofs, val);
-	iowrite32(val, priv->hw_base + ofs);
+	priv->bus.ops->write32(&priv->bus, ofs, val);
 }
 
 static inline u32 iwl_read32(struct iwl_priv *priv, u32 ofs)
 {
-	u32 val = ioread32(priv->hw_base + ofs);
+	u32 val = priv->bus.ops->read32(&priv->bus, ofs);
 	trace_iwlwifi_dev_ioread32(priv, ofs, val);
 	return val;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 00458fc..43de98e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -91,9 +91,28 @@ static struct device *iwl_pci_get_dev(const struct iwl_bus *bus)
 	return &(IWL_BUS_GET_PCI_DEV(bus)->dev);
 }
 
+static void iwl_pci_write8(struct iwl_bus *bus, u32 ofs, u8 val)
+{
+	iowrite8(val, IWL_BUS_GET_PCI_BUS(bus)->hw_base + ofs);
+}
+
+static void iwl_pci_write32(struct iwl_bus *bus, u32 ofs, u32 val)
+{
+	iowrite32(val, IWL_BUS_GET_PCI_BUS(bus)->hw_base + ofs);
+}
+
+static u32 iwl_pci_read32(struct iwl_bus *bus, u32 ofs)
+{
+	u32 val = ioread32(IWL_BUS_GET_PCI_BUS(bus)->hw_base + ofs);
+	return val;
+}
+
 static struct iwl_bus_ops pci_ops = {
 	.set_drv_data = iwl_pci_set_drv_data,
 	.get_dev = iwl_pci_get_dev,
+	.write8 = iwl_pci_write8,
+	.write32 = iwl_pci_write32,
+	.read32 = iwl_pci_read32,
 };
 
 #define IWL_PCI_DEVICE(dev, subdev, cfg) \
@@ -296,6 +315,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
 	struct iwl_pci_bus *bus;
+	u8 rev_id;
+	u16 pci_cmd;
 	int err;
 
 	bus = kzalloc(sizeof(*bus), GFP_KERNEL);
@@ -307,16 +328,103 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	bus->pci_dev = pdev;
 
+	/* W/A - seems to solve weird behavior. We need to remove this if we
+	 * don't want to stay in L1 all the time. This wastes a lot of power */
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
+				PCIE_LINK_STATE_CLKPM);
+
+	if (pci_enable_device(pdev)) {
+		err = -ENODEV;
+		goto out_no_pci;
+	}
+
+	pci_set_master(pdev);
+
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(36));
+	if (!err)
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(36));
+	if (err) {
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		if (!err)
+			err = pci_set_consistent_dma_mask(pdev,
+							DMA_BIT_MASK(32));
+		/* both attempts failed: */
+		if (err) {
+			pr_err("No suitable DMA available.\n");
+			goto out_pci_disable_device;
+		}
+	}
+
+	err = pci_request_regions(pdev, DRV_NAME);
+	if (err) {
+		pr_err("pci_request_regions failed");
+		goto out_pci_disable_device;
+	}
+
+	bus->hw_base = pci_iomap(pdev, 0, 0);
+	if (!bus->hw_base) {
+		pr_err("pci_iomap failed");
+		err = -ENODEV;
+		goto out_pci_release_regions;
+	}
+
+	pr_info("pci_resource_len = 0x%08llx\n",
+		(unsigned long long) pci_resource_len(pdev, 0));
+	pr_info("pci_resource_base = %p\n", bus->hw_base);
+
+	pci_read_config_byte(pdev, PCI_REVISION_ID, &rev_id);
+	pr_info("HW Revision ID = 0x%X\n", rev_id);
+
+	/* We disable the RETRY_TIMEOUT register (0x41) to keep
+	 * PCI Tx retries from interfering with C3 CPU state */
+	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
+
+	err = pci_enable_msi(pdev);
+	if (err) {
+		pr_err("pci_enable_msi failed");
+		goto out_iounmap;
+	}
+
+	/* TODO: Move this away, not needed if not MSI */
+	/* enable rfkill interrupt: hw bug w/a */
+	pci_read_config_word(pdev, PCI_COMMAND, &pci_cmd);
+	if (pci_cmd & PCI_COMMAND_INTX_DISABLE) {
+		pci_cmd &= ~PCI_COMMAND_INTX_DISABLE;
+		pci_write_config_word(pdev, PCI_COMMAND, pci_cmd);
+	}
+
 	err = iwl_probe((void *) bus, &pci_ops, cfg);
 	if (err)
-		goto out_no_pci;
+		goto out_disable_msi;
 	return 0;
 
+out_disable_msi:
+	pci_disable_msi(pdev);
+out_iounmap:
+	pci_iounmap(pdev, bus->hw_base);
+out_pci_release_regions:
+	pci_set_drvdata(pdev, NULL);
+	pci_release_regions(pdev);
+out_pci_disable_device:
+	pci_disable_device(pdev);
 out_no_pci:
 	kfree(bus);
 	return err;
 }
 
+static void iwl_pci_down(void *bus)
+{
+	struct iwl_pci_bus *pci_bus = (struct iwl_pci_bus *) bus;
+
+	pci_disable_msi(pci_bus->pci_dev);
+	pci_iounmap(pci_bus->pci_dev, pci_bus->hw_base);
+	pci_release_regions(pci_bus->pci_dev);
+	pci_disable_device(pci_bus->pci_dev);
+	pci_set_drvdata(pci_bus->pci_dev, NULL);
+
+	kfree(pci_bus);
+}
+
 static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 {
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
@@ -326,7 +434,8 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 		return;
 
 	iwl_remove(priv);
-	kfree(IWL_BUS_GET_PCI_BUS(&priv->bus));
+
+	iwl_pci_down(IWL_BUS_GET_PCI_BUS(&priv->bus));
 }
 
 #ifdef CONFIG_PM
-- 
1.7.0.4

