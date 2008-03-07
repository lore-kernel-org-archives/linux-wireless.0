Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:59138 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbYCGXXJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 18:23:09 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/2] rndis_wlan: cleanup, rename structure members
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Sat, 08 Mar 2008 01:23:25 +0200
Message-ID: <20080307232325.15875.55456.stgit@localhost> (sfid-20080307_232314_384652_E4904F09)
In-Reply-To: <20080307232317.15875.89491.stgit@localhost>
References: <20080307232317.15875.89491.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename members of ndis_80211_* structures to match the style of
the rest of the code.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |  258 ++++++++++++++++++-------------------
 1 files changed, 126 insertions(+), 132 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 157c464..977751f 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -195,80 +195,80 @@ enum ndis_80211_priv_filter {
 };
 
 struct ndis_80211_ssid {
-	__le32 SsidLength;
-	u8 Ssid[NDIS_802_11_LENGTH_SSID];
+	__le32 length;
+	u8 essid[NDIS_802_11_LENGTH_SSID];
 } __attribute__((packed));
 
 struct ndis_80211_conf_freq_hop {
-	__le32 Length;
-	__le32 HopPattern;
-	__le32 HopSet;
-	__le32 DwellTime;
+	__le32 length;
+	__le32 hop_pattern;
+	__le32 hop_set;
+	__le32 dwell_time;
 } __attribute__((packed));
 
 struct ndis_80211_conf {
-	__le32 Length;
-	__le32 BeaconPeriod;
-	__le32 ATIMWindow;
-	__le32 DSConfig;
-	struct ndis_80211_conf_freq_hop FHConfig;
+	__le32 length;
+	__le32 beacon_period;
+	__le32 atim_window;
+	__le32 ds_config;
+	struct ndis_80211_conf_freq_hop fh_config;
 } __attribute__((packed));
 
 struct ndis_80211_bssid_ex {
-	__le32 Length;
-	u8 MacAddress[6];
-	u8 Padding[2];
-	struct ndis_80211_ssid Ssid;
-	__le32 Privacy;
-	__le32 Rssi;
-	__le32 NetworkTypeInUse;
-	struct ndis_80211_conf Configuration;
-	__le32 InfrastructureMode;
-	u8 SupportedRates[NDIS_802_11_LENGTH_RATES_EX];
-	__le32 IELength;
-	u8 IEs[0];
+	__le32 length;
+	u8 mac[6];
+	u8 padding[2];
+	struct ndis_80211_ssid ssid;
+	__le32 privacy;
+	__le32 rssi;
+	__le32 net_type;
+	struct ndis_80211_conf config;
+	__le32 net_infra;
+	u8 rates[NDIS_802_11_LENGTH_RATES_EX];
+	__le32 ie_length;
+	u8 ies[0];
 } __attribute__((packed));
 
 struct ndis_80211_bssid_list_ex {
-	__le32 NumberOfItems;
-	struct ndis_80211_bssid_ex Bssid[0];
+	__le32 num_items;
+	struct ndis_80211_bssid_ex bssid[0];
 } __attribute__((packed));
 
 struct ndis_80211_fixed_ies {
-	u8 Timestamp[8];
-	__le16 BeaconInterval;
-	__le16 Capabilities;
+	u8 timestamp[8];
+	__le16 beacon_interval;
+	__le16 capabilities;
 } __attribute__((packed));
 
 struct ndis_80211_wep_key {
-	__le32 Length;
-	__le32 KeyIndex;
-	__le32 KeyLength;
-	u8 KeyMaterial[32];
+	__le32 size;
+	__le32 index;
+	__le32 length;
+	u8 material[32];
 } __attribute__((packed));
 
 struct ndis_80211_key {
-	__le32 Length;
-	__le32 KeyIndex;
-	__le32 KeyLength;
-	u8 Bssid[6];
-	u8 Padding[6];
-	u8 KeyRSC[8];
-	u8 KeyMaterial[32];
+	__le32 size;
+	__le32 index;
+	__le32 length;
+	u8 bssid[6];
+	u8 padding[6];
+	u8 rsc[8];
+	u8 material[32];
 } __attribute__((packed));
 
 struct ndis_80211_remove_key {
-	__le32 Length;
-	__le32 KeyIndex;
-	u8 Bssid[6];
+	__le32 size;
+	__le32 index;
+	u8 bssid[6];
 } __attribute__((packed));
 
 struct ndis_config_param {
-	__le32 ParameterNameOffset;
-	__le32 ParameterNameLength;
-	__le32 ParameterType;
-	__le32 ParameterValueOffset;
-	__le32 ParameterValueLength;
+	__le32 name_offs;
+	__le32 name_length;
+	__le32 type;
+	__le32 value_offs;
+	__le32 value_length;
 } __attribute__((packed));
 
 /* these have to match what is in wpa_supplicant */
@@ -512,12 +512,11 @@ static int rndis_set_config_parameter(struct usbnet *dev, char *param,
 		devdbg(dev, "setting config parameter: %s, value: %d",
 						param, *(u32 *)value);
 
-	infobuf->ParameterNameOffset = cpu_to_le32(sizeof(*infobuf));
-	infobuf->ParameterNameLength = cpu_to_le32(param_len);
-	infobuf->ParameterType = cpu_to_le32(value_type);
-	infobuf->ParameterValueOffset = cpu_to_le32(sizeof(*infobuf) +
-								param_len);
-	infobuf->ParameterValueLength = cpu_to_le32(value_len);
+	infobuf->name_offs = cpu_to_le32(sizeof(*infobuf));
+	infobuf->name_length = cpu_to_le32(param_len);
+	infobuf->type = cpu_to_le32(value_type);
+	infobuf->value_offs = cpu_to_le32(sizeof(*infobuf) + param_len);
+	infobuf->value_length = cpu_to_le32(value_len);
 
 	/* simple string to unicode string conversion */
 	unibuf = (void *)infobuf + sizeof(*infobuf);
@@ -631,14 +630,14 @@ static int get_essid(struct usbnet *usbdev, struct ndis_80211_ssid *ssid)
 	ret = rndis_query_oid(usbdev, OID_802_11_SSID, ssid, &len);
 
 	if (ret != 0)
-		ssid->SsidLength = 0;
+		ssid->length = 0;
 
 #ifdef DEBUG
 	{
 		unsigned char tmp[NDIS_802_11_LENGTH_SSID + 1];
 
-		memcpy(tmp, ssid->Ssid, le32_to_cpu(ssid->SsidLength));
-		tmp[le32_to_cpu(ssid->SsidLength)] = 0;
+		memcpy(tmp, ssid->essid, le32_to_cpu(ssid->length));
+		tmp[le32_to_cpu(ssid->length)] = 0;
 		devdbg(usbdev, "get_essid: '%s', ret: %d", tmp, ret);
 	}
 #endif
@@ -707,12 +706,12 @@ static int disassociate(struct usbnet *usbdev, int reset_ssid)
 	/* disassociate causes radio to be turned off; if reset_ssid
 	 * is given, set random ssid to enable radio */
 	if (reset_ssid) {
-		ssid.SsidLength = cpu_to_le32(sizeof(ssid.Ssid));
-		get_random_bytes(&ssid.Ssid[2], sizeof(ssid.Ssid)-2);
-		ssid.Ssid[0] = 0x1;
-		ssid.Ssid[1] = 0xff;
-		for (i = 2; i < sizeof(ssid.Ssid); i++)
-			ssid.Ssid[i] = 0x1 + (ssid.Ssid[i] * 0xfe / 0xff);
+		ssid.length = cpu_to_le32(sizeof(ssid.essid));
+		get_random_bytes(&ssid.essid[2], sizeof(ssid.essid)-2);
+		ssid.essid[0] = 0x1;
+		ssid.essid[1] = 0xff;
+		for (i = 2; i < sizeof(ssid.essid); i++)
+			ssid.essid[i] = 0x1 + (ssid.essid[i] * 0xfe / 0xff);
 		ret = set_essid(usbdev, &ssid);
 	}
 	return ret;
@@ -900,13 +899,13 @@ static int add_wep_key(struct usbnet *usbdev, char *key, int key_len, int index)
 
 	memset(&ndis_key, 0, sizeof(ndis_key));
 
-	ndis_key.Length = cpu_to_le32(sizeof(ndis_key));
-	ndis_key.KeyLength = cpu_to_le32(key_len);
-	ndis_key.KeyIndex = cpu_to_le32(index);
-	memcpy(&ndis_key.KeyMaterial, key, key_len);
+	ndis_key.size = cpu_to_le32(sizeof(ndis_key));
+	ndis_key.length = cpu_to_le32(key_len);
+	ndis_key.index = cpu_to_le32(index);
+	memcpy(&ndis_key.material, key, key_len);
 
 	if (index == priv->encr_tx_key_index) {
-		ndis_key.KeyIndex |= cpu_to_le32(1 << 31);
+		ndis_key.index |= cpu_to_le32(1 << 31);
 		ret = set_encr_mode(usbdev, IW_AUTH_CIPHER_WEP104,
 						IW_AUTH_CIPHER_NONE);
 		if (ret)
@@ -947,17 +946,17 @@ static int remove_key(struct usbnet *usbdev, int index, u8 bssid[ETH_ALEN])
 	    priv->wpa_cipher_pair == IW_AUTH_CIPHER_CCMP ||
 	    priv->wpa_cipher_group == IW_AUTH_CIPHER_TKIP ||
 	    priv->wpa_cipher_group == IW_AUTH_CIPHER_CCMP) {
-		remove_key.Length = cpu_to_le32(sizeof(remove_key));
-		remove_key.KeyIndex = cpu_to_le32(index);
+		remove_key.size = cpu_to_le32(sizeof(remove_key));
+		remove_key.index = cpu_to_le32(index);
 		if (bssid) {
 			/* pairwise key */
 			if (memcmp(bssid, ffff_bssid, ETH_ALEN) != 0)
-				remove_key.KeyIndex |= cpu_to_le32(1 << 30);
-			memcpy(remove_key.Bssid, bssid,
-					sizeof(remove_key.Bssid));
+				remove_key.index |= cpu_to_le32(1 << 30);
+			memcpy(remove_key.bssid, bssid,
+					sizeof(remove_key.bssid));
 		} else
-			memset(remove_key.Bssid, 0xff,
-						sizeof(remove_key.Bssid));
+			memset(remove_key.bssid, 0xff,
+						sizeof(remove_key.bssid));
 
 		ret = rndis_set_oid(usbdev, OID_802_11_REMOVE_KEY, &remove_key,
 							sizeof(remove_key));
@@ -1187,11 +1186,11 @@ static int rndis_iw_set_essid(struct net_device *dev,
 	if (length > NDIS_802_11_LENGTH_SSID)
 		length = NDIS_802_11_LENGTH_SSID;
 
-	ssid.SsidLength = cpu_to_le32(length);
+	ssid.length = cpu_to_le32(length);
 	if (length > 0)
-		memcpy(ssid.Ssid, essid, length);
+		memcpy(ssid.essid, essid, length);
 	else
-		memset(ssid.Ssid, 0, NDIS_802_11_LENGTH_SSID);
+		memset(ssid.essid, 0, NDIS_802_11_LENGTH_SSID);
 
 	set_assoc_params(usbdev);
 
@@ -1211,10 +1210,10 @@ static int rndis_iw_get_essid(struct net_device *dev,
 
 	ret = get_essid(usbdev, &ssid);
 
-	if (ret == 0 && le32_to_cpu(ssid.SsidLength) > 0) {
+	if (ret == 0 && le32_to_cpu(ssid.length) > 0) {
 		wrqu->essid.flags = 1;
-		wrqu->essid.length = le32_to_cpu(ssid.SsidLength);
-		memcpy(essid, ssid.Ssid, wrqu->essid.length);
+		wrqu->essid.length = le32_to_cpu(ssid.length);
+		memcpy(essid, ssid.essid, wrqu->essid.length);
 		essid[wrqu->essid.length] = 0;
 	} else {
 		memset(essid, 0, sizeof(NDIS_802_11_LENGTH_SSID));
@@ -1525,54 +1524,54 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 	    ext->alg == IW_ENCODE_ALG_NONE || ext->key_len == 0)
 		return remove_key(usbdev, keyidx, NULL);
 
-	if (ext->key_len > sizeof(ndis_key.KeyMaterial))
+	if (ext->key_len > sizeof(ndis_key.material))
 		return -1;
 
 	memset(&ndis_key, 0, sizeof(ndis_key));
 
-	ndis_key.Length = cpu_to_le32(sizeof(ndis_key) -
-				sizeof(ndis_key.KeyMaterial) + ext->key_len);
-	ndis_key.KeyLength = cpu_to_le32(ext->key_len);
-	ndis_key.KeyIndex = cpu_to_le32(keyidx);
+	ndis_key.size = cpu_to_le32(sizeof(ndis_key) -
+				sizeof(ndis_key.material) + ext->key_len);
+	ndis_key.length = cpu_to_le32(ext->key_len);
+	ndis_key.index = cpu_to_le32(keyidx);
 
 	if (ext->ext_flags & IW_ENCODE_EXT_RX_SEQ_VALID) {
-		memcpy(ndis_key.KeyRSC, ext->rx_seq, 6);
-		ndis_key.KeyIndex |= cpu_to_le32(1 << 29);
+		memcpy(ndis_key.rsc, ext->rx_seq, 6);
+		ndis_key.index |= cpu_to_le32(1 << 29);
 	}
 
 	addr = ext->addr.sa_data;
 	if (ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) {
 		/* group key */
 		if (priv->infra_mode == ndis_80211_infra_adhoc)
-			memset(ndis_key.Bssid, 0xff, ETH_ALEN);
+			memset(ndis_key.bssid, 0xff, ETH_ALEN);
 		else
-			get_bssid(usbdev, ndis_key.Bssid);
+			get_bssid(usbdev, ndis_key.bssid);
 	} else {
 		/* pairwise key */
-		ndis_key.KeyIndex |= cpu_to_le32(1 << 30);
-		memcpy(ndis_key.Bssid, addr, ETH_ALEN);
+		ndis_key.index |= cpu_to_le32(1 << 30);
+		memcpy(ndis_key.bssid, addr, ETH_ALEN);
 	}
 
 	if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
-		ndis_key.KeyIndex |= cpu_to_le32(1 << 31);
+		ndis_key.index |= cpu_to_le32(1 << 31);
 
 	if (ext->alg == IW_ENCODE_ALG_TKIP && ext->key_len == 32) {
 		/* wpa_supplicant gives us the Michael MIC RX/TX keys in
 		 * different order than NDIS spec, so swap the order here. */
-		memcpy(ndis_key.KeyMaterial, ext->key, 16);
-		memcpy(ndis_key.KeyMaterial + 16, ext->key + 24, 8);
-		memcpy(ndis_key.KeyMaterial + 24, ext->key + 16, 8);
+		memcpy(ndis_key.material, ext->key, 16);
+		memcpy(ndis_key.material + 16, ext->key + 24, 8);
+		memcpy(ndis_key.material + 24, ext->key + 16, 8);
 	} else
-		memcpy(ndis_key.KeyMaterial, ext->key, ext->key_len);
+		memcpy(ndis_key.material, ext->key, ext->key_len);
 
 	ret = rndis_set_oid(usbdev, OID_802_11_ADD_KEY, &ndis_key,
-					le32_to_cpu(ndis_key.Length));
+					le32_to_cpu(ndis_key.size));
 	devdbg(usbdev, "SIOCSIWENCODEEXT: OID_802_11_ADD_KEY -> %08X", ret);
 	if (ret != 0)
 		return ret;
 
 	priv->encr_key_len[keyidx] = ext->key_len;
-	memcpy(&priv->encr_keys[keyidx], ndis_key.KeyMaterial, ext->key_len);
+	memcpy(&priv->encr_keys[keyidx], ndis_key.material, ext->key_len);
 	if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
 		priv->encr_tx_key_index = keyidx;
 
@@ -1617,27 +1616,24 @@ static char *rndis_translate_scan(struct net_device *dev,
 	unsigned char sbuf[32];
 	DECLARE_MAC_BUF(mac);
 
-	bssid_len = le32_to_cpu(bssid->Length);
+	bssid_len = le32_to_cpu(bssid->length);
 
-	devdbg(usbdev, "BSSID %s", print_mac(mac, bssid->MacAddress));
+	devdbg(usbdev, "BSSID %s", print_mac(mac, bssid->mac));
 	iwe.cmd = SIOCGIWAP;
 	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
-	memcpy(iwe.u.ap_addr.sa_data, bssid->MacAddress, ETH_ALEN);
+	memcpy(iwe.u.ap_addr.sa_data, bssid->mac, ETH_ALEN);
 	cev = iwe_stream_add_event(cev, end_buf, &iwe, IW_EV_ADDR_LEN);
 
-	devdbg(usbdev, "SSID(%d) %s",
-		le32_to_cpu(bssid->Ssid.SsidLength),
-		bssid->Ssid.Ssid);
+	devdbg(usbdev, "SSID(%d) %s", le32_to_cpu(bssid->ssid.length),
+						bssid->ssid.essid);
 	iwe.cmd = SIOCGIWESSID;
-	iwe.u.essid.length = le32_to_cpu(bssid->Ssid.SsidLength);
+	iwe.u.essid.length = le32_to_cpu(bssid->ssid.length);
 	iwe.u.essid.flags = 1;
-	cev = iwe_stream_add_point(cev, end_buf, &iwe,
-						bssid->Ssid.Ssid);
+	cev = iwe_stream_add_point(cev, end_buf, &iwe, bssid->ssid.essid);
 
-	devdbg(usbdev, "MODE %d",
-			le32_to_cpu(bssid->InfrastructureMode));
+	devdbg(usbdev, "MODE %d", le32_to_cpu(bssid->net_infra));
 	iwe.cmd = SIOCGIWMODE;
-	switch (le32_to_cpu(bssid->InfrastructureMode)) {
+	switch (le32_to_cpu(bssid->net_infra)) {
 	case ndis_80211_infra_adhoc:
 		iwe.u.mode = IW_MODE_ADHOC;
 		break;
@@ -1651,26 +1647,24 @@ static char *rndis_translate_scan(struct net_device *dev,
 	}
 	cev = iwe_stream_add_event(cev, end_buf, &iwe, IW_EV_UINT_LEN);
 
-	devdbg(usbdev, "FREQ %d kHz",
-		le32_to_cpu(bssid->Configuration.DSConfig));
+	devdbg(usbdev, "FREQ %d kHz", le32_to_cpu(bssid->config.ds_config));
 	iwe.cmd = SIOCGIWFREQ;
-	dsconfig_to_freq(le32_to_cpu(bssid->Configuration.DSConfig),
-								&iwe.u.freq);
+	dsconfig_to_freq(le32_to_cpu(bssid->config.ds_config), &iwe.u.freq);
 	cev = iwe_stream_add_event(cev, end_buf, &iwe, IW_EV_FREQ_LEN);
 
-	devdbg(usbdev, "QUAL %d", le32_to_cpu(bssid->Rssi));
+	devdbg(usbdev, "QUAL %d", le32_to_cpu(bssid->rssi));
 	iwe.cmd = IWEVQUAL;
-	iwe.u.qual.qual  = level_to_qual(le32_to_cpu(bssid->Rssi));
-	iwe.u.qual.level = le32_to_cpu(bssid->Rssi);
+	iwe.u.qual.qual  = level_to_qual(le32_to_cpu(bssid->rssi));
+	iwe.u.qual.level = le32_to_cpu(bssid->rssi);
 	iwe.u.qual.updated = IW_QUAL_QUAL_UPDATED
 			| IW_QUAL_LEVEL_UPDATED
 			| IW_QUAL_NOISE_INVALID;
 	cev = iwe_stream_add_event(cev, end_buf, &iwe, IW_EV_QUAL_LEN);
 
-	devdbg(usbdev, "ENCODE %d", le32_to_cpu(bssid->Privacy));
+	devdbg(usbdev, "ENCODE %d", le32_to_cpu(bssid->privacy));
 	iwe.cmd = SIOCGIWENCODE;
 	iwe.u.data.length = 0;
-	if (le32_to_cpu(bssid->Privacy) == ndis_80211_priv_accept_all)
+	if (le32_to_cpu(bssid->privacy) == ndis_80211_priv_accept_all)
 		iwe.u.data.flags = IW_ENCODE_DISABLED;
 	else
 		iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
@@ -1680,10 +1674,10 @@ static char *rndis_translate_scan(struct net_device *dev,
 	devdbg(usbdev, "RATES:");
 	current_val = cev + IW_EV_LCP_LEN;
 	iwe.cmd = SIOCGIWRATE;
-	for (i = 0; i < sizeof(bssid->SupportedRates); i++) {
-		if (bssid->SupportedRates[i] & 0x7f) {
+	for (i = 0; i < sizeof(bssid->rates); i++) {
+		if (bssid->rates[i] & 0x7f) {
 			iwe.u.bitrate.value =
-				((bssid->SupportedRates[i] & 0x7f) *
+				((bssid->rates[i] & 0x7f) *
 				500000);
 			devdbg(usbdev, " %d", iwe.u.bitrate.value);
 			current_val = iwe_stream_add_value(cev,
@@ -1695,23 +1689,23 @@ static char *rndis_translate_scan(struct net_device *dev,
 	if ((current_val - cev) > IW_EV_LCP_LEN)
 		cev = current_val;
 
-	beacon = le32_to_cpu(bssid->Configuration.BeaconPeriod);
+	beacon = le32_to_cpu(bssid->config.beacon_period);
 	devdbg(usbdev, "BCN_INT %d", beacon);
 	iwe.cmd = IWEVCUSTOM;
 	snprintf(sbuf, sizeof(sbuf), "bcn_int=%d", beacon);
 	iwe.u.data.length = strlen(sbuf);
 	cev = iwe_stream_add_point(cev, end_buf, &iwe, sbuf);
 
-	atim = le32_to_cpu(bssid->Configuration.ATIMWindow);
+	atim = le32_to_cpu(bssid->config.atim_window);
 	devdbg(usbdev, "ATIM %d", atim);
 	iwe.cmd = IWEVCUSTOM;
 	snprintf(sbuf, sizeof(sbuf), "atim=%u", atim);
 	iwe.u.data.length = strlen(sbuf);
 	cev = iwe_stream_add_point(cev, end_buf, &iwe, sbuf);
 
-	ie = (void *)(bssid->IEs + sizeof(struct ndis_80211_fixed_ies));
+	ie = (void *)(bssid->ies + sizeof(struct ndis_80211_fixed_ies));
 	ie_len = min(bssid_len - (int)sizeof(*bssid),
-					(int)le32_to_cpu(bssid->IELength));
+					(int)le32_to_cpu(bssid->ie_length));
 	ie_len -= sizeof(struct ndis_80211_fixed_ies);
 	while (ie_len >= sizeof(*ie) && sizeof(*ie) + ie->len <= ie_len) {
 		if ((ie->id == MFIE_TYPE_GENERIC && ie->len >= 4 &&
@@ -1758,16 +1752,16 @@ static int rndis_iw_get_scan(struct net_device *dev,
 		goto out;
 
 	bssid_list = buf;
-	bssid = bssid_list->Bssid;
-	bssid_len = le32_to_cpu(bssid->Length);
-	count = le32_to_cpu(bssid_list->NumberOfItems);
+	bssid = bssid_list->bssid;
+	bssid_len = le32_to_cpu(bssid->length);
+	count = le32_to_cpu(bssid_list->num_items);
 	devdbg(usbdev, "SIOCGIWSCAN: %d BSSIDs found", count);
 
 	while (count && ((void *)bssid + bssid_len) <= (buf + len)) {
 		cev = rndis_translate_scan(dev, cev, extra + IW_SCAN_MAX_DATA,
 									bssid);
 		bssid = (void *)bssid + bssid_len;
-		bssid_len = le32_to_cpu(bssid->Length);
+		bssid_len = le32_to_cpu(bssid->length);
 		count--;
 	}
 
@@ -1960,7 +1954,7 @@ static int rndis_iw_set_freq(struct net_device *dev,
 		return 0;
 	}
 
-	config.DSConfig = cpu_to_le32(dsconfig);
+	config.ds_config = cpu_to_le32(dsconfig);
 
 	devdbg(usbdev, "SIOCSIWFREQ: %d * 10^%d", wrqu->freq.m, wrqu->freq.e);
 	return rndis_set_oid(usbdev, OID_802_11_CONFIGURATION, &config,
@@ -1978,7 +1972,7 @@ static int rndis_iw_get_freq(struct net_device *dev,
 	len = sizeof(config);
 	ret = rndis_query_oid(usbdev, OID_802_11_CONFIGURATION, &config, &len);
 	if (ret == 0)
-		dsconfig_to_freq(le32_to_cpu(config.DSConfig), &wrqu->freq);
+		dsconfig_to_freq(le32_to_cpu(config.ds_config), &wrqu->freq);
 
 	devdbg(usbdev, "SIOCGIWFREQ: %d", wrqu->freq.m);
 	return ret;

