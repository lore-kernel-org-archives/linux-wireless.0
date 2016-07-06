Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33192 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753313AbcGFKlT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:41:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:39:59 +0300
Message-Id: <1467801651-1816-4-git-send-email-luca@coelho.fi> (sfid-20160706_124130_084754_D604EB34)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 04/56] iwlwifi: pcie: unify restock calls on init
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Currently code calls restock for mq devices during the init
function, unlike sq where restock is called after init.
This causes an harmless but alarming deadlock warning from
lockdep, to fix this - unify the init code.
Rename the restock functions while at it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 70e39e4..8d4a60d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -233,10 +233,10 @@ static void iwl_pcie_rxq_check_wrptr(struct iwl_trans *trans)
 }
 
 /*
- * iwl_pcie_rxq_mq_restock - restock implementation for multi-queue rx
+ * iwl_pcie_rxmq_restock - restock implementation for multi-queue rx
  */
-static void iwl_pcie_rxq_mq_restock(struct iwl_trans *trans,
-				    struct iwl_rxq *rxq)
+static void iwl_pcie_rxmq_restock(struct iwl_trans *trans,
+				  struct iwl_rxq *rxq)
 {
 	struct iwl_rx_mem_buffer *rxb;
 
@@ -281,10 +281,10 @@ static void iwl_pcie_rxq_mq_restock(struct iwl_trans *trans,
 }
 
 /*
- * iwl_pcie_rxq_sq_restock - restock implementation for single queue rx
+ * iwl_pcie_rxsq_restock - restock implementation for single queue rx
  */
-static void iwl_pcie_rxq_sq_restock(struct iwl_trans *trans,
-				    struct iwl_rxq *rxq)
+static void iwl_pcie_rxsq_restock(struct iwl_trans *trans,
+				  struct iwl_rxq *rxq)
 {
 	struct iwl_rx_mem_buffer *rxb;
 
@@ -343,9 +343,9 @@ static
 void iwl_pcie_rxq_restock(struct iwl_trans *trans, struct iwl_rxq *rxq)
 {
 	if (trans->cfg->mq_rx_supported)
-		iwl_pcie_rxq_mq_restock(trans, rxq);
+		iwl_pcie_rxmq_restock(trans, rxq);
 	else
-		iwl_pcie_rxq_sq_restock(trans, rxq);
+		iwl_pcie_rxsq_restock(trans, rxq);
 }
 
 /*
@@ -828,9 +828,6 @@ static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
 		enabled |= BIT(i) | BIT(i + 16);
 	}
 
-	/* restock default queue */
-	iwl_pcie_rxq_mq_restock(trans, &trans_pcie->rxq[0]);
-
 	/*
 	 * Enable Rx DMA
 	 * Rx buffer size 4 or 8k or 12k
@@ -960,12 +957,13 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 	}
 
 	iwl_pcie_rxq_alloc_rbs(trans, GFP_KERNEL, def_rxq);
-	if (trans->cfg->mq_rx_supported) {
+
+	if (trans->cfg->mq_rx_supported)
 		iwl_pcie_rx_mq_hw_init(trans);
-	} else {
-		iwl_pcie_rxq_sq_restock(trans, def_rxq);
+	else
 		iwl_pcie_rx_hw_init(trans, def_rxq);
-	}
+
+	iwl_pcie_rxq_restock(trans, def_rxq);
 
 	spin_lock(&def_rxq->lock);
 	iwl_pcie_rxq_inc_wr_ptr(trans, def_rxq);
-- 
2.8.1

