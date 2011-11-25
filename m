Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59592 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab1KYUIT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 15:08:19 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/7] iwlagn: dynamically allocate & reflect calibration data
Date: Fri, 25 Nov 2011 11:11:44 -0800
Message-Id: <1322248308-5113-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111125_210830_689854_91935C60)
In-Reply-To: <1322248308-5113-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1322248308-5113-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This makes handling the calibration data more generic
and no longer requires updating IWL_CALIB_MAX when a
new uCode comes with more calibration packets. Since
we just copy the data back, there's also no need for
understanding which calibration we received -- we can
just reflect it back to the runtime uCode.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |   50 +++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-agn-calib.h |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   40 ++++-----------------
 drivers/net/wireless/iwlwifi/iwl-agn.c       |    2 +
 drivers/net/wireless/iwlwifi/iwl-dev.h       |   24 +++----------
 5 files changed, 46 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index c7bcafa..4d02105 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -88,19 +88,18 @@ int iwl_send_calib_results(struct iwl_priv *priv)
 		.id = REPLY_PHY_CALIBRATION_CMD,
 		.flags = CMD_SYNC,
 	};
-	int i = 0;
+	struct iwl_calib_result *res;
 
-	for (i = 0; i < IWL_CALIB_MAX; i++) {
+	list_for_each_entry(res, &priv->calib_results, list) {
 		int ret;
 
-		if (!priv->calib_results[i].buf)
-			continue;
-		hcmd.len[0] = priv->calib_results[i].buf_len;
-		hcmd.data[0] = priv->calib_results[i].buf;
+		hcmd.len[0] = res->cmd_len;
+		hcmd.data[0] = &res->hdr;
 		hcmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
 		ret = iwl_trans_send_cmd(trans(priv), &hcmd);
 		if (ret) {
-			IWL_ERR(priv, "Error %d iteration %d\n", ret, i);
+			IWL_ERR(priv, "Error %d on calib cmd %d\n",
+				ret, res->hdr.op_code);
 			return ret;
 		}
 	}
@@ -108,28 +107,39 @@ int iwl_send_calib_results(struct iwl_priv *priv)
 	return 0;
 }
 
-int iwl_calib_set(struct iwl_calib_result *res, const u8 *buf, int len)
+int iwl_calib_set(struct iwl_priv *priv,
+		  const struct iwl_calib_hdr *cmd, int len)
 {
-	if (res->buf_len != len) {
-		kfree(res->buf);
-		res->buf = kzalloc(len, GFP_ATOMIC);
-	}
-	if (unlikely(res->buf == NULL))
+	struct iwl_calib_result *res, *tmp;
+
+	res = kmalloc(sizeof(*res) + len - sizeof(struct iwl_calib_hdr),
+		      GFP_ATOMIC);
+	if (!res)
 		return -ENOMEM;
+	memcpy(&res->hdr, cmd, len);
+	res->cmd_len = len;
+
+	list_for_each_entry(tmp, &priv->calib_results, list) {
+		if (tmp->hdr.op_code == res->hdr.op_code) {
+			list_replace(&tmp->list, &res->list);
+			kfree(tmp);
+			return 0;
+		}
+	}
+
+	/* wasn't in list already */
+	list_add_tail(&res->list, &priv->calib_results);
 
-	res->buf_len = len;
-	memcpy(res->buf, buf, len);
 	return 0;
 }
 
 void iwl_calib_free_results(struct iwl_priv *priv)
 {
-	int i;
+	struct iwl_calib_result *res, *tmp;
 
-	for (i = 0; i < IWL_CALIB_MAX; i++) {
-		kfree(priv->calib_results[i].buf);
-		priv->calib_results[i].buf = NULL;
-		priv->calib_results[i].buf_len = 0;
+	list_for_each_entry_safe(res, tmp, &priv->calib_results, list) {
+		list_del(&res->list);
+		kfree(res);
 	}
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.h b/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
index a869fc9..6ed806c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
@@ -73,7 +73,8 @@ void iwl_init_sensitivity(struct iwl_priv *priv);
 void iwl_reset_run_time_calib(struct iwl_priv *priv);
 
 int iwl_send_calib_results(struct iwl_priv *priv);
-int iwl_calib_set(struct iwl_calib_result *res, const u8 *buf, int len);
+int iwl_calib_set(struct iwl_priv *priv,
+		  const struct iwl_calib_hdr *cmd, int len);
 void iwl_calib_free_results(struct iwl_priv *priv);
 
 #endif /* __iwl_calib_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 7043fdb..7694910 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -222,8 +222,7 @@ static int iwlagn_set_Xtal_calib(struct iwl_priv *priv)
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD);
 	cmd.cap_pin1 = le16_to_cpu(xtal_calib[0]);
 	cmd.cap_pin2 = le16_to_cpu(xtal_calib[1]);
-	return iwl_calib_set(&priv->calib_results[IWL_CALIB_XTAL],
-			     (u8 *)&cmd, sizeof(cmd));
+	return iwl_calib_set(priv, (void *)&cmd, sizeof(cmd));
 }
 
 static int iwlagn_set_temperature_offset_calib(struct iwl_priv *priv)
@@ -240,8 +239,7 @@ static int iwlagn_set_temperature_offset_calib(struct iwl_priv *priv)
 
 	IWL_DEBUG_CALIB(priv, "Radio sensor offset: %d\n",
 			le16_to_cpu(cmd.radio_sensor_offset));
-	return iwl_calib_set(&priv->calib_results[IWL_CALIB_TEMP_OFFSET],
-			     (u8 *)&cmd, sizeof(cmd));
+	return iwl_calib_set(priv, (void *)&cmd, sizeof(cmd));
 }
 
 static int iwlagn_set_temperature_offset_calib_v2(struct iwl_priv *priv)
@@ -276,8 +274,7 @@ static int iwlagn_set_temperature_offset_calib_v2(struct iwl_priv *priv)
 	IWL_DEBUG_CALIB(priv, "Voltage Ref: %d\n",
 			le16_to_cpu(cmd.burntVoltageRef));
 
-	return iwl_calib_set(&priv->calib_results[IWL_CALIB_TEMP_OFFSET],
-			     (u8 *)&cmd, sizeof(cmd));
+	return iwl_calib_set(priv, (void *)&cmd, sizeof(cmd));
 }
 
 static int iwlagn_send_calib_cfg(struct iwl_priv *priv)
@@ -306,37 +303,14 @@ int iwlagn_rx_calib_result(struct iwl_priv *priv,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_calib_hdr *hdr = (struct iwl_calib_hdr *)pkt->u.raw;
 	int len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
-	int index;
 
 	/* reduce the size of the length field itself */
 	len -= 4;
 
-	/* Define the order in which the results will be sent to the runtime
-	 * uCode. iwl_send_calib_results sends them in a row according to
-	 * their index. We sort them here
-	 */
-	switch (hdr->op_code) {
-	case IWL_PHY_CALIBRATE_DC_CMD:
-		index = IWL_CALIB_DC;
-		break;
-	case IWL_PHY_CALIBRATE_LO_CMD:
-		index = IWL_CALIB_LO;
-		break;
-	case IWL_PHY_CALIBRATE_TX_IQ_CMD:
-		index = IWL_CALIB_TX_IQ;
-		break;
-	case IWL_PHY_CALIBRATE_TX_IQ_PERD_CMD:
-		index = IWL_CALIB_TX_IQ_PERD;
-		break;
-	case IWL_PHY_CALIBRATE_BASE_BAND_CMD:
-		index = IWL_CALIB_BASE_BAND;
-		break;
-	default:
-		IWL_ERR(priv, "Unknown calibration notification %d\n",
-			  hdr->op_code);
-		return -1;
-	}
-	iwl_calib_set(&priv->calib_results[index], pkt->u.raw, len);
+	if (iwl_calib_set(priv, hdr, len))
+		IWL_ERR(priv, "Failed to record calibration data %d\n",
+			hdr->op_code);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e235e84..8e571c3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1575,6 +1575,8 @@ static int iwl_init_drv(struct iwl_priv *priv)
 
 	mutex_init(&priv->shrd->mutex);
 
+	INIT_LIST_HEAD(&priv->calib_results);
+
 	priv->ieee_channels = NULL;
 	priv->ieee_rates = NULL;
 	priv->band = IEEE80211_BAND_2GHZ;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 556e4a2..0c95ad3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -442,26 +442,12 @@ enum iwlagn_chain_noise_state {
 };
 
 
-/*
- * enum iwl_calib
- * defines the order in which results of initial calibrations
- * should be sent to the runtime uCode
- */
-enum iwl_calib {
-	IWL_CALIB_XTAL,
-	IWL_CALIB_DC,
-	IWL_CALIB_LO,
-	IWL_CALIB_TX_IQ,
-	IWL_CALIB_TX_IQ_PERD,
-	IWL_CALIB_BASE_BAND,
-	IWL_CALIB_TEMP_OFFSET,
-	IWL_CALIB_MAX
-};
-
 /* Opaque calibration results */
 struct iwl_calib_result {
-	void *buf;
-	size_t buf_len;
+	struct list_head list;
+	size_t cmd_len;
+	struct iwl_calib_hdr hdr;
+	/* data follows */
 };
 
 /* Sensitivity calib data */
@@ -869,7 +855,7 @@ struct iwl_priv {
 	s32 last_temperature;
 
 	/* init calibration results */
-	struct iwl_calib_result calib_results[IWL_CALIB_MAX];
+	struct list_head calib_results;
 
 	struct iwl_wipan_noa_data __rcu *noa_data;
 
-- 
1.7.0.4

