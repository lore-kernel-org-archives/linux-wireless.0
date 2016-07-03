Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60816 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752843AbcGCTtF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jul 2016 15:49:05 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Sun,  3 Jul 2016 22:48:46 +0300
Message-Id: <1467575332-32112-7-git-send-email-luca@coelho.fi> (sfid-20160703_214925_315021_718A31AE)
In-Reply-To: <467405215.1837.15.camel@coelho.fi>
References: <467405215.1837.15.camel@coelho.fi>
Subject: [PATCH 07/13] iwlwifi: mvm: free dqa queues on STA removal also in non-bss
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Support queue removal in DQA mode in iwl_mvm_rm_sta() also when
the device isn't a STA connected to an AP.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index fea4d3437..64b07b1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -819,8 +819,9 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 	if (iwl_mvm_has_new_rx_api(mvm))
 		kfree(mvm_sta->dup_data);
 
-	if (vif->type == NL80211_IFTYPE_STATION &&
-	    mvmvif->ap_sta_id == mvm_sta->sta_id) {
+	if ((vif->type == NL80211_IFTYPE_STATION &&
+	     mvmvif->ap_sta_id == mvm_sta->sta_id) ||
+	    iwl_mvm_is_dqa_supported(mvm)){
 		ret = iwl_mvm_drain_sta(mvm, mvm_sta, true);
 		if (ret)
 			return ret;
-- 
2.8.1

