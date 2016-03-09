Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:63100 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933364AbcCIRp4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 12:45:56 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/21] iwlwifi: pcie: refactor RXBs reclaiming code
Date: Wed,  9 Mar 2016 19:45:31 +0200
Message-Id: <1457545550-30677-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160309_184559_600726_58B85C53)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Change the code to move rxbs directly from the allocator's
list to the queue's free list. This makes the code more
readable, saves the interim array and the double loop over
the free RBs.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 75 ++++++++++++----------------
 1 file changed, 33 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 489b07a..a310fd2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -539,40 +539,46 @@ static void iwl_pcie_rx_allocator(struct iwl_trans *trans)
 }
 
 /*
- * iwl_pcie_rx_allocator_get - Returns the pre-allocated pages
+ * iwl_pcie_rx_allocator_get - returns the pre-allocated pages
 .*
 .* Called by queue when the queue posted allocation request and
  * has freed 8 RBDs in order to restock itself.
+ * This function directly moves the allocated RBs to the queue's ownership
+ * and updates the relevant counters.
  */
-static int iwl_pcie_rx_allocator_get(struct iwl_trans *trans,
-				     struct iwl_rx_mem_buffer
-				     *out[RX_CLAIM_REQ_ALLOC])
+static void iwl_pcie_rx_allocator_get(struct iwl_trans *trans,
+				      struct iwl_rxq *rxq)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rb_allocator *rba = &trans_pcie->rba;
 	int i;
 
+	lockdep_assert_held(&rxq->lock);
+
 	/*
 	 * atomic_dec_if_positive returns req_ready - 1 for any scenario.
 	 * If req_ready is 0 atomic_dec_if_positive will return -1 and this
-	 * function will return -ENOMEM, as there are no ready requests.
+	 * function will return early, as there are no ready requests.
 	 * atomic_dec_if_positive will perofrm the *actual* decrement only if
 	 * req_ready > 0, i.e. - there are ready requests and the function
 	 * hands one request to the caller.
 	 */
 	if (atomic_dec_if_positive(&rba->req_ready) < 0)
-		return -ENOMEM;
+		return;
 
 	spin_lock(&rba->lock);
 	for (i = 0; i < RX_CLAIM_REQ_ALLOC; i++) {
 		/* Get next free Rx buffer, remove it from free list */
-		out[i] = list_first_entry(&rba->rbd_allocated,
-			       struct iwl_rx_mem_buffer, list);
-		list_del(&out[i]->list);
+		struct iwl_rx_mem_buffer *rxb =
+			list_first_entry(&rba->rbd_allocated,
+					 struct iwl_rx_mem_buffer, list);
+
+		list_move(&rxb->list, &rxq->rx_free);
 	}
 	spin_unlock(&rba->lock);
 
-	return 0;
+	rxq->used_count -= RX_CLAIM_REQ_ALLOC;
+	rxq->free_count += RX_CLAIM_REQ_ALLOC;
 }
 
 static void iwl_pcie_rx_allocator_work(struct work_struct *data)
@@ -1149,7 +1155,7 @@ static void iwl_pcie_rx_handle(struct iwl_trans *trans, int queue)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *rxq = &trans_pcie->rxq[queue];
-	u32 r, i, j, count = 0;
+	u32 r, i, count = 0;
 	bool emergency = false;
 
 restart:
@@ -1193,39 +1199,24 @@ restart:
 
 		i = (i + 1) & (rxq->queue_size - 1);
 
-		/* If we have RX_CLAIM_REQ_ALLOC released rx buffers -
-		 * try to claim the pre-allocated buffers from the allocator */
-		if (rxq->used_count >= RX_CLAIM_REQ_ALLOC) {
+		/*
+		 * If we have RX_CLAIM_REQ_ALLOC released rx buffers -
+		 * try to claim the pre-allocated buffers from the allocator.
+		 * If not ready - will try to reclaim next time.
+		 * There is no need to reschedule work - allocator exits only
+		 * on success
+		 */
+		if (rxq->used_count >= RX_CLAIM_REQ_ALLOC)
+			iwl_pcie_rx_allocator_get(trans, rxq);
+
+		if (rxq->used_count % RX_CLAIM_REQ_ALLOC == 0 && !emergency) {
 			struct iwl_rb_allocator *rba = &trans_pcie->rba;
-			struct iwl_rx_mem_buffer *out[RX_CLAIM_REQ_ALLOC];
-
-			if (rxq->used_count % RX_CLAIM_REQ_ALLOC == 0 &&
-			    !emergency) {
-				/* Add the remaining 6 empty RBDs
-				* for allocator use
-				 */
-				spin_lock(&rba->lock);
-				list_splice_tail_init(&rxq->rx_used,
-						      &rba->rbd_empty);
-				spin_unlock(&rba->lock);
-			}
 
-			/* If not ready - continue, will try to reclaim later.
-			* No need to reschedule work - allocator exits only on
-			* success */
-			if (!iwl_pcie_rx_allocator_get(trans, out)) {
-				/* If success - then RX_CLAIM_REQ_ALLOC
-				 * buffers were retrieved and should be added
-				 * to free list */
-				rxq->used_count -= RX_CLAIM_REQ_ALLOC;
-				for (j = 0; j < RX_CLAIM_REQ_ALLOC; j++) {
-					list_add_tail(&out[j]->list,
-						      &rxq->rx_free);
-					rxq->free_count++;
-				}
-			}
-		}
-		if (emergency) {
+			/* Add the remaining empty RBDs for allocator use */
+			spin_lock(&rba->lock);
+			list_splice_tail_init(&rxq->rx_used, &rba->rbd_empty);
+			spin_unlock(&rba->lock);
+		} else if (emergency) {
 			count++;
 			if (count == 8) {
 				count = 0;
-- 
2.5.0

