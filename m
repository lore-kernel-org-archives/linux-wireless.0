Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33712 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab2FFNXe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:23:34 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/29] iwlwifi: s/txq_agg_disable/txq_disable
Date: Wed,  6 Jun 2012 15:21:59 +0200
Message-Id: <1338988930-11561-18-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152343_523561_4DC6DC22)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We need to be able to enable / disable Tx queues in HW
dynamically. So this function is no longer related to AGG
only. It can do the job for any queue, even AC ones. Change
the name to better reflect its role.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/tx.c        |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-trans.h     |    8 ++++----
 drivers/net/wireless/iwlwifi/pcie/internal.h |    2 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c    |    2 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c       |    2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 52f2cae..494a25c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -599,7 +599,7 @@ turn_off:
 		 * time, or we hadn't time to drain the AC queues.
 		 */
 		if (agg_state == IWL_AGG_ON)
-			iwl_trans_tx_agg_disable(priv->trans, txq_id);
+			iwl_trans_txq_disable(priv->trans, txq_id);
 		else
 			IWL_DEBUG_TX_QUEUES(priv, "Don't disable tx agg: %d\n",
 					    agg_state);
@@ -755,8 +755,8 @@ static void iwlagn_check_ratid_empty(struct iwl_priv *priv, int sta_id, u8 tid)
 			IWL_DEBUG_TX_QUEUES(priv,
 				"Can continue DELBA flow ssn = next_recl ="
 				" %d", tid_data->next_reclaimed);
-			iwl_trans_tx_agg_disable(priv->trans,
-						 tid_data->agg.txq_id);
+			iwl_trans_txq_disable(priv->trans,
+					      tid_data->agg.txq_id);
 			iwlagn_dealloc_agg_txq(priv, tid_data->agg.txq_id);
 			tid_data->agg.state = IWL_AGG_OFF;
 			ieee80211_stop_tx_ba_cb_irqsafe(vif, addr, tid);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 0aeeb7c..1fff285 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -358,7 +358,7 @@ struct iwl_trans;
  * @tx_agg_setup: setup a tx queue for AMPDU - will be called once the HW is
  *	ready and a successful ADDBA response has been received.
  *	May sleep
- * @tx_agg_disable: de-configure a Tx queue to send AMPDUs
+ * @txq_disable: de-configure a Tx queue to send AMPDUs
  *	Must be atomic
  * @wait_tx_queue_empty: wait until all tx queues are empty
  *	May sleep
@@ -393,7 +393,7 @@ struct iwl_trans_ops {
 
 	void (*tx_agg_setup)(struct iwl_trans *trans, int queue, int fifo,
 			     int sta_id, int tid, int frame_limit, u16 ssn);
-	void (*tx_agg_disable)(struct iwl_trans *trans, int queue);
+	void (*txq_disable)(struct iwl_trans *trans, int queue);
 
 	int (*dbgfs_register)(struct iwl_trans *trans, struct dentry* dir);
 	int (*wait_tx_queue_empty)(struct iwl_trans *trans);
@@ -543,12 +543,12 @@ static inline void iwl_trans_reclaim(struct iwl_trans *trans, int queue,
 	trans->ops->reclaim(trans, queue, ssn, skbs);
 }
 
-static inline void iwl_trans_tx_agg_disable(struct iwl_trans *trans, int queue)
+static inline void iwl_trans_txq_disable(struct iwl_trans *trans, int queue)
 {
 	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
 		  "%s bad state = %d", __func__, trans->state);
 
-	trans->ops->tx_agg_disable(trans, queue);
+	trans->ops->txq_disable(trans, queue);
 }
 
 static inline void iwl_trans_tx_agg_setup(struct iwl_trans *trans, int queue,
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index f027769..f802b5a 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -339,7 +339,7 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans,
 void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 				       struct iwl_tx_queue *txq,
 				       u16 byte_cnt);
-void iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans, int queue);
+void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int queue);
 void iwl_trans_set_wr_ptrs(struct iwl_trans *trans, int txq_id, u32 index);
 void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
 				   struct iwl_tx_queue *txq,
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 0d0c7d8..7c7702a 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -2039,7 +2039,7 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 	.tx = iwl_trans_pcie_tx,
 	.reclaim = iwl_trans_pcie_reclaim,
 
-	.tx_agg_disable = iwl_trans_pcie_tx_agg_disable,
+	.txq_disable = iwl_trans_pcie_txq_disable,
 	.tx_agg_setup = iwl_trans_pcie_tx_agg_setup,
 
 	.dbgfs_register = iwl_trans_pcie_dbgfs_register,
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 8a331a9..98ddc80 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -487,7 +487,7 @@ void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans, int txq_id, int fifo,
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 }
 
-void iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans, int txq_id)
+void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
-- 
1.7.10

