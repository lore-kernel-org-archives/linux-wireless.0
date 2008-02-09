Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:53831 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbYBIJYt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Feb 2008 04:24:49 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add firmware information to modinfo
Date: Sat, 9 Feb 2008 10:23:49 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200802091023.49930.mb@bu3sch.de> (sfid-20080209_092454_894279_391C2A9C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the firmware ID to modinfo.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, I'd also like to have this in 2.6.25, although it's not strictly
a bugfix. The chance to create regressions is less than zero and it will
help people to get the stuff working.

Stefano poor-patch-porter Brivio, needs porting :)


Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2008-02-09 00:17:12.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2008-02-09 10:17:21.000000000 +0100
@@ -54,12 +54,14 @@
 MODULE_DESCRIPTION("Broadcom B43 wireless driver");
 MODULE_AUTHOR("Martin Langer");
 MODULE_AUTHOR("Stefano Brivio");
 MODULE_AUTHOR("Michael Buesch");
 MODULE_LICENSE("GPL");
 
+MODULE_FIRMWARE(B43_SUPPORTED_FIRMWARE_ID);
+
 
 static int modparam_bad_frames_preempt;
 module_param_named(bad_frames_preempt, modparam_bad_frames_preempt, int, 0444);
 MODULE_PARM_DESC(bad_frames_preempt,
 		 "enable(1) / disable(0) Bad Frames Preemption");
 
