Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21027 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933022Ab3CMMNe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 08:13:34 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 13/14] wil6210: sync with new firmware
Date: Wed, 13 Mar 2013 14:12:50 +0200
Message-ID: <1363176771-10082-14-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130313_131349_145423_D45E9213)
In-Reply-To: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adjust driver for changes in the FW API.
Noticeable changes in the FW are:
- temperature sensing
- infrastructure for multiple connections
- infrastructure for P2P
- signal strength indication

This commit introduces only changes that are required to support same functionality
as previous firmware, no new features.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |   12 +-
 drivers/net/wireless/ath/wil6210/main.c     |   15 +-
 drivers/net/wireless/ath/wil6210/txrx.c     |    2 +-
 drivers/net/wireless/ath/wil6210/wil6210.h  |    6 +-
 drivers/net/wireless/ath/wil6210/wmi.c      |   45 +++-
 drivers/net/wireless/ath/wil6210/wmi.h      |  363 +++++++++++++++++++--------
 6 files changed, 321 insertions(+), 122 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index feb33ac..ebb92cbe 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -429,10 +429,6 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 	if (rc)
 		return rc;
 
-	rc = wmi_set_channel(wil, channel->hw_value);
-	if (rc)
-		return rc;
-
 	/* MAC address - pre-requisite for other commands */
 	wmi_set_mac_address(wil, ndev->dev_addr);
 
@@ -452,7 +448,8 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 
 	wil->secure_pcp = info->privacy;
 
-	rc = wmi_set_bcon(wil, info->beacon_interval, wmi_nettype);
+	rc = wmi_pcp_start(wil, info->beacon_interval, wmi_nettype,
+			   channel->hw_value);
 	if (rc)
 		return rc;
 
@@ -469,11 +466,8 @@ static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
 {
 	int rc = 0;
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
-	struct wireless_dev *wdev = ndev->ieee80211_ptr;
-	u8 wmi_nettype = wil_iftype_nl2wmi(wdev->iftype);
 
-	/* To stop beaconing, set BI to 0 */
-	rc = wmi_set_bcon(wil, 0, wmi_nettype);
+	rc = wmi_pcp_stop(wil);
 
 	return rc;
 }
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 9d05628..a0478e2 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -343,9 +343,9 @@ static int __wil_up(struct wil6210_priv *wil)
 			wil_err(wil, "SSID not set\n");
 			return -EINVAL;
 		}
-		wmi_set_ssid(wil, wdev->ssid_len, wdev->ssid);
-		if (channel)
-			wmi_set_channel(wil, channel->hw_value);
+		rc = wmi_set_ssid(wil, wdev->ssid_len, wdev->ssid);
+		if (rc)
+			return rc;
 		break;
 	default:
 		break;
@@ -355,9 +355,12 @@ static int __wil_up(struct wil6210_priv *wil)
 	wmi_set_mac_address(wil, ndev->dev_addr);
 
 	/* Set up beaconing if required. */
-	rc = wmi_set_bcon(wil, bi, wmi_nettype);
-	if (rc)
-		return rc;
+	if (bi > 0) {
+		rc = wmi_pcp_start(wil, bi, wmi_nettype,
+				   (channel ? channel->hw_value : 0));
+		if (rc)
+			return rc;
+	}
 
 	/* Rx VRING. After MAC and beacon */
 	wil_rx_init(wil);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 4af9967..1bfa736 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -557,7 +557,7 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 	if (rc)
 		goto out_free;
 
-	if (reply.cmd.status != WMI_VRING_CFG_SUCCESS) {
+	if (reply.cmd.status != WMI_FW_STATUS_SUCCESS) {
 		wil_err(wil, "Tx config failed, status 0x%02x\n",
 			reply.cmd.status);
 		rc = -EINVAL;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 2ec7258..3bbd86d 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -209,6 +209,8 @@ struct wil6210_priv {
 	struct wireless_dev *wdev;
 	void __iomem *csr;
 	ulong status;
+	u32 fw_version;
+	u8 n_mids; /* number of additional MIDs as reported by FW */
 	/* profile */
 	u32 monitor_flags;
 	u32 secure_pcp; /* create secure PCP? */
@@ -326,6 +328,7 @@ int wmi_add_cipher_key(struct wil6210_priv *wil, u8 key_index,
 int wmi_echo(struct wil6210_priv *wil);
 int wmi_set_ie(struct wil6210_priv *wil, u8 type, u16 ie_len, const void *ie);
 int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring);
+int wmi_p2p_cfg(struct wil6210_priv *wil, int channel);
 
 int wil6210_init_irq(struct wil6210_priv *wil, int irq);
 void wil6210_fini_irq(struct wil6210_priv *wil, int irq);
@@ -339,7 +342,8 @@ struct wireless_dev *wil_cfg80211_init(struct device *dev);
 void wil_wdev_free(struct wil6210_priv *wil);
 
 int wmi_set_mac_address(struct wil6210_priv *wil, void *addr);
-int wmi_set_bcon(struct wil6210_priv *wil, int bi, u8 wmi_nettype);
+int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype, u8 chan);
+int wmi_pcp_stop(struct wil6210_priv *wil);
 void wil6210_disconnect(struct wil6210_priv *wil, void *bssid);
 
 int wil_rx_init(struct wil6210_priv *wil);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index ed2b097..706ee9d 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -269,16 +269,18 @@ static void wmi_evt_ready(struct wil6210_priv *wil, int id, void *d, int len)
 	struct net_device *ndev = wil_to_ndev(wil);
 	struct wireless_dev *wdev = wil->wdev;
 	struct wmi_ready_event *evt = d;
-	u32 ver = le32_to_cpu(evt->sw_version);
+	wil->fw_version = le32_to_cpu(evt->sw_version);
+	wil->n_mids = evt->numof_additional_mids;
 
-	wil_dbg_wmi(wil, "FW ver. %d; MAC %pM\n", ver, evt->mac);
+	wil_dbg_wmi(wil, "FW ver. %d; MAC %pM; %d MID's\n", wil->fw_version,
+		    evt->mac, wil->n_mids);
 
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
 		memcpy(ndev->dev_addr, evt->mac, ETH_ALEN);
 		memcpy(ndev->perm_addr, evt->mac, ETH_ALEN);
 	}
 	snprintf(wdev->wiphy->fw_version, sizeof(wdev->wiphy->fw_version),
-		 "%d", ver);
+		 "%d", wil->fw_version);
 }
 
 static void wmi_evt_fw_ready(struct wil6210_priv *wil, int id, void *d,
@@ -714,18 +716,39 @@ int wmi_set_mac_address(struct wil6210_priv *wil, void *addr)
 	return wmi_send(wil, WMI_SET_MAC_ADDRESS_CMDID, &cmd, sizeof(cmd));
 }
 
-int wmi_set_bcon(struct wil6210_priv *wil, int bi, u8 wmi_nettype)
+int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype, u8 chan)
 {
-	struct wmi_bcon_ctrl_cmd cmd = {
+	int rc;
+
+	struct wmi_pcp_start_cmd cmd = {
 		.bcon_interval = cpu_to_le16(bi),
 		.network_type = wmi_nettype,
 		.disable_sec_offload = 1,
+		.channel = chan,
 	};
+	struct {
+		struct wil6210_mbox_hdr_wmi wmi;
+		struct wmi_pcp_started_event evt;
+	} __packed reply;
 
 	if (!wil->secure_pcp)
 		cmd.disable_sec = 1;
 
-	return wmi_send(wil, WMI_BCON_CTRL_CMDID, &cmd, sizeof(cmd));
+	rc = wmi_call(wil, WMI_PCP_START_CMDID, &cmd, sizeof(cmd),
+		      WMI_PCP_STARTED_EVENTID, &reply, sizeof(reply), 100);
+	if (rc)
+		return rc;
+
+	if (reply.evt.status != WMI_FW_STATUS_SUCCESS)
+		rc = -EINVAL;
+
+	return rc;
+}
+
+int wmi_pcp_stop(struct wil6210_priv *wil)
+{
+	return wmi_call(wil, WMI_PCP_STOP_CMDID, NULL, 0,
+			WMI_PCP_STOPPED_EVENTID, NULL, 0, 20);
 }
 
 int wmi_set_ssid(struct wil6210_priv *wil, u8 ssid_len, const void *ssid)
@@ -796,6 +819,16 @@ int wmi_get_channel(struct wil6210_priv *wil, int *channel)
 	return 0;
 }
 
+int wmi_p2p_cfg(struct wil6210_priv *wil, int channel)
+{
+	struct wmi_p2p_cfg_cmd cmd = {
+		.discovery_mode = WMI_DISCOVERY_MODE_NON_OFFLOAD,
+		.channel = channel - 1,
+	};
+
+	return wmi_send(wil, WMI_P2P_CFG_CMDID, &cmd, sizeof(cmd));
+}
+
 int wmi_tx_eapol(struct wil6210_priv *wil, struct sk_buff *skb)
 {
 	struct wmi_eapol_tx_cmd *cmd;
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index 3bbf875..50b8528 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -36,6 +36,7 @@
 enum wmi_command_id {
 	WMI_CONNECT_CMDID		= 0x0001,
 	WMI_DISCONNECT_CMDID		= 0x0003,
+	WMI_DISCONNECT_STA_CMDID	= 0x0004,
 	WMI_START_SCAN_CMDID		= 0x0007,
 	WMI_SET_BSS_FILTER_CMDID	= 0x0009,
 	WMI_SET_PROBED_SSID_CMDID	= 0x000a,
@@ -44,7 +45,6 @@ enum wmi_command_id {
 	WMI_ADD_CIPHER_KEY_CMDID	= 0x0016,
 	WMI_DELETE_CIPHER_KEY_CMDID	= 0x0017,
 	WMI_SET_APPIE_CMDID		= 0x003f,
-	WMI_GET_APPIE_CMDID		= 0x0040,
 	WMI_SET_WSC_STATUS_CMDID	= 0x0041,
 	WMI_PXMT_RANGE_CFG_CMDID	= 0x0042,
 	WMI_PXMT_SNR2_RANGE_CFG_CMDID	= 0x0043,
@@ -55,11 +55,11 @@ enum wmi_command_id {
 	WMI_DEEP_ECHO_CMDID		= 0x0804,
 	WMI_CONFIG_MAC_CMDID		= 0x0805,
 	WMI_CONFIG_PHY_DEBUG_CMDID	= 0x0806,
-	WMI_ADD_STATION_CMDID		= 0x0807,
 	WMI_ADD_DEBUG_TX_PCKT_CMDID	= 0x0808,
 	WMI_PHY_GET_STATISTICS_CMDID	= 0x0809,
 	WMI_FS_TUNE_CMDID		= 0x080a,
 	WMI_CORR_MEASURE_CMDID		= 0x080b,
+	WMI_READ_RSSI_CMDID		= 0x080c,
 	WMI_TEMP_SENSE_CMDID		= 0x080e,
 	WMI_DC_CALIB_CMDID		= 0x080f,
 	WMI_SEND_TONE_CMDID		= 0x0810,
@@ -75,9 +75,9 @@ enum wmi_command_id {
 	MAC_IO_STATIC_PARAMS_CMDID	= 0x081b,
 	MAC_IO_DYNAMIC_PARAMS_CMDID	= 0x081c,
 	WMI_SILENT_RSSI_CALIB_CMDID	= 0x081d,
+	WMI_RF_RX_TEST_CMDID		= 0x081e,
 	WMI_CFG_RX_CHAIN_CMDID		= 0x0820,
 	WMI_VRING_CFG_CMDID		= 0x0821,
-	WMI_RX_ON_CMDID			= 0x0822,
 	WMI_VRING_BA_EN_CMDID		= 0x0823,
 	WMI_VRING_BA_DIS_CMDID		= 0x0824,
 	WMI_RCP_ADDBA_RESP_CMDID	= 0x0825,
@@ -87,7 +87,6 @@ enum wmi_command_id {
 	WMI_SET_PCP_CHANNEL_CMDID	= 0x0829,
 	WMI_GET_PCP_CHANNEL_CMDID	= 0x082a,
 	WMI_SW_TX_REQ_CMDID		= 0x082b,
-	WMI_RX_OFF_CMDID		= 0x082c,
 	WMI_READ_MAC_RXQ_CMDID		= 0x0830,
 	WMI_READ_MAC_TXQ_CMDID		= 0x0831,
 	WMI_WRITE_MAC_RXQ_CMDID		= 0x0832,
@@ -112,6 +111,18 @@ enum wmi_command_id {
 	WMI_FLASH_READ_CMDID		= 0x0902,
 	WMI_FLASH_WRITE_CMDID		= 0x0903,
 	WMI_SECURITY_UNIT_TEST_CMDID	= 0x0904,
+	/*P2P*/
+	WMI_P2P_CFG_CMDID		= 0x0910,
+	WMI_PORT_ALLOCATE_CMDID		= 0x0911,
+	WMI_PORT_DELETE_CMDID		= 0x0912,
+	WMI_POWER_MGMT_CFG_CMDID	= 0x0913,
+	WMI_START_LISTEN_CMDID		= 0x0914,
+	WMI_START_SEARCH_CMDID		= 0x0915,
+	WMI_DISCOVERY_START_CMDID	= 0x0916,
+	WMI_DISCOVERY_STOP_CMDID	= 0x0917,
+	WMI_PCP_START_CMDID		= 0x0918,
+	WMI_PCP_STOP_CMDID		= 0x0919,
+	WMI_GET_PCP_FACTOR_CMDID	= 0x091b,
 
 	WMI_SET_MAC_ADDRESS_CMDID	= 0xf003,
 	WMI_ABORT_SCAN_CMDID		= 0xf007,
@@ -132,18 +143,6 @@ enum wmi_command_id {
  */
 
 /*
- * Frame Types
- */
-enum wmi_mgmt_frame_type {
-	WMI_FRAME_BEACON	= 0,
-	WMI_FRAME_PROBE_REQ	= 1,
-	WMI_FRAME_PROBE_RESP	= 2,
-	WMI_FRAME_ASSOC_REQ	= 3,
-	WMI_FRAME_ASSOC_RESP	= 4,
-	WMI_NUM_MGMT_FRAME,
-};
-
-/*
  * WMI_CONNECT_CMDID
  */
 enum wmi_network_type {
@@ -184,7 +183,7 @@ enum wmi_crypto_type {
 enum wmi_connect_ctrl_flag_bits {
 	WMI_CONNECT_ASSOC_POLICY_USER		= 0x0001,
 	WMI_CONNECT_SEND_REASSOC		= 0x0002,
-	WMI_CONNECT_IGNORE_WPAx_GROUP_CIPHER	= 0x0004,
+	WMI_CONNECT_IGNORE_WPA_GROUP_CIPHER	= 0x0004,
 	WMI_CONNECT_PROFILE_MATCH_DONE		= 0x0008,
 	WMI_CONNECT_IGNORE_AAC_BEACON		= 0x0010,
 	WMI_CONNECT_CSA_FOLLOW_BSS		= 0x0020,
@@ -212,6 +211,13 @@ struct wmi_connect_cmd {
 	u8 reserved1[2];
 } __packed;
 
+/*
+ * WMI_DISCONNECT_STA_CMDID
+ */
+struct wmi_disconnect_sta_cmd {
+	u8 dst_mac[WMI_MAC_LEN];
+	__le16 disconnect_reason;
+} __packed;
 
 /*
  * WMI_RECONNECT_CMDID
@@ -289,10 +295,12 @@ struct wmi_delete_cipher_key_cmd {
 enum wmi_scan_type {
 	WMI_LONG_SCAN		= 0,
 	WMI_SHORT_SCAN		= 1,
+	WMI_PBC_SCAN		= 2,
 };
 
 struct wmi_start_scan_cmd {
 	u8 reserved[8];
+
 	__le32 home_dwell_time;	/* Max duration in the home channel(ms) */
 	__le32 force_scan_interval;	/* Time interval between scans (ms)*/
 	u8 scan_type;		/* wmi_scan_type */
@@ -309,7 +317,7 @@ struct wmi_start_scan_cmd {
 /*
  * WMI_SET_PROBED_SSID_CMDID
  */
-#define MAX_PROBED_SSID_INDEX   (15)
+#define MAX_PROBED_SSID_INDEX	(3)
 
 enum wmi_ssid_flag {
 	WMI_SSID_FLAG_DISABLE	= 0,	/* disables entry */
@@ -328,6 +336,20 @@ struct wmi_probed_ssid_cmd {
  * WMI_SET_APPIE_CMDID
  * Add Application specified IE to a management frame
  */
+#define WMI_MAX_IE_LEN		(1024)
+
+/*
+ * Frame Types
+ */
+enum wmi_mgmt_frame_type {
+	WMI_FRAME_BEACON	= 0,
+	WMI_FRAME_PROBE_REQ	= 1,
+	WMI_FRAME_PROBE_RESP	= 2,
+	WMI_FRAME_ASSOC_REQ	= 3,
+	WMI_FRAME_ASSOC_RESP	= 4,
+	WMI_NUM_MGMT_FRAME,
+};
+
 struct wmi_set_appie_cmd {
 	u8 mgmt_frm_type;	/* enum wmi_mgmt_frame_type */
 	u8 reserved;
@@ -335,13 +357,18 @@ struct wmi_set_appie_cmd {
 	u8 ie_info[0];
 } __packed;
 
-#define WMI_MAX_IE_LEN (1024)
 
+/*
+ * WMI_PXMT_RANGE_CFG_CMDID
+ */
 struct wmi_pxmt_range_cfg_cmd {
 	u8 dst_mac[WMI_MAC_LEN];
 	__le16 range;
 } __packed;
 
+/*
+ * WMI_PXMT_SNR2_RANGE_CFG_CMDID
+ */
 struct wmi_pxmt_snr2_range_cfg_cmd {
 	s8 snr2range_arr[WMI_PROX_RANGE_NUM-1];
 } __packed;
@@ -359,6 +386,23 @@ struct wmi_rf_mgmt_cmd {
 	__le32 rf_mgmt_type;
 } __packed;
 
+
+/*
+ * WMI_RF_RX_TEST_CMDID
+ */
+struct wmi_rf_rx_test_cmd {
+	__le32 sector;
+} __packed;
+
+/*
+ * WMI_CORR_MEASURE_CMDID
+ */
+struct wmi_corr_measure_cmd {
+	s32 freq_mhz;
+	__le32 length_samples;
+	__le32 iterations;
+} __packed;
+
 /*
  * WMI_SET_SSID_CMDID
  */
@@ -388,6 +432,74 @@ struct wmi_bcon_ctrl_cmd {
 	u8 disable_sec;
 } __packed;
 
+
+/******* P2P ***********/
+
+/*
+ * WMI_PORT_ALLOCATE_CMDID
+ */
+enum wmi_port_role {
+	WMI_PORT_STA		= 0,
+	WMI_PORT_PCP		= 1,
+	WMI_PORT_AP		= 2,
+	WMI_PORT_P2P_DEV	= 3,
+	WMI_PORT_P2P_CLIENT	= 4,
+	WMI_PORT_P2P_GO		= 5,
+};
+
+struct wmi_port_allocate_cmd {
+	u8 mac[WMI_MAC_LEN];
+	u8 port_role;
+	u8 midid;
+} __packed;
+
+/*
+ * WMI_PORT_DELETE_CMDID
+ */
+struct wmi_delete_port_cmd {
+	u8 mid;
+	u8 reserved[3];
+} __packed;
+
+/*
+ * WMI_P2P_CFG_CMDID
+ */
+enum wmi_discovery_mode {
+	WMI_DISCOVERY_MODE_NON_OFFLOAD	= 0,
+	WMI_DISCOVERY_MODE_OFFLOAD	= 1,
+};
+
+struct wmi_p2p_cfg_cmd {
+	u8 discovery_mode;	/* wmi_discovery_mode */
+	u8 channel;
+	__le16 bcon_interval; /* base to listen/search duration calculation */
+} __packed;
+
+/*
+ * WMI_POWER_MGMT_CFG_CMDID
+ */
+enum wmi_power_source_type {
+	WMI_POWER_SOURCE_BATTERY	= 0,
+	WMI_POWER_SOURCE_OTHER		= 1,
+};
+
+struct wmi_power_mgmt_cfg_cmd {
+	u8 power_source;	/* wmi_power_source_type */
+	u8 reserved[3];
+} __packed;
+
+/*
+ * WMI_PCP_START_CMDID
+ */
+struct wmi_pcp_start_cmd {
+	__le16 bcon_interval;
+	u8 reserved0[10];
+	u8 network_type;
+	u8 channel;
+	u8 disable_sec_offload;
+	u8 disable_sec;
+} __packed;
+
 /*
  * WMI_SW_TX_REQ_CMDID
  */
@@ -435,16 +547,17 @@ enum wmi_vring_cfg_schd_params_priority {
 	WMI_SCH_PRIO_HIGH			= 1,
 };
 
+#define CIDXTID_CID_POS (0)
+#define CIDXTID_CID_LEN (4)
+#define CIDXTID_CID_MSK (0xF)
+#define CIDXTID_TID_POS (4)
+#define CIDXTID_TID_LEN (4)
+#define CIDXTID_TID_MSK (0xF0)
+
 struct wmi_vring_cfg {
 	struct wmi_sw_ring_cfg tx_sw_ring;
 	u8 ringid;				/* 0-23 vrings */
 
-	#define CIDXTID_CID_POS (0)
-	#define CIDXTID_CID_LEN (4)
-	#define CIDXTID_CID_MSK (0xF)
-	#define CIDXTID_TID_POS (4)
-	#define CIDXTID_TID_LEN (4)
-	#define CIDXTID_TID_MSK (0xF0)
 	u8 cidxtid;
 
 	u8 encap_trans_type;
@@ -501,8 +614,14 @@ struct wmi_vring_ba_dis_cmd {
  */
 struct wmi_notify_req_cmd {
 	u8 cid;
-	u8 reserved[3];
+	u8 year;
+	u8 month;
+	u8 day;
 	__le32 interval_usec;
+	u8 hour;
+	u8 minute;
+	u8 second;
+	u8 miliseconds;
 } __packed;
 
 /*
@@ -548,6 +667,11 @@ enum wmi_cfg_rx_chain_cmd_nwifi_ds_trans_type {
 	WMI_NWIFI_RX_TRANS_MODE_PBSS2STA	= 2,
 };
 
+enum wmi_cfg_rx_chain_cmd_reorder_type {
+	WMI_RX_HW_REORDER = 0,
+	WMI_RX_SW_REORDER = 1,
+};
+
 struct wmi_cfg_rx_chain_cmd {
 	__le32 action;
 	struct wmi_sw_ring_cfg rx_sw_ring;
@@ -596,7 +720,8 @@ struct wmi_cfg_rx_chain_cmd {
 	__le16 wb_thrsh;
 	__le32 itr_value;
 	__le16 host_thrsh;
-	u8 reserved[2];
+	u8 reorder_type;
+	u8 reserved;
 	struct wmi_sniffer_cfg sniffer_cfg;
 } __packed;
 
@@ -604,15 +729,7 @@ struct wmi_cfg_rx_chain_cmd {
  * WMI_RCP_ADDBA_RESP_CMDID
  */
 struct wmi_rcp_addba_resp_cmd {
-
-	#define CIDXTID_CID_POS (0)
-	#define CIDXTID_CID_LEN (4)
-	#define CIDXTID_CID_MSK (0xF)
-	#define CIDXTID_TID_POS (4)
-	#define CIDXTID_TID_LEN (4)
-	#define CIDXTID_TID_MSK (0xF0)
 	u8 cidxtid;
-
 	u8 dialog_token;
 	__le16 status_code;
 	__le16 ba_param_set;	/* ieee80211_ba_parameterset field to send */
@@ -623,15 +740,7 @@ struct wmi_rcp_addba_resp_cmd {
  * WMI_RCP_DELBA_CMDID
  */
 struct wmi_rcp_delba_cmd {
-
-	#define CIDXTID_CID_POS (0)
-	#define CIDXTID_CID_LEN (4)
-	#define CIDXTID_CID_MSK (0xF)
-	#define CIDXTID_TID_POS (4)
-	#define CIDXTID_TID_LEN (4)
-	#define CIDXTID_TID_MSK (0xF0)
 	u8 cidxtid;
-
 	u8 reserved;
 	__le16 reason;
 } __packed;
@@ -640,15 +749,7 @@ struct wmi_rcp_delba_cmd {
  * WMI_RCP_ADDBA_REQ_CMDID
  */
 struct wmi_rcp_addba_req_cmd {
-
-	#define CIDXTID_CID_POS (0)
-	#define CIDXTID_CID_LEN (4)
-	#define CIDXTID_CID_MSK (0xF)
-	#define CIDXTID_TID_POS (4)
-	#define CIDXTID_TID_LEN (4)
-	#define CIDXTID_TID_MSK (0xF0)
 	u8 cidxtid;
-
 	u8 dialog_token;
 	/* ieee80211_ba_parameterset field as it received */
 	__le16 ba_param_set;
@@ -665,7 +766,6 @@ struct wmi_set_mac_address_cmd {
 	u8 reserved[2];
 } __packed;
 
-
 /*
 * WMI_EAPOL_TX_CMDID
 */
@@ -692,6 +792,17 @@ struct wmi_echo_cmd {
 } __packed;
 
 /*
+ * WMI_TEMP_SENSE_CMDID
+ *
+ * Measure MAC and radio temperatures
+ */
+struct wmi_temp_sense_cmd {
+	__le32 measure_marlon_m_en;
+	__le32 measure_marlon_r_en;
+} __packed;
+
+
+/*
  * WMI Events
  */
 
@@ -699,7 +810,6 @@ struct wmi_echo_cmd {
  * List of Events (target to host)
  */
 enum wmi_event_id {
-	WMI_IMM_RSP_EVENTID			= 0x0000,
 	WMI_READY_EVENTID			= 0x1001,
 	WMI_CONNECT_EVENTID			= 0x1002,
 	WMI_DISCONNECT_EVENTID			= 0x1003,
@@ -709,13 +819,9 @@ enum wmi_event_id {
 	WMI_FW_READY_EVENTID			= 0x1801,
 	WMI_EXIT_FAST_MEM_ACC_MODE_EVENTID	= 0x0200,
 	WMI_ECHO_RSP_EVENTID			= 0x1803,
-	WMI_CONFIG_MAC_DONE_EVENTID		= 0x1805,
-	WMI_CONFIG_PHY_DEBUG_DONE_EVENTID	= 0x1806,
-	WMI_ADD_STATION_DONE_EVENTID		= 0x1807,
-	WMI_ADD_DEBUG_TX_PCKT_DONE_EVENTID	= 0x1808,
-	WMI_PHY_GET_STATISTICS_EVENTID		= 0x1809,
 	WMI_FS_TUNE_DONE_EVENTID		= 0x180a,
-	WMI_CORR_MEASURE_DONE_EVENTID		= 0x180b,
+	WMI_CORR_MEASURE_EVENTID		= 0x180b,
+	WMI_READ_RSSI_EVENTID			= 0x180c,
 	WMI_TEMP_SENSE_DONE_EVENTID		= 0x180e,
 	WMI_DC_CALIB_DONE_EVENTID		= 0x180f,
 	WMI_IQ_TX_CALIB_DONE_EVENTID		= 0x1811,
@@ -727,10 +833,9 @@ enum wmi_event_id {
 	WMI_MARLON_R_WRITE_DONE_EVENTID		= 0x1819,
 	WMI_MARLON_R_TXRX_SEL_DONE_EVENTID	= 0x181a,
 	WMI_SILENT_RSSI_CALIB_DONE_EVENTID	= 0x181d,
-
+	WMI_RF_RX_TEST_DONE_EVENTID		= 0x181e,
 	WMI_CFG_RX_CHAIN_DONE_EVENTID		= 0x1820,
 	WMI_VRING_CFG_DONE_EVENTID		= 0x1821,
-	WMI_RX_ON_DONE_EVENTID			= 0x1822,
 	WMI_BA_STATUS_EVENTID			= 0x1823,
 	WMI_RCP_ADDBA_REQ_EVENTID		= 0x1824,
 	WMI_ADDBA_RESP_SENT_EVENTID		= 0x1825,
@@ -738,7 +843,6 @@ enum wmi_event_id {
 	WMI_GET_SSID_EVENTID			= 0x1828,
 	WMI_GET_PCP_CHANNEL_EVENTID		= 0x182a,
 	WMI_SW_TX_COMPLETE_EVENTID		= 0x182b,
-	WMI_RX_OFF_DONE_EVENTID			= 0x182c,
 
 	WMI_READ_MAC_RXQ_EVENTID		= 0x1830,
 	WMI_READ_MAC_TXQ_EVENTID		= 0x1831,
@@ -765,7 +869,16 @@ enum wmi_event_id {
 	WMI_UNIT_TEST_EVENTID			= 0x1900,
 	WMI_FLASH_READ_DONE_EVENTID		= 0x1902,
 	WMI_FLASH_WRITE_DONE_EVENTID		= 0x1903,
-
+	/*P2P*/
+	WMI_PORT_ALLOCATED_EVENTID		= 0x1911,
+	WMI_PORT_DELETED_EVENTID		= 0x1912,
+	WMI_LISTEN_STARTED_EVENTID		= 0x1914,
+	WMI_SEARCH_STARTED_EVENTID		= 0x1915,
+	WMI_DISCOVERY_STARTED_EVENTID		= 0x1916,
+	WMI_DISCOVERY_STOPPED_EVENTID		= 0x1917,
+	WMI_PCP_STARTED_EVENTID			= 0x1918,
+	WMI_PCP_STOPPED_EVENTID			= 0x1919,
+	WMI_PCP_FACTOR_EVENTID			= 0x191a,
 	WMI_SET_CHANNEL_EVENTID			= 0x9000,
 	WMI_ASSOC_REQ_EVENTID			= 0x9001,
 	WMI_EAPOL_RX_EVENTID			= 0x9002,
@@ -777,6 +890,12 @@ enum wmi_event_id {
  * Events data structures
  */
 
+
+enum wmi_fw_status {
+	WMI_FW_STATUS_SUCCESS,
+	WMI_FW_STATUS_FAILURE,
+};
+
 /*
  * WMI_RF_MGMT_STATUS_EVENTID
  */
@@ -857,7 +976,7 @@ struct wmi_ready_event {
 	__le32 abi_version;
 	u8 mac[WMI_MAC_LEN];
 	u8 phy_capability;		/* enum wmi_phy_capability */
-	u8 reserved;
+	u8 numof_additional_mids;
 } __packed;
 
 /*
@@ -876,6 +995,8 @@ struct wmi_notify_req_done_event {
 	__le16 other_rx_sector;
 	__le16 other_tx_sector;
 	__le16 range;
+	u8 sqi;
+	u8 reserved[3];
 } __packed;
 
 /*
@@ -951,27 +1072,15 @@ struct wmi_vring_ba_status_event {
  * WMI_DELBA_EVENTID
  */
 struct wmi_delba_event {
-
-	#define CIDXTID_CID_POS (0)
-	#define CIDXTID_CID_LEN (4)
-	#define CIDXTID_CID_MSK (0xF)
-	#define CIDXTID_TID_POS (4)
-	#define CIDXTID_TID_LEN (4)
-	#define CIDXTID_TID_MSK (0xF0)
 	u8 cidxtid;
-
 	u8 from_initiator;
 	__le16 reason;
 } __packed;
 
+
 /*
  * WMI_VRING_CFG_DONE_EVENTID
  */
-enum wmi_vring_cfg_done_event_status {
-	WMI_VRING_CFG_SUCCESS		= 0,
-	WMI_VRING_CFG_FAILURE		= 1,
-};
-
 struct wmi_vring_cfg_done_event {
 	u8 ringid;
 	u8 status;
@@ -982,21 +1091,8 @@ struct wmi_vring_cfg_done_event {
 /*
  * WMI_ADDBA_RESP_SENT_EVENTID
  */
-enum wmi_rcp_addba_resp_sent_event_status {
-	WMI_ADDBA_SUCCESS		= 0,
-	WMI_ADDBA_FAIL			= 1,
-};
-
 struct wmi_rcp_addba_resp_sent_event {
-
-	#define CIDXTID_CID_POS (0)
-	#define CIDXTID_CID_LEN (4)
-	#define CIDXTID_CID_MSK (0xF)
-	#define CIDXTID_TID_POS (4)
-	#define CIDXTID_TID_LEN (4)
-	#define CIDXTID_TID_MSK (0xF0)
 	u8 cidxtid;
-
 	u8 reserved;
 	__le16 status;
 } __packed;
@@ -1005,15 +1101,7 @@ struct wmi_rcp_addba_resp_sent_event {
  * WMI_RCP_ADDBA_REQ_EVENTID
  */
 struct wmi_rcp_addba_req_event {
-
-	#define CIDXTID_CID_POS (0)
-	#define CIDXTID_CID_LEN (4)
-	#define CIDXTID_CID_MSK (0xF)
-	#define CIDXTID_TID_POS (4)
-	#define CIDXTID_TID_LEN (4)
-	#define CIDXTID_TID_MSK (0xF0)
 	u8 cidxtid;
-
 	u8 dialog_token;
 	__le16 ba_param_set;	/* ieee80211_ba_parameterset as it received */
 	__le16 ba_timeout;
@@ -1055,6 +1143,7 @@ struct wmi_data_port_open_event {
 	u8 reserved[3];
 } __packed;
 
+
 /*
  * WMI_GET_PCP_CHANNEL_EVENTID
  */
@@ -1063,6 +1152,54 @@ struct wmi_get_pcp_channel_event {
 	u8 reserved[3];
 } __packed;
 
+
+/*
+* WMI_PORT_ALLOCATED_EVENTID
+*/
+struct wmi_port_allocated_event {
+	u8 status;	/* wmi_fw_status */
+	u8 reserved[3];
+} __packed;
+
+/*
+* WMI_PORT_DELETED_EVENTID
+*/
+struct wmi_port_deleted_event {
+	u8 status;	/* wmi_fw_status */
+	u8 reserved[3];
+} __packed;
+
+/*
+ * WMI_LISTEN_STARTED_EVENTID
+ */
+struct wmi_listen_started_event {
+	u8 status;	/* wmi_fw_status */
+	u8 reserved[3];
+} __packed;
+
+/*
+ * WMI_SEARCH_STARTED_EVENTID
+ */
+struct wmi_search_started_event {
+	u8 status;	/* wmi_fw_status */
+	u8 reserved[3];
+} __packed;
+
+/*
+ * WMI_PCP_STARTED_EVENTID
+ */
+struct wmi_pcp_started_event {
+	u8 status;	/* wmi_fw_status */
+	u8 reserved[3];
+} __packed;
+
+/*
+ * WMI_PCP_FACTOR_EVENTID
+ */
+struct wmi_pcp_factor_event {
+	__le32 pcp_factor;
+} __packed;
+
 /*
  * WMI_SW_TX_COMPLETE_EVENTID
  */
@@ -1078,6 +1215,23 @@ struct wmi_sw_tx_complete_event {
 } __packed;
 
 /*
+ * WMI_CORR_MEASURE_EVENTID
+ */
+struct wmi_corr_measure_event {
+	s32 i;
+	s32 q;
+	s32 image_i;
+	s32 image_q;
+} __packed;
+
+/*
+ * WMI_READ_RSSI_EVENTID
+ */
+struct wmi_read_rssi_event {
+	__le32 ina_rssi_adc_dbm;
+} __packed;
+
+/*
  * WMI_GET_SSID_EVENTID
  */
 struct wmi_get_ssid_event {
@@ -1091,7 +1245,8 @@ struct wmi_get_ssid_event {
 struct wmi_rx_mgmt_info {
 	u8 mcs;
 	s8 snr;
-	__le16 range;
+	u8 range;
+	u8 sqi;
 	__le16 stype;
 	__le16 status;
 	__le32 len;
@@ -1113,4 +1268,14 @@ struct wmi_echo_event {
 	__le32 echoed_value;
 } __packed;
 
+/*
+ * WMI_TEMP_SENSE_DONE_EVENTID
+ *
+ * Measure MAC and radio temperatures
+ */
+struct wmi_temp_sense_done_event {
+	__le32 marlon_m_t1000;
+	__le32 marlon_r_t1000;
+} __packed;
+
 #endif /* __WILOCITY_WMI_H__ */
-- 
1.7.10.4

