Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54587 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035Ab2CDUnD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:03 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 034/101] iwlwifi: move ucode loading to op_mode
Date: Sun,  4 Mar 2012 11:28:48 -0800
Message-Id: <1330889395-533-35-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214348_321200_AE148ACC)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

uCode loading belongs to the op_mode, as it
is dependent on various things there and the
commands sent during it are specific to it.
Move the prototypes to iwl-agn.h to indicate
this. To make this possible, also move all
the calibration handling (which is op_mode
dependent after all).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c  |   26 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c        |    9 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h        |   10 ++
 drivers/net/wireless/iwlwifi/iwl-dev.h        |    2 +
 drivers/net/wireless/iwlwifi/iwl-mac80211.c   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h     |   14 +-
 drivers/net/wireless/iwlwifi/iwl-testmode.c   |    8 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans.h      |   19 ---
 drivers/net/wireless/iwlwifi/iwl-ucode.c      |  205 ++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-wifi.h       |    8 -
 13 files changed, 150 insertions(+), 160 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 84fc5ce..29f9459 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -75,6 +75,14 @@
  * INIT calibrations framework
  *****************************************************************************/
 
+/* Opaque calibration results */
+struct iwl_calib_result {
+	struct list_head list;
+	size_t cmd_len;
+	struct iwl_calib_hdr hdr;
+	/* data follows */
+};
+
 struct statistics_general_data {
 	u32 beacon_silence_rssi_a;
 	u32 beacon_silence_rssi_b;
@@ -84,7 +92,7 @@ struct statistics_general_data {
 	u32 beacon_energy_c;
 };
 
-int iwl_send_calib_results(struct iwl_trans *trans)
+int iwl_send_calib_results(struct iwl_priv *priv)
 {
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_PHY_CALIBRATION_CMD,
@@ -92,15 +100,15 @@ int iwl_send_calib_results(struct iwl_trans *trans)
 	};
 	struct iwl_calib_result *res;
 
-	list_for_each_entry(res, &trans->calib_results, list) {
+	list_for_each_entry(res, &priv->calib_results, list) {
 		int ret;
 
 		hcmd.len[0] = res->cmd_len;
 		hcmd.data[0] = &res->hdr;
 		hcmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
-		ret = iwl_trans_send_cmd(trans, &hcmd);
+		ret = iwl_trans_send_cmd(trans(priv), &hcmd);
 		if (ret) {
-			IWL_ERR(trans, "Error %d on calib cmd %d\n",
+			IWL_ERR(priv, "Error %d on calib cmd %d\n",
 				ret, res->hdr.op_code);
 			return ret;
 		}
@@ -109,7 +117,7 @@ int iwl_send_calib_results(struct iwl_trans *trans)
 	return 0;
 }
 
-int iwl_calib_set(struct iwl_trans *trans,
+int iwl_calib_set(struct iwl_priv *priv,
 		  const struct iwl_calib_hdr *cmd, int len)
 {
 	struct iwl_calib_result *res, *tmp;
@@ -121,7 +129,7 @@ int iwl_calib_set(struct iwl_trans *trans,
 	memcpy(&res->hdr, cmd, len);
 	res->cmd_len = len;
 
-	list_for_each_entry(tmp, &trans->calib_results, list) {
+	list_for_each_entry(tmp, &priv->calib_results, list) {
 		if (tmp->hdr.op_code == res->hdr.op_code) {
 			list_replace(&tmp->list, &res->list);
 			kfree(tmp);
@@ -130,16 +138,16 @@ int iwl_calib_set(struct iwl_trans *trans,
 	}
 
 	/* wasn't in list already */
-	list_add_tail(&res->list, &trans->calib_results);
+	list_add_tail(&res->list, &priv->calib_results);
 
 	return 0;
 }
 
-void iwl_calib_free_results(struct iwl_trans *trans)
+void iwl_calib_free_results(struct iwl_priv *priv)
 {
 	struct iwl_calib_result *res, *tmp;
 
-	list_for_each_entry_safe(res, tmp, &trans->calib_results, list) {
+	list_for_each_entry_safe(res, tmp, &priv->calib_results, list) {
 		list_del(&res->list);
 		kfree(res);
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index e96af51..45b060a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1195,7 +1195,7 @@ int iwlagn_suspend(struct iwl_priv *priv,
 
 	priv->wowlan = true;
 
-	ret = iwl_load_ucode_wait_alive(trans(priv), IWL_UCODE_WOWLAN);
+	ret = iwl_load_ucode_wait_alive(priv, IWL_UCODE_WOWLAN);
 	if (ret)
 		goto out;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 8e025e0..d16e73d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -1177,7 +1177,7 @@ int iwl_rx_dispatch(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
 				pkt->hdr.cmd);
 			w->triggered = true;
 			if (w->fn)
-				w->fn(trans(priv), pkt, w->fn_data);
+				w->fn(priv, pkt, w->fn_data);
 		}
 		spin_unlock(&priv->shrd->notif_wait_lock);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8bb3f17..f53308f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -671,14 +671,14 @@ int iwl_alive_start(struct iwl_priv *priv)
 		priv->bt_valid = IWLAGN_BT_VALID_ENABLE_FLAGS;
 		priv->cur_rssi_ctx = NULL;
 
-		iwl_send_prio_tbl(trans(priv));
+		iwl_send_prio_tbl(priv);
 
 		/* FIXME: w/a to force change uCode BT state machine */
-		ret = iwl_send_bt_env(trans(priv), IWL_BT_COEX_ENV_OPEN,
+		ret = iwl_send_bt_env(priv, IWL_BT_COEX_ENV_OPEN,
 					 BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
 		if (ret)
 			return ret;
-		ret = iwl_send_bt_env(trans(priv), IWL_BT_COEX_ENV_CLOSE,
+		ret = iwl_send_bt_env(priv, IWL_BT_COEX_ENV_CLOSE,
 					 BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
 		if (ret)
 			return ret;
@@ -1040,7 +1040,7 @@ static int iwl_init_drv(struct iwl_priv *priv)
 
 	mutex_init(&priv->shrd->mutex);
 
-	INIT_LIST_HEAD(&trans(priv)->calib_results);
+	INIT_LIST_HEAD(&priv->calib_results);
 
 	priv->ieee_channels = NULL;
 	priv->ieee_rates = NULL;
@@ -1105,6 +1105,7 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 	kfree(priv->scan_cmd);
 	kfree(priv->beacon_cmd);
 	kfree(rcu_dereference_raw(priv->noa_data));
+	iwl_calib_free_results(priv);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	kfree(priv->wowlan_sram);
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 70100f9..2a90d77 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -113,6 +113,16 @@ int iwlagn_rx_calib_result(struct iwl_priv *priv,
 			    struct iwl_rx_cmd_buffer *rxb,
 			    struct iwl_device_cmd *cmd);
 void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags);
+int iwl_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
+void iwl_send_prio_tbl(struct iwl_priv *priv);
+int iwl_init_alive_start(struct iwl_priv *priv);
+int iwl_run_init_ucode(struct iwl_priv *priv);
+int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
+			      enum iwl_ucode_type ucode_type);
+int iwl_send_calib_results(struct iwl_priv *priv);
+int iwl_calib_set(struct iwl_priv *priv,
+		  const struct iwl_calib_hdr *cmd, int len);
+void iwl_calib_free_results(struct iwl_priv *priv);
 
 /* lib */
 int iwlagn_send_tx_power(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 5957209..7199748 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -724,6 +724,8 @@ struct iwl_priv {
 	struct ieee80211_rate *ieee_rates;
 	struct kmem_cache *tx_cmd_pool;
 
+	struct list_head calib_results;
+
 	struct workqueue_struct *workqueue;
 
 	enum ieee80211_band band;
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 7f93715..37330ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -278,13 +278,13 @@ static int __iwl_up(struct iwl_priv *priv)
 		}
 	}
 
-	ret = iwl_run_init_ucode(trans(priv));
+	ret = iwl_run_init_ucode(priv);
 	if (ret) {
 		IWL_ERR(priv, "Failed to run INIT ucode: %d\n", ret);
 		goto error;
 	}
 
-	ret = iwl_load_ucode_wait_alive(trans(priv), IWL_UCODE_REGULAR);
+	ret = iwl_load_ucode_wait_alive(priv, IWL_UCODE_REGULAR);
 	if (ret) {
 		IWL_ERR(priv, "Failed to start RT ucode: %d\n", ret);
 		goto error;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index ef80e03..dc55446 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -233,7 +233,7 @@ enum iwl_ucode_type {
 struct iwl_notification_wait {
 	struct list_head list;
 
-	void (*fn)(struct iwl_trans *trans, struct iwl_rx_packet *pkt,
+	void (*fn)(struct iwl_priv *priv, struct iwl_rx_packet *pkt,
 		   void *data);
 	void *fn_data;
 
@@ -472,12 +472,12 @@ bool iwl_check_for_ct_kill(struct iwl_priv *priv);
 void iwl_abort_notification_waits(struct iwl_shared *shrd);
 void __acquires(wait_entry)
 iwl_init_notification_wait(struct iwl_shared *shrd,
-			      struct iwl_notification_wait *wait_entry,
-			      u8 cmd,
-			      void (*fn)(struct iwl_trans *trans,
-					 struct iwl_rx_packet *pkt,
-					 void *data),
-			      void *fn_data);
+			   struct iwl_notification_wait *wait_entry,
+			   u8 cmd,
+			   void (*fn)(struct iwl_priv *priv,
+				      struct iwl_rx_packet *pkt,
+				      void *data),
+			   void *fn_data);
 int __must_check __releases(wait_entry)
 iwl_wait_notification(struct iwl_shared *shrd,
 			 struct iwl_notification_wait *wait_entry,
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index b24b166..ec803ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -422,7 +422,7 @@ static int iwl_testmode_cfg_init_calib(struct iwl_priv *priv)
 	iwl_init_notification_wait(priv->shrd, &calib_wait,
 				      CALIBRATION_COMPLETE_NOTIFICATION,
 				      NULL, NULL);
-	ret = iwl_init_alive_start(trans(priv));
+	ret = iwl_init_alive_start(priv);
 	if (ret) {
 		IWL_ERR(priv, "Fail init calibration: %d\n", ret);
 		goto cfg_init_calib_error;
@@ -484,7 +484,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 		break;
 
 	case IWL_TM_CMD_APP2DEV_LOAD_INIT_FW:
-		status = iwl_load_ucode_wait_alive(trans, IWL_UCODE_INIT);
+		status = iwl_load_ucode_wait_alive(priv, IWL_UCODE_INIT);
 		if (status)
 			IWL_ERR(priv, "Error loading init ucode: %d\n", status);
 		break;
@@ -495,7 +495,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 		break;
 
 	case IWL_TM_CMD_APP2DEV_LOAD_RUNTIME_FW:
-		status = iwl_load_ucode_wait_alive(trans, IWL_UCODE_REGULAR);
+		status = iwl_load_ucode_wait_alive(priv, IWL_UCODE_REGULAR);
 		if (status) {
 			IWL_ERR(priv,
 				"Error loading runtime ucode: %d\n", status);
@@ -510,7 +510,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 	case IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW:
 		iwl_scan_cancel_timeout(priv, 200);
 		iwl_trans_stop_device(trans);
-		status = iwl_load_ucode_wait_alive(trans, IWL_UCODE_WOWLAN);
+		status = iwl_load_ucode_wait_alive(priv, IWL_UCODE_WOWLAN);
 		if (status) {
 			IWL_ERR(priv,
 				"Error loading WOWLAN ucode: %d\n", status);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 3ae2fd7..f49aa18 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1632,7 +1632,6 @@ static void iwl_trans_pcie_free(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	iwl_calib_free_results(trans);
 	iwl_trans_pcie_tx_free(trans);
 #ifndef CONFIG_IWLWIFI_IDI
 	iwl_trans_pcie_rx_free(trans);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index b09192a..6fa0c86 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -315,14 +315,6 @@ struct iwl_trans_ops {
 	u32 (*read32)(struct iwl_trans *trans, u32 ofs);
 };
 
-/* Opaque calibration results */
-struct iwl_calib_result {
-	struct list_head list;
-	size_t cmd_len;
-	struct iwl_calib_hdr hdr;
-	/* data follows */
-};
-
 /**
  * enum iwl_trans_state - state of the transport layer
  *
@@ -349,7 +341,6 @@ enum iwl_trans_state {
  * @ucode_write_complete: indicates that the ucode has been copied.
  * @nvm_device_type: indicates OTP or eeprom
  * @pm_support: set to true in start_hw if link pm is supported
- * @calib_results: list head for init calibration results
  */
 struct iwl_trans {
 	const struct iwl_trans_ops *ops;
@@ -369,8 +360,6 @@ struct iwl_trans {
 	int    nvm_device_type;
 	bool pm_support;
 
-	struct list_head calib_results;
-
 	/* pointer to trans specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
 	char trans_specific[0] __aligned(sizeof(void *));
@@ -574,14 +563,6 @@ static inline u32 iwl_trans_read32(struct iwl_trans *trans, u32 ofs)
 }
 
 /*****************************************************
-* Utils functions
-******************************************************/
-int iwl_send_calib_results(struct iwl_trans *trans);
-int iwl_calib_set(struct iwl_trans *trans,
-		  const struct iwl_calib_hdr *cmd, int len);
-void iwl_calib_free_results(struct iwl_trans *trans);
-
-/*****************************************************
 * Transport layers implementations + their allocation function
 ******************************************************/
 struct pci_dev;
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 64a9c5c..340575a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -80,16 +80,16 @@ static struct iwl_wimax_coex_event_entry cu_priorities[COEX_NUM_OF_EVENTS] = {
  *
  ******************************************************************************/
 
-static inline struct fw_img *iwl_get_ucode_image(struct iwl_nic *nic,
-					enum iwl_ucode_type ucode_type)
+static inline struct fw_img *iwl_get_ucode_image(struct iwl_priv *priv,
+						 enum iwl_ucode_type ucode_type)
 {
 	switch (ucode_type) {
 	case IWL_UCODE_INIT:
-		return &nic->fw.ucode_init;
+		return &nic(priv)->fw.ucode_init;
 	case IWL_UCODE_WOWLAN:
-		return &nic->fw.ucode_wowlan;
+		return &nic(priv)->fw.ucode_wowlan;
 	case IWL_UCODE_REGULAR:
-		return &nic->fw.ucode_rt;
+		return &nic(priv)->fw.ucode_rt;
 	case IWL_UCODE_NONE:
 		break;
 	}
@@ -99,23 +99,23 @@ static inline struct fw_img *iwl_get_ucode_image(struct iwl_nic *nic,
 /*
  *  Calibration
  */
-static int iwl_set_Xtal_calib(struct iwl_trans *trans)
+static int iwl_set_Xtal_calib(struct iwl_priv *priv)
 {
 	struct iwl_calib_xtal_freq_cmd cmd;
 	__le16 *xtal_calib =
-		(__le16 *)iwl_eeprom_query_addr(trans->shrd, EEPROM_XTAL);
+		(__le16 *)iwl_eeprom_query_addr(priv->shrd, EEPROM_XTAL);
 
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD);
 	cmd.cap_pin1 = le16_to_cpu(xtal_calib[0]);
 	cmd.cap_pin2 = le16_to_cpu(xtal_calib[1]);
-	return iwl_calib_set(trans, (void *)&cmd, sizeof(cmd));
+	return iwl_calib_set(priv, (void *)&cmd, sizeof(cmd));
 }
 
-static int iwl_set_temperature_offset_calib(struct iwl_trans *trans)
+static int iwl_set_temperature_offset_calib(struct iwl_priv *priv)
 {
 	struct iwl_calib_temperature_offset_cmd cmd;
 	__le16 *offset_calib =
-		(__le16 *)iwl_eeprom_query_addr(trans->shrd,
+		(__le16 *)iwl_eeprom_query_addr(priv->shrd,
 						EEPROM_RAW_TEMPERATURE);
 
 	memset(&cmd, 0, sizeof(cmd));
@@ -124,48 +124,48 @@ static int iwl_set_temperature_offset_calib(struct iwl_trans *trans)
 	if (!(cmd.radio_sensor_offset))
 		cmd.radio_sensor_offset = DEFAULT_RADIO_SENSOR_OFFSET;
 
-	IWL_DEBUG_CALIB(trans, "Radio sensor offset: %d\n",
+	IWL_DEBUG_CALIB(priv, "Radio sensor offset: %d\n",
 			le16_to_cpu(cmd.radio_sensor_offset));
-	return iwl_calib_set(trans, (void *)&cmd, sizeof(cmd));
+	return iwl_calib_set(priv, (void *)&cmd, sizeof(cmd));
 }
 
-static int iwl_set_temperature_offset_calib_v2(struct iwl_trans *trans)
+static int iwl_set_temperature_offset_calib_v2(struct iwl_priv *priv)
 {
 	struct iwl_calib_temperature_offset_v2_cmd cmd;
-	__le16 *offset_calib_high = (__le16 *)iwl_eeprom_query_addr(trans->shrd,
+	__le16 *offset_calib_high = (__le16 *)iwl_eeprom_query_addr(priv->shrd,
 				     EEPROM_KELVIN_TEMPERATURE);
 	__le16 *offset_calib_low =
-		(__le16 *)iwl_eeprom_query_addr(trans->shrd,
+		(__le16 *)iwl_eeprom_query_addr(priv->shrd,
 						EEPROM_RAW_TEMPERATURE);
 	struct iwl_eeprom_calib_hdr *hdr;
 
 	memset(&cmd, 0, sizeof(cmd));
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD);
-	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(trans->shrd,
+	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(priv->shrd,
 							EEPROM_CALIB_ALL);
 	memcpy(&cmd.radio_sensor_offset_high, offset_calib_high,
 		sizeof(*offset_calib_high));
 	memcpy(&cmd.radio_sensor_offset_low, offset_calib_low,
 		sizeof(*offset_calib_low));
 	if (!(cmd.radio_sensor_offset_low)) {
-		IWL_DEBUG_CALIB(trans, "no info in EEPROM, use default\n");
+		IWL_DEBUG_CALIB(priv, "no info in EEPROM, use default\n");
 		cmd.radio_sensor_offset_low = DEFAULT_RADIO_SENSOR_OFFSET;
 		cmd.radio_sensor_offset_high = DEFAULT_RADIO_SENSOR_OFFSET;
 	}
 	memcpy(&cmd.burntVoltageRef, &hdr->voltage,
 		sizeof(hdr->voltage));
 
-	IWL_DEBUG_CALIB(trans, "Radio sensor offset high: %d\n",
+	IWL_DEBUG_CALIB(priv, "Radio sensor offset high: %d\n",
 			le16_to_cpu(cmd.radio_sensor_offset_high));
-	IWL_DEBUG_CALIB(trans, "Radio sensor offset low: %d\n",
+	IWL_DEBUG_CALIB(priv, "Radio sensor offset low: %d\n",
 			le16_to_cpu(cmd.radio_sensor_offset_low));
-	IWL_DEBUG_CALIB(trans, "Voltage Ref: %d\n",
+	IWL_DEBUG_CALIB(priv, "Voltage Ref: %d\n",
 			le16_to_cpu(cmd.burntVoltageRef));
 
-	return iwl_calib_set(trans, (void *)&cmd, sizeof(cmd));
+	return iwl_calib_set(priv, (void *)&cmd, sizeof(cmd));
 }
 
-static int iwl_send_calib_cfg(struct iwl_trans *trans)
+static int iwl_send_calib_cfg(struct iwl_priv *priv)
 {
 	struct iwl_calib_cfg_cmd calib_cfg_cmd;
 	struct iwl_host_cmd cmd = {
@@ -181,7 +181,7 @@ static int iwl_send_calib_cfg(struct iwl_trans *trans)
 	calib_cfg_cmd.ucd_calib_cfg.flags =
 		IWL_CALIB_CFG_FLAG_SEND_COMPLETE_NTFY_MSK;
 
-	return iwl_trans_send_cmd(trans, &cmd);
+	return iwl_trans_send_cmd(trans(priv), &cmd);
 }
 
 int iwlagn_rx_calib_result(struct iwl_priv *priv,
@@ -195,33 +195,33 @@ int iwlagn_rx_calib_result(struct iwl_priv *priv,
 	/* reduce the size of the length field itself */
 	len -= 4;
 
-	if (iwl_calib_set(trans(priv), hdr, len))
+	if (iwl_calib_set(priv, hdr, len))
 		IWL_ERR(priv, "Failed to record calibration data %d\n",
 			hdr->op_code);
 
 	return 0;
 }
 
-int iwl_init_alive_start(struct iwl_trans *trans)
+int iwl_init_alive_start(struct iwl_priv *priv)
 {
 	int ret;
 
-	if (cfg(trans)->bt_params &&
-	    cfg(trans)->bt_params->advanced_bt_coexist) {
+	if (cfg(priv)->bt_params &&
+	    cfg(priv)->bt_params->advanced_bt_coexist) {
 		/*
 		 * Tell uCode we are ready to perform calibration
 		 * need to perform this before any calibration
 		 * no need to close the envlope since we are going
 		 * to load the runtime uCode later.
 		 */
-		ret = iwl_send_bt_env(trans, IWL_BT_COEX_ENV_OPEN,
+		ret = iwl_send_bt_env(priv, IWL_BT_COEX_ENV_OPEN,
 			BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
 		if (ret)
 			return ret;
 
 	}
 
-	ret = iwl_send_calib_cfg(trans);
+	ret = iwl_send_calib_cfg(priv);
 	if (ret)
 		return ret;
 
@@ -229,21 +229,21 @@ int iwl_init_alive_start(struct iwl_trans *trans)
 	 * temperature offset calibration is only needed for runtime ucode,
 	 * so prepare the value now.
 	 */
-	if (cfg(trans)->need_temp_offset_calib) {
-		if (cfg(trans)->temp_offset_v2)
-			return iwl_set_temperature_offset_calib_v2(trans);
+	if (cfg(priv)->need_temp_offset_calib) {
+		if (cfg(priv)->temp_offset_v2)
+			return iwl_set_temperature_offset_calib_v2(priv);
 		else
-			return iwl_set_temperature_offset_calib(trans);
+			return iwl_set_temperature_offset_calib(priv);
 	}
 
 	return 0;
 }
 
-static int iwl_send_wimax_coex(struct iwl_trans *trans)
+static int iwl_send_wimax_coex(struct iwl_priv *priv)
 {
 	struct iwl_wimax_coex_cmd coex_cmd;
 
-	if (cfg(trans)->base_params->support_wimax_coexist) {
+	if (cfg(priv)->base_params->support_wimax_coexist) {
 		/* UnMask wake up src at associated sleep */
 		coex_cmd.flags = COEX_FLAGS_ASSOC_WA_UNMASK_MSK;
 
@@ -262,7 +262,7 @@ static int iwl_send_wimax_coex(struct iwl_trans *trans)
 		/* coexistence is disabled */
 		memset(&coex_cmd, 0, sizeof(coex_cmd));
 	}
-	return iwl_trans_send_cmd_pdu(trans,
+	return iwl_trans_send_cmd_pdu(trans(priv),
 				COEX_PRIORITY_TABLE_CMD, CMD_SYNC,
 				sizeof(coex_cmd), &coex_cmd);
 }
@@ -289,37 +289,36 @@ static const u8 iwl_bt_prio_tbl[BT_COEX_PRIO_TBL_EVT_MAX] = {
 	0, 0, 0, 0, 0, 0, 0
 };
 
-void iwl_send_prio_tbl(struct iwl_trans *trans)
+void iwl_send_prio_tbl(struct iwl_priv *priv)
 {
 	struct iwl_bt_coex_prio_table_cmd prio_tbl_cmd;
 
 	memcpy(prio_tbl_cmd.prio_tbl, iwl_bt_prio_tbl,
 		sizeof(iwl_bt_prio_tbl));
-	if (iwl_trans_send_cmd_pdu(trans,
+	if (iwl_trans_send_cmd_pdu(trans(priv),
 				REPLY_BT_COEX_PRIO_TABLE, CMD_SYNC,
 				sizeof(prio_tbl_cmd), &prio_tbl_cmd))
-		IWL_ERR(trans, "failed to send BT prio tbl command\n");
+		IWL_ERR(priv, "failed to send BT prio tbl command\n");
 }
 
-int iwl_send_bt_env(struct iwl_trans *trans, u8 action, u8 type)
+int iwl_send_bt_env(struct iwl_priv *priv, u8 action, u8 type)
 {
 	struct iwl_bt_coex_prot_env_cmd env_cmd;
 	int ret;
 
 	env_cmd.action = action;
 	env_cmd.type = type;
-	ret = iwl_trans_send_cmd_pdu(trans,
+	ret = iwl_trans_send_cmd_pdu(trans(priv),
 			       REPLY_BT_COEX_PROT_ENV, CMD_SYNC,
 			       sizeof(env_cmd), &env_cmd);
 	if (ret)
-		IWL_ERR(trans, "failed to send BT env command\n");
+		IWL_ERR(priv, "failed to send BT env command\n");
 	return ret;
 }
 
 
-static int iwl_alive_notify(struct iwl_trans *trans)
+static int iwl_alive_notify(struct iwl_priv *priv)
 {
-	struct iwl_priv *priv = priv(trans);
 	struct iwl_rxon_context *ctx;
 	int ret;
 
@@ -332,21 +331,21 @@ static int iwl_alive_notify(struct iwl_trans *trans)
 	if (!priv->tx_cmd_pool)
 		return -ENOMEM;
 
-	iwl_trans_fw_alive(trans);
+	iwl_trans_fw_alive(trans(priv));
 	for_each_context(priv, ctx)
 		ctx->last_tx_rejected = false;
 
-	ret = iwl_send_wimax_coex(trans);
+	ret = iwl_send_wimax_coex(priv);
 	if (ret)
 		return ret;
 
 	if (!cfg(priv)->no_xtal_calib) {
-		ret = iwl_set_Xtal_calib(trans);
+		ret = iwl_set_Xtal_calib(priv);
 		if (ret)
 			return ret;
 	}
 
-	return iwl_send_calib_results(trans);
+	return iwl_send_calib_results(priv);
 }
 
 
@@ -355,24 +354,23 @@ static int iwl_alive_notify(struct iwl_trans *trans)
  *   using sample data 100 bytes apart.  If these sample points are good,
  *   it's a pretty good bet that everything between them is good, too.
  */
-static int iwl_verify_inst_sparse(struct iwl_nic *nic,
-				      struct fw_desc *fw_desc)
+static int iwl_verify_inst_sparse(struct iwl_priv *priv,
+				  struct fw_desc *fw_desc)
 {
-	struct iwl_trans *trans = trans(nic);
 	__le32 *image = (__le32 *)fw_desc->v_addr;
 	u32 len = fw_desc->len;
 	u32 val;
 	u32 i;
 
-	IWL_DEBUG_FW(nic, "ucode inst image size is %u\n", len);
+	IWL_DEBUG_FW(priv, "ucode inst image size is %u\n", len);
 
 	for (i = 0; i < len; i += 100, image += 100/sizeof(u32)) {
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IWL_DL_IO is set */
-		iwl_write_direct32(trans, HBUS_TARG_MEM_RADDR,
+		iwl_write_direct32(trans(priv), HBUS_TARG_MEM_RADDR,
 			i + IWLAGN_RTC_INST_LOWER_BOUND);
-		val = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
+		val = iwl_read32(trans(priv), HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image))
 			return -EIO;
 	}
@@ -380,28 +378,27 @@ static int iwl_verify_inst_sparse(struct iwl_nic *nic,
 	return 0;
 }
 
-static void iwl_print_mismatch_inst(struct iwl_nic *nic,
+static void iwl_print_mismatch_inst(struct iwl_priv *priv,
 				    struct fw_desc *fw_desc)
 {
-	struct iwl_trans *trans = trans(nic);
 	__le32 *image = (__le32 *)fw_desc->v_addr;
 	u32 len = fw_desc->len;
 	u32 val;
 	u32 offs;
 	int errors = 0;
 
-	IWL_DEBUG_FW(nic, "ucode inst image size is %u\n", len);
+	IWL_DEBUG_FW(priv, "ucode inst image size is %u\n", len);
 
-	iwl_write_direct32(trans, HBUS_TARG_MEM_RADDR,
+	iwl_write_direct32(trans(priv), HBUS_TARG_MEM_RADDR,
 			   IWLAGN_RTC_INST_LOWER_BOUND);
 
 	for (offs = 0;
 	     offs < len && errors < 20;
 	     offs += sizeof(u32), image++) {
 		/* read data comes through single port, auto-incr addr */
-		val = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
+		val = iwl_read32(trans(priv), HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
-			IWL_ERR(nic, "uCode INST section at "
+			IWL_ERR(priv, "uCode INST section at "
 				"offset 0x%x, is 0x%x, s/b 0x%x\n",
 				offs, val, le32_to_cpu(*image));
 			errors++;
@@ -413,24 +410,24 @@ static void iwl_print_mismatch_inst(struct iwl_nic *nic,
  * iwl_verify_ucode - determine which instruction image is in SRAM,
  *    and verify its contents
  */
-static int iwl_verify_ucode(struct iwl_nic *nic,
+static int iwl_verify_ucode(struct iwl_priv *priv,
 			    enum iwl_ucode_type ucode_type)
 {
-	struct fw_img *img = iwl_get_ucode_image(nic, ucode_type);
+	struct fw_img *img = iwl_get_ucode_image(priv, ucode_type);
 
 	if (!img) {
-		IWL_ERR(nic, "Invalid ucode requested (%d)\n", ucode_type);
+		IWL_ERR(priv, "Invalid ucode requested (%d)\n", ucode_type);
 		return -EINVAL;
 	}
 
-	if (!iwl_verify_inst_sparse(nic, &img->code)) {
-		IWL_DEBUG_FW(nic, "uCode is good in inst SRAM\n");
+	if (!iwl_verify_inst_sparse(priv, &img->code)) {
+		IWL_DEBUG_FW(priv, "uCode is good in inst SRAM\n");
 		return 0;
 	}
 
-	IWL_ERR(nic, "UCODE IMAGE IN INSTRUCTION SRAM NOT VALID!!\n");
+	IWL_ERR(priv, "UCODE IMAGE IN INSTRUCTION SRAM NOT VALID!!\n");
 
-	iwl_print_mismatch_inst(nic, &img->code);
+	iwl_print_mismatch_inst(priv, &img->code);
 	return -EIO;
 }
 
@@ -439,7 +436,7 @@ struct iwl_alive_data {
 	u8 subtype;
 };
 
-static void iwl_alive_fn(struct iwl_trans *trans,
+static void iwl_alive_fn(struct iwl_priv *priv,
 			    struct iwl_rx_packet *pkt,
 			    void *data)
 {
@@ -448,14 +445,14 @@ static void iwl_alive_fn(struct iwl_trans *trans,
 
 	palive = &pkt->u.alive_frame;
 
-	IWL_DEBUG_FW(trans, "Alive ucode status 0x%08X revision "
+	IWL_DEBUG_FW(priv, "Alive ucode status 0x%08X revision "
 		       "0x%01X 0x%01X\n",
 		       palive->is_valid, palive->ver_type,
 		       palive->ver_subtype);
 
-	trans->shrd->device_pointers.error_event_table =
+	priv->shrd->device_pointers.error_event_table =
 		le32_to_cpu(palive->error_event_table_ptr);
-	trans->shrd->device_pointers.log_event_table =
+	priv->shrd->device_pointers.log_event_table =
 		le32_to_cpu(palive->log_event_table_ptr);
 
 	alive_data->subtype = palive->ver_subtype;
@@ -464,12 +461,12 @@ static void iwl_alive_fn(struct iwl_trans *trans,
 
 /* notification wait support */
 void iwl_init_notification_wait(struct iwl_shared *shrd,
-				   struct iwl_notification_wait *wait_entry,
-				   u8 cmd,
-				   void (*fn)(struct iwl_trans *trans,
-					      struct iwl_rx_packet *pkt,
-					      void *data),
-				   void *fn_data)
+				struct iwl_notification_wait *wait_entry,
+				u8 cmd,
+				void (*fn)(struct iwl_priv *priv,
+					   struct iwl_rx_packet *pkt,
+					   void *data),
+				void *fn_data)
 {
 	wait_entry->fn = fn;
 	wait_entry->fn_data = fn_data;
@@ -529,7 +526,7 @@ void iwl_abort_notification_waits(struct iwl_shared *shrd)
 #define UCODE_ALIVE_TIMEOUT	HZ
 #define UCODE_CALIB_TIMEOUT	(2*HZ)
 
-int iwl_load_ucode_wait_alive(struct iwl_trans *trans,
+int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 				 enum iwl_ucode_type ucode_type)
 {
 	struct iwl_notification_wait alive_wait;
@@ -538,20 +535,20 @@ int iwl_load_ucode_wait_alive(struct iwl_trans *trans,
 	int ret;
 	enum iwl_ucode_type old_type;
 
-	iwl_init_notification_wait(trans->shrd, &alive_wait, REPLY_ALIVE,
+	iwl_init_notification_wait(priv->shrd, &alive_wait, REPLY_ALIVE,
 				      iwl_alive_fn, &alive_data);
 
-	old_type = trans->shrd->ucode_type;
-	trans->shrd->ucode_type = ucode_type;
-	fw = iwl_get_ucode_image(nic(trans), ucode_type);
+	old_type = priv->shrd->ucode_type;
+	priv->shrd->ucode_type = ucode_type;
+	fw = iwl_get_ucode_image(priv, ucode_type);
 
 	if (!fw)
 		return -EINVAL;
 
-	ret = iwl_trans_start_fw(trans, fw);
+	ret = iwl_trans_start_fw(trans(priv), fw);
 	if (ret) {
-		trans->shrd->ucode_type = old_type;
-		iwl_remove_notification(trans->shrd, &alive_wait);
+		priv->shrd->ucode_type = old_type;
+		iwl_remove_notification(priv->shrd, &alive_wait);
 		return ret;
 	}
 
@@ -559,16 +556,16 @@ int iwl_load_ucode_wait_alive(struct iwl_trans *trans,
 	 * Some things may run in the background now, but we
 	 * just wait for the ALIVE notification here.
 	 */
-	ret = iwl_wait_notification(trans->shrd, &alive_wait,
+	ret = iwl_wait_notification(priv->shrd, &alive_wait,
 					UCODE_ALIVE_TIMEOUT);
 	if (ret) {
-		trans->shrd->ucode_type = old_type;
+		priv->shrd->ucode_type = old_type;
 		return ret;
 	}
 
 	if (!alive_data.valid) {
-		IWL_ERR(trans, "Loaded ucode is not valid!\n");
-		trans->shrd->ucode_type = old_type;
+		IWL_ERR(priv, "Loaded ucode is not valid!\n");
+		priv->shrd->ucode_type = old_type;
 		return -EIO;
 	}
 
@@ -578,9 +575,9 @@ int iwl_load_ucode_wait_alive(struct iwl_trans *trans,
 	 * skip it for WoWLAN.
 	 */
 	if (ucode_type != IWL_UCODE_WOWLAN) {
-		ret = iwl_verify_ucode(nic(trans), ucode_type);
+		ret = iwl_verify_ucode(priv, ucode_type);
 		if (ret) {
-			trans->shrd->ucode_type = old_type;
+			priv->shrd->ucode_type = old_type;
 			return ret;
 		}
 
@@ -588,41 +585,41 @@ int iwl_load_ucode_wait_alive(struct iwl_trans *trans,
 		msleep(5);
 	}
 
-	ret = iwl_alive_notify(trans);
+	ret = iwl_alive_notify(priv);
 	if (ret) {
-		IWL_WARN(trans,
+		IWL_WARN(priv,
 			"Could not complete ALIVE transition: %d\n", ret);
-		trans->shrd->ucode_type = old_type;
+		priv->shrd->ucode_type = old_type;
 		return ret;
 	}
 
 	return 0;
 }
 
-int iwl_run_init_ucode(struct iwl_trans *trans)
+int iwl_run_init_ucode(struct iwl_priv *priv)
 {
 	struct iwl_notification_wait calib_wait;
 	int ret;
 
-	lockdep_assert_held(&trans->shrd->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	/* No init ucode required? Curious, but maybe ok */
-	if (!nic(trans)->fw.ucode_init.code.len)
+	if (!nic(priv)->fw.ucode_init.code.len)
 		return 0;
 
-	if (trans->shrd->ucode_type != IWL_UCODE_NONE)
+	if (priv->shrd->ucode_type != IWL_UCODE_NONE)
 		return 0;
 
-	iwl_init_notification_wait(trans->shrd, &calib_wait,
+	iwl_init_notification_wait(priv->shrd, &calib_wait,
 				      CALIBRATION_COMPLETE_NOTIFICATION,
 				      NULL, NULL);
 
 	/* Will also start the device */
-	ret = iwl_load_ucode_wait_alive(trans, IWL_UCODE_INIT);
+	ret = iwl_load_ucode_wait_alive(priv, IWL_UCODE_INIT);
 	if (ret)
 		goto error;
 
-	ret = iwl_init_alive_start(trans);
+	ret = iwl_init_alive_start(priv);
 	if (ret)
 		goto error;
 
@@ -630,15 +627,15 @@ int iwl_run_init_ucode(struct iwl_trans *trans)
 	 * Some things may run in the background now, but we
 	 * just wait for the calibration complete notification.
 	 */
-	ret = iwl_wait_notification(trans->shrd, &calib_wait,
+	ret = iwl_wait_notification(priv->shrd, &calib_wait,
 					UCODE_CALIB_TIMEOUT);
 
 	goto out;
 
  error:
-	iwl_remove_notification(trans->shrd, &calib_wait);
+	iwl_remove_notification(priv->shrd, &calib_wait);
  out:
 	/* Whatever happened, stop the device */
-	iwl_trans_stop_device(trans);
+	iwl_trans_stop_device(trans(priv));
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-wifi.h b/drivers/net/wireless/iwlwifi/iwl-wifi.h
index d157931..753e338 100644
--- a/drivers/net/wireless/iwlwifi/iwl-wifi.h
+++ b/drivers/net/wireless/iwlwifi/iwl-wifi.h
@@ -95,12 +95,4 @@ struct iwl_nic {
 
 	struct completion request_firmware_complete;
 };
-
-
-int iwl_send_bt_env(struct iwl_trans *trans, u8 action, u8 type);
-void iwl_send_prio_tbl(struct iwl_trans *trans);
-int iwl_init_alive_start(struct iwl_trans *trans);
-int iwl_run_init_ucode(struct iwl_trans *trans);
-int iwl_load_ucode_wait_alive(struct iwl_trans *trans,
-				 enum iwl_ucode_type ucode_type);
 #endif  /* __iwl_wifi_h__ */
-- 
1.7.0.4

