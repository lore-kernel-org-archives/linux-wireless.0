Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35072 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751128AbdFYLNo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:13:44 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:42 +0300
Message-Id: <20170625111158.1792-11-luca@coelho.fi> (sfid-20170625_131347_783484_B53E496F)
In-Reply-To: <20170625111158.1792-1-luca@coelho.fi>
References: <20170625111158.1792-1-luca@coelho.fi>
Subject: [PATCH 10/26] iwlwifi: mvm: fix nvm_data leak
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

We allocate nvm_data in iwl_mvm_nvm_get_from_fw().  If something goes
wrong after the allocation (i.e. if no valid MAC address is valid), we
should free nvm_data before returning an error.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index ad8bd90deed2..efdcffbaac6f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -596,7 +596,7 @@ int iwl_mvm_nvm_get_from_fw(struct iwl_mvm *mvm)
 	if (!is_valid_ether_addr(mvm->nvm_data->hw_addr)) {
 		IWL_ERR(trans, "no valid mac address was found\n");
 		ret = -EINVAL;
-		goto out;
+		goto err_free;
 	}
 
 	/* Initialize general data */
@@ -628,7 +628,11 @@ int iwl_mvm_nvm_get_from_fw(struct iwl_mvm *mvm)
 			mvm->nvm_data->valid_rx_ant & mvm->fw->valid_rx_ant,
 			rsp->regulatory.lar_enabled && lar_fw_supported);
 
-	ret = 0;
+	iwl_free_resp(&hcmd);
+	return 0;
+
+err_free:
+	kfree(mvm->nvm_data);
 out:
 	iwl_free_resp(&hcmd);
 	return ret;
-- 
2.11.0
