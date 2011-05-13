Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4887 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757971Ab1EMKAP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:15 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Sukesh Srikakula" <sukeshs@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 26/32] staging: brcm80211: Added support to change scan
 times from brcmfmac driver
Date: Fri, 13 May 2011 11:59:46 +0200
Message-ID: <1305280792-9475-26-git-send-email-arend@broadcom.com> (sfid-20110513_120023_271761_A61E86F9)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sukesh Srikakula <sukeshs@broadcom.com>

wl_dongle_scantime function moved out of conditional compilation to allow
the fullmac driver to change FW scan times.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   81 ++++++++++++---------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |    4 +
 2 files changed, 50 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index e90015c..450e072 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -259,8 +259,6 @@ static s32 wl_dongle_up(struct net_device *ndev, u32 up);
 static s32 wl_dongle_power(struct net_device *ndev, u32 power_mode);
 static s32 wl_dongle_glom(struct net_device *ndev, u32 glom,
 			    u32 dongle_align);
-static s32 wl_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
-				s32 scan_unassoc_time);
 static s32 wl_dongle_offload(struct net_device *ndev, s32 arpoe,
 			       s32 arp_ol);
 static s32 wl_pattern_atoh(s8 *src, s8 *dst);
@@ -269,6 +267,8 @@ static s32 wl_update_wiphybands(struct wl_priv *wl);
 #endif				/* !EMBEDDED_PLATFORM */
 
 static s32 wl_dongle_eventmsg(struct net_device *ndev);
+static s32 wl_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
+				s32 scan_unassoc_time, s32 scan_passive_time);
 static s32 wl_config_dongle(struct wl_priv *wl, bool need_lock);
 static s32 wl_dongle_roam(struct net_device *ndev, u32 roamvar,
 			    u32 bcn_timeout);
@@ -3633,37 +3633,6 @@ dongle_glom_out:
 }
 
 static s32
-wl_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
-		   s32 scan_unassoc_time)
-{
-	s32 err = 0;
-
-	err = wl_dev_ioctl(ndev, WLC_SET_SCAN_CHANNEL_TIME, &scan_assoc_time,
-			sizeof(scan_assoc_time));
-	if (err) {
-		if (err == -EOPNOTSUPP) {
-			WL_INFO("Scan assoc time is not supported\n");
-		} else {
-			WL_ERR("Scan assoc time error (%d)\n", err);
-		}
-		goto dongle_scantime_out;
-	}
-	err = wl_dev_ioctl(ndev, WLC_SET_SCAN_UNASSOC_TIME, &scan_unassoc_time,
-			sizeof(scan_unassoc_time));
-	if (err) {
-		if (err == -EOPNOTSUPP) {
-			WL_INFO("Scan unassoc time is not supported\n");
-		} else {
-			WL_ERR("Scan unassoc time error (%d)\n", err);
-		}
-		goto dongle_scantime_out;
-	}
-
-dongle_scantime_out:
-	return err;
-}
-
-static s32
 wl_dongle_offload(struct net_device *ndev, s32 arpoe, s32 arp_ol)
 {
 	s8 iovbuf[WL_EVENTING_MASK_LEN + 12];	/*  Room for "event_msgs" +
@@ -3917,6 +3886,45 @@ dongle_rom_out:
 	return err;
 }
 
+static s32
+wl_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
+		s32 scan_unassoc_time, s32 scan_passive_time)
+{
+	s32 err = 0;
+
+	err = wl_dev_ioctl(ndev, WLC_SET_SCAN_CHANNEL_TIME, &scan_assoc_time,
+			sizeof(scan_assoc_time));
+	if (err) {
+		if (err == -EOPNOTSUPP)
+			WL_INFO("Scan assoc time is not supported\n");
+		else
+			WL_ERR("Scan assoc time error (%d)\n", err);
+		goto dongle_scantime_out;
+	}
+	err = wl_dev_ioctl(ndev, WLC_SET_SCAN_UNASSOC_TIME, &scan_unassoc_time,
+			sizeof(scan_unassoc_time));
+	if (err) {
+		if (err == -EOPNOTSUPP)
+			WL_INFO("Scan unassoc time is not supported\n");
+		else
+			WL_ERR("Scan unassoc time error (%d)\n", err);
+		goto dongle_scantime_out;
+	}
+
+	err = wl_dev_ioctl(ndev, WLC_SET_SCAN_PASSIVE_TIME, &scan_passive_time,
+			sizeof(scan_passive_time));
+	if (err) {
+		if (err == -EOPNOTSUPP)
+			WL_INFO("Scan passive time is not supported\n");
+		else
+			WL_ERR("Scan passive time error (%d)\n", err);
+		goto dongle_scantime_out;
+	}
+
+dongle_scantime_out:
+	return err;
+}
+
 s32 wl_config_dongle(struct wl_priv *wl, bool need_lock)
 {
 #ifndef DHD_SDALIGN
@@ -3947,10 +3955,13 @@ s32 wl_config_dongle(struct wl_priv *wl, bool need_lock)
 	err = wl_dongle_glom(ndev, 0, DHD_SDALIGN);
 	if (unlikely(err))
 		goto default_conf_out;
-	wl_dongle_scantime(ndev, 40, 80);
+
 	wl_dongle_offload(ndev, 1, 0xf);
 	wl_dongle_filter(ndev, 1);
-#endif				/* !EMBEDDED_PLATFORM */
+#endif /* !EMBEDDED_PLATFORM */
+
+	wl_dongle_scantime(ndev, WL_SCAN_CHANNEL_TIME,
+			WL_SCAN_UNASSOC_TIME, WL_SCAN_PASSIVE_TIME);
 
 	err = wl_dongle_eventmsg(ndev);
 	if (unlikely(err))
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 04381a9..ced637d 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -99,6 +99,10 @@ do {								\
 #define WL_ROAM_DELTA			20
 #define WL_BEACON_TIMEOUT		3
 
+#define WL_SCAN_CHANNEL_TIME		40
+#define WL_SCAN_UNASSOC_TIME		40
+#define WL_SCAN_PASSIVE_TIME		120
+
 /* dongle status */
 enum wl_status {
 	WL_STATUS_READY,
-- 
1.7.4.1


