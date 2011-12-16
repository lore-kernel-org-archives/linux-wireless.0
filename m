Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15336 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759849Ab1LPQhl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:41 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/24] iwlwifi: don't rely on the wr / rd pointers in DELBA flow
Date: Fri, 16 Dec 2011 07:37:11 -0800
Message-Id: <1324049849-831-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173751_884328_AD39CBEB)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In the same spirit as the previous patch. Eventually this will
allow us to remove the tid_data knowledge from the transport layer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |   21 ++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |   10 ++++------
 2 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 1b1077c..58ee0ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -599,10 +599,8 @@ int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans,
 				  enum iwl_rxon_context_id ctx, int sta_id,
 				  int tid)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	unsigned long flags;
-	int read_ptr, write_ptr;
 	struct iwl_tid_data *tid_data;
+	unsigned long flags;
 	int txq_id;
 
 	spin_lock_irqsave(&trans->shrd->sta_lock, flags);
@@ -642,21 +640,22 @@ int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans,
 		return 0;
 	}
 
-	write_ptr = trans_pcie->txq[txq_id].q.write_ptr;
-	read_ptr = trans_pcie->txq[txq_id].q.read_ptr;
+	tid_data->agg.ssn = SEQ_TO_SN(tid_data->seq_number);
 
-	/* The queue is not empty */
-	if (write_ptr != read_ptr) {
-		IWL_DEBUG_TX_QUEUES(trans,
-				    "Stopping a non empty AGG HW QUEUE\n");
+	/* There are still packets for this RA / TID in the HW */
+	if (tid_data->agg.ssn != tid_data->next_reclaimed) {
+		IWL_DEBUG_TX_QUEUES(trans, "Can't proceed: ssn %d, "
+				    "next_recl = %d",
+				    tid_data->agg.ssn,
+				    tid_data->next_reclaimed);
 		trans->shrd->tid_data[sta_id][tid].agg.state =
 			IWL_EMPTYING_HW_QUEUE_DELBA;
-		tid_data->agg.ssn = SEQ_TO_SN(tid_data->seq_number);
 		spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
 		return 0;
 	}
 
-	IWL_DEBUG_TX_QUEUES(trans, "HW queue is empty\n");
+	IWL_DEBUG_TX_QUEUES(trans, "Can proceed: ssn = next_recl = %d",
+			    tid_data->agg.ssn);
 turn_off:
 	trans->shrd->tid_data[sta_id][tid].agg.state = IWL_AGG_OFF;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index ac689ed..ef057ff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1278,20 +1278,18 @@ static int iwl_trans_pcie_request_irq(struct iwl_trans *trans)
 static int iwlagn_txq_check_empty(struct iwl_trans *trans,
 			   int sta_id, u8 tid, int txq_id)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_queue *q = &trans_pcie->txq[txq_id].q;
 	struct iwl_tid_data *tid_data = &trans->shrd->tid_data[sta_id][tid];
 
 	lockdep_assert_held(&trans->shrd->sta_lock);
 
 	switch (trans->shrd->tid_data[sta_id][tid].agg.state) {
 	case IWL_EMPTYING_HW_QUEUE_DELBA:
-		/* We are reclaiming the last packet of the */
-		/* aggregated HW queue */
+		/* There are no packets for this RA / TID in the HW any more */
 		if ((txq_id  == tid_data->agg.txq_id) &&
-		    (q->read_ptr == q->write_ptr)) {
+		    (tid_data->agg.ssn == tid_data->next_reclaimed)) {
 			IWL_DEBUG_TX_QUEUES(trans,
-				"HW queue empty: continue DELBA flow\n");
+				"Can continue DELBA flow ssn = next_recl ="
+				" %d", tid_data->next_reclaimed);
 			iwl_trans_pcie_txq_agg_disable(trans, txq_id);
 			tid_data->agg.state = IWL_AGG_OFF;
 			iwl_stop_tx_ba_trans_ready(priv(trans),
-- 
1.7.0.4

