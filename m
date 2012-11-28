Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4090 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932347Ab2K1Uoi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 15:44:38 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/11] brcmfmac: get rid of struct
 brcmf_cfg80211_info::link_up attribute
Date: Wed, 28 Nov 2012 21:44:11 +0100
Message-ID: <1354135454-7035-9-git-send-email-arend@broadcom.com> (sfid-20121128_214447_265269_528399B5)
In-Reply-To: <1354135454-7035-1-git-send-email-arend@broadcom.com>
References: <1354135454-7035-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This attribute indicates successful IBSS or AP connection has been
established. However, this no longer works for virtual interfaces.
As it turns out this attribute is identical to the CONNECTED bit
in struct brcmf_cfg80211_vif::sme_state. This patch removes the
attribute and rework some functions relying on it.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   68 +++++++-------------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    2 -
 2 files changed, 22 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 2044fdb..87b3476 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -963,22 +963,21 @@ static void brcmf_ch_to_chanspec(int ch, struct brcmf_join_params *join_params,
 	}
 }
 
-static void brcmf_link_down(struct brcmf_cfg80211_info *cfg)
+static void brcmf_link_down(struct brcmf_cfg80211_vif *vif)
 {
-	struct net_device *ndev = NULL;
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
 
-	if (cfg->link_up) {
-		ndev = cfg_to_ndev(cfg);
+	if (test_bit(BRCMF_VIF_STATUS_CONNECTED, &vif->sme_state)) {
 		WL_INFO("Call WLC_DISASSOC to stop excess roaming\n ");
-		err = brcmf_fil_cmd_data_set(netdev_priv(ndev),
+		err = brcmf_fil_cmd_data_set(vif->ifp,
 					     BRCMF_C_DISASSOC, NULL, 0);
 		if (err)
 			WL_ERR("WLC_DISASSOC failed (%d)\n", err);
-		cfg->link_up = false;
+		clear_bit(BRCMF_VIF_STATUS_CONNECTED, &vif->sme_state);
 	}
+	clear_bit(BRCMF_VIF_STATUS_CONNECTING, &vif->sme_state);
 	WL_TRACE("Exit\n");
 }
 
@@ -1130,7 +1129,6 @@ done:
 static s32
 brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *ndev)
 {
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err = 0;
 
@@ -1138,7 +1136,7 @@ brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *ndev)
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
-	brcmf_link_down(cfg);
+	brcmf_link_down(ifp->vif);
 
 	WL_TRACE("Exit\n");
 
@@ -1496,7 +1494,6 @@ static s32
 brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 		       u16 reason_code)
 {
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct brcmf_scb_val_le scbval;
@@ -1515,8 +1512,6 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 	if (err)
 		WL_ERR("error (%d)\n", err);
 
-	cfg->link_up = false;
-
 	WL_TRACE("Exit\n");
 	return err;
 }
@@ -2596,17 +2591,13 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 		 * While going to suspend if associated with AP disassociate
 		 * from AP to save power while system is in suspended state
 		 */
-		if (test_bit(BRCMF_VIF_STATUS_CONNECTED, &vif->sme_state) ||
-		    test_bit(BRCMF_VIF_STATUS_CONNECTING, &vif->sme_state)) {
-			WL_INFO("Disassociating from AP before suspend\n");
-			brcmf_link_down(cfg);
-
-			/* Make sure WPA_Supplicant receives all the event
-			 * generated due to DISASSOC call to the fw to keep
-			 * the state fw and WPA_Supplicant state consistent
-			 */
-			brcmf_delay(500);
-		}
+		brcmf_link_down(vif);
+
+		/* Make sure WPA_Supplicant receives all the event
+		 * generated due to DISASSOC call to the fw to keep
+		 * the state fw and WPA_Supplicant state consistent
+		 */
+		brcmf_delay(500);
 	}
 
 	/* end any scanning */
@@ -3849,23 +3840,20 @@ static void brcmf_free_vif(struct brcmf_cfg80211_vif *vif)
 	}
 }
 
-static bool brcmf_is_linkup(struct brcmf_cfg80211_info *cfg,
-			    const struct brcmf_event_msg *e)
+static bool brcmf_is_linkup(const struct brcmf_event_msg *e)
 {
 	u32 event = e->event_code;
 	u32 status = e->status;
 
 	if (event == BRCMF_E_SET_SSID && status == BRCMF_E_STATUS_SUCCESS) {
 		WL_CONN("Processing set ssid\n");
-		cfg->link_up = true;
 		return true;
 	}
 
 	return false;
 }
 
-static bool brcmf_is_linkdown(struct brcmf_cfg80211_info *cfg,
-			      const struct brcmf_event_msg *e)
+static bool brcmf_is_linkdown(const struct brcmf_event_msg *e)
 {
 	u32 event = e->event_code;
 	u16 flags = e->flags;
@@ -4117,7 +4105,7 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 
 	if (cfg->conf->mode == WL_MODE_AP) {
 		err = brcmf_notify_connect_status_ap(cfg, ndev, e, data);
-	} else if (brcmf_is_linkup(cfg, e)) {
+	} else if (brcmf_is_linkup(e)) {
 		WL_CONN("Linkup\n");
 		if (brcmf_is_ibssmode(cfg)) {
 			memcpy(profile->bssid, e->addr, ETH_ALEN);
@@ -4129,23 +4117,16 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 				&ifp->vif->sme_state);
 		} else
 			brcmf_bss_connect_done(cfg, ndev, e, true);
-	} else if (brcmf_is_linkdown(cfg, e)) {
+	} else if (brcmf_is_linkdown(e)) {
 		WL_CONN("Linkdown\n");
-		if (brcmf_is_ibssmode(cfg)) {
-			clear_bit(BRCMF_VIF_STATUS_CONNECTING,
-				  &ifp->vif->sme_state);
-			if (test_and_clear_bit(BRCMF_VIF_STATUS_CONNECTED,
-					       &ifp->vif->sme_state))
-				brcmf_link_down(cfg);
-		} else {
+		if (!brcmf_is_ibssmode(cfg)) {
 			brcmf_bss_connect_done(cfg, ndev, e, false);
 			if (test_and_clear_bit(BRCMF_VIF_STATUS_CONNECTED,
-					       &ifp->vif->sme_state)) {
+					       &ifp->vif->sme_state))
 				cfg80211_disconnected(ndev, 0, NULL, 0,
 						      GFP_KERNEL);
-				brcmf_link_down(cfg);
-			}
 		}
+		brcmf_link_down(ifp->vif);
 		brcmf_init_prof(ndev_to_prof(ndev));
 	} else if (brcmf_is_nonetwork(cfg, e)) {
 		if (brcmf_is_ibssmode(cfg))
@@ -4282,7 +4263,6 @@ static s32 wl_init_priv(struct brcmf_cfg80211_info *cfg)
 	mutex_init(&cfg->usr_sync);
 	brcmf_init_escan(cfg);
 	brcmf_init_conf(cfg->conf);
-	brcmf_link_down(cfg);
 
 	return err;
 }
@@ -4290,7 +4270,6 @@ static s32 wl_init_priv(struct brcmf_cfg80211_info *cfg)
 static void wl_deinit_priv(struct brcmf_cfg80211_info *cfg)
 {
 	cfg->dongle_up = false;	/* dongle down */
-	brcmf_link_down(cfg);
 	brcmf_abort_scanning(cfg);
 	brcmf_deinit_priv_mem(cfg);
 }
@@ -4537,11 +4516,8 @@ static s32 __brcmf_cfg80211_down(struct brcmf_if *ifp)
 	 * While going down, if associated with AP disassociate
 	 * from AP to save power
 	 */
-	if ((test_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state) ||
-	     test_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state)) &&
-	     check_vif_up(ifp->vif)) {
-		WL_INFO("Disassociating from AP");
-		brcmf_link_down(cfg);
+	if (check_vif_up(ifp->vif)) {
+		brcmf_link_down(ifp->vif);
 
 		/* Make sure WPA_Supplicant receives all the event
 		   generated due to DISASSOC call to the fw to keep
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index e2ef851..c1acda2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -359,7 +359,6 @@ struct brcmf_pno_scanresults_le {
  * @active_scan: current scan mode.
  * @sched_escan: e-scan for scheduled scan support running.
  * @ibss_starter: indicates this sta is ibss starter.
- * @link_up: link/connection up flag.
  * @pwr_save: indicate whether dongle to support power save mode.
  * @dongle_up: indicate whether dongle up or not.
  * @roam_on: on/off switch for dongle self-roaming.
@@ -391,7 +390,6 @@ struct brcmf_cfg80211_info {
 	bool active_scan;
 	bool sched_escan;
 	bool ibss_starter;
-	bool link_up;
 	bool pwr_save;
 	bool dongle_up;
 	bool roam_on;
-- 
1.7.10.4


