Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53682 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbZBCTI4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 14:08:56 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: (b2062) Fix crystal frequency calculations
Date: Tue, 3 Feb 2009 20:06:14 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200902032006.14373.mb@bu3sch.de> (sfid-20090203_200906_488897_2963E0F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the crystal frequency calculations in the b2062 init code.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

This patch depends on the SSB PMU code.


Index: wireless-testing/drivers/net/wireless/b43/phy_lp.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_lp.c	2009-02-03 19:43:31.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/phy_lp.c	2009-02-03 20:04:26.000000000 +0100
@@ -160,6 +160,7 @@ struct b2062_freqdata {
 /* Initialize the 2062 radio. */
 static void lpphy_2062_init(struct b43_wldev *dev)
 {
+	struct ssb_bus *bus = dev->dev->bus;
 	u32 crystalfreq, pdiv, tmp, ref;
 	unsigned int i;
 	const struct b2062_freqdata *fd = NULL;
@@ -193,7 +194,11 @@ static void lpphy_2062_init(struct b43_w
 	else
 		b43_radio_mask(dev, B2062_N_TSSI_CTL0, ~0x1);
 
-	crystalfreq = 0;//FIXME
+	/* Get the crystal freq, in Hz. */
+	crystalfreq = bus->chipco.pmu.crystalfreq * 1000;
+
+	B43_WARN_ON(!(bus->chipco.capabilities & SSB_CHIPCO_CAP_PMU));
+	B43_WARN_ON(crystalfreq == 0);
 
 	if (crystalfreq >= 30000000) {
 		pdiv = 1;
@@ -219,13 +224,15 @@ static void lpphy_2062_init(struct b43_w
 			break;
 		}
 	}
-	if (B43_WARN_ON(!fd))
-		return;
+	if (!fd)
+		fd = &freqdata_tab[ARRAY_SIZE(freqdata_tab) - 1];
+	b43dbg(dev->wl, "b2062: Using crystal tab entry %u kHz.\n",
+	       fd->freq); /* FIXME: Keep this printk until the code is fully debugged. */
 
 	b43_radio_write(dev, B2062_S_RFPLL_CTL8,
 			((u16)(fd->data[1]) << 4) | fd->data[0]);
 	b43_radio_write(dev, B2062_S_RFPLL_CTL9,
-			((u16)(fd->data[3]) << 4) | fd->data[2]);//FIXME specs are different
+			((u16)(fd->data[3]) << 4) | fd->data[2]);
 	b43_radio_write(dev, B2062_S_RFPLL_CTL10, fd->data[4]);
 	b43_radio_write(dev, B2062_S_RFPLL_CTL11, fd->data[5]);
 }

-- 
Greetings, Michael.
