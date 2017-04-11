Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50684 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752368AbdDKMj3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:39:29 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:34 +0300
Message-Id: <20170411123742.12214-18-luca@coelho.fi> (sfid-20170411_144108_366420_32D1B1EC)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 17/25] iwlwifi: pcie: remove the active field in struct iwl_txq
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

We already have queue_used in the transport - we can
use it instead.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h | 2 --
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 7 +++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 541b969fe283..1ef9bb83a43f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -237,7 +237,6 @@ struct iwl_pcie_first_tb_buf {
  * @stuck_timer: timer that fires if queue gets stuck
  * @trans_pcie: pointer back to transport (for timer)
  * @need_update: indicates need to update read/write index
- * @active: stores if queue is active
  * @ampdu: true if this queue is an ampdu queue for an specific RA/TID
  * @wd_timeout: queue watchdog timeout (jiffies) - per queue
  * @frozen: tx stuck queue timer is frozen
@@ -277,7 +276,6 @@ struct iwl_txq {
 	struct iwl_trans_pcie *trans_pcie;
 	bool need_update;
 	bool frozen;
-	u8 active;
 	bool ampdu;
 	int block;
 	unsigned long wd_timeout;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index a313c187524b..66bdd2df910a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -701,7 +701,6 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
 			spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
 		}
 	}
-	txq->active = false;
 
 	while (!skb_queue_empty(&txq->overflow_q)) {
 		struct sk_buff *skb = __skb_dequeue(&txq->overflow_q);
@@ -932,6 +931,8 @@ void iwl_pcie_tx_free(struct iwl_trans *trans)
 	int txq_id;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
+	memset(trans_pcie->queue_used, 0, sizeof(trans_pcie->queue_used));
+
 	/* Tx queues */
 	if (trans_pcie->txq) {
 		for (txq_id = 0;
@@ -1107,7 +1108,7 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 
 	spin_lock_bh(&txq->lock);
 
-	if (!txq->active) {
+	if (!test_bit(txq_id, trans_pcie->queue_used)) {
 		IWL_DEBUG_TX_QUEUES(trans, "Q %d inactive - ignoring idx %d\n",
 				    txq_id, ssn);
 		goto out;
@@ -1411,8 +1412,6 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 				    "Activate queue %d WrPtr: %d\n",
 				    txq_id, ssn & 0xff);
 	}
-
-	txq->active = true;
 }
 
 void iwl_trans_pcie_txq_set_shared_mode(struct iwl_trans *trans, u32 txq_id,
-- 
2.11.0
