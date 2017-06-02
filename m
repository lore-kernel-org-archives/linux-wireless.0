Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60576 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751284AbdFBJfu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 05:35:50 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 12:35:09 +0300
Message-Id: <20170602093516.16369-4-luca@coelho.fi> (sfid-20170602_113555_439738_5AA51A49)
In-Reply-To: <20170602093516.16369-1-luca@coelho.fi>
References: <20170602093516.16369-1-luca@coelho.fi>
Subject: [PATCH 03/10] iwlwifi: mvm: support ibss in dqa mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Allow working IBSS also when working in DQA mode.
This is done by setting it to treat the queues the
same as a BSS AP treats the queues.

Fixes: 7948b87308a4 ("iwlwifi: mvm: enable dynamic queue allocation mode")
Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index f5c786ddc526..9184ce09b89a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2120,7 +2120,8 @@ int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	if (!iwl_mvm_is_dqa_supported(mvm))
 		return 0;
 
-	if (WARN_ON(vif->type != NL80211_IFTYPE_AP))
+	if (WARN_ON(vif->type != NL80211_IFTYPE_AP &&
+		    vif->type != NL80211_IFTYPE_ADHOC))
 		return -ENOTSUPP;
 
 	/*
@@ -2155,6 +2156,16 @@ int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		mvmvif->cab_queue = queue;
 	} else if (!fw_has_api(&mvm->fw->ucode_capa,
 			       IWL_UCODE_TLV_API_STA_TYPE)) {
+		/*
+		 * In IBSS, ieee80211_check_queues() sets the cab_queue to be
+		 * invalid, so make sure we use the queue we want.
+		 * Note that this is done here as we want to avoid making DQA
+		 * changes in mac80211 layer.
+		 */
+		if (vif->type == NL80211_IFTYPE_ADHOC) {
+			vif->cab_queue = IWL_MVM_DQA_GCAST_QUEUE;
+			mvmvif->cab_queue = vif->cab_queue;
+		}
 		iwl_mvm_enable_txq(mvm, vif->cab_queue, vif->cab_queue, 0,
 				   &cfg, timeout);
 	}
-- 
2.11.0
