Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52088 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751861AbeF3NXk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Jun 2018 09:23:40 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 30 Jun 2018 16:23:18 +0300
Message-Id: <20180630132330.14928-4-luca@coelho.fi> (sfid-20180630_152347_288245_8056EA50)
In-Reply-To: <20180630132330.14928-1-luca@coelho.fi>
References: <20180630132330.14928-1-luca@coelho.fi>
Subject: [PATCH 03/15] iwlwifi: allow different csr flags for different device families
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben Ami <golan.ben.ami@intel.com>

Different device families may have different flag values
for passing a message to the fw (i.e. SW_RESET).
In order to keep the code readable, and avoid conditioning
upon the family, store a value for each flag, which indicates
the bit that needs to be enabled.

Additionally, support 22560 device csr flags and addresses.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c  | 4 +++-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index aafd8cab86b0..2768c2b15acb 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -191,6 +191,7 @@ const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_a0_f0 = {
 	.name = "Intel(R) Dual Band Wireless AX 22000",
 	.fw_name_pre = IWL_22000_HR_A_F0_FW_PRE,
 	IWL_DEVICE_22000,
+	.csr = &iwl_csr_v1,
 	.ht_params = &iwl_22000_ht_params,
 	.nvm_ver = IWL_22000_NVM_VERSION,
 	.nvm_calib_ver = IWL_22000_TX_POWER_VERSION,
@@ -236,10 +237,11 @@ const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_a0 = {
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
-const struct iwl_cfg iwl22000_2ax_cfg_hr_cdb = {
+const struct iwl_cfg iwl22560_2ax_cfg_su_cdb = {
 	.name = "Intel(R) Dual Band Wireless AX 22560",
 	.fw_name_pre = IWL_22000_SU_Z0_FW_PRE,
 	IWL_DEVICE_22000,
+	.csr = &iwl_csr_v2,
 	.ht_params = &iwl_22000_ht_params,
 	.nvm_ver = IWL_22000_NVM_VERSION,
 	.nvm_calib_ver = IWL_22000_TX_POWER_VERSION,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index ede491be7aac..b7389f1aa3af 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -570,7 +570,7 @@ extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_a0_f0;
 extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_b0;
 extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_jf_b0;
 extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_a0;
-extern const struct iwl_cfg iwl22000_2ax_cfg_hr_cdb;
+extern const struct iwl_cfg iwl22560_2ax_cfg_su_cdb;
 #endif /* CONFIG_IWLMVM */
 
 #endif /* __IWL_CONFIG_H__ */
-- 
2.18.0
