Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:53599 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714AbYCDTcB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 14:32:01 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43legacy: Fix module init message
Date: Tue, 4 Mar 2008 20:31:13 +0100
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803042031.13929.mb@bu3sch.de> (sfid-20080304_193207_456909_4EBD6B16)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the module init message to tell that the legacy
driver loaded. This makes it less confusing, in case both drivers are loaded.

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: wireless-testing/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c	2008-02-24 14:23:51.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c	2008-03-04 20:29:32.000000000 +0100
@@ -3870,7 +3870,7 @@ static void b43legacy_print_driverinfo(v
 #ifdef CONFIG_B43LEGACY_DMA
 	feat_dma = "D";
 #endif
-	printk(KERN_INFO "Broadcom 43xx driver loaded "
+	printk(KERN_INFO "Broadcom 43xx-legacy driver loaded "
 	       "[ Features: %s%s%s%s%s, Firmware-ID: "
 	       B43legacy_SUPPORTED_FIRMWARE_ID " ]\n",
 	       feat_pci, feat_leds, feat_rfkill, feat_pio, feat_dma);

-- 
Greetings Michael.
