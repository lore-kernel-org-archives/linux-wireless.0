Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3.versatel.nl ([62.58.50.90]:46012 "EHLO smtp3.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940850AbXHML7e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 07:59:34 -0400
Message-ID: <46C0474B.2000206@hhs.nl>
Date: Mon, 13 Aug 2007 13:58:03 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: Andy Green <andy@warmcat.com>, linux-wireless@vger.kernel.org
Subject: Re: Recent linux-wireless git changes have broken my prism54pci card
References: <46BFF10B.1090307@hhs.nl> <46BFFE4F.802@warmcat.com> <46C00D1E.3000807@hhs.nl> <200708130058.47778.flamingice@sourmilk.net>
In-Reply-To: <200708130058.47778.flamingice@sourmilk.net>
Content-Type: multipart/mixed;
 boundary="------------030806090904040206070609"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030806090904040206070609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Michael Wu wrote:
> On Monday 13 August 2007 00:49, Hans de Goede wrote:
>> I already found that one, but there is no drivers/net/wireless/mac80211 dir
>> there. What am I missing?
>>
> John Linville recently collapsed that directory into driver/net/wireless.
> 
> If you can just find the title of the patches/commits or describe them, that's 
> probably enough for me to find them.
> 

Okay, I still had copies of various git revisions of prism54common.c and .h 
(aka the culprits) on my laptop. I've run some tests again to make sure I had 
the right revisions in mind for the breakage (which I had). I've attached 2 
patches:
diff: with this reversed my speed increases 10x and more importantly when fully
   loading the link (using scp from a local non wireless ethernet machine) it no
   longer looses the connection in a couple of seconds

diff2, when I do not reverse this one, it still associates, but it no longer
   receives / or transmits packages. (no dhcp, no ping when manually assigning
   IP's, etc).

Regards,

Hans

--------------030806090904040206070609
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

--- prism54common.h.orig	2007-07-27 20:47:47.000000000 +0200
+++ prism54common.h	2007-07-27 20:47:46.000000000 +0200
@@ -232,40 +232,44 @@
 
 static const struct ieee80211_rate p54_rates[] = {
 	{ .rate = 10,
-	  .val = 1,
-	  .flags = IEEE80211_RATE_CCK },
+	  .val = 0,
+	  .val2 = 0x10,
+	  .flags = IEEE80211_RATE_CCK_2 },
 	{ .rate = 20,
-	  .val = 2,
-	  .flags = IEEE80211_RATE_CCK },
+	  .val = 1,
+	  .val2 = 0x11,
+	  .flags = IEEE80211_RATE_CCK_2 },
 	{ .rate = 55,
-	  .val = 3,
-	  .flags = IEEE80211_RATE_CCK },
+	  .val = 2,
+	  .val2 = 0x12,
+	  .flags = IEEE80211_RATE_CCK_2 },
 	{ .rate = 110,
-	  .val = 4,
-	  .flags = IEEE80211_RATE_CCK },
+	  .val = 3,
+	  .val2 = 0x13,
+	  .flags = IEEE80211_RATE_CCK_2 },
 	{ .rate = 60,
-	  .val = 5,
+	  .val = 4,
 	  .flags = IEEE80211_RATE_OFDM },
 	{ .rate = 90,
-	  .val = 6,
+	  .val = 5,
 	  .flags = IEEE80211_RATE_OFDM },
 	{ .rate = 120,
-	  .val = 7,
+	  .val = 6,
 	  .flags = IEEE80211_RATE_OFDM },
 	{ .rate = 180,
-	  .val = 8,
+	  .val = 7,
 	  .flags = IEEE80211_RATE_OFDM },
 	{ .rate = 240,
-	  .val = 9,
+	  .val = 8,
 	  .flags = IEEE80211_RATE_OFDM },
 	{ .rate = 360,
-	  .val = 10,
+	  .val = 9,
 	  .flags = IEEE80211_RATE_OFDM },
 	{ .rate = 480,
-	  .val = 11,
+	  .val = 10,
 	  .flags = IEEE80211_RATE_OFDM },
 	{ .rate = 540,
-	  .val = 12,
+	  .val = 11,
 	  .flags = IEEE80211_RATE_OFDM },
 };
 

--------------030806090904040206070609
Content-Type: text/plain;
 name="diff2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff2"

--- prism54common-11-4.c	2007-07-27 20:47:47.000000000 +0200
+++ prism54common-13-6.c	2007-07-27 20:47:47.000000000 +0200
@@ -3,6 +3,7 @@
  * Common code for mac80211 Prism54 drivers
  *
  * Copyright (c) 2006, Michael Wu <flamingice@sourmilk.net>
+ * Copyright (c) 2007, Christian Lamparter <chunkeey@web.de>
  *
  * Based on the islsm (softmac prism54) driver, which is:
  * Copyright 2004-2006 Jean-Baptiste Note <jbnote@gmail.com>, et al.
@@ -283,10 +284,11 @@
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
@@ -294,6 +296,19 @@
 	ieee80211_rx_irqsafe(dev, skb, &rx_status);
 }
 
+static void inline p54_wake_free_queues(struct ieee80211_hw *dev)
+{
+	struct p54_common *priv = dev->priv;
+	int i;
+
+	/* ieee80211_start_queues is great if all queues are really empty.
+	 * But, what if some are full? */
+
+	for (i = 0; i < dev->queues; i++)
+		if (priv->tx_stats.data[i].len < priv->tx_stats.data[i].limit)
+			ieee80211_wake_queue(dev, i);
+}
+
 static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54_common *priv = dev->priv;
@@ -331,6 +346,7 @@
 			status.retry_count = payload->retries - 1;
 			status.ack_signal = le16_to_cpu(payload->ack_rssi);
 			skb_pull(entry, sizeof(*hdr) + sizeof(struct p54_tx_control_allocdata));
+			priv->tx_stats.data[status.control.queue].len--;
 			ieee80211_tx_status_irqsafe(dev, entry, &status);
 			break;
 		} else
@@ -340,7 +356,7 @@
 
 	if (freed >= IEEE80211_MAX_RTS_THRESHOLD + 0x170 +
 	    sizeof(struct p54_control_hdr))
-		ieee80211_wake_queue(dev, 0);
+		p54_wake_free_queues(dev);
 }
 
 static void p54_rx_control(struct ieee80211_hw *dev, struct sk_buff *skb)
@@ -443,7 +459,7 @@
 		__skb_queue_after(&priv->tx_queue, target_skb, skb);
 		if (largest_hole < IEEE80211_MAX_RTS_THRESHOLD + 0x170 +
 				   sizeof(struct p54_control_hdr))
-			ieee80211_stop_queue(dev, 0);
+			ieee80211_stop_queues(dev);
 	}
 	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 
@@ -453,6 +469,7 @@
 static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 		  struct ieee80211_tx_control *control)
 {
+	struct ieee80211_tx_queue_stats_data *current_queue;
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr;
 	struct p54_tx_control_allocdata *txhdr;
@@ -460,6 +477,14 @@
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
 
@@ -493,12 +518,13 @@
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
 
@@ -654,6 +680,64 @@
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
@@ -683,6 +767,7 @@
 
 	p54_set_filter(dev, 0, priv->mac_addr, NULL, 0, 1, 0, 0xF642);
 	p54_set_filter(dev, 0, priv->mac_addr, NULL, 1, 0, 0, 0xF642);
+	p54_set_vdcf(dev);
 
 	switch (conf->type) {
 	case IEEE80211_IF_TYPE_STA:
@@ -712,8 +797,11 @@
 
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
@@ -727,6 +815,26 @@
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
@@ -737,7 +845,13 @@
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
 
@@ -747,6 +861,7 @@
 	.remove_interface	= p54_remove_interface,
 	.config			= p54_config,
 	.config_interface	= p54_config_interface,
+	.conf_tx		= p54_conf_tx,
 	.get_stats		= p54_get_stats,
 	.get_tx_stats		= p54_get_tx_stats
 };
@@ -784,12 +899,29 @@
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
@@ -805,6 +937,7 @@
 	kfree(priv->iq_autocal);
 	kfree(priv->output_limit);
 	kfree(priv->curve_data);
+	kfree(priv->cached_vdcf);
 }
 EXPORT_SYMBOL_GPL(p54_free_common);
 

--------------030806090904040206070609--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
