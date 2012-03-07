Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20333 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932739Ab2CGTGn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 14:06:43 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 33/35] iwlwifi: restore PAN support
Date: Wed,  7 Mar 2012 09:52:41 -0800
Message-Id: <1331142764-5750-33-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120307_200652_118840_D599EEEE)
In-Reply-To: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

in iwlwifi: move setting up fw parameters

Meenakshi moved code up to configure the transport layer, but this
code read the sku before it was set (from the EEPROM). This killed
P2P.
Only the ucode_flags are needed to configure the transport layer, not
the sku which _must_ be set after the EEPROM is read.

We need to reconfigure the transport in case the EEPROM disabled PAN
support. This is not the nicest thing to do, but we have no choice.
Document that we are allowed to configure the transport several times
before start_fw, but not after.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c   |   59 +++++++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-trans.h |    3 +-
 2 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f150edc..3793dc4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1206,35 +1206,17 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	/* TODO: remove fw from shared data later */
 	priv->shrd->fw = fw;
 
-	/************************
-	 * 2. Setup HW constants
-	 ************************/
-	iwl_set_hw_params(priv);
+	/*
+	 * Populate the state variables that the transport layer needs
+	 * to know about.
+	 */
+	trans_cfg.op_mode = op_mode;
 
 	ucode_flags = fw->ucode_capa.flags;
 
 #ifndef CONFIG_IWLWIFI_P2P
 	ucode_flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
 #endif
-	if (!(hw_params(priv).sku & EEPROM_SKU_CAP_IPAN_ENABLE))
-		ucode_flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
-
-	/*
-	 * if not PAN, then don't support P2P -- might be a uCode
-	 * packaging bug or due to the eeprom check above
-	 */
-	if (!(ucode_flags & IWL_UCODE_TLV_FLAGS_PAN))
-		ucode_flags &= ~IWL_UCODE_TLV_FLAGS_P2P;
-
-
-	/*****************************
-	 * Configure transport layer
-	 *****************************/
-	/*
-	 * Populate the state variables that the transport layer needs
-	 * to know about.
-	 */
-	trans_cfg.op_mode = op_mode;
 
 	if (ucode_flags & IWL_UCODE_TLV_FLAGS_PAN) {
 		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
@@ -1277,7 +1259,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	spin_lock_init(&priv->statistics.lock);
 
 	/***********************
-	 * 3. Read REV register
+	 * 2. Read REV register
 	 ***********************/
 	IWL_INFO(priv, "Detected %s, REV=0x%X\n",
 		cfg(priv)->name, trans(priv)->hw_rev);
@@ -1287,9 +1269,8 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 		goto out_free_traffic_mem;
 
 	/*****************
-	 * 4. Read EEPROM
+	 * 3. Read EEPROM
 	 *****************/
-	/* Read the EEPROM */
 	err = iwl_eeprom_init(trans(priv), trans(priv)->hw_rev);
 	/* Reset chip to save power until we load uCode during "up". */
 	iwl_trans_stop_hw(trans(priv));
@@ -1318,8 +1299,28 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 		priv->hw->wiphy->n_addresses++;
 	}
 
+	/************************
+	 * 4. Setup HW constants
+	 ************************/
+	iwl_set_hw_params(priv);
+
+	if (!(hw_params(priv).sku & EEPROM_SKU_CAP_IPAN_ENABLE)) {
+		IWL_DEBUG_INFO(priv, "Your EEPROM disabled PAN");
+		ucode_flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
+		/*
+		 * if not PAN, then don't support P2P -- might be a uCode
+		 * packaging bug or due to the eeprom check above
+		 */
+		ucode_flags &= ~IWL_UCODE_TLV_FLAGS_P2P;
+		priv->sta_key_max_num = STA_KEY_MAX_NUM;
+		trans_cfg.cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
+
+		/* Configure transport layer again*/
+		iwl_trans_configure(trans(priv), &trans_cfg);
+	}
+
 	/*******************
-	 * 6. Setup priv
+	 * 5. Setup priv
 	 *******************/
 
 	err = iwl_init_drv(priv);
@@ -1328,7 +1329,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	/* At this point both hw and priv are initialized. */
 
 	/********************
-	 * 7. Setup services
+	 * 6. Setup services
 	 ********************/
 	iwl_setup_deferred_work(priv);
 	iwl_setup_rx_handlers(priv);
@@ -1355,7 +1356,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	/**************************************************
 	 * This is still part of probe() in a sense...
 	 *
-	 * 9. Setup and register with mac80211 and debugfs
+	 * 7. Setup and register with mac80211 and debugfs
 	 **************************************************/
 	err = iwlagn_mac_setup_register(priv, &fw->ucode_capa);
 	if (err)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index a40c272..7d1990c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -335,7 +335,8 @@ struct iwl_trans_config {
  * @write32: write a u32 to a register at offset ofs from the BAR
  * @read32: read a u32 register at offset ofs from the BAR
  * @configure: configure parameters required by the transport layer from
- *	the op_mode.
+ *	the op_mode. May be called several times before start_fw, can't be
+ *	called after that.
  */
 struct iwl_trans_ops {
 
-- 
1.7.0.4

