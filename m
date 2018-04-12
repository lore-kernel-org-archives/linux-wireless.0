Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:23199 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752639AbeDLIJA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 04:09:00 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 02/10] wil6210: set/get EDMG channel through debugfs
Date: Thu, 12 Apr 2018 11:08:38 +0300
Message-Id: <1523520526-24997-3-git-send-email-merez@codeaurora.org> (sfid-20180412_100925_876350_3A0E1B75)
In-Reply-To: <1523520526-24997-1-git-send-email-merez@codeaurora.org>
References: <1523520526-24997-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>

Setting EDMG channel through debugfs for connect and PCP start
commands.

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 89 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/debugfs.c  |  1 +
 drivers/net/wireless/ath/wil6210/wil6210.h  |  4 ++
 drivers/net/wireless/ath/wil6210/wmi.c      | 25 +++++++-
 drivers/net/wireless/ath/wil6210/wmi.h      | 33 ++++++++++-
 5 files changed, 146 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index cdbb393..c2da159 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -261,6 +261,86 @@ int wil_iftype_nl2wmi(enum nl80211_iftype type)
 	return -EOPNOTSUPP;
 }
 
+int wil_spec2wmi_ch(u8 spec_ch, u8 *wmi_ch)
+{
+	switch (spec_ch) {
+	case 1:
+		*wmi_ch = WMI_CHANNEL_1;
+		break;
+	case 2:
+		*wmi_ch = WMI_CHANNEL_2;
+		break;
+	case 3:
+		*wmi_ch = WMI_CHANNEL_3;
+		break;
+	case 4:
+		*wmi_ch = WMI_CHANNEL_4;
+		break;
+	case 5:
+		*wmi_ch = WMI_CHANNEL_5;
+		break;
+	case 6:
+		*wmi_ch = WMI_CHANNEL_6;
+		break;
+	case 9:
+		*wmi_ch = WMI_CHANNEL_9;
+		break;
+	case 10:
+		*wmi_ch = WMI_CHANNEL_10;
+		break;
+	case 11:
+		*wmi_ch = WMI_CHANNEL_11;
+		break;
+	case 12:
+		*wmi_ch = WMI_CHANNEL_12;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int wil_wmi2spec_ch(u8 wmi_ch, u8 *spec_ch)
+{
+	switch (wmi_ch) {
+	case WMI_CHANNEL_1:
+		*spec_ch = 1;
+		break;
+	case WMI_CHANNEL_2:
+		*spec_ch = 2;
+		break;
+	case WMI_CHANNEL_3:
+		*spec_ch = 3;
+		break;
+	case WMI_CHANNEL_4:
+		*spec_ch = 4;
+		break;
+	case WMI_CHANNEL_5:
+		*spec_ch = 5;
+		break;
+	case WMI_CHANNEL_6:
+		*spec_ch = 6;
+		break;
+	case WMI_CHANNEL_9:
+		*spec_ch = 9;
+		break;
+	case WMI_CHANNEL_10:
+		*spec_ch = 10;
+		break;
+	case WMI_CHANNEL_11:
+		*spec_ch = 11;
+		break;
+	case WMI_CHANNEL_12:
+		*spec_ch = 12;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int wil_cid_fill_sinfo(struct wil6210_vif *vif, int cid,
 		       struct station_info *sinfo)
 {
@@ -1005,6 +1085,15 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 	}
 	conn.channel = ch - 1;
 
+	if (test_bit(WMI_FW_CAPABILITY_CHANNEL_BONDING, wil->fw_capabilities))
+		if (wil->force_edmg_channel) {
+			rc = wil_spec2wmi_ch(wil->force_edmg_channel,
+					     &conn.edmg_channel);
+			if (rc)
+				wil_err(wil, "wmi channel for channel %d not found",
+					wil->force_edmg_channel);
+		}
+
 	ether_addr_copy(conn.bssid, bss->bssid);
 	ether_addr_copy(conn.dst_mac, bss->bssid);
 
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 8c90b31..10ffa4d 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1852,6 +1852,7 @@ static void wil6210_debugfs_init_isr(struct wil6210_priv *wil,
 	WIL_FIELD(abft_len, 0644,		doff_u8),
 	WIL_FIELD(wakeup_trigger, 0644,		doff_u8),
 	WIL_FIELD(vring_idle_trsh, 0644,	doff_u32),
+	WIL_FIELD(force_edmg_channel, 0644,	doff_u8),
 	{},
 };
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index f9c5155..c765ff2 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -791,6 +791,7 @@ struct wil6210_priv {
 	u8 wakeup_trigger;
 	struct wil_suspend_stats suspend_stats;
 	struct wil_debugfs_data dbg_data;
+	u8 force_edmg_channel;
 
 	void *platform_handle;
 	struct wil_platform_ops platform_ops;
@@ -1151,4 +1152,7 @@ int wmi_start_sched_scan(struct wil6210_priv *wil,
 			 struct cfg80211_sched_scan_request *request);
 int wmi_stop_sched_scan(struct wil6210_priv *wil);
 
+int wil_wmi2spec_ch(u8 wmi_ch, u8 *spec_ch);
+int wil_spec2wmi_ch(u8 spec_ch, u8 *wmi_ch);
+
 #endif /* __WIL6210_H__ */
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index a3dda9a..062ead3 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -823,7 +823,8 @@ static void wmi_evt_connect(struct wil6210_vif *vif, int id, void *d, int len)
 	struct net_device *ndev = vif_to_ndev(vif);
 	struct wireless_dev *wdev = vif_to_wdev(vif);
 	struct wmi_connect_event *evt = d;
-	int ch; /* channel number */
+	int ch; /* channel number (primary) */
+	u8 spec_ch = 0; /* spec channel number */
 	struct station_info sinfo;
 	u8 *assoc_req_ie, *assoc_resp_ie;
 	size_t assoc_req_ielen, assoc_resp_ielen;
@@ -851,8 +852,17 @@ static void wmi_evt_connect(struct wil6210_vif *vif, int id, void *d, int len)
 	}
 
 	ch = evt->channel + 1;
-	wil_info(wil, "Connect %pM channel [%d] cid %d aid %d\n",
-		 evt->bssid, ch, evt->cid, evt->aid);
+
+	if (evt->edmg_channel &&
+	    test_bit(WMI_FW_CAPABILITY_CHANNEL_BONDING, wil->fw_capabilities))
+		wil_wmi2spec_ch(evt->edmg_channel, &spec_ch);
+	if (spec_ch)
+		wil_info(wil, "Connect %pM EDMG channel [%d] primary channel [%d] cid %d aid %d\n",
+			 evt->bssid, spec_ch, ch, evt->cid, evt->aid);
+	else
+		wil_info(wil, "Connect %pM channel [%d] cid %d aid %d\n",
+			 evt->bssid, ch, evt->cid, evt->aid);
+
 	wil_hex_dump_wmi("connect AI : ", DUMP_PREFIX_OFFSET, 16, 1,
 			 evt->assoc_info, len - sizeof(*evt), true);
 
@@ -1562,6 +1572,15 @@ int wmi_pcp_start(struct wil6210_vif *vif,
 		struct wmi_pcp_started_event evt;
 	} __packed reply;
 
+	if (test_bit(WMI_FW_CAPABILITY_CHANNEL_BONDING, wil->fw_capabilities))
+		if (wil->force_edmg_channel) {
+			rc = wil_spec2wmi_ch(wil->force_edmg_channel,
+					     &cmd.edmg_channel);
+			if (rc)
+				wil_err(wil, "wmi channel for channel %d not found",
+					wil->force_edmg_channel);
+		}
+
 	if (!vif->privacy)
 		cmd.disable_sec = 1;
 
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index d3e75f0..ecd4b44 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -72,6 +72,7 @@ enum wmi_fw_capability {
 	WMI_FW_CAPABILITY_SET_SILENT_RSSI_TABLE		= 13,
 	WMI_FW_CAPABILITY_LO_POWER_CALIB_FROM_OTP	= 14,
 	WMI_FW_CAPABILITY_PNO				= 15,
+	WMI_FW_CAPABILITY_CHANNEL_BONDING		= 17,
 	WMI_FW_CAPABILITY_REF_CLOCK_CONTROL		= 18,
 	WMI_FW_CAPABILITY_MAX,
 };
@@ -284,6 +285,19 @@ enum wmi_connect_ctrl_flag_bits {
 
 #define WMI_MAX_SSID_LEN	(32)
 
+enum wmi_channel {
+	WMI_CHANNEL_1	= 0x00,
+	WMI_CHANNEL_2	= 0x01,
+	WMI_CHANNEL_3	= 0x02,
+	WMI_CHANNEL_4	= 0x03,
+	WMI_CHANNEL_5	= 0x04,
+	WMI_CHANNEL_6	= 0x05,
+	WMI_CHANNEL_9	= 0x06,
+	WMI_CHANNEL_10	= 0x07,
+	WMI_CHANNEL_11	= 0x08,
+	WMI_CHANNEL_12	= 0x09,
+};
+
 /* WMI_CONNECT_CMDID */
 struct wmi_connect_cmd {
 	u8 network_type;
@@ -295,8 +309,12 @@ struct wmi_connect_cmd {
 	u8 group_crypto_len;
 	u8 ssid_len;
 	u8 ssid[WMI_MAX_SSID_LEN];
+	/* enum wmi_channel WMI_CHANNEL_1..WMI_CHANNEL_6; for EDMG this is
+	 * the primary channel number
+	 */
 	u8 channel;
-	u8 reserved0;
+	/* enum wmi_channel WMI_CHANNEL_9..WMI_CHANNEL_12 */
+	u8 edmg_channel;
 	u8 bssid[WMI_MAC_LEN];
 	__le32 ctrl_flags;
 	u8 dst_mac[WMI_MAC_LEN];
@@ -590,11 +608,16 @@ struct wmi_pcp_start_cmd {
 	u8 pcp_max_assoc_sta;
 	u8 hidden_ssid;
 	u8 is_go;
-	u8 reserved0[5];
+	/* enum wmi_channel WMI_CHANNEL_9..WMI_CHANNEL_12 */
+	u8 edmg_channel;
+	u8 reserved[4];
 	/* A-BFT length override if non-0 */
 	u8 abft_len;
 	u8 disable_ap_sme;
 	u8 network_type;
+	/* enum wmi_channel WMI_CHANNEL_1..WMI_CHANNEL_6; for EDMG this is
+	 * the primary channel number
+	 */
 	u8 channel;
 	u8 disable_sec_offload;
 	u8 disable_sec;
@@ -1576,8 +1599,12 @@ struct wmi_notify_req_done_event {
 
 /* WMI_CONNECT_EVENTID */
 struct wmi_connect_event {
+	/* enum wmi_channel WMI_CHANNEL_1..WMI_CHANNEL_6; for EDMG this is
+	 * the primary channel number
+	 */
 	u8 channel;
-	u8 reserved0;
+	/* enum wmi_channel WMI_CHANNEL_9..WMI_CHANNEL_12 */
+	u8 edmg_channel;
 	u8 bssid[WMI_MAC_LEN];
 	__le16 listen_interval;
 	__le16 beacon_interval;
-- 
1.9.1
