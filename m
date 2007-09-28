Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52368 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbXI1QEk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 12:04:40 -0400
Subject: Re: hostapd: passing sta info struct to drivers?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1190977157.5021.28.camel@johannes.berg>
References: <1190911599.5021.4.camel@johannes.berg>
	 <20070928011630.GI27241@jm.kir.nu> <1190977157.5021.28.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 18:06:01 +0200
Message-Id: <1190995561.22960.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

How about this then?

---
 hostapd/driver.h             |    8 ++++----
 hostapd/driver_bsd.c         |    3 ++-
 hostapd/driver_devicescape.c |    6 +++---
 hostapd/driver_hostap.c      |    4 ++--
 hostapd/driver_madwifi.c     |    3 ++-
 hostapd/driver_prism54.c     |    3 ++-
 hostapd/ieee802_11.c         |    4 ++--
 hostapd/ieee802_1x.c         |    4 ++--
 hostapd/wme.c                |    6 ++++--
 9 files changed, 23 insertions(+), 18 deletions(-)

--- hostap.orig/hostapd/driver.h	2007-09-28 14:20:48.000000000 +0200
+++ hostap/hostapd/driver.h	2007-09-28 14:21:37.000000000 +0200
@@ -92,7 +92,7 @@ struct wpa_driver_ops {
 	int (*get_retry)(void *priv, int *short_retry, int *long_retry);
 
 	int (*sta_set_flags)(void *priv, const u8 *addr,
-			     int flags_or, int flags_and);
+			     int total_flags, int flags_or, int flags_and);
 	int (*set_rate_sets)(void *priv, int *supp_rates, int *basic_rates,
 			     int mode);
 	int (*set_channel_flag)(void *priv, int mode, int chan, int flag,
@@ -427,12 +427,12 @@ hostapd_get_retry(struct hostapd_data *h
 
 static inline int
 hostapd_sta_set_flags(struct hostapd_data *hapd, u8 *addr,
-		      int flags_or, int flags_and)
+		      int total_flags, int flags_or, int flags_and)
 {
 	if (hapd->driver == NULL || hapd->driver->sta_set_flags == NULL)
 		return 0;
-	return hapd->driver->sta_set_flags(hapd->drv_priv, addr, flags_or,
-					   flags_and);
+	return hapd->driver->sta_set_flags(hapd->drv_priv, addr, total_flags,
+					   flags_or, flags_and);
 }
 
 static inline int
--- hostap.orig/hostapd/driver_bsd.c	2007-09-28 14:21:55.000000000 +0200
+++ hostap/hostapd/driver_bsd.c	2007-09-28 14:22:14.000000000 +0200
@@ -322,7 +322,8 @@ bsd_set_sta_authorized(void *priv, const
 }
 
 static int
-bsd_sta_set_flags(void *priv, const u8 *addr, int flags_or, int flags_and)
+bsd_sta_set_flags(void *priv, const u8 *addr, int total_flags, int flags_or,
+		  int flags_and)
 {
 	/* For now, only support setting Authorized flag */
 	if (flags_or & WLAN_STA_AUTHORIZED)
--- hostap.orig/hostapd/driver_devicescape.c	2007-09-28 14:22:25.000000000 +0200
+++ hostap/hostapd/driver_devicescape.c	2007-09-28 14:22:43.000000000 +0200
@@ -75,7 +75,7 @@ struct i802_driver_data {
 #define HAPD_DECL	struct hostapd_data *hapd = iface->bss[0]
 
 static int i802_sta_set_flags(void *priv, const u8 *addr,
-			      int flags_or, int flags_and);
+			      int total_flags, int flags_or, int flags_and);
 
 
 static int hostapd_set_iface_flags(struct i802_driver_data *drv, int dev_up)
@@ -764,7 +764,7 @@ static int i802_sta_remove(void *priv, c
 	struct i802_driver_data *drv = priv;
 	struct prism2_hostapd_param param;
 
-	i802_sta_set_flags(drv, addr, 0, ~WLAN_STA_AUTHORIZED);
+	i802_sta_set_flags(drv, addr, 0, 0, ~WLAN_STA_AUTHORIZED);
 
 	memset(&param, 0, sizeof(param));
 	param.cmd = PRISM2_HOSTAPD_REMOVE_STA;
@@ -776,7 +776,7 @@ static int i802_sta_remove(void *priv, c
 
 
 static int i802_sta_set_flags(void *priv, const u8 *addr,
-			      int flags_or, int flags_and)
+			      int total_flags, int flags_or, int flags_and)
 {
 	struct i802_driver_data *drv = priv;
 	struct prism2_hostapd_param param;
--- hostap.orig/hostapd/driver_hostap.c	2007-09-28 14:22:54.000000000 +0200
+++ hostap/hostapd/driver_hostap.c	2007-09-28 14:23:15.000000000 +0200
@@ -374,7 +374,7 @@ static int hostap_send_eapol(void *priv,
 
 
 static int hostap_sta_set_flags(void *priv, const u8 *addr,
-				int flags_or, int flags_and)
+				int total_flags, int flags_or, int flags_and)
 {
 	struct hostap_driver_data *drv = priv;
 	struct prism2_hostapd_param param;
@@ -694,7 +694,7 @@ static int hostap_sta_remove(void *priv,
 	struct hostap_driver_data *drv = priv;
 	struct prism2_hostapd_param param;
 
-	hostap_sta_set_flags(drv, addr, 0, ~WLAN_STA_AUTHORIZED);
+	hostap_sta_set_flags(drv, addr, 0, 0, ~WLAN_STA_AUTHORIZED);
 
 	memset(&param, 0, sizeof(param));
 	param.cmd = PRISM2_HOSTAPD_REMOVE_STA;
--- hostap.orig/hostapd/driver_madwifi.c	2007-09-28 14:23:15.000000000 +0200
+++ hostap/hostapd/driver_madwifi.c	2007-09-28 14:23:31.000000000 +0200
@@ -410,7 +410,8 @@ madwifi_set_sta_authorized(void *priv, c
 }
 
 static int
-madwifi_sta_set_flags(void *priv, const u8 *addr, int flags_or, int flags_and)
+madwifi_sta_set_flags(void *priv, const u8 *addr, int total_flags,
+		      int flags_or, int flags_and)
 {
 	/* For now, only support setting Authorized flag */
 	if (flags_or & WLAN_STA_AUTHORIZED)
--- hostap.orig/hostapd/driver_prism54.c	2007-09-28 14:23:35.000000000 +0200
+++ hostap/hostapd/driver_prism54.c	2007-09-28 14:23:49.000000000 +0200
@@ -187,7 +187,8 @@ static int prism54_set_sta_authorized(vo
 
 
 static int
-prism54_sta_set_flags(void *priv, const u8 *addr, int flags_or, int flags_and)
+prism54_sta_set_flags(void *priv, const u8 *addr, int total_flags,
+		      int flags_or, int flags_and)
 {
 	/* For now, only support setting Authorized flag */
 	if (flags_or & WLAN_STA_AUTHORIZED)
--- hostap.orig/hostapd/ieee802_11.c	2007-09-28 14:23:51.000000000 +0200
+++ hostap/hostapd/ieee802_11.c	2007-09-28 14:24:04.000000000 +0200
@@ -1625,10 +1625,10 @@ static void handle_assoc_cb(struct hosta
 		ap_sta_bind_vlan(hapd, sta, 0);
 	}
 	if (sta->flags & WLAN_STA_SHORT_PREAMBLE) {
-		hostapd_sta_set_flags(hapd, sta->addr,
+		hostapd_sta_set_flags(hapd, sta->addr, sta->flags,
 				      WLAN_STA_SHORT_PREAMBLE, ~0);
 	} else {
-		hostapd_sta_set_flags(hapd, sta->addr,
+		hostapd_sta_set_flags(hapd, sta->addr, sta->flags,
 				      0, ~WLAN_STA_SHORT_PREAMBLE);
 	}
 
--- hostap.orig/hostapd/ieee802_1x.c	2007-09-28 14:24:04.000000000 +0200
+++ hostap/hostapd/ieee802_1x.c	2007-09-28 14:24:14.000000000 +0200
@@ -94,13 +94,13 @@ void ieee802_1x_set_sta_authorized(struc
 
 	if (authorized) {
 		sta->flags |= WLAN_STA_AUTHORIZED;
-		res = hostapd_sta_set_flags(hapd, sta->addr,
+		res = hostapd_sta_set_flags(hapd, sta->addr, sta->flags,
 					    WLAN_STA_AUTHORIZED, ~0);
 		hostapd_logger(hapd, sta->addr, HOSTAPD_MODULE_IEEE8021X,
 			       HOSTAPD_LEVEL_DEBUG, "authorizing port");
 	} else {
 		sta->flags &= ~WLAN_STA_AUTHORIZED;
-		res = hostapd_sta_set_flags(hapd, sta->addr,
+		res = hostapd_sta_set_flags(hapd, sta->addr, sta->flags,
 					    0, ~WLAN_STA_AUTHORIZED);
 		hostapd_logger(hapd, sta->addr, HOSTAPD_MODULE_IEEE8021X,
 			       HOSTAPD_LEVEL_DEBUG, "unauthorizing port");
--- hostap.orig/hostapd/wme.c	2007-09-28 14:24:16.000000000 +0200
+++ hostap/hostapd/wme.c	2007-09-28 14:24:33.000000000 +0200
@@ -110,9 +110,11 @@ int hostapd_wme_sta_config(struct hostap
 {
 	/* update kernel STA data for WME related items (WLAN_STA_WPA flag) */
 	if (sta->flags & WLAN_STA_WME)
-		hostapd_sta_set_flags(hapd, sta->addr, WLAN_STA_WME, ~0);
+		hostapd_sta_set_flags(hapd, sta->addr, sta->flags,
+				      WLAN_STA_WME, ~0);
 	else
-		hostapd_sta_set_flags(hapd, sta->addr, 0, ~WLAN_STA_WME);
+		hostapd_sta_set_flags(hapd, sta->addr, sta->flags,
+				      0, ~WLAN_STA_WME);
 
 	return 0;
 }


