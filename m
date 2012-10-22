Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4480 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439Ab2JVUzx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 16:55:53 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/12] brcmfmac: use vif struct to check_sys_up()
 function
Date: Mon, 22 Oct 2012 13:55:32 -0700
Message-ID: <1350939341-17687-4-git-send-email-frankyl@broadcom.com> (sfid-20121022_225600_245184_A25D3AD8)
In-Reply-To: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
References: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

This checks the status that will soon be moved to virtual
interface data so preparing for that use the structure
brcmf_cfg80211_vif as parameter instead.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meulemen <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  103 +++++++++++---------
 1 file changed, 59 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index d01396d..d6a70f7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -98,9 +98,10 @@ static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
 
 static u32 brcmf_dbg_level = WL_DBG_ERR;
 
-static bool check_sys_up(struct wiphy *wiphy)
+static bool check_sys_up(struct brcmf_cfg80211_vif *vif)
 {
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_info *cfg = wdev_priv(&vif->wdev);
+
 	if (!test_bit(WL_STATUS_READY, &cfg->status)) {
 		WL_INFO("device is not ready : status (%d)\n",
 			(int)cfg->status);
@@ -1028,8 +1029,7 @@ scan_out:
 }
 
 static s32
-brcmf_cfg80211_scan(struct wiphy *wiphy,
-		 struct cfg80211_scan_request *request)
+brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
 	struct net_device *ndev = request->wdev->netdev;
 	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
@@ -1037,7 +1037,8 @@ brcmf_cfg80211_scan(struct wiphy *wiphy,
 
 	WL_TRACE("Enter\n");
 
-	if (!check_sys_up(wiphy))
+	if (!check_sys_up(container_of(request->wdev,
+				       struct brcmf_cfg80211_vif, wdev)))
 		return -EIO;
 
 	if (cfg->iscan_on)
@@ -1093,10 +1094,11 @@ static s32 brcmf_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct net_device *ndev = cfg_to_ndev(cfg);
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(wiphy))
+	if (!check_sys_up(ifp->vif))
 		return -EIO;
 
 	if (changed & WIPHY_PARAM_RTS_THRESHOLD &&
@@ -1189,7 +1191,8 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 		      struct cfg80211_ibss_params *params)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct brcmf_join_params join_params;
 	size_t join_params_size = 0;
 	s32 err = 0;
@@ -1197,7 +1200,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	s32 bcnprd;
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(wiphy))
+	if (!check_sys_up(ifp->vif))
 		return -EIO;
 
 	if (params->ssid)
@@ -1332,10 +1335,11 @@ static s32
 brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *ndev)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(wiphy))
+	if (!check_sys_up(ifp->vif))
 		return -EIO;
 
 	brcmf_link_down(cfg);
@@ -1603,7 +1607,8 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		    struct cfg80211_connect_params *sme)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct ieee80211_channel *chan = sme->channel;
 	struct brcmf_join_params join_params;
 	size_t join_params_size;
@@ -1612,7 +1617,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(wiphy))
+	if (!check_sys_up(ifp->vif))
 		return -EIO;
 
 	if (!sme->ssid) {
@@ -1696,12 +1701,13 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 		       u16 reason_code)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct brcmf_scb_val_le scbval;
 	s32 err = 0;
 
 	WL_TRACE("Enter. Reason code = %d\n", reason_code);
-	if (!check_sys_up(wiphy))
+	if (!check_sys_up(ifp->vif))
 		return -EIO;
 
 	clear_bit(WL_STATUS_CONNECTED, &cfg->status);
@@ -1725,14 +1731,15 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 {
 
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
+	struct net_device *ndev = cfg_to_ndev(cfg);
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	u16 txpwrmw;
 	s32 err = 0;
 	s32 disable = 0;
 	s32 dbm = MBM_TO_DBM(mbm);
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(wiphy))
+	if (!check_sys_up(ifp->vif))
 		return -EIO;
 
 	switch (type) {
@@ -1771,16 +1778,16 @@ done:
 static s32 brcmf_cfg80211_get_tx_power(struct wiphy *wiphy, s32 *dbm)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	struct net_device *ndev = cfg_to_ndev(cfg);
+	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
 	s32 txpwrdbm;
 	u8 result;
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(wiphy))
+	if (!check_sys_up(ifp->vif))
 		return -EIO;
 
-	err = brcmf_fil_iovar_int_get(netdev_priv(ndev), "qtxpower", &txpwrdbm);
+	err = brcmf_fil_iovar_int_get(ifp, "qtxpower", &txpwrdbm);
 	if (err) {
 		WL_ERR("error (%d)\n", err);
 		goto done;
@@ -1798,16 +1805,17 @@ static s32
 brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 			       u8 key_idx, bool unicast, bool multicast)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	u32 index;
 	u32 wsec;
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
 	WL_CONN("key index (%d)\n", key_idx);
-	if (!check_sys_up(wiphy))
+	if (!check_sys_up(ifp->vif))
 		return -EIO;
 
-	err = brcmf_fil_bsscfg_int_get(netdev_priv(ndev), "wsec", &wsec);
+	err = brcmf_fil_bsscfg_int_get(ifp, "wsec", &wsec);
 	if (err) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		goto done;
@@ -1816,7 +1824,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 	if (wsec & WEP_ENABLED) {
 		/* Just select a new current key */
 		index = key_idx;
-		err = brcmf_fil_cmd_int_set(netdev_priv(ndev),
+		err = brcmf_fil_cmd_int_set(ifp,
 					    BRCMF_C_SET_KEY_PRIMARY, index);
 		if (err)
 			WL_ERR("error (%d)\n", err);
@@ -1911,6 +1919,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		    struct key_params *params)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_wsec_key key;
 	s32 val;
 	s32 wsec;
@@ -1919,7 +1928,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	WL_TRACE("Enter\n");
 	WL_CONN("key index (%d)\n", key_idx);
-	if (!check_sys_up(wiphy))
+	if (!check_sys_up(ifp->vif))
 		return -EIO;
 
 	if (mac_addr) {
@@ -1981,13 +1990,13 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	if (err)
 		goto done;
 
-	err = brcmf_fil_bsscfg_int_get(netdev_priv(ndev), "wsec", &wsec);
+	err = brcmf_fil_bsscfg_int_get(ifp, "wsec", &wsec);
 	if (err) {
 		WL_ERR("get wsec error (%d)\n", err);
 		goto done;
 	}
 	wsec |= val;
-	err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev), "wsec", wsec);
+	err = brcmf_fil_bsscfg_int_set(ifp, "wsec", wsec);
 	if (err) {
 		WL_ERR("set wsec error (%d)\n", err);
 		goto done;
@@ -2002,11 +2011,12 @@ static s32
 brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 		    u8 key_idx, bool pairwise, const u8 *mac_addr)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_wsec_key key;
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(wiphy))
+	if (!check_sys_up(ifp->vif))
 		return -EIO;
 
 	memset(&key, 0, sizeof(key));
@@ -2039,19 +2049,20 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 		    void (*callback) (void *cookie, struct key_params * params))
 {
 	struct key_params params;
-	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct brcmf_cfg80211_security *sec;
 	s32 wsec;
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
 	WL_CONN("key index (%d)\n", key_idx);
-	if (!check_sys_up(wiphy))
+	if (!check_sys_up(ifp->vif))
 		return -EIO;
 
 	memset(&params, 0, sizeof(params));
 
-	err = brcmf_fil_bsscfg_int_get(netdev_priv(ndev), "wsec", &wsec);
+	err = brcmf_fil_bsscfg_int_get(ifp, "wsec", &wsec);
 	if (err) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
@@ -2103,7 +2114,8 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			   u8 *mac, struct station_info *sinfo)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct brcmf_scb_val_le scb_val;
 	int rssi;
 	s32 rate;
@@ -2112,12 +2124,12 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_sta_info_le sta_info_le;
 
 	WL_TRACE("Enter, MAC %pM\n", mac);
-	if (!check_sys_up(wiphy))
+	if (!check_sys_up(ifp->vif))
 		return -EIO;
 
 	if (cfg->conf->mode == WL_MODE_AP) {
 		memcpy(&sta_info_le, mac, ETH_ALEN);
-		err = brcmf_fil_iovar_data_get(netdev_priv(ndev), "sta_info",
+		err = brcmf_fil_iovar_data_get(ifp, "sta_info",
 					       &sta_info_le,
 					       sizeof(sta_info_le));
 		if (err < 0) {
@@ -2140,7 +2152,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			goto done;
 		}
 		/* Report the current tx rate */
-	err = brcmf_fil_cmd_int_get(netdev_priv(ndev), BRCMF_C_GET_RATE, &rate);
+	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_RATE, &rate);
 		if (err) {
 			WL_ERR("Could not get rate (%d)\n", err);
 			goto done;
@@ -2152,8 +2164,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 
 		if (test_bit(WL_STATUS_CONNECTED, &cfg->status)) {
 			memset(&scb_val, 0, sizeof(scb_val));
-		err = brcmf_fil_cmd_data_get(netdev_priv(ndev),
-					     BRCMF_C_GET_RSSI, &scb_val,
+		err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_RSSI, &scb_val,
 					     sizeof(scb_val));
 			if (err) {
 				WL_ERR("Could not get rssi (%d)\n", err);
@@ -2216,6 +2227,7 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *ndev,
 			     const u8 *addr,
 			     const struct cfg80211_bitrate_mask *mask)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcm_rateset_le rateset_le;
 	s32 rate;
 	s32 val;
@@ -2225,12 +2237,12 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *ndev,
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(wiphy))
+	if (!check_sys_up(ifp->vif))
 		return -EIO;
 
 	/* addr param is always NULL. ignore it */
 	/* Get current rateset */
-	err = brcmf_fil_cmd_data_get(netdev_priv(ndev), BRCM_GET_CURR_RATESET,
+	err = brcmf_fil_cmd_data_get(ifp, BRCM_GET_CURR_RATESET,
 				     &rateset_le, sizeof(rateset_le));
 	if (err) {
 		WL_ERR("could not get current rateset (%d)\n", err);
@@ -2258,8 +2270,8 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *ndev,
 	 *      Set rate override,
 	 *      Since the is a/b/g-blind, both a/bg_rate are enforced.
 	 */
-	err_bg = brcmf_fil_iovar_int_set(netdev_priv(ndev), "bg_rate", rate);
-	err_a = brcmf_fil_iovar_int_set(netdev_priv(ndev), "a_rate", rate);
+	err_bg = brcmf_fil_iovar_int_set(ifp, "bg_rate", rate);
+	err_a = brcmf_fil_iovar_int_set(ifp, "a_rate", rate);
 	if (err_bg && err_a) {
 		WL_ERR("could not set fixed rate (%d) (%d)\n", err_bg, err_a);
 		err = err_bg | err_a;
@@ -3072,13 +3084,14 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 			 struct cfg80211_pmksa *pmksa)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct pmkid_list *pmkids = &cfg->pmk_list->pmkids;
 	s32 err = 0;
 	int i;
 	int pmkid_len;
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(wiphy))
+	if (!check_sys_up(ifp->vif))
 		return -EIO;
 
 	pmkid_len = le32_to_cpu(pmkids->npmkid);
@@ -3111,12 +3124,13 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 		      struct cfg80211_pmksa *pmksa)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct pmkid_list pmkid;
 	s32 err = 0;
 	int i, pmkid_len;
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(wiphy))
+	if (!check_sys_up(ifp->vif))
 		return -EIO;
 
 	memcpy(&pmkid.pmkid[0].BSSID, pmksa->bssid, ETH_ALEN);
@@ -3161,10 +3175,11 @@ static s32
 brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *ndev)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(wiphy))
+	if (!check_sys_up(ifp->vif))
 		return -EIO;
 
 	memset(cfg->pmk_list, 0, sizeof(*cfg->pmk_list));
@@ -4106,6 +4121,7 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 			   u8 *mac)
 {
 	struct brcmf_scb_val_le scbval;
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err;
 
 	if (!mac)
@@ -4113,13 +4129,12 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 
 	WL_TRACE("Enter %pM\n", mac);
 
-	if (!check_sys_up(wiphy))
+	if (!check_sys_up(ifp->vif))
 		return -EIO;
 
 	memcpy(&scbval.ea, mac, ETH_ALEN);
 	scbval.val = cpu_to_le32(WLAN_REASON_DEAUTH_LEAVING);
-	err = brcmf_fil_cmd_data_set(netdev_priv(ndev),
-				     BRCMF_C_SCB_DEAUTHENTICATE_FOR_REASON,
+	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCB_DEAUTHENTICATE_FOR_REASON,
 				     &scbval, sizeof(scbval));
 	if (err)
 		WL_ERR("SCB_DEAUTHENTICATE_FOR_REASON failed %d\n", err);
-- 
1.7.9.5


