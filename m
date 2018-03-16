Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56824 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750767AbeCPHFx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 03:05:53 -0400
From: ryanhsu@codeaurora.org
To: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: ryanhsu@codeaurora.org
Subject: [PATCH 1/2] ath10k: enable QCA6174/QCA9377 to read the chip temperature
Date: Fri, 16 Mar 2018 00:05:41 -0700
Message-Id: <1521183942-4291-1-git-send-email-ryanhsu@codeaurora.org> (sfid-20180316_080557_828302_E7464844)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ryan Hsu <ryanhsu@codeaurora.org>

The firmware of QCA6174/QCA9377 already support the feature, just enable
it to be able to handle the get_temperature command and process the event.

You can read the temperature by using the hwmon interface,

cat /sys/class/ieee80211/phy*/device/hwmon/hwmon2/temp1_input

Verified with the following hardware and software combination,
QCA6174, only firmware-4.bin doesn't support this, otherwise all support.
QCA9377, all the firmwares upstreamed support this command

Signed-off-by: Ryan Hsu <ryanhsu@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 39 +++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 11 +++++++++
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 7616c1c..9d31b97 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -412,6 +412,19 @@ static int ath10k_wmi_tlv_event_tx_pause(struct ath10k *ar,
 	return 0;
 }
 
+static int ath10k_wmi_tlv_event_temperature(struct ath10k *ar,
+					    struct sk_buff *skb)
+{
+	const struct wmi_tlv_pdev_temperature_event *ev;
+
+	ev = (struct wmi_tlv_pdev_temperature_event *)skb->data;
+	if (WARN_ON(skb->len < sizeof(*ev)))
+		return -EPROTO;
+
+	ath10k_thermal_event_temperature(ar, __le32_to_cpu(ev->temperature));
+	return 0;
+}
+
 /***********/
 /* TLV ops */
 /***********/
@@ -552,6 +565,9 @@ static void ath10k_wmi_tlv_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_TLV_TX_PAUSE_EVENTID:
 		ath10k_wmi_tlv_event_tx_pause(ar, skb);
 		break;
+	case WMI_TLV_PDEV_TEMPERATURE_EVENTID:
+		ath10k_wmi_tlv_event_temperature(ar, skb);
+		break;
 	default:
 		ath10k_warn(ar, "Unknown eventid: %d\n", id);
 		break;
@@ -2554,6 +2570,25 @@ static void *ath10k_wmi_tlv_put_wmm(void *ptr,
 }
 
 static struct sk_buff *
+ath10k_wmi_tlv_op_gen_pdev_get_temperature(struct ath10k *ar)
+{
+	struct wmi_tlv_pdev_get_temp_cmd *cmd;
+	struct wmi_tlv *tlv;
+	struct sk_buff *skb;
+
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*tlv) + sizeof(*cmd));
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	tlv = (void *)skb->data;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_PDEV_GET_TEMPERATURE_CMD);
+	tlv->len = __cpu_to_le16(sizeof(*cmd));
+	cmd = (void *)tlv->value;
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi pdev get temperature tlv\n");
+	return skb;
+}
+
+static struct sk_buff *
 ath10k_wmi_tlv_op_gen_pktlog_disable(struct ath10k *ar)
 {
 	struct wmi_tlv_pktlog_disable *cmd;
@@ -3334,7 +3369,7 @@ static u32 ath10k_wmi_tlv_prepare_peer_qos(u8 uapsd_queues, u8 sp)
 	.force_fw_hang_cmdid = WMI_TLV_FORCE_FW_HANG_CMDID,
 	.gpio_config_cmdid = WMI_TLV_GPIO_CONFIG_CMDID,
 	.gpio_output_cmdid = WMI_TLV_GPIO_OUTPUT_CMDID,
-	.pdev_get_temperature_cmdid = WMI_TLV_CMD_UNSUPPORTED,
+	.pdev_get_temperature_cmdid = WMI_TLV_PDEV_GET_TEMPERATURE_CMDID,
 	.vdev_set_wmm_params_cmdid = WMI_TLV_VDEV_SET_WMM_PARAMS_CMDID,
 	.tdls_set_state_cmdid = WMI_TLV_TDLS_SET_STATE_CMDID,
 	.tdls_peer_update_cmdid = WMI_TLV_TDLS_PEER_UPDATE_CMDID,
@@ -3596,7 +3631,7 @@ static u32 ath10k_wmi_tlv_prepare_peer_qos(u8 uapsd_queues, u8 sp)
 	.gen_pktlog_enable = ath10k_wmi_tlv_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_tlv_op_gen_pktlog_disable,
 	/* .gen_pdev_set_quiet_mode not implemented */
-	/* .gen_pdev_get_temperature not implemented */
+	.gen_pdev_get_temperature = ath10k_wmi_tlv_op_gen_pdev_get_temperature,
 	/* .gen_addba_clear_resp not implemented */
 	/* .gen_addba_send not implemented */
 	/* .gen_addba_set_resp not implemented */
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 22cf011..906e9e1 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1235,6 +1235,17 @@ struct wmi_tlv_init_cmd {
 	__le32 num_host_mem_chunks;
 } __packed;
 
+struct wmi_tlv_pdev_get_temp_cmd {
+	__le32 pdev_id; /* not used */
+} __packed;
+
+struct wmi_tlv_pdev_temperature_event {
+	__le32 tlv_hdr;
+	/* temperature value in Celcius degree */
+	__le32 temperature;
+	__le32 pdev_id;
+} __packed;
+
 struct wmi_tlv_pdev_set_param_cmd {
 	__le32 pdev_id; /* not used yet */
 	__le32 param_id;
-- 
1.9.1
