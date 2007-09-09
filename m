Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41980
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbXIILzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Sep 2007 07:55:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Don't cancel the restart workqueue in wireless_core_exit
Date: Sun, 9 Sep 2007 13:55:00 +0200
Cc: Larry Finger <larry.finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709091355.00658.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wq must be canceled later on rmmod. It's nonfatal, if
the wq runs on a device that's not started or down. It will
handle these cases.
But syncing in wireless_core_exit() will cause a deadlock with
the restart_work. (restart work cancels itself)

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <larry.finger@lwfinger.net>

Index: wireless-dev/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43/main.c	2007-09-09 13:27:14.000000000 +0200
+++ wireless-dev/drivers/net/wireless/b43/main.c	2007-09-09 13:46:31.000000000 +0200
@@ -3317,7 +3317,6 @@ static void b43_imcfglo_timeouts_workaro
 /* Locking: wl->mutex */
 static void b43_wireless_core_exit(struct b43_wldev *dev)
 {
-	struct b43_wl *wl = dev->wl;
 	struct b43_phy *phy = &dev->phy;
 
 	B43_WARN_ON(b43_status(dev) > B43_STAT_INITIALIZED);
@@ -3325,12 +3324,6 @@ static void b43_wireless_core_exit(struc
 		return;
 	b43_set_status(dev, B43_STAT_UNINIT);
 
-	mutex_unlock(&wl->mutex);
-	/* Must unlock as it would otherwise deadlock. No races here.
-	 * Cancel possibly pending workqueues. */
-	cancel_work_sync(&dev->restart_work);
-	mutex_lock(&wl->mutex);
-
 	b43_rng_exit(dev->wl);
 	b43_pio_free(dev);
 	b43_dma_free(dev);
@@ -3811,6 +3804,7 @@ static void b43_one_core_detach(struct s
 
 	wldev = ssb_get_drvdata(dev);
 	wl = wldev->wl;
+	cancel_work_sync(&wldev->restart_work);
 	b43_debugfs_remove_device(wldev);
 	b43_wireless_core_detach(wldev);
 	list_del(&wldev->list);
