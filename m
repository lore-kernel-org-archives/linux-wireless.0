Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35726 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756538AbZJBW6j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 18:58:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: Protect sanity check against physical device removal
Date: Sat, 3 Oct 2009 00:57:58 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Andrew Price <andy@andrewprice.me.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910030058.00906.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix IRQ mask sanity check for physically pulled device.

Tested-by: Andrew Price <andy@andrewprice.me.uk>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

---
 drivers/net/wireless/b43/main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -3874,6 +3874,7 @@ static struct b43_wldev * b43_wireless_c
 {
 	struct b43_wl *wl = dev->wl;
 	struct b43_wldev *orig_dev;
+	u32 mask;
 
 redo:
 	if (!dev || b43_status(dev) < B43_STAT_STARTED)
@@ -3920,7 +3921,8 @@ redo:
 			goto redo;
 		return dev;
 	}
-	B43_WARN_ON(b43_read32(dev, B43_MMIO_GEN_IRQ_MASK));
+	mask = b43_read32(dev, B43_MMIO_GEN_IRQ_MASK);
+	B43_WARN_ON(mask != 0xFFFFFFFF && mask);
 
 	/* Drain the TX queue */
 	while (skb_queue_len(&wl->tx_queue))

-- 
Greetings, Michael.
