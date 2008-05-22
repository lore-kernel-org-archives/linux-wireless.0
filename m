Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:50694 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbYEVPIP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 11:08:15 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: [PATCH] b43legacy: Fix controller restart crash
Date: Thu, 22 May 2008 17:06:36 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805221706.37185.mb@bu3sch.de> (sfid-20080522_170820_194823_70B46B36)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a kernel crash on rmmod, in the case where the controller
was restarted before doing the rmmod.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Stefano, this is untested. Please test by doing
echo -n 1 >/debug/b43legacy/phy*/restart
rmmod b43legacy
It should not crash anymore at the rmmod (actually the restart should
also hang in b43legacy, as it has a deadlock, which this patch also fixes).

Index: wireless-testing/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c	2008-05-15 23:31:37.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c	2008-05-22 17:02:59.000000000 +0200
@@ -3035,13 +3035,12 @@ static void b43legacy_set_pretbtt(struct
 }
 
 /* Shutdown a wireless core */
 /* Locking: wl->mutex */
 static void b43legacy_wireless_core_exit(struct b43legacy_wldev *dev)
 {
-	struct b43legacy_wl *wl = dev->wl;
 	struct b43legacy_phy *phy = &dev->phy;
 	u32 macctl;
 
 	B43legacy_WARN_ON(b43legacy_status(dev) > B43legacy_STAT_INITIALIZED);
 	if (b43legacy_status(dev) != B43legacy_STAT_INITIALIZED)
 		return;
@@ -3050,18 +3049,12 @@ static void b43legacy_wireless_core_exit
 	/* Stop the microcode PSM. */
 	macctl = b43legacy_read32(dev, B43legacy_MMIO_MACCTL);
 	macctl &= ~B43legacy_MACCTL_PSM_RUN;
 	macctl |= B43legacy_MACCTL_PSM_JMP0;
 	b43legacy_write32(dev, B43legacy_MMIO_MACCTL, macctl);
 
-	mutex_unlock(&wl->mutex);
-	/* Must unlock as it would otherwise deadlock. No races here.
-	 * Cancel possibly pending workqueues. */
-	cancel_work_sync(&dev->restart_work);
-	mutex_lock(&wl->mutex);
-
 	b43legacy_leds_exit(dev);
 	b43legacy_rng_exit(dev->wl);
 	b43legacy_pio_free(dev);
 	b43legacy_dma_free(dev);
 	b43legacy_chip_exit(dev);
 	b43legacy_radio_turn_off(dev, 1);
@@ -3482,12 +3475,14 @@ static void b43legacy_chip_reset(struct 
 		if (err) {
 			b43legacy_wireless_core_exit(dev);
 			goto out;
 		}
 	}
 out:
+	if (err)
+		wl->current_dev = NULL; /* Failed to init the dev. */
 	mutex_unlock(&wl->mutex);
 	if (err)
 		b43legacyerr(wl, "Controller restart FAILED\n");
 	else
 		b43legacyinfo(wl, "Controller restarted\n");
 }
@@ -3614,15 +3609,17 @@ err_powerdown:
 
 static void b43legacy_one_core_detach(struct ssb_device *dev)
 {
 	struct b43legacy_wldev *wldev;
 	struct b43legacy_wl *wl;
 
+	/* Do not cancel ieee80211-workqueue based work here.
+	 * See comment in b43legacy_remove(). */
+
 	wldev = ssb_get_drvdata(dev);
 	wl = wldev->wl;
-	cancel_work_sync(&wldev->restart_work);
 	b43legacy_debugfs_remove_device(wldev);
 	b43legacy_wireless_core_detach(wldev);
 	list_del(&wldev->list);
 	wl->nr_devs--;
 	ssb_set_drvdata(dev, NULL);
 	kfree(wldev);
@@ -3784,12 +3781,16 @@ err_wireless_exit:
 
 static void b43legacy_remove(struct ssb_device *dev)
 {
 	struct b43legacy_wl *wl = ssb_get_devtypedata(dev);
 	struct b43legacy_wldev *wldev = ssb_get_drvdata(dev);
 
+	/* We must cancel any work here before unregistering from ieee80211,
+	 * as the ieee80211 unreg will destroy the workqueue. */
+	cancel_work_sync(&wldev->restart_work);
+
 	B43legacy_WARN_ON(!wl);
 	if (wl->current_dev == wldev)
 		ieee80211_unregister_hw(wl->hw);
 
 	b43legacy_one_core_detach(dev);
 
