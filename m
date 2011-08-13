Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21700 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab1HMQme (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 12:42:34 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/2] Revert "iwlagn: sysfs couldn't find the priv pointer"
Date: Sat, 13 Aug 2011 09:02:43 -0700
Message-Id: <1313251364-6633-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_184244_915089_7AD41B9D)
In-Reply-To: <1313251364-6633-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313251364-6633-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This reverts commit cc1a93e68f6c0d736b771f0746e8e4186f483fdc.

This fix introduced a bug: bad pointer in unload.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-pci.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 69d4ec4..fb7e436 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -134,7 +134,6 @@ static void iwl_pci_apm_config(struct iwl_bus *bus)
 static void iwl_pci_set_drv_data(struct iwl_bus *bus, void *drv_data)
 {
 	bus->drv_data = drv_data;
-	pci_set_drvdata(IWL_BUS_GET_PCI_DEV(bus), drv_data);
 }
 
 static void iwl_pci_get_hw_id(struct iwl_bus *bus, char buf[],
@@ -455,6 +454,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		pci_write_config_word(pdev, PCI_COMMAND, pci_cmd);
 	}
 
+	pci_set_drvdata(pdev, bus);
+
 	bus->dev = &pdev->dev;
 	bus->irq = pdev->irq;
 	bus->ops = &pci_ops;
@@ -493,12 +494,11 @@ static void iwl_pci_down(struct iwl_bus *bus)
 
 static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 {
-	struct iwl_priv *priv = pci_get_drvdata(pdev);
-	void *bus_specific = priv->bus->bus_specific;
+	struct iwl_bus *bus = pci_get_drvdata(pdev);
 
-	iwl_remove(priv);
+	iwl_remove(bus->drv_data);
 
-	iwl_pci_down(bus_specific);
+	iwl_pci_down(bus);
 }
 
 #ifdef CONFIG_PM
@@ -506,20 +506,20 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 static int iwl_pci_suspend(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
-	struct iwl_priv *priv = pci_get_drvdata(pdev);
+	struct iwl_bus *bus = pci_get_drvdata(pdev);
 
 	/* Before you put code here, think about WoWLAN. You cannot check here
 	 * whether WoWLAN is enabled or not, and your code will run even if
 	 * WoWLAN is enabled - don't kill the NIC, someone may need it in Sx.
 	 */
 
-	return iwl_suspend(priv);
+	return iwl_suspend(bus->drv_data);
 }
 
 static int iwl_pci_resume(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
-	struct iwl_priv *priv = pci_get_drvdata(pdev);
+	struct iwl_bus *bus = pci_get_drvdata(pdev);
 
 	/* Before you put code here, think about WoWLAN. You cannot check here
 	 * whether WoWLAN is enabled or not, and your code will run even if
@@ -532,7 +532,7 @@ static int iwl_pci_resume(struct device *device)
 	 */
 	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
 
-	return iwl_resume(priv);
+	return iwl_resume(bus->drv_data);
 }
 
 static SIMPLE_DEV_PM_OPS(iwl_dev_pm_ops, iwl_pci_suspend, iwl_pci_resume);
-- 
1.7.1

