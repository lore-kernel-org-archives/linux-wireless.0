Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53146 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S941016AbdDTEfd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 00:35:33 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 20 Apr 2017 07:35:18 +0300
Message-Id: <20170420043519.18615-2-luca@coelho.fi> (sfid-20170420_063639_522771_D83B83E2)
In-Reply-To: <20170420043519.18615-1-luca@coelho.fi>
References: <20170420043519.18615-1-luca@coelho.fi>
Subject: [PATCH 1/2] iwlwifi: pcie: fix mutex leak in gen2 start
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the context info fails to be allocated, the mutex
isn't unlocked properly, fix that.

Fixes: eda50cde58de ("iwlwifi: pcie: add context information support")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index ef8f563a48d9..ac60a282d6de 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -359,8 +359,9 @@ int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
 		goto out;
 	}
 
-	if (iwl_pcie_ctxt_info_init(trans, fw))
-		return -ENOMEM;
+	ret = iwl_pcie_ctxt_info_init(trans, fw);
+	if (ret)
+		goto out;
 
 	/* re-check RF-Kill state since we may have missed the interrupt */
 	hw_rfkill = iwl_trans_check_hw_rf_kill(trans);
-- 
2.11.0
