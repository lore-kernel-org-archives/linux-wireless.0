Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40776 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752268AbcEJUaE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:30:04 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:29 +0300
Message-Id: <1462910797-20303-33-git-send-email-luca@coelho.fi> (sfid-20160510_223041_020244_06280FC3)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 33/41] iwlwifi: make configuration structs smaller
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since we have a lot of configuration structs (almost 70) saving
some memory in each one of them leads to an overall saving of
~2.6KiB of memory.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-1000.c   |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-2000.c   |   2 -
 drivers/net/wireless/intel/iwlwifi/iwl-5000.c   |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-6000.c   |   3 -
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c   |   1 -
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c   |   1 -
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c   |   1 -
 drivers/net/wireless/intel/iwlwifi/iwl-config.h | 118 ++++++++++++------------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c |   5 +-
 9 files changed, 65 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-1000.c b/drivers/net/wireless/intel/iwlwifi/iwl-1000.c
index 5c2aae6..b2573b1 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-1000.c
@@ -52,7 +52,7 @@
 static const struct iwl_base_params iwl1000_base_params = {
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
-	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
+	.pll_cfg = true,
 	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
 	.shadow_ram_support = false,
 	.led_compensation = 51,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-2000.c b/drivers/net/wireless/intel/iwlwifi/iwl-2000.c
index 2e823bd..1b32ad4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-2000.c
@@ -62,7 +62,6 @@
 static const struct iwl_base_params iwl2000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.pll_cfg_val = 0,
 	.max_ll_items = OTP_MAX_LL_ITEMS_2x00,
 	.shadow_ram_support = true,
 	.led_compensation = 51,
@@ -76,7 +75,6 @@ static const struct iwl_base_params iwl2000_base_params = {
 static const struct iwl_base_params iwl2030_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.pll_cfg_val = 0,
 	.max_ll_items = OTP_MAX_LL_ITEMS_2x00,
 	.shadow_ram_support = true,
 	.led_compensation = 57,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-5000.c b/drivers/net/wireless/intel/iwlwifi/iwl-5000.c
index 4c3e3cf..4aa8f0a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-5000.c
@@ -53,7 +53,7 @@
 static const struct iwl_base_params iwl5000_base_params = {
 	.eeprom_size = IWLAGN_EEPROM_IMG_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
+	.pll_cfg = true,
 	.led_compensation = 51,
 	.wd_timeout = IWL_WATCHDOG_DISABLED,
 	.max_event_log_size = 512,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
index 5a7b7e1..0b9f6a7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
@@ -71,7 +71,6 @@
 static const struct iwl_base_params iwl6000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.pll_cfg_val = 0,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
 	.led_compensation = 51,
@@ -84,7 +83,6 @@ static const struct iwl_base_params iwl6000_base_params = {
 static const struct iwl_base_params iwl6050_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.pll_cfg_val = 0,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x50,
 	.shadow_ram_support = true,
 	.led_compensation = 51,
@@ -97,7 +95,6 @@ static const struct iwl_base_params iwl6050_base_params = {
 static const struct iwl_base_params iwl6000_g2_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.pll_cfg_val = 0,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
 	.led_compensation = 57,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
index abd2904..f4d9215 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
@@ -122,7 +122,6 @@
 static const struct iwl_base_params iwl7000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE_FAMILY_7000,
 	.num_of_queues = 31,
-	.pll_cfg_val = 0,
 	.shadow_ram_support = true,
 	.led_compensation = 57,
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
index d6bff16..8bf11c9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
@@ -112,7 +112,6 @@
 static const struct iwl_base_params iwl8000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE_FAMILY_8000,
 	.num_of_queues = 31,
-	.pll_cfg_val = 0,
 	.shadow_ram_support = true,
 	.led_compensation = 57,
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index a0eeb53..3ac298f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -87,7 +87,6 @@
 static const struct iwl_base_params iwl9000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE_FAMILY_9000,
 	.num_of_queues = 31,
-	.pll_cfg_val = 0,
 	.shadow_ram_support = true,
 	.led_compensation = 57,
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 6eef5dc..4a0af7d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
+ * Copyright (C) 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
+ * Copyright (C) 2016 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -165,20 +167,22 @@ static inline u8 num_of_ant(u8 mask)
  * @scd_chain_ext_wa: should the chain extension feature in SCD be disabled.
  */
 struct iwl_base_params {
-	int eeprom_size;
-	int num_of_queues;	/* def: HW dependent */
-	/* for iwl_pcie_apm_init() */
-	u32 pll_cfg_val;
-
-	const u16 max_ll_items;
-	const bool shadow_ram_support;
-	u16 led_compensation;
 	unsigned int wd_timeout;
-	u32 max_event_log_size;
-	const bool shadow_reg_enable;
-	const bool pcie_l1_allowed;
-	const bool apmg_wake_up_wa;
-	const bool scd_chain_ext_wa;
+
+	u16 eeprom_size;
+	u16 max_event_log_size;
+
+	u8 pll_cfg:1, /* for iwl_pcie_apm_init() */
+	   shadow_ram_support:1,
+	   shadow_reg_enable:1,
+	   pcie_l1_allowed:1,
+	   apmg_wake_up_wa:1,
+	   scd_chain_ext_wa:1;
+
+	u8 num_of_queues;	/* def: HW dependent */
+
+	u8 max_ll_items;
+	u8 led_compensation;
 };
 
 /*
@@ -189,10 +193,10 @@ struct iwl_base_params {
  */
 struct iwl_ht_params {
 	enum ieee80211_smps_mode smps_mode;
-	const bool ht_greenfield_support; /* if used set to true */
-	const bool stbc;
-	const bool ldpc;
-	bool use_rts_for_aggregation;
+	u8 ht_greenfield_support:1,
+	   stbc:1,
+	   ldpc:1,
+	   use_rts_for_aggregation:1;
 	u8 ht40_bands;
 };
 
@@ -233,10 +237,10 @@ struct iwl_tt_params {
 	u32 tx_protection_entry;
 	u32 tx_protection_exit;
 	struct iwl_tt_tx_backoff tx_backoff[TT_TX_BACKOFF_SIZE];
-	bool support_ct_kill;
-	bool support_dynamic_smps;
-	bool support_tx_protection;
-	bool support_tx_backoff;
+	u8 support_ct_kill:1,
+	   support_dynamic_smps:1,
+	   support_tx_protection:1,
+	   support_tx_backoff:1;
 };
 
 /*
@@ -324,51 +328,51 @@ struct iwl_cfg {
 	/* params specific to an individual device within a device family */
 	const char *name;
 	const char *fw_name_pre;
-	const unsigned int ucode_api_max;
-	const unsigned int ucode_api_min;
-	const enum iwl_device_family device_family;
-	const u32 max_data_size;
-	const u32 max_inst_size;
-	u8   valid_tx_ant;
-	u8   valid_rx_ant;
-	u8   non_shared_ant;
-	bool bt_shared_single_ant;
-	u16  nvm_ver;
-	u16  nvm_calib_ver;
 	/* params not likely to change within a device family */
 	const struct iwl_base_params *base_params;
 	/* params likely to change within a device family */
 	const struct iwl_ht_params *ht_params;
 	const struct iwl_eeprom_params *eeprom_params;
-	enum iwl_led_mode led_mode;
-	const bool rx_with_siso_diversity;
-	const bool internal_wimax_coex;
-	const bool host_interrupt_operation_mode;
-	bool high_temp;
-	u8   nvm_hw_section_num;
-	bool mac_addr_from_csr;
-	bool lp_xtal_workaround;
 	const struct iwl_pwr_tx_backoff *pwr_tx_backoffs;
-	bool no_power_up_nic_in_init;
 	const char *default_nvm_file_B_step;
 	const char *default_nvm_file_C_step;
-	netdev_features_t features;
-	unsigned int max_rx_agg_size;
-	bool disable_dummy_notification;
-	unsigned int max_tx_agg_size;
-	unsigned int max_ht_ampdu_exponent;
-	unsigned int max_vht_ampdu_exponent;
-	const u32 dccm_offset;
-	const u32 dccm_len;
-	const u32 dccm2_offset;
-	const u32 dccm2_len;
-	const u32 smem_offset;
-	const u32 smem_len;
 	const struct iwl_tt_params *thermal_params;
-	bool apmg_not_supported;
-	bool mq_rx_supported;
-	bool vht_mu_mimo_supported;
-	bool rf_id;
+	enum iwl_device_family device_family;
+	enum iwl_led_mode led_mode;
+	u32 max_data_size;
+	u32 max_inst_size;
+	netdev_features_t features;
+	u32 dccm_offset;
+	u32 dccm_len;
+	u32 dccm2_offset;
+	u32 dccm2_len;
+	u32 smem_offset;
+	u32 smem_len;
+	u16 nvm_ver;
+	u16 nvm_calib_ver;
+	u16 rx_with_siso_diversity:1,
+	    bt_shared_single_ant:1,
+	    internal_wimax_coex:1,
+	    host_interrupt_operation_mode:1,
+	    high_temp:1,
+	    mac_addr_from_csr:1,
+	    lp_xtal_workaround:1,
+	    no_power_up_nic_in_init:1,
+	    disable_dummy_notification:1,
+	    apmg_not_supported:1,
+	    mq_rx_supported:1,
+	    vht_mu_mimo_supported:1,
+	    rf_id:1;
+	u8 valid_tx_ant;
+	u8 valid_rx_ant;
+	u8 non_shared_ant;
+	u8 nvm_hw_section_num;
+	u8 max_rx_agg_size;
+	u8 max_tx_agg_size;
+	u8 max_ht_ampdu_exponent;
+	u8 max_vht_ampdu_exponent;
+	u8 ucode_api_max;
+	u8 ucode_api_min;
 };
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index eb9bdf0..edf9e23 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -269,9 +269,8 @@ static int iwl_pcie_apm_init(struct iwl_trans *trans)
 	iwl_pcie_apm_config(trans);
 
 	/* Configure analog phase-lock-loop before activating to D0A */
-	if (trans->cfg->base_params->pll_cfg_val)
-		iwl_set_bit(trans, CSR_ANA_PLL_CFG,
-			    trans->cfg->base_params->pll_cfg_val);
+	if (trans->cfg->base_params->pll_cfg)
+		iwl_set_bit(trans, CSR_ANA_PLL_CFG, CSR50_ANA_PLL_CFG_VAL);
 
 	/*
 	 * Set "initialization complete" bit to move adapter from
-- 
2.8.1

