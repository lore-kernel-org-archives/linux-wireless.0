Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36140 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751445AbdAWWEL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:04:11 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com,
        Johannes Berg <johannes.berg@intel.com>
Date: Tue, 24 Jan 2017 00:03:31 +0200
Message-Id: <20170123220350.25305-7-luca@coelho.fi> (sfid-20170123_230415_564613_AEED4675)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
Subject: [PATCH 06/25] iwlwifi: mvm: properly check for transport data in dump
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When copying from vmalloc'ed memory to the SG list, don't crash
if the transport didn't provide any data.

Fixes: 7e62a699aafb ("iwlwifi: mvm: use dev_coredumpsg()")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index 10f2c6e4056a..36f79953c7a1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -848,11 +848,12 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 				     sg_nents(sg_dump_data),
 				     fw_error_dump->op_mode_ptr,
 				     fw_error_dump->op_mode_len, 0);
-		sg_pcopy_from_buffer(sg_dump_data,
-				     sg_nents(sg_dump_data),
-				     fw_error_dump->trans_ptr->data,
-				     fw_error_dump->trans_ptr->len,
-				     fw_error_dump->op_mode_len);
+		if (fw_error_dump->trans_ptr)
+			sg_pcopy_from_buffer(sg_dump_data,
+					     sg_nents(sg_dump_data),
+					     fw_error_dump->trans_ptr->data,
+					     fw_error_dump->trans_ptr->len,
+					     fw_error_dump->op_mode_len);
 		dev_coredumpsg(mvm->trans->dev, sg_dump_data, file_len,
 			       GFP_KERNEL);
 	}
-- 
2.11.0
