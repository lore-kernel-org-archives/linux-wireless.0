Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:36192 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbXHaTjQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 15:39:16 -0400
Date: Fri, 31 Aug 2007 14:38:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: Change radio hardware switch printk from debug to regular
Message-ID: <46d86e37.3WD2x/BxsTzY/pZ3%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes the printouts of the initial state of the
radio on/off switch from debug to normal mode. The change is
needed because some distros have debug disabled in their precompiled
drivers, which complicates the initial troubleshooting.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
CC: Michael Buesch <mb@bu3sch.de>
---

 main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: wireless-dev/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-dev/drivers/net/wireless/b43legacy/main.c
@@ -2046,7 +2046,7 @@ static int b43legacy_chip_init(struct b4
 		goto err_gpio_cleanup;
 	b43legacy_radio_turn_on(dev);
 	dev->radio_hw_enable = b43legacy_is_hw_radio_enabled(dev);
-	b43legacydbg(dev->wl, "Radio %s by hardware\n",
+	b43legacyinfo(dev->wl, "Radio %s by hardware\n",
 	       (dev->radio_hw_enable == 0) ? "disabled" : "enabled");
 
 	b43legacy_write16(dev, 0x03E6, 0x0000);
@@ -2175,7 +2175,7 @@ static void b43legacy_periodic_every1sec
 	radio_hw_enable = b43legacy_is_hw_radio_enabled(dev);
 	if (unlikely(dev->radio_hw_enable != radio_hw_enable)) {
 		dev->radio_hw_enable = radio_hw_enable;
-		b43legacydbg(dev->wl, "Radio hardware status changed to %s\n",
+		b43legacyinfo(dev->wl, "Radio hardware status changed to %s\n",
 		       (radio_hw_enable == 0) ? "disabled" : "enabled");
 		b43legacy_leds_update(dev, 0);
 	}
