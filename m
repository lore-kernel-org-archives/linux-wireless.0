Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61042 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbcDVFq5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2016 01:46:57 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH 2/4] ath10k: implement wmi_pdev_bss_chan_info_request
Date: Fri, 22 Apr 2016 11:16:30 +0530
Message-ID: <1461303992-9913-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160422_074700_675447_57CF85F0)
In-Reply-To: <1461303992-9913-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1461303992-9913-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add WMI ops to send pdev_bss_chan_info_request command to target.
This command will be used to retrieve updated cycle counters and noise
floor value of current operating channel (bss channel).

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 21 +++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c     | 25 ++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h     | 10 ++++++++++
 3 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 7fb00dcc03b8..64ebd304f907 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -191,6 +191,9 @@ struct wmi_ops {
 					       u32 fw_feature_bitmap);
 	int (*get_vdev_subtype)(struct ath10k *ar,
 				enum wmi_vdev_subtype subtype);
+	struct sk_buff *(*gen_pdev_bss_chan_info_req)
+					(struct ath10k *ar,
+					 enum wmi_bss_survey_req_type type);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -1361,4 +1364,22 @@ ath10k_wmi_get_vdev_subtype(struct ath10k *ar, enum wmi_vdev_subtype subtype)
 	return ar->wmi.ops->get_vdev_subtype(ar, subtype);
 }
 
+static inline int
+ath10k_wmi_pdev_bss_chan_info_request(struct ath10k *ar,
+				      enum wmi_bss_survey_req_type type)
+{
+	struct ath10k_wmi *wmi = &ar->wmi;
+	struct sk_buff *skb;
+
+	if (!wmi->ops->gen_pdev_bss_chan_info_req)
+		return -EOPNOTSUPP;
+
+	skb = wmi->ops->gen_pdev_bss_chan_info_req(ar, type);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   wmi->cmd->pdev_bss_chan_info_request_cmdid);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index adb31e188ebd..d6157d3587c5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -521,7 +521,8 @@ static struct wmi_cmd_map wmi_10_2_4_cmd_map = {
 	.vdev_filter_neighbor_rx_packets_cmdid = WMI_CMD_UNSUPPORTED,
 	.mu_cal_start_cmdid = WMI_CMD_UNSUPPORTED,
 	.set_cca_params_cmdid = WMI_CMD_UNSUPPORTED,
-	.pdev_bss_chan_info_request_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_bss_chan_info_request_cmdid =
+		WMI_10_2_PDEV_BSS_CHAN_INFO_REQUEST_CMDID,
 };
 
 /* 10.4 WMI cmd track */
@@ -6639,6 +6640,26 @@ ath10k_wmi_10_2_op_gen_pdev_get_temperature(struct ath10k *ar)
 	return skb;
 }
 
+static struct sk_buff *
+ath10k_wmi_10_2_op_gen_pdev_bss_chan_info(struct ath10k *ar,
+					  enum wmi_bss_survey_req_type type)
+{
+	struct wmi_pdev_chan_info_req_cmd *cmd;
+	struct sk_buff *skb;
+
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	cmd = (struct wmi_pdev_chan_info_req_cmd *)skb->data;
+	cmd->type = __cpu_to_le32(type);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi pdev bss info request type %d\n", type);
+
+	return skb;
+}
+
 /* This function assumes the beacon is already DMA mapped */
 static struct sk_buff *
 ath10k_wmi_op_gen_beacon_dma(struct ath10k *ar, u32 vdev_id, const void *bcn,
@@ -7738,6 +7759,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	.gen_init = ath10k_wmi_10_2_op_gen_init,
 	.gen_peer_assoc = ath10k_wmi_10_2_op_gen_peer_assoc,
 	.gen_pdev_get_temperature = ath10k_wmi_10_2_op_gen_pdev_get_temperature,
+	.gen_pdev_bss_chan_info_req = ath10k_wmi_10_2_op_gen_pdev_bss_chan_info,
 
 	/* shared with 10.1 */
 	.map_svc = wmi_10x_svc_map,
@@ -7864,6 +7886,7 @@ static const struct wmi_ops wmi_10_4_ops = {
 	.gen_request_stats = ath10k_wmi_op_gen_request_stats,
 	.gen_pdev_get_temperature = ath10k_wmi_10_2_op_gen_pdev_get_temperature,
 	.get_vdev_subtype = ath10k_wmi_10_4_op_get_vdev_subtype,
+	.gen_pdev_bss_chan_info_req = ath10k_wmi_10_2_op_gen_pdev_bss_chan_info,
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 40bd08d246af..4cdf216ae999 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6487,6 +6487,16 @@ enum wmi_host_platform_type {
 	WMI_HOST_PLATFORM_LOW_PERF,
 };
 
+enum wmi_bss_survey_req_type {
+	WMI_BSS_SURVEY_REQ_TYPE_READ = 1,
+	WMI_BSS_SURVEY_REQ_TYPE_READ_CLEAR,
+};
+
+struct wmi_pdev_chan_info_req_cmd {
+	__le32 type;
+	__le32 reserved;
+} __packed;
+
 struct ath10k;
 struct ath10k_vif;
 struct ath10k_fw_stats_pdev;
-- 
2.8.0

