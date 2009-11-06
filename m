Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9497 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760070AbZKFWxC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:53:02 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/20] iwlwifi: drop non-production PCI-IDs
Date: Fri,  6 Nov 2009 14:52:55 -0800
Message-Id: <1257547983-12590-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
References: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Remove the support for all the PCI_IDs never make into production

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   98 +------------------------------
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    8 ---
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    4 +-
 3 files changed, 2 insertions(+), 108 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 1f769ea..f732f6d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -90,11 +90,7 @@ static void iwl6000_nic_config(struct iwl_priv *priv)
 		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
 
 	/* no locking required for register write */
-	if (priv->cfg->pa_type == IWL_PA_HYBRID) {
-		/* 2x2 hybrid phy type */
-		iwl_write32(priv, CSR_GP_DRIVER_REG,
-			     CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_HYB);
-	} else if (priv->cfg->pa_type == IWL_PA_INTERNAL) {
+	if (priv->cfg->pa_type == IWL_PA_INTERNAL) {
 		/* 2x2 IPA phy type */
 		iwl_write32(priv, CSR_GP_DRIVER_REG,
 			     CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_IPA);
@@ -279,98 +275,6 @@ static struct iwl_ops iwl6050_ops = {
 	.led = &iwlagn_led_ops,
 };
 
-
-/*
- * "h": Hybrid configuration, use both internal and external Power Amplifier
- */
-struct iwl_cfg iwl6000h_2agn_cfg = {
-	.name = "6000 Series 2x2 AGN",
-	.fw_name_pre = IWL6000_FW_PRE,
-	.ucode_api_max = IWL6000_UCODE_API_MAX,
-	.ucode_api_min = IWL6000_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl6000_ops,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
-	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.num_of_queues = IWL50_NUM_QUEUES,
-	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
-	.mod_params = &iwl50_mod_params,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
-	.pll_cfg_val = 0,
-	.set_l0s = true,
-	.use_bsm = false,
-	.pa_type = IWL_PA_HYBRID,
-	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
-	.shadow_ram_support = true,
-	.ht_greenfield_support = true,
-	.led_compensation = 51,
-	.use_rts_for_ht = true, /* use rts/cts protection */
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
-	.adv_thermal_throttle = true,
-	.support_ct_kill_exit = true,
-};
-
-struct iwl_cfg iwl6000h_2abg_cfg = {
-	.name = "6000 Series 2x2 ABG",
-	.fw_name_pre = IWL6000_FW_PRE,
-	.ucode_api_max = IWL6000_UCODE_API_MAX,
-	.ucode_api_min = IWL6000_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G,
-	.ops = &iwl6000_ops,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
-	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.num_of_queues = IWL50_NUM_QUEUES,
-	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
-	.mod_params = &iwl50_mod_params,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
-	.pll_cfg_val = 0,
-	.set_l0s = true,
-	.use_bsm = false,
-	.pa_type = IWL_PA_HYBRID,
-	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
-	.shadow_ram_support = true,
-	.ht_greenfield_support = true,
-	.led_compensation = 51,
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
-	.adv_thermal_throttle = true,
-	.support_ct_kill_exit = true,
-};
-
-struct iwl_cfg iwl6000h_2bg_cfg = {
-	.name = "6000 Series 2x2 BG",
-	.fw_name_pre = IWL6000_FW_PRE,
-	.ucode_api_max = IWL6000_UCODE_API_MAX,
-	.ucode_api_min = IWL6000_UCODE_API_MIN,
-	.sku = IWL_SKU_G,
-	.ops = &iwl6000_ops,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
-	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.num_of_queues = IWL50_NUM_QUEUES,
-	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
-	.mod_params = &iwl50_mod_params,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
-	.pll_cfg_val = 0,
-	.set_l0s = true,
-	.use_bsm = false,
-	.pa_type = IWL_PA_HYBRID,
-	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
-	.shadow_ram_support = true,
-	.ht_greenfield_support = true,
-	.led_compensation = 51,
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
-	.adv_thermal_throttle = true,
-	.support_ct_kill_exit = true,
-};
-
 /*
  * "i": Internal configuration, use internal Power Amplifier
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index fd7ba51..eff52b1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3453,14 +3453,6 @@ static struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x423D, PCI_ANY_ID, iwl5150_agn_cfg)},
 
 /* 6x00 Series */
-	{IWL_PCI_DEVICE(0x008D, 0x1301, iwl6000h_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x008D, 0x1321, iwl6000h_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x008D, 0x1326, iwl6000h_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x008D, 0x1306, iwl6000h_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x008D, 0x1307, iwl6000h_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x008E, 0x1311, iwl6000h_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x008E, 0x1316, iwl6000h_2abg_cfg)},
-
 	{IWL_PCI_DEVICE(0x422B, 0x1101, iwl6000_3agn_cfg)},
 	{IWL_PCI_DEVICE(0x422B, 0x1121, iwl6000_3agn_cfg)},
 	{IWL_PCI_DEVICE(0x422C, 0x1301, iwl6000i_2agn_cfg)},
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9a19a3d..9dea8fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -927,13 +927,11 @@ enum iwl_access_mode {
 /**
  * enum iwl_pa_type - Power Amplifier type
  * @IWL_PA_SYSTEM:  based on uCode configuration
- * @IWL_PA_HYBRID: use both Internal and external PA
  * @IWL_PA_INTERNAL: use Internal only
  */
 enum iwl_pa_type {
 	IWL_PA_SYSTEM = 0,
-	IWL_PA_HYBRID = 1,
-	IWL_PA_INTERNAL = 2,
+	IWL_PA_INTERNAL = 1,
 };
 
 /* interrupt statistics */
-- 
1.5.6.3

