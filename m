Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:37093
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720AbXHNSOB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 14:14:01 -0400
Message-Id: <20070814181216.879252000@bu3sch.de>
References: <20070814181213.135874000@bu3sch.de>
Date: Tue, 14 Aug 2007 20:12:21 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [patch 8/9] b43: Fix controller reset
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't check the device status. It's checked and handled later in
the workqueue. Use proper locking in the reset callback.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev-new/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/main.c	2007-08-13 17:44:34.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/main.c	2007-08-13 18:13:13.000000000 +0200
@@ -2539,14 +2539,16 @@ static int b43_get_stats(struct ieee8021
 static int b43_dev_reset(struct ieee80211_hw *hw)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
-	struct b43_wldev *dev = wl->current_dev;
-	unsigned long flags;
+	struct b43_wldev *dev;
+	int err = -ENODEV;
 
-	if (!dev)
-		return -ENODEV;
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	b43_controller_restart(dev, "Reset by ieee80211 subsystem");
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
+	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
+	if (dev) {
+		b43_controller_restart(dev, "Reset by ieee80211 subsystem");
+		err = 0;
+	}
+	mutex_unlock(&wl->mutex);
 
 	return 0;
 }
@@ -3911,14 +3913,9 @@ static void b43_remove(struct ssb_device
 	}
 }
 
-/* Hard-reset the chip.
- * This can be called from interrupt or process context.
- * dev->irq_lock must be locked.
- */
+/* Perform a hardware reset. This can be called from any context. */
 void b43_controller_restart(struct b43_wldev *dev, const char *reason)
 {
-	if (b43_status(dev) != B43_STAT_INITIALIZED)
-		return;
 	bcminfo(dev->wl, "Controller RESET (%s) ...\n", reason);
 	queue_work(dev->wl->hw->workqueue, &dev->restart_work);
 }

-- 

