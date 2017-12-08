Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49620 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753182AbdLHMxF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 07:53:05 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  8 Dec 2017 14:52:59 +0200
Message-Id: <20171208125259.21401-1-luca@coelho.fi> (sfid-20171208_135309_203330_0DB403D5)
Subject: [PATCH] iwlwifi: mvm: fix wrong #ifdef that uses a macro from backports
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

I accidentally pushed a patch with CPTCFG (which is used in the
backports project) to the rs-fw.c file.  Fix that to use CONFIG
instead.

Fixes: 9f66a397c877 ("iwlwifi: mvm: rs: add ops for the new rate scaling in the FW")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index 4e5f09408517..55d1274c6092 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -308,7 +308,7 @@ void iwl_mvm_rs_add_sta(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta)
 	lq_sta->pers.last_rssi = S8_MIN;
 	lq_sta->last_rate_n_flags = 0;
 
-#ifdef CPTCFG_MAC80211_DEBUGFS
+#ifdef CONFIG_MAC80211_DEBUGFS
 	lq_sta->pers.dbg_fixed_rate = 0;
 #endif
 }
-- 
2.15.0
