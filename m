Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:52404 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbYDHIc4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 04:32:56 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb-pcicore: Remove b44 TPS flag workaround
Date: Tue, 8 Apr 2008 10:31:22 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804081031.22638.mb@bu3sch.de> (sfid-20080408_093314_386195_BB8165C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that we fixed the TPS flag assignment in commit
JOHN, INSERT COMMIT ID HERE
we don't need the workaround for the bcm44xx chip anymore.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please apply to 2.6.26.
But please insert the commit ID of
"[PATCH] ssb-pcicore: Fix IRQ TPS flag handling" into the commit text first.


Index: wireless-testing/drivers/ssb/driver_pcicore.c
===================================================================
--- wireless-testing.orig/drivers/ssb/driver_pcicore.c	2008-04-08 00:40:06.000000000 +0200
+++ wireless-testing/drivers/ssb/driver_pcicore.c	2008-04-08 00:41:00.000000000 +0200
@@ -559,21 +559,15 @@ int ssb_pcicore_dev_irqvecs_enable(struc
 		if (err)
 			goto out;
 	} else {
 		u32 intvec;
 
 		intvec = ssb_read32(pdev, SSB_INTVEC);
-		if ((bus->chip_id & 0xFF00) == 0x4400) {
-			/* Workaround: On the BCM44XX the BPFLAG routing
-			 * bit is wrong. Use a hardcoded constant. */
-			intvec |= 0x00000002;
-		} else {
-			tmp = ssb_read32(dev, SSB_TPSFLAG);
-			tmp &= SSB_TPSFLAG_BPFLAG;
-			intvec |= (1 << tmp);
-		}
+		tmp = ssb_read32(dev, SSB_TPSFLAG);
+		tmp &= SSB_TPSFLAG_BPFLAG;
+		intvec |= (1 << tmp);
 		ssb_write32(pdev, SSB_INTVEC, intvec);
 	}
 
 	/* Setup PCIcore operation. */
 	if (pc->setup_done)
 		goto out;
