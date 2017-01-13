Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34698 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751670AbdAMMkL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 07:40:11 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Jan 2017 14:39:15 +0200
Message-Id: <20170113123919.30384-3-luca@coelho.fi> (sfid-20170113_134100_029903_CE9A86DE)
In-Reply-To: <20170113123919.30384-1-luca@coelho.fi>
References: <20170113123919.30384-1-luca@coelho.fi>
Subject: [PATCH 2/6] iwlwifi: mvm: properly check for transport data in dump
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
index 2e8e3e8e30a3..067f67f74698 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -816,11 +816,12 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
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
