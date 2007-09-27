Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57631 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbXI0Rzl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 13:55:41 -0400
Subject: Re: hostapd: passing sta info struct to drivers?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1190911599.5021.4.camel@johannes.berg>
References: <1190911599.5021.4.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 27 Sep 2007 19:56:55 +0200
Message-Id: <1190915815.5021.10.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Something like this.

--- hostap.orig/hostapd/driver.h	2007-09-27 18:41:09.000000000 +0200
+++ hostap/hostapd/driver.h	2007-09-27 19:26:52.000000000 +0200
@@ -64,12 +64,12 @@ struct wpa_driver_ops {
 				size_t elem_len);
 
 	int (*read_sta_data)(void *priv, struct hostap_sta_driver_data *data,
-			     const u8 *addr);
+			     const struct sta_info *sta);
 	int (*send_eapol)(void *priv, const u8 *addr, const u8 *data,
 			  size_t data_len, int encrypt, const u8 *own_addr);
 	int (*sta_deauth)(void *priv, const u8 *addr, int reason);
 	int (*sta_disassoc)(void *priv, const u8 *addr, int reason);
-	int (*sta_remove)(void *priv, const u8 *addr);
+	int (*sta_remove)(void *priv, const struct sta_info *sta);
 	int (*get_ssid)(const char *ifname, void *priv, u8 *buf, int len);
 	int (*set_ssid)(const char *ifname, void *priv, const u8 *buf,
 			int len);
@@ -80,8 +80,8 @@ struct wpa_driver_ops {
 	int (*sta_add)(const char *ifname, void *priv, const u8 *addr, u16 aid,
 		       u16 capability, u8 *supp_rates, size_t supp_rates_len,
 		       int flags);
-	int (*get_inact_sec)(void *priv, const u8 *addr);
-	int (*sta_clear_stats)(void *priv, const u8 *addr);
+	int (*get_inact_sec)(void *priv, const struct sta_info *sta);
+	int (*sta_clear_stats)(void *priv, const struct sta_info *sta);
 
 	int (*set_freq)(void *priv, int mode, int freq);
 	int (*set_rts)(void *priv, int rts);
@@ -91,7 +91,7 @@ struct wpa_driver_ops {
 	int (*set_retry)(void *priv, int short_retry, int long_retry);
 	int (*get_retry)(void *priv, int *short_retry, int *long_retry);
 
-	int (*sta_set_flags)(void *priv, const u8 *addr,
+	int (*sta_set_flags)(void *priv, const struct sta_info *sta,
 			     int flags_or, int flags_and);
 	int (*set_rate_sets)(void *priv, int *supp_rates, int *basic_rates,
 			     int mode);
@@ -142,8 +142,8 @@ struct wpa_driver_ops {
 			 char *ifname, const u8 *addr);
 	int (*if_remove)(void *priv, enum hostapd_driver_if_type type,
 			 const char *ifname, const u8 *addr);
-	int (*set_sta_vlan)(void *priv, const u8 *addr, const char *ifname,
-			    int vlan_id);
+	int (*set_sta_vlan)(void *priv, const struct sta_info *sta,
+			    const char *ifname, int vlan_id);
 	/**
 	 * commit - Optional commit changes handler
 	 * @priv: driver private data
@@ -263,11 +263,12 @@ hostapd_set_generic_elem(struct hostapd_
 
 static inline int
 hostapd_read_sta_data(struct hostapd_data *hapd,
-		      struct hostap_sta_driver_data *data, const u8 *addr)
+		      struct hostap_sta_driver_data *data,
+		      const struct sta_info *sta)
 {
 	if (hapd->driver == NULL || hapd->driver->read_sta_data == NULL)
 		return -1;
-	return hapd->driver->read_sta_data(hapd->drv_priv, data, addr);
+	return hapd->driver->read_sta_data(hapd->drv_priv, data, sta);
 }
 
 static inline int
@@ -297,11 +298,11 @@ hostapd_sta_disassoc(struct hostapd_data
 }
 
 static inline int
-hostapd_sta_remove(struct hostapd_data *hapd, const u8 *addr)
+hostapd_sta_remove(struct hostapd_data *hapd, const struct sta_info *sta)
 {
 	if (hapd->driver == NULL || hapd->driver->sta_remove == NULL)
 		return 0;
-	return hapd->driver->sta_remove(hapd->drv_priv, addr);
+	return hapd->driver->sta_remove(hapd->drv_priv, sta);
 }
 
 static inline int
@@ -360,11 +361,11 @@ hostapd_sta_add(const char *ifname, stru
 }
 
 static inline int
-hostapd_get_inact_sec(struct hostapd_data *hapd, const u8 *addr)
+hostapd_get_inact_sec(struct hostapd_data *hapd, const struct sta_info *sta)
 {
 	if (hapd->driver == NULL || hapd->driver->get_inact_sec == NULL)
 		return 0;
-	return hapd->driver->get_inact_sec(hapd->drv_priv, addr);
+	return hapd->driver->get_inact_sec(hapd->drv_priv, sta);
 }
 
 static inline int
@@ -426,12 +427,12 @@ hostapd_get_retry(struct hostapd_data *h
 }
 
 static inline int
-hostapd_sta_set_flags(struct hostapd_data *hapd, u8 *addr,
+hostapd_sta_set_flags(struct hostapd_data *hapd, const struct sta_info *sta,
 		      int flags_or, int flags_and)
 {
 	if (hapd->driver == NULL || hapd->driver->sta_set_flags == NULL)
 		return 0;
-	return hapd->driver->sta_set_flags(hapd->drv_priv, addr, flags_or,
+	return hapd->driver->sta_set_flags(hapd->drv_priv, sta, flags_or,
 					   flags_and);
 }
 
@@ -484,11 +485,11 @@ hostapd_set_ieee80211d(struct hostapd_da
 }
 
 static inline int
-hostapd_sta_clear_stats(struct hostapd_data *hapd, const u8 *addr)
+hostapd_sta_clear_stats(struct hostapd_data *hapd, const struct sta_info *sta)
 {
 	if (hapd->driver == NULL || hapd->driver->sta_clear_stats == NULL)
 		return 0;
-	return hapd->driver->sta_clear_stats(hapd->drv_priv, addr);
+	return hapd->driver->sta_clear_stats(hapd->drv_priv, sta);
 }
 
 static inline int
@@ -654,11 +655,11 @@ hostapd_get_hw_feature_data(struct hosta
 
 static inline int
 hostapd_set_sta_vlan(const char *ifname, struct hostapd_data *hapd,
-		     const u8 *addr, int vlan_id)
+		     const struct sta_info *sta, int vlan_id)
 {
 	if (hapd->driver == NULL || hapd->driver->set_sta_vlan == NULL)
 		return 0;
-	return hapd->driver->set_sta_vlan(hapd->drv_priv, addr, ifname, vlan_id);
+	return hapd->driver->set_sta_vlan(hapd->drv_priv, sta, ifname, vlan_id);
 }
 
 static inline int
--- hostap.orig/hostapd/accounting.c	2007-09-27 19:27:31.000000000 +0200
+++ hostap/hostapd/accounting.c	2007-09-27 19:27:43.000000000 +0200
@@ -185,7 +185,7 @@ static int accounting_sta_update_stats(s
 				       struct sta_info *sta,
 				       struct hostap_sta_driver_data *data)
 {
-	if (hostapd_read_sta_data(hapd, data, sta->addr))
+	if (hostapd_read_sta_data(hapd, data, sta))
 		return -1;
 
 	if (sta->last_rx_bytes > data->rx_bytes)
@@ -237,7 +237,7 @@ void accounting_sta_start(struct hostapd
 	time(&sta->acct_session_start);
 	sta->last_rx_bytes = sta->last_tx_bytes = 0;
 	sta->acct_input_gigawords = sta->acct_output_gigawords = 0;
-	hostapd_sta_clear_stats(hapd, sta->addr);
+	hostapd_sta_clear_stats(hapd, sta);
 
 	if (!hapd->conf->radius->acct_server)
 		return;
--- hostap.orig/hostapd/ieee802_1x.c	2007-09-27 19:27:08.000000000 +0200
+++ hostap/hostapd/ieee802_1x.c	2007-09-27 19:27:18.000000000 +0200
@@ -94,13 +94,13 @@ void ieee802_1x_set_sta_authorized(struc
 
 	if (authorized) {
 		sta->flags |= WLAN_STA_AUTHORIZED;
-		res = hostapd_sta_set_flags(hapd, sta->addr,
+		res = hostapd_sta_set_flags(hapd, sta,
 					    WLAN_STA_AUTHORIZED, ~0);
 		hostapd_logger(hapd, sta->addr, HOSTAPD_MODULE_IEEE8021X,
 			       HOSTAPD_LEVEL_DEBUG, "authorizing port");
 	} else {
 		sta->flags &= ~WLAN_STA_AUTHORIZED;
-		res = hostapd_sta_set_flags(hapd, sta->addr,
+		res = hostapd_sta_set_flags(hapd, sta,
 					    0, ~WLAN_STA_AUTHORIZED);
 		hostapd_logger(hapd, sta->addr, HOSTAPD_MODULE_IEEE8021X,
 			       HOSTAPD_LEVEL_DEBUG, "unauthorizing port");
--- hostap.orig/hostapd/sta_info.c	2007-09-27 19:27:50.000000000 +0200
+++ hostap/hostapd/sta_info.c	2007-09-27 19:28:16.000000000 +0200
@@ -117,7 +117,7 @@ void ap_free_sta(struct hostapd_data *ha
 
 	if (!ap_sta_in_other_bss(hapd, sta, WLAN_STA_ASSOC) &&
 	    !(sta->flags & WLAN_STA_PREAUTH))
-		hostapd_sta_remove(hapd, sta->addr);
+		hostapd_sta_remove(hapd, sta);
 
 	ap_sta_hash_del(hapd, sta);
 	ap_sta_list_del(hapd, sta);
@@ -209,7 +209,7 @@ void ap_handle_timer(void *eloop_ctx, vo
 		HOSTAPD_DEBUG(HOSTAPD_DEBUG_MINIMAL,
 			      "Checking STA " MACSTR " inactivity:\n",
 			      MAC2STR(sta->addr));
-		inactive_sec = hostapd_get_inact_sec(hapd, sta->addr);
+		inactive_sec = hostapd_get_inact_sec(hapd, sta);
 		if (inactive_sec == -1) {
 			printf("  Could not get station info from kernel "
 			       "driver for " MACSTR ".\n",
@@ -408,7 +408,7 @@ static int ap_sta_remove(struct hostapd_
 
 	HOSTAPD_DEBUG(HOSTAPD_DEBUG_MINIMAL, "Removing STA " MACSTR
 		      " from kernel driver\n", MAC2STR(sta->addr));
-	if (hostapd_sta_remove(hapd, sta->addr) &&
+	if (hostapd_sta_remove(hapd, sta) &&
 	    sta->flags & WLAN_STA_ASSOC) {
 		printf("Could not remove station " MACSTR " from kernel "
 		       "driver.\n", MAC2STR(sta->addr));
@@ -580,5 +580,5 @@ int ap_sta_bind_vlan(struct hostapd_data
 	if (wpa_auth_sta_set_vlan(sta->wpa_sm, sta->vlan_id) < 0)
 		wpa_printf(MSG_INFO, "Failed to update VLAN-ID for WPA");
 
-	return hostapd_set_sta_vlan(iface, hapd, sta->addr, sta->vlan_id);
+	return hostapd_set_sta_vlan(iface, hapd, sta, sta->vlan_id);
 }
--- hostap.orig/hostapd/wme.c	2007-09-27 19:28:23.000000000 +0200
+++ hostap/hostapd/wme.c	2007-09-27 19:28:28.000000000 +0200
@@ -110,9 +110,9 @@ int hostapd_wme_sta_config(struct hostap
 {
 	/* update kernel STA data for WME related items (WLAN_STA_WPA flag) */
 	if (sta->flags & WLAN_STA_WME)
-		hostapd_sta_set_flags(hapd, sta->addr, WLAN_STA_WME, ~0);
+		hostapd_sta_set_flags(hapd, sta, WLAN_STA_WME, ~0);
 	else
-		hostapd_sta_set_flags(hapd, sta->addr, 0, ~WLAN_STA_WME);
+		hostapd_sta_set_flags(hapd, sta, 0, ~WLAN_STA_WME);
 
 	return 0;
 }


