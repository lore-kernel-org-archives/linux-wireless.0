Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38048 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab1HMSSd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:33 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 47/60] iwlagn: remove dereferences of priv from transport
Date: Sat, 13 Aug 2011 10:38:23 -0700
Message-Id: <1313257116-2697-48-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201843_117039_2EAAE0BA)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

There are still quite a few, but much less.
A few fields have been moved /copied to hw_params which sits in the
shared area:
 * priv->cfg->base_params->num_of_ampdu_queues
 * priv->cfg->base_params->shadow_reg_enable
 * priv->cfg->sku
 * priv->ucode_owner

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |    7 ++++
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    7 ----
 drivers/net/wireless/iwlwifi/iwl-power.c          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h         |   21 +++++++++---
 drivers/net/wireless/iwlwifi/iwl-sv-open.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |    3 +-
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c  |   15 ++++-----
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  |   35 ++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-trans.c          |   24 ++++++--------
 10 files changed, 64 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index f63c379..872e39d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -102,12 +102,12 @@ static int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id, int sta_id,
 {
 	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IWLAGN_FIRST_AMPDU_QUEUE +
-		priv->cfg->base_params->num_of_ampdu_queues <= txq_id)) {
+		hw_params(priv).num_ampdu_queues <= txq_id)) {
 		IWL_WARN(priv,
 			"queue number out of range: %d, must be %d to %d\n",
 			txq_id, IWLAGN_FIRST_AMPDU_QUEUE,
 			IWLAGN_FIRST_AMPDU_QUEUE +
-			priv->cfg->base_params->num_of_ampdu_queues - 1);
+			hw_params(priv).num_ampdu_queues - 1);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 191e1b0..ce78ace 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3271,6 +3271,13 @@ static int iwl_set_hw_params(struct iwl_priv *priv)
 	if (iwlagn_mod_params.disable_11n)
 		priv->cfg->sku &= ~EEPROM_SKU_CAP_11N_ENABLE;
 
+	hw_params(priv).num_ampdu_queues =
+		priv->cfg->base_params->num_of_ampdu_queues;
+	hw_params(priv).shadow_reg_enable =
+		priv->cfg->base_params->shadow_reg_enable;
+	hw_params(priv).sku =
+		priv->cfg->sku;
+
 	/* Device-specific setup */
 	return priv->cfg->lib->set_hw_params(priv);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 23972f4..cf80fe8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1058,10 +1058,6 @@ struct iwl_testmode_trace {
 };
 #endif
 
-/* uCode ownership */
-#define IWL_OWNERSHIP_DRIVER	0
-#define IWL_OWNERSHIP_TM	1
-
 struct iwl_priv {
 
 	/*data shared among all the driver's layers */
@@ -1149,9 +1145,6 @@ struct iwl_priv {
 	u32 ucode_ver;			/* version of ucode, copy of
 					   iwl_ucode.ver */
 
-	/* uCode owner: default: IWL_OWNERSHIP_DRIVER */
-	u8 ucode_owner;
-
 	struct fw_img ucode_rt;
 	struct fw_img ucode_init;
 	struct fw_img ucode_wowlan;
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 9c8d2da..aafa0f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -215,7 +215,7 @@ static void iwl_static_sleep_cmd(struct iwl_priv *priv,
 	else
 		cmd->flags &= ~IWL_POWER_SLEEP_OVER_DTIM_MSK;
 
-	if (priv->cfg->base_params->shadow_reg_enable)
+	if (hw_params(priv).shadow_reg_enable)
 		cmd->flags |= IWL_POWER_SHADOW_REG_ENA;
 	else
 		cmd->flags &= ~IWL_POWER_SHADOW_REG_ENA;
@@ -301,7 +301,7 @@ static void iwl_power_fill_sleep_cmd(struct iwl_priv *priv,
 	if (priv->power_data.bus_pm)
 		cmd->flags |= IWL_POWER_PCI_PM_MSK;
 
-	if (priv->cfg->base_params->shadow_reg_enable)
+	if (hw_params(priv).shadow_reg_enable)
 		cmd->flags |= IWL_POWER_SHADOW_REG_ENA;
 	else
 		cmd->flags &= ~IWL_POWER_SHADOW_REG_ENA;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index bb61c13..db606a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -133,36 +133,41 @@ struct iwl_mod_params {
 /**
  * struct iwl_hw_params
  * @max_txq_num: Max # Tx queues supported
+ * @num_ampdu_queues: num of ampdu queues
  * @tx/rx_chains_num: Number of TX/RX chains
  * @valid_tx/rx_ant: usable antennas
- * @rx_page_order: Rx buffer page order
- * @rx_wrt_ptr_reg: FH{39}_RSCSR_CHNL0_WPTR
  * @max_stations:
  * @ht40_channel: is 40MHz width possible in band 2.4
+ * @beacon_time_tsf_bits: number of valid tsf bits for beacon time
+ * @sku:
+ * @rx_page_order: Rx buffer page order
+ * @rx_wrt_ptr_reg: FH{39}_RSCSR_CHNL0_WPTR
  * BIT(IEEE80211_BAND_5GHZ) BIT(IEEE80211_BAND_5GHZ)
  * @sw_crypto: 0 for hw, 1 for sw
  * @max_xxx_size: for ucode uses
  * @ct_kill_threshold: temperature threshold
- * @beacon_time_tsf_bits: number of valid tsf bits for beacon time
  * @calib_init_cfg: setup initial calibrations for the hw
  * @calib_rt_cfg: setup runtime calibrations for the hw
  * @struct iwl_sensitivity_ranges: range of sensitivity values
  */
 struct iwl_hw_params {
-	u8 max_txq_num;
+	u8  max_txq_num;
+	u8  num_ampdu_queues;
 	u8  tx_chains_num;
 	u8  rx_chains_num;
 	u8  valid_tx_ant;
 	u8  valid_rx_ant;
-	u32 rx_page_order;
 	u8  max_stations;
 	u8  ht40_channel;
+	bool shadow_reg_enable;
+	u16 beacon_time_tsf_bits;
+	u16 sku;
+	u32 rx_page_order;
 	u32 max_inst_size;
 	u32 max_data_size;
 	u32 ct_kill_threshold; /* value in hw-dependent units */
 	u32 ct_kill_exit_threshold; /* value in hw-dependent units */
 				    /* for 1000, 6000 series and up */
-	u16 beacon_time_tsf_bits;
 	u32 calib_init_cfg;
 	u32 calib_rt_cfg;
 	const struct iwl_sensitivity_ranges *sens;
@@ -201,6 +206,7 @@ struct iwl_tid_data {
  *
  * @dbg_level_dev: dbg level set per device. Prevails on
  *	iwlagn_mod_params.debug_level if set (!= 0)
+ * @ucode_owner: IWL_OWNERSHIP_*
  * @cmd_queue: command queue number
  * @status: STATUS_*
  * @bus: pointer to the bus layer data
@@ -217,6 +223,9 @@ struct iwl_shared {
 	u32 dbg_level_dev;
 #endif /* CONFIG_IWLWIFI_DEBUG */
 
+#define IWL_OWNERSHIP_DRIVER	0
+#define IWL_OWNERSHIP_TM	1
+	u8 ucode_owner;
 	u8 cmd_queue;
 	unsigned long status;
 	bool wowlan;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index b53d77b..848fc18 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -612,7 +612,7 @@ static int iwl_testmode_ownership(struct ieee80211_hw *hw, struct nlattr **tb)
 
 	owner = nla_get_u8(tb[IWL_TM_ATTR_UCODE_OWNER]);
 	if ((owner == IWL_OWNERSHIP_DRIVER) || (owner == IWL_OWNERSHIP_TM))
-		priv->ucode_owner = owner;
+		priv->shrd->ucode_owner = owner;
 	else {
 		IWL_DEBUG_INFO(priv, "Invalid owner\n");
 		return -EINVAL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index bd6e640..269d9e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -162,7 +162,8 @@ irqreturn_t iwl_isr_ict(int irq, void *data);
 /*****************************************************
 * TX / HCMD
 ******************************************************/
-void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
+void iwl_txq_update_write_ptr(struct iwl_trans *trans,
+			struct iwl_tx_queue *txq);
 int iwlagn_txq_attach_buf_to_tfd(struct iwl_trans *trans,
 				 struct iwl_tx_queue *txq,
 				 dma_addr_t addr, u16 len, u8 reset);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index 5cff771..a0699c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -130,7 +130,6 @@ static int iwl_rx_queue_space(const struct iwl_rx_queue *q)
 void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
 			struct iwl_rx_queue *q)
 {
-	struct iwl_priv *priv = priv(trans);
 	unsigned long flags;
 	u32 reg;
 
@@ -139,34 +138,34 @@ void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
 	if (q->need_update == 0)
 		goto exit_unlock;
 
-	if (priv->cfg->base_params->shadow_reg_enable) {
+	if (hw_params(trans).shadow_reg_enable) {
 		/* shadow register enabled */
 		/* Device expects a multiple of 8 */
 		q->write_actual = (q->write & ~0x7);
-		iwl_write32(bus(priv), FH_RSCSR_CHNL0_WPTR, q->write_actual);
+		iwl_write32(bus(trans), FH_RSCSR_CHNL0_WPTR, q->write_actual);
 	} else {
 		/* If power-saving is in use, make sure device is awake */
 		if (test_bit(STATUS_POWER_PMI, &trans->shrd->status)) {
-			reg = iwl_read32(bus(priv), CSR_UCODE_DRV_GP1);
+			reg = iwl_read32(bus(trans), CSR_UCODE_DRV_GP1);
 
 			if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
 				IWL_DEBUG_INFO(trans,
 					"Rx queue requesting wakeup,"
 					" GP1 = 0x%x\n", reg);
-				iwl_set_bit(bus(priv), CSR_GP_CNTRL,
+				iwl_set_bit(bus(trans), CSR_GP_CNTRL,
 					CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 				goto exit_unlock;
 			}
 
 			q->write_actual = (q->write & ~0x7);
-			iwl_write_direct32(bus(priv), FH_RSCSR_CHNL0_WPTR,
+			iwl_write_direct32(bus(trans), FH_RSCSR_CHNL0_WPTR,
 					q->write_actual);
 
 		/* Else device is assumed to be awake */
 		} else {
 			/* Device expects a multiple of 8 */
 			q->write_actual = (q->write & ~0x7);
-			iwl_write_direct32(bus(priv), FH_RSCSR_CHNL0_WPTR,
+			iwl_write_direct32(bus(trans), FH_RSCSR_CHNL0_WPTR,
 				q->write_actual);
 		}
 	}
@@ -1032,7 +1031,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		IWL_DEBUG_ISR(trans, "Wakeup interrupt\n");
 		iwl_rx_queue_update_write_ptr(trans, &trans_pcie->rxq);
 		for (i = 0; i < hw_params(trans).max_txq_num; i++)
-			iwl_txq_update_write_ptr(priv(trans),
+			iwl_txq_update_write_ptr(trans,
 						 &priv(trans)->txq[i]);
 
 		isr_stats->wakeup++;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 15bca8d..0a57688 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -86,7 +86,7 @@ void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 /**
  * iwl_txq_update_write_ptr - Send new write index to hardware
  */
-void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
+void iwl_txq_update_write_ptr(struct iwl_trans *trans, struct iwl_tx_queue *txq)
 {
 	u32 reg = 0;
 	int txq_id = txq->q.id;
@@ -94,28 +94,28 @@ void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	if (txq->need_update == 0)
 		return;
 
-	if (priv->cfg->base_params->shadow_reg_enable) {
+	if (hw_params(trans).shadow_reg_enable) {
 		/* shadow register enabled */
-		iwl_write32(bus(priv), HBUS_TARG_WRPTR,
+		iwl_write32(bus(trans), HBUS_TARG_WRPTR,
 			    txq->q.write_ptr | (txq_id << 8));
 	} else {
 		/* if we're trying to save power */
-		if (test_bit(STATUS_POWER_PMI, &priv->shrd->status)) {
+		if (test_bit(STATUS_POWER_PMI, &trans->shrd->status)) {
 			/* wake up nic if it's powered down ...
 			 * uCode will wake up, and interrupt us again, so next
 			 * time we'll skip this part. */
-			reg = iwl_read32(bus(priv), CSR_UCODE_DRV_GP1);
+			reg = iwl_read32(bus(trans), CSR_UCODE_DRV_GP1);
 
 			if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-				IWL_DEBUG_INFO(priv,
+				IWL_DEBUG_INFO(trans,
 					"Tx queue %d requesting wakeup,"
 					" GP1 = 0x%x\n", txq_id, reg);
-				iwl_set_bit(bus(priv), CSR_GP_CNTRL,
+				iwl_set_bit(bus(trans), CSR_GP_CNTRL,
 					CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 				return;
 			}
 
-			iwl_write_direct32(bus(priv), HBUS_TARG_WRPTR,
+			iwl_write_direct32(bus(trans), HBUS_TARG_WRPTR,
 				     txq->q.write_ptr | (txq_id << 8));
 
 		/*
@@ -124,7 +124,7 @@ void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 		 * trying to tx (during RFKILL, we're not trying to tx).
 		 */
 		} else
-			iwl_write32(bus(priv), HBUS_TARG_WRPTR,
+			iwl_write32(bus(trans), HBUS_TARG_WRPTR,
 				    txq->q.write_ptr | (txq_id << 8));
 	}
 	txq->need_update = 0;
@@ -498,12 +498,12 @@ int iwl_trans_pcie_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 	struct iwl_trans *trans = trans(priv);
 	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IWLAGN_FIRST_AMPDU_QUEUE +
-		priv->cfg->base_params->num_of_ampdu_queues <= txq_id)) {
+		hw_params(priv).num_ampdu_queues <= txq_id)) {
 		IWL_ERR(priv,
 			"queue number out of range: %d, must be %d to %d\n",
 			txq_id, IWLAGN_FIRST_AMPDU_QUEUE,
 			IWLAGN_FIRST_AMPDU_QUEUE +
-			priv->cfg->base_params->num_of_ampdu_queues - 1);
+			hw_params(priv).num_ampdu_queues - 1);
 		return -EINVAL;
 	}
 
@@ -536,8 +536,7 @@ int iwl_trans_pcie_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
  */
 static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 {
-	struct iwl_priv *priv = priv(trans);
-	struct iwl_tx_queue *txq = &priv->txq[priv->shrd->cmd_queue];
+	struct iwl_tx_queue *txq = &priv(trans)->txq[trans->shrd->cmd_queue];
 	struct iwl_queue *q = &txq->q;
 	struct iwl_device_cmd *out_cmd;
 	struct iwl_cmd_meta *out_meta;
@@ -560,7 +559,7 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 		return -EIO;
 	}
 
-	if ((priv->ucode_owner == IWL_OWNERSHIP_TM) &&
+	if ((trans->shrd->ucode_owner == IWL_OWNERSHIP_TM) &&
 	    !(cmd->flags & CMD_ON_DEMAND)) {
 		IWL_DEBUG_HC(trans, "tm own the uCode, no regular hcmd send\n");
 		return -EIO;
@@ -607,10 +606,10 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 		spin_unlock_irqrestore(&trans->hcmd_lock, flags);
 
 		IWL_ERR(trans, "No space in command queue\n");
-		is_ct_kill = iwl_check_for_ct_kill(priv);
+		is_ct_kill = iwl_check_for_ct_kill(priv(trans));
 		if (!is_ct_kill) {
 			IWL_ERR(trans, "Restarting adapter queue is full\n");
-			iwlagn_fw_error(priv, false);
+			iwlagn_fw_error(priv(trans), false);
 		}
 		return -ENOSPC;
 	}
@@ -702,7 +701,7 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	/* check that tracing gets all possible blocks */
 	BUILD_BUG_ON(IWL_MAX_CMD_TFDS + 1 != 3);
 #ifdef CONFIG_IWLWIFI_DEVICE_TRACING
-	trace_iwlwifi_dev_hcmd(priv, cmd->flags,
+	trace_iwlwifi_dev_hcmd(priv(trans), cmd->flags,
 			       trace_bufs[0], trace_lens[0],
 			       trace_bufs[1], trace_lens[1],
 			       trace_bufs[2], trace_lens[2]);
@@ -710,7 +709,7 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 
 	/* Increment and update queue's write index */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-	iwl_txq_update_write_ptr(priv, txq);
+	iwl_txq_update_write_ptr(trans, txq);
 
  out:
 	spin_unlock_irqrestore(&trans->hcmd_lock, flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index a18ed42..ac401b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -138,13 +138,12 @@ static void iwl_trans_rxq_free_rx_bufs(struct iwl_trans *trans)
 	}
 }
 
-static void iwl_trans_rx_hw_init(struct iwl_priv *priv,
+static void iwl_trans_rx_hw_init(struct iwl_trans *trans,
 				 struct iwl_rx_queue *rxq)
 {
 	u32 rb_size;
 	const u32 rfdnlog = RX_QUEUE_SIZE_LOG; /* 256 RBDs */
 	u32 rb_timeout = 0; /* FIXME: RX_RB_TIMEOUT for all devices? */
-	struct iwl_trans *trans = trans(priv);
 
 	rb_timeout = RX_RB_TIMEOUT;
 
@@ -221,7 +220,7 @@ static int iwl_rx_init(struct iwl_trans *trans)
 
 	iwlagn_rx_replenish(trans);
 
-	iwl_trans_rx_hw_init(priv(trans), rxq);
+	iwl_trans_rx_hw_init(trans, rxq);
 
 	spin_lock_irqsave(&trans->shrd->lock, flags);
 	rxq->need_update = 1;
@@ -509,7 +508,7 @@ static int iwl_trans_tx_alloc(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	u16 scd_bc_tbls_size = priv->cfg->base_params->num_of_queues *
+	u16 scd_bc_tbls_size = hw_params(trans).max_txq_num *
 			sizeof(struct iwlagn_scd_bc_tbl);
 
 	/*It is not allowed to alloc twice, so warn when this happens.
@@ -534,7 +533,7 @@ static int iwl_trans_tx_alloc(struct iwl_trans *trans)
 	}
 
 	priv->txq = kzalloc(sizeof(struct iwl_tx_queue) *
-			priv->cfg->base_params->num_of_queues, GFP_KERNEL);
+			hw_params(trans).max_txq_num, GFP_KERNEL);
 	if (!priv->txq) {
 		IWL_ERR(trans, "Not enough memory for txq\n");
 		ret = ENOMEM;
@@ -652,7 +651,7 @@ static int iwl_nic_init(struct iwl_trans *trans)
 	if (iwl_tx_init(trans))
 		return -ENOMEM;
 
-	if (priv->cfg->base_params->shadow_reg_enable) {
+	if (hw_params(trans).shadow_reg_enable) {
 		/* enable shadow regs in HW */
 		iwl_set_bit(bus(trans), CSR_MAC_SHADOW_REG_CTRL,
 			0x800FFFFF);
@@ -717,9 +716,9 @@ static int iwl_trans_pcie_start_device(struct iwl_trans *trans)
 	int ret;
 	struct iwl_priv *priv = priv(trans);
 
-	priv->ucode_owner = IWL_OWNERSHIP_DRIVER;
+	priv->shrd->ucode_owner = IWL_OWNERSHIP_DRIVER;
 
-	if ((priv->cfg->sku & EEPROM_SKU_CAP_AMT_ENABLE) &&
+	if ((hw_params(priv).sku & EEPROM_SKU_CAP_AMT_ENABLE) &&
 	     iwl_trans_pcie_prepare_card_hw(trans)) {
 		IWL_WARN(trans, "Exit HW not ready\n");
 		return -EIO;
@@ -1131,7 +1130,7 @@ static int iwl_trans_pcie_tx(struct iwl_priv *priv, struct sk_buff *skb,
 
 	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-	iwl_txq_update_write_ptr(priv, txq);
+	iwl_txq_update_write_ptr(trans(priv), txq);
 
 	/*
 	 * At this point the frame is "transmitted" successfully
@@ -1142,7 +1141,7 @@ static int iwl_trans_pcie_tx(struct iwl_priv *priv, struct sk_buff *skb,
 	if (iwl_queue_space(q) < q->high_mark) {
 		if (wait_write_ptr) {
 			txq->need_update = 1;
-			iwl_txq_update_write_ptr(priv, txq);
+			iwl_txq_update_write_ptr(trans(priv), txq);
 		} else {
 			iwl_stop_queue(priv, txq);
 		}
@@ -1366,7 +1365,7 @@ static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
 	char *buf;
 	int bufsz = ((IWL_TRAFFIC_ENTRIES * IWL_TRAFFIC_ENTRY_SIZE * 64) * 2) +
-		(priv->cfg->base_params->num_of_queues * 32 * 8) + 400;
+		(hw_params(trans).max_txq_num * 32 * 8) + 400;
 	const u8 *ptr;
 	ssize_t ret;
 
@@ -1468,8 +1467,7 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 	int pos = 0;
 	int cnt;
 	int ret;
-	const size_t bufsz = sizeof(char) * 64 *
-				priv->cfg->base_params->num_of_queues;
+	const size_t bufsz = sizeof(char) * 64 * hw_params(trans).max_txq_num;
 
 	if (!priv->txq) {
 		IWL_ERR(priv, "txq not ready\n");
-- 
1.7.0.4

