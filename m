Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41316 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbYICKcy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 06:32:54 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Replace hardcoded Analog switch
Date: Wed, 3 Sep 2008 12:31:54 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200809031231.55338.mb@bu3sch.de> (sfid-20080903_123303_843140_9638F9E4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace a hardcoded Analog switch (which breaks on N-PHY) by a call to
the switch_analog PHY operation.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue for the next merge window.


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-09-03 11:58:23.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-09-03 12:27:03.000000000 +0200
@@ -2715,13 +2715,14 @@ static int b43_chip_init(struct b43_wlde
 		goto out;	/* firmware is released later */
 
 	err = b43_upload_initvals(dev);
 	if (err)
 		goto err_gpio_clean;
 
-	b43_write16(dev, 0x03E6, 0x0000);
+	/* Turn the Analog on and initialize the PHY. */
+	phy->ops->switch_analog(dev, 1);
 	err = b43_phy_init(dev);
 	if (err)
 		goto err_gpio_clean;
 
 	/* Disable Interference Mitigation. */
 	if (phy->ops->interf_mitigation)
