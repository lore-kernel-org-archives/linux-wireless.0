Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63740 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbYDSPnj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2008 11:43:39 -0400
Date: Sat, 19 Apr 2008 10:42:28 -0500
From: Larry.Finger@lwfinger.net
To: mb@bu3sch.de, linville@tuxdriver.com
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH V2] ssb: Fix case where board flags are unset in SPROM
Message-ID: <480a12e4.JW4WMtJZAF8ZXHLq%Larry.Finger@lwfinger.net> (sfid-20080419_164345_235110_21F435C6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The specifications call for the low 16 bits of the board flags to
be cleared if unset (== 0xFFFF). This step was taken in bcm43xx,
but was missed when ssb was coded. With this patch, Linksys WMP11
cards with a BCM4301 now work.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.26 material.

Larry
---


Index: wireless-testing/drivers/ssb/pci.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pci.c
+++ wireless-testing/drivers/ssb/pci.c
@@ -483,6 +483,11 @@ static int sprom_extract(struct ssb_bus 
 		if (out->revision >= 5)
 			goto unsupported;
 	}
+	/* check for board flags not set (0xFFFF) and make 0 as per specs */
+	if (out->boardflags_lo == 0xFFFF)
+		out->boardflags_lo = 0;
+	if (out->boardflags_hi == 0xFFFF)
+		out->boardflags_hi = 0;
 
 	return 0;
 unsupported:
