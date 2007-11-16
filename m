Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36378 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbXKPGs0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 01:48:26 -0500
Date: Fri, 16 Nov 2007 00:48:23 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] ssb: Fix compilation errors in ssb
Message-ID: <473d3d37.IWXGkSribrkSiHBl%Larry.Finger@lwfinger.net> (sfid-20071116_064832_152995_E43E7FE7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent changes in ssb sprom handling break compilation. These two patches
fix the problem.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

These two changes should be applied to the everything branch of wireless-2.6
ASAP. Sorry about the mixup - I have no idea what happened.

Larry

Index: wireless-2.6/drivers/ssb/pci.c
===================================================================
--- wireless-2.6.orig/drivers/ssb/pci.c
+++ wireless-2.6/drivers/ssb/pci.c
@@ -415,7 +415,7 @@ static int sprom_extract(struct ssb_bus 
 		if (out->revision == 0)
 			goto unsupported;
 		if (out->revision >= 1 && out->revision <= 3) {
-			sprom_extract_r123(out, in, out->revision);
+			sprom_extract_r123(out, in);
 		}
 		if (out->revision == 4)
 			sprom_extract_r4(out, in);
Index: wireless-2.6/include/linux/ssb/ssb.h
===================================================================
--- wireless-2.6.orig/include/linux/ssb/ssb.h
+++ wireless-2.6/include/linux/ssb/ssb.h
@@ -16,6 +16,7 @@ struct ssb_bus;
 struct ssb_driver;
 
 struct ssb_sprom {
+	u8 revision;
 	u8 il0mac[6];		/* MAC address for 802.11b/g */
 	u8 et0mac[6];		/* MAC address for Ethernet */
 	u8 et1mac[6];		/* MAC address for 802.11a */
