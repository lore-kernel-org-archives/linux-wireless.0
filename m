Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1613 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760202Ab3BHO4l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:41 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/27] brcmfmac: Update AP mode for GO creation.
Date: Fri, 8 Feb 2013 15:53:47 +0100
Message-ID: <1360335242-12608-13-git-send-email-arend@broadcom.com> (sfid-20130208_163813_269370_CC5AF849)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

With this update it is possible to create an P2P go. Handle the
p2p go role in creation and the update beacon from cfg80211. Also
store primary bss in global struct. Needed to map cfg device
back to primary device.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |    5 +
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.h      |    3 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  255 +++++++++++++-------
 4 files changed, 183 insertions(+), 86 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
index 7707194..2c4ca59 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
@@ -39,4 +39,9 @@ struct brcmf_fil_chan_info_le {
 	__le32 scan_channel;
 };
 
+struct brcmf_fil_bss_enable_le {
+	__le32 bsscfg_idx;
+	__le32 enable;
+};
+
 #endif /* FWIL_TYPES_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index fa0127e..d5f9711 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -691,15 +691,17 @@ void brcmf_p2p_cancel_remain_on_channel(struct brcmf_if *ifp)
  *
  * @cfg: driver private data for cfg80211 interface.
  */
-void brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg)
+void brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg,
+		      struct brcmf_cfg80211_vif *vif)
 {
 	struct brcmf_p2p_info *p2p;
 
 	p2p = &cfg->p2p;
 
 	p2p->cfg = cfg;
-	brcmf_p2p_set_firmware(p2p);
+	p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif = vif;
 	brcmf_p2p_generate_bss_mac(p2p);
+	brcmf_p2p_set_firmware(p2p);
 }
 
 /**
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
index 1bf57c1..4c1819c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
@@ -102,7 +102,8 @@ struct brcmf_p2p_info {
 	struct ieee80211_channel remain_on_channel;
 };
 
-void brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg);
+void brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg,
+		      struct brcmf_cfg80211_vif *vif);
 void brcmf_p2p_detach(struct brcmf_p2p_info *p2p);
 struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 				       enum nl80211_iftype type, u32 *flags,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 3112265..c94d536 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3625,9 +3625,37 @@ s32 brcmf_vif_clear_mgmt_ies(struct brcmf_cfg80211_vif *vif)
 }
 
 static s32
+brcmf_config_ap_mgmt_ie(struct brcmf_cfg80211_vif *vif,
+			struct cfg80211_beacon_data *beacon)
+{
+	s32 err;
+
+	/* Set Beacon IEs to FW */
+	err = brcmf_vif_set_mgmt_ie(vif, BRCMF_VNDR_IE_BEACON_FLAG,
+				    beacon->tail, beacon->tail_len);
+	if (err) {
+		brcmf_err("Set Beacon IE Failed\n");
+		return err;
+	}
+	brcmf_dbg(TRACE, "Applied Vndr IEs for Beacon\n");
+
+	/* Set Probe Response IEs to FW */
+	err = brcmf_vif_set_mgmt_ie(vif, BRCMF_VNDR_IE_PRBRSP_FLAG,
+				    beacon->proberesp_ies,
+				    beacon->proberesp_ies_len);
+	if (err)
+		brcmf_err("Set Probe Resp IE Failed\n");
+	else
+		brcmf_dbg(TRACE, "Applied Vndr IEs for Probe Resp\n");
+
+	return err;
+}
+
+static s32
 brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			struct cfg80211_ap_settings *settings)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	s32 ie_offset;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_tlv *ssid_ie;
@@ -3636,6 +3664,8 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_tlv *rsn_ie;
 	struct brcmf_vs_tlv *wpa_ie;
 	struct brcmf_join_params join_params;
+	enum nl80211_iftype dev_role;
+	struct brcmf_fil_bss_enable_le bss_enable;
 
 	brcmf_dbg(TRACE, "channel_type=%d, beacon_interval=%d, dtim_period=%d,\n",
 		  cfg80211_get_chandef_type(&settings->chandef),
@@ -3645,9 +3675,21 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		  settings->ssid, settings->ssid_len, settings->auth_type,
 		  settings->inactivity_timeout);
 
-	if (!test_bit(BRCMF_VIF_STATUS_AP_CREATING, &ifp->vif->sme_state)) {
-		brcmf_err("Not in AP creation mode\n");
-		return -EPERM;
+	if (ifp->vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif) {
+		brcmf_dbg(TRACE, "Role = AP\n");
+		dev_role = NL80211_IFTYPE_AP;
+		if (!test_bit(BRCMF_VIF_STATUS_AP_CREATING,
+			      &ifp->vif->sme_state)) {
+			brcmf_err("Not in AP creation mode\n");
+			return -EPERM;
+		}
+	} else {
+		brcmf_dbg(TRACE, "Role = P2P GO\n");
+		dev_role = NL80211_IFTYPE_P2P_GO;
+		if (ifp->vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif) {
+			ifp = cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif->ifp;
+			ndev = ifp->ndev;
+		}
 	}
 
 	memset(&ssid_le, 0, sizeof(ssid_le));
@@ -3669,21 +3711,6 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	brcmf_set_mpc(ndev, 0);
-	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1);
-	if (err < 0) {
-		brcmf_err("BRCMF_C_DOWN error %d\n", err);
-		goto exit;
-	}
-	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, 1);
-	if (err < 0) {
-		brcmf_err("SET INFRA error %d\n", err);
-		goto exit;
-	}
-	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 1);
-	if (err < 0) {
-		brcmf_err("setting AP mode failed %d\n", err);
-		goto exit;
-	}
 
 	/* find the RSN_IE */
 	rsn_ie = brcmf_parse_tlvs((u8 *)settings->beacon.tail,
@@ -3711,25 +3738,8 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		brcmf_dbg(TRACE, "No WPA(2) IEs found\n");
 		brcmf_configure_opensecurity(ifp);
 	}
-	/* Set Beacon IEs to FW */
-	err = brcmf_vif_set_mgmt_ie(ndev_to_vif(ndev),
-				    BRCMF_VNDR_IE_BEACON_FLAG,
-				    settings->beacon.tail,
-				    settings->beacon.tail_len);
-	if (err)
-		brcmf_err("Set Beacon IE Failed\n");
-	else
-		brcmf_dbg(TRACE, "Applied Vndr IEs for Beacon\n");
 
-	/* Set Probe Response IEs to FW */
-	err = brcmf_vif_set_mgmt_ie(ndev_to_vif(ndev),
-				    BRCMF_VNDR_IE_PRBRSP_FLAG,
-				    settings->beacon.proberesp_ies,
-				    settings->beacon.proberesp_ies_len);
-	if (err)
-		brcmf_err("Set Probe Resp IE Failed\n");
-	else
-		brcmf_dbg(TRACE, "Applied Vndr IEs for Probe Resp\n");
+	brcmf_config_ap_mgmt_ie(ifp->vif, &settings->beacon);
 
 	if (settings->beacon_interval) {
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_BCNPRD,
@@ -3747,23 +3757,62 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			goto exit;
 		}
 	}
-	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 1);
-	if (err < 0) {
-		brcmf_err("BRCMF_C_UP error (%d)\n", err);
-		goto exit;
+
+	if (dev_role == NL80211_IFTYPE_AP) {
+		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1);
+		if (err < 0) {
+			brcmf_err("BRCMF_C_DOWN error %d\n", err);
+			goto exit;
+		}
 		brcmf_fil_iovar_int_set(ifp, "apsta", 0);
 	}
 
-	memset(&join_params, 0, sizeof(join_params));
-	/* join parameters starts with ssid */
-	memcpy(&join_params.ssid_le, &ssid_le, sizeof(ssid_le));
-	/* create softap */
-	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
-				     &join_params, sizeof(join_params));
+	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, 1);
 	if (err < 0) {
-		brcmf_err("SET SSID error (%d)\n", err);
+		brcmf_err("SET INFRA error %d\n", err);
 		goto exit;
 	}
+	if (dev_role == NL80211_IFTYPE_AP) {
+		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 1);
+		if (err < 0) {
+			brcmf_err("setting AP mode failed %d\n", err);
+			goto exit;
+		}
+		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 1);
+		if (err < 0) {
+			brcmf_err("BRCMF_C_UP error (%d)\n", err);
+			goto exit;
+		}
+
+		memset(&join_params, 0, sizeof(join_params));
+		/* join parameters starts with ssid */
+		memcpy(&join_params.ssid_le, &ssid_le, sizeof(ssid_le));
+		/* create softap */
+		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
+					     &join_params, sizeof(join_params));
+		if (err < 0) {
+			brcmf_err("SET SSID error (%d)\n", err);
+			goto exit;
+		}
+		brcmf_dbg(TRACE, "AP mode configuration complete\n");
+	} else {
+		err = brcmf_fil_bsscfg_data_set(ifp, "ssid", &ssid_le,
+						sizeof(ssid_le));
+		if (err < 0) {
+			brcmf_err("setting ssid failed %d\n", err);
+			goto exit;
+		}
+		bss_enable.bsscfg_idx = cpu_to_le32(ifp->bssidx);
+		bss_enable.enable = cpu_to_le32(1);
+		err = brcmf_fil_iovar_data_set(ifp, "bss", &bss_enable,
+					       sizeof(bss_enable));
+		if (err < 0) {
+			brcmf_err("bss_enable config failed %d\n", err);
+			goto exit;
+		}
+
+		brcmf_dbg(TRACE, "GO mode configuration complete\n");
+	}
 	clear_bit(BRCMF_VIF_STATUS_AP_CREATING, &ifp->vif->sme_state);
 	set_bit(BRCMF_VIF_STATUS_AP_CREATED, &ifp->vif->sme_state);
 
@@ -3802,10 +3851,41 @@ exit:
 	return err;
 }
 
+static s32
+brcmf_cfg80211_change_beacon(struct wiphy *wiphy, struct net_device *ndev,
+			     struct cfg80211_beacon_data *info)
+{
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	s32 err;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	if (ifp->vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif) {
+		brcmf_dbg(TRACE, "Role = AP\n");
+		if (!test_bit(BRCMF_VIF_STATUS_AP_CREATED,
+			      &ifp->vif->sme_state)) {
+			brcmf_err("AP was not yet created\n");
+			return -EPERM;
+		}
+	} else {
+		brcmf_dbg(TRACE, "Role = P2P GO\n");
+		if (ifp->vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif) {
+			ifp = cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif->ifp;
+			ndev = ifp->ndev;
+		}
+	}
+
+	err = brcmf_config_ap_mgmt_ie(ifp->vif, info);
+
+	return err;
+}
+
 static int
 brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 			   u8 *mac)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_scb_val_le scbval;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err;
@@ -3815,6 +3895,8 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 
 	brcmf_dbg(TRACE, "Enter %pM\n", mac);
 
+	if (ifp->vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif)
+		ifp = cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif->ifp;
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
@@ -3824,7 +3906,12 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 				     &scbval, sizeof(scbval));
 	if (err)
 		brcmf_err("SCB_DEAUTHENTICATE_FOR_REASON failed %d\n", err);
-
+	/*
+	 * Wait for the deauth event to come, supplicant will do the
+	 * delete iface immediately and we will have problem in sending
+	 * deauth frame if we delete the bss in firmware
+	 */
+	brcmf_delay(400);
 	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 }
@@ -3857,6 +3944,7 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	const struct ieee80211_mgmt *mgmt;
+	struct brcmf_if *ifp;
 	struct brcmf_cfg80211_vif *vif;
 	s32 err = 0;
 	s32 ie_offset;
@@ -3868,41 +3956,41 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	mgmt = (const struct ieee80211_mgmt *)buf;
 
-	if (ieee80211_is_mgmt(mgmt->frame_control)) {
-		if (ieee80211_is_probe_resp(mgmt->frame_control)) {
-			/* Right now the only reason to get a probe response */
-			/* is for p2p listen response from wpa_supplicant.   */
-			/* Unfortunately the wpa_supplicant sends it on the  */
-			/* primary ndev, while dongle wants it on the p2p    */
-			/* vif. Since this is only reason for a probe        */
-			/* response to be sent, the vif is taken from cfg.   */
-			/* If ever desired to send proberesp for non p2p     */
-			/* response then data should be checked for          */
-			/* "DIRECT-". Note in future supplicant will take    */
-			/* dedicated p2p wdev to do this and then this 'hack'*/
-			/* is not needed anymore.                            */
-			ie_offset =  DOT11_MGMT_HDR_LEN +
-				     DOT11_BCN_PRB_FIXED_LEN;
-			ie_len = len - ie_offset;
+	if (!ieee80211_is_mgmt(mgmt->frame_control)) {
+		brcmf_err("Driver only allows MGMT packet type\n");
+		return -EPERM;
+	}
 
+	if (ieee80211_is_probe_resp(mgmt->frame_control)) {
+		/* Right now the only reason to get a probe response */
+		/* is for p2p listen response or for p2p GO from     */
+		/* wpa_supplicant. Unfortunately the probe is send   */
+		/* on primary ndev, while dongle wants it on the p2p */
+		/* vif. Since this is only reason for a probe        */
+		/* response to be sent, the vif is taken from cfg.   */
+		/* If ever desired to send proberesp for non p2p     */
+		/* response then data should be checked for          */
+		/* "DIRECT-". Note in future supplicant will take    */
+		/* dedicated p2p wdev to do this and then this 'hack'*/
+		/* is not needed anymore.                            */
+		ie_offset =  DOT11_MGMT_HDR_LEN +
+			     DOT11_BCN_PRB_FIXED_LEN;
+		ie_len = len - ie_offset;
+		ifp = netdev_priv(wdev->netdev);
+		vif = ifp->vif;
+		if (vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif)
 			vif = cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
-			if (vif == NULL) {
-				brcmf_err("No p2p device available for probe response\n");
-				err = -ENODEV;
-				goto exit;
-			}
-			err = brcmf_vif_set_mgmt_ie(vif,
-						    BRCMF_VNDR_IE_PRBRSP_FLAG,
-						    &buf[ie_offset],
-						    ie_len);
-			cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, true,
-						GFP_KERNEL);
-			goto exit;
-		}
+		err = brcmf_vif_set_mgmt_ie(vif,
+					    BRCMF_VNDR_IE_PRBRSP_FLAG,
+					    &buf[ie_offset],
+					    ie_len);
+		cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, true,
+					GFP_KERNEL);
+	} else {
+		brcmf_dbg(TRACE, "Unhandled, fc=%04x!!\n", mgmt->frame_control);
+		brcmf_dbg_hex_dump(true, buf, len, "payload, len=%Zu\n", len);
 	}
-	brcmf_dbg(TRACE, "Unhandled, is_mgmt %d, fc=%04x!!!!!\n",
-		  ieee80211_is_mgmt(mgmt->frame_control), mgmt->frame_control);
-exit:
+
 	return err;
 }
 
@@ -3946,8 +4034,8 @@ static s32 brcmf_notify_rx_mgmt_p2p_probereq(struct brcmf_if *ifp,
 		  "Enter: event %d reason %d\n", e->event_code, e->reason);
 
 	/* Firmware sends us two proberesponses for each idx one. At the */
-	/* moment only bsscfgidx 0 is passed up to supplicant            */
-	if (e->bsscfgidx)
+	/* moment anything but bsscfgidx 0 is passed up to supplicant    */
+	if (e->bsscfgidx == 0)
 		return 0;
 
 	/* Check if wpa_supplicant has registered for this frame */
@@ -3999,6 +4087,7 @@ static struct cfg80211_ops wl_cfg80211_ops = {
 	.flush_pmksa = brcmf_cfg80211_flush_pmksa,
 	.start_ap = brcmf_cfg80211_start_ap,
 	.stop_ap = brcmf_cfg80211_stop_ap,
+	.change_beacon = brcmf_cfg80211_change_beacon,
 	.del_station = brcmf_cfg80211_del_station,
 	.sched_scan_start = brcmf_cfg80211_sched_scan_start,
 	.sched_scan_stop = brcmf_cfg80211_sched_scan_stop,
@@ -4727,7 +4816,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 		brcmf_err("Failed to init iwm_priv (%d)\n", err);
 		goto cfg80211_attach_out;
 	}
-	brcmf_p2p_attach(cfg);
+	brcmf_p2p_attach(cfg, vif);
 
 	ifp->vif = vif;
 	return cfg;
-- 
1.7.10.4


