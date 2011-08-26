Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23946 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab1HZGxh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 40/60] iwlagn: move Keep Warm to transport layer
Date: Thu, 25 Aug 2011 23:11:12 -0700
Message-Id: <1314339092-20797-41-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085434_000200_06619058)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

It is relevant for PCIe only.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |    2 ++
 drivers/net/wireless/iwlwifi/iwl-trans.c          |    8 +++++---
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index abc0118..30963bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1239,7 +1239,6 @@ struct iwl_priv {
 	/* Tx DMA processing queues */
 	struct iwl_tx_queue *txq;
 	unsigned long txq_ctx_active_msk;
-	struct iwl_dma_ptr  kw;	/* keep warm address */
 
 	/* counts mgmt, ctl, and data packets */
 	struct traffic_stats tx_stats;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index af2d478..c258b3f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -95,6 +95,7 @@ struct iwl_rx_queue {
  * @trans: pointer to the generic transport area
  * @scd_base_addr: scheduler sram base address in SRAM
  * @scd_bc_tbls: pointer to the byte count table of the scheduler
+ * @kw: keep warm address
  */
 struct iwl_trans_pcie {
 	struct iwl_rx_queue rxq;
@@ -115,6 +116,7 @@ struct iwl_trans_pcie {
 	u32 inta_mask;
 	u32 scd_base_addr;
 	struct iwl_dma_ptr scd_bc_tbls;
+	struct iwl_dma_ptr kw;
 };
 
 #define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 4f3fdca..14c22b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -489,7 +489,7 @@ static void iwl_trans_pcie_tx_free(struct iwl_trans *trans)
 	kfree(priv->txq);
 	priv->txq = NULL;
 
-	iwlagn_free_dma_ptr(trans, &priv->kw);
+	iwlagn_free_dma_ptr(trans, &trans_pcie->kw);
 
 	iwlagn_free_dma_ptr(trans, &trans_pcie->scd_bc_tbls);
 }
@@ -527,7 +527,7 @@ static int iwl_trans_tx_alloc(struct iwl_trans *trans)
 	}
 
 	/* Alloc keep-warm buffer */
-	ret = iwlagn_alloc_dma_ptr(trans, &priv->kw, IWL_KW_SIZE);
+	ret = iwlagn_alloc_dma_ptr(trans, &trans_pcie->kw, IWL_KW_SIZE);
 	if (ret) {
 		IWL_ERR(trans, "Keep Warm allocation failed\n");
 		goto error;
@@ -567,6 +567,8 @@ static int iwl_tx_init(struct iwl_trans *trans)
 	unsigned long flags;
 	bool alloc = false;
 	struct iwl_priv *priv = priv(trans);
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	if (!priv->txq) {
 		ret = iwl_trans_tx_alloc(trans);
@@ -581,7 +583,7 @@ static int iwl_tx_init(struct iwl_trans *trans)
 	iwl_write_prph(priv, SCD_TXFACT, 0);
 
 	/* Tell NIC where to find the "keep warm" buffer */
-	iwl_write_direct32(priv, FH_KW_MEM_ADDR_REG, priv->kw.dma >> 4);
+	iwl_write_direct32(priv, FH_KW_MEM_ADDR_REG, trans_pcie->kw.dma >> 4);
 
 	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 
-- 
1.7.0.4

