Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4763 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbYJNTfO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 15:35:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@intel.com>
Subject: [PATCH 1/3] iwlwifi: define firmware file name once
Date: Tue, 14 Oct 2008 12:32:41 -0700
Message-Id: <1224012769-8920-2-git-send-email-reinette.chatre@intel.com> (sfid-20081014_213518_777740_5F704115)
In-Reply-To: <1224012769-8920-1-git-send-email-reinette.chatre@intel.com>
References: <>
 <1224012769-8920-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@intel.com>

string repeated for definition of ucode firmware file and in preparation for
multiple firmware files need to consolidate location for their definition.

Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
Acked-by: Tomas Winkler <tomas.winler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 56a3f0c..35e1f6a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -46,6 +46,8 @@
 
 #define IWL5000_UCODE_API  "-1"
 
+#define IWL5000_MODULE_FIRMWARE "iwlwifi-5000" IWL5000_UCODE_API ".ucode"
+
 static const u16 iwl5000_default_queue_to_tx_fifo[] = {
 	IWL_TX_FIFO_AC3,
 	IWL_TX_FIFO_AC2,
@@ -1544,7 +1546,7 @@ static struct iwl_mod_params iwl50_mod_params = {
 
 struct iwl_cfg iwl5300_agn_cfg = {
 	.name = "5300AGN",
-	.fw_name = "iwlwifi-5000" IWL5000_UCODE_API ".ucode",
+	.fw_name = IWL5000_MODULE_FIRMWARE,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl5000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
@@ -1553,7 +1555,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 
 struct iwl_cfg iwl5100_bg_cfg = {
 	.name = "5100BG",
-	.fw_name = "iwlwifi-5000" IWL5000_UCODE_API ".ucode",
+	.fw_name = IWL5000_MODULE_FIRMWARE,
 	.sku = IWL_SKU_G,
 	.ops = &iwl5000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
@@ -1562,7 +1564,7 @@ struct iwl_cfg iwl5100_bg_cfg = {
 
 struct iwl_cfg iwl5100_abg_cfg = {
 	.name = "5100ABG",
-	.fw_name = "iwlwifi-5000" IWL5000_UCODE_API ".ucode",
+	.fw_name = IWL5000_MODULE_FIRMWARE,
 	.sku = IWL_SKU_A|IWL_SKU_G,
 	.ops = &iwl5000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
@@ -1571,7 +1573,7 @@ struct iwl_cfg iwl5100_abg_cfg = {
 
 struct iwl_cfg iwl5100_agn_cfg = {
 	.name = "5100AGN",
-	.fw_name = "iwlwifi-5000" IWL5000_UCODE_API ".ucode",
+	.fw_name = IWL5000_MODULE_FIRMWARE,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl5000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
@@ -1580,14 +1582,14 @@ struct iwl_cfg iwl5100_agn_cfg = {
 
 struct iwl_cfg iwl5350_agn_cfg = {
 	.name = "5350AGN",
-	.fw_name = "iwlwifi-5000" IWL5000_UCODE_API ".ucode",
+	.fw_name = IWL5000_MODULE_FIRMWARE,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl5000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
 	.mod_params = &iwl50_mod_params,
 };
 
-MODULE_FIRMWARE("iwlwifi-5000" IWL5000_UCODE_API ".ucode");
+MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE);
 
 module_param_named(disable50, iwl50_mod_params.disable, int, 0444);
 MODULE_PARM_DESC(disable50,
-- 
1.5.4.3

