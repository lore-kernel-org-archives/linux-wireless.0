Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:33976 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbZIKWxE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 18:53:04 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: Disable PMQ mechanism
Date: Sat, 12 Sep 2009 00:52:48 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <200909120052.48395.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reduces IRQ pressure by about one third on a saturated link
by disabling the PMQ mechanism. We currently don't use that mechanism.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

If we implement PMQ in the future, we need to re-enable it, but only
for AP mode. See the comment in the sourcecode.


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-09-12 00:31:44.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-09-12 00:41:27.000000000 +0200
@@ -2675,6 +2675,20 @@ static void b43_adjust_opmode(struct b43
 			cfp_pretbtt = 50;
 	}
 	b43_write16(dev, 0x612, cfp_pretbtt);
+
+	/* FIXME: We don't currently implement the PMQ mechanism,
+	 *        so always disable it. If we want to implement PMQ,
+	 *        we need to enable it here (clear DISCPMQ) in AP mode.
+	 */
+	if (0  /* ctl & B43_MACCTL_AP */) {
+		b43_write32(dev, B43_MMIO_MACCTL,
+			    b43_read32(dev, B43_MMIO_MACCTL)
+			    & ~B43_MACCTL_DISCPMQ);
+	} else {
+		b43_write32(dev, B43_MMIO_MACCTL,
+			    b43_read32(dev, B43_MMIO_MACCTL)
+			    | B43_MACCTL_DISCPMQ);
+	}
 }
 
 static void b43_rate_memory_write(struct b43_wldev *dev, u16 rate, int is_ofdm)

-- 
Greetings, Michael.
