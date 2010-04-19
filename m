Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:34085 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab0DSHfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 03:35:52 -0400
Received: by mail-ww0-f46.google.com with SMTP id 24so2319543wwb.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 00:35:51 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC 3/5] orinoco: encapsulate driver locking
Date: Mon, 19 Apr 2010 08:35:20 +0100
Message-Id: <1271662522-29119-4-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1271662522-29119-1-git-send-email-kilroyd@googlemail.com>
References: <1271662522-29119-1-git-send-email-kilroyd@googlemail.com>
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
 drivers/net/wireless/orinoco/hermes.c  |   26 +++++++++++++++++++++++++-
 drivers/net/wireless/orinoco/hermes.h  |    4 ++++
 drivers/net/wireless/orinoco/main.c    |   12 ++++++------
 drivers/net/wireless/orinoco/orinoco.h |   16 +++++++++++++---
 4 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/orinoco/hermes.c b/drivers/net/wireless/orinoco/hermes.c
index a7df524..6448366 100644
--- a/drivers/net/wireless/orinoco/hermes.c
+++ b/drivers/net/wireless/orinoco/hermes.c
@@ -529,6 +529,26 @@ static int hermes_write_ltv(hermes_t *hw, int bap, u16 rid,
 	return err;
 }
 
+void hermes_lock_irqsave(spinlock_t *lock, unsigned long *flags)
+{
+	spin_lock_irqsave(lock, *flags);
+}
+
+void hermes_unlock_irqrestore(spinlock_t *lock, unsigned long *flags)
+{
+	spin_unlock_irqrestore(lock, *flags);
+}
+
+void hermes_lock_irq(spinlock_t *lock)
+{
+	spin_lock_irq(lock);
+}
+
+void hermes_unlock_irq(spinlock_t *lock)
+{
+	spin_unlock_irq(lock);
+}
+
 /* Hermes operations for local buses */
 static const struct hermes_ops hermes_ops_local = {
 	.init = hermes_init,
@@ -538,5 +558,9 @@ static const struct hermes_ops hermes_ops_local = {
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
index 9dc458d..9485da2 100644
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
-- 
1.6.4.4

