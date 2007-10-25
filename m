Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbXJYJWv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:22:51 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 16/30] iwlwifi: replacing wording restricted to nic access in iwl-io
Date: Thu, 25 Oct 2007 17:15:37 +0800
Message-Id: <11933037743841-git-send-email-yi.zhu@intel.com> (sfid-20071025_104100_896372_2B931EAD)
In-Reply-To: <1193303773185-git-send-email-yi.zhu@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com>
 <11933037541699-git-send-email-yi.zhu@intel.com>
 <11933037553170-git-send-email-yi.zhu@intel.com>
 <119330375796-git-send-email-yi.zhu@intel.com>
 <11933037584069-git-send-email-yi.zhu@intel.com>
 <11933037601236-git-send-email-yi.zhu@intel.com>
 <11933037613709-git-send-email-yi.zhu@intel.com>
 <1193303762680-git-send-email-yi.zhu@intel.com>
 <11933037641168-git-send-email-yi.zhu@intel.com>
 <11933037663659-git-send-email-yi.zhu@intel.com>
 <11933037674045-git-send-email-yi.zhu@intel.com>
 <11933037692766-git-send-email-yi.zhu@intel.com>
 <1193303770550-git-send-email-yi.zhu@intel.com>
 <11933037721573-git-send-email-yi.zhu@intel.com>
 <1193303773185-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch replaces wording 'restricted' with more appropriate 'nic access'
NIC access is grabbed to prevent NIC entering power save mode
General cleanup of iwl-io.h

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   78 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   80 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-io.h       |  146 +++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   74 +++++++-------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   82 ++++++++--------
 5 files changed, 229 insertions(+), 231 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 08b6917..8b171de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -155,7 +155,7 @@ void iwl_disable_events(struct iwl_priv *priv)
 		return;
 	}
 
-	ret = iwl_grab_restricted_access(priv);
+	ret = iwl_grab_nic_access(priv);
 	if (ret) {
 		IWL_WARNING("Can not read from adapter at this time.\n");
 		return;
@@ -163,18 +163,18 @@ void iwl_disable_events(struct iwl_priv *priv)
 
 	disable_ptr = iwl_read_targ_mem(priv, base + (4 * sizeof(u32)));
 	array_size = iwl_read_targ_mem(priv, base + (5 * sizeof(u32)));
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 
 	if (IWL_EVT_DISABLE && (array_size == IWL_EVT_DISABLE_SIZE)) {
 		IWL_DEBUG_INFO("Disabling selected uCode log events at 0x%x\n",
 			       disable_ptr);
-		ret = iwl_grab_restricted_access(priv);
+		ret = iwl_grab_nic_access(priv);
 		for (i = 0; i < IWL_EVT_DISABLE_SIZE; i++)
 			iwl_write_targ_mem(priv,
 					   disable_ptr + (i * sizeof(u32)),
 					   evt_disable[i]);
 
-		iwl_release_restricted_access(priv);
+		iwl_release_nic_access(priv);
 	} else {
 		IWL_DEBUG_INFO("Selected uCode log events may be disabled\n");
 		IWL_DEBUG_INFO("  by writing \"1\"s into disable bitmap\n");
@@ -709,7 +709,7 @@ static int iwl3945_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
@@ -724,19 +724,19 @@ static int iwl3945_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
 			iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
 					APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
 					~APMG_PS_CTRL_MSK_PWR_SRC);
-			iwl_release_restricted_access(priv);
+			iwl_release_nic_access(priv);
 
 			iwl_poll_bit(priv, CSR_GPIO_IN,
 				     CSR_GPIO_IN_VAL_VAUX_PWR_SRC,
 				     CSR_GPIO_IN_BIT_AUX_POWER, 5000);
 		} else
-			iwl_release_restricted_access(priv);
+			iwl_release_nic_access(priv);
 	} else {
 		iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
 				~APMG_PS_CTRL_MSK_PWR_SRC);
 
-		iwl_release_restricted_access(priv);
+		iwl_release_nic_access(priv);
 		iwl_poll_bit(priv, CSR_GPIO_IN, CSR_GPIO_IN_VAL_VMAIN_PWR_SRC,
 			     CSR_GPIO_IN_BIT_AUX_POWER, 5000);	/* uS */
 	}
@@ -751,18 +751,18 @@ static int iwl3945_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
 
-	iwl_write_restricted(priv, FH_RCSR_RBD_BASE(0), rxq->dma_addr);
-	iwl_write_restricted(priv, FH_RCSR_RPTR_ADDR(0),
+	iwl_write_direct32(priv, FH_RCSR_RBD_BASE(0), rxq->dma_addr);
+	iwl_write_direct32(priv, FH_RCSR_RPTR_ADDR(0),
 			     priv->hw_setting.shared_phys +
 			     offsetof(struct iwl_shared, rx_read_ptr[0]));
-	iwl_write_restricted(priv, FH_RCSR_WPTR(0), 0);
-	iwl_write_restricted(priv, FH_RCSR_CONFIG(0),
+	iwl_write_direct32(priv, FH_RCSR_WPTR(0), 0);
+	iwl_write_direct32(priv, FH_RCSR_CONFIG(0),
 		ALM_FH_RCSR_RX_CONFIG_REG_VAL_DMA_CHNL_EN_ENABLE |
 		ALM_FH_RCSR_RX_CONFIG_REG_VAL_RDRBD_EN_ENABLE |
 		ALM_FH_RCSR_RX_CONFIG_REG_BIT_WR_STTS_EN |
@@ -773,9 +773,9 @@ static int iwl3945_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 		ALM_FH_RCSR_RX_CONFIG_REG_VAL_MSG_MODE_FH);
 
 	/* fake read to flush all prev I/O */
-	iwl_read_restricted(priv, FH_RSSR_CTRL);
+	iwl_read_direct32(priv, FH_RSSR_CTRL);
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
@@ -787,7 +787,7 @@ static int iwl3945_tx_reset(struct iwl_priv *priv)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
@@ -807,10 +807,10 @@ static int iwl3945_tx_reset(struct iwl_priv *priv)
 	iwl_write_prph(priv, SCD_TXF4MF_REG, 0x000004);
 	iwl_write_prph(priv, SCD_TXF5MF_REG, 0x000005);
 
-	iwl_write_restricted(priv, FH_TSSR_CBB_BASE,
+	iwl_write_direct32(priv, FH_TSSR_CBB_BASE,
 			     priv->hw_setting.shared_phys);
 
-	iwl_write_restricted(priv, FH_TSSR_MSG_CONFIG,
+	iwl_write_direct32(priv, FH_TSSR_MSG_CONFIG,
 		ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TXPD_ON |
 		ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_TXPD_ON |
 		ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_MAX_FRAG_SIZE_128B |
@@ -819,7 +819,7 @@ static int iwl3945_tx_reset(struct iwl_priv *priv)
 		ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RSP_WAIT_TH |
 		ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_RSP_WAIT_TH);
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
@@ -885,7 +885,7 @@ int iwl_hw_nic_init(struct iwl_priv *priv)
 		return rc;
 	}
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
@@ -896,7 +896,7 @@ int iwl_hw_nic_init(struct iwl_priv *priv)
 	udelay(20);
 	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
 				    APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* Determine HW type */
@@ -987,13 +987,13 @@ int iwl_hw_nic_init(struct iwl_priv *priv)
 	iwl_rx_queue_update_write_ptr(priv, rxq);
 	*/
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
-	iwl_write_restricted(priv, FH_RCSR_WPTR(0), rxq->write & ~7);
-	iwl_release_restricted_access(priv);
+	iwl_write_direct32(priv, FH_RCSR_WPTR(0), rxq->write & ~7);
+	iwl_release_nic_access(priv);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -1026,7 +1026,7 @@ void iwl_hw_txq_ctx_stop(struct iwl_priv *priv)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (iwl_grab_restricted_access(priv)) {
+	if (iwl_grab_nic_access(priv)) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		iwl_hw_txq_ctx_free(priv);
 		return;
@@ -1037,13 +1037,13 @@ void iwl_hw_txq_ctx_stop(struct iwl_priv *priv)
 
 	/* reset TFD queues */
 	for (queue = TFD_QUEUE_MIN; queue < TFD_QUEUE_MAX; queue++) {
-		iwl_write_restricted(priv, FH_TCSR_CONFIG(queue), 0x0);
-		iwl_poll_restricted_bit(priv, FH_TSSR_TX_STATUS,
+		iwl_write_direct32(priv, FH_TCSR_CONFIG(queue), 0x0);
+		iwl_poll_direct_bit(priv, FH_TSSR_TX_STATUS,
 				ALM_FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(queue),
 				1000);
 	}
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	iwl_hw_txq_ctx_free(priv);
@@ -1097,7 +1097,7 @@ int iwl_hw_nic_reset(struct iwl_priv *priv)
 			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (!rc) {
 		iwl_write_prph(priv, APMG_CLK_CTRL_REG,
 					 APMG_CLK_VAL_BSM_CLK_RQT);
@@ -1122,7 +1122,7 @@ int iwl_hw_nic_reset(struct iwl_priv *priv)
 		udelay(5);
 		iwl_clear_bits_prph(priv, APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_VAL_RESET_REQ);
-		iwl_release_restricted_access(priv);
+		iwl_release_nic_access(priv);
 	}
 
 	/* Clear the 'host command active' bit... */
@@ -2069,18 +2069,18 @@ int iwl_hw_rxq_stop(struct iwl_priv *priv)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
 
-	iwl_write_restricted(priv, FH_RCSR_CONFIG(0), 0);
-	rc = iwl_poll_restricted_bit(priv, FH_RSSR_STATUS, (1 << 24), 1000);
+	iwl_write_direct32(priv, FH_RCSR_CONFIG(0), 0);
+	rc = iwl_poll_direct_bit(priv, FH_RSSR_STATUS, (1 << 24), 1000);
 	if (rc < 0)
 		IWL_ERROR("Can't stop Rx DMA.\n");
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
@@ -2097,21 +2097,21 @@ int iwl_hw_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	shared_data->tx_base_ptr[txq_id] = cpu_to_le32((u32)txq->q.dma_addr);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
-	iwl_write_restricted(priv, FH_CBCC_CTRL(txq_id), 0);
-	iwl_write_restricted(priv, FH_CBCC_BASE(txq_id), 0);
+	iwl_write_direct32(priv, FH_CBCC_CTRL(txq_id), 0);
+	iwl_write_direct32(priv, FH_CBCC_BASE(txq_id), 0);
 
-	iwl_write_restricted(priv, FH_TCSR_CONFIG(txq_id),
+	iwl_write_direct32(priv, FH_TCSR_CONFIG(txq_id),
 		ALM_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_NOINT |
 		ALM_FH_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_TXF |
 		ALM_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_IFTFD |
 		ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL |
 		ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE);
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 
 	/* fake read to flush all prev. writes */
 	iwl_read32(priv, FH_TSSR_CBB_BASE);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 4d76102..cf85195 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -139,20 +139,20 @@ int iwl_hw_rxq_stop(struct iwl_priv *priv)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
 
 	/* stop HW */
-	iwl_write_restricted(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
-	rc = iwl_poll_restricted_bit(priv, FH_MEM_RSSR_RX_STATUS_REG,
+	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+	rc = iwl_poll_direct_bit(priv, FH_MEM_RSSR_RX_STATUS_REG,
 				     (1 << 24), 1000);
 	if (rc < 0)
 		IWL_ERROR("Can't stop Rx DMA.\n");
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
@@ -195,7 +195,7 @@ static int iwl4965_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	ret = iwl_grab_restricted_access(priv);
+	ret = iwl_grab_nic_access(priv);
 	if (ret) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return ret;
@@ -216,7 +216,7 @@ static int iwl4965_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
 			APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
 			~APMG_PS_CTRL_MSK_PWR_SRC);
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return ret;
@@ -228,24 +228,24 @@ static int iwl4965_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
 
 	/* stop HW */
-	iwl_write_restricted(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
 
-	iwl_write_restricted(priv, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
-	iwl_write_restricted(priv, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
+	iwl_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
+	iwl_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
 			     rxq->dma_addr >> 8);
 
-	iwl_write_restricted(priv, FH_RSCSR_CHNL0_STTS_WPTR_REG,
+	iwl_write_direct32(priv, FH_RSCSR_CHNL0_STTS_WPTR_REG,
 			     (priv->hw_setting.shared_phys +
 			      offsetof(struct iwl_shared, val0)) >> 4);
 
-	iwl_write_restricted(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG,
+	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG,
 			     FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
 			     FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
 			     IWL_FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K |
@@ -257,7 +257,7 @@ static int iwl4965_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 	 * iwl_write32(priv,CSR_INT_COAL_REG,0);
 	 */
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
@@ -269,13 +269,13 @@ static int iwl4965_kw_init(struct iwl_priv *priv)
 	int rc;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc)
 		goto out;
 
-	iwl_write_restricted(priv, IWL_FH_KW_MEM_ADDR_REG,
+	iwl_write_direct32(priv, IWL_FH_KW_MEM_ADDR_REG,
 			     priv->kw.dma_addr >> 4);
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 out:
 	spin_unlock_irqrestore(&priv->lock, flags);
 	return rc;
@@ -374,7 +374,7 @@ static int iwl4965_txq_ctx_reset(struct iwl_priv *priv)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (unlikely(rc)) {
 		IWL_ERROR("TX reset failed");
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -382,7 +382,7 @@ static int iwl4965_txq_ctx_reset(struct iwl_priv *priv)
 	}
 
 	iwl_write_prph(priv, SCD_TXFACT, 0);
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	rc = iwl4965_kw_init(priv);
@@ -440,7 +440,7 @@ int iwl_hw_nic_init(struct iwl_priv *priv)
 		return rc;
 	}
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
@@ -458,7 +458,7 @@ int iwl_hw_nic_init(struct iwl_priv *priv)
 	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
 				    APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 	iwl_write32(priv, CSR_INT_COALESCING, 512 / 32);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -504,7 +504,7 @@ int iwl_hw_nic_init(struct iwl_priv *priv)
 		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
 		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc < 0) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		IWL_DEBUG_INFO("Failed to init the card\n");
@@ -518,7 +518,7 @@ int iwl_hw_nic_init(struct iwl_priv *priv)
 	iwl_clear_bits_prph(priv, APMG_PS_CTRL_REG,
 				      APMG_PS_CTRL_VAL_RESET_REQ);
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	iwl_hw_card_show_info(priv);
@@ -602,18 +602,18 @@ void iwl_hw_txq_ctx_stop(struct iwl_priv *priv)
 	/* reset TFD queues */
 	for (txq_id = 0; txq_id < priv->hw_setting.max_txq_num; txq_id++) {
 		spin_lock_irqsave(&priv->lock, flags);
-		if (iwl_grab_restricted_access(priv)) {
+		if (iwl_grab_nic_access(priv)) {
 			spin_unlock_irqrestore(&priv->lock, flags);
 			continue;
 		}
 
-		iwl_write_restricted(priv,
+		iwl_write_direct32(priv,
 				     IWL_FH_TCSR_CHNL_TX_CONFIG_REG(txq_id),
 				     0x0);
-		iwl_poll_restricted_bit(priv, IWL_FH_TSSR_TX_STATUS_REG,
+		iwl_poll_direct_bit(priv, IWL_FH_TSSR_TX_STATUS_REG,
 					IWL_FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE
 					(txq_id), 200);
-		iwl_release_restricted_access(priv);
+		iwl_release_nic_access(priv);
 		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
@@ -640,7 +640,7 @@ int iwl_hw_nic_reset(struct iwl_priv *priv)
 
 	udelay(10);
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (!rc) {
 		iwl_write_prph(priv, APMG_CLK_EN_REG,
 					 APMG_CLK_VAL_DMA_CLK_RQT |
@@ -651,7 +651,7 @@ int iwl_hw_nic_reset(struct iwl_priv *priv)
 		iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
 				APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
-		iwl_release_restricted_access(priv);
+		iwl_release_nic_access(priv);
 	}
 
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
@@ -1580,7 +1580,7 @@ static void iwl4965_bg_txpower_work(struct work_struct *work)
  */
 static void iwl4965_set_wr_ptrs(struct iwl_priv *priv, int txq_id, u32 index)
 {
-	iwl_write_restricted(priv, HBUS_TARG_WRPTR,
+	iwl_write_direct32(priv, HBUS_TARG_WRPTR,
 			     (index & 0xff) | (txq_id << 8));
 	iwl_write_prph(priv, SCD_QUEUE_RDPTR(txq_id), index);
 }
@@ -1647,7 +1647,7 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 		priv->chain_noise_data.delta_gain_code[i] =
 				CHAIN_NOISE_DELTA_GAIN_INIT_VAL;
 #endif /* CONFIG_IWLWIFI_SENSITIVITY*/
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
@@ -1670,7 +1670,7 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 	/* initiate the queues */
 	for (i = 0; i < priv->hw_setting.max_txq_num; i++) {
 		iwl_write_prph(priv, SCD_QUEUE_RDPTR(i), 0);
-		iwl_write_restricted(priv, HBUS_TARG_WRPTR, 0 | (i << 8));
+		iwl_write_direct32(priv, HBUS_TARG_WRPTR, 0 | (i << 8));
 		iwl_write_targ_mem(priv, priv->scd_base_addr +
 					SCD_CONTEXT_QUEUE_OFFSET(i),
 					(SCD_WIN_SIZE <<
@@ -1698,7 +1698,7 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 		iwl4965_tx_queue_set_status(priv, &priv->txq[i], ac, 0);
 	}
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
@@ -2687,19 +2687,19 @@ int iwl_hw_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	int txq_id = txq->q.id;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
 
-	iwl_write_restricted(priv, FH_MEM_CBBC_QUEUE(txq_id),
+	iwl_write_direct32(priv, FH_MEM_CBBC_QUEUE(txq_id),
 			     txq->q.dma_addr >> 8);
-	iwl_write_restricted(
+	iwl_write_direct32(
 		priv, IWL_FH_TCSR_CHNL_TX_CONFIG_REG(txq_id),
 		IWL_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
 		IWL_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL);
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
@@ -4178,7 +4178,7 @@ static int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id,
 	iwl_sta_modify_enable_tid_tx(priv, sta_id, tid);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
@@ -4211,7 +4211,7 @@ static int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id,
 
 	iwl4965_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
@@ -4233,7 +4233,7 @@ static int iwl4965_tx_queue_agg_disable(struct iwl_priv *priv, u16 txq_id,
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
@@ -4252,7 +4252,7 @@ static int iwl4965_tx_queue_agg_disable(struct iwl_priv *priv, u16 txq_id,
 	iwl4965_txq_ctx_deactivate(priv, txq_id);
 	iwl4965_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 0);
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 5cdcfc4..43afcda 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -42,15 +42,14 @@
  * check or debug information is printed when that function is called.
  *
  * A double __ prefix before an access function means that state is checked
- * (in the case of *restricted calls) and the current line number is printed
- * in addition to any other debug output.
+ * and the current line number is printed in addition to any other debug output.
  *
  * The non-prefixed name is the #define that maps the caller into a
  * #define that provides the caller's __LINE__ to the double prefix version.
  *
  * If you wish to call the function without any debug or state checking,
  * you should use the single _ prefix version (as is used by dependent IO
- * routines, for example _iwl_read_restricted calls the non-check version of
+ * routines, for example _iwl_read_direct32 calls the non-check version of
  * _iwl_read32.)
  *
  * These declarations are *extremely* useful in quickly isolating code deltas
@@ -65,8 +64,7 @@
 static inline void __iwl_write32(const char *f, u32 l, struct iwl_priv *iwl,
 				 u32 ofs, u32 val)
 {
-	IWL_DEBUG_IO("write_direct32(0x%08X, 0x%08X) - %s %d\n",
-		     (u32) (ofs), (u32) (val), f, l);
+	IWL_DEBUG_IO("write32(0x%08X, 0x%08X) - %s %d\n", ofs, val, f, l);
 	_iwl_write32(iwl, ofs, val);
 }
 #define iwl_write32(iwl, ofs, val) \
@@ -106,16 +104,16 @@ static inline int __iwl_poll_bit(const char *f, u32 l,
 				 struct iwl_priv *priv, u32 addr,
 				 u32 bits, u32 mask, int timeout)
 {
-	int rc = _iwl_poll_bit(priv, addr, bits, mask, timeout);
-	if (unlikely(rc == -ETIMEDOUT))
+	int ret = _iwl_poll_bit(priv, addr, bits, mask, timeout);
+	if (unlikely(ret  == -ETIMEDOUT))
 		IWL_DEBUG_IO
 		    ("poll_bit(0x%08X, 0x%08X, 0x%08X) - timedout - %s %d\n",
 		     addr, bits, mask, f, l);
 	else
 		IWL_DEBUG_IO
 		    ("poll_bit(0x%08X, 0x%08X, 0x%08X) = 0x%08X - %s %d\n",
-		     addr, bits, mask, rc, f, l);
-	return rc;
+		     addr, bits, mask, ret, f, l);
+	return ret;
 }
 #define iwl_poll_bit(iwl, addr, bits, mask, timeout) \
 	__iwl_poll_bit(__FILE__, __LINE__, iwl, addr, bits, mask, timeout)
@@ -157,9 +155,9 @@ static inline void __iwl_clear_bit(const char *f, u32 l,
 #define iwl_clear_bit(p, r, m) _iwl_clear_bit(p, r, m)
 #endif
 
-static inline int _iwl_grab_restricted_access(struct iwl_priv *priv)
+static inline int _iwl_grab_nic_access(struct iwl_priv *priv)
 {
-	int rc;
+	int ret;
 	u32 gp_ctl;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -184,11 +182,11 @@ static inline int _iwl_grab_restricted_access(struct iwl_priv *priv)
 
 	/* this bit wakes up the NIC */
 	_iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-	rc = _iwl_poll_bit(priv, CSR_GP_CNTRL,
+	ret = _iwl_poll_bit(priv, CSR_GP_CNTRL,
 			   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
 			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
 			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 50);
-	if (rc < 0) {
+	if (ret < 0) {
 		IWL_ERROR("MAC is in deep sleep!\n");
 		return -EIO;
 	}
@@ -200,25 +198,24 @@ static inline int _iwl_grab_restricted_access(struct iwl_priv *priv)
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-static inline int __iwl_grab_restricted_access(const char *f, u32 l,
+static inline int __iwl_grab_nic_access(const char *f, u32 l,
 					       struct iwl_priv *priv)
 {
 	if (atomic_read(&priv->restrict_refcnt))
 		IWL_DEBUG_INFO("Grabbing access while already held at "
 			       "line %d.\n", l);
 
-	IWL_DEBUG_IO("grabbing restricted access - %s %d\n", f, l);
-
-	return _iwl_grab_restricted_access(priv);
+	IWL_DEBUG_IO("grabbing nic access - %s %d\n", f, l);
+	return _iwl_grab_nic_access(priv);
 }
-#define iwl_grab_restricted_access(priv) \
-	__iwl_grab_restricted_access(__FILE__, __LINE__, priv)
+#define iwl_grab_nic_access(priv) \
+	__iwl_grab_nic_access(__FILE__, __LINE__, priv)
 #else
-#define iwl_grab_restricted_access(priv) \
-	_iwl_grab_restricted_access(priv)
+#define iwl_grab_nic_access(priv) \
+	_iwl_grab_nic_access(priv)
 #endif
 
-static inline void _iwl_release_restricted_access(struct iwl_priv *priv)
+static inline void _iwl_release_nic_access(struct iwl_priv *priv)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (atomic_dec_and_test(&priv->restrict_refcnt))
@@ -227,80 +224,80 @@ static inline void _iwl_release_restricted_access(struct iwl_priv *priv)
 			       CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 }
 #ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_release_restricted_access(const char *f, u32 l,
-						   struct iwl_priv *priv)
+static inline void __iwl_release_nic_access(const char *f, u32 l,
+					    struct iwl_priv *priv)
 {
 	if (atomic_read(&priv->restrict_refcnt) <= 0)
-		IWL_ERROR("Release unheld restricted access at line %d.\n", l);
+		IWL_ERROR("Release unheld nic access at line %d.\n", l);
 
-	IWL_DEBUG_IO("releasing restricted access - %s %d\n", f, l);
-	_iwl_release_restricted_access(priv);
+	IWL_DEBUG_IO("releasing nic access - %s %d\n", f, l);
+	_iwl_release_nic_access(priv);
 }
-#define iwl_release_restricted_access(priv) \
-	__iwl_release_restricted_access(__FILE__, __LINE__, priv)
+#define iwl_release_nic_access(priv) \
+	__iwl_release_nic_access(__FILE__, __LINE__, priv)
 #else
-#define iwl_release_restricted_access(priv) \
-	_iwl_release_restricted_access(priv)
+#define iwl_release_nic_access(priv) \
+	_iwl_release_nic_access(priv)
 #endif
 
-static inline u32 _iwl_read_restricted(struct iwl_priv *priv, u32 reg)
+static inline u32 _iwl_read_direct32(struct iwl_priv *priv, u32 reg)
 {
 	return _iwl_read32(priv, reg);
 }
 #ifdef CONFIG_IWLWIFI_DEBUG
-static inline u32 __iwl_read_restricted(const char *f, u32 l,
+static inline u32 __iwl_read_direct32(const char *f, u32 l,
 					struct iwl_priv *priv, u32 reg)
 {
-	u32 value = _iwl_read_restricted(priv, reg);
+	u32 value = _iwl_read_direct32(priv, reg);
 	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Unrestricted access from %s %d\n", f, l);
-	IWL_DEBUG_IO("read_restricted(0x%4X) = 0x%08x - %s %d \n", reg, value,
+		IWL_ERROR("Nic access not held from %s %d\n", f, l);
+	IWL_DEBUG_IO("read_direct32(0x%4X) = 0x%08x - %s %d \n", reg, value,
 		     f, l);
 	return value;
 }
-#define iwl_read_restricted(priv, reg) \
-	__iwl_read_restricted(__FILE__, __LINE__, priv, reg)
+#define iwl_read_direct32(priv, reg) \
+	__iwl_read_direct32(__FILE__, __LINE__, priv, reg)
 #else
-#define iwl_read_restricted _iwl_read_restricted
+#define iwl_read_direct32 _iwl_read_direct32
 #endif
 
-static inline void _iwl_write_restricted(struct iwl_priv *priv,
+static inline void _iwl_write_direct32(struct iwl_priv *priv,
 					 u32 reg, u32 value)
 {
 	_iwl_write32(priv, reg, value);
 }
 #ifdef CONFIG_IWLWIFI_DEBUG
-static void __iwl_write_restricted(u32 line,
+static void __iwl_write_direct32(u32 line,
 				   struct iwl_priv *priv, u32 reg, u32 value)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Unrestricted access from line %d\n", line);
-	_iwl_write_restricted(priv, reg, value);
+		IWL_ERROR("Nic access not held from line %d\n", line);
+	_iwl_write_direct32(priv, reg, value);
 }
-#define iwl_write_restricted(priv, reg, value) \
-	__iwl_write_restricted(__LINE__, priv, reg, value)
+#define iwl_write_direct32(priv, reg, value) \
+	__iwl_write_direct32(__LINE__, priv, reg, value)
 #else
-#define iwl_write_restricted _iwl_write_restricted
+#define iwl_write_direct32 _iwl_write_direct32
 #endif
 
-static inline void iwl_write_buffer_restricted(struct iwl_priv *priv,
+static inline void iwl_write_reg_buf(struct iwl_priv *priv,
 					       u32 reg, u32 len, u32 *values)
 {
 	u32 count = sizeof(u32);
 
 	if ((priv != NULL) && (values != NULL)) {
 		for (; 0 < len; len -= count, reg += count, values++)
-			_iwl_write_restricted(priv, reg, *values);
+			_iwl_write_direct32(priv, reg, *values);
 	}
 }
 
-static inline int _iwl_poll_restricted_bit(struct iwl_priv *priv,
+static inline int _iwl_poll_direct_bit(struct iwl_priv *priv,
 					   u32 addr, u32 mask, int timeout)
 {
 	int i = 0;
 
 	do {
-		if ((_iwl_read_restricted(priv, addr) & mask) == mask)
+		if ((_iwl_read_direct32(priv, addr) & mask) == mask)
 			return i;
 		mdelay(10);
 		i += 10;
@@ -310,36 +307,36 @@ static inline int _iwl_poll_restricted_bit(struct iwl_priv *priv,
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-static inline int __iwl_poll_restricted_bit(const char *f, u32 l,
+static inline int __iwl_poll_direct_bit(const char *f, u32 l,
 					    struct iwl_priv *priv,
 					    u32 addr, u32 mask, int timeout)
 {
-	int rc = _iwl_poll_restricted_bit(priv, addr, mask, timeout);
+	int ret  = _iwl_poll_direct_bit(priv, addr, mask, timeout);
 
-	if (unlikely(rc == -ETIMEDOUT))
-		IWL_DEBUG_IO("poll_restricted_bit(0x%08X, 0x%08X) - "
+	if (unlikely(ret == -ETIMEDOUT))
+		IWL_DEBUG_IO("poll_direct_bit(0x%08X, 0x%08X) - "
 			     "timedout - %s %d\n", addr, mask, f, l);
 	else
-		IWL_DEBUG_IO("poll_restricted_bit(0x%08X, 0x%08X) = 0x%08X "
-			     "- %s %d\n", addr, mask, rc, f, l);
-	return rc;
+		IWL_DEBUG_IO("poll_direct_bit(0x%08X, 0x%08X) = 0x%08X "
+			     "- %s %d\n", addr, mask, ret, f, l);
+	return ret;
 }
-#define iwl_poll_restricted_bit(iwl, addr, mask, timeout) \
-	__iwl_poll_restricted_bit(__FILE__, __LINE__, iwl, addr, mask, timeout)
+#define iwl_poll_direct_bit(iwl, addr, mask, timeout) \
+	__iwl_poll_direct_bit(__FILE__, __LINE__, iwl, addr, mask, timeout)
 #else
-#define iwl_poll_restricted_bit _iwl_poll_restricted_bit
+#define iwl_poll_direct_bit _iwl_poll_direct_bit
 #endif
 
 static inline u32 _iwl_read_prph(struct iwl_priv *priv, u32 reg)
 {
-	_iwl_write_restricted(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
-	return _iwl_read_restricted(priv, HBUS_TARG_PRPH_RDAT);
+	_iwl_write_direct32(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
+	return _iwl_read_direct32(priv, HBUS_TARG_PRPH_RDAT);
 }
 #ifdef CONFIG_IWLWIFI_DEBUG
 static inline u32 __iwl_read_prph(u32 line, struct iwl_priv *priv, u32 reg)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Unrestricted access from line %d\n", line);
+		IWL_ERROR("Nic access not held from line %d\n", line);
 	return _iwl_read_prph(priv, reg);
 }
 
@@ -352,16 +349,16 @@ static inline u32 __iwl_read_prph(u32 line, struct iwl_priv *priv, u32 reg)
 static inline void _iwl_write_prph(struct iwl_priv *priv,
 					     u32 addr, u32 val)
 {
-	_iwl_write_restricted(priv, HBUS_TARG_PRPH_WADDR,
+	_iwl_write_direct32(priv, HBUS_TARG_PRPH_WADDR,
 			      ((addr & 0x0000FFFF) | (3 << 24)));
-	_iwl_write_restricted(priv, HBUS_TARG_PRPH_WDAT, val);
+	_iwl_write_direct32(priv, HBUS_TARG_PRPH_WDAT, val);
 }
 #ifdef CONFIG_IWLWIFI_DEBUG
 static inline void __iwl_write_prph(u32 line, struct iwl_priv *priv,
 					      u32 addr, u32 val)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Unrestricted access from line %d\n", line);
+		IWL_ERROR("Nic access from line %d\n", line);
 	_iwl_write_prph(priv, addr, val);
 }
 
@@ -378,7 +375,8 @@ static inline void __iwl_set_bits_prph(u32 line, struct iwl_priv *priv,
 					u32 reg, u32 mask)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Unrestricted access from line %d\n", line);
+		IWL_ERROR("Nic access not held from line %d\n", line);
+
 	_iwl_set_bits_prph(priv, reg, mask);
 }
 #define iwl_set_bits_prph(priv, reg, mask) \
@@ -395,7 +393,7 @@ static inline void __iwl_set_bits_mask_prph(u32 line,
 		struct iwl_priv *priv, u32 reg, u32 bits, u32 mask)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Unrestricted access from line %d\n", line);
+		IWL_ERROR("Nic access not held from line %d\n", line);
 	_iwl_set_bits_mask_prph(priv, reg, bits, mask);
 }
 #define iwl_set_bits_mask_prph(priv, reg, bits, mask) \
@@ -413,21 +411,21 @@ static inline void iwl_clear_bits_prph(struct iwl_priv
 
 static inline u32 iwl_read_targ_mem(struct iwl_priv *priv, u32 addr)
 {
-	iwl_write_restricted(priv, HBUS_TARG_MEM_RADDR, addr);
-	return iwl_read_restricted(priv, HBUS_TARG_MEM_RDAT);
+	iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR, addr);
+	return iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 }
 
 static inline void iwl_write_targ_mem(struct iwl_priv *priv, u32 addr, u32 val)
 {
-	iwl_write_restricted(priv, HBUS_TARG_MEM_WADDR, addr);
-	iwl_write_restricted(priv, HBUS_TARG_MEM_WDAT, val);
+	iwl_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
+	iwl_write_direct32(priv, HBUS_TARG_MEM_WDAT, val);
 }
 
 static inline void iwl_write_targ_mem_buf(struct iwl_priv *priv, u32 addr,
 					  u32 len, u32 *values)
 {
-	iwl_write_restricted(priv, HBUS_TARG_MEM_WADDR, addr);
+	iwl_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
 	for (; 0 < len; len -= sizeof(u32), values++)
-		iwl_write_restricted(priv, HBUS_TARG_MEM_WDAT, *values);
+		iwl_write_direct32(priv, HBUS_TARG_MEM_WDAT, *values);
 }
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 28fe9cb..37513e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1561,7 +1561,7 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 
 		for (i = 0; i < IWL_EEPROM_ACCESS_TIMEOUT;
 					i += IWL_EEPROM_ACCESS_DELAY) {
-			r = _iwl_read_restricted(priv, CSR_EEPROM_REG);
+			r = _iwl_read_direct32(priv, CSR_EEPROM_REG);
 			if (r & CSR_EEPROM_REG_READ_VALID_MSK)
 				break;
 			udelay(IWL_EEPROM_ACCESS_DELAY);
@@ -2986,8 +2986,8 @@ static void iwl_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl_read32(priv, CSR_UCODE_DRV_GP1);
-	if (!iwl_grab_restricted_access(priv))
-		iwl_release_restricted_access(priv);
+	if (!iwl_grab_nic_access(priv))
+		iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (test_bit(STATUS_RF_KILL_HW, &priv->status)) {
@@ -3944,13 +3944,13 @@ int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q)
 			goto exit_unlock;
 		}
 
-		rc = iwl_grab_restricted_access(priv);
+		rc = iwl_grab_nic_access(priv);
 		if (rc)
 			goto exit_unlock;
 
-		iwl_write_restricted(priv, FH_RSCSR_CHNL0_WPTR,
+		iwl_write_direct32(priv, FH_RSCSR_CHNL0_WPTR,
 				     q->write & ~0x7);
-		iwl_release_restricted_access(priv);
+		iwl_release_nic_access(priv);
 	} else
 		iwl_write32(priv, FH_RSCSR_CHNL0_WPTR, q->write & ~0x7);
 
@@ -4342,12 +4342,12 @@ int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
 		}
 
 		/* restore this queue's parameters in nic hardware. */
-		rc = iwl_grab_restricted_access(priv);
+		rc = iwl_grab_nic_access(priv);
 		if (rc)
 			return rc;
-		iwl_write_restricted(priv, HBUS_TARG_WRPTR,
+		iwl_write_direct32(priv, HBUS_TARG_WRPTR,
 				     txq->q.write_ptr | (txq_id << 8));
-		iwl_release_restricted_access(priv);
+		iwl_release_nic_access(priv);
 
 	/* else not in power-save mode, uCode will never sleep when we're
 	 * trying to tx (during RFKILL, we're not trying to tx). */
@@ -4439,7 +4439,7 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 		return;
 	}
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		IWL_WARNING("Can not read from adapter at this time.\n");
 		return;
@@ -4478,7 +4478,7 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 		     ilink1, ilink2, data1);
 	}
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 
 }
 
@@ -4487,7 +4487,7 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 /**
  * iwl_print_event_log - Dump error event log to syslog
  *
- * NOTE: Must be called with iwl_grab_restricted_access() already obtained!
+ * NOTE: Must be called with iwl_grab_nic_access() already obtained!
  */
 static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 				u32 num_events, u32 mode)
@@ -4543,7 +4543,7 @@ static void iwl_dump_nic_event_log(struct iwl_priv *priv)
 		return;
 	}
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		IWL_WARNING("Can not read from adapter at this time.\n");
 		return;
@@ -4560,7 +4560,7 @@ static void iwl_dump_nic_event_log(struct iwl_priv *priv)
 	/* bail out if nothing in log */
 	if (size == 0) {
 		IWL_ERROR("Start IWL Event Log Dump: nothing in log\n");
-		iwl_release_restricted_access(priv);
+		iwl_release_nic_access(priv);
 		return;
 	}
 
@@ -4576,7 +4576,7 @@ static void iwl_dump_nic_event_log(struct iwl_priv *priv)
 	/* (then/else) start at top of log */
 	iwl_print_event_log(priv, 0, next_entry, mode);
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 }
 
 /**
@@ -4765,11 +4765,11 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		IWL_DEBUG_ISR("Tx interrupt\n");
 
 		iwl_write32(priv, CSR_FH_INT_STATUS, (1 << 6));
-		if (!iwl_grab_restricted_access(priv)) {
-			iwl_write_restricted(priv,
+		if (!iwl_grab_nic_access(priv)) {
+			iwl_write_direct32(priv,
 					     FH_TCSR_CREDIT
 					     (ALM_FH_SRVC_CHNL), 0x0);
-			iwl_release_restricted_access(priv);
+			iwl_release_nic_access(priv);
 		}
 		handled |= CSR_INT_BIT_FH_TX;
 	}
@@ -5472,18 +5472,18 @@ static int iwl_verify_inst_full(struct iwl_priv *priv, __le32 * image, u32 len)
 
 	IWL_DEBUG_INFO("ucode inst image size is %u\n", len);
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc)
 		return rc;
 
-	iwl_write_restricted(priv, HBUS_TARG_MEM_RADDR, RTC_INST_LOWER_BOUND);
+	iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR, RTC_INST_LOWER_BOUND);
 
 	errcnt = 0;
 	for (; len > 0; len -= sizeof(u32), image++) {
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IWL_DL_IO is set */
-		val = _iwl_read_restricted(priv, HBUS_TARG_MEM_RDAT);
+		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 			IWL_ERROR("uCode INST section is invalid at "
 				  "offset 0x%x, is 0x%x, s/b 0x%x\n",
@@ -5495,7 +5495,7 @@ static int iwl_verify_inst_full(struct iwl_priv *priv, __le32 * image, u32 len)
 		}
 	}
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 
 	if (!errcnt)
 		IWL_DEBUG_INFO("ucode image in INSTRUCTION memory is good\n");
@@ -5518,7 +5518,7 @@ static int iwl_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32 len)
 
 	IWL_DEBUG_INFO("ucode inst image size is %u\n", len);
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc)
 		return rc;
 
@@ -5526,9 +5526,9 @@ static int iwl_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32 len)
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IWL_DL_IO is set */
-		iwl_write_restricted(priv, HBUS_TARG_MEM_RADDR,
+		iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR,
 			i + RTC_INST_LOWER_BOUND);
-		val = _iwl_read_restricted(priv, HBUS_TARG_MEM_RDAT);
+		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 #if 0 /* Enable this if you want to see details */
 			IWL_ERROR("uCode INST section is invalid at "
@@ -5542,7 +5542,7 @@ static int iwl_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32 len)
 		}
 	}
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 
 	return rc;
 }
@@ -5689,7 +5689,7 @@ static int iwl_load_bsm(struct iwl_priv *priv)
 	inst_len = priv->ucode_init.len;
 	data_len = priv->ucode_init_data.len;
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc)
 		return rc;
 
@@ -5707,7 +5707,7 @@ static int iwl_load_bsm(struct iwl_priv *priv)
 
 	rc = iwl_verify_bsm(priv);
 	if (rc) {
-		iwl_release_restricted_access(priv);
+		iwl_release_nic_access(priv);
 		return rc;
 	}
 
@@ -5741,7 +5741,7 @@ static int iwl_load_bsm(struct iwl_priv *priv)
 	iwl_write_prph(priv, BSM_WR_CTRL_REG,
 		BSM_WR_CTRL_REG_BIT_START_EN);
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 
 	return 0;
 }
@@ -5982,7 +5982,7 @@ static int iwl_set_ucode_ptrs(struct iwl_priv *priv)
 	pdata = priv->ucode_data_backup.p_addr;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
@@ -5999,7 +5999,7 @@ static int iwl_set_ucode_ptrs(struct iwl_priv *priv)
 	iwl_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG,
 				 priv->ucode_code.len | BSM_DRAM_INST_LOAD);
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -6088,7 +6088,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 
 	iwl_clear_stations_table(priv);
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		IWL_WARNING("Can not read rfkill status from adapter\n");
 		return;
@@ -6096,7 +6096,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 
 	rfkill = iwl_read_prph(priv, APMG_RFKILL_REG);
 	IWL_DEBUG_INFO("RFKILL status: 0x%x\n", rfkill);
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 
 	if (rfkill & 0x1) {
 		clear_bit(STATUS_RF_KILL_HW, &priv->status);
@@ -6259,10 +6259,10 @@ static void __iwl_down(struct iwl_priv *priv)
 	iwl_hw_rxq_stop(priv);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (!iwl_grab_restricted_access(priv)) {
+	if (!iwl_grab_nic_access(priv)) {
 		iwl_write_prph(priv, APMG_CLK_DIS_REG,
 					 APMG_CLK_VAL_DMA_CLK_RQT);
-		iwl_release_restricted_access(priv);
+		iwl_release_nic_access(priv);
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -8604,10 +8604,10 @@ static void iwl_resume(struct iwl_priv *priv)
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 
-	if (!iwl_grab_restricted_access(priv)) {
+	if (!iwl_grab_nic_access(priv)) {
 		iwl_write_prph(priv, APMG_CLK_DIS_REG,
 					 APMG_CLK_VAL_DMA_CLK_RQT);
-		iwl_release_restricted_access(priv);
+		iwl_release_nic_access(priv);
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 0541f71..dad184a 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1608,7 +1608,7 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 
 		for (i = 0; i < IWL_EEPROM_ACCESS_TIMEOUT;
 					i += IWL_EEPROM_ACCESS_DELAY) {
-			r = _iwl_read_restricted(priv, CSR_EEPROM_REG);
+			r = _iwl_read_direct32(priv, CSR_EEPROM_REG);
 			if (r & CSR_EEPROM_REG_READ_VALID_MSK)
 				break;
 			udelay(IWL_EEPROM_ACCESS_DELAY);
@@ -3078,8 +3078,8 @@ static void iwl_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl_read32(priv, CSR_UCODE_DRV_GP1);
-	if (!iwl_grab_restricted_access(priv))
-		iwl_release_restricted_access(priv);
+	if (!iwl_grab_nic_access(priv))
+		iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (test_bit(STATUS_RF_KILL_HW, &priv->status)) {
@@ -4016,23 +4016,23 @@ static void iwl_rx_card_state_notif(struct iwl_priv *priv,
 		iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
 			    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
-		if (!iwl_grab_restricted_access(priv)) {
-			iwl_write_restricted(
+		if (!iwl_grab_nic_access(priv)) {
+			iwl_write_direct32(
 				priv, HBUS_TARG_MBX_C,
 				HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
 
-			iwl_release_restricted_access(priv);
+			iwl_release_nic_access(priv);
 		}
 
 		if (!(flags & RXON_CARD_DISABLED)) {
 			iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
 				    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
-			if (!iwl_grab_restricted_access(priv)) {
-				iwl_write_restricted(
+			if (!iwl_grab_nic_access(priv)) {
+				iwl_write_direct32(
 					priv, HBUS_TARG_MBX_C,
 					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
 
-				iwl_release_restricted_access(priv);
+				iwl_release_nic_access(priv);
 			}
 		}
 
@@ -4040,8 +4040,8 @@ static void iwl_rx_card_state_notif(struct iwl_priv *priv,
 			iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
 				    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
 			iwl_read32(priv, CSR_UCODE_DRV_GP1);
-			if (!iwl_grab_restricted_access(priv))
-				iwl_release_restricted_access(priv);
+			if (!iwl_grab_nic_access(priv))
+				iwl_release_nic_access(priv);
 		}
 	}
 
@@ -4269,13 +4269,13 @@ int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q)
 			goto exit_unlock;
 		}
 
-		rc = iwl_grab_restricted_access(priv);
+		rc = iwl_grab_nic_access(priv);
 		if (rc)
 			goto exit_unlock;
 
-		iwl_write_restricted(priv, FH_RSCSR_CHNL0_WPTR,
+		iwl_write_direct32(priv, FH_RSCSR_CHNL0_WPTR,
 				     q->write & ~0x7);
-		iwl_release_restricted_access(priv);
+		iwl_release_nic_access(priv);
 	} else
 		iwl_write32(priv, FH_RSCSR_CHNL0_WPTR, q->write & ~0x7);
 
@@ -4671,12 +4671,12 @@ int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
 		}
 
 		/* restore this queue's parameters in nic hardware. */
-		rc = iwl_grab_restricted_access(priv);
+		rc = iwl_grab_nic_access(priv);
 		if (rc)
 			return rc;
-		iwl_write_restricted(priv, HBUS_TARG_WRPTR,
+		iwl_write_direct32(priv, HBUS_TARG_WRPTR,
 				     txq->q.write_ptr | (txq_id << 8));
-		iwl_release_restricted_access(priv);
+		iwl_release_nic_access(priv);
 
 	/* else not in power-save mode, uCode will never sleep when we're
 	 * trying to tx (during RFKILL, we're not trying to tx). */
@@ -4768,7 +4768,7 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 		return;
 	}
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		IWL_WARNING("Can not read from adapter at this time.\n");
 		return;
@@ -4800,7 +4800,7 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	IWL_ERROR("0x%05X 0x%05X 0x%05X 0x%05X\n", blink1, blink2,
 		  ilink1, ilink2);
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 }
 
 #define EVENT_START_OFFSET  (4 * sizeof(u32))
@@ -4808,7 +4808,7 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 /**
  * iwl_print_event_log - Dump error event log to syslog
  *
- * NOTE: Must be called with iwl_grab_restricted_access() already obtained!
+ * NOTE: Must be called with iwl_grab_nic_access() already obtained!
  */
 static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 				u32 num_events, u32 mode)
@@ -4864,7 +4864,7 @@ static void iwl_dump_nic_event_log(struct iwl_priv *priv)
 		return;
 	}
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		IWL_WARNING("Can not read from adapter at this time.\n");
 		return;
@@ -4881,7 +4881,7 @@ static void iwl_dump_nic_event_log(struct iwl_priv *priv)
 	/* bail out if nothing in log */
 	if (size == 0) {
 		IWL_ERROR("Start IWL Event Log Dump: nothing in log\n");
-		iwl_release_restricted_access(priv);
+		iwl_release_nic_access(priv);
 		return;
 	}
 
@@ -4897,7 +4897,7 @@ static void iwl_dump_nic_event_log(struct iwl_priv *priv)
 	/* (then/else) start at top of log */
 	iwl_print_event_log(priv, 0, next_entry, mode);
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 }
 
 /**
@@ -5850,18 +5850,18 @@ static int iwl_verify_inst_full(struct iwl_priv *priv, __le32 * image, u32 len)
 
 	IWL_DEBUG_INFO("ucode inst image size is %u\n", len);
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc)
 		return rc;
 
-	iwl_write_restricted(priv, HBUS_TARG_MEM_RADDR, RTC_INST_LOWER_BOUND);
+	iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR, RTC_INST_LOWER_BOUND);
 
 	errcnt = 0;
 	for (; len > 0; len -= sizeof(u32), image++) {
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IWL_DL_IO is set */
-		val = _iwl_read_restricted(priv, HBUS_TARG_MEM_RDAT);
+		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 			IWL_ERROR("uCode INST section is invalid at "
 				  "offset 0x%x, is 0x%x, s/b 0x%x\n",
@@ -5873,7 +5873,7 @@ static int iwl_verify_inst_full(struct iwl_priv *priv, __le32 * image, u32 len)
 		}
 	}
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 
 	if (!errcnt)
 		IWL_DEBUG_INFO
@@ -5897,7 +5897,7 @@ static int iwl_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32 len)
 
 	IWL_DEBUG_INFO("ucode inst image size is %u\n", len);
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc)
 		return rc;
 
@@ -5905,9 +5905,9 @@ static int iwl_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32 len)
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IWL_DL_IO is set */
-		iwl_write_restricted(priv, HBUS_TARG_MEM_RADDR,
+		iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR,
 			i + RTC_INST_LOWER_BOUND);
-		val = _iwl_read_restricted(priv, HBUS_TARG_MEM_RDAT);
+		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 #if 0 /* Enable this if you want to see details */
 			IWL_ERROR("uCode INST section is invalid at "
@@ -5921,7 +5921,7 @@ static int iwl_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32 len)
 		}
 	}
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 
 	return rc;
 }
@@ -6068,7 +6068,7 @@ static int iwl_load_bsm(struct iwl_priv *priv)
 	inst_len = priv->ucode_init.len;
 	data_len = priv->ucode_init_data.len;
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc)
 		return rc;
 
@@ -6086,7 +6086,7 @@ static int iwl_load_bsm(struct iwl_priv *priv)
 
 	rc = iwl_verify_bsm(priv);
 	if (rc) {
-		iwl_release_restricted_access(priv);
+		iwl_release_nic_access(priv);
 		return rc;
 	}
 
@@ -6120,7 +6120,7 @@ static int iwl_load_bsm(struct iwl_priv *priv)
 	iwl_write_prph(priv, BSM_WR_CTRL_REG,
 		BSM_WR_CTRL_REG_BIT_START_EN);
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 
 	return 0;
 }
@@ -6365,7 +6365,7 @@ static int iwl_set_ucode_ptrs(struct iwl_priv *priv)
 	pdata = priv->ucode_data_backup.p_addr >> 4;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
@@ -6382,7 +6382,7 @@ static int iwl_set_ucode_ptrs(struct iwl_priv *priv)
 	iwl_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG,
 				 priv->ucode_code.len | BSM_DRAM_INST_LOAD);
 
-	iwl_release_restricted_access(priv);
+	iwl_release_nic_access(priv);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -6624,10 +6624,10 @@ static void __iwl_down(struct iwl_priv *priv)
 	iwl_hw_rxq_stop(priv);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (!iwl_grab_restricted_access(priv)) {
+	if (!iwl_grab_nic_access(priv)) {
 		iwl_write_prph(priv, APMG_CLK_DIS_REG,
 					 APMG_CLK_VAL_DMA_CLK_RQT);
-		iwl_release_restricted_access(priv);
+		iwl_release_nic_access(priv);
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -9208,10 +9208,10 @@ static void iwl_resume(struct iwl_priv *priv)
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 
-	if (!iwl_grab_restricted_access(priv)) {
+	if (!iwl_grab_nic_access(priv)) {
 		iwl_write_prph(priv, APMG_CLK_DIS_REG,
-					 APMG_CLK_VAL_DMA_CLK_RQT);
-		iwl_release_restricted_access(priv);
+				APMG_CLK_VAL_DMA_CLK_RQT);
+		iwl_release_nic_access(priv);
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-- 
1.5.2
