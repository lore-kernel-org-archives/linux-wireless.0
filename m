Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:52701 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbYDXSJI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:09:08 -0400
From: Michael Buesch <mb@bu3sch.de>
To: stable@kernel.org
Subject: [PATCH stable 1/4] ssb: Fix all-ones boardflags
Date: Thu, 24 Apr 2008 20:00:45 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200804242000.45740.mb@bu3sch.de> (sfid-20080424_200947_618421_48594E74)
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net>

In the SSB SPROM a field set to all ones means the value
is not defined in the SPROM.
In case of the boardflags, we need to set them to zero
to avoid confusing drivers. Drivers will only check the
flags by ANDing.

This patch is in wireless-testing.git, commit
d30cdf8a251e88e58bc566f5acaa9eb97ac102e9

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Gabor Stefanik <netrolller.3d@gmail.com>
Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: linux-2.6.25/drivers/ssb/pci.c
===================================================================
--- linux-2.6.25.orig/drivers/ssb/pci.c	2008-04-17 17:11:28.000000000 +0200
+++ linux-2.6.25/drivers/ssb/pci.c	2008-04-19 17:56:54.000000000 +0200
@@ -482,6 +482,11 @@ static int sprom_extract(struct ssb_bus 
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
