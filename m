Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45424 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S939012AbcIVUw1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 16:52:27 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 22 Sep 2016 23:52:02 +0300
Message-Id: <20160922205210.1778-3-luca@coelho.fi> (sfid-20160922_225243_774402_90BE5F01)
In-Reply-To: <20160922205210.1778-1-luca@coelho.fi>
References: <20160922205210.1778-1-luca@coelho.fi>
Subject: [PATCH 02/10] iwlwifi: mvm: cleanup usage of init_dbg parameter
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Move the init_dbg check to earlier in the function to simplify the
code.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 7322c43..8f10780 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1115,27 +1115,27 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	 * (for example, if we were in RFKILL)
 	 */
 	ret = iwl_run_init_mvm_ucode(mvm, false);
-	if (ret && !iwlmvm_mod_params.init_dbg) {
+
+	if (iwlmvm_mod_params.init_dbg)
+		return 0;
+
+	if (ret) {
 		IWL_ERR(mvm, "Failed to run INIT ucode: %d\n", ret);
 		/* this can't happen */
 		if (WARN_ON(ret > 0))
 			ret = -ERFKILL;
 		goto error;
 	}
-	if (!iwlmvm_mod_params.init_dbg) {
-		/*
-		 * Stop and start the transport without entering low power
-		 * mode. This will save the state of other components on the
-		 * device that are triggered by the INIT firwmare (MFUART).
-		 */
-		_iwl_trans_stop_device(mvm->trans, false);
-		ret = _iwl_trans_start_hw(mvm->trans, false);
-		if (ret)
-			goto error;
-	}
 
-	if (iwlmvm_mod_params.init_dbg)
-		return 0;
+	/*
+	 * Stop and start the transport without entering low power
+	 * mode. This will save the state of other components on the
+	 * device that are triggered by the INIT firwmare (MFUART).
+	 */
+	_iwl_trans_stop_device(mvm->trans, false);
+	ret = _iwl_trans_start_hw(mvm->trans, false);
+	if (ret)
+		goto error;
 
 	ret = iwl_mvm_load_ucode_wait_alive(mvm, IWL_UCODE_REGULAR);
 	if (ret) {
-- 
2.9.3
