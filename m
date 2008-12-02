Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:2104 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbYLBAb3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 19:31:29 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/5] iwlwifi: 5150 add support for 5150
Date: Mon,  1 Dec 2008 16:32:18 -0800
Message-Id: <1228177942-25137-2-git-send-email-reinette.chatre@intel.com> (sfid-20081202_013135_185594_2F763265)
In-Reply-To: <1228177942-25137-1-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228177942-25137-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |   12 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 +
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index c3dce81..8f92ab0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -45,8 +45,10 @@
 #include "iwl-5000-hw.h"
 
 #define IWL5000_UCODE_API  "-1"
+#define IWL5150_UCODE_API  "-1"
 
 #define IWL5000_MODULE_FIRMWARE "iwlwifi-5000" IWL5000_UCODE_API ".ucode"
+#define IWL5150_MODULE_FIRMWARE "iwlwifi-5150" IWL5150_UCODE_API ".ucode"
 
 static const u16 iwl5000_default_queue_to_tx_fifo[] = {
 	IWL_TX_FIFO_AC3,
@@ -1563,7 +1565,17 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.mod_params = &iwl50_mod_params,
 };
 
+struct iwl_cfg iwl5150_agn_cfg = {
+	.name = "5150AGN",
+	.fw_name = IWL5150_MODULE_FIRMWARE,
+	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
+	.ops = &iwl5000_ops,
+	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.mod_params = &iwl50_mod_params,
+};
+
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE);
+MODULE_FIRMWARE(IWL5150_MODULE_FIRMWARE);
 
 module_param_named(disable50, iwl50_mod_params.disable, int, 0444);
 MODULE_PARM_DESC(disable50,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8008b10..247b54d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4220,7 +4220,11 @@ static struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x423A, 0x1001, iwl5350_agn_cfg)},
 	{IWL_PCI_DEVICE(0x423A, 0x1021, iwl5350_agn_cfg)},
 	{IWL_PCI_DEVICE(0x423B, 0x1011, iwl5350_agn_cfg)},
+/* 5150 Wifi/WiMax */
+	{IWL_PCI_DEVICE(0x423C, PCI_ANY_ID, iwl5150_agn_cfg)},
+	{IWL_PCI_DEVICE(0x423D, PCI_ANY_ID, iwl5150_agn_cfg)},
 #endif /* CONFIG_IWL5000 */
+
 	{0}
 };
 MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4da988e..cb6edfd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -54,6 +54,7 @@ extern struct iwl_cfg iwl5100_agn_cfg;
 extern struct iwl_cfg iwl5350_agn_cfg;
 extern struct iwl_cfg iwl5100_bg_cfg;
 extern struct iwl_cfg iwl5100_abg_cfg;
+extern struct iwl_cfg iwl5150_agn_cfg;
 
 /* CT-KILL constants */
 #define CT_KILL_THRESHOLD	110 /* in Celsius */
-- 
1.5.4.3

