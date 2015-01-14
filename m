Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14130 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750782AbbANKrp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 05:47:45 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0EANn2T027577
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 02:47:45 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1rwj838p3d-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 02:47:44 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<gaoqs@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 08/10] mwifiex: handle radar detect event from FW
Date: Wed, 14 Jan 2015 21:45:36 +0530
Message-ID: <1421252138-30157-9-git-send-email-patila@marvell.com> (sfid-20150114_114747_964597_95A177AF)
In-Reply-To: <1421252138-30157-1-git-send-email-patila@marvell.com>
References: <1421252138-30157-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for radar_detected event from FW.
Driver in turn would stop netdev queues to stop TX traffic and
issue RADAR_DETECT event to cfg80211.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Qingshui Gao <gaoqs@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/11h.c       | 24 ++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/fw.h        | 20 ++++++++++++++++++++
 drivers/net/wireless/mwifiex/main.h      |  2 ++
 drivers/net/wireless/mwifiex/sta_event.c |  5 +++++
 drivers/net/wireless/mwifiex/uap_event.c |  4 ++++
 5 files changed, 55 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/11h.c b/drivers/net/wireless/mwifiex/11h.c
index e44cac7..08c12ae 100644
--- a/drivers/net/wireless/mwifiex/11h.c
+++ b/drivers/net/wireless/mwifiex/11h.c
@@ -216,3 +216,27 @@ int mwifiex_11h_handle_chanrpt_ready(struct mwifiex_private *priv,
 
 	return 0;
 }
+
+/* Handler for radar detected event from FW.*/
+int mwifiex_11h_handle_radar_detected(struct mwifiex_private *priv,
+				      struct sk_buff *skb)
+{
+	struct mwifiex_radar_det_event *rdr_event;
+
+	rdr_event = (void *)(skb->data + sizeof(u32));
+
+	if (le32_to_cpu(rdr_event->passed)) {
+		dev_notice(priv->adapter->dev,
+			   "radar detected; indicating kernel\n");
+		cfg80211_radar_event(priv->adapter->wiphy, &priv->dfs_chandef,
+				     GFP_KERNEL);
+		dev_dbg(priv->adapter->dev, "regdomain: %d\n",
+			rdr_event->reg_domain);
+		dev_dbg(priv->adapter->dev, "radar detection type: %d\n",
+			rdr_event->det_type);
+	} else {
+		dev_dbg(priv->adapter->dev, "false radar detection event!\n");
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 324ef29..6d433227 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -495,6 +495,7 @@ enum P2P_MODES {
 #define EVENT_HOSTWAKE_STAIE		0x0000004d
 #define EVENT_CHANNEL_SWITCH_ANN        0x00000050
 #define EVENT_TDLS_GENERIC_EVENT        0x00000052
+#define EVENT_RADAR_DETECTED		0x00000053
 #define EVENT_CHANNEL_REPORT_RDY        0x00000054
 #define EVENT_EXT_SCAN_REPORT           0x00000058
 #define EVENT_REMAIN_ON_CHAN_EXPIRED    0x0000005f
@@ -1813,6 +1814,25 @@ struct mwifiex_ie_types_rssi_threshold {
 	u8 evt_freq;
 } __packed;
 
+#define MWIFIEX_DFS_REC_HDR_LEN		8
+#define MWIFIEX_DFS_REC_HDR_NUM		10
+#define MWIFIEX_BIN_COUNTER_LEN		7
+
+struct mwifiex_radar_det_event {
+	__le32 detect_count;
+	u8 reg_domain;  /*1=fcc, 2=etsi, 3=mic*/
+	u8 det_type;  /*0=none, 1=pw(chirp), 2=pri(radar)*/
+	__le16 pw_chirp_type;
+	u8 pw_chirp_idx;
+	u8 pw_value;
+	u8 pri_radar_type;
+	u8 pri_bincnt;
+	u8 bin_counter[MWIFIEX_BIN_COUNTER_LEN];
+	u8 num_dfs_records;
+	u8 dfs_record_hdr[MWIFIEX_DFS_REC_HDR_NUM][MWIFIEX_DFS_REC_HDR_LEN];
+	__le32 passed;
+} __packed;
+
 struct meas_rpt_map {
 	u8 rssi:3;
 	u8 unmeasured:1;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 26380a5..1a612f6 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1395,6 +1395,8 @@ mwifiex_clone_skb_for_tx_status(struct mwifiex_private *priv,
 				struct sk_buff *skb, u8 flag, u64 *cookie);
 void mwifiex_dfs_cac_work_queue(struct work_struct *work);
 void mwifiex_abort_cac(struct mwifiex_private *priv);
+int mwifiex_11h_handle_radar_detected(struct mwifiex_private *priv,
+				      struct sk_buff *skb);
 
 void mwifiex_hist_data_set(struct mwifiex_private *priv, u8 rx_rate, s8 snr,
 			   s8 nflr);
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index c5899dd..37ade9c 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -518,6 +518,11 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		ret = mwifiex_11h_handle_chanrpt_ready(priv,
 						       adapter->event_skb);
 		break;
+	case EVENT_RADAR_DETECTED:
+		dev_dbg(adapter->dev, "event: Radar detected\n");
+		ret = mwifiex_11h_handle_radar_detected(priv,
+							adapter->event_skb);
+		break;
 	default:
 		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
 			eventcause);
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index 6bb7b27..01303f1 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -222,6 +222,10 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		dev_dbg(adapter->dev, "event: Channel Report\n");
 		mwifiex_11h_handle_chanrpt_ready(priv, adapter->event_skb);
 		break;
+	case EVENT_RADAR_DETECTED:
+		dev_dbg(adapter->dev, "event: Radar detected\n");
+		mwifiex_11h_handle_radar_detected(priv, adapter->event_skb);
+		break;
 	default:
 		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
 			eventcause);
-- 
1.8.1.4

