Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:59666
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbXH1S4Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 14:56:24 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix cancelation of workqueues
Date: Tue, 28 Aug 2007 20:54:16 +0200
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200708282054.16490.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This correctly cancels all workqueues on shutdown.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <larry.finger.lwfinger.net>

Index: wireless-dev-new/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/main.c	2007-08-28 20:23:35.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/main.c	2007-08-28 20:36:27.000000000 +0200
@@ -2474,11 +2474,6 @@ static void b43_periodic_work_handler(st
 	mutex_unlock(&dev->wl->mutex);
 }
 
-static void b43_periodic_tasks_delete(struct b43_wldev *dev)
-{
-	cancel_rearming_delayed_work(&dev->periodic_work);
-}
-
 static void b43_periodic_tasks_setup(struct b43_wldev *dev)
 {
 	struct delayed_work *work = &dev->periodic_work;
@@ -3055,9 +3050,9 @@ static void b43_wireless_core_stop(struc
 	b43_set_status(dev, B43_STAT_INITIALIZED);
 
 	mutex_unlock(&wl->mutex);
-	/* Must unlock as it would otherwise deadlock. No races here. */
-	b43_periodic_tasks_delete(dev);
-	flush_workqueue(dev->wl->hw->workqueue);
+	/* Must unlock as it would otherwise deadlock. No races here.
+	 * Cancel the possibly running self-rearming periodic work. */
+	cancel_delayed_work_sync(&dev->periodic_work);
 	mutex_lock(&wl->mutex);
 
 	ieee80211_stop_queues(wl->hw);	//FIXME this could cause a deadlock, as mac80211 seems buggy.
@@ -3322,13 +3317,22 @@ static void b43_imcfglo_timeouts_workaro
 }
 
 /* Shutdown a wireless core */
+/* Locking: wl->mutex */
 static void b43_wireless_core_exit(struct b43_wldev *dev)
 {
+	struct b43_wl *wl = dev->wl;
 	struct b43_phy *phy = &dev->phy;
 
 	B43_WARN_ON(b43_status(dev) > B43_STAT_INITIALIZED);
 	if (b43_status(dev) != B43_STAT_INITIALIZED)
 		return;
+	b43_set_status(dev, B43_STAT_UNINIT);
+
+	mutex_unlock(&wl->mutex);
+	/* Must unlock as it would otherwise deadlock. No races here.
+	 * Cancel possibly pending workqueues. */
+	cancel_work_sync(&dev->restart_work);
+	mutex_lock(&wl->mutex);
 
 	b43_rng_exit(dev->wl);
 	b43_pio_free(dev);
@@ -3342,7 +3346,6 @@ static void b43_wireless_core_exit(struc
 	phy->lo_control = NULL;
 	ssb_device_disable(dev->dev, 0);
 	ssb_bus_may_powerdown(dev->dev->bus);
-	b43_set_status(dev, B43_STAT_UNINIT);
 }
 
 /* Initialize a wireless core */
@@ -4001,6 +4004,9 @@ static void b43_remove(struct ssb_device
 /* Perform a hardware reset. This can be called from any context. */
 void b43_controller_restart(struct b43_wldev *dev, const char *reason)
 {
+	/* Must avoid requeueing, if we are in shutdown. */
+	if (b43_status(dev) < B43_STAT_INITIALIZED)
+		return;
 	b43info(dev->wl, "Controller RESET (%s) ...\n", reason);
 	queue_work(dev->wl->hw->workqueue, &dev->restart_work);
 }
