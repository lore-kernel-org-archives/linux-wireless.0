Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4527 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755896Ab2JVUz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 16:55:58 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/12] brcmfmac: rename check_sys_up() to check_vif_up()
Date: Mon, 22 Oct 2012 13:55:37 -0700
Message-ID: <1350939341-17687-9-git-send-email-frankyl@broadcom.com> (sfid-20121022_225607_387813_F016F87A)
In-Reply-To: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
References: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The function now return the status for a virtual interface so
it seems better rename the function to understand what it does.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   48 ++++++++++----------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index da48894a..5ce0068 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -98,7 +98,7 @@ static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
 
 static u32 brcmf_dbg_level = WL_DBG_ERR;
 
-static bool check_sys_up(struct brcmf_cfg80211_vif *vif)
+static bool check_vif_up(struct brcmf_cfg80211_vif *vif)
 {
 	if (!test_bit(BRCMF_VIF_STATUS_READY, &vif->sme_state)) {
 		WL_INFO("device is not ready : status (%lu)\n",
@@ -521,7 +521,7 @@ static void brcmf_set_mpc(struct net_device *ndev, int mpc)
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err = 0;
 
-	if (check_sys_up(ifp->vif)) {
+	if (check_vif_up(ifp->vif)) {
 		err = brcmf_fil_iovar_int_set(ifp, "mpc", mpc);
 		if (err) {
 			WL_ERR("fail to set mpc\n");
@@ -1034,7 +1034,7 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 
 	WL_TRACE("Enter\n");
 
-	if (!check_sys_up(container_of(request->wdev,
+	if (!check_vif_up(container_of(request->wdev,
 				       struct brcmf_cfg80211_vif, wdev)))
 		return -EIO;
 
@@ -1095,7 +1095,7 @@ static s32 brcmf_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(ifp->vif))
+	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
 	if (changed & WIPHY_PARAM_RTS_THRESHOLD &&
@@ -1197,7 +1197,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	s32 bcnprd;
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(ifp->vif))
+	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
 	if (params->ssid)
@@ -1336,7 +1336,7 @@ brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *ndev)
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(ifp->vif))
+	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
 	brcmf_link_down(cfg);
@@ -1614,7 +1614,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(ifp->vif))
+	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
 	if (!sme->ssid) {
@@ -1704,7 +1704,7 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 	s32 err = 0;
 
 	WL_TRACE("Enter. Reason code = %d\n", reason_code);
-	if (!check_sys_up(ifp->vif))
+	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
 	clear_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state);
@@ -1736,7 +1736,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 	s32 dbm = MBM_TO_DBM(mbm);
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(ifp->vif))
+	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
 	switch (type) {
@@ -1781,7 +1781,7 @@ static s32 brcmf_cfg80211_get_tx_power(struct wiphy *wiphy, s32 *dbm)
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(ifp->vif))
+	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
 	err = brcmf_fil_iovar_int_get(ifp, "qtxpower", &txpwrdbm);
@@ -1809,7 +1809,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	WL_TRACE("Enter\n");
 	WL_CONN("key index (%d)\n", key_idx);
-	if (!check_sys_up(ifp->vif))
+	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
 	err = brcmf_fil_bsscfg_int_get(ifp, "wsec", &wsec);
@@ -1925,7 +1925,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	WL_TRACE("Enter\n");
 	WL_CONN("key index (%d)\n", key_idx);
-	if (!check_sys_up(ifp->vif))
+	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
 	if (mac_addr) {
@@ -2013,7 +2013,7 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(ifp->vif))
+	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
 	memset(&key, 0, sizeof(key));
@@ -2054,7 +2054,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	WL_TRACE("Enter\n");
 	WL_CONN("key index (%d)\n", key_idx);
-	if (!check_sys_up(ifp->vif))
+	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
 	memset(&params, 0, sizeof(params));
@@ -2121,7 +2121,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_sta_info_le sta_info_le;
 
 	WL_TRACE("Enter, MAC %pM\n", mac);
-	if (!check_sys_up(ifp->vif))
+	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
 	if (cfg->conf->mode == WL_MODE_AP) {
@@ -2200,7 +2200,7 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 	 * FW later while initializing the dongle
 	 */
 	cfg->pwr_save = enabled;
-	if (!check_sys_up(ifp->vif)) {
+	if (!check_vif_up(ifp->vif)) {
 
 		WL_INFO("Device is not ready, storing the value in cfg_info struct\n");
 		goto done;
@@ -2236,7 +2236,7 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *ndev,
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(ifp->vif))
+	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
 	/* addr param is always NULL. ignore it */
@@ -2998,7 +2998,7 @@ static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 	 */
 	WL_TRACE("Enter\n");
 
-	if (check_sys_up(ifp->vif))
+	if (check_vif_up(ifp->vif))
 		brcmf_invoke_iscan(wiphy_to_cfg(wiphy));
 
 	WL_TRACE("Exit\n");
@@ -3026,7 +3026,7 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 	 */
 	if ((test_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state) ||
 	     test_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state)) &&
-	     check_sys_up(ifp->vif)) {
+	     check_vif_up(ifp->vif)) {
 		WL_INFO("Disassociating from AP"
 			" while entering suspend state\n");
 		brcmf_link_down(cfg);
@@ -3089,7 +3089,7 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 	int pmkid_len;
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(ifp->vif))
+	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
 	pmkid_len = le32_to_cpu(pmkids->npmkid);
@@ -3128,7 +3128,7 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 	int i, pmkid_len;
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(ifp->vif))
+	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
 	memcpy(&pmkid.pmkid[0].BSSID, pmksa->bssid, ETH_ALEN);
@@ -3177,7 +3177,7 @@ brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *ndev)
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(ifp->vif))
+	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
 	memset(cfg->pmk_list, 0, sizeof(*cfg->pmk_list));
@@ -4128,7 +4128,7 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 
 	WL_TRACE("Enter %pM\n", mac);
 
-	if (!check_sys_up(ifp->vif))
+	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
 	memcpy(&scbval.ea, mac, ETH_ALEN);
@@ -5288,7 +5288,7 @@ static s32 __brcmf_cfg80211_down(struct brcmf_cfg80211_info *cfg)
 	 */
 	if ((test_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state) ||
 	     test_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state)) &&
-	     check_sys_up(ifp->vif)) {
+	     check_vif_up(ifp->vif)) {
 		WL_INFO("Disassociating from AP");
 		brcmf_link_down(cfg);
 
-- 
1.7.9.5


