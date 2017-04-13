Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51244 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753957AbdDMPZT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 11:25:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 13 Apr 2017 18:24:43 +0300
Message-Id: <20170413152507.9648-3-luca@coelho.fi> (sfid-20170413_172525_745467_F81E78E8)
In-Reply-To: <20170413152507.9648-1-luca@coelho.fi>
References: <20170413152507.9648-1-luca@coelho.fi>
Subject: [PATCH 02/26] iwlwifi: mvm: add queues after adding station
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Currently aux & broadcast queues are added before calling add
station, which results with a SCD_QUEUE_CFG command sent with
a station id unknown yet to fw.
While this works for pre-a000 firmware, the a000 fw requires
the order to be reversed.
The reason the change is only for a000 devices and not for
previous devices is that we cannot reverse the order since
the tfd_queue_mask containing the aux queue will cause FW to
assert on adding a queue mask with a queue that is not enabled.
This is not a problem in a000 fw since the tfd_queue_mask was
removed from the add sta API.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 90 ++++++++++++++++++----------
 1 file changed, 58 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 2d68cee41306..7d6a5dbb50ca 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1700,25 +1700,11 @@ static int iwl_mvm_add_int_sta_common(struct iwl_mvm *mvm,
 	return ret;
 }
 
-int iwl_mvm_add_aux_sta(struct iwl_mvm *mvm)
+static void iwl_mvm_enable_aux_queue(struct iwl_mvm *mvm)
 {
 	unsigned int wdg_timeout = iwlmvm_mod_params.tfd_q_hang_detect ?
 					mvm->cfg->base_params->wd_timeout :
 					IWL_WATCHDOG_DISABLED;
-	int ret;
-
-	lockdep_assert_held(&mvm->mutex);
-
-	/* Map Aux queue to fifo - needs to happen before adding Aux station */
-	if (!iwl_mvm_is_dqa_supported(mvm))
-		iwl_mvm_enable_ac_txq(mvm, mvm->aux_queue, mvm->aux_queue,
-				      IWL_MVM_TX_FIFO_MCAST, 0, wdg_timeout);
-
-	/* Allocate aux station and assign to it the aux queue */
-	ret = iwl_mvm_allocate_int_sta(mvm, &mvm->aux_sta, BIT(mvm->aux_queue),
-				       NL80211_IFTYPE_UNSPECIFIED);
-	if (ret)
-		return ret;
 
 	if (iwl_mvm_is_dqa_supported(mvm)) {
 		struct iwl_trans_txq_scd_cfg cfg = {
@@ -1731,14 +1717,43 @@ int iwl_mvm_add_aux_sta(struct iwl_mvm *mvm)
 
 		iwl_mvm_enable_txq(mvm, mvm->aux_queue, mvm->aux_queue, 0, &cfg,
 				   wdg_timeout);
+	} else {
+		iwl_mvm_enable_ac_txq(mvm, mvm->aux_queue, mvm->aux_queue,
+				      IWL_MVM_TX_FIFO_MCAST, 0, wdg_timeout);
 	}
+}
 
-	ret = iwl_mvm_add_int_sta_common(mvm, &mvm->aux_sta, NULL,
-					 MAC_INDEX_AUX, 0);
+int iwl_mvm_add_aux_sta(struct iwl_mvm *mvm)
+{
+	int ret;
+
+	lockdep_assert_held(&mvm->mutex);
 
+	/* Allocate aux station and assign to it the aux queue */
+	ret = iwl_mvm_allocate_int_sta(mvm, &mvm->aux_sta, BIT(mvm->aux_queue),
+				       NL80211_IFTYPE_UNSPECIFIED);
 	if (ret)
+		return ret;
+
+	/* Map Aux queue to fifo - needs to happen before adding Aux station */
+	if (!iwl_mvm_has_new_tx_api(mvm))
+		iwl_mvm_enable_aux_queue(mvm);
+
+	ret = iwl_mvm_add_int_sta_common(mvm, &mvm->aux_sta, NULL,
+					 MAC_INDEX_AUX, 0);
+	if (ret) {
 		iwl_mvm_dealloc_int_sta(mvm, &mvm->aux_sta);
-	return ret;
+		return ret;
+	}
+
+	/*
+	 * For a000 firmware and on we cannot add queue to a station unknown
+	 * to firmware so enable queue here - after the station was added
+	 */
+	if (iwl_mvm_has_new_tx_api(mvm))
+		iwl_mvm_enable_aux_queue(mvm);
+
+	return 0;
 }
 
 int iwl_mvm_add_snif_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
@@ -1789,22 +1804,21 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	struct iwl_mvm_int_sta *bsta = &mvmvif->bcast_sta;
 	static const u8 _baddr[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
 	const u8 *baddr = _baddr;
+	int queue = 0;
 	int ret;
+	unsigned int wdg_timeout =
+		iwl_mvm_get_wd_timeout(mvm, vif, false, false);
+	struct iwl_trans_txq_scd_cfg cfg = {
+		.fifo = IWL_MVM_TX_FIFO_VO,
+		.sta_id = mvmvif->bcast_sta.sta_id,
+		.tid = IWL_MAX_TID_COUNT,
+		.aggregate = false,
+		.frame_limit = IWL_FRAME_LIMIT,
+	};
 
 	lockdep_assert_held(&mvm->mutex);
 
 	if (iwl_mvm_is_dqa_supported(mvm)) {
-		struct iwl_trans_txq_scd_cfg cfg = {
-			.fifo = IWL_MVM_TX_FIFO_VO,
-			.sta_id = mvmvif->bcast_sta.sta_id,
-			.tid = IWL_MAX_TID_COUNT,
-			.aggregate = false,
-			.frame_limit = IWL_FRAME_LIMIT,
-		};
-		unsigned int wdg_timeout =
-			iwl_mvm_get_wd_timeout(mvm, vif, false, false);
-		int queue;
-
 		if (vif->type == NL80211_IFTYPE_AP)
 			queue = mvm->probe_queue;
 		else if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
@@ -1812,9 +1826,11 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		else if (WARN(1, "Missing required TXQ for adding bcast STA\n"))
 			return -EINVAL;
 
-		iwl_mvm_enable_txq(mvm, queue, vif->hw_queue[0], 0, &cfg,
-				   wdg_timeout);
 		bsta->tfd_queue_msk |= BIT(queue);
+
+		if (!iwl_mvm_has_new_tx_api(mvm))
+			iwl_mvm_enable_txq(mvm, queue, vif->hw_queue[0], 0,
+					   &cfg, wdg_timeout);
 	}
 
 	if (vif->type == NL80211_IFTYPE_ADHOC)
@@ -1825,8 +1841,18 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	ret = iwl_mvm_add_int_sta_common(mvm, bsta, baddr,
 					 mvmvif->id, mvmvif->color);
+	if (ret)
+		return ret;
 
-	return ret;
+	/*
+	 * For a000 firmware and on we cannot add queue to a station unknown
+	 * to firmware so enable queue here - after the station was added
+	 */
+	if (iwl_mvm_has_new_tx_api(mvm))
+		iwl_mvm_enable_txq(mvm, queue, vif->hw_queue[0], 0, &cfg,
+				   wdg_timeout);
+
+	return 0;
 }
 
 static void iwl_mvm_free_bcast_sta_queues(struct iwl_mvm *mvm,
-- 
2.11.0
