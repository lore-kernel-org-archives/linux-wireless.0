Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55196 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757250Ab1LBRqS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 12:46:18 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/16] iwlwifi: replace iwl_priv reference with iwl_trans for ucode.
Date: Fri,  2 Dec 2011 08:48:38 -0800
Message-Id: <1322844520-21149-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111202_184638_109744_67B7F348)
In-Reply-To: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Replace the references to the iwl_priv structure with the iwl_trans
structure as the priv structure is never referenced other than to
access the trans structure.  Rename from iwlagn to iwl.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c   |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-ucode.c |   62 +++++++++++++++---------------
 3 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index db0d3a8..10d3dc9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1232,14 +1232,14 @@ int iwl_alive_start(struct iwl_priv *priv)
 		priv->bt_valid = IWLAGN_BT_VALID_ENABLE_FLAGS;
 		priv->cur_rssi_ctx = NULL;
 
-		iwlagn_send_prio_tbl(priv);
+		iwl_send_prio_tbl(trans(priv));
 
 		/* FIXME: w/a to force change uCode BT state machine */
-		ret = iwlagn_send_bt_env(priv, IWL_BT_COEX_ENV_OPEN,
+		ret = iwl_send_bt_env(trans(priv), IWL_BT_COEX_ENV_OPEN,
 					 BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
 		if (ret)
 			return ret;
-		ret = iwlagn_send_bt_env(priv, IWL_BT_COEX_ENV_CLOSE,
+		ret = iwl_send_bt_env(trans(priv), IWL_BT_COEX_ENV_CLOSE,
 					 BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
 		if (ret)
 			return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 2f446a3..0db0a8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -108,8 +108,8 @@ void iwlagn_config_ht40(struct ieee80211_conf *conf,
 int iwlagn_rx_calib_result(struct iwl_priv *priv,
 			    struct iwl_rx_mem_buffer *rxb,
 			    struct iwl_device_cmd *cmd);
-int iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
-void iwlagn_send_prio_tbl(struct iwl_priv *priv);
+int iwl_send_bt_env(struct iwl_trans *trans, u8 action, u8 type);
+void iwl_send_prio_tbl(struct iwl_trans *trans);
 int iwlagn_run_init_ucode(struct iwl_priv *priv);
 int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 				 enum iwl_ucode_type ucode_type);
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 7694910..0da4b8e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -122,7 +122,7 @@ int iwl_alloc_fw_desc(struct iwl_bus *bus, struct fw_desc *desc,
 /*
  * ucode
  */
-static int iwlagn_load_section(struct iwl_trans *trans, const char *name,
+static int iwl_load_section(struct iwl_trans *trans, const char *name,
 				struct fw_desc *image, u32 dst_addr)
 {
 	struct iwl_bus *bus = bus(trans);
@@ -188,7 +188,7 @@ static inline struct fw_img *iwl_get_ucode_image(struct iwl_trans *trans,
 	return NULL;
 }
 
-static int iwlagn_load_given_ucode(struct iwl_trans *trans,
+static int iwl_load_given_ucode(struct iwl_trans *trans,
 				   enum iwl_ucode_type ucode_type)
 {
 	int ret = 0;
@@ -201,19 +201,19 @@ static int iwlagn_load_given_ucode(struct iwl_trans *trans,
 		return -EINVAL;
 	}
 
-	ret = iwlagn_load_section(trans, "INST", &image->code,
+	ret = iwl_load_section(trans, "INST", &image->code,
 				   IWLAGN_RTC_INST_LOWER_BOUND);
 	if (ret)
 		return ret;
 
-	return iwlagn_load_section(trans, "DATA", &image->data,
+	return iwl_load_section(trans, "DATA", &image->data,
 				    IWLAGN_RTC_DATA_LOWER_BOUND);
 }
 
 /*
  *  Calibration
  */
-static int iwlagn_set_Xtal_calib(struct iwl_priv *priv)
+static int iwl_set_Xtal_calib(struct iwl_priv *priv)
 {
 	struct iwl_calib_xtal_freq_cmd cmd;
 	__le16 *xtal_calib =
@@ -225,7 +225,7 @@ static int iwlagn_set_Xtal_calib(struct iwl_priv *priv)
 	return iwl_calib_set(priv, (void *)&cmd, sizeof(cmd));
 }
 
-static int iwlagn_set_temperature_offset_calib(struct iwl_priv *priv)
+static int iwl_set_temperature_offset_calib(struct iwl_priv *priv)
 {
 	struct iwl_calib_temperature_offset_cmd cmd;
 	__le16 *offset_calib =
@@ -242,7 +242,7 @@ static int iwlagn_set_temperature_offset_calib(struct iwl_priv *priv)
 	return iwl_calib_set(priv, (void *)&cmd, sizeof(cmd));
 }
 
-static int iwlagn_set_temperature_offset_calib_v2(struct iwl_priv *priv)
+static int iwl_set_temperature_offset_calib_v2(struct iwl_priv *priv)
 {
 	struct iwl_calib_temperature_offset_v2_cmd cmd;
 	__le16 *offset_calib_high = (__le16 *)iwl_eeprom_query_addr(priv,
@@ -277,7 +277,7 @@ static int iwlagn_set_temperature_offset_calib_v2(struct iwl_priv *priv)
 	return iwl_calib_set(priv, (void *)&cmd, sizeof(cmd));
 }
 
-static int iwlagn_send_calib_cfg(struct iwl_priv *priv)
+static int iwl_send_calib_cfg(struct iwl_trans *trans)
 {
 	struct iwl_calib_cfg_cmd calib_cfg_cmd;
 	struct iwl_host_cmd cmd = {
@@ -293,7 +293,7 @@ static int iwlagn_send_calib_cfg(struct iwl_priv *priv)
 	calib_cfg_cmd.ucd_calib_cfg.flags =
 		IWL_CALIB_CFG_FLAG_SEND_COMPLETE_NTFY_MSK;
 
-	return iwl_trans_send_cmd(trans(priv), &cmd);
+	return iwl_trans_send_cmd(trans, &cmd);
 }
 
 int iwlagn_rx_calib_result(struct iwl_priv *priv,
@@ -326,14 +326,14 @@ int iwlagn_init_alive_start(struct iwl_priv *priv)
 		 * no need to close the envlope since we are going
 		 * to load the runtime uCode later.
 		 */
-		ret = iwlagn_send_bt_env(priv, IWL_BT_COEX_ENV_OPEN,
+		ret = iwl_send_bt_env(trans(priv), IWL_BT_COEX_ENV_OPEN,
 			BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
 		if (ret)
 			return ret;
 
 	}
 
-	ret = iwlagn_send_calib_cfg(priv);
+	ret = iwl_send_calib_cfg(trans(priv));
 	if (ret)
 		return ret;
 
@@ -343,15 +343,15 @@ int iwlagn_init_alive_start(struct iwl_priv *priv)
 	 */
 	if (priv->cfg->need_temp_offset_calib) {
 		if (priv->cfg->temp_offset_v2)
-			return iwlagn_set_temperature_offset_calib_v2(priv);
+			return iwl_set_temperature_offset_calib_v2(priv);
 		else
-			return iwlagn_set_temperature_offset_calib(priv);
+			return iwl_set_temperature_offset_calib(priv);
 	}
 
 	return 0;
 }
 
-static int iwlagn_send_wimax_coex(struct iwl_priv *priv)
+static int iwl_send_wimax_coex(struct iwl_priv *priv)
 {
 	struct iwl_wimax_coex_cmd coex_cmd;
 
@@ -379,7 +379,7 @@ static int iwlagn_send_wimax_coex(struct iwl_priv *priv)
 				sizeof(coex_cmd), &coex_cmd);
 }
 
-static const u8 iwlagn_bt_prio_tbl[BT_COEX_PRIO_TBL_EVT_MAX] = {
+static const u8 iwl_bt_prio_tbl[BT_COEX_PRIO_TBL_EVT_MAX] = {
 	((BT_COEX_PRIO_TBL_PRIO_BYPASS << IWL_BT_COEX_PRIO_TBL_PRIO_POS) |
 		(0 << IWL_BT_COEX_PRIO_TBL_SHARED_ANTENNA_POS)),
 	((BT_COEX_PRIO_TBL_PRIO_BYPASS << IWL_BT_COEX_PRIO_TBL_PRIO_POS) |
@@ -401,42 +401,42 @@ static const u8 iwlagn_bt_prio_tbl[BT_COEX_PRIO_TBL_EVT_MAX] = {
 	0, 0, 0, 0, 0, 0, 0
 };
 
-void iwlagn_send_prio_tbl(struct iwl_priv *priv)
+void iwl_send_prio_tbl(struct iwl_trans *trans)
 {
 	struct iwl_bt_coex_prio_table_cmd prio_tbl_cmd;
 
-	memcpy(prio_tbl_cmd.prio_tbl, iwlagn_bt_prio_tbl,
-		sizeof(iwlagn_bt_prio_tbl));
-	if (iwl_trans_send_cmd_pdu(trans(priv),
+	memcpy(prio_tbl_cmd.prio_tbl, iwl_bt_prio_tbl,
+		sizeof(iwl_bt_prio_tbl));
+	if (iwl_trans_send_cmd_pdu(trans,
 				REPLY_BT_COEX_PRIO_TABLE, CMD_SYNC,
 				sizeof(prio_tbl_cmd), &prio_tbl_cmd))
-		IWL_ERR(priv, "failed to send BT prio tbl command\n");
+		IWL_ERR(trans, "failed to send BT prio tbl command\n");
 }
 
-int iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type)
+int iwl_send_bt_env(struct iwl_trans *trans, u8 action, u8 type)
 {
 	struct iwl_bt_coex_prot_env_cmd env_cmd;
 	int ret;
 
 	env_cmd.action = action;
 	env_cmd.type = type;
-	ret = iwl_trans_send_cmd_pdu(trans(priv),
+	ret = iwl_trans_send_cmd_pdu(trans,
 			       REPLY_BT_COEX_PROT_ENV, CMD_SYNC,
 			       sizeof(env_cmd), &env_cmd);
 	if (ret)
-		IWL_ERR(priv, "failed to send BT env command\n");
+		IWL_ERR(trans, "failed to send BT env command\n");
 	return ret;
 }
 
 
-static int iwlagn_alive_notify(struct iwl_priv *priv)
+static int iwl_alive_notify(struct iwl_priv *priv)
 {
 	struct iwl_rxon_context *ctx;
 	int ret;
 
 	if (!priv->tx_cmd_pool)
 		priv->tx_cmd_pool =
-			kmem_cache_create("iwlagn_dev_cmd",
+			kmem_cache_create("iwl_dev_cmd",
 					  sizeof(struct iwl_device_cmd),
 					  sizeof(void *), 0, NULL);
 
@@ -447,12 +447,12 @@ static int iwlagn_alive_notify(struct iwl_priv *priv)
 	for_each_context(priv, ctx)
 		ctx->last_tx_rejected = false;
 
-	ret = iwlagn_send_wimax_coex(priv);
+	ret = iwl_send_wimax_coex(priv);
 	if (ret)
 		return ret;
 
 	if (!priv->cfg->no_xtal_calib) {
-		ret = iwlagn_set_Xtal_calib(priv);
+		ret = iwl_set_Xtal_calib(priv);
 		if (ret)
 			return ret;
 	}
@@ -548,7 +548,7 @@ struct iwlagn_alive_data {
 	u8 subtype;
 };
 
-static void iwlagn_alive_fn(struct iwl_priv *priv,
+static void iwl_alive_fn(struct iwl_priv *priv,
 			    struct iwl_rx_packet *pkt,
 			    void *data)
 {
@@ -587,12 +587,12 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 		return ret;
 
 	iwlagn_init_notification_wait(priv, &alive_wait, REPLY_ALIVE,
-				      iwlagn_alive_fn, &alive_data);
+				      iwl_alive_fn, &alive_data);
 
 	old_type = priv->ucode_type;
 	priv->ucode_type = ucode_type;
 
-	ret = iwlagn_load_given_ucode(trans(priv), ucode_type);
+	ret = iwl_load_given_ucode(trans(priv), ucode_type);
 	if (ret) {
 		priv->ucode_type = old_type;
 		iwlagn_remove_notification(priv, &alive_wait);
@@ -633,7 +633,7 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 		msleep(5);
 	}
 
-	ret = iwlagn_alive_notify(priv);
+	ret = iwl_alive_notify(priv);
 	if (ret) {
 		IWL_WARN(priv,
 			"Could not complete ALIVE transition: %d\n", ret);
-- 
1.7.0.4

