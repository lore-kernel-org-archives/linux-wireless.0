Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53478 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbYIZNXE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 09:23:04 -0400
Date: Fri, 26 Sep 2008 08:23:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH V2] b43: Fix Bluetooth Coexistence SPROM programming error for HP 12f8 version of BCM4306
Message-ID: <48dce234.RneC5sIzP1+fVQbA%Larry.Finger@lwfinger.net> (sfid-20080926_152312_509989_BFE36D82)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yet another BCM4306 card with the Bluetooth Coexistence SPROM programming
error has been found.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

Owners of these cards keep crawling out of the woodwork. This is
2.6.28 material.

The previous version had some fuzz when applied as I forgot to apply the
previously submitted MOTOROLA patch first.

Larry
---

Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -4543,6 +4543,7 @@ static void b43_sprom_fixup(struct ssb_b
 		pdev = bus->host_pci;
 		if (IS_PDEV(pdev, BROADCOM, 0x4318, ASUSTEK, 0x100F) ||
 		    IS_PDEV(pdev, BROADCOM, 0x4320,    DELL, 0x0003) ||
+		    IS_PDEV(pdev, BROADCOM, 0x4320,      HP, 0x12f8) ||
 		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0015) ||
 		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0014) ||
 		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0013) ||
