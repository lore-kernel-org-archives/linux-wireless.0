Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:47995 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbYAZM4m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 07:56:42 -0500
From: Michael Buesch <mb@bu3sch.de>
To: stable@kernel.org
Subject: [PATCH stable] b43: Reject new firmware early
Date: Sat, 26 Jan 2008 13:54:52 +0100
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801261354.52659.mb@bu3sch.de> (sfid-20080126_125655_415985_A861DF91)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We must reject new incompatible firmware early to avoid
running into strange transmission failures.

The current development tree supports newer firmware revisions.
These revisions cause strange failures on the stable 2.6.24 kernel.
Add a check to avoid confusing users a lot.

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: linux-2.6.24/drivers/net/wireless/b43/main.c
===================================================================
--- linux-2.6.24.orig/drivers/net/wireless/b43/main.c	2008-01-25 11:50:05.000000000 +0100
+++ linux-2.6.24/drivers/net/wireless/b43/main.c	2008-01-26 13:25:07.000000000 +0100
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
