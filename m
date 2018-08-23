Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:6039 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727247AbeHWPQr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 11:16:47 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 8/9] wil6210: add FT roam support for AP and station
Date: Thu, 23 Aug 2018 14:47:12 +0300
Message-Id: <1535024833-15178-9-git-send-email-merez@codeaurora.org> (sfid-20180823_134731_087887_1D14E87B)
In-Reply-To: <1535024833-15178-1-git-send-email-merez@codeaurora.org>
References: <1535024833-15178-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ahmad Masri <amasri@codeaurora.org>

This feature is needed for enterprise APs and clients to enable
fast roaming as defined in 802.11r between APs in the same ESS.

On AP side, this feature is supported only when disable_ap_sme
is enabled.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c  | 311 ++++++++++++++++++++----
 drivers/net/wireless/ath/wil6210/debugfs.c   |  17 +-
 drivers/net/wireless/ath/wil6210/main.c      |   2 +
 drivers/net/wireless/ath/wil6210/txrx.c      |  83 +++++++
 drivers/net/wireless/ath/wil6210/txrx_edma.c |  11 +
 drivers/net/wireless/ath/wil6210/wil6210.h   |  17 ++
 drivers/net/wireless/ath/wil6210/wmi.c       | 350 ++++++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/wmi.h       |   1 +
 8 files changed, 735 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 1bdb026..d18e81f 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -219,7 +219,9 @@ static int wil_rf_sector_set_selected(struct wiphy *wiphy,
 		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
 		BIT(IEEE80211_STYPE_PROBE_RESP >> 4) |
 		BIT(IEEE80211_STYPE_ASSOC_RESP >> 4) |
-		BIT(IEEE80211_STYPE_DISASSOC >> 4),
+		BIT(IEEE80211_STYPE_DISASSOC >> 4) |
+		BIT(IEEE80211_STYPE_AUTH >> 4) |
+		BIT(IEEE80211_STYPE_REASSOC_RESP >> 4),
 		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
 		BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
 		BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
@@ -891,6 +893,26 @@ static void wil_print_crypto(struct wil6210_priv *wil,
 		     c->control_port_no_encrypt);
 }
 
+static const char *
+wil_get_auth_type_name(enum nl80211_auth_type auth_type)
+{
+	switch (auth_type) {
+	case NL80211_AUTHTYPE_OPEN_SYSTEM:
+		return "OPEN_SYSTEM";
+	case NL80211_AUTHTYPE_SHARED_KEY:
+		return "SHARED_KEY";
+	case NL80211_AUTHTYPE_FT:
+		return "FT";
+	case NL80211_AUTHTYPE_NETWORK_EAP:
+		return "NETWORK_EAP";
+	case NL80211_AUTHTYPE_SAE:
+		return "SAE";
+	case NL80211_AUTHTYPE_AUTOMATIC:
+		return "AUTOMATIC";
+	default:
+		return "unknown";
+	}
+}
 static void wil_print_connect_params(struct wil6210_priv *wil,
 				     struct cfg80211_connect_params *sme)
 {
@@ -904,11 +926,73 @@ static void wil_print_connect_params(struct wil6210_priv *wil,
 	if (sme->ssid)
 		print_hex_dump(KERN_INFO, "  SSID: ", DUMP_PREFIX_OFFSET,
 			       16, 1, sme->ssid, sme->ssid_len, true);
+	if (sme->prev_bssid)
+		wil_info(wil, "  Previous BSSID=%pM\n", sme->prev_bssid);
+	wil_info(wil, "  Auth Type: %s\n",
+		 wil_get_auth_type_name(sme->auth_type));
 	wil_info(wil, "  Privacy: %s\n", sme->privacy ? "secure" : "open");
 	wil_info(wil, "  PBSS: %d\n", sme->pbss);
 	wil_print_crypto(wil, &sme->crypto);
 }
 
+static int wil_ft_connect(struct wiphy *wiphy,
+			  struct net_device *ndev,
+			  struct cfg80211_connect_params *sme)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	struct wil6210_vif *vif = ndev_to_vif(ndev);
+	struct wmi_ft_auth_cmd auth_cmd;
+	int rc;
+
+	if (!test_bit(WMI_FW_CAPABILITY_FT_ROAMING, wil->fw_capabilities)) {
+		wil_err(wil, "FT: FW does not support FT roaming\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (!sme->prev_bssid) {
+		wil_err(wil, "FT: prev_bssid was not set\n");
+		return -EINVAL;
+	}
+
+	if (ether_addr_equal(sme->prev_bssid, sme->bssid)) {
+		wil_err(wil, "FT: can not roam to same AP\n");
+		return -EINVAL;
+	}
+
+	if (!test_bit(wil_vif_fwconnected, vif->status)) {
+		wil_err(wil, "FT: roam while not connected\n");
+		return -EINVAL;
+	}
+
+	if (vif->privacy != sme->privacy) {
+		wil_err(wil, "FT: privacy mismatch, current (%d) roam (%d)\n",
+			vif->privacy, sme->privacy);
+		return -EINVAL;
+	}
+
+	if (sme->pbss) {
+		wil_err(wil, "FT: roam is not valid for PBSS\n");
+		return -EINVAL;
+	}
+
+	memset(&auth_cmd, 0, sizeof(auth_cmd));
+	auth_cmd.channel = sme->channel->hw_value - 1;
+	ether_addr_copy(auth_cmd.bssid, sme->bssid);
+
+	wil_info(wil, "FT: roaming\n");
+
+	set_bit(wil_vif_ft_roam, vif->status);
+	rc = wmi_send(wil, WMI_FT_AUTH_CMDID, vif->mid,
+		      &auth_cmd, sizeof(auth_cmd));
+	if (rc == 0)
+		mod_timer(&vif->connect_timer,
+			  jiffies + msecs_to_jiffies(5000));
+	else
+		clear_bit(wil_vif_ft_roam, vif->status);
+
+	return rc;
+}
+
 static int wil_cfg80211_connect(struct wiphy *wiphy,
 				struct net_device *ndev,
 				struct cfg80211_connect_params *sme)
@@ -921,14 +1005,23 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 	const u8 *rsn_eid;
 	int ch;
 	int rc = 0;
+	bool is_ft_roam = false;
+	u8 network_type;
 	enum ieee80211_bss_type bss_type = IEEE80211_BSS_TYPE_ESS;
 
 	wil_dbg_misc(wil, "connect, mid=%d\n", vif->mid);
 	wil_print_connect_params(wil, sme);
 
-	if (test_bit(wil_vif_fwconnecting, vif->status) ||
+	if (sme->auth_type == NL80211_AUTHTYPE_FT)
+		is_ft_roam = true;
+	if (sme->auth_type == NL80211_AUTHTYPE_AUTOMATIC &&
 	    test_bit(wil_vif_fwconnected, vif->status))
-		return -EALREADY;
+		is_ft_roam = true;
+
+	if (!is_ft_roam)
+		if (test_bit(wil_vif_fwconnecting, vif->status) ||
+		    test_bit(wil_vif_fwconnected, vif->status))
+			return -EALREADY;
 
 	if (sme->ie_len > WMI_MAX_IE_LEN) {
 		wil_err(wil, "IE too large (%td bytes)\n", sme->ie_len);
@@ -938,8 +1031,13 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 	rsn_eid = sme->ie ?
 			cfg80211_find_ie(WLAN_EID_RSN, sme->ie, sme->ie_len) :
 			NULL;
-	if (sme->privacy && !rsn_eid)
+	if (sme->privacy && !rsn_eid) {
 		wil_info(wil, "WSC connection\n");
+		if (is_ft_roam) {
+			wil_err(wil, "No WSC with FT roam\n");
+			return -EINVAL;
+		}
+	}
 
 	if (sme->pbss)
 		bss_type = IEEE80211_BSS_TYPE_PBSS;
@@ -961,6 +1059,45 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 	vif->privacy = sme->privacy;
 	vif->pbss = sme->pbss;
 
+	rc = wmi_set_ie(vif, WMI_FRAME_ASSOC_REQ, sme->ie_len, sme->ie);
+	if (rc)
+		goto out;
+
+	switch (bss->capability & WLAN_CAPABILITY_DMG_TYPE_MASK) {
+	case WLAN_CAPABILITY_DMG_TYPE_AP:
+		network_type = WMI_NETTYPE_INFRA;
+		break;
+	case WLAN_CAPABILITY_DMG_TYPE_PBSS:
+		network_type = WMI_NETTYPE_P2P;
+		break;
+	default:
+		wil_err(wil, "Unsupported BSS type, capability= 0x%04x\n",
+			bss->capability);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	ch = bss->channel->hw_value;
+	if (ch == 0) {
+		wil_err(wil, "BSS at unknown frequency %dMhz\n",
+			bss->channel->center_freq);
+		rc = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (is_ft_roam) {
+		if (network_type != WMI_NETTYPE_INFRA) {
+			wil_err(wil, "FT: Unsupported BSS type, capability= 0x%04x\n",
+				bss->capability);
+			rc = -EINVAL;
+			goto out;
+		}
+		rc = wil_ft_connect(wiphy, ndev, sme);
+		if (rc == 0)
+			vif->bss = bss;
+		goto out;
+	}
+
 	if (vif->privacy) {
 		/* For secure assoc, remove old keys */
 		rc = wmi_del_cipher_key(vif, 0, bss->bssid,
@@ -977,28 +1114,9 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 		}
 	}
 
-	/* WMI_SET_APPIE_CMD. ie may contain rsn info as well as other info
-	 * elements. Send it also in case it's empty, to erase previously set
-	 * ies in FW.
-	 */
-	rc = wmi_set_ie(vif, WMI_FRAME_ASSOC_REQ, sme->ie_len, sme->ie);
-	if (rc)
-		goto out;
-
 	/* WMI_CONNECT_CMD */
 	memset(&conn, 0, sizeof(conn));
-	switch (bss->capability & WLAN_CAPABILITY_DMG_TYPE_MASK) {
-	case WLAN_CAPABILITY_DMG_TYPE_AP:
-		conn.network_type = WMI_NETTYPE_INFRA;
-		break;
-	case WLAN_CAPABILITY_DMG_TYPE_PBSS:
-		conn.network_type = WMI_NETTYPE_P2P;
-		break;
-	default:
-		wil_err(wil, "Unsupported BSS type, capability= 0x%04x\n",
-			bss->capability);
-		goto out;
-	}
+	conn.network_type = network_type;
 	if (vif->privacy) {
 		if (rsn_eid) { /* regular secure connection */
 			conn.dot11_auth_mode = WMI_AUTH11_SHARED;
@@ -1018,14 +1136,6 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 
 	conn.ssid_len = min_t(u8, ssid_eid[1], 32);
 	memcpy(conn.ssid, ssid_eid+2, conn.ssid_len);
-
-	ch = bss->channel->hw_value;
-	if (ch == 0) {
-		wil_err(wil, "BSS at unknown frequency %dMhz\n",
-			bss->channel->center_freq);
-		rc = -EOPNOTSUPP;
-		goto out;
-	}
 	conn.channel = ch - 1;
 
 	ether_addr_copy(conn.bssid, bss->bssid);
@@ -1221,9 +1331,9 @@ static enum wmi_key_usage wil_detect_key_usage(struct wireless_dev *wdev,
 	return &wil->sta[cid];
 }
 
-static void wil_set_crypto_rx(u8 key_index, enum wmi_key_usage key_usage,
-			      struct wil_sta_info *cs,
-			      struct key_params *params)
+void wil_set_crypto_rx(u8 key_index, enum wmi_key_usage key_usage,
+		       struct wil_sta_info *cs,
+		       struct key_params *params)
 {
 	struct wil_tid_crypto_rx_single *cc;
 	int tid;
@@ -1306,13 +1416,19 @@ static int wil_cfg80211_add_key(struct wiphy *wiphy,
 		     params->seq_len, params->seq);
 
 	if (IS_ERR(cs)) {
-		wil_err(wil, "Not connected, %pM %s[%d] PN %*phN\n",
-			mac_addr, key_usage_str[key_usage], key_index,
-			params->seq_len, params->seq);
-		return -EINVAL;
+		/* in FT, sta info may not be available as add_key may be
+		 * sent by host before FW sends WMI_CONNECT_EVENT
+		 */
+		if (!test_bit(wil_vif_ft_roam, vif->status)) {
+			wil_err(wil, "Not connected, %pM %s[%d] PN %*phN\n",
+				mac_addr, key_usage_str[key_usage], key_index,
+				params->seq_len, params->seq);
+			return -EINVAL;
+		}
 	}
 
-	wil_del_rx_key(key_index, key_usage, cs);
+	if (!IS_ERR(cs))
+		wil_del_rx_key(key_index, key_usage, cs);
 
 	if (params->seq && params->seq_len != IEEE80211_GCMP_PN_LEN) {
 		wil_err(wil,
@@ -1325,7 +1441,10 @@ static int wil_cfg80211_add_key(struct wiphy *wiphy,
 
 	rc = wmi_add_cipher_key(vif, key_index, mac_addr, params->key_len,
 				params->key, key_usage);
-	if (!rc)
+	if (!rc && !IS_ERR(cs))
+		/* in FT set crypto will take place upon receiving
+		 * WMI_RING_EN_EVENTID event
+		 */
 		wil_set_crypto_rx(key_index, key_usage, cs, params);
 
 	return rc;
@@ -1488,21 +1607,36 @@ static void wil_print_bcon_data(struct cfg80211_beacon_data *b)
 }
 
 /* internal functions for device reset and starting AP */
-static int _wil_cfg80211_set_ies(struct wil6210_vif *vif,
-				 struct cfg80211_beacon_data *bcon)
+static u8 *
+_wil_cfg80211_get_proberesp_ies(const u8 *proberesp, u16 proberesp_len,
+				u16 *ies_len)
 {
-	int rc;
-	u16 len = 0, proberesp_len = 0;
-	u8 *ies = NULL, *proberesp = NULL;
+	u8 *ies = NULL;
 
-	if (bcon->probe_resp) {
+	if (proberesp) {
 		struct ieee80211_mgmt *f =
-			(struct ieee80211_mgmt *)bcon->probe_resp;
+			(struct ieee80211_mgmt *)proberesp;
 		size_t hlen = offsetof(struct ieee80211_mgmt,
 				       u.probe_resp.variable);
-		proberesp = f->u.probe_resp.variable;
-		proberesp_len = bcon->probe_resp_len - hlen;
+
+		ies = f->u.probe_resp.variable;
+		if (ies_len)
+			*ies_len = proberesp_len - hlen;
 	}
+
+	return ies;
+}
+
+static int _wil_cfg80211_set_ies(struct wil6210_vif *vif,
+				 struct cfg80211_beacon_data *bcon)
+{
+	int rc;
+	u16 len = 0, proberesp_len = 0;
+	u8 *ies = NULL, *proberesp;
+
+	proberesp = _wil_cfg80211_get_proberesp_ies(bcon->probe_resp,
+						    bcon->probe_resp_len,
+						    &proberesp_len);
 	rc = _wil_cfg80211_merge_extra_ies(proberesp,
 					   proberesp_len,
 					   bcon->proberesp_ies,
@@ -1546,6 +1680,9 @@ static int _wil_cfg80211_start_ap(struct wiphy *wiphy,
 	struct wireless_dev *wdev = ndev->ieee80211_ptr;
 	u8 wmi_nettype = wil_iftype_nl2wmi(wdev->iftype);
 	u8 is_go = (wdev->iftype == NL80211_IFTYPE_P2P_GO);
+	u16 proberesp_len = 0;
+	u8 *proberesp;
+	bool ft = false;
 
 	if (pbss)
 		wmi_nettype = WMI_NETTYPE_P2P;
@@ -1558,6 +1695,25 @@ static int _wil_cfg80211_start_ap(struct wiphy *wiphy,
 
 	wil_set_recovery_state(wil, fw_recovery_idle);
 
+	proberesp = _wil_cfg80211_get_proberesp_ies(bcon->probe_resp,
+						    bcon->probe_resp_len,
+						    &proberesp_len);
+	/* check that the probe response IEs has a MDE */
+	if ((proberesp && proberesp_len > 0 &&
+	     cfg80211_find_ie(WLAN_EID_MOBILITY_DOMAIN,
+			      proberesp,
+			      proberesp_len)))
+		ft = true;
+
+	if (ft) {
+		if (!test_bit(WMI_FW_CAPABILITY_FT_ROAMING,
+			      wil->fw_capabilities)) {
+			wil_err(wil, "FW does not support FT roaming\n");
+			return -ENOTSUPP;
+		}
+		set_bit(wil_vif_ft_roam, vif->status);
+	}
+
 	mutex_lock(&wil->mutex);
 
 	if (!wil_has_other_active_ifaces(wil, ndev, true, false)) {
@@ -1719,6 +1875,7 @@ static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
 	mutex_lock(&wil->mutex);
 
 	wmi_pcp_stop(vif);
+	clear_bit(wil_vif_ft_roam, vif->status);
 
 	if (last)
 		__wil_down(wil);
@@ -1738,8 +1895,9 @@ static int wil_cfg80211_add_station(struct wiphy *wiphy,
 	struct wil6210_vif *vif = ndev_to_vif(dev);
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 
-	wil_dbg_misc(wil, "add station %pM aid %d mid %d\n",
-		     mac, params->aid, vif->mid);
+	wil_dbg_misc(wil, "add station %pM aid %d mid %d mask 0x%x set 0x%x\n",
+		     mac, params->aid, vif->mid,
+		     params->sta_flags_mask, params->sta_flags_set);
 
 	if (!disable_ap_sme) {
 		wil_err(wil, "not supported with AP SME enabled\n");
@@ -2060,6 +2218,54 @@ static int wil_cfg80211_resume(struct wiphy *wiphy)
 	return 0;
 }
 
+static int
+wil_cfg80211_update_ft_ies(struct wiphy *wiphy, struct net_device *dev,
+			   struct cfg80211_update_ft_ies_params *ftie)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	struct wil6210_vif *vif = ndev_to_vif(dev);
+	struct cfg80211_bss *bss;
+	struct wmi_ft_reassoc_cmd reassoc;
+	int rc = 0;
+
+	wil_dbg_misc(wil, "update ft ies, mid=%d\n", vif->mid);
+	wil_hex_dump_misc("FT IE ", DUMP_PREFIX_OFFSET, 16, 1,
+			  ftie->ie, ftie->ie_len, true);
+
+	if (!test_bit(WMI_FW_CAPABILITY_FT_ROAMING, wil->fw_capabilities)) {
+		wil_err(wil, "FW does not support FT roaming\n");
+		return -EOPNOTSUPP;
+	}
+
+	rc = wmi_update_ft_ies(vif, ftie->ie_len, ftie->ie);
+	if (rc)
+		return rc;
+
+	if (!test_bit(wil_vif_ft_roam, vif->status))
+		/* vif is not roaming */
+		return 0;
+
+	/* wil_vif_ft_roam is set. wil_cfg80211_update_ft_ies is used as
+	 * a trigger for reassoc
+	 */
+
+	bss = vif->bss;
+	if (!bss) {
+		wil_err(wil, "FT: bss is NULL\n");
+		return -EINVAL;
+	}
+
+	memset(&reassoc, 0, sizeof(reassoc));
+	ether_addr_copy(reassoc.bssid, bss->bssid);
+
+	rc = wmi_send(wil, WMI_FT_REASSOC_CMDID, vif->mid,
+		      &reassoc, sizeof(reassoc));
+	if (rc)
+		wil_err(wil, "FT: reassoc failed (%d)\n", rc);
+
+	return rc;
+}
+
 static const struct cfg80211_ops wil_cfg80211_ops = {
 	.add_virtual_intf = wil_cfg80211_add_iface,
 	.del_virtual_intf = wil_cfg80211_del_iface,
@@ -2095,6 +2301,7 @@ static int wil_cfg80211_resume(struct wiphy *wiphy)
 	.resume = wil_cfg80211_resume,
 	.sched_scan_start = wil_cfg80211_sched_scan_start,
 	.sched_scan_stop = wil_cfg80211_sched_scan_stop,
+	.update_ft_ies = wil_cfg80211_update_ft_ies,
 };
 
 static void wil_wiphy_init(struct wiphy *wiphy)
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 4057f06..6973333 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1669,6 +1669,7 @@ static int wil_sta_debugfs_show(struct seq_file *s, void *data)
 		char *status = "unknown";
 		u8 aid = 0;
 		u8 mid;
+		bool sta_connected = false;
 
 		switch (p->status) {
 		case wil_sta_unused:
@@ -1683,8 +1684,20 @@ static int wil_sta_debugfs_show(struct seq_file *s, void *data)
 			break;
 		}
 		mid = (p->status != wil_sta_unused) ? p->mid : U8_MAX;
-		seq_printf(s, "[%d] %pM %s MID %d AID %d\n", i, p->addr, status,
-			   mid, aid);
+		if (mid < wil->max_vifs) {
+			struct wil6210_vif *vif = wil->vifs[mid];
+
+			if (vif->wdev.iftype == NL80211_IFTYPE_STATION &&
+			    p->status == wil_sta_connected)
+				sta_connected = true;
+		}
+		/* print roam counter only for connected stations */
+		if (sta_connected)
+			seq_printf(s, "[%d] %pM connected (roam counter %d) MID %d AID %d\n",
+				   i, p->addr, p->stats.ft_roams, mid, aid);
+		else
+			seq_printf(s, "[%d] %pM %s MID %d AID %d\n", i,
+				   p->addr, status, mid, aid);
 
 		if (p->status == wil_sta_connected) {
 			spin_lock_bh(&p->tid_rx_lock);
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 3fcf799..398900a 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -361,6 +361,8 @@ static void _wil6210_disconnect(struct wil6210_vif *vif, const u8 *bssid,
 			vif->bss = NULL;
 		}
 		clear_bit(wil_vif_fwconnecting, vif->status);
+		clear_bit(wil_vif_ft_roam, vif->status);
+
 		break;
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 259e4a8..cc5f263 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1059,6 +1059,88 @@ static int wil_vring_init_tx(struct wil6210_vif *vif, int id, int size,
 	return rc;
 }
 
+static int wil_tx_vring_modify(struct wil6210_vif *vif, int ring_id, int cid,
+			       int tid)
+{
+	struct wil6210_priv *wil = vif_to_wil(vif);
+	int rc;
+	struct wmi_vring_cfg_cmd cmd = {
+		.action = cpu_to_le32(WMI_VRING_CMD_MODIFY),
+		.vring_cfg = {
+			.tx_sw_ring = {
+				.max_mpdu_size =
+					cpu_to_le16(wil_mtu2macbuf(mtu_max)),
+				.ring_size = 0,
+			},
+			.ringid = ring_id,
+			.cidxtid = mk_cidxtid(cid, tid),
+			.encap_trans_type = WMI_VRING_ENC_TYPE_802_3,
+			.mac_ctrl = 0,
+			.to_resolution = 0,
+			.agg_max_wsize = 0,
+			.schd_params = {
+				.priority = cpu_to_le16(0),
+				.timeslot_us = cpu_to_le16(0xfff),
+			},
+		},
+	};
+	struct {
+		struct wmi_cmd_hdr wmi;
+		struct wmi_vring_cfg_done_event cmd;
+	} __packed reply = {
+		.cmd = {.status = WMI_FW_STATUS_FAILURE},
+	};
+	struct wil_ring *vring = &wil->ring_tx[ring_id];
+	struct wil_ring_tx_data *txdata = &wil->ring_tx_data[ring_id];
+
+	wil_dbg_misc(wil, "vring_modify: ring %d cid %d tid %d\n", ring_id,
+		     cid, tid);
+	lockdep_assert_held(&wil->mutex);
+
+	if (!vring->va) {
+		wil_err(wil, "Tx ring [%d] not allocated\n", ring_id);
+		return -EINVAL;
+	}
+
+	if (wil->ring2cid_tid[ring_id][0] != cid ||
+	    wil->ring2cid_tid[ring_id][1] != tid) {
+		wil_err(wil, "ring info does not match cid=%u tid=%u\n",
+			wil->ring2cid_tid[ring_id][0],
+			wil->ring2cid_tid[ring_id][1]);
+	}
+
+	cmd.vring_cfg.tx_sw_ring.ring_mem_base = cpu_to_le64(vring->pa);
+
+	rc = wmi_call(wil, WMI_VRING_CFG_CMDID, vif->mid, &cmd, sizeof(cmd),
+		      WMI_VRING_CFG_DONE_EVENTID, &reply, sizeof(reply), 100);
+	if (rc)
+		goto fail;
+
+	if (reply.cmd.status != WMI_FW_STATUS_SUCCESS) {
+		wil_err(wil, "Tx modify failed, status 0x%02x\n",
+			reply.cmd.status);
+		rc = -EINVAL;
+		goto fail;
+	}
+
+	/* set BA aggregation window size to 0 to force a new BA with the
+	 * new AP
+	 */
+	txdata->agg_wsize = 0;
+	if (txdata->dot1x_open && agg_wsize >= 0)
+		wil_addba_tx_request(wil, ring_id, agg_wsize);
+
+	return 0;
+fail:
+	spin_lock_bh(&txdata->lock);
+	txdata->dot1x_open = false;
+	txdata->enabled = 0;
+	spin_unlock_bh(&txdata->lock);
+	wil->ring2cid_tid[ring_id][0] = WIL6210_MAX_CID;
+	wil->ring2cid_tid[ring_id][1] = 0;
+	return rc;
+}
+
 int wil_vring_init_bcast(struct wil6210_vif *vif, int id, int size)
 {
 	struct wil6210_priv *wil = vif_to_wil(vif);
@@ -2281,6 +2363,7 @@ void wil_init_txrx_ops_legacy_dma(struct wil6210_priv *wil)
 	wil->txrx_ops.ring_init_bcast = wil_vring_init_bcast;
 	wil->txrx_ops.tx_init = wil_tx_init;
 	wil->txrx_ops.tx_fini = wil_tx_fini;
+	wil->txrx_ops.tx_ring_modify = wil_tx_vring_modify;
 	/* RX ops */
 	wil->txrx_ops.rx_init = wil_rx_init;
 	wil->txrx_ops.wmi_addba_rx_resp = wmi_addba_rx_resp;
diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 3e7fc29..2bbae75 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -747,6 +747,16 @@ static int wil_ring_init_tx_edma(struct wil6210_vif *vif, int ring_id,
 	return rc;
 }
 
+static int wil_tx_ring_modify_edma(struct wil6210_vif *vif, int ring_id,
+				   int cid, int tid)
+{
+	struct wil6210_priv *wil = vif_to_wil(vif);
+
+	wil_err(wil, "ring modify is not supported for EDMA\n");
+
+	return -EOPNOTSUPP;
+}
+
 /* This function is used only for RX SW reorder */
 static int wil_check_bar(struct wil6210_priv *wil, void *msg, int cid,
 			 struct sk_buff *skb, struct wil_net_stats *stats)
@@ -1600,6 +1610,7 @@ void wil_init_txrx_ops_edma(struct wil6210_priv *wil)
 	wil->txrx_ops.tx_desc_map = wil_tx_desc_map_edma;
 	wil->txrx_ops.tx_desc_unmap = wil_tx_desc_unmap_edma;
 	wil->txrx_ops.tx_ring_tso = __wil_tx_ring_tso_edma;
+	wil->txrx_ops.tx_ring_modify = wil_tx_ring_modify_edma;
 	/* RX ops */
 	wil->txrx_ops.rx_init = wil_rx_init_edma;
 	wil->txrx_ops.wmi_addba_rx_resp = wmi_addba_rx_resp_edma;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 85565de..cf6a691 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -449,6 +449,15 @@ static inline void parse_cidxtid(u8 cidxtid, u8 *cid, u8 *tid)
 	*tid = (cidxtid >> 4) & 0xf;
 }
 
+/**
+ * wil_cid_valid - check cid is valid
+ * @cid: CID value
+ */
+static inline bool wil_cid_valid(u8 cid)
+{
+	return (cid >= 0 && cid < WIL6210_MAX_CID);
+}
+
 struct wil6210_mbox_ring {
 	u32 base;
 	u16 entry_size; /* max. size of mbox entry, incl. all headers */
@@ -577,6 +586,7 @@ struct wil_net_stats {
 	unsigned long	rx_csum_err;
 	u16 last_mcs_rx;
 	u64 rx_per_mcs[WIL_MCS_MAX + 1];
+	u32 ft_roams; /* relevant in STA mode */
 };
 
 /**
@@ -599,6 +609,8 @@ struct wil_txrx_ops {
 			      struct wil_ctx *ctx);
 	int (*tx_ring_tso)(struct wil6210_priv *wil, struct wil6210_vif *vif,
 			   struct wil_ring *ring, struct sk_buff *skb);
+	int (*tx_ring_modify)(struct wil6210_vif *vif, int ring_id,
+			      int cid, int tid);
 	irqreturn_t (*irq_tx)(int irq, void *cookie);
 	/* RX ops */
 	int (*rx_init)(struct wil6210_priv *wil, u16 ring_size);
@@ -821,6 +833,7 @@ struct wil_debugfs_data {
 enum wil6210_vif_status {
 	wil_vif_fwconnecting,
 	wil_vif_fwconnected,
+	wil_vif_ft_roam,
 	wil_vif_status_last /* keep last */
 };
 
@@ -1204,6 +1217,7 @@ int wmi_add_cipher_key(struct wil6210_vif *vif, u8 key_index,
 int wmi_echo(struct wil6210_priv *wil);
 int wmi_set_ie(struct wil6210_vif *vif, u8 type, u16 ie_len, const void *ie);
 int wmi_rx_chain_add(struct wil6210_priv *wil, struct wil_ring *vring);
+int wmi_update_ft_ies(struct wil6210_vif *vif, u16 ie_len, const void *ie);
 int wmi_rxon(struct wil6210_priv *wil, bool on);
 int wmi_get_temperature(struct wil6210_priv *wil, u32 *t_m, u32 *t_r);
 int wmi_disconnect_sta(struct wil6210_vif *vif, const u8 *mac,
@@ -1319,6 +1333,9 @@ void wil_update_net_queues_bh(struct wil6210_priv *wil, struct wil6210_vif *vif,
 void wil_rx_handle(struct wil6210_priv *wil, int *quota);
 void wil6210_unmask_irq_rx(struct wil6210_priv *wil);
 void wil6210_unmask_irq_rx_edma(struct wil6210_priv *wil);
+void wil_set_crypto_rx(u8 key_index, enum wmi_key_usage key_usage,
+		       struct wil_sta_info *cs,
+		       struct key_params *params);
 
 int wil_iftype_nl2wmi(enum nl80211_iftype type);
 
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 42c02a2..c3ad8e4 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -227,6 +227,14 @@ struct blink_on_off_time led_blink_time[] = {
 	{WIL_LED_BLINK_ON_FAST_MS, WIL_LED_BLINK_OFF_FAST_MS},
 };
 
+struct auth_no_hdr {
+	__le16 auth_alg;
+	__le16 auth_transaction;
+	__le16 status_code;
+	/* possibly followed by Challenge text */
+	u8 variable[0];
+} __packed;
+
 u8 led_polarity = LED_POLARITY_LOW_ACTIVE;
 
 /**
@@ -468,6 +476,12 @@ static const char *cmdid2name(u16 cmdid)
 		return "WMI_LINK_STATS_CMD";
 	case WMI_SW_TX_REQ_EXT_CMDID:
 		return "WMI_SW_TX_REQ_EXT_CMDID";
+	case WMI_FT_AUTH_CMDID:
+		return "WMI_FT_AUTH_CMD";
+	case WMI_FT_REASSOC_CMDID:
+		return "WMI_FT_REASSOC_CMD";
+	case WMI_UPDATE_FT_IES_CMDID:
+		return "WMI_UPDATE_FT_IES_CMD";
 	default:
 		return "Untracked CMD";
 	}
@@ -606,6 +620,12 @@ static const char *eventid2name(u16 eventid)
 		return "WMI_LINK_STATS_CONFIG_DONE_EVENT";
 	case WMI_LINK_STATS_EVENTID:
 		return "WMI_LINK_STATS_EVENT";
+	case WMI_COMMAND_NOT_SUPPORTED_EVENTID:
+		return "WMI_COMMAND_NOT_SUPPORTED_EVENT";
+	case WMI_FT_AUTH_STATUS_EVENTID:
+		return "WMI_FT_AUTH_STATUS_EVENT";
+	case WMI_FT_REASSOC_STATUS_EVENTID:
+		return "WMI_FT_REASSOC_STATUS_EVENT";
 	default:
 		return "Untracked EVENT";
 	}
@@ -1156,6 +1176,9 @@ static void wmi_evt_ring_en(struct wil6210_vif *vif, int id, void *d, int len)
 	struct wmi_ring_en_event *evt = d;
 	u8 vri = evt->ring_index;
 	struct wireless_dev *wdev = vif_to_wdev(vif);
+	struct wil_sta_info *sta;
+	int cid;
+	struct key_params params;
 
 	wil_dbg_wmi(wil, "Enable vring %d MID %d\n", vri, vif->mid);
 
@@ -1164,13 +1187,33 @@ static void wmi_evt_ring_en(struct wil6210_vif *vif, int id, void *d, int len)
 		return;
 	}
 
-	if (wdev->iftype != NL80211_IFTYPE_AP || !disable_ap_sme)
-		/* in AP mode with disable_ap_sme, this is done by
-		 * wil_cfg80211_change_station()
+	if (wdev->iftype != NL80211_IFTYPE_AP || !disable_ap_sme ||
+	    test_bit(wil_vif_ft_roam, vif->status))
+		/* in AP mode with disable_ap_sme that is not FT,
+		 * this is done by wil_cfg80211_change_station()
 		 */
 		wil->ring_tx_data[vri].dot1x_open = true;
 	if (vri == vif->bcast_ring) /* no BA for bcast */
 		return;
+
+	cid = wil->ring2cid_tid[vri][0];
+	if (!wil_cid_valid(cid)) {
+		wil_err(wil, "invalid cid %d for vring %d\n", cid, vri);
+		return;
+	}
+
+	/* In FT mode we get key but not store it as it is received
+	 * before WMI_CONNECT_EVENT received from FW.
+	 * wil_set_crypto_rx is called here to reset the security PN
+	 */
+	sta = &wil->sta[cid];
+	if (test_bit(wil_vif_ft_roam, vif->status)) {
+		memset(&params, 0, sizeof(params));
+		wil_set_crypto_rx(0, WMI_KEY_USE_PAIRWISE, sta, &params);
+		if (wdev->iftype != NL80211_IFTYPE_AP)
+			clear_bit(wil_vif_ft_roam, vif->status);
+	}
+
 	if (agg_wsize >= 0)
 		wil_addba_tx_request(wil, vri, agg_wsize);
 }
@@ -1462,6 +1505,271 @@ static void wmi_link_stats_parse(struct wil6210_vif *vif, u64 tsf,
 }
 
 /**
+ * find cid and ringid for the station vif
+ *
+ * return error, if other interfaces are used or ring was not found
+ */
+static int wil_find_cid_ringid_sta(struct wil6210_priv *wil,
+				   struct wil6210_vif *vif,
+				   int *cid,
+				   int *ringid)
+{
+	struct wil_ring *ring;
+	struct wil_ring_tx_data *txdata;
+	int min_ring_id = wil_get_min_tx_ring_id(wil);
+	int i;
+	u8 lcid;
+
+	if (!(vif->wdev.iftype == NL80211_IFTYPE_STATION ||
+	      vif->wdev.iftype == NL80211_IFTYPE_P2P_CLIENT)) {
+		wil_err(wil, "invalid interface type %d\n", vif->wdev.iftype);
+		return -EINVAL;
+	}
+
+	/* In the STA mode, it is expected to have only one ring
+	 * for the AP we are connected to.
+	 * find it and return the cid associated with it.
+	 */
+	for (i = min_ring_id; i < WIL6210_MAX_TX_RINGS; i++) {
+		ring = &wil->ring_tx[i];
+		txdata = &wil->ring_tx_data[i];
+		if (!ring->va || !txdata->enabled || txdata->mid != vif->mid)
+			continue;
+
+		lcid = wil->ring2cid_tid[i][0];
+		if (lcid >= WIL6210_MAX_CID) /* skip BCAST */
+			continue;
+
+		wil_dbg_wmi(wil, "find sta -> ringid %d cid %d\n", i, lcid);
+		*cid = lcid;
+		*ringid = i;
+		return 0;
+	}
+
+	wil_dbg_wmi(wil, "find sta cid while no rings active?\n");
+
+	return -ENOENT;
+}
+
+static void
+wmi_evt_auth_status(struct wil6210_vif *vif, int id, void *d, int len)
+{
+	struct wil6210_priv *wil = vif_to_wil(vif);
+	struct net_device *ndev = vif_to_ndev(vif);
+	struct wmi_ft_auth_status_event *data = d;
+	int ie_len = len - offsetof(struct wmi_ft_auth_status_event, ie_info);
+	int rc, cid = 0, ringid = 0;
+	struct cfg80211_ft_event_params ft;
+	u16 d_len;
+	/* auth_alg(u16) + auth_transaction(u16) + status_code(u16) */
+	const size_t auth_ie_offset = sizeof(u16) * 3;
+	struct auth_no_hdr *auth = (struct auth_no_hdr *)data->ie_info;
+
+	/* check the status */
+	if (ie_len >= 0 && data->status != WMI_FW_STATUS_SUCCESS) {
+		wil_err(wil, "FT: auth failed. status %d\n", data->status);
+		goto fail;
+	}
+
+	if (ie_len < auth_ie_offset) {
+		wil_err(wil, "FT: auth event too short, len %d\n", len);
+		goto fail;
+	}
+
+	d_len = le16_to_cpu(data->ie_len);
+	if (d_len != ie_len) {
+		wil_err(wil,
+			"FT: auth ie length mismatch, d_len %d should be %d\n",
+			d_len, ie_len);
+		goto fail;
+	}
+
+	if (!test_bit(wil_vif_ft_roam, wil->status)) {
+		wil_err(wil, "FT: Not in roaming state\n");
+		goto fail;
+	}
+
+	if (le16_to_cpu(auth->auth_transaction) != 2) {
+		wil_err(wil, "FT: auth error. auth_transaction %d\n",
+			le16_to_cpu(auth->auth_transaction));
+		goto fail;
+	}
+
+	if (le16_to_cpu(auth->auth_alg) != WLAN_AUTH_FT) {
+		wil_err(wil, "FT: auth error. auth_alg %d\n",
+			le16_to_cpu(auth->auth_alg));
+		goto fail;
+	}
+
+	wil_dbg_wmi(wil, "FT: Auth to %pM successfully\n", data->mac_addr);
+	wil_hex_dump_wmi("FT Auth ies : ", DUMP_PREFIX_OFFSET, 16, 1,
+			 data->ie_info, d_len, true);
+
+	/* find cid and ringid */
+	rc = wil_find_cid_ringid_sta(wil, vif, &cid, &ringid);
+	if (rc) {
+		wil_err(wil, "No valid cid found\n");
+		goto fail;
+	}
+
+	if (vif->privacy) {
+		/* For secure assoc, remove old keys */
+		rc = wmi_del_cipher_key(vif, 0, wil->sta[cid].addr,
+					WMI_KEY_USE_PAIRWISE);
+		if (rc) {
+			wil_err(wil, "WMI_DELETE_CIPHER_KEY_CMD(PTK) failed\n");
+			goto fail;
+		}
+		rc = wmi_del_cipher_key(vif, 0, wil->sta[cid].addr,
+					WMI_KEY_USE_RX_GROUP);
+		if (rc) {
+			wil_err(wil, "WMI_DELETE_CIPHER_KEY_CMD(GTK) failed\n");
+			goto fail;
+		}
+	}
+
+	memset(&ft, 0, sizeof(ft));
+	ft.ies = data->ie_info + auth_ie_offset;
+	ft.ies_len = d_len - auth_ie_offset;
+	ft.target_ap = data->mac_addr;
+	cfg80211_ft_event(ndev, &ft);
+
+	return;
+
+fail:
+	wil6210_disconnect(vif, NULL, WLAN_REASON_PREV_AUTH_NOT_VALID, false);
+}
+
+static void
+wmi_evt_reassoc_status(struct wil6210_vif *vif, int id, void *d, int len)
+{
+	struct wil6210_priv *wil = vif_to_wil(vif);
+	struct net_device *ndev = vif_to_ndev(vif);
+	struct wiphy *wiphy = wil_to_wiphy(wil);
+	struct wmi_ft_reassoc_status_event *data = d;
+	int ies_len = len - offsetof(struct wmi_ft_reassoc_status_event,
+				     ie_info);
+	int rc = -ENOENT, cid = 0, ringid = 0;
+	int ch; /* channel number (primary) */
+	size_t assoc_req_ie_len = 0, assoc_resp_ie_len = 0;
+	u8 *assoc_req_ie = NULL, *assoc_resp_ie = NULL;
+	/* capinfo(u16) + listen_interval(u16) + current_ap mac addr + IEs */
+	const size_t assoc_req_ie_offset = sizeof(u16) * 2 + ETH_ALEN;
+	/* capinfo(u16) + status_code(u16) + associd(u16) + IEs */
+	const size_t assoc_resp_ie_offset = sizeof(u16) * 3;
+	u16 d_len;
+	int freq;
+	struct cfg80211_roam_info info;
+
+	if (ies_len < 0) {
+		wil_err(wil, "ft reassoc event too short, len %d\n", len);
+		goto fail;
+	}
+
+	wil_dbg_wmi(wil, "Reasoc Status event: status=%d, aid=%d",
+		    data->status, data->aid);
+	wil_dbg_wmi(wil, "    mac_addr=%pM, beacon_ie_len=%d",
+		    data->mac_addr, data->beacon_ie_len);
+	wil_dbg_wmi(wil, "    reassoc_req_ie_len=%d, reassoc_resp_ie_len=%d",
+		    le16_to_cpu(data->reassoc_req_ie_len),
+		    le16_to_cpu(data->reassoc_resp_ie_len));
+
+	d_len = le16_to_cpu(data->beacon_ie_len) +
+		le16_to_cpu(data->reassoc_req_ie_len) +
+		le16_to_cpu(data->reassoc_resp_ie_len);
+	if (d_len != ies_len) {
+		wil_err(wil,
+			"ft reassoc ie length mismatch, d_len %d should be %d\n",
+			d_len, ies_len);
+		goto fail;
+	}
+
+	/* check the status */
+	if (data->status != WMI_FW_STATUS_SUCCESS) {
+		wil_err(wil, "ft reassoc failed. status %d\n", data->status);
+		goto fail;
+	}
+
+	/* find cid and ringid */
+	rc = wil_find_cid_ringid_sta(wil, vif, &cid, &ringid);
+	if (rc) {
+		wil_err(wil, "No valid cid found\n");
+		goto fail;
+	}
+
+	ch = data->channel + 1;
+	wil_info(wil, "FT: Roam %pM channel [%d] cid %d aid %d\n",
+		 data->mac_addr, ch, cid, data->aid);
+
+	wil_hex_dump_wmi("reassoc AI : ", DUMP_PREFIX_OFFSET, 16, 1,
+			 data->ie_info, len - sizeof(*data), true);
+
+	/* figure out IE's */
+	if (le16_to_cpu(data->reassoc_req_ie_len) > assoc_req_ie_offset) {
+		assoc_req_ie = &data->ie_info[assoc_req_ie_offset];
+		assoc_req_ie_len = le16_to_cpu(data->reassoc_req_ie_len) -
+			assoc_req_ie_offset;
+	}
+	if (le16_to_cpu(data->reassoc_resp_ie_len) <= assoc_resp_ie_offset) {
+		wil_err(wil, "FT: reassoc resp ie len is too short, len %d\n",
+			le16_to_cpu(data->reassoc_resp_ie_len));
+		goto fail;
+	}
+
+	assoc_resp_ie = &data->ie_info[le16_to_cpu(data->reassoc_req_ie_len) +
+		assoc_resp_ie_offset];
+	assoc_resp_ie_len = le16_to_cpu(data->reassoc_resp_ie_len) -
+		assoc_resp_ie_offset;
+
+	if (test_bit(wil_status_resetting, wil->status) ||
+	    !test_bit(wil_status_fwready, wil->status)) {
+		wil_err(wil, "FT: status_resetting, cancel reassoc event\n");
+		/* no need for cleanup, wil_reset will do that */
+		return;
+	}
+
+	mutex_lock(&wil->mutex);
+
+	/* ring modify to set the ring for the roamed AP settings */
+	wil_dbg_wmi(wil,
+		    "ft modify tx config for connection CID %d ring %d\n",
+		    cid, ringid);
+
+	rc = wil->txrx_ops.tx_ring_modify(vif, ringid, cid, 0);
+	if (rc) {
+		wil_err(wil, "modify TX for CID %d MID %d ring %d failed (%d)\n",
+			cid, vif->mid, ringid, rc);
+		mutex_unlock(&wil->mutex);
+		goto fail;
+	}
+
+	/* Update the driver STA members with the new bss */
+	wil->sta[cid].aid = data->aid;
+	wil->sta[cid].stats.ft_roams++;
+	ether_addr_copy(wil->sta[cid].addr, vif->bss->bssid);
+	mutex_unlock(&wil->mutex);
+	del_timer_sync(&vif->connect_timer);
+
+	cfg80211_ref_bss(wiphy, vif->bss);
+	freq = ieee80211_channel_to_frequency(ch, NL80211_BAND_60GHZ);
+
+	memset(&info, 0, sizeof(info));
+	info.channel = ieee80211_get_channel(wiphy, freq);
+	info.bss = vif->bss;
+	info.req_ie = assoc_req_ie;
+	info.req_ie_len = assoc_req_ie_len;
+	info.resp_ie = assoc_resp_ie;
+	info.resp_ie_len = assoc_resp_ie_len;
+	cfg80211_roamed(ndev, &info, GFP_KERNEL);
+	vif->bss = NULL;
+
+	return;
+
+fail:
+	wil6210_disconnect(vif, NULL, WLAN_REASON_PREV_AUTH_NOT_VALID, false);
+}
+
+/**
  * Some events are ignored for purpose; and need not be interpreted as
  * "unhandled events"
  */
@@ -1492,6 +1800,8 @@ static void wmi_evt_ignore(struct wil6210_vif *vif, int id, void *d, int len)
 	{WMI_DATA_PORT_OPEN_EVENTID,		wmi_evt_ignore},
 	{WMI_SCHED_SCAN_RESULT_EVENTID,		wmi_evt_sched_scan_result},
 	{WMI_LINK_STATS_EVENTID,		wmi_evt_link_stats},
+	{WMI_FT_AUTH_STATUS_EVENTID,		wmi_evt_auth_status},
+	{WMI_FT_REASSOC_STATUS_EVENTID,		wmi_evt_reassoc_status},
 };
 
 /*
@@ -2086,6 +2396,40 @@ int wmi_set_ie(struct wil6210_vif *vif, u8 type, u16 ie_len, const void *ie)
 	return rc;
 }
 
+int wmi_update_ft_ies(struct wil6210_vif *vif, u16 ie_len, const void *ie)
+{
+	struct wil6210_priv *wil = vif_to_wil(vif);
+	u16 len;
+	struct wmi_update_ft_ies_cmd *cmd;
+	int rc;
+
+	if (!ie)
+		ie_len = 0;
+
+	len = sizeof(struct wmi_update_ft_ies_cmd) + ie_len;
+	if (len < ie_len) {
+		wil_err(wil, "wraparound. ie len %d\n", ie_len);
+		return -EINVAL;
+	}
+
+	cmd = kzalloc(len, GFP_KERNEL);
+	if (!cmd) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	cmd->ie_len = cpu_to_le16(ie_len);
+	memcpy(cmd->ie_info, ie, ie_len);
+	rc = wmi_send(wil, WMI_UPDATE_FT_IES_CMDID, vif->mid, cmd, len);
+	kfree(cmd);
+
+out:
+	if (rc)
+		wil_err(wil, "update ft ies failed : %d\n", rc);
+
+	return rc;
+}
+
 /**
  * wmi_rxon - turn radio on/off
  * @on:		turn on if true, off otherwise
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index f430e1d..b668758 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -2370,6 +2370,7 @@ struct wmi_ft_reassoc_status_event {
 	__le16 beacon_ie_len;
 	__le16 reassoc_req_ie_len;
 	__le16 reassoc_resp_ie_len;
+	u8 reserved[4];
 	u8 ie_info[0];
 } __packed;
 
-- 
1.9.1
