Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dnainternet-smtp-134.dnaip.fi ([81.175.170.18]:43502 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751838AbZFDRTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 13:19:33 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/2] rndis_wlan: cleanup: capitalize enum labels
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Thu, 04 Jun 2009 20:13:19 +0300
Message-ID: <20090604171319.12853.90551.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Capitalize enum labels as told in Documents/CodingStyle.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |  136 +++++++++++++++++++------------------
 1 files changed, 68 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index c254fdf..de94496 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -157,55 +157,55 @@ MODULE_PARM_DESC(workaround_interval,
 #define NDIS_802_11_LENGTH_RATES_EX 16
 
 enum ndis_80211_net_type {
-	ndis_80211_type_freq_hop,
-	ndis_80211_type_direct_seq,
-	ndis_80211_type_ofdm_a,
-	ndis_80211_type_ofdm_g
+	NDIS_80211_TYPE_FREQ_HOP,
+	NDIS_80211_TYPE_DIRECT_SEQ,
+	NDIS_80211_TYPE_OFDM_A,
+	NDIS_80211_TYPE_OFDM_G
 };
 
 enum ndis_80211_net_infra {
-	ndis_80211_infra_adhoc,
-	ndis_80211_infra_infra,
-	ndis_80211_infra_auto_unknown
+	NDIS_80211_INFRA_ADHOC,
+	NDIS_80211_INFRA_INFRA,
+	NDIS_80211_INFRA_AUTO_UNKNOWN
 };
 
 enum ndis_80211_auth_mode {
-	ndis_80211_auth_open,
-	ndis_80211_auth_shared,
-	ndis_80211_auth_auto_switch,
-	ndis_80211_auth_wpa,
-	ndis_80211_auth_wpa_psk,
-	ndis_80211_auth_wpa_none,
-	ndis_80211_auth_wpa2,
-	ndis_80211_auth_wpa2_psk
+	NDIS_80211_AUTH_OPEN,
+	NDIS_80211_AUTH_SHARED,
+	NDIS_80211_AUTH_AUTO_SWITCH,
+	NDIS_80211_AUTH_WPA,
+	NDIS_80211_AUTH_WPA_PSK,
+	NDIS_80211_AUTH_WPA_NONE,
+	NDIS_80211_AUTH_WPA2,
+	NDIS_80211_AUTH_WPA2_PSK
 };
 
 enum ndis_80211_encr_status {
-	ndis_80211_encr_wep_enabled,
-	ndis_80211_encr_disabled,
-	ndis_80211_encr_wep_key_absent,
-	ndis_80211_encr_not_supported,
-	ndis_80211_encr_tkip_enabled,
-	ndis_80211_encr_tkip_key_absent,
-	ndis_80211_encr_ccmp_enabled,
-	ndis_80211_encr_ccmp_key_absent
+	NDIS_80211_ENCR_WEP_ENABLED,
+	NDIS_80211_ENCR_DISABLED,
+	NDIS_80211_ENCR_WEP_KEY_ABSENT,
+	NDIS_80211_ENCR_NOT_SUPPORTED,
+	NDIS_80211_ENCR_TKIP_ENABLED,
+	NDIS_80211_ENCR_TKIP_KEY_ABSENT,
+	NDIS_80211_ENCR_CCMP_ENABLED,
+	NDIS_80211_ENCR_CCMP_KEY_ABSENT
 };
 
 enum ndis_80211_priv_filter {
-	ndis_80211_priv_accept_all,
-	ndis_80211_priv_8021x_wep
+	NDIS_80211_PRIV_ACCEPT_ALL,
+	NDIS_80211_PRIV_8021X_WEP
 };
 
 enum ndis_80211_addkey_bits {
-	ndis_80211_addkey_8021x_auth = cpu_to_le32(1 << 28),
-	ndis_80211_addkey_set_init_recv_seq = cpu_to_le32(1 << 29),
-	ndis_80211_addkey_pairwise_key = cpu_to_le32(1 << 30),
-	ndis_80211_addkey_transmit_key = cpu_to_le32(1 << 31),
+	NDIS_80211_ADDKEY_8021X_AUTH = cpu_to_le32(1 << 28),
+	NDIS_80211_ADDKEY_SET_INIT_RECV_SEQ = cpu_to_le32(1 << 29),
+	NDIS_80211_ADDKEY_PAIRWISE_KEY = cpu_to_le32(1 << 30),
+	NDIS_80211_ADDKEY_TRANSMIT_KEY = cpu_to_le32(1 << 31)
 };
 
 enum ndis_80211_addwep_bits {
-	ndis_80211_addwep_perclient_key = cpu_to_le32(1 << 30),
-	ndis_80211_addwep_transmit_key = cpu_to_le32(1 << 31),
+	NDIS_80211_ADDWEP_PERCLIENT_KEY = cpu_to_le32(1 << 30),
+	NDIS_80211_ADDWEP_TRANSMIT_KEY = cpu_to_le32(1 << 31)
 };
 
 struct ndis_80211_ssid {
@@ -835,23 +835,23 @@ static int set_auth_mode(struct usbnet *usbdev, int wpa_version, int authalg)
 
 	if (wpa_version & IW_AUTH_WPA_VERSION_WPA2) {
 		if (priv->wpa_keymgmt & IW_AUTH_KEY_MGMT_802_1X)
-			auth_mode = ndis_80211_auth_wpa2;
+			auth_mode = NDIS_80211_AUTH_WPA2;
 		else
-			auth_mode = ndis_80211_auth_wpa2_psk;
+			auth_mode = NDIS_80211_AUTH_WPA2_PSK;
 	} else if (wpa_version & IW_AUTH_WPA_VERSION_WPA) {
 		if (priv->wpa_keymgmt & IW_AUTH_KEY_MGMT_802_1X)
-			auth_mode = ndis_80211_auth_wpa;
+			auth_mode = NDIS_80211_AUTH_WPA;
 		else if (priv->wpa_keymgmt & IW_AUTH_KEY_MGMT_PSK)
-			auth_mode = ndis_80211_auth_wpa_psk;
+			auth_mode = NDIS_80211_AUTH_WPA_PSK;
 		else
-			auth_mode = ndis_80211_auth_wpa_none;
+			auth_mode = NDIS_80211_AUTH_WPA_NONE;
 	} else if (authalg & IW_AUTH_ALG_SHARED_KEY) {
 		if (authalg & IW_AUTH_ALG_OPEN_SYSTEM)
-			auth_mode = ndis_80211_auth_auto_switch;
+			auth_mode = NDIS_80211_AUTH_AUTO_SWITCH;
 		else
-			auth_mode = ndis_80211_auth_shared;
+			auth_mode = NDIS_80211_AUTH_SHARED;
 	} else
-		auth_mode = ndis_80211_auth_open;
+		auth_mode = NDIS_80211_AUTH_OPEN;
 
 	tmp = cpu_to_le32(auth_mode);
 	ret = rndis_set_oid(usbdev, OID_802_11_AUTHENTICATION_MODE, &tmp,
@@ -876,9 +876,9 @@ static int set_priv_filter(struct usbnet *usbdev)
 
 	if (priv->wpa_version & IW_AUTH_WPA_VERSION_WPA2 ||
 	    priv->wpa_version & IW_AUTH_WPA_VERSION_WPA)
-		tmp = cpu_to_le32(ndis_80211_priv_8021x_wep);
+		tmp = cpu_to_le32(NDIS_80211_PRIV_8021X_WEP);
 	else
-		tmp = cpu_to_le32(ndis_80211_priv_accept_all);
+		tmp = cpu_to_le32(NDIS_80211_PRIV_ACCEPT_ALL);
 
 	return rndis_set_oid(usbdev, OID_802_11_PRIVACY_FILTER, &tmp,
 								sizeof(tmp));
@@ -896,18 +896,18 @@ static int set_encr_mode(struct usbnet *usbdev, int pairwise, int groupwise)
 		groupwise);
 
 	if (pairwise & IW_AUTH_CIPHER_CCMP)
-		encr_mode = ndis_80211_encr_ccmp_enabled;
+		encr_mode = NDIS_80211_ENCR_CCMP_ENABLED;
 	else if (pairwise & IW_AUTH_CIPHER_TKIP)
-		encr_mode = ndis_80211_encr_tkip_enabled;
+		encr_mode = NDIS_80211_ENCR_TKIP_ENABLED;
 	else if (pairwise &
 		 (IW_AUTH_CIPHER_WEP40 | IW_AUTH_CIPHER_WEP104))
-		encr_mode = ndis_80211_encr_wep_enabled;
+		encr_mode = NDIS_80211_ENCR_WEP_ENABLED;
 	else if (groupwise & IW_AUTH_CIPHER_CCMP)
-		encr_mode = ndis_80211_encr_ccmp_enabled;
+		encr_mode = NDIS_80211_ENCR_CCMP_ENABLED;
 	else if (groupwise & IW_AUTH_CIPHER_TKIP)
-		encr_mode = ndis_80211_encr_tkip_enabled;
+		encr_mode = NDIS_80211_ENCR_TKIP_ENABLED;
 	else
-		encr_mode = ndis_80211_encr_disabled;
+		encr_mode = NDIS_80211_ENCR_DISABLED;
 
 	tmp = cpu_to_le32(encr_mode);
 	ret = rndis_set_oid(usbdev, OID_802_11_ENCRYPTION_STATUS, &tmp,
@@ -975,7 +975,7 @@ static void set_default_iw_params(struct usbnet *usbdev)
 	priv->wpa_keymgmt = 0;
 	priv->wpa_version = 0;
 
-	set_infra_mode(usbdev, ndis_80211_infra_infra);
+	set_infra_mode(usbdev, NDIS_80211_INFRA_INFRA);
 	set_auth_mode(usbdev, IW_AUTH_WPA_VERSION_DISABLED,
 				IW_AUTH_ALG_OPEN_SYSTEM);
 	set_priv_filter(usbdev);
@@ -1011,7 +1011,7 @@ static int add_wep_key(struct usbnet *usbdev, char *key, int key_len, int index)
 	memcpy(&ndis_key.material, key, key_len);
 
 	if (index == priv->encr_tx_key_index) {
-		ndis_key.index |= ndis_80211_addwep_transmit_key;
+		ndis_key.index |= NDIS_80211_ADDWEP_TRANSMIT_KEY;
 		ret = set_encr_mode(usbdev, IW_AUTH_CIPHER_WEP104,
 						IW_AUTH_CIPHER_NONE);
 		if (ret)
@@ -1047,15 +1047,15 @@ static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
 		return -EINVAL;
 	if (key_len > sizeof(ndis_key.material) || key_len < 0)
 		return -EINVAL;
-	if ((flags & ndis_80211_addkey_set_init_recv_seq) && !rx_seq)
+	if ((flags & NDIS_80211_ADDKEY_SET_INIT_RECV_SEQ) && !rx_seq)
 		return -EINVAL;
-	if ((flags & ndis_80211_addkey_pairwise_key) && !addr)
+	if ((flags & NDIS_80211_ADDKEY_PAIRWISE_KEY) && !addr)
 		return -EINVAL;
 
 	devdbg(usbdev, "add_wpa_key(%i): flags:%i%i%i", index,
-			!!(flags & ndis_80211_addkey_transmit_key),
-			!!(flags & ndis_80211_addkey_pairwise_key),
-			!!(flags & ndis_80211_addkey_set_init_recv_seq));
+			!!(flags & NDIS_80211_ADDKEY_TRANSMIT_KEY),
+			!!(flags & NDIS_80211_ADDKEY_PAIRWISE_KEY),
+			!!(flags & NDIS_80211_ADDKEY_SET_INIT_RECV_SEQ));
 
 	memset(&ndis_key, 0, sizeof(ndis_key));
 
@@ -1073,15 +1073,15 @@ static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
 	} else
 		memcpy(ndis_key.material, key, key_len);
 
-	if (flags & ndis_80211_addkey_set_init_recv_seq)
+	if (flags & NDIS_80211_ADDKEY_SET_INIT_RECV_SEQ)
 		memcpy(ndis_key.rsc, rx_seq, 6);
 
-	if (flags & ndis_80211_addkey_pairwise_key) {
+	if (flags & NDIS_80211_ADDKEY_PAIRWISE_KEY) {
 		/* pairwise key */
 		memcpy(ndis_key.bssid, addr->sa_data, ETH_ALEN);
 	} else {
 		/* group key */
-		if (priv->infra_mode == ndis_80211_infra_adhoc)
+		if (priv->infra_mode == NDIS_80211_INFRA_ADHOC)
 			memset(ndis_key.bssid, 0xff, ETH_ALEN);
 		else
 			get_bssid(usbdev, ndis_key.bssid);
@@ -1096,7 +1096,7 @@ static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
 	priv->encr_key_len[index] = key_len;
 	priv->encr_key_wpa[index] = 1;
 
-	if (flags & ndis_80211_addkey_transmit_key)
+	if (flags & NDIS_80211_ADDKEY_TRANSMIT_KEY)
 		priv->encr_tx_key_index = index;
 
 	return 0;
@@ -1128,7 +1128,7 @@ static int remove_key(struct usbnet *usbdev, int index, u8 bssid[ETH_ALEN])
 			/* pairwise key */
 			if (memcmp(bssid, ffff_bssid, ETH_ALEN) != 0)
 				remove_key.index |=
-					ndis_80211_addkey_pairwise_key;
+					NDIS_80211_ADDKEY_PAIRWISE_KEY;
 			memcpy(remove_key.bssid, bssid,
 					sizeof(remove_key.bssid));
 		} else
@@ -1238,10 +1238,10 @@ static int rndis_change_virtual_intf(struct wiphy *wiphy, int ifindex,
 
 	switch (type) {
 	case NL80211_IFTYPE_ADHOC:
-		mode = ndis_80211_infra_adhoc;
+		mode = NDIS_80211_INFRA_ADHOC;
 		break;
 	case NL80211_IFTYPE_STATION:
-		mode = ndis_80211_infra_infra;
+		mode = NDIS_80211_INFRA_INFRA;
 		break;
 	default:
 		return -EINVAL;
@@ -1698,11 +1698,11 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 
 	flags = 0;
 	if (ext->ext_flags & IW_ENCODE_EXT_RX_SEQ_VALID)
-		flags |= ndis_80211_addkey_set_init_recv_seq;
+		flags |= NDIS_80211_ADDKEY_SET_INIT_RECV_SEQ;
 	if (!(ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY))
-		flags |= ndis_80211_addkey_pairwise_key;
+		flags |= NDIS_80211_ADDKEY_PAIRWISE_KEY;
 	if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
-		flags |= ndis_80211_addkey_transmit_key;
+		flags |= NDIS_80211_ADDKEY_TRANSMIT_KEY;
 
 	return add_wpa_key(usbdev, ext->key, ext->key_len, keyidx, &ext->addr,
 				ext->rx_seq, ext->alg, flags);
@@ -2160,14 +2160,14 @@ static int rndis_wext_get_caps(struct usbnet *usbdev)
 			n = 8;
 		for (i = 0; i < n; i++) {
 			switch (le32_to_cpu(networks_supported.items[i])) {
-			case ndis_80211_type_freq_hop:
-			case ndis_80211_type_direct_seq:
+			case NDIS_80211_TYPE_FREQ_HOP:
+			case NDIS_80211_TYPE_DIRECT_SEQ:
 				priv->caps |= CAP_MODE_80211B;
 				break;
-			case ndis_80211_type_ofdm_a:
+			case NDIS_80211_TYPE_OFDM_A:
 				priv->caps |= CAP_MODE_80211A;
 				break;
-			case ndis_80211_type_ofdm_g:
+			case NDIS_80211_TYPE_OFDM_G:
 				priv->caps |= CAP_MODE_80211G;
 				break;
 			}

