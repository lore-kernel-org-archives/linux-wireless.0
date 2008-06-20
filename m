Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48428 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687AbYFTPtC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 11:49:02 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add simple firmware watchdog
Date: Fri, 20 Jun 2008 17:44:02 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200806201744.03128.mb@bu3sch.de> (sfid-20080620_174909_141012_2380E798)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a simple firmware watchdog for the opensource firmware.
This will check every 15 seconds, if the firmware zeroed out the watchdog
register. The firmware will do this in its eventloop.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue for 2.6.27


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-06-20 17:39:21.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-06-20 17:40:06.000000000 +0200
@@ -2805,12 +2805,27 @@ static void b43_periodic_every30sec(stru
 	b43_calculate_link_quality(dev);
 }
 
 static void b43_periodic_every15sec(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
+	u16 wdr;
+
+	if (dev->fw.opensource) {
+		/* Check if the firmware is still alive.
+		 * It will reset the watchdog counter to 0 in its idle loop. */
+		wdr = b43_shm_read16(dev, B43_SHM_SCRATCH, B43_WATCHDOG_REG);
+		if (unlikely(wdr)) {
+			b43err(dev->wl, "Firmware watchdog: The firmware died!\n");
+			b43_controller_restart(dev, "Firmware watchdog");
+			return;
+		} else {
+			b43_shm_write16(dev, B43_SHM_SCRATCH,
+					B43_WATCHDOG_REG, 1);
+		}
+	}
 
 	if (phy->type == B43_PHYTYPE_G) {
 		//TODO: update_aci_moving_average
 		if (phy->aci_enable && phy->aci_wlan_automatic) {
 			b43_mac_suspend(dev);
 			if (!phy->aci_enable && 1 /*TODO: not scanning? */ ) {
Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-06-20 17:39:21.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-06-20 17:40:06.000000000 +0200
@@ -438,12 +438,14 @@ enum {
 /* The firmware register to fetch the panic reason from. */
 #define B43_FWPANIC_REASON_REG		3
 /* Firmware panic reason codes */
 #define B43_FWPANIC_DIE			0 /* Firmware died. Don't auto-restart it. */
 #define B43_FWPANIC_RESTART		1 /* Firmware died. Schedule a controller reset. */
 
+/* The firmware register that contains the watchdog counter. */
+#define B43_WATCHDOG_REG		1
 
 /* Device specific rate values.
  * The actual values defined here are (rate_in_mbps * 2).
  * Some code depends on this. Don't change it. */
 #define B43_CCK_RATE_1MB		0x02
 #define B43_CCK_RATE_2MB		0x04
