Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:58163 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbZCEUde (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 15:33:34 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 6/7] p54: refractor beacon_update and stop path
Date: Thu, 5 Mar 2009 21:33:32 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903052133.32337.chunkeey@web.de> (sfid-20090305_213336_920648_DED02D6B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the LMAC API Section 3.2.2, we don't have to cancel the previous
beacon manually. The firmware will automatically return it to the driver
through the feedback mechanism. 
And while we're at it, we can remove some left over code as well.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2009-03-05 15:42:57.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2009-03-05 15:50:10.000000000 +0100
@@ -2015,18 +2015,14 @@ static int p54_beacon_update(struct ieee
 	struct sk_buff *beacon;
 	int ret;
 
-	if (priv->cached_beacon) {
-		p54_tx_cancel(dev, priv->cached_beacon);
-		/* wait for the last beacon the be freed */
-		msleep(10);
-	}
-
 	beacon = ieee80211_beacon_get(dev, vif);
 	if (!beacon)
 		return -ENOMEM;
 	ret = p54_beacon_tim(beacon);
 	if (ret)
 		return ret;
+
+	/* the firmware will automatically cancel old beacons. */ 
 	ret = p54_tx(dev, beacon);
 	if (ret)
 		return ret;
@@ -2072,17 +2068,21 @@ out:
 static void p54_stop(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
-	struct sk_buff *skb;
 
 	mutex_lock(&priv->conf_mutex);
 	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
+	p54_setup_mac(dev);
 	cancel_delayed_work_sync(&priv->work);
-	if (priv->cached_beacon)
-		p54_tx_cancel(dev, priv->cached_beacon);
+
+	/*
+	 * p54spi uses mac80211's workqueue to write the frames into
+	 * device's memory. Therefore, we should give the queue a chance
+	 * to complete all outstanding work, before the device is stopped.
+	 */
+	msleep(25);
 
 	priv->stop(dev);
-	while ((skb = skb_dequeue(&priv->tx_queue)))
-		kfree_skb(skb);
+	skb_queue_purge(&priv->tx_queue);
 	priv->cached_beacon = NULL;
 	priv->tsf_high32 = priv->tsf_low32 = 0;
 	mutex_unlock(&priv->conf_mutex);
