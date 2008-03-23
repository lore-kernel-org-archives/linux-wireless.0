Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:35639 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbYCWAKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Mar 2008 20:10:19 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Remove irqs_disabled() sanity checks
Date: Sun, 23 Mar 2008 01:08:22 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803230108.22652.mb@bu3sch.de> (sfid-20080323_001030_358476_A182F9A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove all irqs_disabled() sanity checks, as they are not safe on
a RT-enabled kernel and will trigger bogus warnings.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please apply to 2.6.25


Index: wireless-testing/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.c	2008-02-15 21:39:56.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/debugfs.c	2008-03-23 01:00:40.000000000 +0100
@@ -615,25 +615,25 @@ void b43_debugfs_remove_device(struct b4
 
 	debugfs_remove(e->subdir);
 	kfree(e->txstatlog.log);
 	kfree(e);
 }
 
+/* Called with IRQs disabled. */
 void b43_debugfs_log_txstat(struct b43_wldev *dev,
 			    const struct b43_txstatus *status)
 {
 	struct b43_dfsentry *e = dev->dfsentry;
 	struct b43_txstatus_log *log;
 	struct b43_txstatus *cur;
 	int i;
 
 	if (!e)
 		return;
 	log = &e->txstatlog;
-	B43_WARN_ON(!irqs_disabled());
-	spin_lock(&log->lock);
+	spin_lock(&log->lock); /* IRQs are already disabled. */
 	i = log->end + 1;
 	if (i == B43_NR_LOGGED_TXSTATUS)
 		i = 0;
 	log->end = i;
 	cur = &(log->log[i]);
 	memcpy(cur, status, sizeof(*cur));
Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2008-03-23 00:54:27.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2008-03-23 01:01:14.000000000 +0100
@@ -1343,26 +1343,27 @@ static void b43_fill_txstatus_report(str
 			ring->nr_succeed_tx_packets++;
 		ring->nr_total_packet_tries += status->frame_count;
 #endif /* DEBUG */
 	}
 }
 
+/* Called with IRQs disabled. */
 void b43_dma_handle_txstatus(struct b43_wldev *dev,
 			     const struct b43_txstatus *status)
 {
 	const struct b43_dma_ops *ops;
 	struct b43_dmaring *ring;
 	struct b43_dmadesc_generic *desc;
 	struct b43_dmadesc_meta *meta;
 	int slot;
 
 	ring = parse_cookie(dev, status->cookie, &slot);
 	if (unlikely(!ring))
 		return;
-	B43_WARN_ON(!irqs_disabled());
-	spin_lock(&ring->lock);
+
+	spin_lock(&ring->lock); /* IRQs are already disabled. */
 
 	B43_WARN_ON(!ring->tx);
 	ops = ring->ops;
 	while (1) {
 		B43_WARN_ON(!(slot >= 0 && slot < ring->nr_slots));
 		desc = ops->idx2desc(ring, slot, &meta);
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-03-22 21:50:35.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-03-23 00:59:05.000000000 +0100
@@ -2155,13 +2155,12 @@ static void b43_gpio_cleanup(struct b43_
 
 /* http://bcm-specs.sipsolutions.net/EnableMac */
 static void b43_mac_enable(struct b43_wldev *dev)
 {
 	dev->mac_suspended--;
 	B43_WARN_ON(dev->mac_suspended < 0);
-	B43_WARN_ON(irqs_disabled());
 	if (dev->mac_suspended == 0) {
 		b43_write32(dev, B43_MMIO_MACCTL,
 			    b43_read32(dev, B43_MMIO_MACCTL)
 			    | B43_MACCTL_ENABLED);
 		b43_write32(dev, B43_MMIO_GEN_IRQ_REASON,
 			    B43_IRQ_MAC_SUSPENDED);
@@ -2181,13 +2180,12 @@ static void b43_mac_enable(struct b43_wl
 static void b43_mac_suspend(struct b43_wldev *dev)
 {
 	int i;
 	u32 tmp;
 
 	might_sleep();
-	B43_WARN_ON(irqs_disabled());
 	B43_WARN_ON(dev->mac_suspended < 0);
 
 	if (dev->mac_suspended == 0) {
 		/* Mask IRQs before suspending MAC. Otherwise
 		 * the MAC stays busy and won't suspend. */
 		spin_lock_irq(&dev->wl->irq_lock);
