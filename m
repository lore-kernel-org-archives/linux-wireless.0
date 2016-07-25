Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3449 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752867AbcGYPwC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2016 11:52:02 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u6PFoFx5031715
	for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2016 08:52:01 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0a-0016f401.pphosted.com with ESMTP id 24c5xkfr11-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2016 08:52:01 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2 5/8] mwifiex: process rxba_sync event
Date: Mon, 25 Jul 2016 21:21:08 +0530
Message-ID: <1469461871-3135-6-git-send-email-akarwar@marvell.com> (sfid-20160725_175206_343611_E9E33298)
In-Reply-To: <1469461871-3135-1-git-send-email-akarwar@marvell.com>
References: <1469461871-3135-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Firmware may filter and drop packets under certain condition, for
example, ARP SA=DA packet. this event will be used to synchronize
the Rx Block Acknowledgment (BA) window bitmap and to fill any holes
in driver side.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   | 78 +++++++++++++++++++++-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.h   |  3 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          | 12 ++++
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |  6 ++
 drivers/net/wireless/marvell/mwifiex/uap_event.c   |  7 +-
 5 files changed, 103 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
index a74cc43..9448012 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -78,8 +78,15 @@ static int mwifiex_11n_dispatch_amsdu_pkt(struct mwifiex_private *priv,
  */
 static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
 {
-	int ret = mwifiex_11n_dispatch_amsdu_pkt(priv, payload);
 
+	int ret;
+
+	if (!payload) {
+		mwifiex_dbg(priv->adapter, INFO, "info: fw drop data\n");
+		return 0;
+	}
+
+	ret = mwifiex_11n_dispatch_amsdu_pkt(priv, payload);
 	if (!ret)
 		return 0;
 
@@ -921,3 +928,72 @@ void mwifiex_coex_ampdu_rxwinsize(struct mwifiex_adapter *adapter)
 	else
 		mwifiex_update_ampdu_rxwinsize(adapter, false);
 }
+
+/* This function handles rxba_sync event
+ */
+void mwifiex_11n_rxba_sync_event(struct mwifiex_private *priv,
+				 u8 *event_buf, u16 len)
+{
+	struct mwifiex_ie_types_rxba_sync *tlv_rxba = (void *)event_buf;
+	u16 tlv_type, tlv_len;
+	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr;
+	u8 i, j;
+	u16 seq_num, tlv_seq_num, tlv_bitmap_len;
+	int tlv_buf_left = len;
+	int ret;
+	u8 *tmp;
+
+	mwifiex_dbg_dump(priv->adapter, EVT_D, "RXBA_SYNC event:",
+			 event_buf, len);
+	while (tlv_buf_left >= sizeof(*tlv_rxba)) {
+		tlv_type = le16_to_cpu(tlv_rxba->header.type);
+		tlv_len  = le16_to_cpu(tlv_rxba->header.len);
+		if (tlv_type != TLV_TYPE_RXBA_SYNC) {
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "Wrong TLV id=0x%x\n", tlv_type);
+			return;
+		}
+
+		tlv_seq_num = le16_to_cpu(tlv_rxba->seq_num);
+		tlv_bitmap_len = le16_to_cpu(tlv_rxba->bitmap_len);
+		mwifiex_dbg(priv->adapter, INFO,
+			    "%pM tid=%d seq_num=%d bitmap_len=%d\n",
+			    tlv_rxba->mac, tlv_rxba->tid, tlv_seq_num,
+			    tlv_bitmap_len);
+
+		rx_reor_tbl_ptr =
+			mwifiex_11n_get_rx_reorder_tbl(priv, tlv_rxba->tid,
+						       tlv_rxba->mac);
+		if (!rx_reor_tbl_ptr) {
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "Can not find rx_reorder_tbl!");
+			return;
+		}
+
+		for (i = 0; i < tlv_bitmap_len; i++) {
+			for (j = 0 ; j < 8; j++) {
+				if (tlv_rxba->bitmap[i] & (1 << j)) {
+					seq_num = (MAX_TID_VALUE - 1) &
+						(tlv_seq_num + i * 8 + j);
+
+					mwifiex_dbg(priv->adapter, ERROR,
+						    "drop packet,seq=%d\n",
+						    seq_num);
+
+					ret = mwifiex_11n_rx_reorder_pkt
+					(priv, seq_num, tlv_rxba->tid,
+					 tlv_rxba->mac, 0, NULL);
+
+					if (ret)
+						mwifiex_dbg(priv->adapter,
+							    ERROR,
+							    "Fail to drop packet");
+				}
+			}
+		}
+
+		tlv_buf_left -= (sizeof(*tlv_rxba) + tlv_len);
+		tmp = (u8 *)tlv_rxba + tlv_len + sizeof(*tlv_rxba);
+		tlv_rxba = (struct mwifiex_ie_types_rxba_sync *)tmp;
+	}
+}
diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.h b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.h
index 63ecea8..22d991f 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.h
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.h
@@ -81,5 +81,6 @@ struct mwifiex_rx_reorder_tbl *
 mwifiex_11n_get_rx_reorder_tbl(struct mwifiex_private *priv, int tid, u8 *ta);
 void mwifiex_11n_del_rx_reorder_tbl_by_ta(struct mwifiex_private *priv, u8 *ta);
 void mwifiex_update_rxreor_flags(struct mwifiex_adapter *adapter, u8 flags);
-
+void mwifiex_11n_rxba_sync_event(struct mwifiex_private *priv,
+				 u8 *event_buf, u16 len);
 #endif /* _MWIFIEX_11N_RXREORDER_H_ */
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 3797ef4..3b40e0d 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -176,6 +176,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_PWK_CIPHER         (PROPRIETARY_TLV_BASE_ID + 145)
 #define TLV_TYPE_GWK_CIPHER         (PROPRIETARY_TLV_BASE_ID + 146)
 #define TLV_TYPE_TX_PAUSE           (PROPRIETARY_TLV_BASE_ID + 148)
+#define TLV_TYPE_RXBA_SYNC          (PROPRIETARY_TLV_BASE_ID + 153)
 #define TLV_TYPE_COALESCE_RULE      (PROPRIETARY_TLV_BASE_ID + 154)
 #define TLV_TYPE_KEY_PARAM_V2       (PROPRIETARY_TLV_BASE_ID + 156)
 #define TLV_TYPE_REPEAT_COUNT       (PROPRIETARY_TLV_BASE_ID + 176)
@@ -532,6 +533,7 @@ enum P2P_MODES {
 #define EVENT_CHANNEL_REPORT_RDY        0x00000054
 #define EVENT_TX_DATA_PAUSE             0x00000055
 #define EVENT_EXT_SCAN_REPORT           0x00000058
+#define EVENT_RXBA_SYNC                 0x00000059
 #define EVENT_BG_SCAN_STOPPED           0x00000065
 #define EVENT_REMAIN_ON_CHAN_EXPIRED    0x0000005f
 #define EVENT_MULTI_CHAN_INFO           0x0000006a
@@ -735,6 +737,16 @@ struct mwifiex_ie_types_chan_list_param_set {
 	struct mwifiex_chan_scan_param_set chan_scan_param[1];
 } __packed;
 
+struct mwifiex_ie_types_rxba_sync {
+	struct mwifiex_ie_types_header header;
+	u8 mac[ETH_ALEN];
+	u8 tid;
+	u8 reserved;
+	__le16 seq_num;
+	__le16 bitmap_len;
+	u8 bitmap[1];
+} __packed;
+
 struct chan_band_param_set {
 	u8 radio_type;
 	u8 chan_number;
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index 7e394d4..b973ee8 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -873,6 +873,12 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		mwifiex_bt_coex_wlan_param_update_event(priv,
 							adapter->event_skb);
 		break;
+	case EVENT_RXBA_SYNC:
+		dev_dbg(adapter->dev, "EVENT: RXBA_SYNC\n");
+		mwifiex_11n_rxba_sync_event(priv, adapter->event_body,
+					    adapter->event_skb->len -
+					    sizeof(eventcause));
+		break;
 	default:
 		mwifiex_dbg(adapter, ERROR, "event: unknown event id: %#x\n",
 			    eventcause);
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_event.c b/drivers/net/wireless/marvell/mwifiex/uap_event.c
index 86ff542..d24eca3 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_event.c
@@ -306,7 +306,12 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		mwifiex_dbg(adapter, EVENT, "event: multi-chan info\n");
 		mwifiex_process_multi_chan_event(priv, adapter->event_skb);
 		break;
-
+	case EVENT_RXBA_SYNC:
+		dev_dbg(adapter->dev, "EVENT: RXBA_SYNC\n");
+		mwifiex_11n_rxba_sync_event(priv, adapter->event_body,
+					    adapter->event_skb->len -
+					    sizeof(eventcause));
+		break;
 	default:
 		mwifiex_dbg(adapter, EVENT,
 			    "event: unknown event id: %#x\n", eventcause);
-- 
1.9.1

