Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45456 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934350AbcIVUwX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 16:52:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 22 Sep 2016 23:52:06 +0300
Message-Id: <20160922205210.1778-7-luca@coelho.fi> (sfid-20160922_225240_766918_A52B5569)
In-Reply-To: <20160922205210.1778-1-luca@coelho.fi>
References: <20160922205210.1778-1-luca@coelho.fi>
Subject: [PATCH 06/10] iwlwifi: mvm: correct rate_idx bounds-check
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The upper bound IWL_RATE_COUNT_LEGACY should be used
with a >= check, rejecting the value itself; fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index e0c9065..ef4bdfc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -346,7 +346,7 @@ void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm, struct iwl_tx_cmd *tx_cmd,
 
 	rate_idx = info->control.rates[0].idx;
 	/* if the rate isn't a well known legacy rate, take the lowest one */
-	if (rate_idx < 0 || rate_idx > IWL_RATE_COUNT_LEGACY)
+	if (rate_idx < 0 || rate_idx >= IWL_RATE_COUNT_LEGACY)
 		rate_idx = rate_lowest_index(
 				&mvm->nvm_data->bands[info->band], sta);
 
-- 
2.9.3
