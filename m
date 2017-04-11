Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50692 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751876AbdDKMji (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:39:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:32 +0300
Message-Id: <20170411123742.12214-16-luca@coelho.fi> (sfid-20170411_144108_960420_C2BCB4FF)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 15/25] iwlwifi: mvm: don't assume static queue numbers
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In a000 devices FW will assign the queue number. Prepare for
that by getting rid of static defines and store them in variables.
Enlarge to u16 since we may have up to 512 queues.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h |  5 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 22 ++++++++--------------
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c  |  8 ++++----
 4 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 70b994638273..b58ac2aa9999 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -976,7 +976,10 @@ struct iwl_mvm {
 #endif
 
 	/* Tx queues */
-	u8 aux_queue;
+	u16 aux_queue;
+	u16 probe_queue;
+	u16 p2p_dev_queue;
+
 	u8 first_agg_queue;
 	u8 last_agg_queue;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index f4f957fe71d7..600af8a31200 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -603,6 +603,8 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		}
 	} else {
 		mvm->aux_queue = IWL_MVM_DQA_AUX_QUEUE;
+		mvm->probe_queue = IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
+		mvm->p2p_dev_queue = IWL_MVM_DQA_P2P_DEVICE_QUEUE;
 		mvm->first_agg_queue = IWL_MVM_DQA_MIN_DATA_QUEUE;
 		mvm->last_agg_queue = IWL_MVM_DQA_MAX_DATA_QUEUE;
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 26155e2efa84..2d68cee41306 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1806,9 +1806,9 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		int queue;
 
 		if (vif->type == NL80211_IFTYPE_AP)
-			queue = IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
+			queue = mvm->probe_queue;
 		else if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
-			queue = IWL_MVM_DQA_P2P_DEVICE_QUEUE;
+			queue = mvm->p2p_dev_queue;
 		else if (WARN(1, "Missing required TXQ for adding bcast STA\n"))
 			return -EINVAL;
 
@@ -1836,24 +1836,18 @@ static void iwl_mvm_free_bcast_sta_queues(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (mvmvif->bcast_sta.tfd_queue_msk &
-	    BIT(IWL_MVM_DQA_AP_PROBE_RESP_QUEUE)) {
-		iwl_mvm_disable_txq(mvm,
-				    IWL_MVM_DQA_AP_PROBE_RESP_QUEUE,
+	if (mvmvif->bcast_sta.tfd_queue_msk & BIT(mvm->probe_queue)) {
+		iwl_mvm_disable_txq(mvm, mvm->probe_queue,
 				    vif->hw_queue[0], IWL_MAX_TID_COUNT,
 				    0);
-		mvmvif->bcast_sta.tfd_queue_msk &=
-			~BIT(IWL_MVM_DQA_AP_PROBE_RESP_QUEUE);
+		mvmvif->bcast_sta.tfd_queue_msk &= ~BIT(mvm->probe_queue);
 	}
 
-	if (mvmvif->bcast_sta.tfd_queue_msk &
-	    BIT(IWL_MVM_DQA_P2P_DEVICE_QUEUE)) {
-		iwl_mvm_disable_txq(mvm,
-				    IWL_MVM_DQA_P2P_DEVICE_QUEUE,
+	if (mvmvif->bcast_sta.tfd_queue_msk & BIT(mvm->p2p_dev_queue)) {
+		iwl_mvm_disable_txq(mvm, mvm->p2p_dev_queue,
 				    vif->hw_queue[0], IWL_MAX_TID_COUNT,
 				    0);
-		mvmvif->bcast_sta.tfd_queue_msk &=
-			~BIT(IWL_MVM_DQA_P2P_DEVICE_QUEUE);
+		mvmvif->bcast_sta.tfd_queue_msk &= ~BIT(mvm->p2p_dev_queue);
 	}
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 3f37075f4cde..568b0793e84e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -513,20 +513,20 @@ static int iwl_mvm_get_ctrl_vif_queue(struct iwl_mvm *mvm,
 		 */
 		if (ieee80211_is_probe_resp(fc) || ieee80211_is_auth(fc) ||
 		    ieee80211_is_deauth(fc))
-			return IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
+			return mvm->probe_queue;
 		if (info->hw_queue == info->control.vif->cab_queue)
 			return info->hw_queue;
 
 		WARN_ONCE(1, "fc=0x%02x", le16_to_cpu(fc));
-		return IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
+		return mvm->probe_queue;
 	case NL80211_IFTYPE_P2P_DEVICE:
 		if (ieee80211_is_mgmt(fc))
-			return IWL_MVM_DQA_P2P_DEVICE_QUEUE;
+			return mvm->p2p_dev_queue;
 		if (info->hw_queue == info->control.vif->cab_queue)
 			return info->hw_queue;
 
 		WARN_ON_ONCE(1);
-		return IWL_MVM_DQA_P2P_DEVICE_QUEUE;
+		return mvm->p2p_dev_queue;
 	default:
 		WARN_ONCE(1, "Not a ctrl vif, no available queue\n");
 		return -1;
-- 
2.11.0
