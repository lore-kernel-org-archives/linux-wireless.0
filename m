Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:48501 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751186AbXKSTWU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 14:22:20 -0500
Date: Mon, 19 Nov 2007 20:21:31 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <larry.finger@lwfinger.net>, mb@bu3sch.de
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [PATCH v3] b43/b43legacy: fix left-over URLs and ifdefs
Message-ID: <20071119202131.63c09285@morte> (sfid-20071119_192224_681157_39E9B0F5)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix some left-over URLs and ifdefs in b43 and b43legacy drivers.


Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

---

John,
I hope this is the last try, v2 was line wrapped. :) This is for 2.6.24.

---

Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c
+++ wireless-2.6/drivers/net/wireless/b43/main.c
@@ -1558,7 +1558,7 @@ static void b43_release_firmware(struct 
 static void b43_print_fw_helptext(struct b43_wl *wl)
 {
 	b43err(wl, "You must go to "
-	       "http://linuxwireless.org/en/users/Drivers/bcm43xx#devicefirmware "
+	       "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
 	       "and download the correct firmware (version 4).\n");
 }
 
Index: wireless-2.6/drivers/net/wireless/b43legacy/dma.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/dma.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/dma.c
@@ -996,7 +996,7 @@ int b43legacy_dma_init(struct b43legacy_
 
 	err = ssb_dma_set_mask(dev->dev, dmamask);
 	if (err) {
-#ifdef BCM43XX_PIO
+#ifdef CONFIG_B43LEGACY_PIO
 		b43legacywarn(dev->wl, "DMA for this device not supported. "
 			"Falling back to PIO\n");
 		dev->__using_pio = 1;
Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c
@@ -1398,7 +1398,7 @@ static void b43legacy_release_firmware(s
 static void b43legacy_print_fw_helptext(struct b43legacy_wl *wl)
 {
 	b43legacyerr(wl, "You must go to http://linuxwireless.org/en/users/"
-		     "Drivers/bcm43xx#devicefirmware "
+		     "Drivers/b43#devicefirmware "
 		     "and download the correct firmware (version 3).\n");
 }
 
 
-- 
Ciao
Stefano
