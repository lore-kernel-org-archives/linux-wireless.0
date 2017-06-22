Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34380 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753800AbdFVVWE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:22:04 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:20:48 +0300
Message-Id: <20170622212101.16422-13-luca@coelho.fi> (sfid-20170622_232208_660078_4FC3C536)
In-Reply-To: <20170622212101.16422-1-luca@coelho.fi>
References: <20170622212101.16422-1-luca@coelho.fi>
Subject: [PATCH 12/25] iwlwifi: mvm: make D0I3_END_CMD sync during system resume
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

There is no need to send D0I3_END_CMD as ASYNC during the system
resume flow.  Additionally, the other flags used are meaningless in
this case (they were just copied from the runtime resume flow), so
remove them all.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 0493a03ec3ed..f5b65c1ef42f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2076,9 +2076,6 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 	bool unified_image = fw_has_capa(&mvm->fw->ucode_capa,
 					 IWL_UCODE_TLV_CAPA_CNSLDTD_D3_D0_IMG);
 
-	u32 flags = CMD_ASYNC | CMD_HIGH_PRIO | CMD_SEND_IN_IDLE |
-				    CMD_WAKE_UP_TRANS;
-
 	mutex_lock(&mvm->mutex);
 
 	/* get the BSS vif pointer again */
@@ -2144,7 +2141,7 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 
 out:
 	if (unified_image && !ret) {
-		ret = iwl_mvm_send_cmd_pdu(mvm, D0I3_END_CMD, flags, 0, NULL);
+		ret = iwl_mvm_send_cmd_pdu(mvm, D0I3_END_CMD, 0, 0, NULL);
 		if (!ret) /* D3 ended successfully - no need to reset device */
 			return 0;
 	}
-- 
2.11.0
