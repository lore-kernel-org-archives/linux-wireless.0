Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12033 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757363AbYHVB7R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 21:59:17 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/3] iwlwifi: generic init calibrations framework
Date: Fri, 22 Aug 2008 09:55:39 +0800
Message-Id: <1219370140-21481-3-git-send-email-yi.zhu@intel.com> (sfid-20080822_035924_606119_82CC9589)
In-Reply-To: <1219370140-21481-2-git-send-email-yi.zhu@intel.com>
References: <1219370140-21481-1-git-send-email-yi.zhu@intel.com>
 <1219370140-21481-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch allows variable number of init calibrations and allows
addition new HW.

This patch also fixes critical bug. Only last calibration result
was applied. On reception of one calibration result all the calibration
was freed.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h |    7 +++
 drivers/net/wireless/iwlwifi/iwl-5000.c    |   63 ++++------------------------
 drivers/net/wireless/iwlwifi/iwl-calib.c   |   60 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c    |   19 +--------
 drivers/net/wireless/iwlwifi/iwl-core.h    |    8 +++-
 drivers/net/wireless/iwlwifi/iwl-dev.h     |   14 +++----
 6 files changed, 90 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index 17d4f31..c479ee2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -129,6 +129,13 @@ struct iwl5000_shared {
 	__le32 padding2;
 } __attribute__ ((packed));
 
+/* calibrations defined for 5000 */
+/* defines the order in which results should be sent to the runtime uCode */
+enum iwl5000_calib {
+	IWL5000_CALIB_LO,
+	IWL5000_CALIB_TX_IQ,
+	IWL5000_CALIB_TX_IQ_PERD,
+};
 
 #endif /* __iwl_5000_hw_h__ */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index c648638..897652c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -446,48 +446,6 @@ static int iwl5000_send_Xtal_calib(struct iwl_priv *priv)
 				sizeof(cal_cmd), &cal_cmd);
 }
 
-static int iwl5000_send_calib_results(struct iwl_priv *priv)
-{
-	int ret = 0;
-
-	struct iwl_host_cmd hcmd = {
-		.id = REPLY_PHY_CALIBRATION_CMD,
-		.meta.flags = CMD_SIZE_HUGE,
-	};
-
-	if (priv->calib_results.lo_res) {
-		hcmd.len = priv->calib_results.lo_res_len;
-		hcmd.data = priv->calib_results.lo_res;
-		ret = iwl_send_cmd_sync(priv, &hcmd);
-
-		if (ret)
-			goto err;
-	}
-
-	if (priv->calib_results.tx_iq_res) {
-		hcmd.len = priv->calib_results.tx_iq_res_len;
-		hcmd.data = priv->calib_results.tx_iq_res;
-		ret = iwl_send_cmd_sync(priv, &hcmd);
-
-		if (ret)
-			goto err;
-	}
-
-	if (priv->calib_results.tx_iq_perd_res) {
-		hcmd.len = priv->calib_results.tx_iq_perd_res_len;
-		hcmd.data = priv->calib_results.tx_iq_perd_res;
-		ret = iwl_send_cmd_sync(priv, &hcmd);
-
-		if (ret)
-			goto err;
-	}
-
-	return 0;
-err:
-	IWL_ERROR("Error %d\n", ret);
-	return ret;
-}
-
 static int iwl5000_send_calib_cfg(struct iwl_priv *priv)
 {
 	struct iwl5000_calib_cfg_cmd calib_cfg_cmd;
@@ -512,33 +470,30 @@ static void iwl5000_rx_calib_result(struct iwl_priv *priv,
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl5000_calib_hdr *hdr = (struct iwl5000_calib_hdr *)pkt->u.raw;
 	int len = le32_to_cpu(pkt->len) & FH_RSCSR_FRAME_SIZE_MSK;
-
-	iwl_free_calib_results(priv);
+	int index;
 
 	/* reduce the size of the length field itself */
 	len -= 4;
 
+	/* Define the order in which the results will be sent to the runtime
+	 * uCode. iwl_send_calib_results sends them in a row according to their
+	 * index. We sort them here */
 	switch (hdr->op_code) {
 	case IWL5000_PHY_CALIBRATE_LO_CMD:
-		priv->calib_results.lo_res = kzalloc(len, GFP_ATOMIC);
-		priv->calib_results.lo_res_len = len;
-		memcpy(priv->calib_results.lo_res, pkt->u.raw, len);
+		index = IWL5000_CALIB_LO;
 		break;
 	case IWL5000_PHY_CALIBRATE_TX_IQ_CMD:
-		priv->calib_results.tx_iq_res = kzalloc(len, GFP_ATOMIC);
-		priv->calib_results.tx_iq_res_len = len;
-		memcpy(priv->calib_results.tx_iq_res, pkt->u.raw, len);
+		index = IWL5000_CALIB_TX_IQ;
 		break;
 	case IWL5000_PHY_CALIBRATE_TX_IQ_PERD_CMD:
-		priv->calib_results.tx_iq_perd_res = kzalloc(len, GFP_ATOMIC);
-		priv->calib_results.tx_iq_perd_res_len = len;
-		memcpy(priv->calib_results.tx_iq_perd_res, pkt->u.raw, len);
+		index = IWL5000_CALIB_TX_IQ_PERD;
 		break;
 	default:
 		IWL_ERROR("Unknown calibration notification %d\n",
 			  hdr->op_code);
 		return;
 	}
+	iwl_calib_set(&priv->calib_results[index], pkt->u.raw, len);
 }
 
 static void iwl5000_rx_calib_complete(struct iwl_priv *priv,
@@ -836,7 +791,7 @@ static int iwl5000_alive_notify(struct iwl_priv *priv)
 	iwl5000_send_Xtal_calib(priv);
 
 	if (priv->ucode_type == UCODE_RT)
-		iwl5000_send_calib_results(priv);
+		iwl_send_calib_results(priv);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index ef49440..35fb4a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -66,6 +66,66 @@
 #include "iwl-core.h"
 #include "iwl-calib.h"
 
+/*****************************************************************************
+ * INIT calibrations framework
+ *****************************************************************************/
+
+ int iwl_send_calib_results(struct iwl_priv *priv)
+{
+	int ret = 0;
+	int i = 0;
+
+	struct iwl_host_cmd hcmd = {
+		.id = REPLY_PHY_CALIBRATION_CMD,
+		.meta.flags = CMD_SIZE_HUGE,
+	};
+
+	for (i = 0; i < IWL_CALIB_MAX; i++)
+		if (priv->calib_results[i].buf) {
+			hcmd.len = priv->calib_results[i].buf_len;
+			hcmd.data = priv->calib_results[i].buf;
+			ret = iwl_send_cmd_sync(priv, &hcmd);
+			if (ret)
+				goto err;
+		}
+
+	return 0;
+err:
+	IWL_ERROR("Error %d iteration %d\n", ret, i);
+	return ret;
+}
+EXPORT_SYMBOL(iwl_send_calib_results);
+
+int iwl_calib_set(struct iwl_calib_result *res, const u8 *buf, int len)
+{
+	if (res->buf_len != len) {
+		kfree(res->buf);
+		res->buf = kzalloc(len, GFP_ATOMIC);
+	}
+	if (unlikely(res->buf == NULL))
+		return -ENOMEM;
+
+	res->buf_len = len;
+	memcpy(res->buf, buf, len);
+	return 0;
+}
+EXPORT_SYMBOL(iwl_calib_set);
+
+void iwl_calib_free_results(struct iwl_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < IWL_CALIB_MAX; i++) {
+		kfree(priv->calib_results[i].buf);
+		priv->calib_results[i].buf = NULL;
+		priv->calib_results[i].buf_len = 0;
+	}
+}
+
+/*****************************************************************************
+ * RUNTIME calibrations framework
+ *****************************************************************************/
+
 /* "false alarms" are signals that our DSP tries to lock onto,
  *   but then determines that they are either noise, or transmissions
  *   from a distant wireless network (also "noise", really) that get
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 4694ae1..a5b5c09 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -935,22 +935,6 @@ err:
 }
 EXPORT_SYMBOL(iwl_init_drv);
 
-void iwl_free_calib_results(struct iwl_priv *priv)
-{
-	kfree(priv->calib_results.lo_res);
-	priv->calib_results.lo_res = NULL;
-	priv->calib_results.lo_res_len = 0;
-
-	kfree(priv->calib_results.tx_iq_res);
-	priv->calib_results.tx_iq_res = NULL;
-	priv->calib_results.tx_iq_res_len = 0;
-
-	kfree(priv->calib_results.tx_iq_perd_res);
-	priv->calib_results.tx_iq_perd_res = NULL;
-	priv->calib_results.tx_iq_perd_res_len = 0;
-}
-EXPORT_SYMBOL(iwl_free_calib_results);
-
 int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 {
 	int ret = 0;
@@ -978,10 +962,9 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 }
 EXPORT_SYMBOL(iwl_set_tx_power);
 
-
 void iwl_uninit_drv(struct iwl_priv *priv)
 {
-	iwl_free_calib_results(priv);
+	iwl_calib_free_results(priv);
 	iwlcore_free_geos(priv);
 	iwl_free_channel_map(priv);
 	kfree(priv->scan);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index ff86abc..b5db050 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -186,7 +186,6 @@ struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
 void iwl_hw_detect(struct iwl_priv *priv);
 
 void iwl_clear_stations_table(struct iwl_priv *priv);
-void iwl_free_calib_results(struct iwl_priv *priv);
 void iwl_reset_qos(struct iwl_priv *priv);
 void iwl_set_rxon_chain(struct iwl_priv *priv);
 int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch);
@@ -289,6 +288,13 @@ int iwl_scan_initiate(struct iwl_priv *priv);
 void iwl_setup_rx_scan_handlers(struct iwl_priv *priv);
 void iwl_setup_scan_deferred_work(struct iwl_priv *priv);
 
+/*******************************************************************************
+ * Calibrations - implemented in iwl-calib.c
+ ******************************************************************************/
+int iwl_send_calib_results(struct iwl_priv *priv);
+int iwl_calib_set(struct iwl_calib_result *res, const u8 *buf, int len);
+void iwl_calib_free_results(struct iwl_priv *priv);
+
 /*****************************************************
  *   S e n d i n g     H o s t     C o m m a n d s   *
  *****************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c19db43..b00acf4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -746,13 +746,10 @@ struct statistics_general_data {
 	u32 beacon_energy_c;
 };
 
-struct iwl_calib_results {
-	void *tx_iq_res;
-	void *tx_iq_perd_res;
-	void *lo_res;
-	u32 tx_iq_res_len;
-	u32 tx_iq_perd_res_len;
-	u32 lo_res_len;
+/* Opaque calibration results */
+struct iwl_calib_result {
+	void *buf;
+	size_t buf_len;
 };
 
 enum ucode_type {
@@ -814,6 +811,7 @@ enum {
 
 
 #define IWL_MAX_NUM_QUEUES	20 /* FIXME: do dynamic allocation */
+#define IWL_CALIB_MAX  3
 
 struct iwl_priv {
 
@@ -858,7 +856,7 @@ struct iwl_priv {
 	s32 last_temperature;
 
 	/* init calibration results */
-	struct iwl_calib_results calib_results;
+	struct iwl_calib_result calib_results[IWL_CALIB_MAX];
 
 	/* Scan related variables */
 	unsigned long last_scan_jiffies;
-- 
1.5.3.6

