Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40524 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214AbXHXMRW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 08:17:22 -0400
Subject: [PATCH] hostapd: remove key threshold setting
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 24 Aug 2007 14:18:10 +0200
Message-Id: <1187957890.24933.24.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm in the process of adding this to nl80211 as a per-key setting, so
remove it here for now. It's never called anyway.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 hostapd/driver_devicescape.c |    9 ---------
 1 file changed, 9 deletions(-)

--- hostap.orig/hostapd/driver_devicescape.c	2007-08-24 09:56:52.000000000 +0200
+++ hostap/hostapd/driver_devicescape.c	2007-08-24 09:57:04.000000000 +0200
@@ -999,14 +999,6 @@ static int i802_set_cts_protect(void *pr
 }
 
 
-static int i802_set_key_tx_rx_threshold(void *priv, int value)
-{
-	struct i802_driver_data *drv = priv;
-	return hostap_ioctl_prism2param(drv, PRISM2_PARAM_KEY_TX_RX_THRESHOLD,
-					value);
-}
-
-
 static int i802_set_preamble(void *priv, int value)
 {
 	struct i802_driver_data *drv = priv;
@@ -2041,7 +2033,6 @@ const struct wpa_driver_ops wpa_driver_d
 	.set_dtim_period = i802_set_dtim_period,
 	.set_broadcast_ssid = i802_set_broadcast_ssid,
 	.set_cts_protect = i802_set_cts_protect,
-	.set_key_tx_rx_threshold = i802_set_key_tx_rx_threshold,
 	.set_preamble = i802_set_preamble,
 	.set_short_slot_time = i802_set_short_slot_time,
 	.set_tx_queue_params = i802_set_tx_queue_params,


