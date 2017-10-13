Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53178 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757969AbdJMNZS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 09:25:18 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Beni Lev <beni.lev@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Oct 2017 16:24:57 +0300
Message-Id: <20171013132502.10473-5-luca@coelho.fi> (sfid-20171013_152605_632756_5A91DD0B)
In-Reply-To: <20171013132502.10473-1-luca@coelho.fi>
References: <20171013132502.10473-1-luca@coelho.fi>
Subject: [PATCH 4/9] iwlwifi: mvm: allow reading UMAC error data from SMEM in A000 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Beni Lev <beni.lev@intel.com>

Currently, UMAC error data reading is restricted to DCCM.
A000 NICs use SMEM for this data.

Signed-off-by: Beni Lev <beni.lev@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 2da1b088ac01..4ade688db63b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -459,7 +459,8 @@ static void iwl_mvm_dump_umac_error_log(struct iwl_mvm *mvm)
 
 	base = mvm->umac_error_event_table;
 
-	if (base < 0x800000) {
+	if (base < (mvm->trans->cfg->device_family == IWL_DEVICE_FAMILY_A000 ?
+		    0x400000 : 0x800000)) {
 		IWL_ERR(mvm,
 			"Not valid error log pointer 0x%08X for %s uCode\n",
 			base,
-- 
2.14.2
