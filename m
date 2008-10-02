Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:51263 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbYJBBzw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 21:55:52 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC][PATCH] p54: fix memory management
Date: Thu, 2 Oct 2008 03:59:40 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kalle.valo@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810020359.40610.chunkeey@web.de> (sfid-20081002_035559_034502_2FB1D3BF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well, since a lot of people have worked with the memory management of p54 driver
(or similar projects ;-) ), it's probably the best to give this _urgent_ thing a RFC round.

The problem is that if multiple "control frames" are passed in a very short intervals to
the device's firmware (e.g: QoS and frequency are the best candidates)
the data might get corrupted. As p54_assign_address always put them into same 
memory location and the device's firmware is too slow to pick the frames up,
before they're overwritten again.

P.S: the code inside the #if 0 - #endif will go away in the final version,
but for now its very useful for debugging. So don't complain about it ;-).

Regards,
	Chr
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-09-29 20:41:44.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-10-02 03:17:37.000000000 +0200
@@ -537,11 +537,106 @@ static void inline p54_wake_free_queues(
 	struct p54_common *priv = dev->priv;
 	int i;
 
+	if (priv->mode == NL80211_IFTYPE_UNSPECIFIED)
+		return ;
+
 	for (i = 0; i < dev->queues; i++)
 		if (priv->tx_stats[i + 4].len < priv->tx_stats[i + 4].limit)
 			ieee80211_wake_queue(dev, i);
 }
 
+#if 0
+static void p54_dump_txqueue(struct ieee80211_hw *dev)
+{
+	struct p54_common *priv = dev->priv;
+	struct sk_buff *skb = priv->tx_queue.next;
+	struct ieee80211_tx_info *info;
+	struct memrecord *range;
+	unsigned long flags;
+	u32 last_addr = priv->rx_start, free = 0, total_free = 0;
+	u32 queue_len, biggest_free_hole = 0;
+
+	spin_lock_irqsave(&priv->tx_queue.lock, flags);
+
+	queue_len = skb_queue_len(&priv->tx_queue);
+
+	printk(KERN_DEBUG "%s: Tx queue entries: %d\n",
+	       wiphy_name(dev->wiphy), queue_len);
+
+	while (queue_len--) {
+		info = IEEE80211_SKB_CB(skb);
+		range = (void *)info->driver_data;
+		free = range->start_addr - last_addr;
+		if (free > biggest_free_hole)
+			biggest_free_hole = free;
+		total_free += free;
+		printk(KERN_DEBUG "\tentry: %p (range: [%x-%x]=(%x) free:%x)\n",
+			skb, range->start_addr, range->end_addr,
+			range->end_addr - range->start_addr, free);
+		last_addr = range->end_addr;
+		skb = skb->next;
+	}
+	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
+
+	free = priv->rx_end - last_addr;
+	if (free > biggest_free_hole)
+		biggest_free_hole = free;
+
+	total_free += free;
+	printk(KERN_DEBUG "\tlast entry: (range: [%x-%x] free: %d)\n",
+			last_addr, priv->rx_end, free);
+	printk(KERN_DEBUG "\ttotal_free:%d bytes, biggest free hole:%d bytes\n",
+		total_free, biggest_free_hole);
+}
+#endif
+
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
+
+	info = IEEE80211_SKB_CB(skb);
+	range = (void *)info->driver_data;
+
+	if (skb->prev != (struct sk_buff *)&priv->tx_queue) {
+		struct ieee80211_tx_info *ni;
+		struct memrecord *mr;
+
+		ni = IEEE80211_SKB_CB(skb->prev);
+		mr = (struct memrecord *)ni->driver_data;
+		last_addr = mr->end_addr;
+	}
+
+	if (skb->next != (struct sk_buff *)&priv->tx_queue) {
+		struct ieee80211_tx_info *ni;
+		struct memrecord *mr;
+
+		ni = IEEE80211_SKB_CB(skb->next);
+		mr = (struct memrecord *)ni->driver_data;
+		freed = mr->start_addr - last_addr;
+	} else
+		freed = priv->rx_end - last_addr;
+
+	__skb_unlink(skb, &priv->tx_queue);
+
+	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
+
+	kfree_skb(skb);
+
+	if (freed >= IEEE80211_MAX_RTS_THRESHOLD + 0x170 +
+	    sizeof(struct p54_control_hdr))
+		p54_wake_free_queues(dev);
+}
+EXPORT_SYMBOL(p54_free_skb);
+
 static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54_common *priv = dev->priv;
@@ -703,6 +798,8 @@ static void p54_assign_address(struct ie
 	unsigned int left;
 	len = (len + priv->headroom + priv->tailroom + 3) & ~0x3;
 
+	WARN_ON(!skb);
+
 	spin_lock_irqsave(&priv->tx_queue.lock, flags);
 	left = skb_queue_len(&priv->tx_queue);
 	while (left--) {
@@ -735,6 +832,7 @@ static void p54_assign_address(struct ie
 		struct memrecord *range = (void *)info->driver_data;
 		range->start_addr = target_addr;
 		range->end_addr = target_addr + len;
+		range->dev = dev;
 		__skb_queue_after(&priv->tx_queue, target_skb, skb);
 		if (largest_hole < priv->rx_mtu + priv->headroom +
 				   priv->tailroom +
@@ -751,15 +849,18 @@ int p54_read_eeprom(struct ieee80211_hw 
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
-		goto free;
+	skb = dev_alloc_skb(sizeof(*hdr) + sizeof(*eeprom_hdr) +
+			    EEPROM_READBACK_LEN + priv->tx_hdr_len);
 
+	if (!skb)
+		goto free;
+	skb_reserve(skb, priv->tx_hdr_len);
+	hdr = (struct p54_control_hdr *) skb_put(skb, sizeof(*hdr));
 	priv->eeprom = kzalloc(EEPROM_READBACK_LEN, GFP_KERNEL);
 	if (!priv->eeprom)
 		goto free;
@@ -771,16 +872,18 @@ int p54_read_eeprom(struct ieee80211_hw 
 	hdr->magic1 = cpu_to_le16(0x8000);
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_EEPROM_READBACK);
 	hdr->retry1 = hdr->retry2 = 0;
-	eeprom_hdr = (struct p54_eeprom_lm86 *) hdr->data;
+	eeprom_hdr = (struct p54_eeprom_lm86 *) skb_put(skb,
+		     sizeof(*eeprom_hdr) + EEPROM_READBACK_LEN);
+
+	p54_assign_address(dev, skb, hdr, skb->len);
 
 	while (eeprom_size) {
 		blocksize = min(eeprom_size, (size_t)EEPROM_READBACK_LEN);
 		hdr->len = cpu_to_le16(blocksize + sizeof(*eeprom_hdr));
 		eeprom_hdr->offset = cpu_to_le16(offset);
 		eeprom_hdr->len = cpu_to_le16(blocksize);
-		p54_assign_address(dev, NULL, hdr, le16_to_cpu(hdr->len) +
-				   sizeof(*hdr));
-		priv->tx(dev, hdr, le16_to_cpu(hdr->len) + sizeof(*hdr), 0);
+		priv->tx(dev, hdr, skb, le16_to_cpu(hdr->len) +
+					sizeof(*hdr), 0);
 
 		if (!wait_for_completion_interruptible_timeout(&priv->eeprom_comp, HZ)) {
 			printk(KERN_ERR "%s: device does not respond!\n",
@@ -798,7 +901,7 @@ int p54_read_eeprom(struct ieee80211_hw 
 free:
 	kfree(priv->eeprom);
 	priv->eeprom = NULL;
-	kfree(hdr);
+	p54_free_skb(dev, skb);
 	kfree(eeprom);
 
 	return ret;
@@ -881,7 +984,7 @@ static int p54_tx(struct ieee80211_hw *d
 	/* modifies skb->cb and with it info, so must be last! */
 	p54_assign_address(dev, skb, hdr, skb->len);
 
-	priv->tx(dev, hdr, skb->len, 0);
+	priv->tx(dev, hdr, skb, skb->len, 0);
 	return 0;
 }
 
@@ -890,21 +993,23 @@ static int p54_set_filter(struct ieee802
 {
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr;
+	struct sk_buff *skb;
 	struct p54_tx_control_filter *filter;
 	size_t data_len;
 
-	hdr = kzalloc(sizeof(*hdr) + sizeof(*filter) +
+	skb = __dev_alloc_skb(sizeof(*hdr) + sizeof(*filter) +
 		      priv->tx_hdr_len, GFP_ATOMIC);
-	if (!hdr)
+	if (!skb)
 		return -ENOMEM;
 
-	hdr = (void *)hdr + priv->tx_hdr_len;
-
-	filter = (struct p54_tx_control_filter *) hdr->data;
+	skb_reserve(skb, priv->tx_hdr_len);
+	hdr = (struct p54_control_hdr *) skb_put(skb, sizeof(*hdr));
 	hdr->magic1 = cpu_to_le16(0x8001);
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_FILTER_SET);
+	hdr->retry1 = hdr->retry2 = 0;
 
-	priv->filter_type = filter->filter_type = cpu_to_le16(filter_type);
+	filter = (struct p54_tx_control_filter *) skb_put(skb, sizeof(*filter));
+	filter->filter_type = priv->filter_type = cpu_to_le16(filter_type);
 	memcpy(filter->mac_addr, priv->mac_addr, ETH_ALEN);
 	if (!bssid)
 		memset(filter->bssid, ~0, ETH_ALEN);
@@ -929,33 +1034,34 @@ static int p54_set_filter(struct ieee802
 	}
 
 	hdr->len = cpu_to_le16(data_len);
-	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + data_len);
-	priv->tx(dev, hdr, sizeof(*hdr) + data_len, 1);
+	p54_assign_address(dev, skb, hdr, sizeof(*hdr) + data_len);
+
+	priv->tx(dev, hdr, skb, sizeof(*hdr) + data_len, 1);
 	return 0;
 }
 
 static int p54_set_freq(struct ieee80211_hw *dev, __le16 freq)
 {
 	struct p54_common *priv = dev->priv;
+	struct sk_buff *skb;
 	struct p54_control_hdr *hdr;
 	struct p54_tx_control_channel *chan;
 	unsigned int i;
 	size_t data_len;
 	void *entry;
 
-	hdr = kzalloc(sizeof(*hdr) + sizeof(*chan) +
-		      priv->tx_hdr_len, GFP_KERNEL);
-	if (!hdr)
-		return -ENOMEM;
+	skb = dev_alloc_skb(priv->tx_hdr_len + sizeof(*hdr) + sizeof(*chan));
 
-	hdr = (void *)hdr + priv->tx_hdr_len;
+	if (!skb)
+		return -ENOMEM;
 
-	chan = (struct p54_tx_control_channel *) hdr->data;
+	skb_reserve(skb, priv->tx_hdr_len);
 
+	hdr = (struct p54_control_hdr *)skb_put(skb, sizeof(*hdr));
 	hdr->magic1 = cpu_to_le16(0x8001);
-
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_CHANNEL_CHANGE);
-
+	hdr->retry1 = hdr->retry2 = 0;
+	chan = (struct p54_tx_control_channel *) skb_put(skb, sizeof(*chan));
 	chan->flags = cpu_to_le16(0x1);
 	chan->dwell = cpu_to_le16(0x0);
 
@@ -1018,32 +1124,35 @@ static int p54_set_freq(struct ieee80211
 	}
 
 	hdr->len = cpu_to_le16(data_len);
-	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + data_len);
-	priv->tx(dev, hdr, sizeof(*hdr) + data_len, 1);
+	p54_assign_address(dev, skb, hdr, sizeof(*hdr) + data_len);
+	priv->tx(dev, hdr, skb, sizeof(*hdr) + data_len, 1);
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
+	struct sk_buff *skb;
 	struct p54_control_hdr *hdr;
 	struct p54_tx_control_led *led;
 
-	hdr = kzalloc(sizeof(*hdr) + sizeof(*led) +
-		      priv->tx_hdr_len, GFP_KERNEL);
-	if (!hdr)
+	skb = dev_alloc_skb(sizeof(*hdr) + sizeof(*led) +
+		      priv->tx_hdr_len);
+	if (!skb)
 		return -ENOMEM;
 
-	hdr = (void *)hdr + priv->tx_hdr_len;
+	skb_reserve(skb, priv->tx_hdr_len);
+
+	hdr = (void *)skb_put(skb, sizeof(*hdr) + sizeof(*led));
 	hdr->magic1 = cpu_to_le16(0x8001);
 	hdr->len = cpu_to_le16(sizeof(*led));
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_LED);
-	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*led));
+	hdr->retry1 = hdr->retry2 = 0;
 
 	led = (struct p54_tx_control_led *) hdr->data;
 	led->mode = cpu_to_le16(mode);
@@ -1051,7 +1160,8 @@ static int p54_set_leds(struct ieee80211
 	led->led_temporary = cpu_to_le16(act);
 	led->duration = cpu_to_le16(1000);
 
-	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*led), 1);
+	p54_assign_address(dev, skb, hdr, skb->len);
+	priv->tx(dev, hdr, skb, skb->len, 1);
 
 	return 0;
 }
@@ -1064,53 +1174,78 @@ do {	 							\
 	queue.txop = cpu_to_le16(_txop);			\
 } while(0)
 
-static void p54_init_vdcf(struct ieee80211_hw *dev)
+static int p54_set_vdcf(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr;
 	struct p54_tx_control_vdcf *vdcf;
+	struct sk_buff *skb;
+
+	skb = dev_alloc_skb(priv->tx_hdr_len +
+			sizeof(struct p54_control_hdr) +
+			sizeof(struct p54_tx_control_vdcf));
+
+	if (!skb)
+		return -ENOMEM;
+
+	skb_reserve(skb, priv->tx_hdr_len);
 
-	/* all USB V1 adapters need a extra headroom */
-	hdr = (void *)priv->cached_vdcf + priv->tx_hdr_len;
+	hdr = (void *)skb_put(skb, sizeof(*hdr));
 	hdr->magic1 = cpu_to_le16(0x8001);
 	hdr->len = cpu_to_le16(sizeof(*vdcf));
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_DCFINIT);
 	hdr->req_id = cpu_to_le32(priv->rx_start);
+	hdr->retry1 = hdr->retry2 = 0;
+	vdcf = (void *)skb_put(skb, sizeof(*vdcf));
+	if (dev->conf.flags & IEEE80211_CONF_SHORT_SLOT_TIME) {
+		vdcf->slottime = 9;
+		vdcf->sifs = 0x10;
+		vdcf->eofpad = 0x00;
+	} else {
+		vdcf->slottime = 20;
+		vdcf->sifs = 0x0a;
+		vdcf->eofpad = 0x06;
+	}
+	memset(vdcf->mapping, 0, sizeof(vdcf->mapping));
+	memcpy(vdcf->queue, priv->edcf, sizeof(priv->edcf));
+
+	/* (see prism54/isl_oid.h for further details) */
+	vdcf->frameburst = cpu_to_le16(0);
 
-	vdcf = (struct p54_tx_control_vdcf *) hdr->data;
+	p54_assign_address(dev, skb, hdr, skb->len);
+	priv->tx(dev, hdr, skb, skb->len, 1);
 
-	P54_SET_QUEUE(vdcf->queue[0], 0x0002, 0x0003, 0x0007, 47);
-	P54_SET_QUEUE(vdcf->queue[1], 0x0002, 0x0007, 0x000f, 94);
-	P54_SET_QUEUE(vdcf->queue[2], 0x0003, 0x000f, 0x03ff, 0);
-	P54_SET_QUEUE(vdcf->queue[3], 0x0007, 0x000f, 0x03ff, 0);
+	return 0;
 }
 
-static void p54_set_vdcf(struct ieee80211_hw *dev)
+static int p54_init_stats(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr;
-	struct p54_tx_control_vdcf *vdcf;
+	struct p54_statistics *stats;
 
-	hdr = (void *)priv->cached_vdcf + priv->tx_hdr_len;
+	priv->cached_stats = dev_alloc_skb(priv->tx_hdr_len +
+			sizeof(struct p54_control_hdr) +
+			sizeof(struct p54_statistics));
 
-	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*vdcf));
+	if (!priv->cached_stats)
+			return -ENOMEM;
 
-	vdcf = (struct p54_tx_control_vdcf *) hdr->data;
+	skb_reserve(priv->cached_stats, priv->tx_hdr_len);
 
-	if (dev->conf.flags & IEEE80211_CONF_SHORT_SLOT_TIME) {
-		vdcf->slottime = 9;
-		vdcf->magic1 = 0x10;
-		vdcf->magic2 = 0x00;
-	} else {
-		vdcf->slottime = 20;
-		vdcf->magic1 = 0x0a;
-		vdcf->magic2 = 0x06;
-	}
+	hdr = (void *) skb_put(priv->cached_stats, sizeof(*hdr));
+	hdr->magic1 = cpu_to_le16(0x8000);
+	hdr->len = cpu_to_le16(sizeof(*stats));
+	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_STAT_READBACK);
+	hdr->retry1 = hdr->retry2 = 0;
+	stats = (void *) skb_put(priv->cached_stats, sizeof(*stats));
 
-	/* (see prism54/isl_oid.h for further details) */
-	vdcf->frameburst = cpu_to_le16(0);
+	p54_assign_address(dev, priv->cached_stats,
+			   hdr, priv->cached_stats->len);
+
+	mod_timer(&priv->stats_timer, jiffies + HZ);
 
-	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*vdcf), 0);
+	return 0;
 }
 
 static int p54_start(struct ieee80211_hw *dev)
@@ -1118,34 +1253,18 @@ static int p54_start(struct ieee80211_hw
 	struct p54_common *priv = dev->priv;
 	int err;
 
-	if (!priv->cached_vdcf) {
-		priv->cached_vdcf = kzalloc(sizeof(struct p54_tx_control_vdcf)+
-			priv->tx_hdr_len + sizeof(struct p54_control_hdr),
-			GFP_KERNEL);
-
-		if (!priv->cached_vdcf)
-			return -ENOMEM;
-	}
-
-	if (!priv->cached_stats) {
-		priv->cached_stats = kzalloc(sizeof(struct p54_statistics) +
-			priv->tx_hdr_len + sizeof(struct p54_control_hdr),
-			GFP_KERNEL);
-
-		if (!priv->cached_stats) {
-			kfree(priv->cached_vdcf);
-			priv->cached_vdcf = NULL;
-			return -ENOMEM;
-		}
-	}
-
 	err = priv->open(dev);
 	if (!err)
 		priv->mode = NL80211_IFTYPE_MONITOR;
 
-	p54_init_vdcf(dev);
+	P54_SET_QUEUE(priv->edcf[0], 0x0002, 0x0003, 0x0007, 47);
+	P54_SET_QUEUE(priv->edcf[1], 0x0002, 0x0007, 0x000f, 94);
+	P54_SET_QUEUE(priv->edcf[2], 0x0003, 0x000f, 0x03ff, 0);
+	P54_SET_QUEUE(priv->edcf[3], 0x0007, 0x000f, 0x03ff, 0);
+	err = p54_set_vdcf(dev);
+	if (!err)
+		err = p54_init_stats(dev);
 
-	mod_timer(&priv->stats_timer, jiffies + HZ);
 	return err;
 }
 
@@ -1155,8 +1274,11 @@ static void p54_stop(struct ieee80211_hw
 	struct sk_buff *skb;
 
 	del_timer(&priv->stats_timer);
+	p54_free_skb(dev, priv->cached_stats);
+	priv->cached_stats = NULL;
 	while ((skb = skb_dequeue(&priv->tx_queue)))
 		kfree_skb(skb);
+
 	priv->stop(dev);
 	priv->tsf_high32 = priv->tsf_low32 = 0;
 	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
@@ -1270,46 +1392,39 @@ static int p54_conf_tx(struct ieee80211_
 		       const struct ieee80211_tx_queue_params *params)
 {
 	struct p54_common *priv = dev->priv;
-	struct p54_tx_control_vdcf *vdcf;
-
-	vdcf = (struct p54_tx_control_vdcf *)(((struct p54_control_hdr *)
-		((void *)priv->cached_vdcf + priv->tx_hdr_len))->data);
 
 	if ((params) && !(queue > 4)) {
-		P54_SET_QUEUE(vdcf->queue[queue], params->aifs,
+		P54_SET_QUEUE(priv->edcf[queue], params->aifs,
 			params->cw_min, params->cw_max, params->txop);
 	} else
 		return -EINVAL;
 
-	p54_set_vdcf(dev);
-
-	return 0;
+	return p54_set_vdcf(dev);
 }
 
 static int p54_init_xbow_synth(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
+	struct sk_buff *skb;
 	struct p54_control_hdr *hdr;
 	struct p54_tx_control_xbow_synth *xbow;
 
-	hdr = kzalloc(sizeof(*hdr) + sizeof(*xbow) +
-		      priv->tx_hdr_len, GFP_KERNEL);
-	if (!hdr)
+	skb = dev_alloc_skb(priv->tx_hdr_len + sizeof(*hdr) + sizeof(*xbow));
+	if (!skb)
 		return -ENOMEM;
+	skb_reserve(skb, priv->tx_hdr_len);
 
-	hdr = (void *)hdr + priv->tx_hdr_len;
+	hdr = (struct p54_control_hdr *)skb_put(skb, sizeof(*hdr));
 	hdr->magic1 = cpu_to_le16(0x8001);
 	hdr->len = cpu_to_le16(sizeof(*xbow));
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_XBOW_SYNTH_CFG);
-	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*xbow));
-
-	xbow = (struct p54_tx_control_xbow_synth *) hdr->data;
+	xbow = (struct p54_tx_control_xbow_synth *)skb_put(skb, sizeof(*xbow));
 	xbow->magic1 = cpu_to_le16(0x1);
 	xbow->magic2 = cpu_to_le16(0x2);
 	xbow->freq = cpu_to_le16(5390);
 
-	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*xbow), 1);
-
+	p54_assign_address(dev, skb, hdr, sizeof(*hdr) + sizeof(*xbow));
+	priv->tx(dev, hdr, skb, sizeof(*hdr) + sizeof(*xbow), 1);
 	return 0;
 }
 
@@ -1318,17 +1433,11 @@ static void p54_statistics_timer(unsigne
 	struct ieee80211_hw *dev = (struct ieee80211_hw *) data;
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr;
-	struct p54_statistics *stats;
 
 	BUG_ON(!priv->cached_stats);
 
-	hdr = (void *)priv->cached_stats + priv->tx_hdr_len;
-	hdr->magic1 = cpu_to_le16(0x8000);
-	hdr->len = cpu_to_le16(sizeof(*stats));
-	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_STAT_READBACK);
-	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*stats));
-
-	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*stats), 0);
+	hdr = (struct p54_control_hdr *)priv->cached_stats->data;
+	priv->tx(dev, hdr, priv->cached_stats, priv->cached_stats->len, 0);
 }
 
 static int p54_get_stats(struct ieee80211_hw *dev,
@@ -1418,11 +1527,12 @@ EXPORT_SYMBOL_GPL(p54_init_common);
 void p54_free_common(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
-	kfree(priv->cached_stats);
+
+	del_timer(&priv->stats_timer);
+	kfree_skb(priv->cached_stats);
 	kfree(priv->iq_autocal);
 	kfree(priv->output_limit);
 	kfree(priv->curve_data);
-	kfree(priv->cached_vdcf);
 }
 EXPORT_SYMBOL_GPL(p54_free_common);
 
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-09-29 20:39:31.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.h	2008-10-02 02:19:27.000000000 +0200
@@ -169,6 +169,7 @@ struct pda_pa_curve_data {
 struct memrecord {
 	u32 start_addr;
 	u32 end_addr;
+	struct ieee80211_hw *dev;
 };
 
 struct p54_eeprom_lm86 {
@@ -285,21 +286,15 @@ struct p54_tx_control_led {
 	__le16 duration;
 } __attribute__ ((packed));
 
-struct p54_tx_vdcf_queues {
-	__le16 aifs;
-	__le16 cwmin;
-	__le16 cwmax;
-	__le16 txop;
-} __attribute__ ((packed));
-
 struct p54_tx_control_vdcf {
 	u8 padding;
 	u8 slottime;
-	u8 magic1;
-	u8 magic2;
+	u8 sifs;
+	u8 eofpad;
 	struct p54_tx_vdcf_queues queue[8];
-	u8 pad2[4];
+	u8 mapping[4];
 	__le16 frameburst;
+	__le16 round_trip_delay;
 } __attribute__ ((packed));
 
 struct p54_statistics {
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-09-29 20:39:31.000000000 +0200
+++ b/drivers/net/wireless/p54/p54.h	2008-10-02 01:11:30.000000000 +0200
@@ -49,6 +49,13 @@ struct p54_control_hdr {
 	u8 data[0];
 } __attribute__ ((packed));
 
+struct p54_tx_vdcf_queues {
+	__le16 aifs;
+	__le16 cwmin;
+	__le16 cwmax;
+	__le16 txop;
+} __attribute__ ((packed));
+
 #define EEPROM_READBACK_LEN 0x3fc
 
 #define ISL38XX_DEV_FIRMWARE_ADDR 0x20000
@@ -63,7 +70,7 @@ struct p54_common {
 	u32 rx_end;
 	struct sk_buff_head tx_queue;
 	void (*tx)(struct ieee80211_hw *dev, struct p54_control_hdr *data,
-		   size_t len, int free_on_tx);
+		   struct sk_buff *skb, size_t len, int free_on_tx);
 	int (*open)(struct ieee80211_hw *dev);
 	void (*stop)(struct ieee80211_hw *dev);
 	int mode;
@@ -85,23 +92,24 @@ struct p54_common {
 	u8 version;
 	u8 rx_antenna;
 	unsigned int tx_hdr_len;
-	void *cached_vdcf;
 	unsigned int fw_var;
 	unsigned int fw_interface;
 	unsigned int output_power;
 	u32 tsf_low32;
 	u32 tsf_high32;
 	struct ieee80211_tx_queue_stats tx_stats[8];
+	struct p54_tx_vdcf_queues edcf[8];
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
--- a/drivers/net/wireless/p54/p54pci.c	2008-09-29 20:39:31.000000000 +0200
+++ b/drivers/net/wireless/p54/p54pci.c	2008-10-02 03:21:13.000000000 +0200
@@ -235,7 +235,7 @@ static void p54p_check_tx_ring(struct ie
 
 	while (i != idx) {
 		desc = &ring[i];
-		kfree(tx_buf[i]);
+		p54_free_skb(dev, tx_buf[i]);
 		tx_buf[i] = NULL;
 
 		pci_unmap_single(priv->pdev, le32_to_cpu(desc->host_addr),
@@ -307,7 +307,7 @@ static irqreturn_t p54p_interrupt(int ir
 }
 
 static void p54p_tx(struct ieee80211_hw *dev, struct p54_control_hdr *data,
-		    size_t len, int free_on_tx)
+		    struct sk_buff *skb, size_t len, int free_on_tx)
 {
 	struct p54p_priv *priv = dev->priv;
 	struct p54p_ring_control *ring_control = priv->ring_control;
@@ -333,7 +333,7 @@ static void p54p_tx(struct ieee80211_hw 
 	ring_control->host_idx[1] = cpu_to_le32(idx + 1);
 
 	if (free_on_tx)
-		priv->tx_buf_data[i] = data;
+		priv->tx_buf_data[i] = skb;
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -342,8 +342,10 @@ static void p54p_tx(struct ieee80211_hw 
 
 	/* FIXME: unlikely to happen because the device usually runs out of
 	   memory before we fill the ring up, but we can make it impossible */
-	if (idx - device_idx > ARRAY_SIZE(ring_control->tx_data) - 2)
+	if (idx - device_idx > ARRAY_SIZE(ring_control->tx_data) - 2) {
+		p54_free_skb(dev, skb);
 		printk(KERN_INFO "%s: tx overflow.\n", wiphy_name(dev->wiphy));
+	}
 }
 
 static int p54p_open(struct ieee80211_hw *dev)
@@ -455,7 +457,7 @@ static void p54p_stop(struct ieee80211_h
 					 le16_to_cpu(desc->len),
 					 PCI_DMA_TODEVICE);
 
-		kfree(priv->tx_buf_data[i]);
+		p54_free_skb(dev, priv->tx_buf_data[i]);
 		priv->tx_buf_data[i] = NULL;
 	}
 
@@ -467,7 +469,7 @@ static void p54p_stop(struct ieee80211_h
 					 le16_to_cpu(desc->len),
 					 PCI_DMA_TODEVICE);
 
-		kfree(priv->tx_buf_mgmt[i]);
+		p54_free_skb(dev, priv->tx_buf_mgmt[i]);
 		priv->tx_buf_mgmt[i] = NULL;
 	}
 
diff -Nurp a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c	2008-09-29 20:39:31.000000000 +0200
+++ b/drivers/net/wireless/p54/p54usb.c	2008-10-02 03:08:40.000000000 +0200
@@ -22,6 +22,7 @@
 #include <net/mac80211.h>
 
 #include "p54.h"
+#include "p54common.h"
 #include "p54usb.h"
 
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
@@ -134,6 +135,18 @@ static void p54u_rx_cb(struct urb *urb)
 	usb_submit_urb(urb, GFP_ATOMIC);
 }
 
+static void p54u_tx_reuse_skb_cb(struct urb *urb)
+{
+	struct sk_buff *skb = urb->context;
+	struct ieee80211_tx_info *ni = IEEE80211_SKB_CB(skb);
+	struct memrecord *mr = (struct memrecord *) ni->driver_data;
+	struct p54u_priv *priv = (struct p54u_priv *) mr->dev->priv;
+
+	skb_pull(skb, priv->common.tx_hdr_len);
+
+	usb_free_urb(urb);
+}
+
 static void p54u_tx_cb(struct urb *urb)
 {
 	usb_free_urb(urb);
@@ -145,6 +158,16 @@ static void p54u_tx_free_cb(struct urb *
 	usb_free_urb(urb);
 }
 
+static void p54u_tx_free_skb_cb(struct urb *urb)
+{
+	struct sk_buff *skb = urb->context;
+	struct ieee80211_tx_info *ni = IEEE80211_SKB_CB(skb);
+	struct memrecord *mr = (struct memrecord *)ni->driver_data;
+
+	p54_free_skb(mr->dev, skb);
+	usb_free_urb(urb);
+}
+
 static int p54u_init_urbs(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
@@ -192,7 +215,7 @@ static void p54u_free_urbs(struct ieee80
 }
 
 static void p54u_tx_3887(struct ieee80211_hw *dev, struct p54_control_hdr *data,
-			 size_t len, int free_on_tx)
+			 struct sk_buff *skb, size_t len, int free_on_tx)
 {
 	struct p54u_priv *priv = dev->priv;
 	struct urb *addr_urb, *data_urb;
@@ -212,7 +235,7 @@ static void p54u_tx_3887(struct ieee8021
 		sizeof(data->req_id), p54u_tx_cb, dev);
 	usb_fill_bulk_urb(data_urb, priv->udev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), data, len,
-		free_on_tx ? p54u_tx_free_cb : p54u_tx_cb, dev);
+		free_on_tx ? p54u_tx_free_skb_cb : p54u_tx_reuse_skb_cb, skb);
 
 	usb_submit_urb(addr_urb, GFP_ATOMIC);
 	usb_submit_urb(data_urb, GFP_ATOMIC);
@@ -231,13 +254,13 @@ static __le32 p54u_lm87_chksum(const u32
 	return cpu_to_le32(chk);
 }
 
-static void p54u_tx_lm87(struct ieee80211_hw *dev,
-			 struct p54_control_hdr *data,
-			 size_t len, int free_on_tx)
+static void p54u_tx_lm87(struct ieee80211_hw *dev, struct p54_control_hdr *data,
+			 struct sk_buff *skb, size_t len, int free_on_tx)
 {
 	struct p54u_priv *priv = dev->priv;
 	struct urb *data_urb;
-	struct lm87_tx_hdr *hdr = (void *)data - sizeof(*hdr);
+	struct lm87_tx_hdr *hdr = (struct lm87_tx_hdr *)
+				skb_push(skb, sizeof(*hdr));
 
 	data_urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!data_urb)
@@ -248,14 +271,14 @@ static void p54u_tx_lm87(struct ieee8021
 
 	usb_fill_bulk_urb(data_urb, priv->udev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), hdr,
-		len + sizeof(*hdr), free_on_tx ? p54u_tx_free_cb : p54u_tx_cb,
-		dev);
+		len + sizeof(*hdr), free_on_tx ? p54u_tx_free_skb_cb :
+		p54u_tx_reuse_skb_cb, skb);
 
 	usb_submit_urb(data_urb, GFP_ATOMIC);
 }
 
 static void p54u_tx_net2280(struct ieee80211_hw *dev, struct p54_control_hdr *data,
-			    size_t len, int free_on_tx)
+			    struct sk_buff *skb, size_t len, int free_on_tx)
 {
 	struct p54u_priv *priv = dev->priv;
 	struct urb *int_urb, *data_urb;
@@ -296,7 +319,7 @@ static void p54u_tx_net2280(struct ieee8
 
 	usb_fill_bulk_urb(data_urb, priv->udev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), hdr, len + sizeof(*hdr),
-		free_on_tx ? p54u_tx_free_cb : p54u_tx_cb, dev);
+		free_on_tx ? p54u_tx_free_skb_cb : p54u_tx_reuse_skb_cb, skb);
 	usb_submit_urb(data_urb, GFP_ATOMIC);
 }
 

