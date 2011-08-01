Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28866 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab1HAUYx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2011 16:24:53 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH wireless-3.1] iwlagn: sysfs couldn't find the priv pointer
Date: Mon,  1 Aug 2011 12:46:57 -0700
Message-Id: <1312228017-12061-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110801_222457_795007_6A0FBBC5)
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
Tested-by: Daniel Halperin <dhalperi@cs.washington.edu>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-pci.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index fb7e436..69d4ec4 100644
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
@@ -494,11 +493,12 @@ static void iwl_pci_down(struct iwl_bus *bus)
 
 static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 {
-	struct iwl_bus *bus = pci_get_drvdata(pdev);
+	struct iwl_priv *priv = pci_get_drvdata(pdev);
+	void *bus_specific = priv->bus->bus_specific;
 
-	iwl_remove(bus->drv_data);
+	iwl_remove(priv);
 
-	iwl_pci_down(bus);
+	iwl_pci_down(bus_specific);
 }
 
 #ifdef CONFIG_PM
@@ -506,20 +506,20 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
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
@@ -532,7 +532,7 @@ static int iwl_pci_resume(struct device *device)
 	 */
 	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
 
-	return iwl_resume(bus->drv_data);
+	return iwl_resume(priv);
 }
 
 static SIMPLE_DEV_PM_OPS(iwl_dev_pm_ops, iwl_pci_suspend, iwl_pci_resume);
-- 
1.7.1

