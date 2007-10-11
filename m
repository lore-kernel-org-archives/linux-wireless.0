Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63161 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbXJKFF7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2007 01:05:59 -0400
Date: Thu, 11 Oct 2007 00:05:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: Rewrite pwork locking
Message-ID: <470daf35.ps3UdT7crk8kVap5%Larry.Finger@lwfinger.net> (sfid-20071011_060605_537693_E45DC721)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement much easier and more lightweight locking for
the periodic work. This also removes the last big busywait
loop and replaces it by a sleeping loop.

This patch for b43legacy is patterned aftar the same patch
for b43 by Michael Buesch <mb@bu3sch.de>.

Signed-off-by: Larry Finger <larry.finger@lwfinger.net>
---

 drivers/net/wireless/b43legacy/main.c |   88 +++++++++++-----------------------
 1 file changed, 30 insertions(+), 58 deletions(-)

Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c
@@ -1797,6 +1797,7 @@ void b43legacy_mac_enable(struct b43lega
 {
 	dev->mac_suspended--;
 	B43legacy_WARN_ON(dev->mac_suspended < 0);
+	B43legacy_WARN_ON(irqs_disabled());
 	if (dev->mac_suspended == 0) {
 		b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD,
 				  b43legacy_read32(dev,
@@ -1808,6 +1809,11 @@ void b43legacy_mac_enable(struct b43lega
 		b43legacy_read32(dev, B43legacy_MMIO_STATUS_BITFIELD);
 		b43legacy_read32(dev, B43legacy_MMIO_GEN_IRQ_REASON);
 		b43legacy_power_saving_ctl_bits(dev, -1, -1);
+
+		/* Re-enable IRQs. */
+		spin_lock_irq(&dev->wl->irq_lock);
+		b43legacy_interrupt_enable(dev, dev->irq_savedstate);
+		spin_unlock_irq(&dev->wl->irq_lock);
 	}
 }
 
@@ -1817,20 +1823,31 @@ void b43legacy_mac_suspend(struct b43leg
 	int i;
 	u32 tmp;
 
+	might_sleep();
+	B43legacy_WARN_ON(irqs_disabled());
 	B43legacy_WARN_ON(dev->mac_suspended < 0);
+
 	if (dev->mac_suspended == 0) {
+		/* Mask IRQs before suspending MAC. Otherwise
+		 * the MAC stays busy and won't suspend. */
+		spin_lock_irq(&dev->wl->irq_lock);
+		tmp = b43legacy_interrupt_disable(dev, B43legacy_IRQ_ALL);
+		spin_unlock_irq(&dev->wl->irq_lock);
+		b43legacy_synchronize_irq(dev);
+		dev->irq_savedstate = tmp;
+
 		b43legacy_power_saving_ctl_bits(dev, -1, 1);
 		b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD,
 				  b43legacy_read32(dev,
 				  B43legacy_MMIO_STATUS_BITFIELD)
 				  & ~B43legacy_SBF_MAC_ENABLED);
 		b43legacy_read32(dev, B43legacy_MMIO_GEN_IRQ_REASON);
-		for (i = 10000; i; i--) {
+		for (i = 40; i; i--) {
 			tmp = b43legacy_read32(dev,
 					       B43legacy_MMIO_GEN_IRQ_REASON);
 			if (tmp & B43legacy_IRQ_MAC_SUSPENDED)
 				goto out;
-			udelay(1);
+			msleep(1);
 		}
 		b43legacyerr(dev->wl, "MAC suspend failed\n");
 	}
@@ -2145,81 +2162,36 @@ static void do_periodic_work(struct b43l
 	b43legacy_periodic_every15sec(dev);
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
 static void b43legacy_periodic_work_handler(struct work_struct *work)
 {
-	struct b43legacy_wldev *dev =
-			     container_of(work, struct b43legacy_wldev,
-			     periodic_work.work);
-	unsigned long flags;
+	struct b43legacy_wldev *dev = container_of(work, struct b43legacy_wldev,
+					     periodic_work.work);
+	struct b43legacy_wl *wl = dev->wl;
 	unsigned long delay;
-	u32 savedirqs = 0;
-	int badness;
 
-	mutex_lock(&dev->wl->mutex);
+	mutex_lock(&wl->mutex);
 
 	if (unlikely(b43legacy_status(dev) != B43legacy_STAT_STARTED))
 		goto out;
 	if (b43legacy_debug(dev, B43legacy_DBG_PWORK_STOP))
 		goto out_requeue;
 
-	badness = estimate_periodic_work_badness(dev->periodic_state);
-	if (badness > BADNESS_LIMIT) {
-		spin_lock_irqsave(&dev->wl->irq_lock, flags);
-		/* Suspend TX as we don't want to transmit packets while
-		 * we recalibrate the hardware. */
-		b43legacy_tx_suspend(dev);
-		savedirqs = b43legacy_interrupt_disable(dev,
-							  B43legacy_IRQ_ALL);
-		/* Periodic work will take a long time, so we want it to
-		 * be preemtible and release the spinlock. */
-		spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
-		b43legacy_synchronize_irq(dev);
-
-		do_periodic_work(dev);
+	do_periodic_work(dev);
 
-		spin_lock_irqsave(&dev->wl->irq_lock, flags);
-		b43legacy_interrupt_enable(dev, savedirqs);
-		b43legacy_tx_resume(dev);
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
 	if (b43legacy_debug(dev, B43legacy_DBG_PWORK_FAST))
 		delay = msecs_to_jiffies(50);
 	else
 		delay = round_jiffies(HZ * 15);
-	queue_delayed_work(dev->wl->hw->workqueue,
-			   &dev->periodic_work, delay);
+	queue_delayed_work(wl->hw->workqueue, &dev->periodic_work, delay);
 out:
-	mutex_unlock(&dev->wl->mutex);
+	mutex_unlock(&wl->mutex);
 }
 
 static void b43legacy_periodic_tasks_setup(struct b43legacy_wldev *dev)
