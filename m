Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61654 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbXKIWrk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 17:47:40 -0500
Date: Fri, 09 Nov 2007 16:47:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Output message at startup if hardware switch for
 radio is off
Message-ID: <4734e389.AF3t4zZIQw1IryOf%Larry.Finger@lwfinger.net> (sfid-20071109_224746_886207_DF3E8755)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that the radio is controlled by rfkill, there is a potential
difficulty in helping a new user get started, as it is unlikely
that they will have setup rfkill. This patch prints a message if
the interface is started with the hardware switch off.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch is intended for the everything branch of wireless-2.6.

Larry

 main.c   |   10 +++++++---
 main.h   |    2 ++
 rfkill.c |    2 +-
 3 files changed, 10 insertions(+), 4 deletions(-)

Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c
+++ wireless-2.6/drivers/net/wireless/b43/main.c
@@ -3181,11 +3181,15 @@ static void setup_struct_phy_for_init(st
 
 static void setup_struct_wldev_for_init(struct b43_wldev *dev)
 {
+	struct b43_wl *wl = dev->wl;
+
 	/* Flags */
 	dev->reg124_set_0x4 = 0;
-	/* Assume the radio is enabled. If it's not enabled, the state will
-	 * immediately get fixed on the first periodic work run. */
-	dev->radio_hw_enable = 1;
+	dev->radio_hw_enable = b43_is_hw_radio_enabled(dev);
+	if (!dev->radio_hw_enable)
+		b43info(wl, "***** The hardware switch for your radio switch"
+			" is off.\n          ***** Until it is switched on,"
+			" your device will not work.\n");
 
 	/* Stats */
 	memset(&dev->stats, 0, sizeof(dev->stats));
Index: wireless-2.6/drivers/net/wireless/b43/main.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.h
+++ wireless-2.6/drivers/net/wireless/b43/main.h
@@ -116,6 +116,8 @@ void b43_mac_enable(struct b43_wldev *de
 
 void b43_controller_restart(struct b43_wldev *dev, const char *reason);
 
+bool b43_is_hw_radio_enabled(struct b43_wldev *dev);
+
 #define B43_PS_ENABLED	(1 << 0)	/* Force enable hardware power saving */
 #define B43_PS_DISABLED	(1 << 1)	/* Force disable hardware power saving */
 #define B43_PS_AWAKE	(1 << 2)	/* Force device awake */
Index: wireless-2.6/drivers/net/wireless/b43/rfkill.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/rfkill.c
+++ wireless-2.6/drivers/net/wireless/b43/rfkill.c
@@ -27,7 +27,7 @@
 
 
 /* Returns TRUE, if the radio is enabled in hardware. */
-static bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
+bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
 {
 	if (dev->phy.rev >= 3) {
 		if (!(b43_read32(dev, B43_MMIO_RADIO_HWENABLED_HI)
