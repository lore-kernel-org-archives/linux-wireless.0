Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4898 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758779Ab1EMKAP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:15 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Sukesh Srikakula" <sukeshs@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 25/32] staging: brcm80211: Added support to change
 roaming parameters from brcmfmac driver
Date: Fri, 13 May 2011 11:59:45 +0200
Message-ID: <1305280792-9475-25-git-send-email-arend@broadcom.com> (sfid-20110513_120023_788083_7A8B866C)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sukesh Srikakula <sukeshs@broadcom.com>

'wl_dongle_roam' function moved out of conditional compilation to allow
the fullmac driver to change FW roaming parameters

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   97 ++++++++++++++--------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |    4 +
 2 files changed, 66 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 27baf56..e90015c 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -259,8 +259,6 @@ static s32 wl_dongle_up(struct net_device *ndev, u32 up);
 static s32 wl_dongle_power(struct net_device *ndev, u32 power_mode);
 static s32 wl_dongle_glom(struct net_device *ndev, u32 glom,
 			    u32 dongle_align);
-static s32 wl_dongle_roam(struct net_device *ndev, u32 roamvar,
-			    u32 bcn_timeout);
 static s32 wl_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 				s32 scan_unassoc_time);
 static s32 wl_dongle_offload(struct net_device *ndev, s32 arpoe,
@@ -272,6 +270,8 @@ static s32 wl_update_wiphybands(struct wl_priv *wl);
 
 static s32 wl_dongle_eventmsg(struct net_device *ndev);
 static s32 wl_config_dongle(struct wl_priv *wl, bool need_lock);
+static s32 wl_dongle_roam(struct net_device *ndev, u32 roamvar,
+			    u32 bcn_timeout);
 
 /*
 ** iscan handler
@@ -3633,36 +3633,6 @@ dongle_glom_out:
 }
 
 static s32
-wl_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
-{
-	s8 iovbuf[WL_EVENTING_MASK_LEN + 12];	/*  Room for "event_msgs" +
-						 '\0' + bitvec  */
-	s32 err = 0;
-
-	/* Setup timeout if Beacons are lost and roam is
-		 off to report link down */
-	if (roamvar) {
-		bcm_mkiovar("bcn_timeout", (char *)&bcn_timeout, 4, iovbuf,
-			    sizeof(iovbuf));
-		err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
-		if (unlikely(err)) {
-			WL_ERR("bcn_timeout error (%d)\n", err);
-			goto dongle_rom_out;
-		}
-	}
-	/* Enable/Disable built-in roaming to allow supplicant
-		 to take care of roaming */
-	bcm_mkiovar("roam_off", (char *)&roamvar, 4, iovbuf, sizeof(iovbuf));
-	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
-	if (unlikely(err)) {
-		WL_ERR("roam_off error (%d)\n", err);
-		goto dongle_rom_out;
-	}
-dongle_rom_out:
-	return err;
-}
-
-static s32
 wl_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 		   s32 scan_unassoc_time)
 {
@@ -3890,6 +3860,63 @@ dongle_eventmsg_out:
 	return err;
 }
 
+static s32
+wl_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
+{
+	s8 iovbuf[32];
+	s32 roamtrigger[2];
+	s32 roam_delta[2];
+	s32 err = 0;
+
+	/*
+	 * Setup timeout if Beacons are lost and roam is
+	 * off to report link down
+	 */
+	if (roamvar) {
+		bcm_mkiovar("bcn_timeout", (char *)&bcn_timeout,
+			sizeof(bcn_timeout), iovbuf, sizeof(iovbuf));
+		err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
+		if (unlikely(err)) {
+			WL_ERR("bcn_timeout error (%d)\n", err);
+			goto dongle_rom_out;
+		}
+	}
+
+	/*
+	 * Enable/Disable built-in roaming to allow supplicant
+	 * to take care of roaming
+	 */
+	WL_INFO("Internal Roaming = %s\n", roamvar ? "Off" : "On");
+	bcm_mkiovar("roam_off", (char *)&roamvar,
+				sizeof(roamvar), iovbuf, sizeof(iovbuf));
+	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
+	if (unlikely(err)) {
+		WL_ERR("roam_off error (%d)\n", err);
+		goto dongle_rom_out;
+	}
+
+	roamtrigger[0] = WL_ROAM_TRIGGER_LEVEL;
+	roamtrigger[1] = WLC_BAND_ALL;
+	err = wl_dev_ioctl(ndev, WLC_SET_ROAM_TRIGGER,
+			(void *)roamtrigger, sizeof(roamtrigger));
+	if (unlikely(err)) {
+		WL_ERR("WLC_SET_ROAM_TRIGGER error (%d)\n", err);
+		goto dongle_rom_out;
+	}
+
+	roam_delta[0] = WL_ROAM_DELTA;
+	roam_delta[1] = WLC_BAND_ALL;
+	err = wl_dev_ioctl(ndev, WLC_SET_ROAM_DELTA,
+				(void *)roam_delta, sizeof(roam_delta));
+	if (unlikely(err)) {
+		WL_ERR("WLC_SET_ROAM_DELTA error (%d)\n", err);
+		goto dongle_rom_out;
+	}
+
+dongle_rom_out:
+	return err;
+}
+
 s32 wl_config_dongle(struct wl_priv *wl, bool need_lock)
 {
 #ifndef DHD_SDALIGN
@@ -3920,9 +3947,6 @@ s32 wl_config_dongle(struct wl_priv *wl, bool need_lock)
 	err = wl_dongle_glom(ndev, 0, DHD_SDALIGN);
 	if (unlikely(err))
 		goto default_conf_out;
-	err = wl_dongle_roam(ndev, (wl->roam_on ? 0 : 1), 3);
-	if (unlikely(err))
-		goto default_conf_out;
 	wl_dongle_scantime(ndev, 40, 80);
 	wl_dongle_offload(ndev, 1, 0xf);
 	wl_dongle_filter(ndev, 1);
@@ -3931,6 +3955,9 @@ s32 wl_config_dongle(struct wl_priv *wl, bool need_lock)
 	err = wl_dongle_eventmsg(ndev);
 	if (unlikely(err))
 		goto default_conf_out;
+	err = wl_dongle_roam(ndev, (wl->roam_on ? 0 : 1), WL_BEACON_TIMEOUT);
+	if (unlikely(err))
+		goto default_conf_out;
 	err = wl_dongle_mode(ndev, wdev->iftype);
 	if (unlikely(err && err != -EINPROGRESS))
 		goto default_conf_out;
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 6b61010..04381a9 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -95,6 +95,10 @@ do {								\
 				 */
 #define WL_FILE_NAME_MAX		256
 
+#define WL_ROAM_TRIGGER_LEVEL		-75
+#define WL_ROAM_DELTA			20
+#define WL_BEACON_TIMEOUT		3
+
 /* dongle status */
 enum wl_status {
 	WL_STATUS_READY,
-- 
1.7.4.1


