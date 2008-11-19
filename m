Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10060 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbYKSXb5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 18:31:57 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/7] iwlwifi: TX setup fix confusion between TX queue and TX DMA channel
Date: Wed, 19 Nov 2008 15:32:26 -0800
Message-Id: <1227137548-28718-6-git-send-email-reinette.chatre@intel.com> (sfid-20081120_003218_419512_8C771F53)
In-Reply-To: <1227137548-28718-5-git-send-email-reinette.chatre@intel.com>
References: <>
 <1227137548-28718-1-git-send-email-reinette.chatre@intel.com>
 <1227137548-28718-2-git-send-email-reinette.chatre@intel.com>
 <1227137548-28718-3-git-send-email-reinette.chatre@intel.com>
 <1227137548-28718-4-git-send-email-reinette.chatre@intel.com>
 <1227137548-28718-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch configures correctly TX DMA channel. It is not
the same as TX queue.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   10 ++++++++--
 drivers/net/wireless/iwlwifi/iwl-5000.c |    9 ++++++++-
 drivers/net/wireless/iwlwifi/iwl-tx.c   |    5 -----
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index b96f553..60769b1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -692,9 +692,9 @@ static const u16 default_queue_to_tx_fifo[] = {
 static int iwl4965_alive_notify(struct iwl_priv *priv)
 {
 	u32 a;
-	int i = 0;
 	unsigned long flags;
 	int ret;
+	int i, chan;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -718,6 +718,12 @@ static int iwl4965_alive_notify(struct iwl_priv *priv)
 	iwl_write_prph(priv, IWL49_SCD_DRAM_BASE_ADDR,
 			priv->scd_bc_tbls.dma >> 10);
 
+	/* Enable DMA channel */
+	for (chan = 0; chan < FH49_TCSR_CHNL_NUM ; chan++)
+		iwl_write_direct32(priv, FH_TCSR_CHNL_TX_CONFIG_REG(chan),
+				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
+				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
+
 	/* Disable chain mode for all queues */
 	iwl_write_prph(priv, IWL49_SCD_QUEUECHAIN_SEL, 0);
 
@@ -748,7 +754,7 @@ static int iwl4965_alive_notify(struct iwl_priv *priv)
 				 (1 << priv->hw_params.max_txq_num) - 1);
 
 	/* Activate all Tx DMA/FIFO channels */
-	priv->cfg->ops->lib->txq_set_sched(priv, IWL_MASK(0, 7));
+	priv->cfg->ops->lib->txq_set_sched(priv, IWL_MASK(0, 6));
 
 	iwl4965_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 478c5c3..d73760c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -700,9 +700,9 @@ static int iwl5000_send_wimax_coex(struct iwl_priv *priv)
 static int iwl5000_alive_notify(struct iwl_priv *priv)
 {
 	u32 a;
-	int i = 0;
 	unsigned long flags;
 	int ret;
+	int i, chan;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -725,6 +725,13 @@ static int iwl5000_alive_notify(struct iwl_priv *priv)
 
 	iwl_write_prph(priv, IWL50_SCD_DRAM_BASE_ADDR,
 		       priv->scd_bc_tbls.dma >> 10);
+
+	/* Enable DMA channel */
+	for (chan = 0; chan < FH50_TCSR_CHNL_NUM ; chan++)
+		iwl_write_direct32(priv, FH_TCSR_CHNL_TX_CONFIG_REG(chan),
+				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
+				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
+
 	iwl_write_prph(priv, IWL50_SCD_QUEUECHAIN_SEL,
 		IWL50_SCD_QUEUECHAIN_SEL_ALL(priv->hw_params.max_txq_num));
 	iwl_write_prph(priv, IWL50_SCD_AGGR_SEL, 0);
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 6db11af..9e638c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -449,11 +449,6 @@ static int iwl_hw_tx_queue_init(struct iwl_priv *priv,
 	iwl_write_direct32(priv, FH_MEM_CBBC_QUEUE(txq_id),
 			     txq->q.dma_addr >> 8);
 
-	/* Enable DMA channel, using same id as for TFD queue */
-	iwl_write_direct32(priv, FH_TCSR_CHNL_TX_CONFIG_REG(txq_id),
-			FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
-			FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
-
 	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-- 
1.5.4.3

