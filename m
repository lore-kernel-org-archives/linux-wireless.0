Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2502 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087Ab2LEO0a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 09:26:30 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/11] brcmfmac: replace WL_ERR() with brcmf_err()
Date: Wed, 5 Dec 2012 15:26:00 +0100
Message-ID: <1354717564-7183-8-git-send-email-arend@broadcom.com> (sfid-20121205_152642_701984_5C6CBC53)
In-Reply-To: <1354717564-7183-1-git-send-email-arend@broadcom.com>
References: <1354717564-7183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Getting rid of wl_cfg80211 specific error log macro.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  314 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    2 -
 2 files changed, 158 insertions(+), 158 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index b321813..9840ffb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -435,7 +435,7 @@ send_key_to_dongle(struct net_device *ndev, struct brcmf_wsec_key *key)
 					sizeof(key_le));
 
 	if (err)
-		WL_ERR("wsec_key error (%d)\n", err);
+		brcmf_err("wsec_key error (%d)\n", err);
 	return err;
 }
 
@@ -455,8 +455,8 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	switch (type) {
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_WDS:
-		WL_ERR("type (%d) : currently we do not support this type\n",
-		       type);
+		brcmf_err("type (%d) : currently we do not support this type\n",
+			  type);
 		return -EOPNOTSUPP;
 	case NL80211_IFTYPE_ADHOC:
 		vif->mode = WL_MODE_IBSS;
@@ -481,7 +481,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	} else {
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, infra);
 		if (err) {
-			WL_ERR("WLC_SET_INFRA error (%d)\n", err);
+			brcmf_err("WLC_SET_INFRA error (%d)\n", err);
 			err = -EAGAIN;
 			goto done;
 		}
@@ -504,7 +504,7 @@ static void brcmf_set_mpc(struct net_device *ndev, int mpc)
 	if (check_vif_up(ifp->vif)) {
 		err = brcmf_fil_iovar_int_set(ifp, "mpc", mpc);
 		if (err) {
-			WL_ERR("fail to set mpc\n");
+			brcmf_err("fail to set mpc\n");
 			return;
 		}
 		WL_INFO("MPC : %d\n", mpc);
@@ -625,7 +625,7 @@ brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 		err = brcmf_fil_cmd_data_set(netdev_priv(ndev), BRCMF_C_SCAN,
 					     &params_le, sizeof(params_le));
 		if (err)
-			WL_ERR("Scan abort  failed\n");
+			brcmf_err("Scan abort  failed\n");
 	}
 	/*
 	 * e-scan can be initiated by scheduled scan
@@ -644,7 +644,7 @@ brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 		brcmf_set_mpc(ndev, 1);
 	}
 	if (!test_and_clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
-		WL_ERR("Scan complete while device not scanning\n");
+		brcmf_err("Scan complete while device not scanning\n");
 		return -EPERM;
 	}
 
@@ -687,7 +687,7 @@ brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct net_device *ndev,
 		if (err == -EBUSY)
 			WL_INFO("system busy : escan canceled\n");
 		else
-			WL_ERR("error (%d)\n", err);
+			brcmf_err("error (%d)\n", err);
 	}
 
 	kfree(params);
@@ -711,7 +711,7 @@ brcmf_do_escan(struct brcmf_cfg80211_info *cfg, struct wiphy *wiphy,
 	err = brcmf_fil_cmd_int_set(netdev_priv(ndev), BRCMF_C_SET_PASSIVE_SCAN,
 				    passive_scan);
 	if (err) {
-		WL_ERR("error (%d)\n", err);
+		brcmf_err("error (%d)\n", err);
 		return err;
 	}
 	brcmf_set_mpc(ndev, 0);
@@ -744,16 +744,16 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 	WL_SCAN("START ESCAN\n");
 
 	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
-		WL_ERR("Scanning already: status (%lu)\n", cfg->scan_status);
+		brcmf_err("Scanning already: status (%lu)\n", cfg->scan_status);
 		return -EAGAIN;
 	}
 	if (test_bit(BRCMF_SCAN_STATUS_ABORT, &cfg->scan_status)) {
-		WL_ERR("Scanning being aborted: status (%lu)\n",
-		       cfg->scan_status);
+		brcmf_err("Scanning being aborted: status (%lu)\n",
+			  cfg->scan_status);
 		return -EAGAIN;
 	}
 	if (test_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state)) {
-		WL_ERR("Connecting: status (%lu)\n", ifp->vif->sme_state);
+		brcmf_err("Connecting: status (%lu)\n", ifp->vif->sme_state);
 		return -EAGAIN;
 	}
 
@@ -796,7 +796,7 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PASSIVE_SCAN,
 					    passive_scan);
 		if (err) {
-			WL_ERR("WLC_SET_PASSIVE_SCAN error (%d)\n", err);
+			brcmf_err("WLC_SET_PASSIVE_SCAN error (%d)\n", err);
 			goto scan_out;
 		}
 		brcmf_set_mpc(ndev, 0);
@@ -807,7 +807,7 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 				WL_INFO("BUSY: scan for \"%s\" canceled\n",
 					sr->ssid_le.SSID);
 			else
-				WL_ERR("WLC_SCAN error (%d)\n", err);
+				brcmf_err("WLC_SCAN error (%d)\n", err);
 
 			brcmf_set_mpc(ndev, 1);
 			goto scan_out;
@@ -839,7 +839,7 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 	err = brcmf_cfg80211_escan(wiphy, ndev, request, NULL);
 
 	if (err)
-		WL_ERR("scan error (%d)\n", err);
+		brcmf_err("scan error (%d)\n", err);
 
 	WL_TRACE("Exit\n");
 	return err;
@@ -852,7 +852,7 @@ static s32 brcmf_set_rts(struct net_device *ndev, u32 rts_threshold)
 	err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "rtsthresh",
 				      rts_threshold);
 	if (err)
-		WL_ERR("Error (%d)\n", err);
+		brcmf_err("Error (%d)\n", err);
 
 	return err;
 }
@@ -864,7 +864,7 @@ static s32 brcmf_set_frag(struct net_device *ndev, u32 frag_threshold)
 	err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "fragthresh",
 				      frag_threshold);
 	if (err)
-		WL_ERR("Error (%d)\n", err);
+		brcmf_err("Error (%d)\n", err);
 
 	return err;
 }
@@ -876,7 +876,7 @@ static s32 brcmf_set_retry(struct net_device *ndev, u32 retry, bool l)
 
 	err = brcmf_fil_cmd_int_set(netdev_priv(ndev), cmd, retry);
 	if (err) {
-		WL_ERR("cmd (%d) , error (%d)\n", cmd, err);
+		brcmf_err("cmd (%d) , error (%d)\n", cmd, err);
 		return err;
 	}
 	return err;
@@ -970,7 +970,7 @@ static void brcmf_link_down(struct brcmf_cfg80211_vif *vif)
 		err = brcmf_fil_cmd_data_set(vif->ifp,
 					     BRCMF_C_DISASSOC, NULL, 0);
 		if (err)
-			WL_ERR("WLC_DISASSOC failed (%d)\n", err);
+			brcmf_err("WLC_DISASSOC failed (%d)\n", err);
 		clear_bit(BRCMF_VIF_STATUS_CONNECTED, &vif->sme_state);
 	}
 	clear_bit(BRCMF_VIF_STATUS_CONNECTING, &vif->sme_state);
@@ -1044,7 +1044,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_fil_iovar_int_set(ifp, "wsec", wsec);
 	if (err) {
-		WL_ERR("wsec failed (%d)\n", err);
+		brcmf_err("wsec failed (%d)\n", err);
 		goto done;
 	}
 
@@ -1056,7 +1056,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_BCNPRD, bcnprd);
 	if (err) {
-		WL_ERR("WLC_SET_BCNPRD failed (%d)\n", err);
+		brcmf_err("WLC_SET_BCNPRD failed (%d)\n", err);
 		goto done;
 	}
 
@@ -1099,7 +1099,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_CHANNEL,
 					    target_channel);
 		if (err) {
-			WL_ERR("WLC_SET_CHANNEL failed (%d)\n", err);
+			brcmf_err("WLC_SET_CHANNEL failed (%d)\n", err);
 			goto done;
 		}
 	} else
@@ -1111,7 +1111,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
 				     &join_params, join_params_size);
 	if (err) {
-		WL_ERR("WLC_SET_SSID failed (%d)\n", err);
+		brcmf_err("WLC_SET_SSID failed (%d)\n", err);
 		goto done;
 	}
 
@@ -1156,7 +1156,7 @@ static s32 brcmf_set_wpa_version(struct net_device *ndev,
 	WL_CONN("setting wpa_auth to 0x%0x\n", val);
 	err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "wpa_auth", val);
 	if (err) {
-		WL_ERR("set wpa_auth failed (%d)\n", err);
+		brcmf_err("set wpa_auth failed (%d)\n", err);
 		return err;
 	}
 	sec = &profile->sec;
@@ -1189,13 +1189,13 @@ static s32 brcmf_set_auth_type(struct net_device *ndev,
 		WL_CONN("network eap\n");
 	default:
 		val = 2;
-		WL_ERR("invalid auth type (%d)\n", sme->auth_type);
+		brcmf_err("invalid auth type (%d)\n", sme->auth_type);
 		break;
 	}
 
 	err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "auth", val);
 	if (err) {
-		WL_ERR("set auth failed (%d)\n", err);
+		brcmf_err("set auth failed (%d)\n", err);
 		return err;
 	}
 	sec = &profile->sec;
@@ -1229,8 +1229,8 @@ brcmf_set_set_cipher(struct net_device *ndev,
 			pval = AES_ENABLED;
 			break;
 		default:
-			WL_ERR("invalid cipher pairwise (%d)\n",
-			       sme->crypto.ciphers_pairwise[0]);
+			brcmf_err("invalid cipher pairwise (%d)\n",
+				  sme->crypto.ciphers_pairwise[0]);
 			return -EINVAL;
 		}
 	}
@@ -1250,8 +1250,8 @@ brcmf_set_set_cipher(struct net_device *ndev,
 			gval = AES_ENABLED;
 			break;
 		default:
-			WL_ERR("invalid cipher group (%d)\n",
-			       sme->crypto.cipher_group);
+			brcmf_err("invalid cipher group (%d)\n",
+				  sme->crypto.cipher_group);
 			return -EINVAL;
 		}
 	}
@@ -1259,7 +1259,7 @@ brcmf_set_set_cipher(struct net_device *ndev,
 	WL_CONN("pval (%d) gval (%d)\n", pval, gval);
 	err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "wsec", pval | gval);
 	if (err) {
-		WL_ERR("error (%d)\n", err);
+		brcmf_err("error (%d)\n", err);
 		return err;
 	}
 
@@ -1282,7 +1282,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 		err = brcmf_fil_iovar_int_get(netdev_priv(ndev),
 					      "wpa_auth", &val);
 		if (err) {
-			WL_ERR("could not get wpa_auth (%d)\n", err);
+			brcmf_err("could not get wpa_auth (%d)\n", err);
 			return err;
 		}
 		if (val & (WPA_AUTH_PSK | WPA_AUTH_UNSPECIFIED)) {
@@ -1294,8 +1294,8 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 				val = WPA_AUTH_PSK;
 				break;
 			default:
-				WL_ERR("invalid cipher group (%d)\n",
-				       sme->crypto.cipher_group);
+				brcmf_err("invalid cipher group (%d)\n",
+					  sme->crypto.cipher_group);
 				return -EINVAL;
 			}
 		} else if (val & (WPA2_AUTH_PSK | WPA2_AUTH_UNSPECIFIED)) {
@@ -1307,8 +1307,8 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 				val = WPA2_AUTH_PSK;
 				break;
 			default:
-				WL_ERR("invalid cipher group (%d)\n",
-				       sme->crypto.cipher_group);
+				brcmf_err("invalid cipher group (%d)\n",
+					  sme->crypto.cipher_group);
 				return -EINVAL;
 			}
 		}
@@ -1317,7 +1317,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 		err = brcmf_fil_iovar_int_set(netdev_priv(ndev),
 					      "wpa_auth", val);
 		if (err) {
-			WL_ERR("could not set wpa_auth (%d)\n", err);
+			brcmf_err("could not set wpa_auth (%d)\n", err);
 			return err;
 		}
 	}
@@ -1357,7 +1357,7 @@ brcmf_set_sharedkey(struct net_device *ndev,
 	key.len = (u32) sme->key_len;
 	key.index = (u32) sme->key_idx;
 	if (key.len > sizeof(key.data)) {
-		WL_ERR("Too long key length (%u)\n", key.len);
+		brcmf_err("Too long key length (%u)\n", key.len);
 		return -EINVAL;
 	}
 	memcpy(key.data, sme->key, key.len);
@@ -1370,8 +1370,8 @@ brcmf_set_sharedkey(struct net_device *ndev,
 		key.algo = CRYPTO_ALGO_WEP128;
 		break;
 	default:
-		WL_ERR("Invalid algorithm (%d)\n",
-		       sme->crypto.ciphers_pairwise[0]);
+		brcmf_err("Invalid algorithm (%d)\n",
+			  sme->crypto.ciphers_pairwise[0]);
 		return -EINVAL;
 	}
 	/* Set the new key/index */
@@ -1387,7 +1387,7 @@ brcmf_set_sharedkey(struct net_device *ndev,
 		val = WL_AUTH_SHARED_KEY;	/* shared key */
 		err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev), "auth", val);
 		if (err)
-			WL_ERR("set auth failed (%d)\n", err);
+			brcmf_err("set auth failed (%d)\n", err);
 	}
 	return err;
 }
@@ -1411,7 +1411,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		return -EIO;
 
 	if (!sme->ssid) {
-		WL_ERR("Invalid ssid\n");
+		brcmf_err("Invalid ssid\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -1429,31 +1429,31 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_set_wpa_version(ndev, sme);
 	if (err) {
-		WL_ERR("wl_set_wpa_version failed (%d)\n", err);
+		brcmf_err("wl_set_wpa_version failed (%d)\n", err);
 		goto done;
 	}
 
 	err = brcmf_set_auth_type(ndev, sme);
 	if (err) {
-		WL_ERR("wl_set_auth_type failed (%d)\n", err);
+		brcmf_err("wl_set_auth_type failed (%d)\n", err);
 		goto done;
 	}
 
 	err = brcmf_set_set_cipher(ndev, sme);
 	if (err) {
-		WL_ERR("wl_set_set_cipher failed (%d)\n", err);
+		brcmf_err("wl_set_set_cipher failed (%d)\n", err);
 		goto done;
 	}
 
 	err = brcmf_set_key_mgmt(ndev, sme);
 	if (err) {
-		WL_ERR("wl_set_key_mgmt failed (%d)\n", err);
+		brcmf_err("wl_set_key_mgmt failed (%d)\n", err);
 		goto done;
 	}
 
 	err = brcmf_set_sharedkey(ndev, sme);
 	if (err) {
-		WL_ERR("brcmf_set_sharedkey failed (%d)\n", err);
+		brcmf_err("brcmf_set_sharedkey failed (%d)\n", err);
 		goto done;
 	}
 
@@ -1477,7 +1477,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
 				     &join_params, join_params_size);
 	if (err)
-		WL_ERR("WLC_SET_SSID failed (%d)\n", err);
+		brcmf_err("WLC_SET_SSID failed (%d)\n", err);
 
 done:
 	if (err)
@@ -1506,7 +1506,7 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_DISASSOC,
 				     &scbval, sizeof(scbval));
 	if (err)
-		WL_ERR("error (%d)\n", err);
+		brcmf_err("error (%d)\n", err);
 
 	WL_TRACE("Exit\n");
 	return err;
@@ -1535,7 +1535,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 	case NL80211_TX_POWER_LIMITED:
 	case NL80211_TX_POWER_FIXED:
 		if (dbm < 0) {
-			WL_ERR("TX_POWER_FIXED - dbm is negative\n");
+			brcmf_err("TX_POWER_FIXED - dbm is negative\n");
 			err = -EINVAL;
 			goto done;
 		}
@@ -1545,7 +1545,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 	disable = WL_RADIO_SW_DISABLE << 16;
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_RADIO, disable);
 	if (err)
-		WL_ERR("WLC_SET_RADIO error (%d)\n", err);
+		brcmf_err("WLC_SET_RADIO error (%d)\n", err);
 
 	if (dbm > 0xffff)
 		txpwrmw = 0xffff;
@@ -1554,7 +1554,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 	err = brcmf_fil_iovar_int_set(ifp, "qtxpower",
 				      (s32)brcmf_mw_to_qdbm(txpwrmw));
 	if (err)
-		WL_ERR("qtxpower error (%d)\n", err);
+		brcmf_err("qtxpower error (%d)\n", err);
 	cfg->conf->tx_power = dbm;
 
 done:
@@ -1578,7 +1578,7 @@ static s32 brcmf_cfg80211_get_tx_power(struct wiphy *wiphy,
 
 	err = brcmf_fil_iovar_int_get(ifp, "qtxpower", &txpwrdbm);
 	if (err) {
-		WL_ERR("error (%d)\n", err);
+		brcmf_err("error (%d)\n", err);
 		goto done;
 	}
 
@@ -1606,7 +1606,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_fil_bsscfg_int_get(ifp, "wsec", &wsec);
 	if (err) {
-		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
+		brcmf_err("WLC_GET_WSEC error (%d)\n", err);
 		goto done;
 	}
 
@@ -1616,7 +1616,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 		err = brcmf_fil_cmd_int_set(ifp,
 					    BRCMF_C_SET_KEY_PRIMARY, index);
 		if (err)
-			WL_ERR("error (%d)\n", err);
+			brcmf_err("error (%d)\n", err);
 	}
 done:
 	WL_TRACE("Exit\n");
@@ -1642,10 +1642,10 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *ndev,
 		/* key delete */
 		err = send_key_to_dongle(ndev, &key);
 		if (err)
-			WL_ERR("key delete error (%d)\n", err);
+			brcmf_err("key delete error (%d)\n", err);
 	} else {
 		if (key.len > sizeof(key.data)) {
-			WL_ERR("Invalid key length (%d)\n", key.len);
+			brcmf_err("Invalid key length (%d)\n", key.len);
 			return -EINVAL;
 		}
 
@@ -1692,12 +1692,12 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *ndev,
 			WL_CONN("WLAN_CIPHER_SUITE_CCMP\n");
 			break;
 		default:
-			WL_ERR("Invalid cipher (0x%x)\n", params->cipher);
+			brcmf_err("Invalid cipher (0x%x)\n", params->cipher);
 			return -EINVAL;
 		}
 		err = send_key_to_dongle(ndev, &key);
 		if (err)
-			WL_ERR("wsec_key error (%d)\n", err);
+			brcmf_err("wsec_key error (%d)\n", err);
 	}
 	return err;
 }
@@ -1729,7 +1729,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	key.index = (u32) key_idx;
 
 	if (key.len > sizeof(key.data)) {
-		WL_ERR("Too long key length (%u)\n", key.len);
+		brcmf_err("Too long key length (%u)\n", key.len);
 		err = -EINVAL;
 		goto done;
 	}
@@ -1769,7 +1769,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		WL_CONN("WLAN_CIPHER_SUITE_CCMP\n");
 		break;
 	default:
-		WL_ERR("Invalid cipher (0x%x)\n", params->cipher);
+		brcmf_err("Invalid cipher (0x%x)\n", params->cipher);
 		err = -EINVAL;
 		goto done;
 	}
@@ -1780,13 +1780,13 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_fil_bsscfg_int_get(ifp, "wsec", &wsec);
 	if (err) {
-		WL_ERR("get wsec error (%d)\n", err);
+		brcmf_err("get wsec error (%d)\n", err);
 		goto done;
 	}
 	wsec |= val;
 	err = brcmf_fil_bsscfg_int_set(ifp, "wsec", wsec);
 	if (err) {
-		WL_ERR("set wsec error (%d)\n", err);
+		brcmf_err("set wsec error (%d)\n", err);
 		goto done;
 	}
 
@@ -1809,7 +1809,7 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	if (key_idx >= DOT11_MAX_DEFAULT_KEYS) {
 		/* we ignore this key index in this case */
-		WL_ERR("invalid key index (%d)\n", key_idx);
+		brcmf_err("invalid key index (%d)\n", key_idx);
 		return -EINVAL;
 	}
 
@@ -1849,7 +1849,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_fil_bsscfg_int_get(ifp, "wsec", &wsec);
 	if (err) {
-		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
+		brcmf_err("WLC_GET_WSEC error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
 		err = -EAGAIN;
 		goto done;
@@ -1874,7 +1874,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 		WL_CONN("WLAN_CIPHER_SUITE_AES_CMAC\n");
 		break;
 	default:
-		WL_ERR("Invalid algo (0x%x)\n", wsec);
+		brcmf_err("Invalid algo (0x%x)\n", wsec);
 		err = -EINVAL;
 		goto done;
 	}
@@ -1917,7 +1917,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 					       &sta_info_le,
 					       sizeof(sta_info_le));
 		if (err < 0) {
-			WL_ERR("GET STA INFO failed, %d\n", err);
+			brcmf_err("GET STA INFO failed, %d\n", err);
 			goto done;
 		}
 		sinfo->filled = STATION_INFO_INACTIVE_TIME;
@@ -1930,15 +1930,15 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			 sinfo->inactive_time, sinfo->connected_time);
 	} else if (ifp->vif->mode == WL_MODE_BSS) {
 		if (memcmp(mac, bssid, ETH_ALEN)) {
-			WL_ERR("Wrong Mac address cfg_mac-%pM wl_bssid-%pM\n",
-			       mac, bssid);
+			brcmf_err("Wrong Mac address cfg_mac-%pM wl_bssid-%pM\n",
+				  mac, bssid);
 			err = -ENOENT;
 			goto done;
 		}
 		/* Report the current tx rate */
 	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_RATE, &rate);
 		if (err) {
-			WL_ERR("Could not get rate (%d)\n", err);
+			brcmf_err("Could not get rate (%d)\n", err);
 			goto done;
 		} else {
 			sinfo->filled |= STATION_INFO_TX_BITRATE;
@@ -1952,7 +1952,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_RSSI,
 						     &scb_val, sizeof(scb_val));
 			if (err) {
-				WL_ERR("Could not get rssi (%d)\n", err);
+				brcmf_err("Could not get rssi (%d)\n", err);
 				goto done;
 			} else {
 				rssi = le32_to_cpu(scb_val.val);
@@ -1999,9 +1999,9 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PM, pm);
 	if (err) {
 		if (err == -ENODEV)
-			WL_ERR("net_device is not ready yet\n");
+			brcmf_err("net_device is not ready yet\n");
 		else
-			WL_ERR("error (%d)\n", err);
+			brcmf_err("error (%d)\n", err);
 	}
 done:
 	WL_TRACE("Exit\n");
@@ -2031,7 +2031,7 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_CURR_RATESET,
 				     &rateset_le, sizeof(rateset_le));
 	if (err) {
-		WL_ERR("could not get current rateset (%d)\n", err);
+		brcmf_err("could not get current rateset (%d)\n", err);
 		goto done;
 	}
 
@@ -2059,7 +2059,8 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *ndev,
 	err_bg = brcmf_fil_iovar_int_set(ifp, "bg_rate", rate);
 	err_a = brcmf_fil_iovar_int_set(ifp, "a_rate", rate);
 	if (err_bg && err_a) {
-		WL_ERR("could not set fixed rate (%d) (%d)\n", err_bg, err_a);
+		brcmf_err("could not set fixed rate (%d) (%d)\n", err_bg,
+			  err_a);
 		err = err_bg | err_a;
 	}
 
@@ -2085,7 +2086,7 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 	s32 notify_signal;
 
 	if (le32_to_cpu(bi->length) > WL_BSS_INFO_MAX) {
-		WL_ERR("Bss info is larger than buffer. Discarding\n");
+		brcmf_err("Bss info is larger than buffer. Discarding\n");
 		return 0;
 	}
 
@@ -2145,8 +2146,8 @@ static s32 brcmf_inform_bss(struct brcmf_cfg80211_info *cfg)
 	bss_list = cfg->bss_list;
 	if (bss_list->count != 0 &&
 	    bss_list->version != BRCMF_BSS_INFO_VERSION) {
-		WL_ERR("Version %d != WL_BSS_INFO_VERSION\n",
-		       bss_list->version);
+		brcmf_err("Version %d != WL_BSS_INFO_VERSION\n",
+			  bss_list->version);
 		return -EOPNOTSUPP;
 	}
 	WL_SCAN("scanned AP count (%d)\n", bss_list->count);
@@ -2190,7 +2191,7 @@ static s32 wl_inform_ibss(struct brcmf_cfg80211_info *cfg,
 	err = brcmf_fil_cmd_data_get(netdev_priv(ndev), BRCMF_C_GET_BSS_INFO,
 				     buf, WL_BSS_INFO_MAX);
 	if (err) {
-		WL_ERR("WLC_GET_BSS_INFO failed: %d\n", err);
+		brcmf_err("WLC_GET_BSS_INFO failed: %d\n", err);
 		goto CleanUp;
 	}
 
@@ -2334,7 +2335,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg)
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_BSS_INFO,
 				     cfg->extra_buf, WL_EXTRA_BUF_MAX);
 	if (err) {
-		WL_ERR("Could not get bss info %d\n", err);
+		brcmf_err("Could not get bss info %d\n", err);
 		goto update_bss_info_out;
 	}
 
@@ -2359,7 +2360,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg)
 		u32 var;
 		err = brcmf_fil_iovar_int_get(ifp, "dtim_assoc", &var);
 		if (err) {
-			WL_ERR("wl dtim_assoc failed (%d)\n", err);
+			brcmf_err("wl dtim_assoc failed (%d)\n", err);
 			goto update_bss_info_out;
 		}
 		dtim_period = (u8)var;
@@ -2399,7 +2400,7 @@ static void brcmf_escan_timeout(unsigned long data)
 			(struct brcmf_cfg80211_info *)data;
 
 	if (cfg->scan_request) {
-		WL_ERR("timer expired\n");
+		brcmf_err("timer expired\n");
 		schedule_work(&cfg->escan_timeout_work);
 	}
 }
@@ -2455,8 +2456,8 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 	status = e->status;
 
 	if (!ndev || !test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
-		WL_ERR("scan not ready ndev %p drv_status %x\n", ndev,
-		       !test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status));
+		brcmf_err("scan not ready ndev %p drv_status %x\n", ndev,
+			  !test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status));
 		return -EPERM;
 	}
 
@@ -2464,7 +2465,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 		WL_SCAN("ESCAN Partial result\n");
 		escan_result_le = (struct brcmf_escan_result_le *) data;
 		if (!escan_result_le) {
-			WL_ERR("Invalid escan result (NULL pointer)\n");
+			brcmf_err("Invalid escan result (NULL pointer)\n");
 			goto exit;
 		}
 		if (!cfg->scan_request) {
@@ -2473,8 +2474,8 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 		}
 
 		if (le16_to_cpu(escan_result_le->bss_count) != 1) {
-			WL_ERR("Invalid bss_count %d: ignoring\n",
-				escan_result_le->bss_count);
+			brcmf_err("Invalid bss_count %d: ignoring\n",
+				  escan_result_le->bss_count);
 			goto exit;
 		}
 		bss_info_le = &escan_result_le->bss_info_le;
@@ -2482,8 +2483,8 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 		bi_length = le32_to_cpu(bss_info_le->length);
 		if (bi_length != (le32_to_cpu(escan_result_le->buflen) -
 					WL_ESCAN_RESULTS_FIXED_SIZE)) {
-			WL_ERR("Invalid bss_info length %d: ignoring\n",
-				bi_length);
+			brcmf_err("Invalid bss_info length %d: ignoring\n",
+				  bi_length);
 			goto exit;
 		}
 
@@ -2491,7 +2492,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 					BIT(NL80211_IFTYPE_ADHOC))) {
 			if (le16_to_cpu(bss_info_le->capability) &
 						WLAN_CAPABILITY_IBSS) {
-				WL_ERR("Ignoring IBSS result\n");
+				brcmf_err("Ignoring IBSS result\n");
 				goto exit;
 			}
 		}
@@ -2499,7 +2500,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 		list = (struct brcmf_scan_results *)
 				cfg->escan_info.escan_buf;
 		if (bi_length > WL_ESCAN_BUF_SIZE - list->buflen) {
-			WL_ERR("Buffer is too small: ignoring\n");
+			brcmf_err("Buffer is too small: ignoring\n");
 			goto exit;
 		}
 
@@ -2525,7 +2526,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 			brcmf_notify_escan_complete(cfg, ndev, aborted,
 						    false);
 		} else
-			WL_ERR("Unexpected scan result 0x%x\n", status);
+			brcmf_err("Unexpected scan result 0x%x\n", status);
 	}
 exit:
 	return err;
@@ -2804,7 +2805,8 @@ brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 		for (i = 0; i < result_count; i++) {
 			netinfo = &netinfo_start[i];
 			if (!netinfo) {
-				WL_ERR("Invalid netinfo ptr. index: %d\n", i);
+				brcmf_err("Invalid netinfo ptr. index: %d\n",
+					  i);
 				err = -EINVAL;
 				goto out_err;
 			}
@@ -2847,7 +2849,7 @@ brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 		cfg->sched_escan = true;
 		cfg->scan_request = request;
 	} else {
-		WL_ERR("FALSE PNO Event. (pfn_count == 0)\n");
+		brcmf_err("FALSE PNO Event. (pfn_count == 0)\n");
 		goto out_err;
 	}
 
@@ -2876,7 +2878,7 @@ static int brcmf_dev_pno_clean(struct net_device *ndev)
 					       NULL, 0);
 	}
 	if (ret < 0)
-		WL_ERR("failed code %d\n", ret);
+		brcmf_err("failed code %d\n", ret);
 
 	return ret;
 }
@@ -2914,13 +2916,13 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 	WL_SCAN("Enter n_match_sets:%d   n_ssids:%d\n",
 		request->n_match_sets, request->n_ssids);
 	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
-		WL_ERR("Scanning already: status (%lu)\n", cfg->scan_status);
+		brcmf_err("Scanning already: status (%lu)\n", cfg->scan_status);
 		return -EAGAIN;
 	}
 
 	if (!request || !request->n_ssids || !request->n_match_sets) {
-		WL_ERR("Invalid sched scan req!! n_ssids:%d\n",
-		       request ? request->n_ssids : 0);
+		brcmf_err("Invalid sched scan req!! n_ssids:%d\n",
+			  request ? request->n_ssids : 0);
 		return -EINVAL;
 	}
 
@@ -2941,14 +2943,14 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 		/* clean up everything */
 		ret = brcmf_dev_pno_clean(ndev);
 		if  (ret < 0) {
-			WL_ERR("failed error=%d\n", ret);
+			brcmf_err("failed error=%d\n", ret);
 			return ret;
 		}
 
 		/* configure pno */
 		ret = brcmf_dev_pno_config(ndev);
 		if (ret < 0) {
-			WL_ERR("PNO setup failed!! ret=%d\n", ret);
+			brcmf_err("PNO setup failed!! ret=%d\n", ret);
 			return -EINVAL;
 		}
 
@@ -2961,7 +2963,7 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 			ssid_len = ssid->ssid_len;
 
 			if (!ssid_len) {
-				WL_ERR("skip broadcast ssid\n");
+				brcmf_err("skip broadcast ssid\n");
 				continue;
 			}
 			pfn.auth = cpu_to_le32(WLAN_AUTH_OPEN);
@@ -2979,7 +2981,7 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 		}
 		/* Enable the PNO */
 		if (brcmf_fil_iovar_int_set(ifp, "pfn", 1) < 0) {
-			WL_ERR("PNO enable failed!! ret=%d\n", ret);
+			brcmf_err("PNO enable failed!! ret=%d\n", ret);
 			return -EINVAL;
 		}
 	} else {
@@ -3036,19 +3038,19 @@ static s32 brcmf_configure_opensecurity(struct net_device *ndev, s32 bssidx)
 	/* set auth */
 	err = brcmf_fil_bsscfg_int_set(ifp, "auth", 0);
 	if (err < 0) {
-		WL_ERR("auth error %d\n", err);
+		brcmf_err("auth error %d\n", err);
 		return err;
 	}
 	/* set wsec */
 	err = brcmf_fil_bsscfg_int_set(ifp, "wsec", 0);
 	if (err < 0) {
-		WL_ERR("wsec error %d\n", err);
+		brcmf_err("wsec error %d\n", err);
 		return err;
 	}
 	/* set upper-layer auth */
 	err = brcmf_fil_bsscfg_int_set(ifp, "wpa_auth", WPA_AUTH_NONE);
 	if (err < 0) {
-		WL_ERR("wpa_auth error %d\n", err);
+		brcmf_err("wpa_auth error %d\n", err);
 		return err;
 	}
 
@@ -3096,13 +3098,13 @@ brcmf_configure_wpaie(struct net_device *ndev, struct brcmf_vs_tlv *wpa_ie,
 	/* check for multicast cipher suite */
 	if (offset + WPA_IE_MIN_OUI_LEN > len) {
 		err = -EINVAL;
-		WL_ERR("no multicast cipher suite\n");
+		brcmf_err("no multicast cipher suite\n");
 		goto exit;
 	}
 
 	if (!brcmf_valid_wpa_oui(&data[offset], is_rsn_ie)) {
 		err = -EINVAL;
-		WL_ERR("ivalid OUI\n");
+		brcmf_err("ivalid OUI\n");
 		goto exit;
 	}
 	offset += TLV_OUI_LEN;
@@ -3124,7 +3126,7 @@ brcmf_configure_wpaie(struct net_device *ndev, struct brcmf_vs_tlv *wpa_ie,
 		break;
 	default:
 		err = -EINVAL;
-		WL_ERR("Invalid multi cast cipher info\n");
+		brcmf_err("Invalid multi cast cipher info\n");
 		goto exit;
 	}
 
@@ -3135,13 +3137,13 @@ brcmf_configure_wpaie(struct net_device *ndev, struct brcmf_vs_tlv *wpa_ie,
 	/* Check for unicast suite(s) */
 	if (offset + (WPA_IE_MIN_OUI_LEN * count) > len) {
 		err = -EINVAL;
-		WL_ERR("no unicast cipher suite\n");
+		brcmf_err("no unicast cipher suite\n");
 		goto exit;
 	}
 	for (i = 0; i < count; i++) {
 		if (!brcmf_valid_wpa_oui(&data[offset], is_rsn_ie)) {
 			err = -EINVAL;
-			WL_ERR("ivalid OUI\n");
+			brcmf_err("ivalid OUI\n");
 			goto exit;
 		}
 		offset += TLV_OUI_LEN;
@@ -3159,7 +3161,7 @@ brcmf_configure_wpaie(struct net_device *ndev, struct brcmf_vs_tlv *wpa_ie,
 			pval |= AES_ENABLED;
 			break;
 		default:
-			WL_ERR("Ivalid unicast security info\n");
+			brcmf_err("Ivalid unicast security info\n");
 		}
 		offset++;
 	}
@@ -3169,13 +3171,13 @@ brcmf_configure_wpaie(struct net_device *ndev, struct brcmf_vs_tlv *wpa_ie,
 	/* Check for auth key management suite(s) */
 	if (offset + (WPA_IE_MIN_OUI_LEN * count) > len) {
 		err = -EINVAL;
-		WL_ERR("no auth key mgmt suite\n");
+		brcmf_err("no auth key mgmt suite\n");
 		goto exit;
 	}
 	for (i = 0; i < count; i++) {
 		if (!brcmf_valid_wpa_oui(&data[offset], is_rsn_ie)) {
 			err = -EINVAL;
-			WL_ERR("ivalid OUI\n");
+			brcmf_err("ivalid OUI\n");
 			goto exit;
 		}
 		offset += TLV_OUI_LEN;
@@ -3195,7 +3197,7 @@ brcmf_configure_wpaie(struct net_device *ndev, struct brcmf_vs_tlv *wpa_ie,
 				    (wpa_auth |= WPA_AUTH_PSK);
 			break;
 		default:
-			WL_ERR("Ivalid key mgmt info\n");
+			brcmf_err("Ivalid key mgmt info\n");
 		}
 		offset++;
 	}
@@ -3211,7 +3213,7 @@ brcmf_configure_wpaie(struct net_device *ndev, struct brcmf_vs_tlv *wpa_ie,
 		err = brcmf_fil_bsscfg_int_set(ifp, "wme_bss_disable",
 					       wme_bss_disable);
 		if (err < 0) {
-			WL_ERR("wme_bss_disable error %d\n", err);
+			brcmf_err("wme_bss_disable error %d\n", err);
 			goto exit;
 		}
 	}
@@ -3221,19 +3223,19 @@ brcmf_configure_wpaie(struct net_device *ndev, struct brcmf_vs_tlv *wpa_ie,
 	/* set auth */
 	err = brcmf_fil_bsscfg_int_set(ifp, "auth", auth);
 	if (err < 0) {
-		WL_ERR("auth error %d\n", err);
+		brcmf_err("auth error %d\n", err);
 		goto exit;
 	}
 	/* set wsec */
 	err = brcmf_fil_bsscfg_int_set(ifp, "wsec", wsec);
 	if (err < 0) {
-		WL_ERR("wsec error %d\n", err);
+		brcmf_err("wsec error %d\n", err);
 		goto exit;
 	}
 	/* set upper-layer auth */
 	err = brcmf_fil_bsscfg_int_set(ifp, "wpa_auth", wpa_auth);
 	if (err < 0) {
-		WL_ERR("wpa_auth error %d\n", err);
+		brcmf_err("wpa_auth error %d\n", err);
 		goto exit;
 	}
 
@@ -3261,8 +3263,8 @@ brcmf_parse_vndr_ies(const u8 *vndr_ie_buf, u32 vndr_ie_len,
 		vndrie = (struct brcmf_vs_tlv *)ie;
 		/* len should be bigger than OUI length + one */
 		if (vndrie->len < (VS_IE_FIXED_HDR_LEN - TLV_HDR_LEN + 1)) {
-			WL_ERR("invalid vndr ie. length is too small %d\n",
-				vndrie->len);
+			brcmf_err("invalid vndr ie. length is too small %d\n",
+				  vndrie->len);
 			goto next;
 		}
 		/* if wpa or wme ie, do not add ie */
@@ -3368,18 +3370,18 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 			break;
 		default:
 			err = -EPERM;
-			WL_ERR("not suitable type\n");
+			brcmf_err("not suitable type\n");
 			goto exit;
 		}
 	} else {
 		err = -EPERM;
-		WL_ERR("not suitable type\n");
+		brcmf_err("not suitable type\n");
 		goto exit;
 	}
 
 	if (vndr_ie_len > mgmt_ie_buf_len) {
 		err = -ENOMEM;
-		WL_ERR("extra IE size too big\n");
+		brcmf_err("extra IE size too big\n");
 		goto exit;
 	}
 
@@ -3440,8 +3442,8 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 			/* verify remained buf size before copy data */
 			if (remained_buf_len < (vndrie_info->vndrie.len +
 							VNDR_IE_VSIE_OFFSET)) {
-				WL_ERR("no space in mgmt_ie_buf: len left %d",
-				       remained_buf_len);
+				brcmf_err("no space in mgmt_ie_buf: len left %d",
+					  remained_buf_len);
 				break;
 			}
 			remained_buf_len -= (vndrie_info->ie_len +
@@ -3472,7 +3474,7 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 		err  = brcmf_fil_bsscfg_data_set(ifp, "vndr_ie", iovar_ie_buf,
 						 total_ie_buf_len);
 		if (err)
-			WL_ERR("vndr ie set error : %d\n", err);
+			brcmf_err("vndr ie set error : %d\n", err);
 	}
 
 exit:
@@ -3503,7 +3505,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		 settings->inactivity_timeout);
 
 	if (!test_bit(BRCMF_VIF_STATUS_AP_CREATING, &ifp->vif->sme_state)) {
-		WL_ERR("Not in AP creation mode\n");
+		brcmf_err("Not in AP creation mode\n");
 		return -EPERM;
 	}
 
@@ -3528,17 +3530,17 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	brcmf_set_mpc(ndev, 0);
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1);
 	if (err < 0) {
-		WL_ERR("BRCMF_C_DOWN error %d\n", err);
+		brcmf_err("BRCMF_C_DOWN error %d\n", err);
 		goto exit;
 	}
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, 1);
 	if (err < 0) {
-		WL_ERR("SET INFRA error %d\n", err);
+		brcmf_err("SET INFRA error %d\n", err);
 		goto exit;
 	}
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 1);
 	if (err < 0) {
-		WL_ERR("setting AP mode failed %d\n", err);
+		brcmf_err("setting AP mode failed %d\n", err);
 		goto exit;
 	}
 
@@ -3574,7 +3576,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 				    settings->beacon.tail,
 				    settings->beacon.tail_len);
 	if (err)
-		WL_ERR("Set Beacon IE Failed\n");
+		brcmf_err("Set Beacon IE Failed\n");
 	else
 		WL_TRACE("Applied Vndr IEs for Beacon\n");
 
@@ -3584,7 +3586,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 				    settings->beacon.proberesp_ies,
 				    settings->beacon.proberesp_ies_len);
 	if (err)
-		WL_ERR("Set Probe Resp IE Failed\n");
+		brcmf_err("Set Probe Resp IE Failed\n");
 	else
 		WL_TRACE("Applied Vndr IEs for Probe Resp\n");
 
@@ -3592,7 +3594,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_BCNPRD,
 					    settings->beacon_interval);
 		if (err < 0) {
-			WL_ERR("Beacon Interval Set Error, %d\n", err);
+			brcmf_err("Beacon Interval Set Error, %d\n", err);
 			goto exit;
 		}
 	}
@@ -3600,13 +3602,13 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_DTIMPRD,
 					    settings->dtim_period);
 		if (err < 0) {
-			WL_ERR("DTIM Interval Set Error, %d\n", err);
+			brcmf_err("DTIM Interval Set Error, %d\n", err);
 			goto exit;
 		}
 	}
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 1);
 	if (err < 0) {
-		WL_ERR("BRCMF_C_UP error (%d)\n", err);
+		brcmf_err("BRCMF_C_UP error (%d)\n", err);
 		goto exit;
 	}
 
@@ -3617,7 +3619,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
 				     &join_params, sizeof(join_params));
 	if (err < 0) {
-		WL_ERR("SET SSID error (%d)\n", err);
+		brcmf_err("SET SSID error (%d)\n", err);
 		goto exit;
 	}
 	clear_bit(BRCMF_VIF_STATUS_AP_CREATING, &ifp->vif->sme_state);
@@ -3642,12 +3644,12 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 		msleep(400);
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 0);
 		if (err < 0) {
-			WL_ERR("setting AP mode failed %d\n", err);
+			brcmf_err("setting AP mode failed %d\n", err);
 			goto exit;
 		}
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 0);
 		if (err < 0) {
-			WL_ERR("BRCMF_C_UP error %d\n", err);
+			brcmf_err("BRCMF_C_UP error %d\n", err);
 			goto exit;
 		}
 		brcmf_set_mpc(ndev, 1);
@@ -3679,7 +3681,7 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCB_DEAUTHENTICATE_FOR_REASON,
 				     &scbval, sizeof(scbval));
 	if (err)
-		WL_ERR("SCB_DEAUTHENTICATE_FOR_REASON failed %d\n", err);
+		brcmf_err("SCB_DEAUTHENTICATE_FOR_REASON failed %d\n", err);
 
 	WL_TRACE("Exit\n");
 	return err;
@@ -3750,7 +3752,7 @@ static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
 
 	wiphy = wiphy_new(&wl_cfg80211_ops, sizeof(struct brcmf_cfg80211_info));
 	if (!wiphy) {
-		WL_ERR("Could not allocate wiphy device\n");
+		brcmf_err("Could not allocate wiphy device\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	set_wiphy_dev(wiphy, phydev);
@@ -3777,7 +3779,7 @@ static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
 	brcmf_wiphy_pno_params(wiphy);
 	err = wiphy_register(wiphy);
 	if (err < 0) {
-		WL_ERR("Could not register wiphy device (%d)\n", err);
+		brcmf_err("Could not register wiphy device (%d)\n", err);
 		wiphy_free(wiphy);
 		return ERR_PTR(err);
 	}
@@ -3907,7 +3909,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg)
 	err = brcmf_fil_iovar_data_get(ifp, "assoc_info",
 				       cfg->extra_buf, WL_ASSOC_INFO_MAX);
 	if (err) {
-		WL_ERR("could not get assoc info (%d)\n", err);
+		brcmf_err("could not get assoc info (%d)\n", err);
 		return err;
 	}
 	assoc_info =
@@ -3919,7 +3921,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg)
 					       cfg->extra_buf,
 					       WL_ASSOC_INFO_MAX);
 		if (err) {
-			WL_ERR("could not get assoc req (%d)\n", err);
+			brcmf_err("could not get assoc req (%d)\n", err);
 			return err;
 		}
 		conn_info->req_ie_len = req_len;
@@ -3935,7 +3937,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg)
 					       cfg->extra_buf,
 					       WL_ASSOC_INFO_MAX);
 		if (err) {
-			WL_ERR("could not get assoc resp (%d)\n", err);
+			brcmf_err("could not get assoc resp (%d)\n", err);
 			return err;
 		}
 		conn_info->resp_ie_len = resp_len;
@@ -4072,7 +4074,7 @@ brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
 	    reason == BRCMF_E_STATUS_SUCCESS) {
 		sinfo.filled = STATION_INFO_ASSOC_REQ_IES;
 		if (!data) {
-			WL_ERR("No IEs present in ASSOC/REASSOC_IND");
+			brcmf_err("No IEs present in ASSOC/REASSOC_IND");
 			return -EINVAL;
 		}
 		sinfo.assoc_req_ies = data;
@@ -4280,7 +4282,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	s32 err = 0;
 
 	if (!ndev) {
-		WL_ERR("ndev is invalid\n");
+		brcmf_err("ndev is invalid\n");
 		return NULL;
 	}
 
@@ -4302,7 +4304,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 
 	err = wl_init_priv(cfg);
 	if (err) {
-		WL_ERR("Failed to init iwm_priv (%d)\n", err);
+		brcmf_err("Failed to init iwm_priv (%d)\n", err);
 		goto cfg80211_attach_out;
 	}
 
@@ -4340,7 +4342,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	if (roamvar) {
 		err = brcmf_fil_iovar_int_set(ifp, "bcn_timeout", bcn_timeout);
 		if (err) {
-			WL_ERR("bcn_timeout error (%d)\n", err);
+			brcmf_err("bcn_timeout error (%d)\n", err);
 			goto dongle_rom_out;
 		}
 	}
@@ -4352,7 +4354,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	WL_INFO("Internal Roaming = %s\n", roamvar ? "Off" : "On");
 	err = brcmf_fil_iovar_int_set(ifp, "roam_off", roamvar);
 	if (err) {
-		WL_ERR("roam_off error (%d)\n", err);
+		brcmf_err("roam_off error (%d)\n", err);
 		goto dongle_rom_out;
 	}
 
@@ -4361,7 +4363,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_ROAM_TRIGGER,
 				     (void *)roamtrigger, sizeof(roamtrigger));
 	if (err) {
-		WL_ERR("WLC_SET_ROAM_TRIGGER error (%d)\n", err);
+		brcmf_err("WLC_SET_ROAM_TRIGGER error (%d)\n", err);
 		goto dongle_rom_out;
 	}
 
@@ -4370,7 +4372,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_ROAM_DELTA,
 				     (void *)roam_delta, sizeof(roam_delta));
 	if (err) {
-		WL_ERR("WLC_SET_ROAM_DELTA error (%d)\n", err);
+		brcmf_err("WLC_SET_ROAM_DELTA error (%d)\n", err);
 		goto dongle_rom_out;
 	}
 
@@ -4391,7 +4393,7 @@ brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 		if (err == -EOPNOTSUPP)
 			WL_INFO("Scan assoc time is not supported\n");
 		else
-			WL_ERR("Scan assoc time error (%d)\n", err);
+			brcmf_err("Scan assoc time error (%d)\n", err);
 		goto dongle_scantime_out;
 	}
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_UNASSOC_TIME,
@@ -4400,7 +4402,7 @@ brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 		if (err == -EOPNOTSUPP)
 			WL_INFO("Scan unassoc time is not supported\n");
 		else
-			WL_ERR("Scan unassoc time error (%d)\n", err);
+			brcmf_err("Scan unassoc time error (%d)\n", err);
 		goto dongle_scantime_out;
 	}
 
@@ -4410,7 +4412,7 @@ brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 		if (err == -EOPNOTSUPP)
 			WL_INFO("Scan passive time is not supported\n");
 		else
-			WL_ERR("Scan passive time error (%d)\n", err);
+			brcmf_err("Scan passive time error (%d)\n", err);
 		goto dongle_scantime_out;
 	}
 
@@ -4429,7 +4431,7 @@ static s32 wl_update_wiphybands(struct brcmf_cfg80211_info *cfg)
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_PHYLIST,
 				     &phy_list, sizeof(phy_list));
 	if (err) {
-		WL_ERR("error (%d)\n", err);
+		brcmf_err("error (%d)\n", err);
 		return err;
 	}
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 0e70520..7ca1f2e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -19,8 +19,6 @@
 
 #include "dhd_dbg.h"
 
-#define	WL_ERR(fmt, ...)	brcmf_err(fmt, ##__VA_ARGS__)
-
 #define	WL_INFO(fmt, ...)	brcmf_dbg(INFO, fmt, ##__VA_ARGS__)
 #define	WL_TRACE(fmt, ...)	brcmf_dbg(TRACE, fmt, ##__VA_ARGS__)
 #define	WL_SCAN(fmt, ...)	brcmf_dbg(SCAN, fmt, ##__VA_ARGS__)
-- 
1.7.9.5


