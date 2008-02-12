Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:53106 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752092AbYBLCOf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 21:14:35 -0500
Date: Tue, 12 Feb 2008 03:09:10 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: b43legacy: fix firmware load message level
Message-ID: <20080212030910.57aef9ae@morte> (sfid-20080212_021451_958155_76CFDD18)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware version information should always get printed. Not only on a
debug build.

The patch by Michael Buesch has been ported to b43legacy.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c
@@ -1670,10 +1670,11 @@ static int b43legacy_upload_microcode(st
 		err = -EOPNOTSUPP;
 		goto error;
 	}
-	b43legacydbg(dev->wl, "Loading firmware version 0x%X, patch level %u "
-	       "(20%.2i-%.2i-%.2i %.2i:%.2i:%.2i)\n", fwrev, fwpatch,
-	       (fwdate >> 12) & 0xF, (fwdate >> 8) & 0xF, fwdate & 0xFF,
-	       (fwtime >> 11) & 0x1F, (fwtime >> 5) & 0x3F, fwtime & 0x1F);
+	b43legacyinfo(dev->wl, "Loading firmware version 0x%X, patch level %u "
+		      "(20%.2i-%.2i-%.2i %.2i:%.2i:%.2i)\n", fwrev, fwpatch,
+		      (fwdate >> 12) & 0xF, (fwdate >> 8) & 0xF, fwdate & 0xFF,
+		      (fwtime >> 11) & 0x1F, (fwtime >> 5) & 0x3F,
+		      fwtime & 0x1F);
 
 	dev->fw.rev = fwrev;
 	dev->fw.patch = fwpatch;


-- 
Ciao
Stefano
