Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49624 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752634AbdIHJN1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 05:13:27 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  8 Sep 2017 12:12:55 +0300
Message-Id: <20170908091256.25279-10-luca@coelho.fi> (sfid-20170908_111331_135964_3D5F0DD9)
In-Reply-To: <20170908091256.25279-1-luca@coelho.fi>
References: <20170908091256.25279-1-luca@coelho.fi>
Subject: [PATCH 09/10] iwlwifi: mvm: set status before calling iwl_mvm_send_cmd_status()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

We always must set the status to what we consider success before
calling iwl_mvm_send_cmd_status() (also iwl_mvm_send_cmd_pdu_status()
which calls it).  Fix a few places where initialization is missing.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c   | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 50983615dce6..774122fed454 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -555,7 +555,7 @@ static int iwl_mvm_lmac_scan_abort(struct iwl_mvm *mvm)
 	struct iwl_host_cmd cmd = {
 		.id = SCAN_OFFLOAD_ABORT_CMD,
 	};
-	u32 status;
+	u32 status = CAN_ABORT_STATUS;
 
 	ret = iwl_mvm_send_cmd_status(mvm, &cmd, &status);
 	if (ret)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index 8876c2abc440..4d907f60bce9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -529,6 +529,7 @@ int iwl_mvm_ctdp_command(struct iwl_mvm *mvm, u32 op, u32 state)
 
 	lockdep_assert_held(&mvm->mutex);
 
+	status = 0;
 	ret = iwl_mvm_send_cmd_pdu_status(mvm, WIDE_ID(PHY_OPS_GROUP,
 						       CTDP_CONFIG_CMD),
 					  sizeof(cmd), &cmd, &status);
-- 
2.14.1
