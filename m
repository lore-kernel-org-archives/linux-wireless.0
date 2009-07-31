Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:60600 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbZGaV2K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 17:28:10 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/4] iwlwifi: remove deprecated 6000 series adapters
Date: Fri, 31 Jul 2009 14:28:08 -0700
Message-Id: <1249075689-8973-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1249075689-8973-1-git-send-email-reinette.chatre@intel.com>
References: <1249075689-8973-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Remove the support for deprecated devices. These devices are
engineering samples and no longer supported by the uCode.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   16 ----------------
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    5 -----
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 -
 3 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 052a704..4450943 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -150,22 +150,6 @@ static struct iwl_ops iwl6000_ops = {
 	.utils = &iwl6000_hcmd_utils,
 };
 
-struct iwl_cfg iwl6000_2ag_cfg = {
-	.name = "6000 Series 2x2 AG",
-	.fw_name_pre = IWL6000_FW_PRE,
-	.ucode_api_max = IWL6000_UCODE_API_MAX,
-	.ucode_api_min = IWL6000_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G,
-	.ops = &iwl6000_ops,
-	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
-	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.mod_params = &iwl50_mod_params,
-	.valid_tx_ant = ANT_BC,
-	.valid_rx_ant = ANT_BC,
-	.need_pll_cfg = false,
-	.pa_type = IWL_PA_SYSTEM,
-};
 
 /*
  * "h": Hybrid configuration, use both internal and external Power Amplifier
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a54330b..467c861 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3139,17 +3139,12 @@ static struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x423C, PCI_ANY_ID, iwl5150_agn_cfg)},
 	{IWL_PCI_DEVICE(0x423D, PCI_ANY_ID, iwl5150_agn_cfg)},
 /* 6000/6050 Series */
-	{IWL_PCI_DEVICE(0x0082, 0x1102, iwl6000_2ag_cfg)},
-	{IWL_PCI_DEVICE(0x0085, 0x1112, iwl6000_2ag_cfg)},
-	{IWL_PCI_DEVICE(0x0082, 0x1122, iwl6000_2ag_cfg)},
 	{IWL_PCI_DEVICE(0x008D, PCI_ANY_ID, iwl6000h_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x008E, PCI_ANY_ID, iwl6000h_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x422B, PCI_ANY_ID, iwl6000_3agn_cfg)},
 	{IWL_PCI_DEVICE(0x422C, PCI_ANY_ID, iwl6000i_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x4238, PCI_ANY_ID, iwl6000_3agn_cfg)},
 	{IWL_PCI_DEVICE(0x4239, PCI_ANY_ID, iwl6000i_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0082, PCI_ANY_ID, iwl6000h_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0085, PCI_ANY_ID, iwl6000_3agn_cfg)},
 	{IWL_PCI_DEVICE(0x0086, PCI_ANY_ID, iwl6050_3agn_cfg)},
 	{IWL_PCI_DEVICE(0x0087, PCI_ANY_ID, iwl6050_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0088, PCI_ANY_ID, iwl6050_3agn_cfg)},
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 335a8f3..cab6255 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -56,7 +56,6 @@ extern struct iwl_cfg iwl5350_agn_cfg;
 extern struct iwl_cfg iwl5100_bg_cfg;
 extern struct iwl_cfg iwl5100_abg_cfg;
 extern struct iwl_cfg iwl5150_agn_cfg;
-extern struct iwl_cfg iwl6000_2ag_cfg;
 extern struct iwl_cfg iwl6000h_2agn_cfg;
 extern struct iwl_cfg iwl6000i_2agn_cfg;
 extern struct iwl_cfg iwl6000_3agn_cfg;
-- 
1.5.6.3

