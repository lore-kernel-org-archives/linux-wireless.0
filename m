Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27087 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760188Ab1LPQh7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:59 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 21/24] iwlwifi: remove most of the iwl_priv references from iwl-ucode.c
Date: Fri, 16 Dec 2011 07:37:26 -0800
Message-Id: <1324049849-831-22-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173829_919713_C9B4CEB0)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Remove all but the last few references to iwl_priv from the lower
level iwl-ucode.c, with resulting code changes.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    6 --
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    5 +-
 drivers/net/wireless/iwlwifi/iwl-testmode.c |   14 ++--
 drivers/net/wireless/iwlwifi/iwl-ucode.c    |  103 ++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-wifi.h     |   74 +++++++++++++++++++
 7 files changed, 140 insertions(+), 66 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-wifi.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index cf22f48..64cf439 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -32,6 +32,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 
+#include "iwl-wifi.h"
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
@@ -1195,7 +1196,7 @@ int iwlagn_suspend(struct iwl_priv *priv,
 
 	priv->shrd->wowlan = true;
 
-	ret = iwlagn_load_ucode_wait_alive(priv, IWL_UCODE_WOWLAN);
+	ret = iwl_load_ucode_wait_alive(trans(priv), IWL_UCODE_WOWLAN);
 	if (ret)
 		goto out;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f7e089d..b2d95e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -43,6 +43,7 @@
 #include <asm/div64.h>
 
 #include "iwl-eeprom.h"
+#include "iwl-wifi.h"
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 2c5b6c4..f84fb3c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -109,11 +109,6 @@ void iwlagn_config_ht40(struct ieee80211_conf *conf,
 int iwlagn_rx_calib_result(struct iwl_priv *priv,
 			    struct iwl_rx_mem_buffer *rxb,
 			    struct iwl_device_cmd *cmd);
-int iwl_send_bt_env(struct iwl_trans *trans, u8 action, u8 type);
-void iwl_send_prio_tbl(struct iwl_trans *trans);
-int iwlagn_run_init_ucode(struct iwl_priv *priv);
-int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
-				 enum iwl_ucode_type ucode_type);
 
 /* lib */
 int iwlagn_send_tx_power(struct iwl_priv *priv);
@@ -359,7 +354,6 @@ static inline __le32 iwl_hw_set_rate_n_flags(u8 rate, u32 flags)
 void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv);
 void iwl_eeprom_get_mac(const struct iwl_shared *shrd, u8 *mac);
 
-extern int iwlagn_init_alive_start(struct iwl_priv *priv);
 extern int iwl_alive_start(struct iwl_priv *priv);
 /* svtool */
 #ifdef CONFIG_IWLWIFI_DEVICE_TESTMODE
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 412ff48..da68958 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -44,6 +44,7 @@
 #include <asm/div64.h>
 
 #include "iwl-eeprom.h"
+#include "iwl-wifi.h"
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
@@ -274,13 +275,13 @@ static int __iwl_up(struct iwl_priv *priv)
 		}
 	}
 
-	ret = iwlagn_run_init_ucode(priv);
+	ret = iwl_run_init_ucode(trans(priv));
 	if (ret) {
 		IWL_ERR(priv, "Failed to run INIT ucode: %d\n", ret);
 		goto error;
 	}
 
-	ret = iwlagn_load_ucode_wait_alive(priv, IWL_UCODE_REGULAR);
+	ret = iwl_load_ucode_wait_alive(trans(priv), IWL_UCODE_REGULAR);
 	if (ret) {
 		IWL_ERR(priv, "Failed to start RT ucode: %d\n", ret);
 		goto error;
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 0fb962e..db8a0d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -70,6 +70,7 @@
 #include <net/mac80211.h>
 #include <net/netlink.h>
 
+#include "iwl-wifi.h"
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-debug.h"
@@ -380,7 +381,7 @@ static int iwl_testmode_cfg_init_calib(struct iwl_priv *priv)
 	iwl_init_notification_wait(priv->shrd, &calib_wait,
 				      CALIBRATION_COMPLETE_NOTIFICATION,
 				      NULL, NULL);
-	ret = iwlagn_init_alive_start(priv);
+	ret = iwl_init_alive_start(trans(priv));
 	if (ret) {
 		IWL_DEBUG_INFO(priv,
 			"Error configuring init calibration: %d\n", ret);
@@ -417,6 +418,7 @@ cfg_init_calib_error:
 static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 {
 	struct iwl_priv *priv = hw->priv;
+	struct iwl_trans *trans = trans(priv);
 	struct sk_buff *skb;
 	unsigned char *rsp_data_ptr = NULL;
 	int status = 0, rsp_data_len = 0;
@@ -445,7 +447,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 		break;
 
 	case IWL_TM_CMD_APP2DEV_LOAD_INIT_FW:
-		status = iwlagn_load_ucode_wait_alive(priv, IWL_UCODE_INIT);
+		status = iwl_load_ucode_wait_alive(trans, IWL_UCODE_INIT);
 		if (status)
 			IWL_DEBUG_INFO(priv,
 				"Error loading init ucode: %d\n", status);
@@ -453,11 +455,11 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 
 	case IWL_TM_CMD_APP2DEV_CFG_INIT_CALIB:
 		iwl_testmode_cfg_init_calib(priv);
-		iwl_trans_stop_device(trans(priv));
+		iwl_trans_stop_device(trans);
 		break;
 
 	case IWL_TM_CMD_APP2DEV_LOAD_RUNTIME_FW:
-		status = iwlagn_load_ucode_wait_alive(priv, IWL_UCODE_REGULAR);
+		status = iwl_load_ucode_wait_alive(trans, IWL_UCODE_REGULAR);
 		if (status) {
 			IWL_DEBUG_INFO(priv,
 				"Error loading runtime ucode: %d\n", status);
@@ -471,8 +473,8 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 
 	case IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW:
 		iwl_scan_cancel_timeout(priv, 200);
-		iwl_trans_stop_device(trans(priv));
-		status = iwlagn_load_ucode_wait_alive(priv, IWL_UCODE_WOWLAN);
+		iwl_trans_stop_device(trans);
+		status = iwl_load_ucode_wait_alive(trans, IWL_UCODE_WOWLAN);
 		if (status) {
 			IWL_DEBUG_INFO(priv,
 				"Error loading WOWLAN ucode: %d\n", status);
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 5ed8217..36a1b5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -33,6 +33,7 @@
 #include <linux/sched.h>
 #include <linux/dma-mapping.h>
 
+#include "iwl-wifi.h"
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
@@ -213,23 +214,23 @@ static int iwl_load_given_ucode(struct iwl_trans *trans,
 /*
  *  Calibration
  */
-static int iwl_set_Xtal_calib(struct iwl_priv *priv)
+static int iwl_set_Xtal_calib(struct iwl_trans *trans)
 {
 	struct iwl_calib_xtal_freq_cmd cmd;
 	__le16 *xtal_calib =
-		(__le16 *)iwl_eeprom_query_addr(priv->shrd, EEPROM_XTAL);
+		(__le16 *)iwl_eeprom_query_addr(trans->shrd, EEPROM_XTAL);
 
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD);
 	cmd.cap_pin1 = le16_to_cpu(xtal_calib[0]);
 	cmd.cap_pin2 = le16_to_cpu(xtal_calib[1]);
-	return iwl_calib_set(trans(priv), (void *)&cmd, sizeof(cmd));
+	return iwl_calib_set(trans, (void *)&cmd, sizeof(cmd));
 }
 
-static int iwl_set_temperature_offset_calib(struct iwl_priv *priv)
+static int iwl_set_temperature_offset_calib(struct iwl_trans *trans)
 {
 	struct iwl_calib_temperature_offset_cmd cmd;
 	__le16 *offset_calib =
-		(__le16 *)iwl_eeprom_query_addr(priv->shrd,
+		(__le16 *)iwl_eeprom_query_addr(trans->shrd,
 						EEPROM_RAW_TEMPERATURE);
 
 	memset(&cmd, 0, sizeof(cmd));
@@ -238,45 +239,45 @@ static int iwl_set_temperature_offset_calib(struct iwl_priv *priv)
 	if (!(cmd.radio_sensor_offset))
 		cmd.radio_sensor_offset = DEFAULT_RADIO_SENSOR_OFFSET;
 
-	IWL_DEBUG_CALIB(priv, "Radio sensor offset: %d\n",
+	IWL_DEBUG_CALIB(trans, "Radio sensor offset: %d\n",
 			le16_to_cpu(cmd.radio_sensor_offset));
-	return iwl_calib_set(trans(priv), (void *)&cmd, sizeof(cmd));
+	return iwl_calib_set(trans, (void *)&cmd, sizeof(cmd));
 }
 
-static int iwl_set_temperature_offset_calib_v2(struct iwl_priv *priv)
+static int iwl_set_temperature_offset_calib_v2(struct iwl_trans *trans)
 {
 	struct iwl_calib_temperature_offset_v2_cmd cmd;
-	__le16 *offset_calib_high = (__le16 *)iwl_eeprom_query_addr(priv->shrd,
+	__le16 *offset_calib_high = (__le16 *)iwl_eeprom_query_addr(trans->shrd,
 				     EEPROM_KELVIN_TEMPERATURE);
 	__le16 *offset_calib_low =
-		(__le16 *)iwl_eeprom_query_addr(priv->shrd,
+		(__le16 *)iwl_eeprom_query_addr(trans->shrd,
 						EEPROM_RAW_TEMPERATURE);
 	struct iwl_eeprom_calib_hdr *hdr;
 
 	memset(&cmd, 0, sizeof(cmd));
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD);
-	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(priv->shrd,
+	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(trans->shrd,
 							EEPROM_CALIB_ALL);
 	memcpy(&cmd.radio_sensor_offset_high, offset_calib_high,
 		sizeof(*offset_calib_high));
 	memcpy(&cmd.radio_sensor_offset_low, offset_calib_low,
 		sizeof(*offset_calib_low));
 	if (!(cmd.radio_sensor_offset_low)) {
-		IWL_DEBUG_CALIB(priv, "no info in EEPROM, use default\n");
+		IWL_DEBUG_CALIB(trans, "no info in EEPROM, use default\n");
 		cmd.radio_sensor_offset_low = DEFAULT_RADIO_SENSOR_OFFSET;
 		cmd.radio_sensor_offset_high = DEFAULT_RADIO_SENSOR_OFFSET;
 	}
 	memcpy(&cmd.burntVoltageRef, &hdr->voltage,
 		sizeof(hdr->voltage));
 
-	IWL_DEBUG_CALIB(priv, "Radio sensor offset high: %d\n",
+	IWL_DEBUG_CALIB(trans, "Radio sensor offset high: %d\n",
 			le16_to_cpu(cmd.radio_sensor_offset_high));
-	IWL_DEBUG_CALIB(priv, "Radio sensor offset low: %d\n",
+	IWL_DEBUG_CALIB(trans, "Radio sensor offset low: %d\n",
 			le16_to_cpu(cmd.radio_sensor_offset_low));
-	IWL_DEBUG_CALIB(priv, "Voltage Ref: %d\n",
+	IWL_DEBUG_CALIB(trans, "Voltage Ref: %d\n",
 			le16_to_cpu(cmd.burntVoltageRef));
 
-	return iwl_calib_set(trans(priv), (void *)&cmd, sizeof(cmd));
+	return iwl_calib_set(trans, (void *)&cmd, sizeof(cmd));
 }
 
 static int iwl_send_calib_cfg(struct iwl_trans *trans)
@@ -316,26 +317,26 @@ int iwlagn_rx_calib_result(struct iwl_priv *priv,
 	return 0;
 }
 
-int iwlagn_init_alive_start(struct iwl_priv *priv)
+int iwl_init_alive_start(struct iwl_trans *trans)
 {
 	int ret;
 
-	if (cfg(priv)->bt_params &&
-	    cfg(priv)->bt_params->advanced_bt_coexist) {
+	if (cfg(trans)->bt_params &&
+	    cfg(trans)->bt_params->advanced_bt_coexist) {
 		/*
 		 * Tell uCode we are ready to perform calibration
 		 * need to perform this before any calibration
 		 * no need to close the envlope since we are going
 		 * to load the runtime uCode later.
 		 */
-		ret = iwl_send_bt_env(trans(priv), IWL_BT_COEX_ENV_OPEN,
+		ret = iwl_send_bt_env(trans, IWL_BT_COEX_ENV_OPEN,
 			BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
 		if (ret)
 			return ret;
 
 	}
 
-	ret = iwl_send_calib_cfg(trans(priv));
+	ret = iwl_send_calib_cfg(trans);
 	if (ret)
 		return ret;
 
@@ -343,21 +344,21 @@ int iwlagn_init_alive_start(struct iwl_priv *priv)
 	 * temperature offset calibration is only needed for runtime ucode,
 	 * so prepare the value now.
 	 */
-	if (cfg(priv)->need_temp_offset_calib) {
-		if (cfg(priv)->temp_offset_v2)
-			return iwl_set_temperature_offset_calib_v2(priv);
+	if (cfg(trans)->need_temp_offset_calib) {
+		if (cfg(trans)->temp_offset_v2)
+			return iwl_set_temperature_offset_calib_v2(trans);
 		else
-			return iwl_set_temperature_offset_calib(priv);
+			return iwl_set_temperature_offset_calib(trans);
 	}
 
 	return 0;
 }
 
-static int iwl_send_wimax_coex(struct iwl_priv *priv)
+static int iwl_send_wimax_coex(struct iwl_trans *trans)
 {
 	struct iwl_wimax_coex_cmd coex_cmd;
 
-	if (cfg(priv)->base_params->support_wimax_coexist) {
+	if (cfg(trans)->base_params->support_wimax_coexist) {
 		/* UnMask wake up src at associated sleep */
 		coex_cmd.flags = COEX_FLAGS_ASSOC_WA_UNMASK_MSK;
 
@@ -376,7 +377,7 @@ static int iwl_send_wimax_coex(struct iwl_priv *priv)
 		/* coexistence is disabled */
 		memset(&coex_cmd, 0, sizeof(coex_cmd));
 	}
-	return iwl_trans_send_cmd_pdu(trans(priv),
+	return iwl_trans_send_cmd_pdu(trans,
 				COEX_PRIORITY_TABLE_CMD, CMD_SYNC,
 				sizeof(coex_cmd), &coex_cmd);
 }
@@ -431,8 +432,9 @@ int iwl_send_bt_env(struct iwl_trans *trans, u8 action, u8 type)
 }
 
 
-static int iwl_alive_notify(struct iwl_priv *priv)
+static int iwl_alive_notify(struct iwl_trans *trans)
 {
+	struct iwl_priv *priv = priv(trans);
 	struct iwl_rxon_context *ctx;
 	int ret;
 
@@ -445,21 +447,21 @@ static int iwl_alive_notify(struct iwl_priv *priv)
 	if (!priv->tx_cmd_pool)
 		return -ENOMEM;
 
-	iwl_trans_tx_start(trans(priv));
+	iwl_trans_tx_start(trans);
 	for_each_context(priv, ctx)
 		ctx->last_tx_rejected = false;
 
-	ret = iwl_send_wimax_coex(priv);
+	ret = iwl_send_wimax_coex(trans);
 	if (ret)
 		return ret;
 
 	if (!cfg(priv)->no_xtal_calib) {
-		ret = iwl_set_Xtal_calib(priv);
+		ret = iwl_set_Xtal_calib(trans);
 		if (ret)
 			return ret;
 	}
 
-	return iwl_send_calib_results(trans(priv));
+	return iwl_send_calib_results(trans);
 }
 
 
@@ -545,7 +547,7 @@ static int iwl_verify_ucode(struct iwl_trans *trans,
 	return -EIO;
 }
 
-struct iwlagn_alive_data {
+struct iwl_alive_data {
 	bool valid;
 	u8 subtype;
 };
@@ -554,7 +556,7 @@ static void iwl_alive_fn(struct iwl_trans *trans,
 			    struct iwl_rx_packet *pkt,
 			    void *data)
 {
-	struct iwlagn_alive_data *alive_data = data;
+	struct iwl_alive_data *alive_data = data;
 	struct iwl_alive_resp *palive;
 
 	palive = &pkt->u.alive_frame;
@@ -640,12 +642,11 @@ void iwl_abort_notification_waits(struct iwl_shared *shrd)
 #define UCODE_ALIVE_TIMEOUT	HZ
 #define UCODE_CALIB_TIMEOUT	(2*HZ)
 
-int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
+int iwl_load_ucode_wait_alive(struct iwl_trans *trans,
 				 enum iwl_ucode_type ucode_type)
 {
 	struct iwl_notification_wait alive_wait;
-	struct iwlagn_alive_data alive_data;
-	struct iwl_trans *trans = trans(priv);
+	struct iwl_alive_data alive_data;
 	int ret;
 	enum iwl_ucode_type old_type;
 
@@ -680,7 +681,7 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 	}
 
 	if (!alive_data.valid) {
-		IWL_ERR(priv, "Loaded ucode is not valid!\n");
+		IWL_ERR(trans, "Loaded ucode is not valid!\n");
 		trans->shrd->ucode_type = old_type;
 		return -EIO;
 	}
@@ -701,9 +702,9 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 		msleep(5);
 	}
 
-	ret = iwl_alive_notify(priv);
+	ret = iwl_alive_notify(trans);
 	if (ret) {
-		IWL_WARN(priv,
+		IWL_WARN(trans,
 			"Could not complete ALIVE transition: %d\n", ret);
 		trans->shrd->ucode_type = old_type;
 		return ret;
@@ -712,30 +713,30 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 	return 0;
 }
 
-int iwlagn_run_init_ucode(struct iwl_priv *priv)
+int iwl_run_init_ucode(struct iwl_trans *trans)
 {
 	struct iwl_notification_wait calib_wait;
 	int ret;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&trans->shrd->mutex);
 
 	/* No init ucode required? Curious, but maybe ok */
-	if (!trans(priv)->ucode_init.code.len)
+	if (!trans->ucode_init.code.len)
 		return 0;
 
-	if (priv->shrd->ucode_type != IWL_UCODE_NONE)
+	if (trans->shrd->ucode_type != IWL_UCODE_NONE)
 		return 0;
 
-	iwl_init_notification_wait(priv->shrd, &calib_wait,
+	iwl_init_notification_wait(trans->shrd, &calib_wait,
 				      CALIBRATION_COMPLETE_NOTIFICATION,
 				      NULL, NULL);
 
 	/* Will also start the device */
-	ret = iwlagn_load_ucode_wait_alive(priv, IWL_UCODE_INIT);
+	ret = iwl_load_ucode_wait_alive(trans, IWL_UCODE_INIT);
 	if (ret)
 		goto error;
 
-	ret = iwlagn_init_alive_start(priv);
+	ret = iwl_init_alive_start(trans);
 	if (ret)
 		goto error;
 
@@ -743,15 +744,15 @@ int iwlagn_run_init_ucode(struct iwl_priv *priv)
 	 * Some things may run in the background now, but we
 	 * just wait for the calibration complete notification.
 	 */
-	ret = iwl_wait_notification(priv->shrd, &calib_wait,
+	ret = iwl_wait_notification(trans->shrd, &calib_wait,
 					UCODE_CALIB_TIMEOUT);
 
 	goto out;
 
  error:
-	iwl_remove_notification(priv->shrd, &calib_wait);
+	iwl_remove_notification(trans->shrd, &calib_wait);
  out:
 	/* Whatever happened, stop the device */
-	iwl_trans_stop_device(trans(priv));
+	iwl_trans_stop_device(trans);
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-wifi.h b/drivers/net/wireless/iwlwifi/iwl-wifi.h
new file mode 100644
index 0000000..1850110
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-wifi.h
@@ -0,0 +1,74 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *****************************************************************************/
+
+#ifndef __iwl_wifi_h__
+#define __iwl_wifi_h__
+
+#include "iwl-shared.h"
+
+int iwl_send_bt_env(struct iwl_trans *trans, u8 action, u8 type);
+void iwl_send_prio_tbl(struct iwl_trans *trans);
+int iwl_init_alive_start(struct iwl_trans *trans);
+int iwl_run_init_ucode(struct iwl_trans *trans);
+int iwl_load_ucode_wait_alive(struct iwl_trans *trans,
+				 enum iwl_ucode_type ucode_type);
+#endif  /* __iwl_wifi_h__ */
-- 
1.7.0.4

