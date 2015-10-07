Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12469 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbbJGJ17 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 05:27:59 -0400
From: <c_mkenna@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>,
	Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>
Subject: [PATCH] ath10k: Enable adaptive CCA
Date: Wed, 7 Oct 2015 14:57:13 +0530
Message-ID: <1444210033-25901-1-git-send-email-c_mkenna@qti.qualcomm.com> (sfid-20151007_112804_612468_2858BB63)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>

European Union has made it mandatory that all devices working in 2.4 GHz
has to adhere to the ETSI specification (ETSI EN 300 328 V1.9.1)
beginnig this year. The standard basically speaks about interferences
in 2.4Ghz band.
For example, when 802.11 device detects interference, TX must be stopped
as long as interference is present.

Adaptive CCA is a feature, when enabled the device learns from the
environment and configures CCA levels adaptively. This will improve
detecting interferences and the device can stop trasmissions till the
interference is present eventually leading to good performances in
varying interference conditions.

The patch includes code for enabling adaptive CCA for 10.2.4 firmware on
QCA988X.

Signed-off-by: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
Signed-off-by: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h    |  3 +++
 drivers/net/wireless/ath/ath10k/mac.c     | 13 +++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 23 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c     | 31 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     | 13 +++++++++++++
 5 files changed, 83 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 04e040a..751bacc 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -468,6 +468,9 @@ enum ath10k_fw_features {
 	 */
 	ATH10K_FW_FEATURE_RAW_MODE_SUPPORT = 10,
 
+	/* Firmware Supports Adaptive CCA*/
+	ATH10K_FW_FEATURE_SUPPORTS_ADAPTIVE_CCA = 11,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 79490ad..a528e1f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3904,6 +3904,19 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		goto err_core_stop;
 	}
 
+	if (test_bit(ATH10K_FW_FEATURE_SUPPORTS_ADAPTIVE_CCA,
+		     ar->fw_features)) {
+		ret =
+		ath10k_wmi_pdev_enable_adaptive_cca(ar, 1,
+						    WMI_CCA_DETECT_LEVEL_AUTO,
+						    WMI_CCA_DETECT_MARGIN_AUTO);
+		if (ret) {
+			ath10k_warn(ar, "failed to enable adaptive cca: %d\n",
+				    ret);
+			goto err_core_stop;
+		}
+	}
+
 	ret = ath10k_wmi_pdev_set_param(ar,
 					ar->wmi.pdev_param->ani_enable, 1);
 	if (ret) {
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 248ffc3..1b2502a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -177,6 +177,10 @@ struct wmi_ops {
 						const struct wmi_tdls_peer_capab_arg *cap,
 						const struct wmi_channel_arg *chan);
 	struct sk_buff *(*gen_adaptive_qcs)(struct ath10k *ar, bool enable);
+	struct sk_buff *(*gen_pdev_enable_adaptive_cca)(struct ath10k *ar,
+							u8 enable,
+							u32 detect_level,
+							u32 detect_margin);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -1270,4 +1274,23 @@ ath10k_wmi_adaptive_qcs(struct ath10k *ar, bool enable)
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->adaptive_qcs_cmdid);
 }
 
+static inline int
+ath10k_wmi_pdev_enable_adaptive_cca(struct ath10k *ar, u8 enable,
+				    u32 detect_level, u32 detect_margin)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_pdev_enable_adaptive_cca)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_pdev_enable_adaptive_cca(ar, enable,
+							detect_level,
+							detect_margin);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->pdev_enable_adaptive_cca_cmdid);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 87d9de2..4300349 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -148,6 +148,7 @@ static struct wmi_cmd_map wmi_cmd_map = {
 	.gpio_config_cmdid = WMI_GPIO_CONFIG_CMDID,
 	.gpio_output_cmdid = WMI_GPIO_OUTPUT_CMDID,
 	.pdev_get_temperature_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_enable_adaptive_cca_cmdid = WMI_CMD_UNSUPPORTED,
 	.scan_update_request_cmdid = WMI_CMD_UNSUPPORTED,
 	.vdev_standby_response_cmdid = WMI_CMD_UNSUPPORTED,
 	.vdev_resume_response_cmdid = WMI_CMD_UNSUPPORTED,
@@ -313,6 +314,7 @@ static struct wmi_cmd_map wmi_10x_cmd_map = {
 	.gpio_config_cmdid = WMI_10X_GPIO_CONFIG_CMDID,
 	.gpio_output_cmdid = WMI_10X_GPIO_OUTPUT_CMDID,
 	.pdev_get_temperature_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_enable_adaptive_cca_cmdid = WMI_CMD_UNSUPPORTED,
 	.scan_update_request_cmdid = WMI_CMD_UNSUPPORTED,
 	.vdev_standby_response_cmdid = WMI_CMD_UNSUPPORTED,
 	.vdev_resume_response_cmdid = WMI_CMD_UNSUPPORTED,
@@ -477,6 +479,7 @@ static struct wmi_cmd_map wmi_10_2_4_cmd_map = {
 	.gpio_config_cmdid = WMI_10_2_GPIO_CONFIG_CMDID,
 	.gpio_output_cmdid = WMI_10_2_GPIO_OUTPUT_CMDID,
 	.pdev_get_temperature_cmdid = WMI_10_2_PDEV_GET_TEMPERATURE_CMDID,
+	.pdev_enable_adaptive_cca_cmdid = WMI_10_2_SET_CCA_PARAMS,
 	.scan_update_request_cmdid = WMI_CMD_UNSUPPORTED,
 	.vdev_standby_response_cmdid = WMI_CMD_UNSUPPORTED,
 	.vdev_resume_response_cmdid = WMI_CMD_UNSUPPORTED,
@@ -1407,6 +1410,7 @@ static struct wmi_cmd_map wmi_10_2_cmd_map = {
 	.gpio_config_cmdid = WMI_10_2_GPIO_CONFIG_CMDID,
 	.gpio_output_cmdid = WMI_10_2_GPIO_OUTPUT_CMDID,
 	.pdev_get_temperature_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_enable_adaptive_cca_cmdid = WMI_CMD_UNSUPPORTED,
 	.scan_update_request_cmdid = WMI_CMD_UNSUPPORTED,
 	.vdev_standby_response_cmdid = WMI_CMD_UNSUPPORTED,
 	.vdev_resume_response_cmdid = WMI_CMD_UNSUPPORTED,
@@ -6356,6 +6360,28 @@ ath10k_wmi_op_gen_delba_send(struct ath10k *ar, u32 vdev_id, const u8 *mac,
 	return skb;
 }
 
+static struct sk_buff *
+ath10k_wmi_op_gen_pdev_enable_adaptive_cca(struct ath10k *ar, u8 enable,
+					   u32 detect_level, u32 detect_margin)
+{
+	struct wmi_pdev_set_adaptive_cca_params *cmd;
+	struct sk_buff *skb;
+
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	cmd = (struct wmi_pdev_set_adaptive_cca_params *)skb->data;
+	cmd->enable = __cpu_to_le32(enable);
+	cmd->cca_detect_level = __cpu_to_le32(detect_level);
+	cmd->cca_detect_margin = __cpu_to_le32(detect_margin);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi pdev set adaptive cca params enable:%d detection level:%d detection margin:%d\n",
+		   enable, detect_level, detect_margin);
+	return skb;
+}
+
 static const struct wmi_ops wmi_ops = {
 	.rx = ath10k_wmi_op_rx,
 	.map_svc = wmi_main_svc_map,
@@ -6418,6 +6444,7 @@ static const struct wmi_ops wmi_ops = {
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
 	/* .gen_adaptive_qcs not implemented */
+	/* .gen_pdev_enable_adaptive_cca not implemented */
 };
 
 static const struct wmi_ops wmi_10_1_ops = {
@@ -6483,6 +6510,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
 	/* .gen_adaptive_qcs not implemented */
+	/* .gen_pdev_enable_adaptive_cca not implemented */
 };
 
 static const struct wmi_ops wmi_10_2_ops = {
@@ -6545,6 +6573,7 @@ static const struct wmi_ops wmi_10_2_ops = {
 	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
 	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
 	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
+	/* .gen_pdev_enable_adaptive_cca not implemented */
 };
 
 static const struct wmi_ops wmi_10_2_4_ops = {
@@ -6606,6 +6635,8 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
 	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
 	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
+	.gen_pdev_enable_adaptive_cca =
+		ath10k_wmi_op_gen_pdev_enable_adaptive_cca,
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 3e5a159..d34ea8f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -753,6 +753,7 @@ struct wmi_cmd_map {
 	u32 mu_cal_start_cmdid;
 	u32 set_cca_params_cmdid;
 	u32 pdev_bss_chan_info_request_cmdid;
+	u32 pdev_enable_adaptive_cca_cmdid;
 };
 
 /*
@@ -1362,6 +1363,9 @@ enum wmi_10_2_cmd_id {
 	WMI_10_2_VDEV_ATF_REQUEST_CMDID,
 	WMI_10_2_PEER_ATF_REQUEST_CMDID,
 	WMI_10_2_PDEV_GET_TEMPERATURE_CMDID,
+	WMI_10_2_MU_CAL_START_CMDID,
+	WMI_10_2_SET_LTEU_CONFIG_CMDID,
+	WMI_10_2_SET_CCA_PARAMS,
 	WMI_10_2_PDEV_UTF_CMDID = WMI_10_2_END_CMDID - 1,
 };
 
@@ -6060,6 +6064,15 @@ enum wmi_txbf_conf {
 	WMI_TXBF_CONF_AFTER_ASSOC,
 };
 
+#define	WMI_CCA_DETECT_LEVEL_AUTO	0
+#define	WMI_CCA_DETECT_MARGIN_AUTO	0
+
+struct wmi_pdev_set_adaptive_cca_params {
+	__le32 enable;
+	__le32 cca_detect_level;
+	__le32 cca_detect_margin;
+} __packed;
+
 struct ath10k;
 struct ath10k_vif;
 struct ath10k_fw_stats_pdev;
-- 
1.9.1

