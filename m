Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:45594 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329Ab2B0XTD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:03 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/24] iwlwifi: move content of iwl_probe to post fetch_fw
Date: Mon, 27 Feb 2012 14:07:26 -0800
Message-Id: <1330380468-17674-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_002023_455314_1E7C23B6)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This will allow to have different behavior depending on the fw.
Different fw APIs require completely different implementation
of the mac80211 APIs. Each of these implementations is called an
op_mode.

The current op_mode is called DVM which states for dual virtual MAC.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   53 +++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-shared.h |    3 +
 drivers/net/wireless/iwlwifi/iwl-ucode.c  |   64 ++++++----------------------
 drivers/net/wireless/iwlwifi/iwl-wifi.h   |    2 +
 4 files changed, 67 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e8fed16..5e476a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1142,9 +1142,11 @@ static void iwl_debug_config(struct iwl_priv *priv)
 #endif
 }
 
-int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
-		struct iwl_cfg *cfg)
+int iwl_op_mode_dvm_start(struct iwl_bus *bus,
+			  const struct iwl_trans_ops *trans_ops,
+			  struct iwl_cfg *cfg)
 {
+	struct iwl_fw *fw = &nic(bus)->fw;
 	int err = 0;
 	struct iwl_priv *priv;
 	struct ieee80211_hw *hw;
@@ -1172,7 +1174,6 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	iwl_debug_config(priv);
 
 	IWL_DEBUG_INFO(priv, "*** LOAD DRIVER ***\n");
-	cfg(priv) = cfg;
 
 	/* is antenna coupling more than 35dB ? */
 	priv->bt_ant_couple_ok =
@@ -1260,12 +1261,44 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	iwl_power_initialize(priv);
 	iwl_tt_initialize(priv);
 
-	init_completion(&nic(priv)->request_firmware_complete);
+	snprintf(priv->hw->wiphy->fw_version,
+		 sizeof(priv->hw->wiphy->fw_version),
+		 "%s", fw->fw_version);
+
+	priv->new_scan_threshold_behaviour =
+		!!(fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWSCAN);
 
-	err = iwl_request_firmware(nic(priv), true);
+	if (fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN) {
+		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
+		priv->shrd->cmd_queue = IWL_IPAN_CMD_QUEUE_NUM;
+	} else {
+		priv->sta_key_max_num = STA_KEY_MAX_NUM;
+		priv->shrd->cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
+	}
+
+	priv->phy_calib_chain_noise_reset_cmd =
+		fw->ucode_capa.standard_phy_calibration_size;
+	priv->phy_calib_chain_noise_gain_cmd =
+		fw->ucode_capa.standard_phy_calibration_size + 1;
+
+	/* initialize all valid contexts */
+	iwl_init_context(priv, fw->ucode_capa.flags);
+
+	/**************************************************
+	 * This is still part of probe() in a sense...
+	 *
+	 * 9. Setup and register with mac80211 and debugfs
+	 **************************************************/
+	err = iwlagn_mac_setup_register(priv, &fw->ucode_capa);
 	if (err)
 		goto out_destroy_workqueue;
 
+	err = iwl_dbgfs_register(priv, DRV_NAME);
+	if (err)
+		IWL_ERR(priv,
+			"failed to create debugfs files. Ignoring error: %d\n",
+			err);
+
 	return 0;
 
 out_destroy_workqueue:
@@ -1281,6 +1314,16 @@ out:
 	return err;
 }
 
+int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
+		struct iwl_cfg *cfg)
+{
+	bus->shrd->cfg = cfg;
+
+	init_completion(&nic(bus)->request_firmware_complete);
+
+	return iwl_request_firmware(nic(bus), true);
+}
+
 void __devexit iwl_remove(struct iwl_priv * priv)
 {
 	wait_for_completion(&nic(priv)->request_firmware_complete);
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index f810b41..cf593b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -532,6 +532,9 @@ enum iwl_rxon_context_id {
 	NUM_IWL_RXON_CTX
 };
 
+int iwl_op_mode_dvm_start(struct iwl_bus *bus,
+			  const struct iwl_trans_ops *trans_ops,
+			  struct iwl_cfg *cfg);
 int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 		struct iwl_cfg *cfg);
 void __devexit iwl_remove(struct iwl_priv * priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index ea75709..99f89b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -687,7 +687,6 @@ int iwl_run_init_ucode(struct iwl_trans *trans)
 
 static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context);
 
-#define UCODE_EXPERIMENTAL_INDEX	100
 #define UCODE_EXPERIMENTAL_TAG		"exp"
 
 int __must_check iwl_request_firmware(struct iwl_nic *nic, bool first)
@@ -1047,7 +1046,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	struct iwl_nic *nic = context;
 	struct iwl_cfg *cfg = cfg(nic);
 	struct iwl_fw *fw = &nic->fw;
-	struct iwl_priv *priv = priv(nic); /* temporary */
 	struct iwl_ucode_header *ucode;
 	int err;
 	struct iwlagn_firmware_pieces pieces;
@@ -1127,10 +1125,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 	IWL_INFO(nic, "loaded firmware version %s", nic->fw.fw_version);
 
-	snprintf(priv->hw->wiphy->fw_version,
-		 sizeof(priv->hw->wiphy->fw_version),
-		 "%s", nic->fw.fw_version);
-
 	/*
 	 * For any of the failures below (before allocating pci memory)
 	 * we will try to load a version with a smaller API -- maybe the
@@ -1235,27 +1229,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 #ifndef CONFIG_IWLWIFI_P2P
 	fw->ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
 #endif
-
-	priv->new_scan_threshold_behaviour =
-		!!(fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWSCAN);
-
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
-	if (fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN) {
-		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
-		nic->shrd->cmd_queue = IWL_IPAN_CMD_QUEUE_NUM;
-	} else {
-		priv->sta_key_max_num = STA_KEY_MAX_NUM;
-		nic->shrd->cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
-	}
 	/*
 	 * figure out the offset of chain noise reset and gain commands
 	 * base on the size of standard phy calibration commands table size
@@ -1265,47 +1238,38 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		fw->ucode_capa.standard_phy_calibration_size =
 			IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE;
 
-	priv->phy_calib_chain_noise_reset_cmd =
-		fw->ucode_capa.standard_phy_calibration_size;
-	priv->phy_calib_chain_noise_gain_cmd =
-		fw->ucode_capa.standard_phy_calibration_size + 1;
-
-	/* initialize all valid contexts */
-	iwl_init_context(priv, fw->ucode_capa.flags);
-
-	/**************************************************
-	 * This is still part of probe() in a sense...
-	 *
-	 * 9. Setup and register with mac80211 and debugfs
-	 **************************************************/
-	err = iwlagn_mac_setup_register(priv, &fw->ucode_capa);
-	if (err)
-		goto out_unbind;
+	if (!(cfg->sku & EEPROM_SKU_CAP_IPAN_ENABLE))
+		fw->ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
 
-	err = iwl_dbgfs_register(priv, DRV_NAME);
-	if (err)
-		IWL_ERR(nic,
-			"failed to create debugfs files. Ignoring error: %d\n",
-			err);
+	/*
+	 * if not PAN, then don't support P2P -- might be a uCode
+	 * packaging bug or due to the eeprom check above
+	 */
+	if (!(fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN))
+		fw->ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_P2P;
 
 	/* We have our copies now, allow OS release its copies */
 	release_firmware(ucode_raw);
 	complete(&nic->request_firmware_complete);
+
+	if (iwl_op_mode_dvm_start(bus(nic), trans(nic)->ops, cfg))
+		goto out_unbind;
+
 	return;
 
  try_again:
 	/* try next, if any */
+	release_firmware(ucode_raw);
 	if (iwl_request_firmware(nic, false))
 		goto out_unbind;
-	release_firmware(ucode_raw);
 	return;
 
  err_pci_alloc:
 	IWL_ERR(nic, "failed to allocate pci memory\n");
 	iwl_dealloc_ucode(nic);
+	release_firmware(ucode_raw);
  out_unbind:
 	complete(&nic->request_firmware_complete);
 	device_release_driver(trans(nic)->dev);
-	release_firmware(ucode_raw);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-wifi.h b/drivers/net/wireless/iwlwifi/iwl-wifi.h
index 84172f6..a78120e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-wifi.h
+++ b/drivers/net/wireless/iwlwifi/iwl-wifi.h
@@ -66,6 +66,8 @@
 #include "iwl-shared.h"
 #include "iwl-ucode.h"
 
+#define UCODE_EXPERIMENTAL_INDEX	100
+
 /**
  * struct iwl_nic - nic common data
  * @fw: the iwl_fw structure
-- 
1.7.0.4

