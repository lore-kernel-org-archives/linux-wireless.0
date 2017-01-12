Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57758 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751674AbdALNPR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 08:15:17 -0500
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2 02/13] wil6210: add disable_ap_sme module parameter
Date: Thu, 12 Jan 2017 15:05:54 +0200
Message-Id: <1484226365-10433-3-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170112_141634_523627_B9705357)
In-Reply-To: <1484226365-10433-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1484226365-10433-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <qca_dlansky@qca.qualcomm.com>

By default, AP SME is handled by driver/FW.
In case disable_ap_sme is true, driver doesn't turn-on
WIPHY_FLAG_HAVE_AP_SME and the responsibility for
AP SME is passed to user space.

With AP SME disabled, driver reports assoc request frame
to user space which is then responsible for sending assoc
response frame and for sending NL80211_CMD_NEW_STATION.
Driver also reports disassoc frame to user space
which should then send NL80211_CMD_DEL_STATION.

NL80211_CMD_SET_STATION with NL80211_STA_FLAG_AUTHORIZED
is used by user space to allow/disallow data transmit.

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 92 +++++++++++++++++++++++++++--
 drivers/net/wireless/ath/wil6210/main.c     | 10 +++-
 drivers/net/wireless/ath/wil6210/wil6210.h  |  9 ++-
 drivers/net/wireless/ath/wil6210/wmi.c      | 68 +++++++++++++++++----
 drivers/net/wireless/ath/wil6210/wmi.h      | 23 +++++++-
 5 files changed, 178 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 54dd116..e6001bb 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2016 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -20,6 +20,10 @@
 
 #define WIL_MAX_ROC_DURATION_MS 5000
 
+bool disable_ap_sme;
+module_param(disable_ap_sme, bool, S_IRUGO);
+MODULE_PARM_DESC(disable_ap_sme, " let user space handle AP mode SME");
+
 #define CHAN60G(_channel, _flags) {				\
 	.band			= NL80211_BAND_60GHZ,		\
 	.center_freq		= 56160 + (2160 * (_channel)),	\
@@ -62,9 +66,16 @@
 	},
 	[NL80211_IFTYPE_AP] = {
 		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
-		BIT(IEEE80211_STYPE_PROBE_RESP >> 4),
+		BIT(IEEE80211_STYPE_PROBE_RESP >> 4) |
+		BIT(IEEE80211_STYPE_ASSOC_RESP >> 4) |
+		BIT(IEEE80211_STYPE_DISASSOC >> 4),
 		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
-		BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+		BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
+		BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
+		BIT(IEEE80211_STYPE_DISASSOC >> 4) |
+		BIT(IEEE80211_STYPE_AUTH >> 4) |
+		BIT(IEEE80211_STYPE_DEAUTH >> 4) |
+		BIT(IEEE80211_STYPE_REASSOC_REQ >> 4)
 	},
 	[NL80211_IFTYPE_P2P_CLIENT] = {
 		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
@@ -1322,6 +1333,28 @@ static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
 	return 0;
 }
 
+static int wil_cfg80211_add_station(struct wiphy *wiphy,
+				    struct net_device *dev,
+				    const u8 *mac,
+				    struct station_parameters *params)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_dbg_misc(wil, "add station %pM aid %d\n", mac, params->aid);
+
+	if (!disable_ap_sme) {
+		wil_err(wil, "not supported with AP SME enabled\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (params->aid > WIL_MAX_DMG_AID) {
+		wil_err(wil, "invalid aid\n");
+		return -EINVAL;
+	}
+
+	return wmi_new_sta(wil, mac, params->aid);
+}
+
 static int wil_cfg80211_del_station(struct wiphy *wiphy,
 				    struct net_device *dev,
 				    struct station_del_parameters *params)
@@ -1338,6 +1371,52 @@ static int wil_cfg80211_del_station(struct wiphy *wiphy,
 	return 0;
 }
 
+static int wil_cfg80211_change_station(struct wiphy *wiphy,
+				       struct net_device *dev,
+				       const u8 *mac,
+				       struct station_parameters *params)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	int authorize;
+	int cid, i;
+	struct vring_tx_data *txdata = NULL;
+
+	wil_dbg_misc(wil, "change station %pM mask 0x%x set 0x%x\n", mac,
+		     params->sta_flags_mask, params->sta_flags_set);
+
+	if (!disable_ap_sme) {
+		wil_dbg_misc(wil, "not supported with AP SME enabled\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (!(params->sta_flags_mask & BIT(NL80211_STA_FLAG_AUTHORIZED)))
+		return 0;
+
+	cid = wil_find_cid(wil, mac);
+	if (cid < 0) {
+		wil_err(wil, "station not found\n");
+		return -ENOLINK;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(wil->vring2cid_tid); i++)
+		if (wil->vring2cid_tid[i][0] == cid) {
+			txdata = &wil->vring_tx_data[i];
+			break;
+		}
+
+	if (!txdata) {
+		wil_err(wil, "vring data not found\n");
+		return -ENOLINK;
+	}
+
+	authorize = params->sta_flags_set & BIT(NL80211_STA_FLAG_AUTHORIZED);
+	txdata->dot1x_open = authorize ? 1 : 0;
+	wil_dbg_misc(wil, "cid %d vring %d authorize %d\n", cid, i,
+		     txdata->dot1x_open);
+
+	return 0;
+}
+
 /* probe_client handling */
 static void wil_probe_client_handle(struct wil6210_priv *wil,
 				    struct wil_probe_client_req *req)
@@ -1521,7 +1600,9 @@ static int wil_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 	.change_beacon = wil_cfg80211_change_beacon,
 	.start_ap = wil_cfg80211_start_ap,
 	.stop_ap = wil_cfg80211_stop_ap,
+	.add_station = wil_cfg80211_add_station,
 	.del_station = wil_cfg80211_del_station,
+	.change_station = wil_cfg80211_change_station,
 	.probe_client = wil_cfg80211_probe_client,
 	.change_bss = wil_cfg80211_change_bss,
 	/* P2P device */
@@ -1542,10 +1623,11 @@ static void wil_wiphy_init(struct wiphy *wiphy)
 				 BIT(NL80211_IFTYPE_P2P_GO) |
 				 BIT(NL80211_IFTYPE_P2P_DEVICE) |
 				 BIT(NL80211_IFTYPE_MONITOR);
-	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME |
-			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
+	wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
 			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD |
 			WIPHY_FLAG_PS_ON_BY_DEFAULT;
+	if (!disable_ap_sme)
+		wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME;
 	dev_dbg(wiphy_dev(wiphy), "%s : flags = 0x%08x\n",
 		__func__, wiphy->flags);
 	wiphy->probe_resp_offload =
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index e2e021b..57c19d0 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2016 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -176,8 +176,12 @@ static void wil_disconnect_cid(struct wil6210_priv *wil, int cid,
 		     sta->status);
 	/* inform upper/lower layers */
 	if (sta->status != wil_sta_unused) {
-		if (!from_event)
-			wmi_disconnect_sta(wil, sta->addr, reason_code, true);
+		if (!from_event) {
+			bool del_sta = (wdev->iftype == NL80211_IFTYPE_AP) ?
+						disable_ap_sme : false;
+			wmi_disconnect_sta(wil, sta->addr, reason_code,
+					   true, del_sta);
+		}
 
 		switch (wdev->iftype) {
 		case NL80211_IFTYPE_AP:
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 07d4f76..1cd92c6 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -33,6 +33,7 @@
 extern u32 vring_idle_trsh;
 extern bool rx_align_2;
 extern bool debug_fw;
+extern bool disable_ap_sme;
 
 #define WIL_NAME "wil6210"
 #define WIL_FW_NAME "wil6210.fw" /* code */
@@ -98,6 +99,9 @@ static inline u32 wil_mtu2macbuf(u32 mtu)
 #define WIL6210_RX_HIGH_TRSH_INIT		(0)
 #define WIL6210_RX_HIGH_TRSH_DEFAULT \
 				(1 << (WIL_RX_RING_SIZE_ORDER_DEFAULT - 3))
+#define WIL_MAX_DMG_AID 254 /* for DMG only 1-254 allowed (see
+			     * 802.11REVmc/D5.0, section 9.4.1.8)
+			     */
 /* Hardware definitions begin */
 
 /*
@@ -816,8 +820,8 @@ int wmi_add_cipher_key(struct wil6210_priv *wil, u8 key_index,
 int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring);
 int wmi_rxon(struct wil6210_priv *wil, bool on);
 int wmi_get_temperature(struct wil6210_priv *wil, u32 *t_m, u32 *t_r);
-int wmi_disconnect_sta(struct wil6210_priv *wil, const u8 *mac, u16 reason,
-		       bool full_disconnect);
+int wmi_disconnect_sta(struct wil6210_priv *wil, const u8 *mac,
+		       u16 reason, bool full_disconnect, bool del_sta);
 int wmi_addba(struct wil6210_priv *wil, u8 ringid, u8 size, u16 timeout);
 int wmi_delba_tx(struct wil6210_priv *wil, u8 ringid, u16 reason);
 int wmi_delba_rx(struct wil6210_priv *wil, u8 cidxtid, u16 reason);
@@ -827,6 +831,7 @@ int wmi_ps_dev_profile_cfg(struct wil6210_priv *wil,
 			   enum wmi_ps_profile_type ps_profile);
 int wmi_set_mgmt_retry(struct wil6210_priv *wil, u8 retry_short);
 int wmi_get_mgmt_retry(struct wil6210_priv *wil, u8 *retry_short);
+int wmi_new_sta(struct wil6210_priv *wil, const u8 *mac, u8 aid);
 int wil_addba_rx_request(struct wil6210_priv *wil, u8 cidxtid,
 			 u8 dialog_token, __le16 ba_param_set,
 			 __le16 ba_timeout, __le16 ba_seq_ctrl);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 7585003..556acd3 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2016 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -556,7 +556,7 @@ static void wmi_evt_connect(struct wil6210_priv *wil, int id, void *d, int len)
 		wil_err(wil, "%s: config tx vring failed for CID %d, rc (%d)\n",
 			__func__, evt->cid, rc);
 		wmi_disconnect_sta(wil, wil->sta[evt->cid].addr,
-				   WLAN_REASON_UNSPECIFIED, false);
+				   WLAN_REASON_UNSPECIFIED, false, false);
 	} else {
 		wil_info(wil, "%s: successful connection to CID %d\n",
 			 __func__, evt->cid);
@@ -583,8 +583,12 @@ static void wmi_evt_connect(struct wil6210_priv *wil, int id, void *d, int len)
 		}
 	} else if ((wdev->iftype == NL80211_IFTYPE_AP) ||
 		   (wdev->iftype == NL80211_IFTYPE_P2P_GO)) {
-		if (rc)
+		if (rc) {
+			if (disable_ap_sme)
+				/* notify new_sta has failed */
+				cfg80211_del_sta(ndev, evt->bssid, GFP_KERNEL);
 			goto out;
+		}
 
 		memset(&sinfo, 0, sizeof(sinfo));
 
@@ -687,6 +691,7 @@ static void wmi_evt_vring_en(struct wil6210_priv *wil, int id, void *d, int len)
 {
 	struct wmi_vring_en_event *evt = d;
 	u8 vri = evt->vring_index;
+	struct wireless_dev *wdev = wil_to_wdev(wil);
 
 	wil_dbg_wmi(wil, "Enable vring %d\n", vri);
 
@@ -694,7 +699,12 @@ static void wmi_evt_vring_en(struct wil6210_priv *wil, int id, void *d, int len)
 		wil_err(wil, "Enable for invalid vring %d\n", vri);
 		return;
 	}
-	wil->vring_tx_data[vri].dot1x_open = true;
+
+	if (wdev->iftype != NL80211_IFTYPE_AP || !disable_ap_sme)
+		/* in AP mode with disable_ap_sme, this is done by
+		 * wil_cfg80211_change_station()
+		 */
+		wil->vring_tx_data[vri].dot1x_open = true;
 	if (vri == wil->bcast_vring) /* no BA for bcast */
 		return;
 	if (agg_wsize >= 0)
@@ -1069,6 +1079,7 @@ int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype,
 		.pcp_max_assoc_sta = max_assoc_sta,
 		.hidden_ssid = hidden_ssid,
 		.is_go = is_go,
+		.disable_ap_sme = disable_ap_sme,
 	};
 	struct {
 		struct wmi_cmd_hdr wmi;
@@ -1086,6 +1097,13 @@ int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype,
 		cmd.pcp_max_assoc_sta = WIL6210_MAX_CID;
 	}
 
+	if (disable_ap_sme &&
+	    !test_bit(WMI_FW_CAPABILITY_DISABLE_AP_SME,
+		      wil->fw_capabilities)) {
+		wil_err(wil, "disable_ap_sme not supported by FW\n");
+		return -EOPNOTSUPP;
+	}
+
 	/*
 	 * Processing time may be huge, in case of secure AP it takes about
 	 * 3500ms for FW to start AP
@@ -1456,12 +1474,15 @@ int wmi_get_temperature(struct wil6210_priv *wil, u32 *t_bb, u32 *t_rf)
 	return 0;
 }
 
-int wmi_disconnect_sta(struct wil6210_priv *wil, const u8 *mac, u16 reason,
-		       bool full_disconnect)
+int wmi_disconnect_sta(struct wil6210_priv *wil, const u8 *mac,
+		       u16 reason, bool full_disconnect, bool del_sta)
 {
 	int rc;
 	u16 reason_code;
-	struct wmi_disconnect_sta_cmd cmd = {
+	struct wmi_disconnect_sta_cmd disc_sta_cmd = {
+		.disconnect_reason = cpu_to_le16(reason),
+	};
+	struct wmi_del_sta_cmd del_sta_cmd = {
 		.disconnect_reason = cpu_to_le16(reason),
 	};
 	struct {
@@ -1469,12 +1490,19 @@ int wmi_disconnect_sta(struct wil6210_priv *wil, const u8 *mac, u16 reason,
 		struct wmi_disconnect_event evt;
 	} __packed reply;
 
-	ether_addr_copy(cmd.dst_mac, mac);
-
 	wil_dbg_wmi(wil, "%s(%pM, reason %d)\n", __func__, mac, reason);
 
-	rc = wmi_call(wil, WMI_DISCONNECT_STA_CMDID, &cmd, sizeof(cmd),
-		      WMI_DISCONNECT_EVENTID, &reply, sizeof(reply), 1000);
+	if (del_sta) {
+		ether_addr_copy(del_sta_cmd.dst_mac, mac);
+		rc = wmi_call(wil, WMI_DEL_STA_CMDID, &del_sta_cmd,
+			      sizeof(del_sta_cmd), WMI_DISCONNECT_EVENTID,
+			      &reply, sizeof(reply), 1000);
+	} else {
+		ether_addr_copy(disc_sta_cmd.dst_mac, mac);
+		rc = wmi_call(wil, WMI_DISCONNECT_STA_CMDID, &disc_sta_cmd,
+			      sizeof(disc_sta_cmd), WMI_DISCONNECT_EVENTID,
+			      &reply, sizeof(reply), 1000);
+	}
 	/* failure to disconnect in reasonable time treated as FW error */
 	if (rc) {
 		wil_fw_error_recovery(wil);
@@ -1686,6 +1714,24 @@ int wmi_abort_scan(struct wil6210_priv *wil)
 	return rc;
 }
 
+int wmi_new_sta(struct wil6210_priv *wil, const u8 *mac, u8 aid)
+{
+	int rc;
+	struct wmi_new_sta_cmd cmd = {
+		.aid = aid,
+	};
+
+	wil_dbg_wmi(wil, "new sta %pM, aid %d\n", mac, aid);
+
+	ether_addr_copy(cmd.dst_mac, mac);
+
+	rc = wmi_send(wil, WMI_NEW_STA_CMDID, &cmd, sizeof(cmd));
+	if (rc)
+		wil_err(wil, "Failed to send new sta (%d)\n", rc);
+
+	return rc;
+}
+
 void wmi_event_flush(struct wil6210_priv *wil)
 {
 	struct pending_wmi_event *evt, *t;
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index d93a4d4..9c4a0bd 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2016 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
  * Copyright (c) 2006-2012 Wilocity
  *
  * Permission to use, copy, modify, and/or distribute this software for any
@@ -56,6 +56,7 @@ enum wmi_fw_capability {
 	WMI_FW_CAPABILITY_PS_CONFIG		= 1,
 	WMI_FW_CAPABILITY_RF_SECTORS		= 2,
 	WMI_FW_CAPABILITY_MGMT_RETRY_LIMIT	= 3,
+	WMI_FW_CAPABILITY_DISABLE_AP_SME	= 4,
 	WMI_FW_CAPABILITY_MAX,
 };
 
@@ -187,6 +188,8 @@ enum wmi_command_id {
 	WMI_AOA_MEAS_CMDID				= 0x923,
 	WMI_SET_MGMT_RETRY_LIMIT_CMDID			= 0x930,
 	WMI_GET_MGMT_RETRY_LIMIT_CMDID			= 0x931,
+	WMI_NEW_STA_CMDID				= 0x935,
+	WMI_DEL_STA_CMDID				= 0x936,
 	WMI_TOF_SESSION_START_CMDID			= 0x991,
 	WMI_TOF_GET_CAPABILITIES_CMDID			= 0x992,
 	WMI_TOF_SET_LCR_CMDID				= 0x993,
@@ -543,7 +546,8 @@ struct wmi_pcp_start_cmd {
 	u8 pcp_max_assoc_sta;
 	u8 hidden_ssid;
 	u8 is_go;
-	u8 reserved0[7];
+	u8 reserved0[6];
+	u8 disable_ap_sme;
 	u8 network_type;
 	u8 channel;
 	u8 disable_sec_offload;
@@ -902,6 +906,18 @@ struct wmi_set_mgmt_retry_limit_cmd {
 	u8 reserved[3];
 } __packed;
 
+/* WMI_NEW_STA_CMDID */
+struct wmi_new_sta_cmd {
+	u8 dst_mac[WMI_MAC_LEN];
+	u8 aid;
+} __packed;
+
+/* WMI_DEL_STA_CMDID */
+struct wmi_del_sta_cmd {
+	u8 dst_mac[WMI_MAC_LEN];
+	__le16 disconnect_reason;
+} __packed;
+
 enum wmi_tof_burst_duration {
 	WMI_TOF_BURST_DURATION_250_USEC		= 2,
 	WMI_TOF_BURST_DURATION_500_USEC		= 3,
@@ -1292,7 +1308,7 @@ struct wmi_connect_event {
 	u8 assoc_info[0];
 } __packed;
 
-/* WMI_DISCONNECT_EVENTID */
+/* disconnect_reason */
 enum wmi_disconnect_reason {
 	WMI_DIS_REASON_NO_NETWORK_AVAIL		= 0x01,
 	/* bmiss */
@@ -1310,6 +1326,7 @@ enum wmi_disconnect_reason {
 	WMI_DIS_REASON_IBSS_MERGE		= 0x0E,
 };
 
+/* WMI_DISCONNECT_EVENTID */
 struct wmi_disconnect_event {
 	/* reason code, see 802.11 spec. */
 	__le16 protocol_reason_status;
-- 
1.9.1
