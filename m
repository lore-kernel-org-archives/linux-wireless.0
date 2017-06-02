Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60900 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751140AbdFBL14 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 07:27:56 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 14:25:46 +0300
Message-Id: <20170602112553.2466-19-luca@coelho.fi> (sfid-20170602_132801_526761_F24ADE01)
In-Reply-To: <20170602112553.2466-1-luca@coelho.fi>
References: <20170602112553.2466-1-luca@coelho.fi>
Subject: [PATCH 18/25] iwlwifi: mvm: remove wrt support of page dumps in gen2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

In gen2, page dumping should be done in transport
layer, since the addresses needed for the paging
mechanism reside there.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index 7b86a4f1b574..d8b592aa362c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -691,7 +691,8 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	}
 
 	/* Make room for fw's virtual image pages, if it exists */
-	if (mvm->fw->img[mvm->cur_ucode].paging_mem_size &&
+	if (!mvm->trans->cfg->gen2 &&
+	    mvm->fw->img[mvm->cur_ucode].paging_mem_size &&
 	    mvm->fw_paging_db[0].fw_paging_block)
 		file_len += mvm->num_of_paging_blk *
 			(sizeof(*dump_data) +
@@ -850,7 +851,8 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	}
 
 	/* Dump fw's virtual image */
-	if (mvm->fw->img[mvm->cur_ucode].paging_mem_size &&
+	if (!mvm->trans->cfg->gen2 &&
+	    mvm->fw->img[mvm->cur_ucode].paging_mem_size &&
 	    mvm->fw_paging_db[0].fw_paging_block) {
 		for (i = 1; i < mvm->num_of_paging_blk + 1; i++) {
 			struct iwl_fw_error_dump_paging *paging;
-- 
2.11.0
