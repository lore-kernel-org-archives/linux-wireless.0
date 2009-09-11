Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:59143 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471AbZIKQcV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 12:32:21 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix resume failure
Date: Fri, 11 Sep 2009 18:31:32 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <200909111831.33136.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a resume failure where a signal is pending on resume
so the firmware upload fails.
This removes the interruptible sleep, because we don't really need it.
In the worst case (with broken firmware) the sleep loop will take 1 second.
In the common case (working firmware), it will only take a few milliseconds.
So we don't really need to be interruptible.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-09-11 18:24:59.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-09-11 18:25:13.000000000 +0200
@@ -2309,11 +2309,7 @@ static int b43_upload_microcode(struct b
 			err = -ENODEV;
 			goto error;
 		}
-		msleep_interruptible(50);
-		if (signal_pending(current)) {
-			err = -EINTR;
-			goto error;
-		}
+		msleep(50);
 	}
 	b43_read32(dev, B43_MMIO_GEN_IRQ_REASON);	/* dummy read */
 

-- 
Greetings, Michael.
