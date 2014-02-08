Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22030 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198AbaBHA1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:27:47 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 18/30] mwifiex: parse TDLS action frames during RX
Date: Fri, 7 Feb 2014 16:27:33 -0800
Message-ID: <1391819254-21130-8-git-send-email-bzhao@marvell.com> (sfid-20140208_012751_303476_EDEF0F84)
In-Reply-To: <1391819254-21130-1-git-send-email-bzhao@marvell.com>
References: <1391819254-21130-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds support for parsing TDLS action frames during
station receive handler.
Peer station capabilities are stored into station node.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/decl.h   |   8 +++
 drivers/net/wireless/mwifiex/main.h   |  19 +++++-
 drivers/net/wireless/mwifiex/sta_rx.c |  13 +++-
 drivers/net/wireless/mwifiex/tdls.c   | 119 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/wmm.c    |   5 +-
 drivers/net/wireless/mwifiex/wmm.h    |   3 +
 6 files changed, 160 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index c709f1c..efcd1b8 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -93,6 +93,14 @@ enum mwifiex_bss_role {
 	MWIFIEX_BSS_ROLE_ANY = 0xff,
 };
 
+enum mwifiex_tdls_status {
+	TDLS_NOT_SETUP = 0,
+	TDLS_SETUP_INPROGRESS,
+	TDLS_SETUP_COMPLETE,
+	TDLS_SETUP_FAILURE,
+	TDLS_LINK_TEARDOWN,
+};
+
 #define BSS_ROLE_BIT_MASK    BIT(0)
 
 #define GET_BSS_ROLE(priv)   ((priv)->bss_role & BSS_ROLE_BIT_MASK)
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index c5368f2..fd0f3b5 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -594,8 +594,20 @@ struct mwifiex_bss_priv {
 	u64 fw_tsf;
 };
 
-/* This is AP specific structure which stores information
- * about associated STA
+struct mwifiex_tdls_capab {
+	__le16 capab;
+	u8 rates[32];
+	u8 rates_len;
+	u8 qos_info;
+	u8 coex_2040;
+	struct ieee80211_ht_cap ht_capb;
+	struct ieee80211_ht_operation ht_oper;
+	struct ieee_types_extcap extcap;
+	struct ieee_types_generic rsn_ie;
+};
+
+/* This is AP/TDLS specific structure which stores information
+ * about associated/peer STA
  */
 struct mwifiex_sta_node {
 	struct list_head list;
@@ -605,6 +617,7 @@ struct mwifiex_sta_node {
 	u8 ampdu_sta[MAX_NUM_TID];
 	u16 rx_seq[MAX_NUM_TID];
 	u16 max_amsdu;
+	struct mwifiex_tdls_capab tdls_cap;
 };
 
 struct mwifiex_if_ops {
@@ -1194,6 +1207,8 @@ int mwifiex_send_tdls_action_frame(struct mwifiex_private *priv,
 				 u8 *peer, u8 action_code, u8 dialog_token,
 				 u16 status_code, const u8 *extra_ies,
 				 size_t extra_ies_len);
+void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
+				       u8 *buf, int len);
 
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index 4651d67..b6aa958 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -88,11 +88,14 @@ int mwifiex_process_rx_packet(struct mwifiex_private *priv,
 	struct rxpd *local_rx_pd;
 	int hdr_chop;
 	struct ethhdr *eth;
+	u16 rx_pkt_off, rx_pkt_len;
+	u8 *offset;
 
 	local_rx_pd = (struct rxpd *) (skb->data);
 
-	rx_pkt_hdr = (void *)local_rx_pd +
-		     le16_to_cpu(local_rx_pd->rx_pkt_offset);
+	rx_pkt_off = le16_to_cpu(local_rx_pd->rx_pkt_offset);
+	rx_pkt_len = le16_to_cpu(local_rx_pd->rx_pkt_length);
+	rx_pkt_hdr = (void *)local_rx_pd + rx_pkt_off;
 
 	if ((!memcmp(&rx_pkt_hdr->rfc1042_hdr, bridge_tunnel_header,
 		     sizeof(bridge_tunnel_header))) ||
@@ -142,6 +145,12 @@ int mwifiex_process_rx_packet(struct mwifiex_private *priv,
 		return 0;
 	}
 
+	if (ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info) &&
+	    ntohs(rx_pkt_hdr->eth803_hdr.h_proto) == ETH_P_TDLS) {
+		offset = (u8 *)local_rx_pd + rx_pkt_off;
+		mwifiex_process_tdls_action_frame(priv, offset, rx_pkt_len);
+	}
+
 	priv->rxpd_rate = local_rx_pd->rx_rate;
 
 	priv->rxpd_htinfo = local_rx_pd->ht_info;
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index 73cd444..ba54037 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -16,6 +16,11 @@
  */
 
 #include "main.h"
+#include "wmm.h"
+
+#define TDLS_REQ_FIX_LEN      6
+#define TDLS_RESP_FIX_LEN     8
+#define TDLS_CONFIRM_FIX_LEN  6
 
 /* This function appends rate TLV to scan config command. */
 static int
@@ -421,3 +426,117 @@ int mwifiex_send_tdls_action_frame(struct mwifiex_private *priv,
 
 	return 0;
 }
+
+/* This function process tdls action frame from peer.
+ * Peer capabilities are stored into station node structure.
+ */
+void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
+				       u8 *buf, int len)
+{
+	struct mwifiex_sta_node *sta_ptr;
+	u8 *peer, *pos, *end;
+	u8 i, action, basic;
+	int ie_len = 0;
+
+	if (len < (sizeof(struct ethhdr) + 3))
+		return;
+	if (*(u8 *)(buf + sizeof(struct ethhdr)) != WLAN_TDLS_SNAP_RFTYPE)
+		return;
+	if (*(u8 *)(buf + sizeof(struct ethhdr) + 1) != WLAN_CATEGORY_TDLS)
+		return;
+
+	peer = buf + ETH_ALEN;
+	action = *(u8 *)(buf + sizeof(struct ethhdr) + 2);
+
+	/* just handle TDLS setup request/response/confirm */
+	if (action > WLAN_TDLS_SETUP_CONFIRM)
+		return;
+
+	dev_dbg(priv->adapter->dev,
+		"rx:tdls action: peer=%pM, action=%d\n", peer, action);
+
+	sta_ptr = mwifiex_add_sta_entry(priv, peer);
+	if (!sta_ptr)
+		return;
+
+	switch (action) {
+	case WLAN_TDLS_SETUP_REQUEST:
+		if (len < (sizeof(struct ethhdr) + TDLS_REQ_FIX_LEN))
+			return;
+
+		pos = buf + sizeof(struct ethhdr) + 4;
+		/* payload 1+ category 1 + action 1 + dialog 1 */
+		sta_ptr->tdls_cap.capab = cpu_to_le16(*(u16 *)pos);
+		ie_len = len - sizeof(struct ethhdr) - TDLS_REQ_FIX_LEN;
+		pos += 2;
+		break;
+
+	case WLAN_TDLS_SETUP_RESPONSE:
+		if (len < (sizeof(struct ethhdr) + TDLS_RESP_FIX_LEN))
+			return;
+		/* payload 1+ category 1 + action 1 + dialog 1 + status code 2*/
+		pos = buf + sizeof(struct ethhdr) + 6;
+		sta_ptr->tdls_cap.capab = cpu_to_le16(*(u16 *)pos);
+		ie_len = len - sizeof(struct ethhdr) - TDLS_RESP_FIX_LEN;
+		pos += 2;
+		break;
+
+	case WLAN_TDLS_SETUP_CONFIRM:
+		if (len < (sizeof(struct ethhdr) + TDLS_CONFIRM_FIX_LEN))
+			return;
+		pos = buf + sizeof(struct ethhdr) + TDLS_CONFIRM_FIX_LEN;
+		ie_len = len - sizeof(struct ethhdr) - TDLS_CONFIRM_FIX_LEN;
+		break;
+	default:
+		dev_warn(priv->adapter->dev, "Unknown TDLS frame type.\n");
+		return;
+	}
+
+	for (end = pos + ie_len; pos + 1 < end; pos += 2 + pos[1]) {
+		if (pos + 2 + pos[1] > end)
+			break;
+
+		switch (*pos) {
+		case WLAN_EID_SUPP_RATES:
+			sta_ptr->tdls_cap.rates_len = pos[1];
+			for (i = 0; i < pos[1]; i++)
+				sta_ptr->tdls_cap.rates[i] = pos[i + 2];
+			break;
+
+		case WLAN_EID_EXT_SUPP_RATES:
+			basic = sta_ptr->tdls_cap.rates_len;
+			for (i = 0; i < pos[1]; i++)
+				sta_ptr->tdls_cap.rates[basic + i] = pos[i + 2];
+			sta_ptr->tdls_cap.rates_len += pos[1];
+			break;
+		case WLAN_EID_HT_CAPABILITY:
+			memcpy((u8 *)&sta_ptr->tdls_cap.ht_capb, pos,
+			       sizeof(struct ieee80211_ht_cap));
+			sta_ptr->is_11n_enabled = 1;
+			break;
+		case WLAN_EID_HT_OPERATION:
+			memcpy(&sta_ptr->tdls_cap.ht_oper, pos,
+			       sizeof(struct ieee80211_ht_operation));
+			break;
+		case WLAN_EID_BSS_COEX_2040:
+			sta_ptr->tdls_cap.coex_2040 = pos[2];
+			break;
+		case WLAN_EID_EXT_CAPABILITY:
+			memcpy((u8 *)&sta_ptr->tdls_cap.extcap, pos,
+			       sizeof(struct ieee_types_header) +
+			       min_t(u8, pos[1], 8));
+			break;
+		case WLAN_EID_RSN:
+			memcpy((u8 *)&sta_ptr->tdls_cap.rsn_ie, pos,
+			       sizeof(struct ieee_types_header) + pos[1]);
+			break;
+		case WLAN_EID_QOS_CAPA:
+			sta_ptr->tdls_cap.qos_info = pos[2];
+			break;
+		default:
+			break;
+		}
+	}
+
+	return;
+}
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 2999c3b..557d363 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -374,8 +374,7 @@ mwifiex_wmm_convert_tos_to_ac(struct mwifiex_adapter *adapter, u32 tos)
  * AP is disabled (due to call admission control (ACM bit). Mapping
  * of TID to AC is taken care of internally.
  */
-static u8
-mwifiex_wmm_downgrade_tid(struct mwifiex_private *priv, u32 tid)
+u8 mwifiex_wmm_downgrade_tid(struct mwifiex_private *priv, u32 tid)
 {
 	enum mwifiex_wmm_ac_e ac, ac_down;
 	u8 new_tid;
@@ -578,7 +577,7 @@ mwifiex_wmm_get_ralist_node(struct mwifiex_private *priv, u8 tid,
  * If no such node is found, a new node is added first and then
  * retrieved.
  */
-static struct mwifiex_ra_list_tbl *
+struct mwifiex_ra_list_tbl *
 mwifiex_wmm_get_queue_raptr(struct mwifiex_private *priv, u8 tid, u8 *ra_addr)
 {
 	struct mwifiex_ra_list_tbl *ra_list;
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index d4e6073..83e4208 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -122,5 +122,8 @@ void mwifiex_wmm_setup_queue_priorities(struct mwifiex_private *priv,
 void mwifiex_wmm_setup_ac_downgrade(struct mwifiex_private *priv);
 int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 			       const struct host_cmd_ds_command *resp);
+struct mwifiex_ra_list_tbl *
+mwifiex_wmm_get_queue_raptr(struct mwifiex_private *priv, u8 tid, u8 *ra_addr);
+u8 mwifiex_wmm_downgrade_tid(struct mwifiex_private *priv, u32 tid);
 
 #endif /* !_MWIFIEX_WMM_H_ */
-- 
1.8.2.3

