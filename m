Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:45419 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab3LaRQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:06 -0500
Received: by mail-ea0-f176.google.com with SMTP id h14so5572683eaj.35
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:04 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/28] iwlwifi: pcie: clean up ICT allocation code
Date: Tue, 31 Dec 2013 19:15:30 +0200
Message-Id: <1388510157-23345-1-git-send-email-egrumbach@gmail.com> (sfid-20131231_181609_985734_292A248D)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
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

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
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
index 7aeec5c..b3e6564 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -1048,7 +1048,7 @@ int iwl_pcie_alloc_ict(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	trans_pcie->ict_tbl =
-		dma_alloc_coherent(trans->dev, ICT_SIZE,
+		dma_zalloc_coherent(trans->dev, ICT_SIZE,
 				   &trans_pcie->ict_tbl_dma,
 				   GFP_KERNEL);
 	if (!trans_pcie->ict_tbl)
@@ -1060,17 +1060,10 @@ int iwl_pcie_alloc_ict(struct iwl_trans *trans)
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
1.7.9.5

