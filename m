Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41048 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752129AbdG1O0x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:26:53 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 28 Jul 2017 17:23:33 +0300
Message-Id: <20170728142337.19183-21-luca@coelho.fi> (sfid-20170728_162715_924264_7AF4A3C8)
In-Reply-To: <20170728142337.19183-1-luca@coelho.fi>
References: <20170728142337.19183-1-luca@coelho.fi>
Subject: [PATCH 20/24] iwlwifi: mvm: require AP_LINK_PS for TVQM
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the TXQ timer freeze code will not properly handle the
large TVQM queue numbers, warn if we get into that code when
we have TVQM. Also, just to catch this earlier, warn if the
firmware image doesn't support AP_LINK_PS but we're running
on HW using TVQM.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 44f144c58720..a2e0acc23adc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -445,8 +445,18 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	ieee80211_hw_set(hw, NEEDS_UNIQUE_STA_ADDR);
 	if (iwl_mvm_has_new_rx_api(mvm))
 		ieee80211_hw_set(hw, SUPPORTS_REORDERING_BUFFER);
-	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_STA_PM_NOTIF))
+
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_STA_PM_NOTIF)) {
 		ieee80211_hw_set(hw, AP_LINK_PS);
+	} else if (WARN_ON(iwl_mvm_has_new_tx_api(mvm))) {
+		/*
+		 * we absolutely need this for the new TX API since that comes
+		 * with many more queues than the current code can deal with
+		 * for station powersave
+		 */
+		return -EINVAL;
+	}
 
 	if (mvm->trans->num_rx_queues > 1)
 		ieee80211_hw_set(hw, USES_RSS);
@@ -2399,6 +2409,14 @@ static void __iwl_mvm_mac_sta_notify(struct ieee80211_hw *hw,
 	unsigned long txqs = 0, tids = 0;
 	int tid;
 
+	/*
+	 * If we have TVQM then we get too high queue numbers - luckily
+	 * we really shouldn't get here with that because such hardware
+	 * should have firmware supporting buffer station offload.
+	 */
+	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
+		return;
+
 	spin_lock_bh(&mvmsta->lock);
 	for (tid = 0; tid < IWL_MAX_TID_COUNT; tid++) {
 		struct iwl_mvm_tid_data *tid_data = &mvmsta->tid_data[tid];
-- 
2.13.2
