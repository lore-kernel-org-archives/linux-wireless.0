Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:62255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933634AbcCIRqU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 12:46:20 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/21] iwlwifi: pcie: fine tune number of rxbs
Date: Wed,  9 Mar 2016 19:45:42 +0200
Message-Id: <1457545550-30677-13-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160309_185951_531538_64DF8E29)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

We kick the allocator when we have 2 RBDs that don't have
attached RBs, and the allocator allocates 8 RBs meaning
that it needs another 6 RBDs to attach the RBs to.
The design is that allocator should always have enough RBDs
to fulfill requests, so we give in advance 6 RBDs to the
allocator so that when it is kicked, it gets additional 2 RBDs
and has enough RBDs.
These RBDs were taken from the Rx queue itself, meaning
that each Rx queue didn't have the maximal number of
RBDs, but MAX - 6.
Change initial number of RBDs in the system to include both
queue size and allocator reserves.
Note the multi-queue is always 511 instead of 512 to avoid a
full queue since we cannot detect this state easily enough in
the 9000 arch.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        |  9 ++++++---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       | 11 ++++++-----
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
index 8af818b..582008a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
@@ -511,9 +511,12 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(unsigned int chnl)
  */
 #define FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN	(0x00000002)
 
-#define MQ_RX_TABLE_SIZE		512
-#define MQ_RX_TABLE_MASK		(MQ_RX_TABLE_SIZE - 1)
-#define MQ_RX_POOL_SIZE			MQ_RX_TABLE_MASK
+#define MQ_RX_TABLE_SIZE	512
+#define MQ_RX_TABLE_MASK	(MQ_RX_TABLE_SIZE - 1)
+#define MQ_RX_NUM_RBDS		(MQ_RX_TABLE_SIZE - 1)
+#define RX_POOL_SIZE		(MQ_RX_NUM_RBDS +	\
+				 IWL_MAX_RX_HW_QUEUES *	\
+				 (RX_CLAIM_REQ_ALLOC - RX_POST_REQ_ALLOC))
 
 #define RX_QUEUE_SIZE                         256
 #define RX_QUEUE_MASK                         255
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 6677f31..dadafbd 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -347,7 +347,7 @@ struct iwl_tso_hdr_page {
  */
 struct iwl_trans_pcie {
 	struct iwl_rxq *rxq;
-	struct iwl_rx_mem_buffer rx_pool[MQ_RX_POOL_SIZE];
+	struct iwl_rx_mem_buffer rx_pool[RX_POOL_SIZE];
 	struct iwl_rx_mem_buffer *global_table[MQ_RX_TABLE_SIZE];
 	struct iwl_rb_allocator rba;
 	struct iwl_trans *trans;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 509f790..98524a0 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -434,7 +434,7 @@ static void iwl_pcie_free_rbs_pool(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int i;
 
-	for (i = 0; i < MQ_RX_POOL_SIZE; i++) {
+	for (i = 0; i < RX_POOL_SIZE; i++) {
 		if (!trans_pcie->rx_pool[i].page)
 			continue;
 		dma_unmap_page(trans->dev, trans_pcie->rx_pool[i].page_dma,
@@ -835,7 +835,7 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *def_rxq;
 	struct iwl_rb_allocator *rba = &trans_pcie->rba;
-	int i, err, num_rbds, allocator_pool_size;
+	int i, err, queue_size, allocator_pool_size, num_alloc;
 
 	if (!trans_pcie->rxq) {
 		err = iwl_pcie_rx_alloc(trans);
@@ -887,11 +887,12 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 	}
 
 	/* move the pool to the default queue and allocator ownerships */
-	num_rbds = trans->cfg->mq_rx_supported ?
-		     MQ_RX_POOL_SIZE : RX_QUEUE_SIZE;
+	queue_size = trans->cfg->mq_rx_supported ?
+		     MQ_RX_NUM_RBDS : RX_QUEUE_SIZE;
 	allocator_pool_size = trans->num_rx_queues *
 		(RX_CLAIM_REQ_ALLOC - RX_POST_REQ_ALLOC);
-	for (i = 0; i < num_rbds; i++) {
+	num_alloc = queue_size + allocator_pool_size;
+	for (i = 0; i < num_alloc; i++) {
 		struct iwl_rx_mem_buffer *rxb = &trans_pcie->rx_pool[i];
 
 		if (i < allocator_pool_size)
-- 
2.5.0

