Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:35585 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab1CHASj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 19:18:39 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/3] mwifiex: remove MWIFIEX_MAC_ADDR_LENGTH
Date: Mon,  7 Mar 2011 16:21:37 -0800
Message-Id: <1299543697-15152-3-git-send-email-bzhao@marvell.com>
In-Reply-To: <1299543697-15152-1-git-send-email-bzhao@marvell.com>
References: <1299543697-15152-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use ETH_ALEN instead

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           |   14 ++++------
 drivers/net/wireless/mwifiex/11n.h           |    2 +-
 drivers/net/wireless/mwifiex/11n_aggr.c      |   16 +++--------
 drivers/net/wireless/mwifiex/11n_rxreorder.c |    9 +++---
 drivers/net/wireless/mwifiex/cfg80211.c      |    2 +-
 drivers/net/wireless/mwifiex/cmdevt.c        |    6 +---
 drivers/net/wireless/mwifiex/decl.h          |    2 -
 drivers/net/wireless/mwifiex/fw.h            |   35 ++++++++++++-------------
 drivers/net/wireless/mwifiex/ieee.h          |    2 +-
 drivers/net/wireless/mwifiex/init.c          |    2 +-
 drivers/net/wireless/mwifiex/ioctl.h         |   18 ++++++------
 drivers/net/wireless/mwifiex/join.c          |   17 ++++++------
 drivers/net/wireless/mwifiex/main.h          |   10 +++---
 drivers/net/wireless/mwifiex/scan.c          |   19 ++++++--------
 drivers/net/wireless/mwifiex/sta_cmd.c       |   11 +++----
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |   14 ++++------
 drivers/net/wireless/mwifiex/sta_event.c     |    3 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c     |   20 ++++++---------
 drivers/net/wireless/mwifiex/sta_rx.c        |   13 +++------
 drivers/net/wireless/mwifiex/wmm.c           |   10 +++---
 20 files changed, 98 insertions(+), 127 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index bbfce33..0d8e1c1 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -930,7 +930,7 @@ mwifiex_11n_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
 
 	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
-		if ((!memcmp(tx_ba_tsr_tbl->ra, ra, MWIFIEX_MAC_ADDR_LENGTH))
+		if ((!memcmp(tx_ba_tsr_tbl->ra, ra, ETH_ALEN))
 		    && (tx_ba_tsr_tbl->tid == tid)) {
 			spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock,
 					       flags);
@@ -965,7 +965,7 @@ void mwifiex_11n_create_tx_ba_stream_tbl(struct mwifiex_private *priv,
 
 		new_node->tid = tid;
 		new_node->ba_status = ba_status;
-		memcpy(new_node->ra, ra, MWIFIEX_MAC_ADDR_LENGTH);
+		memcpy(new_node->ra, ra, ETH_ALEN);
 
 		spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 		list_add_tail(&new_node->list, &priv->tx_ba_stream_tbl_ptr);
@@ -999,7 +999,7 @@ int mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
 		dialog_tok = 1;
 
 	add_ba_req.dialog_token = dialog_tok;
-	memcpy(&add_ba_req.peer_mac_addr, peer_mac, MWIFIEX_MAC_ADDR_LENGTH);
+	memcpy(&add_ba_req.peer_mac_addr, peer_mac, ETH_ALEN);
 
 	/* We don't wait for the response of this command */
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_11N_ADDBA_REQ,
@@ -1027,7 +1027,7 @@ int mwifiex_send_delba(struct mwifiex_private *priv, int tid, u8 *peer_mac,
 	else
 		del_ba_param_set &= ~IEEE80211_DELBA_PARAM_INITIATOR_MASK;
 
-	memcpy(&delba.peer_mac_addr, peer_mac, MWIFIEX_MAC_ADDR_LENGTH);
+	memcpy(&delba.peer_mac_addr, peer_mac, ETH_ALEN);
 
 	/* We don't wait for the response of this command */
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_11N_DELBA,
@@ -1092,8 +1092,7 @@ int mwifiex_get_rx_reorder_tbl(struct mwifiex_private *priv,
 	list_for_each_entry(rx_reorder_tbl_ptr, &priv->rx_reorder_tbl_ptr,
 			    list) {
 		rx_reo_tbl->tid = (u16) rx_reorder_tbl_ptr->tid;
-		memcpy(rx_reo_tbl->ta, rx_reorder_tbl_ptr->ta,
-				MWIFIEX_MAC_ADDR_LENGTH);
+		memcpy(rx_reo_tbl->ta, rx_reorder_tbl_ptr->ta, ETH_ALEN);
 		rx_reo_tbl->start_win = rx_reorder_tbl_ptr->start_win;
 		rx_reo_tbl->win_size = rx_reorder_tbl_ptr->win_size;
 		for (i = 0; i < rx_reorder_tbl_ptr->win_size; ++i) {
@@ -1129,8 +1128,7 @@ int mwifiex_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
 		rx_reo_tbl->tid = (u16) tx_ba_tsr_tbl->tid;
 		dev_dbg(priv->adapter->dev, "data: %s tid=%d\n",
 						__func__, rx_reo_tbl->tid);
-		memcpy(rx_reo_tbl->ra, tx_ba_tsr_tbl->ra,
-				MWIFIEX_MAC_ADDR_LENGTH);
+		memcpy(rx_reo_tbl->ra, tx_ba_tsr_tbl->ra, ETH_ALEN);
 		rx_reo_tbl++;
 		count++;
 		if (count >= MWIFIEX_MAX_TX_BASTREAM_SUPPORTED)
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 68a5549..6918881 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -175,7 +175,7 @@ mwifiex_find_stream_to_delete(struct mwifiex_private *priv,
 		if (tid > priv->aggr_prio_tbl[tx_tbl->tid].ampdu_user) {
 			tid = priv->aggr_prio_tbl[tx_tbl->tid].ampdu_user;
 			*ptid = tx_tbl->tid;
-			memcpy(ra, tx_tbl->ra, MWIFIEX_MAC_ADDR_LENGTH);
+			memcpy(ra, tx_tbl->ra, ETH_ALEN);
 			ret = true;
 		}
 	}
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 7e7e8c1..09343cc 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -152,8 +152,7 @@ mwifiex_11n_get_num_aggr_pkts(u8 *data, int total_pkt_len)
 
 	while (total_pkt_len > 0) {
 		/* Length will be in network format, change it to host */
-		pkt_len = ntohs((*(__be16 *)(data +
-				(2 * MWIFIEX_MAC_ADDR_LENGTH))));
+		pkt_len = ntohs((*(__be16 *)(data + 2 * ETH_ALEN)));
 		pad = (((pkt_len + sizeof(struct ethhdr)) & 3)) ?
 			(4 - ((pkt_len + sizeof(struct ethhdr)) & 3)) : 0;
 		data += pkt_len + pad + sizeof(struct ethhdr);
@@ -189,9 +188,7 @@ int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 	int ret = -1;
 	struct rx_packet_hdr *rx_pkt_hdr;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	u8 rfc1042_eth_hdr[MWIFIEX_MAC_ADDR_LENGTH] = { 0xaa, 0xaa, 0x03,
-							0x00, 0x00, 0x00
-							};
+	u8 rfc1042_eth_hdr[ETH_ALEN] = { 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00};
 
 	data = (u8 *) (local_rx_pd + local_rx_pd->rx_pkt_offset);
 	total_pkt_len = local_rx_pd->rx_pkt_length;
@@ -208,8 +205,7 @@ int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 	while (total_pkt_len > 0) {
 		rx_pkt_hdr = (struct rx_packet_hdr *) data;
 		/* Length will be in network format, change it to host */
-		pkt_len = ntohs((*(__be16 *)
-				 (data + (2 * MWIFIEX_MAC_ADDR_LENGTH))));
+		pkt_len = ntohs((*(__be16 *) (data + 2 * ETH_ALEN)));
 		if (pkt_len > total_pkt_len) {
 			dev_err(adapter->dev, "pkt_len %d > total_pkt_len %d\n",
 			       total_pkt_len, pkt_len);
@@ -223,13 +219,11 @@ int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 
 		if (memcmp(&rx_pkt_hdr->rfc1042_hdr,
 			   rfc1042_eth_hdr, sizeof(rfc1042_eth_hdr)) == 0) {
-			memmove(data + LLC_SNAP_LEN, data,
-				(2 * MWIFIEX_MAC_ADDR_LENGTH));
+			memmove(data + LLC_SNAP_LEN, data, 2 * ETH_ALEN);
 			data += LLC_SNAP_LEN;
 			pkt_len += sizeof(struct ethhdr) - LLC_SNAP_LEN;
 		} else {
-			*(u16 *) (data + (2 * MWIFIEX_MAC_ADDR_LENGTH))
-				= (u16) 0;
+			*(u16 *) (data + 2 * ETH_ALEN) = (u16) 0;
 			pkt_len += sizeof(struct ethhdr);
 		}
 
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 63f5205..7d5e7ef 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -180,7 +180,7 @@ mwifiex_11n_get_rx_reorder_tbl(struct mwifiex_private *priv, int tid, u8 *ta)
 
 	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 	list_for_each_entry(rx_reor_tbl_ptr, &priv->rx_reorder_tbl_ptr, list) {
-		if ((!memcmp(rx_reor_tbl_ptr->ta, ta, MWIFIEX_MAC_ADDR_LENGTH))
+		if ((!memcmp(rx_reor_tbl_ptr->ta, ta, ETH_ALEN))
 		    && (rx_reor_tbl_ptr->tid == tid)) {
 			spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock,
 					       flags);
@@ -272,7 +272,7 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 
 		INIT_LIST_HEAD(&new_node->list);
 		new_node->tid = tid;
-		memcpy(new_node->ta, ta, MWIFIEX_MAC_ADDR_LENGTH);
+		memcpy(new_node->ta, ta, ETH_ALEN);
 		new_node->start_win = seq_num;
 		if (mwifiex_queuing_ra_based(priv))
 			/* TODO for adhoc */
@@ -366,7 +366,7 @@ int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
 				S_DS_GEN);
 
 	memcpy(add_ba_rsp->peer_mac_addr, cmd_addba_req->peer_mac_addr,
-	       MWIFIEX_MAC_ADDR_LENGTH);
+	       ETH_ALEN);
 	add_ba_rsp->dialog_token = cmd_addba_req->dialog_token;
 	add_ba_rsp->block_ack_tmo = cmd_addba_req->block_ack_tmo;
 	add_ba_rsp->ssn = cmd_addba_req->ssn;
@@ -621,8 +621,7 @@ void mwifiex_11n_ba_stream_timeout(struct mwifiex_private *priv,
 	struct host_cmd_ds_11n_delba delba;
 
 	memset(&delba, 0, sizeof(struct host_cmd_ds_11n_delba));
-	memcpy(delba.peer_mac_addr, event->peer_mac_addr,
-	       MWIFIEX_MAC_ADDR_LENGTH);
+	memcpy(delba.peer_mac_addr, event->peer_mac_addr, ETH_ALEN);
 
 	delba.del_ba_param_set |=
 		cpu_to_le16((u16) event->tid << DELBA_TID_POS);
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index e6ba12b..c3e5492 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1154,7 +1154,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	memcpy(&priv->cfg_bssid, ssid_bssid.bssid, 6);
 
 	/* Connect to BSS by ESSID */
-	memset(&ssid_bssid.bssid, 0, MWIFIEX_MAC_ADDR_LENGTH);
+	memset(&ssid_bssid.bssid, 0, ETH_ALEN);
 
 	if (mwifiex_bss_start(priv, MWIFIEX_IOCTL_WAIT, &ssid_bssid))
 		return -EFAULT;
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 90d6617..d88fcb3 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1384,8 +1384,7 @@ int mwifiex_cmd_get_hw_spec(struct mwifiex_private *priv,
 	cmd->command = cpu_to_le16(HostCmd_CMD_GET_HW_SPEC);
 	cmd->size =
 		cpu_to_le16(sizeof(struct host_cmd_ds_get_hw_spec) + S_DS_GEN);
-	memcpy(hw_spec->permanent_addr, priv->curr_addr,
-	       MWIFIEX_MAC_ADDR_LENGTH);
+	memcpy(hw_spec->permanent_addr, priv->curr_addr, ETH_ALEN);
 
 	return 0;
 }
@@ -1462,8 +1461,7 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 	       le16_to_cpu(hw_spec->version));
 
 	if (priv->curr_addr[0] == 0xff)
-		memmove(priv->curr_addr, hw_spec->permanent_addr,
-			MWIFIEX_MAC_ADDR_LENGTH);
+		memmove(priv->curr_addr, hw_spec->permanent_addr, ETH_ALEN);
 
 	adapter->region_code = le16_to_cpu(hw_spec->region_code);
 
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index f421e77..ef2fd10 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -57,8 +57,6 @@
 #define MWIFIEX_RX_DATA_BUF_SIZE     (4 * 1024)
 #define MWIFIEX_RX_CMD_BUF_SIZE      (2 * 1024)
 
-#define MWIFIEX_MAC_ADDR_LENGTH     (6)
-
 #define MWIFIEX_RTS_MIN_VALUE              (0)
 #define MWIFIEX_RTS_MAX_VALUE              (2347)
 #define MWIFIEX_FRAG_MIN_VALUE             (256)
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 861e64a..a068d45 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -467,7 +467,7 @@ enum ENH_PS_MODES {
 
 struct mwifiex_event_wep_icv_err {
 	u16 reason_code;
-	u8 src_mac_addr[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 src_mac_addr[ETH_ALEN];
 	u8 wep_key_index;
 	u8 wep_key_length;
 	u8 key[WLAN_KEY_LEN_WEP104];
@@ -731,7 +731,7 @@ struct host_cmd_ds_get_hw_spec {
 	__le16 version;
 	__le16 reserved;
 	__le16 num_of_mcast_adr;
-	u8 permanent_addr[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 permanent_addr[ETH_ALEN];
 	__le16 region_code;
 	__le16 number_of_antenna;
 	__le32 fw_release_number;
@@ -770,7 +770,7 @@ struct host_cmd_ds_802_11_rssi_info_rsp {
 
 struct host_cmd_ds_802_11_mac_address {
 	__le16 action;
-	u8 mac_addr[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 mac_addr[ETH_ALEN];
 };
 
 struct host_cmd_ds_mac_control {
@@ -781,17 +781,16 @@ struct host_cmd_ds_mac_control {
 struct host_cmd_ds_mac_multicast_adr {
 	__le16 action;
 	__le16 num_of_adrs;
-	u8 mac_list[MWIFIEX_MAX_MULTICAST_LIST_SIZE]
-		[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 mac_list[MWIFIEX_MAX_MULTICAST_LIST_SIZE][ETH_ALEN];
 } __packed;
 
 struct host_cmd_ds_802_11_deauthenticate {
-	u8 mac_addr[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 mac_addr[ETH_ALEN];
 	__le16 reason_code;
 } __packed;
 
 struct host_cmd_ds_802_11_associate {
-	u8 peer_sta_addr[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 peer_sta_addr[ETH_ALEN];
 	__le16 cap_info_bitmap;
 	__le16 listen_interval;
 	__le16 beacon_period;
@@ -816,11 +815,11 @@ struct host_cmd_ds_802_11_ad_hoc_start {
 
 struct host_cmd_ds_802_11_ad_hoc_result {
 	u8 pad[3];
-	u8 bssid[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 bssid[ETH_ALEN];
 } __packed;
 
 struct adhoc_bss_desc {
-	u8 bssid[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 bssid[ETH_ALEN];
 	u8 ssid[IW_ESSID_MAX_SIZE];
 	u8 bss_mode;
 	__le16 beacon_period;
@@ -975,7 +974,7 @@ struct mwifiex_scan_cmd_config {
 	u8 bss_mode;
 
 	/* Specific BSSID used to filter scan results in the firmware */
-	u8 specific_bssid[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 specific_bssid[ETH_ALEN];
 
 	/* Length of TLVs sent in command starting at tlvBuffer */
 	u32 tlv_buf_len;
@@ -1026,7 +1025,7 @@ struct mwifiex_user_scan_cfg {
 	u8 num_probes;
 	u8 reserved;
 	/* BSSID filter sent in the firmware command to limit the results */
-	u8 specific_bssid[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 specific_bssid[ETH_ALEN];
 	/* SSID filter list used in the to limit the scan results */
 	struct mwifiex_user_scan_ssid ssid_list[MWIFIEX_MAX_SSID_LIST_LENGTH];
 	/* Variable number (fixed maximum) of channels to scan up */
@@ -1041,7 +1040,7 @@ struct ie_body {
 
 struct host_cmd_ds_802_11_scan {
 	u8 bss_mode;
-	u8 bssid[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 bssid[ETH_ALEN];
 	u8 tlv_buffer[1];
 } __packed;
 
@@ -1078,7 +1077,7 @@ struct host_cmd_ds_802_11d_domain_info_rsp {
 
 struct host_cmd_ds_11n_addba_req {
 	u8 add_req_result;
-	u8 peer_mac_addr[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 peer_mac_addr[ETH_ALEN];
 	u8 dialog_token;
 	__le16 block_ack_param_set;
 	__le16 block_ack_tmo;
@@ -1087,7 +1086,7 @@ struct host_cmd_ds_11n_addba_req {
 
 struct host_cmd_ds_11n_addba_rsp {
 	u8 add_rsp_result;
-	u8 peer_mac_addr[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 peer_mac_addr[ETH_ALEN];
 	u8 dialog_token;
 	__le16 status_code;
 	__le16 block_ack_param_set;
@@ -1097,7 +1096,7 @@ struct host_cmd_ds_11n_addba_rsp {
 
 struct host_cmd_ds_11n_delba {
 	u8 del_result;
-	u8 peer_mac_addr[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 peer_mac_addr[ETH_ALEN];
 	__le16 del_ba_param_set;
 	__le16 reason_code;
 	u8 reserved;
@@ -1105,7 +1104,7 @@ struct host_cmd_ds_11n_delba {
 
 struct host_cmd_ds_11n_batimeout {
 	u8 tid;
-	u8 peer_mac_addr[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 peer_mac_addr[ETH_ALEN];
 	u8 origninator;
 } __packed;
 
@@ -1220,7 +1219,7 @@ struct mwifiex_ie_types_encrproto {
 
 struct mwifiex_ie_types_bssid {
 	struct mwifiex_ie_types_header header;
-	u8 bssid[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 bssid[ETH_ALEN];
 } __packed;
 
 /*
@@ -1308,7 +1307,7 @@ struct host_cmd_ds_802_11_rf_antenna {
 struct host_cmd_ds_802_11_ibss_status {
 	__le16 action;
 	__le16 enable;
-	u8 bssid[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 bssid[ETH_ALEN];
 	__le16 beacon_interval;
 	__le16 atim_window;
 	__le16 use_g_rate_protect;
diff --git a/drivers/net/wireless/mwifiex/ieee.h b/drivers/net/wireless/mwifiex/ieee.h
index c4f5c79..c7e261d 100644
--- a/drivers/net/wireless/mwifiex/ieee.h
+++ b/drivers/net/wireless/mwifiex/ieee.h
@@ -167,7 +167,7 @@ struct ieee_types_obss_scan_param {
 } __packed;
 
 struct mwifiex_bssdescriptor {
-	u8 mac_address[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 mac_address[ETH_ALEN];
 	struct mwifiex_802_11_ssid ssid;
 	u32 privacy;
 	s32 rssi;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 915d01c..0fc9cbf 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -76,7 +76,7 @@ static int mwifiex_init_priv(struct mwifiex_private *priv)
 	int ret = 0;
 
 	priv->media_connected = false;
-	memset(priv->curr_addr, 0xff, MWIFIEX_MAC_ADDR_LENGTH);
+	memset(priv->curr_addr, 0xff, ETH_ALEN);
 
 	priv->pkt_tx_ctrl = 0;
 	priv->bss_mode = MWIFIEX_BSS_MODE_INFRA;
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 06d1b45..6a81f05 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -36,7 +36,7 @@ enum {
 };
 
 struct mwifiex_get_scan_table_fixed {
-	u8 bssid[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 bssid[ETH_ALEN];
 	u8 channel;
 	u8 rssi;
 	long long network_tsf;
@@ -80,7 +80,7 @@ enum {
 struct mwifiex_multicast_list {
 	u32 mode;
 	u32 num_multicast_addr;
-	u8 mac_list[MWIFIEX_MAX_MULTICAST_LIST_SIZE][MWIFIEX_MAC_ADDR_LENGTH];
+	u8 mac_list[MWIFIEX_MAX_MULTICAST_LIST_SIZE][ETH_ALEN];
 };
 
 #define MWIFIEX_MAX_CHANNEL_NUM		128
@@ -97,7 +97,7 @@ struct mwifiex_chan_list {
 
 struct mwifiex_ssid_bssid {
 	struct mwifiex_802_11_ssid ssid;
-	u8 bssid[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 bssid[ETH_ALEN];
 };
 
 enum {
@@ -182,7 +182,7 @@ struct mwifiex_ds_get_signal {
 
 struct mwifiex_fw_info {
 	u32 fw_ver;
-	u8 mac_addr[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 mac_addr[ETH_ALEN];
 };
 
 #define MWIFIEX_MAX_VER_STR_LEN    128
@@ -207,7 +207,7 @@ struct mwifiex_bss_info {
 	u32 wep_status;
 	u32 is_hs_configured;
 	u32 is_deep_sleep;
-	u8 bssid[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 bssid[ETH_ALEN];
 };
 
 #define MAX_NUM_TID     8
@@ -216,7 +216,7 @@ struct mwifiex_bss_info {
 
 struct mwifiex_ds_rx_reorder_tbl {
 	u16 tid;
-	u8 ta[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 ta[ETH_ALEN];
 	u32 start_win;
 	u32 win_size;
 	u32 buffer[MAX_RX_WINSIZE];
@@ -224,7 +224,7 @@ struct mwifiex_ds_rx_reorder_tbl {
 
 struct mwifiex_ds_tx_ba_stream_tbl {
 	u16 tid;
-	u8 ra[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 ra[ETH_ALEN];
 };
 
 #define DBG_CMD_NUM	5
@@ -309,7 +309,7 @@ struct mwifiex_ds_encrypt_key {
 	u32 is_current_wep_key;
 	u32 key_len;
 	u8 key_material[MWIFIEX_MAX_KEY_LENGTH];
-	u8 mac_addr[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 mac_addr[ETH_ALEN];
 	u32 is_wapi_key;
 	u8 wapi_rxpn[WAPI_RXPN_LEN];
 };
@@ -325,7 +325,7 @@ struct mwifiex_pmk {
 
 struct mwifiex_ds_passphrase {
 	struct mwifiex_802_11_ssid        ssid;
-	u8 bssid[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 bssid[ETH_ALEN];
 	u16  psk_type;
 	union {
 		struct mwifiex_passphrase   passphrase;
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 9b34fcb..0cdc88d 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -1176,7 +1176,7 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 		= cpu_to_le16(bss_desc->beacon_period);
 
 	memcpy(&adhoc_join->bss_descriptor.bssid,
-	       &bss_desc->mac_address, MWIFIEX_MAC_ADDR_LENGTH);
+	       &bss_desc->mac_address, ETH_ALEN);
 
 	memcpy(&adhoc_join->bss_descriptor.ssid,
 	       &bss_desc->ssid.ssid, bss_desc->ssid.ssid_len);
@@ -1320,7 +1320,7 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 
 		/* Update the created network descriptor with the new BSSID */
 		memcpy(bss_desc->mac_address,
-		       adhoc_result->bssid, MWIFIEX_MAC_ADDR_LENGTH);
+		       adhoc_result->bssid, ETH_ALEN);
 
 		priv->adhoc_state = ADHOC_STARTED;
 	} else {
@@ -1378,7 +1378,7 @@ int mwifiex_associate(struct mwifiex_private *priv,
 		      void *wait_queue, struct mwifiex_bssdescriptor *bss_desc)
 {
 	int ret = 0;
-	u8 current_bssid[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 current_bssid[ETH_ALEN];
 
 	/* Return error if the adapter or table entry is not marked as infra */
 	if ((priv->bss_mode != MWIFIEX_BSS_MODE_INFRA) ||
@@ -1476,21 +1476,20 @@ static int mwifiex_deauthenticate_infra(struct mwifiex_private *priv,
 					struct mwifiex_wait_queue *wait,
 					u8 *mac)
 {
-	u8 mac_address[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 mac_address[ETH_ALEN];
 	int ret = 0;
-	u8 zero_mac[] = { 0, 0, 0, 0, 0, 0 };
+	u8 zero_mac[ETH_ALEN] = { 0, 0, 0, 0, 0, 0 };
 
 	if (mac) {
 		if (!memcmp(mac, zero_mac, sizeof(zero_mac)))
 			memcpy((u8 *) &mac_address,
 			       (u8 *) &priv->curr_bss_params.bss_descriptor.
-			       mac_address, MWIFIEX_MAC_ADDR_LENGTH);
+			       mac_address, ETH_ALEN);
 		else
-			memcpy((u8 *) &mac_address, (u8 *) mac,
-			       MWIFIEX_MAC_ADDR_LENGTH);
+			memcpy((u8 *) &mac_address, (u8 *) mac, ETH_ALEN);
 	} else {
 		memcpy((u8 *) &mac_address, (u8 *) &priv->curr_bss_params.
-		       bss_descriptor.mac_address, MWIFIEX_MAC_ADDR_LENGTH);
+		       bss_descriptor.mac_address, ETH_ALEN);
 	}
 
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_DEAUTHENTICATE,
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 6503feb..d972512 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -205,7 +205,7 @@ struct mwifiex_tx_aggr {
 struct mwifiex_ra_list_tbl {
 	struct list_head list;
 	struct sk_buff_head skb_head;
-	u8 ra[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 ra[ETH_ALEN];
 	u32 total_pkts_size;
 	u32 is_11n_enabled;
 };
@@ -317,7 +317,7 @@ struct mwifiex_private {
 	u8 bss_priority;
 	u8 bss_num;
 	u8 frame_type;
-	u8 curr_addr[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 curr_addr[ETH_ALEN];
 	u8 media_connected;
 	u32 num_tx_timeout;
 	struct net_device *netdev;
@@ -348,7 +348,7 @@ struct mwifiex_private {
 	s16 bcn_nf_avg;
 	struct mwifiex_bssdescriptor *attempted_bss_desc;
 	struct mwifiex_802_11_ssid prev_ssid;
-	u8 prev_bssid[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 prev_bssid[ETH_ALEN];
 	struct mwifiex_current_bss_params curr_bss_params;
 	u16 beacon_period;
 	u16 listen_interval;
@@ -444,7 +444,7 @@ enum mwifiex_ba_status {
 struct mwifiex_tx_ba_stream_tbl {
 	struct list_head list;
 	int tid;
-	u8 ra[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 ra[ETH_ALEN];
 	enum mwifiex_ba_status ba_status;
 };
 
@@ -459,7 +459,7 @@ struct reorder_tmr_cnxt {
 struct mwifiex_rx_reorder_tbl {
 	struct list_head list;
 	int tid;
-	u8 ta[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 ta[ETH_ALEN];
 	int start_win;
 	int win_size;
 	void **rx_reorder_ptr;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index f463711..2aacec0 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -199,8 +199,7 @@ int mwifiex_find_best_bss(struct mwifiex_private *priv,
 		passphrase.psk_type = MWIFIEX_PSK_QUERY;
 		memcpy(&passphrase.ssid, &ssid_bssid->ssid,
 				sizeof(struct mwifiex_802_11_ssid));
-		memcpy(passphrase.bssid, ssid_bssid->bssid,
-				MWIFIEX_MAC_ADDR_LENGTH);
+		memcpy(passphrase.bssid, ssid_bssid->bssid, ETH_ALEN);
 		ret = mwifiex_sec_ioctl_passphrase(priv, wait1, &passphrase,
 						   HostCmd_ACT_GEN_GET);
 
@@ -983,7 +982,7 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 	struct mwifiex_ie_types_num_probes *num_probes_tlv;
 	struct mwifiex_ie_types_wildcard_ssid_params *wildcard_ssid_tlv;
 	struct mwifiex_ie_types_rates_param_set *rates_tlv;
-	const u8 zero_mac[MWIFIEX_MAC_ADDR_LENGTH] = { 0, 0, 0, 0, 0, 0 };
+	const u8 zero_mac[ETH_ALEN] = { 0, 0, 0, 0, 0, 0 };
 	u8 *tlv_pos;
 	u32 num_probes;
 	u32 ssid_len;
@@ -1378,12 +1377,12 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 
 	bytes_left_for_current_beacon = beacon_size;
 
-	memcpy(bss_entry->mac_address, current_ptr, MWIFIEX_MAC_ADDR_LENGTH);
+	memcpy(bss_entry->mac_address, current_ptr, ETH_ALEN);
 	dev_dbg(adapter->dev, "info: InterpretIE: AP MAC Addr: %pM\n",
 						bss_entry->mac_address);
 
-	current_ptr += MWIFIEX_MAC_ADDR_LENGTH;
-	bytes_left_for_current_beacon -= MWIFIEX_MAC_ADDR_LENGTH;
+	current_ptr += ETH_ALEN;
+	bytes_left_for_current_beacon -= ETH_ALEN;
 
 	if (bytes_left_for_current_beacon < 12) {
 		dev_err(adapter->dev, "InterpretIE: not enough bytes left\n");
@@ -2817,7 +2816,7 @@ mwifiex_find_ssid_in_list(struct mwifiex_private *priv,
 		if (!mwifiex_ssid_cmp(&adapter->scan_table[i].ssid, ssid) &&
 		    (!bssid
 		     || !memcmp(adapter->scan_table[i].mac_address, bssid,
-				MWIFIEX_MAC_ADDR_LENGTH))
+				ETH_ALEN))
 		    &&
 		    (mwifiex_get_cfp_by_band_and_channel_from_cfg80211
 		     (priv, (u8) adapter->scan_table[i].bss_band,
@@ -2896,8 +2895,7 @@ mwifiex_find_bssid_in_list(struct mwifiex_private *priv, u8 *bssid,
 	 */
 	for (i = 0; net < 0 && i < adapter->num_in_scan_table; i++) {
 		if (!memcmp
-		    (adapter->scan_table[i].mac_address, bssid,
-		     MWIFIEX_MAC_ADDR_LENGTH)
+		    (adapter->scan_table[i].mac_address, bssid, ETH_ALEN)
 			&& mwifiex_get_cfp_by_band_and_channel_from_cfg80211
 								(priv,
 							    (u8) adapter->
@@ -2956,8 +2954,7 @@ int mwifiex_find_best_network(struct mwifiex_private *priv,
 		memcpy(&req_ssid_bssid->ssid, &req_bss->ssid,
 		       sizeof(struct mwifiex_802_11_ssid));
 		memcpy((u8 *) &req_ssid_bssid->bssid,
-		       (u8 *) &req_bss->mac_address,
-		       MWIFIEX_MAC_ADDR_LENGTH);
+		       (u8 *) &req_bss->mac_address, ETH_ALEN);
 
 		/* Make sure we are in the right mode */
 		if (priv->bss_mode == MWIFIEX_BSS_MODE_AUTO)
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index b072d06..a3b94e0 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -396,7 +396,7 @@ static int mwifiex_cmd_802_11_mac_address(struct mwifiex_private *priv,
 
 	if (cmd_action == HostCmd_ACT_GEN_SET)
 		memcpy(cmd->params.mac_addr.mac_addr, priv->curr_addr,
-		       MWIFIEX_MAC_ADDR_LENGTH);
+		       ETH_ALEN);
 	return 0;
 }
 
@@ -450,7 +450,7 @@ static int mwifiex_cmd_mac_multicast_adr(struct mwifiex_private *priv,
 	mcast_addr->num_of_adrs =
 		cpu_to_le16((u16) mcast_list->num_multicast_addr);
 	memcpy(mcast_addr->mac_list, mcast_list->mac_list,
-	       mcast_list->num_multicast_addr * MWIFIEX_MAC_ADDR_LENGTH);
+	       mcast_list->num_multicast_addr * ETH_ALEN);
 
 	return 0;
 }
@@ -474,7 +474,7 @@ static int mwifiex_cmd_802_11_deauthenticate(struct mwifiex_private *priv,
 				+ S_DS_GEN);
 
 	/* Set AP MAC address */
-	memcpy(deauth->mac_addr, (u8 *) data_buf, MWIFIEX_MAC_ADDR_LENGTH);
+	memcpy(deauth->mac_addr, (u8 *) data_buf, ETH_ALEN);
 
 	dev_dbg(priv->adapter->dev, "cmd: Deauth: %pM\n", deauth->mac_addr);
 
@@ -776,9 +776,8 @@ mwifiex_cmd_802_11_supplicant_pmk(struct mwifiex_private  *priv,
 	if (memcmp((u8 *)&psk->bssid, zero_mac, sizeof(zero_mac))) {
 		pbssid_tlv = (struct mwifiex_ie_types_bssid *) ptlv_buffer;
 		pbssid_tlv->header.type = cpu_to_le16(TLV_TYPE_BSSID);
-		pbssid_tlv->header.len = cpu_to_le16(MWIFIEX_MAC_ADDR_LENGTH);
-		memcpy(pbssid_tlv->bssid, (u8 *)&psk->bssid,
-					MWIFIEX_MAC_ADDR_LENGTH);
+		pbssid_tlv->header.len = cpu_to_le16(ETH_ALEN);
+		memcpy(pbssid_tlv->bssid, (u8 *)&psk->bssid, ETH_ALEN);
 		ptlv_buffer += (le16_to_cpu(pbssid_tlv->header.len) +
 					sizeof(struct mwifiex_ie_types_header));
 		cmd->size = cpu_to_le16(le16_to_cpu(cmd->size) +
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 60b039c..5d3fb79 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -527,8 +527,7 @@ static int mwifiex_ret_802_11_mac_address(struct mwifiex_private *priv,
 	struct host_cmd_ds_802_11_mac_address *cmd_mac_addr =
 		&resp->params.mac_addr;
 
-	memcpy(priv->curr_addr, cmd_mac_addr->mac_addr,
-		MWIFIEX_MAC_ADDR_LENGTH);
+	memcpy(priv->curr_addr, cmd_mac_addr->mac_addr, ETH_ALEN);
 
 	dev_dbg(priv->adapter->dev,
 		"info: set mac address: %pM\n", priv->curr_addr);
@@ -677,8 +676,7 @@ static int mwifiex_get_passphrase_from_cmdresp(struct mwifiex_private *priv,
 			break;
 		case TLV_TYPE_BSSID:
 			pbssid_tlv = (struct mwifiex_ie_types_bssid *)tlv_buf;
-			memcpy(&passphrase->bssid, pbssid_tlv->bssid,
-				MWIFIEX_MAC_ADDR_LENGTH);
+			memcpy(&passphrase->bssid, pbssid_tlv->bssid, ETH_ALEN);
 			tlv_buf += le16_to_cpu(pbssid_tlv->header.len) +
 				sizeof(struct mwifiex_ie_types_header);
 			tlv_buf_len -= (le16_to_cpu(pbssid_tlv->header.len) +
@@ -1029,7 +1027,7 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_802_11_ibss_status *ibss_coal_resp =
 		&(resp->params.ibss_coalescing);
-	u8 zero_mac[MWIFIEX_MAC_ADDR_LENGTH] = { 0, 0, 0, 0, 0, 0 };
+	u8 zero_mac[ETH_ALEN] = { 0, 0, 0, 0, 0, 0 };
 
 	if (le16_to_cpu(ibss_coal_resp->action) == HostCmd_ACT_GEN_SET)
 		return 0;
@@ -1038,17 +1036,17 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
 		"info: new BSSID %pM\n", ibss_coal_resp->bssid);
 
 	/* If rsp has NULL BSSID, Just return..... No Action */
-	if (!memcmp(ibss_coal_resp->bssid, zero_mac, MWIFIEX_MAC_ADDR_LENGTH)) {
+	if (!memcmp(ibss_coal_resp->bssid, zero_mac, ETH_ALEN)) {
 		dev_warn(priv->adapter->dev, "new BSSID is NULL\n");
 		return 0;
 	}
 
 	/* If BSSID is diff, modify current BSS parameters */
 	if (memcmp(priv->curr_bss_params.bss_descriptor.mac_address,
-		   ibss_coal_resp->bssid, MWIFIEX_MAC_ADDR_LENGTH)) {
+		   ibss_coal_resp->bssid, ETH_ALEN)) {
 		/* BSSID */
 		memcpy(priv->curr_bss_params.bss_descriptor.mac_address,
-		       ibss_coal_resp->bssid, MWIFIEX_MAC_ADDR_LENGTH);
+		       ibss_coal_resp->bssid, ETH_ALEN);
 
 		/* Beacon Interval and ATIM window */
 		priv->curr_bss_params.bss_descriptor.beacon_period
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index e41c947..c3e6dd0 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -106,8 +106,7 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 	       sizeof(struct mwifiex_802_11_ssid));
 
 	memcpy(priv->prev_bssid,
-	       priv->curr_bss_params.bss_descriptor.mac_address,
-	       MWIFIEX_MAC_ADDR_LENGTH);
+	       priv->curr_bss_params.bss_descriptor.mac_address, ETH_ALEN);
 
 	/* Need to erase the current SSID and BSSID info */
 	memset(&priv->curr_bss_params, 0x00, sizeof(priv->curr_bss_params));
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 4fdf28c..23f00b0 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -527,7 +527,7 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
 	       sizeof(struct mwifiex_802_11_ssid));
 
 	/* BSSID */
-	memcpy(&info->bssid, &bss_desc->mac_address, MWIFIEX_MAC_ADDR_LENGTH);
+	memcpy(&info->bssid, &bss_desc->mac_address, ETH_ALEN);
 
 	/* Channel */
 	info->bss_chan = bss_desc->channel;
@@ -761,8 +761,7 @@ int mwifiex_bss_ioctl_mac_address(struct mwifiex_private *priv,
 	int ret = 0;
 
 	if ((action == HostCmd_ACT_GEN_GET) && mac) {
-		memcpy(mac, priv->curr_addr,
-		       MWIFIEX_MAC_ADDR_LENGTH);
+		memcpy(mac, priv->curr_addr, ETH_ALEN);
 		return 0;
 	}
 
@@ -1122,8 +1121,8 @@ int mwifiex_bss_ioctl_find_bss(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	int ret = 0;
 	struct mwifiex_bssdescriptor *bss_desc;
-	u8 zero_mac[] = { 0, 0, 0, 0, 0, 0 };
-	u8 mac[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 zero_mac[ETH_ALEN] = { 0, 0, 0, 0, 0, 0 };
+	u8 mac[ETH_ALEN];
 	int i = 0;
 
 	if (memcmp(ssid_bssid->bssid, zero_mac, sizeof(zero_mac))) {
@@ -1147,8 +1146,7 @@ int mwifiex_bss_ioctl_find_bss(struct mwifiex_private *priv,
 			return -1;
 		}
 		bss_desc = &adapter->scan_table[i];
-		memcpy(ssid_bssid->bssid, bss_desc->mac_address,
-		       MWIFIEX_MAC_ADDR_LENGTH);
+		memcpy(ssid_bssid->bssid, bss_desc->mac_address, ETH_ALEN);
 	} else {
 		ret = mwifiex_find_best_network(priv, ssid_bssid);
 	}
@@ -1216,7 +1214,7 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 	}
 
 	/* Do disonnect */
-	memset(&ssid_bssid, 0, MWIFIEX_MAC_ADDR_LENGTH);
+	memset(&ssid_bssid, 0, ETH_ALEN);
 	status = mwifiex_bss_ioctl_stop(priv, wait, ssid_bssid.bssid);
 
 	if (mwifiex_request_ioctl(priv, wait, status, wait_option)) {
@@ -2219,15 +2217,13 @@ int mwifiex_sec_ioctl_passphrase(struct mwifiex_private *priv,
 					memcpy(&passphrase->ssid,
 					&pbss_desc->ssid,
 					sizeof(struct mwifiex_802_11_ssid));
-					memset(passphrase->bssid, 0,
-					MWIFIEX_MAC_ADDR_LENGTH);
+					memset(passphrase->bssid, 0, ETH_ALEN);
 					dev_dbg(adapter->dev, "info: PSK_QUERY:"
 							" found ssid=%s\n",
 						      passphrase->ssid.ssid);
 				}
 			} else {
-				memset(passphrase->bssid, 0,
-					MWIFIEX_MAC_ADDR_LENGTH);
+				memset(passphrase->bssid, 0, ETH_ALEN);
 			}
 		}
 		cmd_action = HostCmd_ACT_GEN_GET;
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index f645d52..253e057 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -49,8 +49,7 @@ int mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 	struct rxpd *local_rx_pd;
 	int hdr_chop;
 	struct ethhdr *eth_hdr;
-	u8 rfc1042_eth_hdr[MWIFIEX_MAC_ADDR_LENGTH] = { 0xaa, 0xaa, 0x03,
-							0x00, 0x00, 0x00 };
+	u8 rfc1042_eth_hdr[ETH_ALEN] = { 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
 
 	local_rx_pd = (struct rxpd *) (skb->data);
 
@@ -124,7 +123,7 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 	struct rxpd *local_rx_pd;
 	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
 	struct rx_packet_hdr *rx_pkt_hdr;
-	u8 ta[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 ta[ETH_ALEN];
 	u16 rx_pkt_type = 0;
 	struct mwifiex_private *priv = adapter->priv[rx_info->bss_index];
 
@@ -152,21 +151,19 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 	 * directly to os. Don't pass thru rx reordering
 	 */
 	if (!IS_11N_ENABLED(priv) ||
-	    memcmp(priv->curr_addr, rx_pkt_hdr->eth803_hdr.h_dest,
-		   MWIFIEX_MAC_ADDR_LENGTH)) {
+	    memcmp(priv->curr_addr, rx_pkt_hdr->eth803_hdr.h_dest, ETH_ALEN)) {
 		mwifiex_process_rx_packet(adapter, skb);
 		return ret;
 	}
 
 	if (mwifiex_queuing_ra_based(priv)) {
-		memcpy(ta, rx_pkt_hdr->eth803_hdr.h_source,
-		       MWIFIEX_MAC_ADDR_LENGTH);
+		memcpy(ta, rx_pkt_hdr->eth803_hdr.h_source, ETH_ALEN);
 	} else {
 		if (rx_pkt_type != PKT_TYPE_BAR)
 			priv->rx_seq[local_rx_pd->priority] =
 						local_rx_pd->seq_num;
 		memcpy(ta, priv->curr_bss_params.bss_descriptor.mac_address,
-		       MWIFIEX_MAC_ADDR_LENGTH);
+		       ETH_ALEN);
 	}
 
 	/* Reorder and send to OS */
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 947aa6b..a42751f 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -119,7 +119,7 @@ mwifiex_wmm_allocate_ralist_node(struct mwifiex_adapter *adapter, u8 *ra)
 	INIT_LIST_HEAD(&ra_list->list);
 	skb_queue_head_init(&ra_list->skb_head);
 
-	memcpy(ra_list->ra, ra, MWIFIEX_MAC_ADDR_LENGTH);
+	memcpy(ra_list->ra, ra, ETH_ALEN);
 
 	ra_list->total_pkts_size = 0;
 
@@ -546,7 +546,7 @@ mwifiex_wmm_get_ralist_node(struct mwifiex_private *priv, u8 tid,
 
 	list_for_each_entry(ra_list, &priv->wmm.tid_tbl_ptr[tid].ra_list,
 			    list) {
-		if (!memcmp(ra_list->ra, ra_addr, MWIFIEX_MAC_ADDR_LENGTH))
+		if (!memcmp(ra_list->ra, ra_addr, ETH_ALEN))
 			return ra_list;
 	}
 
@@ -609,7 +609,7 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 	struct mwifiex_private *priv = adapter->priv[tx_info->bss_index];
 	u32 tid;
 	struct mwifiex_ra_list_tbl *ra_list;
-	u8 ra[MWIFIEX_MAC_ADDR_LENGTH], tid_down;
+	u8 ra[ETH_ALEN], tid_down;
 	unsigned long flags;
 
 	if (!priv->media_connected) {
@@ -637,7 +637,7 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 		else
 			ra_list = NULL;
 	} else {
-		memcpy(ra, skb->data, MWIFIEX_MAC_ADDR_LENGTH);
+		memcpy(ra, skb->data, ETH_ALEN);
 		ra_list = mwifiex_wmm_get_queue_raptr(priv, tid_down, ra);
 	}
 
@@ -1165,7 +1165,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 	struct mwifiex_ra_list_tbl *ptr;
 	struct mwifiex_private *priv = NULL;
 	int ptr_index = 0;
-	u8 ra[MWIFIEX_MAC_ADDR_LENGTH];
+	u8 ra[ETH_ALEN];
 	int tid_del = 0, tid = 0;
 	unsigned long flags;
 
-- 
1.7.0.2

