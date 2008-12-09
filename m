Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:55180 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbYLIUI7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 15:08:59 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] p54: enforce strict tx_queue limits
Date: Tue, 9 Dec 2008 21:09:00 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812092109.00988.chunkeey@web.de> (sfid-20081209_210901_896878_1D486ED4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch fixes an old FIXME in p54pci.c by moving the "queue full" 
check into the common library, where we can deal with it properly.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-12-09 20:13:56.467888032 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-12-09 20:49:21.235888230 +0100
@@ -889,7 +889,27 @@ static int p54_assign_address(struct iee
 		return -EINVAL;
 
 	spin_lock_irqsave(&priv->tx_queue.lock, flags);
+
 	left = skb_queue_len(&priv->tx_queue);
+	if (unlikely(left >= 28)) {
+		/*
+		 * The tx_queue is nearly full!
+		 * We have throttle normal data traffic, because we must
+		 * have a few spare slots for control frames left.
+		 */
+		ieee80211_stop_queues(dev);
+
+		if (unlikely(left == 32)) {
+			/*
+			 * The tx_queue is now really full.
+			 *
+			 * TODO: check if the device has crashed and reset it.
+			 */
+			spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
+			return -ENOSPC;
+		}
+	}
+
 	while (left--) {
 		u32 hole_size;
 		info = IEEE80211_SKB_CB(entry);
@@ -918,7 +938,7 @@ static int p54_assign_address(struct iee
 	if (!target_skb) {
 		spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 		ieee80211_stop_queues(dev);
-		return -ENOMEM;
+		return -ENOSPC;
 	}
 
 	info = IEEE80211_SKB_CB(skb);
diff -Nurp a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
--- a/drivers/net/wireless/p54/p54pci.c	2008-12-09 20:05:21.251888445 +0100
+++ b/drivers/net/wireless/p54/p54pci.c	2008-12-07 22:04:45.952897552 +0100
@@ -332,13 +332,6 @@ static void p54p_tx(struct ieee80211_hw 
 
 	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_UPDATE));
 	P54P_READ(dev_int);
-
-	/* FIXME: unlikely to happen because the device usually runs out of
-	   memory before we fill the ring up, but we can make it impossible */
-	if (idx - device_idx > ARRAY_SIZE(ring_control->tx_data) - 2) {
-		p54_free_skb(dev, skb);
-		printk(KERN_INFO "%s: tx overflow.\n", wiphy_name(dev->wiphy));
-	}
 }
 
 static void p54p_stop(struct ieee80211_hw *dev)
