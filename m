Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59648 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472Ab2DROpu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 10:45:50 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/15] iwlwifi: transport holds its pointer to the config
Date: Wed, 18 Apr 2012 07:41:07 -0700
Message-Id: <1334760077-5714-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120418_165904_300693_A4538436)
In-Reply-To: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Instead of using the shared area that we be killed.
Remove the pointer to config from shared since it is not
used any more.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c           |    2 -
 drivers/net/wireless/iwlwifi/iwl-eeprom.c        |    4 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    3 --
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    6 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |   36 +++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-trans.h         |    8 ++++-
 8 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 69b5b1a..77262f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -890,8 +890,6 @@ struct iwl_drv *iwl_drv_start(struct iwl_shared *shrd,
 	struct iwl_drv *drv;
 	int ret;
 
-	shrd->cfg = cfg;
-
 	drv = kzalloc(sizeof(*drv), GFP_KERNEL);
 	if (!drv) {
 		dev_printk(KERN_ERR, trans->dev, "Couldn't allocate iwl_drv");
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 593485b..84e2384 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -433,7 +433,7 @@ static int iwl_init_otp_access(struct iwl_trans *trans)
 		 * CSR auto clock gate disable bit -
 		 * this is only applicable for HW with OTP shadow RAM
 		 */
-		if (cfg(trans)->base_params->shadow_ram_support)
+		if (trans->cfg->base_params->shadow_ram_support)
 			iwl_set_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
 				CSR_RESET_LINK_PWR_MGMT_DISABLED);
 	}
@@ -554,7 +554,7 @@ static int iwl_find_otp_image(struct iwl_trans *trans,
 		}
 		/* more in the link list, continue */
 		usedblocks++;
-	} while (usedblocks <= cfg(trans)->base_params->max_ll_items);
+	} while (usedblocks <= trans->cfg->base_params->max_ll_items);
 
 	/* OTP has no valid blocks */
 	IWL_DEBUG_EEPROM(trans, "OTP has no valid blocks\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 00a6dda..68974a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -281,7 +281,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_free_bus;
 	}
 
-	iwl_trans = iwl_trans_pcie_alloc(shrd, pdev, ent);
+	iwl_trans = iwl_trans_pcie_alloc(shrd, pdev, ent, cfg);
 	if (iwl_trans == NULL) {
 		err = -ENOMEM;
 		goto out_free_bus;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index d519487..3ebe96e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -150,16 +150,13 @@ struct iwl_mod_params {
 /**
  * struct iwl_shared - shared fields for all the layers of the driver
  *
- * @cfg: see struct iwl_cfg
  * @trans: pointer to the transport layer data
  */
 struct iwl_shared {
-	const struct iwl_cfg *cfg;
 	struct iwl_trans *trans;
 };
 
 /*Whatever _m is (iwl_trans, iwl_priv, these macros will work */
-#define cfg(_m)		((_m)->shrd->cfg)
 #define trans(_m)	((_m)->shrd->trans)
 
 static inline bool iwl_have_debug_level(u32 level)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index de78fb8..390490b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -140,7 +140,7 @@ void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
 	if (q->need_update == 0)
 		goto exit_unlock;
 
-	if (cfg(trans)->base_params->shadow_reg_enable) {
+	if (trans->cfg->base_params->shadow_reg_enable) {
 		/* shadow register enabled */
 		/* Device expects a multiple of 8 */
 		q->write_actual = (q->write & ~0x7);
@@ -543,7 +543,7 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 static void iwl_irq_handle_error(struct iwl_trans *trans)
 {
 	/* W/A for WiFi/WiMAX coex and WiMAX own the RF */
-	if (cfg(trans)->internal_wimax_coex &&
+	if (trans->cfg->internal_wimax_coex &&
 	    (!(iwl_read_prph(trans, APMG_CLK_CTRL_REG) &
 			APMS_CLK_VAL_MRB_FUNC_MODE) ||
 	     (iwl_read_prph(trans, APMG_PS_CTRL_REG) &
@@ -680,7 +680,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 	if (inta & CSR_INT_BIT_WAKEUP) {
 		IWL_DEBUG_ISR(trans, "Wakeup interrupt\n");
 		iwl_rx_queue_update_write_ptr(trans, &trans_pcie->rxq);
-		for (i = 0; i < cfg(trans)->base_params->num_of_queues; i++)
+		for (i = 0; i < trans->cfg->base_params->num_of_queues; i++)
 			iwl_txq_update_write_ptr(trans,
 						 &trans_pcie->txq[i]);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 9188740..bb0a314 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -99,7 +99,7 @@ void iwl_txq_update_write_ptr(struct iwl_trans *trans, struct iwl_tx_queue *txq)
 	if (txq->need_update == 0)
 		return;
 
-	if (cfg(trans)->base_params->shadow_reg_enable) {
+	if (trans->cfg->base_params->shadow_reg_enable) {
 		/* shadow register enabled */
 		iwl_write32(trans, HBUS_TARG_WRPTR,
 			    txq->q.write_ptr | (txq_id << 8));
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 14a32c4..76f05ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -79,7 +79,7 @@
 #define IWL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
 
 #define SCD_QUEUECHAIN_SEL_ALL(trans, trans_pcie)	\
-	(((1<<cfg(trans)->base_params->num_of_queues) - 1) &\
+	(((1<<trans->cfg->base_params->num_of_queues) - 1) &\
 	(~(1<<(trans_pcie)->cmd_queue)))
 
 static int iwl_trans_rx_alloc(struct iwl_trans *trans)
@@ -522,7 +522,7 @@ static void iwl_trans_pcie_tx_free(struct iwl_trans *trans)
 	/* Tx queues */
 	if (trans_pcie->txq) {
 		for (txq_id = 0;
-		     txq_id < cfg(trans)->base_params->num_of_queues; txq_id++)
+		     txq_id < trans->cfg->base_params->num_of_queues; txq_id++)
 			iwl_tx_queue_free(trans, txq_id);
 	}
 
@@ -547,7 +547,7 @@ static int iwl_trans_tx_alloc(struct iwl_trans *trans)
 	int txq_id, slots_num;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	u16 scd_bc_tbls_size = cfg(trans)->base_params->num_of_queues *
+	u16 scd_bc_tbls_size = trans->cfg->base_params->num_of_queues *
 			sizeof(struct iwlagn_scd_bc_tbl);
 
 	/*It is not allowed to alloc twice, so warn when this happens.
@@ -571,7 +571,7 @@ static int iwl_trans_tx_alloc(struct iwl_trans *trans)
 		goto error;
 	}
 
-	trans_pcie->txq = kcalloc(cfg(trans)->base_params->num_of_queues,
+	trans_pcie->txq = kcalloc(trans->cfg->base_params->num_of_queues,
 				  sizeof(struct iwl_tx_queue), GFP_KERNEL);
 	if (!trans_pcie->txq) {
 		IWL_ERR(trans, "Not enough memory for txq\n");
@@ -580,7 +580,7 @@ static int iwl_trans_tx_alloc(struct iwl_trans *trans)
 	}
 
 	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
-	for (txq_id = 0; txq_id < cfg(trans)->base_params->num_of_queues;
+	for (txq_id = 0; txq_id < trans->cfg->base_params->num_of_queues;
 	     txq_id++) {
 		slots_num = (txq_id == trans_pcie->cmd_queue) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
@@ -626,7 +626,7 @@ static int iwl_tx_init(struct iwl_trans *trans)
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
 	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
-	for (txq_id = 0; txq_id < cfg(trans)->base_params->num_of_queues;
+	for (txq_id = 0; txq_id < trans->cfg->base_params->num_of_queues;
 	     txq_id++) {
 		slots_num = (txq_id == trans_pcie->cmd_queue) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
@@ -749,9 +749,9 @@ static int iwl_apm_init(struct iwl_trans *trans)
 	iwl_apm_config(trans);
 
 	/* Configure analog phase-lock-loop before activating to D0A */
-	if (cfg(trans)->base_params->pll_cfg_val)
+	if (trans->cfg->base_params->pll_cfg_val)
 		iwl_set_bit(trans, CSR_ANA_PLL_CFG,
-			    cfg(trans)->base_params->pll_cfg_val);
+			    trans->cfg->base_params->pll_cfg_val);
 
 	/*
 	 * Set "initialization complete" bit to move adapter from
@@ -861,7 +861,7 @@ static int iwl_nic_init(struct iwl_trans *trans)
 	if (iwl_tx_init(trans))
 		return -ENOMEM;
 
-	if (cfg(trans)->base_params->shadow_reg_enable) {
+	if (trans->cfg->base_params->shadow_reg_enable) {
 		/* enable shadow regs in HW */
 		iwl_set_bit(trans, CSR_MAC_SHADOW_REG_CTRL,
 			0x800FFFFF);
@@ -1080,7 +1080,7 @@ static void iwl_tx_start(struct iwl_trans *trans)
 		iwl_write_targ_mem(trans, a, 0);
 	for (; a < trans_pcie->scd_base_addr +
 	       SCD_TRANS_TBL_OFFSET_QUEUE(
-				cfg(trans)->base_params->num_of_queues);
+				trans->cfg->base_params->num_of_queues);
 	       a += 4)
 		iwl_write_targ_mem(trans, a, 0);
 
@@ -1103,7 +1103,7 @@ static void iwl_tx_start(struct iwl_trans *trans)
 	iwl_write_prph(trans, SCD_AGGR_SEL, 0);
 
 	/* initiate the queues */
-	for (i = 0; i < cfg(trans)->base_params->num_of_queues; i++) {
+	for (i = 0; i < trans->cfg->base_params->num_of_queues; i++) {
 		iwl_write_prph(trans, SCD_QUEUE_RDPTR(i), 0);
 		iwl_write_direct32(trans, HBUS_TARG_WRPTR, 0 | (i << 8));
 		iwl_write_targ_mem(trans, trans_pcie->scd_base_addr +
@@ -1120,7 +1120,7 @@ static void iwl_tx_start(struct iwl_trans *trans)
 	}
 
 	iwl_write_prph(trans, SCD_INTERRUPT_MASK,
-			IWL_MASK(0, cfg(trans)->base_params->num_of_queues));
+			IWL_MASK(0, trans->cfg->base_params->num_of_queues));
 
 	/* Activate all Tx DMA/FIFO channels */
 	iwl_trans_txq_set_sched(trans, IWL_MASK(0, 7));
@@ -1188,7 +1188,7 @@ static int iwl_trans_tx_stop(struct iwl_trans *trans)
 	}
 
 	/* Unmap DMA from host system and free skb's */
-	for (txq_id = 0; txq_id < cfg(trans)->base_params->num_of_queues;
+	for (txq_id = 0; txq_id < trans->cfg->base_params->num_of_queues;
 	     txq_id++)
 		iwl_tx_queue_unmap(trans, txq_id);
 
@@ -1617,7 +1617,7 @@ static int iwl_trans_pcie_wait_tx_queue_empty(struct iwl_trans *trans)
 	int ret = 0;
 
 	/* waiting for all the tx frames complete might take a while */
-	for (cnt = 0; cnt < cfg(trans)->base_params->num_of_queues; cnt++) {
+	for (cnt = 0; cnt < trans->cfg->base_params->num_of_queues; cnt++) {
 		if (cnt == trans_pcie->cmd_queue)
 			continue;
 		txq = &trans_pcie->txq[cnt];
@@ -1829,7 +1829,7 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 	int ret;
 	size_t bufsz;
 
-	bufsz = sizeof(char) * 64 * cfg(trans)->base_params->num_of_queues;
+	bufsz = sizeof(char) * 64 * trans->cfg->base_params->num_of_queues;
 
 	if (!trans_pcie->txq) {
 		IWL_ERR(trans, "txq not ready\n");
@@ -1839,7 +1839,7 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 	if (!buf)
 		return -ENOMEM;
 
-	for (cnt = 0; cnt < cfg(trans)->base_params->num_of_queues; cnt++) {
+	for (cnt = 0; cnt < trans->cfg->base_params->num_of_queues; cnt++) {
 		txq = &trans_pcie->txq[cnt];
 		q = &txq->q;
 		pos += scnprintf(buf + pos, bufsz - pos,
@@ -2085,7 +2085,8 @@ const struct iwl_trans_ops trans_ops_pcie = {
 
 struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
 				       struct pci_dev *pdev,
-				       const struct pci_device_id *ent)
+				       const struct pci_device_id *ent,
+				       const struct iwl_cfg *cfg)
 {
 	struct iwl_trans_pcie *trans_pcie;
 	struct iwl_trans *trans;
@@ -2102,6 +2103,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
 
 	trans->ops = &trans_ops_pcie;
 	trans->shrd = shrd;
+	trans->cfg = cfg;
 	trans_pcie->trans = trans;
 	spin_lock_init(&trans_pcie->irq_lock);
 	init_waitqueue_head(&trans_pcie->ucode_write_waitq);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index f3496a0..80e3399 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -429,6 +429,7 @@ enum iwl_trans_state {
  * @ops - pointer to iwl_trans_ops
  * @op_mode - pointer to the op_mode
  * @shrd - pointer to iwl_shared which holds shared data from the upper layer
+ * @cfg - pointer to the configuration
  * @reg_lock - protect hw register access
  * @dev - pointer to struct device * that represents the device
  * @hw_id: a u32 with the ID of the device / subdevice.
@@ -441,6 +442,7 @@ struct iwl_trans {
 	const struct iwl_trans_ops *ops;
 	struct iwl_op_mode *op_mode;
 	struct iwl_shared *shrd;
+	const struct iwl_cfg *cfg;
 	enum iwl_trans_state state;
 	spinlock_t reg_lock;
 
@@ -625,12 +627,14 @@ struct pci_device_id;
 extern const struct iwl_trans_ops trans_ops_pcie;
 struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
 				       struct pci_dev *pdev,
-				       const struct pci_device_id *ent);
+				       const struct pci_device_id *ent,
+				       const struct iwl_cfg *cfg);
 int __must_check iwl_pci_register_driver(void);
 void iwl_pci_unregister_driver(void);
 
 extern const struct iwl_trans_ops trans_ops_idi;
 struct iwl_trans *iwl_trans_idi_alloc(struct iwl_shared *shrd,
 				      void *pdev_void,
-				      const void *ent_void);
+				      const void *ent_void,
+				      const struct iwl_cfg *cfg);
 #endif /* __iwl_trans_h__ */
-- 
1.7.0.4

