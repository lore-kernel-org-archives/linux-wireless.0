Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:58407 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbYH1RRZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 13:17:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Don't use memcpy for overlapping areas
Date: Thu, 28 Aug 2008 19:13:51 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200808281913.52260.mb@bu3sch.de> (sfid-20080828_191732_539411_41E783F6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is valid to pass &gphy->rfatt and &gphy->bbatt as rfatt and bbatt
pointer arguments to the function. So we have to use memmove for the
possibly overlapping memory areas.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, since we have new policies for bugfixes and I can't prove that this
will actually fix something for somebody in real life, please queue for
the next merge window.


Index: wireless-testing/drivers/net/wireless/b43/phy_g.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_g.c	2008-08-28 19:03:11.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_g.c	2008-08-28 19:08:13.000000000 +0200
@@ -229,17 +229,18 @@ void b43_set_txpower_g(struct b43_wldev 
 	rf = rfatt->att;
 	tx_bias = lo->tx_bias;
 	tx_magn = lo->tx_magn;
 	if (unlikely(tx_bias == 0xFF))
 		tx_bias = 0;
 
-	/* Save the values for later */
+	/* Save the values for later. Use memmove, because it's valid
+	 * to pass &gphy->rfatt as rfatt pointer argument. Same for bbatt. */
 	gphy->tx_control = tx_control;
-	memcpy(&gphy->rfatt, rfatt, sizeof(*rfatt));
+	memmove(&gphy->rfatt, rfatt, sizeof(*rfatt));
 	gphy->rfatt.with_padmix = !!(tx_control & B43_TXCTL_TXMIX);
-	memcpy(&gphy->bbatt, bbatt, sizeof(*bbatt));
+	memmove(&gphy->bbatt, bbatt, sizeof(*bbatt));
 
 	if (b43_debug(dev, B43_DBG_XMITPOWER)) {
 		b43dbg(dev->wl, "Tuning TX-power to bbatt(%u), "
 		       "rfatt(%u), tx_control(0x%02X), "
 		       "tx_bias(0x%02X), tx_magn(0x%02X)\n",
 		       bb, rf, tx_control, tx_bias, tx_magn);
