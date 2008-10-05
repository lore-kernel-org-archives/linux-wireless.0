Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:36081 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbYJEAfu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 20:35:50 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC][PATCH 5/5] p54: integrate parts of lmac_longbow.h and stlc45xx
Date: Sun, 5 Oct 2008 02:39:44 +0200
Cc: Kalle Valo <kalle.valo@nokia.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, tim.dewaal@yahoo.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810050239.44845.chunkeey@web.de> (sfid-20081005_023554_315979_B36E20D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes most/all? of the "magic" numbers and unknown structure 
variables inside the code and replaces them with meaningful prototypes.
Therefore this patch got quite big.

However, I'm not really sure what "(C)" I should put in and where exactly.
But I hope ST's/Nokia's Legal Department or someone else who understands the
laws good enough can give us a green light.
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-10-05 01:45:25.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-10-05 01:45:44.000000000 +0200
@@ -5,8 +5,11 @@
  * Copyright (c) 2006, Michael Wu <flamingice@sourmilk.net>
  * Copyright (c) 2007, Christian Lamparter <chunkeey@web.de>
  *
- * Based on the islsm (softmac prism54) driver, which is:
- * Copyright 2004-2006 Jean-Baptiste Note <jbnote@gmail.com>, et al.
+ * Based on:
+ * - the islsm (softmac prism54) driver, which is:
+ *   Copyright 2004-2006 Jean-Baptiste Note <jbnote@gmail.com>, et al.
+ * - stlc45xx driver
+ *   Copyright (C) 2008 Nokia Corporation and/or its subsidiary(-ies).
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -490,13 +493,13 @@ static int p54_rssi_to_dbm(struct ieee80
 static int p54_rx_data(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54_common *priv = dev->priv;
-	struct p54_rx_hdr *hdr = (struct p54_rx_hdr *) skb->data;
+	struct p54_rx_data *hdr = (struct p54_rx_data *) skb->data;
 	struct ieee80211_rx_status rx_status = {0};
 	u16 freq = le16_to_cpu(hdr->freq);
 	size_t header_len = sizeof(*hdr);
 	u32 tsf32;
 
-	if (!(hdr->magic & cpu_to_le16(0x0001))) {
+	if (!(hdr->flags & cpu_to_le16(P54_HDR_FLAG_DATA_IN_FCS_GOOD))) {
 		if (priv->filter_flags & FIF_FCSFAIL)
 			rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
 		else
@@ -521,7 +524,7 @@ static int p54_rx_data(struct ieee80211_
 
 	rx_status.flag |= RX_FLAG_TSFT;
 
-	if (hdr->magic & cpu_to_le16(0x4000))
+	if (hdr->flags & cpu_to_le16(P54_HDR_FLAG_DATA_ALIGN))
 		header_len += hdr->align[0];
 
 	skb_pull(skb, header_len);
@@ -626,7 +629,7 @@ void p54_free_skb(struct ieee80211_hw *d
 	kfree_skb(skb);
 
 	if (freed >= IEEE80211_MAX_RTS_THRESHOLD + priv->headroom +
-	    priv->tailroom + sizeof(struct p54_control_hdr))
+	    priv->tailroom + sizeof(struct p54_hdr))
 		p54_wake_free_queues(dev);
 }
 EXPORT_SYMBOL(p54_free_skb);
@@ -634,7 +637,7 @@ EXPORT_SYMBOL(p54_free_skb);
 static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54_common *priv = dev->priv;
-	struct p54_control_hdr *hdr = (struct p54_control_hdr *) skb->data;
+	struct p54_hdr *hdr = (struct p54_hdr *) skb->data;
 	struct p54_frame_sent_hdr *payload = (struct p54_frame_sent_hdr *) hdr->data;
 	struct sk_buff *entry = (struct sk_buff *) priv->tx_queue.next;
 	u32 addr = le32_to_cpu(hdr->req_id) - priv->headroom;
@@ -646,8 +649,8 @@ static void p54_rx_frame_sent(struct iee
 	spin_lock_irqsave(&priv->tx_queue.lock, flags);
 	while (entry != (struct sk_buff *)&priv->tx_queue) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(entry);
-		struct p54_control_hdr *entry_hdr;
-		struct p54_tx_control_allocdata *entry_data;
+		struct p54_hdr *entry_hdr;
+		struct p54_tx_data *entry_data;
 		int pad = 0;
 
 		range = (void *)info->driver_data;
@@ -672,21 +675,25 @@ static void p54_rx_frame_sent(struct iee
 		spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 
 		memset(&info->status, 0, sizeof(info->status));
-		entry_hdr = (struct p54_control_hdr *) entry->data;
-		entry_data = (struct p54_tx_control_allocdata *)entry_hdr->data;
-		if (entry_hdr->magic1 & cpu_to_le16(0x4000))
+		entry_hdr = (struct p54_hdr *) entry->data;
+		entry_data = (struct p54_tx_data *) entry_hdr->data;
+		if (entry_hdr->flags & cpu_to_le16(P54_HDR_FLAG_DATA_ALIGN))
 			pad = entry_data->align[0];
 
 		priv->tx_stats[entry_data->hw_queue].len--;
 		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
-			if (!(payload->status & 0x01))
+			if (!(payload->status & P54_TX_FAILED))
 				info->flags |= IEEE80211_TX_STAT_ACK;
-			else
+			else {
 				info->status.excessive_retries = 1;
+				priv->stats.dot11ACKFailureCount++;
+			}
 		}
+		if (payload->status & P54_TX_PSM)
+			info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
 		info->status.retry_count = payload->retries - 1;
 		info->status.ack_signal = p54_rssi_to_dbm(dev,
-				le16_to_cpu(payload->ack_rssi));
+			payload->ack_rssi);
 		skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
 		ieee80211_tx_status_irqsafe(dev, entry);
 		goto out;
@@ -695,14 +702,14 @@ static void p54_rx_frame_sent(struct iee
 
 out:
 	if (freed >= IEEE80211_MAX_RTS_THRESHOLD + priv->headroom +
-	    priv->tailroom + sizeof(struct p54_control_hdr))
+	    priv->tailroom + sizeof(struct p54_hdr))
 		p54_wake_free_queues(dev);
 }
 
 static void p54_rx_eeprom_readback(struct ieee80211_hw *dev,
 				   struct sk_buff *skb)
 {
-	struct p54_control_hdr *hdr = (struct p54_control_hdr *) skb->data;
+	struct p54_hdr *hdr = (struct p54_hdr *) skb->data;
 	struct p54_eeprom_lm86 *eeprom = (struct p54_eeprom_lm86 *) hdr->data;
 	struct p54_common *priv = dev->priv;
 
@@ -717,7 +724,7 @@ static void p54_rx_eeprom_readback(struc
 static void p54_rx_stats(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54_common *priv = dev->priv;
-	struct p54_control_hdr *hdr = (struct p54_control_hdr *) skb->data;
+	struct p54_hdr *hdr = (struct p54_hdr *) skb->data;
 	struct p54_statistics *stats = (struct p54_statistics *) hdr->data;
 	u32 tsf32 = le32_to_cpu(stats->tsf32);
 
@@ -737,7 +744,7 @@ static void p54_rx_stats(struct ieee8021
 
 static int p54_rx_control(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
-	struct p54_control_hdr *hdr = (struct p54_control_hdr *) skb->data;
+	struct p54_hdr *hdr = (struct p54_hdr *) skb->data;
 
 	switch (le16_to_cpu(hdr->type)) {
 	case P54_CONTROL_TYPE_TXDONE:
@@ -763,9 +770,9 @@ static int p54_rx_control(struct ieee802
 /* returns zero if skb can be reused */
 int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
-	u8 type = le16_to_cpu(*((__le16 *)skb->data)) >> 8;
+	u16 type = le16_to_cpu(*((__le16 *)skb->data));
 
-	if (type == 0x80)
+	if (type & P54_HDR_FLAG_CONTROL)
 		return p54_rx_control(dev, skb);
 	else
 		return p54_rx_data(dev, skb);
@@ -782,7 +789,7 @@ EXPORT_SYMBOL_GPL(p54_rx);
  * allocated areas.
  */
 static void p54_assign_address(struct ieee80211_hw *dev, struct sk_buff *skb,
-			       struct p54_control_hdr *data, u32 len)
+			       struct p54_hdr *data, u32 len)
 {
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *entry = priv->tx_queue.next;
@@ -831,8 +838,7 @@ static void p54_assign_address(struct ie
 		range->dev = dev;
 		__skb_queue_after(&priv->tx_queue, target_skb, skb);
 		if (largest_hole < priv->rx_mtu + priv->headroom +
-				   priv->tailroom +
-				   sizeof(struct p54_control_hdr))
+				   priv->tailroom + sizeof(struct p54_hdr))
 			ieee80211_stop_queues(dev);
 	}
 	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
@@ -843,7 +849,7 @@ static void p54_assign_address(struct ie
 int p54_read_eeprom(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
-	struct p54_control_hdr *hdr = NULL;
+	struct p54_hdr *hdr = NULL;
 	struct p54_eeprom_lm86 *eeprom_hdr;
 	struct sk_buff *skb;
 	size_t eeprom_size = 0x2020, offset = 0, blocksize;
@@ -856,7 +862,7 @@ int p54_read_eeprom(struct ieee80211_hw 
 	if (!skb)
 		goto free;
 	skb_reserve(skb, priv->tx_hdr_len);
-	hdr = (struct p54_control_hdr *) skb_put(skb, sizeof(*hdr));
+	hdr = (struct p54_hdr *) skb_put(skb, sizeof(*hdr));
 	priv->eeprom = kzalloc(EEPROM_READBACK_LEN, GFP_KERNEL);
 	if (!priv->eeprom)
 		goto free;
@@ -865,9 +871,9 @@ int p54_read_eeprom(struct ieee80211_hw 
 	if (!eeprom)
 		goto free;
 
-	hdr->magic1 = cpu_to_le16(0x8000);
+	hdr->flags = cpu_to_le16(P54_HDR_FLAG_CONTROL);
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_EEPROM_READBACK);
-	hdr->retry1 = hdr->retry2 = 0;
+	hdr->rts_retries = hdr->retries = 0;
 	eeprom_hdr = (struct p54_eeprom_lm86 *) skb_put(skb,
 		     sizeof(*eeprom_hdr) + EEPROM_READBACK_LEN);
 
@@ -909,9 +915,9 @@ static int p54_tx(struct ieee80211_hw *d
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_queue_stats *current_queue;
 	struct p54_common *priv = dev->priv;
-	struct p54_control_hdr *hdr;
+	struct p54_hdr *hdr;
 	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
-	struct p54_tx_control_allocdata *txhdr;
+	struct p54_tx_data *txhdr;
 	size_t padding, len;
 	u8 rate;
 	u8 cts_rate = 0x20;
@@ -927,17 +933,16 @@ static int p54_tx(struct ieee80211_hw *d
 	padding = (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))) & 3;
 	len = skb->len;
 
-	txhdr = (struct p54_tx_control_allocdata *)
-			skb_push(skb, sizeof(*txhdr) + padding);
-	hdr = (struct p54_control_hdr *) skb_push(skb, sizeof(*hdr));
+	txhdr = (struct p54_tx_data *) skb_push(skb, sizeof(*txhdr) + padding);
+	hdr = (struct p54_hdr *) skb_push(skb, sizeof(*hdr));
 
 	if (padding)
-		hdr->magic1 = cpu_to_le16(0x4010);
+		hdr->flags = cpu_to_le16(P54_HDR_FLAG_DATA_ALIGN);
 	else
-		hdr->magic1 = cpu_to_le16(0x0010);
+		hdr->flags = cpu_to_le16(0);
 	hdr->len = cpu_to_le16(len);
 	hdr->type = (info->flags & IEEE80211_TX_CTL_NO_ACK) ? 0 : cpu_to_le16(1);
-	hdr->retry1 = hdr->retry2 = info->control.retry_limit;
+	hdr->rts_retries = hdr->retries = info->control.retry_limit;
 
 	/* TODO: add support for alternate retry TX rates */
 	rate = ieee80211_get_tx_rate(dev, info)->hw_value;
@@ -951,11 +956,14 @@ static int p54_tx(struct ieee80211_hw *d
 	} else if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT) {
 		rate |= 0x20;
 		cts_rate |= ieee80211_get_rts_cts_rate(dev, info)->hw_value;
-	}
+	} else
+		hdr->flags |= cpu_to_le16(P54_HDR_FLAG_DATA_OUT_BURST);
+
 	memset(txhdr->rateset, rate, 8);
-	memset(txhdr->unalloc0, 0, sizeof(txhdr->unalloc0));
-	memset(txhdr->unalloc1, 0, sizeof(txhdr->unalloc1));
-	memset(txhdr->unalloc2, 0, sizeof(txhdr->unalloc2));
+	memset(txhdr->durations, 0, sizeof(txhdr->durations));
+	txhdr->rts_rate_idx = 0;
+	txhdr->crypt_offset = 0;
+	txhdr->backlog = 32;
 	txhdr->key_type = 0;
 	txhdr->key_len = 0;
 	txhdr->hw_queue = skb_get_queue_mapping(skb) + 4;
@@ -987,89 +995,97 @@ static int p54_tx(struct ieee80211_hw *d
 	return 0;
 }
 
-static int p54_set_filter(struct ieee80211_hw *dev, u16 filter_type,
+static int p54_mac_setup(struct ieee80211_hw *dev, u16 mac_mode,
 			  const u8 *bssid)
 {
 	struct p54_common *priv = dev->priv;
-	struct p54_control_hdr *hdr;
+	struct p54_hdr *hdr;
 	struct sk_buff *skb;
-	struct p54_tx_control_filter *filter;
+	struct p54_setup_mac *setup;
 	size_t data_len;
 
-	skb = __dev_alloc_skb(sizeof(*hdr) + sizeof(*filter) +
+	skb = __dev_alloc_skb(sizeof(*hdr) + sizeof(*setup) +
 		      priv->tx_hdr_len, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
-
 	skb_reserve(skb, priv->tx_hdr_len);
-	hdr = (struct p54_control_hdr *) skb_put(skb, sizeof(*hdr));
-	hdr->magic1 = cpu_to_le16(0x8001);
-	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_FILTER_SET);
-	hdr->retry1 = hdr->retry2 = 0;
-
-	filter = (struct p54_tx_control_filter *) skb_put(skb, sizeof(*filter));
-	filter->filter_type = priv->filter_type = cpu_to_le16(filter_type);
-	memcpy(filter->mac_addr, priv->mac_addr, ETH_ALEN);
+
+	priv->mac_mode = mac_mode;
+	hdr = (struct p54_hdr *) skb_put(skb, sizeof(*hdr));
+	hdr->flags = cpu_to_le16(P54_HDR_FLAG_CONTROL_OPSET);
+	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_SETUP);
+	hdr->rts_retries = hdr->retries = 0;
+
+	setup = (struct p54_setup_mac *) skb_put(skb, sizeof(*setup));
+	setup->mac_mode = cpu_to_le16(mac_mode);
+	memcpy(setup->mac_addr, priv->mac_addr, ETH_ALEN);
 	if (!bssid)
-		memset(filter->bssid, ~0, ETH_ALEN);
+		memset(setup->bssid, ~0, ETH_ALEN);
 	else
-		memcpy(filter->bssid, bssid, ETH_ALEN);
+		memcpy(setup->bssid, bssid, ETH_ALEN);
 
-	filter->rx_antenna = priv->rx_antenna;
+	setup->rx_antenna = priv->rx_antenna;
+	setup->rx_align = 0;
 
 	if (priv->fw_var < 0x500) {
-		data_len = P54_TX_CONTROL_FILTER_V1_LEN;
-		filter->v1.basic_rate_mask = cpu_to_le32(0x15F);
-		filter->v1.rx_addr = cpu_to_le32(priv->rx_end);
-		filter->v1.max_rx = cpu_to_le16(priv->rx_mtu);
-		filter->v1.rxhw = cpu_to_le16(priv->rxhw);
-		filter->v1.wakeup_timer = cpu_to_le16(500);
+		data_len = P54_SETUP_V1_LEN;
+		setup->v1.basic_rate_mask = cpu_to_le32(0x15f);
+		memset(setup->v1.rts_rates, 0, sizeof(setup->v1.rts_rates));
+		setup->v1.rx_addr = cpu_to_le32(priv->rx_end);
+		setup->v1.max_rx = cpu_to_le16(priv->rx_mtu);
+		setup->v1.rxhw = cpu_to_le16(priv->rxhw);
+		setup->v1.wakeup_timer = cpu_to_le16(500);
 	} else {
-		data_len = P54_TX_CONTROL_FILTER_V2_LEN;
-		filter->v2.rx_addr = cpu_to_le32(priv->rx_end);
-		filter->v2.max_rx = cpu_to_le16(priv->rx_mtu);
-		filter->v2.rxhw = cpu_to_le16(priv->rxhw);
-		filter->v2.timer = cpu_to_le16(1000);
+		data_len = P54_SETUP_V2_LEN;
+		setup->v2.rx_addr = cpu_to_le32(priv->rx_end);
+		setup->v2.max_rx = cpu_to_le16(priv->rx_mtu);
+		setup->v2.rxhw = cpu_to_le16(priv->rxhw);
+		setup->v2.timer = cpu_to_le16(1000);
+		setup->v2.basic_rate_mask = cpu_to_le32(0x15f);
+		setup->v2.truncate = cpu_to_le16(48896);
+		setup->v2.mcast_window = 0;
+		setup->v2.sbss_offset = 0;
+		setup->v2.ref_clock = cpu_to_le32(644245094);
+		setup->v2.lpf_bandwidth = cpu_to_le16(65535);
+		setup->v2.osc_start_delay = cpu_to_le16(65535);
+
 	}
 
 	hdr->len = cpu_to_le16(data_len);
 	p54_assign_address(dev, skb, hdr, sizeof(*hdr) + data_len);
-
 	priv->tx(dev, hdr, skb, sizeof(*hdr) + data_len, 1);
 	return 0;
 }
 
-static int p54_set_freq(struct ieee80211_hw *dev, __le16 freq)
+static int p54_scan(struct ieee80211_hw *dev, __le16 freq)
 {
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *skb;
-	struct p54_control_hdr *hdr;
-	struct p54_tx_control_channel *chan;
+	struct p54_hdr *hdr;
+	struct p54_scan *scan;
 	unsigned int i;
 	size_t data_len;
 	void *entry;
 
-	skb = dev_alloc_skb(priv->tx_hdr_len + sizeof(*hdr) + sizeof(*chan));
-
+	skb = dev_alloc_skb(priv->tx_hdr_len + sizeof(*hdr) + sizeof(*scan));
 	if (!skb)
 		return -ENOMEM;
-
 	skb_reserve(skb, priv->tx_hdr_len);
 
-	hdr = (struct p54_control_hdr *)skb_put(skb, sizeof(*hdr));
-	hdr->magic1 = cpu_to_le16(0x8001);
-	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_CHANNEL_CHANGE);
-	hdr->retry1 = hdr->retry2 = 0;
-	chan = (struct p54_tx_control_channel *) skb_put(skb, sizeof(*chan));
-	memset(chan->padding1, 0, sizeof(chan->padding1));
-	chan->flags = cpu_to_le16(0x1);
-	chan->dwell = cpu_to_le16(0x0);
+	hdr = (struct p54_hdr *) skb_put(skb, sizeof(*hdr));
+	hdr->flags = cpu_to_le16(P54_HDR_FLAG_CONTROL_OPSET);
+	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_SCAN);
+	hdr->rts_retries = hdr->retries = 0;
+	scan = (struct p54_scan *) skb_put(skb, sizeof(*scan));
+	memset(scan->padding, 0, sizeof(scan->padding));
+	scan->mode = cpu_to_le16(0x1);
+	scan->dwell = cpu_to_le16(0x0);
 
 	for (i = 0; i < priv->iq_autocal_len; i++) {
 		if (priv->iq_autocal[i].freq != freq)
 			continue;
 
-		memcpy(&chan->iq_autocal, &priv->iq_autocal[i],
+		memcpy(&scan->iq_autocal, &priv->iq_autocal[i],
 		       sizeof(*priv->iq_autocal));
 		break;
 	}
@@ -1080,14 +1096,14 @@ static int p54_set_freq(struct ieee80211
 		if (priv->output_limit[i].freq != freq)
 			continue;
 
-		chan->val_barker = 0x38;
-		chan->val_bpsk = chan->dup_bpsk =
+		scan->val_barker = 0x38;
+		scan->val_bpsk = scan->dup_bpsk =
 			priv->output_limit[i].val_bpsk;
-		chan->val_qpsk = chan->dup_qpsk =
+		scan->val_qpsk = scan->dup_qpsk =
 			priv->output_limit[i].val_qpsk;
-		chan->val_16qam = chan->dup_16qam =
+		scan->val_16qam = scan->dup_16qam =
 			priv->output_limit[i].val_16qam;
-		chan->val_64qam = chan->dup_64qam =
+		scan->val_64qam = scan->dup_64qam =
 			priv->output_limit[i].val_64qam;
 		break;
 	}
@@ -1096,6 +1112,7 @@ static int p54_set_freq(struct ieee80211
 
 	entry = priv->curve_data->data;
 	for (i = 0; i < priv->curve_data->channels; i++) {
+		u8 j;
 		if (*((__le16 *)entry) != freq) {
 			entry += sizeof(__le16);
 			entry += sizeof(struct p54_pa_curve_data_sample) *
@@ -1104,23 +1121,23 @@ static int p54_set_freq(struct ieee80211
 		}
 
 		entry += sizeof(__le16);
-		chan->pa_points_per_curve =
-			min(priv->curve_data->points_per_channel, (u8) 8);
+		j = min(priv->curve_data->points_per_channel, (u8) 8);
+		scan->pa_points_per_curve = 8;
 
-		memcpy(chan->curve_data, entry, sizeof(*chan->curve_data) *
-		       chan->pa_points_per_curve);
+		memcpy(scan->curve_data, entry, sizeof(*scan->curve_data) * j);
 		break;
 	}
 
 	if (priv->fw_var < 0x500) {
-		data_len = P54_TX_CONTROL_CHANNEL_V1_LEN;
-		chan->v1.rssical_mul = cpu_to_le16(130);
-		chan->v1.rssical_add = cpu_to_le16(0xfe70);
+		data_len = P54_SCAN_V1_LEN;
+		scan->v1.rssical_mul = cpu_to_le16(130);
+		scan->v1.rssical_add = cpu_to_le16(0xfe70);
 	} else {
-		data_len = P54_TX_CONTROL_CHANNEL_V2_LEN;
-		chan->v2.rssical_mul = cpu_to_le16(130);
-		chan->v2.rssical_add = cpu_to_le16(0xfe70);
-		chan->v2.basic_rate_mask = cpu_to_le32(0x15f);
+		data_len = P54_SCAN_V2_LEN;
+		scan->v2.rssical_mul = cpu_to_le16(130);
+		scan->v2.rssical_add = cpu_to_le16(0xfe70);
+		scan->v2.basic_rate_mask = cpu_to_le32(0x15f);
+		memset(scan->v2.rts_rates, 0, sizeof(scan->v2.rts_rates));
 	}
 
 	hdr->len = cpu_to_le16(data_len);
@@ -1138,23 +1155,22 @@ static int p54_set_leds(struct ieee80211
 {
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *skb;
-	struct p54_control_hdr *hdr;
-	struct p54_tx_control_led *led;
+	struct p54_hdr *hdr;
+	struct p54_led *led;
 
 	skb = dev_alloc_skb(sizeof(*hdr) + sizeof(*led) +
 		      priv->tx_hdr_len);
 	if (!skb)
 		return -ENOMEM;
-
 	skb_reserve(skb, priv->tx_hdr_len);
 
-	hdr = (void *)skb_put(skb, sizeof(*hdr) + sizeof(*led));
-	hdr->magic1 = cpu_to_le16(0x8001);
+	hdr = (struct p54_hdr *)skb_put(skb, sizeof(*hdr) + sizeof(*led));
+	hdr->flags = cpu_to_le16(P54_HDR_FLAG_CONTROL_OPSET);
 	hdr->len = cpu_to_le16(sizeof(*led));
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_LED);
-	hdr->retry1 = hdr->retry2 = 0;
+	hdr->rts_retries = hdr->retries = 0;
 
-	led = (struct p54_tx_control_led *) hdr->data;
+	led = (struct p54_led *) hdr->data;
 	led->mode = cpu_to_le16(mode);
 	led->led_permanent = cpu_to_le16(link);
 	led->led_temporary = cpu_to_le16(act);
@@ -1162,7 +1178,6 @@ static int p54_set_leds(struct ieee80211
 
 	p54_assign_address(dev, skb, hdr, skb->len);
 	priv->tx(dev, hdr, skb, skb->len, 1);
-
 	return 0;
 }
 
@@ -1174,42 +1189,40 @@ do {	 							\
 	queue.txop = cpu_to_le16(_txop);			\
 } while(0)
 
-static int p54_set_vdcf(struct ieee80211_hw *dev)
+static int p54_set_edcf(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
-	struct p54_control_hdr *hdr;
-	struct p54_tx_control_vdcf *vdcf;
+	struct p54_hdr *hdr;
+	struct p54_edcf *edcf;
 	struct sk_buff *skb;
 
-	skb = dev_alloc_skb(priv->tx_hdr_len +
-			sizeof(struct p54_control_hdr) +
-			sizeof(struct p54_tx_control_vdcf));
-
+	skb = dev_alloc_skb(priv->tx_hdr_len + sizeof(struct p54_hdr) +
+			sizeof(struct p54_edcf));
 	if (!skb)
 		return -ENOMEM;
 	skb_reserve(skb, priv->tx_hdr_len);
 
-	hdr = (struct p54_control_hdr *) skb_put(skb, sizeof(*hdr));
-	hdr->magic1 = cpu_to_le16(0x8001);
-	hdr->len = cpu_to_le16(sizeof(*vdcf));
+	hdr = (struct p54_hdr *) skb_put(skb, sizeof(*hdr));
+	hdr->flags = cpu_to_le16(P54_HDR_FLAG_CONTROL_OPSET);
+	hdr->len = cpu_to_le16(sizeof(*edcf));
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_DCFINIT);
-	hdr->retry1 = hdr->retry2 = 0;
+	hdr->rts_retries = hdr->retries = 0;
 
-	vdcf = (struct p54_tx_control_vdcf *) skb_put(skb, sizeof(*vdcf));
-	vdcf->round_trip_delay = cpu_to_le16(0);
-	memset(vdcf->mapping, 0, sizeof(vdcf->mapping));
-	memcpy(vdcf->queue, priv->qos_params, sizeof(vdcf->queue));
+	edcf = (struct p54_edcf *) skb_put(skb, sizeof(*edcf));
+	edcf->round_trip_delay = cpu_to_le16(0);
+	memset(edcf->mapping, 0, sizeof(edcf->mapping));
+	memcpy(edcf->queue, priv->qos_params, sizeof(edcf->queue));
 	if (dev->conf.flags & IEEE80211_CONF_SHORT_SLOT_TIME) {
-		vdcf->slottime = 9;
-		vdcf->sifs = 0x10;
-		vdcf->eofpad = 0x00;
+		edcf->slottime = 9;
+		edcf->sifs = 0x10;
+		edcf->eofpad = 0x00;
 	} else {
-		vdcf->slottime = 20;
-		vdcf->sifs = 0x0a;
-		vdcf->eofpad = 0x06;
+		edcf->slottime = 20;
+		edcf->sifs = 0x0a;
+		edcf->eofpad = 0x06;
 	}
 	/* (see prism54/isl_oid.h for further details) */
-	vdcf->frameburst = cpu_to_le16(0);
+	edcf->frameburst = cpu_to_le16(0);
 
 	p54_assign_address(dev, skb, hdr, skb->len);
 	priv->tx(dev, hdr, skb, skb->len, 1);
@@ -1219,11 +1232,11 @@ static int p54_set_vdcf(struct ieee80211
 static int p54_init_stats(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
-	struct p54_control_hdr *hdr;
+	struct p54_hdr *hdr;
 	struct p54_statistics *stats;
 
 	priv->cached_stats = dev_alloc_skb(priv->tx_hdr_len +
-			sizeof(struct p54_control_hdr) +
+			sizeof(struct p54_hdr) +
 			sizeof(struct p54_statistics));
 
 	if (!priv->cached_stats)
@@ -1231,18 +1244,17 @@ static int p54_init_stats(struct ieee802
 
 	skb_reserve(priv->cached_stats, priv->tx_hdr_len);
 
-	hdr = (void *) skb_put(priv->cached_stats, sizeof(*hdr));
-	hdr->magic1 = cpu_to_le16(0x8000);
+	hdr = (struct p54_hdr *) skb_put(priv->cached_stats, sizeof(*hdr));
+	hdr->flags = cpu_to_le16(P54_HDR_FLAG_CONTROL);
 	hdr->len = cpu_to_le16(sizeof(*stats));
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_STAT_READBACK);
-	hdr->retry1 = hdr->retry2 = 0;
-	stats = (void *) skb_put(priv->cached_stats, sizeof(*stats));
+	hdr->rts_retries = hdr->retries = 0;
+	stats = (struct p54_statistics *)
+		skb_put(priv->cached_stats, sizeof(*stats));
 
 	p54_assign_address(dev, priv->cached_stats,
 			   hdr, priv->cached_stats->len);
-
 	mod_timer(&priv->stats_timer, jiffies + HZ);
-
 	return 0;
 }
 
@@ -1259,7 +1271,7 @@ static int p54_start(struct ieee80211_hw
 	P54_SET_QUEUE(priv->qos_params[1], 0x0002, 0x0007, 0x000f, 94);
 	P54_SET_QUEUE(priv->qos_params[2], 0x0003, 0x000f, 0x03ff, 0);
 	P54_SET_QUEUE(priv->qos_params[3], 0x0007, 0x000f, 0x03ff, 0);
-	err = p54_set_vdcf(dev);
+	err = p54_set_edcf(dev);
 	if (!err)
 		err = p54_init_stats(dev);
 
@@ -1300,11 +1312,11 @@ static int p54_add_interface(struct ieee
 
 	memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
 
-	p54_set_filter(dev, 0, NULL);
+	p54_mac_setup(dev, P54_FILTER_TYPE_NONE, NULL);
 
 	switch (conf->type) {
 	case NL80211_IFTYPE_STATION:
-		p54_set_filter(dev, 1, NULL);
+		p54_mac_setup(dev, P54_FILTER_TYPE_STATION, NULL);
 		break;
 	default:
 		BUG();	/* impossible */
@@ -1322,7 +1334,7 @@ static void p54_remove_interface(struct 
 	struct p54_common *priv = dev->priv;
 	priv->mode = NL80211_IFTYPE_MONITOR;
 	memset(priv->mac_addr, 0, ETH_ALEN);
-	p54_set_filter(dev, 0, NULL);
+	p54_mac_setup(dev, P54_FILTER_TYPE_NONE, NULL);
 }
 
 static int p54_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
@@ -1334,9 +1346,9 @@ static int p54_config(struct ieee80211_h
 	priv->rx_antenna = (conf->antenna_sel_rx == 0) ?
 		2 : conf->antenna_sel_tx - 1;
 	priv->output_power = conf->power_level << 2;
-	ret = p54_set_freq(dev, cpu_to_le16(conf->channel->center_freq));
+	ret = p54_scan(dev, cpu_to_le16(conf->channel->center_freq));
 	if (!ret)
-		ret = p54_set_vdcf(dev);
+		ret = p54_set_edcf(dev);
 	mutex_unlock(&priv->conf_mutex);
 	return ret;
 }
@@ -1348,7 +1360,7 @@ static int p54_config_interface(struct i
 	struct p54_common *priv = dev->priv;
 
 	mutex_lock(&priv->conf_mutex);
-	p54_set_filter(dev, 0, conf->bssid);
+	p54_mac_setup(dev, P54_FILTER_TYPE_STATION, conf->bssid);
 	p54_set_leds(dev, 1, !is_multicast_ether_addr(conf->bssid), 0);
 	memcpy(priv->bssid, conf->bssid, ETH_ALEN);
 	mutex_unlock(&priv->conf_mutex);
@@ -1370,20 +1382,20 @@ static void p54_configure_filter(struct 
 
 	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
 		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
-			p54_set_filter(dev, le16_to_cpu(priv->filter_type),
+			p54_mac_setup(dev, priv->mac_mode,
 				 NULL);
 		else
-			p54_set_filter(dev, le16_to_cpu(priv->filter_type),
+			p54_mac_setup(dev, priv->mac_mode,
 				 priv->bssid);
 	}
 
 	if (changed_flags & FIF_PROMISC_IN_BSS) {
 		if (*total_flags & FIF_PROMISC_IN_BSS)
-			p54_set_filter(dev, le16_to_cpu(priv->filter_type) |
-				0x8, NULL);
+			p54_mac_setup(dev, priv->mac_mode |
+				P54_FILTER_TYPE_TRANSPARENT, NULL);
 		else
-			p54_set_filter(dev, le16_to_cpu(priv->filter_type) &
-				~0x8, priv->bssid);
+			p54_mac_setup(dev, priv->mac_mode &
+				~P54_FILTER_TYPE_TRANSPARENT, priv->bssid);
 	}
 }
 
@@ -1398,31 +1410,30 @@ static int p54_conf_tx(struct ieee80211_
 	} else
 		return -EINVAL;
 
-	return p54_set_vdcf(dev);
+	return p54_set_edcf(dev);
 }
 
 static int p54_init_xbow_synth(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *skb;
-	struct p54_control_hdr *hdr;
-	struct p54_tx_control_xbow_synth *xbow;
+	struct p54_hdr *hdr;
+	struct p54_xbow_synth *xbow;
 
 	skb = dev_alloc_skb(priv->tx_hdr_len + sizeof(*hdr) + sizeof(*xbow));
 	if (!skb)
 		return -ENOMEM;
 	skb_reserve(skb, priv->tx_hdr_len);
 
-	hdr = (struct p54_control_hdr *)skb_put(skb, sizeof(*hdr));
-	hdr->magic1 = cpu_to_le16(0x8001);
+	hdr = (struct p54_hdr *) skb_put(skb, sizeof(*hdr));
+	hdr->flags = cpu_to_le16(P54_HDR_FLAG_CONTROL_OPSET);
 	hdr->len = cpu_to_le16(sizeof(*xbow));
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_XBOW_SYNTH_CFG);
-	hdr->retry1 = hdr->retry2 = 0;
-	xbow = (struct p54_tx_control_xbow_synth *)skb_put(skb, sizeof(*xbow));
+	hdr->rts_retries = hdr->retries = 0;
+	xbow = (struct p54_xbow_synth *) skb_put(skb, sizeof(*xbow));
 	xbow->magic1 = cpu_to_le16(0x1);
 	xbow->magic2 = cpu_to_le16(0x2);
 	xbow->freq = cpu_to_le16(5390);
-	memset(xbow->padding, 0, sizeof(xbow->padding));
 
 	p54_assign_address(dev, skb, hdr, sizeof(*hdr) + sizeof(*xbow));
 	priv->tx(dev, hdr, skb, sizeof(*hdr) + sizeof(*xbow), 1);
@@ -1433,11 +1444,11 @@ static void p54_statistics_timer(unsigne
 {
 	struct ieee80211_hw *dev = (struct ieee80211_hw *) data;
 	struct p54_common *priv = dev->priv;
-	struct p54_control_hdr *hdr;
+	struct p54_hdr *hdr;
 
 	BUG_ON(!priv->cached_stats);
 
-	hdr = (struct p54_control_hdr *)priv->cached_stats->data;
+	hdr = (struct p54_hdr *)priv->cached_stats->data;
 	priv->tx(dev, hdr, priv->cached_stats, priv->cached_stats->len, 0);
 }
 
@@ -1512,8 +1523,8 @@ struct ieee80211_hw *p54_init_common(siz
 	priv->tx_stats[4].limit = 5;
 	dev->queues = 1;
 	priv->noise = -94;
-	dev->extra_tx_headroom = sizeof(struct p54_control_hdr) + 4 +
-				 sizeof(struct p54_tx_control_allocdata);
+	dev->extra_tx_headroom = sizeof(struct p54_hdr) + 4 +
+				 sizeof(struct p54_tx_data);
 
 	mutex_init(&priv->conf_mutex);
 	init_completion(&priv->eeprom_comp);
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-10-04 01:03:45.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.h	2008-10-05 01:21:01.000000000 +0200
@@ -34,6 +34,13 @@ struct bootrec_exp_if {
 	__le16 top_compat;
 } __attribute__((packed));
 
+#define BR_DESC_PRIV_CAP_WEP		BIT(0)
+#define BR_DESC_PRIV_CAP_TKIP		BIT(1)
+#define BR_DESC_PRIV_CAP_MICHAEL	BIT(2)
+#define BR_DESC_PRIV_CAP_CCX_CP		BIT(3)
+#define BR_DESC_PRIV_CAP_CCX_MIC	BIT(4)
+#define BR_DESC_PRIV_CAP_AESCCMP	BIT(5)
+
 struct bootrec_desc {
 	__le16 modes;
 	__le16 flags;
@@ -41,7 +48,12 @@ struct bootrec_desc {
 	__le32 rx_end;
 	u8 headroom;
 	u8 tailroom;
-	u8 unimportant[6];
+	u8 tx_queues;
+	u8 tx_depth;
+	u8 privacy_caps;
+	u8 rx_keycache_size;
+	u8 time_size;
+	u8 padding;
 	u8 rates[16];
 } __attribute__((packed));
 
@@ -55,6 +67,34 @@ struct bootrec_desc {
 #define BR_CODE_END_OF_BRA		0xFF0000FF
 #define LEGACY_BR_CODE_END_OF_BRA	0xFFFFFFFF
 
+#define P54_HDR_FLAG_CONTROL		BIT(15)
+#define P54_HDR_FLAG_CONTROL_OPSET	(BIT(15) + BIT(0))
+
+#define P54_HDR_FLAG_DATA_ALIGN		BIT(14)
+#define P54_HDR_FLAG_DATA_OUT_PROMISC	BIT(0)
+#define P54_HDR_FLAG_DATA_OUT_TIMESTAMP BIT(1)
+#define P54_HDR_FLAG_DATA_OUT_SEQNR	BIT(2)
+#define P54_HDR_FLAG_DATA_OUT_BIT3	BIT(3)
+#define P54_HDR_FLAG_DATA_OUT_BURST	BIT(4)
+#define P54_HDR_FLAG_DATA_OUT_NOCANCEL	BIT(5)
+#define P54_HDR_FLAG_DATA_OUT_CLEARTIM	BIT(6)
+#define P54_HDR_FLAG_DATA_OUT_HITCHHIKE	BIT(7)
+#define P54_HDR_FLAG_DATA_OUT_COMPRESS	BIT(8)
+#define P54_HDR_FLAG_DATA_OUT_CONCAT	BIT(9)
+#define P54_HDR_FLAG_DATA_OUT_PCS_ACCEPT BIT(10)
+#define P54_HDR_FLAG_DATA_OUT_WAITEOSP	BIT(11)
+
+#define P54_HDR_FLAG_DATA_IN_FCS_GOOD	BIT(0)
+#define P54_HDR_FLAG_DATA_IN_MATCH_MAC	BIT(1)
+#define P54_HDR_FLAG_DATA_IN_MCBC	BIT(2)
+#define P54_HDR_FLAG_DATA_IN_BEACON	BIT(3)
+#define P54_HDR_FLAG_DATA_IN_MATCH_BSS	BIT(4)
+#define P54_HDR_FLAG_DATA_IN_BCAST_BSS	BIT(5)
+#define P54_HDR_FLAG_DATA_IN_DATA	BIT(6)
+#define P54_HDR_FLAG_DATA_IN_TRUNCATED	BIT(7)
+#define P54_HDR_FLAG_DATA_IN_BIT8	BIT(8)
+#define P54_HDR_FLAG_DATA_IN_TRANSPARENT BIT(9)
+
 /* PDA defines are Copyright (C) 2005 Nokia Corporation (taken from islsm_pda.h) */
 
 struct pda_entry {
@@ -175,36 +215,91 @@ struct p54_eeprom_lm86 {
 	u8 data[0];
 } __attribute__ ((packed));
 
-struct p54_rx_hdr {
-	__le16 magic;
+enum p54_rx_decrypt_status {
+	P54_DECRYPT_NONE = 0,
+	P54_DECRYPT_OK,
+	P54_DECRYPT_NOKEY,
+	P54_DECRYPT_NOMICHAEL,
+	P54_DECRYPT_NOCKIPMIC,
+	P54_DECRYPT_FAIL_WEP,
+	P54_DECRYPT_FAIL_TKIP,
+	P54_DECRYPT_FAIL_MICAHEL,
+	P54_DECRYPT_FAIL_CKIPKP,
+	P54_DECRYPT_FAIL_CKIPMIC,
+	P54_DECRYPT_FAIL_AESCCMP
+};
+
+struct p54_rx_data {
+	__le16 flags;
 	__le16 len;
 	__le16 freq;
 	u8 antenna;
 	u8 rate;
 	u8 rssi;
 	u8 quality;
-	u16 unknown2;
+	u8 decrypt_status;
+	u8 rssi_raw;
 	__le32 tsf32;
 	__le32 unalloc0;
 	u8 align[0];
 } __attribute__ ((packed));
 
+enum p54_trap_type {
+	P54_TRAP_SCAN = 0,
+	P54_TRAP_TIMER,
+	P54_TRAP_BEACON_TX,
+	P54_TRAP_FAA_RADIO_ON,
+	P54_TRAP_FAA_RADIO_OFF,
+	P54_TRAP_RADAR,
+	P54_TRAP_NO_BEACON,
+	P54_TRAP_TBTT,
+	P54_TRAP_SCO_ENTER,
+	P54_TRAP_SCO_EXIT
+};
+
+struct p54_trap {
+	__le16 event;
+	__le16 frequency;
+} __attribute__ ((packed));
+
+enum p54_frame_sent_status {
+	P54_TX_OK = 0,
+	P54_TX_FAILED,
+	P54_TX_PSM,
+	P54_TX_PSM_CANCELLED
+};
+
 struct p54_frame_sent_hdr {
 	u8 status;
 	u8 retries;
-	__le16 ack_rssi;
+	u8 ack_rssi;
+	u8 quality;
 	__le16 seq;
-	u16 rate;
+	u8 antenna;
+	u8 padding;
 } __attribute__ ((packed));
 
-struct p54_tx_control_allocdata {
+enum  p54_tx_data_crypt {
+	P54_CRYPTO_NONE = 0,
+	P54_CRYPTO_WEP,
+	P54_CRYPTO_TKIP,
+	P54_CRYPTO_TKIPMICHAEL,
+	P54_CRYPTO_CCX_WEPMIC,
+	P54_CRYPTO_CCX_KPMIC,
+	P54_CRYPTO_CCX_KP,
+	P54_CRYPTO_AESCCMP
+};
+
+struct p54_tx_data {
 	u8 rateset[8];
-	u8 unalloc0[2];
+	u8 rts_rate_idx;
+	u8 crypt_offset;
 	u8 key_type;
 	u8 key_len;
 	u8 key[16];
 	u8 hw_queue;
-	u8 unalloc1[9];
+	u8 backlog;
+	__le16 durations[4];
 	u8 tx_antenna;
 	u8 output_power;
 	u8 cts_rate;
@@ -212,8 +307,18 @@ struct p54_tx_control_allocdata {
 	u8 align[0];
 } __attribute__ ((packed));
 
-struct p54_tx_control_filter {
-	__le16 filter_type;
+#define P54_FILTER_TYPE_NONE		0
+#define P54_FILTER_TYPE_STATION		BIT(0)
+#define P54_FILTER_TYPE_IBSS		BIT(1)
+#define P54_FILTER_TYPE_AP		BIT(2)
+#define P54_FILTER_TYPE_TRANSPARENT	BIT(3)
+#define P54_FILTER_TYPE_PROMISCUOUS	BIT(4)
+#define P54_FILTER_TYPE_HIBERNATE	BIT(5)
+#define P54_FILTER_TYPE_NOACK		BIT(6)
+#define P54_FILTER_TYPE_RX_DISABLED	BIT(7)
+
+struct p54_setup_mac {
+	__le16 mac_mode;
 	u8 mac_addr[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
 	u8 rx_antenna;
@@ -233,19 +338,31 @@ struct p54_tx_control_filter {
 			__le16 max_rx;
 			__le16 rxhw;
 			__le16 timer;
-			__le16 unalloc0;
-			__le32 unalloc1;
+			__le16 truncate;
+			__le32 basic_rate_mask;
+			u8 sbss_offset;
+			u8 mcast_window;
+			u8 rx_rssi_threshold;
+			u8 rx_ed_threshold;
+			__le32 ref_clock;
+			__le16 lpf_bandwidth;
+			__le16 osc_start_delay;
 		} v2 __attribute__ ((packed));
 	} __attribute__ ((packed));
 } __attribute__ ((packed));
 
-#define P54_TX_CONTROL_FILTER_V1_LEN (sizeof(struct p54_tx_control_filter))
-#define P54_TX_CONTROL_FILTER_V2_LEN (sizeof(struct p54_tx_control_filter)-8)
+#define P54_SETUP_V1_LEN 40
+#define P54_SETUP_V2_LEN (sizeof(struct p54_setup_mac))
 
-struct p54_tx_control_channel {
-	__le16 flags;
+#define P54_SCAN_EXIT	BIT(0)
+#define P54_SCAN_TRAP	BIT(1)
+#define P54_SCAN_ACTIVE BIT(2)
+#define P54_SCAN_FILTER BIT(3)
+
+struct p54_scan {
+	__le16 mode;
 	__le16 dwell;
-	u8 padding1[20];
+	u8 padding[20];
 	struct pda_iq_autocal_entry iq_autocal;
 	u8 pa_points_per_curve;
 	u8 val_barker;
@@ -266,29 +383,29 @@ struct p54_tx_control_channel {
 
 		struct {
 			__le32 basic_rate_mask;
-			 u8 rts_rates[8];
+			u8 rts_rates[8];
 			__le16 rssical_mul;
 			__le16 rssical_add;
 		} v2 __attribute__ ((packed));
 	} __attribute__ ((packed));
 } __attribute__ ((packed));
 
-#define P54_TX_CONTROL_CHANNEL_V1_LEN (sizeof(struct p54_tx_control_channel)-12)
-#define P54_TX_CONTROL_CHANNEL_V2_LEN (sizeof(struct p54_tx_control_channel))
+#define P54_SCAN_V1_LEN (sizeof(struct p54_scan)-12)
+#define P54_SCAN_V2_LEN (sizeof(struct p54_scan))
 
-struct p54_tx_control_led {
+struct p54_led {
 	__le16 mode;
 	__le16 led_temporary;
 	__le16 led_permanent;
 	__le16 duration;
 } __attribute__ ((packed));
 
-struct p54_tx_control_vdcf {
+struct p54_edcf {
 	u8 flags;
 	u8 slottime;
 	u8 sifs;
 	u8 eofpad;
-	struct p54_tx_vdcf_queues queue[8];
+	struct p54_edcf_queue_param queue[8];
 	u8 mapping[4];
 	__le16 frameburst;
 	__le16 round_trip_delay;
@@ -304,14 +421,103 @@ struct p54_statistics {
 	__le32 tsf32;
 	__le32 airtime;
 	__le32 noise;
-	__le32 unkn[10]; /* CCE / CCA / RADAR */
+	__le32 sample_noise[8];
+	__le32 sample_cca;
+	__le32 sample_tx;
 } __attribute__ ((packed));
 
-struct p54_tx_control_xbow_synth {
+struct p54_xbow_synth {
 	__le16 magic1;
 	__le16 magic2;
 	__le16 freq;
 	u32 padding[5];
 } __attribute__ ((packed));
 
+struct p54_timer {
+	__le32 interval;
+} __attribute__ ((packed));
+
+struct p54_keycache {
+	u8 entry;
+	u8 key_id;
+	u8 mac[ETH_ALEN];
+	u8 padding[2];
+	u8 key_type;
+	u8 key_len;
+	u8 key[24];
+} __attribute__ ((packed));
+
+struct p54_burst {
+	u8 flags;
+	u8 queue;
+	u8 backlog;
+	u8 pad;
+	__le16 durations[32];
+} __attribute__ ((packed));
+
+struct p54_psm_interval {
+	__le16 interval;
+	__le16 periods;
+} __attribute__ ((packed));
+
+#define P54_PSM				BIT(0)
+#define P54_PSM_DTIM			BIT(1)
+#define P54_PSM_MCBC			BIT(2)
+#define P54_PSM_CHECKSUM		BIT(3)
+#define P54_PSM_SKIP_MORE_DATA		BIT(4)
+#define P54_PSM_BEACON_TIMEOUT		BIT(5)
+#define P54_PSM_HFOSLEEP		BIT(6)
+#define P54_PSM_AUTOSWITCH_SLEEP	BIT(7)
+#define P54_PSM_LPIT			BIT(8)
+#define P54_PSM_BF_UCAST_SKIP		BIT(9)
+#define P54_PSM_BF_MCAST_SKIP		BIT(10)
+
+struct p54_psm {
+	__le16 mode;
+	__le16 aid;
+	struct p54_psm_interval intervals[4];
+	u8 beacon_rssi_skip_max;
+	u8 rssi_delta_threshold;
+	u8 nr;
+	u8 exclude[1];
+} __attribute__ ((packed));
+
+#define MC_FILTER_ADDRESS_NUM 4
+
+struct p54_group_address_table {
+	__le16 filter_enable;
+	__le16 num_address;
+	u8 mac_list[MC_FILTER_ADDRESS_NUM][ETH_ALEN];
+} __attribute__ ((packed));
+
+struct p54_txcancel {
+	__le32 req_id;
+} __attribute__ ((packed));
+
+struct p54_sta_unlock {
+	u8 addr[ETH_ALEN];
+	u16 padding;
+} __attribute__ ((packed));
+
+#define P54_TIM_CLEAR BIT(15)
+struct p54_tx_control_tim {
+	u8 count;
+	u8 padding[3];
+	__le16 entry[8];
+} __attribute__ ((packed));
+
+struct p54_cce_quiet {
+	__le32 period;
+} __attribute__ ((packed));
+
+struct p54_bt_balancer {
+	__le16 prio_thresh;
+	__le16 acl_thresh;
+} __attribute__ ((packed));
+
+struct p54_arp_table {
+	__le16 filter_enable;
+	u8 ipv4_addr[4];
+} __attribute__ ((packed));
+
 #endif /* P54COMMON_H */
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-10-04 01:03:43.000000000 +0200
+++ b/drivers/net/wireless/p54/p54.h	2008-10-04 19:28:43.000000000 +0200
@@ -14,17 +14,17 @@
  * published by the Free Software Foundation.
  */
 
-enum control_frame_types {
-	P54_CONTROL_TYPE_FILTER_SET = 0,
-	P54_CONTROL_TYPE_CHANNEL_CHANGE,
-	P54_CONTROL_TYPE_FREQDONE,
+enum p54_control_frame_types {
+	P54_CONTROL_TYPE_SETUP = 0,
+	P54_CONTROL_TYPE_SCAN,
+	P54_CONTROL_TYPE_TRAP,
 	P54_CONTROL_TYPE_DCFINIT,
-	P54_CONTROL_TYPE_ENCRYPTION,
+	P54_CONTROL_TYPE_RX_KEYCACHE,
 	P54_CONTROL_TYPE_TIM,
-	P54_CONTROL_TYPE_POWERMGT,
-	P54_CONTROL_TYPE_FREEQUEUE,
+	P54_CONTROL_TYPE_PSM,
+	P54_CONTROL_TYPE_TXCANCEL,
 	P54_CONTROL_TYPE_TXDONE,
-	P54_CONTROL_TYPE_PING,
+	P54_CONTROL_TYPE_BURST,
 	P54_CONTROL_TYPE_STAT_READBACK,
 	P54_CONTROL_TYPE_BBP,
 	P54_CONTROL_TYPE_EEPROM_READBACK,
@@ -37,19 +37,24 @@ enum control_frame_types {
 	P54_CONTROL_TYPE_XBOW_SYNTH_CFG,
 	P54_CONTROL_TYPE_CCE_QUIET,
 	P54_CONTROL_TYPE_PSM_STA_UNLOCK,
+	P54_CONTROL_TYPE_PCS,
+	P54_CONTROL_TYPE_BT_BALANCER = 28,
+	P54_CONTROL_TYPE_GROUP_ADDRESS_TABLE = 30,
+	P54_CONTROL_TYPE_ARPTABLE = 31,
+	P54_CONTROL_TYPE_BT_OPTIONS = 35
 };
 
-struct p54_control_hdr {
-	__le16 magic1;
+struct p54_hdr {
+	__le16 flags;
 	__le16 len;
 	__le32 req_id;
-	__le16 type;	/* enum control_frame_types */
-	u8 retry1;
-	u8 retry2;
+	__le16 type;	/* enum p54_control_frame_types */
+	u8 rts_retries;
+	u8 retries;
 	u8 data[0];
 } __attribute__ ((packed));
 
-struct p54_tx_vdcf_queues {
+struct p54_edcf_queue_param {
 	u8 aifs;
 	u8 padding;
 	__le16 cwmin;
@@ -77,7 +82,7 @@ struct p54_common {
 	u32 rx_start;
 	u32 rx_end;
 	struct sk_buff_head tx_queue;
-	void (*tx)(struct ieee80211_hw *dev, struct p54_control_hdr *data,
+	void (*tx)(struct ieee80211_hw *dev, struct p54_hdr *data,
 		   struct sk_buff *skb, size_t len, int free_on_tx);
 	int (*open)(struct ieee80211_hw *dev);
 	void (*stop)(struct ieee80211_hw *dev);
@@ -89,7 +94,7 @@ struct p54_common {
 	struct mutex conf_mutex;
 	u8 mac_addr[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
-	__le16 filter_type;
+	u16 mac_mode;
 	struct pda_iq_autocal_entry *iq_autocal;
 	unsigned int iq_autocal_len;
 	struct pda_channel_output_limit *output_limit;
@@ -106,7 +111,7 @@ struct p54_common {
 	u32 tsf_low32;
 	u32 tsf_high32;
 	struct ieee80211_tx_queue_stats tx_stats[8];
-	struct p54_tx_vdcf_queues qos_params[8];
+	struct p54_edcf_queue_param qos_params[8];
 	struct ieee80211_low_level_stats stats;
 	struct timer_list stats_timer;
 	struct completion stats_comp;
diff -Nurp a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
--- a/drivers/net/wireless/p54/p54pci.c	2008-10-02 03:21:13.000000000 +0200
+++ b/drivers/net/wireless/p54/p54pci.c	2008-10-04 02:05:13.000000000 +0200
@@ -306,7 +306,7 @@ static irqreturn_t p54p_interrupt(int ir
 	return reg ? IRQ_HANDLED : IRQ_NONE;
 }
 
-static void p54p_tx(struct ieee80211_hw *dev, struct p54_control_hdr *data,
+static void p54p_tx(struct ieee80211_hw *dev, struct p54_hdr *data,
 		    struct sk_buff *skb, size_t len, int free_on_tx)
 {
 	struct p54p_priv *priv = dev->priv;
diff -Nurp a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c	2008-10-04 01:02:41.000000000 +0200
+++ b/drivers/net/wireless/p54/p54usb.c	2008-10-04 02:05:29.000000000 +0200
@@ -213,7 +213,7 @@ static void p54u_free_urbs(struct ieee80
 	}
 }
 
-static void p54u_tx_3887(struct ieee80211_hw *dev, struct p54_control_hdr *data,
+static void p54u_tx_3887(struct ieee80211_hw *dev, struct p54_hdr *data,
 			 struct sk_buff *skb, size_t len, int free_on_tx)
 {
 	struct p54u_priv *priv = dev->priv;
@@ -253,7 +253,7 @@ static __le32 p54u_lm87_chksum(const u32
 	return cpu_to_le32(chk);
 }
 
-static void p54u_tx_lm87(struct ieee80211_hw *dev, struct p54_control_hdr *data,
+static void p54u_tx_lm87(struct ieee80211_hw *dev, struct p54_hdr *data,
 			 struct sk_buff *skb, size_t len, int free_on_tx)
 {
 	struct p54u_priv *priv = dev->priv;
@@ -276,7 +276,7 @@ static void p54u_tx_lm87(struct ieee8021
 	usb_submit_urb(data_urb, GFP_ATOMIC);
 }
 
-static void p54u_tx_net2280(struct ieee80211_hw *dev, struct p54_control_hdr *data,
+static void p54u_tx_net2280(struct ieee80211_hw *dev, struct p54_hdr *data,
 			    struct sk_buff *skb, size_t len, int free_on_tx)
 {
 	struct p54u_priv *priv = dev->priv;

