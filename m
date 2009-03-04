Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:54370 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841AbZCDQB4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 11:01:56 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John W Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix compilation for devices without PCI core
Date: Wed, 4 Mar 2009 16:41:10 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903041641.11302.mb@bu3sch.de> (sfid-20090304_170224_123904_F19199BA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes compilation, if the PCI core is disabled.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, I think this is only needed for the next feature release, as the patch
that broke that was only merged for next, afaik.

Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-03-04 16:35:07.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-03-04 16:36:08.000000000 +0100
@@ -4176,15 +4176,17 @@ static int b43_wireless_core_init(struct
 			hf |= B43_HF_4318TSSI;
 		if (phy->radio_rev < 6)
 			hf |= B43_HF_VCORECALC;
 	}
 	if (sprom->boardflags_lo & B43_BFL_XTAL_NOSLOW)
 		hf |= B43_HF_DSCRQ; /* Disable slowclock requests from ucode. */
+#ifdef CONFIG_SSB_DRIVER_PCICORE
 	if ((bus->bustype == SSB_BUSTYPE_PCI) &&
 	    (bus->pcicore.dev->id.revision <= 10))
 		hf |= B43_HF_PCISCW; /* PCI slow clock workaround. */
+#endif
 	hf &= ~B43_HF_SKCFPUP;
 	b43_hf_write(dev, hf);
 
 	b43_set_retry_limits(dev, B43_DEFAULT_SHORT_RETRY_LIMIT,
 			     B43_DEFAULT_LONG_RETRY_LIMIT);
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_SFFBLIM, 3);

-- 
Greetings, Michael.
