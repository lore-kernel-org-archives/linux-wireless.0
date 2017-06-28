Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35946 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751518AbdF1UPB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:15:01 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:22 +0300
Message-Id: <20170628201330.9432-24-luca@coelho.fi> (sfid-20170628_221504_347765_6AD9DF58)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 23/31] iwlwifi: pcie: make ctxt-info free idempotent
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

By setting the pointers to NULL at the end, these functions
are made idempotent.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
index b1f43397bb59..00d1a5f048b3 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
@@ -103,6 +103,7 @@ static void iwl_pcie_ctxt_info_free_fw_img(struct iwl_trans *trans)
 
 	kfree(dram->fw);
 	dram->fw_cnt = 0;
+	dram->fw = NULL;
 }
 
 void iwl_pcie_ctxt_info_free_paging(struct iwl_trans *trans)
@@ -124,6 +125,7 @@ void iwl_pcie_ctxt_info_free_paging(struct iwl_trans *trans)
 
 	kfree(dram->paging);
 	dram->paging_cnt = 0;
+	dram->paging = NULL;
 }
 
 static int iwl_pcie_ctxt_info_init_fw_sec(struct iwl_trans *trans,
-- 
2.11.0
