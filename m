Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4482 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085Ab2JVUzx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 16:55:53 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/12] brcmfmac: separate connection status from
 scanning status
Date: Mon, 22 Oct 2012 13:55:33 -0700
Message-ID: <1350939341-17687-5-git-send-email-frankyl@broadcom.com> (sfid-20121022_225601_288419_FCE1DE29)
In-Reply-To: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
References: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The connection status is to be kept per virtual interface and
the scanning status is for device. So they need to be separated
for multiple interface support.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  235 +++++++++++---------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   41 +++-
 2 files changed, 156 insertions(+), 120 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index d6a70f7..13971d1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -100,11 +100,9 @@ static u32 brcmf_dbg_level = WL_DBG_ERR;
 
 static bool check_sys_up(struct brcmf_cfg80211_vif *vif)
 {
-	struct brcmf_cfg80211_info *cfg = wdev_priv(&vif->wdev);
-
-	if (!test_bit(WL_STATUS_READY, &cfg->status)) {
-		WL_INFO("device is not ready : status (%d)\n",
-			(int)cfg->status);
+	if (!test_bit(BRCMF_VIF_STATUS_READY, &vif->sme_state)) {
+		WL_INFO("device is not ready : status (%lu)\n",
+			vif->sme_state);
 		return false;
 	}
 	return true;
@@ -457,6 +455,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 			 enum nl80211_iftype type, u32 *flags,
 			 struct vif_params *params)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	s32 infra = 0;
 	s32 ap = 0;
@@ -488,7 +487,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	if (ap) {
-		set_bit(WL_STATUS_AP_CREATING, &cfg->status);
+		set_bit(BRCMF_VIF_STATUS_AP_CREATING, &ifp->vif->sme_state);
 		if (!cfg->ap_info)
 			cfg->ap_info = kzalloc(sizeof(*cfg->ap_info),
 					       GFP_KERNEL);
@@ -519,11 +518,11 @@ done:
 
 static void brcmf_set_mpc(struct net_device *ndev, int mpc)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err = 0;
-	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 
-	if (test_bit(WL_STATUS_READY, &cfg->status)) {
-		err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "mpc", mpc);
+	if (check_sys_up(ifp->vif)) {
+		err = brcmf_fil_iovar_int_set(ifp, "mpc", mpc);
 		if (err) {
 			WL_ERR("fail to set mpc\n");
 			return;
@@ -622,6 +621,7 @@ brcmf_cfg80211_iscan(struct wiphy *wiphy, struct net_device *ndev,
 		     struct cfg80211_scan_request *request,
 		     struct cfg80211_ssid *this_ssid)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 	struct cfg80211_ssid *ssids;
 	struct brcmf_cfg80211_scan_req *sr = cfg->scan_req_int;
@@ -631,18 +631,17 @@ brcmf_cfg80211_iscan(struct wiphy *wiphy, struct net_device *ndev,
 	s32 err = 0;
 	u32 SSID_len;
 
-	if (test_bit(WL_STATUS_SCANNING, &cfg->status)) {
-		WL_ERR("Scanning already : status (%lu)\n", cfg->status);
+	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
+		WL_ERR("Scanning already: status (%lu)\n", cfg->scan_status);
 		return -EAGAIN;
 	}
-	if (test_bit(WL_STATUS_SCAN_ABORTING, &cfg->status)) {
-		WL_ERR("Scanning being aborted : status (%lu)\n",
-		       cfg->status);
+	if (test_bit(BRCMF_SCAN_STATUS_ABORT, &cfg->scan_status)) {
+		WL_ERR("Scanning being aborted: status (%lu)\n",
+		       cfg->scan_status);
 		return -EAGAIN;
 	}
-	if (test_bit(WL_STATUS_CONNECTING, &cfg->status)) {
-		WL_ERR("Connecting : status (%lu)\n",
-		       cfg->status);
+	if (test_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state)) {
+		WL_ERR("Connecting: status (%lu)\n", ifp->vif->sme_state);
 		return -EAGAIN;
 	}
 
@@ -660,7 +659,7 @@ brcmf_cfg80211_iscan(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	cfg->scan_request = request;
-	set_bit(WL_STATUS_SCANNING, &cfg->status);
+	set_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 	if (iscan_req) {
 		err = brcmf_do_iscan(cfg);
 		if (!err)
@@ -682,15 +681,14 @@ brcmf_cfg80211_iscan(struct wiphy *wiphy, struct net_device *ndev,
 		}
 
 		passive_scan = cfg->active_scan ? 0 : 1;
-		err = brcmf_fil_cmd_int_set(netdev_priv(ndev),
-					    BRCMF_C_SET_PASSIVE_SCAN,
+		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PASSIVE_SCAN,
 					    passive_scan);
 		if (err) {
 			WL_ERR("WLC_SET_PASSIVE_SCAN error (%d)\n", err);
 			goto scan_out;
 		}
 		brcmf_set_mpc(ndev, 0);
-		err = brcmf_fil_cmd_data_set(netdev_priv(ndev), BRCMF_C_SCAN,
+		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCAN,
 					     &sr->ssid_le, sizeof(sr->ssid_le));
 		if (err) {
 			if (err == -EBUSY)
@@ -707,7 +705,7 @@ brcmf_cfg80211_iscan(struct wiphy *wiphy, struct net_device *ndev,
 	return 0;
 
 scan_out:
-	clear_bit(WL_STATUS_SCANNING, &cfg->status);
+	clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 	cfg->scan_request = NULL;
 	return err;
 }
@@ -844,7 +842,7 @@ brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 		cfg80211_scan_done(scan_request, aborted);
 		brcmf_set_mpc(ndev, 1);
 	}
-	if (!test_and_clear_bit(WL_STATUS_SCANNING, &cfg->status)) {
+	if (!test_and_clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
 		WL_ERR("Scan complete while device not scanning\n");
 		return -EPERM;
 	}
@@ -932,6 +930,7 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 		     struct cfg80211_scan_request *request,
 		     struct cfg80211_ssid *this_ssid)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 	struct cfg80211_ssid *ssids;
 	struct brcmf_cfg80211_scan_req *sr = cfg->scan_req_int;
@@ -943,18 +942,17 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 
 	WL_SCAN("START ESCAN\n");
 
-	if (test_bit(WL_STATUS_SCANNING, &cfg->status)) {
-		WL_ERR("Scanning already : status (%lu)\n", cfg->status);
+	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
+		WL_ERR("Scanning already: status (%lu)\n", cfg->scan_status);
 		return -EAGAIN;
 	}
-	if (test_bit(WL_STATUS_SCAN_ABORTING, &cfg->status)) {
-		WL_ERR("Scanning being aborted : status (%lu)\n",
-		       cfg->status);
+	if (test_bit(BRCMF_SCAN_STATUS_ABORT, &cfg->scan_status)) {
+		WL_ERR("Scanning being aborted: status (%lu)\n",
+		       cfg->scan_status);
 		return -EAGAIN;
 	}
-	if (test_bit(WL_STATUS_CONNECTING, &cfg->status)) {
-		WL_ERR("Connecting : status (%lu)\n",
-		       cfg->status);
+	if (test_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state)) {
+		WL_ERR("Connecting: status (%lu)\n", ifp->vif->sme_state);
 		return -EAGAIN;
 	}
 
@@ -974,7 +972,7 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	cfg->scan_request = request;
-	set_bit(WL_STATUS_SCANNING, &cfg->status);
+	set_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 	if (escan_req) {
 		err = brcmf_do_escan(cfg, wiphy, ndev, request);
 		if (!err)
@@ -996,15 +994,14 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 			WL_SCAN("Broadcast scan\n");
 
 		passive_scan = cfg->active_scan ? 0 : 1;
-		err = brcmf_fil_cmd_int_set(netdev_priv(ndev),
-					    BRCMF_C_SET_PASSIVE_SCAN,
+		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PASSIVE_SCAN,
 					    passive_scan);
 		if (err) {
 			WL_ERR("WLC_SET_PASSIVE_SCAN error (%d)\n", err);
 			goto scan_out;
 		}
 		brcmf_set_mpc(ndev, 0);
-		err = brcmf_fil_cmd_data_set(netdev_priv(ndev), BRCMF_C_SCAN,
+		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCAN,
 					     &sr->ssid_le, sizeof(sr->ssid_le));
 		if (err) {
 			if (err == -EBUSY)
@@ -1021,7 +1018,7 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 	return 0;
 
 scan_out:
-	clear_bit(WL_STATUS_SCANNING, &cfg->status);
+	clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 	if (timer_pending(&cfg->escan_timeout))
 		del_timer_sync(&cfg->escan_timeout);
 	cfg->scan_request = NULL;
@@ -1210,7 +1207,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 		return -EOPNOTSUPP;
 	}
 
-	set_bit(WL_STATUS_CONNECTING, &cfg->status);
+	set_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state);
 
 	if (params->bssid)
 		WL_CONN("BSSID: %pM\n", params->bssid);
@@ -1251,7 +1248,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	if (params->privacy)
 		wsec |= WEP_ENABLED;
 
-	err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "wsec", wsec);
+	err = brcmf_fil_iovar_int_set(ifp, "wsec", wsec);
 	if (err) {
 		WL_ERR("wsec failed (%d)\n", err);
 		goto done;
@@ -1263,7 +1260,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	else
 		bcnprd = 100;
 
-	err = brcmf_fil_cmd_int_set(netdev_priv(ndev), BRCM_SET_BCNPRD, bcnprd);
+	err = brcmf_fil_cmd_int_set(ifp, BRCM_SET_BCNPRD, bcnprd);
 	if (err) {
 		WL_ERR("WLC_SET_BCNPRD failed (%d)\n", err);
 		goto done;
@@ -1305,7 +1302,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 
 		/* set channel for starter */
 		target_channel = cfg->channel;
-		err = brcmf_fil_cmd_int_set(netdev_priv(ndev), BRCM_SET_CHANNEL,
+		err = brcmf_fil_cmd_int_set(ifp, BRCM_SET_CHANNEL,
 					    target_channel);
 		if (err) {
 			WL_ERR("WLC_SET_CHANNEL failed (%d)\n", err);
@@ -1317,7 +1314,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	cfg->ibss_starter = false;
 
 
-	err = brcmf_fil_cmd_data_set(netdev_priv(ndev), BRCMF_C_SET_SSID,
+	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
 				     &join_params, join_params_size);
 	if (err) {
 		WL_ERR("WLC_SET_SSID failed (%d)\n", err);
@@ -1326,7 +1323,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 
 done:
 	if (err)
-		clear_bit(WL_STATUS_CONNECTING, &cfg->status);
+		clear_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state);
 	WL_TRACE("Exit\n");
 	return err;
 }
@@ -1625,7 +1622,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		return -EOPNOTSUPP;
 	}
 
-	set_bit(WL_STATUS_CONNECTING, &cfg->status);
+	set_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state);
 
 	if (chan) {
 		cfg->channel =
@@ -1684,14 +1681,14 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 
 	brcmf_ch_to_chanspec(cfg->channel,
 			     &join_params, &join_params_size);
-	err = brcmf_fil_cmd_data_set(netdev_priv(ndev), BRCMF_C_SET_SSID,
+	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
 				     &join_params, join_params_size);
 	if (err)
 		WL_ERR("WLC_SET_SSID failed (%d)\n", err);
 
 done:
 	if (err)
-		clear_bit(WL_STATUS_CONNECTING, &cfg->status);
+		clear_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state);
 	WL_TRACE("Exit\n");
 	return err;
 }
@@ -1710,11 +1707,11 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 	if (!check_sys_up(ifp->vif))
 		return -EIO;
 
-	clear_bit(WL_STATUS_CONNECTED, &cfg->status);
+	clear_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state);
 
 	memcpy(&scbval.ea, &profile->bssid, ETH_ALEN);
 	scbval.val = cpu_to_le32(reason_code);
-	err = brcmf_fil_cmd_data_set(netdev_priv(ndev), BRCMF_C_DISASSOC,
+	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_DISASSOC,
 				     &scbval, sizeof(scbval));
 	if (err)
 		WL_ERR("error (%d)\n", err);
@@ -2162,10 +2159,11 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			WL_CONN("Rate %d Mbps\n", rate / 2);
 		}
 
-		if (test_bit(WL_STATUS_CONNECTED, &cfg->status)) {
+		if (test_bit(BRCMF_VIF_STATUS_CONNECTED,
+			     &ifp->vif->sme_state)) {
 			memset(&scb_val, 0, sizeof(scb_val));
-		err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_RSSI, &scb_val,
-					     sizeof(scb_val));
+			err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_RSSI,
+						     &scb_val, sizeof(scb_val));
 			if (err) {
 				WL_ERR("Could not get rssi (%d)\n", err);
 				goto done;
@@ -2190,6 +2188,7 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 	s32 pm;
 	s32 err = 0;
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_if *ifp = netdev_priv(ndev);
 
 	WL_TRACE("Enter\n");
 
@@ -2201,7 +2200,7 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 	 * FW later while initializing the dongle
 	 */
 	cfg->pwr_save = enabled;
-	if (!test_bit(WL_STATUS_READY, &cfg->status)) {
+	if (!check_sys_up(ifp->vif)) {
 
 		WL_INFO("Device is not ready, storing the value in cfg_info struct\n");
 		goto done;
@@ -2210,7 +2209,7 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 	pm = enabled ? PM_FAST : PM_OFF;
 	WL_INFO("power save %s\n", (pm ? "enabled" : "disabled"));
 
-	err = brcmf_fil_cmd_int_set(netdev_priv(ndev), BRCMF_C_SET_PM, pm);
+	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PM, pm);
 	if (err) {
 		if (err == -ENODEV)
 			WL_ERR("net_device is not ready yet\n");
@@ -2592,7 +2591,7 @@ static void brcmf_abort_scanning(struct brcmf_cfg80211_info *cfg)
 	struct escan_info *escan = &cfg->escan_info;
 	struct brcmf_ssid ssid;
 
-	set_bit(WL_STATUS_SCAN_ABORTING, &cfg->status);
+	set_bit(BRCMF_SCAN_STATUS_ABORT, &cfg->scan_status);
 	if (cfg->iscan_on) {
 		iscan->state = WL_ISCAN_STATE_IDLE;
 
@@ -2618,8 +2617,8 @@ static void brcmf_abort_scanning(struct brcmf_cfg80211_info *cfg)
 		escan->escan_state = WL_ESCAN_STATE_IDLE;
 		brcmf_notify_escan_complete(cfg, escan->ndev, true, true);
 	}
-	clear_bit(WL_STATUS_SCANNING, &cfg->status);
-	clear_bit(WL_STATUS_SCAN_ABORTING, &cfg->status);
+	clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
+	clear_bit(BRCMF_SCAN_STATUS_ABORT, &cfg->scan_status);
 }
 
 static void brcmf_notify_iscan_complete(struct brcmf_cfg80211_iscan_ctrl *iscan,
@@ -2628,7 +2627,7 @@ static void brcmf_notify_iscan_complete(struct brcmf_cfg80211_iscan_ctrl *iscan,
 	struct brcmf_cfg80211_info *cfg = iscan_to_cfg(iscan);
 	struct net_device *ndev = cfg_to_ndev(cfg);
 
-	if (!test_and_clear_bit(WL_STATUS_SCANNING, &cfg->status)) {
+	if (!test_and_clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
 		WL_ERR("Scan complete while device not scanning\n");
 		return;
 	}
@@ -2886,10 +2885,10 @@ brcmf_cfg80211_escan_handler(struct brcmf_cfg80211_info *cfg,
 	status = be32_to_cpu(e->status);
 
 	if (!ndev || !cfg->escan_on ||
-			!test_bit(WL_STATUS_SCANNING, &cfg->status)) {
+			!test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
 		WL_ERR("scan not ready ndev %p wl->escan_on %d drv_status %x\n",
 			ndev, cfg->escan_on,
-			!test_bit(WL_STATUS_SCANNING, &cfg->status));
+			!test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status));
 		return -EPERM;
 	}
 
@@ -2993,15 +2992,16 @@ static __always_inline void brcmf_delay(u32 ms)
 static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
 
 	/*
-	 * Check for WL_STATUS_READY before any function call which
+	 * Check for BRCMF_VIF_STATUS_READY before any function call which
 	 * could result is bus access. Don't block the resume for
 	 * any driver error conditions
 	 */
 	WL_TRACE("Enter\n");
 
-	if (test_bit(WL_STATUS_READY, &cfg->status))
+	if (check_sys_up(ifp->vif))
 		brcmf_invoke_iscan(wiphy_to_cfg(wiphy));
 
 	WL_TRACE("Exit\n");
@@ -3013,11 +3013,12 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct net_device *ndev = cfg_to_ndev(cfg);
+	struct brcmf_if *ifp = netdev_priv(ndev);
 
 	WL_TRACE("Enter\n");
 
 	/*
-	 * Check for WL_STATUS_READY before any function call which
+	 * Check for BRCMF_VIF_STATUS_READY before any function call which
 	 * could result is bus access. Don't block the suspend for
 	 * any driver error conditions
 	 */
@@ -3026,9 +3027,9 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 	 * While going to suspend if associated with AP disassociate
 	 * from AP to save power while system is in suspended state
 	 */
-	if ((test_bit(WL_STATUS_CONNECTED, &cfg->status) ||
-	     test_bit(WL_STATUS_CONNECTING, &cfg->status)) &&
-	     test_bit(WL_STATUS_READY, &cfg->status)) {
+	if ((test_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state) ||
+	     test_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state)) &&
+	     check_sys_up(ifp->vif)) {
 		WL_INFO("Disassociating from AP"
 			" while entering suspend state\n");
 		brcmf_link_down(cfg);
@@ -3041,13 +3042,13 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 		brcmf_delay(500);
 	}
 
-	if (test_bit(WL_STATUS_READY, &cfg->status))
+	if (test_bit(BRCMF_VIF_STATUS_READY, &ifp->vif->sme_state))
 		brcmf_abort_scanning(cfg);
 	else
-		clear_bit(WL_STATUS_SCANNING, &cfg->status);
+		clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 
 	/* Turn off watchdog timer */
-	if (test_bit(WL_STATUS_READY, &cfg->status))
+	if (test_bit(BRCMF_VIF_STATUS_READY, &ifp->vif->sme_state))
 		brcmf_set_mpc(ndev, 1);
 
 	WL_TRACE("Exit\n");
@@ -3279,15 +3280,15 @@ brcmf_notify_sched_scan_results(struct brcmf_cfg80211_info *cfg,
 		if (request->n_ssids)
 			request->ssids = &ssid[0];
 
-		if (test_bit(WL_STATUS_SCANNING, &cfg->status)) {
+		if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
 			/* Abort any on-going scan */
 			brcmf_abort_scanning(cfg);
 		}
 
-		set_bit(WL_STATUS_SCANNING, &cfg->status);
+		set_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 		err = brcmf_do_escan(cfg, wiphy, ndev, request);
 		if (err) {
-			clear_bit(WL_STATUS_SCANNING, &cfg->status);
+			clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 			goto out_err;
 		}
 		cfg->sched_escan = true;
@@ -3352,6 +3353,7 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 				struct net_device *ndev,
 				struct cfg80211_sched_scan_request *request)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
 	struct brcmf_pno_net_param_le pfn;
 	int i;
@@ -3359,8 +3361,8 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 
 	WL_SCAN("Enter n_match_sets:%d   n_ssids:%d\n",
 		request->n_match_sets, request->n_ssids);
-	if (test_bit(WL_STATUS_SCANNING, &cfg->status)) {
-		WL_ERR("Scanning already : status (%lu)\n", cfg->status);
+	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
+		WL_ERR("Scanning already: status (%lu)\n", cfg->scan_status);
 		return -EAGAIN;
 	}
 
@@ -3417,15 +3419,14 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 			pfn.flags = cpu_to_le32(1 << BRCMF_PNO_HIDDEN_BIT);
 			pfn.ssid.SSID_len = cpu_to_le32(ssid_len);
 			memcpy(pfn.ssid.SSID, ssid->ssid, ssid_len);
-			ret = brcmf_fil_iovar_data_set(netdev_priv(ndev),
-						       "pfn_add", &pfn,
+			ret = brcmf_fil_iovar_data_set(ifp, "pfn_add", &pfn,
 						       sizeof(pfn));
 			WL_SCAN(">>> PNO filter %s for ssid (%s)\n",
 				ret == 0 ? "set" : "failed",
 				ssid->ssid);
 		}
 		/* Enable the PNO */
-		if (brcmf_fil_iovar_int_set(netdev_priv(ndev), "pfn", 1) < 0) {
+		if (brcmf_fil_iovar_int_set(ifp, "pfn", 1) < 0) {
 			WL_ERR("PNO enable failed!! ret=%d\n", ret);
 			return -EINVAL;
 		}
@@ -3774,6 +3775,7 @@ brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
 			struct net_device *ndev, s32 pktflag,
 			u8 *vndr_ie_buf, u32 vndr_ie_len)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err = 0;
 	u8  *iovar_ie_buf;
 	u8  *curr_ie_buf;
@@ -3796,8 +3798,8 @@ brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
 	if (!iovar_ie_buf)
 		return -ENOMEM;
 	curr_ie_buf = iovar_ie_buf;
-	if (test_bit(WL_STATUS_AP_CREATING, &cfg->status) ||
-	    test_bit(WL_STATUS_AP_CREATED, &cfg->status)) {
+	if (test_bit(BRCMF_VIF_STATUS_AP_CREATING, &ifp->vif->sme_state) ||
+	    test_bit(BRCMF_VIF_STATUS_AP_CREATED, &ifp->vif->sme_state)) {
 		switch (pktflag) {
 		case VNDR_IE_PRBRSP_FLAG:
 			mgmt_ie_buf = cfg->ap_info->probe_res_ie;
@@ -3909,8 +3911,7 @@ brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
 		}
 	}
 	if (total_ie_buf_len) {
-		err  = brcmf_fil_bsscfg_data_set(netdev_priv(ndev), "vndr_ie",
-						 iovar_ie_buf,
+		err  = brcmf_fil_bsscfg_data_set(ifp, "vndr_ie", iovar_ie_buf,
 						 total_ie_buf_len);
 		if (err)
 			WL_ERR("vndr ie set error : %d\n", err);
@@ -3943,7 +3944,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		 settings->ssid, settings->ssid_len, settings->auth_type,
 		 settings->inactivity_timeout);
 
-	if (!test_bit(WL_STATUS_AP_CREATING, &cfg->status)) {
+	if (!test_bit(BRCMF_VIF_STATUS_AP_CREATING, &ifp->vif->sme_state)) {
 		WL_ERR("Not in AP creation mode\n");
 		return -EPERM;
 	}
@@ -4077,8 +4078,8 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		WL_ERR("SET SSID error (%d)\n", err);
 		goto exit;
 	}
-	clear_bit(WL_STATUS_AP_CREATING, &cfg->status);
-	set_bit(WL_STATUS_AP_CREATED, &cfg->status);
+	clear_bit(BRCMF_VIF_STATUS_AP_CREATING, &ifp->vif->sme_state);
+	set_bit(BRCMF_VIF_STATUS_AP_CREATED, &ifp->vif->sme_state);
 
 exit:
 	if (err)
@@ -4088,6 +4089,7 @@ exit:
 
 static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	s32 err = -EPERM;
 
@@ -4109,8 +4111,8 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 			goto exit;
 		}
 		brcmf_set_mpc(ndev, 1);
-		clear_bit(WL_STATUS_AP_CREATING, &cfg->status);
-		clear_bit(WL_STATUS_AP_CREATED, &cfg->status);
+		clear_bit(BRCMF_VIF_STATUS_AP_CREATING, &ifp->vif->sme_state);
+		clear_bit(BRCMF_VIF_STATUS_AP_CREATED, &ifp->vif->sme_state);
 	}
 exit:
 	return err;
@@ -4424,7 +4426,8 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 		       struct net_device *ndev,
 		       const struct brcmf_event_msg *e)
 {
-	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
 	struct wiphy *wiphy = cfg_to_wiphy(cfg);
 	struct ieee80211_channel *notify_channel = NULL;
@@ -4449,7 +4452,7 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 
 	/* data sent to dongle has to be little endian */
 	*(__le32 *)buf = cpu_to_le32(WL_BSS_INFO_MAX);
-	err = brcmf_fil_cmd_data_get(netdev_priv(ndev), BRCMF_C_GET_BSS_INFO,
+	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_BSS_INFO,
 				     buf, WL_BSS_INFO_MAX);
 
 	if (err)
@@ -4474,7 +4477,7 @@ done:
 			conn_info->resp_ie, conn_info->resp_ie_len, GFP_KERNEL);
 	WL_CONN("Report roaming result\n");
 
-	set_bit(WL_STATUS_CONNECTED, &cfg->status);
+	set_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state);
 	WL_TRACE("Exit\n");
 	return err;
 }
@@ -4484,13 +4487,15 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 		       struct net_device *ndev, const struct brcmf_event_msg *e,
 		       bool completed)
 {
-	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
 
-	if (test_and_clear_bit(WL_STATUS_CONNECTING, &cfg->status)) {
+	if (test_and_clear_bit(BRCMF_VIF_STATUS_CONNECTING,
+			       &ifp->vif->sme_state)) {
 		if (completed) {
 			brcmf_get_assoc_ies(cfg);
 			memcpy(profile->bssid, e->addr, ETH_ALEN);
@@ -4506,7 +4511,8 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 						    WLAN_STATUS_AUTH_TIMEOUT,
 					GFP_KERNEL);
 		if (completed)
-			set_bit(WL_STATUS_CONNECTED, &cfg->status);
+			set_bit(BRCMF_VIF_STATUS_CONNECTED,
+				&ifp->vif->sme_state);
 		WL_CONN("Report connect result - connection %s\n",
 				completed ? "succeeded" : "failed");
 	}
@@ -4558,7 +4564,8 @@ brcmf_notify_connect_status(struct brcmf_cfg80211_info *cfg,
 			    struct net_device *ndev,
 			    const struct brcmf_event_msg *e, void *data)
 {
-	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	s32 err = 0;
 
 	if (cfg->conf->mode == WL_MODE_AP) {
@@ -4569,30 +4576,34 @@ brcmf_notify_connect_status(struct brcmf_cfg80211_info *cfg,
 			memcpy(profile->bssid, e->addr, ETH_ALEN);
 			wl_inform_ibss(cfg, ndev, e->addr);
 			cfg80211_ibss_joined(ndev, e->addr, GFP_KERNEL);
-			clear_bit(WL_STATUS_CONNECTING, &cfg->status);
-			set_bit(WL_STATUS_CONNECTED, &cfg->status);
+			clear_bit(BRCMF_VIF_STATUS_CONNECTING,
+				  &ifp->vif->sme_state);
+			set_bit(BRCMF_VIF_STATUS_CONNECTED,
+				&ifp->vif->sme_state);
 		} else
 			brcmf_bss_connect_done(cfg, ndev, e, true);
 	} else if (brcmf_is_linkdown(cfg, e)) {
 		WL_CONN("Linkdown\n");
 		if (brcmf_is_ibssmode(cfg)) {
-			clear_bit(WL_STATUS_CONNECTING, &cfg->status);
-			if (test_and_clear_bit(WL_STATUS_CONNECTED,
-				&cfg->status))
+			clear_bit(BRCMF_VIF_STATUS_CONNECTING,
+				  &ifp->vif->sme_state);
+			if (test_and_clear_bit(BRCMF_VIF_STATUS_CONNECTED,
+					       &ifp->vif->sme_state))
 				brcmf_link_down(cfg);
 		} else {
 			brcmf_bss_connect_done(cfg, ndev, e, false);
-			if (test_and_clear_bit(WL_STATUS_CONNECTED,
-				&cfg->status)) {
+			if (test_and_clear_bit(BRCMF_VIF_STATUS_CONNECTED,
+					       &ifp->vif->sme_state)) {
 				cfg80211_disconnected(ndev, 0, NULL, 0,
-					GFP_KERNEL);
+						      GFP_KERNEL);
 				brcmf_link_down(cfg);
 			}
 		}
 		brcmf_init_prof(ndev_to_prof(ndev));
 	} else if (brcmf_is_nonetwork(cfg, e)) {
 		if (brcmf_is_ibssmode(cfg))
-			clear_bit(WL_STATUS_CONNECTING, &cfg->status);
+			clear_bit(BRCMF_VIF_STATUS_CONNECTING,
+				  &ifp->vif->sme_state);
 		else
 			brcmf_bss_connect_done(cfg, ndev, e, false);
 	}
@@ -4605,12 +4616,13 @@ brcmf_notify_roaming_status(struct brcmf_cfg80211_info *cfg,
 			    struct net_device *ndev,
 			    const struct brcmf_event_msg *e, void *data)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err = 0;
 	u32 event = be32_to_cpu(e->event_type);
 	u32 status = be32_to_cpu(e->status);
 
 	if (event == BRCMF_E_ROAM && status == BRCMF_E_STATUS_SUCCESS) {
-		if (test_bit(WL_STATUS_CONNECTED, &cfg->status))
+		if (test_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state))
 			brcmf_bss_roaming_done(cfg, ndev, e);
 		else
 			brcmf_bss_connect_done(cfg, ndev, e, true);
@@ -4643,6 +4655,7 @@ brcmf_notify_scan_status(struct brcmf_cfg80211_info *cfg,
 			 struct net_device *ndev,
 			 const struct brcmf_event_msg *e, void *data)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_channel_info_le channel_inform_le;
 	struct brcmf_scan_results_le *bss_list_le;
 	u32 len = WL_SCAN_BUF_MAX;
@@ -4657,14 +4670,14 @@ brcmf_notify_scan_status(struct brcmf_cfg80211_info *cfg,
 		return brcmf_wakeup_iscan(cfg_to_iscan(cfg));
 	}
 
-	if (!test_and_clear_bit(WL_STATUS_SCANNING, &cfg->status)) {
+	if (!test_and_clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
 		WL_ERR("Scan complete while device not scanning\n");
 		scan_abort = true;
 		err = -EINVAL;
 		goto scan_done_out;
 	}
 
-	err = brcmf_fil_cmd_data_get(netdev_priv(ndev), BRCMF_C_GET_CHANNEL,
+	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_CHANNEL,
 				     &channel_inform_le,
 				     sizeof(channel_inform_le));
 	if (err) {
@@ -4680,7 +4693,7 @@ brcmf_notify_scan_status(struct brcmf_cfg80211_info *cfg,
 
 	memset(cfg->scan_results, 0, len);
 	bss_list_le->buflen = cpu_to_le32(len);
-	err = brcmf_fil_cmd_data_get(netdev_priv(ndev), BRCMF_C_SCAN_RESULTS,
+	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_SCAN_RESULTS,
 				     cfg->scan_results, len);
 	if (err) {
 		WL_ERR("%s Scan_results error (%d)\n", ndev->name, err);
@@ -5289,9 +5302,10 @@ static void brcmf_debugfs_remove_netdev(struct brcmf_cfg80211_info *cfg)
 
 static s32 __brcmf_cfg80211_up(struct brcmf_cfg80211_info *cfg)
 {
+	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
 	s32 err = 0;
 
-	set_bit(WL_STATUS_READY, &cfg->status);
+	set_bit(BRCMF_VIF_STATUS_READY, &ifp->vif->sme_state);
 
 	brcmf_debugfs_add_netdev_params(cfg);
 
@@ -5306,13 +5320,16 @@ static s32 __brcmf_cfg80211_up(struct brcmf_cfg80211_info *cfg)
 
 static s32 __brcmf_cfg80211_down(struct brcmf_cfg80211_info *cfg)
 {
+	struct net_device *ndev = cfg_to_ndev(cfg);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+
 	/*
 	 * While going down, if associated with AP disassociate
 	 * from AP to save power
 	 */
-	if ((test_bit(WL_STATUS_CONNECTED, &cfg->status) ||
-	     test_bit(WL_STATUS_CONNECTING, &cfg->status)) &&
-	     test_bit(WL_STATUS_READY, &cfg->status)) {
+	if ((test_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state) ||
+	     test_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state)) &&
+	     check_sys_up(ifp->vif)) {
 		WL_INFO("Disassociating from AP");
 		brcmf_link_down(cfg);
 
@@ -5324,7 +5341,7 @@ static s32 __brcmf_cfg80211_down(struct brcmf_cfg80211_info *cfg)
 	}
 
 	brcmf_abort_scanning(cfg);
-	clear_bit(WL_STATUS_READY, &cfg->status);
+	clear_bit(BRCMF_VIF_STATUS_READY, &ifp->vif->sme_state);
 
 	brcmf_debugfs_remove_netdev(cfg);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index bf172d9..fca288b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -127,15 +127,15 @@ do {								\
 #define WL_AUTH_SHARED_KEY		1	/* d11 shared authentication */
 #define IE_MAX_LEN			512
 
-/* dongle status */
-enum wl_status {
-	WL_STATUS_READY,
-	WL_STATUS_SCANNING,
-	WL_STATUS_SCAN_ABORTING,
-	WL_STATUS_CONNECTING,
-	WL_STATUS_CONNECTED,
-	WL_STATUS_AP_CREATING,
-	WL_STATUS_AP_CREATED
+/**
+ * enum brcmf_scan_status - dongle scan status
+ *
+ * @BRCMF_SCAN_STATUS_BUSY: scanning in progress on dongle.
+ * @BRCMF_SCAN_STATUS_ABORT: scan being aborted on dongle.
+ */
+enum brcmf_scan_status {
+	BRCMF_SCAN_STATUS_BUSY,
+	BRCMF_SCAN_STATUS_ABORT,
 };
 
 /* wi-fi mode */
@@ -236,6 +236,23 @@ struct brcmf_cfg80211_profile {
 };
 
 /**
+ * enum brcmf_vif_status - bit indices for vif status.
+ *
+ * @BRCMF_VIF_STATUS_READY: ready for operation.
+ * @BRCMF_VIF_STATUS_CONNECTING: connect/join in progress.
+ * @BRCMF_VIF_STATUS_CONNECTED: connected/joined succesfully.
+ * @BRCMF_VIF_STATUS_AP_CREATING: interface configured for AP operation.
+ * @BRCMF_VIF_STATUS_AP_CREATED: AP operation started.
+ */
+enum brcmf_vif_status {
+	BRCMF_VIF_STATUS_READY,
+	BRCMF_VIF_STATUS_CONNECTING,
+	BRCMF_VIF_STATUS_CONNECTED,
+	BRCMF_VIF_STATUS_AP_CREATING,
+	BRCMF_VIF_STATUS_AP_CREATED
+};
+
+/**
  * struct brcmf_cfg80211_vif - virtual interface specific information.
  *
  * @ifp: lower layer interface pointer
@@ -243,6 +260,7 @@ struct brcmf_cfg80211_profile {
  * @profile: profile information.
  * @mode: operating mode.
  * @roam_off: roaming state.
+ * @sme_state: SME state using enum brcmf_vif_status bits.
  * @pm_block: power-management blocked.
  * @list: linked list.
  */
@@ -252,6 +270,7 @@ struct brcmf_cfg80211_vif {
 	struct brcmf_cfg80211_profile profile;
 	s32 mode;
 	s32 roam_off;
+	unsigned long sme_state;
 	bool pm_block;
 	struct list_head list;
 };
@@ -420,7 +439,7 @@ struct brcmf_pno_scanresults_le {
  * @conn_info: association info.
  * @pmk_list: wpa2 pmk list.
  * @event_work: event handler work struct.
- * @status: current dongle status.
+ * @scan_status: scan activity on the dongle.
  * @pub: common driver information.
  * @channel: current channel.
  * @iscan_on: iscan on/off switch.
@@ -462,7 +481,7 @@ struct brcmf_cfg80211_info {
 	struct brcmf_cfg80211_connect_info conn_info;
 	struct brcmf_cfg80211_pmk_list *pmk_list;
 	struct work_struct event_work;
-	unsigned long status;
+	unsigned long scan_status;
 	struct brcmf_pub *pub;
 	u32 channel;
 	bool iscan_on;
-- 
1.7.9.5


