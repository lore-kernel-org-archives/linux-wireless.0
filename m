Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54340 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1954317AbdDYUaM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:30:12 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:40 +0300
Message-Id: <20170425202243.7844-23-luca@coelho.fi> (sfid-20170425_223021_623070_648A0843)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 22/25] iwlwifi: rename wait_for_tx_queues_empty
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Rename current wait_tx_queue_empty to wait_tx_queues_empty since
it waits for multiple queues (up to 32).
Next patch will add a wait for single TX queue which is needed for
gen2 to be scalable for 512.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c      |  2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h    |  8 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 14 +++++++-------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c   |  2 +-
 6 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
index 6c2d6da7eec6..74e52f7c5aa1 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
@@ -180,7 +180,7 @@ void iwlagn_dev_txfifo_flush(struct iwl_priv *priv)
 		goto done;
 	}
 	IWL_DEBUG_INFO(priv, "wait transmit/flush all frames\n");
-	iwl_trans_wait_tx_queue_empty(priv->trans, 0xffffffff);
+	iwl_trans_wait_tx_queues_empty(priv->trans, 0xffffffff);
 done:
 	ieee80211_wake_queues(priv->hw);
 	mutex_unlock(&priv->mutex);
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index 2a04d0cd71ae..5fd307da562e 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -1143,7 +1143,7 @@ static void iwlagn_mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	}
 
 	IWL_DEBUG_TX_QUEUES(priv, "wait transmit/flush all frames\n");
-	iwl_trans_wait_tx_queue_empty(priv->trans, scd_queues);
+	iwl_trans_wait_tx_queues_empty(priv->trans, scd_queues);
 done:
 	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 181636861cb6..0ebfdbb22992 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -691,7 +691,7 @@ struct iwl_trans_ops {
 	void (*txq_set_shared_mode)(struct iwl_trans *trans, u32 txq_id,
 				    bool shared);
 
-	int (*wait_tx_queue_empty)(struct iwl_trans *trans, u32 txq_bm);
+	int (*wait_tx_queues_empty)(struct iwl_trans *trans, u32 txq_bm);
 	void (*freeze_txq_timer)(struct iwl_trans *trans, unsigned long txqs,
 				 bool freeze);
 	void (*block_txq_ptrs)(struct iwl_trans *trans, bool block);
@@ -1195,15 +1195,15 @@ static inline void iwl_trans_block_txq_ptrs(struct iwl_trans *trans,
 		trans->ops->block_txq_ptrs(trans, block);
 }
 
-static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans,
-						u32 txqs)
+static inline int iwl_trans_wait_tx_queues_empty(struct iwl_trans *trans,
+						 u32 txqs)
 {
 	if (WARN_ON_ONCE(trans->state != IWL_TRANS_FW_ALIVE)) {
 		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
 		return -EIO;
 	}
 
-	return trans->ops->wait_tx_queue_empty(trans, txqs);
+	return trans->ops->wait_tx_queues_empty(trans, txqs);
 }
 
 static inline void iwl_trans_write8(struct iwl_trans *trans, u32 ofs, u8 val)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index c121982d781e..d91b28c3ea5e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1478,7 +1478,7 @@ static void iwl_mvm_prepare_mac_removal(struct iwl_mvm *mvm,
 		 * already marked as draining, so to complete the draining, we
 		 * just need to wait until the transport is empty.
 		 */
-		iwl_trans_wait_tx_queue_empty(mvm->trans, tfd_msk);
+		iwl_trans_wait_tx_queues_empty(mvm->trans, tfd_msk);
 	}
 
 	if (vif->type == NL80211_IFTYPE_P2P_DEVICE) {
@@ -4000,7 +4000,7 @@ static void iwl_mvm_mac_flush(struct ieee80211_hw *hw,
 		/* this can take a while, and we may need/want other operations
 		 * to succeed while doing this, so do it without the mutex held
 		 */
-		iwl_trans_wait_tx_queue_empty(mvm->trans, msk);
+		iwl_trans_wait_tx_queues_empty(mvm->trans, msk);
 	}
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index d06ba5cb7297..f5c786ddc526 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -658,7 +658,7 @@ int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
 
 	/* Stop MAC queues and wait for this queue to empty */
 	iwl_mvm_stop_mac_queues(mvm, mq);
-	ret = iwl_trans_wait_tx_queue_empty(mvm->trans, BIT(queue));
+	ret = iwl_trans_wait_tx_queues_empty(mvm->trans, BIT(queue));
 	if (ret) {
 		IWL_ERR(mvm, "Error draining queue %d before reconfig\n",
 			queue);
@@ -1614,8 +1614,8 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 		ret = iwl_mvm_flush_tx_path(mvm, mvm_sta->tfd_queue_msk, 0);
 		if (ret)
 			return ret;
-		ret = iwl_trans_wait_tx_queue_empty(mvm->trans,
-						    mvm_sta->tfd_queue_msk);
+		ret = iwl_trans_wait_tx_queues_empty(mvm->trans,
+						     mvm_sta->tfd_queue_msk);
 		if (ret)
 			return ret;
 		ret = iwl_mvm_drain_sta(mvm, mvm_sta, false);
@@ -2659,8 +2659,8 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			 * If reconfiguring an existing queue, it first must be
 			 * drained
 			 */
-			ret = iwl_trans_wait_tx_queue_empty(mvm->trans,
-							    BIT(queue));
+			ret = iwl_trans_wait_tx_queues_empty(mvm->trans,
+							     BIT(queue));
 			if (ret) {
 				IWL_ERR(mvm,
 					"Error draining queue before reconfig\n");
@@ -2846,8 +2846,8 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		iwl_mvm_drain_sta(mvm, mvmsta, true);
 		if (iwl_mvm_flush_tx_path(mvm, BIT(txq_id), 0))
 			IWL_ERR(mvm, "Couldn't flush the AGG queue\n");
-		iwl_trans_wait_tx_queue_empty(mvm->trans,
-					      mvmsta->tfd_queue_msk);
+		iwl_trans_wait_tx_queues_empty(mvm->trans,
+					       mvmsta->tfd_queue_msk);
 		iwl_mvm_drain_sta(mvm, mvmsta, false);
 
 		iwl_mvm_sta_tx_agg(mvm, sta, tid, txq_id, false);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index c551ba8809db..70acf850a9f1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2833,7 +2833,7 @@ static void iwl_trans_pcie_resume(struct iwl_trans *trans)
 	.ref = iwl_trans_pcie_ref,					\
 	.unref = iwl_trans_pcie_unref,					\
 	.dump_data = iwl_trans_pcie_dump_data,				\
-	.wait_tx_queue_empty = iwl_trans_pcie_wait_txq_empty,		\
+	.wait_tx_queues_empty = iwl_trans_pcie_wait_txq_empty,		\
 	.d3_suspend = iwl_trans_pcie_d3_suspend,			\
 	.d3_resume = iwl_trans_pcie_d3_resume
 
-- 
2.11.0
