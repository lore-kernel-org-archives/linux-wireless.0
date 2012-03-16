Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36487 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032863Ab2CPOzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 10:55:47 -0400
From: Vivek Natarajan <nataraja@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: [RFC] wpa_supplicant: Add support for ACS.
Date: Fri, 16 Mar 2012 20:25:33 +0530
Message-ID: <1331909733-16767-2-git-send-email-nataraja@qca.qualcomm.com> (sfid-20120316_155619_745732_DEA16ED9)
In-Reply-To: <1331909733-16767-1-git-send-email-nataraja@qca.qualcomm.com>
References: <1331909733-16767-1-git-send-email-nataraja@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the frequency is set as 0 in the conf file, pass it to the driver
for using automatic channel selection instead of hardcoding the channel
as 11. Since some drivers have the capability to choose the channel
based on the channel conditions, this patch enables that flexibility.

Signed-hostap-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
---
 src/ap/hw_features.c         |    3 ++-
 src/drivers/driver.h         |    2 ++
 src/drivers/driver_nl80211.c |    8 +++++++-
 wpa_supplicant/ap.c          |    8 +++++---
 4 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/src/ap/hw_features.c b/src/ap/hw_features.c
index 8c6fef2..997d205 100644
--- a/src/ap/hw_features.c
+++ b/src/ap/hw_features.c
@@ -677,7 +677,8 @@ int hostapd_select_hw_mode(struct hostapd_iface *iface)
 		 * the channel automatically */
 		wpa_printf(MSG_ERROR, "Channel not configured "
 			   "(hw_mode/channel in hostapd.conf)");
-		return -3;
+		if (!(iface->drv_flags & WPA_DRIVER_FLAGS_ACS))
+			return -3;
 	}
 	if (ok == 0 && iface->conf->channel != 0) {
 		hostapd_logger(iface->bss[0], NULL,
diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index 04aedcf..92e078b 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -790,6 +790,8 @@ struct wpa_driver_capa {
 #define WPA_DRIVER_FLAGS_PROBE_RESP_OFFLOAD		0x00200000
 /* Driver supports U-APSD in AP mode */
 #define WPA_DRIVER_FLAGS_AP_UAPSD			0x00400000
+#define WPA_DRIVER_FLAGS_ACS				0x00800000
+
 	unsigned int flags;
 
 	int max_scan_ssids;
diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index 184b26f..1f0e6ee 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -2466,6 +2466,11 @@ broken_combination:
 		capa->flags |= WPA_DRIVER_FLAGS_BSS_SELECTION;
 	}
 
+	if (tb[NL80211_ATTR_ACS]) {
+		wpa_printf(MSG_DEBUG, "nl80211: Using driver-based ACS");
+		capa->flags |= WPA_DRIVER_FLAGS_ACS;
+	}
+
 	/* default to 5000 since early versions of mac80211 don't set it */
 	capa->max_remain_on_chan = 5000;
 
@@ -6365,7 +6370,8 @@ static int wpa_driver_nl80211_ap(struct wpa_driver_nl80211_data *drv,
 		nlmode = NL80211_IFTYPE_AP;
 
 	if (wpa_driver_nl80211_set_mode(&drv->first_bss, nlmode) ||
-	    wpa_driver_nl80211_set_freq(&drv->first_bss, params->freq, 0, 0)) {
+	   ((params->freq) &&
+	   wpa_driver_nl80211_set_freq(&drv->first_bss, params->freq, 0, 0))) {
 		nl80211_remove_monitor_interface(drv);
 		return -1;
 	}
diff --git a/wpa_supplicant/ap.c b/wpa_supplicant/ap.c
index 48a6169..6a9187c 100644
--- a/wpa_supplicant/ap.c
+++ b/wpa_supplicant/ap.c
@@ -53,9 +53,11 @@ static int wpa_supplicant_conf_ap(struct wpa_supplicant *wpa_s,
 	os_strlcpy(bss->iface, wpa_s->ifname, sizeof(bss->iface));
 
 	if (ssid->frequency == 0) {
-		/* default channel 11 */
-		conf->hw_mode = HOSTAPD_MODE_IEEE80211G;
-		conf->channel = 11;
+		if (!(wpa_s->drv_flags & WPA_DRIVER_FLAGS_ACS)) {
+			/* default channel 11 */
+			conf->hw_mode = HOSTAPD_MODE_IEEE80211G;
+			conf->channel = 11;
+		}
 	} else if (ssid->frequency >= 2412 && ssid->frequency <= 2472) {
 		conf->hw_mode = HOSTAPD_MODE_IEEE80211G;
 		conf->channel = (ssid->frequency - 2407) / 5;
-- 
1.7.0.4

