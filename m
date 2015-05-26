Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbbEZTSQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:16 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/39] iwlwifi: 8000: fallback to default NVM file
Date: Tue, 26 May 2015 22:17:23 +0300
Message-Id: <1432667872-18092-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211824_133572_61680794)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

Set a default NVM in case the userspace specifies a file
that doesn't match the hardware version. This allows not
to change the boot scripts when someone replaces the device
with a newer hardware step.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c | 48 ++++++++++++++++-----------------
 drivers/net/wireless/iwlwifi/mvm/nvm.c  |  8 +++---
 drivers/net/wireless/iwlwifi/mvm/ops.c  | 17 +++++-------
 3 files changed, 34 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index ce6321b..75881f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2014 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2014 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -69,7 +69,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL8000_UCODE_API_MAX	13
+#define IWL8000_UCODE_API_MAX	14
 
 /* Oldest version we won't warn about */
 #define IWL8000_UCODE_API_OK	12
@@ -122,24 +122,26 @@ static const struct iwl_ht_params iwl8000_ht_params = {
 	.ht40_bands = BIT(IEEE80211_BAND_2GHZ) | BIT(IEEE80211_BAND_5GHZ),
 };
 
-#define IWL_DEVICE_8000						\
-	.ucode_api_max = IWL8000_UCODE_API_MAX,			\
-	.ucode_api_ok = IWL8000_UCODE_API_OK,			\
-	.ucode_api_min = IWL8000_UCODE_API_MIN,			\
-	.device_family = IWL_DEVICE_FAMILY_8000,		\
-	.max_inst_size = IWL60_RTC_INST_SIZE,			\
-	.max_data_size = IWL60_RTC_DATA_SIZE,			\
-	.base_params = &iwl8000_base_params,			\
-	.led_mode = IWL_LED_RF_STATE,				\
-	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_8000,	\
-	.d0i3 = true,						\
-	.non_shared_ant = ANT_A,				\
-	.dccm_offset = IWL8260_DCCM_OFFSET,			\
-	.dccm_len = IWL8260_DCCM_LEN,				\
-	.dccm2_offset = IWL8260_DCCM2_OFFSET,			\
-	.dccm2_len = IWL8260_DCCM2_LEN,				\
-	.smem_offset = IWL8260_SMEM_OFFSET,			\
-	.smem_len = IWL8260_SMEM_LEN
+#define IWL_DEVICE_8000							\
+	.ucode_api_max = IWL8000_UCODE_API_MAX,				\
+	.ucode_api_ok = IWL8000_UCODE_API_OK,				\
+	.ucode_api_min = IWL8000_UCODE_API_MIN,				\
+	.device_family = IWL_DEVICE_FAMILY_8000,			\
+	.max_inst_size = IWL60_RTC_INST_SIZE,				\
+	.max_data_size = IWL60_RTC_DATA_SIZE,				\
+	.base_params = &iwl8000_base_params,				\
+	.led_mode = IWL_LED_RF_STATE,					\
+	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_8000,		\
+	.d0i3 = true,							\
+	.non_shared_ant = ANT_A,					\
+	.dccm_offset = IWL8260_DCCM_OFFSET,				\
+	.dccm_len = IWL8260_DCCM_LEN,					\
+	.dccm2_offset = IWL8260_DCCM2_OFFSET,				\
+	.dccm2_len = IWL8260_DCCM2_LEN,					\
+	.smem_offset = IWL8260_SMEM_OFFSET,				\
+	.smem_len = IWL8260_SMEM_LEN,					\
+	.default_nvm_file_B_step = DEFAULT_NVM_FILE_FAMILY_8000B,	\
+	.default_nvm_file_C_step = DEFAULT_NVM_FILE_FAMILY_8000C
 
 const struct iwl_cfg iwl8260_2n_cfg = {
 	.name = "Intel(R) Dual Band Wireless N 8260",
@@ -177,8 +179,6 @@ const struct iwl_cfg iwl8260_2ac_sdio_cfg = {
 	.ht_params = &iwl8000_ht_params,
 	.nvm_ver = IWL8000_NVM_VERSION,
 	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
-	.default_nvm_file_B_step = DEFAULT_NVM_FILE_FAMILY_8000B,
-	.default_nvm_file_C_step = DEFAULT_NVM_FILE_FAMILY_8000C,
 	.max_rx_agg_size = MAX_RX_AGG_SIZE_8260_SDIO,
 	.disable_dummy_notification = true,
 	.max_ht_ampdu_exponent  = MAX_HT_AMPDU_EXPONENT_8260_SDIO,
@@ -192,8 +192,6 @@ const struct iwl_cfg iwl4165_2ac_sdio_cfg = {
 	.ht_params = &iwl8000_ht_params,
 	.nvm_ver = IWL8000_NVM_VERSION,
 	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
-	.default_nvm_file_B_step = DEFAULT_NVM_FILE_FAMILY_8000B,
-	.default_nvm_file_C_step = DEFAULT_NVM_FILE_FAMILY_8000C,
 	.max_rx_agg_size = MAX_RX_AGG_SIZE_8260_SDIO,
 	.bt_shared_single_ant = true,
 	.disable_dummy_notification = true,
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 87b2a30..4701424 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -583,9 +583,9 @@ int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 		kfree(nvm_buffer);
 	}
 
-	/* load external NVM if configured */
+	/* Only if PNVM selected in the mod param - load external NVM  */
 	if (mvm->nvm_file_name) {
-		/* read External NVM file - take the default */
+		/* read External NVM file from the mod param */
 		ret = iwl_mvm_read_external_nvm(mvm);
 		if (ret) {
 			/* choose the nvm_file name according to the
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 02028bc..534a9fd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -517,15 +517,12 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	min_backoff = calc_min_backoff(trans, cfg);
 	iwl_mvm_tt_initialize(mvm, min_backoff);
-	/* set the nvm_file_name according to priority */
-	if (iwlwifi_mod_params.nvm_file) {
+
+	if (iwlwifi_mod_params.nvm_file)
 		mvm->nvm_file_name = iwlwifi_mod_params.nvm_file;
-	} else if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000) {
-		if (CSR_HW_REV_STEP(trans->hw_rev) == SILICON_B_STEP)
-			mvm->nvm_file_name = mvm->cfg->default_nvm_file_B_step;
-		else
-			mvm->nvm_file_name = mvm->cfg->default_nvm_file_C_step;
-	}
+	else
+		IWL_DEBUG_EEPROM(mvm->trans->dev,
+				 "working without external nvm file\n");
 
 	if (WARN(cfg->no_power_up_nic_in_init && !mvm->nvm_file_name,
 		 "not allowing power-up and not having nvm_file\n"))
-- 
2.1.4

