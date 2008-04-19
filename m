Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:50862 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbYDSPwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2008 11:52:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH v2] ssb: Fix all-ones boardflags
Date: Sat, 19 Apr 2008 17:52:12 +0200
Cc: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>,
	Larry.Finger@lwfinger.net, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200804191752.13038.mb@bu3sch.de> (sfid-20080419_165253_678646_7E2E2BA2)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net>

In the SSB SPROM a field set to all ones means the value
is not defined in the SPROM.
In case of the boardflags, we need to set them to zero
to avoid confusing drivers. Drivers will only check the
flags by ANDing.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Gabor Stefanik <netrolller.3d@gmail.com>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Resent without quoted-printable encoding and attachment.

John,

This is 2.6.26 material.


diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index 904b1a8..57c4ccf 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -484,6 +484,11 @@ static int sprom_extract(struct ssb_bus *bus,
struct ssb_sprom *out,
 			goto unsupported;
 	}

+	if (out->boardflags_lo == 0xFFFF)
+		out->boardflags_lo = 0;  /* per specs */
+	if (out->boardflags_hi == 0xFFFF)
+		out->boardflags_hi = 0;  /* per specs */
+
 	return 0;
 unsupported:
 	ssb_printk(KERN_WARNING PFX "Unsupported SPROM revision %d "

-- 
Greetings Michael.
