Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD14AC64EB8
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7827D2087C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:18:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7827D2087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbeJHP3C (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:29:02 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:56446 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725973AbeJHP3B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:29:01 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g9Qjk-0003w6-IP; Mon, 08 Oct 2018 11:17:57 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  8 Oct 2018 11:17:35 +0300
Message-Id: <20181008081735.3401-19-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181008081735.3401-1-luca@coelho.fi>
References: <20181008081735.3401-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 18/18] iwlwifi: mvm: kill INACTIVE queue state
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

We don't really need this state: instead of having an inactive
state where we can awaken zombie queues again if needed, just
keep them in their normal state unless a new queue is actually
needed and there's no other way of getting one.

We do this here by making the inactivity check not free queues
unless instructed that we now really need to allocate one to a
specific station, and in that case it'll just free the queue
immediately, without doing any inactivity step inbetween.

The only downside is a little bit more processing in this case,
but the code complexity is lower.

Additionally, this fixes a corner case: due to the way the code
worked, we could only ever reuse an inactive queue if it was
the reserved queue for a station, as iwl_mvm_find_free_queue()
would never consider returning an inactive queue.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h |   7 -
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 136 ++++++++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h |   4 -
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c  |  34 ++---
 4 files changed, 66 insertions(+), 115 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 8cbd9468aa8b..7ba5bc2ed1c4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -754,19 +754,12 @@ iwl_mvm_baid_data_from_reorder_buf(struct iwl_mvm_reorder_buffer *buf)
  *	This is a state in which a single queue serves more than one TID, all of
  *	which are not aggregated. Note that the queue is only associated to one
  *	RA.
- * @IWL_MVM_QUEUE_INACTIVE: queue is allocated but no traffic on it
- *	This is a state of a queue that has had traffic on it, but during the
- *	last %IWL_MVM_DQA_QUEUE_TIMEOUT time period there has been no traffic on
- *	it. In this state, when a new queue is needed to be allocated but no
- *	such free queue exists, an inactive queue might be freed and given to
- *	the new RA/TID.
  */
 enum iwl_mvm_queue_status {
 	IWL_MVM_QUEUE_FREE,
 	IWL_MVM_QUEUE_RESERVED,
 	IWL_MVM_QUEUE_READY,
 	IWL_MVM_QUEUE_SHARED,
-	IWL_MVM_QUEUE_INACTIVE,
 };
 
 #define IWL_MVM_DQA_QUEUE_TIMEOUT	(5 * HZ)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 8ae4fbf17f03..1887d2b9f185 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -549,11 +549,12 @@ static int iwl_mvm_remove_sta_queue_marking(struct iwl_mvm *mvm, int queue)
 }
 
 static int iwl_mvm_free_inactive_queue(struct iwl_mvm *mvm, int queue,
-				       bool same_sta)
+				       u8 new_sta_id)
 {
 	struct iwl_mvm_sta *mvmsta;
 	u8 txq_curr_ac, sta_id, tid;
 	unsigned long disable_agg_tids = 0;
+	bool same_sta;
 	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -567,6 +568,8 @@ static int iwl_mvm_free_inactive_queue(struct iwl_mvm *mvm, int queue,
 	tid = mvm->queue_info[queue].txq_tid;
 	spin_unlock_bh(&mvm->queue_info_lock);
 
+	same_sta = sta_id == new_sta_id;
+
 	mvmsta = iwl_mvm_sta_from_staid_protected(mvm, sta_id);
 	if (WARN_ON(!mvmsta))
 		return -EINVAL;
@@ -581,10 +584,6 @@ static int iwl_mvm_free_inactive_queue(struct iwl_mvm *mvm, int queue,
 				  mvmsta->vif->hw_queue[txq_curr_ac],
 				  tid, 0);
 	if (ret) {
-		/* Re-mark the inactive queue as inactive */
-		spin_lock_bh(&mvm->queue_info_lock);
-		mvm->queue_info[queue].status = IWL_MVM_QUEUE_INACTIVE;
-		spin_unlock_bh(&mvm->queue_info_lock);
 		IWL_ERR(mvm,
 			"Failed to free inactive queue %d (ret=%d)\n",
 			queue, ret);
@@ -844,7 +843,6 @@ static int iwl_mvm_sta_alloc_queue_tvqm(struct iwl_mvm *mvm,
 
 	spin_lock_bh(&mvmsta->lock);
 	mvmsta->tid_data[tid].txq_id = queue;
-	mvmsta->tid_data[tid].is_tid_active = true;
 	spin_unlock_bh(&mvmsta->lock);
 
 	return 0;
@@ -1063,8 +1061,10 @@ static void iwl_mvm_unshare_queue(struct iwl_mvm *mvm, int queue)
  * Remove inactive TIDs of a given queue.
  * If all queue TIDs are inactive - mark the queue as inactive
  * If only some the queue TIDs are inactive - unmap them from the queue
+ *
+ * Returns %true if all TIDs were removed and the queue could be reused.
  */
-static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
+static bool iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 					 struct iwl_mvm_sta *mvmsta, int queue,
 					 unsigned long tid_bitmap,
 					 unsigned long *unshare_queues,
@@ -1076,7 +1076,7 @@ static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 	lockdep_assert_held(&mvm->queue_info_lock);
 
 	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
-		return;
+		return false;
 
 	/* Go over all non-active TIDs, incl. IWL_MAX_TID_COUNT (for mgmt) */
 	for_each_set_bit(tid, &tid_bitmap, IWL_MAX_TID_COUNT + 1) {
@@ -1089,16 +1089,10 @@ static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 			tid_bitmap &= ~BIT(tid);
 	}
 
-	/* If all TIDs in the queue are inactive - mark queue as inactive. */
+	/* If all TIDs in the queue are inactive - return it can be reused */
 	if (tid_bitmap == mvm->queue_info[queue].tid_bitmap) {
-		mvm->queue_info[queue].status = IWL_MVM_QUEUE_INACTIVE;
-
-		for_each_set_bit(tid, &tid_bitmap, IWL_MAX_TID_COUNT + 1)
-			mvmsta->tid_data[tid].is_tid_active = false;
-
-		IWL_DEBUG_TX_QUEUES(mvm, "Queue %d marked as inactive\n",
-				    queue);
-		return;
+		IWL_DEBUG_TX_QUEUES(mvm, "Queue %d is inactive\n", queue);
+		return true;
 	}
 
 	/*
@@ -1112,7 +1106,6 @@ static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 		mvmsta->tid_data[tid].txq_id = IWL_MVM_INVALID_QUEUE;
 		mvm->hw_queue_to_mac80211[queue] &= ~BIT(mac_queue);
 		mvm->queue_info[queue].tid_bitmap &= ~BIT(tid);
-		mvmsta->tid_data[tid].is_tid_active = false;
 
 		tid_bitmap = mvm->queue_info[queue].tid_bitmap;
 
@@ -1156,19 +1149,30 @@ static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 				    queue);
 		set_bit(queue, unshare_queues);
 	}
+
+	return false;
 }
 
-static void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
+/*
+ * Check for inactivity - this includes checking if any queue
+ * can be unshared and finding one (and only one) that can be
+ * reused.
+ * This function is also invoked as a sort of clean-up task,
+ * in which case @alloc_for_sta is IWL_MVM_INVALID_STA.
+ *
+ * Returns the queue number, or -ENOSPC.
+ */
+static int iwl_mvm_inactivity_check(struct iwl_mvm *mvm, u8 alloc_for_sta)
 {
 	unsigned long now = jiffies;
 	unsigned long unshare_queues = 0;
 	unsigned long changetid_queues = 0;
-	int i;
+	int i, ret, free_queue = -ENOSPC;
 
 	lockdep_assert_held(&mvm->mutex);
 
 	if (iwl_mvm_has_new_tx_api(mvm))
-		return;
+		return -ENOSPC;
 
 	spin_lock_bh(&mvm->queue_info_lock);
 
@@ -1177,11 +1181,6 @@ static void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 	/* we skip the CMD queue below by starting at 1 */
 	BUILD_BUG_ON(IWL_MVM_DQA_CMD_QUEUE != 0);
 
-	/*
-	 * If a queue times out - mark it as INACTIVE (don't remove right away
-	 * if we don't have to.) This is an optimization in case traffic comes
-	 * later, and we don't HAVE to use a currently-inactive queue
-	 */
 	for (i = 1; i < IWL_MAX_HW_QUEUES; i++) {
 		struct ieee80211_sta *sta;
 		struct iwl_mvm_sta *mvmsta;
@@ -1237,10 +1236,12 @@ static void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 		/* and we need this locking order */
 		spin_lock(&mvmsta->lock);
 		spin_lock(&mvm->queue_info_lock);
-		iwl_mvm_remove_inactive_tids(mvm, mvmsta, i,
-					     inactive_tid_bitmap,
-					     &unshare_queues,
-					     &changetid_queues);
+		ret = iwl_mvm_remove_inactive_tids(mvm, mvmsta, i,
+						   inactive_tid_bitmap,
+						   &unshare_queues,
+						   &changetid_queues);
+		if (ret >= 0 && free_queue < 0)
+			free_queue = ret;
 		/* only unlock sta lock - we still need the queue info lock */
 		spin_unlock(&mvmsta->lock);
 	}
@@ -1253,6 +1254,15 @@ static void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 		iwl_mvm_unshare_queue(mvm, i);
 	for_each_set_bit(i, &changetid_queues, IWL_MAX_HW_QUEUES)
 		iwl_mvm_change_queue_tid(mvm, i);
+
+	if (free_queue >= 0 && alloc_for_sta != IWL_MVM_INVALID_STA) {
+		ret = iwl_mvm_free_inactive_queue(mvm, free_queue,
+						  alloc_for_sta);
+		if (ret)
+			return ret;
+	}
+
+	return free_queue;
 }
 
 static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
@@ -1270,7 +1280,6 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 		iwl_mvm_get_wd_timeout(mvm, mvmsta->vif, false, false);
 	u8 mac_queue = mvmsta->vif->hw_queue[ac];
 	int queue = -1;
-	bool using_inactive_queue = false, same_sta = false;
 	unsigned long disable_agg_tids = 0;
 	enum iwl_mvm_agg_state queue_state;
 	bool shared_queue = false, inc_ssn;
@@ -1307,9 +1316,7 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 
 	if ((queue < 0 && mvmsta->reserved_queue != IEEE80211_INVAL_HW_QUEUE) &&
 	    (mvm->queue_info[mvmsta->reserved_queue].status ==
-	     IWL_MVM_QUEUE_RESERVED ||
-	     mvm->queue_info[mvmsta->reserved_queue].status ==
-	     IWL_MVM_QUEUE_INACTIVE)) {
+			IWL_MVM_QUEUE_RESERVED)) {
 		queue = mvmsta->reserved_queue;
 		mvm->queue_info[queue].reserved = true;
 		IWL_DEBUG_TX_QUEUES(mvm, "Using reserved queue #%d\n", queue);
@@ -1319,21 +1326,13 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 		queue = iwl_mvm_find_free_queue(mvm, mvmsta->sta_id,
 						IWL_MVM_DQA_MIN_DATA_QUEUE,
 						IWL_MVM_DQA_MAX_DATA_QUEUE);
+	if (queue < 0) {
+		spin_unlock_bh(&mvm->queue_info_lock);
 
-	/*
-	 * Check if this queue is already allocated but inactive.
-	 * In such a case, we'll need to first free this queue before enabling
-	 * it again, so we'll mark it as reserved to make sure no new traffic
-	 * arrives on it
-	 */
-	if (queue > 0 &&
-	    mvm->queue_info[queue].status == IWL_MVM_QUEUE_INACTIVE) {
-		mvm->queue_info[queue].status = IWL_MVM_QUEUE_RESERVED;
-		using_inactive_queue = true;
-		same_sta = mvm->queue_info[queue].ra_sta_id == mvmsta->sta_id;
-		IWL_DEBUG_TX_QUEUES(mvm,
-				    "Re-assigning TXQ %d: sta_id=%d, tid=%d\n",
-				    queue, mvmsta->sta_id, tid);
+		/* try harder - perhaps kill an inactive queue */
+		queue = iwl_mvm_inactivity_check(mvm, mvmsta->sta_id);
+
+		spin_lock_bh(&mvm->queue_info_lock);
 	}
 
 	/* No free queue - we'll have to share */
@@ -1372,16 +1371,6 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	cfg.aggregate = (queue >= IWL_MVM_DQA_MIN_DATA_QUEUE ||
 			 queue == IWL_MVM_DQA_BSS_CLIENT_QUEUE);
 
-	/*
-	 * If this queue was previously inactive (idle) - we need to free it
-	 * first
-	 */
-	if (using_inactive_queue) {
-		ret = iwl_mvm_free_inactive_queue(mvm, queue, same_sta);
-		if (ret)
-			return ret;
-	}
-
 	IWL_DEBUG_TX_QUEUES(mvm,
 			    "Allocating %squeue #%d to sta %d on tid %d\n",
 			    shared_queue ? "shared " : "", queue,
@@ -1425,7 +1414,6 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	if (inc_ssn)
 		mvmsta->tid_data[tid].seq_number += 0x10;
 	mvmsta->tid_data[tid].txq_id = queue;
-	mvmsta->tid_data[tid].is_tid_active = true;
 	mvmsta->tfd_queue_msk |= BIT(queue);
 	queue_state = mvmsta->tid_data[tid].state;
 
@@ -1532,7 +1520,7 @@ void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk)
 
 	mutex_lock(&mvm->mutex);
 
-	iwl_mvm_inactivity_check(mvm);
+	iwl_mvm_inactivity_check(mvm, IWL_MVM_INVALID_STA);
 
 	/* Go over all stations with deferred traffic */
 	for_each_set_bit(sta_id, mvm->sta_deferred_frames,
@@ -1560,17 +1548,13 @@ static int iwl_mvm_reserve_sta_stream(struct iwl_mvm *mvm,
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	int queue;
-	bool using_inactive_queue = false, same_sta = false;
 
 	/* queue reserving is disabled on new TX path */
 	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
 		return 0;
 
-	/*
-	 * Check for inactive queues, so we don't reach a situation where we
-	 * can't add a STA due to a shortage in queues that doesn't really exist
-	 */
-	iwl_mvm_inactivity_check(mvm);
+	/* run the general cleanup/unsharing of queues */
+	iwl_mvm_inactivity_check(mvm, IWL_MVM_INVALID_STA);
 
 	spin_lock_bh(&mvm->queue_info_lock);
 
@@ -1586,16 +1570,13 @@ static int iwl_mvm_reserve_sta_stream(struct iwl_mvm *mvm,
 						IWL_MVM_DQA_MAX_DATA_QUEUE);
 	if (queue < 0) {
 		spin_unlock_bh(&mvm->queue_info_lock);
-		IWL_ERR(mvm, "No available queues for new station\n");
-		return -ENOSPC;
-	} else if (mvm->queue_info[queue].status == IWL_MVM_QUEUE_INACTIVE) {
-		/*
-		 * If this queue is already allocated but inactive we'll need to
-		 * first free this queue before enabling it again, we'll mark
-		 * it as reserved to make sure no new traffic arrives on it
-		 */
-		using_inactive_queue = true;
-		same_sta = mvm->queue_info[queue].ra_sta_id == mvmsta->sta_id;
+		/* try again - this time kick out a queue if needed */
+		queue = iwl_mvm_inactivity_check(mvm, mvmsta->sta_id);
+		if (queue < 0) {
+			IWL_ERR(mvm, "No available queues for new station\n");
+			return -ENOSPC;
+		}
+		spin_lock_bh(&mvm->queue_info_lock);
 	}
 	mvm->queue_info[queue].status = IWL_MVM_QUEUE_RESERVED;
 
@@ -1603,9 +1584,6 @@ static int iwl_mvm_reserve_sta_stream(struct iwl_mvm *mvm,
 
 	mvmsta->reserved_queue = queue;
 
-	if (using_inactive_queue)
-		iwl_mvm_free_inactive_queue(mvm, queue, same_sta);
-
 	IWL_DEBUG_TX_QUEUES(mvm, "Reserving data queue #%d for sta_id %d\n",
 			    queue, mvmsta->sta_id);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index 492cfd37521b..de1a0a2d8723 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -312,9 +312,6 @@ enum iwl_mvm_agg_state {
  *	Basically when next_reclaimed reaches ssn, we can tell mac80211 that
  *	we are ready to finish the Tx AGG stop / start flow.
  * @tx_time: medium time consumed by this A-MPDU
- * @is_tid_active: has this TID sent traffic in the last
- *	%IWL_MVM_DQA_QUEUE_TIMEOUT time period. If %txq_id is invalid, this
- *	field should be ignored.
  * @tpt_meas_start: time of the throughput measurements start, is reset every HZ
  * @tx_count_last: number of frames transmitted during the last second
  * @tx_count: counts the number of frames transmitted since the last reset of
@@ -332,7 +329,6 @@ struct iwl_mvm_tid_data {
 	u16 txq_id;
 	u16 ssn;
 	u16 tx_time;
-	bool is_tid_active;
 	unsigned long tpt_meas_start;
 	u32 tx_count_last;
 	u32 tx_count;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 99c64ea2619b..ec57682efe54 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1140,32 +1140,16 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	WARN_ON_ONCE(info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM);
 
 	/* Check if TXQ needs to be allocated or re-activated */
-	if (unlikely(txq_id == IWL_MVM_INVALID_QUEUE ||
-		     !mvmsta->tid_data[tid].is_tid_active)) {
-		/* If TXQ needs to be allocated... */
-		if (txq_id == IWL_MVM_INVALID_QUEUE) {
-			iwl_mvm_tx_add_stream(mvm, mvmsta, tid, skb);
+	if (unlikely(txq_id == IWL_MVM_INVALID_QUEUE)) {
+		iwl_mvm_tx_add_stream(mvm, mvmsta, tid, skb);
 
-			/*
-			 * The frame is now deferred, and the worker scheduled
-			 * will re-allocate it, so we can free it for now.
-			 */
-			iwl_trans_free_tx_cmd(mvm->trans, dev_cmd);
-			spin_unlock(&mvmsta->lock);
-			return 0;
-		}
-
-		/* queue should always be active in new TX path */
-		WARN_ON(iwl_mvm_has_new_tx_api(mvm));
-
-		/* If we are here - TXQ exists and needs to be re-activated */
-		spin_lock(&mvm->queue_info_lock);
-		mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_READY;
-		mvmsta->tid_data[tid].is_tid_active = true;
-		spin_unlock(&mvm->queue_info_lock);
-
-		IWL_DEBUG_TX_QUEUES(mvm, "Re-activating queue %d for TX\n",
-				    txq_id);
+		/*
+		 * The frame is now deferred, and the worker scheduled
+		 * will re-allocate it, so we can free it for now.
+		 */
+		iwl_trans_free_tx_cmd(mvm->trans, dev_cmd);
+		spin_unlock(&mvmsta->lock);
+		return 0;
 	}
 
 	if (!iwl_mvm_has_new_tx_api(mvm)) {
-- 
2.19.0

