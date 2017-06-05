Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59276 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751258AbdFEUmi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:42:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Jun 2017 23:41:59 +0300
Message-Id: <20170605204218.30151-7-luca@coelho.fi> (sfid-20170605_224246_994457_209B1922)
In-Reply-To: <20170605204218.30151-1-luca@coelho.fi>
References: <20170605204218.30151-1-luca@coelho.fi>
Subject: [PATCH 06/25] iwlwifi: add dbgc_supported to transport configuration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Use transport configuration to determine DBGC support
instead of relying on device family.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c   | 3 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c   | 3 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c   | 3 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h | 3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
index 4d6135b5ff92..5d446740383a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
@@ -164,7 +164,8 @@ static const struct iwl_tt_params iwl8000_tt_params = {
 	.default_nvm_file_C_step = DEFAULT_NVM_FILE_FAMILY_8000C,	\
 	.thermal_params = &iwl8000_tt_params,				\
 	.apmg_not_supported = true,					\
-	.ext_nvm = true
+	.ext_nvm = true,						\
+	.dbgc_supported = true
 
 #define IWL_DEVICE_8000							\
 	IWL_DEVICE_8000_COMMON,						\
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index 3cb416157e73..c7e6ba878af8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -148,7 +148,8 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 	.vht_mu_mimo_supported = true,					\
 	.mac_addr_from_csr = true,					\
 	.rf_id = true,							\
-	.ext_nvm = true
+	.ext_nvm = true,						\
+	.dbgc_supported = true
 
 const struct iwl_cfg iwl9160_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 9160",
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
index ca913b3ddd11..9d09c7ebc3c4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
@@ -124,7 +124,8 @@ static const struct iwl_ht_params iwl_a000_ht_params = {
 	.use_tfh = true,						\
 	.rf_id = true,							\
 	.gen2 = true,							\
-	.ext_nvm = true
+	.ext_nvm = true,						\
+	.dbgc_supported = true
 
 const struct iwl_cfg iwla000_2ac_cfg_hr = {
 		.name = "Intel(R) Dual Band Wireless AC a000",
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 5b0f1d65d199..f7533045dbce 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -366,7 +366,8 @@ struct iwl_cfg {
 	    use_tfh:1,
 	    gen2:1,
 	    cdb:1,
-	    ext_nvm:1;
+	    ext_nvm:1,
+	    dbgc_supported:1;
 	u8 valid_tx_ant;
 	u8 valid_rx_ant;
 	u8 non_shared_ant;
-- 
2.11.0
