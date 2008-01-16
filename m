Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:35482 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbYAPLFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 06:05:00 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 2.6.24] b43: Reject new firmware early
Date: Wed, 16 Jan 2008 12:02:08 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801161202.09122.mb@bu3sch.de> (sfid-20080116_110506_433928_CA1A87D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We must reject new incompatible firmware early to avoid
running into strange transmission failures.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this must _only_ be applied to 2.6.24.
2.6.25 does have actual support for the new firmware.



Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2008-01-16 11:33:55.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2008-01-16 11:44:06.000000000 +0100
@@ -1800,6 +1800,18 @@ static int b43_upload_microcode(struct b
 		err = -EOPNOTSUPP;
 		goto out;
 	}
+	if (fwrev > 351) {
+		b43err(dev->wl, "YOUR FIRMWARE IS TOO NEW. Please downgrade your "
+		       "firmware.\n");
+		b43err(dev->wl, "Use this firmware tarball: "
+		       "http://downloads.openwrt.org/sources/broadcom-wl-4.80.53.0.tar.bz2\n");
+		b43err(dev->wl, "Use this b43-fwcutter tarball: "
+		       "http://bu3sch.de/b43/fwcutter/b43-fwcutter-009.tar.bz2\n");
+		b43err(dev->wl, "Read, understand and _do_ what this message says, please.\n");
+		b43_write32(dev, B43_MMIO_MACCTL, 0);
+		err = -EOPNOTSUPP;
+		goto out;
+	}
 	b43dbg(dev->wl, "Loading firmware version %u.%u "
 	       "(20%.2i-%.2i-%.2i %.2i:%.2i:%.2i)\n",
 	       fwrev, fwpatch,

-- 
Greetings Michael.
