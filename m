Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53955 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbYHNX5L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 19:57:11 -0400
Date: Thu, 14 Aug 2008 18:57:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: tim.gardner@canonical.com, linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Fix for another Bluetooth Coexistence SPROM
 Programming error for BCM4306
Message-ID: <48a4c657.3Vw2yJT7Y4Gu6f4D%Larry.Finger@lwfinger.net> (sfid-20080815_015730_473682_0210AAAD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In trying to help users on the Ubuntu Bugzilla, I discovered another
BCM4306 with the Bluetooth Coexistence programming error in the SPROM.

This patch is contingent on the one that added the Linksys device with
subdevice code of 0x0014.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@kernel.org>
---

John,

This is more 2.6.27 material.

Larry
---

Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -4615,6 +4615,7 @@ static void b43_sprom_fixup(struct ssb_b
 	if (bus->bustype == SSB_BUSTYPE_PCI) {
 		pdev = bus->host_pci;
 		if (IS_PDEV(pdev, BROADCOM, 0x4318, ASUSTEK, 0x100F) ||
+		    IS_PDEV(pdev, BROADCOM, 0x4320,    DELL, 0x0003) ||
 		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0015) ||
 		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0014) ||
 		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0013))


