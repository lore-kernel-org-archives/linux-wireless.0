Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59304 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751104AbeBQIeI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Feb 2018 03:34:08 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 17 Feb 2018 10:33:53 +0200
Message-Id: <20180217083354.31160-9-luca@coelho.fi> (sfid-20180217_093420_571422_3DD91446)
In-Reply-To: <20180217083354.31160-1-luca@coelho.fi>
References: <20180217083354.31160-1-luca@coelho.fi>
Subject: [PATCH 8/9] iwlwifi: mvm: Correctly set the tid for mcast queue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

In the scheduler config command, the meaning of tid == 0xf was intended
to indicate the configuration is for management frames. However,
tid == 0xf was also used for the multicast queue that was meant only
for multicast data frames, which resulted with the FW not encrypting
multicast data frames.

As multicast frames do not have a QoS header, fix this by setting
tid == 0, to indicate that this is a data queue and not management
one.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 3739e42b34e4..630e23cb0ffb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2039,7 +2039,7 @@ int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	struct iwl_trans_txq_scd_cfg cfg = {
 		.fifo = IWL_MVM_TX_FIFO_MCAST,
 		.sta_id = msta->sta_id,
-		.tid = IWL_MAX_TID_COUNT,
+		.tid = 0,
 		.aggregate = false,
 		.frame_limit = IWL_FRAME_LIMIT,
 	};
@@ -2090,7 +2090,7 @@ int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	if (iwl_mvm_has_new_tx_api(mvm)) {
 		int queue = iwl_mvm_tvqm_enable_txq(mvm, vif->cab_queue,
 						    msta->sta_id,
-						    IWL_MAX_TID_COUNT,
+						    0,
 						    timeout);
 		mvmvif->cab_queue = queue;
 	} else if (!fw_has_api(&mvm->fw->ucode_capa,
@@ -2115,7 +2115,7 @@ int iwl_mvm_rm_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	iwl_mvm_flush_sta(mvm, &mvmvif->mcast_sta, true, 0);
 
 	iwl_mvm_disable_txq(mvm, mvmvif->cab_queue, vif->cab_queue,
-			    IWL_MAX_TID_COUNT, 0);
+			    0, 0);
 
 	ret = iwl_mvm_rm_sta_common(mvm, mvmvif->mcast_sta.sta_id);
 	if (ret)
-- 
2.15.1
