Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB6D1C00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80B8D2087C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:18:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80B8D2087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbeJHP3F (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:29:05 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:56452 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725973AbeJHP3E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:29:04 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g9Qjj-0003w6-Gz; Mon, 08 Oct 2018 11:17:56 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  8 Oct 2018 11:17:34 +0300
Message-Id: <20181008081735.3401-18-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181008081735.3401-1-luca@coelho.fi>
References: <20181008081735.3401-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 17/18] iwlwifi: mvm: move iwl_mvm_sta_alloc_queue() down
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

We want to call iwl_mvm_inactivity_check() from here in the
next patch, so need to move the code down to be able to.

Fix a minor checkpatch complaint while at it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 410 +++++++++----------
 1 file changed, 205 insertions(+), 205 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 24631866a174..8ae4fbf17f03 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -936,211 +936,6 @@ static bool iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue,
 	return inc_ssn;
 }
 
-static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
-				   struct ieee80211_sta *sta, u8 ac, int tid,
-				   struct ieee80211_hdr *hdr)
-{
-	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
-	struct iwl_trans_txq_scd_cfg cfg = {
-		.fifo = iwl_mvm_mac_ac_to_tx_fifo(mvm, ac),
-		.sta_id = mvmsta->sta_id,
-		.tid = tid,
-		.frame_limit = IWL_FRAME_LIMIT,
-	};
-	unsigned int wdg_timeout =
-		iwl_mvm_get_wd_timeout(mvm, mvmsta->vif, false, false);
-	u8 mac_queue = mvmsta->vif->hw_queue[ac];
-	int queue = -1;
-	bool using_inactive_queue = false, same_sta = false;
-	unsigned long disable_agg_tids = 0;
-	enum iwl_mvm_agg_state queue_state;
-	bool shared_queue = false, inc_ssn;
-	int ssn;
-	unsigned long tfd_queue_mask;
-	int ret;
-
-	lockdep_assert_held(&mvm->mutex);
-
-	if (iwl_mvm_has_new_tx_api(mvm))
-		return iwl_mvm_sta_alloc_queue_tvqm(mvm, sta, ac, tid);
-
-	spin_lock_bh(&mvmsta->lock);
-	tfd_queue_mask = mvmsta->tfd_queue_msk;
-	spin_unlock_bh(&mvmsta->lock);
-
-	spin_lock_bh(&mvm->queue_info_lock);
-
-	/*
-	 * Non-QoS, QoS NDP and MGMT frames should go to a MGMT queue, if one
-	 * exists
-	 */
-	if (!ieee80211_is_data_qos(hdr->frame_control) ||
-	    ieee80211_is_qos_nullfunc(hdr->frame_control)) {
-		queue = iwl_mvm_find_free_queue(mvm, mvmsta->sta_id,
-						IWL_MVM_DQA_MIN_MGMT_QUEUE,
-						IWL_MVM_DQA_MAX_MGMT_QUEUE);
-		if (queue >= IWL_MVM_DQA_MIN_MGMT_QUEUE)
-			IWL_DEBUG_TX_QUEUES(mvm, "Found free MGMT queue #%d\n",
-					    queue);
-
-		/* If no such queue is found, we'll use a DATA queue instead */
-	}
-
-	if ((queue < 0 && mvmsta->reserved_queue != IEEE80211_INVAL_HW_QUEUE) &&
-	    (mvm->queue_info[mvmsta->reserved_queue].status ==
-	     IWL_MVM_QUEUE_RESERVED ||
-	     mvm->queue_info[mvmsta->reserved_queue].status ==
-	     IWL_MVM_QUEUE_INACTIVE)) {
-		queue = mvmsta->reserved_queue;
-		mvm->queue_info[queue].reserved = true;
-		IWL_DEBUG_TX_QUEUES(mvm, "Using reserved queue #%d\n", queue);
-	}
-
-	if (queue < 0)
-		queue = iwl_mvm_find_free_queue(mvm, mvmsta->sta_id,
-						IWL_MVM_DQA_MIN_DATA_QUEUE,
-						IWL_MVM_DQA_MAX_DATA_QUEUE);
-
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
-	}
-
-	/* No free queue - we'll have to share */
-	if (queue <= 0) {
-		queue = iwl_mvm_get_shared_queue(mvm, tfd_queue_mask, ac);
-		if (queue > 0) {
-			shared_queue = true;
-			mvm->queue_info[queue].status = IWL_MVM_QUEUE_SHARED;
-		}
-	}
-
-	/*
-	 * Mark TXQ as ready, even though it hasn't been fully configured yet,
-	 * to make sure no one else takes it.
-	 * This will allow avoiding re-acquiring the lock at the end of the
-	 * configuration. On error we'll mark it back as free.
-	 */
-	if ((queue > 0) && !shared_queue)
-		mvm->queue_info[queue].status = IWL_MVM_QUEUE_READY;
-
-	spin_unlock_bh(&mvm->queue_info_lock);
-
-	/* This shouldn't happen - out of queues */
-	if (WARN_ON(queue <= 0)) {
-		IWL_ERR(mvm, "No available queues for tid %d on sta_id %d\n",
-			tid, cfg.sta_id);
-		return queue;
-	}
-
-	/*
-	 * Actual en/disablement of aggregations is through the ADD_STA HCMD,
-	 * but for configuring the SCD to send A-MPDUs we need to mark the queue
-	 * as aggregatable.
-	 * Mark all DATA queues as allowing to be aggregated at some point
-	 */
-	cfg.aggregate = (queue >= IWL_MVM_DQA_MIN_DATA_QUEUE ||
-			 queue == IWL_MVM_DQA_BSS_CLIENT_QUEUE);
-
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
-	IWL_DEBUG_TX_QUEUES(mvm,
-			    "Allocating %squeue #%d to sta %d on tid %d\n",
-			    shared_queue ? "shared " : "", queue,
-			    mvmsta->sta_id, tid);
-
-	if (shared_queue) {
-		/* Disable any open aggs on this queue */
-		disable_agg_tids = iwl_mvm_get_queue_agg_tids(mvm, queue);
-
-		if (disable_agg_tids) {
-			IWL_DEBUG_TX_QUEUES(mvm, "Disabling aggs on queue %d\n",
-					    queue);
-			iwl_mvm_invalidate_sta_queue(mvm, queue,
-						     disable_agg_tids, false);
-		}
-	}
-
-	ssn = IEEE80211_SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
-	inc_ssn = iwl_mvm_enable_txq(mvm, queue, mac_queue,
-				     ssn, &cfg, wdg_timeout);
-	if (inc_ssn) {
-		ssn = (ssn + 1) & IEEE80211_SCTL_SEQ;
-		le16_add_cpu(&hdr->seq_ctrl, 0x10);
-	}
-
-	/*
-	 * Mark queue as shared in transport if shared
-	 * Note this has to be done after queue enablement because enablement
-	 * can also set this value, and there is no indication there to shared
-	 * queues
-	 */
-	if (shared_queue)
-		iwl_trans_txq_set_shared_mode(mvm->trans, queue, true);
-
-	spin_lock_bh(&mvmsta->lock);
-	/*
-	 * This looks racy, but it is not. We have only one packet for
-	 * this ra/tid in our Tx path since we stop the Qdisc when we
-	 * need to allocate a new TFD queue.
-	 */
-	if (inc_ssn)
-		mvmsta->tid_data[tid].seq_number += 0x10;
-	mvmsta->tid_data[tid].txq_id = queue;
-	mvmsta->tid_data[tid].is_tid_active = true;
-	mvmsta->tfd_queue_msk |= BIT(queue);
-	queue_state = mvmsta->tid_data[tid].state;
-
-	if (mvmsta->reserved_queue == queue)
-		mvmsta->reserved_queue = IEEE80211_INVAL_HW_QUEUE;
-	spin_unlock_bh(&mvmsta->lock);
-
-	if (!shared_queue) {
-		ret = iwl_mvm_sta_send_to_fw(mvm, sta, true, STA_MODIFY_QUEUES);
-		if (ret)
-			goto out_err;
-
-		/* If we need to re-enable aggregations... */
-		if (queue_state == IWL_AGG_ON) {
-			ret = iwl_mvm_sta_tx_agg(mvm, sta, tid, queue, true);
-			if (ret)
-				goto out_err;
-		}
-	} else {
-		/* Redirect queue, if needed */
-		ret = iwl_mvm_scd_queue_redirect(mvm, queue, tid, ac, ssn,
-						 wdg_timeout, false);
-		if (ret)
-			goto out_err;
-	}
-
-	return 0;
-
-out_err:
-	iwl_mvm_disable_txq(mvm, queue, mac_queue, tid, 0);
-
-	return ret;
-}
-
 static void iwl_mvm_change_queue_tid(struct iwl_mvm *mvm, int queue)
 {
 	struct iwl_scd_txq_cfg_cmd cmd = {
@@ -1460,6 +1255,211 @@ static void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 		iwl_mvm_change_queue_tid(mvm, i);
 }
 
+static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
+				   struct ieee80211_sta *sta, u8 ac, int tid,
+				   struct ieee80211_hdr *hdr)
+{
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	struct iwl_trans_txq_scd_cfg cfg = {
+		.fifo = iwl_mvm_mac_ac_to_tx_fifo(mvm, ac),
+		.sta_id = mvmsta->sta_id,
+		.tid = tid,
+		.frame_limit = IWL_FRAME_LIMIT,
+	};
+	unsigned int wdg_timeout =
+		iwl_mvm_get_wd_timeout(mvm, mvmsta->vif, false, false);
+	u8 mac_queue = mvmsta->vif->hw_queue[ac];
+	int queue = -1;
+	bool using_inactive_queue = false, same_sta = false;
+	unsigned long disable_agg_tids = 0;
+	enum iwl_mvm_agg_state queue_state;
+	bool shared_queue = false, inc_ssn;
+	int ssn;
+	unsigned long tfd_queue_mask;
+	int ret;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	if (iwl_mvm_has_new_tx_api(mvm))
+		return iwl_mvm_sta_alloc_queue_tvqm(mvm, sta, ac, tid);
+
+	spin_lock_bh(&mvmsta->lock);
+	tfd_queue_mask = mvmsta->tfd_queue_msk;
+	spin_unlock_bh(&mvmsta->lock);
+
+	spin_lock_bh(&mvm->queue_info_lock);
+
+	/*
+	 * Non-QoS, QoS NDP and MGMT frames should go to a MGMT queue, if one
+	 * exists
+	 */
+	if (!ieee80211_is_data_qos(hdr->frame_control) ||
+	    ieee80211_is_qos_nullfunc(hdr->frame_control)) {
+		queue = iwl_mvm_find_free_queue(mvm, mvmsta->sta_id,
+						IWL_MVM_DQA_MIN_MGMT_QUEUE,
+						IWL_MVM_DQA_MAX_MGMT_QUEUE);
+		if (queue >= IWL_MVM_DQA_MIN_MGMT_QUEUE)
+			IWL_DEBUG_TX_QUEUES(mvm, "Found free MGMT queue #%d\n",
+					    queue);
+
+		/* If no such queue is found, we'll use a DATA queue instead */
+	}
+
+	if ((queue < 0 && mvmsta->reserved_queue != IEEE80211_INVAL_HW_QUEUE) &&
+	    (mvm->queue_info[mvmsta->reserved_queue].status ==
+	     IWL_MVM_QUEUE_RESERVED ||
+	     mvm->queue_info[mvmsta->reserved_queue].status ==
+	     IWL_MVM_QUEUE_INACTIVE)) {
+		queue = mvmsta->reserved_queue;
+		mvm->queue_info[queue].reserved = true;
+		IWL_DEBUG_TX_QUEUES(mvm, "Using reserved queue #%d\n", queue);
+	}
+
+	if (queue < 0)
+		queue = iwl_mvm_find_free_queue(mvm, mvmsta->sta_id,
+						IWL_MVM_DQA_MIN_DATA_QUEUE,
+						IWL_MVM_DQA_MAX_DATA_QUEUE);
+
+	/*
+	 * Check if this queue is already allocated but inactive.
+	 * In such a case, we'll need to first free this queue before enabling
+	 * it again, so we'll mark it as reserved to make sure no new traffic
+	 * arrives on it
+	 */
+	if (queue > 0 &&
+	    mvm->queue_info[queue].status == IWL_MVM_QUEUE_INACTIVE) {
+		mvm->queue_info[queue].status = IWL_MVM_QUEUE_RESERVED;
+		using_inactive_queue = true;
+		same_sta = mvm->queue_info[queue].ra_sta_id == mvmsta->sta_id;
+		IWL_DEBUG_TX_QUEUES(mvm,
+				    "Re-assigning TXQ %d: sta_id=%d, tid=%d\n",
+				    queue, mvmsta->sta_id, tid);
+	}
+
+	/* No free queue - we'll have to share */
+	if (queue <= 0) {
+		queue = iwl_mvm_get_shared_queue(mvm, tfd_queue_mask, ac);
+		if (queue > 0) {
+			shared_queue = true;
+			mvm->queue_info[queue].status = IWL_MVM_QUEUE_SHARED;
+		}
+	}
+
+	/*
+	 * Mark TXQ as ready, even though it hasn't been fully configured yet,
+	 * to make sure no one else takes it.
+	 * This will allow avoiding re-acquiring the lock at the end of the
+	 * configuration. On error we'll mark it back as free.
+	 */
+	if (queue > 0 && !shared_queue)
+		mvm->queue_info[queue].status = IWL_MVM_QUEUE_READY;
+
+	spin_unlock_bh(&mvm->queue_info_lock);
+
+	/* This shouldn't happen - out of queues */
+	if (WARN_ON(queue <= 0)) {
+		IWL_ERR(mvm, "No available queues for tid %d on sta_id %d\n",
+			tid, cfg.sta_id);
+		return queue;
+	}
+
+	/*
+	 * Actual en/disablement of aggregations is through the ADD_STA HCMD,
+	 * but for configuring the SCD to send A-MPDUs we need to mark the queue
+	 * as aggregatable.
+	 * Mark all DATA queues as allowing to be aggregated at some point
+	 */
+	cfg.aggregate = (queue >= IWL_MVM_DQA_MIN_DATA_QUEUE ||
+			 queue == IWL_MVM_DQA_BSS_CLIENT_QUEUE);
+
+	/*
+	 * If this queue was previously inactive (idle) - we need to free it
+	 * first
+	 */
+	if (using_inactive_queue) {
+		ret = iwl_mvm_free_inactive_queue(mvm, queue, same_sta);
+		if (ret)
+			return ret;
+	}
+
+	IWL_DEBUG_TX_QUEUES(mvm,
+			    "Allocating %squeue #%d to sta %d on tid %d\n",
+			    shared_queue ? "shared " : "", queue,
+			    mvmsta->sta_id, tid);
+
+	if (shared_queue) {
+		/* Disable any open aggs on this queue */
+		disable_agg_tids = iwl_mvm_get_queue_agg_tids(mvm, queue);
+
+		if (disable_agg_tids) {
+			IWL_DEBUG_TX_QUEUES(mvm, "Disabling aggs on queue %d\n",
+					    queue);
+			iwl_mvm_invalidate_sta_queue(mvm, queue,
+						     disable_agg_tids, false);
+		}
+	}
+
+	ssn = IEEE80211_SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
+	inc_ssn = iwl_mvm_enable_txq(mvm, queue, mac_queue,
+				     ssn, &cfg, wdg_timeout);
+	if (inc_ssn) {
+		ssn = (ssn + 1) & IEEE80211_SCTL_SEQ;
+		le16_add_cpu(&hdr->seq_ctrl, 0x10);
+	}
+
+	/*
+	 * Mark queue as shared in transport if shared
+	 * Note this has to be done after queue enablement because enablement
+	 * can also set this value, and there is no indication there to shared
+	 * queues
+	 */
+	if (shared_queue)
+		iwl_trans_txq_set_shared_mode(mvm->trans, queue, true);
+
+	spin_lock_bh(&mvmsta->lock);
+	/*
+	 * This looks racy, but it is not. We have only one packet for
+	 * this ra/tid in our Tx path since we stop the Qdisc when we
+	 * need to allocate a new TFD queue.
+	 */
+	if (inc_ssn)
+		mvmsta->tid_data[tid].seq_number += 0x10;
+	mvmsta->tid_data[tid].txq_id = queue;
+	mvmsta->tid_data[tid].is_tid_active = true;
+	mvmsta->tfd_queue_msk |= BIT(queue);
+	queue_state = mvmsta->tid_data[tid].state;
+
+	if (mvmsta->reserved_queue == queue)
+		mvmsta->reserved_queue = IEEE80211_INVAL_HW_QUEUE;
+	spin_unlock_bh(&mvmsta->lock);
+
+	if (!shared_queue) {
+		ret = iwl_mvm_sta_send_to_fw(mvm, sta, true, STA_MODIFY_QUEUES);
+		if (ret)
+			goto out_err;
+
+		/* If we need to re-enable aggregations... */
+		if (queue_state == IWL_AGG_ON) {
+			ret = iwl_mvm_sta_tx_agg(mvm, sta, tid, queue, true);
+			if (ret)
+				goto out_err;
+		}
+	} else {
+		/* Redirect queue, if needed */
+		ret = iwl_mvm_scd_queue_redirect(mvm, queue, tid, ac, ssn,
+						 wdg_timeout, false);
+		if (ret)
+			goto out_err;
+	}
+
+	return 0;
+
+out_err:
+	iwl_mvm_disable_txq(mvm, queue, mac_queue, tid, 0);
+
+	return ret;
+}
+
 static inline u8 iwl_mvm_tid_to_ac_queue(int tid)
 {
 	if (tid == IWL_MAX_TID_COUNT)
-- 
2.19.0

