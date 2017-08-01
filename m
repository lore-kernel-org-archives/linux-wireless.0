Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41540 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751623AbdHAJku (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 05:40:50 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  1 Aug 2017 12:40:37 +0300
Message-Id: <20170801094039.22349-7-luca@coelho.fi> (sfid-20170801_114055_017664_39B16E52)
In-Reply-To: <20170801094039.22349-1-luca@coelho.fi>
References: <20170801094039.22349-1-luca@coelho.fi>
Subject: [PATCH 6/8] iwlwifi: fix fw_pre_next_step to apply also for C step
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

C step NICs should use the latest FW (currently B step).
Correct the condition to make C step NICs advanced its default FW name
to the latest one.
Also rename _next_ to b_or_c to avoid confusion.

Fixes: 5da083d1922c ("iwlwifi: add support for 9000 HW B-step NICs")
Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c   | 14 +++++++-------
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  8 ++++----
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c    |  5 +++--
 3 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
index b4ecd1fe1374..97208ce19f92 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
@@ -154,7 +154,7 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 const struct iwl_cfg iwl9160_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 9160",
 	.fw_name_pre = IWL9260A_FW_PRE,
-	.fw_name_pre_next_step = IWL9260B_FW_PRE,
+	.fw_name_pre_b_or_c_step = IWL9260B_FW_PRE,
 	IWL_DEVICE_9000,
 	.ht_params = &iwl9000_ht_params,
 	.nvm_ver = IWL9000_NVM_VERSION,
@@ -165,7 +165,7 @@ const struct iwl_cfg iwl9160_2ac_cfg = {
 const struct iwl_cfg iwl9260_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 9260",
 	.fw_name_pre = IWL9260A_FW_PRE,
-	.fw_name_pre_next_step = IWL9260B_FW_PRE,
+	.fw_name_pre_b_or_c_step = IWL9260B_FW_PRE,
 	IWL_DEVICE_9000,
 	.ht_params = &iwl9000_ht_params,
 	.nvm_ver = IWL9000_NVM_VERSION,
@@ -176,7 +176,7 @@ const struct iwl_cfg iwl9260_2ac_cfg = {
 const struct iwl_cfg iwl9270_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 9270",
 	.fw_name_pre = IWL9260A_FW_PRE,
-	.fw_name_pre_next_step = IWL9260B_FW_PRE,
+	.fw_name_pre_b_or_c_step = IWL9260B_FW_PRE,
 	IWL_DEVICE_9000,
 	.ht_params = &iwl9000_ht_params,
 	.nvm_ver = IWL9000_NVM_VERSION,
@@ -186,8 +186,8 @@ const struct iwl_cfg iwl9270_2ac_cfg = {
 
 const struct iwl_cfg iwl9460_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 9460",
-	.fw_name_pre = IWL9000_FW_PRE,
-	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
+	.fw_name_pre = IWL9260A_FW_PRE,
+	.fw_name_pre_b_or_c_step = IWL9260B_FW_PRE,
 	IWL_DEVICE_9000,
 	.ht_params = &iwl9000_ht_params,
 	.nvm_ver = IWL9000_NVM_VERSION,
@@ -198,8 +198,8 @@ const struct iwl_cfg iwl9460_2ac_cfg = {
 
 const struct iwl_cfg iwl9560_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 9560",
-	.fw_name_pre = IWL9000_FW_PRE,
-	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
+	.fw_name_pre = IWL9260A_FW_PRE,
+	.fw_name_pre_b_or_c_step = IWL9260B_FW_PRE,
 	IWL_DEVICE_9000,
 	.ht_params = &iwl9000_ht_params,
 	.nvm_ver = IWL9000_NVM_VERSION,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index c52623cb7c2a..d19c74827fbb 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -276,10 +276,10 @@ struct iwl_pwr_tx_backoff {
  * @fw_name_pre: Firmware filename prefix. The api version and extension
  *	(.ucode) will be added to filename before loading from disk. The
  *	filename is constructed as fw_name_pre<api>.ucode.
- * @fw_name_pre_next_step: same as @fw_name_pre, only for next step
+ * @fw_name_pre_b_or_c_step: same as @fw_name_pre, only for b or c steps
  *	(if supported)
- * @fw_name_pre_rf_next_step: same as @fw_name_pre_next_step, only for rf next
- *	step. Supported only in integrated solutions.
+ * @fw_name_pre_rf_next_step: same as @fw_name_pre_b_or_c_step, only for rf
+ *	next step. Supported only in integrated solutions.
  * @ucode_api_max: Highest version of uCode API supported by driver.
  * @ucode_api_min: Lowest version of uCode API supported by driver.
  * @max_inst_size: The maximal length of the fw inst section
@@ -330,7 +330,7 @@ struct iwl_cfg {
 	/* params specific to an individual device within a device family */
 	const char *name;
 	const char *fw_name_pre;
-	const char *fw_name_pre_next_step;
+	const char *fw_name_pre_b_or_c_step;
 	const char *fw_name_pre_rf_next_step;
 	/* params not likely to change within a device family */
 	const struct iwl_base_params *base_params;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 6fdb5921e17f..4e0f86fe0a6f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -216,8 +216,9 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 	const char *fw_pre_name;
 
 	if (drv->trans->cfg->device_family == IWL_DEVICE_FAMILY_9000 &&
-	    CSR_HW_REV_STEP(drv->trans->hw_rev) == SILICON_B_STEP)
-		fw_pre_name = cfg->fw_name_pre_next_step;
+	    (CSR_HW_REV_STEP(drv->trans->hw_rev) == SILICON_B_STEP ||
+	     CSR_HW_REV_STEP(drv->trans->hw_rev) == SILICON_C_STEP))
+		fw_pre_name = cfg->fw_name_pre_b_or_c_step;
 	else if (drv->trans->cfg->integrated &&
 		 CSR_HW_RFID_STEP(drv->trans->hw_rf_id) == SILICON_B_STEP &&
 		 cfg->fw_name_pre_rf_next_step)
-- 
2.13.2
