Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45480 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S940174AbcIVUw1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 16:52:27 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 22 Sep 2016 23:52:09 +0300
Message-Id: <20160922205210.1778-10-luca@coelho.fi> (sfid-20160922_225243_143290_38E1CE83)
In-Reply-To: <20160922205210.1778-1-luca@coelho.fi>
References: <20160922205210.1778-1-luca@coelho.fi>
Subject: [PATCH 09/10] iwlwifi: allow error table address new range
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The firmware has a new smart linker, and this table can now be
in ICCM or in SMEM. It is not hardcoded, but depends on code
size. Allow the full range.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 9e366e2..d04babd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -512,7 +512,7 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 			base = mvm->fw->inst_errlog_ptr;
 	}
 
-	if (base < 0x800000) {
+	if (base < 0x400000) {
 		IWL_ERR(mvm,
 			"Not valid error log pointer 0x%08X for %s uCode\n",
 			base,
-- 
2.9.3
