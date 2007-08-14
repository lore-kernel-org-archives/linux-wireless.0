Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:37065
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538AbXHNSN5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 14:13:57 -0400
Message-Id: <20070814181214.599568000@bu3sch.de>
References: <20070814181213.135874000@bu3sch.de>
Date: Tue, 14 Aug 2007 20:12:16 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [patch 3/9] b43: Powerup the bus before accessing any MMIO
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This crashes otherwise.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev-new/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/main.c	2007-08-12 20:17:01.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/main.c	2007-08-12 20:17:07.000000000 +0200
@@ -3619,6 +3619,11 @@ static int b43_wireless_core_attach(stru
 	 * that in core_init(), too.
 	 */
 
+	err = ssb_bus_powerup(bus, 0);
+	if (err) {
+		bcmerr(wl, "Bus powerup failed\n");
+		goto out;
+	}
 	/* Get the PHY type. */
 	if (dev->dev->id.revision >= 5) {
 		u32 tmshigh;
@@ -3637,7 +3642,7 @@ static int b43_wireless_core_attach(stru
 	/* Initialize LEDs structs. */
 	err = b43_leds_init(dev);
 	if (err)
-		goto out;
+		goto err_powerdown;
 
 	dev->phy.gmode = (have_gphy || have_bphy);
 	tmp = dev->phy.gmode ? B43_TMSLOW_GMODE : 0;
@@ -3689,11 +3694,13 @@ static int b43_wireless_core_attach(stru
 	ssb_device_disable(dev->dev, 0);
 	ssb_bus_may_powerdown(bus);
 
-      out:
+out:
 	return err;
 
-      err_leds_exit:
+err_leds_exit:
 	b43_leds_exit(dev);
+err_powerdown:
+	ssb_bus_may_powerdown(bus);
 	return err;
 }
 

-- 

