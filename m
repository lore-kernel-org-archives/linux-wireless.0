Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48915 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932242AbcGKPFC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 11:05:02 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u6BF1gcK000965
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2016 08:05:01 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0a-0016f401.pphosted.com with ESMTP id 242xmkxd9e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2016 08:05:00 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 8/9] mwifiex: add HT aggregation support for adhoc mode
Date: Mon, 11 Jul 2016 20:23:51 +0530
Message-ID: <1468248832-21969-9-git-send-email-akarwar@marvell.com> (sfid-20160711_170507_740387_7D413E0B)
In-Reply-To: <1468248832-21969-1-git-send-email-akarwar@marvell.com>
References: <1468248832-21969-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch adds HT support for adhoc station. Firmware will upload
ibss sta connect event with beacon data, whenever new station joins
the adhoc network. Driver will check the HT IE and decide whether to
support HT aggreagation or not.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/11n.h       |   7 +-
 drivers/net/wireless/marvell/mwifiex/fw.h        |   9 ++
 drivers/net/wireless/marvell/mwifiex/sta_event.c | 132 ++++++++++++++++++++++-
 3 files changed, 144 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n.h b/drivers/net/wireless/marvell/mwifiex/11n.h
index afdd58a..ea0fa68 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n.h
+++ b/drivers/net/wireless/marvell/mwifiex/11n.h
@@ -171,9 +171,10 @@ mwifiex_find_stream_to_delete(struct mwifiex_private *priv, int ptr_tid,
 static inline int mwifiex_is_sta_11n_enabled(struct mwifiex_private *priv,
 					     struct mwifiex_sta_node *node)
 {
-
-	if (!node || (priv->bss_role != MWIFIEX_BSS_ROLE_UAP) ||
-	    !priv->ap_11n_enabled)
+	if (!node || ((priv->bss_role == MWIFIEX_BSS_ROLE_UAP) &&
+		      !priv->ap_11n_enabled) ||
+	    ((priv->bss_mode == NL80211_IFTYPE_ADHOC) &&
+	     !priv->adapter->adhoc_11n_enabled))
 		return 0;
 
 	return node->is_11n_enabled;
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 3b40e0d..a88030a 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -210,6 +210,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 
 #define MWIFIEX_TX_DATA_BUF_SIZE_4K        4096
 #define MWIFIEX_TX_DATA_BUF_SIZE_8K        8192
+#define MWIFIEX_TX_DATA_BUF_SIZE_12K       12288
 
 #define ISSUPP_11NENABLED(FwCapInfo) (FwCapInfo & BIT(11))
 #define ISSUPP_TDLS_ENABLED(FwCapInfo) (FwCapInfo & BIT(14))
@@ -506,6 +507,8 @@ enum P2P_MODES {
 #define EVENT_RSSI_HIGH                 0x0000001c
 #define EVENT_SNR_HIGH                  0x0000001d
 #define EVENT_IBSS_COALESCED            0x0000001e
+#define EVENT_IBSS_STA_CONNECT          0x00000020
+#define EVENT_IBSS_STA_DISCONNECT       0x00000021
 #define EVENT_DATA_RSSI_LOW             0x00000024
 #define EVENT_DATA_SNR_LOW              0x00000025
 #define EVENT_DATA_RSSI_HIGH            0x00000026
@@ -1686,6 +1689,12 @@ struct mwifiex_ie_types_wmm_param_set {
 	u8 wmm_ie[1];
 };
 
+struct mwifiex_ie_types_mgmt_frame {
+	struct mwifiex_ie_types_header header;
+	__le16 frame_control;
+	u8 frame_contents[0];
+};
+
 struct mwifiex_ie_types_wmm_queue_status {
 	struct mwifiex_ie_types_header header;
 	u8 queue_index;
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index b973ee8..9df0c4d 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -25,6 +25,99 @@
 #include "wmm.h"
 #include "11n.h"
 
+#define MWIFIEX_IBSS_CONNECT_EVT_FIX_SIZE    12
+
+static int mwifiex_check_ibss_peer_capabilties(struct mwifiex_private *priv,
+					       struct mwifiex_sta_node *sta_ptr,
+					       struct sk_buff *event)
+{
+	int evt_len, ele_len;
+	u8 *curr;
+	struct ieee_types_header *ele_hdr;
+	struct mwifiex_ie_types_mgmt_frame *tlv_mgmt_frame;
+	const struct ieee80211_ht_cap *ht_cap;
+	const struct ieee80211_vht_cap *vht_cap;
+
+	skb_pull(event, MWIFIEX_IBSS_CONNECT_EVT_FIX_SIZE);
+	evt_len = event->len;
+	curr = event->data;
+
+	mwifiex_dbg_dump(priv->adapter, EVT_D, "ibss peer capabilties:",
+			 event->data, event->len);
+
+	skb_push(event, MWIFIEX_IBSS_CONNECT_EVT_FIX_SIZE);
+
+	tlv_mgmt_frame = (void *)curr;
+	if (evt_len >= sizeof(*tlv_mgmt_frame) &&
+	    le16_to_cpu(tlv_mgmt_frame->header.type) ==
+	    TLV_TYPE_UAP_MGMT_FRAME) {
+		/* Locate curr pointer to the start of beacon tlv,
+		 * timestamp 8 bytes, beacon intervel 2 bytes,
+		 * capability info 2 bytes, totally 12 byte beacon header
+		 */
+		evt_len = le16_to_cpu(tlv_mgmt_frame->header.len);
+		curr += (sizeof(*tlv_mgmt_frame) + 12);
+	} else {
+		mwifiex_dbg(priv->adapter, MSG,
+			    "management frame tlv not found!\n");
+		return 0;
+	}
+
+	while (evt_len >= sizeof(*ele_hdr)) {
+		ele_hdr = (struct ieee_types_header *)curr;
+		ele_len = ele_hdr->len;
+
+		if (evt_len < ele_len + sizeof(*ele_hdr))
+			break;
+
+		switch (ele_hdr->element_id) {
+		case WLAN_EID_HT_CAPABILITY:
+			sta_ptr->is_11n_enabled = true;
+			ht_cap = (void *)(ele_hdr + 2);
+			sta_ptr->max_amsdu = le16_to_cpu(ht_cap->cap_info) &
+				IEEE80211_HT_CAP_MAX_AMSDU ?
+				MWIFIEX_TX_DATA_BUF_SIZE_8K :
+				MWIFIEX_TX_DATA_BUF_SIZE_4K;
+			mwifiex_dbg(priv->adapter, INFO,
+				    "11n enabled!, max_amsdu : %d\n",
+				    sta_ptr->max_amsdu);
+			break;
+
+		case WLAN_EID_VHT_CAPABILITY:
+			sta_ptr->is_11ac_enabled = true;
+			vht_cap = (void *)(ele_hdr + 2);
+			/* check VHT MAXMPDU capability */
+			switch (le32_to_cpu(vht_cap->vht_cap_info) & 0x3) {
+			case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454:
+				sta_ptr->max_amsdu =
+					MWIFIEX_TX_DATA_BUF_SIZE_12K;
+				break;
+			case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991:
+				sta_ptr->max_amsdu =
+					MWIFIEX_TX_DATA_BUF_SIZE_8K;
+				break;
+			case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895:
+				sta_ptr->max_amsdu =
+					MWIFIEX_TX_DATA_BUF_SIZE_4K;
+			default:
+				break;
+			}
+
+			mwifiex_dbg(priv->adapter, INFO,
+				    "11ac enabled!, max_amsdu : %d\n",
+				    sta_ptr->max_amsdu);
+			break;
+		default:
+			break;
+		}
+
+		curr += (ele_len + sizeof(*ele_hdr));
+		evt_len -= (ele_len + sizeof(*ele_hdr));
+	}
+
+	return 0;
+}
+
 /*
  * This function resets the connection state.
  *
@@ -519,6 +612,8 @@ void mwifiex_bt_coex_wlan_param_update_event(struct mwifiex_private *priv,
  *      - EVENT_LINK_QUALITY
  *      - EVENT_PRE_BEACON_LOST
  *      - EVENT_IBSS_COALESCED
+ *      - EVENT_IBSS_STA_CONNECT
+ *      - EVENT_IBSS_STA_DISCONNECT
  *      - EVENT_WEP_ICV_ERR
  *      - EVENT_BW_CHANGE
  *      - EVENT_HOSTWAKE_STAIE
@@ -547,9 +642,11 @@ void mwifiex_bt_coex_wlan_param_update_event(struct mwifiex_private *priv,
 int mwifiex_process_sta_event(struct mwifiex_private *priv)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	int ret = 0;
+	int ret = 0, i;
 	u32 eventcause = adapter->event_cause;
 	u16 ctrl, reason_code;
+	u8 ibss_sta_addr[ETH_ALEN];
+	struct mwifiex_sta_node *sta_ptr;
 
 	switch (eventcause) {
 	case EVENT_DUMMY_HOST_WAKEUP_SIGNAL:
@@ -775,6 +872,39 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 				HostCmd_CMD_802_11_IBSS_COALESCING_STATUS,
 				HostCmd_ACT_GEN_GET, 0, NULL, false);
 		break;
+	case EVENT_IBSS_STA_CONNECT:
+		ether_addr_copy(ibss_sta_addr, adapter->event_body + 2);
+		mwifiex_dbg(adapter, EVENT, "event: IBSS_STA_CONNECT %pM\n",
+			    ibss_sta_addr);
+		sta_ptr = mwifiex_add_sta_entry(priv, ibss_sta_addr);
+		if (sta_ptr && adapter->adhoc_11n_enabled) {
+			mwifiex_check_ibss_peer_capabilties(priv, sta_ptr,
+							    adapter->event_skb);
+			if (sta_ptr->is_11n_enabled)
+				for (i = 0; i < MAX_NUM_TID; i++)
+					sta_ptr->ampdu_sta[i] =
+					priv->aggr_prio_tbl[i].ampdu_user;
+			else
+				for (i = 0; i < MAX_NUM_TID; i++)
+					sta_ptr->ampdu_sta[i] =
+						BA_STREAM_NOT_ALLOWED;
+			memset(sta_ptr->rx_seq, 0xff, sizeof(sta_ptr->rx_seq));
+		}
+
+		break;
+	case EVENT_IBSS_STA_DISCONNECT:
+		ether_addr_copy(ibss_sta_addr, adapter->event_body + 2);
+		mwifiex_dbg(adapter, EVENT, "event: IBSS_STA_DISCONNECT %pM\n",
+			    ibss_sta_addr);
+		sta_ptr = mwifiex_get_sta_entry(priv, ibss_sta_addr);
+		if (sta_ptr && sta_ptr->is_11n_enabled) {
+			mwifiex_11n_del_rx_reorder_tbl_by_ta(priv,
+							     ibss_sta_addr);
+			mwifiex_del_tx_ba_stream_tbl_by_ra(priv, ibss_sta_addr);
+		}
+		mwifiex_wmm_del_peer_ra_list(priv, ibss_sta_addr);
+		mwifiex_del_sta_entry(priv, ibss_sta_addr);
+		break;
 	case EVENT_ADDBA:
 		mwifiex_dbg(adapter, EVENT, "event: ADDBA Request\n");
 		mwifiex_send_cmd(priv, HostCmd_CMD_11N_ADDBA_RSP,
-- 
1.9.1

