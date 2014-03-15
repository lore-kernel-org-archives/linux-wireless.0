Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:45742 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958AbaCOQSe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2014 12:18:34 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 5/5] brcmfmac: remove mode field from brcmf_cfg80211_vif structure
Date: Sat, 15 Mar 2014 17:18:21 +0100
Message-ID: <1394900301-15417-6-git-send-email-arend@broadcom.com> (sfid-20140315_171841_885922_B00599B0)
In-Reply-To: <1394900301-15417-1-git-send-email-arend@broadcom.com>
References: <1394900301-15417-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The nl80211 iftype was converted to a mode value and stored in
brcmf_cfg80211_vif structure. The value was used only within
brcmfmac driver to decide execution of conditional code. Better
use wireless_dev::iftype for that as the wdev is contained in
the brcmf_cfg80211_vif structure.

Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |    6 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   60 +++++++-------------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   17 ------
 3 files changed, 21 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index fc4f98b..f3445ac 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -797,7 +797,8 @@ static s32 brcmf_p2p_run_escan(struct brcmf_cfg80211_info *cfg,
 			/* SOCIAL CHANNELS 1, 6, 11 */
 			search_state = WL_P2P_DISC_ST_SEARCH;
 			brcmf_dbg(INFO, "P2P SEARCH PHASE START\n");
-		} else if (dev != NULL && vif->mode == WL_MODE_AP) {
+		} else if (dev != NULL &&
+			   vif->wdev.iftype == NL80211_IFTYPE_P2P_GO) {
 			/* If you are already a GO, then do SEARCH only */
 			brcmf_dbg(INFO, "Already a GO. Do SEARCH Only\n");
 			search_state = WL_P2P_DISC_ST_SEARCH;
@@ -2256,7 +2257,6 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
 	struct brcmf_cfg80211_vif *vif;
 	enum brcmf_fil_p2p_if_types iftype;
-	enum wl_mode mode;
 	int err;
 
 	if (brcmf_cfg80211_vif_event_armed(cfg))
@@ -2267,11 +2267,9 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 	switch (type) {
 	case NL80211_IFTYPE_P2P_CLIENT:
 		iftype = BRCMF_FIL_P2P_IF_CLIENT;
-		mode = WL_MODE_BSS;
 		break;
 	case NL80211_IFTYPE_P2P_GO:
 		iftype = BRCMF_FIL_P2P_IF_GO;
-		mode = WL_MODE_AP;
 		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
 		return brcmf_p2p_create_p2pdev(&cfg->p2p, wiphy,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index adbd5b7..9f75afb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -494,6 +494,19 @@ brcmf_configure_arp_offload(struct brcmf_if *ifp, bool enable)
 	return err;
 }
 
+static bool brcmf_is_apmode(struct brcmf_cfg80211_vif *vif)
+{
+	enum nl80211_iftype iftype;
+
+	iftype = vif->wdev.iftype;
+	return iftype == NL80211_IFTYPE_AP || iftype == NL80211_IFTYPE_P2P_GO;
+}
+
+static bool brcmf_is_ibssmode(struct brcmf_cfg80211_vif *vif)
+{
+	return vif->wdev.iftype == NL80211_IFTYPE_ADHOC;
+}
+
 static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 						     const char *name,
 						     enum nl80211_iftype type,
@@ -654,7 +667,6 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 			  type);
 		return -EOPNOTSUPP;
 	case NL80211_IFTYPE_ADHOC:
-		vif->mode = WL_MODE_IBSS;
 		infra = 0;
 		break;
 	case NL80211_IFTYPE_STATION:
@@ -670,12 +682,10 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 			 */
 			return 0;
 		}
-		vif->mode = WL_MODE_BSS;
 		infra = 1;
 		break;
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
-		vif->mode = WL_MODE_AP;
 		ap = 1;
 		break;
 	default:
@@ -699,7 +709,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 			err = -EAGAIN;
 			goto done;
 		}
-		brcmf_dbg(INFO, "IF Type = %s\n", (vif->mode == WL_MODE_IBSS) ?
+		brcmf_dbg(INFO, "IF Type = %s\n", brcmf_is_ibssmode(vif) ?
 			  "Adhoc" : "Infra");
 	}
 	ndev->ieee80211_ptr->iftype = type;
@@ -1923,7 +1933,7 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *ndev,
 		brcmf_dbg(CONN, "Setting the key index %d\n", key.index);
 		memcpy(key.data, params->key, key.len);
 
-		if ((ifp->vif->mode != WL_MODE_AP) &&
+		if (!brcmf_is_apmode(ifp->vif) &&
 		    (params->cipher == WLAN_CIPHER_SUITE_TKIP)) {
 			brcmf_dbg(CONN, "Swapping RX/TX MIC key\n");
 			memcpy(keybuf, &key.data[24], sizeof(keybuf));
@@ -2022,7 +2032,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_WEP104\n");
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
-		if (ifp->vif->mode != WL_MODE_AP) {
+		if (!brcmf_is_apmode(ifp->vif)) {
 			brcmf_dbg(CONN, "Swapping RX/TX MIC key\n");
 			memcpy(keybuf, &key.data[24], sizeof(keybuf));
 			memcpy(&key.data[24], &key.data[16], sizeof(keybuf));
@@ -2183,7 +2193,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
-	if (ifp->vif->mode == WL_MODE_AP) {
+	if (brcmf_is_apmode(ifp->vif)) {
 		memcpy(&sta_info_le, mac, ETH_ALEN);
 		err = brcmf_fil_iovar_data_get(ifp, "sta_info",
 					       &sta_info_le,
@@ -2200,7 +2210,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 		}
 		brcmf_dbg(TRACE, "STA idle time : %d ms, connected time :%d sec\n",
 			  sinfo->inactive_time, sinfo->connected_time);
-	} else if (ifp->vif->mode == WL_MODE_BSS) {
+	} else if (ifp->vif->wdev.iftype == NL80211_IFTYPE_STATION) {
 		if (memcmp(mac, bssid, ETH_ALEN)) {
 			brcmf_err("Wrong Mac address cfg_mac-%pM wl_bssid-%pM\n",
 				  mac, bssid);
@@ -2482,11 +2492,6 @@ CleanUp:
 	return err;
 }
 
-static bool brcmf_is_ibssmode(struct brcmf_cfg80211_vif *vif)
-{
-	return vif->mode == WL_MODE_IBSS;
-}
-
 static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg,
 				 struct brcmf_if *ifp)
 {
@@ -4259,32 +4264,6 @@ static struct cfg80211_ops wl_cfg80211_ops = {
 	CFG80211_TESTMODE_CMD(brcmf_cfg80211_testmode)
 };
 
-static s32 brcmf_nl80211_iftype_to_mode(enum nl80211_iftype type)
-{
-	switch (type) {
-	case NL80211_IFTYPE_AP_VLAN:
-	case NL80211_IFTYPE_WDS:
-	case NL80211_IFTYPE_MONITOR:
-	case NL80211_IFTYPE_MESH_POINT:
-		return -ENOTSUPP;
-	case NL80211_IFTYPE_ADHOC:
-		return WL_MODE_IBSS;
-	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_P2P_CLIENT:
-		return WL_MODE_BSS;
-	case NL80211_IFTYPE_AP:
-	case NL80211_IFTYPE_P2P_GO:
-		return WL_MODE_AP;
-	case NL80211_IFTYPE_P2P_DEVICE:
-		return WL_MODE_P2P;
-	case NL80211_IFTYPE_UNSPECIFIED:
-	default:
-		break;
-	}
-
-	return -EINVAL;
-}
-
 static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
 {
 	/* scheduled scan settings */
@@ -4409,7 +4388,6 @@ struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
 	vif->wdev.wiphy = cfg->wiphy;
 	vif->wdev.iftype = type;
 
-	vif->mode = brcmf_nl80211_iftype_to_mode(type);
 	vif->pm_block = pm_block;
 	vif->roam_off = -1;
 
@@ -4703,7 +4681,7 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 	s32 err = 0;
 	u16 reason;
 
-	if (ifp->vif->mode == WL_MODE_AP) {
+	if (brcmf_is_apmode(ifp->vif)) {
 		err = brcmf_notify_connect_status_ap(cfg, ndev, e, data);
 	} else if (brcmf_is_linkup(e)) {
 		brcmf_dbg(CONN, "Linkup\n");
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 5715bb0..283c525 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -89,21 +89,6 @@ enum brcmf_scan_status {
 	BRCMF_SCAN_STATUS_SUPPRESS,
 };
 
-/**
- * enum wl_mode - driver mode of virtual interface.
- *
- * @WL_MODE_BSS: connects to BSS.
- * @WL_MODE_IBSS: operate as ad-hoc.
- * @WL_MODE_AP: operate as access-point.
- * @WL_MODE_P2P: provide P2P discovery.
- */
-enum wl_mode {
-	WL_MODE_BSS,
-	WL_MODE_IBSS,
-	WL_MODE_AP,
-	WL_MODE_P2P
-};
-
 /* dongle configuration */
 struct brcmf_cfg80211_conf {
 	u32 frag_threshold;
@@ -193,7 +178,6 @@ struct vif_saved_ie {
  * @ifp: lower layer interface pointer
  * @wdev: wireless device.
  * @profile: profile information.
- * @mode: operating mode.
  * @roam_off: roaming state.
  * @sme_state: SME state using enum brcmf_vif_status bits.
  * @pm_block: power-management blocked.
@@ -204,7 +188,6 @@ struct brcmf_cfg80211_vif {
 	struct brcmf_if *ifp;
 	struct wireless_dev wdev;
 	struct brcmf_cfg80211_profile profile;
-	s32 mode;
 	s32 roam_off;
 	unsigned long sme_state;
 	bool pm_block;
-- 
1.7.9.5

