Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45452 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S939012AbcIVUwX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 16:52:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 22 Sep 2016 23:52:05 +0300
Message-Id: <20160922205210.1778-6-luca@coelho.fi> (sfid-20160922_225240_222312_7C1A601E)
In-Reply-To: <20160922205210.1778-1-luca@coelho.fi>
References: <20160922205210.1778-1-luca@coelho.fi>
Subject: [PATCH 05/10] iwlwifi: mvm: bail out if CTDP start operation fails
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

We were assigning the return value of iwl_mvm_ctdp_command() to a
variable, but never checking it.  If this command fails, we should not
allow the interface up process to proceed, since it is potentially
dangerous to ignore thermal management requirements.

Fixes: commit 5c89e7bc557e ("iwlwifi: mvm: add registration to cooling device")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 8f10780..8974120 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1233,9 +1233,12 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	}
 
 	/* TODO: read the budget from BIOS / Platform NVM */
-	if (iwl_mvm_is_ctdp_supported(mvm) && mvm->cooling_dev.cur_state > 0)
+	if (iwl_mvm_is_ctdp_supported(mvm) && mvm->cooling_dev.cur_state > 0) {
 		ret = iwl_mvm_ctdp_command(mvm, CTDP_CMD_OPERATION_START,
 					   mvm->cooling_dev.cur_state);
+		if (ret)
+			goto error;
+	}
 #else
 	/* Initialize tx backoffs to the minimal possible */
 	iwl_mvm_tt_tx_backoff(mvm, 0);
-- 
2.9.3
