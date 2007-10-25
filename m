Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbXJYJWr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:22:47 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 14/30] iwlwifi: replace restricted_reg with prph
Date: Thu, 25 Oct 2007 17:15:35 +0800
Message-Id: <11933037721573-git-send-email-yi.zhu@intel.com> (sfid-20071025_104103_565914_DB905803)
In-Reply-To: <1193303770550-git-send-email-yi.zhu@intel.com>
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch renames restricted_reg suffix with more proper
name prhp for function accessing registers on the periphery bus.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   36 +++++-----
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   64 +++++++++---------
 drivers/net/wireless/iwlwifi/iwl-io.h       |   98 +++++++++------------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   40 ++++++------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   38 +++++-----
 5 files changed, 119 insertions(+), 157 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index d4dc30d..d761531 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -722,7 +722,7 @@ static int iwl3945_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
 		rc = pci_read_config_dword(priv->pci_dev,
 				PCI_POWER_SOURCE, &val);
 		if (val & PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT) {
-			iwl_set_bits_mask_restricted_reg(priv, APMG_PS_CTRL_REG,
+			iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
 					APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
 					~APMG_PS_CTRL_MSK_PWR_SRC);
 			iwl_release_restricted_access(priv);
@@ -733,7 +733,7 @@ static int iwl3945_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
 		} else
 			iwl_release_restricted_access(priv);
 	} else {
-		iwl_set_bits_mask_restricted_reg(priv, APMG_PS_CTRL_REG,
+		iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
 				~APMG_PS_CTRL_MSK_PWR_SRC);
 
@@ -795,18 +795,18 @@ static int iwl3945_tx_reset(struct iwl_priv *priv)
 	}
 
 	/* bypass mode */
-	iwl_write_restricted_reg(priv, SCD_MODE_REG, 0x2);
+	iwl_write_prph(priv, SCD_MODE_REG, 0x2);
 
 	/* RA 0 is active */
-	iwl_write_restricted_reg(priv, SCD_ARASTAT_REG, 0x01);
+	iwl_write_prph(priv, SCD_ARASTAT_REG, 0x01);
 
 	/* all 6 fifo are active */
-	iwl_write_restricted_reg(priv, SCD_TXFACT_REG, 0x3f);
+	iwl_write_prph(priv, SCD_TXFACT_REG, 0x3f);
 
-	iwl_write_restricted_reg(priv, SCD_SBYP_MODE_1_REG, 0x010000);
-	iwl_write_restricted_reg(priv, SCD_SBYP_MODE_2_REG, 0x030002);
-	iwl_write_restricted_reg(priv, SCD_TXF4MF_REG, 0x000004);
-	iwl_write_restricted_reg(priv, SCD_TXF5MF_REG, 0x000005);
+	iwl_write_prph(priv, SCD_SBYP_MODE_1_REG, 0x010000);
+	iwl_write_prph(priv, SCD_SBYP_MODE_2_REG, 0x030002);
+	iwl_write_prph(priv, SCD_TXF4MF_REG, 0x000004);
+	iwl_write_prph(priv, SCD_TXF5MF_REG, 0x000005);
 
 	iwl_write_restricted(priv, FH_TSSR_CBB_BASE,
 			     priv->hw_setting.shared_phys);
@@ -891,11 +891,11 @@ int iwl_hw_nic_init(struct iwl_priv *priv)
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
-	iwl_write_restricted_reg(priv, APMG_CLK_EN_REG,
+	iwl_write_prph(priv, APMG_CLK_EN_REG,
 				 APMG_CLK_VAL_DMA_CLK_RQT |
 				 APMG_CLK_VAL_BSM_CLK_RQT);
 	udelay(20);
-	iwl_set_bits_restricted_reg(priv, APMG_PCIDEV_STT_REG,
+	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
 				    APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 	iwl_release_restricted_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -1034,7 +1034,7 @@ void iwl_hw_txq_ctx_stop(struct iwl_priv *priv)
 	}
 
 	/* stop SCD */
-	iwl_write_restricted_reg(priv, SCD_MODE_REG, 0);
+	iwl_write_prph(priv, SCD_MODE_REG, 0);
 
 	/* reset TFD queues */
 	for (queue = TFD_QUEUE_MIN; queue < TFD_QUEUE_MAX; queue++) {
@@ -1100,7 +1100,7 @@ int iwl_hw_nic_reset(struct iwl_priv *priv)
 
 	rc = iwl_grab_restricted_access(priv);
 	if (!rc) {
-		iwl_write_restricted_reg(priv, APMG_CLK_CTRL_REG,
+		iwl_write_prph(priv, APMG_CLK_CTRL_REG,
 					 APMG_CLK_VAL_BSM_CLK_RQT);
 
 		udelay(10);
@@ -1108,20 +1108,20 @@ int iwl_hw_nic_reset(struct iwl_priv *priv)
 		iwl_set_bit(priv, CSR_GP_CNTRL,
 			    CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
-		iwl_write_restricted_reg(priv, APMG_RTC_INT_MSK_REG, 0x0);
-		iwl_write_restricted_reg(priv, APMG_RTC_INT_STT_REG,
+		iwl_write_prph(priv, APMG_RTC_INT_MSK_REG, 0x0);
+		iwl_write_prph(priv, APMG_RTC_INT_STT_REG,
 					0xFFFFFFFF);
 
 		/* enable DMA */
-		iwl_write_restricted_reg(priv, APMG_CLK_EN_REG,
+		iwl_write_prph(priv, APMG_CLK_EN_REG,
 					 APMG_CLK_VAL_DMA_CLK_RQT |
 					 APMG_CLK_VAL_BSM_CLK_RQT);
 		udelay(10);
 
-		iwl_set_bits_restricted_reg(priv, APMG_PS_CTRL_REG,
+		iwl_set_bits_prph(priv, APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_VAL_RESET_REQ);
 		udelay(5);
-		iwl_clear_bits_restricted_reg(priv, APMG_PS_CTRL_REG,
+		iwl_clear_bits_prph(priv, APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_VAL_RESET_REQ);
 		iwl_release_restricted_access(priv);
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 39c7d1f..2d6fe6f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -191,37 +191,35 @@ u8 iwl_hw_find_station(struct iwl_priv *priv, const u8 *addr)
 
 static int iwl4965_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
 {
-	int rc = 0;
+	int ret;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_restricted_access(priv);
-	if (rc) {
+	ret = iwl_grab_restricted_access(priv);
+	if (ret) {
 		spin_unlock_irqrestore(&priv->lock, flags);
-		return rc;
+		return ret;
 	}
 
 	if (!pwr_max) {
 		u32 val;
 
-		rc = pci_read_config_dword(priv->pci_dev, PCI_POWER_SOURCE,
+		ret = pci_read_config_dword(priv->pci_dev, PCI_POWER_SOURCE,
 					   &val);
 
 		if (val & PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT)
-			iwl_set_bits_mask_restricted_reg(
-				priv, APMG_PS_CTRL_REG,
+			iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
 				~APMG_PS_CTRL_MSK_PWR_SRC);
 	} else
-		iwl_set_bits_mask_restricted_reg(
-			priv, APMG_PS_CTRL_REG,
+		iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
 			APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
 			~APMG_PS_CTRL_MSK_PWR_SRC);
 
 	iwl_release_restricted_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	return rc;
+	return ret;
 }
 
 static int iwl4965_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
@@ -383,7 +381,7 @@ static int iwl4965_txq_ctx_reset(struct iwl_priv *priv)
 		goto error_reset;
 	}
 
-	iwl_write_restricted_reg(priv, SCD_TXFACT, 0);
+	iwl_write_prph(priv, SCD_TXFACT, 0);
 	iwl_release_restricted_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -448,16 +446,16 @@ int iwl_hw_nic_init(struct iwl_priv *priv)
 		return rc;
 	}
 
-	iwl_read_restricted_reg(priv, APMG_CLK_CTRL_REG);
+	iwl_read_prph(priv, APMG_CLK_CTRL_REG);
 
-	iwl_write_restricted_reg(priv, APMG_CLK_CTRL_REG,
+	iwl_write_prph(priv, APMG_CLK_CTRL_REG,
 				 APMG_CLK_VAL_DMA_CLK_RQT |
 				 APMG_CLK_VAL_BSM_CLK_RQT);
-	iwl_read_restricted_reg(priv, APMG_CLK_CTRL_REG);
+	iwl_read_prph(priv, APMG_CLK_CTRL_REG);
 
 	udelay(20);
 
-	iwl_set_bits_restricted_reg(priv, APMG_PCIDEV_STT_REG,
+	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
 				    APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
 	iwl_release_restricted_access(priv);
@@ -513,11 +511,11 @@ int iwl_hw_nic_init(struct iwl_priv *priv)
 		return rc;
 	}
 
-	iwl_read_restricted_reg(priv, APMG_PS_CTRL_REG);
-	iwl_set_bits_restricted_reg(priv, APMG_PS_CTRL_REG,
+	iwl_read_prph(priv, APMG_PS_CTRL_REG);
+	iwl_set_bits_prph(priv, APMG_PS_CTRL_REG,
 				    APMG_PS_CTRL_VAL_RESET_REQ);
 	udelay(5);
-	iwl_clear_bits_restricted_reg(priv, APMG_PS_CTRL_REG,
+	iwl_clear_bits_prph(priv, APMG_PS_CTRL_REG,
 				      APMG_PS_CTRL_VAL_RESET_REQ);
 
 	iwl_release_restricted_access(priv);
@@ -644,13 +642,13 @@ int iwl_hw_nic_reset(struct iwl_priv *priv)
 
 	rc = iwl_grab_restricted_access(priv);
 	if (!rc) {
-		iwl_write_restricted_reg(priv, APMG_CLK_EN_REG,
+		iwl_write_prph(priv, APMG_CLK_EN_REG,
 					 APMG_CLK_VAL_DMA_CLK_RQT |
 					 APMG_CLK_VAL_BSM_CLK_RQT);
 
 		udelay(10);
 
-		iwl_set_bits_restricted_reg(priv, APMG_PCIDEV_STT_REG,
+		iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
 				APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
 		iwl_release_restricted_access(priv);
@@ -1584,7 +1582,7 @@ static void iwl4965_set_wr_ptrs(struct iwl_priv *priv, int txq_id, u32 index)
 {
 	iwl_write_restricted(priv, HBUS_TARG_WRPTR,
 			     (index & 0xff) | (txq_id << 8));
-	iwl_write_restricted_reg(priv, SCD_QUEUE_RDPTR(txq_id), index);
+	iwl_write_prph(priv, SCD_QUEUE_RDPTR(txq_id), index);
 }
 
 /*
@@ -1597,7 +1595,7 @@ static void iwl4965_tx_queue_set_status(struct iwl_priv *priv,
 	int txq_id = txq->q.id;
 	int active = test_bit(txq_id, &priv->txq_ctx_active_msk)?1:0;
 
-	iwl_write_restricted_reg(priv, SCD_QUEUE_STATUS_BITS(txq_id),
+	iwl_write_prph(priv, SCD_QUEUE_STATUS_BITS(txq_id),
 				 (active << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
 				 (tx_fifo_id << SCD_QUEUE_STTS_REG_POS_TXF) |
 				 (scd_retry << SCD_QUEUE_STTS_REG_POS_WSL) |
@@ -1655,7 +1653,7 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 		return rc;
 	}
 
-	priv->scd_base_addr = iwl_read_restricted_reg(priv, SCD_SRAM_BASE_ADDR);
+	priv->scd_base_addr = iwl_read_prph(priv, SCD_SRAM_BASE_ADDR);
 	a = priv->scd_base_addr + SCD_CONTEXT_DATA_OFFSET;
 	for (; a < priv->scd_base_addr + SCD_TX_STTS_BITMAP_OFFSET; a += 4)
 		iwl_write_restricted_mem(priv, a, 0);
@@ -1664,14 +1662,14 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 	for (; a < sizeof(u16) * priv->hw_setting.max_txq_num; a += 4)
 		iwl_write_restricted_mem(priv, a, 0);
 
-	iwl_write_restricted_reg(priv, SCD_DRAM_BASE_ADDR,
+	iwl_write_prph(priv, SCD_DRAM_BASE_ADDR,
 		(priv->hw_setting.shared_phys +
 		 offsetof(struct iwl_shared, queues_byte_cnt_tbls)) >> 10);
-	iwl_write_restricted_reg(priv, SCD_QUEUECHAIN_SEL, 0);
+	iwl_write_prph(priv, SCD_QUEUECHAIN_SEL, 0);
 
 	/* initiate the queues */
 	for (i = 0; i < priv->hw_setting.max_txq_num; i++) {
-		iwl_write_restricted_reg(priv, SCD_QUEUE_RDPTR(i), 0);
+		iwl_write_prph(priv, SCD_QUEUE_RDPTR(i), 0);
 		iwl_write_restricted(priv, HBUS_TARG_WRPTR, 0 | (i << 8));
 		iwl_write_restricted_mem(priv, priv->scd_base_addr +
 					SCD_CONTEXT_QUEUE_OFFSET(i),
@@ -1686,10 +1684,10 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 					SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK);
 
 	}
-	iwl_write_restricted_reg(priv, SCD_INTERRUPT_MASK,
+	iwl_write_prph(priv, SCD_INTERRUPT_MASK,
 				 (1 << priv->hw_setting.max_txq_num) - 1);
 
-	iwl_write_restricted_reg(priv, SCD_TXFACT,
+	iwl_write_prph(priv, SCD_TXFACT,
 				 SCD_TXFACT_REG_TXFIFO_MASK(0, 7));
 
 	iwl4965_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
@@ -4130,7 +4128,7 @@ static void iwl4965_rx_reply_compressed_ba(struct iwl_priv *priv,
 
 static void iwl4965_tx_queue_stop_scheduler(struct iwl_priv *priv, u16 txq_id)
 {
-	iwl_write_restricted_reg(priv,
+	iwl_write_prph(priv,
 		SCD_QUEUE_STATUS_BITS(txq_id),
 		(0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
 		(1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
@@ -4191,7 +4189,7 @@ static int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id,
 	iwl4965_tx_queue_set_q2ratid(priv, ra_tid, txq_id);
 
 
-	iwl_set_bits_restricted_reg(priv, SCD_QUEUECHAIN_SEL, (1<<txq_id));
+	iwl_set_bits_prph(priv, SCD_QUEUECHAIN_SEL, (1<<txq_id));
 
 	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
 	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
@@ -4209,7 +4207,7 @@ static int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id,
 			(SCD_FRAME_LIMIT << SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS)
 			& SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK);
 
-	iwl_set_bits_restricted_reg(priv, SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_set_bits_prph(priv, SCD_INTERRUPT_MASK, (1 << txq_id));
 
 	iwl4965_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
 
@@ -4243,14 +4241,14 @@ static int iwl4965_tx_queue_agg_disable(struct iwl_priv *priv, u16 txq_id,
 
 	iwl4965_tx_queue_stop_scheduler(priv, txq_id);
 
-	iwl_clear_bits_restricted_reg(priv, SCD_QUEUECHAIN_SEL, (1 << txq_id));
+	iwl_clear_bits_prph(priv, SCD_QUEUECHAIN_SEL, (1 << txq_id));
 
 	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
 	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
 	/* supposes that ssn_idx is valid (!= 0xFFF) */
 	iwl4965_set_wr_ptrs(priv, txq_id, ssn_idx);
 
-	iwl_clear_bits_restricted_reg(priv, SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_clear_bits_prph(priv, SCD_INTERRUPT_MASK, (1 << txq_id));
 	iwl4965_txq_ctx_deactivate(priv, txq_id);
 	iwl4965_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 0);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 8a8b96f..b78afed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -330,27 +330,26 @@ static inline int __iwl_poll_restricted_bit(const char *f, u32 l,
 #define iwl_poll_restricted_bit _iwl_poll_restricted_bit
 #endif
 
-static inline u32 _iwl_read_restricted_reg(struct iwl_priv *priv, u32 reg)
+static inline u32 _iwl_read_prph(struct iwl_priv *priv, u32 reg)
 {
 	_iwl_write_restricted(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
 	return _iwl_read_restricted(priv, HBUS_TARG_PRPH_RDAT);
 }
 #ifdef CONFIG_IWLWIFI_DEBUG
-static inline u32 __iwl_read_restricted_reg(u32 line,
-					    struct iwl_priv *priv, u32 reg)
+static inline u32 __iwl_read_prph(u32 line, struct iwl_priv *priv, u32 reg)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
 		IWL_ERROR("Unrestricted access from line %d\n", line);
-	return _iwl_read_restricted_reg(priv, reg);
+	return _iwl_read_prph(priv, reg);
 }
 
-#define iwl_read_restricted_reg(priv, reg) \
-	__iwl_read_restricted_reg(__LINE__, priv, reg)
+#define iwl_read_prph(priv, reg) \
+	__iwl_read_prph(__LINE__, priv, reg)
 #else
-#define iwl_read_restricted_reg _iwl_read_restricted_reg
+#define iwl_read_prph _iwl_read_prph
 #endif
 
-static inline void _iwl_write_restricted_reg(struct iwl_priv *priv,
+static inline void _iwl_write_prph(struct iwl_priv *priv,
 					     u32 addr, u32 val)
 {
 	_iwl_write_restricted(priv, HBUS_TARG_PRPH_WADDR,
@@ -358,61 +357,58 @@ static inline void _iwl_write_restricted_reg(struct iwl_priv *priv,
 	_iwl_write_restricted(priv, HBUS_TARG_PRPH_WDAT, val);
 }
 #ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_write_restricted_reg(u32 line,
-					      struct iwl_priv *priv,
+static inline void __iwl_write_prph(u32 line, struct iwl_priv *priv,
 					      u32 addr, u32 val)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
 		IWL_ERROR("Unrestricted access from line %d\n", line);
-	_iwl_write_restricted_reg(priv, addr, val);
+	_iwl_write_prph(priv, addr, val);
 }
 
-#define iwl_write_restricted_reg(priv, addr, val) \
-	__iwl_write_restricted_reg(__LINE__, priv, addr, val);
+#define iwl_write_prph(priv, addr, val) \
+	__iwl_write_prph(__LINE__, priv, addr, val);
 #else
-#define iwl_write_restricted_reg _iwl_write_restricted_reg
+#define iwl_write_prph _iwl_write_prph
 #endif
 
-#define _iwl_set_bits_restricted_reg(priv, reg, mask) \
-	_iwl_write_restricted_reg(priv, reg, \
-				  (_iwl_read_restricted_reg(priv, reg) | mask))
+#define _iwl_set_bits_prph(priv, reg, mask) \
+	_iwl_write_prph(priv, reg, (_iwl_read_prph(priv, reg) | mask))
 #ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_set_bits_restricted_reg(u32 line, struct iwl_priv
-						 *priv, u32 reg, u32 mask)
+static inline void __iwl_set_bits_prph(u32 line, struct iwl_priv *priv,
+					u32 reg, u32 mask)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
 		IWL_ERROR("Unrestricted access from line %d\n", line);
-	_iwl_set_bits_restricted_reg(priv, reg, mask);
+	_iwl_set_bits_prph(priv, reg, mask);
 }
-#define iwl_set_bits_restricted_reg(priv, reg, mask) \
-	__iwl_set_bits_restricted_reg(__LINE__, priv, reg, mask)
+#define iwl_set_bits_prph(priv, reg, mask) \
+	__iwl_set_bits_prph(__LINE__, priv, reg, mask)
 #else
-#define iwl_set_bits_restricted_reg _iwl_set_bits_restricted_reg
+#define iwl_set_bits_prph _iwl_set_bits_prph
 #endif
 
-#define _iwl_set_bits_mask_restricted_reg(priv, reg, bits, mask) \
-	_iwl_write_restricted_reg( \
-	    priv, reg, ((_iwl_read_restricted_reg(priv, reg) & mask) | bits))
+#define _iwl_set_bits_mask_prph(priv, reg, bits, mask) \
+	_iwl_write_prph(priv, reg, ((_iwl_read_prph(priv, reg) & mask) | bits))
+
 #ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_set_bits_mask_restricted_reg(u32 line,
+static inline void __iwl_set_bits_mask_prph(u32 line,
 		struct iwl_priv *priv, u32 reg, u32 bits, u32 mask)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
 		IWL_ERROR("Unrestricted access from line %d\n", line);
-	_iwl_set_bits_mask_restricted_reg(priv, reg, bits, mask);
+	_iwl_set_bits_mask_prph(priv, reg, bits, mask);
 }
-
-#define iwl_set_bits_mask_restricted_reg(priv, reg, bits, mask) \
-	__iwl_set_bits_mask_restricted_reg(__LINE__, priv, reg, bits, mask)
+#define iwl_set_bits_mask_prph(priv, reg, bits, mask) \
+	__iwl_set_bits_mask_prph(__LINE__, priv, reg, bits, mask)
 #else
-#define iwl_set_bits_mask_restricted_reg _iwl_set_bits_mask_restricted_reg
+#define iwl_set_bits_mask_prph _iwl_set_bits_mask_prph
 #endif
 
-static inline void iwl_clear_bits_restricted_reg(struct iwl_priv
+static inline void iwl_clear_bits_prph(struct iwl_priv
 						 *priv, u32 reg, u32 mask)
 {
-	u32 val = _iwl_read_restricted_reg(priv, reg);
-	_iwl_write_restricted_reg(priv, reg, (val & ~mask));
+	u32 val = _iwl_read_prph(priv, reg);
+	_iwl_write_prph(priv, reg, (val & ~mask));
 }
 
 static inline u32 iwl_read_restricted_mem(struct iwl_priv *priv, u32 addr)
@@ -435,36 +431,4 @@ static inline void iwl_write_restricted_mems(struct iwl_priv *priv, u32 addr,
 	for (; 0 < len; len -= sizeof(u32), values++)
 		iwl_write_restricted(priv, HBUS_TARG_MEM_WDAT, *values);
 }
-
-static inline void iwl_write_restricted_regs(struct iwl_priv *priv, u32 reg,
-					     u32 len, u8 *values)
-{
-	u32 reg_offset = reg;
-	u32 aligment = reg & 0x3;
-
-	/* write any non-dword-aligned stuff at the beginning */
-	if (len < sizeof(u32)) {
-		if ((aligment + len) <= sizeof(u32)) {
-			u8 size;
-			u32 value = 0;
-			size = len - 1;
-			memcpy(&value, values, len);
-			reg_offset = (reg_offset & 0x0000FFFF);
-
-			_iwl_write_restricted(priv,
-					      HBUS_TARG_PRPH_WADDR,
-					      (reg_offset | (size << 24)));
-			_iwl_write_restricted(priv, HBUS_TARG_PRPH_WDAT,
-					      value);
-		}
-
-		return;
-	}
-
-	/* now write all the dword-aligned stuff */
-	for (; reg_offset < (reg + len);
-	     reg_offset += sizeof(u32), values += sizeof(u32))
-		_iwl_write_restricted_reg(priv, reg_offset, *((u32 *) values));
-}
-
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 7fb73c3..79e5417 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5608,11 +5608,11 @@ static int iwl_verify_bsm(struct iwl_priv *priv)
 	IWL_DEBUG_INFO("Begin verify bsm\n");
 
 	/* verify BSM SRAM contents */
-	val = iwl_read_restricted_reg(priv, BSM_WR_DWCOUNT_REG);
+	val = iwl_read_prph(priv, BSM_WR_DWCOUNT_REG);
 	for (reg = BSM_SRAM_LOWER_BOUND;
 	     reg < BSM_SRAM_LOWER_BOUND + len;
 	     reg += sizeof(u32), image ++) {
-		val = iwl_read_restricted_reg(priv, reg);
+		val = iwl_read_prph(priv, reg);
 		if (val != le32_to_cpu(*image)) {
 			IWL_ERROR("BSM uCode verification failed at "
 				  "addr 0x%08X+%u (of %u), is 0x%x, s/b 0x%x\n",
@@ -5693,16 +5693,16 @@ static int iwl_load_bsm(struct iwl_priv *priv)
 	if (rc)
 		return rc;
 
-	iwl_write_restricted_reg(priv, BSM_DRAM_INST_PTR_REG, pinst);
-	iwl_write_restricted_reg(priv, BSM_DRAM_DATA_PTR_REG, pdata);
-	iwl_write_restricted_reg(priv, BSM_DRAM_INST_BYTECOUNT_REG, inst_len);
-	iwl_write_restricted_reg(priv, BSM_DRAM_DATA_BYTECOUNT_REG, data_len);
+	iwl_write_prph(priv, BSM_DRAM_INST_PTR_REG, pinst);
+	iwl_write_prph(priv, BSM_DRAM_DATA_PTR_REG, pdata);
+	iwl_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG, inst_len);
+	iwl_write_prph(priv, BSM_DRAM_DATA_BYTECOUNT_REG, data_len);
 
 	/* Fill BSM memory with bootstrap instructions */
 	for (reg_offset = BSM_SRAM_LOWER_BOUND;
 	     reg_offset < BSM_SRAM_LOWER_BOUND + len;
 	     reg_offset += sizeof(u32), image++)
-		_iwl_write_restricted_reg(priv, reg_offset,
+		_iwl_write_prph(priv, reg_offset,
 					  le32_to_cpu(*image));
 
 	rc = iwl_verify_bsm(priv);
@@ -5712,19 +5712,19 @@ static int iwl_load_bsm(struct iwl_priv *priv)
 	}
 
 	/* Tell BSM to copy from BSM SRAM into instruction SRAM, when asked */
-	iwl_write_restricted_reg(priv, BSM_WR_MEM_SRC_REG, 0x0);
-	iwl_write_restricted_reg(priv, BSM_WR_MEM_DST_REG,
+	iwl_write_prph(priv, BSM_WR_MEM_SRC_REG, 0x0);
+	iwl_write_prph(priv, BSM_WR_MEM_DST_REG,
 				 RTC_INST_LOWER_BOUND);
-	iwl_write_restricted_reg(priv, BSM_WR_DWCOUNT_REG, len / sizeof(u32));
+	iwl_write_prph(priv, BSM_WR_DWCOUNT_REG, len / sizeof(u32));
 
 	/* Load bootstrap code into instruction SRAM now,
 	 *   to prepare to load "initialize" uCode */
-	iwl_write_restricted_reg(priv, BSM_WR_CTRL_REG,
+	iwl_write_prph(priv, BSM_WR_CTRL_REG,
 		BSM_WR_CTRL_REG_BIT_START);
 
 	/* Wait for load of bootstrap uCode to finish */
 	for (i = 0; i < 100; i++) {
-		done = iwl_read_restricted_reg(priv, BSM_WR_CTRL_REG);
+		done = iwl_read_prph(priv, BSM_WR_CTRL_REG);
 		if (!(done & BSM_WR_CTRL_REG_BIT_START))
 			break;
 		udelay(10);
@@ -5738,7 +5738,7 @@ static int iwl_load_bsm(struct iwl_priv *priv)
 
 	/* Enable future boot loads whenever power management unit triggers it
 	 *   (e.g. when powering back up after power-save shutdown) */
-	iwl_write_restricted_reg(priv, BSM_WR_CTRL_REG,
+	iwl_write_prph(priv, BSM_WR_CTRL_REG,
 		BSM_WR_CTRL_REG_BIT_START_EN);
 
 	iwl_release_restricted_access(priv);
@@ -5989,14 +5989,14 @@ static int iwl_set_ucode_ptrs(struct iwl_priv *priv)
 	}
 
 	/* Tell bootstrap uCode where to find image to load */
-	iwl_write_restricted_reg(priv, BSM_DRAM_INST_PTR_REG, pinst);
-	iwl_write_restricted_reg(priv, BSM_DRAM_DATA_PTR_REG, pdata);
-	iwl_write_restricted_reg(priv, BSM_DRAM_DATA_BYTECOUNT_REG,
+	iwl_write_prph(priv, BSM_DRAM_INST_PTR_REG, pinst);
+	iwl_write_prph(priv, BSM_DRAM_DATA_PTR_REG, pdata);
+	iwl_write_prph(priv, BSM_DRAM_DATA_BYTECOUNT_REG,
 				 priv->ucode_data.len);
 
 	/* Inst bytecount must be last to set up, bit 31 signals uCode
 	 *   that all new ptr/size info is in place */
-	iwl_write_restricted_reg(priv, BSM_DRAM_INST_BYTECOUNT_REG,
+	iwl_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG,
 				 priv->ucode_code.len | BSM_DRAM_INST_LOAD);
 
 	iwl_release_restricted_access(priv);
@@ -6094,7 +6094,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		return;
 	}
 
-	rfkill = iwl_read_restricted_reg(priv, APMG_RFKILL_REG);
+	rfkill = iwl_read_prph(priv, APMG_RFKILL_REG);
 	IWL_DEBUG_INFO("RFKILL status: 0x%x\n", rfkill);
 	iwl_release_restricted_access(priv);
 
@@ -6260,7 +6260,7 @@ static void __iwl_down(struct iwl_priv *priv)
 
 	spin_lock_irqsave(&priv->lock, flags);
 	if (!iwl_grab_restricted_access(priv)) {
-		iwl_write_restricted_reg(priv, APMG_CLK_DIS_REG,
+		iwl_write_prph(priv, APMG_CLK_DIS_REG,
 					 APMG_CLK_VAL_DMA_CLK_RQT);
 		iwl_release_restricted_access(priv);
 	}
@@ -8605,7 +8605,7 @@ static void iwl_resume(struct iwl_priv *priv)
 	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 
 	if (!iwl_grab_restricted_access(priv)) {
-		iwl_write_restricted_reg(priv, APMG_CLK_DIS_REG,
+		iwl_write_prph(priv, APMG_CLK_DIS_REG,
 					 APMG_CLK_VAL_DMA_CLK_RQT);
 		iwl_release_restricted_access(priv);
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 0b1d91e..b702dd4 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5987,11 +5987,11 @@ static int iwl_verify_bsm(struct iwl_priv *priv)
 	IWL_DEBUG_INFO("Begin verify bsm\n");
 
 	/* verify BSM SRAM contents */
-	val = iwl_read_restricted_reg(priv, BSM_WR_DWCOUNT_REG);
+	val = iwl_read_prph(priv, BSM_WR_DWCOUNT_REG);
 	for (reg = BSM_SRAM_LOWER_BOUND;
 	     reg < BSM_SRAM_LOWER_BOUND + len;
 	     reg += sizeof(u32), image ++) {
-		val = iwl_read_restricted_reg(priv, reg);
+		val = iwl_read_prph(priv, reg);
 		if (val != le32_to_cpu(*image)) {
 			IWL_ERROR("BSM uCode verification failed at "
 				  "addr 0x%08X+%u (of %u), is 0x%x, s/b 0x%x\n",
@@ -6072,16 +6072,16 @@ static int iwl_load_bsm(struct iwl_priv *priv)
 	if (rc)
 		return rc;
 
-	iwl_write_restricted_reg(priv, BSM_DRAM_INST_PTR_REG, pinst);
-	iwl_write_restricted_reg(priv, BSM_DRAM_DATA_PTR_REG, pdata);
-	iwl_write_restricted_reg(priv, BSM_DRAM_INST_BYTECOUNT_REG, inst_len);
-	iwl_write_restricted_reg(priv, BSM_DRAM_DATA_BYTECOUNT_REG, data_len);
+	iwl_write_prph(priv, BSM_DRAM_INST_PTR_REG, pinst);
+	iwl_write_prph(priv, BSM_DRAM_DATA_PTR_REG, pdata);
+	iwl_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG, inst_len);
+	iwl_write_prph(priv, BSM_DRAM_DATA_BYTECOUNT_REG, data_len);
 
 	/* Fill BSM memory with bootstrap instructions */
 	for (reg_offset = BSM_SRAM_LOWER_BOUND;
 	     reg_offset < BSM_SRAM_LOWER_BOUND + len;
 	     reg_offset += sizeof(u32), image++)
-		_iwl_write_restricted_reg(priv, reg_offset,
+		_iwl_write_prph(priv, reg_offset,
 					  le32_to_cpu(*image));
 
 	rc = iwl_verify_bsm(priv);
@@ -6091,19 +6091,19 @@ static int iwl_load_bsm(struct iwl_priv *priv)
 	}
 
 	/* Tell BSM to copy from BSM SRAM into instruction SRAM, when asked */
-	iwl_write_restricted_reg(priv, BSM_WR_MEM_SRC_REG, 0x0);
-	iwl_write_restricted_reg(priv, BSM_WR_MEM_DST_REG,
+	iwl_write_prph(priv, BSM_WR_MEM_SRC_REG, 0x0);
+	iwl_write_prph(priv, BSM_WR_MEM_DST_REG,
 				 RTC_INST_LOWER_BOUND);
-	iwl_write_restricted_reg(priv, BSM_WR_DWCOUNT_REG, len / sizeof(u32));
+	iwl_write_prph(priv, BSM_WR_DWCOUNT_REG, len / sizeof(u32));
 
 	/* Load bootstrap code into instruction SRAM now,
 	 *   to prepare to load "initialize" uCode */
-	iwl_write_restricted_reg(priv, BSM_WR_CTRL_REG,
+	iwl_write_prph(priv, BSM_WR_CTRL_REG,
 		BSM_WR_CTRL_REG_BIT_START);
 
 	/* Wait for load of bootstrap uCode to finish */
 	for (i = 0; i < 100; i++) {
-		done = iwl_read_restricted_reg(priv, BSM_WR_CTRL_REG);
+		done = iwl_read_prph(priv, BSM_WR_CTRL_REG);
 		if (!(done & BSM_WR_CTRL_REG_BIT_START))
 			break;
 		udelay(10);
@@ -6117,7 +6117,7 @@ static int iwl_load_bsm(struct iwl_priv *priv)
 
 	/* Enable future boot loads whenever power management unit triggers it
 	 *   (e.g. when powering back up after power-save shutdown) */
-	iwl_write_restricted_reg(priv, BSM_WR_CTRL_REG,
+	iwl_write_prph(priv, BSM_WR_CTRL_REG,
 		BSM_WR_CTRL_REG_BIT_START_EN);
 
 	iwl_release_restricted_access(priv);
@@ -6372,14 +6372,14 @@ static int iwl_set_ucode_ptrs(struct iwl_priv *priv)
 	}
 
 	/* Tell bootstrap uCode where to find image to load */
-	iwl_write_restricted_reg(priv, BSM_DRAM_INST_PTR_REG, pinst);
-	iwl_write_restricted_reg(priv, BSM_DRAM_DATA_PTR_REG, pdata);
-	iwl_write_restricted_reg(priv, BSM_DRAM_DATA_BYTECOUNT_REG,
+	iwl_write_prph(priv, BSM_DRAM_INST_PTR_REG, pinst);
+	iwl_write_prph(priv, BSM_DRAM_DATA_PTR_REG, pdata);
+	iwl_write_prph(priv, BSM_DRAM_DATA_BYTECOUNT_REG,
 				 priv->ucode_data.len);
 
 	/* Inst bytecount must be last to set up, bit 31 signals uCode
 	 *   that all new ptr/size info is in place */
-	iwl_write_restricted_reg(priv, BSM_DRAM_INST_BYTECOUNT_REG,
+	iwl_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG,
 				 priv->ucode_code.len | BSM_DRAM_INST_LOAD);
 
 	iwl_release_restricted_access(priv);
@@ -6625,7 +6625,7 @@ static void __iwl_down(struct iwl_priv *priv)
 
 	spin_lock_irqsave(&priv->lock, flags);
 	if (!iwl_grab_restricted_access(priv)) {
-		iwl_write_restricted_reg(priv, APMG_CLK_DIS_REG,
+		iwl_write_prph(priv, APMG_CLK_DIS_REG,
 					 APMG_CLK_VAL_DMA_CLK_RQT);
 		iwl_release_restricted_access(priv);
 	}
@@ -9209,7 +9209,7 @@ static void iwl_resume(struct iwl_priv *priv)
 	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 
 	if (!iwl_grab_restricted_access(priv)) {
-		iwl_write_restricted_reg(priv, APMG_CLK_DIS_REG,
+		iwl_write_prph(priv, APMG_CLK_DIS_REG,
 					 APMG_CLK_VAL_DMA_CLK_RQT);
 		iwl_release_restricted_access(priv);
 	}
-- 
1.5.2
