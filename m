Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49531 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751600AbbANKra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 05:47:30 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0EANkvN027574
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 02:47:29 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1rwj838p31-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 02:47:29 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<gaoqs@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 07/10] mwifiex: support for channel report for radar detection
Date: Wed, 14 Jan 2015 21:45:35 +0530
Message-ID: <1421252138-30157-8-git-send-email-patila@marvell.com> (sfid-20150114_114733_580703_9903C732)
In-Reply-To: <1421252138-30157-1-git-send-email-patila@marvell.com>
References: <1421252138-30157-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for channel report enabling.
Channel report event happens if radar is detected on specified channel
after driver has issued radar detect command within CAC time.
Driver in turn sends RADAR_DETECTED event to cfg80211 to tell radar was
detected within CAC time.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Qingshui Gao <gaoqs@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/11h.c       | 51 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/fw.h        | 23 ++++++++++++++
 drivers/net/wireless/mwifiex/main.h      |  2 ++
 drivers/net/wireless/mwifiex/sta_event.c |  5 ++++
 drivers/net/wireless/mwifiex/uap_event.c |  4 +++
 5 files changed, 85 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/11h.c b/drivers/net/wireless/mwifiex/11h.c
index 8832c83..e44cac7 100644
--- a/drivers/net/wireless/mwifiex/11h.c
+++ b/drivers/net/wireless/mwifiex/11h.c
@@ -165,3 +165,54 @@ void mwifiex_abort_cac(struct mwifiex_private *priv)
 				   NL80211_RADAR_CAC_ABORTED, GFP_KERNEL);
 	}
 }
+
+/* This function handles channel report event from FW during CAC period.
+ * If radar is detected during CAC, driver indicates the same to cfg80211
+ * and also cancels ongoing delayed work.
+ */
+int mwifiex_11h_handle_chanrpt_ready(struct mwifiex_private *priv,
+				     struct sk_buff *skb)
+{
+	struct host_cmd_ds_chan_rpt_event *rpt_event;
+	struct mwifiex_ie_types_chan_rpt_data *rpt;
+	u8 *evt_buf;
+	u16 event_len, tlv_len;
+
+	rpt_event = (void *)(skb->data + sizeof(u32));
+	event_len = skb->len - (sizeof(struct host_cmd_ds_chan_rpt_event)+
+				sizeof(u32));
+
+	if (le32_to_cpu(rpt_event->result) != HostCmd_RESULT_OK) {
+		dev_err(priv->adapter->dev, "Error in channel report event\n");
+		return -1;
+	}
+
+	evt_buf = (void *)&rpt_event->tlvbuf;
+
+	while (event_len >= sizeof(struct mwifiex_ie_types_header)) {
+		rpt = (void *)&rpt_event->tlvbuf;
+		tlv_len = le16_to_cpu(rpt->header.len);
+
+		switch (le16_to_cpu(rpt->header.type)) {
+		case TLV_TYPE_CHANRPT_11H_BASIC:
+			if (rpt->map.radar) {
+				dev_notice(priv->adapter->dev,
+					   "RADAR Detected on channel %d!\n",
+					    priv->dfs_chandef.chan->hw_value);
+				cancel_delayed_work_sync(&priv->dfs_cac_work);
+				cfg80211_cac_event(priv->netdev,
+						   &priv->dfs_chandef,
+						   NL80211_RADAR_DETECTED,
+						   GFP_KERNEL);
+			}
+			break;
+		default:
+			break;
+		}
+
+		evt_buf += (tlv_len + sizeof(rpt->header));
+		event_len -= (tlv_len + sizeof(rpt->header));
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 739151c..324ef29 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -158,6 +158,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_POWER_GROUP        (PROPRIETARY_TLV_BASE_ID + 84)
 #define TLV_TYPE_BSS_SCAN_RSP       (PROPRIETARY_TLV_BASE_ID + 86)
 #define TLV_TYPE_BSS_SCAN_INFO      (PROPRIETARY_TLV_BASE_ID + 87)
+#define TLV_TYPE_CHANRPT_11H_BASIC  (PROPRIETARY_TLV_BASE_ID + 91)
 #define TLV_TYPE_UAP_RETRY_LIMIT    (PROPRIETARY_TLV_BASE_ID + 93)
 #define TLV_TYPE_WAPI_IE            (PROPRIETARY_TLV_BASE_ID + 94)
 #define TLV_TYPE_UAP_MGMT_FRAME     (PROPRIETARY_TLV_BASE_ID + 104)
@@ -494,6 +495,7 @@ enum P2P_MODES {
 #define EVENT_HOSTWAKE_STAIE		0x0000004d
 #define EVENT_CHANNEL_SWITCH_ANN        0x00000050
 #define EVENT_TDLS_GENERIC_EVENT        0x00000052
+#define EVENT_CHANNEL_REPORT_RDY        0x00000054
 #define EVENT_EXT_SCAN_REPORT           0x00000058
 #define EVENT_REMAIN_ON_CHAN_EXPIRED    0x0000005f
 #define EVENT_TX_STATUS_REPORT		0x00000074
@@ -1228,6 +1230,13 @@ struct host_cmd_ds_chan_rpt_req {
 	__le32 msec_dwell_time;
 } __packed;
 
+struct host_cmd_ds_chan_rpt_event {
+	__le32 result;
+	__le64 start_tsf;
+	__le32 duration;
+	u8 tlvbuf[0];
+} __packed;
+
 struct mwifiex_fixed_bcn_param {
 	__le64 timestamp;
 	__le16 beacon_period;
@@ -1804,6 +1813,20 @@ struct mwifiex_ie_types_rssi_threshold {
 	u8 evt_freq;
 } __packed;
 
+struct meas_rpt_map {
+	u8 rssi:3;
+	u8 unmeasured:1;
+	u8 radar:1;
+	u8 unidentified_sig:1;
+	u8 ofdm_preamble:1;
+	u8 bss:1;
+} __packed;
+
+struct mwifiex_ie_types_chan_rpt_data {
+	struct mwifiex_ie_types_header header;
+	struct meas_rpt_map map;
+} __packed;
+
 struct host_cmd_ds_802_11_subsc_evt {
 	__le16 action;
 	__le16 events;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 8e2b692..26380a5 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1384,6 +1384,8 @@ void mwifiex_clean_auto_tdls(struct mwifiex_private *priv);
 int mwifiex_cmd_issue_chan_report_request(struct mwifiex_private *priv,
 					  struct host_cmd_ds_command *cmd,
 					  void *data_buf);
+int mwifiex_11h_handle_chanrpt_ready(struct mwifiex_private *priv,
+				     struct sk_buff *skb);
 
 void mwifiex_parse_tx_status_event(struct mwifiex_private *priv,
 				   void *event_body);
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 0482116..c5899dd 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -513,6 +513,11 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		mwifiex_parse_tx_status_event(priv, adapter->event_body);
 		break;
 
+	case EVENT_CHANNEL_REPORT_RDY:
+		dev_dbg(adapter->dev, "event: Channel Report\n");
+		ret = mwifiex_11h_handle_chanrpt_ready(priv,
+						       adapter->event_skb);
+		break;
 	default:
 		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
 			eventcause);
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index ec40be8..6bb7b27 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -216,7 +216,11 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		adapter->ps_state = PS_STATE_AWAKE;
 		adapter->pm_wakeup_card_req = false;
 		adapter->pm_wakeup_fw_try = false;
+		break;
 
+	case EVENT_CHANNEL_REPORT_RDY:
+		dev_dbg(adapter->dev, "event: Channel Report\n");
+		mwifiex_11h_handle_chanrpt_ready(priv, adapter->event_skb);
 		break;
 	default:
 		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
-- 
1.8.1.4

