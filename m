Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27652 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab1FRQF1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:27 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/25] iwlagn: add a iwl_pci.[ch] files that will contain all PCI specific code
Date: Sat, 18 Jun 2011 08:34:11 -0700
Message-Id: <1308411271-26093-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180608_383095_13EBE7C9)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Move some PCI functionality to the new iwl_pci.[ch] files:
* the PCI_DEVICE_TABLE
* the pci_driver struct definition
* the PCI probe / remove functions
* the PCI suspend / resume functions

All these functions are now split: the trigger comes from the PCI layer which
calls to the bus generic code located in the other files.

This is the beginning only. There are still a lot of PCI related code needs
to be gathered.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile   |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c  |  219 +-------------------
 drivers/net/wireless/iwlwifi/iwl-agn.h  |    3 +
 drivers/net/wireless/iwlwifi/iwl-core.c |   24 +--
 drivers/net/wireless/iwlwifi/iwl-core.h |   17 +--
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    2 +
 drivers/net/wireless/iwlwifi/iwl-pci.c  |  340 +++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-pci.h  |   69 +++++++
 8 files changed, 427 insertions(+), 248 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-pci.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-pci.h

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 8226604..9a56ce5 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -13,6 +13,7 @@ iwlagn-objs             += iwl-5000.o
 iwlagn-objs             += iwl-6000.o
 iwlagn-objs             += iwl-1000.o
 iwlagn-objs             += iwl-2000.o
+iwlagn-objs             += iwl-pci.o
 
 iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlagn-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 0c747c3..d5eeb3e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -32,6 +32,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+/* TODO: remove include to PCI*.h when no PCI will be needed here */
 #include <linux/pci.h>
 #include <linux/pci-aspm.h>
 #include <linux/slab.h>
@@ -49,8 +50,6 @@
 
 #include <asm/div64.h>
 
-#define DRV_NAME        "iwlagn"
-
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
 #include "iwl-core.h"
@@ -59,6 +58,7 @@
 #include "iwl-sta.h"
 #include "iwl-agn-calib.h"
 #include "iwl-agn.h"
+#include "iwl-pci.h"
 
 
 /******************************************************************************
@@ -3479,12 +3479,11 @@ static void iwl_init_context(struct iwl_priv *priv)
 	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
 }
 
-static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+int iwl_probe(struct pci_dev *pdev, struct iwl_cfg *cfg)
 {
 	int err = 0;
 	struct iwl_priv *priv;
 	struct ieee80211_hw *hw;
-	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
 	u16 pci_cmd, num_mac;
 	u32 hw_rev;
 
@@ -3717,7 +3716,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return err;
 }
 
-static void __devexit iwl_pci_remove(struct pci_dev *pdev)
+void __devexit iwl_remove(struct pci_dev *pdev)
 {
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
 	unsigned long flags;
@@ -3801,206 +3800,6 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
  * driver and module entry point
  *
  *****************************************************************************/
-
-/* Hardware specific file defines the PCI IDs table for that hardware module */
-static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
-	{IWL_PCI_DEVICE(0x4232, 0x1201, iwl5100_agn_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x4232, 0x1301, iwl5100_agn_cfg)}, /* Half Mini Card */
-	{IWL_PCI_DEVICE(0x4232, 0x1204, iwl5100_agn_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x4232, 0x1304, iwl5100_agn_cfg)}, /* Half Mini Card */
-	{IWL_PCI_DEVICE(0x4232, 0x1205, iwl5100_bgn_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x4232, 0x1305, iwl5100_bgn_cfg)}, /* Half Mini Card */
-	{IWL_PCI_DEVICE(0x4232, 0x1206, iwl5100_abg_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x4232, 0x1306, iwl5100_abg_cfg)}, /* Half Mini Card */
-	{IWL_PCI_DEVICE(0x4232, 0x1221, iwl5100_agn_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x4232, 0x1321, iwl5100_agn_cfg)}, /* Half Mini Card */
-	{IWL_PCI_DEVICE(0x4232, 0x1224, iwl5100_agn_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x4232, 0x1324, iwl5100_agn_cfg)}, /* Half Mini Card */
-	{IWL_PCI_DEVICE(0x4232, 0x1225, iwl5100_bgn_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x4232, 0x1325, iwl5100_bgn_cfg)}, /* Half Mini Card */
-	{IWL_PCI_DEVICE(0x4232, 0x1226, iwl5100_abg_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x4232, 0x1326, iwl5100_abg_cfg)}, /* Half Mini Card */
-	{IWL_PCI_DEVICE(0x4237, 0x1211, iwl5100_agn_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x4237, 0x1311, iwl5100_agn_cfg)}, /* Half Mini Card */
-	{IWL_PCI_DEVICE(0x4237, 0x1214, iwl5100_agn_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x4237, 0x1314, iwl5100_agn_cfg)}, /* Half Mini Card */
-	{IWL_PCI_DEVICE(0x4237, 0x1215, iwl5100_bgn_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x4237, 0x1315, iwl5100_bgn_cfg)}, /* Half Mini Card */
-	{IWL_PCI_DEVICE(0x4237, 0x1216, iwl5100_abg_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x4237, 0x1316, iwl5100_abg_cfg)}, /* Half Mini Card */
-
-/* 5300 Series WiFi */
-	{IWL_PCI_DEVICE(0x4235, 0x1021, iwl5300_agn_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x4235, 0x1121, iwl5300_agn_cfg)}, /* Half Mini Card */
-	{IWL_PCI_DEVICE(0x4235, 0x1024, iwl5300_agn_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x4235, 0x1124, iwl5300_agn_cfg)}, /* Half Mini Card */
-	{IWL_PCI_DEVICE(0x4235, 0x1001, iwl5300_agn_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x4235, 0x1101, iwl5300_agn_cfg)}, /* Half Mini Card */
-	{IWL_PCI_DEVICE(0x4235, 0x1004, iwl5300_agn_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x4235, 0x1104, iwl5300_agn_cfg)}, /* Half Mini Card */
-	{IWL_PCI_DEVICE(0x4236, 0x1011, iwl5300_agn_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x4236, 0x1111, iwl5300_agn_cfg)}, /* Half Mini Card */
-	{IWL_PCI_DEVICE(0x4236, 0x1014, iwl5300_agn_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x4236, 0x1114, iwl5300_agn_cfg)}, /* Half Mini Card */
-
-/* 5350 Series WiFi/WiMax */
-	{IWL_PCI_DEVICE(0x423A, 0x1001, iwl5350_agn_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x423A, 0x1021, iwl5350_agn_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x423B, 0x1011, iwl5350_agn_cfg)}, /* Mini Card */
-
-/* 5150 Series Wifi/WiMax */
-	{IWL_PCI_DEVICE(0x423C, 0x1201, iwl5150_agn_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x423C, 0x1301, iwl5150_agn_cfg)}, /* Half Mini Card */
-	{IWL_PCI_DEVICE(0x423C, 0x1206, iwl5150_abg_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x423C, 0x1306, iwl5150_abg_cfg)}, /* Half Mini Card */
-	{IWL_PCI_DEVICE(0x423C, 0x1221, iwl5150_agn_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x423C, 0x1321, iwl5150_agn_cfg)}, /* Half Mini Card */
-
-	{IWL_PCI_DEVICE(0x423D, 0x1211, iwl5150_agn_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x423D, 0x1311, iwl5150_agn_cfg)}, /* Half Mini Card */
-	{IWL_PCI_DEVICE(0x423D, 0x1216, iwl5150_abg_cfg)}, /* Mini Card */
-	{IWL_PCI_DEVICE(0x423D, 0x1316, iwl5150_abg_cfg)}, /* Half Mini Card */
-
-/* 6x00 Series */
-	{IWL_PCI_DEVICE(0x422B, 0x1101, iwl6000_3agn_cfg)},
-	{IWL_PCI_DEVICE(0x422B, 0x1121, iwl6000_3agn_cfg)},
-	{IWL_PCI_DEVICE(0x422C, 0x1301, iwl6000i_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x422C, 0x1306, iwl6000i_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x422C, 0x1307, iwl6000i_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x422C, 0x1321, iwl6000i_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x422C, 0x1326, iwl6000i_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x4238, 0x1111, iwl6000_3agn_cfg)},
-	{IWL_PCI_DEVICE(0x4239, 0x1311, iwl6000i_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x4239, 0x1316, iwl6000i_2abg_cfg)},
-
-/* 6x05 Series */
-	{IWL_PCI_DEVICE(0x0082, 0x1301, iwl6005_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0082, 0x1306, iwl6005_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x0082, 0x1307, iwl6005_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x0082, 0x1321, iwl6005_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0082, 0x1326, iwl6005_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x0085, 0x1311, iwl6005_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0085, 0x1316, iwl6005_2abg_cfg)},
-
-/* 6x30 Series */
-	{IWL_PCI_DEVICE(0x008A, 0x5305, iwl1030_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x008A, 0x5307, iwl1030_bg_cfg)},
-	{IWL_PCI_DEVICE(0x008A, 0x5325, iwl1030_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x008A, 0x5327, iwl1030_bg_cfg)},
-	{IWL_PCI_DEVICE(0x008B, 0x5315, iwl1030_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x008B, 0x5317, iwl1030_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0090, 0x5211, iwl6030_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0090, 0x5215, iwl6030_2bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0090, 0x5216, iwl6030_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x0091, 0x5201, iwl6030_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0091, 0x5205, iwl6030_2bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0091, 0x5206, iwl6030_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x0091, 0x5207, iwl6030_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x0091, 0x5221, iwl6030_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0091, 0x5225, iwl6030_2bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0091, 0x5226, iwl6030_2abg_cfg)},
-
-/* 6x50 WiFi/WiMax Series */
-	{IWL_PCI_DEVICE(0x0087, 0x1301, iwl6050_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0087, 0x1306, iwl6050_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x0087, 0x1321, iwl6050_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0087, 0x1326, iwl6050_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x0089, 0x1311, iwl6050_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0089, 0x1316, iwl6050_2abg_cfg)},
-
-/* 6150 WiFi/WiMax Series */
-	{IWL_PCI_DEVICE(0x0885, 0x1305, iwl6150_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0885, 0x1307, iwl6150_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0885, 0x1325, iwl6150_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0885, 0x1327, iwl6150_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0886, 0x1315, iwl6150_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0886, 0x1317, iwl6150_bg_cfg)},
-
-/* 1000 Series WiFi */
-	{IWL_PCI_DEVICE(0x0083, 0x1205, iwl1000_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0083, 0x1305, iwl1000_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0083, 0x1225, iwl1000_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0083, 0x1325, iwl1000_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0084, 0x1215, iwl1000_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0084, 0x1315, iwl1000_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0083, 0x1206, iwl1000_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0083, 0x1306, iwl1000_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0083, 0x1226, iwl1000_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0083, 0x1326, iwl1000_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0084, 0x1216, iwl1000_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0084, 0x1316, iwl1000_bg_cfg)},
-
-/* 100 Series WiFi */
-	{IWL_PCI_DEVICE(0x08AE, 0x1005, iwl100_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x08AE, 0x1007, iwl100_bg_cfg)},
-	{IWL_PCI_DEVICE(0x08AF, 0x1015, iwl100_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x08AF, 0x1017, iwl100_bg_cfg)},
-	{IWL_PCI_DEVICE(0x08AE, 0x1025, iwl100_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x08AE, 0x1027, iwl100_bg_cfg)},
-
-/* 130 Series WiFi */
-	{IWL_PCI_DEVICE(0x0896, 0x5005, iwl130_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0896, 0x5007, iwl130_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0897, 0x5015, iwl130_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0897, 0x5017, iwl130_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0896, 0x5025, iwl130_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0896, 0x5027, iwl130_bg_cfg)},
-
-/* 2x00 Series */
-	{IWL_PCI_DEVICE(0x0890, 0x4022, iwl2000_2bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0891, 0x4222, iwl2000_2bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0890, 0x4422, iwl2000_2bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0890, 0x4026, iwl2000_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x0891, 0x4226, iwl2000_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x0890, 0x4426, iwl2000_2bg_cfg)},
-
-/* 2x30 Series */
-	{IWL_PCI_DEVICE(0x0887, 0x4062, iwl2030_2bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0888, 0x4262, iwl2030_2bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0887, 0x4462, iwl2030_2bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0887, 0x4066, iwl2030_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x0888, 0x4266, iwl2030_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x0887, 0x4466, iwl2030_2bg_cfg)},
-
-/* 6x35 Series */
-	{IWL_PCI_DEVICE(0x088E, 0x4060, iwl6035_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x088F, 0x4260, iwl6035_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x088E, 0x4460, iwl6035_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x088E, 0x4064, iwl6035_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x088F, 0x4264, iwl6035_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x088E, 0x4464, iwl6035_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x088E, 0x4066, iwl6035_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x088F, 0x4266, iwl6035_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x088E, 0x4466, iwl6035_2bg_cfg)},
-
-/* 105 Series */
-	{IWL_PCI_DEVICE(0x0894, 0x0022, iwl105_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0895, 0x0222, iwl105_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0894, 0x0422, iwl105_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0894, 0x0026, iwl105_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0895, 0x0226, iwl105_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0894, 0x0426, iwl105_bg_cfg)},
-
-/* 135 Series */
-	{IWL_PCI_DEVICE(0x0892, 0x0062, iwl135_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0893, 0x0262, iwl135_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0892, 0x0462, iwl135_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0892, 0x0066, iwl135_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0893, 0x0266, iwl135_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0892, 0x0466, iwl135_bg_cfg)},
-
-	{0}
-};
-MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
-
-static struct pci_driver iwl_driver = {
-	.name = DRV_NAME,
-	.id_table = iwl_hw_card_ids,
-	.probe = iwl_pci_probe,
-	.remove = __devexit_p(iwl_pci_remove),
-	.driver.pm = IWL_PM_OPS,
-};
-
 static int __init iwl_init(void)
 {
 
@@ -4014,12 +3813,10 @@ static int __init iwl_init(void)
 		return ret;
 	}
 
-	ret = pci_register_driver(&iwl_driver);
-	if (ret) {
-		pr_err("Unable to initialize PCI module\n");
-		goto error_register;
-	}
+	ret = iwl_pci_register_driver();
 
+	if (ret)
+		goto error_register;
 	return ret;
 
 error_register:
@@ -4029,7 +3826,7 @@ error_register:
 
 static void __exit iwl_exit(void)
 {
-	pci_unregister_driver(&iwl_driver);
+	iwl_pci_unregister_driver();
 	iwlagn_rate_control_unregister();
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 5d8b2db..9dab387 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -379,4 +379,7 @@ void iwl_testmode_cleanup(struct iwl_priv *priv)
 }
 #endif
 
+int iwl_probe(struct pci_dev *pdev, struct iwl_cfg *cfg);
+void iwl_remove(struct pci_dev *pdev);
+
 #endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 445ddac..4268a3f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1948,11 +1948,8 @@ __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
 
 #ifdef CONFIG_PM
 
-int iwl_pci_suspend(struct device *device)
+int iwl_suspend(struct iwl_priv *priv)
 {
-	struct pci_dev *pdev = to_pci_dev(device);
-	struct iwl_priv *priv = pci_get_drvdata(pdev);
-
 	/*
 	 * This function is called when system goes into suspend state
 	 * mac80211 will call iwl_mac_stop() from the mac80211 suspend function
@@ -1965,18 +1962,10 @@ int iwl_pci_suspend(struct device *device)
 	return 0;
 }
 
-int iwl_pci_resume(struct device *device)
+int iwl_resume(struct iwl_priv *priv)
 {
-	struct pci_dev *pdev = to_pci_dev(device);
-	struct iwl_priv *priv = pci_get_drvdata(pdev);
 	bool hw_rfkill = false;
 
-	/*
-	 * We disable the RETRY_TIMEOUT register (0x41) to keep
-	 * PCI Tx retries from interfering with C3 CPU state.
-	 */
-	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
-
 	iwl_enable_interrupts(priv);
 
 	if (!(iwl_read32(priv, CSR_GP_CNTRL) &
@@ -1993,13 +1982,4 @@ int iwl_pci_resume(struct device *device)
 	return 0;
 }
 
-const struct dev_pm_ops iwl_pm_ops = {
-	.suspend = iwl_pci_suspend,
-	.resume = iwl_pci_resume,
-	.freeze = iwl_pci_suspend,
-	.thaw = iwl_pci_resume,
-	.poweroff = iwl_pci_suspend,
-	.restore = iwl_pci_resume,
-};
-
 #endif /* CONFIG_PM */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 84f28e1..84032bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -76,11 +76,6 @@ struct iwl_cmd;
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2011 Intel Corporation"
 #define DRV_AUTHOR     "<ilw@linux.intel.com>"
 
-#define IWL_PCI_DEVICE(dev, subdev, cfg) \
-	.vendor = PCI_VENDOR_ID_INTEL,  .device = (dev), \
-	.subvendor = PCI_ANY_ID, .subdevice = (subdev), \
-	.driver_data = (kernel_ulong_t)&(cfg)
-
 #define TIME_UNIT		1024
 
 #define IWL_CMD(x) case x: return #x
@@ -495,16 +490,8 @@ __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
 			   u32 addon, u32 beacon_interval);
 
 #ifdef CONFIG_PM
-int iwl_pci_suspend(struct device *device);
-int iwl_pci_resume(struct device *device);
-extern const struct dev_pm_ops iwl_pm_ops;
-
-#define IWL_PM_OPS	(&iwl_pm_ops)
-
-#else /* !CONFIG_PM */
-
-#define IWL_PM_OPS	NULL
-
+int iwl_suspend(struct iwl_priv *priv);
+int iwl_resume(struct iwl_priv *priv);
 #endif /* !CONFIG_PM */
 
 /*****************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ffed302..59316fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -48,6 +48,8 @@
 #include "iwl-agn-rs.h"
 #include "iwl-agn-tt.h"
 
+#define DRV_NAME        "iwlagn"
+
 struct iwl_tx_queue;
 
 /* CT-KILL constants */
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
new file mode 100644
index 0000000..d930be4
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -0,0 +1,340 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+#include <linux/pci.h>
+#include <linux/pci-aspm.h>
+
+#include "iwl-pci.h"
+#include "iwl-agn.h"
+#include "iwl-core.h"
+
+#define IWL_PCI_DEVICE(dev, subdev, cfg) \
+	.vendor = PCI_VENDOR_ID_INTEL,  .device = (dev), \
+	.subvendor = PCI_ANY_ID, .subdevice = (subdev), \
+	.driver_data = (kernel_ulong_t)&(cfg)
+
+/* Hardware specific file defines the PCI IDs table for that hardware module */
+static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
+	{IWL_PCI_DEVICE(0x4232, 0x1201, iwl5100_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1301, iwl5100_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1204, iwl5100_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1304, iwl5100_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1205, iwl5100_bgn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1305, iwl5100_bgn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1206, iwl5100_abg_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1306, iwl5100_abg_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1221, iwl5100_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1321, iwl5100_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1224, iwl5100_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1324, iwl5100_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1225, iwl5100_bgn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1325, iwl5100_bgn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1226, iwl5100_abg_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1326, iwl5100_abg_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4237, 0x1211, iwl5100_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4237, 0x1311, iwl5100_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4237, 0x1214, iwl5100_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4237, 0x1314, iwl5100_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4237, 0x1215, iwl5100_bgn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4237, 0x1315, iwl5100_bgn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4237, 0x1216, iwl5100_abg_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4237, 0x1316, iwl5100_abg_cfg)}, /* Half Mini Card */
+
+/* 5300 Series WiFi */
+	{IWL_PCI_DEVICE(0x4235, 0x1021, iwl5300_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4235, 0x1121, iwl5300_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4235, 0x1024, iwl5300_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4235, 0x1124, iwl5300_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4235, 0x1001, iwl5300_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4235, 0x1101, iwl5300_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4235, 0x1004, iwl5300_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4235, 0x1104, iwl5300_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4236, 0x1011, iwl5300_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4236, 0x1111, iwl5300_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4236, 0x1014, iwl5300_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4236, 0x1114, iwl5300_agn_cfg)}, /* Half Mini Card */
+
+/* 5350 Series WiFi/WiMax */
+	{IWL_PCI_DEVICE(0x423A, 0x1001, iwl5350_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x423A, 0x1021, iwl5350_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x423B, 0x1011, iwl5350_agn_cfg)}, /* Mini Card */
+
+/* 5150 Series Wifi/WiMax */
+	{IWL_PCI_DEVICE(0x423C, 0x1201, iwl5150_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x423C, 0x1301, iwl5150_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x423C, 0x1206, iwl5150_abg_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x423C, 0x1306, iwl5150_abg_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x423C, 0x1221, iwl5150_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x423C, 0x1321, iwl5150_agn_cfg)}, /* Half Mini Card */
+
+	{IWL_PCI_DEVICE(0x423D, 0x1211, iwl5150_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x423D, 0x1311, iwl5150_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x423D, 0x1216, iwl5150_abg_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x423D, 0x1316, iwl5150_abg_cfg)}, /* Half Mini Card */
+
+/* 6x00 Series */
+	{IWL_PCI_DEVICE(0x422B, 0x1101, iwl6000_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x422B, 0x1121, iwl6000_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x422C, 0x1301, iwl6000i_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x422C, 0x1306, iwl6000i_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x422C, 0x1307, iwl6000i_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x422C, 0x1321, iwl6000i_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x422C, 0x1326, iwl6000i_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x4238, 0x1111, iwl6000_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x4239, 0x1311, iwl6000i_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x4239, 0x1316, iwl6000i_2abg_cfg)},
+
+/* 6x05 Series */
+	{IWL_PCI_DEVICE(0x0082, 0x1301, iwl6005_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1306, iwl6005_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1307, iwl6005_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1321, iwl6005_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1326, iwl6005_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0085, 0x1311, iwl6005_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0085, 0x1316, iwl6005_2abg_cfg)},
+
+/* 6x30 Series */
+	{IWL_PCI_DEVICE(0x008A, 0x5305, iwl1030_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x008A, 0x5307, iwl1030_bg_cfg)},
+	{IWL_PCI_DEVICE(0x008A, 0x5325, iwl1030_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x008A, 0x5327, iwl1030_bg_cfg)},
+	{IWL_PCI_DEVICE(0x008B, 0x5315, iwl1030_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x008B, 0x5317, iwl1030_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0090, 0x5211, iwl6030_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0090, 0x5215, iwl6030_2bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0090, 0x5216, iwl6030_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0091, 0x5201, iwl6030_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0091, 0x5205, iwl6030_2bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0091, 0x5206, iwl6030_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0091, 0x5207, iwl6030_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x0091, 0x5221, iwl6030_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0091, 0x5225, iwl6030_2bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0091, 0x5226, iwl6030_2abg_cfg)},
+
+/* 6x50 WiFi/WiMax Series */
+	{IWL_PCI_DEVICE(0x0087, 0x1301, iwl6050_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0087, 0x1306, iwl6050_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0087, 0x1321, iwl6050_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0087, 0x1326, iwl6050_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0089, 0x1311, iwl6050_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0089, 0x1316, iwl6050_2abg_cfg)},
+
+/* 6150 WiFi/WiMax Series */
+	{IWL_PCI_DEVICE(0x0885, 0x1305, iwl6150_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0885, 0x1307, iwl6150_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0885, 0x1325, iwl6150_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0885, 0x1327, iwl6150_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0886, 0x1315, iwl6150_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0886, 0x1317, iwl6150_bg_cfg)},
+
+/* 1000 Series WiFi */
+	{IWL_PCI_DEVICE(0x0083, 0x1205, iwl1000_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0083, 0x1305, iwl1000_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0083, 0x1225, iwl1000_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0083, 0x1325, iwl1000_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0084, 0x1215, iwl1000_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0084, 0x1315, iwl1000_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0083, 0x1206, iwl1000_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0083, 0x1306, iwl1000_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0083, 0x1226, iwl1000_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0083, 0x1326, iwl1000_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0084, 0x1216, iwl1000_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0084, 0x1316, iwl1000_bg_cfg)},
+
+/* 100 Series WiFi */
+	{IWL_PCI_DEVICE(0x08AE, 0x1005, iwl100_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x08AE, 0x1007, iwl100_bg_cfg)},
+	{IWL_PCI_DEVICE(0x08AF, 0x1015, iwl100_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x08AF, 0x1017, iwl100_bg_cfg)},
+	{IWL_PCI_DEVICE(0x08AE, 0x1025, iwl100_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x08AE, 0x1027, iwl100_bg_cfg)},
+
+/* 130 Series WiFi */
+	{IWL_PCI_DEVICE(0x0896, 0x5005, iwl130_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0896, 0x5007, iwl130_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0897, 0x5015, iwl130_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0897, 0x5017, iwl130_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0896, 0x5025, iwl130_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0896, 0x5027, iwl130_bg_cfg)},
+
+/* 2x00 Series */
+	{IWL_PCI_DEVICE(0x0890, 0x4022, iwl2000_2bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0891, 0x4222, iwl2000_2bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0890, 0x4422, iwl2000_2bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0890, 0x4026, iwl2000_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x0891, 0x4226, iwl2000_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x0890, 0x4426, iwl2000_2bg_cfg)},
+
+/* 2x30 Series */
+	{IWL_PCI_DEVICE(0x0887, 0x4062, iwl2030_2bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0888, 0x4262, iwl2030_2bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0887, 0x4462, iwl2030_2bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0887, 0x4066, iwl2030_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x0888, 0x4266, iwl2030_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x0887, 0x4466, iwl2030_2bg_cfg)},
+
+/* 6x35 Series */
+	{IWL_PCI_DEVICE(0x088E, 0x4060, iwl6035_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x088F, 0x4260, iwl6035_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x088E, 0x4460, iwl6035_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x088E, 0x4064, iwl6035_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x088F, 0x4264, iwl6035_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x088E, 0x4464, iwl6035_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x088E, 0x4066, iwl6035_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x088F, 0x4266, iwl6035_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x088E, 0x4466, iwl6035_2bg_cfg)},
+
+/* 105 Series */
+	{IWL_PCI_DEVICE(0x0894, 0x0022, iwl105_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0895, 0x0222, iwl105_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0894, 0x0422, iwl105_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0894, 0x0026, iwl105_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0895, 0x0226, iwl105_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0894, 0x0426, iwl105_bg_cfg)},
+
+/* 135 Series */
+	{IWL_PCI_DEVICE(0x0892, 0x0062, iwl135_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0893, 0x0262, iwl135_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0892, 0x0462, iwl135_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0892, 0x0066, iwl135_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0893, 0x0266, iwl135_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0892, 0x0466, iwl135_bg_cfg)},
+
+	{0}
+};
+MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
+
+static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
+
+	return iwl_probe(pdev, cfg);
+}
+
+static void __devexit iwl_pci_remove(struct pci_dev *pdev)
+{
+	iwl_remove(pdev);
+}
+
+#ifdef CONFIG_PM
+
+static int iwl_pci_suspend(struct device *device)
+{
+	struct pci_dev *pdev = to_pci_dev(device);
+	struct iwl_priv *priv = pci_get_drvdata(pdev);
+
+	return iwl_suspend(priv);
+}
+
+static int iwl_pci_resume(struct device *device)
+{
+	struct pci_dev *pdev = to_pci_dev(device);
+	struct iwl_priv *priv = pci_get_drvdata(pdev);
+
+	/*
+	 * We disable the RETRY_TIMEOUT register (0x41) to keep
+	 * PCI Tx retries from interfering with C3 CPU state.
+	 */
+	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
+
+	return iwl_resume(priv);
+}
+
+static const struct dev_pm_ops iwl_dev_pm_ops = {
+	.suspend = iwl_pci_suspend,
+	.resume = iwl_pci_resume,
+	.freeze = iwl_pci_suspend,
+	.thaw = iwl_pci_resume,
+	.poweroff = iwl_pci_suspend,
+	.restore = iwl_pci_resume,
+};
+
+#define IWL_PM_OPS	(&iwl_dev_pm_ops)
+
+#else
+
+#define IWL_PM_OPS	NULL
+
+#endif
+
+static struct pci_driver iwl_pci_driver = {
+	.name = DRV_NAME,
+	.id_table = iwl_hw_card_ids,
+	.probe = iwl_pci_probe,
+	.remove = __devexit_p(iwl_pci_remove),
+	.driver.pm = IWL_PM_OPS,
+};
+
+int __must_check iwl_pci_register_driver(void)
+{
+	int ret;
+	ret = pci_register_driver(&iwl_pci_driver);
+	if (ret)
+		pr_err("Unable to initialize PCI module\n");
+
+	return ret;
+}
+
+void iwl_pci_unregister_driver(void)
+{
+	pci_unregister_driver(&iwl_pci_driver);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.h b/drivers/net/wireless/iwlwifi/iwl-pci.h
new file mode 100644
index 0000000..9396c7c
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.h
@@ -0,0 +1,69 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+#ifndef __iwl_pci_h__
+#define __iwl_pci_h__
+
+int __must_check iwl_pci_register_driver(void);
+void iwl_pci_unregister_driver(void);
+
+#endif
-- 
1.7.0.4

