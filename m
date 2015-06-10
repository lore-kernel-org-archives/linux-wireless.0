Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10475 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753594AbbFJNUf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 09:20:35 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t5ADK63t000742
	for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2015 06:20:34 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1uwp9spkdc-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2015 06:20:34 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Avinash Patil <patila@marvell.com>,
	Chunfan Chen <jeffc@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: handle BT coex event to adjust Rx BA window size
Date: Wed, 10 Jun 2015 06:19:48 -0700
Message-ID: <1433942388-28320-1-git-send-email-akarwar@marvell.com> (sfid-20150610_152039_262116_833E4511)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chunfan Chen <jeffc@marvell.com>

If timeshare coexistance between bluetooth and WLAN gets enabled,
firmware will give host an event to reduce Rx AMPDU BA window size.
The event is handled in this patch.

Signed-off-by: Chunfan Chen <jeffc@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           | 93 ++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/11n_rxreorder.c | 80 ++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/decl.h          |  7 ++-
 drivers/net/wireless/mwifiex/fw.h            | 19 ++++++
 drivers/net/wireless/mwifiex/main.h          | 14 ++++-
 drivers/net/wireless/mwifiex/sta_event.c     | 61 ++++++++++++++++++
 drivers/net/wireless/mwifiex/uap_event.c     |  5 ++
 7 files changed, 277 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 4d8ef49..c174e79 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -648,6 +648,30 @@ int mwifiex_send_delba(struct mwifiex_private *priv, int tid, u8 *peer_mac,
 }
 
 /*
+ * This function sends delba to specific tid
+ */
+void mwifiex_11n_delba(struct mwifiex_private *priv, int tid)
+{
+	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr;
+
+	if (list_empty(&priv->rx_reorder_tbl_ptr)) {
+		dev_dbg(priv->adapter->dev,
+			"mwifiex_11n_delba: rx_reorder_tbl_ptr empty\n");
+		return;
+	}
+
+	list_for_each_entry(rx_reor_tbl_ptr, &priv->rx_reorder_tbl_ptr, list) {
+		if (rx_reor_tbl_ptr->tid == tid) {
+			dev_dbg(priv->adapter->dev,
+				"Send delba to tid=%d, %pM\n",
+				tid, rx_reor_tbl_ptr->ta);
+			mwifiex_send_delba(priv, tid, rx_reor_tbl_ptr->ta, 0);
+			return;
+		}
+	}
+}
+
+/*
  * This function handles the command response of a delete BA request.
  */
 void mwifiex_11n_delete_ba_stream(struct mwifiex_private *priv, u8 *del_ba)
@@ -819,3 +843,72 @@ u8 mwifiex_get_sec_chan_offset(int chan)
 
 	return sec_offset;
 }
+
+/* This function will send DELBA to entries in the priv's
+ * Tx BA stream table
+ */
+static void
+mwifiex_send_delba_txbastream_tbl(struct mwifiex_private *priv, u8 tid)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_tx_ba_stream_tbl *tx_ba_stream_tbl_ptr;
+
+	if (list_empty(&priv->tx_ba_stream_tbl_ptr))
+		return;
+
+	list_for_each_entry(tx_ba_stream_tbl_ptr,
+			    &priv->tx_ba_stream_tbl_ptr, list) {
+		if (tx_ba_stream_tbl_ptr->ba_status == BA_SETUP_COMPLETE) {
+			if (tid == tx_ba_stream_tbl_ptr->tid) {
+				dev_dbg(adapter->dev,
+					"Tx:Send delba to tid=%d, %pM\n", tid,
+					tx_ba_stream_tbl_ptr->ra);
+				mwifiex_send_delba(priv,
+						   tx_ba_stream_tbl_ptr->tid,
+						   tx_ba_stream_tbl_ptr->ra, 1);
+				return;
+			}
+		}
+	}
+}
+
+/* This function updates all the tx_win_size
+ */
+void mwifiex_update_ampdu_txwinsize(struct mwifiex_adapter *adapter)
+{
+	u8 i;
+	u32 tx_win_size;
+	struct mwifiex_private *priv;
+
+	for (i = 0; i < adapter->priv_num; i++) {
+		if (!adapter->priv[i])
+			continue;
+		priv = adapter->priv[i];
+		tx_win_size = priv->add_ba_param.tx_win_size;
+
+		if (priv->bss_type == MWIFIEX_BSS_TYPE_STA)
+			priv->add_ba_param.tx_win_size =
+				MWIFIEX_STA_AMPDU_DEF_TXWINSIZE;
+
+		if (priv->bss_type == MWIFIEX_BSS_TYPE_P2P)
+			priv->add_ba_param.tx_win_size =
+				MWIFIEX_STA_AMPDU_DEF_TXWINSIZE;
+
+		if (priv->bss_type == MWIFIEX_BSS_TYPE_UAP)
+			priv->add_ba_param.tx_win_size =
+				MWIFIEX_UAP_AMPDU_DEF_TXWINSIZE;
+
+		if (adapter->coex_win_size) {
+			if (adapter->coex_tx_win_size)
+				priv->add_ba_param.tx_win_size =
+					adapter->coex_tx_win_size;
+		}
+
+		if (tx_win_size != priv->add_ba_param.tx_win_size) {
+			if (!priv->media_connected)
+				continue;
+			for (i = 0; i < MAX_NUM_TID; i++)
+				mwifiex_send_delba_txbastream_tbl(priv, i);
+		}
+	}
+}
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 64401a7..2906cd5 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -828,3 +828,83 @@ void mwifiex_update_rxreor_flags(struct mwifiex_adapter *adapter, u8 flags)
 
 	return;
 }
+
+/* This function update all the rx_win_size based on coex flag
+ */
+static void mwifiex_update_ampdu_rxwinsize(struct mwifiex_adapter *adapter,
+					   bool coex_flag)
+{
+	u8 i;
+	u32 rx_win_size;
+	struct mwifiex_private *priv;
+
+	dev_dbg(adapter->dev, "Update rxwinsize %d\n", coex_flag);
+
+	for (i = 0; i < adapter->priv_num; i++) {
+		if (!adapter->priv[i])
+			continue;
+		priv = adapter->priv[i];
+		rx_win_size = priv->add_ba_param.rx_win_size;
+		if (coex_flag) {
+			if (priv->bss_type == MWIFIEX_BSS_TYPE_STA)
+				priv->add_ba_param.rx_win_size =
+					MWIFIEX_STA_COEX_AMPDU_DEF_RXWINSIZE;
+			if (priv->bss_type == MWIFIEX_BSS_TYPE_P2P)
+				priv->add_ba_param.rx_win_size =
+					MWIFIEX_STA_COEX_AMPDU_DEF_RXWINSIZE;
+			if (priv->bss_type == MWIFIEX_BSS_TYPE_UAP)
+				priv->add_ba_param.rx_win_size =
+					MWIFIEX_UAP_COEX_AMPDU_DEF_RXWINSIZE;
+		} else {
+			if (priv->bss_type == MWIFIEX_BSS_TYPE_STA)
+				priv->add_ba_param.rx_win_size =
+					MWIFIEX_STA_AMPDU_DEF_RXWINSIZE;
+			if (priv->bss_type == MWIFIEX_BSS_TYPE_P2P)
+				priv->add_ba_param.rx_win_size =
+					MWIFIEX_STA_AMPDU_DEF_RXWINSIZE;
+			if (priv->bss_type == MWIFIEX_BSS_TYPE_UAP)
+				priv->add_ba_param.rx_win_size =
+					MWIFIEX_UAP_AMPDU_DEF_RXWINSIZE;
+		}
+
+		if (adapter->coex_win_size && adapter->coex_rx_win_size)
+			priv->add_ba_param.rx_win_size =
+					adapter->coex_rx_win_size;
+
+		if (rx_win_size != priv->add_ba_param.rx_win_size) {
+			if (!priv->media_connected)
+				continue;
+			for (i = 0; i < MAX_NUM_TID; i++)
+				mwifiex_11n_delba(priv, i);
+		}
+	}
+}
+
+/* This function check coex for RX BA
+ */
+void mwifiex_coex_ampdu_rxwinsize(struct mwifiex_adapter *adapter)
+{
+	u8 i;
+	struct mwifiex_private *priv;
+	u8 count = 0;
+
+	for (i = 0; i < adapter->priv_num; i++) {
+		if (adapter->priv[i]) {
+			priv = adapter->priv[i];
+			if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) {
+				if (priv->media_connected)
+					count++;
+			}
+			if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP) {
+				if (priv->bss_started)
+					count++;
+			}
+		}
+		if (count >= MWIFIEX_BSS_COEX_COUNT)
+			break;
+	}
+	if (count >= MWIFIEX_BSS_COEX_COUNT)
+		mwifiex_update_ampdu_rxwinsize(adapter, true);
+	else
+		mwifiex_update_ampdu_rxwinsize(adapter, false);
+}
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 38f24e0..51e3447 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -29,7 +29,7 @@
 #include <uapi/linux/if_arp.h>
 #include <net/mac80211.h>
 
-
+#define MWIFIEX_BSS_COEX_COUNT	     2
 #define MWIFIEX_MAX_BSS_NUM         (3)
 
 #define MWIFIEX_DMA_ALIGN_SZ	    64
@@ -49,7 +49,12 @@
 
 #define MWIFIEX_STA_AMPDU_DEF_TXWINSIZE        64
 #define MWIFIEX_STA_AMPDU_DEF_RXWINSIZE        64
+#define MWIFIEX_STA_COEX_AMPDU_DEF_RXWINSIZE   16
+
 #define MWIFIEX_UAP_AMPDU_DEF_TXWINSIZE        32
+
+#define MWIFIEX_UAP_COEX_AMPDU_DEF_RXWINSIZE   16
+
 #define MWIFIEX_UAP_AMPDU_DEF_RXWINSIZE        16
 #define MWIFIEX_11AC_STA_AMPDU_DEF_TXWINSIZE   64
 #define MWIFIEX_11AC_STA_AMPDU_DEF_RXWINSIZE   64
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 72f161e..cd09051 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -175,6 +175,8 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_SCAN_CHANNEL_GAP   (PROPRIETARY_TLV_BASE_ID + 197)
 #define TLV_TYPE_API_REV            (PROPRIETARY_TLV_BASE_ID + 199)
 #define TLV_TYPE_CHANNEL_STATS      (PROPRIETARY_TLV_BASE_ID + 198)
+#define TLV_BTCOEX_WL_AGGR_WINSIZE  (PROPRIETARY_TLV_BASE_ID + 202)
+#define TLV_BTCOEX_WL_SCANTIME      (PROPRIETARY_TLV_BASE_ID + 203)
 
 #define MWIFIEX_TX_DATA_BUF_SIZE_2K        2048
 
@@ -510,6 +512,7 @@ enum P2P_MODES {
 #define EVENT_EXT_SCAN_REPORT           0x00000058
 #define EVENT_REMAIN_ON_CHAN_EXPIRED    0x0000005f
 #define EVENT_TX_STATUS_REPORT		0x00000074
+#define EVENT_BT_COEX_WLAN_PARA_CHANGE	0X00000076
 
 #define EVENT_ID_MASK                   0xffff
 #define BSS_NUM_MASK                    0xf
@@ -1786,6 +1789,22 @@ struct host_cmd_tlv_power_constraint {
 	u8 constraint;
 } __packed;
 
+struct mwifiex_ie_types_btcoex_scan_time {
+	struct mwifiex_ie_types_header header;
+	u8 coex_scan;
+	u8 reserved;
+	u16 min_scan_time;
+	u16 max_scan_time;
+} __packed;
+
+struct mwifiex_ie_types_btcoex_aggr_win_size {
+	struct mwifiex_ie_types_header header;
+	u8 coex_win_size;
+	u8 tx_win_size;
+	u8 rx_win_size;
+	u8 reserved;
+} __packed;
+
 struct host_cmd_ds_version_ext {
 	u8 version_str_sel;
 	char version_str[128];
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index d92c527..ae98b5b 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -973,6 +973,12 @@ struct mwifiex_adapter {
 	u32 num_in_chan_stats;
 	int survey_idx;
 	bool auto_tdls;
+	u8 coex_scan;
+	u8 coex_min_scan_time;
+	u8 coex_max_scan_time;
+	u8 coex_win_size;
+	u8 coex_tx_win_size;
+	u8 coex_rx_win_size;
 };
 
 void mwifiex_process_tx_queue(struct mwifiex_adapter *adapter);
@@ -1162,6 +1168,11 @@ mwifiex_set_wmm_params(struct mwifiex_private *priv,
 		       struct mwifiex_uap_bss_param *bss_cfg,
 		       struct cfg80211_ap_settings *params);
 void mwifiex_set_ba_params(struct mwifiex_private *priv);
+
+void mwifiex_update_ampdu_txwinsize(struct mwifiex_adapter *pmadapter);
+void mwifiex_bt_coex_wlan_param_update_event(struct mwifiex_private *priv,
+					     struct sk_buff *event_skb);
+
 void mwifiex_set_11ac_ba_params(struct mwifiex_private *priv);
 int mwifiex_cmd_802_11_scan_ext(struct mwifiex_private *priv,
 				struct host_cmd_ds_command *cmd,
@@ -1509,7 +1520,8 @@ void mwifiex_drv_info_dump(struct mwifiex_adapter *adapter);
 void mwifiex_upload_device_dump(struct mwifiex_adapter *adapter);
 void *mwifiex_alloc_dma_align_buf(int rx_len, gfp_t flags);
 void mwifiex_queue_main_work(struct mwifiex_adapter *adapter);
-
+void mwifiex_coex_ampdu_rxwinsize(struct mwifiex_adapter *adapter);
+void mwifiex_11n_delba(struct mwifiex_private *priv, int tid);
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
 void mwifiex_debugfs_remove(void);
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 9520378..ac229ef 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -183,6 +183,63 @@ static int mwifiex_parse_tdls_event(struct mwifiex_private *priv,
 }
 
 /*
+* This function handles coex events generated by firmware
+*/
+void mwifiex_bt_coex_wlan_param_update_event(struct mwifiex_private *priv,
+					     struct sk_buff *event_skb)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_ie_types_header *tlv;
+	struct mwifiex_ie_types_btcoex_aggr_win_size *winsizetlv;
+	struct mwifiex_ie_types_btcoex_scan_time *scantlv;
+	s32 len = event_skb->len - sizeof(u32);
+	u8 *cur_ptr = event_skb->data + sizeof(u32);
+	u16 tlv_type, tlv_len;
+
+	while (len >= sizeof(struct mwifiex_ie_types_header)) {
+		tlv = (struct mwifiex_ie_types_header *)cur_ptr;
+		tlv_len = le16_to_cpu(tlv->len);
+		tlv_type = le16_to_cpu(tlv->type);
+
+		if ((tlv_len + sizeof(struct mwifiex_ie_types_header)) > len)
+			break;
+		switch (tlv_type) {
+		case TLV_BTCOEX_WL_AGGR_WINSIZE:
+			winsizetlv =
+			    (struct mwifiex_ie_types_btcoex_aggr_win_size *)tlv;
+			adapter->coex_win_size = winsizetlv->coex_win_size;
+			adapter->coex_tx_win_size =
+				winsizetlv->tx_win_size;
+			adapter->coex_rx_win_size =
+				winsizetlv->rx_win_size;
+			mwifiex_coex_ampdu_rxwinsize(adapter);
+			mwifiex_update_ampdu_txwinsize(adapter);
+			break;
+
+		case TLV_BTCOEX_WL_SCANTIME:
+			scantlv =
+			    (struct mwifiex_ie_types_btcoex_scan_time *)tlv;
+			adapter->coex_scan = scantlv->coex_scan;
+			adapter->coex_min_scan_time = scantlv->min_scan_time;
+			adapter->coex_max_scan_time = scantlv->max_scan_time;
+			break;
+
+		default:
+			break;
+		}
+
+		len -= tlv_len + sizeof(struct mwifiex_ie_types_header);
+		cur_ptr += tlv_len +
+			sizeof(struct mwifiex_ie_types_header);
+	}
+
+	dev_dbg(adapter->dev, "coex_scan=%d min_scan=%d coex_win=%d, tx_win=%d rx_win=%d\n",
+		adapter->coex_scan, adapter->coex_min_scan_time,
+		adapter->coex_win_size, adapter->coex_tx_win_size,
+		adapter->coex_rx_win_size);
+}
+
+/*
  * This function handles events generated by firmware.
  *
  * This is a generic function and handles all events.
@@ -531,6 +588,10 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		ret = mwifiex_11h_handle_radar_detected(priv,
 							adapter->event_skb);
 		break;
+	case EVENT_BT_COEX_WLAN_PARA_CHANGE:
+		dev_dbg(adapter->dev, "EVENT: BT coex wlan param update\n");
+		mwifiex_bt_coex_wlan_param_update_event(priv,
+							adapter->event_skb);
 	default:
 		mwifiex_dbg(adapter, ERROR, "event: unknown event id: %#x\n",
 			    eventcause);
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index fee05f5..7bc1f85 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -292,6 +292,11 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		mwifiex_dbg(adapter, EVENT, "event: Radar detected\n");
 		mwifiex_11h_handle_radar_detected(priv, adapter->event_skb);
 		break;
+	case EVENT_BT_COEX_WLAN_PARA_CHANGE:
+		dev_err(adapter->dev, "EVENT: BT coex wlan param update\n");
+		mwifiex_bt_coex_wlan_param_update_event(priv,
+							adapter->event_skb);
+		break;
 	default:
 		mwifiex_dbg(adapter, EVENT,
 			    "event: unknown event id: %#x\n", eventcause);
-- 
1.8.1.4

