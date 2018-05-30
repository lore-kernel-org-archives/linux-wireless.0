Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46936 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934440AbeE3HUR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 03:20:17 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 30 May 2018 10:20:01 +0300
Message-Id: <20180530072005.633-7-luca@coelho.fi> (sfid-20180530_092039_966479_1B700B04)
In-Reply-To: <20180530072005.633-1-luca@coelho.fi>
References: <20180530072005.633-1-luca@coelho.fi>
Subject: [PATCH 06/10] iwlwifi: mvm: remove division by size of sizeof(struct ieee80211_wmm_rule)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The subtraction of two struct ieee80211_wmm_rule pointers leaves a result
that is automatically scaled down by the size of the size of pointed-to
type, hence the division by sizeof(struct ieee80211_wmm_rule) is
bogus and should be removed.

Detected by CoverityScan, CID#1467777 ("Extra sizeof expression")

Fixes: 77e30e10ee28 ("iwlwifi: mvm: query regdb for wmm rule if needed")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 0f9d56420c42..b815ba38dbdb 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -1025,8 +1025,7 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 			continue;
 
 		copy_rd->reg_rules[i].wmm_rule = d_wmm +
-			(regd->reg_rules[i].wmm_rule - s_wmm) /
-			sizeof(struct ieee80211_wmm_rule);
+			(regd->reg_rules[i].wmm_rule - s_wmm);
 	}
 
 out:
-- 
2.17.0
