Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34238 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965073Ab1GMIrA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 04:47:00 -0400
Subject: [TODO] at76c50x: remove wext includes
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kalle.valo@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jul 2011 10:47:16 +0200
Message-ID: <1310546836.3873.6.camel@jlt3.sipsolutions.net> (sfid-20110713_104704_324549_A1DF1978)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not possible right now:
at76c50x-usb.h:404:11: error: ‘IW_ESSID_MAX_SIZE’ undeclared here (not in a function)
at76c50x-usb.c: In function ‘at76_startup_device’:
at76c50x-usb.c:1371:263: error: ‘IW_MODE_ADHOC’ undeclared (first use in this function)
at76c50x-usb.c:1371:263: note: each undeclared identifier is reported only once for each function it appears in
at76c50x-usb.c: In function ‘at76_add_interface’:
at76c50x-usb.c:1863:19: error: ‘IW_MODE_INFRA’ undeclared (first use in this function)
at76c50x-usb.c: In function ‘at76_init_new_device’:
at76c50x-usb.c:2269:18: error: ‘IW_MODE_INFRA’ undeclared (first use in this function)

but none of those constants should be used in a mac80211 driver.

Also this driver is missing a MAINTAINERS entry.

Cc: Kalle Valo <kalle.valo@iki.fi>
---
 drivers/net/wireless/at76c50x-usb.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/wireless/at76c50x-usb.c	2011-07-13 10:09:37.000000000 +0200
+++ b/drivers/net/wireless/at76c50x-usb.c	2011-07-13 10:09:40.000000000 +0200
@@ -38,8 +38,6 @@
 #include <linux/if_arp.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
-#include <linux/wireless.h>
-#include <net/iw_handler.h>
 #include <net/ieee80211_radiotap.h>
 #include <linux/firmware.h>
 #include <linux/leds.h>


