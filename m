Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21700 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab1HMQmf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 12:42:35 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/2] iwlagn: sysfs couldn't find the priv pointer
Date: Sat, 13 Aug 2011 09:02:44 -0700
Message-Id: <1313251364-6633-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_184244_399097_001F2CC6)
In-Reply-To: <1313251364-6633-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313251364-6633-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This bug has been introduced by:
d593411084a56124aa9d80aafa15db8463b2d8f7
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Mon Jul 11 10:48:51 2011 +0300

    iwlagn: simplify the bus architecture

Revert part of the buggy patch: dev_get_drvdata will now return
iwl_priv as it did before the patch.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-pci.c |   39 ++++++++++++++------------------
 1 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index fb7e436..2fdbffa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -134,6 +134,7 @@ static void iwl_pci_apm_config(struct iwl_bus *bus)
 static void iwl_pci_set_drv_data(struct iwl_bus *bus, void *drv_data)
 {
 	bus->drv_data = drv_data;
+	pci_set_drvdata(IWL_BUS_GET_PCI_DEV(bus), drv_data);
 }
 
 static void iwl_pci_get_hw_id(struct iwl_bus *bus, char buf[],
@@ -454,8 +455,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		pci_write_config_word(pdev, PCI_COMMAND, pci_cmd);
 	}
 
-	pci_set_drvdata(pdev, bus);
-
 	bus->dev = &pdev->dev;
 	bus->irq = pdev->irq;
 	bus->ops = &pci_ops;
@@ -479,26 +478,22 @@ out_no_pci:
 	return err;
 }
 
-static void iwl_pci_down(struct iwl_bus *bus)
-{
-	struct iwl_pci_bus *pci_bus = (struct iwl_pci_bus *) bus->bus_specific;
-
-	pci_disable_msi(pci_bus->pci_dev);
-	pci_iounmap(pci_bus->pci_dev, pci_bus->hw_base);
-	pci_release_regions(pci_bus->pci_dev);
-	pci_disable_device(pci_bus->pci_dev);
-	pci_set_drvdata(pci_bus->pci_dev, NULL);
-
-	kfree(bus);
-}
-
 static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 {
-	struct iwl_bus *bus = pci_get_drvdata(pdev);
+	struct iwl_priv *priv = pci_get_drvdata(pdev);
+	struct iwl_bus *bus = priv->bus;
+	struct iwl_pci_bus *pci_bus = IWL_BUS_GET_PCI_BUS(bus);
+	struct pci_dev *pci_dev = IWL_BUS_GET_PCI_DEV(bus);
 
-	iwl_remove(bus->drv_data);
+	iwl_remove(priv);
 
-	iwl_pci_down(bus);
+	pci_disable_msi(pci_dev);
+	pci_iounmap(pci_dev, pci_bus->hw_base);
+	pci_release_regions(pci_dev);
+	pci_disable_device(pci_dev);
+	pci_set_drvdata(pci_dev, NULL);
+
+	kfree(bus);
 }
 
 #ifdef CONFIG_PM
@@ -506,20 +501,20 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 static int iwl_pci_suspend(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
-	struct iwl_bus *bus = pci_get_drvdata(pdev);
+	struct iwl_priv *priv = pci_get_drvdata(pdev);
 
 	/* Before you put code here, think about WoWLAN. You cannot check here
 	 * whether WoWLAN is enabled or not, and your code will run even if
 	 * WoWLAN is enabled - don't kill the NIC, someone may need it in Sx.
 	 */
 
-	return iwl_suspend(bus->drv_data);
+	return iwl_suspend(priv);
 }
 
 static int iwl_pci_resume(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
-	struct iwl_bus *bus = pci_get_drvdata(pdev);
+	struct iwl_priv *priv = pci_get_drvdata(pdev);
 
 	/* Before you put code here, think about WoWLAN. You cannot check here
 	 * whether WoWLAN is enabled or not, and your code will run even if
@@ -532,7 +527,7 @@ static int iwl_pci_resume(struct device *device)
 	 */
 	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
 
-	return iwl_resume(bus->drv_data);
+	return iwl_resume(priv);
 }
 
 static SIMPLE_DEV_PM_OPS(iwl_dev_pm_ops, iwl_pci_suspend, iwl_pci_resume);
-- 
1.7.1

