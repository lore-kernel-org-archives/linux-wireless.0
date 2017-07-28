Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40872 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752158AbdG1OYL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:24:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 28 Jul 2017 17:23:20 +0300
Message-Id: <20170728142337.19183-8-luca@coelho.fi> (sfid-20170728_162423_729401_F17C3D02)
In-Reply-To: <20170728142337.19183-1-luca@coelho.fi>
References: <20170728142337.19183-1-luca@coelho.fi>
Subject: [PATCH 07/24] iwlwifi: mvm: add and use iwl_mvm_has_unified_ucode()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This may need to be refined later, but for now using this,
even with the TODO, is better than checking "has new TX API".

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  | 8 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 6 ++++++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 2 +-
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index e6f6de2500db..58f846610e5d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -457,7 +457,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	};
 	int ret;
 
-	if (iwl_mvm_has_new_tx_api(mvm))
+	if (iwl_mvm_has_unified_ucode(mvm))
 		return iwl_run_unified_mvm_ucode(mvm, true);
 
 	lockdep_assert_held(&mvm->mutex);
@@ -1034,7 +1034,7 @@ static int iwl_mvm_load_rt_fw(struct iwl_mvm *mvm)
 {
 	int ret;
 
-	if (iwl_mvm_has_new_tx_api(mvm))
+	if (iwl_mvm_has_unified_ucode(mvm))
 		return iwl_run_unified_mvm_ucode(mvm, false);
 
 	ret = iwl_run_init_mvm_ucode(mvm, false);
@@ -1101,8 +1101,8 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	if (ret)
 		goto error;
 
-	/* Send phy db control command and then phy db calibration*/
-	if (!iwl_mvm_has_new_tx_api(mvm)) {
+	if (!iwl_mvm_has_unified_ucode(mvm)) {
+		/* Send phy db control command and then phy db calibration */
 		ret = iwl_send_phy_db_data(mvm->phy_db);
 		if (ret)
 			goto error;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 6fa2c44e6edd..e9440ef3022f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1232,6 +1232,12 @@ static inline bool iwl_mvm_has_new_tx_api(struct iwl_mvm *mvm)
 	return mvm->trans->cfg->use_tfh;
 }
 
+static inline bool iwl_mvm_has_unified_ucode(struct iwl_mvm *mvm)
+{
+	/* TODO - better define this */
+	return mvm->trans->cfg->device_family >= IWL_DEVICE_FAMILY_A000;
+}
+
 static inline bool iwl_mvm_is_cdb_supported(struct iwl_mvm *mvm)
 {
 	/*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 6b385cf10555..4d591fdc61f2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -645,7 +645,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		mvm->last_agg_queue = IWL_MVM_DQA_MAX_DATA_QUEUE;
 	}
 	mvm->sf_state = SF_UNINIT;
-	if (iwl_mvm_has_new_tx_api(mvm))
+	if (iwl_mvm_has_unified_ucode(mvm))
 		iwl_fw_set_current_image(&mvm->fwrt, IWL_UCODE_REGULAR);
 	else
 		iwl_fw_set_current_image(&mvm->fwrt, IWL_UCODE_INIT);
-- 
2.13.2
