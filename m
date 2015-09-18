Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:23395 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988AbbIRNdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:33:15 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t8IDOR8d027007
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:33:14 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0a-0016f401.pphosted.com with ESMTP id 1wy3qpfe8r-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:33:14 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Zhaoyang Liu <liuzy@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 13/16] mwifiex: add usb multi channel event process support
Date: Fri, 18 Sep 2015 06:32:15 -0700
Message-ID: <1442583138-2979-14-git-send-email-akarwar@marvell.com> (sfid-20150918_153322_338097_A101DAD5)
In-Reply-To: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
References: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

This patch add multi channel event process for USB multi tx data endpoints.
Driver receives firmware multi channel event only in case that new
connection is setup or interface is disconnect. Different BSS interface
need update used usb endpoint.

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h        | 18 +++++++++
 drivers/net/wireless/mwifiex/init.c      |  1 +
 drivers/net/wireless/mwifiex/main.h      |  2 +
 drivers/net/wireless/mwifiex/sta_event.c | 69 +++++++++++++++++++++++++++-----
 drivers/net/wireless/mwifiex/usb.c       |  2 +
 5 files changed, 82 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index eaed2e0..1e1e81a 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -107,6 +107,7 @@ enum KEY_TYPE_ID {
 enum mwifiex_usb_ep {
 	MWIFIEX_USB_EP_CMD_EVENT = 1,
 	MWIFIEX_USB_EP_DATA = 2,
+	MWIFIEX_USB_EP_DATA_CH2 = 3,
 };
 
 enum MWIFIEX_802_11_PRIVACY_FILTER {
@@ -177,6 +178,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_COALESCE_RULE      (PROPRIETARY_TLV_BASE_ID + 154)
 #define TLV_TYPE_KEY_PARAM_V2       (PROPRIETARY_TLV_BASE_ID + 156)
 #define TLV_TYPE_MULTI_CHAN_INFO    (PROPRIETARY_TLV_BASE_ID + 183)
+#define TLV_TYPE_MC_GROUP_INFO      (PROPRIETARY_TLV_BASE_ID + 184)
 #define TLV_TYPE_TDLS_IDLE_TIMEOUT  (PROPRIETARY_TLV_BASE_ID + 194)
 #define TLV_TYPE_SCAN_CHANNEL_GAP   (PROPRIETARY_TLV_BASE_ID + 197)
 #define TLV_TYPE_API_REV            (PROPRIETARY_TLV_BASE_ID + 199)
@@ -1994,6 +1996,22 @@ struct mwifiex_ie_types_multi_chan_info {
 	u8 tlv_buffer[0];
 } __packed;
 
+struct mwifiex_ie_types_mc_group_info {
+	struct mwifiex_ie_types_header header;
+	u8 chan_group_id;
+	u8 chan_buf_weight;
+	u8 band_config;
+	u8 chan_num;
+	u32 chan_time;
+	u32 reserved;
+	union {
+		u8 sdio_func_num;
+		u8 usb_ep_num;
+	} hid_num;
+	u8 intf_num;
+	u8 bss_type_numlist[0];
+} __packed;
+
 struct meas_rpt_map {
 	u8 rssi:3;
 	u8 unmeasured:1;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 5d3ae63..de74a77 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -78,6 +78,7 @@ int mwifiex_init_priv(struct mwifiex_private *priv)
 	priv->media_connected = false;
 	eth_broadcast_addr(priv->curr_addr);
 	priv->port_open = false;
+	priv->usb_port = MWIFIEX_USB_EP_DATA;
 	priv->pkt_tx_ctrl = 0;
 	priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
 	priv->data_rate = 0;	/* Initially indicate the rate as auto */
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 8f5c3da..3e044b4 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -520,6 +520,7 @@ struct mwifiex_private {
 	u8 curr_addr[ETH_ALEN];
 	u8 media_connected;
 	u8 port_open;
+	u8 usb_port;
 	u32 num_tx_timeout;
 	/* track consecutive timeout */
 	u8 tx_timeout_cnt;
@@ -990,6 +991,7 @@ struct mwifiex_adapter {
 	u8 coex_rx_win_size;
 	bool drcs_enabled;
 	u8 active_scan_triggered;
+	bool usb_mc_status;
 };
 
 void mwifiex_process_tx_queue(struct mwifiex_adapter *adapter);
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 3d18c58..6792089 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -313,25 +313,74 @@ void mwifiex_process_multi_chan_event(struct mwifiex_private *priv,
 				      struct sk_buff *event_skb)
 {
 	struct mwifiex_ie_types_multi_chan_info *chan_info;
-	u16 status;
+	struct mwifiex_ie_types_mc_group_info *grp_info;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_ie_types_header *tlv;
+	u16 tlv_buf_left, tlv_type, tlv_len;
+	int intf_num, bss_type, bss_num, i;
+	struct mwifiex_private *intf_priv;
 
+	tlv_buf_left = event_skb->len - sizeof(u32);
 	chan_info = (void *)event_skb->data + sizeof(u32);
 
-	if (le16_to_cpu(chan_info->header.type) != TLV_TYPE_MULTI_CHAN_INFO) {
-		mwifiex_dbg(priv->adapter, ERROR,
+	if (le16_to_cpu(chan_info->header.type) != TLV_TYPE_MULTI_CHAN_INFO ||
+	    tlv_buf_left < sizeof(struct mwifiex_ie_types_multi_chan_info)) {
+		mwifiex_dbg(adapter, ERROR,
 			    "unknown TLV in chan_info event\n");
 		return;
 	}
 
-	status = le16_to_cpu(chan_info->status);
+	adapter->usb_mc_status = le16_to_cpu(chan_info->status);
+	mwifiex_dbg(adapter, EVENT, "multi chan operation %s\n",
+		    adapter->usb_mc_status ? "started" : "over");
 
-	if (status) {
-		mwifiex_dbg(priv->adapter, EVENT,
-			    "multi-channel operation started\n");
-	} else {
-		mwifiex_dbg(priv->adapter, EVENT,
-			    "multi-channel operation over\n");
+	tlv_buf_left -= sizeof(struct mwifiex_ie_types_multi_chan_info);
+	tlv = (struct mwifiex_ie_types_header *)chan_info->tlv_buffer;
+
+	while (tlv_buf_left >= (int)sizeof(struct mwifiex_ie_types_header)) {
+		tlv_type = le16_to_cpu(tlv->type);
+		tlv_len  = le16_to_cpu(tlv->len);
+		if ((sizeof(struct mwifiex_ie_types_header) + tlv_len) >
+		    tlv_buf_left) {
+			mwifiex_dbg(adapter, ERROR, "wrong tlv: tlvLen=%d,\t"
+				    "tlvBufLeft=%d\n", tlv_len, tlv_buf_left);
+			break;
+		}
+		if (tlv_type != TLV_TYPE_MC_GROUP_INFO) {
+			mwifiex_dbg(adapter, ERROR, "wrong tlv type: 0x%x\n",
+				    tlv_type);
+			break;
+		}
+
+		grp_info = (struct mwifiex_ie_types_mc_group_info *)tlv;
+		intf_num = grp_info->intf_num;
+		for (i = 0; i < intf_num; i++) {
+			bss_type = grp_info->bss_type_numlist[i] >> 4;
+			bss_num = grp_info->bss_type_numlist[i] & BSS_NUM_MASK;
+			intf_priv = mwifiex_get_priv_by_id(adapter, bss_num,
+							   bss_type);
+			if (!intf_priv) {
+				mwifiex_dbg(adapter, ERROR,
+					    "Invalid bss_type bss_num\t"
+					    "in multi channel event\n");
+				continue;
+			}
+			if (adapter->iface_type == MWIFIEX_USB) {
+				u8 ep;
+
+				ep = grp_info->hid_num.usb_ep_num;
+				if (ep == MWIFIEX_USB_EP_DATA ||
+				    ep == MWIFIEX_USB_EP_DATA_CH2)
+					intf_priv->usb_port = ep;
+			}
+		}
+
+		tlv_buf_left -= sizeof(struct mwifiex_ie_types_header) +
+				tlv_len;
+		tlv = (void *)((u8 *)tlv + tlv_len +
+			       sizeof(struct mwifiex_ie_types_header));
 	}
+
 }
 
 void mwifiex_process_tx_pause_event(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 3f1713e..5a70fe9 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -845,6 +845,8 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 		break;
 	}
 
+	adapter->usb_mc_status = false;
+
 	return 0;
 }
 
-- 
1.8.1.4

