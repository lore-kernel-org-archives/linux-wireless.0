Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48644 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752059AbdLBQ32 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 11:29:28 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Gregory Greenman <gregory.greenman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  2 Dec 2017 18:28:54 +0200
Message-Id: <20171202162858.4167-12-luca@coelho.fi> (sfid-20171202_174638_739872_4E9F2DD7)
In-Reply-To: <20171202162858.4167-1-luca@coelho.fi>
References: <20171202162858.4167-1-luca@coelho.fi>
Subject: [PATCH 11/15] iwlwifi: mvm: rs: add sanity check when sending LQ command
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

When sending LQ command, verify the rate scaling is not in firmware.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 280edf89e5eb..b7fc1b9fb605 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -912,7 +912,9 @@ int iwl_mvm_send_lq_cmd(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq, bool init)
 		.data = { lq, },
 	};
 
-	if (WARN_ON(lq->sta_id == IWL_MVM_INVALID_STA))
+	if (WARN_ON(lq->sta_id == IWL_MVM_INVALID_STA ||
+		    fw_has_capa(&mvm->fw->ucode_capa,
+				IWL_UCODE_TLV_CAPA_TLC_OFFLOAD)))
 		return -EINVAL;
 
 	return iwl_mvm_send_cmd(mvm, &cmd);
-- 
2.15.0
