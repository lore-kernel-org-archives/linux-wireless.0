Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:57947 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932821AbXBLBSd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 20:18:33 -0500
Message-ID: <45CFC062.1050301@lwfinger.net>
Date: Sun, 11 Feb 2007 19:18:26 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] bcm43xx: Fix loss of association after resume
References: <45cc9ebb.+9O/IXvs/C9RyFnk%Larry.Finger@lwfinger.net>	<200702111514.04893.mb@bu3sch.de> <45CF3D51.5050302@lwfinger.net> <200702120150.59747.rjw@sisk.pl>
In-Reply-To: <200702120150.59747.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafael J. Wysocki wrote:
> 
> It doesn't help in my case.  The behavior is similar to that without the patch,
> but also with the patch it loses the association entirely.

Thanks for trying.

Do you have this patch installed? If you do, please try increasing the 100 to 200.


Larry
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





