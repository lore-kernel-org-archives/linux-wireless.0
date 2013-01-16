Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37680 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab3APN6R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 08:58:17 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/6] iwlwifi: enable communication with WoWLAN firmware
Date: Wed, 16 Jan 2013 14:58:38 +0100
Message-Id: <1358344719-26486-5-git-send-email-johannes@sipsolutions.net> (sfid-20130116_145826_775277_1CE44C64)
In-Reply-To: <1358344719-26486-1-git-send-email-johannes@sipsolutions.net>
References: <1358344682.22862.4.camel@jlt4.sipsolutions.net>
 <1358344719-26486-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

On resuming, the opmode may have to be able to talk
to the WoWLAN/D3 firmware in order to query it about
its status and wakeup reasons. To do that, the opmode
has to call the new d3_resume() transport API which
will set up the device for command communcation.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c  |  5 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h        |  4 ++
 drivers/net/wireless/iwlwifi/iwl-trans.h     | 29 +++++++--
 drivers/net/wireless/iwlwifi/pcie/internal.h |  2 +
 drivers/net/wireless/iwlwifi/pcie/rx.c       |  6 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c    | 91 ++++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/pcie/tx.c       | 23 +++++++
 7 files changed, 136 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 1ed4bc6..fef17c1 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -206,7 +206,8 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 
 #ifdef CONFIG_PM_SLEEP
 	if (priv->fw->img[IWL_UCODE_WOWLAN].sec[0].len &&
-	    priv->trans->ops->wowlan_suspend &&
+	    priv->trans->ops->d3_suspend &&
+	    priv->trans->ops->d3_resume &&
 	    device_can_wakeup(priv->trans->dev)) {
 		hw->wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
 					  WIPHY_WOWLAN_DISCONNECT |
@@ -426,7 +427,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 	if (ret)
 		goto error;
 
-	iwl_trans_wowlan_suspend(priv->trans);
+	iwl_trans_d3_suspend(priv->trans);
 
 	goto out;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index ec48563..c646a90 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -225,6 +225,8 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(unsigned int chnl)
 #define FH_RSCSR_CHNL0_RBDCB_WPTR_REG	(FH_MEM_RSCSR_CHNL0 + 0x008)
 #define FH_RSCSR_CHNL0_WPTR        (FH_RSCSR_CHNL0_RBDCB_WPTR_REG)
 
+#define FW_RSCSR_CHNL0_RXDCB_RDPTR_REG	(FH_MEM_RSCSR_CHNL0 + 0x00c)
+#define FH_RSCSR_CHNL0_RDPTR		FW_RSCSR_CHNL0_RXDCB_RDPTR_REG
 
 /**
  * Rx Config/Status Registers (RCSR)
@@ -257,6 +259,8 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(unsigned int chnl)
 #define FH_MEM_RCSR_CHNL0            (FH_MEM_RCSR_LOWER_BOUND)
 
 #define FH_MEM_RCSR_CHNL0_CONFIG_REG	(FH_MEM_RCSR_CHNL0)
+#define FH_MEM_RCSR_CHNL0_RBDCB_WPTR	(FH_MEM_RCSR_CHNL0 + 0x8)
+#define FH_MEM_RCSR_CHNL0_FLUSH_RB_REQ	(FH_MEM_RCSR_CHNL0 + 0x10)
 
 #define FH_RCSR_CHNL0_RX_CONFIG_RB_TIMEOUT_MSK (0x00000FF0) /* bits 4-11 */
 #define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_MSK   (0x00001000) /* bits 12 */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 55a140a..0f85eb3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -308,6 +308,16 @@ static inline struct page *rxb_steal_page(struct iwl_rx_cmd_buffer *r)
 #define IWL_FRAME_LIMIT	64
 
 /**
+ * enum iwl_wowlan_status - WoWLAN image/device status
+ * @IWL_D3_STATUS_ALIVE: firmware is still running after resume
+ * @IWL_D3_STATUS_RESET: device was reset while suspended
+ */
+enum iwl_d3_status {
+	IWL_D3_STATUS_ALIVE,
+	IWL_D3_STATUS_RESET,
+};
+
+/**
  * struct iwl_trans_config - transport configuration
  *
  * @op_mode: pointer to the upper layer.
@@ -363,9 +373,12 @@ struct iwl_trans;
  *	May sleep
  * @stop_device:stops the whole device (embedded CPU put to reset)
  *	May sleep
- * @wowlan_suspend: put the device into the correct mode for WoWLAN during
+ * @d3_suspend: put the device into the correct mode for WoWLAN during
  *	suspend. This is optional, if not implemented WoWLAN will not be
  *	supported. This callback may sleep.
+ * @d3_resume: resume the device after WoWLAN, enabling the opmode to
+ *	talk to the WoWLAN image to get its status. This is optional, if not
+ *	implemented WoWLAN will not be supported. This callback may sleep.
  * @send_cmd:send a host command. Must return -ERFKILL if RFkill is asserted.
  *	If RFkill is asserted in the middle of a SYNC host command, it must
  *	return -ERFKILL straight away.
@@ -409,7 +422,8 @@ struct iwl_trans_ops {
 	void (*fw_alive)(struct iwl_trans *trans, u32 scd_addr);
 	void (*stop_device)(struct iwl_trans *trans);
 
-	void (*wowlan_suspend)(struct iwl_trans *trans);
+	void (*d3_suspend)(struct iwl_trans *trans);
+	int (*d3_resume)(struct iwl_trans *trans, enum iwl_d3_status *status);
 
 	int (*send_cmd)(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
 
@@ -562,10 +576,17 @@ static inline void iwl_trans_stop_device(struct iwl_trans *trans)
 	trans->state = IWL_TRANS_NO_FW;
 }
 
-static inline void iwl_trans_wowlan_suspend(struct iwl_trans *trans)
+static inline void iwl_trans_d3_suspend(struct iwl_trans *trans)
+{
+	might_sleep();
+	trans->ops->d3_suspend(trans);
+}
+
+static inline int iwl_trans_d3_resume(struct iwl_trans *trans,
+				      enum iwl_d3_status *status)
 {
 	might_sleep();
-	trans->ops->wowlan_suspend(trans);
+	return trans->ops->d3_resume(trans, status);
 }
 
 static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 8f017c3..20735a0 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -357,6 +357,8 @@ void iwl_pcie_hcmd_complete(struct iwl_trans *trans,
 			    struct iwl_rx_cmd_buffer *rxb, int handler_status);
 void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 			    struct sk_buff_head *skbs);
+void iwl_trans_pcie_tx_reset(struct iwl_trans *trans);
+
 /*****************************************************
 * Error handling
 ******************************************************/
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index ea9e991..9601303 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -455,6 +455,10 @@ static void iwl_pcie_rx_hw_init(struct iwl_trans *trans, struct iwl_rxq *rxq)
 
 	/* Stop Rx DMA */
 	iwl_write_direct32(trans, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+	/* reset and flush pointers */
+	iwl_write_direct32(trans, FH_MEM_RCSR_CHNL0_RBDCB_WPTR, 0);
+	iwl_write_direct32(trans, FH_MEM_RCSR_CHNL0_FLUSH_RB_REQ, 0);
+	iwl_write_direct32(trans, FH_RSCSR_CHNL0_RDPTR, 0);
 
 	/* Reset driver's Rx queue write index */
 	iwl_write_direct32(trans, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
@@ -491,7 +495,6 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *rxq = &trans_pcie->rxq;
-
 	int i, err;
 	unsigned long flags;
 
@@ -518,6 +521,7 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 	rxq->read = rxq->write = 0;
 	rxq->write_actual = 0;
 	rxq->free_count = 0;
+	memset(rxq->rb_stts, 0, sizeof(*rxq->rb_stts));
 	spin_unlock_irqrestore(&rxq->lock, flags);
 
 	iwl_pcie_rx_replenish(trans);
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 4028c03..59340ff 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -75,21 +75,16 @@
 #include "iwl-agn-hw.h"
 #include "internal.h"
 
-static void iwl_pcie_set_pwr_vmain(struct iwl_trans *trans)
+static void iwl_pcie_set_pwr(struct iwl_trans *trans, bool vaux)
 {
-/*
- * (for documentation purposes)
- * to set power to V_AUX, do:
-
-		if (pci_pme_capable(priv->pci_dev, PCI_D3cold))
-			iwl_set_bits_mask_prph(trans, APMG_PS_CTRL_REG,
-					       APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
-					       ~APMG_PS_CTRL_MSK_PWR_SRC);
- */
-
-	iwl_set_bits_mask_prph(trans, APMG_PS_CTRL_REG,
-			       APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
-			       ~APMG_PS_CTRL_MSK_PWR_SRC);
+	if (vaux && pci_pme_capable(to_pci_dev(trans->dev), PCI_D3cold))
+		iwl_set_bits_mask_prph(trans, APMG_PS_CTRL_REG,
+				       APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
+				       ~APMG_PS_CTRL_MSK_PWR_SRC);
+	else
+		iwl_set_bits_mask_prph(trans, APMG_PS_CTRL_REG,
+				       APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
+				       ~APMG_PS_CTRL_MSK_PWR_SRC);
 }
 
 /* PCI registers */
@@ -259,7 +254,7 @@ static int iwl_pcie_nic_init(struct iwl_trans *trans)
 
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
-	iwl_pcie_set_pwr_vmain(trans);
+	iwl_pcie_set_pwr(trans, false);
 
 	iwl_op_mode_nic_config(trans->op_mode);
 
@@ -545,15 +540,76 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	clear_bit(STATUS_RFKILL, &trans_pcie->status);
 }
 
-static void iwl_trans_pcie_wowlan_suspend(struct iwl_trans *trans)
+static void iwl_trans_pcie_d3_suspend(struct iwl_trans *trans)
 {
 	/* let the ucode operate on its own */
 	iwl_write32(trans, CSR_UCODE_DRV_GP1_SET,
 		    CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
 
 	iwl_disable_interrupts(trans);
+	iwl_pcie_disable_ict(trans);
+
 	iwl_clear_bit(trans, CSR_GP_CNTRL,
 		      CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	iwl_clear_bit(trans, CSR_GP_CNTRL,
+		      CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+
+	/*
+	 * reset TX queues -- some of their registers reset during S3
+	 * so if we don't reset everything here the D3 image would try
+	 * to execute some invalid memory upon resume
+	 */
+	iwl_trans_pcie_tx_reset(trans);
+
+	iwl_pcie_set_pwr(trans, true);
+}
+
+static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
+				    enum iwl_d3_status *status)
+{
+	u32 val;
+	int ret;
+
+	iwl_pcie_set_pwr(trans, false);
+
+	val = iwl_read32(trans, CSR_RESET);
+	if (val & CSR_RESET_REG_FLAG_NEVO_RESET) {
+		*status = IWL_D3_STATUS_RESET;
+		return 0;
+	}
+
+	/*
+	 * Also enables interrupts - none will happen as the device doesn't
+	 * know we're waking it up, only when the opmode actually tells it
+	 * after this call.
+	 */
+	iwl_pcie_reset_ict(trans);
+
+	iwl_set_bit(trans, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	iwl_set_bit(trans, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+
+	ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
+			   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+			   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+			   25000);
+	if (ret) {
+		IWL_ERR(trans, "Failed to resume the device (mac ready)\n");
+		return ret;
+	}
+
+	iwl_trans_pcie_tx_reset(trans);
+
+	ret = iwl_pcie_rx_init(trans);
+	if (ret) {
+		IWL_ERR(trans, "Failed to resume the device (RX reset)\n");
+		return ret;
+	}
+
+	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR,
+		    CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
+
+	*status = IWL_D3_STATUS_ALIVE;
+	return 0;
 }
 
 static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
@@ -1279,7 +1335,8 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 	.start_fw = iwl_trans_pcie_start_fw,
 	.stop_device = iwl_trans_pcie_stop_device,
 
-	.wowlan_suspend = iwl_trans_pcie_wowlan_suspend,
+	.d3_suspend = iwl_trans_pcie_d3_suspend,
+	.d3_resume = iwl_trans_pcie_d3_resume,
 
 	.send_cmd = iwl_trans_pcie_send_hcmd,
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index d3c4e8f..fd3280f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -692,6 +692,29 @@ void iwl_pcie_tx_start(struct iwl_trans *trans, u32 scd_base_addr)
 			    APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 }
 
+void iwl_trans_pcie_tx_reset(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int txq_id;
+
+	for (txq_id = 0; txq_id < trans->cfg->base_params->num_of_queues;
+	     txq_id++) {
+		struct iwl_txq *txq = &trans_pcie->txq[txq_id];
+
+		iwl_write_direct32(trans, FH_MEM_CBBC_QUEUE(txq_id),
+				   txq->q.dma_addr >> 8);
+		iwl_pcie_txq_unmap(trans, txq_id);
+		txq->q.read_ptr = 0;
+		txq->q.write_ptr = 0;
+	}
+
+	/* Tell NIC where to find the "keep warm" buffer */
+	iwl_write_direct32(trans, FH_KW_MEM_ADDR_REG,
+			   trans_pcie->kw.dma >> 4);
+
+	iwl_pcie_tx_start(trans, trans_pcie->scd_base_addr);
+}
+
 /*
  * iwl_pcie_tx_stop - Stop all Tx DMA channels
  */
-- 
1.8.0

