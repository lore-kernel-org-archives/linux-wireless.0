Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7910C32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7710320657
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7710320657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbeKBUO6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 16:14:58 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:33980 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726700AbeKBUO5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 16:14:57 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gIXJ9-0007MW-Fp; Fri, 02 Nov 2018 13:08:08 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  2 Nov 2018 13:07:47 +0200
Message-Id: <20181102110800.29817-3-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181102110800.29817-1-luca@coelho.fi>
References: <20181102110800.29817-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/15] iwlwifi: mvm: remove queue_info_lock
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

All the queue management code runs under mvm->mutex, so there are
only very few cases of accessing the data structures without it:
 * TX path, which doesn't take any locks anyway
 * iwl_mvm_wake_sw_queue() and iwl_mvm_stop_sw_queue() where we
   just (atomically) read a bitmap, so the lock isn't needed.

Therefore, we can remove the spinlock. This enables some cleanup
in the ugly locking in iwl_mvm_inactivity_check().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |   1 -
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  13 +--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 102 ++----------------
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |  10 +-
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |   6 +-
 5 files changed, 19 insertions(+), 113 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 7ba5bc2ed1c4..8a933774a934 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -844,7 +844,6 @@ struct iwl_mvm {
 	u16 hw_queue_to_mac80211[IWL_MAX_TVQM_QUEUES];
 
 	struct iwl_mvm_dqa_txq_info queue_info[IWL_MAX_HW_QUEUES];
-	spinlock_t queue_info_lock; /* For syncing queue mgmt operations */
 	struct work_struct add_stream_wk; /* To add streams to queues */
 
 	atomic_t mac80211_queue_stop_count[IEEE80211_MAX_QUEUES];
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 0e2092526fae..758aa1f75ca1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -676,7 +676,6 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	INIT_LIST_HEAD(&mvm->aux_roc_te_list);
 	INIT_LIST_HEAD(&mvm->async_handlers_list);
 	spin_lock_init(&mvm->time_event_lock);
-	spin_lock_init(&mvm->queue_info_lock);
 
 	INIT_WORK(&mvm->async_handlers_wk, iwl_mvm_async_handlers_wk);
 	INIT_WORK(&mvm->roc_done_wk, iwl_mvm_roc_done_wk);
@@ -1108,11 +1107,7 @@ static void iwl_mvm_async_cb(struct iwl_op_mode *op_mode,
 static void iwl_mvm_stop_sw_queue(struct iwl_op_mode *op_mode, int hw_queue)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
-	unsigned long mq;
-
-	spin_lock_bh(&mvm->queue_info_lock);
-	mq = mvm->hw_queue_to_mac80211[hw_queue];
-	spin_unlock_bh(&mvm->queue_info_lock);
+	unsigned long mq = mvm->hw_queue_to_mac80211[hw_queue];
 
 	iwl_mvm_stop_mac_queues(mvm, mq);
 }
@@ -1138,11 +1133,7 @@ void iwl_mvm_start_mac_queues(struct iwl_mvm *mvm, unsigned long mq)
 static void iwl_mvm_wake_sw_queue(struct iwl_op_mode *op_mode, int hw_queue)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
-	unsigned long mq;
-
-	spin_lock_bh(&mvm->queue_info_lock);
-	mq = mvm->hw_queue_to_mac80211[hw_queue];
-	spin_unlock_bh(&mvm->queue_info_lock);
+	unsigned long mq = mvm->hw_queue_to_mac80211[hw_queue];
 
 	iwl_mvm_start_mac_queues(mvm, mq);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index c2b7bb5d107c..79ccc698ad83 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -319,9 +319,7 @@ static int iwl_mvm_invalidate_sta_queue(struct iwl_mvm *mvm, int queue,
 	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
 		return -EINVAL;
 
-	spin_lock_bh(&mvm->queue_info_lock);
 	sta_id = mvm->queue_info[queue].ra_sta_id;
-	spin_unlock_bh(&mvm->queue_info_lock);
 
 	rcu_read_lock();
 
@@ -372,25 +370,17 @@ static int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue,
 		return -EINVAL;
 
 	if (iwl_mvm_has_new_tx_api(mvm)) {
-		spin_lock_bh(&mvm->queue_info_lock);
-
 		if (remove_mac_queue)
 			mvm->hw_queue_to_mac80211[queue] &=
 				~BIT(mac80211_queue);
 
-		spin_unlock_bh(&mvm->queue_info_lock);
-
 		iwl_trans_txq_free(mvm->trans, queue);
 
 		return 0;
 	}
 
-	spin_lock_bh(&mvm->queue_info_lock);
-
-	if (WARN_ON(mvm->queue_info[queue].tid_bitmap == 0)) {
-		spin_unlock_bh(&mvm->queue_info_lock);
+	if (WARN_ON(mvm->queue_info[queue].tid_bitmap == 0))
 		return 0;
-	}
 
 	mvm->queue_info[queue].tid_bitmap &= ~BIT(tid);
 
@@ -426,10 +416,8 @@ static int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue,
 			    mvm->hw_queue_to_mac80211[queue]);
 
 	/* If the queue is still enabled - nothing left to do in this func */
-	if (cmd.action == SCD_CFG_ENABLE_QUEUE) {
-		spin_unlock_bh(&mvm->queue_info_lock);
+	if (cmd.action == SCD_CFG_ENABLE_QUEUE)
 		return 0;
-	}
 
 	cmd.sta_id = mvm->queue_info[queue].ra_sta_id;
 	cmd.tid = mvm->queue_info[queue].txq_tid;
@@ -448,8 +436,6 @@ static int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue,
 	/* Regardless if this is a reserved TXQ for a STA - mark it as false */
 	mvm->queue_info[queue].reserved = false;
 
-	spin_unlock_bh(&mvm->queue_info_lock);
-
 	iwl_trans_txq_disable(mvm->trans, queue, false);
 	ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, flags,
 				   sizeof(struct iwl_scd_txq_cfg_cmd), &cmd);
@@ -474,10 +460,8 @@ static int iwl_mvm_get_queue_agg_tids(struct iwl_mvm *mvm, int queue)
 	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
 		return -EINVAL;
 
-	spin_lock_bh(&mvm->queue_info_lock);
 	sta_id = mvm->queue_info[queue].ra_sta_id;
 	tid_bitmap = mvm->queue_info[queue].tid_bitmap;
-	spin_unlock_bh(&mvm->queue_info_lock);
 
 	sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[sta_id],
 					lockdep_is_held(&mvm->mutex));
@@ -516,10 +500,8 @@ static int iwl_mvm_remove_sta_queue_marking(struct iwl_mvm *mvm, int queue)
 	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
 		return -EINVAL;
 
-	spin_lock_bh(&mvm->queue_info_lock);
 	sta_id = mvm->queue_info[queue].ra_sta_id;
 	tid_bitmap = mvm->queue_info[queue].tid_bitmap;
-	spin_unlock_bh(&mvm->queue_info_lock);
 
 	rcu_read_lock();
 
@@ -572,11 +554,9 @@ static int iwl_mvm_free_inactive_queue(struct iwl_mvm *mvm, int queue,
 	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
 		return -EINVAL;
 
-	spin_lock_bh(&mvm->queue_info_lock);
 	txq_curr_ac = mvm->queue_info[queue].mac80211_ac;
 	sta_id = mvm->queue_info[queue].ra_sta_id;
 	tid = mvm->queue_info[queue].txq_tid;
-	spin_unlock_bh(&mvm->queue_info_lock);
 
 	same_sta = sta_id == new_sta_id;
 
@@ -620,7 +600,6 @@ static int iwl_mvm_get_shared_queue(struct iwl_mvm *mvm,
 	 * by the inactivity checker.
 	 */
 	lockdep_assert_held(&mvm->mutex);
-	lockdep_assert_held(&mvm->queue_info_lock);
 
 	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
 		return -EINVAL;
@@ -706,10 +685,7 @@ static int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
 	 * value 3 and VO with value 0, so to check if ac X is lower than ac Y
 	 * we need to check if the numerical value of X is LARGER than of Y.
 	 */
-	spin_lock_bh(&mvm->queue_info_lock);
 	if (ac <= mvm->queue_info[queue].mac80211_ac && !force) {
-		spin_unlock_bh(&mvm->queue_info_lock);
-
 		IWL_DEBUG_TX_QUEUES(mvm,
 				    "No redirection needed on TXQ #%d\n",
 				    queue);
@@ -721,7 +697,6 @@ static int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
 	cmd.tid = mvm->queue_info[queue].txq_tid;
 	mq = mvm->hw_queue_to_mac80211[queue];
 	shared_queue = hweight16(mvm->queue_info[queue].tid_bitmap) > 1;
-	spin_unlock_bh(&mvm->queue_info_lock);
 
 	IWL_DEBUG_TX_QUEUES(mvm, "Redirecting TXQ #%d to FIFO #%d\n",
 			    queue, iwl_mvm_ac_to_tx_fifo[ac]);
@@ -747,9 +722,7 @@ static int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
 	iwl_trans_txq_enable_cfg(mvm->trans, queue, ssn, NULL, wdg_timeout);
 
 	/* Update the TID "owner" of the queue */
-	spin_lock_bh(&mvm->queue_info_lock);
 	mvm->queue_info[queue].txq_tid = tid;
-	spin_unlock_bh(&mvm->queue_info_lock);
 
 	/* TODO: Work-around SCD bug when moving back by multiples of 0x40 */
 
@@ -758,9 +731,7 @@ static int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
 			     cmd.sta_id, tid, IWL_FRAME_LIMIT, ssn);
 
 	/* Update AC marking of the queue */
-	spin_lock_bh(&mvm->queue_info_lock);
 	mvm->queue_info[queue].mac80211_ac = ac;
-	spin_unlock_bh(&mvm->queue_info_lock);
 
 	/*
 	 * Mark queue as shared in transport if shared
@@ -783,7 +754,7 @@ static int iwl_mvm_find_free_queue(struct iwl_mvm *mvm, u8 sta_id,
 {
 	int i;
 
-	lockdep_assert_held(&mvm->queue_info_lock);
+	lockdep_assert_held(&mvm->mutex);
 
 	/* This should not be hit with new TX path */
 	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
@@ -863,11 +834,8 @@ static bool iwl_mvm_update_txq_mapping(struct iwl_mvm *mvm, int queue,
 {
 	bool enable_queue = true;
 
-	spin_lock_bh(&mvm->queue_info_lock);
-
 	/* Make sure this TID isn't already enabled */
 	if (mvm->queue_info[queue].tid_bitmap & BIT(tid)) {
-		spin_unlock_bh(&mvm->queue_info_lock);
 		IWL_ERR(mvm, "Trying to enable TXQ %d with existing TID %d\n",
 			queue, tid);
 		return false;
@@ -903,8 +871,6 @@ static bool iwl_mvm_update_txq_mapping(struct iwl_mvm *mvm, int queue,
 			    queue, mvm->queue_info[queue].tid_bitmap,
 			    mvm->hw_queue_to_mac80211[queue]);
 
-	spin_unlock_bh(&mvm->queue_info_lock);
-
 	return enable_queue;
 }
 
@@ -959,9 +925,7 @@ static void iwl_mvm_change_queue_tid(struct iwl_mvm *mvm, int queue)
 	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
 		return;
 
-	spin_lock_bh(&mvm->queue_info_lock);
 	tid_bitmap = mvm->queue_info[queue].tid_bitmap;
-	spin_unlock_bh(&mvm->queue_info_lock);
 
 	if (WARN(!tid_bitmap, "TXQ %d has no tids assigned to it\n", queue))
 		return;
@@ -978,9 +942,7 @@ static void iwl_mvm_change_queue_tid(struct iwl_mvm *mvm, int queue)
 		return;
 	}
 
-	spin_lock_bh(&mvm->queue_info_lock);
 	mvm->queue_info[queue].txq_tid = tid;
-	spin_unlock_bh(&mvm->queue_info_lock);
 	IWL_DEBUG_TX_QUEUES(mvm, "Changed TXQ %d ownership to tid %d\n",
 			    queue, tid);
 }
@@ -1002,10 +964,8 @@ static void iwl_mvm_unshare_queue(struct iwl_mvm *mvm, int queue)
 
 	lockdep_assert_held(&mvm->mutex);
 
-	spin_lock_bh(&mvm->queue_info_lock);
 	sta_id = mvm->queue_info[queue].ra_sta_id;
 	tid_bitmap = mvm->queue_info[queue].tid_bitmap;
-	spin_unlock_bh(&mvm->queue_info_lock);
 
 	/* Find TID for queue, and make sure it is the only one on the queue */
 	tid = find_first_bit(&tid_bitmap, IWL_MAX_TID_COUNT + 1);
@@ -1062,9 +1022,7 @@ static void iwl_mvm_unshare_queue(struct iwl_mvm *mvm, int queue)
 		}
 	}
 
-	spin_lock_bh(&mvm->queue_info_lock);
 	mvm->queue_info[queue].status = IWL_MVM_QUEUE_READY;
-	spin_unlock_bh(&mvm->queue_info_lock);
 }
 
 /*
@@ -1083,7 +1041,7 @@ static bool iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 	int tid;
 
 	lockdep_assert_held(&mvmsta->lock);
-	lockdep_assert_held(&mvm->queue_info_lock);
+	lockdep_assert_held(&mvm->mutex);
 
 	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
 		return false;
@@ -1184,8 +1142,6 @@ static int iwl_mvm_inactivity_check(struct iwl_mvm *mvm, u8 alloc_for_sta)
 	if (iwl_mvm_has_new_tx_api(mvm))
 		return -ENOSPC;
 
-	spin_lock_bh(&mvm->queue_info_lock);
-
 	rcu_read_lock();
 
 	/* we skip the CMD queue below by starting at 1 */
@@ -1240,12 +1196,7 @@ static int iwl_mvm_inactivity_check(struct iwl_mvm *mvm, u8 alloc_for_sta)
 
 		mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
-		/* this isn't so nice, but works OK due to the way we loop */
-		spin_unlock(&mvm->queue_info_lock);
-
-		/* and we need this locking order */
-		spin_lock(&mvmsta->lock);
-		spin_lock(&mvm->queue_info_lock);
+		spin_lock_bh(&mvmsta->lock);
 		ret = iwl_mvm_remove_inactive_tids(mvm, mvmsta, i,
 						   inactive_tid_bitmap,
 						   &unshare_queues,
@@ -1253,11 +1204,10 @@ static int iwl_mvm_inactivity_check(struct iwl_mvm *mvm, u8 alloc_for_sta)
 		if (ret >= 0 && free_queue < 0)
 			free_queue = ret;
 		/* only unlock sta lock - we still need the queue info lock */
-		spin_unlock(&mvmsta->lock);
+		spin_unlock_bh(&mvmsta->lock);
 	}
 
 	rcu_read_unlock();
-	spin_unlock_bh(&mvm->queue_info_lock);
 
 	/* Reconfigure queues requiring reconfiguation */
 	for_each_set_bit(i, &unshare_queues, IWL_MAX_HW_QUEUES)
@@ -1306,8 +1256,6 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	tfd_queue_mask = mvmsta->tfd_queue_msk;
 	spin_unlock_bh(&mvmsta->lock);
 
-	spin_lock_bh(&mvm->queue_info_lock);
-
 	/*
 	 * Non-QoS, QoS NDP and MGMT frames should go to a MGMT queue, if one
 	 * exists
@@ -1337,12 +1285,8 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 						IWL_MVM_DQA_MIN_DATA_QUEUE,
 						IWL_MVM_DQA_MAX_DATA_QUEUE);
 	if (queue < 0) {
-		spin_unlock_bh(&mvm->queue_info_lock);
-
 		/* try harder - perhaps kill an inactive queue */
 		queue = iwl_mvm_inactivity_check(mvm, mvmsta->sta_id);
-
-		spin_lock_bh(&mvm->queue_info_lock);
 	}
 
 	/* No free queue - we'll have to share */
@@ -1363,8 +1307,6 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	if (queue > 0 && !shared_queue)
 		mvm->queue_info[queue].status = IWL_MVM_QUEUE_READY;
 
-	spin_unlock_bh(&mvm->queue_info_lock);
-
 	/* This shouldn't happen - out of queues */
 	if (WARN_ON(queue <= 0)) {
 		IWL_ERR(mvm, "No available queues for tid %d on sta_id %d\n",
@@ -1566,8 +1508,6 @@ static int iwl_mvm_reserve_sta_stream(struct iwl_mvm *mvm,
 	/* run the general cleanup/unsharing of queues */
 	iwl_mvm_inactivity_check(mvm, IWL_MVM_INVALID_STA);
 
-	spin_lock_bh(&mvm->queue_info_lock);
-
 	/* Make sure we have free resources for this STA */
 	if (vif_type == NL80211_IFTYPE_STATION && !sta->tdls &&
 	    !mvm->queue_info[IWL_MVM_DQA_BSS_CLIENT_QUEUE].tid_bitmap &&
@@ -1579,19 +1519,15 @@ static int iwl_mvm_reserve_sta_stream(struct iwl_mvm *mvm,
 						IWL_MVM_DQA_MIN_DATA_QUEUE,
 						IWL_MVM_DQA_MAX_DATA_QUEUE);
 	if (queue < 0) {
-		spin_unlock_bh(&mvm->queue_info_lock);
 		/* try again - this time kick out a queue if needed */
 		queue = iwl_mvm_inactivity_check(mvm, mvmsta->sta_id);
 		if (queue < 0) {
 			IWL_ERR(mvm, "No available queues for new station\n");
 			return -ENOSPC;
 		}
-		spin_lock_bh(&mvm->queue_info_lock);
 	}
 	mvm->queue_info[queue].status = IWL_MVM_QUEUE_RESERVED;
 
-	spin_unlock_bh(&mvm->queue_info_lock);
-
 	mvmsta->reserved_queue = queue;
 
 	IWL_DEBUG_TX_QUEUES(mvm, "Reserving data queue #%d for sta_id %d\n",
@@ -2014,18 +1950,14 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 		 * is still marked as IWL_MVM_QUEUE_RESERVED, and
 		 * should be manually marked as free again
 		 */
-		spin_lock_bh(&mvm->queue_info_lock);
 		status = &mvm->queue_info[reserved_txq].status;
 		if (WARN((*status != IWL_MVM_QUEUE_RESERVED) &&
 			 (*status != IWL_MVM_QUEUE_FREE),
 			 "sta_id %d reserved txq %d status %d",
-			 sta_id, reserved_txq, *status)) {
-			spin_unlock_bh(&mvm->queue_info_lock);
+			 sta_id, reserved_txq, *status))
 			return -EINVAL;
-		}
 
 		*status = IWL_MVM_QUEUE_FREE;
-		spin_unlock_bh(&mvm->queue_info_lock);
 	}
 
 	if (vif->type == NL80211_IFTYPE_STATION &&
@@ -2883,8 +2815,6 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		return -EIO;
 	}
 
-	spin_lock(&mvm->queue_info_lock);
-
 	/*
 	 * Note the possible cases:
 	 *  1. An enabled TXQ - TXQ needs to become agg'ed
@@ -2899,7 +2829,7 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		if (txq_id < 0) {
 			ret = txq_id;
 			IWL_ERR(mvm, "Failed to allocate agg queue\n");
-			goto release_locks;
+			goto out;
 		}
 
 		/* TXQ hasn't yet been enabled, so mark it only as reserved */
@@ -2910,11 +2840,9 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		IWL_DEBUG_TX_QUEUES(mvm,
 				    "Can't start tid %d agg on shared queue!\n",
 				    tid);
-		goto release_locks;
+		goto out;
 	}
 
-	spin_unlock(&mvm->queue_info_lock);
-
 	IWL_DEBUG_TX_QUEUES(mvm,
 			    "AGG for tid %d will be on queue #%d\n",
 			    tid, txq_id);
@@ -2945,10 +2873,7 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	}
 
 	ret = 0;
-	goto out;
 
-release_locks:
-	spin_unlock(&mvm->queue_info_lock);
 out:
 	spin_unlock_bh(&mvmsta->lock);
 
@@ -3017,9 +2942,7 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	cfg.fifo = iwl_mvm_ac_to_tx_fifo[tid_to_mac80211_ac[tid]];
 
-	spin_lock_bh(&mvm->queue_info_lock);
 	queue_status = mvm->queue_info[queue].status;
-	spin_unlock_bh(&mvm->queue_info_lock);
 
 	/* Maybe there is no need to even alloc a queue... */
 	if (mvm->queue_info[queue].status == IWL_MVM_QUEUE_READY)
@@ -3065,9 +2988,7 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	}
 
 	/* No need to mark as reserved */
-	spin_lock_bh(&mvm->queue_info_lock);
 	mvm->queue_info[queue].status = IWL_MVM_QUEUE_READY;
-	spin_unlock_bh(&mvm->queue_info_lock);
 
 out:
 	/*
@@ -3093,10 +3014,11 @@ static void iwl_mvm_unreserve_agg_queue(struct iwl_mvm *mvm,
 {
 	u16 txq_id = tid_data->txq_id;
 
+	lockdep_assert_held(&mvm->mutex);
+
 	if (iwl_mvm_has_new_tx_api(mvm))
 		return;
 
-	spin_lock_bh(&mvm->queue_info_lock);
 	/*
 	 * The TXQ is marked as reserved only if no traffic came through yet
 	 * This means no traffic has been sent on this TID (agg'd or not), so
@@ -3108,8 +3030,6 @@ static void iwl_mvm_unreserve_agg_queue(struct iwl_mvm *mvm,
 		mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_FREE;
 		tid_data->txq_id = IWL_MVM_INVALID_QUEUE;
 	}
-
-	spin_unlock_bh(&mvm->queue_info_lock);
 }
 
 int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index ec57682efe54..320453f51ec7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1160,11 +1160,11 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 		 * If we have timed-out TIDs - schedule the worker that will
 		 * reconfig the queues and update them
 		 *
-		 * Note that the mvm->queue_info_lock isn't being taken here in
-		 * order to not serialize the TX flow. This isn't dangerous
-		 * because scheduling mvm->add_stream_wk can't ruin the state,
-		 * and if we DON'T schedule it due to some race condition then
-		 * next TX we get here we will.
+		 * Note that the no lock is taken here in order to not serialize
+		 * the TX flow. This isn't dangerous because scheduling
+		 * mvm->add_stream_wk can't ruin the state, and if we DON'T
+		 * schedule it due to some race condition then next TX we get
+		 * here we will.
 		 */
 		if (unlikely(mvm->queue_info[txq_id].status ==
 			     IWL_MVM_QUEUE_SHARED &&
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 818e1180bbdd..11730d018e20 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -618,13 +618,9 @@ int iwl_mvm_reconfig_scd(struct iwl_mvm *mvm, int queue, int fifo, int sta_id,
 	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
 		return -EINVAL;
 
-	spin_lock_bh(&mvm->queue_info_lock);
 	if (WARN(mvm->queue_info[queue].tid_bitmap == 0,
-		 "Trying to reconfig unallocated queue %d\n", queue)) {
-		spin_unlock_bh(&mvm->queue_info_lock);
+		 "Trying to reconfig unallocated queue %d\n", queue))
 		return -ENXIO;
-	}
-	spin_unlock_bh(&mvm->queue_info_lock);
 
 	IWL_DEBUG_TX_QUEUES(mvm, "Reconfig SCD for TXQ #%d\n", queue);
 
-- 
2.19.1

