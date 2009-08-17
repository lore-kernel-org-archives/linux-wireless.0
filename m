Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:46444 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbZHQGC6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 02:02:58 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: j@w1.fi
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org,
	Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH V2] nl80211 connect API support
Date: Mon, 17 Aug 2009 14:04:44 +0800
Message-Id: <1250489084-13368-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nl80211 driver connect API support.

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
V2: Use auth/assoc as the default operations if they are supported.

diff --git a/src/common/ieee802_11_defs.h b/src/common/ieee802_11_defs.h
index b4c804e..e1bd487 100644
--- a/src/common/ieee802_11_defs.h
+++ b/src/common/ieee802_11_defs.h
@@ -679,4 +679,19 @@ enum {
 
 #define VENDOR_HT_CAPAB_OUI_TYPE 0x33 /* 00-90-4c:0x33 */
 
+/* cipher suite selectors */
+#define WLAN_CIPHER_SUITE_USE_GROUP	0x000FAC00
+#define WLAN_CIPHER_SUITE_WEP40		0x000FAC01
+#define WLAN_CIPHER_SUITE_TKIP		0x000FAC02
+/* reserved: 				0x000FAC03 */
+#define WLAN_CIPHER_SUITE_CCMP		0x000FAC04
+#define WLAN_CIPHER_SUITE_WEP104	0x000FAC05
+#define WLAN_CIPHER_SUITE_AES_CMAC	0x000FAC06
+
+/* AKM suite selectors */
+#define WLAN_AKM_SUITE_8021X		0x000FAC01
+#define WLAN_AKM_SUITE_PSK		0x000FAC02
+
+#define WLAN_MAX_KEY_LEN		32
+
 #endif /* IEEE802_11_DEFS_H */
diff --git a/src/common/nl80211_copy.h b/src/common/nl80211_copy.h
index dbea93b..c019a16 100644
--- a/src/common/nl80211_copy.h
+++ b/src/common/nl80211_copy.h
@@ -310,6 +310,14 @@ enum nl80211_commands {
 	NL80211_CMD_JOIN_IBSS,
 	NL80211_CMD_LEAVE_IBSS,
 
+	NL80211_CMD_TESTMODE,
+
+	NL80211_CMD_CONNECT,
+	NL80211_CMD_ROAM,
+	NL80211_CMD_DISCONNECT,
+
+	NL80211_CMD_SET_WIPHY_NETNS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -619,6 +627,28 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_CONTROL_PORT,
 
+	NL80211_ATTR_TESTDATA,
+
+	NL80211_ATTR_PRIVACY,
+
+	NL80211_ATTR_DISCONNECTED_BY_AP,
+	NL80211_ATTR_STATUS_CODE,
+
+	NL80211_ATTR_CIPHER_SUITES_PAIRWISE,
+	NL80211_ATTR_CIPHER_SUITE_GROUP,
+	NL80211_ATTR_WPA_VERSIONS,
+	NL80211_ATTR_AKM_SUITES,
+
+	NL80211_ATTR_REQ_IE,
+	NL80211_ATTR_RESP_IE,
+
+	NL80211_ATTR_PREV_BSSID,
+
+	NL80211_ATTR_KEY,
+	NL80211_ATTR_KEYS,
+
+	NL80211_ATTR_PID,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1224,4 +1254,39 @@ enum nl80211_mfp {
 	NL80211_MFP_REQUIRED,
 };
 
+enum nl80211_wpa_versions {
+	NL80211_WPA_VERSION_1 = 1 << 0,
+	NL80211_WPA_VERSION_2 = 1 << 1,
+};
+
+/**
+ * enum nl80211_key_attributes - key attributes
+ * @__NL80211_KEY_INVALID: invalid
+ * @NL80211_KEY_DATA: (temporal) key data; for TKIP this consists of
+ *	16 bytes encryption key followed by 8 bytes each for TX and RX MIC
+ *	keys
+ * @NL80211_KEY_IDX: key ID (u8, 0-3)
+ * @NL80211_KEY_CIPHER: key cipher suite (u32, as defined by IEEE 802.11
+ *	section 7.3.2.25.1, e.g. 0x000FAC04)
+ * @NL80211_KEY_SEQ: transmit key sequence number (IV/PN) for TKIP and
+ *	CCMP keys, each six bytes in little endian
+ * @NL80211_KEY_DEFAULT: flag indicating default key
+ * @NL80211_KEY_DEFAULT_MGMT: flag indicating default management key
+ * @__NL80211_KEY_AFTER_LAST: internal
+ * @NL80211_KEY_MAX: highest key attribute
+ */
+enum nl80211_key_attributes {
+	__NL80211_KEY_INVALID,
+	NL80211_KEY_DATA,
+	NL80211_KEY_IDX,
+	NL80211_KEY_CIPHER,
+	NL80211_KEY_SEQ,
+	NL80211_KEY_DEFAULT,
+	NL80211_KEY_DEFAULT_MGMT,
+
+	/* keep last */
+	__NL80211_KEY_AFTER_LAST,
+	NL80211_KEY_MAX = __NL80211_KEY_AFTER_LAST - 1
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index 2ae5b1a..fcb602b 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -441,9 +441,11 @@ struct wpa_driver_capa {
 #define WPA_DRIVER_FLAGS_WIRED		0x00000010
 /* Driver provides separate commands for authentication and association (SME in
  * wpa_supplicant). */
-#define WPA_DRIVER_FLAGS_SME		0x00000020
+#define WPA_DRIVER_FLAGS_SME_AUTH	0x00000020
 /* Driver supports AP mode */
 #define WPA_DRIVER_FLAGS_AP		0x00000040
+/* Driver supports connect API */
+#define WPA_DRIVER_FLAGS_SME_CONNECT	0x00000080
 	unsigned int flags;
 
 	int max_scan_ssids;
@@ -1333,6 +1335,21 @@ struct wpa_driver_ops {
 	 * Returns: 0 on success, -1 on failure
 	 */
 	int (*set_supp_port)(void *priv, int authorized);
+
+	/**
+	 * connect - Request driver to connect
+	 * @priv: private driver interface data
+	 * @params: connect parameters
+	 * Returns: 0 on success, -1 on failure
+	 *
+	 * This is an optional function that can be used with drivers that
+	 * support connect (both authentication and association) API. If
+	 * driver SME is not supported (both connect and authenticate are
+	 * not implemented), associate() function is expected to take care
+	 * of IEEE 802.11 authentication and association, too.
+	 */
+	int (*connect)(void *priv, struct wpa_driver_associate_params *params);
+	int (*disconnect)(void *priv, u8 *addr, int reason_code);
 };
 
 /**
diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index 9b2bf7c..c032ddc 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -739,6 +739,40 @@ static void mlme_event_assoc(struct wpa_driver_nl80211_data *drv,
 	wpa_supplicant_event(drv->ctx, EVENT_ASSOC, &event);
 }
 
+static void mlme_event_connect(struct wpa_driver_nl80211_data *drv,
+			       enum nl80211_commands cmd, struct nlattr *status,
+			       struct nlattr *addr, struct nlattr *req_ie,
+			       struct nlattr *resp_ie)
+{
+	union wpa_event_data event;
+
+	os_memset(&event, 0, sizeof(event));
+	if (cmd == NL80211_CMD_CONNECT &&
+	    nla_get_u16(status) != WLAN_STATUS_SUCCESS) {
+		if (resp_ie) {
+			event.assoc_reject.resp_ies = nla_data(resp_ie);
+			event.assoc_reject.resp_ies_len = nla_len(resp_ie);
+		}
+		event.assoc_reject.status_code = nla_get_u16(status);
+		wpa_supplicant_event(drv->ctx, EVENT_ASSOC_REJECT, &event);
+		return;
+	}
+
+	drv->associated = 1;
+	if (addr)
+		os_memcpy(drv->bssid, nla_data(addr), ETH_ALEN);
+
+	if (req_ie) {
+		event.assoc_info.req_ies = nla_data(req_ie);
+		event.assoc_info.req_ies_len = nla_len(req_ie);
+	}
+	if (resp_ie) {
+		event.assoc_info.resp_ies = nla_data(resp_ie);
+		event.assoc_info.resp_ies_len = nla_len(resp_ie);
+	}
+
+	wpa_supplicant_event(drv->ctx, EVENT_ASSOC, &event);
+}
 
 static void mlme_timeout_event(struct wpa_driver_nl80211_data *drv,
 			       enum nl80211_commands cmd, struct nlattr *addr)
@@ -895,6 +929,17 @@ static int process_event(struct nl_msg *msg, void *arg)
 		mlme_event(drv, gnlh->cmd, tb[NL80211_ATTR_FRAME],
 			   tb[NL80211_ATTR_MAC], tb[NL80211_ATTR_TIMED_OUT]);
 		break;
+	case NL80211_CMD_CONNECT:
+	case NL80211_CMD_ROAM:
+		mlme_event_connect(drv, gnlh->cmd, tb[NL80211_ATTR_STATUS_CODE],
+				   tb[NL80211_ATTR_MAC],
+				   tb[NL80211_ATTR_REQ_IE],
+				   tb[NL80211_ATTR_RESP_IE]);
+		break;
+	case NL80211_CMD_DISCONNECT:
+		drv->associated = 0;
+		wpa_supplicant_event(drv->ctx, EVENT_DISASSOC, NULL);
+		break;
 #endif /* HOSTAPD */
 	case NL80211_CMD_MICHAEL_MIC_FAILURE:
 		mlme_event_michael_mic_failure(drv, tb);
@@ -1003,6 +1048,8 @@ nla_put_failure:
 struct wiphy_info_data {
 	int max_scan_ssids;
 	int ap_supported;
+	int auth_supported;
+	int connect_supported;
 };
 
 
@@ -1031,6 +1078,19 @@ static int wiphy_info_handler(struct nl_msg *msg, void *arg)
 		}
 	}
 
+	if (tb[NL80211_ATTR_SUPPORTED_COMMANDS]) {
+		struct nlattr *nl_cmd;
+		int i;
+
+		nla_for_each_nested(nl_cmd,
+				    tb[NL80211_ATTR_SUPPORTED_COMMANDS], i) {
+			if (nla_get_u32(nl_cmd) == NL80211_CMD_AUTHENTICATE)
+				info->auth_supported = 1;
+			if (nla_get_u32(nl_cmd) == NL80211_CMD_CONNECT)
+				info->connect_supported = 1;
+		}
+	}
+
 	return NL_SKIP;
 }
 
@@ -1078,6 +1138,12 @@ static void wpa_driver_nl80211_capa(struct wpa_driver_nl80211_data *drv)
 	drv->capa.max_scan_ssids = info.max_scan_ssids;
 	if (info.ap_supported)
 		drv->capa.flags |= WPA_DRIVER_FLAGS_AP;
+
+	if (info.auth_supported)
+		drv->capa.flags |= WPA_DRIVER_FLAGS_SME_AUTH;
+
+	if (info.connect_supported)
+		drv->capa.flags |= WPA_DRIVER_FLAGS_SME_CONNECT;
 }
 #endif /* HOSTAPD */
 
@@ -1227,8 +1293,6 @@ static void * wpa_driver_nl80211_init(void *ctx, const char *ifname)
 		return NULL;
 	}
 
-	drv->capa.flags |= WPA_DRIVER_FLAGS_SME;
-
 	drv->ioctl_sock = socket(PF_INET, SOCK_DGRAM, 0);
 	if (drv->ioctl_sock < 0) {
 		perror("socket(PF_INET,SOCK_DGRAM)");
@@ -1658,19 +1722,22 @@ static int nl_set_encr(int ifindex, struct wpa_driver_nl80211_data *drv,
 		case WPA_ALG_WEP:
 			if (key_len == 5)
 				NLA_PUT_U32(msg, NL80211_ATTR_KEY_CIPHER,
-					    0x000FAC01);
+					    WLAN_CIPHER_SUITE_WEP40);
 			else
 				NLA_PUT_U32(msg, NL80211_ATTR_KEY_CIPHER,
-					    0x000FAC05);
+					    WLAN_CIPHER_SUITE_WEP104);
 			break;
 		case WPA_ALG_TKIP:
-			NLA_PUT_U32(msg, NL80211_ATTR_KEY_CIPHER, 0x000FAC02);
+			NLA_PUT_U32(msg, NL80211_ATTR_KEY_CIPHER,
+				    WLAN_CIPHER_SUITE_TKIP);
 			break;
 		case WPA_ALG_CCMP:
-			NLA_PUT_U32(msg, NL80211_ATTR_KEY_CIPHER, 0x000FAC04);
+			NLA_PUT_U32(msg, NL80211_ATTR_KEY_CIPHER,
+				    WLAN_CIPHER_SUITE_CCMP);
 			break;
 		case WPA_ALG_IGTK:
-			NLA_PUT_U32(msg, NL80211_ATTR_KEY_CIPHER, 0x000FAC06);
+			NLA_PUT_U32(msg, NL80211_ATTR_KEY_CIPHER,
+				    WLAN_CIPHER_SUITE_AES_CMAC);
 			break;
 		default:
 			wpa_printf(MSG_ERROR, "%s: Unsupported encryption "
@@ -1737,6 +1804,60 @@ nla_put_failure:
 
 #ifndef HOSTAPD
 
+static int nl80211_set_conn_keys(void *priv,
+				  struct wpa_driver_associate_params *params,
+				  struct nl_msg *msg)
+{
+	int i, privacy = 0;
+	struct nlattr *nl_keys, *nl_key;
+
+	for (i = 0; i < 4; i++) {
+		if (!params->wep_key[i])
+			continue;
+		privacy = 1;
+		break;
+	}
+	if (!privacy)
+		return 0;
+
+	NLA_PUT_FLAG(msg, NL80211_ATTR_PRIVACY);
+
+	nl_keys = nla_nest_start(msg, NL80211_ATTR_KEYS);
+	if (!nl_keys)
+		goto nla_put_failure;
+
+	for (i = 0; i < 4; i++) {
+		if (!params->wep_key[i])
+			continue;
+
+		nl_key = nla_nest_start(msg, i);
+		if (!nl_key)
+			goto nla_put_failure;
+
+		NLA_PUT(msg, NL80211_KEY_DATA, params->wep_key_len[i],
+			params->wep_key[i]);
+		if (params->wep_key_len[i] == 5)
+			NLA_PUT_U32(msg, NL80211_KEY_CIPHER,
+				    WLAN_CIPHER_SUITE_WEP40);
+		else
+			NLA_PUT_U32(msg, NL80211_KEY_CIPHER,
+				    WLAN_CIPHER_SUITE_WEP104);
+
+		NLA_PUT_U8(msg, NL80211_KEY_IDX, i);
+
+		if (i == params->wep_tx_keyidx)
+			NLA_PUT_FLAG(msg, NL80211_KEY_DEFAULT);
+
+		nla_nest_end(msg, nl_key);
+	}
+	nla_nest_end(msg, nl_keys);
+
+	return 0;
+
+nla_put_failure:
+	return -ENOBUFS;
+}
+
 static int wpa_driver_nl80211_set_key(void *priv, wpa_alg alg,
 				      const u8 *addr, int key_idx,
 				      int set_tx, const u8 *seq,
@@ -1883,6 +2004,164 @@ nla_put_failure:
 	return ret;
 }
 
+static int wpa_driver_nl80211_connect(
+	void *priv, struct wpa_driver_associate_params *params)
+{
+	struct wpa_driver_nl80211_data *drv = priv;
+	struct nl_msg *msg;
+	enum nl80211_auth_type type;
+	int ret = 0;
+
+	if (!(drv->capa.flags & WPA_DRIVER_FLAGS_SME_CONNECT))
+		return -EOPNOTSUPP;
+
+	msg = nlmsg_alloc();
+	if (!msg)
+		return -1;
+
+	wpa_printf(MSG_DEBUG, "nl80211: Connect (ifindex=%d)", drv->ifindex);
+	genlmsg_put(msg, 0, 0, genl_family_get_id(drv->nl80211), 0, 0,
+		    NL80211_CMD_CONNECT, 0);
+
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, drv->ifindex);
+	if (params->bssid) {
+		wpa_printf(MSG_DEBUG, "  * bssid=" MACSTR,
+			   MAC2STR(params->bssid));
+		NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, params->bssid);
+	}
+	if (params->freq) {
+		wpa_printf(MSG_DEBUG, "  * freq=%d", params->freq);
+		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, params->freq);
+	}
+	if (params->ssid) {
+		wpa_hexdump_ascii(MSG_DEBUG, "  * SSID",
+				  params->ssid, params->ssid_len);
+		NLA_PUT(msg, NL80211_ATTR_SSID, params->ssid_len,
+			params->ssid);
+		if (params->ssid_len > sizeof(drv->ssid))
+			goto nla_put_failure;
+		os_memcpy(drv->ssid, params->ssid, params->ssid_len);
+		drv->ssid_len = params->ssid_len;
+	}
+	wpa_hexdump(MSG_DEBUG, "  * IEs", params->wpa_ie, params->wpa_ie_len);
+	if (params->wpa_ie)
+		NLA_PUT(msg, NL80211_ATTR_IE, params->wpa_ie_len,
+			params->wpa_ie);
+
+	if (params->auth_alg & AUTH_ALG_OPEN_SYSTEM)
+		type = NL80211_AUTHTYPE_OPEN_SYSTEM;
+	else if (params->auth_alg & AUTH_ALG_SHARED_KEY)
+		type = NL80211_AUTHTYPE_SHARED_KEY;
+	else if (params->auth_alg & AUTH_ALG_LEAP)
+		type = NL80211_AUTHTYPE_NETWORK_EAP;
+	else if (params->auth_alg & AUTH_ALG_FT)
+		type = NL80211_AUTHTYPE_FT;
+	else
+		goto nla_put_failure;
+
+	wpa_printf(MSG_DEBUG, "  * Auth Type %d", type);
+	NLA_PUT_U32(msg, NL80211_ATTR_AUTH_TYPE, type);
+
+	if (params->wpa_ie && params->wpa_ie_len) {
+		enum nl80211_wpa_versions ver;
+
+		if (params->wpa_ie[0] == WLAN_EID_RSN)
+			ver = NL80211_WPA_VERSION_2;
+		else
+			ver = NL80211_WPA_VERSION_1;
+
+		wpa_printf(MSG_DEBUG, "  * WPA Version %d", ver);
+		NLA_PUT_U32(msg, NL80211_ATTR_WPA_VERSIONS, ver);
+	}
+
+	if (params->pairwise_suite != CIPHER_NONE) {
+		int cipher = IW_AUTH_CIPHER_NONE;
+
+		switch (params->pairwise_suite) {
+		case CIPHER_WEP40:
+			cipher = WLAN_CIPHER_SUITE_WEP40;
+			break;
+		case CIPHER_WEP104:
+			cipher = WLAN_CIPHER_SUITE_WEP104;
+			break;
+		case CIPHER_CCMP:
+			cipher = WLAN_CIPHER_SUITE_CCMP;
+			break;
+		case CIPHER_TKIP:
+		default:
+			cipher = WLAN_CIPHER_SUITE_TKIP;
+			break;
+		}
+		NLA_PUT_U32(msg, NL80211_ATTR_CIPHER_SUITES_PAIRWISE, cipher);
+	}
+
+	if (params->group_suite != CIPHER_NONE) {
+		int cipher = IW_AUTH_CIPHER_NONE;
+
+		switch (params->group_suite) {
+		case CIPHER_WEP40:
+			cipher = WLAN_CIPHER_SUITE_WEP40;
+			break;
+		case CIPHER_WEP104:
+			cipher = WLAN_CIPHER_SUITE_WEP104;
+			break;
+		case CIPHER_CCMP:
+			cipher = WLAN_CIPHER_SUITE_CCMP;
+			break;
+		case CIPHER_TKIP:
+		default:
+			cipher = WLAN_CIPHER_SUITE_TKIP;
+			break;
+		}
+		NLA_PUT_U32(msg, NL80211_ATTR_CIPHER_SUITE_GROUP, cipher);
+	}
+
+	if (params->key_mgmt_suite == KEY_MGMT_802_1X ||
+	    params->key_mgmt_suite == KEY_MGMT_PSK) {
+		int mgmt = WLAN_AKM_SUITE_PSK;
+
+		switch (params->key_mgmt_suite) {
+		case KEY_MGMT_802_1X:
+			mgmt = WLAN_AKM_SUITE_8021X;
+			break;
+		case KEY_MGMT_PSK:
+		default:
+			mgmt = WLAN_AKM_SUITE_PSK;
+			break;
+		}
+		NLA_PUT_U32(msg, NL80211_ATTR_AKM_SUITES, mgmt);
+	}
+
+	ret = nl80211_set_conn_keys(drv, params, msg);
+	if (ret)
+		goto nla_put_failure;
+
+	ret = send_and_recv_msgs(drv, msg, NULL, NULL);
+	msg = NULL;
+	if (ret) {
+		wpa_printf(MSG_DEBUG, "nl80211: MLME connect failed: ret=%d "
+			   "(%s)", ret, strerror(-ret));
+		goto nla_put_failure;
+	}
+	ret = 0;
+	wpa_printf(MSG_DEBUG, "nl80211: Connect request send successfully");
+
+nla_put_failure:
+	nlmsg_free(msg);
+	return ret;
+
+}
+
+static int wpa_driver_nl80211_disconnect(void *priv, u8 *addr, int reason_code)
+{
+	struct wpa_driver_nl80211_data *drv = priv;
+
+	wpa_printf(MSG_DEBUG, "%s", __func__);
+	drv->associated = 0;
+	return wpa_driver_nl80211_mlme(drv, addr, NL80211_CMD_DISCONNECT,
+				       reason_code);
+}
+
 #endif /* HOSTAPD */
 
 
@@ -4060,6 +4339,8 @@ const struct wpa_driver_ops wpa_driver_nl80211_ops = {
 	.get_capa = wpa_driver_nl80211_get_capa,
 	.set_operstate = wpa_driver_nl80211_set_operstate,
 	.set_supp_port = wpa_driver_nl80211_set_supp_port,
+	.connect = wpa_driver_nl80211_connect,
+	.disconnect = wpa_driver_nl80211_disconnect,
 #endif /* HOSTAPD */
 	.set_country = wpa_driver_nl80211_set_country,
 	.set_mode = wpa_driver_nl80211_set_mode,
diff --git a/wpa_supplicant/driver_i.h b/wpa_supplicant/driver_i.h
index 4cb5372..e5a8ef4 100644
--- a/wpa_supplicant/driver_i.h
+++ b/wpa_supplicant/driver_i.h
@@ -448,4 +448,22 @@ static inline int wpa_drv_set_supp_port(struct wpa_supplicant *wpa_s,
 	return 0;
 }
 
+static inline int wpa_drv_connect(struct wpa_supplicant *wpa_s,
+				  struct wpa_driver_associate_params *params)
+{
+	if (wpa_s->driver->connect)
+		return wpa_s->driver->connect(wpa_s->drv_priv, params);
+
+	return -1;
+}
+
+static inline int wpa_drv_disconnect(struct wpa_supplicant *wpa_s, u8 *addr,
+				     int reason_code)
+{
+	if (wpa_s->driver->disconnect)
+		return wpa_s->driver->disconnect(wpa_s->drv_priv, addr,
+						 reason_code);
+	return -1;
+}
+
 #endif /* DRIVER_I_H */
diff --git a/wpa_supplicant/sme.c b/wpa_supplicant/sme.c
index 0d729ef..426afd2 100644
--- a/wpa_supplicant/sme.c
+++ b/wpa_supplicant/sme.c
@@ -238,6 +238,175 @@ void sme_authenticate(struct wpa_supplicant *wpa_s,
 	 */
 }
 
+void sme_connect(struct wpa_supplicant *wpa_s, struct wpa_scan_res *bss,
+		 struct wpa_ssid *ssid)
+{
+	struct wpa_driver_associate_params params;
+	const u8 *ie;
+	int i;
+
+	if (bss == NULL) {
+		wpa_printf(MSG_ERROR, "SME: No scan result available for the "
+			   "network");
+		return;
+	}
+
+	os_memset(&params, 0, sizeof(params));
+	wpa_s->reassociate = 0;
+
+	params.freq = bss->freq;
+	params.bssid = bss->bssid;
+	ie = wpa_scan_get_ie(bss, WLAN_EID_SSID);
+	if (ie == NULL) {
+		wpa_printf(MSG_ERROR, "SME: SSID not available for the BSS");
+		return;
+	}
+	params.ssid = ie + 2;
+	params.ssid_len = ie[1];
+
+	wpa_s->sme.freq = params.freq;
+	os_memcpy(wpa_s->sme.ssid, params.ssid, params.ssid_len);
+	wpa_s->sme.ssid_len = params.ssid_len;
+
+	params.auth_alg = AUTH_ALG_OPEN_SYSTEM;
+#ifdef IEEE8021X_EAPOL
+	if (ssid->key_mgmt & WPA_KEY_MGMT_IEEE8021X_NO_WPA) {
+		if (ssid->leap) {
+			if (ssid->non_leap == 0)
+				params.auth_alg = AUTH_ALG_LEAP;
+			else
+				params.auth_alg |= AUTH_ALG_LEAP;
+		}
+	}
+#endif /* IEEE8021X_EAPOL */
+	wpa_printf(MSG_DEBUG, "Automatic auth_alg selection: 0x%x",
+		   params.auth_alg);
+	if (ssid->auth_alg) {
+		params.auth_alg = 0;
+		if (ssid->auth_alg & WPA_AUTH_ALG_OPEN)
+			params.auth_alg |= AUTH_ALG_OPEN_SYSTEM;
+		if (ssid->auth_alg & WPA_AUTH_ALG_SHARED)
+			params.auth_alg |= AUTH_ALG_SHARED_KEY;
+		if (ssid->auth_alg & WPA_AUTH_ALG_LEAP)
+			params.auth_alg |= AUTH_ALG_LEAP;
+		wpa_printf(MSG_DEBUG, "Overriding auth_alg selection: 0x%x",
+			   params.auth_alg);
+	}
+
+	for (i = 0; i < NUM_WEP_KEYS; i++) {
+		if (ssid->wep_key_len[i])
+			params.wep_key[i] = ssid->wep_key[i];
+		params.wep_key_len[i] = ssid->wep_key_len[i];
+	}
+	params.wep_tx_keyidx = ssid->wep_tx_keyidx;
+
+	os_memset(wpa_s->bssid, 0, ETH_ALEN);
+	os_memcpy(wpa_s->pending_bssid, bss->bssid, ETH_ALEN);
+
+	if (bss && (wpa_scan_get_vendor_ie(bss, WPA_IE_VENDOR_TYPE) ||
+		    wpa_scan_get_ie(bss, WLAN_EID_RSN)) &&
+	    (ssid->key_mgmt & (WPA_KEY_MGMT_IEEE8021X | WPA_KEY_MGMT_PSK |
+			       WPA_KEY_MGMT_FT_IEEE8021X |
+			       WPA_KEY_MGMT_FT_PSK |
+			       WPA_KEY_MGMT_IEEE8021X_SHA256 |
+			       WPA_KEY_MGMT_PSK_SHA256))) {
+		int try_opportunistic;
+		try_opportunistic = ssid->proactive_key_caching &&
+			(ssid->proto & WPA_PROTO_RSN);
+		if (pmksa_cache_set_current(wpa_s->wpa, NULL, bss->bssid,
+					    wpa_s->current_ssid,
+					    try_opportunistic) == 0)
+			eapol_sm_notify_pmkid_attempt(wpa_s->eapol, 1);
+		wpa_s->sme.assoc_req_ie_len = sizeof(wpa_s->sme.assoc_req_ie);
+		if (wpa_supplicant_set_suites(wpa_s, bss, ssid,
+					      wpa_s->sme.assoc_req_ie,
+					      &wpa_s->sme.assoc_req_ie_len)) {
+			wpa_printf(MSG_WARNING, "SME: Failed to set WPA key "
+				   "management and encryption suites");
+			return;
+		}
+	} else if (ssid->key_mgmt &
+		   (WPA_KEY_MGMT_PSK | WPA_KEY_MGMT_IEEE8021X |
+		    WPA_KEY_MGMT_WPA_NONE | WPA_KEY_MGMT_FT_PSK |
+		    WPA_KEY_MGMT_FT_IEEE8021X | WPA_KEY_MGMT_PSK_SHA256 |
+		    WPA_KEY_MGMT_IEEE8021X_SHA256)) {
+		wpa_s->sme.assoc_req_ie_len = sizeof(wpa_s->sme.assoc_req_ie);
+		if (wpa_supplicant_set_suites(wpa_s, NULL, ssid,
+					      wpa_s->sme.assoc_req_ie,
+					      &wpa_s->sme.assoc_req_ie_len)) {
+			wpa_printf(MSG_WARNING, "SME: Failed to set WPA key "
+				   "management and encryption suites (no scan "
+				   "results)");
+			return;
+		}
+#ifdef CONFIG_WPS
+	} else if (ssid->key_mgmt & WPA_KEY_MGMT_WPS) {
+		struct wpabuf *wps_ie;
+		wps_ie = wps_build_assoc_req_ie(wpas_wps_get_req_type(ssid));
+		if (wps_ie && wpabuf_len(wps_ie) <=
+		    sizeof(wpa_s->sme.assoc_req_ie)) {
+			wpa_s->sme.assoc_req_ie_len = wpabuf_len(wps_ie);
+			os_memcpy(wpa_s->sme.assoc_req_ie, wpabuf_head(wps_ie),
+				  wpa_s->sme.assoc_req_ie_len);
+		} else
+			wpa_s->sme.assoc_req_ie_len = 0;
+		wpabuf_free(wps_ie);
+		wpa_supplicant_set_non_wpa_policy(wpa_s, ssid);
+#endif /* CONFIG_WPS */
+	} else {
+		wpa_supplicant_set_non_wpa_policy(wpa_s, ssid);
+		wpa_s->sme.assoc_req_ie_len = 0;
+	}
+
+#ifdef CONFIG_IEEE80211W
+	switch (ssid->ieee80211w) {
+	case NO_IEEE80211W:
+		wpa_s->sme.mfp = NO_MGMT_FRAME_PROTECTION;
+		break;
+	case IEEE80211W_OPTIONAL:
+		wpa_s->sme.mfp = MGMT_FRAME_PROTECTION_OPTIONAL;
+		break;
+	case IEEE80211W_REQUIRED:
+		wpa_s->sme.mfp = MGMT_FRAME_PROTECTION_REQUIRED;
+		break;
+	}
+	if (ssid->ieee80211w != NO_IEEE80211W && bss) {
+		const u8 *rsn = wpa_scan_get_ie(bss, WLAN_EID_RSN);
+		struct wpa_ie_data _ie;
+		if (rsn && wpa_parse_wpa_ie(rsn, 2 + rsn[1], &_ie) == 0 &&
+		    _ie.capabilities &
+		    (WPA_CAPABILITY_MFPC | WPA_CAPABILITY_MFPR)) {
+			wpa_printf(MSG_DEBUG, "WPA: Selected AP supports MFP: "
+				   "require MFP");
+			wpa_s->sme.mfp = MGMT_FRAME_PROTECTION_REQUIRED;
+		}
+	}
+#endif /* CONFIG_IEEE80211W */
+
+	wpa_supplicant_cancel_scan(wpa_s);
+
+	wpa_msg(wpa_s, MSG_INFO, "Trying to connect with " MACSTR
+		" (SSID='%s' freq=%d MHz)", MAC2STR(params.bssid),
+		wpa_ssid_txt(params.ssid, params.ssid_len), params.freq);
+
+	wpa_clear_keys(wpa_s, bss->bssid);
+	wpa_supplicant_set_state(wpa_s, WPA_ASSOCIATING);
+	wpa_s->current_ssid = ssid;
+	wpa_supplicant_rsn_supp_set_config(wpa_s, wpa_s->current_ssid);
+	wpa_supplicant_initiate_eapol(wpa_s);
+
+	params.key_mgmt_suite = key_mgmt2driver(wpa_s->key_mgmt);
+	params.wpa_ie = wpa_s->sme.assoc_req_ie;
+	params.wpa_ie_len = wpa_s->sme.assoc_req_ie_len;
+	params.pairwise_suite = cipher_suite2driver(wpa_s->pairwise_cipher);
+	params.group_suite = cipher_suite2driver(wpa_s->group_cipher);
+
+	if (wpa_drv_connect(wpa_s, &params) < 0) {
+		wpa_msg(wpa_s, MSG_INFO, "Connect to the driver failed");
+		return;
+	}
+}
+
 
 void sme_event_auth(struct wpa_supplicant *wpa_s, union wpa_event_data *data)
 {
diff --git a/wpa_supplicant/sme.h b/wpa_supplicant/sme.h
index 2780041..fd5ea9c 100644
--- a/wpa_supplicant/sme.h
+++ b/wpa_supplicant/sme.h
@@ -19,6 +19,8 @@
 
 void sme_authenticate(struct wpa_supplicant *wpa_s,
 		      struct wpa_scan_res *bss, struct wpa_ssid *ssid);
+void sme_connect(struct wpa_supplicant *wpa_s, struct wpa_scan_res *bss,
+		 struct wpa_ssid *ssid);
 void sme_event_auth(struct wpa_supplicant *wpa_s, union wpa_event_data *data);
 int sme_update_ft_ies(struct wpa_supplicant *wpa_s, const u8 *md,
 		      const u8 *ies, size_t ies_len);
@@ -37,6 +39,12 @@ static inline void sme_authenticate(struct wpa_supplicant *wpa_s,
 {
 }
 
+static inline void sme_connect(struct wpa_supplicant *wpa_s,
+			       struct wpa_scan_res *bss,
+			       struct wpa_ssid *ssid)
+{
+}
+
 static inline void sme_event_auth(struct wpa_supplicant *wpa_s,
 				  union wpa_event_data *data)
 {
diff --git a/wpa_supplicant/wpa_supplicant.c b/wpa_supplicant/wpa_supplicant.c
index f1f929a..4282b14 100644
--- a/wpa_supplicant/wpa_supplicant.c
+++ b/wpa_supplicant/wpa_supplicant.c
@@ -640,7 +640,7 @@ static void wpa_supplicant_reconfig(int sig, void *eloop_ctx,
 }
 
 
-static wpa_cipher cipher_suite2driver(int cipher)
+wpa_cipher cipher_suite2driver(int cipher)
 {
 	switch (cipher) {
 	case WPA_CIPHER_NONE:
@@ -658,7 +658,7 @@ static wpa_cipher cipher_suite2driver(int cipher)
 }
 
 
-static wpa_key_mgmt key_mgmt2driver(int key_mgmt)
+wpa_key_mgmt key_mgmt2driver(int key_mgmt)
 {
 	switch (key_mgmt) {
 	case WPA_KEY_MGMT_NONE:
@@ -965,11 +965,16 @@ void wpa_supplicant_associate(struct wpa_supplicant *wpa_s,
 		return;
 	}
 
-	if (wpa_s->drv_flags & WPA_DRIVER_FLAGS_SME) {
+	if (wpa_s->drv_flags & WPA_DRIVER_FLAGS_SME_AUTH) {
 		sme_authenticate(wpa_s, bss, ssid);
 		return;
 	}
 
+	if (wpa_s->drv_flags & WPA_DRIVER_FLAGS_SME_CONNECT) {
+		sme_connect(wpa_s, bss, ssid);
+		return;
+	}
+
 	wpa_s->reassociate = 0;
 	if (bss) {
 #ifdef CONFIG_IEEE80211R
@@ -1303,9 +1308,12 @@ void wpa_supplicant_deauthenticate(struct wpa_supplicant *wpa_s,
 	if (!is_zero_ether_addr(wpa_s->bssid)) {
 		if (wpa_s->drv_flags & WPA_DRIVER_FLAGS_USER_SPACE_MLME)
 			ieee80211_sta_deauthenticate(wpa_s, reason_code);
-		else
+		else if (wpa_s->drv_flags & WPA_DRIVER_FLAGS_SME_AUTH)
 			wpa_drv_deauthenticate(wpa_s, wpa_s->bssid,
 					       reason_code);
+		else if (wpa_s->drv_flags & WPA_DRIVER_FLAGS_SME_CONNECT)
+			wpa_drv_disconnect(wpa_s, wpa_s->bssid, reason_code);
+
 		addr = wpa_s->bssid;
 	}
 	wpa_clear_keys(wpa_s, addr);
diff --git a/wpa_supplicant/wpa_supplicant_i.h b/wpa_supplicant/wpa_supplicant_i.h
index 63984d8..13896d9 100644
--- a/wpa_supplicant/wpa_supplicant_i.h
+++ b/wpa_supplicant/wpa_supplicant_i.h
@@ -392,6 +392,8 @@ int wpa_supplicant_reload_configuration(struct wpa_supplicant *wpa_s);
 
 const char * wpa_supplicant_state_txt(int state);
 int wpa_supplicant_driver_init(struct wpa_supplicant *wpa_s);
+wpa_cipher cipher_suite2driver(int cipher);
+wpa_key_mgmt key_mgmt2driver(int key_mgmt);
 int wpa_supplicant_set_suites(struct wpa_supplicant *wpa_s,
 			      struct wpa_scan_res *bss,
 			      struct wpa_ssid *ssid,
diff --git a/wpa_supplicant/wpas_glue.c b/wpa_supplicant/wpas_glue.c
index b1f8bf8..3cfcd32 100644
--- a/wpa_supplicant/wpas_glue.c
+++ b/wpa_supplicant/wpas_glue.c
@@ -478,7 +478,7 @@ static int wpa_supplicant_update_ft_ies(void *ctx, const u8 *md,
 	struct wpa_supplicant *wpa_s = ctx;
 	if (wpa_s->drv_flags & WPA_DRIVER_FLAGS_USER_SPACE_MLME)
 		return ieee80211_sta_update_ft_ies(wpa_s, md, ies, ies_len);
-	if (wpa_s->drv_flags & WPA_DRIVER_FLAGS_SME)
+	if (wpa_s->drv_flags & WPA_DRIVER_FLAGS_SME_AUTH)
 		return sme_update_ft_ies(wpa_s, md, ies, ies_len);
 	return wpa_drv_update_ft_ies(wpa_s, md, ies, ies_len);
 }
