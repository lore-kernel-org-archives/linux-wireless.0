Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55231 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933078AbbFVII1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 04:08:27 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t5M80NBO000563
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:08:27 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1v57pduf4r-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:08:26 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 17/17] mwifiex: handle multichannel event
Date: Mon, 22 Jun 2015 19:06:23 +0530
Message-ID: <1434980183-2901-18-git-send-email-patila@marvell.com> (sfid-20150622_103355_147671_7FB191C7)
In-Reply-To: <1434980183-2901-1-git-send-email-patila@marvell.com>
References: <1434980183-2901-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support to handle multichannel event from FW.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h        |  8 ++++++++
 drivers/net/wireless/mwifiex/main.h      |  2 ++
 drivers/net/wireless/mwifiex/sta_event.c | 30 ++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/uap_event.c |  6 ++++++
 4 files changed, 46 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 976b585..98269bf 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -172,6 +172,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_TX_PAUSE           (PROPRIETARY_TLV_BASE_ID + 148)
 #define TLV_TYPE_COALESCE_RULE      (PROPRIETARY_TLV_BASE_ID + 154)
 #define TLV_TYPE_KEY_PARAM_V2       (PROPRIETARY_TLV_BASE_ID + 156)
+#define TLV_TYPE_MULTI_CHAN_INFO    (PROPRIETARY_TLV_BASE_ID + 183)
 #define TLV_TYPE_TDLS_IDLE_TIMEOUT  (PROPRIETARY_TLV_BASE_ID + 194)
 #define TLV_TYPE_SCAN_CHANNEL_GAP   (PROPRIETARY_TLV_BASE_ID + 197)
 #define TLV_TYPE_API_REV            (PROPRIETARY_TLV_BASE_ID + 199)
@@ -516,6 +517,7 @@ enum P2P_MODES {
 #define EVENT_TX_DATA_PAUSE             0x00000055
 #define EVENT_EXT_SCAN_REPORT           0x00000058
 #define EVENT_REMAIN_ON_CHAN_EXPIRED    0x0000005f
+#define EVENT_MULTI_CHAN_INFO           0x0000006a
 #define EVENT_TX_STATUS_REPORT		0x00000074
 #define EVENT_BT_COEX_WLAN_PARA_CHANGE	0X00000076
 
@@ -1970,6 +1972,12 @@ struct mwifiex_radar_det_event {
 	__le32 passed;
 } __packed;
 
+struct mwifiex_ie_types_multi_chan_info {
+	struct mwifiex_ie_types_header header;
+	__le16 status;
+	u8 tlv_buffer[0];
+} __packed;
+
 struct meas_rpt_map {
 	u8 rssi:3;
 	u8 unmeasured:1;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index f3264f2..face747 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1557,6 +1557,8 @@ void mwifiex_11n_delba(struct mwifiex_private *priv, int tid);
 int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy);
 void mwifiex_process_tx_pause_event(struct mwifiex_private *priv,
 				    struct sk_buff *event);
+void mwifiex_process_multi_chan_event(struct mwifiex_private *priv,
+				      struct sk_buff *event_skb);
 
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index a2777d1..3d18c58 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -309,6 +309,31 @@ static void mwifiex_process_sta_tx_pause(struct mwifiex_private *priv,
 	}
 }
 
+void mwifiex_process_multi_chan_event(struct mwifiex_private *priv,
+				      struct sk_buff *event_skb)
+{
+	struct mwifiex_ie_types_multi_chan_info *chan_info;
+	u16 status;
+
+	chan_info = (void *)event_skb->data + sizeof(u32);
+
+	if (le16_to_cpu(chan_info->header.type) != TLV_TYPE_MULTI_CHAN_INFO) {
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "unknown TLV in chan_info event\n");
+		return;
+	}
+
+	status = le16_to_cpu(chan_info->status);
+
+	if (status) {
+		mwifiex_dbg(priv->adapter, EVENT,
+			    "multi-channel operation started\n");
+	} else {
+		mwifiex_dbg(priv->adapter, EVENT,
+			    "multi-channel operation over\n");
+	}
+}
+
 void mwifiex_process_tx_pause_event(struct mwifiex_private *priv,
 				    struct sk_buff *event_skb)
 {
@@ -748,6 +773,11 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		mwifiex_process_tx_pause_event(priv, adapter->event_skb);
 		break;
 
+	case EVENT_MULTI_CHAN_INFO:
+		mwifiex_dbg(adapter, EVENT, "event: multi-chan info\n");
+		mwifiex_process_multi_chan_event(priv, adapter->event_skb);
+		break;
+
 	case EVENT_TX_STATUS_REPORT:
 		mwifiex_dbg(adapter, EVENT, "event: TX_STATUS Report\n");
 		mwifiex_parse_tx_status_event(priv, adapter->event_body);
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index a9d34c6..492a8b3 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -304,6 +304,12 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		mwifiex_dbg(adapter, EVENT, "event: TX DATA PAUSE\n");
 		mwifiex_process_tx_pause_event(priv, adapter->event_skb);
 		break;
+
+	case EVENT_MULTI_CHAN_INFO:
+		mwifiex_dbg(adapter, EVENT, "event: multi-chan info\n");
+		mwifiex_process_multi_chan_event(priv, adapter->event_skb);
+		break;
+
 	default:
 		mwifiex_dbg(adapter, EVENT,
 			    "event: unknown event id: %#x\n", eventcause);
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
