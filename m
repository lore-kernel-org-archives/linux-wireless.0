Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:35280
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbXI1OV2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 10:21:28 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Rewrite pwork locking policy.
Date: Fri, 28 Sep 2007 16:19:03 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709281619.04154.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement much easier and more lightweight locking for
the periodic work.
This also removes the last big busywait loop and replaces it
by a sleeping loop.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2007-09-28 14:31:48.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2007-09-28 15:59:40.000000000 +0200
@@ -1989,6 +1989,7 @@ void b43_mac_enable(struct b43_wldev *de
 {
 	dev->mac_suspended--;
 	B43_WARN_ON(dev->mac_suspended < 0);
+	B43_WARN_ON(irqs_disabled());
 	if (dev->mac_suspended == 0) {
 		b43_write32(dev, B43_MMIO_MACCTL,
 			    b43_read32(dev, B43_MMIO_MACCTL)
@@ -1999,6 +2000,11 @@ void b43_mac_enable(struct b43_wldev *de
 		b43_read32(dev, B43_MMIO_MACCTL);
 		b43_read32(dev, B43_MMIO_GEN_IRQ_REASON);
 		b43_power_saving_ctl_bits(dev, 0);
+
+		/* Re-enable IRQs. */
+		spin_lock_irq(&dev->wl->irq_lock);
+		b43_interrupt_enable(dev, dev->irq_savedstate);
+		spin_unlock_irq(&dev->wl->irq_lock);
 	}
 }
 
@@ -2008,23 +2014,34 @@ void b43_mac_suspend(struct b43_wldev *d
 	int i;
 	u32 tmp;
 
+	might_sleep();
+	B43_WARN_ON(irqs_disabled());
 	B43_WARN_ON(dev->mac_suspended < 0);
+
 	if (dev->mac_suspended == 0) {
+		/* Mask IRQs before suspending MAC. Otherwise
+		 * the MAC stays busy and won't suspend. */
+		spin_lock_irq(&dev->wl->irq_lock);
+		tmp = b43_interrupt_disable(dev, B43_IRQ_ALL);
+		spin_unlock_irq(&dev->wl->irq_lock);
+		b43_synchronize_irq(dev);
+		dev->irq_savedstate = tmp;
+
 		b43_power_saving_ctl_bits(dev, B43_PS_AWAKE);
 		b43_write32(dev, B43_MMIO_MACCTL,
 			    b43_read32(dev, B43_MMIO_MACCTL)
 			    & ~B43_MACCTL_ENABLED);
 		/* force pci to flush the write */
 		b43_read32(dev, B43_MMIO_MACCTL);
-		for (i = 10000; i; i--) {
+		for (i = 40; i; i--) {
 			tmp = b43_read32(dev, B43_MMIO_GEN_IRQ_REASON);
 			if (tmp & B43_IRQ_MAC_SUSPENDED)
 				goto out;
-			udelay(1);
+			msleep(1);
 		}
 		b43err(dev->wl, "MAC suspend failed\n");
 	}
-      out:
+out:
 	dev->mac_suspended++;
 }
 
@@ -2373,77 +2390,36 @@ static void do_periodic_work(struct b43_
 	b43_periodic_every15sec(dev);
 }
 
-/* Estimate a "Badness" value based on the periodic work
- * state-machine state. "Badness" is worse (bigger), if the
- * periodic work will take longer.
+/* Periodic work locking policy:
+ * 	The whole periodic work handler is protected by
+ * 	wl->mutex. If another lock is needed somewhere in the
+ * 	pwork callchain, it's aquired in-place, where it's needed.
  */
-static int estimate_periodic_work_badness(unsigned int state)
-{
-	int badness = 0;
-
-	if (state % 8 == 0)	/* every 120 sec */
-		badness += 10;
-	if (state % 4 == 0)	/* every 60 sec */
-		badness += 5;
-	if (state % 2 == 0)	/* every 30 sec */
-		badness += 1;
-
-#define BADNESS_LIMIT	4
-	return badness;
-}
-
 static void b43_periodic_work_handler(struct work_struct *work)
 {
-	struct b43_wldev *dev =
-	    container_of(work, struct b43_wldev, periodic_work.work);
-	unsigned long flags, delay;
-	u32 savedirqs = 0;
-	int badness;
+	struct b43_wldev *dev = container_of(work, struct b43_wldev,
+					     periodic_work.work);
+	struct b43_wl *wl = dev->wl;
+	unsigned long delay;
 
-	mutex_lock(&dev->wl->mutex);
+	mutex_lock(&wl->mutex);
 
 	if (unlikely(b43_status(dev) != B43_STAT_STARTED))
 		goto out;
 	if (b43_debug(dev, B43_DBG_PWORK_STOP))
 		goto out_requeue;
 
-	badness = estimate_periodic_work_badness(dev->periodic_state);
-	if (badness > BADNESS_LIMIT) {
-		spin_lock_irqsave(&dev->wl->irq_lock, flags);
-		/* Suspend TX as we don't want to transmit packets while
-		 * we recalibrate the hardware. */
-		b43_tx_suspend(dev);
-		savedirqs = b43_interrupt_disable(dev, B43_IRQ_ALL);
-		/* Periodic work will take a long time, so we want it to
-		 * be preemtible and release the spinlock. */
-		spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
-		b43_synchronize_irq(dev);
-
-		do_periodic_work(dev);
+	do_periodic_work(dev);
 
-		spin_lock_irqsave(&dev->wl->irq_lock, flags);
-		b43_interrupt_enable(dev, savedirqs);
-		b43_tx_resume(dev);
-		mmiowb();
-		spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
-	} else {
-		/* Take the global driver lock. This will lock any operation. */
-		spin_lock_irqsave(&dev->wl->irq_lock, flags);
-
-		do_periodic_work(dev);
-
-		mmiowb();
-		spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
-	}
 	dev->periodic_state++;
 out_requeue:
 	if (b43_debug(dev, B43_DBG_PWORK_FAST))
 		delay = msecs_to_jiffies(50);
 	else
 		delay = round_jiffies(HZ * 15);
-	queue_delayed_work(dev->wl->hw->workqueue, &dev->periodic_work, delay);
+	queue_delayed_work(wl->hw->workqueue, &dev->periodic_work, delay);
 out:
-	mutex_unlock(&dev->wl->mutex);
+	mutex_unlock(&wl->mutex);
 }
 
 static void b43_periodic_tasks_setup(struct b43_wldev *dev)
