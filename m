Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost03.isp.att.net ([204.127.217.103]:51184 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbZENXV3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 19:21:29 -0400
Message-ID: <4A0CA760.5040900@lwfinger.net>
Date: Thu, 14 May 2009 18:21:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: Stefano Brivio <stefano.brivio@polimi.it>,
	Michael Buesch <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 2/2] b43legacy: Fix locking problem
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit abb1d2bca0fc429c136747a64e675dd4d8906f36 introduced a locking
problem in b43legacy that caused the system to freeze upon booting.

Signed-off-by: Larry Finger@lwfinger.net
---

John,

This is 2.6.31 material. I hope that you do not have trouble with
this patch. While on the road, my normal method is not available.

Larry
---

Index: wireless-testing/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c
@@ -2771,29 +2771,18 @@ static void b43legacy_op_bss_info_change
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev;
-	struct b43legacy_phy *phy;
 	unsigned long flags;

 	mutex_lock(&wl->mutex);
-	B43legacy_WARN_ON(wl->vif != vif);

 	dev = wl->current_dev;
-	phy = &dev->phy;
-
-	/* Disable IRQs while reconfiguring the device.
-	 * This makes it possible to drop the spinlock throughout
-	 * the reconfiguration process. */
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	if (b43legacy_status(dev) < B43legacy_STAT_STARTED) {
-		spin_unlock_irqrestore(&wl->irq_lock, flags);
+	if (!dev || b43legacy_status(dev) < B43legacy_STAT_STARTED)
 		goto out_unlock_mutex;
-	}
-	b43legacy_write32(dev, B43legacy_MMIO_GEN_IRQ_MASK, 0);

-	if (changed & BSS_CHANGED_BSSID) {
-		spin_unlock_irqrestore(&wl->irq_lock, flags);
-		b43legacy_synchronize_irq(dev);
+	B43legacy_WARN_ON(wl->vif != vif);

+	if (changed & BSS_CHANGED_BSSID) {
+		spin_lock_irqsave(&wl->irq_lock, flags);
 		if (conf->bssid)
 			memcpy(wl->bssid, conf->bssid, ETH_ALEN);
 		else
@@ -2831,12 +2820,6 @@ static void b43legacy_op_bss_info_change
 	}

 	b43legacy_mac_enable(dev);
-
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	b43legacy_write32(dev, B43legacy_MMIO_GEN_IRQ_MASK, dev->irq_mask);
-	/* XXX: why? */
-	mmiowb();
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
  out_unlock_mutex:
 	mutex_unlock(&wl->mutex);
 }


