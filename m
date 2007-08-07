Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:48484
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761213AbXHGQQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 12:16:43 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] bcm43xx-mac80211: Remove the stackdump in rfatt/bbatt assertion
Date: Tue, 7 Aug 2007 18:15:09 +0200
Cc: linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>,
	Larry Finger <larry.finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200708071815.09936.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the stackdump in the rfatt/bbatt assertion
to reduce verbosity, but it also increases the message log
level from "debug" to "error".

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_lo.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_lo.c	2007-08-07 17:57:52.000000000 +0200
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_lo.c	2007-08-07 18:11:04.000000000 +0200
@@ -62,28 +62,23 @@ static void bcm43xx_lo_write(struct bcm4
 	bcm43xx_phy_write(dev, reg, value);
 }
 
-static inline
-int assert_rfatt_and_bbatt(const struct bcm43xx_rfatt *rfatt,
-			   const struct bcm43xx_bbatt *bbatt,
-			   struct bcm43xx_wldev *dev)
+static int assert_rfatt_and_bbatt(const struct bcm43xx_rfatt *rfatt,
+				  const struct bcm43xx_bbatt *bbatt,
+				  struct bcm43xx_wldev *dev)
 {
 	int err = 0;
 
 	/* Check the attenuation values against the LO control array sizes. */
-#if BCM43xx_DEBUG
-	if (rfatt->att >= BCM43xx_NR_RF) {
-		bcmdbg(dev->wl, "rfatt(%u) >= size of LO array\n",
+	if (unlikely(rfatt->att >= BCM43xx_NR_RF)) {
+		bcmerr(dev->wl, "rfatt(%u) >= size of LO array\n",
 		       rfatt->att);
 		err = -EINVAL;
 	}
-	if (bbatt->att >= BCM43xx_NR_BB) {
-		bcmdbg(dev->wl, "bbatt(%u) >= size of LO array\n",
+	if (unlikely(bbatt->att >= BCM43xx_NR_BB)) {
+		bcmerr(dev->wl, "bbatt(%u) >= size of LO array\n",
 		       bbatt->att);
 		err = -EINVAL;
 	}
-	if (err)
-		dump_stack();
-#endif /* BCM43xx_DEBUG */
 
 	return err;
 }

-- 
Greetings Michael.
