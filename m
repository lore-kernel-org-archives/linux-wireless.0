Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25551 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757504AbZEVRzO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 13:55:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/10] iwlcore: register locks
Date: Fri, 22 May 2009 11:01:47 -0700
Message-Id: <1243015315-13848-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1243015315-13848-2-git-send-email-reinette.chatre@intel.com>
References: <1243015315-13848-1-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

    Add new lock to be used when accessing some registers. Also move
    the register lock and iwl_grab_nic_access inside the function for register access. This
    will prevent from forgetting to hold locks and nic access in the right way and make code
    easier to maintain.

    We over use the priv->lock spin lock and I guess we need to add new
    one for Tx queue after that we might need to change most of these lock to
    BH and just keep priv->lock as irq type.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |  144 ++--------------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   60 +------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   54 ------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   56 ++-----
 drivers/net/wireless/iwlwifi/iwl-core.c     |   34 +----
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    2 -
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |    2 -
 drivers/net/wireless/iwlwifi/iwl-io.h       |  253 +++++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   31 ----
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   17 --
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   73 +-------
 12 files changed, 203 insertions(+), 524 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 5b0c6e5..8bed044 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -98,7 +98,6 @@ const struct iwl3945_rate_info iwl3945_rates[IWL_RATE_COUNT_3945] = {
  *   ... and set IWL_EVT_DISABLE to 1. */
 void iwl3945_disable_events(struct iwl_priv *priv)
 {
-	int ret;
 	int i;
 	u32 base;		/* SRAM address of event log header */
 	u32 disable_ptr;	/* SRAM address of event-disable bitmap array */
@@ -159,26 +158,17 @@ void iwl3945_disable_events(struct iwl_priv *priv)
 		return;
 	}
 
-	ret = iwl_grab_nic_access(priv);
-	if (ret) {
-		IWL_WARN(priv, "Can not read from adapter at this time.\n");
-		return;
-	}
-
 	disable_ptr = iwl_read_targ_mem(priv, base + (4 * sizeof(u32)));
 	array_size = iwl_read_targ_mem(priv, base + (5 * sizeof(u32)));
-	iwl_release_nic_access(priv);
 
 	if (IWL_EVT_DISABLE && (array_size == IWL_EVT_DISABLE_SIZE)) {
 		IWL_DEBUG_INFO(priv, "Disabling selected uCode log events at 0x%x\n",
 			       disable_ptr);
-		ret = iwl_grab_nic_access(priv);
 		for (i = 0; i < IWL_EVT_DISABLE_SIZE; i++)
 			iwl_write_targ_mem(priv,
 					   disable_ptr + (i * sizeof(u32)),
 					   evt_disable[i]);
 
-		iwl_release_nic_access(priv);
 	} else {
 		IWL_DEBUG_INFO(priv, "Selected uCode log events may be disabled\n");
 		IWL_DEBUG_INFO(priv, "  by writing \"1\"s into disable bitmap\n");
@@ -908,55 +898,30 @@ u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id, u16 tx_rate, u8 flags)
 
 static int iwl3945_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
 {
-	int ret;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	ret = iwl_grab_nic_access(priv);
-	if (ret) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return ret;
-	}
-
 	if (src == IWL_PWR_SRC_VAUX) {
 		if (pci_pme_capable(priv->pci_dev, PCI_D3cold)) {
 			iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
 					APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
 					~APMG_PS_CTRL_MSK_PWR_SRC);
-			iwl_release_nic_access(priv);
 
 			iwl_poll_bit(priv, CSR_GPIO_IN,
 				     CSR_GPIO_IN_VAL_VAUX_PWR_SRC,
 				     CSR_GPIO_IN_BIT_AUX_POWER, 5000);
-		} else {
-			iwl_release_nic_access(priv);
 		}
 	} else {
 		iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
 				~APMG_PS_CTRL_MSK_PWR_SRC);
 
-		iwl_release_nic_access(priv);
 		iwl_poll_bit(priv, CSR_GPIO_IN, CSR_GPIO_IN_VAL_VMAIN_PWR_SRC,
 			     CSR_GPIO_IN_BIT_AUX_POWER, 5000);	/* uS */
 	}
-	spin_unlock_irqrestore(&priv->lock, flags);
 
-	return ret;
+	return 0;
 }
 
 static int iwl3945_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 {
-	int rc;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return rc;
-	}
-
 	iwl_write_direct32(priv, FH39_RCSR_RBD_BASE(0), rxq->dma_addr);
 	iwl_write_direct32(priv, FH39_RCSR_RPTR_ADDR(0), rxq->rb_stts_dma);
 	iwl_write_direct32(priv, FH39_RCSR_WPTR(0), 0);
@@ -973,23 +938,11 @@ static int iwl3945_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 	/* fake read to flush all prev I/O */
 	iwl_read_direct32(priv, FH39_RSSR_CTRL);
 
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	return 0;
 }
 
 static int iwl3945_tx_reset(struct iwl_priv *priv)
 {
-	int rc;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return rc;
-	}
 
 	/* bypass mode */
 	iwl_write_prph(priv, ALM_SCD_MODE_REG, 0x2);
@@ -1017,8 +970,6 @@ static int iwl3945_tx_reset(struct iwl_priv *priv)
 		FH39_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RSP_WAIT_TH |
 		FH39_TSSR_TX_MSG_CONFIG_REG_VAL_RSP_WAIT_TH);
 
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
 }
@@ -1061,7 +1012,7 @@ static int iwl3945_txq_ctx_reset(struct iwl_priv *priv)
 
 static int iwl3945_apm_init(struct iwl_priv *priv)
 {
-	int ret = 0;
+	int ret;
 
 	iwl_power_initialize(priv);
 
@@ -1083,10 +1034,6 @@ static int iwl3945_apm_init(struct iwl_priv *priv)
 		goto out;
 	}
 
-	ret = iwl_grab_nic_access(priv);
-	if (ret)
-		goto out;
-
 	/* enable DMA */
 	iwl_write_prph(priv, APMG_CLK_CTRL_REG, APMG_CLK_VAL_DMA_CLK_RQT |
 						APMG_CLK_VAL_BSM_CLK_RQT);
@@ -1097,7 +1044,6 @@ static int iwl3945_apm_init(struct iwl_priv *priv)
 	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
 			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
-	iwl_release_nic_access(priv);
 out:
 	return ret;
 }
@@ -1196,22 +1142,13 @@ int iwl3945_hw_nic_init(struct iwl_priv *priv)
 
 	iwl3945_rx_init(priv, rxq);
 
-	spin_lock_irqsave(&priv->lock, flags);
 
 	/* Look at using this instead:
 	rxq->need_update = 1;
 	iwl_rx_queue_update_write_ptr(priv, rxq);
 	*/
 
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return rc;
-	}
 	iwl_write_direct32(priv, FH39_RCSR_WPTR(0), rxq->write & ~7);
-	iwl_release_nic_access(priv);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
 
 	rc = iwl3945_txq_ctx_reset(priv);
 	if (rc)
@@ -1243,14 +1180,6 @@ void iwl3945_hw_txq_ctx_free(struct iwl_priv *priv)
 void iwl3945_hw_txq_ctx_stop(struct iwl_priv *priv)
 {
 	int txq_id;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	if (iwl_grab_nic_access(priv)) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		iwl3945_hw_txq_ctx_free(priv);
-		return;
-	}
 
 	/* stop SCD */
 	iwl_write_prph(priv, ALM_SCD_MODE_REG, 0);
@@ -1263,9 +1192,6 @@ void iwl3945_hw_txq_ctx_stop(struct iwl_priv *priv)
 				1000);
 	}
 
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	iwl3945_hw_txq_ctx_free(priv);
 }
 
@@ -1310,12 +1236,8 @@ static void iwl3945_apm_stop(struct iwl_priv *priv)
 
 static int iwl3945_apm_reset(struct iwl_priv *priv)
 {
-	int rc;
-	unsigned long flags;
-
 	iwl3945_apm_stop_master(priv);
 
-	spin_lock_irqsave(&priv->lock, flags);
 
 	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
 	udelay(10);
@@ -1325,36 +1247,31 @@ static int iwl3945_apm_reset(struct iwl_priv *priv)
 	iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
 			 CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 
-	rc = iwl_grab_nic_access(priv);
-	if (!rc) {
-		iwl_write_prph(priv, APMG_CLK_CTRL_REG,
-					 APMG_CLK_VAL_BSM_CLK_RQT);
+	iwl_write_prph(priv, APMG_CLK_CTRL_REG,
+				APMG_CLK_VAL_BSM_CLK_RQT);
 
-		iwl_write_prph(priv, APMG_RTC_INT_MSK_REG, 0x0);
-		iwl_write_prph(priv, APMG_RTC_INT_STT_REG,
+	iwl_write_prph(priv, APMG_RTC_INT_MSK_REG, 0x0);
+	iwl_write_prph(priv, APMG_RTC_INT_STT_REG,
 					0xFFFFFFFF);
 
-		/* enable DMA */
-		iwl_write_prph(priv, APMG_CLK_EN_REG,
-					 APMG_CLK_VAL_DMA_CLK_RQT |
-					 APMG_CLK_VAL_BSM_CLK_RQT);
-		udelay(10);
+	/* enable DMA */
+	iwl_write_prph(priv, APMG_CLK_EN_REG,
+				APMG_CLK_VAL_DMA_CLK_RQT |
+				APMG_CLK_VAL_BSM_CLK_RQT);
+	udelay(10);
 
-		iwl_set_bits_prph(priv, APMG_PS_CTRL_REG,
+	iwl_set_bits_prph(priv, APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_VAL_RESET_REQ);
-		udelay(5);
-		iwl_clear_bits_prph(priv, APMG_PS_CTRL_REG,
+	udelay(5);
+	iwl_clear_bits_prph(priv, APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_VAL_RESET_REQ);
-		iwl_release_nic_access(priv);
-	}
 
 	/* Clear the 'host command active' bit... */
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 
 	wake_up_interruptible(&priv->wait_command_queue);
-	spin_unlock_irqrestore(&priv->lock, flags);
 
-	return rc;
+	return 0;
 }
 
 /**
@@ -2500,14 +2417,6 @@ int iwl3945_txpower_set_from_eeprom(struct iwl_priv *priv)
 int iwl3945_hw_rxq_stop(struct iwl_priv *priv)
 {
 	int rc;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return rc;
-	}
 
 	iwl_write_direct32(priv, FH39_RCSR_CONFIG(0), 0);
 	rc = iwl_poll_direct_bit(priv, FH39_RSSR_STATUS,
@@ -2515,28 +2424,17 @@ int iwl3945_hw_rxq_stop(struct iwl_priv *priv)
 	if (rc < 0)
 		IWL_ERR(priv, "Can't stop Rx DMA.\n");
 
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	return 0;
 }
 
 int iwl3945_hw_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 {
-	int rc;
-	unsigned long flags;
 	int txq_id = txq->q.id;
 
 	struct iwl3945_shared *shared_data = priv->shared_virt;
 
 	shared_data->tx_base_ptr[txq_id] = cpu_to_le32((u32)txq->q.dma_addr);
 
-	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return rc;
-	}
 	iwl_write_direct32(priv, FH39_CBCC_CTRL(txq_id), 0);
 	iwl_write_direct32(priv, FH39_CBCC_BASE(txq_id), 0);
 
@@ -2546,11 +2444,9 @@ int iwl3945_hw_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 		FH39_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_IFTFD |
 		FH39_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL |
 		FH39_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE);
-	iwl_release_nic_access(priv);
 
 	/* fake read to flush all prev. writes */
 	iwl_read32(priv, FH39_TSSR_CBB_BASE);
-	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
 }
@@ -2858,10 +2754,6 @@ static int iwl3945_load_bsm(struct iwl_priv *priv)
 	inst_len = priv->ucode_init.len;
 	data_len = priv->ucode_init_data.len;
 
-	rc = iwl_grab_nic_access(priv);
-	if (rc)
-		return rc;
-
 	iwl_write_prph(priv, BSM_DRAM_INST_PTR_REG, pinst);
 	iwl_write_prph(priv, BSM_DRAM_DATA_PTR_REG, pdata);
 	iwl_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG, inst_len);
@@ -2875,10 +2767,8 @@ static int iwl3945_load_bsm(struct iwl_priv *priv)
 					  le32_to_cpu(*image));
 
 	rc = iwl3945_verify_bsm(priv);
-	if (rc) {
-		iwl_release_nic_access(priv);
+	if (rc)
 		return rc;
-	}
 
 	/* Tell BSM to copy from BSM SRAM into instruction SRAM, when asked */
 	iwl_write_prph(priv, BSM_WR_MEM_SRC_REG, 0x0);
@@ -2910,8 +2800,6 @@ static int iwl3945_load_bsm(struct iwl_priv *priv)
 	iwl_write_prph(priv, BSM_WR_CTRL_REG,
 		BSM_WR_CTRL_REG_BIT_START_EN);
 
-	iwl_release_nic_access(priv);
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 97131e6..4be7bd2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -163,10 +163,6 @@ static int iwl4965_load_bsm(struct iwl_priv *priv)
 	inst_len = priv->ucode_init.len;
 	data_len = priv->ucode_init_data.len;
 
-	ret = iwl_grab_nic_access(priv);
-	if (ret)
-		return ret;
-
 	iwl_write_prph(priv, BSM_DRAM_INST_PTR_REG, pinst);
 	iwl_write_prph(priv, BSM_DRAM_DATA_PTR_REG, pdata);
 	iwl_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG, inst_len);
@@ -179,10 +175,8 @@ static int iwl4965_load_bsm(struct iwl_priv *priv)
 		_iwl_write_prph(priv, reg_offset, le32_to_cpu(*image));
 
 	ret = iwl4965_verify_bsm(priv);
-	if (ret) {
-		iwl_release_nic_access(priv);
+	if (ret)
 		return ret;
-	}
 
 	/* Tell BSM to copy from BSM SRAM into instruction SRAM, when asked */
 	iwl_write_prph(priv, BSM_WR_MEM_SRC_REG, 0x0);
@@ -211,7 +205,6 @@ static int iwl4965_load_bsm(struct iwl_priv *priv)
 	 *   (e.g. when powering back up after power-save shutdown) */
 	iwl_write_prph(priv, BSM_WR_CTRL_REG, BSM_WR_CTRL_REG_BIT_START_EN);
 
-	iwl_release_nic_access(priv);
 
 	return 0;
 }
@@ -229,20 +222,12 @@ static int iwl4965_set_ucode_ptrs(struct iwl_priv *priv)
 {
 	dma_addr_t pinst;
 	dma_addr_t pdata;
-	unsigned long flags;
 	int ret = 0;
 
 	/* bits 35:4 for 4965 */
 	pinst = priv->ucode_code.p_addr >> 4;
 	pdata = priv->ucode_data_backup.p_addr >> 4;
 
-	spin_lock_irqsave(&priv->lock, flags);
-	ret = iwl_grab_nic_access(priv);
-	if (ret) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return ret;
-	}
-
 	/* Tell bootstrap uCode where to find image to load */
 	iwl_write_prph(priv, BSM_DRAM_INST_PTR_REG, pinst);
 	iwl_write_prph(priv, BSM_DRAM_DATA_PTR_REG, pdata);
@@ -253,10 +238,6 @@ static int iwl4965_set_ucode_ptrs(struct iwl_priv *priv)
 	 *   that all new ptr/size info is in place */
 	iwl_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG,
 				 priv->ucode_code.len | BSM_DRAM_INST_LOAD);
-	iwl_release_nic_access(priv);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	IWL_DEBUG_INFO(priv, "Runtime uCode pointers are set.\n");
 
 	return ret;
@@ -358,10 +339,6 @@ static int iwl4965_apm_init(struct iwl_priv *priv)
 		goto out;
 	}
 
-	ret = iwl_grab_nic_access(priv);
-	if (ret)
-		goto out;
-
 	/* enable DMA */
 	iwl_write_prph(priv, APMG_CLK_CTRL_REG, APMG_CLK_VAL_DMA_CLK_RQT |
 						APMG_CLK_VAL_BSM_CLK_RQT);
@@ -372,7 +349,6 @@ static int iwl4965_apm_init(struct iwl_priv *priv)
 	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
 			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
-	iwl_release_nic_access(priv);
 out:
 	return ret;
 }
@@ -454,11 +430,9 @@ static void iwl4965_apm_stop(struct iwl_priv *priv)
 static int iwl4965_apm_reset(struct iwl_priv *priv)
 {
 	int ret = 0;
-	unsigned long flags;
 
 	iwl4965_apm_stop_master(priv);
 
-	spin_lock_irqsave(&priv->lock, flags);
 
 	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
 
@@ -475,9 +449,6 @@ static int iwl4965_apm_reset(struct iwl_priv *priv)
 
 	udelay(10);
 
-	ret = iwl_grab_nic_access(priv);
-	if (ret)
-		goto out;
 	/* Enable DMA and BSM Clock */
 	iwl_write_prph(priv, APMG_CLK_EN_REG, APMG_CLK_VAL_DMA_CLK_RQT |
 					      APMG_CLK_VAL_BSM_CLK_RQT);
@@ -488,14 +459,10 @@ static int iwl4965_apm_reset(struct iwl_priv *priv)
 	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
 			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
-	iwl_release_nic_access(priv);
-
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 	wake_up_interruptible(&priv->wait_command_queue);
 
 out:
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	return ret;
 }
 
@@ -681,18 +648,11 @@ static int iwl4965_alive_notify(struct iwl_priv *priv)
 {
 	u32 a;
 	unsigned long flags;
-	int ret;
 	int i, chan;
 	u32 reg_val;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	ret = iwl_grab_nic_access(priv);
-	if (ret) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return ret;
-	}
-
 	/* Clear 4965's internal Tx Scheduler data base */
 	priv->scd_base_addr = iwl_read_prph(priv, IWL49_SCD_SRAM_BASE_ADDR);
 	a = priv->scd_base_addr + IWL49_SCD_CONTEXT_DATA_OFFSET;
@@ -759,10 +719,9 @@ static int iwl4965_alive_notify(struct iwl_priv *priv)
 		iwl4965_tx_queue_set_status(priv, &priv->txq[i], ac, 0);
 	}
 
-	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	return ret;
+	return 0;
 }
 
 static struct iwl_sensitivity_ranges iwl4965_sensitivity = {
@@ -1840,8 +1799,6 @@ static void iwl4965_tx_queue_stop_scheduler(struct iwl_priv *priv,
 static int iwl4965_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 				   u16 ssn_idx, u8 tx_fifo)
 {
-	int ret = 0;
-
 	if ((IWL49_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IWL49_FIRST_AMPDU_QUEUE + IWL49_NUM_AMPDU_QUEUES <= txq_id)) {
 		IWL_WARN(priv,
@@ -1851,10 +1808,6 @@ static int iwl4965_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 		return -EINVAL;
 	}
 
-	ret = iwl_grab_nic_access(priv);
-	if (ret)
-		return ret;
-
 	iwl4965_tx_queue_stop_scheduler(priv, txq_id);
 
 	iwl_clear_bits_prph(priv, IWL49_SCD_QUEUECHAIN_SEL, (1 << txq_id));
@@ -1868,8 +1821,6 @@ static int iwl4965_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 	iwl_txq_ctx_deactivate(priv, txq_id);
 	iwl4965_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 0);
 
-	iwl_release_nic_access(priv);
-
 	return 0;
 }
 
@@ -1911,7 +1862,6 @@ static int iwl4965_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 				  int tx_fifo, int sta_id, int tid, u16 ssn_idx)
 {
 	unsigned long flags;
-	int ret;
 	u16 ra_tid;
 
 	if ((IWL49_FIRST_AMPDU_QUEUE > txq_id) ||
@@ -1929,11 +1879,6 @@ static int iwl4965_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	ret = iwl_grab_nic_access(priv);
-	if (ret) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return ret;
-	}
 
 	/* Stop this Tx queue before configuring it */
 	iwl4965_tx_queue_stop_scheduler(priv, txq_id);
@@ -1966,7 +1911,6 @@ static int iwl4965_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
 	iwl4965_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
 
-	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 3681315..96ba1d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -124,10 +124,6 @@ static int iwl5000_apm_init(struct iwl_priv *priv)
 		return ret;
 	}
 
-	ret = iwl_grab_nic_access(priv);
-	if (ret)
-		return ret;
-
 	/* enable DMA */
 	iwl_write_prph(priv, APMG_CLK_EN_REG, APMG_CLK_VAL_DMA_CLK_RQT);
 
@@ -137,8 +133,6 @@ static int iwl5000_apm_init(struct iwl_priv *priv)
 	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
 			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
-	iwl_release_nic_access(priv);
-
 	return ret;
 }
 
@@ -165,12 +159,9 @@ static void iwl5000_apm_stop(struct iwl_priv *priv)
 static int iwl5000_apm_reset(struct iwl_priv *priv)
 {
 	int ret = 0;
-	unsigned long flags;
 
 	iwl5000_apm_stop_master(priv);
 
-	spin_lock_irqsave(&priv->lock, flags);
-
 	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
 
 	udelay(10);
@@ -193,10 +184,6 @@ static int iwl5000_apm_reset(struct iwl_priv *priv)
 		goto out;
 	}
 
-	ret = iwl_grab_nic_access(priv);
-	if (ret)
-		goto out;
-
 	/* enable DMA */
 	iwl_write_prph(priv, APMG_CLK_EN_REG, APMG_CLK_VAL_DMA_CLK_RQT);
 
@@ -205,11 +192,7 @@ static int iwl5000_apm_reset(struct iwl_priv *priv)
 	/* disable L1-Active */
 	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
 			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
-
-	iwl_release_nic_access(priv);
-
 out:
-	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return ret;
 }
@@ -252,11 +235,9 @@ static void iwl5000_nic_config(struct iwl_priv *priv)
 	 * (PCIe power is lost before PERST# is asserted),
 	 * causing ME FW to lose ownership and not being able to obtain it back.
 	 */
-	iwl_grab_nic_access(priv);
 	iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS,
 				~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
-	iwl_release_nic_access(priv);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
@@ -537,19 +518,9 @@ static int iwl5000_load_section(struct iwl_priv *priv,
 				struct fw_desc *image,
 				u32 dst_addr)
 {
-	int ret = 0;
-	unsigned long flags;
-
 	dma_addr_t phy_addr = image->p_addr;
 	u32 byte_cnt = image->len;
 
-	spin_lock_irqsave(&priv->lock, flags);
-	ret = iwl_grab_nic_access(priv);
-	if (ret) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return ret;
-	}
-
 	iwl_write_direct32(priv,
 		FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
 		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE);
@@ -578,8 +549,6 @@ static int iwl5000_load_section(struct iwl_priv *priv,
 		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE	|
 		FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
 
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
 	return 0;
 }
 
@@ -740,18 +709,11 @@ static int iwl5000_alive_notify(struct iwl_priv *priv)
 {
 	u32 a;
 	unsigned long flags;
-	int ret;
 	int i, chan;
 	u32 reg_val;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	ret = iwl_grab_nic_access(priv);
-	if (ret) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return ret;
-	}
-
 	priv->scd_base_addr = iwl_read_prph(priv, IWL50_SCD_SRAM_BASE_ADDR);
 	a = priv->scd_base_addr + IWL50_SCD_CONTEXT_DATA_OFFSET;
 	for (; a < priv->scd_base_addr + IWL50_SCD_TX_STTS_BITMAP_OFFSET;
@@ -819,7 +781,6 @@ static int iwl5000_alive_notify(struct iwl_priv *priv)
 	iwl_txq_ctx_activate(priv, 8);
 	iwl_txq_ctx_activate(priv, 9);
 
-	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 
@@ -1000,7 +961,6 @@ static int iwl5000_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 				  int tx_fifo, int sta_id, int tid, u16 ssn_idx)
 {
 	unsigned long flags;
-	int ret;
 	u16 ra_tid;
 
 	if ((IWL50_FIRST_AMPDU_QUEUE > txq_id) ||
@@ -1018,11 +978,6 @@ static int iwl5000_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	ret = iwl_grab_nic_access(priv);
-	if (ret) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return ret;
-	}
 
 	/* Stop this Tx queue before configuring it */
 	iwl5000_tx_queue_stop_scheduler(priv, txq_id);
@@ -1058,7 +1013,6 @@ static int iwl5000_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
 	iwl5000_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
 
-	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
@@ -1067,8 +1021,6 @@ static int iwl5000_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 static int iwl5000_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 				   u16 ssn_idx, u8 tx_fifo)
 {
-	int ret;
-
 	if ((IWL50_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IWL50_FIRST_AMPDU_QUEUE + IWL50_NUM_AMPDU_QUEUES <= txq_id)) {
 		IWL_ERR(priv,
@@ -1078,10 +1030,6 @@ static int iwl5000_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 		return -EINVAL;
 	}
 
-	ret = iwl_grab_nic_access(priv);
-	if (ret)
-		return ret;
-
 	iwl5000_tx_queue_stop_scheduler(priv, txq_id);
 
 	iwl_clear_bits_prph(priv, IWL50_SCD_AGGR_SEL, (1 << txq_id));
@@ -1095,8 +1043,6 @@ static int iwl5000_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 	iwl_txq_ctx_deactivate(priv, txq_id);
 	iwl5000_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 0);
 
-	iwl_release_nic_access(priv);
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index fd36734..4e41038 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -503,24 +503,12 @@ int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 int iwl_hw_tx_queue_init(struct iwl_priv *priv,
 			 struct iwl_tx_queue *txq)
 {
-	int ret;
-	unsigned long flags;
 	int txq_id = txq->q.id;
 
-	spin_lock_irqsave(&priv->lock, flags);
-	ret = iwl_grab_nic_access(priv);
-	if (ret) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return ret;
-	}
-
 	/* Circular buffer (TFD queue in DRAM) physical base address */
 	iwl_write_direct32(priv, FH_MEM_CBBC_QUEUE(txq_id),
 			     txq->q.dma_addr >> 8);
 
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	return 0;
 }
 
@@ -709,6 +697,7 @@ static void iwl_rx_card_state_notif(struct iwl_priv *priv,
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
 	unsigned long status = priv->status;
+	unsigned long reg_flags;
 
 	IWL_DEBUG_RF_KILL(priv, "Card state received: HW:%s SW:%s\n",
 			  (flags & HW_CARD_DISABLED) ? "Kill" : "On",
@@ -720,32 +709,25 @@ static void iwl_rx_card_state_notif(struct iwl_priv *priv,
 		iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
 			    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
-		if (!iwl_grab_nic_access(priv)) {
-			iwl_write_direct32(
-				priv, HBUS_TARG_MBX_C,
-				HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
-
-			iwl_release_nic_access(priv);
-		}
+		iwl_write_direct32(priv, HBUS_TARG_MBX_C,
+					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
 
 		if (!(flags & RXON_CARD_DISABLED)) {
 			iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
 				    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
-			if (!iwl_grab_nic_access(priv)) {
-				iwl_write_direct32(
-					priv, HBUS_TARG_MBX_C,
+			iwl_write_direct32(priv, HBUS_TARG_MBX_C,
 					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
 
-				iwl_release_nic_access(priv);
-			}
 		}
 
 		if (flags & RF_CARD_DISABLED) {
 			iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
 				    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
 			iwl_read32(priv, CSR_UCODE_DRV_GP1);
+			spin_lock_irqsave(&priv->reg_lock, reg_flags);
 			if (!iwl_grab_nic_access(priv))
 				iwl_release_nic_access(priv);
+			spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
 		}
 	}
 
@@ -774,14 +756,6 @@ static void iwl_rx_card_state_notif(struct iwl_priv *priv,
 
 int iwl_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
 {
-	int ret;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	ret = iwl_grab_nic_access(priv);
-	if (ret)
-		goto err;
-
 	if (src == IWL_PWR_SRC_VAUX) {
 		if (pci_pme_capable(priv->pci_dev, PCI_D3cold))
 			iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
@@ -793,10 +767,7 @@ int iwl_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
 				       ~APMG_PS_CTRL_MSK_PWR_SRC);
 	}
 
-	iwl_release_nic_access(priv);
-err:
-	spin_unlock_irqrestore(&priv->lock, flags);
-	return ret;
+	return 0;
 }
 
 /**
@@ -1587,13 +1558,8 @@ static void __iwl_down(struct iwl_priv *priv)
 	iwl_txq_ctx_stop(priv);
 	iwl_rxq_stop(priv);
 
-	spin_lock_irqsave(&priv->lock, flags);
-	if (!iwl_grab_nic_access(priv)) {
-		iwl_write_prph(priv, APMG_CLK_DIS_REG,
-					 APMG_CLK_VAL_DMA_CLK_RQT);
-		iwl_release_nic_access(priv);
-	}
-	spin_unlock_irqrestore(&priv->lock, flags);
+	iwl_write_prph(priv, APMG_CLK_DIS_REG,
+				APMG_CLK_VAL_DMA_CLK_RQT);
 
 	udelay(5);
 
@@ -2707,6 +2673,10 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		(unsigned long long) pci_resource_len(pdev, 0));
 	IWL_DEBUG_INFO(priv, "pci_resource_base = %p\n", priv->hw_base);
 
+	/* this spin lock will be used in apm_ops.init and EEPROM access
+	 * we should init now
+	 */
+	spin_lock_init(&priv->reg_lock);
 	iwl_hw_detect(priv);
 	IWL_INFO(priv, "Detected Intel Wireless WiFi Link %s REV=0x%X\n",
 		priv->cfg->name, priv->hw_rev);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6c1b171..c7cbb2e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1588,10 +1588,6 @@ static int iwlcore_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32
 
 	IWL_DEBUG_INFO(priv, "ucode inst image size is %u\n", len);
 
-	ret = iwl_grab_nic_access(priv);
-	if (ret)
-		return ret;
-
 	for (i = 0; i < len; i += 100, image += 100/sizeof(u32)) {
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
@@ -1607,8 +1603,6 @@ static int iwlcore_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32
 		}
 	}
 
-	iwl_release_nic_access(priv);
-
 	return ret;
 }
 
@@ -1626,10 +1620,6 @@ static int iwl_verify_inst_full(struct iwl_priv *priv, __le32 *image,
 
 	IWL_DEBUG_INFO(priv, "ucode inst image size is %u\n", len);
 
-	ret = iwl_grab_nic_access(priv);
-	if (ret)
-		return ret;
-
 	iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR,
 			   IWL49_RTC_INST_LOWER_BOUND);
 
@@ -1650,8 +1640,6 @@ static int iwl_verify_inst_full(struct iwl_priv *priv, __le32 *image,
 		}
 	}
 
-	iwl_release_nic_access(priv);
-
 	if (!errcnt)
 		IWL_DEBUG_INFO(priv,
 		    "ucode image in INSTRUCTION memory is good\n");
@@ -1760,7 +1748,6 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	u32 data2, line;
 	u32 desc, time, count, base, data1;
 	u32 blink1, blink2, ilink1, ilink2;
-	int ret;
 
 	if (priv->ucode_type == UCODE_INIT)
 		base = le32_to_cpu(priv->card_alive_init.error_event_table_ptr);
@@ -1772,12 +1759,6 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 		return;
 	}
 
-	ret = iwl_grab_nic_access(priv);
-	if (ret) {
-		IWL_WARN(priv, "Can not read from adapter at this time.\n");
-		return;
-	}
-
 	count = iwl_read_targ_mem(priv, base);
 
 	if (ERROR_START_OFFSET <= count * ERROR_ELEM_SIZE) {
@@ -1804,7 +1785,6 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	IWL_ERR(priv, "0x%05X 0x%05X 0x%05X 0x%05X\n", blink1, blink2,
 		ilink1, ilink2);
 
-	iwl_release_nic_access(priv);
 }
 EXPORT_SYMBOL(iwl_dump_nic_error_log);
 
@@ -1813,7 +1793,6 @@ EXPORT_SYMBOL(iwl_dump_nic_error_log);
 /**
  * iwl_print_event_log - Dump error event log to syslog
  *
- * NOTE: Must be called with iwl_grab_nic_access() already obtained!
  */
 static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 				u32 num_events, u32 mode)
@@ -1859,7 +1838,6 @@ static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 
 void iwl_dump_nic_event_log(struct iwl_priv *priv)
 {
-	int ret;
 	u32 base;       /* SRAM byte address of event log header */
 	u32 capacity;   /* event log capacity in # entries */
 	u32 mode;       /* 0 - no timestamp, 1 - timestamp recorded */
@@ -1877,12 +1855,6 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv)
 		return;
 	}
 
-	ret = iwl_grab_nic_access(priv);
-	if (ret) {
-		IWL_WARN(priv, "Can not read from adapter at this time.\n");
-		return;
-	}
-
 	/* event log header */
 	capacity = iwl_read_targ_mem(priv, base);
 	mode = iwl_read_targ_mem(priv, base + (1 * sizeof(u32)));
@@ -1894,7 +1866,6 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv)
 	/* bail out if nothing in log */
 	if (size == 0) {
 		IWL_ERR(priv, "Start IWL Event Log Dump: nothing in log\n");
-		iwl_release_nic_access(priv);
 		return;
 	}
 
@@ -1909,7 +1880,6 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv)
 	/* (then/else) start at top of log */
 	iwl_print_event_log(priv, 0, next_entry, mode);
 
-	iwl_release_nic_access(priv);
 }
 EXPORT_SYMBOL(iwl_dump_nic_event_log);
 
@@ -2016,11 +1986,11 @@ int iwl_radio_kill_sw_enable_radio(struct iwl_priv *priv)
 	/* wake up ucode */
 	msleep(10);
 
-	spin_lock_irqsave(&priv->lock, flags);
 	iwl_read32(priv, CSR_UCODE_DRV_GP1);
+	spin_lock_irqsave(&priv->reg_lock, flags);
 	if (!iwl_grab_nic_access(priv))
 		iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->reg_lock, flags);
 
 	if (test_bit(STATUS_RF_KILL_HW, &priv->status)) {
 		IWL_DEBUG_RF_KILL(priv, "Can not turn radio back on - "
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 713f9ed..03006c6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -172,7 +172,6 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
 	const size_t bufsz = sizeof(buf);
 
-	iwl_grab_nic_access(priv);
 	for (i = priv->dbgfs->sram_len; i > 0; i -= 4) {
 		val = iwl_read_targ_mem(priv, priv->dbgfs->sram_offset + \
 					priv->dbgfs->sram_len - i);
@@ -192,7 +191,6 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 		pos += scnprintf(buf + pos, bufsz - pos, "0x%08x ", val);
 	}
 	pos += scnprintf(buf + pos, bufsz - pos, "\n");
-	iwl_release_nic_access(priv);
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8282def..1310c41 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -896,6 +896,7 @@ struct iwl_priv {
 	/* spinlock */
 	spinlock_t lock;	/* protect general shared data */
 	spinlock_t hcmd_lock;	/* protect hcmd */
+	spinlock_t reg_lock;	/* protect hw register access */
 	struct mutex mutex;
 
 	/* basic pci-network driver stuff */
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 9cc063b..cefa501 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -240,14 +240,12 @@ static int iwl_init_otp_access(struct iwl_priv *priv)
 	if (ret < 0)
 		IWL_ERR(priv, "Time out access OTP\n");
 	else {
-		ret = iwl_grab_nic_access(priv);
 		if (!ret) {
 			iwl_set_bits_prph(priv, APMG_PS_CTRL_REG,
 					  APMG_PS_CTRL_VAL_RESET_REQ);
 			udelay(5);
 			iwl_clear_bits_prph(priv, APMG_PS_CTRL_REG,
 					    APMG_PS_CTRL_VAL_RESET_REQ);
-			iwl_release_nic_access(priv);
 		}
 	}
 	return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 083ea1f..d30cb02 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -131,9 +131,23 @@ static inline void __iwl_set_bit(const char *f, u32 l,
 	IWL_DEBUG_IO(priv, "set_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
 	_iwl_write32(priv, reg, val);
 }
-#define iwl_set_bit(p, r, m) __iwl_set_bit(__FILE__, __LINE__, p, r, m)
+static inline void iwl_set_bit(struct iwl_priv *p, u32 r, u32 m)
+{
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&p->reg_lock, reg_flags);
+	__iwl_set_bit(__FILE__, __LINE__, p, r, m);
+	spin_unlock_irqrestore(&p->reg_lock, reg_flags);
+}
 #else
-#define iwl_set_bit(p, r, m) _iwl_set_bit(p, r, m)
+static inline void iwl_set_bit(struct iwl_priv *p, u32 r, u32 m)
+{
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&p->reg_lock, reg_flags);
+	_iwl_set_bit(p, r, m);
+	spin_unlock_irqrestore(&p->reg_lock, reg_flags);
+}
 #endif
 
 static inline void _iwl_clear_bit(struct iwl_priv *priv, u32 reg, u32 mask)
@@ -148,19 +162,30 @@ static inline void __iwl_clear_bit(const char *f, u32 l,
 	IWL_DEBUG_IO(priv, "clear_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
 	_iwl_write32(priv, reg, val);
 }
-#define iwl_clear_bit(p, r, m) __iwl_clear_bit(__FILE__, __LINE__, p, r, m)
+static inline void iwl_clear_bit(struct iwl_priv *p, u32 r, u32 m)
+{
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&p->reg_lock, reg_flags);
+	__iwl_clear_bit(__FILE__, __LINE__, p, r, m);
+	spin_unlock_irqrestore(&p->reg_lock, reg_flags);
+}
 #else
-#define iwl_clear_bit(p, r, m) _iwl_clear_bit(p, r, m)
+static inline void iwl_clear_bit(struct iwl_priv *p, u32 r, u32 m)
+{
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&p->reg_lock, reg_flags);
+	_iwl_clear_bit(p, r, m);
+	spin_unlock_irqrestore(&p->reg_lock, reg_flags);
+}
 #endif
 
 static inline int _iwl_grab_nic_access(struct iwl_priv *priv)
 {
 	int ret;
 	u32 val;
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (atomic_read(&priv->restrict_refcnt))
-		return 0;
-#endif
+
 	/* this bit wakes up the NIC */
 	_iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 	ret = _iwl_poll_bit(priv, CSR_GP_CNTRL,
@@ -170,12 +195,10 @@ static inline int _iwl_grab_nic_access(struct iwl_priv *priv)
 	if (ret < 0) {
 		val = _iwl_read32(priv, CSR_GP_CNTRL);
 		IWL_ERR(priv, "MAC is in deep sleep!.  CSR_GP_CNTRL = 0x%08X\n", val);
+		_iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_FORCE_NMI);
 		return -EIO;
 	}
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-	atomic_inc(&priv->restrict_refcnt);
-#endif
 	return 0;
 }
 
@@ -183,9 +206,6 @@ static inline int _iwl_grab_nic_access(struct iwl_priv *priv)
 static inline int __iwl_grab_nic_access(const char *f, u32 l,
 					       struct iwl_priv *priv)
 {
-	if (atomic_read(&priv->restrict_refcnt))
-		IWL_ERR(priv, "Grabbing access while already held %s %d.\n", f, l);
-
 	IWL_DEBUG_IO(priv, "grabbing nic access - %s %d\n", f, l);
 	return _iwl_grab_nic_access(priv);
 }
@@ -198,18 +218,13 @@ static inline int __iwl_grab_nic_access(const char *f, u32 l,
 
 static inline void _iwl_release_nic_access(struct iwl_priv *priv)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (atomic_dec_and_test(&priv->restrict_refcnt))
-#endif
-		_iwl_clear_bit(priv, CSR_GP_CNTRL,
-			       CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	_iwl_clear_bit(priv, CSR_GP_CNTRL,
+			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 }
 #ifdef CONFIG_IWLWIFI_DEBUG
 static inline void __iwl_release_nic_access(const char *f, u32 l,
 					    struct iwl_priv *priv)
 {
-	if (atomic_read(&priv->restrict_refcnt) <= 0)
-		IWL_ERR(priv, "Release unheld nic access at line %s %d.\n", f, l);
 
 	IWL_DEBUG_IO(priv, "releasing nic access - %s %d\n", f, l);
 	_iwl_release_nic_access(priv);
@@ -230,16 +245,37 @@ static inline u32 __iwl_read_direct32(const char *f, u32 l,
 					struct iwl_priv *priv, u32 reg)
 {
 	u32 value = _iwl_read_direct32(priv, reg);
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERR(priv, "Nic access not held from %s %d\n", f, l);
 	IWL_DEBUG_IO(priv, "read_direct32(0x%4X) = 0x%08x - %s %d \n", reg, value,
 		     f, l);
 	return value;
 }
-#define iwl_read_direct32(priv, reg) \
-	__iwl_read_direct32(__FILE__, __LINE__, priv, reg)
+static inline u32 iwl_read_direct32(struct iwl_priv *priv, u32 reg)
+{
+	u32 value;
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&priv->reg_lock, reg_flags);
+	iwl_grab_nic_access(priv);
+	value = __iwl_read_direct32(__FILE__, __LINE__, priv, reg);
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
+	return value;
+}
+
 #else
-#define iwl_read_direct32 _iwl_read_direct32
+static inline u32 iwl_read_direct32(struct iwl_priv *priv, u32 reg)
+{
+	u32 value;
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&priv->reg_lock, reg_flags);
+	iwl_grab_nic_access(priv);
+	value = _iwl_read_direct32(priv, reg);
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
+	return value;
+
+}
 #endif
 
 static inline void _iwl_write_direct32(struct iwl_priv *priv,
@@ -247,19 +283,17 @@ static inline void _iwl_write_direct32(struct iwl_priv *priv,
 {
 	_iwl_write32(priv, reg, value);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
-static void __iwl_write_direct32(const char *f , u32 line,
-				   struct iwl_priv *priv, u32 reg, u32 value)
+static inline void iwl_write_direct32(struct iwl_priv *priv, u32 reg, u32 value)
 {
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERR(priv, "Nic access not held from %s line %d\n", f, line);
-	_iwl_write_direct32(priv, reg, value);
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&priv->reg_lock, reg_flags);
+	if (!iwl_grab_nic_access(priv)) {
+		_iwl_write_direct32(priv, reg, value);
+		iwl_release_nic_access(priv);
+	}
+	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
 }
-#define iwl_write_direct32(priv, reg, value) \
-	__iwl_write_direct32(__func__, __LINE__, priv, reg, value)
-#else
-#define iwl_write_direct32 _iwl_write_direct32
-#endif
 
 static inline void iwl_write_reg_buf(struct iwl_priv *priv,
 					       u32 reg, u32 len, u32 *values)
@@ -268,14 +302,23 @@ static inline void iwl_write_reg_buf(struct iwl_priv *priv,
 
 	if ((priv != NULL) && (values != NULL)) {
 		for (; 0 < len; len -= count, reg += count, values++)
-			_iwl_write_direct32(priv, reg, *values);
+			iwl_write_direct32(priv, reg, *values);
 	}
 }
 
 static inline int _iwl_poll_direct_bit(struct iwl_priv *priv, u32 addr,
 				       u32 mask, int timeout)
 {
-	return _iwl_poll_bit(priv, addr, mask, mask, timeout);
+	int t = 0;
+
+	do {
+		if ((iwl_read_direct32(priv, addr) & mask) == mask)
+			return t;
+		udelay(IWL_POLL_INTERVAL);
+		t += IWL_POLL_INTERVAL;
+	} while (t < timeout);
+
+	return -ETIMEDOUT;
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -305,20 +348,18 @@ static inline u32 _iwl_read_prph(struct iwl_priv *priv, u32 reg)
 	rmb();
 	return _iwl_read_direct32(priv, HBUS_TARG_PRPH_RDAT);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline u32 __iwl_read_prph(const char *f, u32 line,
-				  struct iwl_priv *priv, u32 reg)
+static inline u32 iwl_read_prph(struct iwl_priv *priv, u32 reg)
 {
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERR(priv, "Nic access not held from %s line %d\n", f, line);
-	return _iwl_read_prph(priv, reg);
-}
+	unsigned long reg_flags;
+	u32 val;
 
-#define iwl_read_prph(priv, reg) \
-	__iwl_read_prph(__func__, __LINE__, priv, reg)
-#else
-#define iwl_read_prph _iwl_read_prph
-#endif
+	spin_lock_irqsave(&priv->reg_lock, reg_flags);
+	iwl_grab_nic_access(priv);
+	val = _iwl_read_prph(priv, reg);
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
+	return val;
+}
 
 static inline void _iwl_write_prph(struct iwl_priv *priv,
 					     u32 addr, u32 val)
@@ -328,83 +369,107 @@ static inline void _iwl_write_prph(struct iwl_priv *priv,
 	wmb();
 	_iwl_write_direct32(priv, HBUS_TARG_PRPH_WDAT, val);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_write_prph(const char *f, u32 line,
-				    struct iwl_priv *priv, u32 addr, u32 val)
+
+static inline void iwl_write_prph(struct iwl_priv *priv, u32 addr, u32 val)
 {
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERR(priv, "Nic access not held from %s line %d\n", f, line);
-	_iwl_write_prph(priv, addr, val);
-}
+	unsigned long reg_flags;
 
-#define iwl_write_prph(priv, addr, val) \
-	__iwl_write_prph(__func__, __LINE__, priv, addr, val);
-#else
-#define iwl_write_prph _iwl_write_prph
-#endif
+	spin_lock_irqsave(&priv->reg_lock, reg_flags);
+	if (!iwl_grab_nic_access(priv)) {
+		_iwl_write_prph(priv, addr, val);
+		iwl_release_nic_access(priv);
+	}
+	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
+}
 
 #define _iwl_set_bits_prph(priv, reg, mask) \
 	_iwl_write_prph(priv, reg, (_iwl_read_prph(priv, reg) | mask))
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_set_bits_prph(const char *f, u32 line,
-				       struct iwl_priv *priv,
-				       u32 reg, u32 mask)
+
+static inline void iwl_set_bits_prph(struct iwl_priv *priv, u32 reg, u32 mask)
 {
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERR(priv, "Nic access not held from %s line %d\n", f, line);
+	unsigned long reg_flags;
 
+	spin_lock_irqsave(&priv->reg_lock, reg_flags);
+	iwl_grab_nic_access(priv);
 	_iwl_set_bits_prph(priv, reg, mask);
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
 }
-#define iwl_set_bits_prph(priv, reg, mask) \
-	__iwl_set_bits_prph(__func__, __LINE__, priv, reg, mask)
-#else
-#define iwl_set_bits_prph _iwl_set_bits_prph
-#endif
 
 #define _iwl_set_bits_mask_prph(priv, reg, bits, mask) \
 	_iwl_write_prph(priv, reg, ((_iwl_read_prph(priv, reg) & mask) | bits))
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_set_bits_mask_prph(const char *f, u32 line,
-		struct iwl_priv *priv, u32 reg, u32 bits, u32 mask)
+static inline void iwl_set_bits_mask_prph(struct iwl_priv *priv, u32 reg,
+				u32 bits, u32 mask)
 {
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERR(priv, "Nic access not held from %s line %d\n", f, line);
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&priv->reg_lock, reg_flags);
+	iwl_grab_nic_access(priv);
 	_iwl_set_bits_mask_prph(priv, reg, bits, mask);
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
 }
-#define iwl_set_bits_mask_prph(priv, reg, bits, mask) \
-	__iwl_set_bits_mask_prph(__func__, __LINE__, priv, reg, bits, mask)
-#else
-#define iwl_set_bits_mask_prph _iwl_set_bits_mask_prph
-#endif
 
 static inline void iwl_clear_bits_prph(struct iwl_priv
 						 *priv, u32 reg, u32 mask)
 {
-	u32 val = _iwl_read_prph(priv, reg);
+	unsigned long reg_flags;
+	u32 val;
+
+	spin_lock_irqsave(&priv->reg_lock, reg_flags);
+	iwl_grab_nic_access(priv);
+	val = _iwl_read_prph(priv, reg);
 	_iwl_write_prph(priv, reg, (val & ~mask));
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
 }
 
 static inline u32 iwl_read_targ_mem(struct iwl_priv *priv, u32 addr)
 {
-	iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR, addr);
+	unsigned long reg_flags;
+	u32 value;
+
+	spin_lock_irqsave(&priv->reg_lock, reg_flags);
+	iwl_grab_nic_access(priv);
+
+	_iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR, addr);
 	rmb();
-	return iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+	value = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
+	return value;
 }
 
 static inline void iwl_write_targ_mem(struct iwl_priv *priv, u32 addr, u32 val)
 {
-	iwl_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
-	wmb();
-	iwl_write_direct32(priv, HBUS_TARG_MEM_WDAT, val);
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&priv->reg_lock, reg_flags);
+	if (!iwl_grab_nic_access(priv)) {
+		_iwl_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
+		wmb();
+		_iwl_write_direct32(priv, HBUS_TARG_MEM_WDAT, val);
+		iwl_release_nic_access(priv);
+	}
+	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
 }
 
 static inline void iwl_write_targ_mem_buf(struct iwl_priv *priv, u32 addr,
 					  u32 len, u32 *values)
 {
-	iwl_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
-	wmb();
-	for (; 0 < len; len -= sizeof(u32), values++)
-		iwl_write_direct32(priv, HBUS_TARG_MEM_WDAT, *values);
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&priv->reg_lock, reg_flags);
+	if (!iwl_grab_nic_access(priv)) {
+		_iwl_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
+		wmb();
+		for (; 0 < len; len -= sizeof(u32), values++)
+			_iwl_write_direct32(priv, HBUS_TARG_MEM_WDAT, *values);
+
+		iwl_release_nic_access(priv);
+	}
+	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
 }
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 73739cf..7a43282 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -145,13 +145,7 @@ int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q)
 			goto exit_unlock;
 		}
 
-		ret = iwl_grab_nic_access(priv);
-		if (ret)
-			goto exit_unlock;
-
-		/* Device expects a multiple of 8 */
 		iwl_write_direct32(priv, rx_wrt_ptr_reg, q->write & ~0x7);
-		iwl_release_nic_access(priv);
 
 	/* Else device is assumed to be awake */
 	} else {
@@ -403,19 +397,10 @@ EXPORT_SYMBOL(iwl_rx_queue_reset);
 
 int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 {
-	int ret;
-	unsigned long flags;
 	u32 rb_size;
 	const u32 rfdnlog = RX_QUEUE_SIZE_LOG; /* 256 RBDs */
 	const u32 rb_timeout = 0; /* FIXME: RX_RB_TIMEOUT why this stalls RX */
 
-	spin_lock_irqsave(&priv->lock, flags);
-	ret = iwl_grab_nic_access(priv);
-	if (ret) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return ret;
-	}
-
 	if (priv->cfg->mod_params->amsdu_size_8K)
 		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K;
 	else
@@ -452,35 +437,19 @@ int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 			   (rb_timeout << FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS)|
 			   (rfdnlog << FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
 
-	iwl_release_nic_access(priv);
-
 	iwl_write32(priv, CSR_INT_COALESCING, 0x40);
 
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	return 0;
 }
 
 int iwl_rxq_stop(struct iwl_priv *priv)
 {
-	int ret;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	ret = iwl_grab_nic_access(priv);
-	if (unlikely(ret)) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return ret;
-	}
 
 	/* stop Rx DMA */
 	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
 	iwl_poll_direct_bit(priv, FH_MEM_RSSR_RX_STATUS_REG,
 			    FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
 
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	return 0;
 }
 EXPORT_SYMBOL(iwl_rxq_stop);
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index a82cca0..85ae7a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -102,13 +102,8 @@ int iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 			return ret;
 		}
 
-		/* restore this queue's parameters in nic hardware. */
-		ret = iwl_grab_nic_access(priv);
-		if (ret)
-			return ret;
 		iwl_write_direct32(priv, HBUS_TARG_WRPTR,
 				     txq->q.write_ptr | (txq_id << 8));
-		iwl_release_nic_access(priv);
 
 	/* else not in power-save mode, uCode will never sleep when we're
 	 * trying to tx (during RFKILL, we're not trying to tx). */
@@ -429,11 +424,6 @@ int iwl_txq_ctx_reset(struct iwl_priv *priv)
 		goto error_kw;
 	}
 	spin_lock_irqsave(&priv->lock, flags);
-	ret = iwl_grab_nic_access(priv);
-	if (unlikely(ret)) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		goto error_reset;
-	}
 
 	/* Turn off all Tx DMA fifos */
 	priv->cfg->ops->lib->txq_set_sched(priv, 0);
@@ -441,7 +431,6 @@ int iwl_txq_ctx_reset(struct iwl_priv *priv)
 	/* Tell NIC where to find the "keep warm" buffer */
 	iwl_write_direct32(priv, FH_KW_MEM_ADDR_REG, priv->kw.dma >> 4);
 
-	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* Alloc and init all Tx queues, including the command queue (#4) */
@@ -460,7 +449,6 @@ int iwl_txq_ctx_reset(struct iwl_priv *priv)
 
  error:
 	iwl_hw_txq_ctx_free(priv);
- error_reset:
 	iwl_free_dma_ptr(priv, &priv->kw);
  error_kw:
 	iwl_free_dma_ptr(priv, &priv->scd_bc_tbls);
@@ -478,10 +466,6 @@ void iwl_txq_ctx_stop(struct iwl_priv *priv)
 
 	/* Turn off all Tx DMA fifos */
 	spin_lock_irqsave(&priv->lock, flags);
-	if (iwl_grab_nic_access(priv)) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return;
-	}
 
 	priv->cfg->ops->lib->txq_set_sched(priv, 0);
 
@@ -492,7 +476,6 @@ void iwl_txq_ctx_stop(struct iwl_priv *priv)
 				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
 				    1000);
 	}
-	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* Deallocate memory for all Tx queues */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index ded7fea..2e25cb2 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1686,7 +1686,6 @@ static void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
 	u32 i;
 	u32 desc, time, count, base, data1;
 	u32 blink1, blink2, ilink1, ilink2;
-	int rc;
 
 	base = le32_to_cpu(priv->card_alive.error_event_table_ptr);
 
@@ -1695,11 +1694,6 @@ static void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
 		return;
 	}
 
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
-		IWL_WARN(priv, "Can not read from adapter at this time.\n");
-		return;
-	}
 
 	count = iwl_read_targ_mem(priv, base);
 
@@ -1734,8 +1728,6 @@ static void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
 			ilink1, ilink2, data1);
 	}
 
-	iwl_release_nic_access(priv);
-
 }
 
 #define EVENT_START_OFFSET  (6 * sizeof(u32))
@@ -1743,7 +1735,6 @@ static void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
 /**
  * iwl3945_print_event_log - Dump error event log to syslog
  *
- * NOTE: Must be called with iwl_grab_nic_access() already obtained!
  */
 static void iwl3945_print_event_log(struct iwl_priv *priv, u32 start_idx,
 				u32 num_events, u32 mode)
@@ -1786,7 +1777,6 @@ static void iwl3945_print_event_log(struct iwl_priv *priv, u32 start_idx,
 
 static void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
 {
-	int rc;
 	u32 base;       /* SRAM byte address of event log header */
 	u32 capacity;   /* event log capacity in # entries */
 	u32 mode;       /* 0 - no timestamp, 1 - timestamp recorded */
@@ -1800,12 +1790,6 @@ static void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
 		return;
 	}
 
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
-		IWL_WARN(priv, "Can not read from adapter at this time.\n");
-		return;
-	}
-
 	/* event log header */
 	capacity = iwl_read_targ_mem(priv, base);
 	mode = iwl_read_targ_mem(priv, base + (1 * sizeof(u32)));
@@ -1817,7 +1801,6 @@ static void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
 	/* bail out if nothing in log */
 	if (size == 0) {
 		IWL_ERR(priv, "Start IWL Event Log Dump: nothing in log\n");
-		iwl_release_nic_access(priv);
 		return;
 	}
 
@@ -1833,7 +1816,6 @@ static void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
 	/* (then/else) start at top of log */
 	iwl3945_print_event_log(priv, 0, next_entry, mode);
 
-	iwl_release_nic_access(priv);
 }
 
 static void iwl3945_irq_tasklet(struct iwl_priv *priv)
@@ -1952,11 +1934,8 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 		priv->isr_stats.tx++;
 
 		iwl_write32(priv, CSR_FH_INT_STATUS, (1 << 6));
-		if (!iwl_grab_nic_access(priv)) {
-			iwl_write_direct32(priv, FH39_TCSR_CREDIT
-					     (FH39_SRVC_CHNL), 0x0);
-			iwl_release_nic_access(priv);
-		}
+		iwl_write_direct32(priv, FH39_TCSR_CREDIT
+					(FH39_SRVC_CHNL), 0x0);
 		handled |= CSR_INT_BIT_FH_TX;
 	}
 
@@ -2131,10 +2110,6 @@ static int iwl3945_verify_inst_full(struct iwl_priv *priv, __le32 *image, u32 le
 
 	IWL_DEBUG_INFO(priv, "ucode inst image size is %u\n", len);
 
-	rc = iwl_grab_nic_access(priv);
-	if (rc)
-		return rc;
-
 	iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR,
 			       IWL39_RTC_INST_LOWER_BOUND);
 
@@ -2155,7 +2130,6 @@ static int iwl3945_verify_inst_full(struct iwl_priv *priv, __le32 *image, u32 le
 		}
 	}
 
-	iwl_release_nic_access(priv);
 
 	if (!errcnt)
 		IWL_DEBUG_INFO(priv,
@@ -2179,10 +2153,6 @@ static int iwl3945_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32
 
 	IWL_DEBUG_INFO(priv, "ucode inst image size is %u\n", len);
 
-	rc = iwl_grab_nic_access(priv);
-	if (rc)
-		return rc;
-
 	for (i = 0; i < len; i += 100, image += 100/sizeof(u32)) {
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
@@ -2203,8 +2173,6 @@ static int iwl3945_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32
 		}
 	}
 
-	iwl_release_nic_access(priv);
-
 	return rc;
 }
 
@@ -2528,20 +2496,11 @@ static int iwl3945_set_ucode_ptrs(struct iwl_priv *priv)
 {
 	dma_addr_t pinst;
 	dma_addr_t pdata;
-	int rc = 0;
-	unsigned long flags;
 
 	/* bits 31:0 for 3945 */
 	pinst = priv->ucode_code.p_addr;
 	pdata = priv->ucode_data_backup.p_addr;
 
-	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return rc;
-	}
-
 	/* Tell bootstrap uCode where to find image to load */
 	iwl_write_prph(priv, BSM_DRAM_INST_PTR_REG, pinst);
 	iwl_write_prph(priv, BSM_DRAM_DATA_PTR_REG, pdata);
@@ -2553,13 +2512,9 @@ static int iwl3945_set_ucode_ptrs(struct iwl_priv *priv)
 	iwl_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG,
 				 priv->ucode_code.len | BSM_DRAM_INST_LOAD);
 
-	iwl_release_nic_access(priv);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	IWL_DEBUG_INFO(priv, "Runtime uCode pointers are set.\n");
 
-	return rc;
+	return 0;
 }
 
 /**
@@ -2612,7 +2567,6 @@ static void iwl3945_init_alive_start(struct iwl_priv *priv)
  */
 static void iwl3945_alive_start(struct iwl_priv *priv)
 {
-	int rc = 0;
 	int thermal_spin = 0;
 	u32 rfkill;
 
@@ -2637,15 +2591,8 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 
 	priv->cfg->ops->smgmt->clear_station_table(priv);
 
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
-		IWL_WARN(priv, "Can not read RFKILL status from adapter\n");
-		return;
-	}
-
 	rfkill = iwl_read_prph(priv, APMG_RFKILL_REG);
 	IWL_DEBUG_INFO(priv, "RFKILL status: 0x%x\n", rfkill);
-	iwl_release_nic_access(priv);
 
 	if (rfkill & 0x1) {
 		clear_bit(STATUS_RF_KILL_HW, &priv->status);
@@ -2791,13 +2738,8 @@ static void __iwl3945_down(struct iwl_priv *priv)
 	iwl3945_hw_txq_ctx_stop(priv);
 	iwl3945_hw_rxq_stop(priv);
 
-	spin_lock_irqsave(&priv->lock, flags);
-	if (!iwl_grab_nic_access(priv)) {
-		iwl_write_prph(priv, APMG_CLK_DIS_REG,
-					 APMG_CLK_VAL_DMA_CLK_RQT);
-		iwl_release_nic_access(priv);
-	}
-	spin_unlock_irqrestore(&priv->lock, flags);
+	iwl_write_prph(priv, APMG_CLK_DIS_REG,
+				APMG_CLK_VAL_DMA_CLK_RQT);
 
 	udelay(5);
 
@@ -4290,6 +4232,11 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 * PCI Tx retries from interfering with C3 CPU state */
 	pci_write_config_byte(pdev, 0x41, 0x00);
 
+	/* this spin lock will be used in apm_ops.init and EEPROM access
+	 * we should init now
+	 */
+	spin_lock_init(&priv->reg_lock);
+
 	/* amp init */
 	err = priv->cfg->ops->lib->apm_ops.init(priv);
 	if (err < 0) {
-- 
1.5.6.3

