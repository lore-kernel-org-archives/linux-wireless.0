Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:2928 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbbLUUvN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:51:13 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/45] iwlwifi: pcie: allow the op_mode to block the tx queues
Date: Mon, 21 Dec 2015 22:50:12 +0200
Message-Id: <1450731046-2796-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215157_625705_36BB0EB4)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In certain flows (see next patches), the op_mode may need to
block the Tx queues for a short period. Provide an API for
that. The transport is in charge of counting the number of
times the queues are blocked since the op_mode may block the
queues several times in a row before unblocking them.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     | 16 +++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 28 ++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  4 +++-
 4 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 3d089ae..0cd69cd 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -542,6 +542,11 @@ struct iwl_trans_txq_scd_cfg {
  * @wait_tx_queue_empty: wait until tx queues are empty. May sleep.
  * @freeze_txq_timer: prevents the timer of the queue from firing until the
  *	queue is set to awake. Must be atomic.
+ * @block_txq_ptrs: stop updating the write pointers of the Tx queues. Note
+ *	that the transport needs to refcount the calls since this function
+ *	will be called several times with block = true, and then the queues
+ *	need to be unblocked only after the same number of calls with
+ *	block = false.
  * @write8: write a u8 to a register at offset ofs from the BAR
  * @write32: write a u32 to a register at offset ofs from the BAR
  * @read32: read a u32 register at offset ofs from the BAR
@@ -600,6 +605,7 @@ struct iwl_trans_ops {
 	int (*wait_tx_queue_empty)(struct iwl_trans *trans, u32 txq_bm);
 	void (*freeze_txq_timer)(struct iwl_trans *trans, unsigned long txqs,
 				 bool freeze);
+	void (*block_txq_ptrs)(struct iwl_trans *trans, bool block);
 
 	void (*write8)(struct iwl_trans *trans, u32 ofs, u8 val);
 	void (*write32)(struct iwl_trans *trans, u32 ofs, u32 val);
@@ -1010,6 +1016,16 @@ static inline void iwl_trans_freeze_txq_timer(struct iwl_trans *trans,
 		trans->ops->freeze_txq_timer(trans, txqs, freeze);
 }
 
+static inline void iwl_trans_block_txq_ptrs(struct iwl_trans *trans,
+					    bool block)
+{
+	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE))
+		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
+
+	if (trans->ops->block_txq_ptrs)
+		trans->ops->block_txq_ptrs(trans, block);
+}
+
 static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans,
 						u32 txqs)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 44dc09d..31f30a2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -278,6 +278,7 @@ struct iwl_txq {
 	bool frozen;
 	u8 active;
 	bool ampdu;
+	bool block;
 	unsigned long wd_timeout;
 };
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index efef487..316162a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1673,6 +1673,33 @@ next_queue:
 	}
 }
 
+static void iwl_trans_pcie_block_txq_ptrs(struct iwl_trans *trans, bool block)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int i;
+
+	for (i = 0; i < trans->cfg->base_params->num_of_queues; i++) {
+		struct iwl_txq *txq = &trans_pcie->txq[i];
+
+		if (i == trans_pcie->cmd_queue)
+			continue;
+
+		spin_lock_bh(&txq->lock);
+
+		if (!block && !(WARN_ON_ONCE(!txq->block))) {
+			txq->block--;
+			if (!txq->block) {
+				iwl_write32(trans, HBUS_TARG_WRPTR,
+					    txq->q.write_ptr | (i << 8));
+			}
+		} else if (block) {
+			txq->block++;
+		}
+
+		spin_unlock_bh(&txq->lock);
+	}
+}
+
 #define IWL_FLUSH_WAIT_MS	2000
 
 static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, u32 txq_bm)
@@ -2467,6 +2494,7 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 
 	.wait_tx_queue_empty = iwl_trans_pcie_wait_txq_empty,
 	.freeze_txq_timer = iwl_trans_pcie_freeze_txq_timer,
+	.block_txq_ptrs = iwl_trans_pcie_block_txq_ptrs,
 
 	.write8 = iwl_trans_pcie_write8,
 	.write32 = iwl_trans_pcie_write32,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index a8c8a4a..95ba920 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -318,7 +318,9 @@ static void iwl_pcie_txq_inc_wr_ptr(struct iwl_trans *trans,
 	 * trying to tx (during RFKILL, we're not trying to tx).
 	 */
 	IWL_DEBUG_TX(trans, "Q:%d WR: 0x%x\n", txq_id, txq->q.write_ptr);
-	iwl_write32(trans, HBUS_TARG_WRPTR, txq->q.write_ptr | (txq_id << 8));
+	if (!txq->block)
+		iwl_write32(trans, HBUS_TARG_WRPTR,
+			    txq->q.write_ptr | (txq_id << 8));
 }
 
 void iwl_pcie_txq_check_wrptrs(struct iwl_trans *trans)
-- 
2.5.0

