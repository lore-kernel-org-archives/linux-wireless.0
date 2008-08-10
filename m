Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49729 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbYHJPTo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2008 11:19:44 -0400
Date: Sun, 10 Aug 2008 10:19:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Fix for SPROM coding error in Linksys WMP54G
 (BCM4306/3)
Message-ID: <489f0705.cL5monvdYRxgZaoz%Larry.Finger@lwfinger.net> (sfid-20080810_171953_621970_EAE71073)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Linksys WMP54G (BCM4306/3) card in a PCI format has an SPROM coding
error and needs the fix found for several other cards.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
--------

John,

This is a fix for 2.6.27.

Larry
---

 main.c |    1 +
 1 file changed, 1 insertion(+)

Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -4616,6 +4616,7 @@ static void b43_sprom_fixup(struct ssb_b
 		pdev = bus->host_pci;
 		if (IS_PDEV(pdev, BROADCOM, 0x4318, ASUSTEK, 0x100F) ||
 		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0015) ||
+		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0014) ||
 		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0013))
 			bus->sprom.boardflags_lo &= ~B43_BFL_BTCOEXIST;
 	}
