Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2496 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083Ab2LEO0a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 09:26:30 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/11] brcmfmac: remove WL_TRACE() macro
Date: Wed, 5 Dec 2012 15:26:02 +0100
Message-ID: <1354717564-7183-10-git-send-email-arend@broadcom.com> (sfid-20121205_152637_780676_E9117E4C)
In-Reply-To: <1354717564-7183-1-git-send-email-arend@broadcom.com>
References: <1354717564-7183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Get rid of WL_TRACE(...) macro in favor of brcmf_dbg(TRACE,...)

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  190 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    1 -
 2 files changed, 95 insertions(+), 96 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 2013bf3..1a24c77 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -450,7 +450,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	s32 ap = 0;
 	s32 err = 0;
 
-	WL_TRACE("Enter, ndev=%p, type=%d\n", ndev, type);
+	brcmf_dbg(TRACE, "Enter, ndev=%p, type=%d\n", ndev, type);
 
 	switch (type) {
 	case NL80211_IFTYPE_MONITOR:
@@ -491,7 +491,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	ndev->ieee80211_ptr->iftype = type;
 
 done:
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 
 	return err;
 }
@@ -830,7 +830,7 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 	struct net_device *ndev = request->wdev->netdev;
 	s32 err = 0;
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (!check_vif_up(container_of(request->wdev,
 				       struct brcmf_cfg80211_vif, wdev)))
@@ -841,7 +841,7 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 	if (err)
 		brcmf_err("scan error (%d)\n", err);
 
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 }
 
@@ -889,7 +889,7 @@ static s32 brcmf_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err = 0;
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
@@ -923,7 +923,7 @@ static s32 brcmf_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	}
 
 done:
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 }
 
@@ -963,7 +963,7 @@ static void brcmf_link_down(struct brcmf_cfg80211_vif *vif)
 {
 	s32 err = 0;
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (test_bit(BRCMF_VIF_STATUS_CONNECTED, &vif->sme_state)) {
 		brcmf_dbg(INFO, "Call WLC_DISASSOC to stop excess roaming\n ");
@@ -974,7 +974,7 @@ static void brcmf_link_down(struct brcmf_cfg80211_vif *vif)
 		clear_bit(BRCMF_VIF_STATUS_CONNECTED, &vif->sme_state);
 	}
 	clear_bit(BRCMF_VIF_STATUS_CONNECTING, &vif->sme_state);
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 }
 
 static s32
@@ -990,7 +990,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	s32 wsec = 0;
 	s32 bcnprd;
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
@@ -1118,7 +1118,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 done:
 	if (err)
 		clear_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state);
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 }
 
@@ -1128,13 +1128,13 @@ brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *ndev)
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err = 0;
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
 	brcmf_link_down(ifp->vif);
 
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 
 	return err;
 }
@@ -1406,7 +1406,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 
 	s32 err = 0;
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
@@ -1482,7 +1482,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 done:
 	if (err)
 		clear_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state);
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 }
 
@@ -1495,7 +1495,7 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_scb_val_le scbval;
 	s32 err = 0;
 
-	WL_TRACE("Enter. Reason code = %d\n", reason_code);
+	brcmf_dbg(TRACE, "Enter. Reason code = %d\n", reason_code);
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
@@ -1508,7 +1508,7 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 	if (err)
 		brcmf_err("error (%d)\n", err);
 
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 }
 
@@ -1525,7 +1525,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 	s32 disable = 0;
 	s32 dbm = MBM_TO_DBM(mbm);
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
@@ -1558,7 +1558,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 	cfg->conf->tx_power = dbm;
 
 done:
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 }
 
@@ -1572,7 +1572,7 @@ static s32 brcmf_cfg80211_get_tx_power(struct wiphy *wiphy,
 	u8 result;
 	s32 err = 0;
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
@@ -1586,7 +1586,7 @@ static s32 brcmf_cfg80211_get_tx_power(struct wiphy *wiphy,
 	*dbm = (s32) brcmf_qdbm_to_mw(result);
 
 done:
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 }
 
@@ -1599,7 +1599,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 	u32 wsec;
 	s32 err = 0;
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 	WL_CONN("key index (%d)\n", key_idx);
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
@@ -1619,7 +1619,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 			brcmf_err("error (%d)\n", err);
 	}
 done:
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 }
 
@@ -1714,13 +1714,13 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	s32 err = 0;
 	u8 keybuf[8];
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 	WL_CONN("key index (%d)\n", key_idx);
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
 	if (mac_addr) {
-		WL_TRACE("Exit");
+		brcmf_dbg(TRACE, "Exit");
 		return brcmf_add_keyext(wiphy, ndev, key_idx, mac_addr, params);
 	}
 	memset(&key, 0, sizeof(key));
@@ -1791,7 +1791,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 done:
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 }
 
@@ -1803,7 +1803,7 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_wsec_key key;
 	s32 err = 0;
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
@@ -1824,7 +1824,7 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 	/* Set the new key/index */
 	err = send_key_to_dongle(ndev, &key);
 
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 }
 
@@ -1840,7 +1840,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 	s32 wsec;
 	s32 err = 0;
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 	WL_CONN("key index (%d)\n", key_idx);
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
@@ -1881,7 +1881,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 	callback(cookie, &params);
 
 done:
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 }
 
@@ -1907,7 +1907,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 	u8 *bssid = profile->bssid;
 	struct brcmf_sta_info_le sta_info_le;
 
-	WL_TRACE("Enter, MAC %pM\n", mac);
+	brcmf_dbg(TRACE, "Enter, MAC %pM\n", mac);
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
@@ -1926,8 +1926,8 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			sinfo->filled |= STATION_INFO_CONNECTED_TIME;
 			sinfo->connected_time = le32_to_cpu(sta_info_le.in);
 		}
-		WL_TRACE("STA idle time : %d ms, connected time :%d sec\n",
-			 sinfo->inactive_time, sinfo->connected_time);
+		brcmf_dbg(TRACE, "STA idle time : %d ms, connected time :%d sec\n",
+			  sinfo->inactive_time, sinfo->connected_time);
 	} else if (ifp->vif->mode == WL_MODE_BSS) {
 		if (memcmp(mac, bssid, ETH_ALEN)) {
 			brcmf_err("Wrong Mac address cfg_mac-%pM wl_bssid-%pM\n",
@@ -1964,7 +1964,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 	} else
 		err = -EPERM;
 done:
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 }
 
@@ -1977,7 +1977,7 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 
 	/*
 	 * Powersave enable/disable request is coming from the
@@ -2004,7 +2004,7 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 			brcmf_err("error (%d)\n", err);
 	}
 done:
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 }
 
@@ -2022,7 +2022,7 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *ndev,
 	u32 legacy;
 	s32 err = 0;
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
@@ -2065,7 +2065,7 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 done:
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 }
 
@@ -2178,7 +2178,7 @@ static s32 wl_inform_ibss(struct brcmf_cfg80211_info *cfg,
 	size_t notify_ielen;
 	s32 notify_signal;
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 
 	buf = kzalloc(WL_BSS_INFO_MAX, GFP_KERNEL);
 	if (buf == NULL) {
@@ -2234,7 +2234,7 @@ CleanUp:
 
 	kfree(buf);
 
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 
 	return err;
 }
@@ -2325,7 +2325,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg)
 	u8 *ie;
 	s32 err = 0;
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 	if (brcmf_is_ibssmode(ifp->vif))
 		return err;
 
@@ -2367,7 +2367,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg)
 	}
 
 update_bss_info_out:
-	WL_TRACE("Exit");
+	brcmf_dbg(TRACE, "Exit");
 	return err;
 }
 
@@ -2557,7 +2557,7 @@ static __always_inline void brcmf_delay(u32 ms)
 
 static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 {
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 
 	return 0;
 }
@@ -2569,7 +2569,7 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 	struct net_device *ndev = cfg_to_ndev(cfg);
 	struct brcmf_cfg80211_vif *vif;
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 
 	/*
 	 * if the primary net_device is not READY there is nothing
@@ -2603,7 +2603,7 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 	brcmf_set_mpc(ndev, 1);
 
 exit:
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 	/* clear any scanning activity */
 	cfg->scan_status = 0;
 	return 0;
@@ -2644,7 +2644,7 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 	int i;
 	int pmkid_len;
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
@@ -2669,7 +2669,7 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_update_pmklist(ndev, cfg->pmk_list, err);
 
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 }
 
@@ -2683,7 +2683,7 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 	s32 err = 0;
 	int i, pmkid_len;
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
@@ -2720,7 +2720,7 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_update_pmklist(ndev, cfg->pmk_list, err);
 
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 
 }
@@ -2732,14 +2732,14 @@ brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *ndev)
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err = 0;
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
 	memset(cfg->pmk_list, 0, sizeof(*cfg->pmk_list));
 	err = brcmf_update_pmklist(ndev, cfg->pmk_list, err);
 
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 
 }
@@ -3012,8 +3012,8 @@ static int brcmf_cfg80211_testmode(struct wiphy *wiphy, void *data, int len)
 	struct sk_buff *reply;
 	int ret;
 
-	WL_TRACE("cmd %x set %d buf %p len %d\n", dcmd->cmd, dcmd->set,
-		 dcmd->buf, dcmd->len);
+	brcmf_dbg(TRACE, "cmd %x set %d buf %p len %d\n", dcmd->cmd, dcmd->set,
+		  dcmd->buf, dcmd->len);
 
 	if (dcmd->set)
 		ret = brcmf_fil_cmd_data_set(netdev_priv(ndev), dcmd->cmd,
@@ -3084,7 +3084,7 @@ brcmf_configure_wpaie(struct net_device *ndev, struct brcmf_vs_tlv *wpa_ie,
 	u16 rsn_cap;
 	u32 wme_bss_disable;
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 	if (wpa_ie == NULL)
 		goto exit;
 
@@ -3183,16 +3183,16 @@ brcmf_configure_wpaie(struct net_device *ndev, struct brcmf_vs_tlv *wpa_ie,
 		offset += TLV_OUI_LEN;
 		switch (data[offset]) {
 		case RSN_AKM_NONE:
-			WL_TRACE("RSN_AKM_NONE\n");
+			brcmf_dbg(TRACE, "RSN_AKM_NONE\n");
 			wpa_auth |= WPA_AUTH_NONE;
 			break;
 		case RSN_AKM_UNSPECIFIED:
-			WL_TRACE("RSN_AKM_UNSPECIFIED\n");
+			brcmf_dbg(TRACE, "RSN_AKM_UNSPECIFIED\n");
 			is_rsn_ie ? (wpa_auth |= WPA2_AUTH_UNSPECIFIED) :
 				    (wpa_auth |= WPA_AUTH_UNSPECIFIED);
 			break;
 		case RSN_AKM_PSK:
-			WL_TRACE("RSN_AKM_PSK\n");
+			brcmf_dbg(TRACE, "RSN_AKM_PSK\n");
 			is_rsn_ie ? (wpa_auth |= WPA2_AUTH_PSK) :
 				    (wpa_auth |= WPA_AUTH_PSK);
 			break;
@@ -3271,7 +3271,7 @@ brcmf_parse_vndr_ies(const u8 *vndr_ie_buf, u32 vndr_ie_len,
 		if (!memcmp(vndrie->oui, (u8 *)WPA_OUI, TLV_OUI_LEN) &&
 		    ((vndrie->oui_type == WPA_OUI_TYPE) ||
 		    (vndrie->oui_type == WME_OUI_TYPE))) {
-			WL_TRACE("Found WPA/WME oui. Do not add it\n");
+			brcmf_dbg(TRACE, "Found WPA/WME oui. Do not add it\n");
 			goto next;
 		}
 
@@ -3284,11 +3284,11 @@ brcmf_parse_vndr_ies(const u8 *vndr_ie_buf, u32 vndr_ie_len,
 
 		vndr_ies->count++;
 
-		WL_TRACE("** OUI %02x %02x %02x, type 0x%02x\n",
-			 parsed_info->vndrie.oui[0],
-			 parsed_info->vndrie.oui[1],
-			 parsed_info->vndrie.oui[2],
-			 parsed_info->vndrie.oui_type);
+		brcmf_dbg(TRACE, "** OUI %02x %02x %02x, type 0x%02x\n",
+			  parsed_info->vndrie.oui[0],
+			  parsed_info->vndrie.oui[1],
+			  parsed_info->vndrie.oui[2],
+			  parsed_info->vndrie.oui_type);
 
 		if (vndr_ies->count >= MAX_VNDR_IE_NUMBER)
 			break;
@@ -3351,7 +3351,7 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 	ifp = vif->ifp;
 	saved_ie = &vif->saved_ie;
 
-	WL_TRACE("bssidx %d, pktflag : 0x%02X\n", ifp->bssidx, pktflag);
+	brcmf_dbg(TRACE, "bssidx %d, pktflag : 0x%02X\n", ifp->bssidx, pktflag);
 	iovar_ie_buf = kzalloc(WL_EXTRA_BUF_MAX, GFP_KERNEL);
 	if (!iovar_ie_buf)
 		return -ENOMEM;
@@ -3401,7 +3401,7 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 		if (parsed_ie_buf_len && (parsed_ie_buf_len == *mgmt_ie_len) &&
 		    (memcmp(mgmt_ie_buf, curr_ie_buf,
 			    parsed_ie_buf_len) == 0)) {
-			WL_TRACE("Previous mgmt IE equals to current IE\n");
+			brcmf_dbg(TRACE, "Previous mgmt IE equals to current IE\n");
 			goto exit;
 		}
 
@@ -3412,12 +3412,12 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 		for (i = 0; i < old_vndr_ies.count; i++) {
 			vndrie_info = &old_vndr_ies.ie_info[i];
 
-			WL_TRACE("DEL ID : %d, Len: %d , OUI:%02x:%02x:%02x\n",
-				 vndrie_info->vndrie.id,
-				 vndrie_info->vndrie.len,
-				 vndrie_info->vndrie.oui[0],
-				 vndrie_info->vndrie.oui[1],
-				 vndrie_info->vndrie.oui[2]);
+			brcmf_dbg(TRACE, "DEL ID : %d, Len: %d , OUI:%02x:%02x:%02x\n",
+				  vndrie_info->vndrie.id,
+				  vndrie_info->vndrie.len,
+				  vndrie_info->vndrie.oui[0],
+				  vndrie_info->vndrie.oui[1],
+				  vndrie_info->vndrie.oui[2]);
 
 			del_add_ie_buf_len = brcmf_vndr_ie(curr_ie_buf, pktflag,
 							   vndrie_info->ie_ptr,
@@ -3449,12 +3449,12 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 			remained_buf_len -= (vndrie_info->ie_len +
 					     VNDR_IE_VSIE_OFFSET);
 
-			WL_TRACE("ADDED ID : %d, Len: %d, OUI:%02x:%02x:%02x\n",
-				 vndrie_info->vndrie.id,
-				 vndrie_info->vndrie.len,
-				 vndrie_info->vndrie.oui[0],
-				 vndrie_info->vndrie.oui[1],
-				 vndrie_info->vndrie.oui[2]);
+			brcmf_dbg(TRACE, "ADDED ID : %d, Len: %d, OUI:%02x:%02x:%02x\n",
+				  vndrie_info->vndrie.id,
+				  vndrie_info->vndrie.len,
+				  vndrie_info->vndrie.oui[0],
+				  vndrie_info->vndrie.oui[1],
+				  vndrie_info->vndrie.oui[2]);
 
 			del_add_ie_buf_len = brcmf_vndr_ie(curr_ie_buf, pktflag,
 							   vndrie_info->ie_ptr,
@@ -3496,13 +3496,13 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_join_params join_params;
 	s32 bssidx = 0;
 
-	WL_TRACE("channel_type=%d, beacon_interval=%d, dtim_period=%d,\n",
-		 cfg80211_get_chandef_type(&settings->chandef),
-		 settings->beacon_interval,
-		 settings->dtim_period);
-	WL_TRACE("ssid=%s(%zu), auth_type=%d, inactivity_timeout=%d\n",
-		 settings->ssid, settings->ssid_len, settings->auth_type,
-		 settings->inactivity_timeout);
+	brcmf_dbg(TRACE, "channel_type=%d, beacon_interval=%d, dtim_period=%d,\n",
+		  cfg80211_get_chandef_type(&settings->chandef),
+		  settings->beacon_interval,
+		  settings->dtim_period);
+	brcmf_dbg(TRACE, "ssid=%s(%zu), auth_type=%d, inactivity_timeout=%d\n",
+		  settings->ssid, settings->ssid_len, settings->auth_type,
+		  settings->inactivity_timeout);
 
 	if (!test_bit(BRCMF_VIF_STATUS_AP_CREATING, &ifp->vif->sme_state)) {
 		brcmf_err("Not in AP creation mode\n");
@@ -3521,7 +3521,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 
 		memcpy(ssid_le.SSID, ssid_ie->data, ssid_ie->len);
 		ssid_le.SSID_len = cpu_to_le32(ssid_ie->len);
-		WL_TRACE("SSID is (%s) in Head\n", ssid_le.SSID);
+		brcmf_dbg(TRACE, "SSID is (%s) in Head\n", ssid_le.SSID);
 	} else {
 		memcpy(ssid_le.SSID, settings->ssid, settings->ssid_len);
 		ssid_le.SSID_len = cpu_to_le32((u32)settings->ssid_len);
@@ -3553,7 +3553,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 				  settings->beacon.tail_len);
 
 	if ((wpa_ie != NULL || rsn_ie != NULL)) {
-		WL_TRACE("WPA(2) IE is found\n");
+		brcmf_dbg(TRACE, "WPA(2) IE is found\n");
 		if (wpa_ie != NULL) {
 			/* WPA IE */
 			err = brcmf_configure_wpaie(ndev, wpa_ie, false);
@@ -3567,7 +3567,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 				goto exit;
 		}
 	} else {
-		WL_TRACE("No WPA(2) IEs found\n");
+		brcmf_dbg(TRACE, "No WPA(2) IEs found\n");
 		brcmf_configure_opensecurity(ndev, bssidx);
 	}
 	/* Set Beacon IEs to FW */
@@ -3578,7 +3578,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	if (err)
 		brcmf_err("Set Beacon IE Failed\n");
 	else
-		WL_TRACE("Applied Vndr IEs for Beacon\n");
+		brcmf_dbg(TRACE, "Applied Vndr IEs for Beacon\n");
 
 	/* Set Probe Response IEs to FW */
 	err = brcmf_vif_set_mgmt_ie(ndev_to_vif(ndev),
@@ -3588,7 +3588,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	if (err)
 		brcmf_err("Set Probe Resp IE Failed\n");
 	else
-		WL_TRACE("Applied Vndr IEs for Probe Resp\n");
+		brcmf_dbg(TRACE, "Applied Vndr IEs for Probe Resp\n");
 
 	if (settings->beacon_interval) {
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_BCNPRD,
@@ -3636,7 +3636,7 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err = -EPERM;
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (ifp->vif->mode == WL_MODE_AP) {
 		/* Due to most likely deauths outstanding we sleep */
@@ -3671,7 +3671,7 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 	if (!mac)
 		return -EFAULT;
 
-	WL_TRACE("Enter %pM\n", mac);
+	brcmf_dbg(TRACE, "Enter %pM\n", mac);
 
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
@@ -3683,7 +3683,7 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 	if (err)
 		brcmf_err("SCB_DEAUTHENTICATE_FOR_REASON failed %d\n", err);
 
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 }
 
@@ -3971,7 +3971,7 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 	u32 target_channel;
 	u8 *buf;
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 
 	brcmf_get_assoc_ies(cfg);
 	memcpy(profile->bssid, e->addr, ETH_ALEN);
@@ -4011,7 +4011,7 @@ done:
 	WL_CONN("Report roaming result\n");
 
 	set_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state);
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 }
 
@@ -4025,7 +4025,7 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
 	s32 err = 0;
 
-	WL_TRACE("Enter\n");
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (test_and_clear_bit(BRCMF_VIF_STATUS_CONNECTING,
 			       &ifp->vif->sme_state)) {
@@ -4049,7 +4049,7 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 		WL_CONN("Report connect result - connection %s\n",
 				completed ? "succeeded" : "failed");
 	}
-	WL_TRACE("Exit\n");
+	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 2ae2a3d..577152f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -19,7 +19,6 @@
 
 #include "dhd_dbg.h"
 
-#define	WL_TRACE(fmt, ...)	brcmf_dbg(TRACE, fmt, ##__VA_ARGS__)
 #define	WL_SCAN(fmt, ...)	brcmf_dbg(SCAN, fmt, ##__VA_ARGS__)
 #define	WL_CONN(fmt, ...)	brcmf_dbg(CONN, fmt, ##__VA_ARGS__)
 
-- 
1.7.9.5


