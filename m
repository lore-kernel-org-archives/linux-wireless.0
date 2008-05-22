Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:46294 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbYEVOeG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 10:34:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix controller restart crash
Date: Thu, 22 May 2008 16:32:16 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805221632.17243.mb@bu3sch.de> (sfid-20080522_163411_303038_25F9BE78)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a kernel crash on rmmod, in the case where the controller
was restarted before doing the rmmod.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is a bugfix for 2.6.26


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-05-20 01:05:04.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-05-22 16:23:03.000000000 +0200
@@ -4362,13 +4362,15 @@ static void b43_chip_reset(struct work_s
 		err = b43_wireless_core_start(dev);
 		if (err) {
 			b43_wireless_core_exit(dev);
 			goto out;
 		}
 	}
-      out:
+out:
+	if (err)
+		wl->current_dev = NULL; /* Failed to init the dev. */
 	mutex_unlock(&wl->mutex);
 	if (err)
 		b43err(wl, "Controller restart FAILED\n");
 	else
 		b43info(wl, "Controller restarted\n");
 }
@@ -4503,15 +4505,17 @@ err_powerdown:
 
 static void b43_one_core_detach(struct ssb_device *dev)
 {
 	struct b43_wldev *wldev;
 	struct b43_wl *wl;
 
+	/* Do not cancel ieee80211-workqueue based work here.
+	 * See comment in b43_remove(). */
+
 	wldev = ssb_get_drvdata(dev);
 	wl = wldev->wl;
-	cancel_work_sync(&wldev->restart_work);
 	b43_debugfs_remove_device(wldev);
 	b43_wireless_core_detach(wldev);
 	list_del(&wldev->list);
 	wl->nr_devs--;
 	ssb_set_drvdata(dev, NULL);
 	kfree(wldev);
@@ -4690,12 +4694,16 @@ static int b43_probe(struct ssb_device *
 
 static void b43_remove(struct ssb_device *dev)
 {
 	struct b43_wl *wl = ssb_get_devtypedata(dev);
 	struct b43_wldev *wldev = ssb_get_drvdata(dev);
 
+	/* We must cancel any work here before unregistering from ieee80211,
+	 * as the ieee80211 unreg will destroy the workqueue. */
+	cancel_work_sync(&wldev->restart_work);
+
 	B43_WARN_ON(!wl);
 	if (wl->current_dev == wldev)
 		ieee80211_unregister_hw(wl->hw);
 
 	b43_one_core_detach(dev);
 
