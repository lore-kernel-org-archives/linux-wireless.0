Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50976 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1759027AbdLRMiY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Dec 2017 07:38:24 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 18 Dec 2017 14:38:07 +0200
Message-Id: <20171218123815.3968-4-luca@coelho.fi> (sfid-20171218_133828_813563_9AB3B8E9)
In-Reply-To: <20171218123815.3968-1-luca@coelho.fi>
References: <20171218123815.3968-1-luca@coelho.fi>
Subject: [PATCH 03/11] iwlwifi: mvm: force quota update upon NoA setting
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shaul Triebitz <shaul.triebitz@intel.com>

The way p2p NoA is forced in SCM (used for WFA tests)
is by setting a quota < 100% (simulating DCM).
A test-mode command is used for setting the NoA params.
In that case, force quota update or nothing will happen
if there was no significant change in the quota
at that exact point (which is likely to be the case).

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 4f5686526d4b..357380a791c3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3801,7 +3801,7 @@ static int __iwl_mvm_mac_testmode_cmd(struct iwl_mvm *mvm,
 		mvm->noa_duration = noa_duration;
 		mvm->noa_vif = vif;
 
-		return iwl_mvm_update_quotas(mvm, false, NULL);
+		return iwl_mvm_update_quotas(mvm, true, NULL);
 	case IWL_MVM_TM_CMD_SET_BEACON_FILTER:
 		/* must be associated client vif - ignore authorized */
 		if (!vif || vif->type != NL80211_IFTYPE_STATION ||
-- 
2.15.1
