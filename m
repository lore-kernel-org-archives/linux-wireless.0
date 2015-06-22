Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26262 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbbFVOms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 10:42:48 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH v2 08/10] ath10k: handle 10.4 fw wmi mgmt rx event
Date: Mon, 22 Jun 2015 20:10:16 +0530
Message-ID: <1434984018-24057-9-git-send-email-rmani@qti.qualcomm.com> (sfid-20150622_164252_328424_6A1C9719)
In-Reply-To: <1434984018-24057-1-git-send-email-rmani@qti.qualcomm.com>
References: <1434984018-24057-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

10.4 firmware wmi mgmt rx event format differs from non 10.4
firmware and changing existing wmi mgmt rx event parsing function
ath10k_wmi_op_pull_mgmt_rx_ev() for 10.4 would add more complex.

This patch adds new function to receive any wmi rx event from
10.4 firmware and also introduce new function to parse wmi mgmt
rx event.

In addition, fw main branch service rdy event parsing function
is linked in wmi ops table.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 64 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h | 15 ++++++++
 2 files changed, 79 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6c51b20..9502032 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2124,6 +2124,40 @@ static int ath10k_wmi_op_pull_mgmt_rx_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
+static int ath10k_wmi_10_4_op_pull_mgmt_rx_ev(struct ath10k *ar,
+					      struct sk_buff *skb,
+					      struct wmi_mgmt_rx_ev_arg *arg)
+{
+	struct wmi_10_4_mgmt_rx_event *ev;
+	struct wmi_10_4_mgmt_rx_hdr *ev_hdr;
+	size_t pull_len;
+	u32 msdu_len;
+
+	ev = (struct wmi_10_4_mgmt_rx_event *)skb->data;
+	ev_hdr = &ev->hdr;
+	pull_len = sizeof(*ev);
+
+	if (skb->len < pull_len)
+		return -EPROTO;
+
+	skb_pull(skb, pull_len);
+	arg->channel = ev_hdr->channel;
+	arg->buf_len = ev_hdr->buf_len;
+	arg->status = ev_hdr->status;
+	arg->snr = ev_hdr->snr;
+	arg->phy_mode = ev_hdr->phy_mode;
+	arg->rate = ev_hdr->rate;
+
+	msdu_len = __le32_to_cpu(arg->buf_len);
+	if (skb->len < msdu_len)
+		return -EPROTO;
+
+	/* Make sure bytes added for padding are removed. */
+	skb_trim(skb, msdu_len);
+
+	return 0;
+}
+
 int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_mgmt_rx_ev_arg arg = {};
@@ -4267,6 +4301,33 @@ out:
 	dev_kfree_skb(skb);
 }
 
+static void ath10k_wmi_10_4_op_rx(struct ath10k *ar, struct sk_buff *skb)
+{
+	struct wmi_cmd_hdr *cmd_hdr;
+	enum wmi_10_4_event_id id;
+
+	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
+	id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
+
+	if (!skb_pull(skb, sizeof(struct wmi_cmd_hdr)))
+		goto out;
+
+	trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
+
+	switch (id) {
+	case WMI_10_4_MGMT_RX_EVENTID:
+		ath10k_wmi_event_mgmt_rx(ar, skb);
+		/* mgmt_rx() owns the skb now! */
+		return;
+	default:
+		ath10k_warn(ar, "Unknown eventid: %d\n", id);
+		break;
+	}
+
+out:
+	dev_kfree_skb(skb);
+}
+
 static void ath10k_wmi_process_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	int ret;
@@ -6186,7 +6247,10 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 };
 
 static const struct wmi_ops wmi_10_4_ops = {
+	.rx = ath10k_wmi_10_4_op_rx,
 	.map_svc = wmi_10_4_svc_map,
+	.pull_mgmt_rx = ath10k_wmi_10_4_op_pull_mgmt_rx_ev,
+	.pull_svc_rdy = ath10k_wmi_main_op_pull_svc_rdy_ev,
 	.gen_init = ath10k_wmi_10_4_op_gen_init,
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index dbb9f1c..b1bec03 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2947,6 +2947,21 @@ struct wmi_mgmt_rx_event_v2 {
 	u8 buf[0];
 } __packed;
 
+struct wmi_10_4_mgmt_rx_hdr {
+	__le32 channel;
+	__le32 snr;
+	    u8 rssi_ctl[4];
+	__le32 rate;
+	__le32 phy_mode;
+	__le32 buf_len;
+	__le32 status;
+} __packed;
+
+struct wmi_10_4_mgmt_rx_event {
+	struct wmi_10_4_mgmt_rx_hdr hdr;
+	u8 buf[0];
+} __packed;
+
 #define WMI_RX_STATUS_OK			0x00
 #define WMI_RX_STATUS_ERR_CRC			0x01
 #define WMI_RX_STATUS_ERR_DECRYPT		0x08
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
