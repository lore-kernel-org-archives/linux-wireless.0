Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41180 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758003AbcH3Lje (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 07:39:34 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 30 Aug 2016 14:38:54 +0300
Message-Id: <1472557142-14782-8-git-send-email-luca@coelho.fi> (sfid-20160830_133948_057548_E5953109)
In-Reply-To: <1472557142-14782-1-git-send-email-luca@coelho.fi>
References: <1472556999.27868.86.camel@coelho.fi>
 <1472557142-14782-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 08/16] iwlwifi: mvm: support txq tid owner change
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Every active TXQ is assigned to a TID given through the
SCD_CONFIG_CMD, and acts as an identifier in the FW. However,
there may be cases this ownership needs to be changed.

For example, in the following scenario:
 1. TID x is owner of a queue
 2. Due to a shortage of queues, TID y and z share with x
 3. TID x becomes inactive and needs to be removed from the
    shared queue.
In this scenario, if another queue is freed and traffic on x
continues, we can't allocate it a new queue as long as it is
the owner of the first queue.

Support moving ownership of a TXQ to a different TID (same
STA) without stopping the queue.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 51 ++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index e87473a..30fc3af 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -850,6 +850,41 @@ out_err:
 	return ret;
 }
 
+static void iwl_mvm_change_queue_owner(struct iwl_mvm *mvm, int queue)
+{
+	struct iwl_scd_txq_cfg_cmd cmd = {
+		.scd_queue = queue,
+		.action = SCD_CFG_UPDATE_QUEUE_TID,
+	};
+	s8 sta_id;
+	int tid;
+	unsigned long tid_bitmap;
+	int ret;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	spin_lock_bh(&mvm->queue_info_lock);
+	sta_id = mvm->queue_info[queue].ra_sta_id;
+	tid_bitmap = mvm->queue_info[queue].tid_bitmap;
+	spin_unlock_bh(&mvm->queue_info_lock);
+
+	if (WARN(!tid_bitmap, "TXQ %d has no tids assigned to it\n", queue))
+		return;
+
+	/* Find any TID for queue */
+	tid = find_first_bit(&tid_bitmap, IWL_MAX_TID_COUNT + 1);
+	cmd.tid = tid;
+	cmd.tx_fifo = iwl_mvm_ac_to_tx_fifo[tid_to_mac80211_ac[tid]];
+
+	ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, 0, sizeof(cmd), &cmd);
+	if (ret)
+		IWL_ERR(mvm, "Failed to update owner of TXQ %d (ret=%d)\n",
+			queue, ret);
+	else
+		IWL_DEBUG_TX_QUEUES(mvm, "Changed TXQ %d ownership to tid %d\n",
+				    queue, tid);
+}
+
 static void iwl_mvm_unshare_queue(struct iwl_mvm *mvm, int queue)
 {
 	struct ieee80211_sta *sta;
@@ -1005,14 +1040,30 @@ void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk)
 	/* Reconfigure queues requiring reconfiguation */
 	for (queue = 0; queue < IWL_MAX_HW_QUEUES; queue++) {
 		bool reconfig;
+		bool change_owner;
 
 		spin_lock_bh(&mvm->queue_info_lock);
 		reconfig = (mvm->queue_info[queue].status ==
 			    IWL_MVM_QUEUE_RECONFIGURING);
+
+		/*
+		 * We need to take into account a situation in which a TXQ was
+		 * allocated to TID x, and then turned shared by adding TIDs y
+		 * and z. If TID x becomes inactive and is removed from the TXQ,
+		 * ownership must be given to one of the remaining TIDs.
+		 * This is mainly because if TID x continues - a new queue can't
+		 * be allocated for it as long as it is an owner of another TXQ.
+		 */
+		change_owner = !(mvm->queue_info[queue].tid_bitmap &
+				 BIT(mvm->queue_info[queue].txq_tid)) &&
+			       (mvm->queue_info[queue].status ==
+				IWL_MVM_QUEUE_SHARED);
 		spin_unlock_bh(&mvm->queue_info_lock);
 
 		if (reconfig)
 			iwl_mvm_unshare_queue(mvm, queue);
+		else if (change_owner)
+			iwl_mvm_change_queue_owner(mvm, queue);
 	}
 
 	/* Go over all stations with deferred traffic */
-- 
2.8.1
