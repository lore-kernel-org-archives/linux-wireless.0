Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39371 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbYISTrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 15:47:39 -0400
Date: Fri, 19 Sep 2008 14:47:38 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, bbullins@triad.rr.com
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Fix Bluetooth coexistence SPROM coding error for
 Motorola 7010 variant of BCM4306
Message-ID: <48d401da.Q+F4HRESoxeIVa3r%Larry.Finger@lwfinger.net> (sfid-20080919_214743_829054_90911EB9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An additional BCM4306 has been found with the Bluetooth coexistence
SPROM coding error.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

These devices work with bcm43xx, but not with b43. I'll let you
decide if this is a regression.

Larry
---

Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -4545,7 +4545,8 @@ static void b43_sprom_fixup(struct ssb_b
 		    IS_PDEV(pdev, BROADCOM, 0x4320,    DELL, 0x0003) ||
 		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0015) ||
 		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0014) ||
-		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0013))
+		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0013) ||
+		    IS_PDEV(pdev, BROADCOM, 0x4320, MOTOROLA, 0x7010))
 			bus->sprom.boardflags_lo &= ~B43_BFL_BTCOEXIST;
 	}
 }
