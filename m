Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:34172
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbXITUNj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 16:13:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Remove the "radio hw enabled" message on startup.
Date: Thu, 20 Sep 2007 22:12:58 +0200
Cc: linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709202212.58455.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This message is useless. Only report state changes.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <larry.finger@lwfinger.net>

Index: wireless-dev/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43/main.c	2007-09-20 19:39:06.000000000 +0200
+++ wireless-dev/drivers/net/wireless/b43/main.c	2007-09-20 20:06:24.000000000 +0200
@@ -2227,9 +2227,6 @@ static int b43_chip_init(struct b43_wlde
 	if (err)
 		goto err_gpio_cleanup;
 	b43_radio_turn_on(dev);
-	dev->radio_hw_enable = b43_is_hw_radio_enabled(dev);
-	b43dbg(dev->wl, "Radio %s by hardware\n",
-	       dev->radio_hw_enable ? "enabled" : "disabled");
 
 	b43_write16(dev, 0x03E6, 0x0000);
 	err = b43_phy_init(dev);
@@ -3251,6 +3248,9 @@ static void setup_struct_wldev_for_init(
 {
 	/* Flags */
 	dev->reg124_set_0x4 = 0;
+	/* Assume the radio is enabled. If it's not enabled, the state will
+	 * immediately get fixed on the first periodic work run. */
+	dev->radio_hw_enable = 1;
 
 	/* Stats */
 	memset(&dev->stats, 0, sizeof(dev->stats));
