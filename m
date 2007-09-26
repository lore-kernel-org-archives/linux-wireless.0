Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57221 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbXIZMxD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 08:53:03 -0400
Subject: [PATCH] hostapd: don't try setting the generic IE to the kernel
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 26 Sep 2007 14:54:18 +0200
Message-Id: <1190811258.4204.7.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have no mac80211 drivers that generate beacons themselves
and would require this, and we also have no way to support such
drivers currently. Hence, it seems we should remove this to
decrease the confusion. Since the generic hostapd code actually
requires a positive result though we cannot just remove the
implementation. The same information is put into the beacon,
however.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 hostapd/driver_devicescape.c |   14 --------------
 1 file changed, 14 deletions(-)

--- hostap.orig/hostapd/driver_devicescape.c	2007-09-26 14:45:22.000000000 +0200
+++ hostap/hostapd/driver_devicescape.c	2007-09-26 14:47:17.000000000 +0200
@@ -695,20 +695,6 @@ static int i802_sta_set_flags(void *priv
 static int i802_set_generic_elem(const char *ifname, void *priv,
 				 const u8 *elem, size_t elem_len)
 {
-	struct i802_driver_data *drv = priv;
-	struct iwreq iwr;
-
-	memset(&iwr, 0, sizeof(iwr));
-
-	os_strlcpy(iwr.ifr_name, drv->hapd->conf->iface, IFNAMSIZ);
-	iwr.u.data.length = elem_len;
-	iwr.u.data.pointer = (void*)elem;
-
-	if (ioctl(drv->ioctl_sock, SIOCSIWGENIE, &iwr) < 0) {
-		perror("Failed to set generic info element");
-		return -1;
-	}
-
 	return 0;
 }
 


