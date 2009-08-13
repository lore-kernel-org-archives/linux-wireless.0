Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25438 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbZHMIxy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 04:53:54 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: j@w1.fi
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org,
	Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] nl80211 connect API support
Date: Thu, 13 Aug 2009 16:55:31 +0800
Message-Id: <1250153731-17208-2-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1250153731-17208-1-git-send-email-yi.zhu@intel.com>
References: <1250153731-17208-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 src/common/ieee802_11_defs.h      |   15 ++
 src/common/nl80211_copy.h         |   65 +++++++++
 src/drivers/driver.h              |   28 +++-
 src/drivers/driver_nl80211.c      |  289 ++++++++++++++++++++++++++++++++++++-
 wpa_supplicant/driver_i.h         |   18 +++
 wpa_supplicant/sme.c              |   43 +++++--
 wpa_supplicant/sme.h              |   15 ++-
 wpa_supplicant/wpa_supplicant.c   |    9 +-
 wpa_supplicant/wpa_supplicant_i.h |    2 +
 9 files changed, 455 insertions(+), 29 deletions(-)

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
index 2ae5b1a..cc56124 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -444,6 +444,8 @@ struct wpa_driver_capa {
 #define WPA_DRIVER_FLAGS_SME		0x00000020
 /* Driver supports AP mode */
 #define WPA_DRIVER_FLAGS_AP		0x00000040
+/* Driver supports connect API */
+#define WPA_DRIVER_FLAGS_CONNECT	0x00000080
 	unsigned int flags;
 
 	int max_scan_ssids;
@@ -1184,16 +1186,14 @@ struct wpa_driver_ops {
 	int (*scan2)(void *priv, struct wpa_driver_scan_params *params);
 
 	/**
-	 * authenticate - Request driver to authenticate
+	 * authenticate - Request driver to authenticate (deprecated)
 	 * @priv: private driver interface data
 	 * @params: authentication parameters
 	 * Returns: 0 on success, -1 on failure
 	 *
-	 * This is an optional function that can be used with drivers that
-	 * support separate authentication and association steps, i.e., when
-	 * wpa_supplicant can act as the SME. If not implemented, associate()
-	 * function is expected to take care of IEEE 802.11 authentication,
-	 * too.
+	 * This is an optional function that to make compatibility for wireless
+	 * stack that doesn't support connect API when driver SME is used
+	 * (WPA_DRIVER_FLAGS_SME).
 	 */
 	int (*authenticate)(void *priv,
 			    struct wpa_driver_auth_params *params);
@@ -1333,6 +1333,22 @@ struct wpa_driver_ops {
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
+	 * support connect (both authentication and association) step, i.e.,
+	 * when wpa_supplicant can act as the SME. If driver SME is not
+	 * supported (both connect and authenticate are not implemented),
+	 * associate() function is expected to take care of IEEE 802.11
+	 * authentication, too.
+	 */
+	int (*connect)(void *priv, struct wpa_driver_associate_params *params);
+	int (*disconnect)(void *priv, u8 *addr, int reason_code);
 };
 
 /**
diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index 9b2bf7c..ca3670c 100644
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
@@ -1003,6 +1048,7 @@ nla_put_failure:
 struct wiphy_info_data {
 	int max_scan_ssids;
 	int ap_supported;
+	int connect_supported;
 };
 
 
@@ -1031,6 +1077,19 @@ static int wiphy_info_handler(struct nl_msg *msg, void *arg)
 		}
 	}
 
+	info->connect_supported = 0;
+	if (tb[NL80211_ATTR_SUPPORTED_COMMANDS]) {
+		struct nlattr *nl_cmd;
+		int i;
+
+		nla_for_each_nested(nl_cmd,
+				    tb[NL80211_ATTR_SUPPORTED_COMMANDS], i)
+			if (nla_get_u32(nl_cmd) == NL80211_CMD_CONNECT) {
+				info->connect_supported = 1;
+				break;
+			}
+	}
+
 	return NL_SKIP;
 }
 
@@ -1078,6 +1137,9 @@ static void wpa_driver_nl80211_capa(struct wpa_driver_nl80211_data *drv)
 	drv->capa.max_scan_ssids = info.max_scan_ssids;
 	if (info.ap_supported)
 		drv->capa.flags |= WPA_DRIVER_FLAGS_AP;
+
+	if (info.connect_supported)
+		drv->capa.flags |= WPA_DRIVER_FLAGS_CONNECT;
 }
 #endif /* HOSTAPD */
 
@@ -1658,19 +1720,22 @@ static int nl_set_encr(int ifindex, struct wpa_driver_nl80211_data *drv,
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
@@ -1737,6 +1802,60 @@ nla_put_failure:
 
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
@@ -1883,6 +2002,164 @@ nla_put_failure:
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
+	if (!(drv->capa.flags & WPA_DRIVER_FLAGS_CONNECT))
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
 
 
@@ -4060,6 +4337,8 @@ const struct wpa_driver_ops wpa_driver_nl80211_ops = {
 	.get_capa = wpa_driver_nl80211_get_capa,
 	.set_operstate = wpa_driver_nl80211_set_operstate,
 	.set_supp_port = wpa_driver_nl80211_set_supp_port,
+	.connect = wpa_driver_nl80211_connect,
+	.disconnect = wpa_driver_nl80211_disconnect,
 #endif /* HOSTAPD */
 	.set_country = wpa_driver_nl80211_set_country,
 	.set_mode = wpa_driver_nl80211_set_mode,
diff --git a/wpa_supplicant/driver_i.h b/wpa_supplicant/driver_i.h
index 4cb5372..8e59de2 100644
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
+	return -EOPNOTSUPP;
+}
+
+static inline int wpa_drv_disconnect(struct wpa_supplicant *wpa_s, u8 *addr,
+				     int reason_code)
+{
+	if (wpa_s->driver->disconnect)
+		return wpa_s->driver->disconnect(wpa_s->drv_priv, addr,
+						 reason_code);
+	return -EOPNOTSUPP;
+}
+
 #endif /* DRIVER_I_H */
diff --git a/wpa_supplicant/sme.c b/wpa_supplicant/sme.c
index 0d729ef..3582c20 100644
--- a/wpa_supplicant/sme.c
+++ b/wpa_supplicant/sme.c
@@ -27,10 +27,10 @@
 #include "wps_supplicant.h"
 #include "sme.h"
 
-void sme_authenticate(struct wpa_supplicant *wpa_s,
-		      struct wpa_scan_res *bss, struct wpa_ssid *ssid)
+void sme_connect(struct wpa_supplicant *wpa_s, struct wpa_scan_res *bss,
+		 struct wpa_ssid *ssid)
 {
-	struct wpa_driver_auth_params params;
+	struct wpa_driver_associate_params params;
 	const u8 *ie;
 #ifdef CONFIG_IEEE80211R
 	const u8 *md = NULL;
@@ -181,8 +181,6 @@ void sme_authenticate(struct wpa_supplicant *wpa_s,
 			wpa_printf(MSG_DEBUG, "SME: Trying to use FT "
 				   "over-the-air");
 			params.auth_alg = AUTH_ALG_FT;
-			params.ie = wpa_s->sme.ft_ies;
-			params.ie_len = wpa_s->sme.ft_ies_len;
 		}
 	}
 #endif /* CONFIG_IEEE80211R */
@@ -224,10 +222,37 @@ void sme_authenticate(struct wpa_supplicant *wpa_s,
 	wpa_supplicant_rsn_supp_set_config(wpa_s, wpa_s->current_ssid);
 	wpa_supplicant_initiate_eapol(wpa_s);
 
-	if (wpa_drv_authenticate(wpa_s, &params) < 0) {
-		wpa_msg(wpa_s, MSG_INFO, "Authentication request to the "
-			"driver failed");
-		return;
+	params.key_mgmt_suite = key_mgmt2driver(wpa_s->key_mgmt);
+	params.wpa_ie = wpa_s->sme.assoc_req_ie;
+	params.wpa_ie_len = wpa_s->sme.assoc_req_ie_len;
+	params.pairwise_suite = cipher_suite2driver(wpa_s->pairwise_cipher);
+	params.group_suite = cipher_suite2driver(wpa_s->group_cipher);
+
+	if (wpa_drv_connect(wpa_s, &params) == -EOPNOTSUPP) {
+		struct wpa_driver_auth_params auth;
+
+		os_memset(&auth, 0, sizeof(auth));
+		auth.freq = params.freq;
+		auth.bssid = params.bssid;
+		auth.ssid = params.ssid;
+		auth.ssid_len = params.ssid_len;
+		auth.auth_alg = params.auth_alg;
+		if (auth.auth_alg == AUTH_ALG_FT) {
+			auth.ie = wpa_s->sme.ft_ies;
+			auth.ie_len = wpa_s->sme.ft_ies_len;
+		}
+		for (i = 0; i < NUM_WEP_KEYS; i++) {
+			if (params.wep_key_len[i])
+				auth.wep_key[i] = params.wep_key[i];
+			auth.wep_key_len[i] = params.wep_key_len[i];
+		}
+		auth.wep_tx_keyidx = params.wep_tx_keyidx;
+
+		if (wpa_drv_authenticate(wpa_s, &auth) < 0) {
+			wpa_msg(wpa_s, MSG_INFO, "Authentication request to "
+				"the driver failed");
+			return;
+		}
 	}
 
 	/* TODO: add timeout on authentication */
diff --git a/wpa_supplicant/sme.h b/wpa_supplicant/sme.h
index 2780041..87804e3 100644
--- a/wpa_supplicant/sme.h
+++ b/wpa_supplicant/sme.h
@@ -17,8 +17,8 @@
 
 #ifdef CONFIG_SME
 
-void sme_authenticate(struct wpa_supplicant *wpa_s,
-		      struct wpa_scan_res *bss, struct wpa_ssid *ssid);
+void sme_connect(struct wpa_supplicant *wpa_s, struct wpa_scan_res *bss,
+		 struct wpa_ssid *ssid);
 void sme_event_auth(struct wpa_supplicant *wpa_s, union wpa_event_data *data);
 int sme_update_ft_ies(struct wpa_supplicant *wpa_s, const u8 *md,
 		      const u8 *ies, size_t ies_len);
@@ -31,9 +31,9 @@ void sme_event_assoc_timed_out(struct wpa_supplicant *wpa_s,
 
 #else /* CONFIG_SME */
 
-static inline void sme_authenticate(struct wpa_supplicant *wpa_s,
-				    struct wpa_scan_res *bss,
-				    struct wpa_ssid *ssid)
+static inline void sme_connect(struct wpa_supplicant *wpa_s,
+			       struct wpa_scan_res *bss,
+			       struct wpa_ssid *ssid)
 {
 }
 
@@ -64,6 +64,11 @@ static inline void sme_event_assoc_timed_out(struct wpa_supplicant *wpa_s,
 {
 }
 
+void sme_connect(struct wpa_supplicant *wpa_s,
+		 struct wpa_scan_res *bss, struct wpa_ssid *ssid);
+{
+}
+
 #endif /* CONFIG_SME */
 
 #endif /* SME_H */
diff --git a/wpa_supplicant/wpa_supplicant.c b/wpa_supplicant/wpa_supplicant.c
index f1f929a..3797955 100644
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
@@ -966,7 +966,7 @@ void wpa_supplicant_associate(struct wpa_supplicant *wpa_s,
 	}
 
 	if (wpa_s->drv_flags & WPA_DRIVER_FLAGS_SME) {
-		sme_authenticate(wpa_s, bss, ssid);
+		sme_connect(wpa_s, bss, ssid);
 		return;
 	}
 
@@ -1303,7 +1303,8 @@ void wpa_supplicant_deauthenticate(struct wpa_supplicant *wpa_s,
 	if (!is_zero_ether_addr(wpa_s->bssid)) {
 		if (wpa_s->drv_flags & WPA_DRIVER_FLAGS_USER_SPACE_MLME)
 			ieee80211_sta_deauthenticate(wpa_s, reason_code);
-		else
+		else if (wpa_drv_disconnect(wpa_s, wpa_s->bssid, reason_code)
+			 == -EOPNOTSUPP)
 			wpa_drv_deauthenticate(wpa_s, wpa_s->bssid,
 					       reason_code);
 		addr = wpa_s->bssid;
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
-- 
1.6.0.4

