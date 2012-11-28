Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4101 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350Ab2K1Uoi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 15:44:38 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/11] brcmfmac: remove mode from struct
 brcmf_cfg80211_conf
Date: Wed, 28 Nov 2012 21:44:12 +0100
Message-ID: <1354135454-7035-10-git-send-email-arend@broadcom.com> (sfid-20121128_214443_352981_ACA01FCB)
In-Reply-To: <1354135454-7035-1-git-send-email-arend@broadcom.com>
References: <1354135454-7035-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mode should be stored and used per virtual interface. Remove
the mode from device global structure and rework the code to use
the mode from brcmf_cfg80211_vif.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   47 +++++++++-----------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    1 -
 2 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 87b3476..5dea1b4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -447,7 +447,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 			 struct vif_params *params)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_vif *vif = ifp->vif;
 	s32 infra = 0;
 	s32 ap = 0;
 	s32 err = 0;
@@ -461,15 +461,15 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 		       type);
 		return -EOPNOTSUPP;
 	case NL80211_IFTYPE_ADHOC:
-		cfg->conf->mode = WL_MODE_IBSS;
+		vif->mode = WL_MODE_IBSS;
 		infra = 0;
 		break;
 	case NL80211_IFTYPE_STATION:
-		cfg->conf->mode = WL_MODE_BSS;
+		vif->mode = WL_MODE_BSS;
 		infra = 1;
 		break;
 	case NL80211_IFTYPE_AP:
-		cfg->conf->mode = WL_MODE_AP;
+		vif->mode = WL_MODE_AP;
 		ap = 1;
 		break;
 	default:
@@ -478,18 +478,16 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	if (ap) {
-		set_bit(BRCMF_VIF_STATUS_AP_CREATING, &ifp->vif->sme_state);
+		set_bit(BRCMF_VIF_STATUS_AP_CREATING, &vif->sme_state);
 		WL_INFO("IF Type = AP\n");
 	} else {
-		err = brcmf_fil_cmd_int_set(netdev_priv(ndev),
-					    BRCMF_C_SET_INFRA, infra);
+		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, infra);
 		if (err) {
 			WL_ERR("WLC_SET_INFRA error (%d)\n", err);
 			err = -EAGAIN;
 			goto done;
 		}
-		WL_INFO("IF Type = %s\n",
-			(cfg->conf->mode == WL_MODE_IBSS) ?
+		WL_INFO("IF Type = %s\n", (vif->mode == WL_MODE_IBSS) ?
 			"Adhoc" : "Infra");
 	}
 	ndev->ieee80211_ptr->iftype = type;
@@ -1711,7 +1709,6 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		    u8 key_idx, bool pairwise, const u8 *mac_addr,
 		    struct key_params *params)
 {
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_wsec_key key;
 	s32 val;
@@ -1753,7 +1750,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		WL_CONN("WLAN_CIPHER_SUITE_WEP104\n");
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
-		if (cfg->conf->mode != WL_MODE_AP) {
+		if (ifp->vif->mode != WL_MODE_AP) {
 			WL_CONN("Swapping key\n");
 			memcpy(keybuf, &key.data[24], sizeof(keybuf));
 			memcpy(&key.data[24], &key.data[16], sizeof(keybuf));
@@ -1903,7 +1900,6 @@ static s32
 brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			   u8 *mac, struct station_info *sinfo)
 {
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct brcmf_scb_val_le scb_val;
@@ -1917,7 +1913,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
-	if (cfg->conf->mode == WL_MODE_AP) {
+	if (ifp->vif->mode == WL_MODE_AP) {
 		memcpy(&sta_info_le, mac, ETH_ALEN);
 		err = brcmf_fil_iovar_data_get(ifp, "sta_info",
 					       &sta_info_le,
@@ -1934,7 +1930,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 		}
 		WL_TRACE("STA idle time : %d ms, connected time :%d sec\n",
 			 sinfo->inactive_time, sinfo->connected_time);
-	} else if (cfg->conf->mode == WL_MODE_BSS) {
+	} else if (ifp->vif->mode == WL_MODE_BSS) {
 		if (memcmp(mac, bssid, ETH_ALEN)) {
 			WL_ERR("Wrong Mac address cfg_mac-%pM wl_bssid-%pM\n",
 			       mac, bssid);
@@ -2244,9 +2240,9 @@ CleanUp:
 	return err;
 }
 
-static bool brcmf_is_ibssmode(struct brcmf_cfg80211_info *cfg)
+static bool brcmf_is_ibssmode(struct brcmf_cfg80211_vif *vif)
 {
-	return cfg->conf->mode == WL_MODE_IBSS;
+	return vif->mode == WL_MODE_IBSS;
 }
 
 /*
@@ -2331,7 +2327,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg)
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	if (brcmf_is_ibssmode(cfg))
+	if (brcmf_is_ibssmode(ifp->vif))
 		return err;
 
 	ssid = &profile->ssid;
@@ -3634,22 +3630,20 @@ exit:
 static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	s32 err = -EPERM;
 
 	WL_TRACE("Enter\n");
 
-	if (cfg->conf->mode == WL_MODE_AP) {
+	if (ifp->vif->mode == WL_MODE_AP) {
 		/* Due to most likely deauths outstanding we sleep */
 		/* first to make sure they get processed by fw. */
 		msleep(400);
-		err = brcmf_fil_cmd_int_set(netdev_priv(ndev),
-					    BRCMF_C_SET_AP, 0);
+		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 0);
 		if (err < 0) {
 			WL_ERR("setting AP mode failed %d\n", err);
 			goto exit;
 		}
-		err = brcmf_fil_cmd_int_set(netdev_priv(ndev), BRCMF_C_UP, 0);
+		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 0);
 		if (err < 0) {
 			WL_ERR("BRCMF_C_UP error %d\n", err);
 			goto exit;
@@ -4103,11 +4097,11 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	s32 err = 0;
 
-	if (cfg->conf->mode == WL_MODE_AP) {
+	if (ifp->vif->mode == WL_MODE_AP) {
 		err = brcmf_notify_connect_status_ap(cfg, ndev, e, data);
 	} else if (brcmf_is_linkup(e)) {
 		WL_CONN("Linkup\n");
-		if (brcmf_is_ibssmode(cfg)) {
+		if (brcmf_is_ibssmode(ifp->vif)) {
 			memcpy(profile->bssid, e->addr, ETH_ALEN);
 			wl_inform_ibss(cfg, ndev, e->addr);
 			cfg80211_ibss_joined(ndev, e->addr, GFP_KERNEL);
@@ -4119,7 +4113,7 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 			brcmf_bss_connect_done(cfg, ndev, e, true);
 	} else if (brcmf_is_linkdown(e)) {
 		WL_CONN("Linkdown\n");
-		if (!brcmf_is_ibssmode(cfg)) {
+		if (!brcmf_is_ibssmode(ifp->vif)) {
 			brcmf_bss_connect_done(cfg, ndev, e, false);
 			if (test_and_clear_bit(BRCMF_VIF_STATUS_CONNECTED,
 					       &ifp->vif->sme_state))
@@ -4129,7 +4123,7 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 		brcmf_link_down(ifp->vif);
 		brcmf_init_prof(ndev_to_prof(ndev));
 	} else if (brcmf_is_nonetwork(cfg, e)) {
-		if (brcmf_is_ibssmode(cfg))
+		if (brcmf_is_ibssmode(ifp->vif))
 			clear_bit(BRCMF_VIF_STATUS_CONNECTING,
 				  &ifp->vif->sme_state);
 		else
@@ -4178,7 +4172,6 @@ brcmf_notify_mic_status(struct brcmf_if *ifp,
 
 static void brcmf_init_conf(struct brcmf_cfg80211_conf *conf)
 {
-	conf->mode = (u32)-1;
 	conf->frag_threshold = (u32)-1;
 	conf->rts_threshold = (u32)-1;
 	conf->retry_short = (u32)-1;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index c1acda2..d60de18 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -128,7 +128,6 @@ enum wl_mode {
 
 /* dongle configuration */
 struct brcmf_cfg80211_conf {
-	u32 mode;		/* adhoc , infrastructure or ap */
 	u32 frag_threshold;
 	u32 rts_threshold;
 	u32 retry_short;
-- 
1.7.10.4


