Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51937 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759734Ab2CGTGk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 14:06:40 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 30/35] iwlwifi: remove messages from queue wake/stop
Date: Wed,  7 Mar 2012 09:52:39 -0800
Message-Id: <1331142764-5750-31-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120307_200708_922625_5F0C3AFB)
In-Reply-To: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The only reason we ever stop/wake queues at
the transport level is now that they become
full (or non-full), so the messages aren't
useful any more -- remove them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |   36 ++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |    4 +-
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 14e5d52..6796559 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -411,7 +411,7 @@ static inline u8 iwl_get_queue_ac(struct iwl_tx_queue *txq)
 }
 
 static inline void iwl_wake_queue(struct iwl_trans *trans,
-				  struct iwl_tx_queue *txq, const char *msg)
+				  struct iwl_tx_queue *txq)
 {
 	u8 queue = txq->swq_id;
 	u8 ac = queue & 3;
@@ -422,19 +422,19 @@ static inline void iwl_wake_queue(struct iwl_trans *trans,
 	if (test_and_clear_bit(hwq, trans_pcie->queue_stopped)) {
 		if (atomic_dec_return(&trans_pcie->queue_stop_count[ac]) <= 0) {
 			iwl_op_mode_queue_not_full(trans->op_mode, ac);
-			IWL_DEBUG_TX_QUEUES(trans, "Wake hwq %d ac %d. %s",
-					    hwq, ac, msg);
+			IWL_DEBUG_TX_QUEUES(trans, "Wake hwq %d ac %d",
+					    hwq, ac);
 		} else {
-			IWL_DEBUG_TX_QUEUES(trans, "Don't wake hwq %d ac %d"
-					    " stop count %d. %s",
-					    hwq, ac, atomic_read(&trans_pcie->
-					    queue_stop_count[ac]), msg);
+			IWL_DEBUG_TX_QUEUES(trans,
+				"Don't wake hwq %d ac %d stop count %d",
+				hwq, ac,
+				atomic_read(&trans_pcie->queue_stop_count[ac]));
 		}
 	}
 }
 
 static inline void iwl_stop_queue(struct iwl_trans *trans,
-				  struct iwl_tx_queue *txq, const char *msg)
+				  struct iwl_tx_queue *txq)
 {
 	u8 queue = txq->swq_id;
 	u8 ac = queue & 3;
@@ -445,19 +445,19 @@ static inline void iwl_stop_queue(struct iwl_trans *trans,
 	if (!test_and_set_bit(hwq, trans_pcie->queue_stopped)) {
 		if (atomic_inc_return(&trans_pcie->queue_stop_count[ac]) > 0) {
 			iwl_op_mode_queue_full(trans->op_mode, ac);
-			IWL_DEBUG_TX_QUEUES(trans, "Stop hwq %d ac %d"
-					    " stop count %d. %s",
-					    hwq, ac, atomic_read(&trans_pcie->
-					    queue_stop_count[ac]), msg);
+			IWL_DEBUG_TX_QUEUES(trans,
+				"Stop hwq %d ac %d stop count %d",
+				hwq, ac,
+				atomic_read(&trans_pcie->queue_stop_count[ac]));
 		} else {
-			IWL_DEBUG_TX_QUEUES(trans, "Don't stop hwq %d ac %d"
-					    " stop count %d. %s",
-					    hwq, ac, atomic_read(&trans_pcie->
-					    queue_stop_count[ac]), msg);
+			IWL_DEBUG_TX_QUEUES(trans,
+				"Don't stop hwq %d ac %d stop count %d",
+				hwq, ac,
+				atomic_read(&trans_pcie->queue_stop_count[ac]));
 		}
 	} else {
-		IWL_DEBUG_TX_QUEUES(trans, "stop hwq %d, but it is stopped/ %s",
-				    hwq, msg);
+		IWL_DEBUG_TX_QUEUES(trans, "stop hwq %d, but it is stopped",
+				    hwq);
 	}
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index f28f4cb..7c80897 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1497,7 +1497,7 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 			txq->need_update = 1;
 			iwl_txq_update_write_ptr(trans, txq);
 		} else {
-			iwl_stop_queue(trans, txq, "Queue is full");
+			iwl_stop_queue(trans, txq);
 		}
 	}
 	spin_unlock(&txq->lock);
@@ -1601,7 +1601,7 @@ static int iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 				tfd_num, ssn);
 		freed = iwl_tx_queue_reclaim(trans, txq_id, tfd_num, skbs);
 		if (iwl_queue_space(&txq->q) > txq->q.low_mark)
-			iwl_wake_queue(trans, txq, "Packets reclaimed");
+			iwl_wake_queue(trans, txq);
 	}
 
 	spin_unlock(&txq->lock);
-- 
1.7.0.4

