Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:49188 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877AbYL0R1v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2008 12:27:51 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: Change schedule for old-fw support removal
Date: Sat, 27 Dec 2008 18:26:39 +0100
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812271826.39910.mb@bu3sch.de> (sfid-20081227_182759_789173_EC8C6484)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The scheduled date for the removal of old fw support was in July 2008.
However, we're not going to remove the support unless it causes a major
headache. So change the schedule from "July 2008" to "when it causes headaches".

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Please queue for 2.6.29

Index: wireless-testing/Documentation/feature-removal-schedule.txt
===================================================================
--- wireless-testing.orig/Documentation/feature-removal-schedule.txt	2008-12-05 17:54:27.000000000 +0100
+++ wireless-testing/Documentation/feature-removal-schedule.txt	2008-12-27 15:06:55.000000000 +0100
@@ -233,13 +233,15 @@ When:	January 2009 or Linux 2.7.0, which
 Why:	Superseded by newer revisions or modules
 Who:	Jan Engelhardt <jengelh@computergmbh.de>
 
 ---------------------------
 
 What:	b43 support for firmware revision < 410
-When:	July 2008
+When:	The schedule was July 2008, but it was decided that we are going to keep the
+        code as long as there are no major maintanance headaches.
+	So it _could_ be removed _any_ time now, if it conflicts with something new.
 Why:	The support code for the old firmware hurts code readability/maintainability
 	and slightly hurts runtime performance. Bugfixes for the old firmware
 	are not provided by Broadcom anymore.
 Who:	Michael Buesch <mb@bu3sch.de>
 
 ---------------------------
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-12-27 15:01:47.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-12-27 15:10:48.000000000 +0100
@@ -1949,14 +1949,15 @@ static void b43_release_firmware(struct 
 
 static void b43_print_fw_helptext(struct b43_wl *wl, bool error)
 {
 	const char *text;
 
 	text = "You must go to "
-	       "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
-	       "and download the latest firmware (version 4).\n";
+	       "http://wireless.kernel.org/en/users/Drivers/b43#devicefirmware "
+	       "and download the correct firmware for this driver version. "
+	       "Please carefully read all instructions on this website.\n";
 	if (error)
 		b43err(wl, text);
 	else
 		b43warn(wl, text);
 }
 
@@ -2266,14 +2267,17 @@ static int b43_upload_microcode(struct b
 				"Hardware accelerated cryptography is disabled.\n");
 			b43_print_fw_helptext(dev->wl, 0);
 		}
 	}
 
 	if (b43_is_old_txhdr_format(dev)) {
+		/* We're over the deadline, but we keep support for old fw
+		 * until it turns out to be in major conflict with something new. */
 		b43warn(dev->wl, "You are using an old firmware image. "
-			"Support for old firmware will be removed in July 2008.\n");
+			"Support for old firmware will be removed soon "
+			"(official deadline was July 2008).\n");
 		b43_print_fw_helptext(dev->wl, 0);
 	}
 
 	return 0;
 
 error:

-- 
Greetings, Michael.
