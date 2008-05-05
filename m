Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15420 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577AbYEECY0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:26 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 18/25] iwlwifi: move iwl4965_init_alive_start to iwl-4965.c
Date: Mon,  5 May 2008 10:22:45 +0800
Message-Id: <1209954172-3092-19-git-send-email-yi.zhu@intel.com> (sfid-20080505_044414_346069_9518C86E)
In-Reply-To: <1209954172-3092-18-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-8-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-9-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-10-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-11-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-12-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-13-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-14-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-15-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-16-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-17-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-18-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch moves iwl_4965_init_alive_start to iwl-4965.c.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   97 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  101 +--------------------------
 3 files changed, 100 insertions(+), 100 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 639bbc3..77ae7f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -222,6 +222,102 @@ static int iwl4965_load_bsm(struct iwl_priv *priv)
 	return 0;
 }
 
+/**
+ * iwl4965_set_ucode_ptrs - Set uCode address location
+ *
+ * Tell initialization uCode where to find runtime uCode.
+ *
+ * BSM registers initially contain pointers to initialization uCode.
+ * We need to replace them to load runtime uCode inst and data,
+ * and to save runtime data when powering down.
+ */
+static int iwl4965_set_ucode_ptrs(struct iwl_priv *priv)
+{
+	dma_addr_t pinst;
+	dma_addr_t pdata;
+	unsigned long flags;
+	int ret = 0;
+
+	/* bits 35:4 for 4965 */
+	pinst = priv->ucode_code.p_addr >> 4;
+	pdata = priv->ucode_data_backup.p_addr >> 4;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	ret = iwl_grab_nic_access(priv);
+	if (ret) {
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return ret;
+	}
+
+	/* Tell bootstrap uCode where to find image to load */
+	iwl_write_prph(priv, BSM_DRAM_INST_PTR_REG, pinst);
+	iwl_write_prph(priv, BSM_DRAM_DATA_PTR_REG, pdata);
+	iwl_write_prph(priv, BSM_DRAM_DATA_BYTECOUNT_REG,
+				 priv->ucode_data.len);
+
+	/* Inst bytecount must be last to set up, bit 31 signals uCode
+	 *   that all new ptr/size info is in place */
+	iwl_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG,
+				 priv->ucode_code.len | BSM_DRAM_INST_LOAD);
+	iwl_release_nic_access(priv);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	IWL_DEBUG_INFO("Runtime uCode pointers are set.\n");
+
+	return ret;
+}
+
+/**
+ * iwl4965_init_alive_start - Called after REPLY_ALIVE notification received
+ *
+ * Called after REPLY_ALIVE notification received from "initialize" uCode.
+ *
+ * The 4965 "initialize" ALIVE reply contains calibration data for:
+ *   Voltage, temperature, and MIMO tx gain correction, now stored in priv
+ *   (3945 does not contain this data).
+ *
+ * Tell "initialize" uCode to go ahead and load the runtime uCode.
+*/
+static void iwl4965_init_alive_start(struct iwl_priv *priv)
+{
+	/* Check alive response for "valid" sign from uCode */
+	if (priv->card_alive_init.is_valid != UCODE_VALID_OK) {
+		/* We had an error bringing up the hardware, so take it
+		 * all the way back down so we can try again */
+		IWL_DEBUG_INFO("Initialize Alive failed.\n");
+		goto restart;
+	}
+
+	/* Bootstrap uCode has loaded initialize uCode ... verify inst image.
+	 * This is a paranoid check, because we would not have gotten the
+	 * "initialize" alive if code weren't properly loaded.  */
+	if (iwl_verify_ucode(priv)) {
+		/* Runtime instruction load was bad;
+		 * take it all the way back down so we can try again */
+		IWL_DEBUG_INFO("Bad \"initialize\" uCode load.\n");
+		goto restart;
+	}
+
+	/* Calculate temperature */
+	priv->temperature = iwl4965_get_temperature(priv);
+
+	/* Send pointers to protocol/runtime uCode image ... init code will
+	 * load and launch runtime uCode, which will send us another "Alive"
+	 * notification. */
+	IWL_DEBUG_INFO("Initialization Alive received.\n");
+	if (iwl4965_set_ucode_ptrs(priv)) {
+		/* Runtime instruction load won't happen;
+		 * take it all the way back down so we can try again */
+		IWL_DEBUG_INFO("Couldn't set up uCode pointers.\n");
+		goto restart;
+	}
+	return;
+
+restart:
+	queue_work(priv->workqueue, &priv->restart);
+}
+
 static int is_fat_channel(__le32 rxon_flags)
 {
 	return (rxon_flags & RXON_FLG_CHANNEL_MODE_PURE_40_MSK) ||
@@ -3721,6 +3817,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.rx_handler_setup = iwl4965_rx_handler_setup,
 	.is_valid_rtc_data_addr = iwl4965_hw_valid_rtc_data_addr,
 	.alive_notify = iwl4965_alive_notify,
+	.init_alive_start = iwl4965_init_alive_start,
 	.load_ucode = iwl4965_load_bsm,
 	.apm_ops = {
 		.init = iwl4965_apm_init,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 3a75dc6..08eccde 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -110,6 +110,8 @@ struct iwl_lib_ops {
 	void (*rx_handler_setup)(struct iwl_priv *priv);
 	/* nic Tx fifo handling */
 	int (*disable_tx_fifo)(struct iwl_priv *priv);
+	/* alive notification after init uCode load */
+	void (*init_alive_start)(struct iwl_priv *priv);
 	/* alive notification */
 	int (*alive_notify)(struct iwl_priv *priv);
 	/* check validity of rtc data address */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 5b54579..d155f75 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -4163,105 +4163,6 @@ static int iwl4965_read_ucode(struct iwl_priv *priv)
 	return ret;
 }
 
-
-/**
- * iwl4965_set_ucode_ptrs - Set uCode address location
- *
- * Tell initialization uCode where to find runtime uCode.
- *
- * BSM registers initially contain pointers to initialization uCode.
- * We need to replace them to load runtime uCode inst and data,
- * and to save runtime data when powering down.
- */
-static int iwl4965_set_ucode_ptrs(struct iwl_priv *priv)
-{
-	dma_addr_t pinst;
-	dma_addr_t pdata;
-	int rc = 0;
-	unsigned long flags;
-
-	/* bits 35:4 for 4965 */
-	pinst = priv->ucode_code.p_addr >> 4;
-	pdata = priv->ucode_data_backup.p_addr >> 4;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return rc;
-	}
-
-	/* Tell bootstrap uCode where to find image to load */
-	iwl_write_prph(priv, BSM_DRAM_INST_PTR_REG, pinst);
-	iwl_write_prph(priv, BSM_DRAM_DATA_PTR_REG, pdata);
-	iwl_write_prph(priv, BSM_DRAM_DATA_BYTECOUNT_REG,
-				 priv->ucode_data.len);
-
-	/* Inst bytecount must be last to set up, bit 31 signals uCode
-	 *   that all new ptr/size info is in place */
-	iwl_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG,
-				 priv->ucode_code.len | BSM_DRAM_INST_LOAD);
-
-	iwl_release_nic_access(priv);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	IWL_DEBUG_INFO("Runtime uCode pointers are set.\n");
-
-	return rc;
-}
-
-/**
- * iwl4965_init_alive_start - Called after REPLY_ALIVE notification received
- *
- * Called after REPLY_ALIVE notification received from "initialize" uCode.
- *
- * The 4965 "initialize" ALIVE reply contains calibration data for:
- *   Voltage, temperature, and MIMO tx gain correction, now stored in priv
- *   (3945 does not contain this data).
- *
- * Tell "initialize" uCode to go ahead and load the runtime uCode.
-*/
-static void iwl4965_init_alive_start(struct iwl_priv *priv)
-{
-	/* Check alive response for "valid" sign from uCode */
-	if (priv->card_alive_init.is_valid != UCODE_VALID_OK) {
-		/* We had an error bringing up the hardware, so take it
-		 * all the way back down so we can try again */
-		IWL_DEBUG_INFO("Initialize Alive failed.\n");
-		goto restart;
-	}
-
-	/* Bootstrap uCode has loaded initialize uCode ... verify inst image.
-	 * This is a paranoid check, because we would not have gotten the
-	 * "initialize" alive if code weren't properly loaded.  */
-	if (iwl_verify_ucode(priv)) {
-		/* Runtime instruction load was bad;
-		 * take it all the way back down so we can try again */
-		IWL_DEBUG_INFO("Bad \"initialize\" uCode load.\n");
-		goto restart;
-	}
-
-	/* Calculate temperature */
-	priv->temperature = iwl4965_get_temperature(priv);
-
-	/* Send pointers to protocol/runtime uCode image ... init code will
-	 * load and launch runtime uCode, which will send us another "Alive"
-	 * notification. */
-	IWL_DEBUG_INFO("Initialization Alive received.\n");
-	if (iwl4965_set_ucode_ptrs(priv)) {
-		/* Runtime instruction load won't happen;
-		 * take it all the way back down so we can try again */
-		IWL_DEBUG_INFO("Couldn't set up uCode pointers.\n");
-		goto restart;
-	}
-	return;
-
- restart:
-	queue_work(priv->workqueue, &priv->restart);
-}
-
-
 /**
  * iwl4965_alive_start - called after REPLY_ALIVE notification received
  *                   from protocol/runtime uCode (initialization uCode's
@@ -4587,7 +4488,7 @@ static void iwl4965_bg_init_alive_start(struct work_struct *data)
 		return;
 
 	mutex_lock(&priv->mutex);
-	iwl4965_init_alive_start(priv);
+	priv->cfg->ops->lib->init_alive_start(priv);
 	mutex_unlock(&priv->mutex);
 }
 
-- 
1.5.3.6

