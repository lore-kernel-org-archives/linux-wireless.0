Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:38260 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751532AbZH1K1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 06:27:48 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [RFC PATCH 01/10] rndis_wlan: add cfg80211 connect, disconnect,
	join_ibss and leave_ibss
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 28 Aug 2009 13:27:47 +0300
Message-ID: <20090828102747.15684.95437.stgit@fate.lan>
In-Reply-To: <20090828102742.15684.10566.stgit@fate.lan>
References: <20090828102742.15684.10566.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add cfg80211 connect functions for station and ad-hoc modes and
convert wext to use theim.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |  669 +++++++++++++++++++++++++------------
 1 files changed, 460 insertions(+), 209 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index c5a674d..c2af5be 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -358,13 +358,6 @@ struct ndis_80211_assoc_info {
 	__le32 offset_resp_ies;
 } __attribute__((packed));
 
-/* these have to match what is in wpa_supplicant */
-enum wpa_alg { WPA_ALG_NONE, WPA_ALG_WEP, WPA_ALG_TKIP, WPA_ALG_CCMP };
-enum wpa_cipher { CIPHER_NONE, CIPHER_WEP40, CIPHER_TKIP, CIPHER_CCMP,
-		  CIPHER_WEP104 };
-enum wpa_key_mgmt { KEY_MGMT_802_1X, KEY_MGMT_PSK, KEY_MGMT_NONE,
-		    KEY_MGMT_802_1X_NO_WPA, KEY_MGMT_WPA_NONE };
-
 /*
  *  private data
  */
@@ -379,6 +372,15 @@ enum wpa_key_mgmt { KEY_MGMT_802_1X, KEY_MGMT_PSK, KEY_MGMT_NONE,
 #define WORK_LINK_DOWN		(1<<1)
 #define WORK_SET_MULTICAST_LIST	(1<<2)
 
+#define RNDIS_WLAN_ALG_NONE	0
+#define RNDIS_WLAN_ALG_WEP	(1<<0)
+#define RNDIS_WLAN_ALG_TKIP	(1<<1)
+#define RNDIS_WLAN_ALG_CCMP	(1<<2)
+
+#define RNDIS_WLAN_KEY_MGMT_NONE	0
+#define RNDIS_WLAN_KEY_MGMT_802_1X	(1<<0)
+#define RNDIS_WLAN_KEY_MGMT_PSK		(1<<1)
+
 #define COMMAND_BUFFER_SIZE	(CONTROL_BUFFER_SIZE + sizeof(struct rndis_set))
 
 static const struct ieee80211_channel rndis_channels[] = {
@@ -469,15 +471,16 @@ struct rndis_wlan_private {
 	/* hardware state */
 	int radio_on;
 	int infra_mode;
+	bool connected;
 	struct ndis_80211_ssid essid;
 	__le32 current_command_oid;
 
 	/* encryption stuff */
 	int  encr_tx_key_index;
 	struct rndis_wlan_encr_key encr_keys[4];
+	enum nl80211_auth_type wpa_auth_type;
 	int  wpa_version;
 	int  wpa_keymgmt;
-	int  wpa_authalg;
 	int  wpa_ie_len;
 	u8  *wpa_ie;
 	int  wpa_cipher_pair;
@@ -503,12 +506,27 @@ static int rndis_set_tx_power(struct wiphy *wiphy, enum tx_power_setting type,
 				int dbm);
 static int rndis_get_tx_power(struct wiphy *wiphy, int *dbm);
 
+static int rndis_connect(struct wiphy *wiphy, struct net_device *dev,
+				struct cfg80211_connect_params *sme);
+
+static int rndis_disconnect(struct wiphy *wiphy, struct net_device *dev,
+				u16 reason_code);
+
+static int rndis_join_ibss(struct wiphy *wiphy, struct net_device *dev,
+					struct cfg80211_ibss_params *params);
+
+static int rndis_leave_ibss(struct wiphy *wiphy, struct net_device *dev);
+
 static struct cfg80211_ops rndis_config_ops = {
 	.change_virtual_intf = rndis_change_virtual_intf,
 	.scan = rndis_scan,
 	.set_wiphy_params = rndis_set_wiphy_params,
 	.set_tx_power = rndis_set_tx_power,
 	.get_tx_power = rndis_get_tx_power,
+	.connect = rndis_connect,
+	.disconnect = rndis_disconnect,
+	.join_ibss = rndis_join_ibss,
+	.leave_ibss = rndis_leave_ibss,
 };
 
 static void *rndis_wiphy_privid = &rndis_wiphy_privid;
@@ -545,6 +563,34 @@ static bool is_wpa_key(struct rndis_wlan_private *priv, int idx)
 }
 
 
+static int rndis_cipher_to_alg(u32 cipher)
+{
+	switch (cipher) {
+	default:
+		return RNDIS_WLAN_ALG_NONE;
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		return RNDIS_WLAN_ALG_WEP;
+	case WLAN_CIPHER_SUITE_TKIP:
+		return RNDIS_WLAN_ALG_TKIP;
+	case WLAN_CIPHER_SUITE_CCMP:
+		return RNDIS_WLAN_ALG_CCMP;
+	}
+}
+
+static int rndis_akm_suite_to_key_mgmt(u32 akm_suite)
+{
+	switch (akm_suite) {
+	default:
+		return RNDIS_WLAN_KEY_MGMT_NONE;
+	case WLAN_AKM_SUITE_8021X:
+		return RNDIS_WLAN_KEY_MGMT_802_1X;
+	case WLAN_AKM_SUITE_PSK:
+		return RNDIS_WLAN_KEY_MGMT_PSK;
+	}
+}
+
+
 #ifdef DEBUG
 static const char *oid_to_string(__le32 oid)
 {
@@ -925,35 +971,16 @@ static int set_infra_mode(struct usbnet *usbdev, int mode);
 static void restore_keys(struct usbnet *usbdev);
 static int rndis_check_bssid_list(struct usbnet *usbdev);
 
-static int get_essid(struct usbnet *usbdev, struct ndis_80211_ssid *ssid)
-{
-	int ret, len;
-
-	len = sizeof(*ssid);
-	ret = rndis_query_oid(usbdev, OID_802_11_SSID, ssid, &len);
-
-	if (ret != 0)
-		ssid->length = 0;
-
-#ifdef DEBUG
-	{
-		unsigned char tmp[NDIS_802_11_LENGTH_SSID + 1];
-
-		memcpy(tmp, ssid->essid, le32_to_cpu(ssid->length));
-		tmp[le32_to_cpu(ssid->length)] = 0;
-		devdbg(usbdev, "get_essid: '%s', ret: %d", tmp, ret);
-	}
-#endif
-	return ret;
-}
-
-
 static int set_essid(struct usbnet *usbdev, struct ndis_80211_ssid *ssid)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	int ret;
 
 	ret = rndis_set_oid(usbdev, OID_802_11_SSID, ssid, sizeof(*ssid));
+	if (ret < 0) {
+		devwarn(usbdev, "setting SSID failed (%08X)", ret);
+		return ret;
+	}
 	if (ret == 0) {
 		memcpy(&priv->essid, ssid, sizeof(priv->essid));
 		priv->radio_on = 1;
@@ -963,6 +990,25 @@ static int set_essid(struct usbnet *usbdev, struct ndis_80211_ssid *ssid)
 	return ret;
 }
 
+static int set_bssid(struct usbnet *usbdev, u8 bssid[ETH_ALEN])
+{
+	int ret;
+
+	ret = rndis_set_oid(usbdev, OID_802_11_BSSID, bssid, ETH_ALEN);
+	if (ret < 0) {
+		devwarn(usbdev, "setting BSSID[%pM] failed (%08X)", bssid, ret);
+		return ret;
+	}
+
+	return ret;
+}
+
+static int clear_bssid(struct usbnet *usbdev)
+{
+	u8 broadcast_mac[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+
+	return set_bssid(usbdev, broadcast_mac);
+}
 
 static int get_bssid(struct usbnet *usbdev, u8 bssid[ETH_ALEN])
 {
@@ -984,11 +1030,15 @@ static int get_association_info(struct usbnet *usbdev,
 				info, &len);
 }
 
-static int is_associated(struct usbnet *usbdev)
+static bool is_associated(struct usbnet *usbdev)
 {
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	u8 bssid[ETH_ALEN];
 	int ret;
 
+	if (!priv->radio_on)
+		return false;
+
 	ret = get_bssid(usbdev, bssid);
 
 	return (ret == 0 && !is_zero_ether_addr(bssid));
@@ -1032,34 +1082,34 @@ static int disassociate(struct usbnet *usbdev, int reset_ssid)
 }
 
 
-static int set_auth_mode(struct usbnet *usbdev, int wpa_version, int authalg)
+static int set_auth_mode(struct usbnet *usbdev, u32 wpa_version,
+				enum nl80211_auth_type auth_type, int keymgmt)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	__le32 tmp;
 	int auth_mode, ret;
 
 	devdbg(usbdev, "set_auth_mode: wpa_version=0x%x authalg=0x%x "
-		"keymgmt=0x%x", wpa_version, authalg, priv->wpa_keymgmt);
+		"keymgmt=0x%x", wpa_version, auth_type, keymgmt);
 
-	if (wpa_version & IW_AUTH_WPA_VERSION_WPA2) {
-		if (priv->wpa_keymgmt & IW_AUTH_KEY_MGMT_802_1X)
+	if (wpa_version & NL80211_WPA_VERSION_2) {
+		if (keymgmt & RNDIS_WLAN_KEY_MGMT_802_1X)
 			auth_mode = NDIS_80211_AUTH_WPA2;
 		else
 			auth_mode = NDIS_80211_AUTH_WPA2_PSK;
-	} else if (wpa_version & IW_AUTH_WPA_VERSION_WPA) {
-		if (priv->wpa_keymgmt & IW_AUTH_KEY_MGMT_802_1X)
+	} else if (wpa_version & NL80211_WPA_VERSION_1) {
+		if (keymgmt & RNDIS_WLAN_KEY_MGMT_802_1X)
 			auth_mode = NDIS_80211_AUTH_WPA;
-		else if (priv->wpa_keymgmt & IW_AUTH_KEY_MGMT_PSK)
+		else if (keymgmt & RNDIS_WLAN_KEY_MGMT_PSK)
 			auth_mode = NDIS_80211_AUTH_WPA_PSK;
 		else
 			auth_mode = NDIS_80211_AUTH_WPA_NONE;
-	} else if (authalg & IW_AUTH_ALG_SHARED_KEY) {
-		if (authalg & IW_AUTH_ALG_OPEN_SYSTEM)
-			auth_mode = NDIS_80211_AUTH_AUTO_SWITCH;
-		else
-			auth_mode = NDIS_80211_AUTH_SHARED;
-	} else
+	} else if (auth_type == NL80211_AUTHTYPE_SHARED_KEY)
+		auth_mode = NDIS_80211_AUTH_SHARED;
+	else if (auth_type == NL80211_AUTHTYPE_OPEN_SYSTEM)
 		auth_mode = NDIS_80211_AUTH_OPEN;
+	else
+		return -ENOTSUPP;
 
 	tmp = cpu_to_le32(auth_mode);
 	ret = rndis_set_oid(usbdev, OID_802_11_AUTHENTICATION_MODE, &tmp,
@@ -1070,7 +1120,9 @@ static int set_auth_mode(struct usbnet *usbdev, int wpa_version, int authalg)
 	}
 
 	priv->wpa_version = wpa_version;
-	priv->wpa_authalg = authalg;
+	priv->wpa_auth_type = auth_type;
+	priv->wpa_keymgmt = keymgmt;
+
 	return 0;
 }
 
@@ -1082,8 +1134,8 @@ static int set_priv_filter(struct usbnet *usbdev)
 
 	devdbg(usbdev, "set_priv_filter: wpa_version=0x%x", priv->wpa_version);
 
-	if (priv->wpa_version & IW_AUTH_WPA_VERSION_WPA2 ||
-	    priv->wpa_version & IW_AUTH_WPA_VERSION_WPA)
+	if (priv->wpa_version & NL80211_WPA_VERSION_2 ||
+	    priv->wpa_version & NL80211_WPA_VERSION_1)
 		tmp = cpu_to_le32(NDIS_80211_PRIV_8021X_WEP);
 	else
 		tmp = cpu_to_le32(NDIS_80211_PRIV_ACCEPT_ALL);
@@ -1100,19 +1152,17 @@ static int set_encr_mode(struct usbnet *usbdev, int pairwise, int groupwise)
 	int encr_mode, ret;
 
 	devdbg(usbdev, "set_encr_mode: cipher_pair=0x%x cipher_group=0x%x",
-		pairwise,
-		groupwise);
+		pairwise, groupwise);
 
-	if (pairwise & IW_AUTH_CIPHER_CCMP)
+	if (pairwise & RNDIS_WLAN_ALG_CCMP)
 		encr_mode = NDIS_80211_ENCR_CCMP_ENABLED;
-	else if (pairwise & IW_AUTH_CIPHER_TKIP)
+	else if (pairwise & RNDIS_WLAN_ALG_TKIP)
 		encr_mode = NDIS_80211_ENCR_TKIP_ENABLED;
-	else if (pairwise &
-		 (IW_AUTH_CIPHER_WEP40 | IW_AUTH_CIPHER_WEP104))
+	else if (pairwise & RNDIS_WLAN_ALG_WEP)
 		encr_mode = NDIS_80211_ENCR_WEP_ENABLED;
-	else if (groupwise & IW_AUTH_CIPHER_CCMP)
+	else if (groupwise & RNDIS_WLAN_ALG_CCMP)
 		encr_mode = NDIS_80211_ENCR_CCMP_ENABLED;
-	else if (groupwise & IW_AUTH_CIPHER_TKIP)
+	else if (groupwise & RNDIS_WLAN_ALG_TKIP)
 		encr_mode = NDIS_80211_ENCR_TKIP_ENABLED;
 	else
 		encr_mode = NDIS_80211_ENCR_DISABLED;
@@ -1131,18 +1181,6 @@ static int set_encr_mode(struct usbnet *usbdev, int pairwise, int groupwise)
 }
 
 
-static int set_assoc_params(struct usbnet *usbdev)
-{
-	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
-
-	set_auth_mode(usbdev, priv->wpa_version, priv->wpa_authalg);
-	set_priv_filter(usbdev);
-	set_encr_mode(usbdev, priv->wpa_cipher_pair, priv->wpa_cipher_group);
-
-	return 0;
-}
-
-
 static int set_infra_mode(struct usbnet *usbdev, int mode)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
@@ -1201,16 +1239,11 @@ static int set_frag_threshold(struct usbnet *usbdev, u32 frag_threshold)
 
 static void set_default_iw_params(struct usbnet *usbdev)
 {
-	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
-
-	priv->wpa_keymgmt = 0;
-	priv->wpa_version = 0;
-
 	set_infra_mode(usbdev, NDIS_80211_INFRA_INFRA);
-	set_auth_mode(usbdev, IW_AUTH_WPA_VERSION_DISABLED,
-				IW_AUTH_ALG_OPEN_SYSTEM);
+	set_auth_mode(usbdev, 0, NL80211_AUTHTYPE_OPEN_SYSTEM,
+						RNDIS_WLAN_KEY_MGMT_NONE);
 	set_priv_filter(usbdev);
-	set_encr_mode(usbdev, IW_AUTH_CIPHER_NONE, IW_AUTH_CIPHER_NONE);
+	set_encr_mode(usbdev, RNDIS_WLAN_ALG_NONE, RNDIS_WLAN_ALG_NONE);
 }
 
 
@@ -1224,8 +1257,40 @@ static int deauthenticate(struct usbnet *usbdev)
 }
 
 
+static int set_channel(struct usbnet *usbdev, int channel)
+{
+	struct ndis_80211_conf config;
+	unsigned int dsconfig;
+	int len, ret;
+
+	devdbg(usbdev, "set_channel(%d)", channel);
+
+	/* this OID is valid only when not associated */
+	if (is_associated(usbdev))
+		return 0;
+
+	dsconfig = ieee80211_dsss_chan_to_freq(channel) * 1000;
+
+	len = sizeof(config);
+	ret = rndis_query_oid(usbdev, OID_802_11_CONFIGURATION, &config, &len);
+	if (ret < 0) {
+		devdbg(usbdev, "set_channel: querying configuration failed");
+		return ret;
+	}
+
+	config.ds_config = cpu_to_le32(dsconfig);
+	ret = rndis_set_oid(usbdev, OID_802_11_CONFIGURATION, &config,
+								sizeof(config));
+
+	devdbg(usbdev, "set_channel: %d -> %d", channel, ret);
+
+	return ret;
+}
+
+
 /* index must be 0 - N, as per NDIS  */
-static int add_wep_key(struct usbnet *usbdev, char *key, int key_len, int index)
+static int add_wep_key(struct usbnet *usbdev, const u8 *key, int key_len,
+								int index)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ndis_80211_wep_key ndis_key;
@@ -1248,8 +1313,8 @@ static int add_wep_key(struct usbnet *usbdev, char *key, int key_len, int index)
 
 	if (index == priv->encr_tx_key_index) {
 		ndis_key.index |= NDIS_80211_ADDWEP_TRANSMIT_KEY;
-		ret = set_encr_mode(usbdev, IW_AUTH_CIPHER_WEP104,
-						IW_AUTH_CIPHER_NONE);
+		ret = set_encr_mode(usbdev, RNDIS_WLAN_ALG_WEP,
+							RNDIS_WLAN_ALG_NONE);
 		if (ret)
 			devwarn(usbdev, "encryption couldn't be enabled (%08X)",
 									ret);
@@ -1458,7 +1523,7 @@ static int remove_key(struct usbnet *usbdev, int index, u8 bssid[ETH_ALEN])
 
 	/* if it is transmit key, disable encryption */
 	if (index == priv->encr_tx_key_index)
-		set_encr_mode(usbdev, IW_AUTH_CIPHER_NONE, IW_AUTH_CIPHER_NONE);
+		set_encr_mode(usbdev, RNDIS_WLAN_ALG_NONE, RNDIS_WLAN_ALG_NONE);
 
 	return 0;
 }
@@ -1765,6 +1830,243 @@ static void rndis_get_scan_results(struct work_struct *work)
 	priv->scan_request = NULL;
 }
 
+static int rndis_connect(struct wiphy *wiphy, struct net_device *dev,
+					struct cfg80211_connect_params *sme)
+{
+	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
+	struct usbnet *usbdev = priv->usbdev;
+	struct ieee80211_channel *channel = sme->channel;
+	struct ndis_80211_ssid ssid;
+	int pairwise = RNDIS_WLAN_ALG_NONE;
+	int groupwise = RNDIS_WLAN_ALG_NONE;
+	int keymgmt = RNDIS_WLAN_KEY_MGMT_NONE;
+	int length, i, ret, chan = -1;
+
+	if (channel)
+		chan = ieee80211_frequency_to_channel(channel->center_freq);
+
+	groupwise = rndis_cipher_to_alg(sme->crypto.cipher_group);
+	for (i = 0; i < sme->crypto.n_ciphers_pairwise; i++)
+		pairwise |=
+			rndis_cipher_to_alg(sme->crypto.ciphers_pairwise[i]);
+
+	if (sme->crypto.n_ciphers_pairwise > 0 &&
+			pairwise == RNDIS_WLAN_ALG_NONE) {
+		deverr(usbdev, "Unsupported pairwise cipher");
+		return -ENOTSUPP;
+	}
+
+	for (i = 0; i < sme->crypto.n_akm_suites; i++)
+		keymgmt |=
+			rndis_akm_suite_to_key_mgmt(sme->crypto.akm_suites[i]);
+
+	if (sme->crypto.n_akm_suites > 0 &&
+			keymgmt == RNDIS_WLAN_KEY_MGMT_NONE) {
+		deverr(usbdev, "Invalid keymgmt");
+		return -ENOTSUPP;
+	}
+
+	devdbg(usbdev, "cfg80211.connect('%.32s':[%pM]:%d:[%d,0x%x:0x%x]:[0x%x:"
+			"0x%x]:0x%x)", sme->ssid, sme->bssid, chan,
+			sme->privacy, sme->crypto.wpa_versions, sme->auth_type,
+			groupwise, pairwise, keymgmt);
+
+	if (is_associated(usbdev))
+		disassociate(usbdev, false);
+
+	ret = set_infra_mode(usbdev, NDIS_80211_INFRA_INFRA);
+	if (ret < 0) {
+		devdbg(usbdev, "connect: set_infra_mode failed, %d", ret);
+		goto err_turn_radio_on;
+	}
+
+	ret = set_auth_mode(usbdev, sme->crypto.wpa_versions, sme->auth_type,
+								keymgmt);
+	if (ret < 0) {
+		devdbg(usbdev, "connect: set_auth_mode failed, %d", ret);
+		goto err_turn_radio_on;
+	}
+
+	set_priv_filter(usbdev);
+
+	ret = set_encr_mode(usbdev, pairwise, groupwise);
+	if (ret < 0) {
+		devdbg(usbdev, "connect: set_encr_mode failed, %d", ret);
+		goto err_turn_radio_on;
+	}
+
+	if (channel) {
+		ret = set_channel(usbdev, chan);
+		if (ret < 0) {
+			devdbg(usbdev, "connect: set_channel failed, %d", ret);
+			goto err_turn_radio_on;
+		}
+	}
+
+	if (sme->key && ((groupwise | pairwise) & RNDIS_WLAN_ALG_WEP)) {
+		priv->encr_tx_key_index = sme->key_idx;
+		ret = add_wep_key(usbdev, sme->key, sme->key_len, sme->key_idx);
+		if (ret < 0) {
+			devdbg(usbdev, "connect: add_wep_key failed, %d "
+				"(%d, %d)", ret, sme->key_len, sme->key_idx);
+			goto err_turn_radio_on;
+		}
+	}
+
+	if (sme->bssid && !is_zero_ether_addr(sme->bssid) &&
+				!is_broadcast_ether_addr(sme->bssid)) {
+		ret = set_bssid(usbdev, sme->bssid);
+		if (ret < 0) {
+			devdbg(usbdev, "connect: set_bssid failed, %d", ret);
+			goto err_turn_radio_on;
+		}
+	} else
+		clear_bssid(usbdev);
+
+	length = sme->ssid_len;
+	if (length > NDIS_802_11_LENGTH_SSID)
+		length = NDIS_802_11_LENGTH_SSID;
+
+	memset(&ssid, 0, sizeof(ssid));
+	ssid.length = cpu_to_le32(length);
+	memcpy(ssid.essid, sme->ssid, length);
+
+	/* Pause and purge rx queue, so we don't pass packets before
+	 * 'media connect'-indication.
+	 */
+	usbnet_pause_rx(usbdev);
+	usbnet_purge_paused_rxq(usbdev);
+
+	ret = set_essid(usbdev, &ssid);
+	if (ret < 0)
+		devdbg(usbdev, "connect: set_essid failed, %d", ret);
+	return ret;
+
+err_turn_radio_on:
+	disassociate(usbdev, 1);
+
+	return ret;
+}
+
+static int rndis_disconnect(struct wiphy *wiphy, struct net_device *dev,
+								u16 reason_code)
+{
+	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
+	struct usbnet *usbdev = priv->usbdev;
+
+	devdbg(usbdev, "cfg80211.disconnect(%d)", reason_code);
+
+	priv->connected = false;
+
+	return deauthenticate(usbdev);
+}
+
+static int rndis_join_ibss(struct wiphy *wiphy, struct net_device *dev,
+					struct cfg80211_ibss_params *params)
+{
+	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
+	struct usbnet *usbdev = priv->usbdev;
+	struct ieee80211_channel *channel = params->channel;
+	struct ndis_80211_ssid ssid;
+	enum nl80211_auth_type auth_type;
+	int ret, alg, length, chan = -1;
+
+	if (channel)
+		chan = ieee80211_frequency_to_channel(channel->center_freq);
+
+	/* TODO: How to handle ad-hoc encryption?
+	 * connect() has *key, join_ibss() doesn't. RNDIS requires key to be
+	 * pre-shared for encryption (open/shared/wpa), is key set before
+	 * join_ibss? Which auth_type to use (not in params)? What about WPA?
+	 */
+	if (params->privacy) {
+		auth_type = NL80211_AUTHTYPE_SHARED_KEY;
+		alg = RNDIS_WLAN_ALG_WEP;
+	} else {
+		auth_type = NL80211_AUTHTYPE_OPEN_SYSTEM;
+		alg = RNDIS_WLAN_ALG_NONE;
+	}
+
+	devdbg(usbdev, "cfg80211.join_ibss('%.32s':[%pM]:%d:%d)", params->ssid,
+					params->bssid, chan, params->privacy);
+
+	if (is_associated(usbdev))
+		disassociate(usbdev, false);
+
+	ret = set_infra_mode(usbdev, NDIS_80211_INFRA_ADHOC);
+	if (ret < 0) {
+		devdbg(usbdev, "join_ibss: set_infra_mode failed, %d", ret);
+		goto err_turn_radio_on;
+	}
+
+	ret = set_auth_mode(usbdev, 0, auth_type, RNDIS_WLAN_KEY_MGMT_NONE);
+	if (ret < 0) {
+		devdbg(usbdev, "join_ibss: set_auth_mode failed, %d", ret);
+		goto err_turn_radio_on;
+	}
+
+	set_priv_filter(usbdev);
+
+	ret = set_encr_mode(usbdev, alg, RNDIS_WLAN_ALG_NONE);
+	if (ret < 0) {
+		devdbg(usbdev, "join_ibss: set_encr_mode failed, %d", ret);
+		goto err_turn_radio_on;
+	}
+
+	if (channel) {
+		ret = set_channel(usbdev, chan);
+		if (ret < 0) {
+			devdbg(usbdev, "join_ibss: set_channel failed, %d",
+				ret);
+			goto err_turn_radio_on;
+		}
+	}
+
+	if (params->bssid && !is_zero_ether_addr(params->bssid) &&
+				!is_broadcast_ether_addr(params->bssid)) {
+		ret = set_bssid(usbdev, params->bssid);
+		if (ret < 0) {
+			devdbg(usbdev, "join_ibss: set_bssid failed, %d", ret);
+			goto err_turn_radio_on;
+		}
+	} else
+		clear_bssid(usbdev);
+
+	length = params->ssid_len;
+	if (length > NDIS_802_11_LENGTH_SSID)
+		length = NDIS_802_11_LENGTH_SSID;
+
+	memset(&ssid, 0, sizeof(ssid));
+	ssid.length = cpu_to_le32(length);
+	memcpy(ssid.essid, params->ssid, length);
+
+	/* Don't need to pause rx queue for ad-hoc. */
+	usbnet_purge_paused_rxq(usbdev);
+	usbnet_resume_rx(usbdev);
+
+	ret = set_essid(usbdev, &ssid);
+	if (ret < 0)
+		devdbg(usbdev, "join_ibss: set_essid failed, %d", ret);
+	return ret;
+
+err_turn_radio_on:
+	disassociate(usbdev, 1);
+
+	return ret;
+}
+
+static int rndis_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
+{
+	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
+	struct usbnet *usbdev = priv->usbdev;
+
+	devdbg(usbdev, "cfg80211.leave_ibss()");
+
+	priv->connected = false;
+
+	return deauthenticate(usbdev);
+}
+
 
 /*
  * wireless extension handlers
@@ -1777,7 +2079,10 @@ static int rndis_iw_commit(struct net_device *dev,
 	return 0;
 }
 
-
+#if 0
+/* Commented code out instead of removing to have more sane patch for review.
+ * Will be removed later in the set.
+ */
 static int rndis_iw_set_essid(struct net_device *dev,
     struct iw_request_info *info, union iwreq_data *wrqu, char *essid)
 {
@@ -1990,6 +2295,7 @@ static int rndis_iw_get_auth(struct net_device *dev,
 	}
 	return 0;
 }
+#endif
 
 
 static int rndis_iw_set_encode(struct net_device *dev,
@@ -2024,11 +2330,11 @@ static int rndis_iw_set_encode(struct net_device *dev,
 
 	/* global encryption state (for all keys) */
 	if (wrqu->data.flags & IW_ENCODE_OPEN)
-		ret = set_auth_mode(usbdev, IW_AUTH_WPA_VERSION_DISABLED,
-						IW_AUTH_ALG_OPEN_SYSTEM);
+		ret = set_auth_mode(usbdev, 0, NL80211_AUTHTYPE_OPEN_SYSTEM,
+						RNDIS_WLAN_KEY_MGMT_NONE);
 	else /*if (wrqu->data.flags & IW_ENCODE_RESTRICTED)*/
-		ret = set_auth_mode(usbdev, IW_AUTH_WPA_VERSION_DISABLED,
-						IW_AUTH_ALG_SHARED_KEY);
+		ret = set_auth_mode(usbdev, 0, NL80211_AUTHTYPE_SHARED_KEY,
+						RNDIS_WLAN_KEY_MGMT_NONE);
 	if (ret != 0)
 		return ret;
 
@@ -2077,7 +2383,7 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 		return -EINVAL;
 	}
 
-	if (ext->alg == WPA_ALG_WEP) {
+	if (ext->alg == IW_ENCODE_ALG_WEP) {
 		if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
 			priv->encr_tx_key_index = keyidx;
 		return add_wep_key(usbdev, ext->key, ext->key_len, keyidx);
@@ -2110,63 +2416,6 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 }
 
 
-static int rndis_iw_set_genie(struct net_device *dev,
-    struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
-{
-	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
-	int ret = 0;
-
-#ifdef DEBUG
-	int j;
-	u8 *gie = extra;
-	for (j = 0; j < wrqu->data.length; j += 8)
-		devdbg(usbdev,
-			"SIOCSIWGENIE %04x - "
-			"%02x %02x %02x %02x %02x %02x %02x %02x", j,
-			gie[j + 0], gie[j + 1], gie[j + 2], gie[j + 3],
-			gie[j + 4], gie[j + 5], gie[j + 6], gie[j + 7]);
-#endif
-	/* clear existing IEs */
-	if (priv->wpa_ie_len) {
-		kfree(priv->wpa_ie);
-		priv->wpa_ie_len = 0;
-	}
-
-	/* set new IEs */
-	priv->wpa_ie = kmalloc(wrqu->data.length, GFP_KERNEL);
-	if (priv->wpa_ie) {
-		priv->wpa_ie_len = wrqu->data.length;
-		memcpy(priv->wpa_ie, extra, priv->wpa_ie_len);
-	} else
-		ret = -ENOMEM;
-	return ret;
-}
-
-
-static int rndis_iw_get_genie(struct net_device *dev,
-    struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
-{
-	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
-
-	devdbg(usbdev, "SIOCGIWGENIE");
-
-	if (priv->wpa_ie_len == 0 || priv->wpa_ie == NULL) {
-		wrqu->data.length = 0;
-		return 0;
-	}
-
-	if (wrqu->data.length < priv->wpa_ie_len)
-		return -E2BIG;
-
-	wrqu->data.length = priv->wpa_ie_len;
-	memcpy(extra, priv->wpa_ie, priv->wpa_ie_len);
-
-	return 0;
-}
-
-
 static int rndis_iw_set_freq(struct net_device *dev,
     struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
@@ -2233,32 +2482,6 @@ static int rndis_iw_get_rate(struct net_device *dev,
 }
 
 
-static int rndis_iw_set_mlme(struct net_device *dev,
-    struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
-{
-	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
-	struct iw_mlme *mlme = (struct iw_mlme *)extra;
-	unsigned char bssid[ETH_ALEN];
-
-	get_bssid(usbdev, bssid);
-
-	if (memcmp(bssid, mlme->addr.sa_data, ETH_ALEN))
-		return -EINVAL;
-
-	switch (mlme->cmd) {
-	case IW_MLME_DEAUTH:
-		return deauthenticate(usbdev);
-	case IW_MLME_DISASSOC:
-		return disassociate(usbdev, priv->radio_on);
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	return 0;
-}
-
-
 static struct iw_statistics *rndis_get_wireless_stats(struct net_device *dev)
 {
 	struct usbnet *usbdev = netdev_priv(dev);
@@ -2283,12 +2506,12 @@ static const iw_handler rndis_iw_handler[] =
 	IW_IOCTL(SIOCSIWMODE)      = (iw_handler) cfg80211_wext_siwmode,
 	IW_IOCTL(SIOCGIWMODE)      = (iw_handler) cfg80211_wext_giwmode,
 	IW_IOCTL(SIOCGIWRANGE)     = (iw_handler) cfg80211_wext_giwrange,
-	IW_IOCTL(SIOCSIWAP)        = rndis_iw_set_bssid,
-	IW_IOCTL(SIOCGIWAP)        = rndis_iw_get_bssid,
+	IW_IOCTL(SIOCSIWAP)        = (iw_handler) cfg80211_wext_siwap,
+	IW_IOCTL(SIOCGIWAP)        = (iw_handler) cfg80211_wext_giwap,
 	IW_IOCTL(SIOCSIWSCAN)      = (iw_handler) cfg80211_wext_siwscan,
 	IW_IOCTL(SIOCGIWSCAN)      = (iw_handler) cfg80211_wext_giwscan,
-	IW_IOCTL(SIOCSIWESSID)     = rndis_iw_set_essid,
-	IW_IOCTL(SIOCGIWESSID)     = rndis_iw_get_essid,
+	IW_IOCTL(SIOCSIWESSID)     = (iw_handler) cfg80211_wext_siwessid,
+	IW_IOCTL(SIOCGIWESSID)     = (iw_handler) cfg80211_wext_giwessid,
 	IW_IOCTL(SIOCGIWRATE)      = rndis_iw_get_rate,
 	IW_IOCTL(SIOCSIWRTS)       = (iw_handler) cfg80211_wext_siwrts,
 	IW_IOCTL(SIOCGIWRTS)       = (iw_handler) cfg80211_wext_giwrts,
@@ -2298,11 +2521,10 @@ static const iw_handler rndis_iw_handler[] =
 	IW_IOCTL(SIOCGIWTXPOW)     = (iw_handler) cfg80211_wext_giwtxpower,
 	IW_IOCTL(SIOCSIWENCODE)    = rndis_iw_set_encode,
 	IW_IOCTL(SIOCSIWENCODEEXT) = rndis_iw_set_encode_ext,
-	IW_IOCTL(SIOCSIWAUTH)      = rndis_iw_set_auth,
-	IW_IOCTL(SIOCGIWAUTH)      = rndis_iw_get_auth,
-	IW_IOCTL(SIOCSIWGENIE)     = rndis_iw_set_genie,
-	IW_IOCTL(SIOCGIWGENIE)     = rndis_iw_get_genie,
-	IW_IOCTL(SIOCSIWMLME)      = rndis_iw_set_mlme,
+	IW_IOCTL(SIOCSIWAUTH)      = (iw_handler) cfg80211_wext_siwauth,
+	IW_IOCTL(SIOCGIWAUTH)      = (iw_handler) cfg80211_wext_giwauth,
+	IW_IOCTL(SIOCSIWGENIE)     = (iw_handler) cfg80211_wext_siwgenie,
+	IW_IOCTL(SIOCSIWMLME)      = (iw_handler) cfg80211_wext_siwmlme,
 };
 
 static const iw_handler rndis_wlan_private_handler[] = {
@@ -2325,49 +2547,78 @@ static const struct iw_handler_def rndis_iw_handlers = {
 
 static void rndis_wlan_do_link_up_work(struct usbnet *usbdev)
 {
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ndis_80211_assoc_info *info;
-	union iwreq_data evt;
 	u8 assoc_buf[sizeof(*info) + IW_CUSTOM_MAX + 32];
 	u8 bssid[ETH_ALEN];
+	int resp_ie_len, req_ie_len;
+	u8 *req_ie, *resp_ie;
 	int ret, offset;
+	bool roamed = false;
+
+	if (priv->infra_mode == NDIS_80211_INFRA_INFRA && priv->connected) {
+		/* received media connect indication while connected, either
+		 * device reassociated with same AP or roamed to new. */
+		roamed = true;
+	}
+
+	req_ie_len = 0;
+	resp_ie_len = 0;
+	req_ie = NULL;
+	resp_ie = NULL;
+
+	if (priv->infra_mode == NDIS_80211_INFRA_INFRA) {
+		memset(assoc_buf, 0, sizeof(assoc_buf));
+		info = (void *)assoc_buf;
+
+		/* Get association info IEs from device and send them back to
+		 * userspace. */
+		ret = get_association_info(usbdev, info, sizeof(assoc_buf));
+		if (!ret) {
+			req_ie_len = le32_to_cpu(info->req_ie_length);
+			if (req_ie_len > 0) {
+				offset = le32_to_cpu(info->offset_req_ies);
+				req_ie = (u8 *)info + offset;
+			}
 
-	memset(assoc_buf, 0, sizeof(assoc_buf));
-	info = (void *)assoc_buf;
+			resp_ie_len = le32_to_cpu(info->resp_ie_length);
+			if (resp_ie_len > 0) {
+				offset = le32_to_cpu(info->offset_resp_ies);
+				resp_ie = (u8 *)info + offset;
+			}
+		}
+	} else if (WARN_ON(priv->infra_mode != NDIS_80211_INFRA_ADHOC))
+		return;
 
-	netif_carrier_on(usbdev->net);
+	ret = get_bssid(usbdev, bssid);
+	if (ret < 0)
+		memset(bssid, 0, sizeof(bssid));
 
-	/* Get association info IEs from device and send them back to
-	 * userspace. */
-	ret = get_association_info(usbdev, info, sizeof(assoc_buf));
-	if (!ret) {
-		evt.data.length = le32_to_cpu(info->req_ie_length);
-		if (evt.data.length > 0) {
-			offset = le32_to_cpu(info->offset_req_ies);
-			wireless_send_event(usbdev->net,
-				IWEVASSOCREQIE, &evt,
-				(char *)info + offset);
-		}
+	devdbg(usbdev, "link up work: [%pM] %s", bssid, roamed ? "roamed" : "");
 
-		evt.data.length = le32_to_cpu(info->resp_ie_length);
-		if (evt.data.length > 0) {
-			offset = le32_to_cpu(info->offset_resp_ies);
-			wireless_send_event(usbdev->net,
-				IWEVASSOCRESPIE, &evt,
-				(char *)info + offset);
-		}
+	/* Internal bss list in device always contains at least the currently
+	 * connected bss and we can get it to cfg80211 with
+	 * rndis_check_bssid_list().
+	 * NOTE: This is true for Broadcom chip, but not mentioned in RNDIS
+	 * spec.
+	 */
+	rndis_check_bssid_list(usbdev);
 
-		usbnet_resume_rx(usbdev);
-	}
+	if (priv->infra_mode == NDIS_80211_INFRA_INFRA) {
+		if (!roamed)
+			cfg80211_connect_result(usbdev->net, bssid, req_ie,
+						req_ie_len, resp_ie,
+						resp_ie_len, 0, GFP_KERNEL);
+		else
+			cfg80211_roamed(usbdev->net, bssid, req_ie, req_ie_len,
+					resp_ie, resp_ie_len, GFP_KERNEL);
+	} else if (priv->infra_mode == NDIS_80211_INFRA_ADHOC)
+		cfg80211_ibss_joined(usbdev->net, bssid, GFP_KERNEL);
 
-	ret = get_bssid(usbdev, bssid);
-	if (!ret) {
-		evt.data.flags = 0;
-		evt.data.length = 0;
-		memcpy(evt.ap_addr.sa_data, bssid, ETH_ALEN);
-		wireless_send_event(usbdev->net, SIOCGIWAP, &evt, NULL);
-	}
+	priv->connected = true;
 
 	usbnet_resume_rx(usbdev);
+	netif_carrier_on(usbdev->net);
 }
 
 static void rndis_wlan_do_link_down_work(struct usbnet *usbdev)

