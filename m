Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:37545 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab0EANGH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 09:06:07 -0400
Received: by wwb34 with SMTP id 34so763778wwb.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 May 2010 06:06:06 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net, linville@tuxdriver.com,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 3/6] orinoco: encapsulate driver locking
Date: Sat,  1 May 2010 14:05:40 +0100
Message-Id: <1272719143-26171-4-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1272719143-26171-1-git-send-email-kilroyd@googlemail.com>
References: <1272719143-26171-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Local bus and USB drivers will need to do locking differently.

The original orinoco_usb patches had a boolean variable controlling
whether spin_lock_bh was used, or irq based locking. This version
provides wrappers for the lock functions and the drivers specify the
functions pointers needed.

This will introduce a performance penalty, but I'm not expecting it to
be noticable.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/airport.c     |    4 ++--
 drivers/net/wireless/orinoco/hermes.c      |   28 +++++++++++++++++++++++++++-
 drivers/net/wireless/orinoco/hermes.h      |    4 ++++
 drivers/net/wireless/orinoco/main.c        |   20 ++++++++++----------
 drivers/net/wireless/orinoco/orinoco.h     |   16 +++++++++++++---
 drivers/net/wireless/orinoco/orinoco_cs.c  |    4 ++--
 drivers/net/wireless/orinoco/spectrum_cs.c |    4 ++--
 7 files changed, 60 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/orinoco/airport.c b/drivers/net/wireless/orinoco/airport.c
index 7dac5ad..9bcee10 100644
--- a/drivers/net/wireless/orinoco/airport.c
+++ b/drivers/net/wireless/orinoco/airport.c
@@ -77,9 +77,9 @@ airport_resume(struct macio_dev *mdev)
 
 	enable_irq(card->irq);
 
-	spin_lock_irqsave(&priv->lock, flags);
+	priv->hw.ops->lock_irqsave(&priv->lock, &flags);
 	err = orinoco_up(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
+	priv->hw.ops->unlock_irqrestore(&priv->lock, &flags);
 
 	return err;
 }
diff --git a/drivers/net/wireless/orinoco/hermes.c b/drivers/net/wireless/orinoco/hermes.c
index a7df524..845693f 100644
--- a/drivers/net/wireless/orinoco/hermes.c
+++ b/drivers/net/wireless/orinoco/hermes.c
@@ -529,6 +529,28 @@ static int hermes_write_ltv(hermes_t *hw, int bap, u16 rid,
 	return err;
 }
 
+static void hermes_lock_irqsave(spinlock_t *lock,
+				unsigned long *flags) __acquires(lock)
+{
+	spin_lock_irqsave(lock, *flags);
+}
+
+static void hermes_unlock_irqrestore(spinlock_t *lock,
+				     unsigned long *flags) __releases(lock)
+{
+	spin_unlock_irqrestore(lock, *flags);
+}
+
+static void hermes_lock_irq(spinlock_t *lock) __acquires(lock)
+{
+	spin_lock_irq(lock);
+}
+
+static void hermes_unlock_irq(spinlock_t *lock) __releases(lock)
+{
+	spin_unlock_irq(lock);
+}
+
 /* Hermes operations for local buses */
 static const struct hermes_ops hermes_ops_local = {
 	.init = hermes_init,
@@ -538,5 +560,9 @@ static const struct hermes_ops hermes_ops_local = {
 	.read_ltv = hermes_read_ltv,
 	.write_ltv = hermes_write_ltv,
 	.bap_pread = hermes_bap_pread,
-	.bap_pwrite = hermes_bap_pwrite
+	.bap_pwrite = hermes_bap_pwrite,
+	.lock_irqsave = hermes_lock_irqsave,
+	.unlock_irqrestore = hermes_unlock_irqrestore,
+	.lock_irq = hermes_lock_irq,
+	.unlock_irq = hermes_unlock_irq,
 };
diff --git a/drivers/net/wireless/orinoco/hermes.h b/drivers/net/wireless/orinoco/hermes.h
index 18b268c..9e21ecd 100644
--- a/drivers/net/wireless/orinoco/hermes.h
+++ b/drivers/net/wireless/orinoco/hermes.h
@@ -393,6 +393,10 @@ struct hermes_ops {
 			 u16 id, u16 offset);
 	int (*bap_pwrite)(struct hermes *hw, int bap, const void *buf,
 			  int len, u16 id, u16 offset);
+	void (*lock_irqsave)(spinlock_t *lock, unsigned long *flags);
+	void (*unlock_irqrestore)(spinlock_t *lock, unsigned long *flags);
+	void (*lock_irq)(spinlock_t *lock);
+	void (*unlock_irq)(spinlock_t *lock);
 };
 
 /* Basic control structure */
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 9dc458d..78a210d 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -282,13 +282,13 @@ int orinoco_stop(struct net_device *dev)
 	/* We mustn't use orinoco_lock() here, because we need to be
 	   able to close the interface even if hw_unavailable is set
 	   (e.g. as we're released after a PC Card removal) */
-	spin_lock_irq(&priv->lock);
+	orinoco_lock_irq(priv);
 
 	priv->open = 0;
 
 	err = __orinoco_down(priv);
 
-	spin_unlock_irq(&priv->lock);
+	orinoco_unlock_irq(priv);
 
 	return err;
 }
@@ -1742,7 +1742,7 @@ void orinoco_reset(struct work_struct *work)
 	}
 
 	/* This has to be called from user context */
-	spin_lock_irq(&priv->lock);
+	orinoco_lock_irq(priv);
 
 	priv->hw_unavailable--;
 
@@ -1757,7 +1757,7 @@ void orinoco_reset(struct work_struct *work)
 			dev->trans_start = jiffies;
 	}
 
-	spin_unlock_irq(&priv->lock);
+	orinoco_unlock_irq(priv);
 
 	return;
  disable:
@@ -2074,9 +2074,9 @@ int orinoco_init(struct orinoco_private *priv)
 
 	/* Make the hardware available, as long as it hasn't been
 	 * removed elsewhere (e.g. by PCMCIA hot unplug) */
-	spin_lock_irq(&priv->lock);
+	orinoco_lock_irq(priv);
 	priv->hw_unavailable--;
-	spin_unlock_irq(&priv->lock);
+	orinoco_unlock_irq(priv);
 
 	dev_dbg(dev, "Ready\n");
 
@@ -2318,7 +2318,7 @@ int orinoco_up(struct orinoco_private *priv)
 	unsigned long flags;
 	int err;
 
-	spin_lock_irqsave(&priv->lock, flags);
+	priv->hw.ops->lock_irqsave(&priv->lock, &flags);
 
 	err = orinoco_reinit_firmware(priv);
 	if (err) {
@@ -2338,7 +2338,7 @@ int orinoco_up(struct orinoco_private *priv)
 	}
 
 exit:
-	spin_unlock_irqrestore(&priv->lock, flags);
+	priv->hw.ops->unlock_irqrestore(&priv->lock, &flags);
 
 	return 0;
 }
@@ -2350,7 +2350,7 @@ void orinoco_down(struct orinoco_private *priv)
 	unsigned long flags;
 	int err;
 
-	spin_lock_irqsave(&priv->lock, flags);
+	priv->hw.ops->lock_irqsave(&priv->lock, &flags);
 	err = __orinoco_down(priv);
 	if (err)
 		printk(KERN_WARNING "%s: Error %d downing interface\n",
@@ -2358,7 +2358,7 @@ void orinoco_down(struct orinoco_private *priv)
 
 	netif_device_detach(dev);
 	priv->hw_unavailable++;
-	spin_unlock_irqrestore(&priv->lock, flags);
+	priv->hw.ops->unlock_irqrestore(&priv->lock, &flags);
 }
 EXPORT_SYMBOL(orinoco_down);
 
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index f1901d6..80a1386 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -212,11 +212,11 @@ void orinoco_tx_timeout(struct net_device *dev);
 static inline int orinoco_lock(struct orinoco_private *priv,
 			       unsigned long *flags)
 {
-	spin_lock_irqsave(&priv->lock, *flags);
+	priv->hw.ops->lock_irqsave(&priv->lock, flags);
 	if (priv->hw_unavailable) {
 		DEBUG(1, "orinoco_lock() called with hw_unavailable (dev=%p)\n",
 		       priv->ndev);
-		spin_unlock_irqrestore(&priv->lock, *flags);
+		priv->hw.ops->unlock_irqrestore(&priv->lock, flags);
 		return -EBUSY;
 	}
 	return 0;
@@ -225,7 +225,17 @@ static inline int orinoco_lock(struct orinoco_private *priv,
 static inline void orinoco_unlock(struct orinoco_private *priv,
 				  unsigned long *flags)
 {
-	spin_unlock_irqrestore(&priv->lock, *flags);
+	priv->hw.ops->unlock_irqrestore(&priv->lock, flags);
+}
+
+static inline void orinoco_lock_irq(struct orinoco_private *priv)
+{
+	priv->hw.ops->lock_irq(&priv->lock);
+}
+
+static inline void orinoco_unlock_irq(struct orinoco_private *priv)
+{
+	priv->hw.ops->unlock_irq(&priv->lock);
 }
 
 /*** Navigate from net_device to orinoco_private ***/
diff --git a/drivers/net/wireless/orinoco/orinoco_cs.c b/drivers/net/wireless/orinoco/orinoco_cs.c
index 525f74e..f99b13b 100644
--- a/drivers/net/wireless/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco/orinoco_cs.c
@@ -327,9 +327,9 @@ orinoco_cs_release(struct pcmcia_device *link)
 
 	/* We're committed to taking the device away now, so mark the
 	 * hardware as unavailable */
-	spin_lock_irqsave(&priv->lock, flags);
+	priv->hw.ops->lock_irqsave(&priv->lock, &flags);
 	priv->hw_unavailable++;
-	spin_unlock_irqrestore(&priv->lock, flags);
+	priv->hw.ops->unlock_irqrestore(&priv->lock, &flags);
 
 	pcmcia_disable_device(link);
 	if (priv->hw.iobase)
diff --git a/drivers/net/wireless/orinoco/spectrum_cs.c b/drivers/net/wireless/orinoco/spectrum_cs.c
index 77b5871..b4f68ef 100644
--- a/drivers/net/wireless/orinoco/spectrum_cs.c
+++ b/drivers/net/wireless/orinoco/spectrum_cs.c
@@ -405,9 +405,9 @@ spectrum_cs_release(struct pcmcia_device *link)
 
 	/* We're committed to taking the device away now, so mark the
 	 * hardware as unavailable */
-	spin_lock_irqsave(&priv->lock, flags);
+	priv->hw.ops->lock_irqsave(&priv->lock, &flags);
 	priv->hw_unavailable++;
-	spin_unlock_irqrestore(&priv->lock, flags);
+	priv->hw.ops->unlock_irqrestore(&priv->lock, &flags);
 
 	pcmcia_disable_device(link);
 	if (priv->hw.iobase)
-- 
1.6.4.4

