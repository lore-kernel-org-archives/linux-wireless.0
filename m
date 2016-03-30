Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:24696 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbcC3OGC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:02 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/43] iwlwifi: mvm: support bss dynamic alloc/dealloc of queues
Date: Wed, 30 Mar 2016 17:04:51 +0300
Message-Id: <1459346715-7954-19-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160613_492569_EA5C8AD6)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

"DQA" is shorthand for "dynamic queue allocation". This
enables on-demand allocation of queues per RA/TID rather than
statically allocating per vif, thus allowing a potential
benefit of various factors.

Please refer to the DOC section this patch adds to sta.h to
see a more in-depth explanation of this feature.

There are many things to take into consideration when working
in DQA mode, and this patch is only one in a series. Note that
default operation mode is non-DQA mode, unless the FW
indicates that it supports DQA mode.

This patch enables support of DQA for a station connected to
an AP, and works in a non-aggregated mode.

When a frame for an unused RA/TID arrives at the driver, it
isn't TXed immediately, but deferred first until a suitable
queue is first allocated for it, and then TXed by a worker
that both allocates the queues and TXes deferred traffic.

When a STA is removed, its queues goes back into the queue
pools for reuse as needed.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h   |  22 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  21 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  49 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |   7 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 254 +++++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h      |  87 +++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       |  54 +++++
 9 files changed, 481 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index c1a3131..e3561bb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -723,7 +723,7 @@ static int iwl_mvm_d3_reprogram(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		return -EIO;
 	}
 
-	ret = iwl_mvm_sta_send_to_fw(mvm, ap_sta, false);
+	ret = iwl_mvm_sta_send_to_fw(mvm, ap_sta, false, 0);
 	if (ret)
 		return ret;
 	rcu_assign_pointer(mvm->fw_id_to_mac_id[mvmvif->ap_sta_id], ap_sta);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index e6bd0c8..8217eb2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -80,12 +80,32 @@
 #include "fw-api-stats.h"
 #include "fw-api-tof.h"
 
-/* Tx queue numbers */
+/* Tx queue numbers for non-DQA mode */
 enum {
 	IWL_MVM_OFFCHANNEL_QUEUE = 8,
 	IWL_MVM_CMD_QUEUE = 9,
 };
 
+/*
+ * DQA queue numbers
+ *
+ * @IWL_MVM_DQA_MIN_MGMT_QUEUE: first TXQ in pool for MGMT and non-QOS frames.
+ *	Each MGMT queue is mapped to a single STA
+ *	MGMT frames are frames that return true on ieee80211_is_mgmt()
+ * @IWL_MVM_DQA_MAX_MGMT_QUEUE: last TXQ in pool for MGMT frames
+ * @IWL_MVM_DQA_MIN_DATA_QUEUE: first TXQ in pool for DATA frames.
+ *	DATA frames are intended for !ieee80211_is_mgmt() frames, but if
+ *	the MGMT TXQ pool is exhausted, mgmt frames can be sent on DATA queues
+ *	as well
+ * @IWL_MVM_DQA_MAX_DATA_QUEUE: last TXQ in pool for DATA frames
+ */
+enum iwl_mvm_dqa_txq {
+	IWL_MVM_DQA_MIN_MGMT_QUEUE = 5,
+	IWL_MVM_DQA_MAX_MGMT_QUEUE = 8,
+	IWL_MVM_DQA_MIN_DATA_QUEUE = 10,
+	IWL_MVM_DQA_MAX_DATA_QUEUE = 31,
+};
+
 enum iwl_mvm_tx_fifo {
 	IWL_MVM_TX_FIFO_BK = 0,
 	IWL_MVM_TX_FIFO_BE,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index e885db3..c02c105 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -425,12 +425,17 @@ static int iwl_mvm_mac_ctxt_allocate_resources(struct iwl_mvm *mvm,
 		return 0;
 	}
 
-	/* Find available queues, and allocate them to the ACs */
+	/*
+	 * Find available queues, and allocate them to the ACs. When in
+	 * DQA-mode they aren't really used, and this is done only so the
+	 * mac80211 ieee80211_check_queues() function won't fail
+	 */
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		u8 queue = find_first_zero_bit(&used_hw_queues,
 					       mvm->first_agg_queue);
 
-		if (queue >= mvm->first_agg_queue) {
+		if (!iwl_mvm_is_dqa_supported(mvm) &&
+		    queue >= mvm->first_agg_queue) {
 			IWL_ERR(mvm, "Failed to allocate queue\n");
 			ret = -EIO;
 			goto exit_fail;
@@ -495,6 +500,10 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 				      IWL_MVM_TX_FIFO_MCAST, 0, wdg_timeout);
 		/* fall through */
 	default:
+		/* If DQA is supported - queues will be enabled when needed */
+		if (iwl_mvm_is_dqa_supported(mvm))
+			break;
+
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
 			iwl_mvm_enable_ac_txq(mvm, vif->hw_queue[ac],
 					      vif->hw_queue[ac],
@@ -523,6 +532,14 @@ void iwl_mvm_mac_ctxt_release(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 				    IWL_MAX_TID_COUNT, 0);
 		/* fall through */
 	default:
+		/*
+		 * If DQA is supported - queues were already disabled, since in
+		 * DQA-mode the queues are a property of the STA and not of the
+		 * vif, and at this point the STA was already deleted
+		 */
+		if (iwl_mvm_is_dqa_supported(mvm))
+			break;
+
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
 			iwl_mvm_disable_txq(mvm, vif->hw_queue[ac],
 					    vif->hw_queue[ac],
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 1a3481b..115d7aa 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -992,6 +992,7 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 	iwl_mvm_reset_phy_ctxts(mvm);
 	memset(mvm->fw_key_table, 0, sizeof(mvm->fw_key_table));
 	memset(mvm->sta_drained, 0, sizeof(mvm->sta_drained));
+	memset(mvm->sta_deferred_frames, 0, sizeof(mvm->sta_deferred_frames));
 	memset(mvm->tfd_drained, 0, sizeof(mvm->tfd_drained));
 	memset(&mvm->last_bt_notif, 0, sizeof(mvm->last_bt_notif));
 	memset(&mvm->last_bt_notif_old, 0, sizeof(mvm->last_bt_notif_old));
@@ -1178,6 +1179,7 @@ static void iwl_mvm_mac_stop(struct ieee80211_hw *hw)
 
 	flush_work(&mvm->d0i3_exit_work);
 	flush_work(&mvm->async_handlers_wk);
+	flush_work(&mvm->add_stream_wk);
 	cancel_delayed_work_sync(&mvm->fw_dump_wk);
 	iwl_mvm_free_fw_dump_desc(mvm);
 
@@ -2382,6 +2384,22 @@ iwl_mvm_tdls_check_trigger(struct iwl_mvm *mvm,
 				    peer_addr, action);
 }
 
+static void iwl_mvm_purge_deferred_tx_frames(struct iwl_mvm *mvm,
+					     struct iwl_mvm_sta *mvm_sta)
+{
+	struct iwl_mvm_tid_data *tid_data;
+	struct sk_buff *skb;
+	int i;
+
+	spin_lock_bh(&mvm_sta->lock);
+	for (i = 0; i <= IWL_MAX_TID_COUNT; i++) {
+		tid_data = &mvm_sta->tid_data[i];
+		while ((skb = __skb_dequeue(&tid_data->deferred_tx_frames)))
+			ieee80211_free_txskb(mvm->hw, skb);
+	}
+	spin_unlock_bh(&mvm_sta->lock);
+}
+
 static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_sta *sta,
@@ -2402,6 +2420,33 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 	/* if a STA is being removed, reuse its ID */
 	flush_work(&mvm->sta_drained_wk);
 
+	/*
+	 * If we are in a STA removal flow and in DQA mode:
+	 *
+	 * This is after the sync_rcu part, so the queues have already been
+	 * flushed. No more TXs on their way in mac80211's path, and no more in
+	 * the queues.
+	 * Also, we won't be getting any new TX frames for this station.
+	 * What we might have are deferred TX frames that need to be taken care
+	 * of.
+	 *
+	 * Drop any still-queued deferred-frame before removing the STA, and
+	 * make sure the worker is no longer handling frames for this STA.
+	 */
+	if (old_state == IEEE80211_STA_NONE &&
+	    new_state == IEEE80211_STA_NOTEXIST &&
+	    iwl_mvm_is_dqa_supported(mvm)) {
+		struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
+
+		iwl_mvm_purge_deferred_tx_frames(mvm, mvm_sta);
+		flush_work(&mvm->add_stream_wk);
+
+		/*
+		 * No need to make sure deferred TX indication is off since the
+		 * worker will already remove it if it was on
+		 */
+	}
+
 	mutex_lock(&mvm->mutex);
 	if (old_state == IEEE80211_STA_NOTEXIST &&
 	    new_state == IEEE80211_STA_NONE) {
@@ -3738,6 +3783,10 @@ static void iwl_mvm_mac_flush(struct ieee80211_hw *hw,
 	if (!vif || vif->type != NL80211_IFTYPE_STATION)
 		return;
 
+	/* Make sure we're done with the deferred traffic before flushing */
+	if (iwl_mvm_is_dqa_supported(mvm))
+		flush_work(&mvm->add_stream_wk);
+
 	mutex_lock(&mvm->mutex);
 	mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 02ef1d9..f9430ee 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -665,10 +665,16 @@ struct iwl_mvm {
 		/* Map to HW queue */
 		u32 hw_queue_to_mac80211;
 		u8 hw_queue_refcount;
+		/*
+		 * This is to mark that queue is reserved for a STA but not yet
+		 * allocated. This is needed to make sure we have at least one
+		 * available queue to use when adding a new STA
+		 */
 		bool setup_reserved;
 		u16 tid_bitmap; /* Bitmap of the TIDs mapped to this queue */
 	} queue_info[IWL_MAX_HW_QUEUES];
 	spinlock_t queue_info_lock; /* For syncing queue mgmt operations */
+	struct work_struct add_stream_wk; /* To add streams to queues */
 	atomic_t mac80211_queue_stop_count[IEEE80211_MAX_QUEUES];
 
 	const char *nvm_file_name;
@@ -688,6 +694,7 @@ struct iwl_mvm {
 	struct iwl_rx_phy_info last_phy_info;
 	struct ieee80211_sta __rcu *fw_id_to_mac_id[IWL_MVM_STATION_COUNT];
 	struct work_struct sta_drained_wk;
+	unsigned long sta_deferred_frames[BITS_TO_LONGS(IWL_MVM_STATION_COUNT)];
 	unsigned long sta_drained[BITS_TO_LONGS(IWL_MVM_STATION_COUNT)];
 	atomic_t pending_frames[IWL_MVM_STATION_COUNT];
 	u32 tfd_drained[IWL_MVM_STATION_COUNT];
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index d4b71a7..9fc705c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -579,6 +579,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	INIT_WORK(&mvm->d0i3_exit_work, iwl_mvm_d0i3_exit_work);
 	INIT_DELAYED_WORK(&mvm->fw_dump_wk, iwl_mvm_fw_error_dump_wk);
 	INIT_DELAYED_WORK(&mvm->tdls_cs.dwork, iwl_mvm_tdls_ch_switch_work);
+	INIT_WORK(&mvm->add_stream_wk, iwl_mvm_add_new_dqa_stream_wk);
 
 	spin_lock_init(&mvm->d0i3_tx_lock);
 	spin_lock_init(&mvm->refs_lock);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index ef99942..3f36a66 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -111,7 +111,7 @@ static int iwl_mvm_find_free_sta_id(struct iwl_mvm *mvm,
 
 /* send station add/update command to firmware */
 int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			   bool update)
+			   bool update, unsigned int flags)
 {
 	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_add_sta_cmd add_sta_cmd = {
@@ -126,9 +126,12 @@ int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	u32 status;
 	u32 agg_size = 0, mpdu_dens = 0;
 
-	if (!update) {
+	if (!update || (flags & STA_MODIFY_QUEUES)) {
 		add_sta_cmd.tfd_queue_msk = cpu_to_le32(mvm_sta->tfd_queue_msk);
 		memcpy(&add_sta_cmd.addr, sta->addr, ETH_ALEN);
+
+		if (flags & STA_MODIFY_QUEUES)
+			add_sta_cmd.modify_mask |= STA_MODIFY_QUEUES;
 	}
 
 	switch (sta->bandwidth) {
@@ -274,6 +277,204 @@ static void iwl_mvm_tdls_sta_deinit(struct iwl_mvm *mvm,
 		iwl_mvm_disable_txq(mvm, i, i, IWL_MAX_TID_COUNT, 0);
 }
 
+static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
+				   struct ieee80211_sta *sta, u8 ac, int tid,
+				   struct ieee80211_hdr *hdr)
+{
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	struct iwl_trans_txq_scd_cfg cfg = {
+		.fifo = iwl_mvm_ac_to_tx_fifo[ac],
+		.sta_id = mvmsta->sta_id,
+		.tid = tid,
+		.frame_limit = IWL_FRAME_LIMIT,
+	};
+	unsigned int wdg_timeout =
+		iwl_mvm_get_wd_timeout(mvm, mvmsta->vif, false, false);
+	u8 mac_queue = mvmsta->vif->hw_queue[ac];
+	int queue = -1;
+	int ssn;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	spin_lock(&mvm->queue_info_lock);
+
+	/*
+	 * Non-QoS, QoS NDP and MGMT frames should go to a MGMT queue, if one
+	 * exists
+	 */
+	if (!ieee80211_is_data_qos(hdr->frame_control) ||
+	    ieee80211_is_qos_nullfunc(hdr->frame_control)) {
+		queue = iwl_mvm_find_free_queue(mvm, IWL_MVM_DQA_MIN_MGMT_QUEUE,
+						IWL_MVM_DQA_MAX_MGMT_QUEUE);
+		if (queue >= IWL_MVM_DQA_MIN_MGMT_QUEUE)
+			IWL_DEBUG_TX_QUEUES(mvm, "Found free MGMT queue #%d\n",
+					    queue);
+
+		/* If no such queue is found, we'll use a DATA queue instead */
+	}
+
+	if (queue < 0 && mvmsta->reserved_queue != IEEE80211_INVAL_HW_QUEUE) {
+		queue = mvmsta->reserved_queue;
+		IWL_DEBUG_TX_QUEUES(mvm, "Using reserved queue #%d\n", queue);
+	}
+
+	if (queue < 0)
+		queue = iwl_mvm_find_free_queue(mvm, IWL_MVM_DQA_MIN_DATA_QUEUE,
+						IWL_MVM_DQA_MAX_DATA_QUEUE);
+	if (queue >= 0)
+		mvm->queue_info[queue].setup_reserved = false;
+
+	spin_unlock(&mvm->queue_info_lock);
+
+	/* TODO: support shared queues for same RA */
+	if (queue < 0)
+		return -ENOSPC;
+
+	/*
+	 * Actual en/disablement of aggregations is through the ADD_STA HCMD,
+	 * but for configuring the SCD to send A-MPDUs we need to mark the queue
+	 * as aggregatable.
+	 * Mark all DATA queues as allowing to be aggregated at some point
+	 */
+	cfg.aggregate = (queue >= IWL_MVM_DQA_MIN_DATA_QUEUE);
+
+	IWL_DEBUG_TX_QUEUES(mvm, "Allocating queue #%d to sta %d on tid %d\n",
+			    queue, mvmsta->sta_id, tid);
+
+	ssn = IEEE80211_SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
+	iwl_mvm_enable_txq(mvm, queue, mac_queue, ssn, &cfg,
+			   wdg_timeout);
+
+	spin_lock_bh(&mvmsta->lock);
+	mvmsta->tid_data[tid].txq_id = queue;
+	mvmsta->tfd_queue_msk |= BIT(queue);
+
+	if (mvmsta->reserved_queue == queue)
+		mvmsta->reserved_queue = IEEE80211_INVAL_HW_QUEUE;
+	spin_unlock_bh(&mvmsta->lock);
+
+	return iwl_mvm_sta_send_to_fw(mvm, sta, true, STA_MODIFY_QUEUES);
+}
+
+static inline u8 iwl_mvm_tid_to_ac_queue(int tid)
+{
+	if (tid == IWL_MAX_TID_COUNT)
+		return IEEE80211_AC_VO; /* MGMT */
+
+	return tid_to_mac80211_ac[tid];
+}
+
+static void iwl_mvm_tx_deferred_stream(struct iwl_mvm *mvm,
+				       struct ieee80211_sta *sta, int tid)
+{
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	struct iwl_mvm_tid_data *tid_data = &mvmsta->tid_data[tid];
+	struct sk_buff *skb;
+	struct ieee80211_hdr *hdr;
+	struct sk_buff_head deferred_tx;
+	u8 mac_queue;
+	bool no_queue = false; /* Marks if there is a problem with the queue */
+	u8 ac;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	skb = skb_peek(&tid_data->deferred_tx_frames);
+	if (!skb)
+		return;
+	hdr = (void *)skb->data;
+
+	ac = iwl_mvm_tid_to_ac_queue(tid);
+	mac_queue = IEEE80211_SKB_CB(skb)->hw_queue;
+
+	if (tid_data->txq_id == IEEE80211_INVAL_HW_QUEUE &&
+	    iwl_mvm_sta_alloc_queue(mvm, sta, ac, tid, hdr)) {
+		IWL_ERR(mvm,
+			"Can't alloc TXQ for sta %d tid %d - dropping frame\n",
+			mvmsta->sta_id, tid);
+
+		/*
+		 * Mark queue as problematic so later the deferred traffic is
+		 * freed, as we can do nothing with it
+		 */
+		no_queue = true;
+	}
+
+	__skb_queue_head_init(&deferred_tx);
+
+	spin_lock(&mvmsta->lock);
+	skb_queue_splice_init(&tid_data->deferred_tx_frames, &deferred_tx);
+	spin_unlock(&mvmsta->lock);
+
+	/* Disable bottom-halves when entering TX path */
+	local_bh_disable();
+	while ((skb = __skb_dequeue(&deferred_tx)))
+		if (no_queue || iwl_mvm_tx_skb(mvm, skb, sta))
+			ieee80211_free_txskb(mvm->hw, skb);
+	local_bh_enable();
+
+	/* Wake queue */
+	iwl_mvm_start_mac_queues(mvm, BIT(mac_queue));
+}
+
+void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk)
+{
+	struct iwl_mvm *mvm = container_of(wk, struct iwl_mvm,
+					   add_stream_wk);
+	struct ieee80211_sta *sta;
+	struct iwl_mvm_sta *mvmsta;
+	unsigned long deferred_tid_traffic;
+	int sta_id, tid;
+
+	mutex_lock(&mvm->mutex);
+
+	/* Go over all stations with deferred traffic */
+	for_each_set_bit(sta_id, mvm->sta_deferred_frames,
+			 IWL_MVM_STATION_COUNT) {
+		clear_bit(sta_id, mvm->sta_deferred_frames);
+		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[sta_id],
+						lockdep_is_held(&mvm->mutex));
+		if (IS_ERR_OR_NULL(sta))
+			continue;
+
+		mvmsta = iwl_mvm_sta_from_mac80211(sta);
+		deferred_tid_traffic = mvmsta->deferred_traffic_tid_map;
+
+		for_each_set_bit(tid, &deferred_tid_traffic,
+				 IWL_MAX_TID_COUNT + 1)
+			iwl_mvm_tx_deferred_stream(mvm, sta, tid);
+	}
+
+	mutex_unlock(&mvm->mutex);
+}
+
+static int iwl_mvm_reserve_sta_stream(struct iwl_mvm *mvm,
+				      struct ieee80211_sta *sta)
+{
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	int queue;
+
+	spin_lock_bh(&mvm->queue_info_lock);
+
+	/* Make sure we have free resources for this STA */
+	queue = iwl_mvm_find_free_queue(mvm, IWL_MVM_DQA_MIN_DATA_QUEUE,
+					IWL_MVM_DQA_MAX_DATA_QUEUE);
+	if (queue < 0) {
+		spin_unlock_bh(&mvm->queue_info_lock);
+		IWL_ERR(mvm, "No available queues for new station\n");
+		return -ENOSPC;
+	}
+	mvm->queue_info[queue].setup_reserved = true;
+
+	spin_unlock_bh(&mvm->queue_info_lock);
+
+	mvmsta->reserved_queue = queue;
+
+	IWL_DEBUG_TX_QUEUES(mvm, "Reserving data queue #%d for sta_id %d\n",
+			    queue, mvmsta->sta_id);
+
+	return 0;
+}
+
 int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 		    struct ieee80211_vif *vif,
 		    struct ieee80211_sta *sta)
@@ -314,18 +515,29 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 		ret = iwl_mvm_tdls_sta_init(mvm, sta);
 		if (ret)
 			return ret;
-	} else {
+	} else if (!iwl_mvm_is_dqa_supported(mvm)) {
 		for (i = 0; i < IEEE80211_NUM_ACS; i++)
 			if (vif->hw_queue[i] != IEEE80211_INVAL_HW_QUEUE)
 				mvm_sta->tfd_queue_msk |= BIT(vif->hw_queue[i]);
 	}
 
 	/* for HW restart - reset everything but the sequence number */
-	for (i = 0; i < IWL_MAX_TID_COUNT; i++) {
+	for (i = 0; i <= IWL_MAX_TID_COUNT; i++) {
 		u16 seq = mvm_sta->tid_data[i].seq_number;
 		memset(&mvm_sta->tid_data[i], 0, sizeof(mvm_sta->tid_data[i]));
 		mvm_sta->tid_data[i].seq_number = seq;
+
+		if (!iwl_mvm_is_dqa_supported(mvm))
+			continue;
+
+		/*
+		 * Mark all queues for this STA as unallocated and defer TX
+		 * frames until the queue is allocated
+		 */
+		mvm_sta->tid_data[i].txq_id = IEEE80211_INVAL_HW_QUEUE;
+		skb_queue_head_init(&mvm_sta->tid_data[i].deferred_tx_frames);
 	}
+	mvm_sta->deferred_traffic_tid_map = 0;
 	mvm_sta->agg_tids = 0;
 
 	if (iwl_mvm_has_new_rx_api(mvm) &&
@@ -338,7 +550,13 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 		mvm_sta->dup_data = dup_data;
 	}
 
-	ret = iwl_mvm_sta_send_to_fw(mvm, sta, false);
+	if (iwl_mvm_is_dqa_supported(mvm)) {
+		ret = iwl_mvm_reserve_sta_stream(mvm, sta);
+		if (ret)
+			goto err;
+	}
+
+	ret = iwl_mvm_sta_send_to_fw(mvm, sta, false, 0);
 	if (ret)
 		goto err;
 
@@ -364,7 +582,7 @@ int iwl_mvm_update_sta(struct iwl_mvm *mvm,
 		       struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta)
 {
-	return iwl_mvm_sta_send_to_fw(mvm, sta, true);
+	return iwl_mvm_sta_send_to_fw(mvm, sta, true, 0);
 }
 
 int iwl_mvm_drain_sta(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
@@ -509,6 +727,26 @@ void iwl_mvm_sta_drained_wk(struct work_struct *wk)
 	mutex_unlock(&mvm->mutex);
 }
 
+static void iwl_mvm_disable_sta_queues(struct iwl_mvm *mvm,
+				       struct ieee80211_vif *vif,
+				       struct iwl_mvm_sta *mvm_sta)
+{
+	int ac;
+	int i;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	for (i = 0; i < ARRAY_SIZE(mvm_sta->tid_data); i++) {
+		if (mvm_sta->tid_data[i].txq_id == IEEE80211_INVAL_HW_QUEUE)
+			continue;
+
+		ac = iwl_mvm_tid_to_ac_queue(i);
+		iwl_mvm_disable_txq(mvm, mvm_sta->tid_data[i].txq_id,
+				    vif->hw_queue[ac], i, 0);
+		mvm_sta->tid_data[i].txq_id = IEEE80211_INVAL_HW_QUEUE;
+	}
+}
+
 int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 		   struct ieee80211_vif *vif,
 		   struct ieee80211_sta *sta)
@@ -537,6 +775,10 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 			return ret;
 		ret = iwl_mvm_drain_sta(mvm, mvm_sta, false);
 
+		/* If DQA is supported - the queues can be disabled now */
+		if (iwl_mvm_is_dqa_supported(mvm))
+			iwl_mvm_disable_sta_queues(mvm, vif, mvm_sta);
+
 		/* if we are associated - we can't remove the AP STA now */
 		if (vif->bss_conf.assoc)
 			return ret;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index 1a8f69a..e3efdcd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
- * Copyright(c) 2015        Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -34,7 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
- * Copyright(c) 2015        Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -80,6 +80,60 @@ struct iwl_mvm;
 struct iwl_mvm_vif;
 
 /**
+ * DOC: DQA - Dynamic Queue Allocation -introduction
+ *
+ * Dynamic Queue Allocation (AKA "DQA") is a feature implemented in iwlwifi
+ * driver to allow dynamic allocation of queues on-demand, rather than allocate
+ * them statically ahead of time. Ideally, we would like to allocate one queue
+ * per RA/TID, thus allowing an AP - for example - to send BE traffic to STA2
+ * even if it also needs to send traffic to a sleeping STA1, without being
+ * blocked by the sleeping station.
+ *
+ * Although the queues in DQA mode are dynamically allocated, there are still
+ * some queues that are statically allocated:
+ *	TXQ #0 - command queue
+ *	TXQ #1 - aux frames
+ *	TXQ #2 - P2P device frames
+ *	TXQ #3 - P2P GO/SoftAP GCAST/BCAST frames
+ *	TXQ #4 - BSS DATA frames queue
+ *	TXQ #5-8 - Non-QoS and MGMT frames queue pool
+ *	TXQ #9 - P2P GO/SoftAP probe responses
+ *	TXQ #10-31 - DATA frames queue pool
+ * The queues are dynamically taken from either the MGMT frames queue pool or
+ * the DATA frames one. See the %iwl_mvm_dqa_txq for more information on every
+ * queue.
+ *
+ * When a frame for a previously unseen RA/TID comes in, it needs to be deferred
+ * until a queue is allocated for it, and only then can be TXed. Therefore, it
+ * is placed into %iwl_mvm_tid_data.deferred_tx_frames, and a worker called
+ * %mvm->add_stream_wk later allocates the queues and TXes the deferred frames.
+ *
+ * For convenience, MGMT is considered as if it has TID=8, and go to the MGMT
+ * queues in the pool. If there is no longer a free MGMT queue to allocate, a
+ * queue will be allocated from the DATA pool instead. Since QoS NDPs can create
+ * a problem for aggregations, they too will use a MGMT queue.
+ *
+ * When adding a STA, a DATA queue is reserved for it so that it can TX from
+ * it. If no such free queue exists for reserving, the STA addition will fail.
+ *
+ * If the DATA queue pool gets exhausted, no new STA will be accepted, and if a
+ * new RA/TID comes in for an existing STA, one of the STA's queues will become
+ * shared and will serve more than the single TID (but always for the same RA!).
+ *
+ * When a RA/TID needs to become aggregated, no new queue is required to be
+ * allocated, only mark the queue as aggregated via the ADD_STA command. Note,
+ * however, that a shared queue cannot be aggregated, and only after the other
+ * TIDs become inactive and are removed - only then can the queue be
+ * reconfigured and become aggregated.
+ *
+ * When removing a station, its queues are returned to the pool for reuse. Here
+ * we also need to make sure that we are synced with the worker thread that TXes
+ * the deferred frames so we don't get into a situation where the queues are
+ * removed and then the worker puts deferred frames onto the released queues or
+ * tries to allocate new queues for a STA we don't need anymore.
+ */
+
+/**
  * DOC: station table - introduction
  *
  * The station table is a list of data structure that reprensent the stations.
@@ -253,6 +307,7 @@ enum iwl_mvm_agg_state {
 
 /**
  * struct iwl_mvm_tid_data - holds the states for each RA / TID
+ * @deferred_tx_frames: deferred TX frames for this RA/TID
  * @seq_number: the next WiFi sequence number to use
  * @next_reclaimed: the WiFi sequence number of the next packet to be acked.
  *	This is basically (last acked packet++).
@@ -260,7 +315,7 @@ enum iwl_mvm_agg_state {
  *	Tx response (TX_CMD), and the block ack notification (COMPRESSED_BA).
  * @amsdu_in_ampdu_allowed: true if A-MSDU in A-MPDU is allowed.
  * @state: state of the BA agreement establishment / tear down.
- * @txq_id: Tx queue used by the BA session
+ * @txq_id: Tx queue used by the BA session / DQA
  * @ssn: the first packet to be sent in AGG HW queue in Tx AGG start flow, or
  *	the first packet to be sent in legacy HW queue in Tx AGG stop flow.
  *	Basically when next_reclaimed reaches ssn, we can tell mac80211 that
@@ -268,6 +323,7 @@ enum iwl_mvm_agg_state {
  * @tx_time: medium time consumed by this A-MPDU
  */
 struct iwl_mvm_tid_data {
+	struct sk_buff_head deferred_tx_frames;
 	u16 seq_number;
 	u16 next_reclaimed;
 	/* The rest is Tx AGG related */
@@ -316,7 +372,10 @@ struct iwl_mvm_rxq_dup_data {
  *	we need to signal the EOSP
  * @lock: lock to protect the whole struct. Since %tid_data is access from Tx
  * and from Tx response flow, it needs a spinlock.
- * @tid_data: per tid data. Look at %iwl_mvm_tid_data.
+ * @tid_data: per tid data + mgmt. Look at %iwl_mvm_tid_data.
+ * @reserved_queue: the queue reserved for this STA for DQA purposes
+ *	Every STA has is given one reserved queue to allow it to operate. If no
+ *	such queue can be guaranteed, the STA addition will fail.
  * @tx_protection: reference counter for controlling the Tx protection.
  * @tt_tx_protection: is thermal throttling enable Tx protection?
  * @disable_tx: is tx to this STA disabled?
@@ -329,6 +388,7 @@ struct iwl_mvm_rxq_dup_data {
  *	the BA window. To be used for UAPSD only.
  * @ptk_pn: per-queue PTK PN data structures
  * @dup_data: per queue duplicate packet detection data
+ * @deferred_traffic_tid_map: indication bitmap of deferred traffic per-TID
  *
  * When mac80211 creates a station it reserves some space (hw->sta_data_size)
  * in the structure for use by driver. This structure is placed in that
@@ -345,12 +405,16 @@ struct iwl_mvm_sta {
 	bool bt_reduced_txpower;
 	bool next_status_eosp;
 	spinlock_t lock;
-	struct iwl_mvm_tid_data tid_data[IWL_MAX_TID_COUNT];
+	struct iwl_mvm_tid_data tid_data[IWL_MAX_TID_COUNT + 1];
 	struct iwl_lq_sta lq_sta;
 	struct ieee80211_vif *vif;
 	struct iwl_mvm_key_pn __rcu *ptk_pn[4];
 	struct iwl_mvm_rxq_dup_data *dup_data;
 
+	u16 deferred_traffic_tid_map;
+
+	u8 reserved_queue;
+
 	/* Temporary, until the new TLC will control the Tx protection */
 	s8 tx_protection;
 	bool tt_tx_protection;
@@ -378,8 +442,18 @@ struct iwl_mvm_int_sta {
 	u32 tfd_queue_msk;
 };
 
+/**
+ * Send the STA info to the FW.
+ *
+ * @mvm: the iwl_mvm* to use
+ * @sta: the STA
+ * @update: this is true if the FW is being updated about a STA it already knows
+ *	about. Otherwise (if this is a new STA), this should be false.
+ * @flags: if update==true, this marks what is being changed via ORs of values
+ *	from enum iwl_sta_modify_flag. Otherwise, this is ignored.
+ */
 int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			   bool update);
+			   bool update, unsigned int flags);
 int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 		    struct ieee80211_vif *vif,
 		    struct ieee80211_sta *sta);
@@ -459,5 +533,6 @@ void iwl_mvm_modify_all_sta_disable_tx(struct iwl_mvm *mvm,
 				       struct iwl_mvm_vif *mvmvif,
 				       bool disable);
 void iwl_mvm_csa_client_absent(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk);
 
 #endif /* __sta_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index c7c3d7b..24cff98 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -639,6 +639,35 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 }
 #endif
 
+static void iwl_mvm_tx_add_stream(struct iwl_mvm *mvm,
+				  struct iwl_mvm_sta *mvm_sta, u8 tid,
+				  struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	u8 mac_queue = info->hw_queue;
+	struct sk_buff_head *deferred_tx_frames;
+
+	lockdep_assert_held(&mvm_sta->lock);
+
+	mvm_sta->deferred_traffic_tid_map |= BIT(tid);
+	set_bit(mvm_sta->sta_id, mvm->sta_deferred_frames);
+
+	deferred_tx_frames = &mvm_sta->tid_data[tid].deferred_tx_frames;
+
+	skb_queue_tail(deferred_tx_frames, skb);
+
+	/*
+	 * The first deferred frame should've stopped the MAC queues, so we
+	 * should never get a second deferred frame for the RA/TID.
+	 */
+	if (!WARN(skb_queue_len(deferred_tx_frames) != 1,
+		  "RATID %d/%d has %d deferred frames\n", mvm_sta->sta_id, tid,
+		  skb_queue_len(deferred_tx_frames))) {
+		iwl_mvm_stop_mac_queues(mvm, BIT(mac_queue));
+		schedule_work(&mvm->add_stream_wk);
+	}
+}
+
 /*
  * Sets the fields in the Tx cmd that are crypto related
  */
@@ -695,6 +724,14 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
 		hdr->seq_ctrl |= cpu_to_le16(seq_number);
 		is_ampdu = info->flags & IEEE80211_TX_CTL_AMPDU;
+	} else if (iwl_mvm_is_dqa_supported(mvm) &&
+		   (ieee80211_is_qos_nullfunc(fc) ||
+		    ieee80211_is_nullfunc(fc))) {
+		/*
+		 * nullfunc frames should go to the MGMT queue regardless of QOS
+		 */
+		tid = IWL_MAX_TID_COUNT;
+		txq_id = mvmsta->tid_data[tid].txq_id;
 	}
 
 	/* Copy MAC header from skb into command buffer */
@@ -715,6 +752,23 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 		txq_id = mvmsta->tid_data[tid].txq_id;
 	}
 
+	if (iwl_mvm_is_dqa_supported(mvm)) {
+		if (unlikely(mvmsta->tid_data[tid].txq_id ==
+			     IEEE80211_INVAL_HW_QUEUE)) {
+			iwl_mvm_tx_add_stream(mvm, mvmsta, tid, skb);
+
+			/*
+			 * The frame is now deferred, and the worker scheduled
+			 * will re-allocate it, so we can free it for now.
+			 */
+			iwl_trans_free_tx_cmd(mvm->trans, dev_cmd);
+			spin_unlock(&mvmsta->lock);
+			return 0;
+		}
+
+		txq_id = mvmsta->tid_data[tid].txq_id;
+	}
+
 	IWL_DEBUG_TX(mvm, "TX to [%d|%d] Q:%d - seq: 0x%x\n", mvmsta->sta_id,
 		     tid, txq_id, IEEE80211_SEQ_TO_SN(seq_number));
 
-- 
2.5.0

