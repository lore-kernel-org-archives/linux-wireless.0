Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:44854 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbYJEAgj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 20:36:39 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC][PATCH 2/5] p54: refactor statistic timer code
Date: Sun, 5 Oct 2008 02:38:40 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Kalle Valo <kalle.valo@nokia.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810050238.41014.chunkeey@web.de> (sfid-20081005_023642_124683_4D1C7C01)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-10-05 01:46:00.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-10-05 01:46:18.000000000 +0200
@@ -1103,19 +1103,32 @@ static int p54_set_vdcf(struct ieee80211
 	return 0;
 }
 
-static int p54_start(struct ieee80211_hw *dev)
+static int p54_init_stats(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
-	int err;
+	struct p54_control_hdr *hdr;
+	struct p54_statistics *stats;
 
-	if (!priv->cached_stats) {
-		priv->cached_stats = kzalloc(sizeof(struct p54_statistics) +
-			priv->tx_hdr_len + sizeof(struct p54_control_hdr),
-			GFP_KERNEL);
+	priv->cached_stats = kzalloc(priv->tx_hdr_len +
+			sizeof(*hdr) + sizeof(*stats), GFP_KERNEL);
 
-		if (!priv->cached_stats)
+	if (!priv->cached_stats)
 			return -ENOMEM;
-	}
+
+	hdr = (void *) priv->cached_stats + priv->tx_hdr_len;
+	hdr->magic1 = cpu_to_le16(0x8000);
+	hdr->len = cpu_to_le16(sizeof(*stats));
+	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_STAT_READBACK);
+	hdr->retry1 = hdr->retry2 = 0;
+
+	mod_timer(&priv->stats_timer, jiffies + HZ);
+	return 0;
+}
+
+static int p54_start(struct ieee80211_hw *dev)
+{
+	struct p54_common *priv = dev->priv;
+	int err;
 
 	err = priv->open(dev);
 	if (!err)
@@ -1127,7 +1140,7 @@ static int p54_start(struct ieee80211_hw
 	P54_SET_QUEUE(priv->qos_params[3], 0x0007, 0x000f, 0x03ff, 0);
 	err = p54_set_vdcf(dev);
 	if (!err)
-		mod_timer(&priv->stats_timer, jiffies + HZ);
+		err = p54_init_stats(dev);
 
 	return err;
 }
@@ -1138,6 +1151,8 @@ static void p54_stop(struct ieee80211_hw
 	struct sk_buff *skb;
 
 	del_timer(&priv->stats_timer);
+	kfree(priv->cached_stats);
+	priv->cached_stats = NULL;
 	while ((skb = skb_dequeue(&priv->tx_queue)))
 		kfree_skb(skb);
 	priv->stop(dev);
@@ -1299,11 +1314,7 @@ static void p54_statistics_timer(unsigne
 	struct p54_statistics *stats;
 
 	BUG_ON(!priv->cached_stats);
-
-	hdr = (void *)priv->cached_stats + priv->tx_hdr_len;
-	hdr->magic1 = cpu_to_le16(0x8000);
-	hdr->len = cpu_to_le16(sizeof(*stats));
-	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_STAT_READBACK);
+	hdr = (void *) priv->cached_stats + priv->tx_hdr_len;
 	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*stats));
 
 	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*stats), 0);

