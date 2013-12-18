Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asav21.altibox.net ([109.247.116.8]:42754 "EHLO
	asav21.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab3LRXgc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 18:36:32 -0500
From: Henrik Austad <henrik@austad.us>
To: linux-rt-users@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/10] iwlwifi: pcie: clean up ICT allocation code
Date: Thu, 19 Dec 2013 00:25:56 +0100
Message-Id: <1387409165-28319-2-git-send-email-henrik@austad.us> (sfid-20131219_003644_490223_596F0C15)
In-Reply-To: <1387409165-28319-1-git-send-email-henrik@austad.us>
References: <1387409165-28319-1-git-send-email-henrik@austad.us>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since iwl_trans_pcie_alloc_ict is called in the PCIe
allocation code, we always set CSR_INT_BIT_RX_PERIODIC.
Move that bit to the default list of interrupts we enable
and simplify the code.
Also use dma_zalloc_ and avoid to memset the memory
afterwards.
trans_pcie->ict_index is 0 since trans_pcie has just been
kzalloced, remove the redundant assignment.

Change-Id: I1612bafb2c93d8a796cdd42444102e39199d4869
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-csr.h |    3 ++-
 drivers/net/wireless/iwlwifi/pcie/rx.c |   15 ++++-----------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index da4eca8..bbab26e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -198,7 +198,8 @@
 				 CSR_INT_BIT_RF_KILL | \
 				 CSR_INT_BIT_SW_RX   | \
 				 CSR_INT_BIT_WAKEUP  | \
-				 CSR_INT_BIT_ALIVE)
+				 CSR_INT_BIT_ALIVE   | \
+				 CSR_INT_BIT_RX_PERIODIC)
 
 /* interrupt flags in FH (flow handler) (PCI busmaster DMA) */
 #define CSR_FH_INT_BIT_ERR       (1 << 31) /* Error */
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index be3995a..f1d3b84 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -1051,7 +1051,7 @@ int iwl_pcie_alloc_ict(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	trans_pcie->ict_tbl =
-		dma_alloc_coherent(trans->dev, ICT_SIZE,
+		dma_zalloc_coherent(trans->dev, ICT_SIZE,
 				   &trans_pcie->ict_tbl_dma,
 				   GFP_KERNEL);
 	if (!trans_pcie->ict_tbl)
@@ -1063,17 +1063,10 @@ int iwl_pcie_alloc_ict(struct iwl_trans *trans)
 		return -EINVAL;
 	}
 
-	IWL_DEBUG_ISR(trans, "ict dma addr %Lx\n",
-		      (unsigned long long)trans_pcie->ict_tbl_dma);
+	IWL_DEBUG_ISR(trans, "ict dma addr %Lx ict vir addr %p\n",
+		      (unsigned long long)trans_pcie->ict_tbl_dma,
+		      trans_pcie->ict_tbl);
 
-	IWL_DEBUG_ISR(trans, "ict vir addr %p\n", trans_pcie->ict_tbl);
-
-	/* reset table and index to all 0 */
-	memset(trans_pcie->ict_tbl, 0, ICT_SIZE);
-	trans_pcie->ict_index = 0;
-
-	/* add periodic RX interrupt */
-	trans_pcie->inta_mask |= CSR_INT_BIT_RX_PERIODIC;
 	return 0;
 }
 
-- 
1.7.10.4

