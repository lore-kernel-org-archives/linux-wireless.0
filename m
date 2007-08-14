Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57267 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758935AbXHNLuf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 07:50:35 -0400
Message-Id: <20070814093408.541566000@sipsolutions.net>
References: <20070814093254.021041000@sipsolutions.net>
Date: Tue, 14 Aug 2007 11:32:55 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/4] hostapd: remove enable/disable calls
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This isn't really useful since mac80211 always enables the radio
when the interface is brought up.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 hostapd/driver_devicescape.c |    6 ------
 1 file changed, 6 deletions(-)

--- hostap.orig/hostapd/driver_devicescape.c	2007-08-14 11:32:34.000000000 +0200
+++ hostap/hostapd/driver_devicescape.c	2007-08-14 11:32:34.000000000 +0200
@@ -2075,9 +2075,6 @@ static void * i802_init(struct hostapd_d
 	if (i802_init_sockets(drv))
 		goto failed;
 
-	/* Enable the radio by default. */
-	(void) hostap_ioctl_prism2param(drv, PRISM2_PARAM_RADIO_ENABLED, 1);
-
 	return drv;
 
 failed:
@@ -2091,9 +2088,6 @@ static void i802_deinit(void *priv)
 	struct i802_driver_data *drv = priv;
 	struct nl_msg *msg;
 
-	/* Disable the radio. */
-	(void) hostap_ioctl_prism2param(drv, PRISM2_PARAM_RADIO_ENABLED, 0);
-
 	(void) hostapd_set_iface_flags(drv, 0);
 
 	if (drv->ioctl_sock >= 0)

-- 

