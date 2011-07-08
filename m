Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2126 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab1GHQUh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:20:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/21] iwlagn: remove the indirection for the dma channel num
Date: Fri,  8 Jul 2011 08:46:15 -0700
Message-Id: <1310139989-27661-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182112_901141_374AC24E)
In-Reply-To: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not needed since the driver split.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-5000.c      |    2 --
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h       |    2 --
 drivers/net/wireless/iwlwifi/iwl-fh.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c     |    2 +-
 8 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index cf1449d..9cc161d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -125,7 +125,6 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	priv->hw_params.max_txq_num = priv->cfg->base_params->num_of_queues;
-	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
 	priv->hw_params.scd_bc_tbls_size =
 			priv->cfg->base_params->num_of_queues *
 			sizeof(struct iwlagn_scd_bc_tbl);
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index a401113..0c32450 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -123,7 +123,6 @@ static int iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	priv->hw_params.max_txq_num = priv->cfg->base_params->num_of_queues;
-	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
 	priv->hw_params.scd_bc_tbls_size =
 		priv->cfg->base_params->num_of_queues *
 		sizeof(struct iwlagn_scd_bc_tbl);
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 8209334..0c5105f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -156,7 +156,6 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	priv->hw_params.max_txq_num = priv->cfg->base_params->num_of_queues;
-	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
 	priv->hw_params.scd_bc_tbls_size =
 			priv->cfg->base_params->num_of_queues *
 			sizeof(struct iwlagn_scd_bc_tbl);
@@ -200,7 +199,6 @@ static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	priv->hw_params.max_txq_num = priv->cfg->base_params->num_of_queues;
-	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
 	priv->hw_params.scd_bc_tbls_size =
 			priv->cfg->base_params->num_of_queues *
 			sizeof(struct iwlagn_scd_bc_tbl);
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 2134514..ced3bbe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -144,7 +144,6 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	priv->hw_params.max_txq_num = priv->cfg->base_params->num_of_queues;
-	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
 	priv->hw_params.scd_bc_tbls_size =
 			priv->cfg->base_params->num_of_queues *
 			sizeof(struct iwlagn_scd_bc_tbl);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 1976582..d31b826 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -406,7 +406,7 @@ static int iwlagn_alive_notify(struct iwl_priv *priv)
 		       priv->scd_bc_tbls.dma >> 10);
 
 	/* Enable DMA channel */
-	for (chan = 0; chan < FH50_TCSR_CHNL_NUM ; chan++)
+	for (chan = 0; chan < FH_TCSR_CHNL_NUM ; chan++)
 		iwl_write_direct32(priv, FH_TCSR_CHNL_TX_CONFIG_REG(chan),
 				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
 				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 975ad79..92f8ce9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -640,7 +640,6 @@ struct iwl_sensitivity_ranges {
 /**
  * struct iwl_hw_params
  * @max_txq_num: Max # Tx queues supported
- * @dma_chnl_num: Number of Tx DMA/FIFO channels
  * @scd_bc_tbls_size: size of scheduler byte count tables
  * @tfd_size: TFD size
  * @tx/rx_chains_num: Number of TX/RX chains
@@ -662,7 +661,6 @@ struct iwl_sensitivity_ranges {
  */
 struct iwl_hw_params {
 	u8 max_txq_num;
-	u8 dma_chnl_num;
 	u16 scd_bc_tbls_size;
 	u32 tfd_size;
 	u8  tx_chains_num;
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 6dfa806..0ad60b3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -326,7 +326,7 @@
 #define FH_TCSR_UPPER_BOUND  (FH_MEM_LOWER_BOUND + 0xE60)
 
 /* Find Control/Status reg for given Tx DMA/FIFO channel */
-#define FH50_TCSR_CHNL_NUM                            (8)
+#define FH_TCSR_CHNL_NUM                            (8)
 
 /* TCSR: tx_config register values */
 #define FH_TCSR_CHNL_TX_CONFIG_REG(_chnl)	\
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 5c5a489..0c92456 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -529,7 +529,7 @@ static int iwl_trans_tx_stop(struct iwl_priv *priv)
 	iwlagn_txq_set_sched(priv, 0);
 
 	/* Stop each Tx DMA channel, and wait for it to be idle */
-	for (ch = 0; ch < priv->hw_params.dma_chnl_num; ch++) {
+	for (ch = 0; ch < FH_TCSR_CHNL_NUM; ch++) {
 		iwl_write_direct32(priv, FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
 		if (iwl_poll_direct_bit(priv, FH_TSSR_TX_STATUS_REG,
 				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
-- 
1.7.0.4

