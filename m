Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:56752 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758085AbZIFSLK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Sep 2009 14:11:10 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Luis Rodriguez <mcgrof@gmail.com>
Subject: [COMPAT PATCH] b43: Threaded interrupts wrapper
Date: Sun, 6 Sep 2009 20:07:26 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Message-Id: <200909062007.27279.mb@bu3sch.de>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_fp/oKWctQxZ0TsT"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_fp/oKWctQxZ0TsT
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

A patch converting b43 to threaded interrupts will be merged soon.
This will completely break b43 on compat-wireless, because working
threaded IRQ support requires kernel >= 2.6.31.

This patchset implements a workqueue based workaround wrapper, which
works on kernels with and without threaded IRQ support.

It's split up into a generic header and a b43 specific patch.
The generic header needs to be put somewhere into the compat include search
path. The b43 specific patch needs to be applied to compat-b43.
(The #include for the header file will also need to be adjusted)


-- 
Greetings, Michael.

--Boundary-00=_fp/oKWctQxZ0TsT
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="011-b43-use-compat-threaded-irq.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="011-b43-use-compat-threaded-irq.patch"

Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-09-06 19:48:52.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-09-06 19:54:28.000000000 +0200
@@ -3841,7 +3841,7 @@ redo:
 	/* Synchronize the interrupt handlers. Unlock to avoid deadlocks. */
 	orig_dev = dev;
 	mutex_unlock(&wl->mutex);
-	synchronize_irq(dev->dev->irq);
+	compat_synchronize_threaded_irq(&dev->irq_compat);
 	mutex_lock(&wl->mutex);
 	dev = wl->current_dev;
 	if (!dev)
@@ -3858,7 +3858,7 @@ redo:
 		dev_kfree_skb(skb_dequeue(&wl->tx_queue));
 
 	b43_mac_suspend(dev);
-	free_irq(dev->dev->irq, dev);
+	compat_free_threaded_irq(&dev->irq_compat);
 	b43_leds_exit(dev);
 	b43dbg(wl, "Wireless interface stopped\n");
 
@@ -3873,9 +3873,11 @@ static int b43_wireless_core_start(struc
 	B43_WARN_ON(b43_status(dev) != B43_STAT_INITIALIZED);
 
 	drain_txstatus_queue(dev);
-	err = request_threaded_irq(dev->dev->irq, b43_interrupt_handler,
-				   b43_interrupt_thread_handler,
-				   IRQF_SHARED, KBUILD_MODNAME, dev);
+	err = compat_request_threaded_irq(&dev->irq_compat,
+					  dev->dev->irq,
+					  b43_interrupt_handler,
+					  b43_interrupt_thread_handler,
+					  IRQF_SHARED, KBUILD_MODNAME, dev);
 	if (err) {
 		b43err(dev->wl, "Cannot request IRQ-%d\n", dev->dev->irq);
 		goto out;
@@ -4576,6 +4578,7 @@ static int b43_setup_bands(struct b43_wl
 
 static void b43_wireless_core_detach(struct b43_wldev *dev)
 {
+	compat_destroy_threaded_irq(&dev->irq_compat);
 	/* We release firmware that late to not be required to re-request
 	 * is all the time when we reinit the core. */
 	b43_release_firmware(dev);
Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2009-09-06 19:48:52.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2009-09-06 19:49:46.000000000 +0200
@@ -7,6 +7,7 @@
 #include <linux/hw_random.h>
 #include <linux/ssb/ssb.h>
 #include <net/mac80211.h>
+#include <linux/compat-threaded-irq.h>
 
 #include "debugfs.h"
 #include "leds.h"
@@ -818,6 +819,8 @@ struct b43_wldev {
 #ifdef CONFIG_B43_DEBUG
 	struct b43_dfsentry *dfsentry;
 #endif
+
+	struct compat_threaded_irq irq_compat;
 };
 
 static inline struct b43_wl *hw_to_b43_wl(struct ieee80211_hw *hw)

--Boundary-00=_fp/oKWctQxZ0TsT
Content-Type: text/x-chdr;
  charset="iso 8859-15";
  name="compat-threaded-irq.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="compat-threaded-irq.h"

#ifndef LINUX_COMPAT_THREADED_IRQ_H_
#define LINUX_COMPAT_THREADED_IRQ_H_

#include <linux/workqueue.h>
#include <linux/interrupt.h>
#include <linux/version.h>


#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
# define USE_COMP_THREADED_IRQ	1
# warning "Using compat threaded IRQ"
#else
# define USE_COMP_THREADED_IRQ	0
#endif


struct compat_threaded_irq {
	unsigned int irq;
	irq_handler_t handler;
	irq_handler_t thread_fn;
	void *dev_id;
	char wq_name[64];
	struct workqueue_struct *wq;
	struct work_struct work;
};

static inline
void compat_irq_work(struct work_struct *work)
{
	struct compat_threaded_irq *comp = container_of(work, struct compat_threaded_irq, work);

	comp->thread_fn(comp->irq, comp->dev_id);
}

static inline
irqreturn_t compat_irq_dispatcher(int irq, void *dev_id)
{
	struct compat_threaded_irq *comp = dev_id;
	irqreturn_t res;

	res = comp->handler(irq, comp->dev_id);
	if (res == IRQ_WAKE_THREAD) {
		queue_work(comp->wq, &comp->work);
		res = IRQ_HANDLED;
	}

	return res;
}

static inline
int compat_request_threaded_irq(struct compat_threaded_irq *comp,
				unsigned int irq,
				irq_handler_t handler,
				irq_handler_t thread_fn,
				unsigned long flags,
				const char *name,
				void *dev_id)
{
	comp->irq = irq;
	comp->handler = handler;
	comp->thread_fn = thread_fn;
	comp->dev_id = dev_id;
	INIT_WORK(&comp->work, compat_irq_work);

#if USE_COMP_THREADED_IRQ
	if (!comp->wq) {
		snprintf(comp->wq_name, sizeof(comp->wq_name),
			 "compirq/%u-%s", irq, name);
		comp->wq = create_singlethread_workqueue(comp->wq_name);
		if (!comp->wq) {
			printk(KERN_ERR "Failed to create compat-threaded-IRQ workqueue %s\n",
			       comp->wq_name);
			return -ENOMEM;
		}
	}
	return request_irq(irq, compat_irq_dispatcher, flags, name, comp);
#else
	return request_threaded_irq(irq, handler, thread_fn, flags, name, dev_id);
#endif
}

static inline
void compat_free_threaded_irq(struct compat_threaded_irq *comp)
{
#if USE_COMP_THREADED_IRQ
	free_irq(comp->irq, comp);
#else
	free_irq(comp->irq, comp->dev_id);
#endif
}

static inline
void compat_destroy_threaded_irq(struct compat_threaded_irq *comp)
{
#if USE_COMP_THREADED_IRQ
	if (comp->wq)
		destroy_workqueue(comp->wq);
	comp->wq = NULL;
#endif
}

static inline
void compat_synchronize_threaded_irq(struct compat_threaded_irq *comp)
{
	synchronize_irq(comp->irq);
#if USE_COMP_THREADED_IRQ
	cancel_work_sync(&comp->work);
#endif
}

#endif /* LINUX_COMPAT_THREADED_IRQ_H_ */

--Boundary-00=_fp/oKWctQxZ0TsT--
