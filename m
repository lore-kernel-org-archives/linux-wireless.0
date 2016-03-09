Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:62255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933653AbcCIRqb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 12:46:31 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Gregory Greenman <gregory.greenman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/21] iwlwifi: pcie: avoid restocks inside rx loop if not emergency
Date: Wed,  9 Mar 2016 19:45:47 +0200
Message-Id: <1457545550-30677-18-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160309_185951_389596_8FDC1E35)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

When trying to reach high Rx throughput of more than 500Mbps on
a device with a relatively weak CPU (Atom x5-Z8500), CPU utilization
may become a bottleneck. Analysis showed that we are looping in
iwl_pcie_rx_handle for very long periods which led to starvation
of other threads (iwl_pcie_rx_handle runs with _bh disabled).
We were handling Rx and allocating new buffers and the new buffers
were ready quickly enough to be available before we had finished
handling all the buffers available in the hardware. As a
consequence, we called iwl_pcie_rxq_restock to refill the hardware
with the new buffers, and start again handling new buffers without
exiting the function. Since we read the hardware pointer again when
we goto restart, new buffers were handled immediately instead of
exiting the function.

This patch avoids refilling RBs inside rx handling loop, unless an
emergency situation is reached. It also doesn't read the hardware
pointer again unless we are in an emergency (unlikely) case.
This significantly reduce the maximal time we spend in
iwl_pcie_rx_handle with _bh disabled.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 59 ++++++++++++++++------------
 1 file changed, 33 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 98524a0..4be3c35 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -231,6 +231,9 @@ static void iwl_pcie_rxq_check_wrptr(struct iwl_trans *trans)
 	}
 }
 
+/*
+ * iwl_pcie_rxq_mq_restock - restock implementation for multi-queue rx
+ */
 static void iwl_pcie_rxq_mq_restock(struct iwl_trans *trans,
 				    struct iwl_rxq *rxq)
 {
@@ -277,17 +280,10 @@ static void iwl_pcie_rxq_mq_restock(struct iwl_trans *trans,
 }
 
 /*
- * iwl_pcie_rxq_restock - refill RX queue from pre-allocated pool
- *
- * If there are slots in the RX queue that need to be restocked,
- * and we have free pre-allocated buffers, fill the ranks as much
- * as we can, pulling from rx_free.
- *
- * This moves the 'write' index forward to catch up with 'processed', and
- * also updates the memory address in the firmware to reference the new
- * target buffer.
+ * iwl_pcie_rxq_sq_restock - restock implementation for single queue rx
  */
-static void iwl_pcie_rxq_restock(struct iwl_trans *trans, struct iwl_rxq *rxq)
+static void iwl_pcie_rxq_sq_restock(struct iwl_trans *trans,
+				    struct iwl_rxq *rxq)
 {
 	struct iwl_rx_mem_buffer *rxb;
 
@@ -332,6 +328,26 @@ static void iwl_pcie_rxq_restock(struct iwl_trans *trans, struct iwl_rxq *rxq)
 }
 
 /*
+ * iwl_pcie_rxq_restock - refill RX queue from pre-allocated pool
+ *
+ * If there are slots in the RX queue that need to be restocked,
+ * and we have free pre-allocated buffers, fill the ranks as much
+ * as we can, pulling from rx_free.
+ *
+ * This moves the 'write' index forward to catch up with 'processed', and
+ * also updates the memory address in the firmware to reference the new
+ * target buffer.
+ */
+static
+void iwl_pcie_rxq_restock(struct iwl_trans *trans, struct iwl_rxq *rxq)
+{
+	if (trans->cfg->mq_rx_supported)
+		iwl_pcie_rxq_mq_restock(trans, rxq);
+	else
+		iwl_pcie_rxq_sq_restock(trans, rxq);
+}
+
+/*
  * iwl_pcie_rx_alloc_page - allocates and returns a page.
  *
  */
@@ -907,7 +923,7 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 	if (trans->cfg->mq_rx_supported) {
 		iwl_pcie_rx_mq_hw_init(trans);
 	} else {
-		iwl_pcie_rxq_restock(trans, def_rxq);
+		iwl_pcie_rxq_sq_restock(trans, def_rxq);
 		iwl_pcie_rx_hw_init(trans, def_rxq);
 	}
 
@@ -1222,24 +1238,13 @@ restart:
 				count = 0;
 				if (rxq->used_count < rxq->queue_size / 3)
 					emergency = false;
+
+				rxq->read = i;
 				spin_unlock(&rxq->lock);
 				iwl_pcie_rxq_alloc_rbs(trans, GFP_ATOMIC, rxq);
-				spin_lock(&rxq->lock);
-			}
-		}
-		/* handle restock for three cases, can be all of them at once:
-		* - we just pulled buffers from the allocator
-		* - we have 8+ unstolen pages accumulated
-		* - we are in emergency and allocated buffers
-		 */
-		if (rxq->free_count >=  RX_CLAIM_REQ_ALLOC) {
-			rxq->read = i;
-			spin_unlock(&rxq->lock);
-			if (trans->cfg->mq_rx_supported)
-				iwl_pcie_rxq_mq_restock(trans, rxq);
-			else
 				iwl_pcie_rxq_restock(trans, rxq);
-			goto restart;
+				goto restart;
+			}
 		}
 	}
 out:
@@ -1264,6 +1269,8 @@ out:
 
 	if (rxq->napi.poll)
 		napi_gro_flush(&rxq->napi, false);
+
+	iwl_pcie_rxq_restock(trans, rxq);
 }
 
 static struct iwl_trans_pcie *iwl_pcie_get_trans_pcie(struct msix_entry *entry)
-- 
2.5.0

