Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35892 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbXHOLGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 07:06:13 -0400
Subject: [PATCH] hostapd: fix eloop warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 15 Aug 2007 13:08:51 +0200
Message-Id: <1187176131.3998.29.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a warning that occurs when turning off hostapd.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
Thought I'd send that earlier but it seems I forgot.
This is a slightly modified version of my original patch, please do test
it as I've not been able to test it right now. The original was fine
though, but it shut down the eloop in wireless_event_deinit instead of
here.

--- hostap.orig/hostapd/driver_devicescape.c	2007-08-15 13:06:48.000000000 +0200
+++ hostap/hostapd/driver_devicescape.c	2007-08-15 13:07:39.000000000 +0200
@@ -1954,8 +1954,10 @@ static void i802_deinit(void *priv)
 
 	(void) hostapd_set_iface_flags(drv, 0);
 
-	if (drv->sock >= 0)
+	if (drv->sock >= 0) {
+		eloop_unregister_read_sock(drv->sock);
 		close(drv->sock);
+	}
 	if (drv->ioctl_sock >= 0)
 		close(drv->ioctl_sock);
 


