Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:45182 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752906AbeDKNFl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Apr 2018 09:05:41 -0400
From: Colin King <colin.king@canonical.com>
To: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] iwlwifi: mvm: remove division by size of sizeof(struct ieee80211_wmm_rule)
Date: Wed, 11 Apr 2018 14:05:33 +0100
Message-Id: <20180411130533.11827-1-colin.king@canonical.com> (sfid-20180411_150559_919651_572C6363)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index ca0174680af9..e78219057d2f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -1007,8 +1007,7 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 			continue;
 
 		copy_rd->reg_rules[i].wmm_rule = d_wmm +
-			(regd->reg_rules[i].wmm_rule - s_wmm) /
-			sizeof(struct ieee80211_wmm_rule);
+			(regd->reg_rules[i].wmm_rule - s_wmm);
 	}
 
 out:
-- 
2.17.0
