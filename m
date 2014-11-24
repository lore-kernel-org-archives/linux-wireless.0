Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:63569 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbaKXOgT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:19 -0500
Received: by mail-wg0-f51.google.com with SMTP id k14so12245274wgh.38
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:18 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 46/75] iwlwifi: mvm: use private TFD queues for TDLS stations
Date: Mon, 24 Nov 2014 16:34:22 +0200
Message-Id: <1416839691-28533-46-git-send-email-egrumbach@gmail.com> (sfid-20141124_153853_734966_160AB6EF)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

When adding a TDLS station, allocate 4 new queues for it. Configure them
to FW and enable them. On station removal, drain the queues if needed
and disable them when empty.

Make sure to flush all packets in the private queues of TDLS stations in
the mac80211 flush() callback.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 28 ++++++---
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  1 +
 drivers/net/wireless/iwlwifi/mvm/sta.c      | 94 +++++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/sta.h      |  2 +
 drivers/net/wireless/iwlwifi/mvm/tx.c       |  7 +++
 5 files changed, 121 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 3883a86..64e89e8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -876,6 +876,7 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 	iwl_mvm_reset_phy_ctxts(mvm);
 	memset(mvm->fw_key_table, 0, sizeof(mvm->fw_key_table));
 	memset(mvm->sta_drained, 0, sizeof(mvm->sta_drained));
+	memset(mvm->tfd_drained, 0, sizeof(mvm->tfd_drained));
 	memset(&mvm->last_bt_notif, 0, sizeof(mvm->last_bt_notif));
 	memset(&mvm->last_bt_notif_old, 0, sizeof(mvm->last_bt_notif_old));
 	memset(&mvm->last_bt_ci_cmd, 0, sizeof(mvm->last_bt_ci_cmd));
@@ -3113,31 +3114,44 @@ static void iwl_mvm_mac_flush(struct ieee80211_hw *hw,
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	struct iwl_mvm_vif *mvmvif;
 	struct iwl_mvm_sta *mvmsta;
+	struct ieee80211_sta *sta;
+	int i;
+	u32 msk = 0;
 
 	if (!vif || vif->type != NL80211_IFTYPE_STATION)
 		return;
 
 	mutex_lock(&mvm->mutex);
 	mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	mvmsta = iwl_mvm_sta_from_staid_protected(mvm, mvmvif->ap_sta_id);
 
-	if (WARN_ON_ONCE(!mvmsta)) {
-		mutex_unlock(&mvm->mutex);
-		return;
+	/* flush the AP-station and all TDLS peers */
+	for (i = 0; i < IWL_MVM_STATION_COUNT; i++) {
+		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[i],
+						lockdep_is_held(&mvm->mutex));
+		if (IS_ERR_OR_NULL(sta))
+			continue;
+
+		mvmsta = iwl_mvm_sta_from_mac80211(sta);
+		if (mvmsta->vif != vif)
+			continue;
+
+		/* make sure only TDLS peers or the AP are flushed */
+		WARN_ON(i != mvmvif->ap_sta_id && !sta->tdls);
+
+		msk |= mvmsta->tfd_queue_msk;
 	}
 
 	if (drop) {
-		if (iwl_mvm_flush_tx_path(mvm, mvmsta->tfd_queue_msk, true))
+		if (iwl_mvm_flush_tx_path(mvm, msk, true))
 			IWL_ERR(mvm, "flush request fail\n");
 		mutex_unlock(&mvm->mutex);
 	} else {
-		u32 tfd_queue_msk = mvmsta->tfd_queue_msk;
 		mutex_unlock(&mvm->mutex);
 
 		/* this can take a while, and we may need/want other operations
 		 * to succeed while doing this, so do it without the mutex held
 		 */
-		iwl_trans_wait_tx_queue_empty(mvm->trans, tfd_queue_msk);
+		iwl_trans_wait_tx_queue_empty(mvm->trans, msk);
 	}
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 363be83..63d2d45 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -578,6 +578,7 @@ struct iwl_mvm {
 	struct work_struct sta_drained_wk;
 	unsigned long sta_drained[BITS_TO_LONGS(IWL_MVM_STATION_COUNT)];
 	atomic_t pending_frames[IWL_MVM_STATION_COUNT];
+	u32 tfd_drained[IWL_MVM_STATION_COUNT];
 	u8 rx_ba_sessions;
 
 	/* configured by mac80211 */
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 0eb8505..15afa9a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -204,6 +204,56 @@ int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	return ret;
 }
 
+static int iwl_mvm_tdls_sta_init(struct iwl_mvm *mvm,
+				 struct ieee80211_sta *sta)
+{
+	unsigned long used_hw_queues;
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	u32 ac;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	used_hw_queues = iwl_mvm_get_used_hw_queues(mvm, NULL);
+
+	/* Find available queues, and allocate them to the ACs */
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		u8 queue = find_first_zero_bit(&used_hw_queues,
+					       mvm->first_agg_queue);
+
+		if (queue >= mvm->first_agg_queue) {
+			IWL_ERR(mvm, "Failed to allocate STA queue\n");
+			return -EBUSY;
+		}
+
+		__set_bit(queue, &used_hw_queues);
+		mvmsta->hw_queue[ac] = queue;
+	}
+
+	/* Found a place for all queues - enable them */
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		iwl_mvm_enable_ac_txq(mvm, mvmsta->hw_queue[ac],
+				      iwl_mvm_ac_to_tx_fifo[ac]);
+		mvmsta->tfd_queue_msk |= BIT(mvmsta->hw_queue[ac]);
+	}
+
+	return 0;
+}
+
+static void iwl_mvm_tdls_sta_deinit(struct iwl_mvm *mvm,
+				    struct ieee80211_sta *sta)
+{
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	unsigned long sta_msk;
+	int i;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	/* disable the TDLS STA-specific queues */
+	sta_msk = mvmsta->tfd_queue_msk;
+	for_each_set_bit(i, &sta_msk, sizeof(sta_msk))
+		iwl_mvm_disable_txq(mvm, i);
+}
+
 int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 		    struct ieee80211_vif *vif,
 		    struct ieee80211_sta *sta)
@@ -237,9 +287,17 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 	atomic_set(&mvm->pending_frames[sta_id], 0);
 	mvm_sta->tid_disable_agg = 0;
 	mvm_sta->tfd_queue_msk = 0;
-	for (i = 0; i < IEEE80211_NUM_ACS; i++)
-		if (vif->hw_queue[i] != IEEE80211_INVAL_HW_QUEUE)
-			mvm_sta->tfd_queue_msk |= BIT(vif->hw_queue[i]);
+
+	/* allocate new queues for a TDLS station */
+	if (sta->tdls) {
+		ret = iwl_mvm_tdls_sta_init(mvm, sta);
+		if (ret)
+			return ret;
+	} else {
+		for (i = 0; i < IEEE80211_NUM_ACS; i++)
+			if (vif->hw_queue[i] != IEEE80211_INVAL_HW_QUEUE)
+				mvm_sta->tfd_queue_msk |= BIT(vif->hw_queue[i]);
+	}
 
 	/* for HW restart - reset everything but the sequence number */
 	for (i = 0; i < IWL_MAX_TID_COUNT; i++) {
@@ -251,7 +309,7 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 
 	ret = iwl_mvm_sta_send_to_fw(mvm, sta, false);
 	if (ret)
-		return ret;
+		goto err;
 
 	if (vif->type == NL80211_IFTYPE_STATION) {
 		if (!sta->tdls) {
@@ -265,6 +323,10 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 	rcu_assign_pointer(mvm->fw_id_to_mac_id[sta_id], sta);
 
 	return 0;
+
+err:
+	iwl_mvm_tdls_sta_deinit(mvm, sta);
+	return ret;
 }
 
 int iwl_mvm_update_sta(struct iwl_mvm *mvm,
@@ -398,6 +460,17 @@ void iwl_mvm_sta_drained_wk(struct work_struct *wk)
 		}
 		RCU_INIT_POINTER(mvm->fw_id_to_mac_id[sta_id], NULL);
 		clear_bit(sta_id, mvm->sta_drained);
+
+		if (mvm->tfd_drained[sta_id]) {
+			unsigned long i, msk = mvm->tfd_drained[sta_id];
+
+			for_each_set_bit(i, &msk, sizeof(msk))
+				iwl_mvm_disable_txq(mvm, i);
+
+			mvm->tfd_drained[sta_id] = 0;
+			IWL_DEBUG_TDLS(mvm, "Drained sta %d, with queues %ld\n",
+				       sta_id, msk);
+		}
 	}
 
 	mutex_unlock(&mvm->mutex);
@@ -443,9 +516,22 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 		rcu_assign_pointer(mvm->fw_id_to_mac_id[mvm_sta->sta_id],
 				   ERR_PTR(-EBUSY));
 		spin_unlock_bh(&mvm_sta->lock);
+
+		/* disable TDLS sta queues on drain complete */
+		if (sta->tdls) {
+			mvm->tfd_drained[mvm_sta->sta_id] =
+							mvm_sta->tfd_queue_msk;
+			IWL_DEBUG_TDLS(mvm, "Draining TDLS sta %d\n",
+				       mvm_sta->sta_id);
+		}
+
 		ret = iwl_mvm_drain_sta(mvm, mvm_sta, true);
 	} else {
 		spin_unlock_bh(&mvm_sta->lock);
+
+		if (sta->tdls)
+			iwl_mvm_tdls_sta_deinit(mvm, sta);
+
 		ret = iwl_mvm_rm_sta_common(mvm, mvm_sta->sta_id);
 		RCU_INIT_POINTER(mvm->fw_id_to_mac_id[mvm_sta->sta_id], NULL);
 	}
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.h b/drivers/net/wireless/iwlwifi/mvm/sta.h
index 84f37ca..2c869bc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.h
@@ -288,6 +288,7 @@ static inline u16 iwl_mvm_tid_queued(struct iwl_mvm_tid_data *tid_data)
  * struct iwl_mvm_sta - representation of a station in the driver
  * @sta_id: the index of the station in the fw (will be replaced by id_n_color)
  * @tfd_queue_msk: the tfd queues used by the station
+ * @hw_queue: per-AC mapping of the TFD queues used by station
  * @mac_id_n_color: the MAC context this station is linked to
  * @tid_disable_agg: bitmap: if bit(tid) is set, the fw won't send ampdus for
  *	tid.
@@ -311,6 +312,7 @@ static inline u16 iwl_mvm_tid_queued(struct iwl_mvm_tid_data *tid_data)
 struct iwl_mvm_sta {
 	u32 sta_id;
 	u32 tfd_queue_msk;
+	u8 hw_queue[IEEE80211_NUM_ACS];
 	u32 mac_id_n_color;
 	u16 tid_disable_agg;
 	u8 max_agg_bufsize;
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index b54708e..4f15d9d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -424,6 +424,13 @@ int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	WARN_ON_ONCE(info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM);
 
+	if (sta->tdls) {
+		/* default to TID 0 for non-QoS packets */
+		u8 tdls_tid = tid == IWL_MAX_TID_COUNT ? 0 : tid;
+
+		txq_id = mvmsta->hw_queue[tid_to_mac80211_ac[tdls_tid]];
+	}
+
 	if (is_ampdu) {
 		if (WARN_ON_ONCE(mvmsta->tid_data[tid].state != IWL_AGG_ON))
 			goto drop_unlock_sta;
-- 
1.9.1

