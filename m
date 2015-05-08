Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12552 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216AbbEHOCV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 10:02:21 -0400
From: <c_mpubbi@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>
Subject: [PATCH] ath10k: new debugfs interface to enable adaptive CCA
Date: Fri, 8 May 2015 19:31:03 +0530
Message-ID: <1431093663-15206-1-git-send-email-c_mpubbi@qti.qualcomm.com> (sfid-20150508_160231_970126_B6C3FC21)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>

For devices working in 2.4 GHz to be ETSI compliant,
it is required to support adaptive CCA. Some firmwares
support adaptive CCA and is disabled by default.

The patch is an attempt to add a new debugfs interface to enable
adaptive cca on supported firmwares. Support for this feature is
advertised with a new firmware feature flag.

Signed-off-by: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h    |  9 ++++--
 drivers/net/wireless/ath/ath10k/debug.c   | 52 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 21 +++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c     | 31 ++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     | 10 ++++++
 5 files changed, 121 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 827b3d7..89176f1 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -461,10 +461,13 @@ enum ath10k_fw_features {
 	ATH10K_FW_FEATURE_WOWLAN_SUPPORT = 6,
 
 	/* Don't trust error code from otp.bin */
-	ATH10K_FW_FEATURE_IGNORE_OTP_RESULT,
+	ATH10K_FW_FEATURE_IGNORE_OTP_RESULT = 7,
+
+	/* Firmware has support for adaptive CCA */
+	ATH10K_FW_FEATURE_HAS_ADAPTIVE_CCA = 8,
 
 	/* keep last */
-	ATH10K_FW_FEATURE_COUNT,
+	ATH10K_FW_FEATURE_COUNT
 };
 
 enum ath10k_dev_flags {
@@ -726,6 +729,8 @@ struct ath10k {
 	struct ath10k_thermal thermal;
 	struct ath10k_wow wow;
 
+	bool ath10k_adaptive_cca_enable;
+
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
 };
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 8fa606a..7774bb1 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2092,6 +2092,55 @@ static const struct file_operations fops_quiet_period = {
 	.open = simple_open
 };
 
+static ssize_t ath10k_write_adaptive_cca_enable(struct file *file,
+						const char __user *ubuf,
+						size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	u8 enable;
+	int ret = 0;
+
+	if (kstrtou8_from_user(ubuf, count, 0, &enable))
+		return -EINVAL;
+
+	if (!test_bit(ATH10K_FW_FEATURE_HAS_ADAPTIVE_CCA, ar->fw_features)) {
+		ath10k_warn(ar, "firmware %s do not support adaptive cca\n",
+			    ar->hw->wiphy->fw_version);
+		return -ENOTSUPP;
+	}
+
+	mutex_lock(&ar->conf_mutex);
+	if (enable != ar->ath10k_adaptive_cca_enable) {
+		ar->ath10k_adaptive_cca_enable = enable;
+		ret = ath10k_wmi_pdev_enable_adaptive_cca(ar, enable, 0, 0);
+	}
+	mutex_unlock(&ar->conf_mutex);
+
+	return ret ?: count;
+}
+
+static ssize_t ath10k_read_adaptive_cca_enable(struct file *file,
+					       char __user *ubuf,
+					       size_t count, loff_t *ppos)
+{
+	char buf[32];
+	struct ath10k *ar = file->private_data;
+	int len = 0;
+
+	mutex_lock(&ar->conf_mutex);
+	len = scnprintf(buf, sizeof(buf) - len, "%d\n",
+			ar->ath10k_adaptive_cca_enable);
+	mutex_unlock(&ar->conf_mutex);
+
+	return simple_read_from_buffer(ubuf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_cca_detect_enable = {
+	.read = ath10k_read_adaptive_cca_enable,
+	.write = ath10k_write_adaptive_cca_enable,
+	.open = simple_open
+};
+
 int ath10k_debug_create(struct ath10k *ar)
 {
 	ar->debug.fw_crash_data = vzalloc(sizeof(*ar->debug.fw_crash_data));
@@ -2195,6 +2244,9 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("quiet_period", S_IRUGO | S_IWUSR,
 			    ar->debug.debugfs_phy, ar, &fops_quiet_period);
 
+	debugfs_create_file("adaptive_cca_enable", S_IRUGO | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_cca_detect_enable);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 47fe2e7..eb7991e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -174,6 +174,10 @@ struct wmi_ops {
 						const struct wmi_tdls_peer_capab_arg *cap,
 						const struct wmi_channel_arg *chan);
 	struct sk_buff *(*gen_adaptive_qcs)(struct ath10k *ar, bool enable);
+	struct sk_buff *(*gen_pdev_enable_adaptive_cca)(struct ath10k *ar,
+							u8 enable,
+							int detect_level,
+							u32 detect_margin);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -1248,4 +1252,21 @@ ath10k_wmi_adaptive_qcs(struct ath10k *ar, bool enable)
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->adaptive_qcs_cmdid);
 }
 
+static inline int
+ath10k_wmi_pdev_enable_adaptive_cca(struct ath10k *ar, u8 enable,
+				    int detect_level, u32 detect_margin)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_pdev_enable_adaptive_cca)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_pdev_enable_adaptive_cca(ar,
+			enable, detect_level, detect_margin);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+			ar->wmi.cmd->pdev_enable_adaptive_cca_cmdid);
+}
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index ebaa096..1cdcf3e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -147,6 +147,7 @@ static struct wmi_cmd_map wmi_cmd_map = {
 	.gpio_config_cmdid = WMI_GPIO_CONFIG_CMDID,
 	.gpio_output_cmdid = WMI_GPIO_OUTPUT_CMDID,
 	.pdev_get_temperature_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_enable_adaptive_cca_cmdid = WMI_CMD_UNSUPPORTED,
 };
 
 /* 10.X WMI cmd track */
@@ -270,6 +271,7 @@ static struct wmi_cmd_map wmi_10x_cmd_map = {
 	.gpio_config_cmdid = WMI_10X_GPIO_CONFIG_CMDID,
 	.gpio_output_cmdid = WMI_10X_GPIO_OUTPUT_CMDID,
 	.pdev_get_temperature_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_enable_adaptive_cca_cmdid = WMI_CMD_UNSUPPORTED,
 };
 
 /* 10.2.4 WMI cmd track */
@@ -392,6 +394,7 @@ static struct wmi_cmd_map wmi_10_2_4_cmd_map = {
 	.gpio_config_cmdid = WMI_10_2_GPIO_CONFIG_CMDID,
 	.gpio_output_cmdid = WMI_10_2_GPIO_OUTPUT_CMDID,
 	.pdev_get_temperature_cmdid = WMI_10_2_PDEV_GET_TEMPERATURE_CMDID,
+	.pdev_enable_adaptive_cca_cmdid = WMI_10_2_SET_CCA_PARAMS,
 };
 
 /* MAIN WMI VDEV param map */
@@ -848,6 +851,7 @@ static struct wmi_cmd_map wmi_10_2_cmd_map = {
 	.gpio_config_cmdid = WMI_10_2_GPIO_CONFIG_CMDID,
 	.gpio_output_cmdid = WMI_10_2_GPIO_OUTPUT_CMDID,
 	.pdev_get_temperature_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_enable_adaptive_cca_cmdid = WMI_CMD_UNSUPPORTED,
 };
 
 void ath10k_wmi_put_wmi_channel(struct wmi_channel *ch,
@@ -5154,6 +5158,28 @@ ath10k_wmi_op_gen_delba_send(struct ath10k *ar, u32 vdev_id, const u8 *mac,
 	return skb;
 }
 
+static struct sk_buff *
+ath10k_wmi_ops_gen_pdev_enable_adaptive_cca(struct ath10k *ar, u8 enable,
+					    int detect_level, u32 detect_margin)
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
@@ -5215,6 +5241,7 @@ static const struct wmi_ops wmi_ops = {
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
 	/* .gen_adaptive_qcs not implemented */
+	/* .gen_pdev_enable_adaptive_cca not implemented */
 };
 
 static const struct wmi_ops wmi_10_1_ops = {
@@ -5279,6 +5306,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
 	/* .gen_adaptive_qcs not implemented */
+	/* .gen_pdev_enable_adaptive_cca not implemented */
 };
 
 static const struct wmi_ops wmi_10_2_ops = {
@@ -5340,6 +5368,7 @@ static const struct wmi_ops wmi_10_2_ops = {
 	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
 	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
 	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
+	/* .gen_pdev_enable_adaptive_cca not implemented */
 };
 
 static const struct wmi_ops wmi_10_2_4_ops = {
@@ -5400,6 +5429,8 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
 	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
 	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
+	.gen_pdev_enable_adaptive_cca =
+			ath10k_wmi_ops_gen_pdev_enable_adaptive_cca,
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index cad72ae..2bdc2c6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -565,6 +565,7 @@ struct wmi_cmd_map {
 	u32 tdls_set_state_cmdid;
 	u32 tdls_peer_update_cmdid;
 	u32 adaptive_qcs_cmdid;
+	u32 pdev_enable_adaptive_cca_cmdid;
 };
 
 /*
@@ -1174,6 +1175,9 @@ enum wmi_10_2_cmd_id {
 	WMI_10_2_VDEV_ATF_REQUEST_CMDID,
 	WMI_10_2_PEER_ATF_REQUEST_CMDID,
 	WMI_10_2_PDEV_GET_TEMPERATURE_CMDID,
+	WMI_10_2_MU_CAL_START_CMDID,
+	WMI_10_2_SET_LTEU_CONFIG_CMDID,
+	WMI_10_2_SET_CCA_PARAMS,
 	WMI_10_2_PDEV_UTF_CMDID = WMI_10_2_END_CMDID - 1,
 };
 
@@ -5086,6 +5090,12 @@ struct wmi_tdls_peer_capab_arg {
 	u32 pref_offchan_bw;
 };
 
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

