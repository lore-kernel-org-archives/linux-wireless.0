Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46093 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343Ab2BQUX4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:56 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 23/26] iwlwifi: save ucode capabilities in iwl_fw
Date: Fri, 17 Feb 2012 11:13:51 -0800
Message-Id: <1329506034-1394-24-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212413_646678_F714CC64)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

The capabilities parsed from the ucode file are never saved.  Save
them in the iwl_fw structure.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    8 +----
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h    |    3 --
 drivers/net/wireless/iwlwifi/iwl-ucode.c    |   38 +++++++++++++-------------
 4 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 8a170b7..79894ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -65,11 +65,7 @@
 
 #include "iwl-dev.h"
 
-struct iwlagn_ucode_capabilities {
-	u32 max_probe_length;
-	u32 standard_phy_calibration_size;
-	u32 flags;
-};
+struct iwl_ucode_capabilities;
 
 extern struct ieee80211_ops iwlagn_hw_ops;
 
@@ -88,7 +84,7 @@ void iwlagn_prepare_restart(struct iwl_priv *priv);
 /* MAC80211 */
 struct ieee80211_hw *iwl_alloc_all(void);
 int iwlagn_mac_setup_register(struct iwl_priv *priv,
-			      struct iwlagn_ucode_capabilities *capa);
+			      struct iwl_ucode_capabilities *capa);
 void iwlagn_mac_unregister(struct iwl_priv *priv);
 
 /* RXON */
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 90d8081..9c29234 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -136,7 +136,7 @@ iwlagn_iface_combinations_p2p[] = {
  * other mac80211 functions grouped here.
  */
 int iwlagn_mac_setup_register(struct iwl_priv *priv,
-				  struct iwlagn_ucode_capabilities *capa)
+				  struct iwl_ucode_capabilities *capa)
 {
 	int ret;
 	struct ieee80211_hw *hw = priv->hw;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 20b50a0..cc7a3cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -321,9 +321,6 @@ enum iwl_trans_state {
  *	Set during transport allocation.
  * @hw_id_str: a string with info about HW ID. Set during transport allocation.
  * @ucode_write_complete: indicates that the ucode has been copied.
- * @ucode_rt: run time ucode image
- * @ucode_init: init ucode image
- * @ucode_wowlan: wake on wireless ucode image (optional)
  * @nvm_device_type: indicates OTP or eeprom
  * @pm_support: set to true in start_hw if link pm is supported
  * @calib_results: list head for init calibration results
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 01768f7..9e21fc1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -805,7 +805,7 @@ static int iwl_parse_v1_v2_firmware(struct iwl_nic *nic,
 static int iwl_parse_tlv_firmware(struct iwl_nic *nic,
 				const struct firmware *ucode_raw,
 				struct iwlagn_firmware_pieces *pieces,
-				struct iwlagn_ucode_capabilities *capa)
+				struct iwl_ucode_capabilities *capa)
 {
 	struct iwl_tlv_ucode_header *ucode = (void *)ucode_raw->data;
 	struct iwl_ucode_tlv *tlv;
@@ -1012,6 +1012,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 {
 	struct iwl_nic *nic = context;
 	struct iwl_cfg *cfg = cfg(nic);
+	struct iwl_fw *fw = &nic->fw;
 	struct iwl_priv *priv = priv(nic); /* temporary */
 	struct iwl_ucode_header *ucode;
 	int err;
@@ -1022,11 +1023,10 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	u32 api_ver;
 	char buildstr[25];
 	u32 build;
-	struct iwlagn_ucode_capabilities ucode_capa = {
-		.max_probe_length = 200,
-		.standard_phy_calibration_size =
-			IWL_DEFAULT_STANDARD_PHY_CALIBRATE_TBL_SIZE,
-	};
+
+	fw->ucode_capa.max_probe_length = 200;
+	fw->ucode_capa.standard_phy_calibration_size =
+			IWL_DEFAULT_STANDARD_PHY_CALIBRATE_TBL_SIZE;
 
 	if (!api_ok)
 		api_ok = api_max;
@@ -1057,7 +1057,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		err = iwl_parse_v1_v2_firmware(nic, ucode_raw, &pieces);
 	else
 		err = iwl_parse_tlv_firmware(nic, ucode_raw, &pieces,
-					   &ucode_capa);
+					   &fw->ucode_capa);
 
 	if (err)
 		goto try_again;
@@ -1219,23 +1219,23 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 			cfg->base_params->max_event_log_size;
 	nic->inst_errlog_ptr = pieces.inst_errlog_ptr;
 #ifndef CONFIG_IWLWIFI_P2P
-	ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
+	fw->ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
 #endif
 
 	priv->new_scan_threshold_behaviour =
-		!!(ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWSCAN);
+		!!(fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWSCAN);
 
 	if (!(cfg->sku & EEPROM_SKU_CAP_IPAN_ENABLE))
-		ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
+		fw->ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
 
 	/*
 	 * if not PAN, then don't support P2P -- might be a uCode
 	 * packaging bug or due to the eeprom check above
 	 */
-	if (!(ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN))
-		ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_P2P;
+	if (!(fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN))
+		fw->ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_P2P;
 
-	if (ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN) {
+	if (fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN) {
 		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
 		nic->shrd->cmd_queue = IWL_IPAN_CMD_QUEUE_NUM;
 	} else {
@@ -1246,25 +1246,25 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	 * figure out the offset of chain noise reset and gain commands
 	 * base on the size of standard phy calibration commands table size
 	 */
-	if (ucode_capa.standard_phy_calibration_size >
+	if (fw->ucode_capa.standard_phy_calibration_size >
 	    IWL_MAX_PHY_CALIBRATE_TBL_SIZE)
-		ucode_capa.standard_phy_calibration_size =
+		fw->ucode_capa.standard_phy_calibration_size =
 			IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE;
 
 	priv->phy_calib_chain_noise_reset_cmd =
-		ucode_capa.standard_phy_calibration_size;
+		fw->ucode_capa.standard_phy_calibration_size;
 	priv->phy_calib_chain_noise_gain_cmd =
-		ucode_capa.standard_phy_calibration_size + 1;
+		fw->ucode_capa.standard_phy_calibration_size + 1;
 
 	/* initialize all valid contexts */
-	iwl_init_context(priv, ucode_capa.flags);
+	iwl_init_context(priv, fw->ucode_capa.flags);
 
 	/**************************************************
 	 * This is still part of probe() in a sense...
 	 *
 	 * 9. Setup and register with mac80211 and debugfs
 	 **************************************************/
-	err = iwlagn_mac_setup_register(priv, &ucode_capa);
+	err = iwlagn_mac_setup_register(priv, &fw->ucode_capa);
 	if (err)
 		goto out_unbind;
 
-- 
1.7.0.4

