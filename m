Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2493 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082Ab2LEO0a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 09:26:30 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/11] brcmfmac: remove WL_CONN() macro
Date: Wed, 5 Dec 2012 15:26:04 +0100
Message-ID: <1354717564-7183-12-git-send-email-arend@broadcom.com> (sfid-20121205_152645_134233_BB603E77)
In-Reply-To: <1354717564-7183-1-git-send-email-arend@broadcom.com>
References: <1354717564-7183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Get rid of WL_CONN(...) macro in favor of brcmf_dbg(CONN,...)

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  188 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    4 -
 2 files changed, 94 insertions(+), 98 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index f196613..1261a9b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -27,6 +27,7 @@
 #include <defs.h>
 #include <brcmu_wifi.h>
 #include "dhd.h"
+#include "dhd_dbg.h"
 #include "wl_cfg80211.h"
 #include "fwil.h"
 
@@ -955,9 +956,7 @@ static void brcmf_ch_to_chanspec(int ch, struct brcmf_join_params *join_params,
 		join_params->params_le.chanspec_list[0] = cpu_to_le16(chanspec);
 		join_params->params_le.chanspec_num = cpu_to_le32(1);
 
-		WL_CONN("join_params->params.chanspec_list[0]= %#X,"
-			"channel %d, chanspec %#X\n",
-			chanspec, ch, chanspec);
+		brcmf_dbg(CONN, "channel %d, chanspec %#X\n", ch, chanspec);
 	}
 }
 
@@ -997,48 +996,50 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 		return -EIO;
 
 	if (params->ssid)
-		WL_CONN("SSID: %s\n", params->ssid);
+		brcmf_dbg(CONN, "SSID: %s\n", params->ssid);
 	else {
-		WL_CONN("SSID: NULL, Not supported\n");
+		brcmf_dbg(CONN, "SSID: NULL, Not supported\n");
 		return -EOPNOTSUPP;
 	}
 
 	set_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state);
 
 	if (params->bssid)
-		WL_CONN("BSSID: %pM\n", params->bssid);
+		brcmf_dbg(CONN, "BSSID: %pM\n", params->bssid);
 	else
-		WL_CONN("No BSSID specified\n");
+		brcmf_dbg(CONN, "No BSSID specified\n");
 
 	if (params->chandef.chan)
-		WL_CONN("channel: %d\n", params->chandef.chan->center_freq);
+		brcmf_dbg(CONN, "channel: %d\n",
+			  params->chandef.chan->center_freq);
 	else
-		WL_CONN("no channel specified\n");
+		brcmf_dbg(CONN, "no channel specified\n");
 
 	if (params->channel_fixed)
-		WL_CONN("fixed channel required\n");
+		brcmf_dbg(CONN, "fixed channel required\n");
 	else
-		WL_CONN("no fixed channel required\n");
+		brcmf_dbg(CONN, "no fixed channel required\n");
 
 	if (params->ie && params->ie_len)
-		WL_CONN("ie len: %d\n", params->ie_len);
+		brcmf_dbg(CONN, "ie len: %d\n", params->ie_len);
 	else
-		WL_CONN("no ie specified\n");
+		brcmf_dbg(CONN, "no ie specified\n");
 
 	if (params->beacon_interval)
-		WL_CONN("beacon interval: %d\n", params->beacon_interval);
+		brcmf_dbg(CONN, "beacon interval: %d\n",
+			  params->beacon_interval);
 	else
-		WL_CONN("no beacon interval specified\n");
+		brcmf_dbg(CONN, "no beacon interval specified\n");
 
 	if (params->basic_rates)
-		WL_CONN("basic rates: %08X\n", params->basic_rates);
+		brcmf_dbg(CONN, "basic rates: %08X\n", params->basic_rates);
 	else
-		WL_CONN("no basic rates specified\n");
+		brcmf_dbg(CONN, "no basic rates specified\n");
 
 	if (params->privacy)
-		WL_CONN("privacy required\n");
+		brcmf_dbg(CONN, "privacy required\n");
 	else
-		WL_CONN("no privacy required\n");
+		brcmf_dbg(CONN, "no privacy required\n");
 
 	/* Configure Privacy for starter */
 	if (params->privacy)
@@ -1155,7 +1156,7 @@ static s32 brcmf_set_wpa_version(struct net_device *ndev,
 		val = WPA2_AUTH_PSK | WPA2_AUTH_UNSPECIFIED;
 	else
 		val = WPA_AUTH_DISABLED;
-	WL_CONN("setting wpa_auth to 0x%0x\n", val);
+	brcmf_dbg(CONN, "setting wpa_auth to 0x%0x\n", val);
 	err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "wpa_auth", val);
 	if (err) {
 		brcmf_err("set wpa_auth failed (%d)\n", err);
@@ -1177,18 +1178,18 @@ static s32 brcmf_set_auth_type(struct net_device *ndev,
 	switch (sme->auth_type) {
 	case NL80211_AUTHTYPE_OPEN_SYSTEM:
 		val = 0;
-		WL_CONN("open system\n");
+		brcmf_dbg(CONN, "open system\n");
 		break;
 	case NL80211_AUTHTYPE_SHARED_KEY:
 		val = 1;
-		WL_CONN("shared key\n");
+		brcmf_dbg(CONN, "shared key\n");
 		break;
 	case NL80211_AUTHTYPE_AUTOMATIC:
 		val = 2;
-		WL_CONN("automatic\n");
+		brcmf_dbg(CONN, "automatic\n");
 		break;
 	case NL80211_AUTHTYPE_NETWORK_EAP:
-		WL_CONN("network eap\n");
+		brcmf_dbg(CONN, "network eap\n");
 	default:
 		val = 2;
 		brcmf_err("invalid auth type (%d)\n", sme->auth_type);
@@ -1258,7 +1259,7 @@ brcmf_set_set_cipher(struct net_device *ndev,
 		}
 	}
 
-	WL_CONN("pval (%d) gval (%d)\n", pval, gval);
+	brcmf_dbg(CONN, "pval (%d) gval (%d)\n", pval, gval);
 	err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "wsec", pval | gval);
 	if (err) {
 		brcmf_err("error (%d)\n", err);
@@ -1315,7 +1316,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 			}
 		}
 
-		WL_CONN("setting wpa_auth to %d\n", val);
+		brcmf_dbg(CONN, "setting wpa_auth to %d\n", val);
 		err = brcmf_fil_iovar_int_set(netdev_priv(ndev),
 					      "wpa_auth", val);
 		if (err) {
@@ -1339,14 +1340,14 @@ brcmf_set_sharedkey(struct net_device *ndev,
 	s32 val;
 	s32 err = 0;
 
-	WL_CONN("key len (%d)\n", sme->key_len);
+	brcmf_dbg(CONN, "key len (%d)\n", sme->key_len);
 
 	if (sme->key_len == 0)
 		return 0;
 
 	sec = &profile->sec;
-	WL_CONN("wpa_versions 0x%x cipher_pairwise 0x%x\n",
-		sec->wpa_versions, sec->cipher_pairwise);
+	brcmf_dbg(CONN, "wpa_versions 0x%x cipher_pairwise 0x%x\n",
+		  sec->wpa_versions, sec->cipher_pairwise);
 
 	if (sec->wpa_versions & (NL80211_WPA_VERSION_1 | NL80211_WPA_VERSION_2))
 		return 0;
@@ -1377,15 +1378,15 @@ brcmf_set_sharedkey(struct net_device *ndev,
 		return -EINVAL;
 	}
 	/* Set the new key/index */
-	WL_CONN("key length (%d) key index (%d) algo (%d)\n",
-		key.len, key.index, key.algo);
-	WL_CONN("key \"%s\"\n", key.data);
+	brcmf_dbg(CONN, "key length (%d) key index (%d) algo (%d)\n",
+		  key.len, key.index, key.algo);
+	brcmf_dbg(CONN, "key \"%s\"\n", key.data);
 	err = send_key_to_dongle(ndev, &key);
 	if (err)
 		return err;
 
 	if (sec->auth_type == NL80211_AUTHTYPE_SHARED_KEY) {
-		WL_CONN("set auth_type to shared key\n");
+		brcmf_dbg(CONN, "set auth_type to shared key\n");
 		val = WL_AUTH_SHARED_KEY;	/* shared key */
 		err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev), "auth", val);
 		if (err)
@@ -1422,8 +1423,8 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	if (chan) {
 		cfg->channel =
 			ieee80211_frequency_to_channel(chan->center_freq);
-		WL_CONN("channel (%d), center_req (%d)\n",
-				cfg->channel, chan->center_freq);
+		brcmf_dbg(CONN, "channel (%d), center_req (%d)\n",
+			  cfg->channel, chan->center_freq);
 	} else
 		cfg->channel = 0;
 
@@ -1471,8 +1472,8 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	memset(join_params.params_le.bssid, 0xFF, ETH_ALEN);
 
 	if (ssid.SSID_len < IEEE80211_MAX_SSID_LEN)
-		WL_CONN("ssid \"%s\", len (%d)\n",
-		       ssid.SSID, ssid.SSID_len);
+		brcmf_dbg(CONN, "ssid \"%s\", len (%d)\n",
+			  ssid.SSID, ssid.SSID_len);
 
 	brcmf_ch_to_chanspec(cfg->channel,
 			     &join_params, &join_params_size);
@@ -1602,7 +1603,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 	s32 err = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
-	WL_CONN("key index (%d)\n", key_idx);
+	brcmf_dbg(CONN, "key index (%d)\n", key_idx);
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
@@ -1651,7 +1652,7 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *ndev,
 			return -EINVAL;
 		}
 
-		WL_CONN("Setting the key index %d\n", key.index);
+		brcmf_dbg(CONN, "Setting the key index %d\n", key.index);
 		memcpy(key.data, params->key, key.len);
 
 		if (params->cipher == WLAN_CIPHER_SUITE_TKIP) {
@@ -1675,23 +1676,23 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *ndev,
 		switch (params->cipher) {
 		case WLAN_CIPHER_SUITE_WEP40:
 			key.algo = CRYPTO_ALGO_WEP1;
-			WL_CONN("WLAN_CIPHER_SUITE_WEP40\n");
+			brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_WEP40\n");
 			break;
 		case WLAN_CIPHER_SUITE_WEP104:
 			key.algo = CRYPTO_ALGO_WEP128;
-			WL_CONN("WLAN_CIPHER_SUITE_WEP104\n");
+			brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_WEP104\n");
 			break;
 		case WLAN_CIPHER_SUITE_TKIP:
 			key.algo = CRYPTO_ALGO_TKIP;
-			WL_CONN("WLAN_CIPHER_SUITE_TKIP\n");
+			brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_TKIP\n");
 			break;
 		case WLAN_CIPHER_SUITE_AES_CMAC:
 			key.algo = CRYPTO_ALGO_AES_CCM;
-			WL_CONN("WLAN_CIPHER_SUITE_AES_CMAC\n");
+			brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_AES_CMAC\n");
 			break;
 		case WLAN_CIPHER_SUITE_CCMP:
 			key.algo = CRYPTO_ALGO_AES_CCM;
-			WL_CONN("WLAN_CIPHER_SUITE_CCMP\n");
+			brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_CCMP\n");
 			break;
 		default:
 			brcmf_err("Invalid cipher (0x%x)\n", params->cipher);
@@ -1717,7 +1718,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	u8 keybuf[8];
 
 	brcmf_dbg(TRACE, "Enter\n");
-	WL_CONN("key index (%d)\n", key_idx);
+	brcmf_dbg(CONN, "key index (%d)\n", key_idx);
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
@@ -1742,33 +1743,33 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	case WLAN_CIPHER_SUITE_WEP40:
 		key.algo = CRYPTO_ALGO_WEP1;
 		val = WEP_ENABLED;
-		WL_CONN("WLAN_CIPHER_SUITE_WEP40\n");
+		brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_WEP40\n");
 		break;
 	case WLAN_CIPHER_SUITE_WEP104:
 		key.algo = CRYPTO_ALGO_WEP128;
 		val = WEP_ENABLED;
-		WL_CONN("WLAN_CIPHER_SUITE_WEP104\n");
+		brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_WEP104\n");
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
 		if (ifp->vif->mode != WL_MODE_AP) {
-			WL_CONN("Swapping key\n");
+			brcmf_dbg(CONN, "Swapping key\n");
 			memcpy(keybuf, &key.data[24], sizeof(keybuf));
 			memcpy(&key.data[24], &key.data[16], sizeof(keybuf));
 			memcpy(&key.data[16], keybuf, sizeof(keybuf));
 		}
 		key.algo = CRYPTO_ALGO_TKIP;
 		val = TKIP_ENABLED;
-		WL_CONN("WLAN_CIPHER_SUITE_TKIP\n");
+		brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_TKIP\n");
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 		key.algo = CRYPTO_ALGO_AES_CCM;
 		val = AES_ENABLED;
-		WL_CONN("WLAN_CIPHER_SUITE_AES_CMAC\n");
+		brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_AES_CMAC\n");
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 		key.algo = CRYPTO_ALGO_AES_CCM;
 		val = AES_ENABLED;
-		WL_CONN("WLAN_CIPHER_SUITE_CCMP\n");
+		brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_CCMP\n");
 		break;
 	default:
 		brcmf_err("Invalid cipher (0x%x)\n", params->cipher);
@@ -1821,7 +1822,7 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 	key.flags = BRCMF_PRIMARY_KEY;
 	key.algo = CRYPTO_ALGO_OFF;
 
-	WL_CONN("key index (%d)\n", key_idx);
+	brcmf_dbg(CONN, "key index (%d)\n", key_idx);
 
 	/* Set the new key/index */
 	err = send_key_to_dongle(ndev, &key);
@@ -1843,7 +1844,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 	s32 err = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
-	WL_CONN("key index (%d)\n", key_idx);
+	brcmf_dbg(CONN, "key index (%d)\n", key_idx);
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
@@ -1861,19 +1862,19 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 		sec = &profile->sec;
 		if (sec->cipher_pairwise & WLAN_CIPHER_SUITE_WEP40) {
 			params.cipher = WLAN_CIPHER_SUITE_WEP40;
-			WL_CONN("WLAN_CIPHER_SUITE_WEP40\n");
+			brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_WEP40\n");
 		} else if (sec->cipher_pairwise & WLAN_CIPHER_SUITE_WEP104) {
 			params.cipher = WLAN_CIPHER_SUITE_WEP104;
-			WL_CONN("WLAN_CIPHER_SUITE_WEP104\n");
+			brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_WEP104\n");
 		}
 		break;
 	case TKIP_ENABLED:
 		params.cipher = WLAN_CIPHER_SUITE_TKIP;
-		WL_CONN("WLAN_CIPHER_SUITE_TKIP\n");
+		brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_TKIP\n");
 		break;
 	case AES_ENABLED:
 		params.cipher = WLAN_CIPHER_SUITE_AES_CMAC;
-		WL_CONN("WLAN_CIPHER_SUITE_AES_CMAC\n");
+		brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_AES_CMAC\n");
 		break;
 	default:
 		brcmf_err("Invalid algo (0x%x)\n", wsec);
@@ -1945,7 +1946,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 		} else {
 			sinfo->filled |= STATION_INFO_TX_BITRATE;
 			sinfo->txrate.legacy = rate * 5;
-			WL_CONN("Rate %d Mbps\n", rate / 2);
+			brcmf_dbg(CONN, "Rate %d Mbps\n", rate / 2);
 		}
 
 		if (test_bit(BRCMF_VIF_STATUS_CONNECTED,
@@ -1960,7 +1961,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 				rssi = le32_to_cpu(scb_val.val);
 				sinfo->filled |= STATION_INFO_SIGNAL;
 				sinfo->signal = rssi;
-				WL_CONN("RSSI %d dBm\n", rssi);
+				brcmf_dbg(CONN, "RSSI %d dBm\n", rssi);
 			}
 		}
 	} else
@@ -2051,7 +2052,7 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *ndev,
 		/* Specified rate in bps */
 		rate = val / 500000;
 
-	WL_CONN("rate %d mbps\n", rate / 2);
+	brcmf_dbg(CONN, "rate %d mbps\n", rate / 2);
 
 	/*
 	 *
@@ -2109,13 +2110,11 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 	notify_ielen = le32_to_cpu(bi->ie_length);
 	notify_signal = (s16)le16_to_cpu(bi->RSSI) * 100;
 
-	WL_CONN("bssid: %2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X\n",
-			bi->BSSID[0], bi->BSSID[1], bi->BSSID[2],
-			bi->BSSID[3], bi->BSSID[4], bi->BSSID[5]);
-	WL_CONN("Channel: %d(%d)\n", channel, freq);
-	WL_CONN("Capability: %X\n", notify_capability);
-	WL_CONN("Beacon interval: %d\n", notify_interval);
-	WL_CONN("Signal: %d\n", notify_signal);
+	brcmf_dbg(CONN, "bssid: %pM\n", bi->BSSID);
+	brcmf_dbg(CONN, "Channel: %d(%d)\n", channel, freq);
+	brcmf_dbg(CONN, "Capability: %X\n", notify_capability);
+	brcmf_dbg(CONN, "Beacon interval: %d\n", notify_interval);
+	brcmf_dbg(CONN, "Signal: %d\n", notify_signal);
 
 	bss = cfg80211_inform_bss(wiphy, notify_channel, (const u8 *)bi->BSSID,
 		0, notify_capability, notify_interval, notify_ie,
@@ -2216,10 +2215,10 @@ static s32 wl_inform_ibss(struct brcmf_cfg80211_info *cfg,
 	notify_ielen = le32_to_cpu(bi->ie_length);
 	notify_signal = (s16)le16_to_cpu(bi->RSSI) * 100;
 
-	WL_CONN("channel: %d(%d)\n", channel, freq);
-	WL_CONN("capability: %X\n", notify_capability);
-	WL_CONN("beacon interval: %d\n", notify_interval);
-	WL_CONN("signal: %d\n", notify_signal);
+	brcmf_dbg(CONN, "channel: %d(%d)\n", channel, freq);
+	brcmf_dbg(CONN, "capability: %X\n", notify_capability);
+	brcmf_dbg(CONN, "beacon interval: %d\n", notify_interval);
+	brcmf_dbg(CONN, "signal: %d\n", notify_signal);
 
 	bss = cfg80211_inform_bss(wiphy, notify_channel, bssid,
 		0, notify_capability, notify_interval,
@@ -2620,12 +2619,13 @@ brcmf_update_pmklist(struct net_device *ndev,
 
 	pmkid_len = le32_to_cpu(pmk_list->pmkids.npmkid);
 
-	WL_CONN("No of elements %d\n", pmkid_len);
+	brcmf_dbg(CONN, "No of elements %d\n", pmkid_len);
 	for (i = 0; i < pmkid_len; i++) {
-		WL_CONN("PMKID[%d]: %pM =\n", i,
-			&pmk_list->pmkids.pmkid[i].BSSID);
+		brcmf_dbg(CONN, "PMKID[%d]: %pM =\n", i,
+			  &pmk_list->pmkids.pmkid[i].BSSID);
 		for (j = 0; j < WLAN_PMKID_LEN; j++)
-			WL_CONN("%02x\n", pmk_list->pmkids.pmkid[i].PMKID[j]);
+			brcmf_dbg(CONN, "%02x\n",
+				  pmk_list->pmkids.pmkid[i].PMKID[j]);
 	}
 
 	if (!err)
@@ -2664,10 +2664,10 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 	} else
 		err = -EINVAL;
 
-	WL_CONN("set_pmksa,IW_PMKSA_ADD - PMKID: %pM =\n",
-		pmkids->pmkid[pmkid_len].BSSID);
+	brcmf_dbg(CONN, "set_pmksa,IW_PMKSA_ADD - PMKID: %pM =\n",
+		  pmkids->pmkid[pmkid_len].BSSID);
 	for (i = 0; i < WLAN_PMKID_LEN; i++)
-		WL_CONN("%02x\n", pmkids->pmkid[pmkid_len].PMKID[i]);
+		brcmf_dbg(CONN, "%02x\n", pmkids->pmkid[pmkid_len].PMKID[i]);
 
 	err = brcmf_update_pmklist(ndev, cfg->pmk_list, err);
 
@@ -2692,10 +2692,10 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 	memcpy(&pmkid.pmkid[0].BSSID, pmksa->bssid, ETH_ALEN);
 	memcpy(&pmkid.pmkid[0].PMKID, pmksa->pmkid, WLAN_PMKID_LEN);
 
-	WL_CONN("del_pmksa,IW_PMKSA_REMOVE - PMKID: %pM =\n",
-	       &pmkid.pmkid[0].BSSID);
+	brcmf_dbg(CONN, "del_pmksa,IW_PMKSA_REMOVE - PMKID: %pM =\n",
+		  &pmkid.pmkid[0].BSSID);
 	for (i = 0; i < WLAN_PMKID_LEN; i++)
-		WL_CONN("%02x\n", pmkid.pmkid[0].PMKID[i]);
+		brcmf_dbg(CONN, "%02x\n", pmkid.pmkid[0].PMKID[i]);
 
 	pmkid_len = le32_to_cpu(cfg->pmk_list->pmkids.npmkid);
 	for (i = 0; i < pmkid_len; i++)
@@ -3845,7 +3845,7 @@ static bool brcmf_is_linkup(const struct brcmf_event_msg *e)
 	u32 status = e->status;
 
 	if (event == BRCMF_E_SET_SSID && status == BRCMF_E_STATUS_SUCCESS) {
-		WL_CONN("Processing set ssid\n");
+		brcmf_dbg(CONN, "Processing set ssid\n");
 		return true;
 	}
 
@@ -3858,7 +3858,7 @@ static bool brcmf_is_linkdown(const struct brcmf_event_msg *e)
 	u16 flags = e->flags;
 
 	if (event == BRCMF_E_LINK && (!(flags & BRCMF_EVENT_MSG_LINK))) {
-		WL_CONN("Processing link down\n");
+		brcmf_dbg(CONN, "Processing link down\n");
 		return true;
 	}
 	return false;
@@ -3871,13 +3871,13 @@ static bool brcmf_is_nonetwork(struct brcmf_cfg80211_info *cfg,
 	u32 status = e->status;
 
 	if (event == BRCMF_E_LINK && status == BRCMF_E_STATUS_NO_NETWORKS) {
-		WL_CONN("Processing Link %s & no network found\n",
-			e->flags & BRCMF_EVENT_MSG_LINK ? "up" : "down");
+		brcmf_dbg(CONN, "Processing Link %s & no network found\n",
+			  e->flags & BRCMF_EVENT_MSG_LINK ? "up" : "down");
 		return true;
 	}
 
 	if (event == BRCMF_E_SET_SSID && status != BRCMF_E_STATUS_SUCCESS) {
-		WL_CONN("Processing connecting & no network found\n");
+		brcmf_dbg(CONN, "Processing connecting & no network found\n");
 		return true;
 	}
 
@@ -3949,8 +3949,8 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg)
 		conn_info->resp_ie_len = 0;
 		conn_info->resp_ie = NULL;
 	}
-	WL_CONN("req len (%d) resp len (%d)\n",
-	       conn_info->req_ie_len, conn_info->resp_ie_len);
+	brcmf_dbg(CONN, "req len (%d) resp len (%d)\n",
+		  conn_info->req_ie_len, conn_info->resp_ie_len);
 
 	return err;
 }
@@ -4009,7 +4009,7 @@ done:
 	cfg80211_roamed(ndev, notify_channel, (u8 *)profile->bssid,
 			conn_info->req_ie, conn_info->req_ie_len,
 			conn_info->resp_ie, conn_info->resp_ie_len, GFP_KERNEL);
-	WL_CONN("Report roaming result\n");
+	brcmf_dbg(CONN, "Report roaming result\n");
 
 	set_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state);
 	brcmf_dbg(TRACE, "Exit\n");
@@ -4047,8 +4047,8 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 		if (completed)
 			set_bit(BRCMF_VIF_STATUS_CONNECTED,
 				&ifp->vif->sme_state);
-		WL_CONN("Report connect result - connection %s\n",
-				completed ? "succeeded" : "failed");
+		brcmf_dbg(CONN, "Report connect result - connection %s\n",
+			  completed ? "succeeded" : "failed");
 	}
 	brcmf_dbg(TRACE, "Exit\n");
 	return err;
@@ -4067,7 +4067,7 @@ brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
 
 	struct station_info sinfo;
 
-	WL_CONN("event %d, reason %d\n", event, reason);
+	brcmf_dbg(CONN, "event %d, reason %d\n", event, reason);
 	memset(&sinfo, 0, sizeof(sinfo));
 
 	sinfo.filled = 0;
@@ -4105,7 +4105,7 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 	if (ifp->vif->mode == WL_MODE_AP) {
 		err = brcmf_notify_connect_status_ap(cfg, ndev, e, data);
 	} else if (brcmf_is_linkup(e)) {
-		WL_CONN("Linkup\n");
+		brcmf_dbg(CONN, "Linkup\n");
 		if (brcmf_is_ibssmode(ifp->vif)) {
 			memcpy(profile->bssid, e->addr, ETH_ALEN);
 			wl_inform_ibss(cfg, ndev, e->addr);
@@ -4117,7 +4117,7 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 		} else
 			brcmf_bss_connect_done(cfg, ndev, e, true);
 	} else if (brcmf_is_linkdown(e)) {
-		WL_CONN("Linkdown\n");
+		brcmf_dbg(CONN, "Linkdown\n");
 		if (!brcmf_is_ibssmode(ifp->vif)) {
 			brcmf_bss_connect_done(cfg, ndev, e, false);
 			if (test_and_clear_bit(BRCMF_VIF_STATUS_CONNECTED,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index e636813..e4d9cc7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -17,10 +17,6 @@
 #ifndef _wl_cfg80211_h_
 #define _wl_cfg80211_h_
 
-#include "dhd_dbg.h"
-
-#define	WL_CONN(fmt, ...)	brcmf_dbg(CONN, fmt, ##__VA_ARGS__)
-
 #define WL_NUM_SCAN_MAX			10
 #define WL_NUM_PMKIDS_MAX		MAXPMKID
 #define WL_TLV_INFO_MAX			1024
-- 
1.7.9.5


