Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57201 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752472AbbJEPBq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 11:01:46 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:46 +0300
Message-Id: <1444055820-27506-15-git-send-email-luca@coelho.fi> (sfid-20151005_170150_663982_894CD2C1)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 15/29] iwlwifi: mvm: support using multiple ACs on single HW queue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

"DQA" is shorthand for "dynamic queue allocation", with the
idea of allocating queues per-RA/TID on-demand rather than
using shared queues statically allocated per vif. The goal
of this is to enable future features (like GO PM) and to
improve performance measurements of TX traffic.

When RA/TID streams can't be neatly sorted into different AC
queues, DQA allows sharing queues for the same RA. This means
that DQA allows different ACs may reach the same HW queue.

Update the code to allow such queue sharing by having a mapping
between the HW queue and the mac80211 queues using it (as this
could be more than one queue).

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c       |   8 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c |  15 ++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  40 +++++---
 drivers/net/wireless/iwlwifi/mvm/ops.c      |  51 ++++++----
 drivers/net/wireless/iwlwifi/mvm/sta.c      |  71 +++++++++-----
 drivers/net/wireless/iwlwifi/mvm/tx.c       |  11 +--
 drivers/net/wireless/iwlwifi/mvm/utils.c    | 142 ++++++++++++++++++++++++----
 7 files changed, 249 insertions(+), 89 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 248b025..834641e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -616,12 +616,8 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	 * will be empty.
 	 */
 
-	for (i = 0; i < IWL_MAX_HW_QUEUES; i++) {
-		if (i < mvm->first_agg_queue && i != IWL_MVM_CMD_QUEUE)
-			mvm->queue_to_mac80211[i] = i;
-		else
-			mvm->queue_to_mac80211[i] = IWL_INVALID_MAC80211_QUEUE;
-	}
+	memset(&mvm->queue_info, 0, sizeof(mvm->queue_info));
+	mvm->queue_info[IWL_MVM_CMD_QUEUE].hw_queue_refcount = 1;
 
 	for (i = 0; i < IEEE80211_MAX_QUEUES; i++)
 		atomic_set(&mvm->mac80211_queue_stop_count[i], 0);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 3615650..d2a221d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -486,15 +486,17 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	switch (vif->type) {
 	case NL80211_IFTYPE_P2P_DEVICE:
 		iwl_mvm_enable_ac_txq(mvm, IWL_MVM_OFFCHANNEL_QUEUE,
+				      IWL_MVM_OFFCHANNEL_QUEUE,
 				      IWL_MVM_TX_FIFO_VO, wdg_timeout);
 		break;
 	case NL80211_IFTYPE_AP:
-		iwl_mvm_enable_ac_txq(mvm, vif->cab_queue,
+		iwl_mvm_enable_ac_txq(mvm, vif->cab_queue, vif->cab_queue,
 				      IWL_MVM_TX_FIFO_MCAST, wdg_timeout);
 		/* fall through */
 	default:
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
 			iwl_mvm_enable_ac_txq(mvm, vif->hw_queue[ac],
+					      vif->hw_queue[ac],
 					      iwl_mvm_ac_to_tx_fifo[ac],
 					      wdg_timeout);
 		break;
@@ -511,14 +513,19 @@ void iwl_mvm_mac_ctxt_release(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_P2P_DEVICE:
-		iwl_mvm_disable_txq(mvm, IWL_MVM_OFFCHANNEL_QUEUE, 0);
+		iwl_mvm_disable_txq(mvm, IWL_MVM_OFFCHANNEL_QUEUE,
+				    IWL_MVM_OFFCHANNEL_QUEUE, IWL_MAX_TID_COUNT,
+				    0);
 		break;
 	case NL80211_IFTYPE_AP:
-		iwl_mvm_disable_txq(mvm, vif->cab_queue, 0);
+		iwl_mvm_disable_txq(mvm, vif->cab_queue, vif->cab_queue,
+				    IWL_MAX_TID_COUNT, 0);
 		/* fall through */
 	default:
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-			iwl_mvm_disable_txq(mvm, vif->hw_queue[ac], 0);
+			iwl_mvm_disable_txq(mvm, vif->hw_queue[ac],
+					    vif->hw_queue[ac],
+					    IWL_MAX_TID_COUNT, 0);
 	}
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 5e02736..a7a9619 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -82,7 +82,6 @@
 #include "constants.h"
 #include "tof.h"
 
-#define IWL_INVALID_MAC80211_QUEUE	0xff
 #define IWL_MVM_MAX_ADDRESSES		5
 /* RSSI offset for WkP */
 #define IWL_RSSI_OFFSET 50
@@ -605,7 +604,14 @@ struct iwl_mvm {
 		u64 on_time_scan;
 	} radio_stats, accu_radio_stats;
 
-	u8 queue_to_mac80211[IWL_MAX_HW_QUEUES];
+	struct {
+		/* Map to HW queue */
+		u32 hw_queue_to_mac80211;
+		u8 hw_queue_refcount;
+		bool setup_reserved;
+		u16 tid_bitmap; /* Bitmap of the TIDs mapped to this queue */
+	} queue_info[IWL_MAX_HW_QUEUES];
+	spinlock_t queue_info_lock; /* For syncing queue mgmt operations */
 	atomic_t mac80211_queue_stop_count[IEEE80211_MAX_QUEUES];
 
 	const char *nvm_file_name;
@@ -910,6 +916,12 @@ static inline bool iwl_mvm_is_d0i3_supported(struct iwl_mvm *mvm)
 			   IWL_UCODE_TLV_CAPA_D0I3_SUPPORT);
 }
 
+static inline bool iwl_mvm_is_dqa_supported(struct iwl_mvm *mvm)
+{
+	return fw_has_capa(&mvm->fw->ucode_capa,
+			   IWL_UCODE_TLV_CAPA_DQA_SUPPORT);
+}
+
 static inline bool iwl_mvm_is_lar_supported(struct iwl_mvm *mvm)
 {
 	bool nvm_lar = mvm->nvm_data->lar_enabled;
@@ -1341,13 +1353,19 @@ static inline bool iwl_mvm_vif_low_latency(struct iwl_mvm_vif *mvmvif)
 }
 
 /* hw scheduler queue config */
-void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, u16 ssn,
-			const struct iwl_trans_txq_scd_cfg *cfg,
+void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
+			u16 ssn, const struct iwl_trans_txq_scd_cfg *cfg,
 			unsigned int wdg_timeout);
-void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, u8 flags);
+/*
+ * Disable a TXQ.
+ * Note that in non-DQA mode the %mac80211_queue and %tid params are ignored.
+ */
+void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
+			 u8 tid, u8 flags);
+int iwl_mvm_find_free_queue(struct iwl_mvm *mvm, u8 minq, u8 maxq);
 
 static inline
-void iwl_mvm_enable_ac_txq(struct iwl_mvm *mvm, int queue,
+void iwl_mvm_enable_ac_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 			   u8 fifo, unsigned int wdg_timeout)
 {
 	struct iwl_trans_txq_scd_cfg cfg = {
@@ -1357,13 +1375,13 @@ void iwl_mvm_enable_ac_txq(struct iwl_mvm *mvm, int queue,
 		.frame_limit = IWL_FRAME_LIMIT,
 	};
 
-	iwl_mvm_enable_txq(mvm, queue, 0, &cfg, wdg_timeout);
+	iwl_mvm_enable_txq(mvm, queue, mac80211_queue, 0, &cfg, wdg_timeout);
 }
 
 static inline void iwl_mvm_enable_agg_txq(struct iwl_mvm *mvm, int queue,
-					  int fifo, int sta_id, int tid,
-					  int frame_limit, u16 ssn,
-					  unsigned int wdg_timeout)
+					  int mac80211_queue, int fifo,
+					  int sta_id, int tid, int frame_limit,
+					  u16 ssn, unsigned int wdg_timeout)
 {
 	struct iwl_trans_txq_scd_cfg cfg = {
 		.fifo = fifo,
@@ -1373,7 +1391,7 @@ static inline void iwl_mvm_enable_agg_txq(struct iwl_mvm *mvm, int queue,
 		.aggregate = true,
 	};
 
-	iwl_mvm_enable_txq(mvm, queue, ssn, &cfg, wdg_timeout);
+	iwl_mvm_enable_txq(mvm, queue, mac80211_queue, ssn, &cfg, wdg_timeout);
 }
 
 /* Thermal management and CT-kill */
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 1c38e45..0e8166f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -453,6 +453,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	INIT_LIST_HEAD(&mvm->aux_roc_te_list);
 	INIT_LIST_HEAD(&mvm->async_handlers_list);
 	spin_lock_init(&mvm->time_event_lock);
+	spin_lock_init(&mvm->queue_info_lock);
 
 	INIT_WORK(&mvm->async_handlers_wk, iwl_mvm_async_handlers_wk);
 	INIT_WORK(&mvm->roc_done_wk, iwl_mvm_roc_done_wk);
@@ -775,37 +776,51 @@ static void iwl_mvm_rx_dispatch(struct iwl_op_mode *op_mode,
 static void iwl_mvm_stop_sw_queue(struct iwl_op_mode *op_mode, int queue)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
-	int mq = mvm->queue_to_mac80211[queue];
+	unsigned long mq;
+	int q;
 
-	if (WARN_ON_ONCE(mq == IWL_INVALID_MAC80211_QUEUE))
-		return;
+	spin_lock_bh(&mvm->queue_info_lock);
+	mq = mvm->queue_info[queue].hw_queue_to_mac80211;
+	spin_unlock_bh(&mvm->queue_info_lock);
 
-	if (atomic_inc_return(&mvm->mac80211_queue_stop_count[mq]) > 1) {
-		IWL_DEBUG_TX_QUEUES(mvm,
-				    "queue %d (mac80211 %d) already stopped\n",
-				    queue, mq);
+	if (WARN_ON_ONCE(!mq))
 		return;
-	}
 
-	ieee80211_stop_queue(mvm->hw, mq);
+	for_each_set_bit(q, &mq, IEEE80211_MAX_QUEUES) {
+		if (atomic_inc_return(&mvm->mac80211_queue_stop_count[q]) > 1) {
+			IWL_DEBUG_TX_QUEUES(mvm,
+					    "queue %d (mac80211 %d) already stopped\n",
+					    queue, q);
+			continue;
+		}
+
+		ieee80211_stop_queue(mvm->hw, q);
+	}
 }
 
 static void iwl_mvm_wake_sw_queue(struct iwl_op_mode *op_mode, int queue)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
-	int mq = mvm->queue_to_mac80211[queue];
+	unsigned long mq;
+	int q;
 
-	if (WARN_ON_ONCE(mq == IWL_INVALID_MAC80211_QUEUE))
-		return;
+	spin_lock_bh(&mvm->queue_info_lock);
+	mq = mvm->queue_info[queue].hw_queue_to_mac80211;
+	spin_unlock_bh(&mvm->queue_info_lock);
 
-	if (atomic_dec_return(&mvm->mac80211_queue_stop_count[mq]) > 0) {
-		IWL_DEBUG_TX_QUEUES(mvm,
-				    "queue %d (mac80211 %d) still stopped\n",
-				    queue, mq);
+	if (WARN_ON_ONCE(!mq))
 		return;
-	}
 
-	ieee80211_wake_queue(mvm->hw, mq);
+	for_each_set_bit(q, &mq, IEEE80211_MAX_QUEUES) {
+		if (atomic_dec_return(&mvm->mac80211_queue_stop_count[q]) > 0) {
+			IWL_DEBUG_TX_QUEUES(mvm,
+					    "queue %d (mac80211 %d) still stopped\n",
+					    queue, q);
+			continue;
+		}
+
+		ieee80211_wake_queue(mvm->hw, q);
+	}
 }
 
 void iwl_mvm_set_hw_ctkill_state(struct iwl_mvm *mvm, bool state)
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 4967990..9bda6c9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -234,6 +234,7 @@ static int iwl_mvm_tdls_sta_init(struct iwl_mvm *mvm,
 	/* Found a place for all queues - enable them */
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		iwl_mvm_enable_ac_txq(mvm, mvmsta->hw_queue[ac],
+				      mvmsta->hw_queue[ac],
 				      iwl_mvm_ac_to_tx_fifo[ac], wdg_timeout);
 		mvmsta->tfd_queue_msk |= BIT(mvmsta->hw_queue[ac]);
 	}
@@ -253,7 +254,7 @@ static void iwl_mvm_tdls_sta_deinit(struct iwl_mvm *mvm,
 	/* disable the TDLS STA-specific queues */
 	sta_msk = mvmsta->tfd_queue_msk;
 	for_each_set_bit(i, &sta_msk, sizeof(sta_msk) * BITS_PER_BYTE)
-		iwl_mvm_disable_txq(mvm, i, 0);
+		iwl_mvm_disable_txq(mvm, i, i, 0, 0);
 }
 
 int iwl_mvm_add_sta(struct iwl_mvm *mvm,
@@ -472,7 +473,7 @@ void iwl_mvm_sta_drained_wk(struct work_struct *wk)
 			unsigned long i, msk = mvm->tfd_drained[sta_id];
 
 			for_each_set_bit(i, &msk, sizeof(msk) * BITS_PER_BYTE)
-				iwl_mvm_disable_txq(mvm, i, 0);
+				iwl_mvm_disable_txq(mvm, i, i, 0, 0);
 
 			mvm->tfd_drained[sta_id] = 0;
 			IWL_DEBUG_TDLS(mvm, "Drained sta %d, with queues %ld\n",
@@ -651,7 +652,7 @@ int iwl_mvm_add_aux_sta(struct iwl_mvm *mvm)
 	lockdep_assert_held(&mvm->mutex);
 
 	/* Map Aux queue to fifo - needs to happen before adding Aux station */
-	iwl_mvm_enable_ac_txq(mvm, mvm->aux_queue,
+	iwl_mvm_enable_ac_txq(mvm, mvm->aux_queue, mvm->aux_queue,
 			      IWL_MVM_TX_FIFO_MCAST, wdg_timeout);
 
 	/* Allocate aux station and assign to it the aux queue */
@@ -923,6 +924,7 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_tid_data *tid_data;
 	int txq_id;
+	int ret;
 
 	if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
 		return -EINVAL;
@@ -935,17 +937,6 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	lockdep_assert_held(&mvm->mutex);
 
-	for (txq_id = mvm->first_agg_queue;
-	     txq_id <= mvm->last_agg_queue; txq_id++)
-		if (mvm->queue_to_mac80211[txq_id] ==
-		    IWL_INVALID_MAC80211_QUEUE)
-			break;
-
-	if (txq_id > mvm->last_agg_queue) {
-		IWL_ERR(mvm, "Failed to allocate agg queue\n");
-		return -EIO;
-	}
-
 	spin_lock_bh(&mvmsta->lock);
 
 	/* possible race condition - we entered D0i3 while starting agg */
@@ -955,8 +946,18 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		return -EIO;
 	}
 
-	/* the new tx queue is still connected to the same mac80211 queue */
-	mvm->queue_to_mac80211[txq_id] = vif->hw_queue[tid_to_mac80211_ac[tid]];
+	spin_lock_bh(&mvm->queue_info_lock);
+
+	txq_id = iwl_mvm_find_free_queue(mvm, mvm->first_agg_queue,
+					 mvm->last_agg_queue);
+	if (txq_id < 0) {
+		ret = txq_id;
+		spin_unlock_bh(&mvm->queue_info_lock);
+		IWL_ERR(mvm, "Failed to allocate agg queue\n");
+		goto release_locks;
+	}
+	mvm->queue_info[txq_id].setup_reserved = true;
+	spin_unlock_bh(&mvm->queue_info_lock);
 
 	tid_data = &mvmsta->tid_data[tid];
 	tid_data->ssn = IEEE80211_SEQ_TO_SN(tid_data->seq_number);
@@ -975,9 +976,12 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		tid_data->state = IWL_EMPTYING_HW_QUEUE_ADDBA;
 	}
 
+	ret = 0;
+
+release_locks:
 	spin_unlock_bh(&mvmsta->lock);
 
-	return 0;
+	return ret;
 }
 
 int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
@@ -1005,13 +1009,19 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	fifo = iwl_mvm_ac_to_tx_fifo[tid_to_mac80211_ac[tid]];
 
-	iwl_mvm_enable_agg_txq(mvm, queue, fifo, mvmsta->sta_id, tid,
-			       buf_size, ssn, wdg_timeout);
+	iwl_mvm_enable_agg_txq(mvm, queue,
+			       vif->hw_queue[tid_to_mac80211_ac[tid]], fifo,
+			       mvmsta->sta_id, tid, buf_size, ssn, wdg_timeout);
 
 	ret = iwl_mvm_sta_tx_agg(mvm, sta, tid, queue, true);
 	if (ret)
 		return -EIO;
 
+	/* No need to mark as reserved */
+	spin_lock_bh(&mvm->queue_info_lock);
+	mvm->queue_info[queue].setup_reserved = false;
+	spin_unlock_bh(&mvm->queue_info_lock);
+
 	/*
 	 * Even though in theory the peer could have different
 	 * aggregation reorder buffer sizes for different sessions,
@@ -1056,6 +1066,11 @@ int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	mvmsta->agg_tids &= ~BIT(tid);
 
+	/* No need to mark as reserved anymore */
+	spin_lock_bh(&mvm->queue_info_lock);
+	mvm->queue_info[txq_id].setup_reserved = false;
+	spin_unlock_bh(&mvm->queue_info_lock);
+
 	switch (tid_data->state) {
 	case IWL_AGG_ON:
 		tid_data->ssn = IEEE80211_SEQ_TO_SN(tid_data->seq_number);
@@ -1073,14 +1088,15 @@ int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 		tid_data->ssn = 0xffff;
 		tid_data->state = IWL_AGG_OFF;
-		mvm->queue_to_mac80211[txq_id] = IWL_INVALID_MAC80211_QUEUE;
 		spin_unlock_bh(&mvmsta->lock);
 
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 
 		iwl_mvm_sta_tx_agg(mvm, sta, tid, txq_id, false);
 
-		iwl_mvm_disable_txq(mvm, txq_id, 0);
+		iwl_mvm_disable_txq(mvm, txq_id,
+				    vif->hw_queue[tid_to_mac80211_ac[tid]], tid,
+				    0);
 		return 0;
 	case IWL_AGG_STARTING:
 	case IWL_EMPTYING_HW_QUEUE_ADDBA:
@@ -1091,7 +1107,6 @@ int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 		/* No barriers since we are under mutex */
 		lockdep_assert_held(&mvm->mutex);
-		mvm->queue_to_mac80211[txq_id] = IWL_INVALID_MAC80211_QUEUE;
 
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		tid_data->state = IWL_AGG_OFF;
@@ -1132,6 +1147,11 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	mvmsta->agg_tids &= ~BIT(tid);
 	spin_unlock_bh(&mvmsta->lock);
 
+	/* No need to mark as reserved */
+	spin_lock_bh(&mvm->queue_info_lock);
+	mvm->queue_info[txq_id].setup_reserved = false;
+	spin_unlock_bh(&mvm->queue_info_lock);
+
 	if (old_state >= IWL_AGG_ON) {
 		iwl_mvm_drain_sta(mvm, mvmsta, true);
 		if (iwl_mvm_flush_tx_path(mvm, BIT(txq_id), true))
@@ -1142,12 +1162,11 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 		iwl_mvm_sta_tx_agg(mvm, sta, tid, txq_id, false);
 
-		iwl_mvm_disable_txq(mvm, tid_data->txq_id, 0);
+		iwl_mvm_disable_txq(mvm, tid_data->txq_id,
+				    vif->hw_queue[tid_to_mac80211_ac[tid]], tid,
+				    0);
 	}
 
-	mvm->queue_to_mac80211[tid_data->txq_id] =
-				IWL_INVALID_MAC80211_QUEUE;
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 6df5aad..ff8b9bd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -560,15 +560,10 @@ static void iwl_mvm_check_ratid_empty(struct iwl_mvm *mvm,
 		IWL_DEBUG_TX_QUEUES(mvm,
 				    "Can continue DELBA flow ssn = next_recl = %d\n",
 				    tid_data->next_reclaimed);
-		iwl_mvm_disable_txq(mvm, tid_data->txq_id, CMD_ASYNC);
+		iwl_mvm_disable_txq(mvm, tid_data->txq_id,
+				    vif->hw_queue[tid_to_mac80211_ac[tid]], tid,
+				    CMD_ASYNC);
 		tid_data->state = IWL_AGG_OFF;
-		/*
-		 * we can't hold the mutex - but since we are after a sequence
-		 * point (call to iwl_mvm_disable_txq(), so we don't even need
-		 * a memory barrier.
-		 */
-		mvm->queue_to_mac80211[tid_data->txq_id] =
-					IWL_INVALID_MAC80211_QUEUE;
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 06cba97..ad0f169 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright (C) 2015 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -657,34 +658,143 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 	if (mvm->support_umac_log)
 		iwl_mvm_dump_umac_error_log(mvm);
 }
-void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, u16 ssn,
-			const struct iwl_trans_txq_scd_cfg *cfg,
+
+int iwl_mvm_find_free_queue(struct iwl_mvm *mvm, u8 minq, u8 maxq)
+{
+	int i;
+
+	lockdep_assert_held(&mvm->queue_info_lock);
+
+	for (i = minq; i <= maxq; i++)
+		if (mvm->queue_info[i].hw_queue_refcount == 0 &&
+		    !mvm->queue_info[i].setup_reserved)
+			return i;
+
+	return -ENOSPC;
+}
+
+void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
+			u16 ssn, const struct iwl_trans_txq_scd_cfg *cfg,
 			unsigned int wdg_timeout)
 {
-	struct iwl_scd_txq_cfg_cmd cmd = {
-		.scd_queue = queue,
-		.enable = 1,
-		.window = cfg->frame_limit,
-		.sta_id = cfg->sta_id,
-		.ssn = cpu_to_le16(ssn),
-		.tx_fifo = cfg->fifo,
-		.aggregate = cfg->aggregate,
-		.tid = cfg->tid,
-	};
+	bool enable_queue = true;
+
+	spin_lock_bh(&mvm->queue_info_lock);
+
+	/* Make sure this TID isn't already enabled */
+	if (mvm->queue_info[queue].tid_bitmap & BIT(cfg->tid)) {
+		spin_unlock_bh(&mvm->queue_info_lock);
+		IWL_ERR(mvm, "Trying to enable TXQ with existing TID %d\n",
+			cfg->tid);
+		return;
+	}
 
-	iwl_trans_txq_enable_cfg(mvm->trans, queue, ssn, NULL, wdg_timeout);
-	WARN(iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, 0, sizeof(cmd), &cmd),
-	     "Failed to configure queue %d on FIFO %d\n", queue, cfg->fifo);
+	/* Update mappings and refcounts */
+	mvm->queue_info[queue].hw_queue_to_mac80211 |= BIT(mac80211_queue);
+	mvm->queue_info[queue].hw_queue_refcount++;
+	if (mvm->queue_info[queue].hw_queue_refcount > 1)
+		enable_queue = false;
+	mvm->queue_info[queue].tid_bitmap |= BIT(cfg->tid);
+
+	IWL_DEBUG_TX_QUEUES(mvm,
+			    "Enabling TXQ #%d refcount=%d (mac80211 map:0x%x)\n",
+			    queue, mvm->queue_info[queue].hw_queue_refcount,
+			    mvm->queue_info[queue].hw_queue_to_mac80211);
+
+	spin_unlock_bh(&mvm->queue_info_lock);
+
+	/* Send the enabling command if we need to */
+	if (enable_queue) {
+		struct iwl_scd_txq_cfg_cmd cmd = {
+			.scd_queue = queue,
+			.enable = 1,
+			.window = cfg->frame_limit,
+			.sta_id = cfg->sta_id,
+			.ssn = cpu_to_le16(ssn),
+			.tx_fifo = cfg->fifo,
+			.aggregate = cfg->aggregate,
+			.tid = cfg->tid,
+		};
+
+		iwl_trans_txq_enable_cfg(mvm->trans, queue, ssn, NULL,
+					 wdg_timeout);
+		WARN(iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, 0, sizeof(cmd),
+					  &cmd),
+		     "Failed to configure queue %d on FIFO %d\n", queue,
+		     cfg->fifo);
+	}
 }
 
-void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, u8 flags)
+void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
+			 u8 tid, u8 flags)
 {
 	struct iwl_scd_txq_cfg_cmd cmd = {
 		.scd_queue = queue,
 		.enable = 0,
 	};
+	bool remove_mac_queue = true;
 	int ret;
 
+	spin_lock_bh(&mvm->queue_info_lock);
+
+	if (WARN_ON(mvm->queue_info[queue].hw_queue_refcount == 0)) {
+		spin_unlock_bh(&mvm->queue_info_lock);
+		return;
+	}
+
+	mvm->queue_info[queue].tid_bitmap &= ~BIT(tid);
+
+	/*
+	 * If there is another TID with the same AC - don't remove the MAC queue
+	 * from the mapping
+	 */
+	if (tid < IWL_MAX_TID_COUNT) {
+		unsigned long tid_bitmap =
+			mvm->queue_info[queue].tid_bitmap;
+		int ac = tid_to_mac80211_ac[tid];
+		int i;
+
+		for_each_set_bit(i, &tid_bitmap, IWL_MAX_TID_COUNT) {
+			if (tid_to_mac80211_ac[i] == ac)
+				remove_mac_queue = false;
+		}
+	}
+
+	if (remove_mac_queue)
+		mvm->queue_info[queue].hw_queue_to_mac80211 &=
+			~BIT(mac80211_queue);
+	mvm->queue_info[queue].hw_queue_refcount--;
+
+	cmd.enable = mvm->queue_info[queue].hw_queue_refcount ? 1 : 0;
+
+	IWL_DEBUG_TX_QUEUES(mvm,
+			    "Disabling TXQ #%d refcount=%d (mac80211 map:0x%x)\n",
+			    queue,
+			    mvm->queue_info[queue].hw_queue_refcount,
+			    mvm->queue_info[queue].hw_queue_to_mac80211);
+
+	/* If the queue is still enabled - nothing left to do in this func */
+	if (cmd.enable) {
+		spin_unlock_bh(&mvm->queue_info_lock);
+		return;
+	}
+
+	/* Make sure queue info is correct even though we overwrite it */
+	WARN(mvm->queue_info[queue].hw_queue_refcount ||
+	     mvm->queue_info[queue].tid_bitmap ||
+	     mvm->queue_info[queue].hw_queue_to_mac80211,
+	     "TXQ #%d info out-of-sync - refcount=%d, mac map=0x%x, tid=0x%x\n",
+	     queue, mvm->queue_info[queue].hw_queue_refcount,
+	     mvm->queue_info[queue].hw_queue_to_mac80211,
+	     mvm->queue_info[queue].tid_bitmap);
+
+	/* If we are here - the queue is freed and we can zero out these vals */
+	mvm->queue_info[queue].hw_queue_refcount = 0;
+	mvm->queue_info[queue].tid_bitmap = 0;
+	mvm->queue_info[queue].hw_queue_to_mac80211 = 0;
+
+	spin_unlock_bh(&mvm->queue_info_lock);
+
 	iwl_trans_txq_disable(mvm->trans, queue, false);
 	ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, flags,
 				   sizeof(cmd), &cmd);
-- 
2.5.3

