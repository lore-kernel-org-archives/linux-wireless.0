Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:42343 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933025AbXBFRkf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Feb 2007 12:40:35 -0500
Date: Tue, 06 Feb 2007 11:39:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, netdev@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx: Fix for oops on resume
Message-ID: <45c8bd59.oamnvaNRMZvKoPBa%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a kernel oops on bcm43xx when resuming due to an overly tight timeout loop.

Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
---

Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx.h
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx.h
@@ -21,7 +21,7 @@
 #define PFX				KBUILD_MODNAME ": "
 
 #define BCM43xx_SWITCH_CORE_MAX_RETRIES	50
-#define BCM43xx_IRQWAIT_MAX_RETRIES	50
+#define BCM43xx_IRQWAIT_MAX_RETRIES	100
 
 #define BCM43xx_IO_SIZE			8192
 
