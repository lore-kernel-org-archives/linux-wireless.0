Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:38514 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbYJOCDH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 22:03:07 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 4/6] p54: fix memory management
Date: Wed, 15 Oct 2008 04:07:16 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810150407.17062.chunkeey@web.de> (sfid-20081015_040314_092094_BE197E36)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have to be careful if multiple "control frames" are passed in a very short intervals to
the device's firmware. As p54_assign_address always put them into same memory location.
To guarantee that this won't happen anymore, we have to treat control frames like normal
data frames in the devices own memory management.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-10-14 22:23:19.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-10-15 02:39:03.000000000 +0200
@@ -528,11 +528,55 @@ static void inline p54_wake_free_queues(
 	struct p54_common *priv = dev->priv;
 	int i;
 
+	if (priv->mode == NL80211_IFTYPE_UNSPECIFIED)
+		return ;
+
 	for (i = 0; i < dev->queues; i++)
 		if (priv->tx_stats[i + 4].len < priv->tx_stats[i + 4].limit)
 			ieee80211_wake_queue(dev, i);
 }
 
+void p54_free_skb(struct ieee80211_hw *dev, struct sk_buff *skb)
+{
+	struct p54_common *priv = dev->priv;
+	struct ieee80211_tx_info *info;
+	struct memrecord *range;
+	unsigned long flags;
+	u32 freed = 0, last_addr = priv->rx_start;
+
+	if (!skb || !dev)
+		return;
+
+	spin_lock_irqsave(&priv->tx_queue.lock, flags);
+	info = IEEE80211_SKB_CB(skb);
+	range = (void *)info->rate_driver_data;
+	if (skb->prev != (struct sk_buff *)&priv->tx_queue) {
+		struct ieee80211_tx_info *ni;
+		struct memrecord *mr;
+
+		ni = IEEE80211_SKB_CB(skb->prev);
+		mr = (struct memrecord *)ni->rate_driver_data;
+		last_addr = mr->end_addr;
+	}
+	if (skb->next != (struct sk_buff *)&priv->tx_queue) {
+		struct ieee80211_tx_info *ni;
+		struct memrecord *mr;
+
+		ni = IEEE80211_SKB_CB(skb->next);
+		mr = (struct memrecord *)ni->rate_driver_data;
+		freed = mr->start_addr - last_addr;
+	} else
+		freed = priv->rx_end - last_addr;
+	__skb_unlink(skb, &priv->tx_queue);
+	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
+	kfree_skb(skb);
+
+	if (freed >= priv->headroom + sizeof(struct p54_control_hdr) + 48 +
+		     IEEE80211_MAX_RTS_THRESHOLD + priv->tailroom)
+		p54_wake_free_queues(dev);
+}
+EXPORT_SYMBOL_GPL(p54_free_skb);
+
 static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54_common *priv = dev->priv;
@@ -705,12 +749,14 @@ EXPORT_SYMBOL_GPL(p54_rx);
  * marks allocated areas as reserved if necessary. p54_rx_frame_sent frees
  * allocated areas.
  */
-static void p54_assign_address(struct ieee80211_hw *dev, struct sk_buff *skb,
+static int p54_assign_address(struct ieee80211_hw *dev, struct sk_buff *skb,
 			       struct p54_control_hdr *data, u32 len)
 {
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *entry = priv->tx_queue.next;
 	struct sk_buff *target_skb = NULL;
+	struct ieee80211_tx_info *info;
+	struct memrecord *range;
 	u32 last_addr = priv->rx_start;
 	u32 largest_hole = 0;
 	u32 target_addr = priv->rx_start;
@@ -718,12 +764,15 @@ static void p54_assign_address(struct ie
 	unsigned int left;
 	len = (len + priv->headroom + priv->tailroom + 3) & ~0x3;
 
+	if (!skb)
+		return -EINVAL;
+
 	spin_lock_irqsave(&priv->tx_queue.lock, flags);
 	left = skb_queue_len(&priv->tx_queue);
 	while (left--) {
 		u32 hole_size;
-		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(entry);
-		struct memrecord *range = (void *)info->rate_driver_data;
+		info = IEEE80211_SKB_CB(entry);
+		range = (void *)info->rate_driver_data;
 		hole_size = range->start_addr - last_addr;
 		if (!target_skb && hole_size >= len) {
 			target_skb = entry->prev;
@@ -738,27 +787,57 @@ static void p54_assign_address(struct ie
 		target_skb = priv->tx_queue.prev;
 		largest_hole = max(largest_hole, priv->rx_end - last_addr - len);
 		if (!skb_queue_empty(&priv->tx_queue)) {
-			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(target_skb);
-			struct memrecord *range = (void *)info->rate_driver_data;
+			info = IEEE80211_SKB_CB(target_skb);
+			range = (void *)info->rate_driver_data;
 			target_addr = range->end_addr;
 		}
 	} else
 		largest_hole = max(largest_hole, priv->rx_end - last_addr);
 
-	if (skb) {
-		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-		struct memrecord *range = (void *)info->rate_driver_data;
-		range->start_addr = target_addr;
-		range->end_addr = target_addr + len;
-		__skb_queue_after(&priv->tx_queue, target_skb, skb);
-		if (largest_hole < priv->rx_mtu + priv->headroom +
-				   priv->tailroom +
-				   sizeof(struct p54_control_hdr))
-			ieee80211_stop_queues(dev);
+	if (!target_skb) {
+		spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
+		ieee80211_stop_queues(dev);
+		return -ENOMEM;
 	}
+
+	info = IEEE80211_SKB_CB(skb);
+	range = (void *)info->rate_driver_data;
+	range->start_addr = target_addr;
+	range->end_addr = target_addr + len;
+	__skb_queue_after(&priv->tx_queue, target_skb, skb);
 	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 
+	if (largest_hole < priv->headroom + sizeof(struct p54_control_hdr) +
+			   48 + IEEE80211_MAX_RTS_THRESHOLD + priv->tailroom)
+		ieee80211_stop_queues(dev);
+
 	data->req_id = cpu_to_le32(target_addr + priv->headroom);
+	return 0;
+}
+
+static struct sk_buff *p54_alloc_skb(struct ieee80211_hw *dev,
+		u16 hdr_flags, u16 len, u16 type, gfp_t memflags)
+{
+	struct p54_common *priv = dev->priv;
+	struct p54_control_hdr *hdr;
+	struct sk_buff *skb;
+
+	skb = __dev_alloc_skb(len + priv->tx_hdr_len, memflags);
+	if (!skb)
+		return NULL;
+	skb_reserve(skb, priv->tx_hdr_len);
+
+	hdr = (struct p54_control_hdr *) skb_put(skb, sizeof(*hdr));
+	hdr->magic1 = cpu_to_le16(hdr_flags);
+	hdr->len = cpu_to_le16(len - sizeof(*hdr));
+	hdr->type = cpu_to_le16(type);
+	hdr->retry1 = hdr->retry2 = 0;
+
+	if (unlikely(p54_assign_address(dev, skb, hdr, len))) {
+		kfree_skb(skb);
+		return NULL;
+	}
+	return skb;
 }
 
 int p54_read_eeprom(struct ieee80211_hw *dev)
@@ -766,36 +845,31 @@ int p54_read_eeprom(struct ieee80211_hw 
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr = NULL;
 	struct p54_eeprom_lm86 *eeprom_hdr;
+	struct sk_buff *skb;
 	size_t eeprom_size = 0x2020, offset = 0, blocksize;
 	int ret = -ENOMEM;
 	void *eeprom = NULL;
 
-	hdr = (struct p54_control_hdr *)kzalloc(sizeof(*hdr) +
-		sizeof(*eeprom_hdr) + EEPROM_READBACK_LEN, GFP_KERNEL);
-	if (!hdr)
+	skb = p54_alloc_skb(dev, 0x8000, sizeof(*hdr) + sizeof(*eeprom_hdr) +
+			    EEPROM_READBACK_LEN,
+			    P54_CONTROL_TYPE_EEPROM_READBACK, GFP_KERNEL);
+	if (!skb)
 		goto free;
-
 	priv->eeprom = kzalloc(EEPROM_READBACK_LEN, GFP_KERNEL);
 	if (!priv->eeprom)
 		goto free;
-
 	eeprom = kzalloc(eeprom_size, GFP_KERNEL);
 	if (!eeprom)
 		goto free;
 
-	hdr->magic1 = cpu_to_le16(0x8000);
-	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_EEPROM_READBACK);
-	hdr->retry1 = hdr->retry2 = 0;
-	eeprom_hdr = (struct p54_eeprom_lm86 *) hdr->data;
+	eeprom_hdr = (struct p54_eeprom_lm86 *) skb_put(skb,
+		     sizeof(*eeprom_hdr) + EEPROM_READBACK_LEN);
 
 	while (eeprom_size) {
 		blocksize = min(eeprom_size, (size_t)EEPROM_READBACK_LEN);
-		hdr->len = cpu_to_le16(blocksize + sizeof(*eeprom_hdr));
 		eeprom_hdr->offset = cpu_to_le16(offset);
 		eeprom_hdr->len = cpu_to_le16(blocksize);
-		p54_assign_address(dev, NULL, hdr, le16_to_cpu(hdr->len) +
-				   sizeof(*hdr));
-		priv->tx(dev, hdr, le16_to_cpu(hdr->len) + sizeof(*hdr), 0);
+		priv->tx(dev, skb, 0);
 
 		if (!wait_for_completion_interruptible_timeout(&priv->eeprom_comp, HZ)) {
 			printk(KERN_ERR "%s: device does not respond!\n",
@@ -813,7 +887,7 @@ int p54_read_eeprom(struct ieee80211_hw 
 free:
 	kfree(priv->eeprom);
 	priv->eeprom = NULL;
-	kfree(hdr);
+	p54_free_skb(dev, skb);
 	kfree(eeprom);
 
 	return ret;
@@ -936,9 +1010,11 @@ static int p54_tx(struct ieee80211_hw *d
 		txhdr->align[0] = padding;
 
 	/* modifies skb->cb and with it info, so must be last! */
-	p54_assign_address(dev, skb, hdr, skb->len);
-
-	priv->tx(dev, hdr, skb->len, 0);
+	if (unlikely(p54_assign_address(dev, skb, hdr, skb->len))) {
+		skb_pull(skb, sizeof(*hdr) + sizeof(*txhdr) + padding);
+		return NETDEV_TX_BUSY;
+	}
+	priv->tx(dev, skb, 0);
 	return 0;
 }
 
@@ -946,22 +1022,22 @@ static int p54_set_filter(struct ieee802
 			  const u8 *bssid)
 {
 	struct p54_common *priv = dev->priv;
-	struct p54_control_hdr *hdr;
+	struct sk_buff *skb;
 	struct p54_tx_control_filter *filter;
-	size_t data_len;
-
-	hdr = kzalloc(sizeof(*hdr) + sizeof(*filter) +
-		      priv->tx_hdr_len, GFP_ATOMIC);
-	if (!hdr)
-		return -ENOMEM;
+	u16 data_len = sizeof(struct p54_control_hdr) + sizeof(*filter);
 
-	hdr = (void *)hdr + priv->tx_hdr_len;
+	if (priv->fw_var < 0x500)
+		data_len += P54_TX_CONTROL_FILTER_V1_LEN;
+	else
+		data_len += P54_TX_CONTROL_FILTER_V2_LEN;
 
-	filter = (struct p54_tx_control_filter *) hdr->data;
-	hdr->magic1 = cpu_to_le16(0x8001);
-	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_FILTER_SET);
+	skb = p54_alloc_skb(dev, 0x8001, data_len, P54_CONTROL_TYPE_FILTER_SET,
+			    GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
 
-	priv->filter_type = filter->filter_type = cpu_to_le16(filter_type);
+	filter = (struct p54_tx_control_filter *) skb_put(skb, sizeof(*filter));
+	filter->filter_type = priv->filter_type = cpu_to_le16(filter_type);
 	memcpy(filter->mac_addr, priv->mac_addr, ETH_ALEN);
 	if (!bssid)
 		memset(filter->bssid, ~0, ETH_ALEN);
@@ -969,47 +1045,37 @@ static int p54_set_filter(struct ieee802
 		memcpy(filter->bssid, bssid, ETH_ALEN);
 	filter->rx_antenna = priv->rx_antenna;
 	if (priv->fw_var < 0x500) {
-		data_len = P54_TX_CONTROL_FILTER_V1_LEN;
 		filter->v1.basic_rate_mask = cpu_to_le32(0x15f);
 		filter->v1.rx_addr = cpu_to_le32(priv->rx_end);
 		filter->v1.max_rx = cpu_to_le16(priv->rx_mtu);
 		filter->v1.rxhw = cpu_to_le16(priv->rxhw);
 		filter->v1.wakeup_timer = cpu_to_le16(500);
 	} else {
-		data_len = P54_TX_CONTROL_FILTER_V2_LEN;
 		filter->v2.rx_addr = cpu_to_le32(priv->rx_end);
 		filter->v2.max_rx = cpu_to_le16(priv->rx_mtu);
 		filter->v2.rxhw = cpu_to_le16(priv->rxhw);
 		filter->v2.timer = cpu_to_le16(1000);
 	}
-	hdr->len = cpu_to_le16(data_len);
-	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + data_len);
-	priv->tx(dev, hdr, sizeof(*hdr) + data_len, 1);
+	priv->tx(dev, skb, 1);
 	return 0;
 }
 
 static int p54_set_freq(struct ieee80211_hw *dev, __le16 freq)
 {
 	struct p54_common *priv = dev->priv;
-	struct p54_control_hdr *hdr;
+	struct sk_buff *skb;
 	struct p54_tx_control_channel *chan;
 	unsigned int i;
-	size_t data_len;
+	size_t data_len = sizeof(struct p54_control_hdr) + sizeof(*chan);
 	void *entry;
 
-	hdr = kzalloc(sizeof(*hdr) + sizeof(*chan) +
-		      priv->tx_hdr_len, GFP_KERNEL);
-	if (!hdr)
+	skb = p54_alloc_skb(dev, 0x8001, data_len,
+			    P54_CONTROL_TYPE_CHANNEL_CHANGE, GFP_ATOMIC);
+	if (!skb)
 		return -ENOMEM;
 
-	hdr = (void *)hdr + priv->tx_hdr_len;
-
-	chan = (struct p54_tx_control_channel *) hdr->data;
-
-	hdr->magic1 = cpu_to_le16(0x8001);
-
-	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_CHANNEL_CHANGE);
-
+	chan = (struct p54_tx_control_channel *) skb_put(skb, sizeof(*chan));
+	memset(chan->padding1, 0, sizeof(chan->padding1));
 	chan->flags = cpu_to_le16(0x1);
 	chan->dwell = cpu_to_le16(0x0);
 
@@ -1065,48 +1131,37 @@ static int p54_set_freq(struct ieee80211
 		chan->v1.rssical_mul = cpu_to_le16(130);
 		chan->v1.rssical_add = cpu_to_le16(0xfe70);
 	} else {
-		data_len = P54_TX_CONTROL_CHANNEL_V2_LEN;
 		chan->v2.rssical_mul = cpu_to_le16(130);
 		chan->v2.rssical_add = cpu_to_le16(0xfe70);
 		chan->v2.basic_rate_mask = cpu_to_le32(0x15f);
 	}
-
-	hdr->len = cpu_to_le16(data_len);
-	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + data_len);
-	priv->tx(dev, hdr, sizeof(*hdr) + data_len, 1);
+	priv->tx(dev, skb, 1);
 	return 0;
 
  err:
 	printk(KERN_ERR "%s: frequency change failed\n", wiphy_name(dev->wiphy));
-	kfree(hdr);
+	kfree_skb(skb);
 	return -EINVAL;
 }
 
 static int p54_set_leds(struct ieee80211_hw *dev, int mode, int link, int act)
 {
 	struct p54_common *priv = dev->priv;
-	struct p54_control_hdr *hdr;
+	struct sk_buff *skb;
 	struct p54_tx_control_led *led;
 
-	hdr = kzalloc(sizeof(*hdr) + sizeof(*led) +
-		      priv->tx_hdr_len, GFP_KERNEL);
-	if (!hdr)
+	skb = p54_alloc_skb(dev, 0x8001, sizeof(*led) +
+			sizeof(struct p54_control_hdr),
+			P54_CONTROL_TYPE_LED, GFP_ATOMIC);
+	if (!skb)
 		return -ENOMEM;
 
-	hdr = (void *)hdr + priv->tx_hdr_len;
-	hdr->magic1 = cpu_to_le16(0x8001);
-	hdr->len = cpu_to_le16(sizeof(*led));
-	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_LED);
-	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*led));
-
-	led = (struct p54_tx_control_led *) hdr->data;
+	led = (struct p54_tx_control_led *)skb_put(skb, sizeof(*led));
 	led->mode = cpu_to_le16(mode);
 	led->led_permanent = cpu_to_le16(link);
 	led->led_temporary = cpu_to_le16(act);
 	led->duration = cpu_to_le16(1000);
-
-	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*led), 1);
-
+	priv->tx(dev, skb, 1);
 	return 0;
 }
 
@@ -1121,20 +1176,15 @@ do {	 							\
 static int p54_set_edcf(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
-	struct p54_control_hdr *hdr;
+	struct sk_buff *skb;
 	struct p54_edcf *edcf;
 
-	hdr = kzalloc(priv->tx_hdr_len + sizeof(*hdr) + sizeof(*edcf),
-			GFP_ATOMIC);
-	if (!hdr)
+	skb = p54_alloc_skb(dev, 0x8001, sizeof(struct p54_control_hdr) +
+			sizeof(*edcf), P54_CONTROL_TYPE_DCFINIT, GFP_ATOMIC);
+	if (!skb)
 		return -ENOMEM;
 
-	hdr = (void *)hdr + priv->tx_hdr_len;
-	hdr->magic1 = cpu_to_le16(0x8001);
-	hdr->len = cpu_to_le16(sizeof(*edcf));
-	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_DCFINIT);
-	hdr->retry1 = hdr->retry2 = 0;
-	edcf = (struct p54_edcf *)hdr->data;
+	edcf = (struct p54_edcf *)skb_put(skb, sizeof(*edcf));
 	if (priv->use_short_slot) {
 		edcf->slottime = 9;
 		edcf->sifs = 0x10;
@@ -1149,30 +1199,22 @@ static int p54_set_edcf(struct ieee80211
 	edcf->round_trip_delay = cpu_to_le16(0);
 	memset(edcf->mapping, 0, sizeof(edcf->mapping));
 	memcpy(edcf->queue, priv->qos_params, sizeof(edcf->queue));
-
-	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*edcf));
-	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*edcf), 1);
+	priv->tx(dev, skb, 1);
 	return 0;
 }
 
 static int p54_init_stats(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
-	struct p54_control_hdr *hdr;
-	struct p54_statistics *stats;
-
-	priv->cached_stats = kzalloc(priv->tx_hdr_len +
-			sizeof(*hdr) + sizeof(*stats), GFP_KERNEL);
 
+	priv->cached_stats = p54_alloc_skb(dev, 0x8000,
+			sizeof(struct p54_control_hdr) +
+			sizeof(struct p54_statistics),
+			P54_CONTROL_TYPE_STAT_READBACK,
+			GFP_KERNEL);
 	if (!priv->cached_stats)
 			return -ENOMEM;
 
-	hdr = (void *) priv->cached_stats + priv->tx_hdr_len;
-	hdr->magic1 = cpu_to_le16(0x8000);
-	hdr->len = cpu_to_le16(sizeof(*stats));
-	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_STAT_READBACK);
-	hdr->retry1 = hdr->retry2 = 0;
-
 	mod_timer(&priv->stats_timer, jiffies + HZ);
 	return 0;
 }
@@ -1202,10 +1244,11 @@ static void p54_stop(struct ieee80211_hw
 	struct sk_buff *skb;
 
 	del_timer(&priv->stats_timer);
-	kfree(priv->cached_stats);
+	p54_free_skb(dev, priv->cached_stats);
 	priv->cached_stats = NULL;
 	while ((skb = skb_dequeue(&priv->tx_queue)))
 		kfree_skb(skb);
+
 	priv->stop(dev);
 	priv->tsf_high32 = priv->tsf_low32 = 0;
 	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
@@ -1333,27 +1376,21 @@ static int p54_conf_tx(struct ieee80211_
 static int p54_init_xbow_synth(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
-	struct p54_control_hdr *hdr;
+	struct sk_buff *skb;
 	struct p54_tx_control_xbow_synth *xbow;
 
-	hdr = kzalloc(sizeof(*hdr) + sizeof(*xbow) +
-		      priv->tx_hdr_len, GFP_KERNEL);
-	if (!hdr)
+	skb = p54_alloc_skb(dev, 0x8001, sizeof(struct p54_control_hdr) +
+			    sizeof(*xbow), P54_CONTROL_TYPE_XBOW_SYNTH_CFG,
+			    GFP_KERNEL);
+	if (!skb)
 		return -ENOMEM;
 
-	hdr = (void *)hdr + priv->tx_hdr_len;
-	hdr->magic1 = cpu_to_le16(0x8001);
-	hdr->len = cpu_to_le16(sizeof(*xbow));
-	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_XBOW_SYNTH_CFG);
-	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*xbow));
-
-	xbow = (struct p54_tx_control_xbow_synth *) hdr->data;
+	xbow = (struct p54_tx_control_xbow_synth *)skb_put(skb, sizeof(*xbow));
 	xbow->magic1 = cpu_to_le16(0x1);
 	xbow->magic2 = cpu_to_le16(0x2);
 	xbow->freq = cpu_to_le16(5390);
-
-	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*xbow), 1);
-
+	memset(xbow->padding, 0, sizeof(xbow->padding));
+	priv->tx(dev, skb, 1);
 	return 0;
 }
 
@@ -1361,14 +1398,10 @@ static void p54_statistics_timer(unsigne
 {
 	struct ieee80211_hw *dev = (struct ieee80211_hw *) data;
 	struct p54_common *priv = dev->priv;
-	struct p54_control_hdr *hdr;
-	struct p54_statistics *stats;
 
 	BUG_ON(!priv->cached_stats);
-	hdr = (void *) priv->cached_stats + priv->tx_hdr_len;
-	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*stats));
 
-	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*stats), 0);
+	priv->tx(dev, priv->cached_stats, 0);
 }
 
 static int p54_get_stats(struct ieee80211_hw *dev,
@@ -1486,7 +1519,8 @@ EXPORT_SYMBOL_GPL(p54_init_common);
 void p54_free_common(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
-	kfree(priv->cached_stats);
+	del_timer(&priv->stats_timer);
+	kfree_skb(priv->cached_stats);
 	kfree(priv->iq_autocal);
 	kfree(priv->output_limit);
 	kfree(priv->curve_data);
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-10-14 22:23:19.000000000 +0200
+++ b/drivers/net/wireless/p54/p54.h	2008-10-14 22:24:00.000000000 +0200
@@ -69,8 +69,8 @@ struct p54_common {
 	u32 rx_start;
 	u32 rx_end;
 	struct sk_buff_head tx_queue;
-	void (*tx)(struct ieee80211_hw *dev, struct p54_control_hdr *data,
-		   size_t len, int free_on_tx);
+	void (*tx)(struct ieee80211_hw *dev, struct sk_buff *skb,
+		   int free_on_tx);
 	int (*open)(struct ieee80211_hw *dev);
 	void (*stop)(struct ieee80211_hw *dev);
 	int mode;
@@ -102,13 +102,14 @@ struct p54_common {
 	struct ieee80211_low_level_stats stats;
 	struct timer_list stats_timer;
 	struct completion stats_comp;
-	void *cached_stats;
+	struct sk_buff *cached_stats;
 	int noise;
 	void *eeprom;
 	struct completion eeprom_comp;
 };
 
 int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb);
+void p54_free_skb(struct ieee80211_hw *dev, struct sk_buff *skb);
 int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw);
 int p54_read_eeprom(struct ieee80211_hw *dev);
 struct ieee80211_hw *p54_init_common(size_t priv_data_len);
diff -Nurp a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
--- a/drivers/net/wireless/p54/p54pci.c	2008-10-12 17:44:02.000000000 +0200
+++ b/drivers/net/wireless/p54/p54pci.c	2008-10-14 20:00:33.000000000 +0200
@@ -235,7 +235,7 @@ static void p54p_check_tx_ring(struct ie
 
 	while (i != idx) {
 		desc = &ring[i];
-		kfree(tx_buf[i]);
+		p54_free_skb(dev, tx_buf[i]);
 		tx_buf[i] = NULL;
 
 		pci_unmap_single(priv->pdev, le32_to_cpu(desc->host_addr),
@@ -306,8 +306,8 @@ static irqreturn_t p54p_interrupt(int ir
 	return reg ? IRQ_HANDLED : IRQ_NONE;
 }
 
-static void p54p_tx(struct ieee80211_hw *dev, struct p54_control_hdr *data,
-		    size_t len, int free_on_tx)
+static void p54p_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
+		    int free_on_tx)
 {
 	struct p54p_priv *priv = dev->priv;
 	struct p54p_ring_control *ring_control = priv->ring_control;
@@ -322,18 +322,19 @@ static void p54p_tx(struct ieee80211_hw 
 	idx = le32_to_cpu(ring_control->host_idx[1]);
 	i = idx % ARRAY_SIZE(ring_control->tx_data);
 
-	mapping = pci_map_single(priv->pdev, data, len, PCI_DMA_TODEVICE);
+	mapping = pci_map_single(priv->pdev, skb->data, skb->len,
+				 PCI_DMA_TODEVICE);
 	desc = &ring_control->tx_data[i];
 	desc->host_addr = cpu_to_le32(mapping);
-	desc->device_addr = data->req_id;
-	desc->len = cpu_to_le16(len);
+	desc->device_addr = ((struct p54_control_hdr *)skb->data)->req_id;
+	desc->len = cpu_to_le16(skb->len);
 	desc->flags = 0;
 
 	wmb();
 	ring_control->host_idx[1] = cpu_to_le32(idx + 1);
 
 	if (free_on_tx)
-		priv->tx_buf_data[i] = data;
+		priv->tx_buf_data[i] = skb;
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -342,8 +343,10 @@ static void p54p_tx(struct ieee80211_hw 
 
 	/* FIXME: unlikely to happen because the device usually runs out of
 	   memory before we fill the ring up, but we can make it impossible */
-	if (idx - device_idx > ARRAY_SIZE(ring_control->tx_data) - 2)
+	if (idx - device_idx > ARRAY_SIZE(ring_control->tx_data) - 2) {
+		p54_free_skb(dev, skb);
 		printk(KERN_INFO "%s: tx overflow.\n", wiphy_name(dev->wiphy));
+	}
 }
 
 static int p54p_open(struct ieee80211_hw *dev)
@@ -455,7 +458,7 @@ static void p54p_stop(struct ieee80211_h
 					 le16_to_cpu(desc->len),
 					 PCI_DMA_TODEVICE);
 
-		kfree(priv->tx_buf_data[i]);
+		p54_free_skb(dev, priv->tx_buf_data[i]);
 		priv->tx_buf_data[i] = NULL;
 	}
 
@@ -467,7 +470,7 @@ static void p54p_stop(struct ieee80211_h
 					 le16_to_cpu(desc->len),
 					 PCI_DMA_TODEVICE);
 
-		kfree(priv->tx_buf_mgmt[i]);
+		p54_free_skb(dev, priv->tx_buf_mgmt[i]);
 		priv->tx_buf_mgmt[i] = NULL;
 	}
 
diff -Nurp a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c	2008-10-13 23:48:36.000000000 +0200
+++ b/drivers/net/wireless/p54/p54usb.c	2008-10-14 20:58:15.000000000 +0200
@@ -135,6 +135,16 @@ static void p54u_rx_cb(struct urb *urb)
 	usb_submit_urb(urb, GFP_ATOMIC);
 }
 
+static void p54u_tx_reuse_skb_cb(struct urb *urb)
+{
+	struct sk_buff *skb = urb->context;
+	struct p54u_priv *priv = (struct p54u_priv *)((struct ieee80211_hw *)
+		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0)))->priv;
+
+	skb_pull(skb, priv->common.tx_hdr_len);
+	usb_free_urb(urb);
+}
+
 static void p54u_tx_cb(struct urb *urb)
 {
 	usb_free_urb(urb);
@@ -146,6 +156,16 @@ static void p54u_tx_free_cb(struct urb *
 	usb_free_urb(urb);
 }
 
+static void p54u_tx_free_skb_cb(struct urb *urb)
+{
+	struct sk_buff *skb = urb->context;
+	struct ieee80211_hw *dev = (struct ieee80211_hw *)
+		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
+
+	p54_free_skb(dev, skb);
+	usb_free_urb(urb);
+}
+
 static int p54u_init_urbs(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
@@ -192,8 +212,8 @@ static void p54u_free_urbs(struct ieee80
 	}
 }
 
-static void p54u_tx_3887(struct ieee80211_hw *dev, struct p54_control_hdr *data,
-			 size_t len, int free_on_tx)
+static void p54u_tx_3887(struct ieee80211_hw *dev, struct sk_buff *skb,
+			 int free_on_tx)
 {
 	struct p54u_priv *priv = dev->priv;
 	struct urb *addr_urb, *data_urb;
@@ -209,11 +229,14 @@ static void p54u_tx_3887(struct ieee8021
 	}
 
 	usb_fill_bulk_urb(addr_urb, priv->udev,
-		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), &data->req_id,
-		sizeof(data->req_id), p54u_tx_cb, dev);
+			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
+			  &((struct p54_control_hdr *)skb->data)->req_id, 4,
+			  p54u_tx_cb, dev);
 	usb_fill_bulk_urb(data_urb, priv->udev,
-		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), data, len,
-		free_on_tx ? p54u_tx_free_cb : p54u_tx_cb, dev);
+			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
+			  skb->data, skb->len,
+			  free_on_tx ? p54u_tx_free_skb_cb :
+				       p54u_tx_reuse_skb_cb, skb);
 
 	usb_submit_urb(addr_urb, GFP_ATOMIC);
 	usb_submit_urb(data_urb, GFP_ATOMIC);
@@ -232,31 +255,35 @@ static __le32 p54u_lm87_chksum(const u32
 	return cpu_to_le32(chk);
 }
 
-static void p54u_tx_lm87(struct ieee80211_hw *dev,
-			 struct p54_control_hdr *data,
-			 size_t len, int free_on_tx)
+static void p54u_tx_lm87(struct ieee80211_hw *dev, struct sk_buff *skb,
+			 int free_on_tx)
 {
 	struct p54u_priv *priv = dev->priv;
 	struct urb *data_urb;
-	struct lm87_tx_hdr *hdr = (void *)data - sizeof(*hdr);
+	struct lm87_tx_hdr *hdr;
+	__le32 checksum;
+	__le32 addr = ((struct p54_control_hdr *)skb->data)->req_id;
 
 	data_urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!data_urb)
 		return;
 
-	hdr->chksum = p54u_lm87_chksum((u32 *)data, len);
-	hdr->device_addr = data->req_id;
+	checksum = p54u_lm87_chksum((u32 *)skb->data, skb->len);
+	hdr = (struct lm87_tx_hdr *)skb_push(skb, sizeof(*hdr));
+	hdr->chksum = checksum;
+	hdr->device_addr = addr;
 
 	usb_fill_bulk_urb(data_urb, priv->udev,
-		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), hdr,
-		len + sizeof(*hdr), free_on_tx ? p54u_tx_free_cb : p54u_tx_cb,
-		dev);
+			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
+			  skb->data, skb->len,
+			  free_on_tx ? p54u_tx_free_skb_cb :
+				       p54u_tx_reuse_skb_cb, skb);
 
 	usb_submit_urb(data_urb, GFP_ATOMIC);
 }
 
-static void p54u_tx_net2280(struct ieee80211_hw *dev, struct p54_control_hdr *data,
-			    size_t len, int free_on_tx)
+static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb,
+			    int free_on_tx)
 {
 	struct p54u_priv *priv = dev->priv;
 	struct urb *int_urb, *data_urb;
@@ -284,11 +311,10 @@ static void p54u_tx_net2280(struct ieee8
 	reg->addr = cpu_to_le32(P54U_DEV_BASE);
 	reg->val = cpu_to_le32(ISL38XX_DEV_INT_DATA);
 
-	len += sizeof(*data);
-	hdr = (void *)data - sizeof(*hdr);
+	hdr = (void *)skb_push(skb, sizeof(*hdr));
 	memset(hdr, 0, sizeof(*hdr));
-	hdr->device_addr = data->req_id;
-	hdr->len = cpu_to_le16(len);
+	hdr->device_addr = ((struct p54_control_hdr *)skb->data)->req_id;
+	hdr->len = cpu_to_le16(skb->len + sizeof(struct p54_control_hdr));
 
 	usb_fill_bulk_urb(int_urb, priv->udev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DEV), reg, sizeof(*reg),
@@ -296,8 +322,10 @@ static void p54u_tx_net2280(struct ieee8
 	usb_submit_urb(int_urb, GFP_ATOMIC);
 
 	usb_fill_bulk_urb(data_urb, priv->udev,
-		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), hdr, len + sizeof(*hdr),
-		free_on_tx ? p54u_tx_free_cb : p54u_tx_cb, dev);
+			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
+			  skb->data, skb->len,
+			  free_on_tx ? p54u_tx_free_skb_cb :
+				       p54u_tx_reuse_skb_cb, skb);
 	usb_submit_urb(data_urb, GFP_ATOMIC);
 }
 
