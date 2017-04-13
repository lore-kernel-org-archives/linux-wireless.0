Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51418 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754728AbdDMP0v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 11:26:51 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 13 Apr 2017 18:24:53 +0300
Message-Id: <20170413152507.9648-13-luca@coelho.fi> (sfid-20170413_172655_833513_33E4E15D)
In-Reply-To: <20170413152507.9648-1-luca@coelho.fi>
References: <20170413152507.9648-1-luca@coelho.fi>
Subject: [PATCH 12/26] iwlwifi: mvm: support a000 SCD queue configuration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

a000 devices queue management is going to change significantly.
We will have 512 queues. Those queues will be assigned number
by the firmware and not by the driver.

In addition, due to SN offload having TX queue shared between TIDs
is impossible

Also, the ADD_STA command no longer updates queues status.
The only point of changing queue in the SCD queue config API.

>From driver perspective we have here a new design:

Queue sharing and inactivity checks are disabled.

Once this is done, the only paths that call scd_queue_cfg command
are paths that alloc and release TX queues - which will make future
accommodation to queue number assignment by FW easier.
Since allocating 512 queues statically is not advisable, transport
will allocate the queue on demand, fill the command with DRAM data
and send it. This is reflected in the new transport API.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/fw-api-sta.h    |  5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 62 ++++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  3 ++
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     | 39 +++++++++++---
 4 files changed, 96 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
index cd5fdf83d040..4f8648f53879 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
@@ -351,7 +351,8 @@ struct iwl_mvm_add_sta_cmd_v7 {
  * @assoc_id: assoc_id to be sent in VHT PLCP (9-bit), for grp use 0, for AP
  *	mac-addr.
  * @beamform_flags: beam forming controls
- * @tfd_queue_msk: tfd queues used by this station
+ * @tfd_queue_msk: tfd queues used by this station.
+ *	Obselete for new TX API (9 and above).
  * @rx_ba_window: aggregation window size
  * @scd_queue_bank: queue bank in used. Each bank contains 32 queues. 0 means
  *	that the queues used by this station are in the first 32.
@@ -386,7 +387,7 @@ struct iwl_mvm_add_sta_cmd {
 	__le16 rx_ba_window;
 	u8 scd_queue_bank;
 	u8 uapsd_trigger_acs;
-} __packed; /* ADD_STA_CMD_API_S_VER_8 */
+} __packed; /* ADD_STA_CMD_API_S_VER_9 */
 
 /**
  * struct iwl_mvm_add_sta_key_common - add/modify sta key common part
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index d538ef0cfd4e..ffbfd34d8e92 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -127,11 +127,17 @@ int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	u32 agg_size = 0, mpdu_dens = 0;
 
 	if (!update || (flags & STA_MODIFY_QUEUES)) {
-		add_sta_cmd.tfd_queue_msk = cpu_to_le32(mvm_sta->tfd_queue_msk);
 		memcpy(&add_sta_cmd.addr, sta->addr, ETH_ALEN);
 
-		if (flags & STA_MODIFY_QUEUES)
-			add_sta_cmd.modify_mask |= STA_MODIFY_QUEUES;
+		if (!iwl_mvm_has_new_tx_api(mvm)) {
+			add_sta_cmd.tfd_queue_msk =
+				cpu_to_le32(mvm_sta->tfd_queue_msk);
+
+			if (flags & STA_MODIFY_QUEUES)
+				add_sta_cmd.modify_mask |= STA_MODIFY_QUEUES;
+		} else {
+			WARN_ON(flags & STA_MODIFY_QUEUES);
+		}
 	}
 
 	switch (sta->bandwidth) {
@@ -337,6 +343,9 @@ static int iwl_mvm_invalidate_sta_queue(struct iwl_mvm *mvm, int queue,
 	u8 sta_id;
 	int ret;
 
+	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
+		return -EINVAL;
+
 	spin_lock_bh(&mvm->queue_info_lock);
 	sta_id = mvm->queue_info[queue].ra_sta_id;
 	spin_unlock_bh(&mvm->queue_info_lock);
@@ -387,6 +396,9 @@ static int iwl_mvm_get_queue_agg_tids(struct iwl_mvm *mvm, int queue)
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
+		return -EINVAL;
+
 	spin_lock_bh(&mvm->queue_info_lock);
 	sta_id = mvm->queue_info[queue].ra_sta_id;
 	tid_bitmap = mvm->queue_info[queue].tid_bitmap;
@@ -426,6 +438,9 @@ static int iwl_mvm_remove_sta_queue_marking(struct iwl_mvm *mvm, int queue)
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
+		return -EINVAL;
+
 	spin_lock_bh(&mvm->queue_info_lock);
 	sta_id = mvm->queue_info[queue].ra_sta_id;
 	tid_bitmap = mvm->queue_info[queue].tid_bitmap;
@@ -468,6 +483,9 @@ static int iwl_mvm_free_inactive_queue(struct iwl_mvm *mvm, int queue,
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
+		return -EINVAL;
+
 	spin_lock_bh(&mvm->queue_info_lock);
 	txq_curr_ac = mvm->queue_info[queue].mac80211_ac;
 	sta_id = mvm->queue_info[queue].ra_sta_id;
@@ -512,6 +530,8 @@ static int iwl_mvm_get_shared_queue(struct iwl_mvm *mvm,
 	int i;
 
 	lockdep_assert_held(&mvm->queue_info_lock);
+	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
+		return -EINVAL;
 
 	memset(&ac_to_queue, IEEE80211_INVAL_HW_QUEUE, sizeof(ac_to_queue));
 
@@ -596,6 +616,9 @@ int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
 	unsigned long mq;
 	int ret;
 
+	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
+		return -EINVAL;
+
 	/*
 	 * If the AC is lower than current one - FIFO needs to be redirected to
 	 * the lowest one of the streams in the queue. Check if this is needed
@@ -757,6 +780,15 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 
 	/* No free queue - we'll have to share */
 	if (queue <= 0) {
+		/* This shouldn't happen in new HW - we have 512 queues */
+		if (WARN(iwl_mvm_has_new_tx_api(mvm),
+			 "No available queues for tid %d on sta_id %d\n",
+			 tid, cfg.sta_id)) {
+			spin_unlock_bh(&mvm->queue_info_lock);
+
+			return queue;
+		}
+
 		queue = iwl_mvm_get_shared_queue(mvm, tfd_queue_mask, ac);
 		if (queue > 0) {
 			shared_queue = true;
@@ -841,6 +873,9 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 		mvmsta->reserved_queue = IEEE80211_INVAL_HW_QUEUE;
 	spin_unlock_bh(&mvmsta->lock);
 
+	if (iwl_mvm_has_new_tx_api(mvm))
+		return 0;
+
 	if (!shared_queue) {
 		ret = iwl_mvm_sta_send_to_fw(mvm, sta, true, STA_MODIFY_QUEUES);
 		if (ret)
@@ -880,6 +915,9 @@ static void iwl_mvm_change_queue_owner(struct iwl_mvm *mvm, int queue)
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
+		return;
+
 	spin_lock_bh(&mvm->queue_info_lock);
 	tid_bitmap = mvm->queue_info[queue].tid_bitmap;
 	spin_unlock_bh(&mvm->queue_info_lock);
@@ -917,6 +955,10 @@ static void iwl_mvm_unshare_queue(struct iwl_mvm *mvm, int queue)
 	int ssn;
 	int ret = true;
 
+	/* queue sharing is disabled on new TX path */
+	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
+		return;
+
 	lockdep_assert_held(&mvm->mutex);
 
 	spin_lock_bh(&mvm->queue_info_lock);
@@ -1675,7 +1717,8 @@ static int iwl_mvm_add_int_sta_common(struct iwl_mvm *mvm,
 	cmd.mac_id_n_color = cpu_to_le32(FW_CMD_ID_AND_COLOR(mac_id,
 							     color));
 
-	cmd.tfd_queue_msk = cpu_to_le32(sta->tfd_queue_msk);
+	if (!iwl_mvm_has_new_tx_api(mvm))
+		cmd.tfd_queue_msk = cpu_to_le32(sta->tfd_queue_msk);
 	cmd.tid_disable_tx = cpu_to_le16(0xffff);
 
 	if (addr)
@@ -2287,7 +2330,9 @@ int iwl_mvm_sta_tx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	cmd.mac_id_n_color = cpu_to_le32(mvm_sta->mac_id_n_color);
 	cmd.sta_id = mvm_sta->sta_id;
 	cmd.add_modify = STA_MODE_MODIFY;
-	cmd.modify_mask = STA_MODIFY_QUEUES | STA_MODIFY_TID_DISABLE_TX;
+	if (!iwl_mvm_has_new_tx_api(mvm))
+		cmd.modify_mask = STA_MODIFY_QUEUES;
+	cmd.modify_mask |= STA_MODIFY_TID_DISABLE_TX;
 	cmd.tfd_queue_msk = cpu_to_le32(mvm_sta->tfd_queue_msk);
 	cmd.tid_disable_tx = cpu_to_le16(mvm_sta->tid_disable_agg);
 
@@ -2488,6 +2533,13 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		 */
 		if (!alloc_queue && buf_size < mvmsta->max_agg_bufsize) {
 			/*
+			 * On new TX API rs and BA manager are offloaded.
+			 * For now though, just don't support being reconfigured
+			 */
+			if (iwl_mvm_has_new_tx_api(mvm))
+				return -ENOTSUPP;
+
+			/*
 			 * If reconfiguring an existing queue, it first must be
 			 * drained
 			 */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 279f56bf175f..876e58905cd8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -890,6 +890,9 @@ static bool iwl_mvm_txq_should_update(struct iwl_mvm *mvm, int txq_id)
 	unsigned long now = jiffies;
 	int tid;
 
+	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
+		return false;
+
 	for_each_set_bit(tid, &queue_tid_bitmap, IWL_MAX_TID_COUNT + 1) {
 		if (time_before(mvm->queue_info[txq_id].last_frame_time[tid] +
 				IWL_MVM_DQA_QUEUE_TIMEOUT, now))
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 3054945b949a..74f62851f653 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -598,6 +598,9 @@ int iwl_mvm_find_free_queue(struct iwl_mvm *mvm, u8 sta_id, u8 minq, u8 maxq)
 		    mvm->queue_info[i].status == IWL_MVM_QUEUE_FREE)
 			return i;
 
+	if (iwl_mvm_has_new_tx_api(mvm))
+		return -ENOSPC;
+
 	/*
 	 * If no free queue found - settle for an inactive one to reconfigure
 	 * Make sure that the inactive queue either already belongs to this STA,
@@ -628,6 +631,9 @@ int iwl_mvm_reconfig_scd(struct iwl_mvm *mvm, int queue, int fifo, int sta_id,
 	};
 	int ret;
 
+	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
+		return -EINVAL;
+
 	spin_lock_bh(&mvm->queue_info_lock);
 	if (WARN(mvm->queue_info[queue].hw_queue_refcount == 0,
 		 "Trying to reconfig unallocated queue %d\n", queue)) {
@@ -696,7 +702,7 @@ void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 	/* Send the enabling command if we need to */
 	if (iwl_mvm_update_txq_mapping(mvm, queue, mac80211_queue,
 				       cfg->sta_id, cfg->tid)) {
-		struct iwl_scd_txq_cfg_cmd cmd = {
+		struct iwl_tx_queue_cfg_cmd cmd = {
 			.scd_queue = queue,
 			.action = SCD_CFG_ENABLE_QUEUE,
 			.window = cfg->frame_limit,
@@ -707,9 +713,16 @@ void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 			.tid = cfg->tid,
 		};
 
+		if (iwl_mvm_has_new_tx_api(mvm)) {
+			iwl_trans_txq_alloc(mvm->trans, (void *)&cmd,
+					    SCD_QUEUE_CFG, wdg_timeout);
+			return;
+		}
+
 		iwl_trans_txq_enable_cfg(mvm->trans, queue, ssn, NULL,
 					 wdg_timeout);
-		WARN(iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, 0, sizeof(cmd),
+		WARN(iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, 0,
+					  sizeof(struct iwl_scd_txq_cfg_cmd),
 					  &cmd),
 		     "Failed to configure queue %d on FIFO %d\n", queue,
 		     cfg->fifo);
@@ -719,7 +732,7 @@ void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 			u8 tid, u8 flags)
 {
-	struct iwl_scd_txq_cfg_cmd cmd = {
+	struct iwl_tx_queue_cfg_cmd cmd = {
 		.scd_queue = queue,
 		.action = SCD_CFG_DISABLE_QUEUE,
 	};
@@ -795,9 +808,17 @@ int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 
 	spin_unlock_bh(&mvm->queue_info_lock);
 
-	iwl_trans_txq_disable(mvm->trans, queue, false);
-	ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, flags,
-				   sizeof(cmd), &cmd);
+	if (iwl_mvm_has_new_tx_api(mvm)) {
+		iwl_trans_txq_free(mvm->trans, queue);
+		ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, flags,
+					   sizeof(cmd), &cmd);
+	} else {
+		iwl_trans_txq_disable(mvm->trans, queue, false);
+		ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, flags,
+					   sizeof(struct iwl_scd_txq_cfg_cmd),
+					   &cmd);
+	}
+
 	if (ret)
 		IWL_ERR(mvm, "Failed to disable queue %d (ret=%d)\n",
 			queue, ret);
@@ -1096,6 +1117,9 @@ static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 	lockdep_assert_held(&mvmsta->lock);
 	lockdep_assert_held(&mvm->queue_info_lock);
 
+	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
+		return;
+
 	/* Go over all non-active TIDs, incl. IWL_MAX_TID_COUNT (for mgmt) */
 	for_each_set_bit(tid, &tid_bitmap, IWL_MAX_TID_COUNT + 1) {
 		/* If some TFDs are still queued - don't mark TID as inactive */
@@ -1162,6 +1186,9 @@ void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 	unsigned long now = jiffies;
 	int i;
 
+	if (iwl_mvm_has_new_tx_api(mvm))
+		return;
+
 	spin_lock_bh(&mvm->queue_info_lock);
 	for (i = 0; i < IWL_MAX_HW_QUEUES; i++)
 		if (mvm->queue_info[i].hw_queue_refcount > 0)
-- 
2.11.0
