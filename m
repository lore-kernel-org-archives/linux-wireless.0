Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33366 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752755AbcGFKoP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:44 +0300
Message-Id: <1467801651-1816-49-git-send-email-luca@coelho.fi> (sfid-20160706_124420_620445_1078981D)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 49/56] iwlwifi: pcie: track rxb status
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In MQ environment and new architecture in early stages
we may encounter DMA issues. Track RXB status and bail
out in case we receive index to an RXB that was not
mapped and handed over to HW.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  2 ++
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       | 10 +++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 54af3da..190f611 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -68,12 +68,14 @@ struct iwl_host_cmd;
  * struct iwl_rx_mem_buffer
  * @page_dma: bus address of rxb page
  * @page: driver's pointer to the rxb page
+ * @invalid: rxb is in driver ownership - not owned by HW
  * @vid: index of this rxb in the global table
  */
 struct iwl_rx_mem_buffer {
 	dma_addr_t page_dma;
 	struct page *page;
 	u16 vid;
+	bool invalid;
 	struct list_head list;
 };
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 45f1b7e..153b308 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -266,7 +266,7 @@ static void iwl_pcie_rxmq_restock(struct iwl_trans *trans,
 		rxb = list_first_entry(&rxq->rx_free, struct iwl_rx_mem_buffer,
 				       list);
 		list_del(&rxb->list);
-
+		rxb->invalid = false;
 		/* 12 first bits are expected to be empty */
 		WARN_ON(rxb->page_dma & DMA_BIT_MASK(12));
 		/* Point to Rx buffer via next RBD in circular buffer */
@@ -317,6 +317,7 @@ static void iwl_pcie_rxsq_restock(struct iwl_trans *trans,
 		rxb = list_first_entry(&rxq->rx_free, struct iwl_rx_mem_buffer,
 				       list);
 		list_del(&rxb->list);
+		rxb->invalid = false;
 
 		/* Point to Rx buffer via next RBD in circular buffer */
 		bd[rxq->write] = iwl_pcie_dma_addr2rbd_ptr(rxb->page_dma);
@@ -961,6 +962,7 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 			list_add(&rxb->list, &def_rxq->rx_used);
 		trans_pcie->global_table[i] = rxb;
 		rxb->vid = (u16)(i + 1);
+		rxb->invalid = true;
 	}
 
 	iwl_pcie_rxq_alloc_rbs(trans, GFP_KERNEL, def_rxq);
@@ -1256,6 +1258,12 @@ restart:
 				goto out;
 			}
 			rxb = trans_pcie->global_table[vid - 1];
+			if (WARN(rxb->invalid,
+				 "Invalid rxb from HW %u\n", (u32)vid)) {
+				iwl_force_nmi(trans);
+				goto out;
+			}
+			rxb->invalid = true;
 		} else {
 			rxb = rxq->queue[i];
 			rxq->queue[i] = NULL;
-- 
2.8.1

