Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4551 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428Ab2B0XTD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:03 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/24] iwlwifi: move uCode flags handling to op_mode
Date: Mon, 27 Feb 2012 14:07:27 -0800
Message-Id: <1330380468-17674-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_002024_042789_20B7B668)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The uCode flags modification is op_mode dependent
since the P2P config is an op-mode config.

This also fixes P2P enabling: due to the uCode
loading code shuffle moving the SKU check before
the EEPROM was read it was always false and would
always disable PAN/P2P.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c   |   23 ++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-ucode.c |   14 +-------------
 2 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5e476a8..d70dd6f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1151,6 +1151,7 @@ int iwl_op_mode_dvm_start(struct iwl_bus *bus,
 	struct iwl_priv *priv;
 	struct ieee80211_hw *hw;
 	u16 num_mac;
+	u32 ucode_flags;
 
 	/************************
 	 * 1. Allocating HW data
@@ -1242,6 +1243,22 @@ int iwl_op_mode_dvm_start(struct iwl_bus *bus,
 	 ************************/
 	iwl_set_hw_params(priv);
 
+	ucode_flags = fw->ucode_capa.flags;
+
+#ifndef CONFIG_IWLWIFI_P2P
+	ucode_flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
+#endif
+	if (!(hw_params(priv).sku & EEPROM_SKU_CAP_IPAN_ENABLE))
+		ucode_flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
+
+	/*
+	 * if not PAN, then don't support P2P -- might be a uCode
+	 * packaging bug or due to the eeprom check above
+	 */
+	if (!(ucode_flags & IWL_UCODE_TLV_FLAGS_PAN))
+		ucode_flags &= ~IWL_UCODE_TLV_FLAGS_P2P;
+
+
 	/*******************
 	 * 6. Setup priv
 	 *******************/
@@ -1266,9 +1283,9 @@ int iwl_op_mode_dvm_start(struct iwl_bus *bus,
 		 "%s", fw->fw_version);
 
 	priv->new_scan_threshold_behaviour =
-		!!(fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWSCAN);
+		!!(ucode_flags & IWL_UCODE_TLV_FLAGS_NEWSCAN);
 
-	if (fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN) {
+	if (ucode_flags & IWL_UCODE_TLV_FLAGS_PAN) {
 		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
 		priv->shrd->cmd_queue = IWL_IPAN_CMD_QUEUE_NUM;
 	} else {
@@ -1282,7 +1299,7 @@ int iwl_op_mode_dvm_start(struct iwl_bus *bus,
 		fw->ucode_capa.standard_phy_calibration_size + 1;
 
 	/* initialize all valid contexts */
-	iwl_init_context(priv, fw->ucode_capa.flags);
+	iwl_init_context(priv, ucode_flags);
 
 	/**************************************************
 	 * This is still part of probe() in a sense...
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 99f89b2..3645bf3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -1226,9 +1226,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		nic->inst_evtlog_size =
 			cfg->base_params->max_event_log_size;
 	nic->inst_errlog_ptr = pieces.inst_errlog_ptr;
-#ifndef CONFIG_IWLWIFI_P2P
-	fw->ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
-#endif
+
 	/*
 	 * figure out the offset of chain noise reset and gain commands
 	 * base on the size of standard phy calibration commands table size
@@ -1238,16 +1236,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		fw->ucode_capa.standard_phy_calibration_size =
 			IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE;
 
-	if (!(cfg->sku & EEPROM_SKU_CAP_IPAN_ENABLE))
-		fw->ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
-
-	/*
-	 * if not PAN, then don't support P2P -- might be a uCode
-	 * packaging bug or due to the eeprom check above
-	 */
-	if (!(fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN))
-		fw->ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_P2P;
-
 	/* We have our copies now, allow OS release its copies */
 	release_firmware(ucode_raw);
 	complete(&nic->request_firmware_complete);
-- 
1.7.0.4

