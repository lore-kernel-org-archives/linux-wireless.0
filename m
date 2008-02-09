Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:33327 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbYBIQyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Feb 2008 11:54:43 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix firmware load message level
Date: Sat, 9 Feb 2008 17:53:41 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200802091753.41852.mb@bu3sch.de> (sfid-20080209_165449_836081_751C4899)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware version information should always get printed. Not only
on a debug build.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, for 2.6.25

Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2008-02-09 12:03:20.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2008-02-09 17:23:11.000000000 +0100
@@ -1956,17 +1956,17 @@ static int b43_upload_microcode(struct b
 		       "binary drivers older than version 4.x is unsupported. "
 		       "You must upgrade your firmware files.\n");
 		b43_print_fw_helptext(dev->wl, 1);
 		err = -EOPNOTSUPP;
 		goto error;
 	}
-	b43dbg(dev->wl, "Loading firmware version %u.%u "
-	       "(20%.2i-%.2i-%.2i %.2i:%.2i:%.2i)\n",
-	       fwrev, fwpatch,
-	       (fwdate >> 12) & 0xF, (fwdate >> 8) & 0xF, fwdate & 0xFF,
-	       (fwtime >> 11) & 0x1F, (fwtime >> 5) & 0x3F, fwtime & 0x1F);
+	b43info(dev->wl, "Loading firmware version %u.%u "
+		"(20%.2i-%.2i-%.2i %.2i:%.2i:%.2i)\n",
+		fwrev, fwpatch,
+		(fwdate >> 12) & 0xF, (fwdate >> 8) & 0xF, fwdate & 0xFF,
+		(fwtime >> 11) & 0x1F, (fwtime >> 5) & 0x3F, fwtime & 0x1F);
 
 	dev->fw.rev = fwrev;
 	dev->fw.patch = fwpatch;
 
 	if (b43_is_old_txhdr_format(dev)) {
 		b43warn(dev->wl, "You are using an old firmware image. "
