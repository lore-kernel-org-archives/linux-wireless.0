Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7916 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaLOFN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 00:13:56 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 4/5] ath10k: add wmi interface for pdev_get_temperature
Date: Mon, 15 Dec 2014 10:41:13 +0530
Message-ID: <1418620274-3081-5-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141215_061359_445187_C3078591)
In-Reply-To: <1418620274-3081-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1418620274-3081-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add WMI command support for reading temperature from the target and
corresponding WMI temperature event handler. The pdev_get_temperature
command is currently supported in 10.2 firmware alone.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 17 ++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  2 ++
 drivers/net/wireless/ath/ath10k/wmi.c     | 33 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     | 13 ++++++++++++
 4 files changed, 65 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index feed0fe..20e2c30 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -118,6 +118,7 @@ struct wmi_ops {
 						   u32 period, u32 duration,
 						   u32 next_offset,
 						   u32 enabled);
+	struct sk_buff *(*gen_pdev_get_temperature)(struct ath10k *ar);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -840,4 +841,20 @@ ath10k_wmi_pdev_set_quiet_mode(struct ath10k *ar, u32 period, u32 duration,
 				   ar->wmi.cmd->pdev_set_quiet_mode_cmdid);
 }
 
+static inline int
+ath10k_wmi_pdev_get_temperature(struct ath10k *ar)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_pdev_get_temperature)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_pdev_get_temperature(ar);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->pdev_get_temperature_cmdid);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index e203dad..4c050ce 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2044,6 +2044,7 @@ static struct wmi_cmd_map wmi_tlv_cmd_map = {
 	.force_fw_hang_cmdid = WMI_TLV_FORCE_FW_HANG_CMDID,
 	.gpio_config_cmdid = WMI_TLV_GPIO_CONFIG_CMDID,
 	.gpio_output_cmdid = WMI_TLV_GPIO_OUTPUT_CMDID,
+	.pdev_get_temperature_cmdid = WMI_TLV_CMD_UNSUPPORTED,
 };
 
 static struct wmi_pdev_param_map wmi_tlv_pdev_param_map = {
@@ -2205,6 +2206,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_pktlog_enable = ath10k_wmi_tlv_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_tlv_op_gen_pktlog_disable,
 	/* .gen_pdev_set_quiet_mode not implemented */
+	/* .gen_pdev_get_temperature not implemented */
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index abf4c98..c32dc19 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -145,6 +145,7 @@ static struct wmi_cmd_map wmi_cmd_map = {
 	.force_fw_hang_cmdid = WMI_FORCE_FW_HANG_CMDID,
 	.gpio_config_cmdid = WMI_GPIO_CONFIG_CMDID,
 	.gpio_output_cmdid = WMI_GPIO_OUTPUT_CMDID,
+	.pdev_get_temperature_cmdid = WMI_CMD_UNSUPPORTED,
 };
 
 /* 10.X WMI cmd track */
@@ -267,6 +268,7 @@ static struct wmi_cmd_map wmi_10x_cmd_map = {
 	.force_fw_hang_cmdid = WMI_CMD_UNSUPPORTED,
 	.gpio_config_cmdid = WMI_10X_GPIO_CONFIG_CMDID,
 	.gpio_output_cmdid = WMI_10X_GPIO_OUTPUT_CMDID,
+	.pdev_get_temperature_cmdid = WMI_CMD_UNSUPPORTED,
 };
 
 /* MAIN WMI VDEV param map */
@@ -611,6 +613,7 @@ static struct wmi_cmd_map wmi_10_2_cmd_map = {
 	.force_fw_hang_cmdid = WMI_CMD_UNSUPPORTED,
 	.gpio_config_cmdid = WMI_10_2_GPIO_CONFIG_CMDID,
 	.gpio_output_cmdid = WMI_10_2_GPIO_OUTPUT_CMDID,
+	.pdev_get_temperature_cmdid = WMI_10_2_PDEV_GET_TEMPERATURE_CMDID,
 };
 
 void ath10k_wmi_put_wmi_channel(struct wmi_channel *ch,
@@ -2794,6 +2797,17 @@ int ath10k_wmi_event_ready(struct ath10k *ar, struct sk_buff *skb)
 	return 0;
 }
 
+static int ath10k_wmi_event_temperature(struct ath10k *ar, struct sk_buff *skb)
+{
+	const struct wmi_pdev_temperature_event *ev;
+
+	ev = (struct wmi_pdev_temperature_event *)skb->data;
+	if (WARN_ON(skb->len < sizeof(*ev)))
+		return -EPROTO;
+
+	return 0;
+}
+
 static void ath10k_wmi_op_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_cmd_hdr *cmd_hdr;
@@ -3133,6 +3147,9 @@ static void ath10k_wmi_10_2_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_10_2_READY_EVENTID:
 		ath10k_wmi_event_ready(ar, skb);
 		break;
+	case WMI_10_2_PDEV_TEMPERATURE_EVENTID:
+		ath10k_wmi_event_temperature(ar, skb);
+		break;
 	case WMI_10_2_RTT_KEEPALIVE_EVENTID:
 	case WMI_10_2_GPIO_INPUT_EVENTID:
 	case WMI_10_2_PEER_RATECODE_LIST_EVENTID:
@@ -4414,6 +4431,19 @@ ath10k_wmi_10_2_op_gen_peer_assoc(struct ath10k *ar,
 	return skb;
 }
 
+static struct sk_buff *
+ath10k_wmi_10_2_op_gen_pdev_get_temperature(struct ath10k *ar)
+{
+	struct sk_buff *skb;
+
+	skb = ath10k_wmi_alloc_skb(ar, 0);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi pdev get temperature\n");
+	return skb;
+}
+
 /* This function assumes the beacon is already DMA mapped */
 static struct sk_buff *
 ath10k_wmi_op_gen_beacon_dma(struct ath10k_vif *arvif)
@@ -4663,6 +4693,7 @@ static const struct wmi_ops wmi_ops = {
 	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
 	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
+	/* .gen_pdev_get_temperature not implemented */
 };
 
 static const struct wmi_ops wmi_10_1_ops = {
@@ -4674,6 +4705,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	.gen_pdev_set_rd = ath10k_wmi_10x_op_gen_pdev_set_rd,
 	.gen_start_scan = ath10k_wmi_10x_op_gen_start_scan,
 	.gen_peer_assoc = ath10k_wmi_10_1_op_gen_peer_assoc,
+	/* .gen_pdev_get_temperature not implemented */
 
 	/* shared with main branch */
 	.pull_scan = ath10k_wmi_op_pull_scan_ev,
@@ -4722,6 +4754,7 @@ static const struct wmi_ops wmi_10_2_ops = {
 	.rx = ath10k_wmi_10_2_op_rx,
 	.gen_init = ath10k_wmi_10_2_op_gen_init,
 	.gen_peer_assoc = ath10k_wmi_10_2_op_gen_peer_assoc,
+	.gen_pdev_get_temperature = ath10k_wmi_10_2_op_gen_pdev_get_temperature,
 
 	/* shared with 10.1 */
 	.map_svc = wmi_10x_svc_map,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index ce517bf..f26531f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -550,6 +550,7 @@ struct wmi_cmd_map {
 	u32 force_fw_hang_cmdid;
 	u32 gpio_config_cmdid;
 	u32 gpio_output_cmdid;
+	u32 pdev_get_temperature_cmdid;
 };
 
 /*
@@ -1154,6 +1155,11 @@ enum wmi_10_2_cmd_id {
 	WMI_10_2_PDEV_SET_MIMOGAIN_TABLE_CMDID,
 	WMI_10_2_PDEV_RATEPWR_TABLE_CMDID,
 	WMI_10_2_PDEV_RATEPWR_CHAINMSK_TABLE_CMDID,
+	WMI_10_2_PDEV_GET_INFO,
+	WMI_10_2_VDEV_GET_INFO,
+	WMI_10_2_VDEV_ATF_REQUEST_CMDID,
+	WMI_10_2_PEER_ATF_REQUEST_CMDID,
+	WMI_10_2_PDEV_GET_TEMPERATURE_CMDID,
 	WMI_10_2_PDEV_UTF_CMDID = WMI_10_2_END_CMDID - 1,
 };
 
@@ -1195,6 +1201,8 @@ enum wmi_10_2_event_id {
 	WMI_10_2_MCAST_BUF_RELEASE_EVENTID,
 	WMI_10_2_MCAST_LIST_AGEOUT_EVENTID,
 	WMI_10_2_WDS_PEER_EVENTID,
+	WMI_10_2_PEER_STA_PS_STATECHG_EVENTID,
+	WMI_10_2_PDEV_TEMPERATURE_EVENTID,
 	WMI_10_2_PDEV_UTF_EVENTID = WMI_10_2_END_EVENTID - 1,
 };
 
@@ -4733,6 +4741,11 @@ struct wmi_rdy_ev_arg {
 	const u8 *mac_addr;
 };
 
+struct wmi_pdev_temperature_event {
+	/* temperature value in Celcius degree */
+	__le32 temperature;
+} __packed;
+
 struct ath10k;
 struct ath10k_vif;
 struct ath10k_fw_stats_pdev;
-- 
2.1.3

