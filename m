Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55167 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab1H3TDQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 15:03:16 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 13/22] ath6kl: Notify cfg80211 of TX status of mgmt_tx frames
Date: Tue, 30 Aug 2011 21:58:02 +0300
Message-ID: <1314730691-12089-14-git-send-email-jouni@qca.qualcomm.com> (sfid-20110830_210320_281864_7DC51748)
In-Reply-To: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use WMI_TX_STATUS_EVENTID event to generate cfg80211_mgmt_tx_frame()
calls. Since we support only a single pending frame for now, use the
hardcoded cookie value 1 and store a copy of the pending frame in
the driver.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |   28 +++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath6kl/wmi.h |    3 +++
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 9b2a182..d098cbd 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -483,10 +483,11 @@ static int ath6kl_wmi_cancel_remain_on_chnl_event_rx(struct wmi *wmi,
 	return 0;
 }
 
-static int ath6kl_wmi_tx_status_event_rx(u8 *datap, int len)
+static int ath6kl_wmi_tx_status_event_rx(struct wmi *wmi, u8 *datap, int len)
 {
 	struct wmi_tx_status_event *ev;
 	u32 id;
+	struct ath6kl *ar = wmi->parent_dev;
 
 	if (len < sizeof(*ev))
 		return -EINVAL;
@@ -495,6 +496,15 @@ static int ath6kl_wmi_tx_status_event_rx(u8 *datap, int len)
 	id = le32_to_cpu(ev->id);
 	ath6kl_dbg(ATH6KL_DBG_WMI, "tx_status: id=%x ack_status=%u\n",
 		   id, ev->ack_status);
+	if (wmi->last_mgmt_tx_frame) {
+		cfg80211_mgmt_tx_status(ar->net_dev, id,
+					wmi->last_mgmt_tx_frame,
+					wmi->last_mgmt_tx_frame_len,
+					!!ev->ack_status, GFP_ATOMIC);
+		kfree(wmi->last_mgmt_tx_frame);
+		wmi->last_mgmt_tx_frame = NULL;
+		wmi->last_mgmt_tx_frame_len = 0;
+	}
 
 	return 0;
 }
@@ -2740,13 +2750,24 @@ int ath6kl_wmi_send_action_cmd(struct wmi *wmi, u32 id, u32 freq, u32 wait,
 {
 	struct sk_buff *skb;
 	struct wmi_send_action_cmd *p;
+	u8 *buf;
 
 	if (wait)
 		return -EINVAL; /* Offload for wait not supported */
 
+	buf = kmalloc(data_len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
 	skb = ath6kl_wmi_get_new_buf(sizeof(*p) + data_len);
-	if (!skb)
+	if (!skb) {
+		kfree(buf);
 		return -ENOMEM;
+	}
+
+	kfree(wmi->last_mgmt_tx_frame);
+	wmi->last_mgmt_tx_frame = buf;
+	wmi->last_mgmt_tx_frame_len = data_len;
 
 	ath6kl_dbg(ATH6KL_DBG_WMI, "send_action_cmd: id=%u freq=%u wait=%u "
 		   "len=%u\n", id, freq, wait, data_len);
@@ -3053,7 +3074,7 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		break;
 	case WMI_TX_STATUS_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_TX_STATUS_EVENTID\n");
-		ret = ath6kl_wmi_tx_status_event_rx(datap, len);
+		ret = ath6kl_wmi_tx_status_event_rx(wmi, datap, len);
 		break;
 	case WMI_RX_PROBE_REQ_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_RX_PROBE_REQ_EVENTID\n");
@@ -3127,5 +3148,6 @@ void ath6kl_wmi_shutdown(struct wmi *wmi)
 	if (!wmi)
 		return;
 
+	kfree(wmi->last_mgmt_tx_frame);
 	kfree(wmi);
 }
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 83af518..cb3d27a 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -129,6 +129,9 @@ struct wmi {
 	u8 ht_allowed[A_NUM_BANDS];
 	u8 traffic_class;
 	bool is_probe_ssid;
+
+	u8 *last_mgmt_tx_frame;
+	size_t last_mgmt_tx_frame_len;
 };
 
 struct host_app_area {
-- 
1.7.4.1

