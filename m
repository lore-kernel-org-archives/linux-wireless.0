Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54906 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753780AbcIOSNE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:13:04 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:24 +0300
Message-Id: <20160915181131.32213-18-luca@coelho.fi> (sfid-20160915_201319_012489_0D9C6252)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 18/25] iwlwifi: mvm: use setup_timer instead of init_timer and data fields
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use setup_timer function instead of initializing timer with the function
and data fields

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 11c7e15..216aa54 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2050,11 +2050,9 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		baid_data->baid = baid;
 		baid_data->timeout = timeout;
 		baid_data->last_rx = jiffies;
-		init_timer(&baid_data->session_timer);
-		baid_data->session_timer.function =
-			iwl_mvm_rx_agg_session_expired;
-		baid_data->session_timer.data =
-			(unsigned long)&mvm->baid_map[baid];
+		setup_timer(&baid_data->session_timer,
+			    iwl_mvm_rx_agg_session_expired,
+			    (unsigned long)&mvm->baid_map[baid]);
 		baid_data->mvm = mvm;
 		baid_data->tid = tid;
 		baid_data->sta_id = mvm_sta->sta_id;
-- 
2.9.3
