Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4923 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab2I0MSS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 08:18:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/11] brcmfmac: add hostap supoort.
Date: Thu, 27 Sep 2012 14:17:54 +0200
Message-ID: <1348748277-21460-9-git-send-email-arend@broadcom.com> (sfid-20120927_141830_217257_7982239C)
In-Reply-To: <1348748277-21460-1-git-send-email-arend@broadcom.com>
References: <1348748277-21460-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

This patch adds support for host AP mode.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   29 +
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  966 +++++++++++++++++++-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   18 +-
 3 files changed, 962 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index fc4bc6d..eed695a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -27,6 +27,7 @@
  * IO codes that are interpreted by dongle firmware
  ******************************************************************************/
 #define BRCMF_C_UP				2
+#define BRCMF_C_DOWN				3
 #define BRCMF_C_SET_PROMISC			10
 #define BRCMF_C_GET_RATE			12
 #define BRCMF_C_GET_INFRA			19
@@ -50,7 +51,10 @@
 #define BRCMF_C_REASSOC				53
 #define BRCMF_C_SET_ROAM_TRIGGER		55
 #define BRCMF_C_SET_ROAM_DELTA			57
+#define BRCMF_C_GET_BCNPRD			75
+#define BRCMF_C_SET_BCNPRD			76
 #define BRCMF_C_GET_DTIMPRD			77
+#define BRCMF_C_SET_DTIMPRD			78
 #define BRCMF_C_SET_COUNTRY			84
 #define BRCMF_C_GET_PM				85
 #define BRCMF_C_SET_PM				86
@@ -134,6 +138,9 @@
 
 #define WLC_BSS_RSSI_ON_CHANNEL		0x0002
 
+#define BRCMF_MAXRATES_IN_SET		16	/* max # of rates in rateset */
+#define BRCMF_STA_ASSOC			0x10		/* Associated */
+
 struct brcmf_event_msg {
 	__be16 version;
 	__be16 flags;
@@ -566,6 +573,28 @@ struct brcmf_channel_info_le {
 	__le32 scan_channel;
 };
 
+struct brcmf_sta_info_le {
+	__le16	ver;		/* version of this struct */
+	__le16	len;		/* length in bytes of this structure */
+	__le16	cap;		/* sta's advertised capabilities */
+	__le32	flags;		/* flags defined below */
+	__le32	idle;		/* time since data pkt rx'd from sta */
+	u8	ea[ETH_ALEN];		/* Station address */
+	__le32	count;			/* # rates in this set */
+	u8	rates[BRCMF_MAXRATES_IN_SET];	/* rates in 500kbps units */
+						/* w/hi bit set if basic */
+	__le32	in;		/* seconds elapsed since associated */
+	__le32	listen_interval_inms; /* Min Listen interval in ms for STA */
+	__le32	tx_pkts;	/* # of packets transmitted */
+	__le32	tx_failures;	/* # of packets failed */
+	__le32	rx_ucast_pkts;	/* # of unicast packets received */
+	__le32	rx_mcast_pkts;	/* # of multicast packets received */
+	__le32	tx_rate;	/* Rate of last successful tx frame */
+	__le32	rx_rate;	/* Rate of last successful rx frame */
+	__le32	rx_decrypt_succeeds;	/* # of packet decrypted successfully */
+	__le32	rx_decrypt_failures;	/* # of packet decrypted failed */
+};
+
 /* Bus independent dongle command */
 struct brcmf_dcmd {
 	uint cmd;		/* common dongle cmd definition */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index e25430d..9d8d2eb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -48,7 +48,45 @@
 #define BRCMF_PNO_SCAN_COMPLETE		1
 #define BRCMF_PNO_SCAN_INCOMPLETE	0
 
+#define TLV_LEN_OFF			1	/* length offset */
 #define TLV_HDR_LEN			2	/* header length */
+#define TLV_BODY_OFF			2	/* body offset */
+#define TLV_OUI_LEN			3	/* oui id length */
+#define WPA_OUI				"\x00\x50\xF2"	/* WPA OUI */
+#define WPA_OUI_TYPE			1
+#define RSN_OUI				"\x00\x0F\xAC"	/* RSN OUI */
+#define	WME_OUI_TYPE			2
+
+#define VS_IE_FIXED_HDR_LEN		6
+#define WPA_IE_VERSION_LEN		2
+#define WPA_IE_MIN_OUI_LEN		4
+#define WPA_IE_SUITE_COUNT_LEN		2
+
+#define WPA_CIPHER_NONE			0	/* None */
+#define WPA_CIPHER_WEP_40		1	/* WEP (40-bit) */
+#define WPA_CIPHER_TKIP			2	/* TKIP: default for WPA */
+#define WPA_CIPHER_AES_CCM		4	/* AES (CCM) */
+#define WPA_CIPHER_WEP_104		5	/* WEP (104-bit) */
+
+#define RSN_AKM_NONE			0	/* None (IBSS) */
+#define RSN_AKM_UNSPECIFIED		1	/* Over 802.1x */
+#define RSN_AKM_PSK			2	/* Pre-shared Key */
+#define RSN_CAP_LEN			2	/* Length of RSN capabilities */
+#define RSN_CAP_PTK_REPLAY_CNTR_MASK	0x000C
+
+#define VNDR_IE_CMD_LEN			4	/* length of the set command
+						 * string :"add", "del" (+ NUL)
+						 */
+#define VNDR_IE_COUNT_OFFSET		4
+#define VNDR_IE_PKTFLAG_OFFSET		8
+#define VNDR_IE_VSIE_OFFSET		12
+#define VNDR_IE_HDR_SIZE		12
+#define VNDR_IE_BEACON_FLAG		0x1
+#define VNDR_IE_PRBRSP_FLAG		0x2
+#define MAX_VNDR_IE_NUMBER		5
+
+#define	DOT11_MGMT_HDR_LEN		24	/* d11 management header len */
+#define	DOT11_BCN_PRB_FIXED_LEN		12	/* beacon/probe fixed length */
 
 #define BRCMF_ASSOC_PARAMS_FIXED_SIZE \
 	(sizeof(struct brcmf_assoc_params_le) - sizeof(u16))
@@ -250,6 +288,25 @@ struct brcmf_tlv {
 	u8 data[1];
 };
 
+/* Vendor specific ie. id = 221, oui and type defines exact ie */
+struct brcmf_vs_tlv {
+	u8 id;
+	u8 len;
+	u8 oui[3];
+	u8 oui_type;
+};
+
+struct parsed_vndr_ie_info {
+	u8 *ie_ptr;
+	u32 ie_len;	/* total length including id & length field */
+	struct brcmf_vs_tlv vndrie;
+};
+
+struct parsed_vndr_ies {
+	u32 count;
+	struct parsed_vndr_ie_info ie_info[MAX_VNDR_IE_NUMBER];
+};
+
 /* Quarter dBm units to mW
  * Table starts at QDBM_OFFSET, so the first entry is mW for qdBm=153
  * Table is offset so the last entry is largest mW value that fits in
@@ -424,13 +481,11 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 			 struct vif_params *params)
 {
 	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
-	struct wireless_dev *wdev;
 	s32 infra = 0;
+	s32 ap = 0;
 	s32 err = 0;
 
-	WL_TRACE("Enter\n");
-	if (!check_sys_up(wiphy))
-		return -EIO;
+	WL_TRACE("Enter, ndev=%p, type=%d\n", ndev, type);
 
 	switch (type) {
 	case NL80211_IFTYPE_MONITOR:
@@ -446,22 +501,37 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 		cfg_priv->conf->mode = WL_MODE_BSS;
 		infra = 1;
 		break;
+	case NL80211_IFTYPE_AP:
+		cfg_priv->conf->mode = WL_MODE_AP;
+		ap = 1;
+		break;
 	default:
 		err = -EINVAL;
 		goto done;
 	}
 
-	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_INFRA, &infra);
-	if (err) {
-		WL_ERR("WLC_SET_INFRA error (%d)\n", err);
-		err = -EAGAIN;
+	if (ap) {
+		set_bit(WL_STATUS_AP_CREATING, &cfg_priv->status);
+		if (!cfg_priv->ap_info)
+			cfg_priv->ap_info = kzalloc(sizeof(*cfg_priv->ap_info),
+						    GFP_KERNEL);
+		if (!cfg_priv->ap_info) {
+			err = -ENOMEM;
+			goto done;
+		}
+		WL_INFO("IF Type = AP\n");
 	} else {
-		wdev = ndev->ieee80211_ptr;
-		wdev->iftype = type;
+		err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_INFRA, &infra);
+		if (err) {
+			WL_ERR("WLC_SET_INFRA error (%d)\n", err);
+			err = -EAGAIN;
+			goto done;
+		}
+		WL_INFO("IF Type = %s\n",
+			(cfg_priv->conf->mode == WL_MODE_IBSS) ?
+			"Adhoc" : "Infra");
 	}
-
-	WL_INFO("IF Type = %s\n",
-		(cfg_priv->conf->mode == WL_MODE_IBSS) ? "Adhoc" : "Infra");
+	ndev->ieee80211_ptr->iftype = type;
 
 done:
 	WL_TRACE("Exit\n");
@@ -2101,9 +2171,12 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		WL_CONN("WLAN_CIPHER_SUITE_WEP104\n");
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
-		memcpy(keybuf, &key.data[24], sizeof(keybuf));
-		memcpy(&key.data[24], &key.data[16], sizeof(keybuf));
-		memcpy(&key.data[16], keybuf, sizeof(keybuf));
+		if (cfg_priv->conf->mode != WL_MODE_AP) {
+			WL_CONN("Swapping key\n");
+			memcpy(keybuf, &key.data[24], sizeof(keybuf));
+			memcpy(&key.data[24], &key.data[16], sizeof(keybuf));
+			memcpy(&key.data[16], keybuf, sizeof(keybuf));
+		}
 		key.algo = CRYPTO_ALGO_TKIP;
 		val = TKIP_ENABLED;
 		WL_CONN("WLAN_CIPHER_SUITE_TKIP\n");
@@ -2253,7 +2326,7 @@ brcmf_cfg80211_config_default_mgmt_key(struct wiphy *wiphy,
 
 static s32
 brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
-			u8 *mac, struct station_info *sinfo)
+			   u8 *mac, struct station_info *sinfo)
 {
 	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
 	struct brcmf_scb_val_le scb_val;
@@ -2261,45 +2334,64 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 	s32 rate;
 	s32 err = 0;
 	u8 *bssid = brcmf_read_prof(cfg_priv, WL_PROF_BSSID);
+	struct brcmf_sta_info_le *sta_info_le;
 
-	WL_TRACE("Enter\n");
+	WL_TRACE("Enter, MAC %pM\n", mac);
 	if (!check_sys_up(wiphy))
 		return -EIO;
 
-	if (memcmp(mac, bssid, ETH_ALEN)) {
-		WL_ERR("Wrong Mac address cfg_mac-%X:%X:%X:%X:%X:%X"
-			"wl_bssid-%X:%X:%X:%X:%X:%X\n",
-			mac[0], mac[1], mac[2], mac[3], mac[4], mac[5],
-			bssid[0], bssid[1], bssid[2], bssid[3],
-			bssid[4], bssid[5]);
-		err = -ENOENT;
-		goto done;
-	}
-
-	/* Report the current tx rate */
-	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_GET_RATE, &rate);
-	if (err) {
-		WL_ERR("Could not get rate (%d)\n", err);
-	} else {
-		sinfo->filled |= STATION_INFO_TX_BITRATE;
-		sinfo->txrate.legacy = rate * 5;
-		WL_CONN("Rate %d Mbps\n", rate / 2);
-	}
+	if (cfg_priv->conf->mode == WL_MODE_AP) {
+		err = brcmf_dev_iovar_getbuf(ndev, "sta_info", mac, ETH_ALEN,
+					     cfg_priv->dcmd_buf,
+					     WL_DCMD_LEN_MAX);
+		if (err < 0) {
+			WL_ERR("GET STA INFO failed, %d\n", err);
+			goto done;
+		}
+		sta_info_le = (struct brcmf_sta_info_le *)cfg_priv->dcmd_buf;
 
-	if (test_bit(WL_STATUS_CONNECTED, &cfg_priv->status)) {
-		memset(&scb_val, 0, sizeof(scb_val));
-		err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_RSSI, &scb_val,
-				      sizeof(struct brcmf_scb_val_le));
+		sinfo->filled = STATION_INFO_INACTIVE_TIME;
+		sinfo->inactive_time = le32_to_cpu(sta_info_le->idle) * 1000;
+		if (le32_to_cpu(sta_info_le->flags) & BRCMF_STA_ASSOC) {
+			sinfo->filled |= STATION_INFO_CONNECTED_TIME;
+			sinfo->connected_time = le32_to_cpu(sta_info_le->in);
+		}
+		WL_TRACE("STA idle time : %d ms, connected time :%d sec\n",
+			 sinfo->inactive_time, sinfo->connected_time);
+	} else if (cfg_priv->conf->mode == WL_MODE_BSS) {
+		if (memcmp(mac, bssid, ETH_ALEN)) {
+			WL_ERR("Wrong Mac address cfg_mac-%pM wl_bssid-%pM\n",
+			       mac, bssid);
+			err = -ENOENT;
+			goto done;
+		}
+		/* Report the current tx rate */
+		err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_GET_RATE, &rate);
 		if (err) {
-			WL_ERR("Could not get rssi (%d)\n", err);
+			WL_ERR("Could not get rate (%d)\n", err);
+			goto done;
 		} else {
-			rssi = le32_to_cpu(scb_val.val);
-			sinfo->filled |= STATION_INFO_SIGNAL;
-			sinfo->signal = rssi;
-			WL_CONN("RSSI %d dBm\n", rssi);
+			sinfo->filled |= STATION_INFO_TX_BITRATE;
+			sinfo->txrate.legacy = rate * 5;
+			WL_CONN("Rate %d Mbps\n", rate / 2);
 		}
-	}
 
+		if (test_bit(WL_STATUS_CONNECTED, &cfg_priv->status)) {
+			memset(&scb_val, 0, sizeof(scb_val));
+			err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_RSSI, &scb_val,
+					      sizeof(scb_val));
+			if (err) {
+				WL_ERR("Could not get rssi (%d)\n", err);
+				goto done;
+			} else {
+				rssi = le32_to_cpu(scb_val.val);
+				sinfo->filled |= STATION_INFO_SIGNAL;
+				sinfo->signal = rssi;
+				WL_CONN("RSSI %d dBm\n", rssi);
+			}
+		}
+	} else
+		err = -EPERM;
 done:
 	WL_TRACE("Exit\n");
 	return err;
@@ -2605,6 +2697,45 @@ static struct brcmf_tlv *brcmf_parse_tlvs(void *buf, int buflen, uint key)
 	return NULL;
 }
 
+/* Is any of the tlvs the expected entry? If
+ * not update the tlvs buffer pointer/length.
+ */
+static bool
+brcmf_tlv_has_ie(u8 *ie, u8 **tlvs, u32 *tlvs_len,
+		 u8 *oui, u32 oui_len, u8 type)
+{
+	/* If the contents match the OUI and the type */
+	if (ie[TLV_LEN_OFF] >= oui_len + 1 &&
+	    !memcmp(&ie[TLV_BODY_OFF], oui, oui_len) &&
+	    type == ie[TLV_BODY_OFF + oui_len]) {
+		return true;
+	}
+
+	if (tlvs == NULL)
+		return false;
+	/* point to the next ie */
+	ie += ie[TLV_LEN_OFF] + TLV_HDR_LEN;
+	/* calculate the length of the rest of the buffer */
+	*tlvs_len -= (int)(ie - *tlvs);
+	/* update the pointer to the start of the buffer */
+	*tlvs = ie;
+
+	return false;
+}
+
+struct brcmf_vs_tlv *
+brcmf_find_wpaie(u8 *parse, u32 len)
+{
+	struct brcmf_tlv *ie;
+
+	while ((ie = brcmf_parse_tlvs(parse, len, WLAN_EID_WPA))) {
+		if (brcmf_tlv_has_ie((u8 *)ie, &parse, &len,
+				     WPA_OUI, TLV_OUI_LEN, WPA_OUI_TYPE))
+			return (struct brcmf_vs_tlv *)ie;
+	}
+	return NULL;
+}
+
 static s32 brcmf_update_bss_info(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	struct brcmf_bss_info_le *bi;
@@ -3588,6 +3719,682 @@ static int brcmf_cfg80211_testmode(struct wiphy *wiphy, void *data, int len)
 }
 #endif
 
+static s32 brcmf_configure_opensecurity(struct net_device *ndev, s32 bssidx)
+{
+	s32 err;
+
+	/* set auth */
+	err = brcmf_dev_intvar_set_bsscfg(ndev, "auth", 0, bssidx);
+	if (err < 0) {
+		WL_ERR("auth error %d\n", err);
+		return err;
+	}
+	/* set wsec */
+	err = brcmf_dev_intvar_set_bsscfg(ndev, "wsec", 0, bssidx);
+	if (err < 0) {
+		WL_ERR("wsec error %d\n", err);
+		return err;
+	}
+	/* set upper-layer auth */
+	err = brcmf_dev_intvar_set_bsscfg(ndev, "wpa_auth",
+					  WPA_AUTH_NONE, bssidx);
+	if (err < 0) {
+		WL_ERR("wpa_auth error %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+static bool brcmf_valid_wpa_oui(u8 *oui, bool is_rsn_ie)
+{
+	if (is_rsn_ie)
+		return (memcmp(oui, RSN_OUI, TLV_OUI_LEN) == 0);
+
+	return (memcmp(oui, WPA_OUI, TLV_OUI_LEN) == 0);
+}
+
+static s32
+brcmf_configure_wpaie(struct net_device *ndev, struct brcmf_vs_tlv *wpa_ie,
+		     bool is_rsn_ie, s32 bssidx)
+{
+	u32 auth = 0; /* d11 open authentication */
+	u16 count;
+	s32 err = 0;
+	s32 len = 0;
+	u32 i;
+	u32 wsec;
+	u32 pval = 0;
+	u32 gval = 0;
+	u32 wpa_auth = 0;
+	u32 offset;
+	u8 *data;
+	u16 rsn_cap;
+	u32 wme_bss_disable;
+
+	WL_TRACE("Enter\n");
+	if (wpa_ie == NULL)
+		goto exit;
+
+	len = wpa_ie->len + TLV_HDR_LEN;
+	data = (u8 *)wpa_ie;
+	offset = 0;
+	if (!is_rsn_ie)
+		offset += VS_IE_FIXED_HDR_LEN;
+	offset += WPA_IE_VERSION_LEN;
+
+	/* check for multicast cipher suite */
+	if (offset + WPA_IE_MIN_OUI_LEN > len) {
+		err = -EINVAL;
+		WL_ERR("no multicast cipher suite\n");
+		goto exit;
+	}
+
+	if (!brcmf_valid_wpa_oui(&data[offset], is_rsn_ie)) {
+		err = -EINVAL;
+		WL_ERR("ivalid OUI\n");
+		goto exit;
+	}
+	offset += TLV_OUI_LEN;
+
+	/* pick up multicast cipher */
+	switch (data[offset]) {
+	case WPA_CIPHER_NONE:
+		gval = 0;
+		break;
+	case WPA_CIPHER_WEP_40:
+	case WPA_CIPHER_WEP_104:
+		gval = WEP_ENABLED;
+		break;
+	case WPA_CIPHER_TKIP:
+		gval = TKIP_ENABLED;
+		break;
+	case WPA_CIPHER_AES_CCM:
+		gval = AES_ENABLED;
+		break;
+	default:
+		err = -EINVAL;
+		WL_ERR("Invalid multi cast cipher info\n");
+		goto exit;
+	}
+
+	offset++;
+	/* walk thru unicast cipher list and pick up what we recognize */
+	count = data[offset] + (data[offset + 1] << 8);
+	offset += WPA_IE_SUITE_COUNT_LEN;
+	/* Check for unicast suite(s) */
+	if (offset + (WPA_IE_MIN_OUI_LEN * count) > len) {
+		err = -EINVAL;
+		WL_ERR("no unicast cipher suite\n");
+		goto exit;
+	}
+	for (i = 0; i < count; i++) {
+		if (!brcmf_valid_wpa_oui(&data[offset], is_rsn_ie)) {
+			err = -EINVAL;
+			WL_ERR("ivalid OUI\n");
+			goto exit;
+		}
+		offset += TLV_OUI_LEN;
+		switch (data[offset]) {
+		case WPA_CIPHER_NONE:
+			break;
+		case WPA_CIPHER_WEP_40:
+		case WPA_CIPHER_WEP_104:
+			pval |= WEP_ENABLED;
+			break;
+		case WPA_CIPHER_TKIP:
+			pval |= TKIP_ENABLED;
+			break;
+		case WPA_CIPHER_AES_CCM:
+			pval |= AES_ENABLED;
+			break;
+		default:
+			WL_ERR("Ivalid unicast security info\n");
+		}
+		offset++;
+	}
+	/* walk thru auth management suite list and pick up what we recognize */
+	count = data[offset] + (data[offset + 1] << 8);
+	offset += WPA_IE_SUITE_COUNT_LEN;
+	/* Check for auth key management suite(s) */
+	if (offset + (WPA_IE_MIN_OUI_LEN * count) > len) {
+		err = -EINVAL;
+		WL_ERR("no auth key mgmt suite\n");
+		goto exit;
+	}
+	for (i = 0; i < count; i++) {
+		if (!brcmf_valid_wpa_oui(&data[offset], is_rsn_ie)) {
+			err = -EINVAL;
+			WL_ERR("ivalid OUI\n");
+			goto exit;
+		}
+		offset += TLV_OUI_LEN;
+		switch (data[offset]) {
+		case RSN_AKM_NONE:
+			WL_TRACE("RSN_AKM_NONE\n");
+			wpa_auth |= WPA_AUTH_NONE;
+			break;
+		case RSN_AKM_UNSPECIFIED:
+			WL_TRACE("RSN_AKM_UNSPECIFIED\n");
+			is_rsn_ie ? (wpa_auth |= WPA2_AUTH_UNSPECIFIED) :
+				    (wpa_auth |= WPA_AUTH_UNSPECIFIED);
+			break;
+		case RSN_AKM_PSK:
+			WL_TRACE("RSN_AKM_PSK\n");
+			is_rsn_ie ? (wpa_auth |= WPA2_AUTH_PSK) :
+				    (wpa_auth |= WPA_AUTH_PSK);
+			break;
+		default:
+			WL_ERR("Ivalid key mgmt info\n");
+		}
+		offset++;
+	}
+
+	if (is_rsn_ie) {
+		wme_bss_disable = 1;
+		if ((offset + RSN_CAP_LEN) <= len) {
+			rsn_cap = data[offset] + (data[offset + 1] << 8);
+			if (rsn_cap & RSN_CAP_PTK_REPLAY_CNTR_MASK)
+				wme_bss_disable = 0;
+		}
+		/* set wme_bss_disable to sync RSN Capabilities */
+		err = brcmf_dev_intvar_set_bsscfg(ndev, "wme_bss_disable",
+						  wme_bss_disable, bssidx);
+		if (err < 0) {
+			WL_ERR("wme_bss_disable error %d\n", err);
+			goto exit;
+		}
+	}
+	/* FOR WPS , set SES_OW_ENABLED */
+	wsec = (pval | gval | SES_OW_ENABLED);
+
+	/* set auth */
+	err = brcmf_dev_intvar_set_bsscfg(ndev, "auth", auth, bssidx);
+	if (err < 0) {
+		WL_ERR("auth error %d\n", err);
+		goto exit;
+	}
+	/* set wsec */
+	err = brcmf_dev_intvar_set_bsscfg(ndev, "wsec", wsec, bssidx);
+	if (err < 0) {
+		WL_ERR("wsec error %d\n", err);
+		goto exit;
+	}
+	/* set upper-layer auth */
+	err = brcmf_dev_intvar_set_bsscfg(ndev, "wpa_auth", wpa_auth, bssidx);
+	if (err < 0) {
+		WL_ERR("wpa_auth error %d\n", err);
+		goto exit;
+	}
+
+exit:
+	return err;
+}
+
+static s32
+brcmf_parse_vndr_ies(u8 *vndr_ie_buf, u32 vndr_ie_len,
+		     struct parsed_vndr_ies *vndr_ies)
+{
+	s32 err = 0;
+	struct brcmf_vs_tlv *vndrie;
+	struct brcmf_tlv *ie;
+	struct parsed_vndr_ie_info *parsed_info;
+	s32 remaining_len;
+
+	remaining_len = (s32)vndr_ie_len;
+	memset(vndr_ies, 0, sizeof(*vndr_ies));
+
+	ie = (struct brcmf_tlv *)vndr_ie_buf;
+	while (ie) {
+		if (ie->id != WLAN_EID_VENDOR_SPECIFIC)
+			goto next;
+		vndrie = (struct brcmf_vs_tlv *)ie;
+		/* len should be bigger than OUI length + one */
+		if (vndrie->len < (VS_IE_FIXED_HDR_LEN - TLV_HDR_LEN + 1)) {
+			WL_ERR("invalid vndr ie. length is too small %d\n",
+				vndrie->len);
+			goto next;
+		}
+		/* if wpa or wme ie, do not add ie */
+		if (!memcmp(vndrie->oui, (u8 *)WPA_OUI, TLV_OUI_LEN) &&
+		    ((vndrie->oui_type == WPA_OUI_TYPE) ||
+		    (vndrie->oui_type == WME_OUI_TYPE))) {
+			WL_TRACE("Found WPA/WME oui. Do not add it\n");
+			goto next;
+		}
+
+		parsed_info = &vndr_ies->ie_info[vndr_ies->count];
+
+		/* save vndr ie information */
+		parsed_info->ie_ptr = (char *)vndrie;
+		parsed_info->ie_len = vndrie->len + TLV_HDR_LEN;
+		memcpy(&parsed_info->vndrie, vndrie, sizeof(*vndrie));
+
+		vndr_ies->count++;
+
+		WL_TRACE("** OUI %02x %02x %02x, type 0x%02x\n",
+			 parsed_info->vndrie.oui[0],
+			 parsed_info->vndrie.oui[1],
+			 parsed_info->vndrie.oui[2],
+			 parsed_info->vndrie.oui_type);
+
+		if (vndr_ies->count >= MAX_VNDR_IE_NUMBER)
+			break;
+next:
+		remaining_len -= ie->len;
+		if (remaining_len <= 2)
+			ie = NULL;
+		else
+			ie = (struct brcmf_tlv *)(((u8 *)ie) + ie->len);
+	}
+	return err;
+}
+
+static u32
+brcmf_vndr_ie(u8 *iebuf, s32 pktflag, u8 *ie_ptr, u32 ie_len, s8 *add_del_cmd)
+{
+
+	__le32 iecount_le;
+	__le32 pktflag_le;
+
+	strncpy(iebuf, add_del_cmd, VNDR_IE_CMD_LEN - 1);
+	iebuf[VNDR_IE_CMD_LEN - 1] = '\0';
+
+	iecount_le = cpu_to_le32(1);
+	memcpy(&iebuf[VNDR_IE_COUNT_OFFSET], &iecount_le, sizeof(iecount_le));
+
+	pktflag_le = cpu_to_le32(pktflag);
+	memcpy(&iebuf[VNDR_IE_PKTFLAG_OFFSET], &pktflag_le, sizeof(pktflag_le));
+
+	memcpy(&iebuf[VNDR_IE_VSIE_OFFSET], ie_ptr, ie_len);
+
+	return ie_len + VNDR_IE_HDR_SIZE;
+}
+
+s32
+brcmf_set_management_ie(struct brcmf_cfg80211_priv *cfg_priv,
+			struct net_device *ndev, s32 bssidx, s32 pktflag,
+			u8 *vndr_ie_buf, u32 vndr_ie_len)
+{
+	s32 err = 0;
+	u8  *iovar_ie_buf;
+	u8  *curr_ie_buf;
+	u8  *mgmt_ie_buf = NULL;
+	u32 mgmt_ie_buf_len = 0;
+	u32 *mgmt_ie_len = 0;
+	u32 del_add_ie_buf_len = 0;
+	u32 total_ie_buf_len = 0;
+	u32 parsed_ie_buf_len = 0;
+	struct parsed_vndr_ies old_vndr_ies;
+	struct parsed_vndr_ies new_vndr_ies;
+	struct parsed_vndr_ie_info *vndrie_info;
+	s32 i;
+	u8 *ptr;
+	u32 remained_buf_len;
+
+	WL_TRACE("bssidx %d, pktflag : 0x%02X\n", bssidx, pktflag);
+	iovar_ie_buf = kzalloc(WL_EXTRA_BUF_MAX, GFP_KERNEL);
+	if (!iovar_ie_buf)
+		return -ENOMEM;
+	curr_ie_buf = iovar_ie_buf;
+	if (test_bit(WL_STATUS_AP_CREATING, &cfg_priv->status) ||
+	    test_bit(WL_STATUS_AP_CREATED, &cfg_priv->status)) {
+		switch (pktflag) {
+		case VNDR_IE_PRBRSP_FLAG:
+			mgmt_ie_buf = cfg_priv->ap_info->probe_res_ie;
+			mgmt_ie_len = &cfg_priv->ap_info->probe_res_ie_len;
+			mgmt_ie_buf_len =
+				sizeof(cfg_priv->ap_info->probe_res_ie);
+			break;
+		case VNDR_IE_BEACON_FLAG:
+			mgmt_ie_buf = cfg_priv->ap_info->beacon_ie;
+			mgmt_ie_len = &cfg_priv->ap_info->beacon_ie_len;
+			mgmt_ie_buf_len = sizeof(cfg_priv->ap_info->beacon_ie);
+			break;
+		default:
+			err = -EPERM;
+			WL_ERR("not suitable type\n");
+			goto exit;
+		}
+		bssidx = 0;
+	} else {
+		err = -EPERM;
+		WL_ERR("not suitable type\n");
+		goto exit;
+	}
+
+	if (vndr_ie_len > mgmt_ie_buf_len) {
+		err = -ENOMEM;
+		WL_ERR("extra IE size too big\n");
+		goto exit;
+	}
+
+	/* parse and save new vndr_ie in curr_ie_buff before comparing it */
+	if (vndr_ie_buf && vndr_ie_len && curr_ie_buf) {
+		ptr = curr_ie_buf;
+		brcmf_parse_vndr_ies(vndr_ie_buf, vndr_ie_len, &new_vndr_ies);
+		for (i = 0; i < new_vndr_ies.count; i++) {
+			vndrie_info = &new_vndr_ies.ie_info[i];
+			memcpy(ptr + parsed_ie_buf_len, vndrie_info->ie_ptr,
+			       vndrie_info->ie_len);
+			parsed_ie_buf_len += vndrie_info->ie_len;
+		}
+	}
+
+	if (mgmt_ie_buf != NULL) {
+		if (parsed_ie_buf_len && (parsed_ie_buf_len == *mgmt_ie_len) &&
+		    (memcmp(mgmt_ie_buf, curr_ie_buf,
+			    parsed_ie_buf_len) == 0)) {
+			WL_TRACE("Previous mgmt IE is equals to current IE");
+			goto exit;
+		}
+
+		/* parse old vndr_ie */
+		brcmf_parse_vndr_ies(mgmt_ie_buf, *mgmt_ie_len, &old_vndr_ies);
+
+		/* make a command to delete old ie */
+		for (i = 0; i < old_vndr_ies.count; i++) {
+			vndrie_info = &old_vndr_ies.ie_info[i];
+
+			WL_TRACE("DEL ID : %d, Len: %d , OUI:%02x:%02x:%02x\n",
+				 vndrie_info->vndrie.id,
+				 vndrie_info->vndrie.len,
+				 vndrie_info->vndrie.oui[0],
+				 vndrie_info->vndrie.oui[1],
+				 vndrie_info->vndrie.oui[2]);
+
+			del_add_ie_buf_len = brcmf_vndr_ie(curr_ie_buf, pktflag,
+							   vndrie_info->ie_ptr,
+							   vndrie_info->ie_len,
+							   "del");
+			curr_ie_buf += del_add_ie_buf_len;
+			total_ie_buf_len += del_add_ie_buf_len;
+		}
+	}
+
+	*mgmt_ie_len = 0;
+	/* Add if there is any extra IE */
+	if (mgmt_ie_buf && parsed_ie_buf_len) {
+		ptr = mgmt_ie_buf;
+
+		remained_buf_len = mgmt_ie_buf_len;
+
+		/* make a command to add new ie */
+		for (i = 0; i < new_vndr_ies.count; i++) {
+			vndrie_info = &new_vndr_ies.ie_info[i];
+
+			WL_TRACE("ADDED ID : %d, Len: %d, OUI:%02x:%02x:%02x\n",
+				 vndrie_info->vndrie.id,
+				 vndrie_info->vndrie.len,
+				 vndrie_info->vndrie.oui[0],
+				 vndrie_info->vndrie.oui[1],
+				 vndrie_info->vndrie.oui[2]);
+
+			del_add_ie_buf_len = brcmf_vndr_ie(curr_ie_buf, pktflag,
+							   vndrie_info->ie_ptr,
+							   vndrie_info->ie_len,
+							   "add");
+			/* verify remained buf size before copy data */
+			remained_buf_len -= vndrie_info->ie_len;
+			if (remained_buf_len < 0) {
+				WL_ERR("no space in mgmt_ie_buf: len left %d",
+					remained_buf_len);
+				break;
+			}
+
+			/* save the parsed IE in wl struct */
+			memcpy(ptr + (*mgmt_ie_len), vndrie_info->ie_ptr,
+			       vndrie_info->ie_len);
+			*mgmt_ie_len += vndrie_info->ie_len;
+
+			curr_ie_buf += del_add_ie_buf_len;
+			total_ie_buf_len += del_add_ie_buf_len;
+		}
+	}
+	if (total_ie_buf_len) {
+		err  = brcmf_dev_iovar_setbuf_bsscfg(ndev, "vndr_ie",
+						     iovar_ie_buf,
+						     total_ie_buf_len,
+						     cfg_priv->extra_buf,
+						     WL_EXTRA_BUF_MAX, bssidx);
+		if (err)
+			WL_ERR("vndr ie set error : %d\n", err);
+	}
+
+exit:
+	kfree(iovar_ie_buf);
+	return err;
+}
+
+static s32
+brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
+			struct cfg80211_ap_settings *settings)
+{
+	s32 ie_offset;
+	struct brcmf_tlv *ssid_ie;
+	struct brcmf_ssid_le ssid_le;
+	s32 ioctl_value;
+	s32 err = -EPERM;
+	struct brcmf_tlv *rsn_ie;
+	struct brcmf_vs_tlv *wpa_ie;
+	struct brcmf_join_params join_params;
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	s32 bssidx = 0;
+
+	WL_TRACE("channel_type=%d, beacon_interval=%d, dtim_period=%d,\n",
+		 settings->channel_type, settings->beacon_interval,
+		 settings->dtim_period);
+	WL_TRACE("ssid=%s(%d), auth_type=%d, inactivity_timeout=%d\n",
+		 settings->ssid, settings->ssid_len, settings->auth_type,
+		 settings->inactivity_timeout);
+
+	if (!test_bit(WL_STATUS_AP_CREATING, &cfg_priv->status)) {
+		WL_ERR("Not in AP creation mode\n");
+		return -EPERM;
+	}
+
+	memset(&ssid_le, 0, sizeof(ssid_le));
+	if (settings->ssid == NULL || settings->ssid_len == 0) {
+		ie_offset = DOT11_MGMT_HDR_LEN + DOT11_BCN_PRB_FIXED_LEN;
+		ssid_ie = brcmf_parse_tlvs(
+				(u8 *)&settings->beacon.head[ie_offset],
+				settings->beacon.head_len - ie_offset,
+				WLAN_EID_SSID);
+		if (!ssid_ie)
+			return -EINVAL;
+
+		memcpy(ssid_le.SSID, ssid_ie->data, ssid_ie->len);
+		ssid_le.SSID_len = cpu_to_le32(ssid_ie->len);
+		WL_TRACE("SSID is (%s) in Head\n", ssid_le.SSID);
+	} else {
+		memcpy(ssid_le.SSID, settings->ssid, settings->ssid_len);
+		ssid_le.SSID_len = cpu_to_le32((u32)settings->ssid_len);
+	}
+
+	brcmf_set_mpc(ndev, 0);
+	ioctl_value = 1;
+	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_DOWN, &ioctl_value);
+	if (err < 0) {
+		WL_ERR("BRCMF_C_DOWN error %d\n", err);
+		goto exit;
+	}
+	ioctl_value = 1;
+	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_INFRA, &ioctl_value);
+	if (err < 0) {
+		WL_ERR("SET INFRA error %d\n", err);
+		goto exit;
+	}
+	ioctl_value = 1;
+	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_AP, &ioctl_value);
+	if (err < 0) {
+		WL_ERR("setting AP mode failed %d\n", err);
+		goto exit;
+	}
+
+	/* find the RSN_IE */
+	rsn_ie = brcmf_parse_tlvs((u8 *)settings->beacon.tail,
+				  settings->beacon.tail_len, WLAN_EID_RSN);
+
+	/* find the WPA_IE */
+	wpa_ie = brcmf_find_wpaie((u8 *)settings->beacon.tail,
+				  settings->beacon.tail_len);
+
+	kfree(cfg_priv->ap_info->rsn_ie);
+	cfg_priv->ap_info->rsn_ie = NULL;
+	kfree(cfg_priv->ap_info->wpa_ie);
+	cfg_priv->ap_info->wpa_ie = NULL;
+
+	if ((wpa_ie != NULL || rsn_ie != NULL)) {
+		WL_TRACE("WPA(2) IE is found\n");
+		if (wpa_ie != NULL) {
+			/* WPA IE */
+			err = brcmf_configure_wpaie(ndev, wpa_ie, false,
+						    bssidx);
+			if (err < 0)
+				goto exit;
+			cfg_priv->ap_info->wpa_ie = kmemdup(wpa_ie,
+							    wpa_ie->len +
+							    TLV_HDR_LEN,
+							    GFP_KERNEL);
+		} else {
+			/* RSN IE */
+			err = brcmf_configure_wpaie(ndev,
+				(struct brcmf_vs_tlv *)rsn_ie, true, bssidx);
+			if (err < 0)
+				goto exit;
+			cfg_priv->ap_info->rsn_ie = kmemdup(rsn_ie,
+							    rsn_ie->len +
+							    TLV_HDR_LEN,
+							    GFP_KERNEL);
+		}
+		cfg_priv->ap_info->security_mode = true;
+	} else {
+		WL_TRACE("No WPA(2) IEs found\n");
+		brcmf_configure_opensecurity(ndev, bssidx);
+		cfg_priv->ap_info->security_mode = false;
+	}
+	/* Set Beacon IEs to FW */
+	err = brcmf_set_management_ie(cfg_priv, ndev, bssidx,
+				      VNDR_IE_BEACON_FLAG,
+				      (u8 *)settings->beacon.tail,
+				      settings->beacon.tail_len);
+	if (err)
+		WL_ERR("Set Beacon IE Failed\n");
+	else
+		WL_TRACE("Applied Vndr IEs for Beacon\n");
+
+	/* Set Probe Response IEs to FW */
+	err = brcmf_set_management_ie(cfg_priv, ndev, bssidx,
+				      VNDR_IE_PRBRSP_FLAG,
+				      (u8 *)settings->beacon.proberesp_ies,
+				      settings->beacon.proberesp_ies_len);
+	if (err)
+		WL_ERR("Set Probe Resp IE Failed\n");
+	else
+		WL_TRACE("Applied Vndr IEs for Probe Resp\n");
+
+	if (settings->beacon_interval) {
+		ioctl_value = settings->beacon_interval;
+		err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_BCNPRD,
+					  &ioctl_value);
+		if (err < 0) {
+			WL_ERR("Beacon Interval Set Error, %d\n", err);
+			goto exit;
+		}
+	}
+	if (settings->dtim_period) {
+		ioctl_value = settings->dtim_period;
+		err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_DTIMPRD,
+					  &ioctl_value);
+		if (err < 0) {
+			WL_ERR("DTIM Interval Set Error, %d\n", err);
+			goto exit;
+		}
+	}
+	ioctl_value = 1;
+	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_UP, &ioctl_value);
+	if (err < 0) {
+		WL_ERR("BRCMF_C_UP error (%d)\n", err);
+		goto exit;
+	}
+
+	memset(&join_params, 0, sizeof(join_params));
+	/* join parameters starts with ssid */
+	memcpy(&join_params.ssid_le, &ssid_le, sizeof(ssid_le));
+	/* create softap */
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_SSID, &join_params,
+			      sizeof(join_params));
+	if (err < 0) {
+		WL_ERR("SET SSID error (%d)\n", err);
+		goto exit;
+	}
+	clear_bit(WL_STATUS_AP_CREATING, &cfg_priv->status);
+	set_bit(WL_STATUS_AP_CREATED, &cfg_priv->status);
+
+exit:
+	if (err)
+		brcmf_set_mpc(ndev, 1);
+	return err;
+}
+
+static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
+{
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	s32 ioctl_value;
+	s32 err = -EPERM;
+
+	WL_TRACE("Enter\n");
+
+	if (cfg_priv->conf->mode == WL_MODE_AP) {
+		/* Due to most likely deauths outstanding we sleep */
+		/* first to make sure they get processed by fw. */
+		msleep(400);
+		ioctl_value = 0;
+		err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_AP, &ioctl_value);
+		if (err < 0) {
+			WL_ERR("setting AP mode failed %d\n", err);
+			goto exit;
+		}
+		ioctl_value = 0;
+		err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_UP, &ioctl_value);
+		if (err < 0) {
+			WL_ERR("BRCMF_C_UP error %d\n", err);
+			goto exit;
+		}
+		brcmf_set_mpc(ndev, 1);
+		clear_bit(WL_STATUS_AP_CREATING, &cfg_priv->status);
+		clear_bit(WL_STATUS_AP_CREATED, &cfg_priv->status);
+	}
+exit:
+	return err;
+}
+
+static int
+brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
+			   u8 *mac)
+{
+	struct brcmf_scb_val_le scbval;
+	s32 err;
+
+	if (!mac)
+		return -EFAULT;
+
+	WL_TRACE("Enter %pM\n", mac);
+
+	if (!check_sys_up(wiphy))
+		return -EIO;
+
+	memcpy(&scbval.ea, mac, ETH_ALEN);
+	scbval.val = cpu_to_le32(WLAN_REASON_DEAUTH_LEAVING);
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_SCB_DEAUTHENTICATE_FOR_REASON,
+			      &scbval, sizeof(scbval));
+	if (err)
+		WL_ERR("SCB_DEAUTHENTICATE_FOR_REASON failed %d\n", err);
+
+	WL_TRACE("Exit\n");
+	return err;
+}
+
 static struct cfg80211_ops wl_cfg80211_ops = {
 	.change_virtual_intf = brcmf_cfg80211_change_iface,
 	.scan = brcmf_cfg80211_scan,
@@ -3611,6 +4418,9 @@ static struct cfg80211_ops wl_cfg80211_ops = {
 	.set_pmksa = brcmf_cfg80211_set_pmksa,
 	.del_pmksa = brcmf_cfg80211_del_pmksa,
 	.flush_pmksa = brcmf_cfg80211_flush_pmksa,
+	.start_ap = brcmf_cfg80211_start_ap,
+	.stop_ap = brcmf_cfg80211_stop_ap,
+	.del_station = brcmf_cfg80211_del_station,
 #ifndef CONFIG_BRCMISCAN
 	/* scheduled scan need e-scan, which is mutual exclusive with i-scan */
 	.sched_scan_start = brcmf_cfg80211_sched_scan_start,
@@ -3667,8 +4477,9 @@ static struct wireless_dev *brcmf_alloc_wdev(struct device *ndev)
 	set_wiphy_dev(wdev->wiphy, ndev);
 	wdev->wiphy->max_scan_ssids = WL_NUM_SCAN_MAX;
 	wdev->wiphy->max_num_pmkids = WL_NUM_PMKIDS_MAX;
-	wdev->wiphy->interface_modes =
-	    BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
+	wdev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				       BIT(NL80211_IFTYPE_ADHOC) |
+				       BIT(NL80211_IFTYPE_AP);
 	wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = &__wl_band_2ghz;
 	wdev->wiphy->bands[IEEE80211_BAND_5GHZ] = &__wl_band_5ghz_a;	/* Set
 						* it as 11a by default.
@@ -3917,13 +4728,54 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_priv *cfg_priv,
 }
 
 static s32
+brcmf_notify_connect_status_ap(struct brcmf_cfg80211_priv *cfg_priv,
+			       struct net_device *ndev,
+			       const struct brcmf_event_msg *e, void *data)
+{
+	s32 err = 0;
+	u32 event = be32_to_cpu(e->event_type);
+	u32 reason = be32_to_cpu(e->reason);
+	u32 len = be32_to_cpu(e->datalen);
+	static int generation;
+
+	struct station_info sinfo;
+
+	WL_CONN("event %d, reason %d\n", event, reason);
+	memset(&sinfo, 0, sizeof(sinfo));
+
+	sinfo.filled = 0;
+	if (((event == BRCMF_E_ASSOC_IND) || (event == BRCMF_E_REASSOC_IND)) &&
+	    reason == BRCMF_E_STATUS_SUCCESS) {
+		sinfo.filled = STATION_INFO_ASSOC_REQ_IES;
+		if (!data) {
+			WL_ERR("No IEs present in ASSOC/REASSOC_IND");
+			return -EINVAL;
+		}
+		sinfo.assoc_req_ies = data;
+		sinfo.assoc_req_ies_len = len;
+		generation++;
+		sinfo.generation = generation;
+		cfg80211_new_sta(ndev, e->addr, &sinfo, GFP_ATOMIC);
+	} else if ((event == BRCMF_E_DISASSOC_IND) ||
+		   (event == BRCMF_E_DEAUTH_IND) ||
+		   (event == BRCMF_E_DEAUTH)) {
+		generation++;
+		sinfo.generation = generation;
+		cfg80211_del_sta(ndev, e->addr, GFP_ATOMIC);
+	}
+	return err;
+}
+
+static s32
 brcmf_notify_connect_status(struct brcmf_cfg80211_priv *cfg_priv,
 			    struct net_device *ndev,
 			    const struct brcmf_event_msg *e, void *data)
 {
 	s32 err = 0;
 
-	if (brcmf_is_linkup(cfg_priv, e)) {
+	if (cfg_priv->conf->mode == WL_MODE_AP) {
+		err = brcmf_notify_connect_status_ap(cfg_priv, ndev, e, data);
+	} else if (brcmf_is_linkup(cfg_priv, e)) {
 		WL_CONN("Linkup\n");
 		if (brcmf_is_ibssmode(cfg_priv)) {
 			brcmf_update_prof(cfg_priv, NULL, (void *)e->addr,
@@ -4084,6 +4936,11 @@ static void brcmf_init_eloop_handler(struct brcmf_cfg80211_event_loop *el)
 	memset(el, 0, sizeof(*el));
 	el->handler[BRCMF_E_SCAN_COMPLETE] = brcmf_notify_scan_status;
 	el->handler[BRCMF_E_LINK] = brcmf_notify_connect_status;
+	el->handler[BRCMF_E_DEAUTH_IND] = brcmf_notify_connect_status;
+	el->handler[BRCMF_E_DEAUTH] = brcmf_notify_connect_status;
+	el->handler[BRCMF_E_DISASSOC_IND] = brcmf_notify_connect_status;
+	el->handler[BRCMF_E_ASSOC_IND] = brcmf_notify_connect_status;
+	el->handler[BRCMF_E_REASSOC_IND] = brcmf_notify_connect_status;
 	el->handler[BRCMF_E_ROAM] = brcmf_notify_roaming_status;
 	el->handler[BRCMF_E_MIC_ERROR] = brcmf_notify_mic_status;
 	el->handler[BRCMF_E_SET_SSID] = brcmf_notify_connect_status;
@@ -4112,6 +4969,12 @@ static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_priv *cfg_priv)
 	cfg_priv->iscan = NULL;
 	kfree(cfg_priv->pmk_list);
 	cfg_priv->pmk_list = NULL;
+	if (cfg_priv->ap_info) {
+		kfree(cfg_priv->ap_info->wpa_ie);
+		kfree(cfg_priv->ap_info->rsn_ie);
+		kfree(cfg_priv->ap_info);
+		cfg_priv->ap_info = NULL;
+	}
 }
 
 static s32 brcmf_init_priv_mem(struct brcmf_cfg80211_priv *cfg_priv)
@@ -4390,6 +5253,9 @@ static s32 brcmf_dongle_mode(struct net_device *ndev, s32 iftype)
 	case NL80211_IFTYPE_STATION:
 		infra = 1;
 		break;
+	case NL80211_IFTYPE_AP:
+		infra = 1;
+		break;
 	default:
 		err = -EINVAL;
 		WL_ERR("invalid type (%d)\n", iftype);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 97f36d3..3746800 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -125,6 +125,7 @@ do {								\
 #define WL_ESCAN_ACTION_ABORT		3
 
 #define WL_AUTH_SHARED_KEY		1	/* d11 shared authentication */
+#define IE_MAX_LEN			512
 
 /* dongle status */
 enum wl_status {
@@ -132,7 +133,9 @@ enum wl_status {
 	WL_STATUS_SCANNING,
 	WL_STATUS_SCAN_ABORTING,
 	WL_STATUS_CONNECTING,
-	WL_STATUS_CONNECTED
+	WL_STATUS_CONNECTED,
+	WL_STATUS_AP_CREATING,
+	WL_STATUS_AP_CREATED
 };
 
 /* wi-fi mode */
@@ -285,6 +288,17 @@ struct escan_info {
 	struct net_device *ndev;
 };
 
+/* Structure to hold WPS, WPA IEs for a AP */
+struct ap_info {
+	u8 probe_res_ie[IE_MAX_LEN];
+	u8 beacon_ie[IE_MAX_LEN];
+	u32 probe_res_ie_len;
+	u32 beacon_ie_len;
+	u8 *wpa_ie;
+	u8 *rsn_ie;
+	bool security_mode;
+};
+
 /**
  * struct brcmf_pno_param_le - PNO scan configuration parameters
  *
@@ -407,6 +421,7 @@ struct brcmf_pno_scanresults_le {
  * @escan_timeout: Timer for catch scan timeout.
  * @escan_timeout_work: scan timeout worker.
  * @escan_ioctl_buf: dongle command buffer for escan commands.
+ * @ap_info: host ap information.
  * @ci: used to link this structure to netdev private data.
  */
 struct brcmf_cfg80211_priv {
@@ -448,6 +463,7 @@ struct brcmf_cfg80211_priv {
 	struct timer_list escan_timeout;
 	struct work_struct escan_timeout_work;
 	u8 *escan_ioctl_buf;
+	struct ap_info *ap_info;
 };
 
 static inline struct wiphy *cfg_to_wiphy(struct brcmf_cfg80211_priv *w)
-- 
1.7.9.5


