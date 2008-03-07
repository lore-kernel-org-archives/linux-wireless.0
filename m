Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:47909 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbYCGXXB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 18:23:01 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/2] rndis_wlan: cleanup,
	rename and reorder enums and structures
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Sat, 08 Mar 2008 01:23:17 +0200
Message-ID: <20080307232317.15875.89491.stgit@localhost> (sfid-20080307_232309_164472_ABC72AAB)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename enums and structures to ndis_80211_* for greater readability. 
Also change order so that enumerations are presented first.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |  213 ++++++++++++++++++-------------------
 1 files changed, 103 insertions(+), 110 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 10b776c..157c464 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -154,107 +154,100 @@ MODULE_PARM_DESC(workaround_interval,
 #define NDIS_802_11_LENGTH_RATES 8
 #define NDIS_802_11_LENGTH_RATES_EX 16
 
-struct NDIS_802_11_SSID {
+enum ndis_80211_net_type {
+	ndis_80211_type_freq_hop,
+	ndis_80211_type_direct_seq,
+	ndis_80211_type_ofdm_a,
+	ndis_80211_type_ofdm_g
+};
+
+enum ndis_80211_net_infra {
+	ndis_80211_infra_adhoc,
+	ndis_80211_infra_infra,
+	ndis_80211_infra_auto_unknown
+};
+
+enum ndis_80211_auth_mode {
+	ndis_80211_auth_open,
+	ndis_80211_auth_shared,
+	ndis_80211_auth_auto_switch,
+	ndis_80211_auth_wpa,
+	ndis_80211_auth_wpa_psk,
+	ndis_80211_auth_wpa_none,
+	ndis_80211_auth_wpa2,
+	ndis_80211_auth_wpa2_psk
+};
+
+enum ndis_80211_encr_status {
+	ndis_80211_encr_wep_enabled,
+	ndis_80211_encr_disabled,
+	ndis_80211_encr_wep_key_absent,
+	ndis_80211_encr_not_supported,
+	ndis_80211_encr_tkip_enabled,
+	ndis_80211_encr_tkip_key_absent,
+	ndis_80211_encr_ccmp_enabled,
+	ndis_80211_encr_ccmp_key_absent
+};
+
+enum ndis_80211_priv_filter {
+	ndis_80211_priv_accept_all,
+	ndis_80211_priv_8021x_wep
+};
+
+struct ndis_80211_ssid {
 	__le32 SsidLength;
 	u8 Ssid[NDIS_802_11_LENGTH_SSID];
 } __attribute__((packed));
 
-enum NDIS_802_11_NETWORK_TYPE {
-	Ndis802_11FH,
-	Ndis802_11DS,
-	Ndis802_11OFDM5,
-	Ndis802_11OFDM24,
-	Ndis802_11NetworkTypeMax
-};
-
-struct NDIS_802_11_CONFIGURATION_FH {
+struct ndis_80211_conf_freq_hop {
 	__le32 Length;
 	__le32 HopPattern;
 	__le32 HopSet;
 	__le32 DwellTime;
 } __attribute__((packed));
 
-struct NDIS_802_11_CONFIGURATION {
+struct ndis_80211_conf {
 	__le32 Length;
 	__le32 BeaconPeriod;
 	__le32 ATIMWindow;
 	__le32 DSConfig;
-	struct NDIS_802_11_CONFIGURATION_FH FHConfig;
+	struct ndis_80211_conf_freq_hop FHConfig;
 } __attribute__((packed));
 
-enum NDIS_802_11_NETWORK_INFRASTRUCTURE {
-	Ndis802_11IBSS,
-	Ndis802_11Infrastructure,
-	Ndis802_11AutoUnknown,
-	Ndis802_11InfrastructureMax
-};
-
-enum NDIS_802_11_AUTHENTICATION_MODE {
-	Ndis802_11AuthModeOpen,
-	Ndis802_11AuthModeShared,
-	Ndis802_11AuthModeAutoSwitch,
-	Ndis802_11AuthModeWPA,
-	Ndis802_11AuthModeWPAPSK,
-	Ndis802_11AuthModeWPANone,
-	Ndis802_11AuthModeWPA2,
-	Ndis802_11AuthModeWPA2PSK,
-	Ndis802_11AuthModeMax
-};
-
-enum NDIS_802_11_ENCRYPTION_STATUS {
-	Ndis802_11WEPEnabled,
-	Ndis802_11Encryption1Enabled = Ndis802_11WEPEnabled,
-	Ndis802_11WEPDisabled,
-	Ndis802_11EncryptionDisabled = Ndis802_11WEPDisabled,
-	Ndis802_11WEPKeyAbsent,
-	Ndis802_11Encryption1KeyAbsent = Ndis802_11WEPKeyAbsent,
-	Ndis802_11WEPNotSupported,
-	Ndis802_11EncryptionNotSupported = Ndis802_11WEPNotSupported,
-	Ndis802_11Encryption2Enabled,
-	Ndis802_11Encryption2KeyAbsent,
-	Ndis802_11Encryption3Enabled,
-	Ndis802_11Encryption3KeyAbsent
-};
-
-enum NDIS_802_11_PRIVACY_FILTER {
-	Ndis802_11PrivFilterAcceptAll,
-	Ndis802_11PrivFilter8021xWEP
-};
-
-struct NDIS_WLAN_BSSID_EX {
+struct ndis_80211_bssid_ex {
 	__le32 Length;
 	u8 MacAddress[6];
 	u8 Padding[2];
-	struct NDIS_802_11_SSID Ssid;
+	struct ndis_80211_ssid Ssid;
 	__le32 Privacy;
 	__le32 Rssi;
 	__le32 NetworkTypeInUse;
-	struct NDIS_802_11_CONFIGURATION Configuration;
+	struct ndis_80211_conf Configuration;
 	__le32 InfrastructureMode;
 	u8 SupportedRates[NDIS_802_11_LENGTH_RATES_EX];
 	__le32 IELength;
 	u8 IEs[0];
 } __attribute__((packed));
 
-struct NDIS_802_11_BSSID_LIST_EX {
+struct ndis_80211_bssid_list_ex {
 	__le32 NumberOfItems;
-	struct NDIS_WLAN_BSSID_EX Bssid[0];
+	struct ndis_80211_bssid_ex Bssid[0];
 } __attribute__((packed));
 
-struct NDIS_802_11_FIXED_IEs {
+struct ndis_80211_fixed_ies {
 	u8 Timestamp[8];
 	__le16 BeaconInterval;
 	__le16 Capabilities;
 } __attribute__((packed));
 
-struct NDIS_802_11_WEP {
+struct ndis_80211_wep_key {
 	__le32 Length;
 	__le32 KeyIndex;
 	__le32 KeyLength;
 	u8 KeyMaterial[32];
 } __attribute__((packed));
 
-struct NDIS_802_11_KEY {
+struct ndis_80211_key {
 	__le32 Length;
 	__le32 KeyIndex;
 	__le32 KeyLength;
@@ -264,13 +257,13 @@ struct NDIS_802_11_KEY {
 	u8 KeyMaterial[32];
 } __attribute__((packed));
 
-struct NDIS_802_11_REMOVE_KEY {
+struct ndis_80211_remove_key {
 	__le32 Length;
 	__le32 KeyIndex;
 	u8 Bssid[6];
 } __attribute__((packed));
 
-struct RNDIS_CONFIG_PARAMETER_INFOBUFFER {
+struct ndis_config_param {
 	__le32 ParameterNameOffset;
 	__le32 ParameterNameLength;
 	__le32 ParameterType;
@@ -334,7 +327,7 @@ struct rndis_wext_private {
 	/* hardware state */
 	int radio_on;
 	int infra_mode;
-	struct NDIS_802_11_SSID essid;
+	struct ndis_80211_ssid essid;
 
 	/* encryption stuff */
 	int  encr_tx_key_index;
@@ -484,7 +477,7 @@ static int rndis_set_oid(struct usbnet *dev, __le32 oid, void *data, int len)
 static int rndis_set_config_parameter(struct usbnet *dev, char *param,
 						int value_type, void *value)
 {
-	struct RNDIS_CONFIG_PARAMETER_INFOBUFFER *infobuf;
+	struct ndis_config_param *infobuf;
 	int value_len, info_len, param_len, ret, i;
 	__le16 *unibuf;
 	__le32 *dst_value;
@@ -630,7 +623,7 @@ static int freq_to_dsconfig(struct iw_freq *freq, unsigned int *dsconfig)
 static int
 add_wep_key(struct usbnet *usbdev, char *key, int key_len, int index);
 
-static int get_essid(struct usbnet *usbdev, struct NDIS_802_11_SSID *ssid)
+static int get_essid(struct usbnet *usbdev, struct ndis_80211_ssid *ssid)
 {
 	int ret, len;
 
@@ -653,7 +646,7 @@ static int get_essid(struct usbnet *usbdev, struct NDIS_802_11_SSID *ssid)
 }
 
 
-static int set_essid(struct usbnet *usbdev, struct NDIS_802_11_SSID *ssid)
+static int set_essid(struct usbnet *usbdev, struct ndis_80211_ssid *ssid)
 {
 	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
 	int ret;
@@ -697,7 +690,7 @@ static int is_associated(struct usbnet *usbdev)
 static int disassociate(struct usbnet *usbdev, int reset_ssid)
 {
 	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
-	struct NDIS_802_11_SSID ssid;
+	struct ndis_80211_ssid ssid;
 	int i, ret = 0;
 
 	if (priv->radio_on) {
@@ -737,23 +730,23 @@ static int set_auth_mode(struct usbnet *usbdev, int wpa_version, int authalg)
 
 	if (wpa_version & IW_AUTH_WPA_VERSION_WPA2) {
 		if (priv->wpa_keymgmt & IW_AUTH_KEY_MGMT_802_1X)
-			auth_mode = Ndis802_11AuthModeWPA2;
+			auth_mode = ndis_80211_auth_wpa2;
 		else
-			auth_mode = Ndis802_11AuthModeWPA2PSK;
+			auth_mode = ndis_80211_auth_wpa2_psk;
 	} else if (wpa_version & IW_AUTH_WPA_VERSION_WPA) {
 		if (priv->wpa_keymgmt & IW_AUTH_KEY_MGMT_802_1X)
-			auth_mode = Ndis802_11AuthModeWPA;
+			auth_mode = ndis_80211_auth_wpa;
 		else if (priv->wpa_keymgmt & IW_AUTH_KEY_MGMT_PSK)
-			auth_mode = Ndis802_11AuthModeWPAPSK;
+			auth_mode = ndis_80211_auth_wpa_psk;
 		else
-			auth_mode = Ndis802_11AuthModeWPANone;
+			auth_mode = ndis_80211_auth_wpa_none;
 	} else if (authalg & IW_AUTH_ALG_SHARED_KEY) {
 		if (authalg & IW_AUTH_ALG_OPEN_SYSTEM)
-			auth_mode = Ndis802_11AuthModeAutoSwitch;
+			auth_mode = ndis_80211_auth_auto_switch;
 		else
-			auth_mode = Ndis802_11AuthModeShared;
+			auth_mode = ndis_80211_auth_shared;
 	} else
-		auth_mode = Ndis802_11AuthModeOpen;
+		auth_mode = ndis_80211_auth_open;
 
 	tmp = cpu_to_le32(auth_mode);
 	ret = rndis_set_oid(usbdev, OID_802_11_AUTHENTICATION_MODE, &tmp,
@@ -778,9 +771,9 @@ static int set_priv_filter(struct usbnet *usbdev)
 
 	if (priv->wpa_version & IW_AUTH_WPA_VERSION_WPA2 ||
 	    priv->wpa_version & IW_AUTH_WPA_VERSION_WPA)
-		tmp = cpu_to_le32(Ndis802_11PrivFilter8021xWEP);
+		tmp = cpu_to_le32(ndis_80211_priv_8021x_wep);
 	else
-		tmp = cpu_to_le32(Ndis802_11PrivFilterAcceptAll);
+		tmp = cpu_to_le32(ndis_80211_priv_accept_all);
 
 	return rndis_set_oid(usbdev, OID_802_11_PRIVACY_FILTER, &tmp,
 								sizeof(tmp));
@@ -798,18 +791,18 @@ static int set_encr_mode(struct usbnet *usbdev, int pairwise, int groupwise)
 		groupwise);
 
 	if (pairwise & IW_AUTH_CIPHER_CCMP)
-		encr_mode = Ndis802_11Encryption3Enabled;
+		encr_mode = ndis_80211_encr_ccmp_enabled;
 	else if (pairwise & IW_AUTH_CIPHER_TKIP)
-		encr_mode = Ndis802_11Encryption2Enabled;
+		encr_mode = ndis_80211_encr_tkip_enabled;
 	else if (pairwise &
 		 (IW_AUTH_CIPHER_WEP40 | IW_AUTH_CIPHER_WEP104))
-		encr_mode = Ndis802_11Encryption1Enabled;
+		encr_mode = ndis_80211_encr_wep_enabled;
 	else if (groupwise & IW_AUTH_CIPHER_CCMP)
-		encr_mode = Ndis802_11Encryption3Enabled;
+		encr_mode = ndis_80211_encr_ccmp_enabled;
 	else if (groupwise & IW_AUTH_CIPHER_TKIP)
-		encr_mode = Ndis802_11Encryption2Enabled;
+		encr_mode = ndis_80211_encr_tkip_enabled;
 	else
-		encr_mode = Ndis802_11EncryptionDisabled;
+		encr_mode = ndis_80211_encr_disabled;
 
 	tmp = cpu_to_le32(encr_mode);
 	ret = rndis_set_oid(usbdev, OID_802_11_ENCRYPTION_STATUS, &tmp,
@@ -877,7 +870,7 @@ static void set_default_iw_params(struct usbnet *usbdev)
 	priv->wpa_keymgmt = 0;
 	priv->wpa_version = 0;
 
-	set_infra_mode(usbdev, Ndis802_11Infrastructure);
+	set_infra_mode(usbdev, ndis_80211_infra_infra);
 	set_auth_mode(usbdev, IW_AUTH_WPA_VERSION_DISABLED,
 				IW_AUTH_ALG_OPEN_SYSTEM);
 	set_priv_filter(usbdev);
@@ -899,7 +892,7 @@ static int deauthenticate(struct usbnet *usbdev)
 static int add_wep_key(struct usbnet *usbdev, char *key, int key_len, int index)
 {
 	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
-	struct NDIS_802_11_WEP ndis_key;
+	struct ndis_80211_wep_key ndis_key;
 	int ret;
 
 	if (key_len <= 0 || key_len > 32 || index < 0 || index >= 4)
@@ -940,7 +933,7 @@ static int add_wep_key(struct usbnet *usbdev, char *key, int key_len, int index)
 static int remove_key(struct usbnet *usbdev, int index, u8 bssid[ETH_ALEN])
 {
 	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
-	struct NDIS_802_11_REMOVE_KEY remove_key;
+	struct ndis_80211_remove_key remove_key;
 	__le32 keyindex;
 	int ret;
 
@@ -1184,7 +1177,7 @@ static int rndis_iw_get_name(struct net_device *dev,
 static int rndis_iw_set_essid(struct net_device *dev,
     struct iw_request_info *info, union iwreq_data *wrqu, char *essid)
 {
-	struct NDIS_802_11_SSID ssid;
+	struct ndis_80211_ssid ssid;
 	int length = wrqu->essid.length;
 	struct usbnet *usbdev = dev->priv;
 
@@ -1212,7 +1205,7 @@ static int rndis_iw_set_essid(struct net_device *dev,
 static int rndis_iw_get_essid(struct net_device *dev,
     struct iw_request_info *info, union iwreq_data *wrqu, char *essid)
 {
-	struct NDIS_802_11_SSID ssid;
+	struct ndis_80211_ssid ssid;
 	struct usbnet *usbdev = dev->priv;
 	int ret;
 
@@ -1398,13 +1391,13 @@ static int rndis_iw_get_mode(struct net_device *dev,
 	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
 
 	switch (priv->infra_mode) {
-	case Ndis802_11IBSS:
+	case ndis_80211_infra_adhoc:
 		wrqu->mode = IW_MODE_ADHOC;
 		break;
-	case Ndis802_11Infrastructure:
+	case ndis_80211_infra_infra:
 		wrqu->mode = IW_MODE_INFRA;
 		break;
-	/*case Ndis802_11AutoUnknown:*/
+	/*case ndis_80211_infra_auto_unknown:*/
 	default:
 		wrqu->mode = IW_MODE_AUTO;
 		break;
@@ -1424,14 +1417,14 @@ static int rndis_iw_set_mode(struct net_device *dev,
 
 	switch (wrqu->mode) {
 	case IW_MODE_ADHOC:
-		mode = Ndis802_11IBSS;
+		mode = ndis_80211_infra_adhoc;
 		break;
 	case IW_MODE_INFRA:
-		mode = Ndis802_11Infrastructure;
+		mode = ndis_80211_infra_infra;
 		break;
 	/*case IW_MODE_AUTO:*/
 	default:
-		mode = Ndis802_11AutoUnknown;
+		mode = ndis_80211_infra_auto_unknown;
 		break;
 	}
 
@@ -1507,7 +1500,7 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 	struct usbnet *usbdev = dev->priv;
 	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
-	struct NDIS_802_11_KEY ndis_key;
+	struct ndis_80211_key ndis_key;
 	int keyidx, ret;
 	u8 *addr;
 
@@ -1550,7 +1543,7 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 	addr = ext->addr.sa_data;
 	if (ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) {
 		/* group key */
-		if (priv->infra_mode == Ndis802_11IBSS)
+		if (priv->infra_mode == ndis_80211_infra_adhoc)
 			memset(ndis_key.Bssid, 0xff, ETH_ALEN);
 		else
 			get_bssid(usbdev, ndis_key.Bssid);
@@ -1611,7 +1604,7 @@ static int rndis_iw_set_scan(struct net_device *dev,
 
 
 static char *rndis_translate_scan(struct net_device *dev,
-    char *cev, char *end_buf, struct NDIS_WLAN_BSSID_EX *bssid)
+    char *cev, char *end_buf, struct ndis_80211_bssid_ex *bssid)
 {
 #ifdef DEBUG
 	struct usbnet *usbdev = dev->priv;
@@ -1645,13 +1638,13 @@ static char *rndis_translate_scan(struct net_device *dev,
 			le32_to_cpu(bssid->InfrastructureMode));
 	iwe.cmd = SIOCGIWMODE;
 	switch (le32_to_cpu(bssid->InfrastructureMode)) {
-	case Ndis802_11IBSS:
+	case ndis_80211_infra_adhoc:
 		iwe.u.mode = IW_MODE_ADHOC;
 		break;
-	case Ndis802_11Infrastructure:
+	case ndis_80211_infra_infra:
 		iwe.u.mode = IW_MODE_INFRA;
 		break;
-	/*case Ndis802_11AutoUnknown:*/
+	/*case ndis_80211_infra_auto_unknown:*/
 	default:
 		iwe.u.mode = IW_MODE_AUTO;
 		break;
@@ -1677,7 +1670,7 @@ static char *rndis_translate_scan(struct net_device *dev,
 	devdbg(usbdev, "ENCODE %d", le32_to_cpu(bssid->Privacy));
 	iwe.cmd = SIOCGIWENCODE;
 	iwe.u.data.length = 0;
-	if (le32_to_cpu(bssid->Privacy) == Ndis802_11PrivFilterAcceptAll)
+	if (le32_to_cpu(bssid->Privacy) == ndis_80211_priv_accept_all)
 		iwe.u.data.flags = IW_ENCODE_DISABLED;
 	else
 		iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
@@ -1716,10 +1709,10 @@ static char *rndis_translate_scan(struct net_device *dev,
 	iwe.u.data.length = strlen(sbuf);
 	cev = iwe_stream_add_point(cev, end_buf, &iwe, sbuf);
 
-	ie = (void *)(bssid->IEs + sizeof(struct NDIS_802_11_FIXED_IEs));
+	ie = (void *)(bssid->IEs + sizeof(struct ndis_80211_fixed_ies));
 	ie_len = min(bssid_len - (int)sizeof(*bssid),
 					(int)le32_to_cpu(bssid->IELength));
-	ie_len -= sizeof(struct NDIS_802_11_FIXED_IEs);
+	ie_len -= sizeof(struct ndis_80211_fixed_ies);
 	while (ie_len >= sizeof(*ie) && sizeof(*ie) + ie->len <= ie_len) {
 		if ((ie->id == MFIE_TYPE_GENERIC && ie->len >= 4 &&
 				memcmp(ie->data, "\x00\x50\xf2\x01", 4) == 0) ||
@@ -1746,8 +1739,8 @@ static int rndis_iw_get_scan(struct net_device *dev,
 	struct usbnet *usbdev = dev->priv;
 	void *buf = NULL;
 	char *cev = extra;
-	struct NDIS_802_11_BSSID_LIST_EX *bssid_list;
-	struct NDIS_WLAN_BSSID_EX *bssid;
+	struct ndis_80211_bssid_list_ex *bssid_list;
+	struct ndis_80211_bssid_ex *bssid;
 	int ret = -EINVAL, len, count, bssid_len;
 
 	devdbg(usbdev, "SIOCGIWSCAN");
@@ -1948,7 +1941,7 @@ static int rndis_iw_set_freq(struct net_device *dev,
     struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
 	struct usbnet *usbdev = dev->priv;
-	struct NDIS_802_11_CONFIGURATION config;
+	struct ndis_80211_conf config;
 	unsigned int dsconfig;
 	int len, ret;
 
@@ -1979,7 +1972,7 @@ static int rndis_iw_get_freq(struct net_device *dev,
     struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
 	struct usbnet *usbdev = dev->priv;
-	struct NDIS_802_11_CONFIGURATION config;
+	struct ndis_80211_conf config;
 	int len, ret;
 
 	len = sizeof(config);
@@ -2266,14 +2259,14 @@ static int rndis_wext_get_caps(struct usbnet *dev)
 			n = 8;
 		for (i = 0; i < n; i++) {
 			switch (le32_to_cpu(networks_supported.items[i])) {
-			case Ndis802_11FH:
-			case Ndis802_11DS:
+			case ndis_80211_type_freq_hop:
+			case ndis_80211_type_direct_seq:
 				priv->caps |= CAP_MODE_80211B;
 				break;
-			case Ndis802_11OFDM5:
+			case ndis_80211_type_ofdm_a:
 				priv->caps |= CAP_MODE_80211A;
 				break;
-			case Ndis802_11OFDM24:
+			case ndis_80211_type_ofdm_g:
 				priv->caps |= CAP_MODE_80211G;
 				break;
 			}

