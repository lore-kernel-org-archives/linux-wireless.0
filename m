Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:35293
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699AbXISQwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 12:52:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Don't lock irq_lock in debugfs txpower adjust
Date: Wed, 19 Sep 2007 18:51:38 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709191851.38740.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's not required and the txpower adjustment must not be in atomic.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43/debugfs.c	2007-09-19 18:13:49.000000000 +0200
+++ wireless-dev/drivers/net/wireless/b43/debugfs.c	2007-09-19 18:13:51.000000000 +0200
@@ -223,15 +223,10 @@ out:
 static int txpower_g_write_file(struct b43_wldev *dev,
 				const char *buf, size_t count)
 {
-	unsigned long flags;
 	unsigned long phy_flags;
-	int err = 0;
 
-	spin_lock_irqsave(&dev->wl->irq_lock, flags);
-	if (dev->phy.type != B43_PHYTYPE_G) {
-		err = -ENODEV;
-		goto out_unlock;
-	}
+	if (dev->phy.type != B43_PHYTYPE_G)
+		return -ENODEV;
 	if ((count >= 4) && (memcmp(buf, "auto", 4) == 0)) {
 		/* Automatic control */
 		dev->phy.manual_txpower_control = 0;
@@ -240,10 +235,8 @@ static int txpower_g_write_file(struct b
 		int bbatt = 0, rfatt = 0, txmix = 0, pa2db = 0, pa3db = 0;
 		/* Manual control */
 		if (sscanf(buf, "%d %d %d %d %d", &bbatt, &rfatt,
-			   &txmix, &pa2db, &pa3db) != 5) {
-			err = -EINVAL;
-			goto out_unlock;
-		}
+			   &txmix, &pa2db, &pa3db) != 5)
+			return -EINVAL;
 		b43_put_attenuation_into_ranges(dev, &bbatt, &rfatt);
 		dev->phy.manual_txpower_control = 1;
 		dev->phy.bbatt.att = bbatt;
@@ -262,10 +255,8 @@ static int txpower_g_write_file(struct b
 		b43_radio_unlock(dev);
 		b43_phy_unlock(dev, phy_flags);
 	}
-out_unlock:
-	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
 
-	return err;
+	return 0;
 }
 
 /* wl->irq_lock is locked */
