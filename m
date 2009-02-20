Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60608 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbZBTN76 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 08:59:58 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John W Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Enable PCI slow clock workaround, if needed.
Date: Fri, 20 Feb 2009 14:58:59 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200902201458.59759.mb@bu3sch.de> (sfid-20090220_150009_650740_A1BA0526)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable the PCI slow clock workaround, if we're running a PCI core rev <= 10.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this doesn't fix know bugs. Please queue for the next feature release.


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-02-20 14:41:53.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-02-20 14:53:23.000000000 +0100
@@ -4187,12 +4187,15 @@ static int b43_wireless_core_init(struct
 			hf |= B43_HF_4318TSSI;
 		if (phy->radio_rev < 6)
 			hf |= B43_HF_VCORECALC;
 	}
 	if (sprom->boardflags_lo & B43_BFL_XTAL_NOSLOW)
 		hf |= B43_HF_DSCRQ; /* Disable slowclock requests from ucode. */
+	if ((bus->bustype == SSB_BUSTYPE_PCI) &&
+	    (bus->pcicore.dev->id.revision <= 10))
+		hf |= B43_HF_PCISCW; /* PCI slow clock workaround. */
 	b43_hf_write(dev, hf);
 
 	b43_set_retry_limits(dev, B43_DEFAULT_SHORT_RETRY_LIMIT,
 			     B43_DEFAULT_LONG_RETRY_LIMIT);
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_SFFBLIM, 3);
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_LFFBLIM, 2);

-- 
Greetings, Michael.
