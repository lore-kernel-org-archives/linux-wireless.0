Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:7538 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbaDHIgt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 04:36:49 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 3/5] wil6210: sync with the latest FW API
Date: Tue, 8 Apr 2014 11:36:17 +0300
Message-ID: <1396946179-11677-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140408_103708_885232_1B318EEC)
In-Reply-To: <1396946179-11677-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1396946179-11677-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- add pcp_max_assoc_sta to the struct wmi_pcp_start_cmd
- enum for the scan ststus

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c |  3 +-
 drivers/net/wireless/ath/wil6210/wmi.h | 50 +++++++++++++++++++++-------------
 2 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index b7764f3..e9a11cb 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -348,7 +348,7 @@ static void wmi_evt_scan_complete(struct wil6210_priv *wil, int id,
 {
 	if (wil->scan_request) {
 		struct wmi_scan_complete_event *data = d;
-		bool aborted = (data->status != 0);
+		bool aborted = (data->status != WMI_SCAN_SUCCESS);
 
 		wil_dbg_wmi(wil, "SCAN_COMPLETE(0x%08x)\n", data->status);
 		cfg80211_scan_done(wil->scan_request, aborted);
@@ -802,6 +802,7 @@ int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype, u8 chan)
 		.network_type = wmi_nettype,
 		.disable_sec_offload = 1,
 		.channel = chan - 1,
+		.pcp_max_assoc_sta = WIL6210_MAX_CID,
 	};
 	struct {
 		struct wil6210_mbox_hdr_wmi wmi;
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index 50b8528..17334c8 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -28,7 +28,7 @@
 #define __WILOCITY_WMI_H__
 
 /* General */
-
+#define WILOCITY_MAX_ASSOC_STA (8)
 #define WMI_MAC_LEN		(6)
 #define WMI_PROX_RANGE_NUM	(3)
 
@@ -219,15 +219,6 @@ struct wmi_disconnect_sta_cmd {
 	__le16 disconnect_reason;
 } __packed;
 
-/*
- * WMI_RECONNECT_CMDID
- */
-struct wmi_reconnect_cmd {
-	u8 channel;			/* hint */
-	u8 reserved;
-	u8 bssid[WMI_MAC_LEN];		/* mandatory if set */
-} __packed;
-
 
 /*
  * WMI_SET_PMK_CMDID
@@ -296,11 +287,13 @@ enum wmi_scan_type {
 	WMI_LONG_SCAN		= 0,
 	WMI_SHORT_SCAN		= 1,
 	WMI_PBC_SCAN		= 2,
+	WMI_ACTIVE_SCAN		= 3,
+	WMI_DIRECT_SCAN		= 4,
 };
 
 struct wmi_start_scan_cmd {
-	u8 reserved[8];
-
+	u8 direct_scan_mac_addr[6];
+	u8 reserved[2];
 	__le32 home_dwell_time;	/* Max duration in the home channel(ms) */
 	__le32 force_scan_interval;	/* Time interval between scans (ms)*/
 	u8 scan_type;		/* wmi_scan_type */
@@ -332,6 +325,7 @@ struct wmi_probed_ssid_cmd {
 	u8 ssid[WMI_MAX_SSID_LEN];
 } __packed;
 
+
 /*
  * WMI_SET_APPIE_CMDID
  * Add Application specified IE to a management frame
@@ -427,7 +421,7 @@ struct wmi_bcon_ctrl_cmd {
 	__le16 frag_num;
 	__le64 ss_mask;
 	u8 network_type;
-	u8 reserved;
+	u8 pcp_max_assoc_sta;
 	u8 disable_sec_offload;
 	u8 disable_sec;
 } __packed;
@@ -450,7 +444,7 @@ enum wmi_port_role {
 struct wmi_port_allocate_cmd {
 	u8 mac[WMI_MAC_LEN];
 	u8 port_role;
-	u8 midid;
+	u8 mid;
 } __packed;
 
 /*
@@ -467,6 +461,7 @@ struct wmi_delete_port_cmd {
 enum wmi_discovery_mode {
 	WMI_DISCOVERY_MODE_NON_OFFLOAD	= 0,
 	WMI_DISCOVERY_MODE_OFFLOAD	= 1,
+	WMI_DISCOVERY_MODE_PEER2PEER	= 2,
 };
 
 struct wmi_p2p_cfg_cmd {
@@ -493,7 +488,8 @@ struct wmi_power_mgmt_cfg_cmd {
  */
 struct wmi_pcp_start_cmd {
 	__le16 bcon_interval;
-	u8 reserved0[10];
+	u8 pcp_max_assoc_sta;
+	u8 reserved0[9];
 	u8 network_type;
 	u8 channel;
 	u8 disable_sec_offload;
@@ -857,6 +853,7 @@ enum wmi_event_id {
 	WMI_RF_MGMT_STATUS_EVENTID		= 0x1853,
 	WMI_BF_SM_MGMT_DONE_EVENTID		= 0x1838,
 	WMI_RX_MGMT_PACKET_EVENTID		= 0x1840,
+	WMI_TX_MGMT_PACKET_EVENTID		= 0x1841,
 
 	/* Performance monitoring events */
 	WMI_DATA_PORT_OPEN_EVENTID		= 0x1860,
@@ -1040,16 +1037,23 @@ enum wmi_disconnect_reason {
 struct wmi_disconnect_event {
 	__le16 protocol_reason_status;	/* reason code, see 802.11 spec. */
 	u8 bssid[WMI_MAC_LEN];		/* set if known */
-	u8 disconnect_reason;		/* see wmi_disconnect_reason_e */
-	u8 assoc_resp_len;
-	u8 assoc_info[0];
+	u8 disconnect_reason;		/* see wmi_disconnect_reason */
+	u8 assoc_resp_len;		/* not in use */
+	u8 assoc_info[0];		/* not in use */
 } __packed;
 
 /*
  * WMI_SCAN_COMPLETE_EVENTID
  */
+enum scan_status {
+	WMI_SCAN_SUCCESS	= 0,
+	WMI_SCAN_FAILED		= 1,
+	WMI_SCAN_ABORTED	= 2,
+	WMI_SCAN_REJECTED	= 3,
+};
+
 struct wmi_scan_complete_event {
-	__le32 status;
+	__le32 status;	/* scan_status */
 } __packed;
 
 /*
@@ -1256,6 +1260,14 @@ struct wmi_rx_mgmt_info {
 	u8 channel;	/* From Radio MNGR */
 } __packed;
 
+
+/*
+ * WMI_TX_MGMT_PACKET_EVENTID
+ */
+struct wmi_tx_mgmt_packet_event {
+	u8 payload[0];
+} __packed;
+
 struct wmi_rx_mgmt_packet_event {
 	struct wmi_rx_mgmt_info info;
 	u8 payload[0];
-- 
1.8.3.2

