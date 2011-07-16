Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23684 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755460Ab1GPPcM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 11:32:12 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.guy@intel.com>
Subject: [PATCH 16/18] iwlagn: move iwlagn_stop_device to transport layer
Date: Sat, 16 Jul 2011 07:56:37 -0700
Message-Id: <1310828199-18000-18-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110716_173242_975569_B6A889A2)
In-Reply-To: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since iwlagn_stop_device was the only caller to the rx_stop / tx_stop,
these two don't need to be API any more.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |   39 -----------------------
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h       |    7 ++--
 drivers/net/wireless/iwlwifi/iwl-sv-open.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c     |   44 ++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-trans.h     |   13 ++-----
 8 files changed, 52 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 4156316..e06a5c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -2166,42 +2166,3 @@ int iwlagn_start_device(struct iwl_priv *priv)
 	return 0;
 }
 
-void iwlagn_stop_device(struct iwl_priv *priv)
-{
-	unsigned long flags;
-
-	/* stop and reset the on-board processor */
-	iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
-
-	/* tell the device to stop sending interrupts */
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl_disable_interrupts(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-	trans_sync_irq(priv);
-
-	/* device going down, Stop using ICT table */
-	iwl_disable_ict(priv);
-
-	/*
-	 * If a HW restart happens during firmware loading,
-	 * then the firmware loading might call this function
-	 * and later it might be called again due to the
-	 * restart. So don't process again if the device is
-	 * already dead.
-	 */
-	if (test_bit(STATUS_DEVICE_ENABLED, &priv->status)) {
-		trans_tx_stop(priv);
-		trans_rx_stop(priv);
-
-		/* Power-down device's busmaster DMA clocks */
-		iwl_write_prph(priv, APMG_CLK_DIS_REG,
-			       APMG_CLK_VAL_DMA_CLK_RQT);
-		udelay(5);
-	}
-
-	/* Make sure (redundant) we've released our request to stay awake */
-	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-
-	/* Stop the device, and put it in low power state */
-	iwl_apm_stop(priv);
-}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 06304a6..c15a1f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -707,6 +707,6 @@ int iwlagn_run_init_ucode(struct iwl_priv *priv)
 	iwlagn_remove_notification(priv, &calib_wait);
  out:
 	/* Whatever happened, stop the device */
-	iwlagn_stop_device(priv);
+	trans_stop_device(priv);
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index bd85af9..3de90c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1782,7 +1782,7 @@ static void __iwl_down(struct iwl_priv *priv)
 		       test_bit(STATUS_EXIT_PENDING, &priv->status) <<
 				STATUS_EXIT_PENDING;
 
-	iwlagn_stop_device(priv);
+	trans_stop_device(priv);
 
 	dev_kfree_skb(priv->beacon_skb);
 	priv->beacon_skb = NULL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 0c4e145..fa32eb9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -129,7 +129,6 @@ static inline void iwl_set_calib_hdr(struct iwl_calib_hdr *hdr, u8 cmd)
 int iwl_prepare_card_hw(struct iwl_priv *priv);
 
 int iwlagn_start_device(struct iwl_priv *priv);
-void iwlagn_stop_device(struct iwl_priv *priv);
 
 /* tx queue */
 void iwlagn_set_wr_ptrs(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 34625de..cf6f4b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1236,11 +1236,10 @@ struct iwl_trans;
  * struct iwl_trans_ops - transport specific operations
 
  * @rx_init: inits the rx memory, allocate it if needed
- * @rx_stop: stop the rx
  * @rx_free: frees the rx memory
  * @tx_init:inits the tx memory, allocate if needed
- * @tx_stop: stop the tx
  * @tx_free: frees the tx memory
+ * @stop_device:stops the whole device (embedded CPU put to reset)
  * @send_cmd:send a host command
  * @send_cmd_pdu:send a host command: flags can be CMD_*
  * @get_tx_cmd: returns a pointer to a new Tx cmd for the upper layer use
@@ -1254,13 +1253,13 @@ struct iwl_trans;
  */
 struct iwl_trans_ops {
 	int (*rx_init)(struct iwl_priv *priv);
-	int (*rx_stop)(struct iwl_priv *priv);
 	void (*rx_free)(struct iwl_priv *priv);
 
 	int (*tx_init)(struct iwl_priv *priv);
-	int (*tx_stop)(struct iwl_priv *priv);
 	void (*tx_free)(struct iwl_priv *priv);
 
+	void (*stop_device)(struct iwl_priv *priv);
+
 	int (*send_cmd)(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
 
 	int (*send_cmd_pdu)(struct iwl_priv *priv, u8 id, u32 flags, u16 len,
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index 77ed1c2..d736a9d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -407,7 +407,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 
 	case IWL_TM_CMD_APP2DEV_CFG_INIT_CALIB:
 		iwl_testmode_cfg_init_calib(priv);
-		iwlagn_stop_device(priv);
+		trans_stop_device(priv);
 		break;
 
 	case IWL_TM_CMD_APP2DEV_LOAD_RUNTIME_FW:
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 6b7cb73..8d45554 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -611,6 +611,46 @@ static int iwl_trans_tx_stop(struct iwl_priv *priv)
 	return 0;
 }
 
+static void iwl_trans_stop_device(struct iwl_priv *priv)
+{
+	unsigned long flags;
+
+	/* stop and reset the on-board processor */
+	iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+
+	/* tell the device to stop sending interrupts */
+	spin_lock_irqsave(&priv->lock, flags);
+	iwl_disable_interrupts(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+	trans_sync_irq(priv);
+
+	/* device going down, Stop using ICT table */
+	iwl_disable_ict(priv);
+
+	/*
+	 * If a HW restart happens during firmware loading,
+	 * then the firmware loading might call this function
+	 * and later it might be called again due to the
+	 * restart. So don't process again if the device is
+	 * already dead.
+	 */
+	if (test_bit(STATUS_DEVICE_ENABLED, &priv->status)) {
+		iwl_trans_tx_stop(priv);
+		iwl_trans_rx_stop(priv);
+
+		/* Power-down device's busmaster DMA clocks */
+		iwl_write_prph(priv, APMG_CLK_DIS_REG,
+			       APMG_CLK_VAL_DMA_CLK_RQT);
+		udelay(5);
+	}
+
+	/* Make sure (redundant) we've released our request to stay awake */
+	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+
+	/* Stop the device, and put it in low power state */
+	iwl_apm_stop(priv);
+}
+
 static struct iwl_tx_cmd *iwl_trans_get_tx_cmd(struct iwl_priv *priv,
 						int txq_id)
 {
@@ -779,13 +819,13 @@ static void iwl_trans_free(struct iwl_priv *priv)
 
 static const struct iwl_trans_ops trans_ops = {
 	.rx_init = iwl_trans_rx_init,
-	.rx_stop = iwl_trans_rx_stop,
 	.rx_free = iwl_trans_rx_free,
 
 	.tx_init = iwl_trans_tx_init,
-	.tx_stop = iwl_trans_tx_stop,
 	.tx_free = iwl_trans_tx_free,
 
+	.stop_device = iwl_trans_stop_device,
+
 	.send_cmd = iwl_send_cmd,
 	.send_cmd_pdu = iwl_send_cmd_pdu,
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 8293f54..55e6c33 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -69,11 +69,6 @@ static inline int trans_rx_init(struct iwl_priv *priv)
 	return priv->trans.ops->rx_init(priv);
 }
 
-static inline int trans_rx_stop(struct iwl_priv *priv)
-{
-	return priv->trans.ops->rx_stop(priv);
-}
-
 static inline void trans_rx_free(struct iwl_priv *priv)
 {
 	priv->trans.ops->rx_free(priv);
@@ -84,14 +79,14 @@ static inline int trans_tx_init(struct iwl_priv *priv)
 	return priv->trans.ops->tx_init(priv);
 }
 
-static inline int trans_tx_stop(struct iwl_priv *priv)
+static inline void trans_tx_free(struct iwl_priv *priv)
 {
-	return priv->trans.ops->tx_stop(priv);
+	priv->trans.ops->tx_free(priv);
 }
 
-static inline void trans_tx_free(struct iwl_priv *priv)
+static inline void trans_stop_device(struct iwl_priv *priv)
 {
-	priv->trans.ops->tx_free(priv);
+	priv->trans.ops->stop_device(priv);
 }
 
 static inline int trans_send_cmd(struct iwl_priv *priv,
-- 
1.7.0.4

