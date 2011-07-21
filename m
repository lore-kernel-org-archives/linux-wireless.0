Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32866 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab1GUP0p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:45 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/25] iwlagn: move more functions from the start flow to the transport layer
Date: Thu, 21 Jul 2011 07:50:12 -0700
Message-Id: <1311259828-8415-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172734_792452_D0D5941A)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Basically all the nic_init flow should be in the transport layer.
iwl_prepare_card_hw will move to the transport too in a separate patch.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |  102 --------------
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c           |   49 -------
 drivers/net/wireless/iwlwifi/iwl-agn.h           |    5 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h           |   16 +--
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c |   12 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c         |  164 ++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-trans.h         |   21 +--
 8 files changed, 178 insertions(+), 193 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 339a89c..6ed0eae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -606,59 +606,6 @@ struct iwl_mod_params iwlagn_mod_params = {
 	/* the rest are 0 by default */
 };
 
-static void iwlagn_set_pwr_vmain(struct iwl_priv *priv)
-{
-/*
- * (for documentation purposes)
- * to set power to V_AUX, do:
-
-		if (pci_pme_capable(priv->pci_dev, PCI_D3cold))
-			iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
-					       APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
-					       ~APMG_PS_CTRL_MSK_PWR_SRC);
- */
-
-	iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
-			       APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
-			       ~APMG_PS_CTRL_MSK_PWR_SRC);
-}
-
-/*TODO: this function should move to transport layer */
-int iwlagn_hw_nic_init(struct iwl_priv *priv)
-{
-	unsigned long flags;
-
-	/* nic_init */
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl_apm_init(priv);
-
-	/* Set interrupt coalescing calibration timer to default (512 usecs) */
-	iwl_write8(priv, CSR_INT_COALESCING, IWL_HOST_INT_CALIB_TIMEOUT_DEF);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	iwlagn_set_pwr_vmain(priv);
-
-	priv->cfg->lib->nic_config(priv);
-
-	/* Allocate the RX queue, or reset if it is already allocated */
-	trans_rx_init(priv);
-
-	/* Allocate or reset and init all Tx and Command queues */
-	if (trans_tx_init(priv))
-		return -ENOMEM;
-
-	if (priv->cfg->base_params->shadow_reg_enable) {
-		/* enable shadow regs in HW */
-		iwl_set_bit(priv, CSR_MAC_SHADOW_REG_CTRL,
-			0x800FFFFF);
-	}
-
-	set_bit(STATUS_INIT, &priv->status);
-
-	return 0;
-}
-
 int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band)
 {
 	int idx = 0;
@@ -2092,52 +2039,3 @@ void iwlagn_remove_notification(struct iwl_priv *priv,
 	list_del(&wait_entry->list);
 	spin_unlock_bh(&priv->_agn.notif_wait_lock);
 }
-
-int iwlagn_start_device(struct iwl_priv *priv)
-{
-	int ret;
-
-	priv->ucode_owner = IWL_OWNERSHIP_DRIVER;
-
-	if ((priv->cfg->sku & EEPROM_SKU_CAP_AMT_ENABLE) &&
-	     iwl_prepare_card_hw(priv)) {
-		IWL_WARN(priv, "Exit HW not ready\n");
-		return -EIO;
-	}
-
-	/* If platform's RF_KILL switch is NOT set to KILL */
-	if (iwl_read32(priv, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
-		clear_bit(STATUS_RF_KILL_HW, &priv->status);
-	else
-		set_bit(STATUS_RF_KILL_HW, &priv->status);
-
-	if (iwl_is_rfkill(priv)) {
-		wiphy_rfkill_set_hw_state(priv->hw->wiphy, true);
-		iwl_enable_interrupts(priv);
-		return -ERFKILL;
-	}
-
-	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
-
-	ret = iwlagn_hw_nic_init(priv);
-	if (ret) {
-		IWL_ERR(priv, "Unable to init nic\n");
-		return ret;
-	}
-
-	/* make sure rfkill handshake bits are cleared */
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
-		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
-
-	/* clear (again), then enable host interrupts */
-	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
-	iwl_enable_interrupts(priv);
-
-	/* really make sure rfkill handshake bits are cleared */
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-
-	return 0;
-}
-
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 667cfb7..e4b2f78 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -478,7 +478,7 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 	int ret;
 	enum iwlagn_ucode_type old_type;
 
-	ret = iwlagn_start_device(priv);
+	ret = trans_start_device(priv);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 9ba5fcd..d0f6875 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1798,55 +1798,6 @@ static void iwl_down(struct iwl_priv *priv)
 	iwl_cancel_deferred_work(priv);
 }
 
-#define HW_READY_TIMEOUT (50)
-
-/* Note: returns poll_bit return value, which is >= 0 if success */
-static int iwl_set_hw_ready(struct iwl_priv *priv)
-{
-	int ret;
-
-	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-		CSR_HW_IF_CONFIG_REG_BIT_NIC_READY);
-
-	/* See if we got it */
-	ret = iwl_poll_bit(priv, CSR_HW_IF_CONFIG_REG,
-				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
-				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
-				HW_READY_TIMEOUT);
-
-	IWL_DEBUG_INFO(priv, "hardware%s ready\n", ret < 0 ? " not" : "");
-	return ret;
-}
-
-/* Note: returns standard 0/-ERROR code */
-int iwl_prepare_card_hw(struct iwl_priv *priv)
-{
-	int ret;
-
-	IWL_DEBUG_INFO(priv, "iwl_prepare_card_hw enter\n");
-
-	ret = iwl_set_hw_ready(priv);
-	if (ret >= 0)
-		return 0;
-
-	/* If HW is not ready, prepare the conditions to check again */
-	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-			CSR_HW_IF_CONFIG_REG_PREPARE);
-
-	ret = iwl_poll_bit(priv, CSR_HW_IF_CONFIG_REG,
-			~CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE,
-			CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE, 150000);
-
-	if (ret < 0)
-		return ret;
-
-	/* HW should be ready by now, check again. */
-	ret = iwl_set_hw_ready(priv);
-	if (ret >= 0)
-		return 0;
-	return ret;
-}
-
 #define MAX_HW_RESTARTS 5
 
 static int __iwl_up(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 0a8417a..ffb6bd2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -122,12 +122,10 @@ static inline void iwl_set_calib_hdr(struct iwl_calib_hdr *hdr, u8 cmd)
 	hdr->data_valid = 1;
 }
 
+/* TODO: this one should be API of the transport layer */
 int iwl_prepare_card_hw(struct iwl_priv *priv);
 
-int iwlagn_start_device(struct iwl_priv *priv);
-
 /* tx queue */
-/*TODO: this one should go to transport layer */
 void iwl_free_tfds_in_queue(struct iwl_priv *priv,
 			    int sta_id, int tid, int freed);
 
@@ -158,7 +156,6 @@ int iwlagn_hw_valid_rtc_data_addr(u32 addr);
 int iwlagn_send_tx_power(struct iwl_priv *priv);
 void iwlagn_temperature(struct iwl_priv *priv);
 u16 iwlagn_eeprom_calib_version(struct iwl_priv *priv);
-int iwlagn_hw_nic_init(struct iwl_priv *priv);
 int iwlagn_wait_tx_queue_empty(struct iwl_priv *priv);
 int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
 void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index b18a9a8..ca15434 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1234,13 +1234,13 @@ struct iwl_trans;
 
 /**
  * struct iwl_trans_ops - transport specific operations
- * @rx_init: inits the rx memory, allocate it if needed
- * @rx_free: frees the rx memory
- * @tx_init:inits the tx memory, allocate if needed
+ * @start_device: allocates and inits all the resources for the transport
+ *                layer.
  * @tx_start: starts and configures all the Tx fifo - usually done once the fw
  *           is alive.
- * @tx_free: frees the tx memory
  * @stop_device:stops the whole device (embedded CPU put to reset)
+ * @rx_free: frees the rx memory
+ * @tx_free: frees the tx memory
  * @send_cmd:send a host command
  * @send_cmd_pdu:send a host command: flags can be CMD_*
  * @get_tx_cmd: returns a pointer to a new Tx cmd for the upper layer use
@@ -1257,14 +1257,12 @@ struct iwl_trans;
  *        irq, tasklet etc...
  */
 struct iwl_trans_ops {
-	int (*rx_init)(struct iwl_priv *priv);
-	void (*rx_free)(struct iwl_priv *priv);
 
-	int (*tx_init)(struct iwl_priv *priv);
+	int (*start_device)(struct iwl_priv *priv);
+	void (*stop_device)(struct iwl_priv *priv);
 	void (*tx_start)(struct iwl_priv *priv);
 	void (*tx_free)(struct iwl_priv *priv);
-
-	void (*stop_device)(struct iwl_priv *priv);
+	void (*rx_free)(struct iwl_priv *priv);
 
 	int (*send_cmd)(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 9cecb10..7dac6ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -35,15 +35,9 @@
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
-#include "iwl-sta.h"
 #include "iwl-helpers.h"
 #include "iwl-trans-int-pcie.h"
 
-/* TODO:this file should _not_ include the external API header file
- * (iwl-trans.h). This is needed as a W/A until reclaim functions will move to
- * the transport layer */
-#include "iwl-trans.h"
-
 /**
  * iwl_trans_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
  */
@@ -339,7 +333,11 @@ int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 }
 
 /*TODO: this functions should NOT be exported from trans module - export it
- * until the reclaim flow will be brought to the transport module too */
+ * until the reclaim flow will be brought to the transport module too.
+ * Add a declaration to make sparse happy */
+void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
+					  struct iwl_tx_queue *txq);
+
 void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
 					  struct iwl_tx_queue *txq)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index bddc12d..e9c7de9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -177,7 +177,7 @@ static void iwl_trans_rx_hw_init(struct iwl_priv *priv,
 	iwl_write8(priv, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
 }
 
-static int iwl_trans_rx_init(struct iwl_priv *priv)
+static int iwl_rx_init(struct iwl_priv *priv)
 {
 	struct iwl_rx_queue *rxq = &priv->rxq;
 	int i, err;
@@ -530,7 +530,7 @@ error:
 
 	return ret;
 }
-static int iwl_trans_tx_init(struct iwl_priv *priv)
+static int iwl_tx_init(struct iwl_priv *priv)
 {
 	int ret;
 	int txq_id, slots_num;
@@ -574,6 +574,156 @@ error:
 	return ret;
 }
 
+static void iwl_set_pwr_vmain(struct iwl_priv *priv)
+{
+/*
+ * (for documentation purposes)
+ * to set power to V_AUX, do:
+
+		if (pci_pme_capable(priv->pci_dev, PCI_D3cold))
+			iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
+					       APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
+					       ~APMG_PS_CTRL_MSK_PWR_SRC);
+ */
+
+	iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
+			       APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
+			       ~APMG_PS_CTRL_MSK_PWR_SRC);
+}
+
+static int iwl_nic_init(struct iwl_priv *priv)
+{
+	unsigned long flags;
+
+	/* nic_init */
+	spin_lock_irqsave(&priv->lock, flags);
+	iwl_apm_init(priv);
+
+	/* Set interrupt coalescing calibration timer to default (512 usecs) */
+	iwl_write8(priv, CSR_INT_COALESCING, IWL_HOST_INT_CALIB_TIMEOUT_DEF);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	iwl_set_pwr_vmain(priv);
+
+	priv->cfg->lib->nic_config(priv);
+
+	/* Allocate the RX queue, or reset if it is already allocated */
+	iwl_rx_init(priv);
+
+	/* Allocate or reset and init all Tx and Command queues */
+	if (iwl_tx_init(priv))
+		return -ENOMEM;
+
+	if (priv->cfg->base_params->shadow_reg_enable) {
+		/* enable shadow regs in HW */
+		iwl_set_bit(priv, CSR_MAC_SHADOW_REG_CTRL,
+			0x800FFFFF);
+	}
+
+	set_bit(STATUS_INIT, &priv->status);
+
+	return 0;
+}
+
+#define HW_READY_TIMEOUT (50)
+
+/* Note: returns poll_bit return value, which is >= 0 if success */
+static int iwl_set_hw_ready(struct iwl_priv *priv)
+{
+	int ret;
+
+	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		CSR_HW_IF_CONFIG_REG_BIT_NIC_READY);
+
+	/* See if we got it */
+	ret = iwl_poll_bit(priv, CSR_HW_IF_CONFIG_REG,
+				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
+				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
+				HW_READY_TIMEOUT);
+
+	IWL_DEBUG_INFO(priv, "hardware%s ready\n", ret < 0 ? " not" : "");
+	return ret;
+}
+
+/* Note: returns standard 0/-ERROR code */
+int iwl_prepare_card_hw(struct iwl_priv *priv)
+{
+	int ret;
+
+	IWL_DEBUG_INFO(priv, "iwl_prepare_card_hw enter\n");
+
+	ret = iwl_set_hw_ready(priv);
+	if (ret >= 0)
+		return 0;
+
+	/* If HW is not ready, prepare the conditions to check again */
+	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+			CSR_HW_IF_CONFIG_REG_PREPARE);
+
+	ret = iwl_poll_bit(priv, CSR_HW_IF_CONFIG_REG,
+			~CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE,
+			CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE, 150000);
+
+	if (ret < 0)
+		return ret;
+
+	/* HW should be ready by now, check again. */
+	ret = iwl_set_hw_ready(priv);
+	if (ret >= 0)
+		return 0;
+	return ret;
+}
+
+static int iwl_trans_start_device(struct iwl_priv *priv)
+{
+	int ret;
+
+	priv->ucode_owner = IWL_OWNERSHIP_DRIVER;
+
+	if ((priv->cfg->sku & EEPROM_SKU_CAP_AMT_ENABLE) &&
+	     iwl_prepare_card_hw(priv)) {
+		IWL_WARN(priv, "Exit HW not ready\n");
+		return -EIO;
+	}
+
+	/* If platform's RF_KILL switch is NOT set to KILL */
+	if (iwl_read32(priv, CSR_GP_CNTRL) &
+			CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
+		clear_bit(STATUS_RF_KILL_HW, &priv->status);
+	else
+		set_bit(STATUS_RF_KILL_HW, &priv->status);
+
+	if (iwl_is_rfkill(priv)) {
+		wiphy_rfkill_set_hw_state(priv->hw->wiphy, true);
+		iwl_enable_interrupts(priv);
+		return -ERFKILL;
+	}
+
+	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
+
+	ret = iwl_nic_init(priv);
+	if (ret) {
+		IWL_ERR(priv, "Unable to init nic\n");
+		return ret;
+	}
+
+	/* make sure rfkill handshake bits are cleared */
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
+		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
+
+	/* clear (again), then enable host interrupts */
+	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
+	iwl_enable_interrupts(priv);
+
+	/* really make sure rfkill handshake bits are cleared */
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+
+	return 0;
+}
+
 /*
  * Activate/Deactivate Tx DMA/FIFO channels according tx fifos mask
  * must be called under priv->lock and mac access
@@ -972,14 +1122,12 @@ static void iwl_trans_free(struct iwl_priv *priv)
 }
 
 static const struct iwl_trans_ops trans_ops = {
-	.rx_init = iwl_trans_rx_init,
-	.rx_free = iwl_trans_rx_free,
-
-	.tx_init = iwl_trans_tx_init,
+	.start_device = iwl_trans_start_device,
+	.stop_device = iwl_trans_stop_device,
 	.tx_start = iwl_trans_tx_start,
-	.tx_free = iwl_trans_tx_free,
 
-	.stop_device = iwl_trans_stop_device,
+	.rx_free = iwl_trans_rx_free,
+	.tx_free = iwl_trans_tx_free,
 
 	.send_cmd = iwl_send_cmd,
 	.send_cmd_pdu = iwl_send_cmd_pdu,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 215f4d5..9e801d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -64,19 +64,14 @@
  /*This file includes the declaration that are exported from the transport
  * layer */
 
-static inline int trans_rx_init(struct iwl_priv *priv)
+static inline int trans_start_device(struct iwl_priv *priv)
 {
-	return priv->trans.ops->rx_init(priv);
+	return priv->trans.ops->start_device(priv);
 }
 
-static inline void trans_rx_free(struct iwl_priv *priv)
-{
-	priv->trans.ops->rx_free(priv);
-}
-
-static inline int trans_tx_init(struct iwl_priv *priv)
+static inline void trans_stop_device(struct iwl_priv *priv)
 {
-	return priv->trans.ops->tx_init(priv);
+	priv->trans.ops->stop_device(priv);
 }
 
 static inline void trans_tx_start(struct iwl_priv *priv)
@@ -84,14 +79,14 @@ static inline void trans_tx_start(struct iwl_priv *priv)
 	priv->trans.ops->tx_start(priv);
 }
 
-static inline void trans_tx_free(struct iwl_priv *priv)
+static inline void trans_rx_free(struct iwl_priv *priv)
 {
-	priv->trans.ops->tx_free(priv);
+	priv->trans.ops->rx_free(priv);
 }
 
-static inline void trans_stop_device(struct iwl_priv *priv)
+static inline void trans_tx_free(struct iwl_priv *priv)
 {
-	priv->trans.ops->stop_device(priv);
+	priv->trans.ops->tx_free(priv);
 }
 
 static inline int trans_send_cmd(struct iwl_priv *priv,
-- 
1.7.0.4

