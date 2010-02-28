Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:53796 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968260Ab0B1OmY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 09:42:24 -0500
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id E353FCA89CB
	for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2010 15:32:10 +0100 (CET)
Message-ID: <4B8A7E39.3020809@free.fr>
Date: Sun, 28 Feb 2010 15:31:21 +0100
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Dan Williams <dcbw@redhat.com>
Subject: [PATCH] airo : fix printing status info
Content-Type: multipart/mixed;
 boundary="------------010205000201010405050509"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010205000201010405050509
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

For some status, reason is encoded in the low byte, but airo_print_status forgot tp mask low byte in status parsing.

This make it only work when reason is 0.

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>

--------------010205000201010405050509
Content-Type: text/x-diff;
 name="airo_status.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="airo_status.diff"

Index: airo.c
===================================================================
--- 1/drivers/net/wireless/airo.c
+++ 2/drivers/net/wireless/airo.c
@@ -3325,20 +3325,27 @@
 {
 	u8 reason = status & 0xFF;
 
-	switch (status) {
+	switch (status & 0xFF00) {
 	case STAT_NOBEACON:
-		airo_print_dbg(devname, "link lost (missed beacons)");
+		switch (status) {
+		case STAT_NOBEACON:
+			airo_print_dbg(devname, "link lost (missed beacons)");
+			break;
+		case STAT_MAXRETRIES:
+		case STAT_MAXARL:
+			airo_print_dbg(devname, "link lost (max retries)");
+			break;
+		case STAT_FORCELOSS:
+			airo_print_dbg(devname, "link lost (local choice)");
+			break;
+		case STAT_TSFSYNC:
+			airo_print_dbg(devname, "link lost (TSF sync lost)");
+			break;
+		default:
+			airo_print_dbg(devname, "unknow status %x\n", status);
+			break;
+		}
 		break;
-	case STAT_MAXRETRIES:
-	case STAT_MAXARL:
-		airo_print_dbg(devname, "link lost (max retries)");
-		break;
-	case STAT_FORCELOSS:
-		airo_print_dbg(devname, "link lost (local choice)");
-		break;
-	case STAT_TSFSYNC:
-		airo_print_dbg(devname, "link lost (TSF sync lost)");
-		break;
 	case STAT_DEAUTH:
 		airo_print_dbg(devname, "deauthenticated (reason: %d)", reason);
 		break;
@@ -3353,7 +3360,11 @@
 		airo_print_dbg(devname, "authentication failed (reason: %d)",
 			       reason);
 		break;
+	case STAT_ASSOC:
+	case STAT_REASSOC:
+		break;
 	default:
+		airo_print_dbg(devname, "unknow status %x\n", status);
 		break;
 	}
 }

--------------010205000201010405050509--
