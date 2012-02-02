Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37622 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab2BCAQx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:53 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/28] iwlwifi: introduce trans_ops->stop_hw
Date: Thu,  2 Feb 2012 15:09:05 -0800
Message-Id: <1328224159-18134-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011756_952369_54BC90A4)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This handler stops the HW and puts it in low power state.
It will allow to clean up the flows in the upper layers.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c       |   40 ------------------
 drivers/net/wireless/iwlwifi/iwl-shared.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   54 ++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-trans.h      |    8 ++++
 5 files changed, 61 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3aeaa89..8846246 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1839,7 +1839,7 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	/* Read the EEPROM */
 	err = iwl_eeprom_init(priv, hw_rev);
 	/* Reset chip to save power until we load uCode during "up". */
-	iwl_apm_stop(priv);
+	iwl_trans_stop_hw(trans(priv));
 	if (err) {
 		IWL_ERR(priv, "Unable to init EEPROM\n");
 		goto out_free_traffic_mem;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 3ba59fa..95f2c33 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -883,46 +883,6 @@ void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 	}
 }
 
-static int iwl_apm_stop_master(struct iwl_priv *priv)
-{
-	int ret = 0;
-
-	/* stop device's busmaster DMA activity */
-	iwl_set_bit(trans(priv), CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
-
-	ret = iwl_poll_bit(trans(priv), CSR_RESET,
-			CSR_RESET_REG_FLAG_MASTER_DISABLED,
-			CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
-	if (ret)
-		IWL_WARN(priv, "Master Disable Timed Out, 100 usec\n");
-
-	IWL_DEBUG_INFO(priv, "stop master\n");
-
-	return ret;
-}
-
-void iwl_apm_stop(struct iwl_priv *priv)
-{
-	IWL_DEBUG_INFO(priv, "Stop card, put in low power state\n");
-
-	clear_bit(STATUS_DEVICE_ENABLED, &priv->shrd->status);
-
-	/* Stop device's DMA activity */
-	iwl_apm_stop_master(priv);
-
-	/* Reset the entire device */
-	iwl_set_bit(trans(priv), CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
-
-	udelay(10);
-
-	/*
-	 * Clear "initialization complete" bit to move adapter from
-	 * D0A* (powered-up Active) --> D0U* (Uninitialized) state.
-	 */
-	iwl_clear_bit(trans(priv), CSR_GP_CNTRL,
-		      CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-}
-
 int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 {
 	int ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 338a55f..63d4a4f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -543,7 +543,6 @@ int iwlagn_hw_valid_rtc_data_addr(u32 addr);
 void iwl_set_hw_rfkill_state(struct iwl_priv *priv, bool state);
 void iwl_nic_config(struct iwl_priv *priv);
 void iwl_free_skb(struct iwl_priv *priv, struct sk_buff *skb);
-void iwl_apm_stop(struct iwl_priv *priv);
 void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand);
 const char *get_cmd_string(u8 cmd);
 bool iwl_check_for_ct_kill(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 335d4b1..43e894f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -714,6 +714,46 @@ out:
 	return ret;
 }
 
+static int iwl_apm_stop_master(struct iwl_trans *trans)
+{
+	int ret = 0;
+
+	/* stop device's busmaster DMA activity */
+	iwl_set_bit(trans, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
+
+	ret = iwl_poll_bit(trans, CSR_RESET,
+			CSR_RESET_REG_FLAG_MASTER_DISABLED,
+			CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
+	if (ret)
+		IWL_WARN(trans, "Master Disable Timed Out, 100 usec\n");
+
+	IWL_DEBUG_INFO(trans, "stop master\n");
+
+	return ret;
+}
+
+static void iwl_apm_stop(struct iwl_trans *trans)
+{
+	IWL_DEBUG_INFO(trans, "Stop card, put in low power state\n");
+
+	clear_bit(STATUS_DEVICE_ENABLED, &trans->shrd->status);
+
+	/* Stop device's DMA activity */
+	iwl_apm_stop_master(trans);
+
+	/* Reset the entire device */
+	iwl_set_bit(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+
+	udelay(10);
+
+	/*
+	 * Clear "initialization complete" bit to move adapter from
+	 * D0A* (powered-up Active) --> D0U* (Uninitialized) state.
+	 */
+	iwl_clear_bit(trans, CSR_GP_CNTRL,
+		      CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+}
+
 static int iwl_nic_init(struct iwl_trans *trans)
 {
 	unsigned long flags;
@@ -1118,7 +1158,7 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 
 	/* Stop the device, and put it in low power state */
-	iwl_apm_stop(priv(trans));
+	iwl_apm_stop(trans);
 
 	/* Upon stop, the APM issues an interrupt if HW RF kill is set.
 	 * Clean again the interrupt here
@@ -1361,6 +1401,15 @@ error:
 	return err;
 }
 
+static void iwl_trans_pcie_stop_hw(struct iwl_trans *trans)
+{
+	iwl_apm_stop(trans);
+
+	/* Even if we stop the HW, we still want the RF kill interrupt */
+	IWL_DEBUG_ISR(trans, "Enabling rfkill interrupt\n");
+	iwl_write32(trans, CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
+}
+
 static int iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 		      int txq_id, int ssn, u32 status,
 		      struct sk_buff_head *skbs)
@@ -1455,7 +1504,7 @@ static int iwl_trans_pcie_suspend(struct iwl_trans *trans)
 	 * things already :-)
 	 */
 	if (!trans->shrd->wowlan) {
-		iwl_apm_stop(priv(trans));
+		iwl_apm_stop(trans);
 	} else {
 		iwl_disable_interrupts(trans);
 		iwl_clear_bit(trans, CSR_GP_CNTRL,
@@ -2024,6 +2073,7 @@ static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
 
 const struct iwl_trans_ops trans_ops_pcie = {
 	.start_hw = iwl_trans_pcie_start_hw,
+	.stop_hw = iwl_trans_pcie_stop_hw,
 	.fw_alive = iwl_trans_pcie_fw_alive,
 	.start_device = iwl_trans_pcie_start_device,
 	.stop_device = iwl_trans_pcie_stop_device,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 55b5dc3..d0b6146 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -134,6 +134,8 @@ struct iwl_host_cmd {
 /**
  * struct iwl_trans_ops - transport specific operations
  * @start_hw: starts the HW- from that point on, the HW can send interrupts
+ * @stop_hw: stops the HW- from that point on, the HW will be in low power but
+ *	will still issue interrupt if the HW RF kill is triggered.
  * @start_device: allocates and inits all the resources for the transport
  *                layer.
  * @fw_alive: called when the fw sends alive notification
@@ -163,6 +165,7 @@ struct iwl_host_cmd {
 struct iwl_trans_ops {
 
 	int (*start_hw)(struct iwl_trans *iwl_trans);
+	void (*stop_hw)(struct iwl_trans *iwl_trans);
 	int (*start_device)(struct iwl_trans *trans);
 	void (*fw_alive)(struct iwl_trans *trans);
 	void (*stop_device)(struct iwl_trans *trans);
@@ -271,6 +274,11 @@ static inline int iwl_trans_start_hw(struct iwl_trans *trans)
 	return trans->ops->start_hw(trans);
 }
 
+static inline void iwl_trans_stop_hw(struct iwl_trans *trans)
+{
+	trans->ops->stop_hw(trans);
+}
+
 static inline void iwl_trans_fw_alive(struct iwl_trans *trans)
 {
 	trans->ops->fw_alive(trans);
-- 
1.7.0.4

