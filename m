Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32866 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab1GUP0r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:47 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/25] iwlagn: iwl_bus holds drv_data as void * instead of iwl_priv
Date: Thu, 21 Jul 2011 07:50:16 -0700
Message-Id: <1311259828-8415-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172728_023709_03B3A3AA)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The price to pay is the access to the log system. Therefore logs from bus layer
are sent by dev_printk instead of IWL_XXXX.

Rename bus->priv to bus->drv_data to make the separation even clearer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    3 --
 drivers/net/wireless/iwlwifi/iwl-agn.h  |    3 --
 drivers/net/wireless/iwlwifi/iwl-bus.h  |    7 +----
 drivers/net/wireless/iwlwifi/iwl-core.h |    3 ++
 drivers/net/wireless/iwlwifi/iwl-pci.c  |   37 +++++++++++++++++-------------
 5 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index aee62d0..8afdeca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -26,9 +26,6 @@
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 78dccde..785987d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -336,7 +336,4 @@ void iwl_testmode_cleanup(struct iwl_priv *priv)
 }
 #endif
 
-int iwl_probe(struct iwl_bus *bus, struct iwl_cfg *cfg);
-void __devexit iwl_remove(struct iwl_priv * priv);
-
 #endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-bus.h b/drivers/net/wireless/iwlwifi/iwl-bus.h
index fef62e6..f3ee1c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-bus.h
+++ b/drivers/net/wireless/iwlwifi/iwl-bus.h
@@ -67,10 +67,9 @@ struct iwl_bus;
 
 /**
  * struct iwl_bus_ops - bus specific operations
-
  * @get_pm_support: must returns true if the bus can go to sleep
  * @apm_config: will be called during the config of the APM configuration
- * @set_drv_data: set the priv pointer to the bus layer
+ * @set_drv_data: set the drv_data pointer to the bus layer
  * @get_hw_id: prints the hw_id in the provided buffer
  * @write8: write a byte to register at offset ofs
  * @write32: write a dword to register at offset ofs
@@ -88,9 +87,7 @@ struct iwl_bus_ops {
 
 struct iwl_bus {
 	/* Common data to all buses */
-
-	/*TODO: priv should be void * */
-	struct iwl_priv *priv; /* driver's context */
+	void *drv_data; /* driver's context */
 	struct device *dev;
 	struct iwl_bus_ops *ops;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index a2cb1f5..c2d58df 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -398,6 +398,9 @@ int iwl_suspend(struct iwl_priv *priv);
 int iwl_resume(struct iwl_priv *priv);
 #endif /* !CONFIG_PM */
 
+int iwl_probe(struct iwl_bus *bus, struct iwl_cfg *cfg);
+void __devexit iwl_remove(struct iwl_priv * priv);
+
 /*****************************************************
 *  Error Handling Debugging
 ******************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 6644889..0b815de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -120,20 +120,20 @@ static void iwl_pci_apm_config(struct iwl_bus *bus)
 	if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) ==
 				PCI_CFG_LINK_CTRL_VAL_L1_EN) {
 		/* L1-ASPM enabled; disable(!) L0S */
-		iwl_set_bit(bus->priv, CSR_GIO_REG,
+		iwl_set_bit(bus->drv_data, CSR_GIO_REG,
 				CSR_GIO_REG_VAL_L0S_ENABLED);
-		IWL_DEBUG_POWER(bus->priv, "L1 Enabled; Disabling L0S\n");
+		dev_printk(KERN_INFO, bus->dev, "L1 Enabled; Disabling L0S\n");
 	} else {
 		/* L1-ASPM disabled; enable(!) L0S */
-		iwl_clear_bit(bus->priv, CSR_GIO_REG,
+		iwl_clear_bit(bus->drv_data, CSR_GIO_REG,
 				CSR_GIO_REG_VAL_L0S_ENABLED);
-		IWL_DEBUG_POWER(bus->priv, "L1 Disabled; Enabling L0S\n");
+		dev_printk(KERN_INFO, bus->dev, "L1 Disabled; Enabling L0S\n");
 	}
 }
 
 static void iwl_pci_set_drv_data(struct iwl_bus *bus, void *drv_data)
 {
-	bus->priv = drv_data;
+	bus->drv_data = drv_data;
 }
 
 static void iwl_pci_get_hw_id(struct iwl_bus *bus, char buf[],
@@ -377,7 +377,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	bus = kzalloc(sizeof(*bus) + sizeof(*pci_bus), GFP_KERNEL);
 	if (!bus) {
-		pr_err("Couldn't allocate iwl_pci_bus");
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "Couldn't allocate iwl_pci_bus");
 		err = -ENOMEM;
 		goto out_no_pci;
 	}
@@ -407,29 +408,33 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 							DMA_BIT_MASK(32));
 		/* both attempts failed: */
 		if (err) {
-			pr_err("No suitable DMA available.\n");
+			dev_printk(KERN_ERR, bus->dev,
+				   "No suitable DMA available.\n");
 			goto out_pci_disable_device;
 		}
 	}
 
 	err = pci_request_regions(pdev, DRV_NAME);
 	if (err) {
-		pr_err("pci_request_regions failed");
+		dev_printk(KERN_ERR, bus->dev, "pci_request_regions failed");
 		goto out_pci_disable_device;
 	}
 
 	pci_bus->hw_base = pci_iomap(pdev, 0, 0);
 	if (!pci_bus->hw_base) {
-		pr_err("pci_iomap failed");
+		dev_printk(KERN_ERR, bus->dev, "pci_iomap failed");
 		err = -ENODEV;
 		goto out_pci_release_regions;
 	}
 
-	pr_info("pci_resource_len = 0x%08llx\n",
+	dev_printk(KERN_INFO, &pdev->dev,
+		"pci_resource_len = 0x%08llx\n",
 		(unsigned long long) pci_resource_len(pdev, 0));
-	pr_info("pci_resource_base = %p\n", pci_bus->hw_base);
+	dev_printk(KERN_INFO, &pdev->dev,
+		"pci_resource_base = %p\n", pci_bus->hw_base);
 
-	pr_info("HW Revision ID = 0x%X\n", pdev->revision);
+	dev_printk(KERN_INFO, &pdev->dev,
+		"HW Revision ID = 0x%X\n", pdev->revision);
 
 	/* We disable the RETRY_TIMEOUT register (0x41) to keep
 	 * PCI Tx retries from interfering with C3 CPU state */
@@ -437,7 +442,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = pci_enable_msi(pdev);
 	if (err) {
-		pr_err("pci_enable_msi failed");
+		dev_printk(KERN_ERR, &pdev->dev, "pci_enable_msi failed");
 		goto out_iounmap;
 	}
 
@@ -491,7 +496,7 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 {
 	struct iwl_bus *bus = pci_get_drvdata(pdev);
 
-	iwl_remove(bus->priv);
+	iwl_remove(bus->drv_data);
 
 	iwl_pci_down(bus);
 }
@@ -503,7 +508,7 @@ static int iwl_pci_suspend(struct device *device)
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct iwl_bus *bus = pci_get_drvdata(pdev);
 
-	return iwl_suspend(bus->priv);
+	return iwl_suspend(bus->drv_data);
 }
 
 static int iwl_pci_resume(struct device *device)
@@ -517,7 +522,7 @@ static int iwl_pci_resume(struct device *device)
 	 */
 	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
 
-	return iwl_resume(bus->priv);
+	return iwl_resume(bus->drv_data);
 }
 
 static SIMPLE_DEV_PM_OPS(iwl_dev_pm_ops, iwl_pci_suspend, iwl_pci_resume);
-- 
1.7.0.4

