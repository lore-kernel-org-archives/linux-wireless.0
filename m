Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37970 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751958AbdBCOjf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:39:35 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:38:03 +0200
Message-Id: <20170203143812.7525-17-luca@coelho.fi> (sfid-20170203_153938_729581_3894CD73)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 16/25] iwlwifi: mvm: release static queues on bcast release
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

A few of the static queues are enabled along with the bcast
STA. Make sure they are removed along with it, rather than
waiting for the mac ctxt release.

This is needed because we sometimes have a STA being removed
and then added again (either with the same sta_id or a
different one). If we wait for the mac ctxt release we will
try to allocate the queues again (as this is currently done
in the STA allocation and not in the MAC init) although
they weren't freed, and even if the sta_id of the STA has
changed.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 34 +++------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 16 ----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 90 ++++++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c    |  4 +-
 4 files changed, 85 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index ebf6c071eb36..bf0555fcf695 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -531,38 +531,26 @@ void iwl_mvm_mac_ctxt_release(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	lockdep_assert_held(&mvm->mutex);
 
+	/*
+	 * If DQA is supported - queues were already disabled, since in
+	 * DQA-mode the queues are a property of the STA and not of the
+	 * vif, and at this point the STA was already deleted
+	 */
+	if (iwl_mvm_is_dqa_supported(mvm))
+		return;
+
 	switch (vif->type) {
 	case NL80211_IFTYPE_P2P_DEVICE:
-		if (!iwl_mvm_is_dqa_supported(mvm))
-			iwl_mvm_disable_txq(mvm, IWL_MVM_OFFCHANNEL_QUEUE,
-					    IWL_MVM_OFFCHANNEL_QUEUE,
-					    IWL_MAX_TID_COUNT, 0);
-		else
-			iwl_mvm_disable_txq(mvm,
-					    IWL_MVM_DQA_P2P_DEVICE_QUEUE,
-					    vif->hw_queue[0], IWL_MAX_TID_COUNT,
-					    0);
+		iwl_mvm_disable_txq(mvm, IWL_MVM_OFFCHANNEL_QUEUE,
+				    IWL_MVM_OFFCHANNEL_QUEUE,
+				    IWL_MAX_TID_COUNT, 0);
 
 		break;
 	case NL80211_IFTYPE_AP:
 		iwl_mvm_disable_txq(mvm, vif->cab_queue, vif->cab_queue,
 				    IWL_MAX_TID_COUNT, 0);
-
-		if (iwl_mvm_is_dqa_supported(mvm))
-			iwl_mvm_disable_txq(mvm,
-					    IWL_MVM_DQA_AP_PROBE_RESP_QUEUE,
-					    vif->hw_queue[0], IWL_MAX_TID_COUNT,
-					    0);
 		/* fall through */
 	default:
-		/*
-		 * If DQA is supported - queues were already disabled, since in
-		 * DQA-mode the queues are a property of the STA and not of the
-		 * vif, and at this point the STA was already deleted
-		 */
-		if (iwl_mvm_is_dqa_supported(mvm))
-			break;
-
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
 			iwl_mvm_disable_txq(mvm, vif->hw_queue[ac],
 					    vif->hw_queue[ac],
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 72102566a02b..15ecd3aba71b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2104,22 +2104,6 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	if (ret)
 		goto out_unbind;
 
-	/* enable the multicast queue, now that we have a station for it */
-	if (iwl_mvm_is_dqa_supported(mvm)) {
-		unsigned int wdg_timeout =
-			iwl_mvm_get_wd_timeout(mvm, vif, false, false);
-		struct iwl_trans_txq_scd_cfg cfg = {
-			.fifo = IWL_MVM_TX_FIFO_MCAST,
-			.sta_id = mvmvif->bcast_sta.sta_id,
-			.tid = IWL_MAX_TID_COUNT,
-			.aggregate = false,
-			.frame_limit = IWL_FRAME_LIMIT,
-		};
-
-		iwl_mvm_enable_txq(mvm, vif->cab_queue, vif->cab_queue, 0,
-				   &cfg, wdg_timeout);
-	}
-
 	/* must be set before quota calculations */
 	mvmvif->ap_ibss_active = true;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 4afd52f8d9c3..40fb64ead469 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1780,6 +1780,7 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	struct iwl_mvm_int_sta *bsta = &mvmvif->bcast_sta;
 	static const u8 _baddr[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
 	const u8 *baddr = _baddr;
+	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -1795,19 +1796,16 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 			iwl_mvm_get_wd_timeout(mvm, vif, false, false);
 		int queue;
 
-		if ((vif->type == NL80211_IFTYPE_AP) &&
-		    (mvmvif->bcast_sta.tfd_queue_msk &
-		     BIT(IWL_MVM_DQA_AP_PROBE_RESP_QUEUE)))
+		if (vif->type == NL80211_IFTYPE_AP)
 			queue = IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
-		else if ((vif->type == NL80211_IFTYPE_P2P_DEVICE) &&
-			 (mvmvif->bcast_sta.tfd_queue_msk &
-			  BIT(IWL_MVM_DQA_P2P_DEVICE_QUEUE)))
+		else if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
 			queue = IWL_MVM_DQA_P2P_DEVICE_QUEUE;
-		else if (WARN(1, "Missed required TXQ for adding bcast STA\n"))
+		else if (WARN(1, "Missing required TXQ for adding bcast STA\n"))
 			return -EINVAL;
 
 		iwl_mvm_enable_txq(mvm, queue, vif->hw_queue[0], 0, &cfg,
 				   wdg_timeout);
+		bsta->tfd_queue_msk |= BIT(queue);
 	}
 
 	if (vif->type == NL80211_IFTYPE_ADHOC)
@@ -1816,8 +1814,67 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	if (WARN_ON_ONCE(bsta->sta_id == IWL_MVM_STATION_COUNT))
 		return -ENOSPC;
 
-	return iwl_mvm_add_int_sta_common(mvm, bsta, baddr,
-					  mvmvif->id, mvmvif->color);
+	ret = iwl_mvm_add_int_sta_common(mvm, bsta, baddr,
+					 mvmvif->id, mvmvif->color);
+	if (ret)
+		return ret;
+
+	/*
+	 * In AP vif type, we also need to enable the cab_queue. However, we
+	 * have to enable it after the ADD_STA command is sent, otherwise the
+	 * FW will throw an assert once we send the ADD_STA command (it'll
+	 * detect a mismatch in the tfd_queue_msk, as we can't add the
+	 * enabled-cab_queue to the mask)
+	 */
+	if (iwl_mvm_is_dqa_supported(mvm) &&
+	    vif->type == NL80211_IFTYPE_AP) {
+		struct iwl_trans_txq_scd_cfg cfg = {
+			.fifo = IWL_MVM_TX_FIFO_MCAST,
+			.sta_id = mvmvif->bcast_sta.sta_id,
+			.tid = IWL_MAX_TID_COUNT,
+			.aggregate = false,
+			.frame_limit = IWL_FRAME_LIMIT,
+		};
+		unsigned int wdg_timeout =
+			iwl_mvm_get_wd_timeout(mvm, vif, false, false);
+
+		iwl_mvm_enable_txq(mvm, vif->cab_queue, vif->cab_queue,
+				   0, &cfg, wdg_timeout);
+	}
+
+	return 0;
+}
+
+static void iwl_mvm_free_bcast_sta_queues(struct iwl_mvm *mvm,
+					  struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	lockdep_assert_held(&mvm->mutex);
+
+	if (vif->type == NL80211_IFTYPE_AP)
+		iwl_mvm_disable_txq(mvm, vif->cab_queue, vif->cab_queue,
+				    IWL_MAX_TID_COUNT, 0);
+
+	if (mvmvif->bcast_sta.tfd_queue_msk &
+	    BIT(IWL_MVM_DQA_AP_PROBE_RESP_QUEUE)) {
+		iwl_mvm_disable_txq(mvm,
+				    IWL_MVM_DQA_AP_PROBE_RESP_QUEUE,
+				    vif->hw_queue[0], IWL_MAX_TID_COUNT,
+				    0);
+		mvmvif->bcast_sta.tfd_queue_msk &=
+			~BIT(IWL_MVM_DQA_AP_PROBE_RESP_QUEUE);
+	}
+
+	if (mvmvif->bcast_sta.tfd_queue_msk &
+	    BIT(IWL_MVM_DQA_P2P_DEVICE_QUEUE)) {
+		iwl_mvm_disable_txq(mvm,
+				    IWL_MVM_DQA_P2P_DEVICE_QUEUE,
+				    vif->hw_queue[0], IWL_MAX_TID_COUNT,
+				    0);
+		mvmvif->bcast_sta.tfd_queue_msk &=
+			~BIT(IWL_MVM_DQA_P2P_DEVICE_QUEUE);
+	}
 }
 
 /* Send the FW a request to remove the station from it's internal data
@@ -1829,6 +1886,9 @@ int iwl_mvm_send_rm_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (iwl_mvm_is_dqa_supported(mvm))
+		iwl_mvm_free_bcast_sta_queues(mvm, vif);
+
 	ret = iwl_mvm_rm_sta_common(mvm, mvmvif->bcast_sta.sta_id);
 	if (ret)
 		IWL_WARN(mvm, "Failed sending remove station\n");
@@ -1842,22 +1902,16 @@ int iwl_mvm_alloc_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (!iwl_mvm_is_dqa_supported(mvm))
+	if (!iwl_mvm_is_dqa_supported(mvm)) {
 		qmask = iwl_mvm_mac_get_queues_mask(vif);
 
-	if (vif->type == NL80211_IFTYPE_AP) {
 		/*
 		 * The firmware defines the TFD queue mask to only be relevant
 		 * for *unicast* queues, so the multicast (CAB) queue shouldn't
-		 * be included.
+		 * be included. This only happens in NL80211_IFTYPE_AP vif type,
+		 * so the next line will only have an effect there.
 		 */
 		qmask &= ~BIT(vif->cab_queue);
-
-		if (iwl_mvm_is_dqa_supported(mvm))
-			qmask |= BIT(IWL_MVM_DQA_AP_PROBE_RESP_QUEUE);
-	} else if (iwl_mvm_is_dqa_supported(mvm) &&
-		   vif->type == NL80211_IFTYPE_P2P_DEVICE) {
-		qmask |= BIT(IWL_MVM_DQA_P2P_DEVICE_QUEUE);
 	}
 
 	return iwl_mvm_allocate_int_sta(mvm, &mvmvif->bcast_sta, qmask,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index eb3434c0d148..dedea96a8e0f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -655,8 +655,8 @@ void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 	/* Make sure this TID isn't already enabled */
 	if (mvm->queue_info[queue].tid_bitmap & BIT(cfg->tid)) {
 		spin_unlock_bh(&mvm->queue_info_lock);
-		IWL_ERR(mvm, "Trying to enable TXQ with existing TID %d\n",
-			cfg->tid);
+		IWL_ERR(mvm, "Trying to enable TXQ %d with existing TID %d\n",
+			queue, cfg->tid);
 		return;
 	}
 
-- 
2.11.0
