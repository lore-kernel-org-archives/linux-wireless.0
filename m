Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:59029 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbYLMNOX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Dec 2008 08:14:23 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: move statistic timer update routine into a workqueue
Date: Sat, 13 Dec 2008 14:14:20 +0100
Cc: John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812131414.20822.chunkeey@web.de> (sfid-20081213_141438_993346_8FEE3EE3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves a good chunk of code from the former statistic update
timer routine into a workqueue, which is kindly provided by mac80211.

Also as a nice side-effect we can lay the foundation for other
essential housekeeping features we want to do in the future.
e.g:
 - drain the (clogged) tx_queue.
 - initiate bursts.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-12-12 23:26:28.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-12-13 13:36:02.000000000 +0100
@@ -590,6 +590,9 @@ static int p54_rx_data(struct ieee80211_
 
 	ieee80211_rx_irqsafe(dev, skb, &rx_status);
 
+	queue_delayed_work(dev->workqueue, &priv->work,
+			   msecs_to_jiffies(P54_STATISTICS_UPDATE));
+
 	return -1;
 }
 
@@ -653,6 +656,27 @@ void p54_free_skb(struct ieee80211_hw *d
 }
 EXPORT_SYMBOL_GPL(p54_free_skb);
 
+static struct sk_buff *p54_find_tx_entry(struct ieee80211_hw *dev,
+					   __le32 req_id)
+{
+	struct p54_common *priv = dev->priv;
+	struct sk_buff *entry = priv->tx_queue.next;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->tx_queue.lock, flags);
+	while (entry != (struct sk_buff *)&priv->tx_queue) {
+		struct p54_hdr *hdr = (struct p54_hdr *) entry->data;
+
+		if (hdr->req_id == req_id) {
+			spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
+			return entry;
+		}
+		entry = entry->next;
+	}
+	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
+	return NULL;
+}
+
 static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54_common *priv = dev->priv;
@@ -776,8 +800,12 @@ static void p54_rx_stats(struct ieee8021
 	struct p54_common *priv = dev->priv;
 	struct p54_hdr *hdr = (struct p54_hdr *) skb->data;
 	struct p54_statistics *stats = (struct p54_statistics *) hdr->data;
-	u32 tsf32 = le32_to_cpu(stats->tsf32);
+	u32 tsf32;
 
+	if (unlikely(priv->mode == NL80211_IFTYPE_UNSPECIFIED))
+		return ;
+
+	tsf32 = le32_to_cpu(stats->tsf32);
 	if (tsf32 < priv->tsf_low32)
 		priv->tsf_high32++;
 	priv->tsf_low32 = tsf32;
@@ -787,9 +815,8 @@ static void p54_rx_stats(struct ieee8021
 	priv->stats.dot11FCSErrorCount = le32_to_cpu(stats->rx_bad_fcs);
 
 	priv->noise = p54_rssi_to_dbm(dev, le32_to_cpu(stats->noise));
-	complete(&priv->stats_comp);
 
-	mod_timer(&priv->stats_timer, jiffies + 5 * HZ);
+	p54_free_skb(dev, p54_find_tx_entry(dev, hdr->req_id));
 }
 
 static void p54_rx_trap(struct ieee80211_hw *dev, struct sk_buff *skb)
@@ -898,6 +925,8 @@ static int p54_assign_address(struct iee
 		 * have a few spare slots for control frames left.
 		 */
 		ieee80211_stop_queues(dev);
+		queue_delayed_work(dev->workqueue, &priv->work,
+				   msecs_to_jiffies(P54_TX_TIMEOUT));
 
 		if (unlikely(left == 32)) {
 			/*
@@ -1355,6 +1384,10 @@ static int p54_tx(struct ieee80211_hw *d
 	if (unlikely(p54_assign_address(dev, skb, hdr, skb->len + tim_len)))
 		goto err;
 	priv->tx(dev, skb, 0);
+
+	queue_delayed_work(dev->workqueue, &priv->work,
+			   msecs_to_jiffies(P54_TX_FRAME_LIFETIME));
+
 	return 0;
 
  err:
@@ -1580,20 +1613,6 @@ static int p54_set_edcf(struct ieee80211
 	return 0;
 }
 
-static int p54_init_stats(struct ieee80211_hw *dev)
-{
-	struct p54_common *priv = dev->priv;
-
-	priv->cached_stats = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL,
-			sizeof(struct p54_hdr) + sizeof(struct p54_statistics),
-			P54_CONTROL_TYPE_STAT_READBACK, GFP_KERNEL);
-	if (!priv->cached_stats)
-			return -ENOMEM;
-
-	mod_timer(&priv->stats_timer, jiffies + HZ);
-	return 0;
-}
-
 static int p54_beacon_tim(struct sk_buff *skb)
 {
 	/*
@@ -1687,9 +1706,6 @@ static int p54_start(struct ieee80211_hw
 	err = p54_set_edcf(dev);
 	if (err)
 		goto out;
-	err = p54_init_stats(dev);
-	if (err)
-		goto out;
 
 	memset(priv->bssid, ~0, ETH_ALEN);
 	priv->mode = NL80211_IFTYPE_MONITOR;
@@ -1699,6 +1715,8 @@ static int p54_start(struct ieee80211_hw
 		goto out;
 	}
 
+	queue_delayed_work(dev->workqueue, &priv->work, 0);
+
 out:
 	mutex_unlock(&priv->conf_mutex);
 	return err;
@@ -1711,9 +1729,7 @@ static void p54_stop(struct ieee80211_hw
 
 	mutex_lock(&priv->conf_mutex);
 	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
-	del_timer(&priv->stats_timer);
-	p54_free_skb(dev, priv->cached_stats);
-	priv->cached_stats = NULL;
+	cancel_delayed_work_sync(&priv->work);
 	if (priv->cached_beacon)
 		p54_tx_cancel(dev, priv->cached_beacon);
 
@@ -1890,14 +1906,29 @@ static int p54_init_xbow_synth(struct ie
 	return 0;
 }
 
-static void p54_statistics_timer(unsigned long data)
+static void p54_work(struct work_struct *work)
 {
-	struct ieee80211_hw *dev = (struct ieee80211_hw *) data;
-	struct p54_common *priv = dev->priv;
+	struct p54_common *priv = container_of(work, struct p54_common,
+					       work.work);
+	struct ieee80211_hw *dev = priv->hw;
+	struct sk_buff *skb;
+
+	if (unlikely(priv->mode == NL80211_IFTYPE_UNSPECIFIED))
+		return ;
+
+	/*
+	 * TODO: walk through tx_queue and do the following tasks
+	 * 	1. initiate bursts.
+	 *      2. cancel stuck frames / reset the device if necessary.
+	 */
 
-	BUG_ON(!priv->cached_stats);
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL, sizeof(struct p54_hdr) +
+			    sizeof(struct p54_statistics),
+			    P54_CONTROL_TYPE_STAT_READBACK, GFP_KERNEL);
+	if (!skb)
+		return ;
 
-	priv->tx(dev, priv->cached_stats, 0);
+	priv->tx(dev, skb, 0);
 }
 
 static int p54_get_stats(struct ieee80211_hw *dev,
@@ -1905,17 +1936,7 @@ static int p54_get_stats(struct ieee8021
 {
 	struct p54_common *priv = dev->priv;
 
-	del_timer(&priv->stats_timer);
-	p54_statistics_timer((unsigned long)dev);
-
-	if (!wait_for_completion_interruptible_timeout(&priv->stats_comp, HZ)) {
-		printk(KERN_ERR "%s: device does not respond!\n",
-			wiphy_name(dev->wiphy));
-		return -EBUSY;
-	}
-
 	memcpy(stats, &priv->stats, sizeof(*stats));
-
 	return 0;
 }
 
@@ -2073,6 +2094,7 @@ struct ieee80211_hw *p54_init_common(siz
 		return NULL;
 
 	priv = dev->priv;
+	priv->hw = dev;
 	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
 	priv->basic_rate_mask = 0x15f;
 	skb_queue_head_init(&priv->tx_queue);
@@ -2108,9 +2130,7 @@ struct ieee80211_hw *p54_init_common(siz
 
 	mutex_init(&priv->conf_mutex);
 	init_completion(&priv->eeprom_comp);
-	init_completion(&priv->stats_comp);
-	setup_timer(&priv->stats_timer, p54_statistics_timer,
-		(unsigned long)dev);
+	INIT_DELAYED_WORK(&priv->work, p54_work);
 
 	return dev;
 }
@@ -2119,8 +2139,6 @@ EXPORT_SYMBOL_GPL(p54_init_common);
 void p54_free_common(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
-	del_timer(&priv->stats_timer);
-	kfree_skb(priv->cached_stats);
 	kfree(priv->iq_autocal);
 	kfree(priv->output_limit);
 	kfree(priv->curve_data);
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-12-12 23:26:30.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.h	2008-12-13 13:01:51.000000000 +0100
@@ -355,6 +355,11 @@ struct p54_tx_data {
 	u8 align[0];
 } __attribute__ ((packed));
 
+/* unit is ms */
+#define P54_TX_FRAME_LIFETIME 2000
+#define P54_TX_TIMEOUT 4000
+#define P54_STATISTICS_UPDATE 5000
+
 #define P54_FILTER_TYPE_NONE		0
 #define P54_FILTER_TYPE_STATION		BIT(0)
 #define P54_FILTER_TYPE_IBSS		BIT(1)
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-12-12 23:26:30.000000000 +0100
+++ b/drivers/net/wireless/p54/p54.h	2008-12-13 00:47:20.000000000 +0100
@@ -71,6 +71,7 @@ struct p54_edcf_queue_param {
 #define FW_LM20 0x4c4d3230
 
 struct p54_common {
+	struct ieee80211_hw *hw;
 	u32 rx_start;
 	u32 rx_end;
 	struct sk_buff_head tx_queue;
@@ -106,9 +107,7 @@ struct p54_common {
 	struct ieee80211_tx_queue_stats tx_stats[8];
 	struct p54_edcf_queue_param qos_params[8];
 	struct ieee80211_low_level_stats stats;
-	struct timer_list stats_timer;
-	struct completion stats_comp;
-	struct sk_buff *cached_stats;
+	struct delayed_work work;
 	struct sk_buff *cached_beacon;
 	int noise;
 	void *eeprom;
