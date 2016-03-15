Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2940 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934192AbcCOOb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2016 10:31:56 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>, <kvalo@codeaurora.org>,
	<mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Subject: [PATCH 1/2] ath10k: Introduce Extended Resource Config support for 10.4
Date: Tue, 15 Mar 2016 20:00:49 +0530
Message-ID: <1458052250-2529-2-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160315_153209_353254_FB608E8A)
In-Reply-To: <1458052250-2529-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1458052250-2529-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qti.qualcomm.com>

Add API support for Extended Resource Configuration for 10.4. This
is useful to enable new features like Peer Stats, LTEU etc if the
firmware advertises support for the service. This is also done to
provide backward compatibility with older firmware. Also for clarity
send default host platform type as 'WMI_HOST_PLATFORM_HIGH_PERF',
though this should not make any difference in functionality

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h |   23 ++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c     |   24 +++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |   33 ++++++++++++++++++++++++++++-
 3 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 32ab34e..7fb00dc 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -186,6 +186,9 @@ struct wmi_ops {
 							u8 enable,
 							u32 detect_level,
 							u32 detect_margin);
+	struct sk_buff *(*ext_resource_config)(struct ath10k *ar,
+					       enum wmi_host_platform_type type,
+					       u32 fw_feature_bitmap);
 	int (*get_vdev_subtype)(struct ath10k *ar,
 				enum wmi_vdev_subtype subtype);
 };
@@ -1330,6 +1333,26 @@ ath10k_wmi_pdev_enable_adaptive_cca(struct ath10k *ar, u8 enable,
 }
 
 static inline int
+ath10k_wmi_ext_resource_config(struct ath10k *ar,
+			       enum wmi_host_platform_type type,
+			       u32 fw_feature_bitmap)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->ext_resource_config)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->ext_resource_config(ar, type,
+					       fw_feature_bitmap);
+
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->ext_resource_cfg_cmdid);
+}
+
+static inline int
 ath10k_wmi_get_vdev_subtype(struct ath10k *ar, enum wmi_vdev_subtype subtype)
 {
 	if (!ar->wmi.ops->get_vdev_subtype)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index c260894..fcef9a0 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -705,6 +705,7 @@ static struct wmi_cmd_map wmi_10_4_cmd_map = {
 	.set_cca_params_cmdid = WMI_10_4_SET_CCA_PARAMS_CMDID,
 	.pdev_bss_chan_info_request_cmdid =
 			WMI_10_4_PDEV_BSS_CHAN_INFO_REQUEST_CMDID,
+	.ext_resource_cfg_cmdid = WMI_10_4_EXT_RESOURCE_CFG_CMDID,
 };
 
 /* MAIN WMI VDEV param map */
@@ -7509,6 +7510,28 @@ static int ath10k_wmi_10_4_op_get_vdev_subtype(struct ath10k *ar,
 	return -ENOTSUPP;
 }
 
+static struct sk_buff *
+ath10k_wmi_10_4_ext_resource_config(struct ath10k *ar,
+				    enum wmi_host_platform_type type,
+				    u32 fw_feature_bitmap)
+{
+	struct wmi_ext_resource_config_10_4_cmd *cmd;
+	struct sk_buff *skb;
+
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	cmd = (struct wmi_ext_resource_config_10_4_cmd *)skb->data;
+	cmd->host_platform_config = __cpu_to_le32(type);
+	cmd->fw_feature_bitmap = __cpu_to_le32(fw_feature_bitmap);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "host platform type :%d firmware feature bitmap :%08x\n",
+		   type, fw_feature_bitmap);
+	return skb;
+}
+
 static const struct wmi_ops wmi_ops = {
 	.rx = ath10k_wmi_op_rx,
 	.map_svc = wmi_main_svc_map,
@@ -7835,6 +7858,7 @@ static const struct wmi_ops wmi_10_4_ops = {
 	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
 	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
 	.fw_stats_fill = ath10k_wmi_10_4_op_fw_stats_fill,
+	.ext_resource_config = ath10k_wmi_10_4_ext_resource_config,
 
 	/* shared with 10.2 */
 	.gen_request_stats = ath10k_wmi_op_gen_request_stats,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index bb42f7a..1d3e085 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -816,6 +816,7 @@ struct wmi_cmd_map {
 	u32 set_cca_params_cmdid;
 	u32 pdev_bss_chan_info_request_cmdid;
 	u32 pdev_enable_adaptive_cca_cmdid;
+	u32 ext_resource_cfg_cmdid;
 };
 
 /*
@@ -2665,7 +2666,32 @@ struct wmi_resource_config_10_4 {
 	 * 0  - This is not qwrap
 	 */
 	__le32 qwrap_config;
-} __packed;
+} __packed
+
+/**
+ * enum wmi_10_4_feature_mask - WMI 10.4 feature enable/disable flags
+ * @WMI_10_4_LTEU_SUPPORT: LTEU config
+ * @WMI_10_4_COEX_GPIO_SUPPORT: COEX GPIO config
+ * @WMI_10_4_AUX_RADIO_SPECTRAL_INTF: AUX Radio Enhancement for spectral scan
+ * @WMI_10_4_AUX_RADIO_CHAN_LOAD_INTF: AUX Radio Enhancement for chan load scan
+ * @WMI_10_4_BSS_CHANNEL_INFO_64: BSS channel info stats
+ * @WMI_10_4_PEER_STATS: Per station stats
+ */
+enum wmi_10_4_feature_mask {
+	WMI_10_4_LTEU_SUPPORT			= BIT(0),
+	WMI_10_4_COEX_GPIO_SUPPORT		= BIT(1),
+	WMI_10_4_AUX_RADIO_SPECTRAL_INTF	= BIT(2),
+	WMI_10_4_AUX_RADIO_CHAN_LOAD_INTF	= BIT(3),
+	WMI_10_4_BSS_CHANNEL_INFO_64		= BIT(4),
+	WMI_10_4_PEER_STATS			= BIT(5),
+};
+
+struct wmi_ext_resource_config_10_4_cmd {
+	/* contains enum wmi_host_platform_type */
+	__le32 host_platform_config;
+	/* see enum wmi_10_4_feature_mask */
+	__le32 fw_feature_bitmap;
+};
 
 /* strucutre describing host memory chunk. */
 struct host_memory_chunk {
@@ -6408,6 +6434,11 @@ struct wmi_pdev_set_adaptive_cca_params {
 	__le32 cca_detect_margin;
 } __packed;
 
+enum wmi_host_platform_type {
+	WMI_HOST_PLATFORM_HIGH_PERF,
+	WMI_HOST_PLATFORM_LOW_PERF,
+};
+
 struct ath10k;
 struct ath10k_vif;
 struct ath10k_fw_stats_pdev;
-- 
1.7.9.5

