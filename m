Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27087 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760032Ab1LPQhn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:43 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/24] iwlwifi: we can wake SW queues even when draining HW queues
Date: Fri, 16 Dec 2011 07:37:10 -0800
Message-Id: <1324049849-831-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173758_128434_7A0C7037)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In the very first implementation of HT, the driver was responsible
for the queueing: stopping and waking the queues while the HW queues
where being drained. In this implementation, we had to deal with the
case where we were draining the AGG queue because we wanted to tear
down the BA agreement.
In the normal flow (when we don't drain any HW queue), when packets
are reclaimed, we wake the SW queue in case the SW queue was stopped
which can happen when the HW queues are too full.
While draining a HW queue, we must make sure that we don't wake the
SW queue, since the whole point of the draining is to empty totally
the HW queue and not only get below a certain threshold.
This is why there is condition in the reclaim function:

if (NOT EMPTYING DELBA)
	wake the SW queue is applicable

Since then, a lot has changed and mac80211 is now able to buffer
packets that are being sent to a packet list that will be spliced
after the driver has reported it has drained its HW queues.
Hence, there is no need for the for aforementioned if, and we can
safely wake up the queue even if we are draining HW queues.
Removing this if, also allows us to remove the wake_queue in
check_empty that was there in order to deal with a corner case
created by the if.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 4d31843..ac689ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1297,8 +1297,6 @@ static int iwlagn_txq_check_empty(struct iwl_trans *trans,
 			iwl_stop_tx_ba_trans_ready(priv(trans),
 						   NUM_IWL_RXON_CTX,
 						   sta_id, tid);
-			iwl_wake_queue(trans, &trans_pcie->txq[txq_id],
-				       "DELBA flow complete");
 		}
 		break;
 	case IWL_EMPTYING_HW_QUEUE_ADDBA:
@@ -1326,28 +1324,20 @@ static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
-	enum iwl_agg_state agg_state;
 	/* n_bd is usually 256 => n_bd - 1 = 0xff */
 	int tfd_num = ssn & (txq->q.n_bd - 1);
 	int freed = 0;
-	bool cond;
 
 	txq->time_stamp = jiffies;
 
-	if (txq->sched_retry) {
-		agg_state =
-			trans->shrd->tid_data[txq->sta_id][txq->tid].agg.state;
-		cond = (agg_state != IWL_EMPTYING_HW_QUEUE_DELBA);
-	} else {
-		cond = (status != TX_STATUS_FAIL_PASSIVE_NO_RX);
-	}
-
 	if (txq->q.read_ptr != tfd_num) {
 		IWL_DEBUG_TX_REPLY(trans, "[Q %d | AC %d] %d -> %d (%d)\n",
 				txq_id, iwl_get_queue_ac(txq), txq->q.read_ptr,
 				tfd_num, ssn);
 		freed = iwl_tx_queue_reclaim(trans, txq_id, tfd_num, skbs);
-		if (iwl_queue_space(&txq->q) > txq->q.low_mark && cond)
+		if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
+		   (!txq->sched_retry ||
+		   status != TX_STATUS_FAIL_PASSIVE_NO_RX))
 			iwl_wake_queue(trans, txq, "Packets reclaimed");
 	}
 
-- 
1.7.0.4

