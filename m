Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50716 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752040AbdDKMjy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:39:54 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:41 +0300
Message-Id: <20170411123742.12214-25-luca@coelho.fi> (sfid-20170411_145544_045399_05E23E85)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 24/25] iwlwifi: mvm: remove call for paging in new init flow
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Now that transport inits the paging in the context info -
remove the call in mvm.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  | 8 --------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 3 ++-
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 286f18609729..e481bb050c6e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -850,14 +850,6 @@ int iwl_run_unified_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 		goto error;
 	}
 
-	/* TODO: remove when integrating context info */
-	ret = iwl_mvm_init_paging(mvm);
-	if (ret) {
-		IWL_ERR(mvm, "Failed to init paging: %d\n",
-			ret);
-		goto error;
-	}
-
 	/* Read the NVM only at driver load time, no need to do this twice */
 	if (read_nvm) {
 		/* Read nvm */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index b3f67fe98203..91bd5ebd5b65 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1709,7 +1709,8 @@ void iwl_mvm_enable_ac_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 
 static inline void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 {
-	iwl_free_fw_paging(mvm);
+	if (!iwl_mvm_has_new_tx_api(mvm))
+		iwl_free_fw_paging(mvm);
 	mvm->ucode_loaded = false;
 	iwl_trans_stop_device(mvm->trans);
 }
-- 
2.11.0
