Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2433 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072Ab2LEO0a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 09:26:30 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/11] brcmfmac: replace WL_INFO() macro
Date: Wed, 5 Dec 2012 15:26:01 +0100
Message-ID: <1354717564-7183-9-git-send-email-arend@broadcom.com> (sfid-20121205_152641_451148_4CCD2113)
In-Reply-To: <1354717564-7183-1-git-send-email-arend@broadcom.com>
References: <1354717564-7183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Get rid of WL_INFO() in favor of brcmf_dbg(INFO,...).

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   42 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    1 -
 2 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 9840ffb..2013bf3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -90,8 +90,8 @@
 static bool check_vif_up(struct brcmf_cfg80211_vif *vif)
 {
 	if (!test_bit(BRCMF_VIF_STATUS_READY, &vif->sme_state)) {
-		WL_INFO("device is not ready : status (%lu)\n",
-			vif->sme_state);
+		brcmf_dbg(INFO, "device is not ready : status (%lu)\n",
+			  vif->sme_state);
 		return false;
 	}
 	return true;
@@ -477,7 +477,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 
 	if (ap) {
 		set_bit(BRCMF_VIF_STATUS_AP_CREATING, &vif->sme_state);
-		WL_INFO("IF Type = AP\n");
+		brcmf_dbg(INFO, "IF Type = AP\n");
 	} else {
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, infra);
 		if (err) {
@@ -485,8 +485,8 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 			err = -EAGAIN;
 			goto done;
 		}
-		WL_INFO("IF Type = %s\n", (vif->mode == WL_MODE_IBSS) ?
-			"Adhoc" : "Infra");
+		brcmf_dbg(INFO, "IF Type = %s\n", (vif->mode == WL_MODE_IBSS) ?
+			  "Adhoc" : "Infra");
 	}
 	ndev->ieee80211_ptr->iftype = type;
 
@@ -507,7 +507,7 @@ static void brcmf_set_mpc(struct net_device *ndev, int mpc)
 			brcmf_err("fail to set mpc\n");
 			return;
 		}
-		WL_INFO("MPC : %d\n", mpc);
+		brcmf_dbg(INFO, "MPC : %d\n", mpc);
 	}
 }
 
@@ -685,7 +685,7 @@ brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct net_device *ndev,
 				       params, params_size);
 	if (err) {
 		if (err == -EBUSY)
-			WL_INFO("system busy : escan canceled\n");
+			brcmf_dbg(INFO, "system busy : escan canceled\n");
 		else
 			brcmf_err("error (%d)\n", err);
 	}
@@ -804,8 +804,8 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 					     &sr->ssid_le, sizeof(sr->ssid_le));
 		if (err) {
 			if (err == -EBUSY)
-				WL_INFO("BUSY: scan for \"%s\" canceled\n",
-					sr->ssid_le.SSID);
+				brcmf_dbg(INFO, "BUSY: scan for \"%s\" canceled\n",
+					  sr->ssid_le.SSID);
 			else
 				brcmf_err("WLC_SCAN error (%d)\n", err);
 
@@ -966,7 +966,7 @@ static void brcmf_link_down(struct brcmf_cfg80211_vif *vif)
 	WL_TRACE("Enter\n");
 
 	if (test_bit(BRCMF_VIF_STATUS_CONNECTED, &vif->sme_state)) {
-		WL_INFO("Call WLC_DISASSOC to stop excess roaming\n ");
+		brcmf_dbg(INFO, "Call WLC_DISASSOC to stop excess roaming\n ");
 		err = brcmf_fil_cmd_data_set(vif->ifp,
 					     BRCMF_C_DISASSOC, NULL, 0);
 		if (err)
@@ -1425,7 +1425,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	} else
 		cfg->channel = 0;
 
-	WL_INFO("ie (%p), ie_len (%zd)\n", sme->ie, sme->ie_len);
+	brcmf_dbg(INFO, "ie (%p), ie_len (%zd)\n", sme->ie, sme->ie_len);
 
 	err = brcmf_set_wpa_version(ndev, sme);
 	if (err) {
@@ -1889,7 +1889,7 @@ static s32
 brcmf_cfg80211_config_default_mgmt_key(struct wiphy *wiphy,
 				    struct net_device *ndev, u8 key_idx)
 {
-	WL_INFO("Not supported\n");
+	brcmf_dbg(INFO, "Not supported\n");
 
 	return -EOPNOTSUPP;
 }
@@ -1989,12 +1989,12 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 	cfg->pwr_save = enabled;
 	if (!check_vif_up(ifp->vif)) {
 
-		WL_INFO("Device is not ready, storing the value in cfg_info struct\n");
+		brcmf_dbg(INFO, "Device is not ready, storing the value in cfg_info struct\n");
 		goto done;
 	}
 
 	pm = enabled ? PM_FAST : PM_OFF;
-	WL_INFO("power save %s\n", (pm ? "enabled" : "disabled"));
+	brcmf_dbg(INFO, "power save %s\n", (pm ? "enabled" : "disabled"));
 
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PM, pm);
 	if (err) {
@@ -4351,7 +4351,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	 * Enable/Disable built-in roaming to allow supplicant
 	 * to take care of roaming
 	 */
-	WL_INFO("Internal Roaming = %s\n", roamvar ? "Off" : "On");
+	brcmf_dbg(INFO, "Internal Roaming = %s\n", roamvar ? "Off" : "On");
 	err = brcmf_fil_iovar_int_set(ifp, "roam_off", roamvar);
 	if (err) {
 		brcmf_err("roam_off error (%d)\n", err);
@@ -4391,7 +4391,7 @@ brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 				    scan_assoc_time);
 	if (err) {
 		if (err == -EOPNOTSUPP)
-			WL_INFO("Scan assoc time is not supported\n");
+			brcmf_dbg(INFO, "Scan assoc time is not supported\n");
 		else
 			brcmf_err("Scan assoc time error (%d)\n", err);
 		goto dongle_scantime_out;
@@ -4400,7 +4400,7 @@ brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 				    scan_unassoc_time);
 	if (err) {
 		if (err == -EOPNOTSUPP)
-			WL_INFO("Scan unassoc time is not supported\n");
+			brcmf_dbg(INFO, "Scan unassoc time is not supported\n");
 		else
 			brcmf_err("Scan unassoc time error (%d)\n", err);
 		goto dongle_scantime_out;
@@ -4410,7 +4410,7 @@ brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 				    scan_passive_time);
 	if (err) {
 		if (err == -EOPNOTSUPP)
-			WL_INFO("Scan passive time is not supported\n");
+			brcmf_dbg(INFO, "Scan passive time is not supported\n");
 		else
 			brcmf_err("Scan passive time error (%d)\n", err);
 		goto dongle_scantime_out;
@@ -4436,7 +4436,7 @@ static s32 wl_update_wiphybands(struct brcmf_cfg80211_info *cfg)
 	}
 
 	phy = ((char *)&phy_list)[0];
-	WL_INFO("%c phy\n", phy);
+	brcmf_dbg(INFO, "%c phy\n", phy);
 	if (phy == 'n' || phy == 'a') {
 		wiphy = cfg_to_wiphy(cfg);
 		wiphy->bands[IEEE80211_BAND_5GHZ] = &__wl_band_5ghz_n;
@@ -4471,8 +4471,8 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 				    power_mode);
 	if (err)
 		goto default_conf_out;
-	WL_INFO("power save set to %s\n",
-		(power_mode ? "enabled" : "disabled"));
+	brcmf_dbg(INFO, "power save set to %s\n",
+		  (power_mode ? "enabled" : "disabled"));
 
 	err = brcmf_dongle_roam(ndev, (cfg->roam_on ? 0 : 1),
 				WL_BEACON_TIMEOUT);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 7ca1f2e..2ae2a3d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -19,7 +19,6 @@
 
 #include "dhd_dbg.h"
 
-#define	WL_INFO(fmt, ...)	brcmf_dbg(INFO, fmt, ##__VA_ARGS__)
 #define	WL_TRACE(fmt, ...)	brcmf_dbg(TRACE, fmt, ##__VA_ARGS__)
 #define	WL_SCAN(fmt, ...)	brcmf_dbg(SCAN, fmt, ##__VA_ARGS__)
 #define	WL_CONN(fmt, ...)	brcmf_dbg(CONN, fmt, ##__VA_ARGS__)
-- 
1.7.9.5


