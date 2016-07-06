Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33596 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753933AbcGFKqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:46:14 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:37 +0300
Message-Id: <1467801651-1816-42-git-send-email-luca@coelho.fi> (sfid-20160706_125024_780473_D1643AA7)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 42/56] iwlwifi: mvm: support dqa-mode scd queue redirection
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Make sure that in DQA mode, the SCD's configuration of a
queue is redirected to the lower AC of the streams of the
queue.

Make sure that this queue is redirected to the lowest AC
when adding a new RA/TID to an existing queue. If it isn't -
redirect the queue.

Also, as redirection revealed a bug in the marking of a
shared queue, this patch contains a small fix to make
sure a shared queue maintains the appropriate "shared queue
marking".

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 115 +++++++++++++++++++++++++--
 1 file changed, 110 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 1617de7..a6d6df9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -513,6 +513,101 @@ static int iwl_mvm_get_shared_queue(struct iwl_mvm *mvm,
 	return queue;
 }
 
+/*
+ * If a given queue has a higher AC than the TID stream that is being added to
+ * it, the queue needs to be redirected to the lower AC. This function does that
+ * in such a case, otherwise - if no redirection required - it does nothing,
+ * unless the %force param is true.
+ */
+static int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
+				      int ac, int ssn, unsigned int wdg_timeout,
+				      bool force)
+{
+	struct iwl_scd_txq_cfg_cmd cmd = {
+		.scd_queue = queue,
+		.enable = 0,
+	};
+	bool shared_queue;
+	unsigned long mq;
+	int ret;
+
+	/*
+	 * If the AC is lower than current one - FIFO needs to be redirected to
+	 * the lowest one of the streams in the queue. Check if this is needed
+	 * here.
+	 * Notice that the enum ieee80211_ac_numbers is "flipped", so BK is with
+	 * value 3 and VO with value 0, so to check if ac X is lower than ac Y
+	 * we need to check if the numerical value of X is LARGER than of Y.
+	 */
+	spin_lock_bh(&mvm->queue_info_lock);
+	if (ac <= mvm->queue_info[queue].mac80211_ac && !force) {
+		spin_unlock_bh(&mvm->queue_info_lock);
+
+		IWL_DEBUG_TX_QUEUES(mvm,
+				    "No redirection needed on TXQ #%d\n",
+				    queue);
+		return 0;
+	}
+
+	cmd.sta_id = mvm->queue_info[queue].ra_sta_id;
+	cmd.tx_fifo = iwl_mvm_ac_to_tx_fifo[mvm->queue_info[queue].mac80211_ac];
+	mq = mvm->queue_info[queue].hw_queue_to_mac80211;
+	shared_queue = (mvm->queue_info[queue].hw_queue_refcount > 1);
+	spin_unlock_bh(&mvm->queue_info_lock);
+
+	IWL_DEBUG_TX_QUEUES(mvm, "Redirecting shared TXQ #%d to FIFO #%d\n",
+			    queue, iwl_mvm_ac_to_tx_fifo[ac]);
+
+	/* Stop MAC queues and wait for this queue to empty */
+	iwl_mvm_stop_mac_queues(mvm, mq);
+	ret = iwl_trans_wait_tx_queue_empty(mvm->trans, BIT(queue));
+	if (ret) {
+		IWL_ERR(mvm, "Error draining queue %d before reconfig\n",
+			queue);
+		ret = -EIO;
+		goto out;
+	}
+
+	/* Before redirecting the queue we need to de-activate it */
+	iwl_trans_txq_disable(mvm->trans, queue, false);
+	ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, 0, sizeof(cmd), &cmd);
+	if (ret)
+		IWL_ERR(mvm, "Failed SCD disable TXQ %d (ret=%d)\n", queue,
+			ret);
+
+	/* Make sure the SCD wrptr is correctly set before reconfiguring */
+	iwl_trans_txq_enable(mvm->trans, queue, iwl_mvm_ac_to_tx_fifo[ac],
+			     cmd.sta_id, tid, LINK_QUAL_AGG_FRAME_LIMIT_DEF,
+			     ssn, wdg_timeout);
+
+	/* TODO: Work-around SCD bug when moving back by multiples of 0x40 */
+
+	/* Redirect to lower AC */
+	iwl_mvm_reconfig_scd(mvm, queue, iwl_mvm_ac_to_tx_fifo[ac],
+			     cmd.sta_id, tid, LINK_QUAL_AGG_FRAME_LIMIT_DEF,
+			     ssn);
+
+	/* Update AC marking of the queue */
+	spin_lock_bh(&mvm->queue_info_lock);
+	mvm->queue_info[queue].mac80211_ac = ac;
+	spin_unlock_bh(&mvm->queue_info_lock);
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
+out:
+	/* Continue using the MAC queues */
+	iwl_mvm_start_mac_queues(mvm, mq);
+
+	return ret;
+}
+
 static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 				   struct ieee80211_sta *sta, u8 ac, int tid,
 				   struct ieee80211_hdr *hdr)
@@ -680,17 +775,21 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 			iwl_mvm_invalidate_sta_queue(mvm, queue,
 						     disable_agg_tids, false);
 		}
-
-		/* Mark queue as shared in transport */
-		iwl_trans_txq_set_shared_mode(mvm->trans, queue, true);
-
-		/* TODO: a redirection may be required - DQA phase 2 */
 	}
 
 	ssn = IEEE80211_SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
 	iwl_mvm_enable_txq(mvm, queue, mac_queue, ssn, &cfg,
 			   wdg_timeout);
 
+	/*
+	 * Mark queue as shared in transport if shared
+	 * Note this has to be done after queue enablement because enablement
+	 * can also set this value, and there is no indication there to shared
+	 * queues
+	 */
+	if (shared_queue)
+		iwl_trans_txq_set_shared_mode(mvm->trans, queue, true);
+
 	spin_lock_bh(&mvmsta->lock);
 	mvmsta->tid_data[tid].txq_id = queue;
 	mvmsta->tid_data[tid].is_tid_active = true;
@@ -712,6 +811,12 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 			if (ret)
 				goto out_err;
 		}
+	} else {
+		/* Redirect queue, if needed */
+		ret = iwl_mvm_scd_queue_redirect(mvm, queue, tid, ac, ssn,
+						 wdg_timeout, false);
+		if (ret)
+			goto out_err;
 	}
 
 	return 0;
-- 
2.8.1

