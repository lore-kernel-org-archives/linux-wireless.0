Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:34294 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbYJOBwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 21:52:09 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/6] p54: refactor statistic timer code
Date: Wed, 15 Oct 2008 03:56:20 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810150356.20354.chunkeey@web.de> (sfid-20081015_035214_283208_CB1CC76D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-10-12 17:42:00.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-10-12 17:42:09.000000000 +0200
@@ -1159,19 +1159,32 @@ static int p54_set_vdcf(struct ieee80211
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
@@ -1182,7 +1195,7 @@ static int p54_start(struct ieee80211_hw
 	P54_SET_QUEUE(priv->qos_params[3], 0x0007, 0x000f, 0x03ff, 0);
 	err = p54_set_vdcf(dev);
 	if (!err)
-		mod_timer(&priv->stats_timer, jiffies + HZ);
+		err = p54_init_stats(dev);
 
 	return err;
 }
@@ -1193,6 +1206,8 @@ static void p54_stop(struct ieee80211_hw
 	struct sk_buff *skb;
 
 	del_timer(&priv->stats_timer);
+	kfree(priv->cached_stats);
+	priv->cached_stats = NULL;
 	while ((skb = skb_dequeue(&priv->tx_queue)))
 		kfree_skb(skb);
 	priv->stop(dev);
@@ -1354,11 +1369,7 @@ static void p54_statistics_timer(unsigne
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
