Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48532 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab2FKJxe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 05:53:34 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/13] iwlwifi: remove lock around txq_enable
Date: Mon, 11 Jun 2012 11:53:07 +0200
Message-Id: <1339408392-19425-9-git-send-email-johannes@sipsolutions.net> (sfid-20120611_115351_143230_2CE3525B)
In-Reply-To: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
References: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This locking isn't needed. The only locking we need is when
we access prph registers but there is already a separate
lock for that.
Since we haven't returned from the mac80211's
IEEE80211_AMPDU_TX_OPERATIONAL ampdu_action, we cannot
receive any Tx frame for that sta / tid while enabling the
queue.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/internal.h |    5 +----
 drivers/net/wireless/iwlwifi/pcie/trans.c    |    5 ++---
 drivers/net/wireless/iwlwifi/pcie/tx.c       |   21 ++-------------------
 3 files changed, 5 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 6c7b355..5024fb6 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -339,12 +339,9 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans,
 void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 				       struct iwl_tx_queue *txq,
 				       u16 byte_cnt);
-void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int queue);
-void __iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id,
-					int fifo, int sta_id, int tid,
-					int frame_limit, u16 ssn);
 void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, int fifo,
 			       int sta_id, int tid, int frame_limit, u16 ssn);
+void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int queue);
 void iwl_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 		      enum dma_data_direction dma_dir);
 int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 1904fda..4d4cbae 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1068,9 +1068,8 @@ static void iwl_tx_start(struct iwl_trans *trans)
 	for (i = 0; i < trans_pcie->n_q_to_fifo; i++) {
 		int fifo = trans_pcie->setup_q_to_fifo[i];
 
-		__iwl_trans_pcie_txq_enable(trans, i, fifo, IWL_INVALID_STATION,
-					    IWL_TID_NON_QOS,
-					    SCD_FRAME_LIMIT, 0);
+		iwl_trans_pcie_txq_enable(trans, i, fifo, IWL_INVALID_STATION,
+					  IWL_TID_NON_QOS, SCD_FRAME_LIMIT, 0);
 	}
 
 	/* Activate all Tx DMA/FIFO channels */
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 18e6c81..a092fb3 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -415,14 +415,11 @@ static inline void iwl_txq_set_inactive(struct iwl_trans *trans, u16 txq_id)
 		(1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
 }
 
-void __iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id,
-					int fifo, int sta_id, int tid,
-					int frame_limit, u16 ssn)
+void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, int fifo,
+			       int sta_id, int tid, int frame_limit, u16 ssn)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	lockdep_assert_held(&trans_pcie->irq_lock);
-
 	if (test_and_set_bit(txq_id, trans_pcie->queue_used))
 		WARN_ONCE(1, "queue %d already used - expect issues", txq_id);
 
@@ -480,20 +477,6 @@ void __iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id,
 			    txq_id, fifo, ssn & 0xff);
 }
 
-void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, int fifo,
-			       int sta_id, int tid, int frame_limit, u16 ssn)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	unsigned long flags;
-
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
-
-	__iwl_trans_pcie_txq_enable(trans, txq_id, fifo, sta_id,
-				    tid, frame_limit, ssn);
-
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
-}
-
 void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-- 
1.7.10

