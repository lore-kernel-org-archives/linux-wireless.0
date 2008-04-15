Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41005 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbYDOXCJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 19:02:09 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 05/11] iwlwifi: move HW device registration
Date: Tue, 15 Apr 2008 16:01:41 -0700
Message-Id: <1208300507-25628-6-git-send-email-reinette.chatre@intel.com> (sfid-20080416_000231_240504_8C4C5F0F)
In-Reply-To: <1208300507-25628-5-git-send-email-reinette.chatre@intel.com>
References: <1208300507-25628-1-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-2-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-3-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-4-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch moves the HW device registration from the iwl-4965.c file, which
implies a HW specific support, to a more general location.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   10 +---------
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    6 +++---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   22 +++++++++++++++-------
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 8c8d7cf..4a40109 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4930,7 +4930,7 @@ static struct iwl_ops iwl4965_ops = {
 	.utils = &iwl4965_hcmd_utils,
 };
 
-static struct iwl_cfg iwl4965_agn_cfg = {
+struct iwl_cfg iwl4965_agn_cfg = {
 	.name = "4965AGN",
 	.fw_name = "iwlwifi-4965" IWL4965_UCODE_API ".ucode",
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
@@ -4938,14 +4938,6 @@ static struct iwl_cfg iwl4965_agn_cfg = {
 	.mod_params = &iwl4965_mod_params,
 };
 
-struct pci_device_id iwl4965_hw_card_ids[] = {
-	{IWL_PCI_DEVICE(0x4229, PCI_ANY_ID, iwl4965_agn_cfg)},
-	{IWL_PCI_DEVICE(0x4230, PCI_ANY_ID, iwl4965_agn_cfg)},
-	{0}
-};
-
-MODULE_DEVICE_TABLE(pci, iwl4965_hw_card_ids);
-
 module_param_named(antenna, iwl4965_mod_params.antenna, int, 0444);
 MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
 module_param_named(disable, iwl4965_mod_params.disable, int, 0444);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index cf909e8..ddcbad5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -36,9 +36,6 @@
 #include <linux/kernel.h>
 #include <net/ieee80211_radiotap.h>
 
-/* Hardware specific file defines the PCI IDs table for that hardware module */
-extern struct pci_device_id iwl4965_hw_card_ids[];
-
 #define DRV_NAME        "iwl4965"
 #include "iwl-rfkill.h"
 #include "iwl-eeprom.h"
@@ -48,6 +45,9 @@ extern struct pci_device_id iwl4965_hw_card_ids[];
 #include "iwl-debug.h"
 #include "iwl-led.h"
 
+/* configuration for the iwl4965 */
+extern struct iwl_cfg iwl4965_agn_cfg;
+
 /* Change firmware file name, using "-" and incrementing number,
  *   *only* when uCode interface or architecture changes so that it
  *   is not compatible with earlier drivers.
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index c71910d..249af41 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -8020,9 +8020,17 @@ static int iwl4965_pci_resume(struct pci_dev *pdev)
  *
  *****************************************************************************/
 
-static struct pci_driver iwl4965_driver = {
+/* Hardware specific file defines the PCI IDs table for that hardware module */
+static struct pci_device_id iwl_hw_card_ids[] = {
+	{IWL_PCI_DEVICE(0x4229, PCI_ANY_ID, iwl4965_agn_cfg)},
+	{IWL_PCI_DEVICE(0x4230, PCI_ANY_ID, iwl4965_agn_cfg)},
+	{0}
+};
+MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
+
+static struct pci_driver iwl_driver = {
 	.name = DRV_NAME,
-	.id_table = iwl4965_hw_card_ids,
+	.id_table = iwl_hw_card_ids,
 	.probe = iwl4965_pci_probe,
 	.remove = __devexit_p(iwl4965_pci_remove),
 #ifdef CONFIG_PM
@@ -8044,13 +8052,13 @@ static int __init iwl4965_init(void)
 		return ret;
 	}
 
-	ret = pci_register_driver(&iwl4965_driver);
+	ret = pci_register_driver(&iwl_driver);
 	if (ret) {
 		IWL_ERROR("Unable to initialize PCI module\n");
 		goto error_register;
 	}
 #ifdef CONFIG_IWLWIFI_DEBUG
-	ret = driver_create_file(&iwl4965_driver.driver, &driver_attr_debug_level);
+	ret = driver_create_file(&iwl_driver.driver, &driver_attr_debug_level);
 	if (ret) {
 		IWL_ERROR("Unable to create driver sysfs file\n");
 		goto error_debug;
@@ -8061,7 +8069,7 @@ static int __init iwl4965_init(void)
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 error_debug:
-	pci_unregister_driver(&iwl4965_driver);
+	pci_unregister_driver(&iwl_driver);
 #endif
 error_register:
 	iwl4965_rate_control_unregister();
@@ -8071,9 +8079,9 @@ error_register:
 static void __exit iwl4965_exit(void)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
-	driver_remove_file(&iwl4965_driver.driver, &driver_attr_debug_level);
+	driver_remove_file(&iwl_driver.driver, &driver_attr_debug_level);
 #endif
-	pci_unregister_driver(&iwl4965_driver);
+	pci_unregister_driver(&iwl_driver);
 	iwl4965_rate_control_unregister();
 }
 
-- 
1.5.3.4

