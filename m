Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC621C00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BFA82087C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:17:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6BFA82087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbeJHP2W (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:28:22 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:56356 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726793AbeJHP2W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:28:22 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g9Qjc-0003w6-M5; Mon, 08 Oct 2018 11:17:49 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  8 Oct 2018 11:17:26 +0300
Message-Id: <20181008081735.3401-10-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181008081735.3401-1-luca@coelho.fi>
References: <20181008081735.3401-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/18] iwlwifi: mvm: move queue management into sta.c
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

None of these functions really need to be separate, they're all
only used in sta.c, move them there and make them static.

Fix a small typo in related code while at it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  13 -
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 409 +++++++++++++++++
 .../net/wireless/intel/iwlwifi/mvm/utils.c    | 418 ------------------
 3 files changed, 409 insertions(+), 431 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index cff58ed35fbe..f5a532dc712d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1886,17 +1886,6 @@ void iwl_mvm_vif_set_low_latency(struct iwl_mvm_vif *mvmvif, bool set,
 		mvmvif->low_latency &= ~cause;
 }
 
-/* hw scheduler queue config */
-bool iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
-			u16 ssn, const struct iwl_trans_txq_scd_cfg *cfg,
-			unsigned int wdg_timeout);
-int iwl_mvm_tvqm_enable_txq(struct iwl_mvm *mvm, int mac80211_queue,
-			    u8 sta_id, u8 tid, unsigned int timeout);
-
-int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
-			u8 tid, u8 flags);
-int iwl_mvm_find_free_queue(struct iwl_mvm *mvm, u8 sta_id, u8 minq, u8 maxq);
-
 /* Return a bitmask with all the hw supported queues, except for the
  * command queue, which can't be flushed.
  */
@@ -1998,8 +1987,6 @@ void iwl_mvm_reorder_timer_expired(struct timer_list *t);
 struct ieee80211_vif *iwl_mvm_get_bss_vif(struct iwl_mvm *mvm);
 bool iwl_mvm_is_vif_assoc(struct iwl_mvm *mvm);
 
-void iwl_mvm_inactivity_check(struct iwl_mvm *mvm);
-
 #define MVM_TCM_PERIOD_MSEC 500
 #define MVM_TCM_PERIOD (HZ * MVM_TCM_PERIOD_MSEC / 1000)
 #define MVM_LL_PERIOD (10 * HZ)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 8f929c774e70..fd33b8d148b3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -358,6 +358,112 @@ static int iwl_mvm_invalidate_sta_queue(struct iwl_mvm *mvm, int queue,
 	return ret;
 }
 
+static int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue,
+			       int mac80211_queue, u8 tid, u8 flags)
+{
+	struct iwl_scd_txq_cfg_cmd cmd = {
+		.scd_queue = queue,
+		.action = SCD_CFG_DISABLE_QUEUE,
+	};
+	bool remove_mac_queue = mac80211_queue != IEEE80211_INVAL_HW_QUEUE;
+	int ret;
+
+	if (WARN_ON(remove_mac_queue && mac80211_queue >= IEEE80211_MAX_QUEUES))
+		return -EINVAL;
+
+	if (iwl_mvm_has_new_tx_api(mvm)) {
+		spin_lock_bh(&mvm->queue_info_lock);
+
+		if (remove_mac_queue)
+			mvm->hw_queue_to_mac80211[queue] &=
+				~BIT(mac80211_queue);
+
+		spin_unlock_bh(&mvm->queue_info_lock);
+
+		iwl_trans_txq_free(mvm->trans, queue);
+
+		return 0;
+	}
+
+	spin_lock_bh(&mvm->queue_info_lock);
+
+	if (WARN_ON(mvm->queue_info[queue].hw_queue_refcount == 0)) {
+		spin_unlock_bh(&mvm->queue_info_lock);
+		return 0;
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
+		mvm->hw_queue_to_mac80211[queue] &=
+			~BIT(mac80211_queue);
+	mvm->queue_info[queue].hw_queue_refcount--;
+
+	cmd.action = mvm->queue_info[queue].hw_queue_refcount ?
+		SCD_CFG_ENABLE_QUEUE : SCD_CFG_DISABLE_QUEUE;
+	if (cmd.action == SCD_CFG_DISABLE_QUEUE)
+		mvm->queue_info[queue].status = IWL_MVM_QUEUE_FREE;
+
+	IWL_DEBUG_TX_QUEUES(mvm,
+			    "Disabling TXQ #%d refcount=%d (mac80211 map:0x%x)\n",
+			    queue,
+			    mvm->queue_info[queue].hw_queue_refcount,
+			    mvm->hw_queue_to_mac80211[queue]);
+
+	/* If the queue is still enabled - nothing left to do in this func */
+	if (cmd.action == SCD_CFG_ENABLE_QUEUE) {
+		spin_unlock_bh(&mvm->queue_info_lock);
+		return 0;
+	}
+
+	cmd.sta_id = mvm->queue_info[queue].ra_sta_id;
+	cmd.tid = mvm->queue_info[queue].txq_tid;
+
+	/* Make sure queue info is correct even though we overwrite it */
+	WARN(mvm->queue_info[queue].hw_queue_refcount ||
+	     mvm->queue_info[queue].tid_bitmap ||
+	     mvm->hw_queue_to_mac80211[queue],
+	     "TXQ #%d info out-of-sync - refcount=%d, mac map=0x%x, tid=0x%x\n",
+	     queue, mvm->queue_info[queue].hw_queue_refcount,
+	     mvm->hw_queue_to_mac80211[queue],
+	     mvm->queue_info[queue].tid_bitmap);
+
+	/* If we are here - the queue is freed and we can zero out these vals */
+	mvm->queue_info[queue].hw_queue_refcount = 0;
+	mvm->queue_info[queue].tid_bitmap = 0;
+	mvm->hw_queue_to_mac80211[queue] = 0;
+
+	/* Regardless if this is a reserved TXQ for a STA - mark it as false */
+	mvm->queue_info[queue].reserved = false;
+
+	spin_unlock_bh(&mvm->queue_info_lock);
+
+	iwl_trans_txq_disable(mvm->trans, queue, false);
+	ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, flags,
+				   sizeof(struct iwl_scd_txq_cfg_cmd), &cmd);
+
+	if (ret)
+		IWL_ERR(mvm, "Failed to disable queue %d (ret=%d)\n",
+			queue, ret);
+	return ret;
+}
+
 static int iwl_mvm_get_queue_agg_tids(struct iwl_mvm *mvm, int queue)
 {
 	struct ieee80211_sta *sta;
@@ -674,6 +780,57 @@ int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
 	return ret;
 }
 
+static int iwl_mvm_find_free_queue(struct iwl_mvm *mvm, u8 sta_id,
+				   u8 minq, u8 maxq)
+{
+	int i;
+
+	lockdep_assert_held(&mvm->queue_info_lock);
+
+	/* This should not be hit with new TX path */
+	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
+		return -ENOSPC;
+
+	/* Start by looking for a free queue */
+	for (i = minq; i <= maxq; i++)
+		if (mvm->queue_info[i].hw_queue_refcount == 0 &&
+		    mvm->queue_info[i].status == IWL_MVM_QUEUE_FREE)
+			return i;
+
+	return -ENOSPC;
+}
+
+static int iwl_mvm_tvqm_enable_txq(struct iwl_mvm *mvm, int mac80211_queue,
+				   u8 sta_id, u8 tid, unsigned int timeout)
+{
+	int queue, size = IWL_DEFAULT_QUEUE_SIZE;
+
+	if (tid == IWL_MAX_TID_COUNT) {
+		tid = IWL_MGMT_TID;
+		size = IWL_MGMT_QUEUE_SIZE;
+	}
+	queue = iwl_trans_txq_alloc(mvm->trans,
+				    cpu_to_le16(TX_QUEUE_CFG_ENABLE_QUEUE),
+				    sta_id, tid, SCD_QUEUE_CFG, size, timeout);
+
+	if (queue < 0) {
+		IWL_DEBUG_TX_QUEUES(mvm,
+				    "Failed allocating TXQ for sta %d tid %d, ret: %d\n",
+				    sta_id, tid, queue);
+		return queue;
+	}
+
+	IWL_DEBUG_TX_QUEUES(mvm, "Enabling TXQ #%d for sta %d tid %d\n",
+			    queue, sta_id, tid);
+
+	mvm->hw_queue_to_mac80211[queue] |= BIT(mac80211_queue);
+	IWL_DEBUG_TX_QUEUES(mvm,
+			    "Enabling TXQ #%d (mac80211 map:0x%x)\n",
+			    queue, mvm->hw_queue_to_mac80211[queue]);
+
+	return queue;
+}
+
 static int iwl_mvm_sta_alloc_queue_tvqm(struct iwl_mvm *mvm,
 					struct ieee80211_sta *sta, u8 ac,
 					int tid)
@@ -704,6 +861,93 @@ static int iwl_mvm_sta_alloc_queue_tvqm(struct iwl_mvm *mvm,
 	return 0;
 }
 
+static bool iwl_mvm_update_txq_mapping(struct iwl_mvm *mvm, int queue,
+				       int mac80211_queue, u8 sta_id, u8 tid)
+{
+	bool enable_queue = true;
+
+	spin_lock_bh(&mvm->queue_info_lock);
+
+	/* Make sure this TID isn't already enabled */
+	if (mvm->queue_info[queue].tid_bitmap & BIT(tid)) {
+		spin_unlock_bh(&mvm->queue_info_lock);
+		IWL_ERR(mvm, "Trying to enable TXQ %d with existing TID %d\n",
+			queue, tid);
+		return false;
+	}
+
+	/* Update mappings and refcounts */
+	if (mvm->queue_info[queue].hw_queue_refcount > 0)
+		enable_queue = false;
+
+	if (mac80211_queue != IEEE80211_INVAL_HW_QUEUE) {
+		WARN(mac80211_queue >=
+		     BITS_PER_BYTE * sizeof(mvm->hw_queue_to_mac80211[0]),
+		     "cannot track mac80211 queue %d (queue %d, sta %d, tid %d)\n",
+		     mac80211_queue, queue, sta_id, tid);
+		mvm->hw_queue_to_mac80211[queue] |= BIT(mac80211_queue);
+	}
+
+	mvm->queue_info[queue].hw_queue_refcount++;
+	mvm->queue_info[queue].tid_bitmap |= BIT(tid);
+	mvm->queue_info[queue].ra_sta_id = sta_id;
+
+	if (enable_queue) {
+		if (tid != IWL_MAX_TID_COUNT)
+			mvm->queue_info[queue].mac80211_ac =
+				tid_to_mac80211_ac[tid];
+		else
+			mvm->queue_info[queue].mac80211_ac = IEEE80211_AC_VO;
+
+		mvm->queue_info[queue].txq_tid = tid;
+	}
+
+	IWL_DEBUG_TX_QUEUES(mvm,
+			    "Enabling TXQ #%d refcount=%d (mac80211 map:0x%x)\n",
+			    queue, mvm->queue_info[queue].hw_queue_refcount,
+			    mvm->hw_queue_to_mac80211[queue]);
+
+	spin_unlock_bh(&mvm->queue_info_lock);
+
+	return enable_queue;
+}
+
+static bool iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue,
+			       int mac80211_queue, u16 ssn,
+			       const struct iwl_trans_txq_scd_cfg *cfg,
+			       unsigned int wdg_timeout)
+{
+	struct iwl_scd_txq_cfg_cmd cmd = {
+		.scd_queue = queue,
+		.action = SCD_CFG_ENABLE_QUEUE,
+		.window = cfg->frame_limit,
+		.sta_id = cfg->sta_id,
+		.ssn = cpu_to_le16(ssn),
+		.tx_fifo = cfg->fifo,
+		.aggregate = cfg->aggregate,
+		.tid = cfg->tid,
+	};
+	bool inc_ssn;
+
+	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
+		return false;
+
+	/* Send the enabling command if we need to */
+	if (!iwl_mvm_update_txq_mapping(mvm, queue, mac80211_queue,
+					cfg->sta_id, cfg->tid))
+		return false;
+
+	inc_ssn = iwl_trans_txq_enable_cfg(mvm->trans, queue, ssn,
+					   NULL, wdg_timeout);
+	if (inc_ssn)
+		le16_add_cpu(&cmd.ssn, 1);
+
+	WARN(iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, 0, sizeof(cmd), &cmd),
+	     "Failed to configure queue %d on FIFO %d\n", queue, cfg->fifo);
+
+	return inc_ssn;
+}
+
 static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 				   struct ieee80211_sta *sta, u8 ac, int tid,
 				   struct ieee80211_hdr *hdr)
@@ -1032,6 +1276,171 @@ static void iwl_mvm_unshare_queue(struct iwl_mvm *mvm, int queue)
 	spin_unlock_bh(&mvm->queue_info_lock);
 }
 
+/*
+ * Remove inactive TIDs of a given queue.
+ * If all queue TIDs are inactive - mark the queue as inactive
+ * If only some the queue TIDs are inactive - unmap them from the queue
+ */
+static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
+					 struct iwl_mvm_sta *mvmsta, int queue,
+					 unsigned long tid_bitmap)
+{
+	int tid;
+
+	lockdep_assert_held(&mvmsta->lock);
+	lockdep_assert_held(&mvm->queue_info_lock);
+
+	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
+		return;
+
+	/* Go over all non-active TIDs, incl. IWL_MAX_TID_COUNT (for mgmt) */
+	for_each_set_bit(tid, &tid_bitmap, IWL_MAX_TID_COUNT + 1) {
+		/* If some TFDs are still queued - don't mark TID as inactive */
+		if (iwl_mvm_tid_queued(mvm, &mvmsta->tid_data[tid]))
+			tid_bitmap &= ~BIT(tid);
+
+		/* Don't mark as inactive any TID that has an active BA */
+		if (mvmsta->tid_data[tid].state != IWL_AGG_OFF)
+			tid_bitmap &= ~BIT(tid);
+	}
+
+	/* If all TIDs in the queue are inactive - mark queue as inactive. */
+	if (tid_bitmap == mvm->queue_info[queue].tid_bitmap) {
+		mvm->queue_info[queue].status = IWL_MVM_QUEUE_INACTIVE;
+
+		for_each_set_bit(tid, &tid_bitmap, IWL_MAX_TID_COUNT + 1)
+			mvmsta->tid_data[tid].is_tid_active = false;
+
+		IWL_DEBUG_TX_QUEUES(mvm, "Queue %d marked as inactive\n",
+				    queue);
+		return;
+	}
+
+	/*
+	 * If we are here, this is a shared queue and not all TIDs timed-out.
+	 * Remove the ones that did.
+	 */
+	for_each_set_bit(tid, &tid_bitmap, IWL_MAX_TID_COUNT + 1) {
+		int mac_queue = mvmsta->vif->hw_queue[tid_to_mac80211_ac[tid]];
+
+		mvmsta->tid_data[tid].txq_id = IWL_MVM_INVALID_QUEUE;
+		mvm->hw_queue_to_mac80211[queue] &= ~BIT(mac_queue);
+		mvm->queue_info[queue].hw_queue_refcount--;
+		mvm->queue_info[queue].tid_bitmap &= ~BIT(tid);
+		mvmsta->tid_data[tid].is_tid_active = false;
+
+		IWL_DEBUG_TX_QUEUES(mvm,
+				    "Removing inactive TID %d from shared Q:%d\n",
+				    tid, queue);
+	}
+
+	IWL_DEBUG_TX_QUEUES(mvm,
+			    "TXQ #%d left with tid bitmap 0x%x\n", queue,
+			    mvm->queue_info[queue].tid_bitmap);
+
+	/*
+	 * There may be different TIDs with the same mac queues, so make
+	 * sure all TIDs have existing corresponding mac queues enabled
+	 */
+	tid_bitmap = mvm->queue_info[queue].tid_bitmap;
+	for_each_set_bit(tid, &tid_bitmap, IWL_MAX_TID_COUNT + 1) {
+		mvm->hw_queue_to_mac80211[queue] |=
+			BIT(mvmsta->vif->hw_queue[tid_to_mac80211_ac[tid]]);
+	}
+
+	/* If the queue is marked as shared - "unshare" it */
+	if (mvm->queue_info[queue].hw_queue_refcount == 1 &&
+	    mvm->queue_info[queue].status == IWL_MVM_QUEUE_SHARED) {
+		mvm->queue_info[queue].status = IWL_MVM_QUEUE_RECONFIGURING;
+		IWL_DEBUG_TX_QUEUES(mvm, "Marking Q:%d for reconfig\n",
+				    queue);
+	}
+}
+
+static void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
+{
+	unsigned long timeout_queues_map = 0;
+	unsigned long now = jiffies;
+	int i;
+
+	if (iwl_mvm_has_new_tx_api(mvm))
+		return;
+
+	spin_lock_bh(&mvm->queue_info_lock);
+	for (i = 0; i < IWL_MAX_HW_QUEUES; i++)
+		if (mvm->queue_info[i].hw_queue_refcount > 0)
+			timeout_queues_map |= BIT(i);
+	spin_unlock_bh(&mvm->queue_info_lock);
+
+	rcu_read_lock();
+
+	/*
+	 * If a queue times out - mark it as INACTIVE (don't remove right away
+	 * if we don't have to.) This is an optimization in case traffic comes
+	 * later, and we don't HAVE to use a currently-inactive queue
+	 */
+	for_each_set_bit(i, &timeout_queues_map, IWL_MAX_HW_QUEUES) {
+		struct ieee80211_sta *sta;
+		struct iwl_mvm_sta *mvmsta;
+		u8 sta_id;
+		int tid;
+		unsigned long inactive_tid_bitmap = 0;
+		unsigned long queue_tid_bitmap;
+
+		spin_lock_bh(&mvm->queue_info_lock);
+		queue_tid_bitmap = mvm->queue_info[i].tid_bitmap;
+
+		/* If TXQ isn't in active use anyway - nothing to do here... */
+		if (mvm->queue_info[i].status != IWL_MVM_QUEUE_READY &&
+		    mvm->queue_info[i].status != IWL_MVM_QUEUE_SHARED) {
+			spin_unlock_bh(&mvm->queue_info_lock);
+			continue;
+		}
+
+		/* Check to see if there are inactive TIDs on this queue */
+		for_each_set_bit(tid, &queue_tid_bitmap,
+				 IWL_MAX_TID_COUNT + 1) {
+			if (time_after(mvm->queue_info[i].last_frame_time[tid] +
+				       IWL_MVM_DQA_QUEUE_TIMEOUT, now))
+				continue;
+
+			inactive_tid_bitmap |= BIT(tid);
+		}
+		spin_unlock_bh(&mvm->queue_info_lock);
+
+		/* If all TIDs are active - finish check on this queue */
+		if (!inactive_tid_bitmap)
+			continue;
+
+		/*
+		 * If we are here - the queue hadn't been served recently and is
+		 * in use
+		 */
+
+		sta_id = mvm->queue_info[i].ra_sta_id;
+		sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
+
+		/*
+		 * If the STA doesn't exist anymore, it isn't an error. It could
+		 * be that it was removed since getting the queues, and in this
+		 * case it should've inactivated its queues anyway.
+		 */
+		if (IS_ERR_OR_NULL(sta))
+			continue;
+
+		mvmsta = iwl_mvm_sta_from_mac80211(sta);
+
+		spin_lock_bh(&mvmsta->lock);
+		spin_lock(&mvm->queue_info_lock);
+		iwl_mvm_remove_inactive_tids(mvm, mvmsta, i,
+					     inactive_tid_bitmap);
+		spin_unlock(&mvm->queue_info_lock);
+		spin_unlock_bh(&mvmsta->lock);
+	}
+
+	rcu_read_unlock();
+}
+
 static inline u8 iwl_mvm_tid_to_ac_queue(int tid)
 {
 	if (tid == IWL_MAX_TID_COUNT)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 6c14d3413bdc..dec097b72300 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -599,36 +599,6 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 	iwl_mvm_dump_umac_error_log(mvm);
 }
 
-int iwl_mvm_find_free_queue(struct iwl_mvm *mvm, u8 sta_id, u8 minq, u8 maxq)
-{
-	int i;
-
-	lockdep_assert_held(&mvm->queue_info_lock);
-
-	/* This should not be hit with new TX path */
-	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
-		return -ENOSPC;
-
-	/* Start by looking for a free queue */
-	for (i = minq; i <= maxq; i++)
-		if (mvm->queue_info[i].hw_queue_refcount == 0 &&
-		    mvm->queue_info[i].status == IWL_MVM_QUEUE_FREE)
-			return i;
-
-	/*
-	 * If no free queue found - settle for an inactive one to reconfigure
-	 * Make sure that the inactive queue either already belongs to this STA,
-	 * or that if it belongs to another one - it isn't the reserved queue
-	 */
-	for (i = minq; i <= maxq; i++)
-		if (mvm->queue_info[i].status == IWL_MVM_QUEUE_INACTIVE &&
-		    (sta_id == mvm->queue_info[i].ra_sta_id ||
-		     !mvm->queue_info[i].reserved))
-			return i;
-
-	return -ENOSPC;
-}
-
 int iwl_mvm_reconfig_scd(struct iwl_mvm *mvm, int queue, int fifo, int sta_id,
 			 int tid, int frame_limit, u16 ssn)
 {
@@ -665,229 +635,6 @@ int iwl_mvm_reconfig_scd(struct iwl_mvm *mvm, int queue, int fifo, int sta_id,
 	return ret;
 }
 
-static bool iwl_mvm_update_txq_mapping(struct iwl_mvm *mvm, int queue,
-				       int mac80211_queue, u8 sta_id, u8 tid)
-{
-	bool enable_queue = true;
-
-	spin_lock_bh(&mvm->queue_info_lock);
-
-	/* Make sure this TID isn't already enabled */
-	if (mvm->queue_info[queue].tid_bitmap & BIT(tid)) {
-		spin_unlock_bh(&mvm->queue_info_lock);
-		IWL_ERR(mvm, "Trying to enable TXQ %d with existing TID %d\n",
-			queue, tid);
-		return false;
-	}
-
-	/* Update mappings and refcounts */
-	if (mvm->queue_info[queue].hw_queue_refcount > 0)
-		enable_queue = false;
-
-	if (mac80211_queue != IEEE80211_INVAL_HW_QUEUE) {
-		WARN(mac80211_queue >=
-		     BITS_PER_BYTE * sizeof(mvm->hw_queue_to_mac80211[0]),
-		     "cannot track mac80211 queue %d (queue %d, sta %d, tid %d)\n",
-		     mac80211_queue, queue, sta_id, tid);
-		mvm->hw_queue_to_mac80211[queue] |= BIT(mac80211_queue);
-	}
-
-	mvm->queue_info[queue].hw_queue_refcount++;
-	mvm->queue_info[queue].tid_bitmap |= BIT(tid);
-	mvm->queue_info[queue].ra_sta_id = sta_id;
-
-	if (enable_queue) {
-		if (tid != IWL_MAX_TID_COUNT)
-			mvm->queue_info[queue].mac80211_ac =
-				tid_to_mac80211_ac[tid];
-		else
-			mvm->queue_info[queue].mac80211_ac = IEEE80211_AC_VO;
-
-		mvm->queue_info[queue].txq_tid = tid;
-	}
-
-	IWL_DEBUG_TX_QUEUES(mvm,
-			    "Enabling TXQ #%d refcount=%d (mac80211 map:0x%x)\n",
-			    queue, mvm->queue_info[queue].hw_queue_refcount,
-			    mvm->hw_queue_to_mac80211[queue]);
-
-	spin_unlock_bh(&mvm->queue_info_lock);
-
-	return enable_queue;
-}
-
-int iwl_mvm_tvqm_enable_txq(struct iwl_mvm *mvm, int mac80211_queue,
-			    u8 sta_id, u8 tid, unsigned int timeout)
-{
-	int queue, size = IWL_DEFAULT_QUEUE_SIZE;
-
-	if (tid == IWL_MAX_TID_COUNT) {
-		tid = IWL_MGMT_TID;
-		size = IWL_MGMT_QUEUE_SIZE;
-	}
-	queue = iwl_trans_txq_alloc(mvm->trans,
-				    cpu_to_le16(TX_QUEUE_CFG_ENABLE_QUEUE),
-				    sta_id, tid, SCD_QUEUE_CFG, size, timeout);
-
-	if (queue < 0) {
-		IWL_DEBUG_TX_QUEUES(mvm,
-				    "Failed allocating TXQ for sta %d tid %d, ret: %d\n",
-				    sta_id, tid, queue);
-		return queue;
-	}
-
-	IWL_DEBUG_TX_QUEUES(mvm, "Enabling TXQ #%d for sta %d tid %d\n",
-			    queue, sta_id, tid);
-
-	mvm->hw_queue_to_mac80211[queue] |= BIT(mac80211_queue);
-	IWL_DEBUG_TX_QUEUES(mvm,
-			    "Enabling TXQ #%d (mac80211 map:0x%x)\n",
-			    queue, mvm->hw_queue_to_mac80211[queue]);
-
-	return queue;
-}
-
-bool iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
-			u16 ssn, const struct iwl_trans_txq_scd_cfg *cfg,
-			unsigned int wdg_timeout)
-{
-	struct iwl_scd_txq_cfg_cmd cmd = {
-		.scd_queue = queue,
-		.action = SCD_CFG_ENABLE_QUEUE,
-		.window = cfg->frame_limit,
-		.sta_id = cfg->sta_id,
-		.ssn = cpu_to_le16(ssn),
-		.tx_fifo = cfg->fifo,
-		.aggregate = cfg->aggregate,
-		.tid = cfg->tid,
-	};
-	bool inc_ssn;
-
-	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
-		return false;
-
-	/* Send the enabling command if we need to */
-	if (!iwl_mvm_update_txq_mapping(mvm, queue, mac80211_queue,
-					cfg->sta_id, cfg->tid))
-		return false;
-
-	inc_ssn = iwl_trans_txq_enable_cfg(mvm->trans, queue, ssn,
-					   NULL, wdg_timeout);
-	if (inc_ssn)
-		le16_add_cpu(&cmd.ssn, 1);
-
-	WARN(iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, 0, sizeof(cmd), &cmd),
-	     "Failed to configure queue %d on FIFO %d\n", queue, cfg->fifo);
-
-	return inc_ssn;
-}
-
-int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
-			u8 tid, u8 flags)
-{
-	struct iwl_scd_txq_cfg_cmd cmd = {
-		.scd_queue = queue,
-		.action = SCD_CFG_DISABLE_QUEUE,
-	};
-	bool remove_mac_queue = mac80211_queue != IEEE80211_INVAL_HW_QUEUE;
-	int ret;
-
-	if (WARN_ON(remove_mac_queue && mac80211_queue >= IEEE80211_MAX_QUEUES))
-		return -EINVAL;
-
-	if (iwl_mvm_has_new_tx_api(mvm)) {
-		spin_lock_bh(&mvm->queue_info_lock);
-
-		if (remove_mac_queue)
-			mvm->hw_queue_to_mac80211[queue] &=
-				~BIT(mac80211_queue);
-
-		spin_unlock_bh(&mvm->queue_info_lock);
-
-		iwl_trans_txq_free(mvm->trans, queue);
-
-		return 0;
-	}
-
-	spin_lock_bh(&mvm->queue_info_lock);
-
-	if (WARN_ON(mvm->queue_info[queue].hw_queue_refcount == 0)) {
-		spin_unlock_bh(&mvm->queue_info_lock);
-		return 0;
-	}
-
-	mvm->queue_info[queue].tid_bitmap &= ~BIT(tid);
-
-	/*
-	 * If there is another TID with the same AC - don't remove the MAC queue
-	 * from the mapping
-	 */
-	if (tid < IWL_MAX_TID_COUNT) {
-		unsigned long tid_bitmap =
-			mvm->queue_info[queue].tid_bitmap;
-		int ac = tid_to_mac80211_ac[tid];
-		int i;
-
-		for_each_set_bit(i, &tid_bitmap, IWL_MAX_TID_COUNT) {
-			if (tid_to_mac80211_ac[i] == ac)
-				remove_mac_queue = false;
-		}
-	}
-
-	if (remove_mac_queue)
-		mvm->hw_queue_to_mac80211[queue] &=
-			~BIT(mac80211_queue);
-	mvm->queue_info[queue].hw_queue_refcount--;
-
-	cmd.action = mvm->queue_info[queue].hw_queue_refcount ?
-		SCD_CFG_ENABLE_QUEUE : SCD_CFG_DISABLE_QUEUE;
-	if (cmd.action == SCD_CFG_DISABLE_QUEUE)
-		mvm->queue_info[queue].status = IWL_MVM_QUEUE_FREE;
-
-	IWL_DEBUG_TX_QUEUES(mvm,
-			    "Disabling TXQ #%d refcount=%d (mac80211 map:0x%x)\n",
-			    queue,
-			    mvm->queue_info[queue].hw_queue_refcount,
-			    mvm->hw_queue_to_mac80211[queue]);
-
-	/* If the queue is still enabled - nothing left to do in this func */
-	if (cmd.action == SCD_CFG_ENABLE_QUEUE) {
-		spin_unlock_bh(&mvm->queue_info_lock);
-		return 0;
-	}
-
-	cmd.sta_id = mvm->queue_info[queue].ra_sta_id;
-	cmd.tid = mvm->queue_info[queue].txq_tid;
-
-	/* Make sure queue info is correct even though we overwrite it */
-	WARN(mvm->queue_info[queue].hw_queue_refcount ||
-	     mvm->queue_info[queue].tid_bitmap ||
-	     mvm->hw_queue_to_mac80211[queue],
-	     "TXQ #%d info out-of-sync - refcount=%d, mac map=0x%x, tid=0x%x\n",
-	     queue, mvm->queue_info[queue].hw_queue_refcount,
-	     mvm->hw_queue_to_mac80211[queue],
-	     mvm->queue_info[queue].tid_bitmap);
-
-	/* If we are here - the queue is freed and we can zero out these vals */
-	mvm->queue_info[queue].hw_queue_refcount = 0;
-	mvm->queue_info[queue].tid_bitmap = 0;
-	mvm->hw_queue_to_mac80211[queue] = 0;
-
-	/* Regardless if this is a reserved TXQ for a STA - mark it as false */
-	mvm->queue_info[queue].reserved = false;
-
-	spin_unlock_bh(&mvm->queue_info_lock);
-
-	iwl_trans_txq_disable(mvm->trans, queue, false);
-	ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, flags,
-				   sizeof(struct iwl_scd_txq_cfg_cmd), &cmd);
-
-	if (ret)
-		IWL_ERR(mvm, "Failed to disable queue %d (ret=%d)\n",
-			queue, ret);
-	return ret;
-}
-
 /**
  * iwl_mvm_send_lq_cmd() - Send link quality command
  * @sync: This command can be sent synchronously.
@@ -1255,171 +1002,6 @@ void iwl_mvm_connection_loss(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	ieee80211_connection_loss(vif);
 }
 
-/*
- * Remove inactive TIDs of a given queue.
- * If all queue TIDs are inactive - mark the queue as inactive
- * If only some the queue TIDs are inactive - unmap them from the queue
- */
-static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
-					 struct iwl_mvm_sta *mvmsta, int queue,
-					 unsigned long tid_bitmap)
-{
-	int tid;
-
-	lockdep_assert_held(&mvmsta->lock);
-	lockdep_assert_held(&mvm->queue_info_lock);
-
-	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
-		return;
-
-	/* Go over all non-active TIDs, incl. IWL_MAX_TID_COUNT (for mgmt) */
-	for_each_set_bit(tid, &tid_bitmap, IWL_MAX_TID_COUNT + 1) {
-		/* If some TFDs are still queued - don't mark TID as inactive */
-		if (iwl_mvm_tid_queued(mvm, &mvmsta->tid_data[tid]))
-			tid_bitmap &= ~BIT(tid);
-
-		/* Don't mark as inactive any TID that has an active BA */
-		if (mvmsta->tid_data[tid].state != IWL_AGG_OFF)
-			tid_bitmap &= ~BIT(tid);
-	}
-
-	/* If all TIDs in the queue are inactive - mark queue as inactive. */
-	if (tid_bitmap == mvm->queue_info[queue].tid_bitmap) {
-		mvm->queue_info[queue].status = IWL_MVM_QUEUE_INACTIVE;
-
-		for_each_set_bit(tid, &tid_bitmap, IWL_MAX_TID_COUNT + 1)
-			mvmsta->tid_data[tid].is_tid_active = false;
-
-		IWL_DEBUG_TX_QUEUES(mvm, "Queue %d marked as inactive\n",
-				    queue);
-		return;
-	}
-
-	/*
-	 * If we are here, this is a shared queue and not all TIDs timed-out.
-	 * Remove the ones that did.
-	 */
-	for_each_set_bit(tid, &tid_bitmap, IWL_MAX_TID_COUNT + 1) {
-		int mac_queue = mvmsta->vif->hw_queue[tid_to_mac80211_ac[tid]];
-
-		mvmsta->tid_data[tid].txq_id = IWL_MVM_INVALID_QUEUE;
-		mvm->hw_queue_to_mac80211[queue] &= ~BIT(mac_queue);
-		mvm->queue_info[queue].hw_queue_refcount--;
-		mvm->queue_info[queue].tid_bitmap &= ~BIT(tid);
-		mvmsta->tid_data[tid].is_tid_active = false;
-
-		IWL_DEBUG_TX_QUEUES(mvm,
-				    "Removing inactive TID %d from shared Q:%d\n",
-				    tid, queue);
-	}
-
-	IWL_DEBUG_TX_QUEUES(mvm,
-			    "TXQ #%d left with tid bitmap 0x%x\n", queue,
-			    mvm->queue_info[queue].tid_bitmap);
-
-	/*
-	 * There may be different TIDs with the same mac queues, so make
-	 * sure all TIDs have existing corresponding mac queues enabled
-	 */
-	tid_bitmap = mvm->queue_info[queue].tid_bitmap;
-	for_each_set_bit(tid, &tid_bitmap, IWL_MAX_TID_COUNT + 1) {
-		mvm->hw_queue_to_mac80211[queue] |=
-			BIT(mvmsta->vif->hw_queue[tid_to_mac80211_ac[tid]]);
-	}
-
-	/* If the queue is marked as shared - "unshare" it */
-	if (mvm->queue_info[queue].hw_queue_refcount == 1 &&
-	    mvm->queue_info[queue].status == IWL_MVM_QUEUE_SHARED) {
-		mvm->queue_info[queue].status = IWL_MVM_QUEUE_RECONFIGURING;
-		IWL_DEBUG_TX_QUEUES(mvm, "Marking Q:%d for reconfig\n",
-				    queue);
-	}
-}
-
-void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
-{
-	unsigned long timeout_queues_map = 0;
-	unsigned long now = jiffies;
-	int i;
-
-	if (iwl_mvm_has_new_tx_api(mvm))
-		return;
-
-	spin_lock_bh(&mvm->queue_info_lock);
-	for (i = 0; i < IWL_MAX_HW_QUEUES; i++)
-		if (mvm->queue_info[i].hw_queue_refcount > 0)
-			timeout_queues_map |= BIT(i);
-	spin_unlock_bh(&mvm->queue_info_lock);
-
-	rcu_read_lock();
-
-	/*
-	 * If a queue time outs - mark it as INACTIVE (don't remove right away
-	 * if we don't have to.) This is an optimization in case traffic comes
-	 * later, and we don't HAVE to use a currently-inactive queue
-	 */
-	for_each_set_bit(i, &timeout_queues_map, IWL_MAX_HW_QUEUES) {
-		struct ieee80211_sta *sta;
-		struct iwl_mvm_sta *mvmsta;
-		u8 sta_id;
-		int tid;
-		unsigned long inactive_tid_bitmap = 0;
-		unsigned long queue_tid_bitmap;
-
-		spin_lock_bh(&mvm->queue_info_lock);
-		queue_tid_bitmap = mvm->queue_info[i].tid_bitmap;
-
-		/* If TXQ isn't in active use anyway - nothing to do here... */
-		if (mvm->queue_info[i].status != IWL_MVM_QUEUE_READY &&
-		    mvm->queue_info[i].status != IWL_MVM_QUEUE_SHARED) {
-			spin_unlock_bh(&mvm->queue_info_lock);
-			continue;
-		}
-
-		/* Check to see if there are inactive TIDs on this queue */
-		for_each_set_bit(tid, &queue_tid_bitmap,
-				 IWL_MAX_TID_COUNT + 1) {
-			if (time_after(mvm->queue_info[i].last_frame_time[tid] +
-				       IWL_MVM_DQA_QUEUE_TIMEOUT, now))
-				continue;
-
-			inactive_tid_bitmap |= BIT(tid);
-		}
-		spin_unlock_bh(&mvm->queue_info_lock);
-
-		/* If all TIDs are active - finish check on this queue */
-		if (!inactive_tid_bitmap)
-			continue;
-
-		/*
-		 * If we are here - the queue hadn't been served recently and is
-		 * in use
-		 */
-
-		sta_id = mvm->queue_info[i].ra_sta_id;
-		sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
-
-		/*
-		 * If the STA doesn't exist anymore, it isn't an error. It could
-		 * be that it was removed since getting the queues, and in this
-		 * case it should've inactivated its queues anyway.
-		 */
-		if (IS_ERR_OR_NULL(sta))
-			continue;
-
-		mvmsta = iwl_mvm_sta_from_mac80211(sta);
-
-		spin_lock_bh(&mvmsta->lock);
-		spin_lock(&mvm->queue_info_lock);
-		iwl_mvm_remove_inactive_tids(mvm, mvmsta, i,
-					     inactive_tid_bitmap);
-		spin_unlock(&mvm->queue_info_lock);
-		spin_unlock_bh(&mvmsta->lock);
-	}
-
-	rcu_read_unlock();
-}
-
 void iwl_mvm_event_frame_timeout_callback(struct iwl_mvm *mvm,
 					  struct ieee80211_vif *vif,
 					  const struct ieee80211_sta *sta,
-- 
2.19.0

