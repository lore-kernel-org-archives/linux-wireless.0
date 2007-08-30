Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55937 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbXH3NPl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 09:15:41 -0400
Subject: [PATCH] hostapd: driver_devicescape: remove set_broadcast_ssid
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 15:16:52 +0200
Message-Id: <1188479812.2963.36.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 doesn't have any drivers that care about this flag which
is not really surprising: hostapd is responsible for this setting
since it creates the beacon. Remove the callback.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 hostapd/driver_devicescape.c |    9 ---------
 1 file changed, 9 deletions(-)

--- hostap.orig/hostapd/driver_devicescape.c	2007-08-30 15:15:23.000000000 +0200
+++ hostap/hostapd/driver_devicescape.c	2007-08-30 15:15:24.000000000 +0200
@@ -929,14 +929,6 @@ static int i802_set_dtim_period(const ch
 }
 
 
-static int i802_set_broadcast_ssid(void *priv, int value)
-{
-	struct i802_driver_data *drv = priv;
-	return hostap_ioctl_prism2param(drv, PRISM2_PARAM_BROADCAST_SSID,
-					value);
-}
-
-
 static int i802_set_cts_protect(void *priv, int value)
 {
 	struct i802_driver_data *drv = priv;
@@ -1993,7 +1985,6 @@ const struct wpa_driver_ops wpa_driver_d
 	.set_internal_bridge = i802_set_internal_bridge,
 	.set_beacon_int = i802_set_beacon_int,
 	.set_dtim_period = i802_set_dtim_period,
-	.set_broadcast_ssid = i802_set_broadcast_ssid,
 	.set_cts_protect = i802_set_cts_protect,
 	.set_preamble = i802_set_preamble,
 	.set_short_slot_time = i802_set_short_slot_time,


