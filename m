Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:23204 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988Ab1LIBZD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 20:25:03 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/15] iwlwifi: move calib_results list from iwl_priv to iwl_trans
Date: Thu,  8 Dec 2011 16:26:19 -0800
Message-Id: <1323390382-1678-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111209_022527_256048_BE5DFBD9)
In-Reply-To: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Move the calib_results list from the upper layer iwl_priv structure
to the lower layer iwl_trans structure.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c  |   18 +++++++++---------
 drivers/net/wireless/iwlwifi/iwl-agn-calib.h  |    5 -----
 drivers/net/wireless/iwlwifi/iwl-agn.c        |    3 +--
 drivers/net/wireless/iwlwifi/iwl-dev.h        |   12 ------------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans.h      |   18 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-ucode.c      |   10 +++++-----
 7 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 4d02105..16971a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -82,7 +82,7 @@ struct statistics_general_data {
 	u32 beacon_energy_c;
 };
 
-int iwl_send_calib_results(struct iwl_priv *priv)
+int iwl_send_calib_results(struct iwl_trans *trans)
 {
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_PHY_CALIBRATION_CMD,
@@ -90,15 +90,15 @@ int iwl_send_calib_results(struct iwl_priv *priv)
 	};
 	struct iwl_calib_result *res;
 
-	list_for_each_entry(res, &priv->calib_results, list) {
+	list_for_each_entry(res, &trans->calib_results, list) {
 		int ret;
 
 		hcmd.len[0] = res->cmd_len;
 		hcmd.data[0] = &res->hdr;
 		hcmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
-		ret = iwl_trans_send_cmd(trans(priv), &hcmd);
+		ret = iwl_trans_send_cmd(trans, &hcmd);
 		if (ret) {
-			IWL_ERR(priv, "Error %d on calib cmd %d\n",
+			IWL_ERR(trans, "Error %d on calib cmd %d\n",
 				ret, res->hdr.op_code);
 			return ret;
 		}
@@ -107,7 +107,7 @@ int iwl_send_calib_results(struct iwl_priv *priv)
 	return 0;
 }
 
-int iwl_calib_set(struct iwl_priv *priv,
+int iwl_calib_set(struct iwl_trans *trans,
 		  const struct iwl_calib_hdr *cmd, int len)
 {
 	struct iwl_calib_result *res, *tmp;
@@ -119,7 +119,7 @@ int iwl_calib_set(struct iwl_priv *priv,
 	memcpy(&res->hdr, cmd, len);
 	res->cmd_len = len;
 
-	list_for_each_entry(tmp, &priv->calib_results, list) {
+	list_for_each_entry(tmp, &trans->calib_results, list) {
 		if (tmp->hdr.op_code == res->hdr.op_code) {
 			list_replace(&tmp->list, &res->list);
 			kfree(tmp);
@@ -128,16 +128,16 @@ int iwl_calib_set(struct iwl_priv *priv,
 	}
 
 	/* wasn't in list already */
-	list_add_tail(&res->list, &priv->calib_results);
+	list_add_tail(&res->list, &trans->calib_results);
 
 	return 0;
 }
 
-void iwl_calib_free_results(struct iwl_priv *priv)
+void iwl_calib_free_results(struct iwl_trans *trans)
 {
 	struct iwl_calib_result *res, *tmp;
 
-	list_for_each_entry_safe(res, tmp, &priv->calib_results, list) {
+	list_for_each_entry_safe(res, tmp, &trans->calib_results, list) {
 		list_del(&res->list);
 		kfree(res);
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.h b/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
index 6ed806c..10275ce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
@@ -72,9 +72,4 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv);
 void iwl_init_sensitivity(struct iwl_priv *priv);
 void iwl_reset_run_time_calib(struct iwl_priv *priv);
 
-int iwl_send_calib_results(struct iwl_priv *priv);
-int iwl_calib_set(struct iwl_priv *priv,
-		  const struct iwl_calib_hdr *cmd, int len);
-void iwl_calib_free_results(struct iwl_priv *priv);
-
 #endif /* __iwl_calib_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 02927fa..f5fe42d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1577,7 +1577,7 @@ static int iwl_init_drv(struct iwl_priv *priv)
 
 	mutex_init(&priv->shrd->mutex);
 
-	INIT_LIST_HEAD(&priv->calib_results);
+	INIT_LIST_HEAD(&trans(priv)->calib_results);
 
 	priv->ieee_channels = NULL;
 	priv->ieee_rates = NULL;
@@ -1635,7 +1635,6 @@ err:
 
 static void iwl_uninit_drv(struct iwl_priv *priv)
 {
-	iwl_calib_free_results(priv);
 	iwl_free_geos(priv);
 	iwl_free_channel_map(priv);
 	if (priv->tx_cmd_pool)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index aa225be..69ecf6e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -440,15 +440,6 @@ enum iwlagn_chain_noise_state {
 	IWL_CHAIN_NOISE_DONE,
 };
 
-
-/* Opaque calibration results */
-struct iwl_calib_result {
-	struct list_head list;
-	size_t cmd_len;
-	struct iwl_calib_hdr hdr;
-	/* data follows */
-};
-
 /* Sensitivity calib data */
 struct iwl_sensitivity_data {
 	u32 auto_corr_ofdm;
@@ -830,9 +821,6 @@ struct iwl_priv {
 	s32 temperature;	/* Celsius */
 	s32 last_temperature;
 
-	/* init calibration results */
-	struct list_head calib_results;
-
 	struct iwl_wipan_noa_data __rcu *noa_data;
 
 	/* Scan related variables */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 304b2ea..66e1b9f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1373,6 +1373,7 @@ static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 
 static void iwl_trans_pcie_free(struct iwl_trans *trans)
 {
+	iwl_calib_free_results(trans);
 	iwl_trans_pcie_tx_free(trans);
 	iwl_trans_pcie_rx_free(trans);
 	free_irq(bus(trans)->irq, trans);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 4a29b8a..f94a6ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -220,6 +220,14 @@ struct fw_img {
 	struct fw_desc data;	/* firmware data image */
 };
 
+/* Opaque calibration results */
+struct iwl_calib_result {
+	struct list_head list;
+	size_t cmd_len;
+	struct iwl_calib_hdr hdr;
+	/* data follows */
+};
+
 /**
  * struct iwl_trans - transport common data
  * @ops - pointer to iwl_trans_ops
@@ -229,6 +237,8 @@ struct fw_img {
  * @ucode_rt: run time ucode image
  * @ucode_init: init ucode image
  * @ucode_wowlan: wake on wireless ucode image (optional)
+ * @nvm_device_type: indicates OTP or eeprom
+ * @calib_results: list head for init calibration results
  */
 struct iwl_trans {
 	const struct iwl_trans_ops *ops;
@@ -243,6 +253,9 @@ struct iwl_trans {
 	/* eeprom related variables */
 	int    nvm_device_type;
 
+	/* init calibration results */
+	struct list_head calib_results;
+
 	/* pointer to trans specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
 	char trans_specific[0] __attribute__((__aligned__(sizeof(void *))));
@@ -379,4 +392,9 @@ int iwl_alloc_fw_desc(struct iwl_bus *bus, struct fw_desc *desc,
 		      const void *data, size_t len);
 void iwl_dealloc_ucode(struct iwl_trans *trans);
 
+int iwl_send_calib_results(struct iwl_trans *trans);
+int iwl_calib_set(struct iwl_trans *trans,
+		  const struct iwl_calib_hdr *cmd, int len);
+void iwl_calib_free_results(struct iwl_trans *trans);
+
 #endif /* __iwl_trans_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 256f647..0577212 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -222,7 +222,7 @@ static int iwl_set_Xtal_calib(struct iwl_priv *priv)
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD);
 	cmd.cap_pin1 = le16_to_cpu(xtal_calib[0]);
 	cmd.cap_pin2 = le16_to_cpu(xtal_calib[1]);
-	return iwl_calib_set(priv, (void *)&cmd, sizeof(cmd));
+	return iwl_calib_set(trans(priv), (void *)&cmd, sizeof(cmd));
 }
 
 static int iwl_set_temperature_offset_calib(struct iwl_priv *priv)
@@ -240,7 +240,7 @@ static int iwl_set_temperature_offset_calib(struct iwl_priv *priv)
 
 	IWL_DEBUG_CALIB(priv, "Radio sensor offset: %d\n",
 			le16_to_cpu(cmd.radio_sensor_offset));
-	return iwl_calib_set(priv, (void *)&cmd, sizeof(cmd));
+	return iwl_calib_set(trans(priv), (void *)&cmd, sizeof(cmd));
 }
 
 static int iwl_set_temperature_offset_calib_v2(struct iwl_priv *priv)
@@ -276,7 +276,7 @@ static int iwl_set_temperature_offset_calib_v2(struct iwl_priv *priv)
 	IWL_DEBUG_CALIB(priv, "Voltage Ref: %d\n",
 			le16_to_cpu(cmd.burntVoltageRef));
 
-	return iwl_calib_set(priv, (void *)&cmd, sizeof(cmd));
+	return iwl_calib_set(trans(priv), (void *)&cmd, sizeof(cmd));
 }
 
 static int iwl_send_calib_cfg(struct iwl_trans *trans)
@@ -309,7 +309,7 @@ int iwlagn_rx_calib_result(struct iwl_priv *priv,
 	/* reduce the size of the length field itself */
 	len -= 4;
 
-	if (iwl_calib_set(priv, hdr, len))
+	if (iwl_calib_set(trans(priv), hdr, len))
 		IWL_ERR(priv, "Failed to record calibration data %d\n",
 			hdr->op_code);
 
@@ -459,7 +459,7 @@ static int iwl_alive_notify(struct iwl_priv *priv)
 			return ret;
 	}
 
-	return iwl_send_calib_results(priv);
+	return iwl_send_calib_results(trans(priv));
 }
 
 
-- 
1.7.0.4

