Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60932 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751125AbdFBL2Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 07:28:24 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 14:25:53 +0300
Message-Id: <20170602112553.2466-26-luca@coelho.fi> (sfid-20170602_132829_034963_9A3FA417)
In-Reply-To: <20170602112553.2466-1-luca@coelho.fi>
References: <20170602112553.2466-1-luca@coelho.fi>
Subject: [PATCH 25/25] iwlwifi: add wait for tx queue empty
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Now that we have 512 queues, add a wait for single TX
queue to gen2.
This replaces gen1 wait_tx_queues_empty, which was limited
to 32 queues.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c    |  2 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h    | 20 ++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 41 ++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h      |  2 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c   | 72 ++++++++++++++---------
 6 files changed, 107 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 0bde26bab15d..c0871f8f2c68 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -102,6 +102,8 @@ struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 	if (!trans->dev_cmd_pool)
 		return NULL;
 
+	WARN_ON(!ops->wait_txq_empty && !ops->wait_tx_queues_empty);
+
 	return trans;
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 0ebfdbb22992..d3a78a11821a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -619,7 +619,8 @@ struct iwl_tx_queue_cfg_rsp {
  * @txq_disable: de-configure a Tx queue to send AMPDUs
  *	Must be atomic
  * @txq_set_shared_mode: change Tx queue shared/unshared marking
- * @wait_tx_queue_empty: wait until tx queues are empty. May sleep.
+ * @wait_tx_queues_empty: wait until tx queues are empty. May sleep.
+ * @wait_txq_empty: wait until specific tx queue is empty. May sleep.
  * @freeze_txq_timer: prevents the timer of the queue from firing until the
  *	queue is set to awake. Must be atomic.
  * @block_txq_ptrs: stop updating the write pointers of the Tx queues. Note
@@ -692,6 +693,7 @@ struct iwl_trans_ops {
 				    bool shared);
 
 	int (*wait_tx_queues_empty)(struct iwl_trans *trans, u32 txq_bm);
+	int (*wait_txq_empty)(struct iwl_trans *trans, int queue);
 	void (*freeze_txq_timer)(struct iwl_trans *trans, unsigned long txqs,
 				 bool freeze);
 	void (*block_txq_ptrs)(struct iwl_trans *trans, bool block);
@@ -1198,6 +1200,9 @@ static inline void iwl_trans_block_txq_ptrs(struct iwl_trans *trans,
 static inline int iwl_trans_wait_tx_queues_empty(struct iwl_trans *trans,
 						 u32 txqs)
 {
+	if (WARN_ON_ONCE(!trans->ops->wait_tx_queues_empty))
+		return -ENOTSUPP;
+
 	if (WARN_ON_ONCE(trans->state != IWL_TRANS_FW_ALIVE)) {
 		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
 		return -EIO;
@@ -1206,6 +1211,19 @@ static inline int iwl_trans_wait_tx_queues_empty(struct iwl_trans *trans,
 	return trans->ops->wait_tx_queues_empty(trans, txqs);
 }
 
+static inline int iwl_trans_wait_txq_empty(struct iwl_trans *trans, int queue)
+{
+	if (WARN_ON_ONCE(!trans->ops->wait_txq_empty))
+		return -ENOTSUPP;
+
+	if (WARN_ON_ONCE(trans->state != IWL_TRANS_FW_ALIVE)) {
+		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
+		return -EIO;
+	}
+
+	return trans->ops->wait_txq_empty(trans, queue);
+}
+
 static inline void iwl_trans_write8(struct iwl_trans *trans, u32 ofs, u8 val)
 {
 	trans->ops->write8(trans, ofs, val);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index f4437d5b2e73..50510e96a82d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3995,6 +3995,8 @@ static void iwl_mvm_mac_flush(struct ieee80211_hw *hw,
 				IWL_ERR(mvm, "flush request fail\n");
 		} else {
 			msk |= mvmsta->tfd_queue_msk;
+			if (iwl_mvm_has_new_tx_api(mvm))
+				iwl_mvm_wait_sta_queues_empty(mvm, mvmsta);
 		}
 	}
 
@@ -4003,7 +4005,7 @@ static void iwl_mvm_mac_flush(struct ieee80211_hw *hw,
 	/* this can take a while, and we may need/want other operations
 	 * to succeed while doing this, so do it without the mutex held
 	 */
-	if (!drop)
+	if (!drop && !iwl_mvm_has_new_tx_api(mvm))
 		iwl_trans_wait_tx_queues_empty(mvm->trans, msk);
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 9f74d4ff6b73..3dad87b79cf0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1590,6 +1590,29 @@ static void iwl_mvm_disable_sta_queues(struct iwl_mvm *mvm,
 	}
 }
 
+int iwl_mvm_wait_sta_queues_empty(struct iwl_mvm *mvm,
+				  struct iwl_mvm_sta *mvm_sta)
+{
+	int i, ret;
+
+	for (i = 0; i < ARRAY_SIZE(mvm_sta->tid_data); i++) {
+		u16 txq_id;
+
+		spin_lock_bh(&mvm_sta->lock);
+		txq_id = mvm_sta->tid_data[i].txq_id;
+		spin_unlock_bh(&mvm_sta->lock);
+
+		if (txq_id == IWL_MVM_INVALID_QUEUE)
+			continue;
+
+		ret = iwl_trans_wait_txq_empty(mvm->trans, txq_id);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
 int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 		   struct ieee80211_vif *vif,
 		   struct ieee80211_sta *sta)
@@ -1614,8 +1637,14 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 		ret = iwl_mvm_flush_sta(mvm, mvm_sta, false, 0);
 		if (ret)
 			return ret;
-		ret = iwl_trans_wait_tx_queues_empty(mvm->trans,
-						     mvm_sta->tfd_queue_msk);
+		if (iwl_mvm_has_new_tx_api(mvm)) {
+			ret = iwl_mvm_wait_sta_queues_empty(mvm, mvm_sta);
+		} else {
+			u32 q_mask = mvm_sta->tfd_queue_msk;
+
+			ret = iwl_trans_wait_tx_queues_empty(mvm->trans,
+							     q_mask);
+		}
 		if (ret)
 			return ret;
 		ret = iwl_mvm_drain_sta(mvm, mvm_sta, false);
@@ -2850,7 +2879,13 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		iwl_mvm_drain_sta(mvm, mvmsta, true);
 		if (iwl_mvm_flush_tx_path(mvm, BIT(txq_id), 0))
 			IWL_ERR(mvm, "Couldn't flush the AGG queue\n");
-		iwl_trans_wait_tx_queues_empty(mvm->trans, BIT(txq_id));
+
+		if (iwl_mvm_has_new_tx_api(mvm))
+			iwl_trans_wait_txq_empty(mvm->trans, txq_id);
+
+		else
+			iwl_trans_wait_tx_queues_empty(mvm->trans, BIT(txq_id));
+
 		iwl_mvm_drain_sta(mvm, mvmsta, false);
 
 		iwl_mvm_sta_tx_agg(mvm, sta, tid, txq_id, false);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index 2716cb5483bf..1c28caecaa1e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -487,6 +487,8 @@ static inline int iwl_mvm_update_sta(struct iwl_mvm *mvm,
 	return iwl_mvm_sta_send_to_fw(mvm, sta, true, 0);
 }
 
+int iwl_mvm_wait_sta_queues_empty(struct iwl_mvm *mvm,
+				  struct iwl_mvm_sta *mvm_sta);
 int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 		   struct ieee80211_vif *vif,
 		   struct ieee80211_sta *sta);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 85f44d8f1c41..a6c171c5b26f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2045,17 +2045,52 @@ void iwl_trans_pcie_log_scd_error(struct iwl_trans *trans, struct iwl_txq *txq)
 		iwl_read_direct32(trans, FH_TX_TRB_REG(fifo)));
 }
 
-static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, u32 txq_bm)
+static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, int txq_idx)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq;
-	int cnt;
 	unsigned long now = jiffies;
+	u8 wr_ptr;
+
+	if (!test_bit(txq_idx, trans_pcie->queue_used))
+		return -EINVAL;
+
+	IWL_DEBUG_TX_QUEUES(trans, "Emptying queue %d...\n", txq_idx);
+	txq = trans_pcie->txq[txq_idx];
+	wr_ptr = ACCESS_ONCE(txq->write_ptr);
+
+	while (txq->read_ptr != ACCESS_ONCE(txq->write_ptr) &&
+	       !time_after(jiffies,
+			   now + msecs_to_jiffies(IWL_FLUSH_WAIT_MS))) {
+		u8 write_ptr = ACCESS_ONCE(txq->write_ptr);
+
+		if (WARN_ONCE(wr_ptr != write_ptr,
+			      "WR pointer moved while flushing %d -> %d\n",
+			      wr_ptr, write_ptr))
+			return -ETIMEDOUT;
+		usleep_range(1000, 2000);
+	}
+
+	if (txq->read_ptr != txq->write_ptr) {
+		IWL_ERR(trans,
+			"fail to flush all tx fifo queues Q %d\n", txq_idx);
+		iwl_trans_pcie_log_scd_error(trans, txq);
+		return -ETIMEDOUT;
+	}
+
+	IWL_DEBUG_TX_QUEUES(trans, "Queue %d is now empty.\n", txq_idx);
+
+	return 0;
+}
+
+static int iwl_trans_pcie_wait_txqs_empty(struct iwl_trans *trans, u32 txq_bm)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int cnt;
 	int ret = 0;
 
 	/* waiting for all the tx frames complete might take a while */
 	for (cnt = 0; cnt < trans->cfg->base_params->num_of_queues; cnt++) {
-		u8 wr_ptr;
 
 		if (cnt == trans_pcie->cmd_queue)
 			continue;
@@ -2064,34 +2099,11 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, u32 txq_bm)
 		if (!(BIT(cnt) & txq_bm))
 			continue;
 
-		IWL_DEBUG_TX_QUEUES(trans, "Emptying queue %d...\n", cnt);
-		txq = trans_pcie->txq[cnt];
-		wr_ptr = ACCESS_ONCE(txq->write_ptr);
-
-		while (txq->read_ptr != ACCESS_ONCE(txq->write_ptr) &&
-		       !time_after(jiffies,
-				   now + msecs_to_jiffies(IWL_FLUSH_WAIT_MS))) {
-			u8 write_ptr = ACCESS_ONCE(txq->write_ptr);
-
-			if (WARN_ONCE(wr_ptr != write_ptr,
-				      "WR pointer moved while flushing %d -> %d\n",
-				      wr_ptr, write_ptr))
-				return -ETIMEDOUT;
-			usleep_range(1000, 2000);
-		}
-
-		if (txq->read_ptr != txq->write_ptr) {
-			IWL_ERR(trans,
-				"fail to flush all tx fifo queues Q %d\n", cnt);
-			ret = -ETIMEDOUT;
+		ret = iwl_trans_pcie_wait_txq_empty(trans, cnt);
+		if (ret)
 			break;
-		}
-		IWL_DEBUG_TX_QUEUES(trans, "Queue %d is now empty.\n", cnt);
 	}
 
-	if (ret)
-		iwl_trans_pcie_log_scd_error(trans, txq);
-
 	return ret;
 }
 
@@ -2862,7 +2874,6 @@ static void iwl_trans_pcie_resume(struct iwl_trans *trans)
 	.ref = iwl_trans_pcie_ref,					\
 	.unref = iwl_trans_pcie_unref,					\
 	.dump_data = iwl_trans_pcie_dump_data,				\
-	.wait_tx_queues_empty = iwl_trans_pcie_wait_txq_empty,		\
 	.d3_suspend = iwl_trans_pcie_d3_suspend,			\
 	.d3_resume = iwl_trans_pcie_d3_resume
 
@@ -2892,6 +2903,8 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 
 	.txq_set_shared_mode = iwl_trans_pcie_txq_set_shared_mode,
 
+	.wait_tx_queues_empty = iwl_trans_pcie_wait_txqs_empty,
+
 	.freeze_txq_timer = iwl_trans_pcie_freeze_txq_timer,
 	.block_txq_ptrs = iwl_trans_pcie_block_txq_ptrs,
 };
@@ -2911,6 +2924,7 @@ static const struct iwl_trans_ops trans_ops_pcie_gen2 = {
 
 	.txq_alloc = iwl_trans_pcie_dyn_txq_alloc,
 	.txq_free = iwl_trans_pcie_dyn_txq_free,
+	.wait_txq_empty = iwl_trans_pcie_wait_txq_empty,
 };
 
 struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
-- 
2.11.0
