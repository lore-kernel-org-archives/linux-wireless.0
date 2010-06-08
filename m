Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:2668 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab0FHS3w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jun 2010 14:29:52 -0400
Message-ID: <4C0E84AF.5010003@canonical.com>
Date: Tue, 08 Jun 2010 11:58:07 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Colin King <colin.king@canonical.com>
Subject: [PATCH] Bug 16111 - hostap_pci: infinite registered netdevice wifi0
Content-Type: multipart/mixed;
 boundary="------------040500040209040008060603"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040500040209040008060603
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

John,

With regard to https://bugzilla.kernel.org/show_bug.cgi?id=16111

This patch is against 2.6.35-rc2. I beleive the patch is suitable for 
stable, but it definitely needs to be backported.

rtg
-- 
Tim Gardner tim.gardner@canonical.com

--------------040500040209040008060603
Content-Type: text/x-patch;
 name="0001-hostap-Protect-against-initialization-interrupt.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-hostap-Protect-against-initialization-interrupt.patch"

>From c8422f9ee8ee77b1d248f3b76d2c0d593fd43282 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Tue, 8 Jun 2010 11:33:02 -0600
Subject: [PATCH] hostap: Protect against initialization interrupt

Use an irq spinlock to hold off the IRQ handler until
enough early card init is complete such that the handler
can run without faulting.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Cc: stable@kernel.org
---
 drivers/net/wireless/hostap/hostap_cs.c   |   15 +++++++++++++--
 drivers/net/wireless/hostap/hostap_hw.c   |   10 +++++++---
 drivers/net/wireless/hostap/hostap_wlan.h |    2 +-
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index db72461..29b31a6 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -594,6 +594,7 @@ static int prism2_config(struct pcmcia_device *link)
 	local_info_t *local;
 	int ret = 1;
 	struct hostap_cs_priv *hw_priv;
+	unsigned long flags;
 
 	PDEBUG(DEBUG_FLOW, "prism2_config()\n");
 
@@ -625,9 +626,15 @@ static int prism2_config(struct pcmcia_device *link)
 	local->hw_priv = hw_priv;
 	hw_priv->link = link;
 
+	/*
+	 * Make sure the IRQ handler cannot proceed until at least
+	 * dev->base_addr is initialized.
+	 */
+	spin_lock_irqsave(&local->irq_init_lock, flags);
+
 	ret = pcmcia_request_irq(link, prism2_interrupt);
 	if (ret)
-		goto failed;
+		goto failed_unlock;
 
 	/*
 	 * This actually configures the PCMCIA socket -- setting up
@@ -636,11 +643,13 @@ static int prism2_config(struct pcmcia_device *link)
 	 */
 	ret = pcmcia_request_configuration(link, &link->conf);
 	if (ret)
-		goto failed;
+		goto failed_unlock;
 
 	dev->irq = link->irq;
 	dev->base_addr = link->io.BasePort1;
 
+	spin_unlock_irqrestore(&local->irq_init_lock, flags);
+
 	/* Finally, report what we've done */
 	printk(KERN_INFO "%s: index 0x%02x: ",
 	       dev_info, link->conf.ConfigIndex);
@@ -667,6 +676,8 @@ static int prism2_config(struct pcmcia_device *link)
 
 	return ret;
 
+ failed_unlock:
+	 spin_unlock_irqrestore(&local->irq_init_lock, flags);
  failed:
 	kfree(hw_priv);
 	prism2_release((u_long)link);
diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index d707328..2f999fc 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -2618,17 +2618,20 @@ static irqreturn_t prism2_interrupt(int irq, void *dev_id)
 	int events = 0;
 	u16 ev;
 
+	iface = netdev_priv(dev);
+	local = iface->local;
+
 	/* Detect early interrupt before driver is fully configued */
+	spin_lock(&local->irq_init_lock);
 	if (!dev->base_addr) {
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG "%s: Interrupt, but dev not configured\n",
 			       dev->name);
 		}
+		spin_unlock(&local->irq_init_lock);
 		return IRQ_HANDLED;
 	}
-
-	iface = netdev_priv(dev);
-	local = iface->local;
+	spin_unlock(&local->irq_init_lock);
 
 	prism2_io_debug_add(dev, PRISM2_IO_DEBUG_CMD_INTERRUPT, 0, 0);
 
@@ -3147,6 +3150,7 @@ prism2_init_local_data(struct prism2_helper_functions *funcs, int card_idx,
 	spin_lock_init(&local->cmdlock);
 	spin_lock_init(&local->baplock);
 	spin_lock_init(&local->lock);
+	spin_lock_init(&local->irq_init_lock);
 	mutex_init(&local->rid_bap_mtx);
 
 	if (card_idx < 0 || card_idx >= MAX_PARM_DEVICES)
diff --git a/drivers/net/wireless/hostap/hostap_wlan.h b/drivers/net/wireless/hostap/hostap_wlan.h
index 3d23891..1ba33be 100644
--- a/drivers/net/wireless/hostap/hostap_wlan.h
+++ b/drivers/net/wireless/hostap/hostap_wlan.h
@@ -654,7 +654,7 @@ struct local_info {
 	rwlock_t iface_lock; /* hostap_interfaces read lock; use write lock
 			      * when removing entries from the list.
 			      * TX and RX paths can use read lock. */
-	spinlock_t cmdlock, baplock, lock;
+	spinlock_t cmdlock, baplock, lock, irq_init_lock;
 	struct mutex rid_bap_mtx;
 	u16 infofid; /* MAC buffer id for info frame */
 	/* txfid, intransmitfid, next_txtid, and next_alloc are protected by
-- 
1.7.0.4


--------------040500040209040008060603--
