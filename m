Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35986 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751652AbdF1UP3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:15:29 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:23 +0300
Message-Id: <20170628201330.9432-25-luca@coelho.fi> (sfid-20170628_221556_182302_BACF1FFB)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 24/31] iwlwifi: pcie: warn if paging is already initialized during init
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This appears to happen in some cases, like when iwlmvm is unloaded and
loaded again without also unloading iwlwifi. Warn in this case and free
the paging data to be able to continue without causing corruption and
kernel crashes due to it (otherwise, paging data is overwritten, but
dram->paging_cnt gets to be twice as big as it should be, and then an
eventual free will crash.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
index 00d1a5f048b3..eddaca76d514 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
@@ -137,6 +137,11 @@ static int iwl_pcie_ctxt_info_init_fw_sec(struct iwl_trans *trans,
 	struct iwl_context_info_dram *ctxt_dram = &ctxt_info->dram;
 	int i, ret, lmac_cnt, umac_cnt, paging_cnt;
 
+	if (WARN(dram->paging,
+		 "paging shouldn't already be initialized (%d pages)\n",
+		 dram->paging_cnt))
+		iwl_pcie_ctxt_info_free_paging(trans);
+
 	lmac_cnt = iwl_pcie_get_num_sections(fw, 0);
 	/* add 1 due to separator */
 	umac_cnt = iwl_pcie_get_num_sections(fw, lmac_cnt + 1);
-- 
2.11.0
