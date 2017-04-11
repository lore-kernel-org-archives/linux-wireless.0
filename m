Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50676 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752395AbdDKMjY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:39:24 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:28 +0300
Message-Id: <20170411123742.12214-12-luca@coelho.fi> (sfid-20170411_144107_830041_B1CAA202)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 11/25] iwlwifi: add support for 9000 HW B-step NICs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Once we remove support for A-step, we'll be able to
clean the code back again.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c   | 25 ++++++++++++++++---------
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  7 +++++--
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c    | 19 +++++++++++++------
 3 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index da58ece2286a..d265b279b2ca 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015-2016 Intel Deutschland GmbH
+ * Copyright(c) 2015-2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -18,7 +18,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015-2016 Intel Deutschland GmbH
+ * Copyright(c) 2015-2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -73,11 +73,14 @@
 #define IWL9000_SMEM_LEN		0x68000
 
 #define  IWL9000_FW_PRE "iwlwifi-9000-pu-a0-jf-a0-"
-#define  IWL9260_FW_PRE "iwlwifi-9260-th-a0-jf-a0-"
+#define  IWL9260A_FW_PRE "iwlwifi-9260-th-a0-jf-a0-"
+#define  IWL9260B_FW_PRE "iwlwifi-9260-th-b0-jf-b0-"
 #define IWL9000_MODULE_FIRMWARE(api) \
 	IWL9000_FW_PRE "-" __stringify(api) ".ucode"
-#define IWL9260_MODULE_FIRMWARE(api) \
-	IWL9260_FW_PRE "-" __stringify(api) ".ucode"
+#define IWL9260A_MODULE_FIRMWARE(api) \
+	IWL9260A_FW_PRE "-" __stringify(api) ".ucode"
+#define IWL9260B_MODULE_FIRMWARE(api) \
+	IWL9260B_FW_PRE "-" __stringify(api) ".ucode"
 
 #define NVM_HW_SECTION_NUM_FAMILY_9000		10
 
@@ -145,7 +148,8 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 
 const struct iwl_cfg iwl9160_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 9160",
-	.fw_name_pre = IWL9260_FW_PRE,
+	.fw_name_pre = IWL9260A_FW_PRE,
+	.fw_name_pre_next_step = IWL9260B_FW_PRE,
 	IWL_DEVICE_9000,
 	.ht_params = &iwl9000_ht_params,
 	.nvm_ver = IWL9000_NVM_VERSION,
@@ -155,7 +159,8 @@ const struct iwl_cfg iwl9160_2ac_cfg = {
 
 const struct iwl_cfg iwl9260_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 9260",
-	.fw_name_pre = IWL9260_FW_PRE,
+	.fw_name_pre = IWL9260A_FW_PRE,
+	.fw_name_pre_next_step = IWL9260B_FW_PRE,
 	IWL_DEVICE_9000,
 	.ht_params = &iwl9000_ht_params,
 	.nvm_ver = IWL9000_NVM_VERSION,
@@ -165,7 +170,8 @@ const struct iwl_cfg iwl9260_2ac_cfg = {
 
 const struct iwl_cfg iwl9270_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 9270",
-	.fw_name_pre = IWL9260_FW_PRE,
+	.fw_name_pre = IWL9260A_FW_PRE,
+	.fw_name_pre_next_step = IWL9260B_FW_PRE,
 	IWL_DEVICE_9000,
 	.ht_params = &iwl9000_ht_params,
 	.nvm_ver = IWL9000_NVM_VERSION,
@@ -196,4 +202,5 @@ const struct iwl_cfg iwl9560_2ac_cfg = {
 };
 
 MODULE_FIRMWARE(IWL9000_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL9260_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL9260A_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL9260B_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 96a2ec32f707..852963487bd9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
- * Copyright (C) 2016 Intel Deutschland GmbH
+ * Copyright (C) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
- * Copyright (C) 2016 Intel Deutschland GmbH
+ * Copyright (C) 2016 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -283,6 +283,8 @@ struct iwl_pwr_tx_backoff {
  * @fw_name_pre: Firmware filename prefix. The api version and extension
  *	(.ucode) will be added to filename before loading from disk. The
  *	filename is constructed as fw_name_pre<api>.ucode.
+ * @fw_name_pre_next_step: same as @fw_name_pre, only for next step
+ *	(if supported)
  * @ucode_api_max: Highest version of uCode API supported by driver.
  * @ucode_api_min: Lowest version of uCode API supported by driver.
  * @max_inst_size: The maximal length of the fw inst section
@@ -330,6 +332,7 @@ struct iwl_cfg {
 	/* params specific to an individual device within a device family */
 	const char *name;
 	const char *fw_name_pre;
+	const char *fw_name_pre_next_step;
 	/* params not likely to change within a device family */
 	const struct iwl_base_params *base_params;
 	/* params likely to change within a device family */
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 21c523a9cc7e..212fb8d5c064 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016        Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -34,7 +34,7 @@
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016        Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -213,6 +213,13 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 {
 	const struct iwl_cfg *cfg = drv->trans->cfg;
 	char tag[8];
+	const char *fw_pre_name;
+
+	if (drv->trans->cfg->device_family == IWL_DEVICE_FAMILY_8000 &&
+	    CSR_HW_REV_STEP(drv->trans->hw_rev) == SILICON_B_STEP)
+		fw_pre_name = cfg->fw_name_pre_next_step;
+	else
+		fw_pre_name = cfg->fw_name_pre;
 
 	if (first) {
 		drv->fw_index = cfg->ucode_api_max;
@@ -226,14 +233,14 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 		IWL_ERR(drv, "no suitable firmware found!\n");
 
 		if (cfg->ucode_api_min == cfg->ucode_api_max) {
-			IWL_ERR(drv, "%s%d is required\n", cfg->fw_name_pre,
+			IWL_ERR(drv, "%s%d is required\n", fw_pre_name,
 				cfg->ucode_api_max);
 		} else {
 			IWL_ERR(drv, "minimum version required: %s%d\n",
-				cfg->fw_name_pre,
+				fw_pre_name,
 				cfg->ucode_api_min);
 			IWL_ERR(drv, "maximum version supported: %s%d\n",
-				cfg->fw_name_pre,
+				fw_pre_name,
 				cfg->ucode_api_max);
 		}
 
@@ -243,7 +250,7 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 	}
 
 	snprintf(drv->firmware_name, sizeof(drv->firmware_name), "%s%s.ucode",
-		 cfg->fw_name_pre, tag);
+		 fw_pre_name, tag);
 
 	IWL_DEBUG_INFO(drv, "attempting to load firmware '%s'\n",
 		       drv->firmware_name);
-- 
2.11.0
