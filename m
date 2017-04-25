Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54172 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1954147AbdDYUXL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:23:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:25 +0300
Message-Id: <20170425202243.7844-8-luca@coelho.fi> (sfid-20170425_222327_955572_30707ACF)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 07/25] iwlwifi: mvm: avoid variable shadowing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Remove an extra variable 'queue' that already exists.
Also, since there are no code paths that use 'queue'
without intializing it, remove the unnecessary zero
initialization.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index fc6d854b04b6..e502a6e6bf90 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1895,7 +1895,7 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	struct iwl_mvm_int_sta *bsta = &mvmvif->bcast_sta;
 	static const u8 _baddr[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
 	const u8 *baddr = _baddr;
-	int queue = 0;
+	int queue;
 	int ret;
 	unsigned int wdg_timeout =
 		iwl_mvm_get_wd_timeout(mvm, vif, false, false);
@@ -1940,10 +1940,11 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	 * to firmware so enable queue here - after the station was added
 	 */
 	if (iwl_mvm_has_new_tx_api(mvm)) {
-		int queue = iwl_mvm_tvqm_enable_txq(mvm, vif->hw_queue[0],
-						    bsta->sta_id,
-						    IWL_MAX_TID_COUNT,
-						    wdg_timeout);
+		queue = iwl_mvm_tvqm_enable_txq(mvm, vif->hw_queue[0],
+						bsta->sta_id,
+						IWL_MAX_TID_COUNT,
+						wdg_timeout);
+
 		if (vif->type == NL80211_IFTYPE_AP)
 			mvm->probe_queue = queue;
 		else if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
-- 
2.11.0
