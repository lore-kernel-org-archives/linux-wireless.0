Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62943 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966044Ab0BZU3B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 15:29:01 -0500
Date: Fri, 26 Feb 2010 14:28:58 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: torvalds@linux-foundation.org, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Make driver fall back gracefully to PIO mode after
 fatal DMA errors
Message-ID: <4b882f0a.mh6Uqo07p1AwjuBv%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Subject: Make b43 driver fall back gracefully to PIO mode after fatal DMA errors
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Feb 2010 10:34:27 -0800 (PST)

This makes the b43 driver just automatically fall back to PIO mode when 
DMA doesn't work.

The driver already told the user to do it, so rather than have the user 
reload the module with a new flag, just make the driver do it 
automatically. We keep the message as an indication that something is 
wrong, but now just automatically fall back to the hopefully working PIO 
case.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

John,

This version will work with wireless-testing.

Larry
---

Index: wireless-testing/drivers/net/wireless/b43/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/Kconfig
+++ wireless-testing/drivers/net/wireless/b43/Kconfig
@@ -3,7 +3,6 @@ config B43
 	depends on SSB_POSSIBLE && MAC80211 && HAS_DMA
 	select SSB
 	select FW_LOADER
-	select SSB_BLOCKIO
 	---help---
 	  b43 is a driver for the Broadcom 43xx series wireless devices.
 
@@ -79,6 +78,14 @@ config B43_SDIO
 
 	  If unsure, say N.
 
+#Data transfers to the device via PIO. We want it as a fallback even
+# if we can do DMA.
+config B43_PIO
+	bool
+	depends on B43
+	select SSB_BLOCKIO
+	default y
+
 config B43_NPHY
 	bool "Pre IEEE 802.11n support (BROKEN)"
 	depends on B43 && EXPERIMENTAL && BROKEN
@@ -130,4 +137,12 @@ config B43_DEBUG
 	  for production use.
 	  Only say Y, if you are debugging a problem in the b43 driver sourcecode.
 
-
+config B43_FORCE_PIO
+	bool "Force usage of PIO instead of DMA"
+	depends on B43 && B43_DEBUG
+	---help---
+	  This will disable DMA and always enable PIO instead.
+
+	  Say N!
+	  This is only for debugging the PIO engine code. You do
+	  _NOT_ want to enable this.
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -107,9 +107,9 @@ int b43_modparam_verbose = B43_VERBOSITY
 module_param_named(verbose, b43_modparam_verbose, int, 0644);
 MODULE_PARM_DESC(verbose, "Log message verbosity: 0=error, 1=warn, 2=info(default), 3=debug");
 
-static int modparam_pio;
-module_param_named(pio, modparam_pio, int, 0444);
-MODULE_PARM_DESC(pio, "enable(1) / disable(0) PIO mode");
+int b43_modparam_pio = B43_PIO_DEFAULT;
+module_param_named(pio, b43_modparam_pio, int, 0644);
+MODULE_PARM_DESC(pio, "Use PIO accesses by default: 0=DMA, 1=PIO");
 
 static const struct ssb_device_id b43_ssb_tbl[] = {
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 5),
@@ -1804,8 +1804,9 @@ static void b43_do_interrupt_thread(stru
 			       dma_reason[4], dma_reason[5]);
 			b43err(dev->wl, "This device does not support DMA "
 			       "on your system. Please use PIO instead.\n");
-			b43err(dev->wl, "Unload the b43 module and reload "
-			       "with 'pio=1'\n");
+			/* Fall back to PIO transfers if we get fatal DMA errors! */
+			dev->use_pio = 1;
+			b43_controller_restart(dev, "DMA error");
 			return;
 		}
 		if (merged_dma_reason & B43_DMAIRQ_NONFATALMASK) {
@@ -4357,7 +4358,7 @@ static int b43_wireless_core_init(struct
 
 	if ((dev->dev->bus->bustype == SSB_BUSTYPE_PCMCIA) ||
 	    (dev->dev->bus->bustype == SSB_BUSTYPE_SDIO) ||
-	    modparam_pio) {
+	    dev->use_pio) {
 		dev->__using_pio_transfers = 1;
 		err = b43_pio_init(dev);
 	} else {
@@ -4824,6 +4825,7 @@ static int b43_one_core_attach(struct ss
 	if (!wldev)
 		goto out;
 
+	wldev->use_pio = b43_modparam_pio;
 	wldev->dev = dev;
 	wldev->wl = wl;
 	b43_set_status(wldev, B43_STAT_UNINIT);
