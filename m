Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:29747 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760073AbXFKBX2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2007 21:23:28 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] p54: QoS/WMM/WME/802.11e support
Date: Sun, 10 Jun 2007 18:22:27 -0700
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Chr <chunkeey@web.de>
Message-Id: <200706101822.27567.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8";
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Christian Lamparter <chunkeey@web.de>

The p54 fw has 8 (different) queues for transmitting frames. The problem
is, that there's "fixed" a limit for each queue, how many packages can
stay at the same time. And guess what happens, if the queue overflows?
... lots of strange bugs and crashes.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/mac80211/p54/prism54.h       |    2 
 drivers/net/wireless/mac80211/p54/prism54common.c |  153 ++++++++++++++++++++-
 drivers/net/wireless/mac80211/p54/prism54common.h |    1 
 drivers/net/wireless/mac80211/p54/prism54magic.h  |   77 -----------
 drivers/net/wireless/mac80211/p54/prism54pci.c    |   13 --
 drivers/net/wireless/mac80211/p54/prism54usb.c    |   54 -------
 6 files changed, 149 insertions(+), 151 deletions(-)

diff --git a/drivers/net/wireless/mac80211/p54/prism54.h b/drivers/net/wireless/mac80211/p54/prism54.h
index 79641de..6f82726 100644
--- a/drivers/net/wireless/mac80211/p54/prism54.h
+++ b/drivers/net/wireless/mac80211/p54/prism54.h
@@ -61,10 +61,12 @@ struct p54_common {
 	__le16 rxhw;
 	u8 version;
 	unsigned int tx_hdr_len;
+	void *cached_vdcf;
 	/* FIXME: this channels/modes/rates stuff sucks */
 	struct ieee80211_channel channels[14];
 	struct ieee80211_rate rates[12];
 	struct ieee80211_hw_mode modes[2];
+	struct ieee80211_tx_queue_stats tx_stats;
 };
 
 int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb);
diff --git a/drivers/net/wireless/mac80211/p54/prism54common.c b/drivers/net/wireless/mac80211/p54/prism54common.c
index 2539464..be05911 100644
--- a/drivers/net/wireless/mac80211/p54/prism54common.c
+++ b/drivers/net/wireless/mac80211/p54/prism54common.c
@@ -3,6 +3,7 @@
  * Common code for mac80211 Prism54 drivers
  *
  * Copyright (c) 2006, Michael Wu <flamingice@sourmilk.net>
+ * Copyright (c) 2007, Christian Lamparter <chunkeey@web.de>
  *
  * Based on the islsm (softmac prism54) driver, which is:
  * Copyright 2004-2006 Jean-Baptiste Note <jbnote@gmail.com>, et al.
@@ -283,10 +284,11 @@ static void p54_rx_data(struct ieee80211_hw *dev, struct sk_buff *skb)
 	u16 freq = le16_to_cpu(hdr->freq);
 
 	rx_status.ssi = hdr->rssi;	/* TODO: check this */
-	rx_status.rate = hdr->rate & 0x0f;
+	rx_status.rate = hdr->rate & 0x1f; /* report short preambles & CCK too */
 	rx_status.channel = freq == 2484 ? 14 : (freq - 2407)/5;
 	rx_status.freq = freq;
 	rx_status.phymode = MODE_IEEE80211G;
+	rx_status.antenna = hdr->antenna;
 
 	skb_pull(skb, sizeof(*hdr));
 	skb_trim(skb, le16_to_cpu(hdr->len));
@@ -294,6 +296,19 @@ static void p54_rx_data(struct ieee80211_hw *dev, struct sk_buff *skb)
 	ieee80211_rx_irqsafe(dev, skb, &rx_status);
 }
 
+static void inline p54_wake_free_queues(struct ieee80211_hw *dev)
+{
+	struct p54_common *priv = dev->priv;
+	int i;
+
+ 	/* ieee80211_start_queues is great if all queues are really empty.
+ 	 * But, what if some are full? */
+
+	for (i = 0; i < dev->queues; i++)
+		if (priv->tx_stats.data[i].len < priv->tx_stats.data[i].limit)
+			ieee80211_wake_queue(dev, i);
+}
+
 static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54_common *priv = dev->priv;
@@ -331,6 +346,7 @@ static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff *skb)
 			status.retry_count = payload->retries - 1;
 			status.ack_signal = le16_to_cpu(payload->ack_rssi);
 			skb_pull(entry, sizeof(*hdr) + sizeof(struct p54_tx_control_allocdata));
+			priv->tx_stats.data[status.control.queue].len--;
 			ieee80211_tx_status_irqsafe(dev, entry, &status);
 			break;
 		} else
@@ -340,7 +356,7 @@ static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff *skb)
 
 	if (freed >= IEEE80211_MAX_RTS_THRESHOLD + 0x170 +
 	    sizeof(struct p54_control_hdr))
-		ieee80211_wake_queue(dev, 0);
+		p54_wake_free_queues(dev);
 }
 
 static void p54_rx_control(struct ieee80211_hw *dev, struct sk_buff *skb)
@@ -443,7 +459,7 @@ static void p54_assign_address(struct ieee80211_hw *dev, struct sk_buff *skb,
 		__skb_queue_after(&priv->tx_queue, target_skb, skb);
 		if (largest_hole < IEEE80211_MAX_RTS_THRESHOLD + 0x170 +
 				   sizeof(struct p54_control_hdr))
-			ieee80211_stop_queue(dev, 0);
+			ieee80211_stop_queues(dev);
 	}
 	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 
@@ -453,6 +469,7 @@ static void p54_assign_address(struct ieee80211_hw *dev, struct sk_buff *skb,
 static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 		  struct ieee80211_tx_control *control)
 {
+	struct ieee80211_tx_queue_stats_data *current_queue;
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr;
 	struct p54_tx_control_allocdata *txhdr;
@@ -460,6 +477,14 @@ static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 	size_t padding, len;
 	u8 rate;
 
+	current_queue = &priv->tx_stats.data[control->queue];
+	if (unlikely(current_queue->len > current_queue->limit))
+		return NETDEV_TX_BUSY;
+	current_queue->len++;
+	current_queue->count++;
+	if (current_queue->len == current_queue->limit)
+		ieee80211_stop_queue(dev, control->queue);
+
 	padding = (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))) & 3;
 	len = skb->len;
 
@@ -493,12 +518,13 @@ static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 	memset(txhdr->rateset, rate, 8);
 	txhdr->wep_key_present = 0;
 	txhdr->wep_key_len = 0;
-	txhdr->frame_type = cpu_to_le32(0x4);
+	txhdr->frame_type = cpu_to_le32(control->queue + 4);
 	txhdr->magic4 = 0;
-	txhdr->antenna = control->antenna_sel_tx;
+	txhdr->antenna = (control->antenna_sel_tx == 0) ? 
+		2 : control->antenna_sel_tx - 1;
 	txhdr->output_power = 0x7f; // HW Maximum
 	txhdr->magic5 = (control->flags & IEEE80211_TXCTL_NO_ACK) ?
-			 0 : cpu_to_le32(0x23);
+		0 : ((rate > 0x3) ? cpu_to_le32(0x33) : cpu_to_le32(0x23));
 	if (padding)
 		txhdr->align[0] = padding;
 
@@ -654,6 +680,64 @@ static int p54_set_leds(struct ieee80211_hw *dev, int mode, int link, int act)
 	return 0;
 }
 
+#define P54_SET_QUEUE(queue, ai_fs, cw_min, cw_max, burst)	\
+do {	 							\
+	queue.aifs = cpu_to_le16(ai_fs);			\
+	queue.cwmin = cpu_to_le16(cw_min);			\
+	queue.cwmax = cpu_to_le16(cw_max);			\
+	queue.txop = (burst == 0) ? 				\
+		0 : cpu_to_le16((burst * 100) / 32 + 1);	\
+} while(0)
+
+static void p54_init_vdcf(struct ieee80211_hw *dev)
+{
+	struct p54_common *priv = dev->priv;
+	struct p54_control_hdr *hdr;
+	struct p54_tx_control_vdcf *vdcf;
+
+	/* all USB V1 adapters need a extra headroom */
+	hdr = (void *)priv->cached_vdcf + priv->tx_hdr_len;
+	hdr->magic1 = cpu_to_le16(0x8001);
+	hdr->len = cpu_to_le16(sizeof(*vdcf));
+	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_DCFINIT);
+	hdr->req_id = cpu_to_le32(priv->rx_start);
+
+	vdcf = (struct p54_tx_control_vdcf *) hdr->data;
+
+	P54_SET_QUEUE(vdcf->queue[0], 0x0002, 0x0003, 0x0007, 0x000f);
+	P54_SET_QUEUE(vdcf->queue[1], 0x0002, 0x0007, 0x000f, 0x001e);
+	P54_SET_QUEUE(vdcf->queue[2], 0x0002, 0x000f, 0x03ff, 0x0014);
+	P54_SET_QUEUE(vdcf->queue[3], 0x0007, 0x000f, 0x03ff, 0x0000);
+}
+
+static void p54_set_vdcf(struct ieee80211_hw *dev)
+{
+	struct p54_common *priv = dev->priv;
+	struct p54_control_hdr *hdr;
+	struct p54_tx_control_vdcf *vdcf;
+
+	hdr = (void *)priv->cached_vdcf + priv->tx_hdr_len;
+
+	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*vdcf), NULL);
+
+	vdcf = (struct p54_tx_control_vdcf *) hdr->data;
+
+	if (dev->conf.flags & IEEE80211_CONF_SHORT_SLOT_TIME) {
+		vdcf->slottime = 9;
+		vdcf->magic1 = 0x00;
+		vdcf->magic2 = 0x10;
+	} else {
+		vdcf->slottime = 20;
+		vdcf->magic1 = 0x0a;
+		vdcf->magic2 = 0x06;
+	}
+
+	/* (see prism54/isl_oid.h for further details) */
+	vdcf->frameburst = cpu_to_le16(0);
+
+	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*vdcf), 0);
+}
+
 static int p54_add_interface(struct ieee80211_hw *dev,
 			     struct ieee80211_if_init_conf *conf)
 {
@@ -683,6 +767,7 @@ static int p54_add_interface(struct ieee80211_hw *dev,
 
 	p54_set_filter(dev, 0, priv->mac_addr, NULL, 0, 1, 0, 0xF642);
 	p54_set_filter(dev, 0, priv->mac_addr, NULL, 1, 0, 0, 0xF642);
+	p54_set_vdcf(dev);
 
 	switch (conf->type) {
 	case IEEE80211_IF_TYPE_STA:
@@ -712,8 +797,11 @@ static void p54_remove_interface(struct ieee80211_hw *dev,
 
 static int p54_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
 {
-	p54_set_freq(dev, cpu_to_le16(conf->freq));
-	return 0;
+	int ret;
+
+	ret = p54_set_freq(dev, cpu_to_le16(conf->freq));
+	p54_set_vdcf(dev);
+	return ret;
 }
 
 static int p54_config_interface(struct ieee80211_hw *dev, int if_id,
@@ -727,6 +815,26 @@ static int p54_config_interface(struct ieee80211_hw *dev, int if_id,
 	return 0;
 }
 
+static int p54_conf_tx(struct ieee80211_hw *dev, int queue,
+		       const struct ieee80211_tx_queue_params *params)
+{
+	struct p54_common *priv = dev->priv;
+	struct p54_tx_control_vdcf *vdcf;
+
+	vdcf = (struct p54_tx_control_vdcf *)(((struct p54_control_hdr *)
+		((void *)priv->cached_vdcf + priv->tx_hdr_len))->data);
+
+	if ((params) && !((queue < 0) || (queue > 4))) {
+		P54_SET_QUEUE(vdcf->queue[queue], params->aifs,
+			params->cw_min, params->cw_max, params->burst_time);
+	} else
+		return -EINVAL;
+
+	p54_set_vdcf(dev);
+
+	return 0;
+}
+
 static int p54_get_stats(struct ieee80211_hw *dev,
 			 struct ieee80211_low_level_stats *stats)
 {
@@ -737,7 +845,13 @@ static int p54_get_stats(struct ieee80211_hw *dev,
 static int p54_get_tx_stats(struct ieee80211_hw *dev,
 			    struct ieee80211_tx_queue_stats *stats)
 {
-	/* TODO.. probably should let lower level deal with this */
+	struct p54_common *priv = dev->priv;
+	unsigned int i;
+
+	for (i = 0; i < dev->queues; i++)
+		memcpy(&stats->data[i], &priv->tx_stats.data[i],
+			sizeof(stats->data[i]));
+	
 	return 0;
 }
 
@@ -747,6 +861,7 @@ static const struct ieee80211_ops p54_ops = {
 	.remove_interface	= p54_remove_interface,
 	.config			= p54_config,
 	.config_interface	= p54_config_interface,
+	.conf_tx		= p54_conf_tx,
 	.get_stats		= p54_get_stats,
 	.get_tx_stats		= p54_get_tx_stats
 };
@@ -784,12 +899,29 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
 	dev->max_rssi = 100;
 
-	dev->queues = 1;
+	/* (hard) queue limits */
+	priv->tx_stats.data[0].limit = 3;
+	priv->tx_stats.data[1].limit = 4;
+	priv->tx_stats.data[2].limit = 3;
+	priv->tx_stats.data[3].limit = 1;
+
+	dev->queues = 4;
 	dev->extra_tx_headroom = sizeof(struct p54_control_hdr) + 4 +
 				 sizeof(struct p54_tx_control_allocdata);
 
+        priv->cached_vdcf = kzalloc(sizeof(struct p54_tx_control_vdcf) +
+              priv->tx_hdr_len + sizeof(struct p54_control_hdr), GFP_KERNEL);
+
+	if (!priv->cached_vdcf) {
+		ieee80211_free_hw(dev);
+		return NULL;
+	}
+
+	p54_init_vdcf(dev);
+
 	for (i = 0; i < 2; i++) {
 		if (ieee80211_register_hwmode(dev, &priv->modes[i])) {
+			kfree(priv->cached_vdcf);
 			ieee80211_free_hw(dev);
 			return NULL;
 		}
@@ -805,6 +937,7 @@ void p54_free_common(struct ieee80211_hw *dev)
 	kfree(priv->iq_autocal);
 	kfree(priv->output_limit);
 	kfree(priv->curve_data);
+	kfree(priv->cached_vdcf);
 }
 EXPORT_SYMBOL_GPL(p54_free_common);
 
diff --git a/drivers/net/wireless/mac80211/p54/prism54common.h b/drivers/net/wireless/mac80211/p54/prism54common.h
index 7427cc2..1520f29 100644
--- a/drivers/net/wireless/mac80211/p54/prism54common.h
+++ b/drivers/net/wireless/mac80211/p54/prism54common.h
@@ -5,6 +5,7 @@
  * Common code specific definitions for mac80211 Prism54 drivers
  *
  * Copyright (c) 2006, Michael Wu <flamingice@sourmilk.net>
+ * Copyright (c) 2007, Christian Lamparter <chunkeey@web.de>
  *
  * Based on the islsm (softmac prism54) driver, which is:
  * Copyright 2004-2006 Jean-Baptiste Note <jbnote@gmail.com>, et al.
diff --git a/drivers/net/wireless/mac80211/p54/prism54magic.h b/drivers/net/wireless/mac80211/p54/prism54magic.h
deleted file mode 100644
index 839e9d7..0000000
--- a/drivers/net/wireless/mac80211/p54/prism54magic.h
+++ /dev/null
@@ -1,77 +0,0 @@
-#ifndef PRISM54MAGIC_H
-#define PRISM54MAGIC_H
-
-/*
- * Magic packets for softmac Prism54 hardware
- *
- * Copyright (c) 2006, Michael Wu <flamingice@sourmilk.net>
- *
- * Based on the islsm (softmac prism54) driver, which is:
- * Copyright 2004-2006 Jean-Baptiste Note <jbnote@gmail.com>, et al.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-/* usb version 1 packet */
-static const char p54u_net2280_magic_packet[86] = {
-	0x01, 0x80, 0x4a, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00,
-	0x00,
-	0x00, 0x14, 0x0a, 0x06,
-	0x02, 0x00, 0x1f, 0x00, 0xff, 0x03, 0x00, 0x00, 0x00, 0x00, 0x1f,
-	0x00,
-	0xff, 0x03, 0x00, 0x00,
-	0x00, 0x00, 0x1f, 0x00, 0xff, 0x03, 0x00, 0x00, 0x00, 0x00, 0x1f,
-	0x00,
-	0xff, 0x03, 0x00, 0x00,
-	0x00, 0x00, 0x1f, 0x00, 0xff, 0x03, 0x00, 0x00, 0x00, 0x00, 0x1f,
-	0x00,
-	0xff, 0x03, 0x00, 0x00,
-	0x00, 0x00, 0x1f, 0x00, 0xff, 0x03, 0x00, 0x00, 0x00, 0x00, 0x1f,
-	0x00,
-	0xff, 0x03, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00
-};
-
-/* usb version 2 packet */
-static const char p54u_3887_magic_packet[86] = {
-	0x01, 0x80, 0x4a, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00,
-	0x00,
-	0x00, 0x14, 0x0a, 0x06,
-	0x02, 0x00, 0x03, 0x00, 0x07, 0x00, 0x5e, 0x00, 0x02, 0x00, 0x07,
-	0x00,
-	0x0f, 0x00, 0x2f, 0x00,
-	0x03, 0x00, 0x0f, 0x00, 0xff, 0x03, 0x2b, 0x00, 0x07, 0x00, 0x0f,
-	0x00,
-	0xff, 0x03, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00,
-	0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00,
-	0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x78, 0x05
-};
-
-/* pci packet. 5a values are "don't care" values. */
-static const char p54p_magic_packet[88] = {
-	0x01, 0x80, 0x4a, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00,
-        0x00,
-        0x00, 0x14, 0x0a, 0x06,
-        0x02, 0x5a, 0x03, 0x00, 0x07, 0x00, 0x2f, 0x00, 0x02, 0x5a, 0x07,
-        0x00,
-        0x0f, 0x00, 0x5e, 0x00,
-        0x03, 0x5a, 0x0f, 0x00, 0xff, 0x03, 0x00, 0x00, 0x07, 0x5a, 0x0f,
-        0x00,
-        0xff, 0x03, 0x00, 0x00,
-        0x5a, 0x5a, 0x5a, 0x5a, 0x5a, 0x5a, 0x5a, 0x5a, 0x5a, 0x5a, 0x5a,
-        0x5a,
-        0x5a, 0x5a, 0x5a, 0x5a,
-        0x5a, 0x5a, 0x5a, 0x5a, 0x5a, 0x5a, 0x5a, 0x5a, 0x5a, 0x5a, 0x5a,
-        0x5a,
-        0x5a, 0x5a, 0x5a, 0x5a,
-        0x00, 0x00, 0x00, 0x00, 0x00, 0x00
-};
-
-#endif /* PRISM54MAGIC_H */
diff --git a/drivers/net/wireless/mac80211/p54/prism54pci.c b/drivers/net/wireless/mac80211/p54/prism54pci.c
index 5de5726..90cc470 100644
--- a/drivers/net/wireless/mac80211/p54/prism54pci.c
+++ b/drivers/net/wireless/mac80211/p54/prism54pci.c
@@ -22,7 +22,6 @@
 
 #include "prism54.h"
 #include "prism54pci.h"
-#include "prism54magic.h"
 
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
 MODULE_DESCRIPTION("Prism54 PCI wireless driver");
@@ -403,20 +402,14 @@ static void p54p_tx(struct ieee80211_hw *dev, struct p54_control_hdr *data,
 static int p54p_open(struct ieee80211_hw *dev)
 {
 	struct p54p_priv *priv = dev->priv;
-	struct p54_control_hdr *startup_packet;
 	int err;
 
-	startup_packet = kmalloc(sizeof(p54p_magic_packet), GFP_KERNEL);
-	if (!startup_packet)
-		return -ENOMEM;
-
 	init_completion(&priv->boot_comp);
 	err = request_irq(priv->pdev->irq, &p54p_interrupt,
 			  IRQF_SHARED, "prism54pci", dev);
 	if (err) {
 		printk(KERN_ERR "%s: failed to register IRQ handler\n",
 		       wiphy_name(dev->wiphy));
-		kfree(startup_packet);
 		return err;
 	}
 
@@ -442,7 +435,6 @@ static int p54p_open(struct ieee80211_hw *dev)
 	if (!wait_for_completion_interruptible_timeout(&priv->boot_comp, HZ)) {
 		printk(KERN_ERR "%s: Cannot boot firmware!\n",
 		       wiphy_name(dev->wiphy));
-		kfree(startup_packet);
 		free_irq(priv->pdev->irq, dev);
 		return -ETIMEDOUT;
 	}
@@ -457,11 +449,6 @@ static int p54p_open(struct ieee80211_hw *dev)
 	wmb();
 	udelay(10);
 
-	memcpy(startup_packet, p54p_magic_packet, sizeof(p54p_magic_packet));
-	startup_packet->req_id = cpu_to_le32(priv->common.rx_start);
-
-	p54p_tx(dev, startup_packet, sizeof(p54p_magic_packet), 1);
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mac80211/p54/prism54usb.c b/drivers/net/wireless/mac80211/p54/prism54usb.c
index e65da2d..4c6b849 100644
--- a/drivers/net/wireless/mac80211/p54/prism54usb.c
+++ b/drivers/net/wireless/mac80211/p54/prism54usb.c
@@ -23,7 +23,6 @@
 
 #include "prism54.h"
 #include "prism54usb.h"
-#include "prism54magic.h"
 
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
 MODULE_DESCRIPTION("Prism54 USB wireless driver");
@@ -745,63 +744,16 @@ static int p54u_upload_firmware_net2280(struct ieee80211_hw *dev)
 	return err;
 }
 
-static int p54u_open_3887(struct ieee80211_hw *dev)
+static int p54u_open(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
-	struct p54_control_hdr *startup_packet;
 	int err;
 
-	startup_packet = kmalloc(sizeof(p54u_3887_magic_packet), GFP_KERNEL);
-	if (!startup_packet) {
-		printk(KERN_ERR "%s: cannot alloc startup packet\n",
-		       wiphy_name(dev->wiphy));
-		return -ENOMEM;
-	}
-
-	err = p54u_init_urbs(dev);
-	if (err) {
-		kfree(startup_packet);
-		return err;
-	}
-
-	memcpy(startup_packet, p54u_3887_magic_packet,
-	       sizeof(p54u_3887_magic_packet));
-	startup_packet->req_id = cpu_to_le32(priv->common.rx_start);
-
-	p54u_tx_3887(dev, startup_packet, sizeof(p54u_3887_magic_packet), 1);
-	priv->common.open = p54u_init_urbs;
-
-	return 0;
-}
-
-static int p54u_open_net2280(struct ieee80211_hw *dev)
-{
-	struct p54u_priv *priv = dev->priv;
-	struct p54_control_hdr *startup_packet;
-	int err;
-
-	startup_packet = kmalloc(sizeof(p54u_net2280_magic_packet) +
-				 priv->common.tx_hdr_len, GFP_KERNEL);
-	if (!startup_packet) {
-		printk(KERN_ERR "%s: cannot alloc startup packet\n",
-		       wiphy_name(dev->wiphy));
-		return -ENOMEM;
-	}
-
 	err = p54u_init_urbs(dev);
 	if (err) {
-		kfree(startup_packet);
 		return err;
 	}
 
-	startup_packet = (void *)startup_packet + priv->common.tx_hdr_len;
-
-	memcpy(startup_packet, p54u_net2280_magic_packet,
-	       sizeof(p54u_net2280_magic_packet));
-	startup_packet->req_id = cpu_to_le32(priv->common.rx_start);
-
-	p54u_tx_net2280(dev, startup_packet,
-			sizeof(p54u_net2280_magic_packet), 1);
 	priv->common.open = p54u_init_urbs;
 
 	return 0;
@@ -857,14 +809,14 @@ static int __devinit p54u_probe(struct usb_interface *intf,
 			recognized_pipes++;
 		}
 	}
+	priv->common.open = p54u_open;
+
 	if (recognized_pipes < P54U_PIPE_NUMBER) {
 		priv->hw_type = P54U_3887;
-		priv->common.open = p54u_open_3887;
 		priv->common.tx = p54u_tx_3887;
 	} else {
 		dev->extra_tx_headroom += sizeof(struct net2280_tx_hdr);
 		priv->common.tx_hdr_len = sizeof(struct net2280_tx_hdr);
-		priv->common.open = p54u_open_net2280;
 		priv->common.tx = p54u_tx_net2280;
 	}
 	priv->common.stop = p54u_stop;

