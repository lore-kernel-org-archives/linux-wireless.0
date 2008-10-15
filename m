Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:59959 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbYJOCEf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 22:04:35 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 6/6] p54: integrate parts of lmac_longbow.h and other parts of stlc45xx
Date: Wed, 15 Oct 2008 04:08:44 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200810150408.44363.chunkeey@web.de> (sfid-20081015_040439_243388_A2EE7FA3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes most/all? of the "magic" numbers and unknown structu=
re=20
variables inside the code and replaces them with meaningful prototypes.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireles=
s/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-10-15 03:04:38.00000000=
0 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-10-15 02:59:26.00000000=
0 +0200
@@ -5,8 +5,11 @@
  * Copyright (c) 2007, Christian Lamparter <chunkeey@web.de>
  * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
  *
- * Based on the islsm (softmac prism54) driver, which is:
- * Copyright 2004-2006 Jean-Baptiste Note <jbnote@gmail.com>, et al.
+ * Based on:
+ * - the islsm (softmac prism54) driver, which is:
+ *   Copyright 2004-2006 Jean-Baptiste Note <jbnote@gmail.com>, et al.
+ * - stlc45xx driver
+ * =C3=82  Copyright (C) 2008 Nokia Corporation and/or its subsidiary(=
-ies).
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License version 2 as
@@ -481,13 +484,13 @@ static int p54_rssi_to_dbm(struct ieee80
 static int p54_rx_data(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54_common *priv =3D dev->priv;
-	struct p54_rx_hdr *hdr =3D (struct p54_rx_hdr *) skb->data;
+	struct p54_rx_data *hdr =3D (struct p54_rx_data *) skb->data;
 	struct ieee80211_rx_status rx_status =3D {0};
 	u16 freq =3D le16_to_cpu(hdr->freq);
 	size_t header_len =3D sizeof(*hdr);
 	u32 tsf32;
=20
-	if (!(hdr->magic & cpu_to_le16(0x0001))) {
+	if (!(hdr->flags & cpu_to_le16(P54_HDR_FLAG_DATA_IN_FCS_GOOD))) {
 		if (priv->filter_flags & FIF_FCSFAIL)
 			rx_status.flag |=3D RX_FLAG_FAILED_FCS_CRC;
 		else
@@ -512,7 +515,7 @@ static int p54_rx_data(struct ieee80211_
=20
 	rx_status.flag |=3D RX_FLAG_TSFT;
=20
-	if (hdr->magic & cpu_to_le16(0x4000))
+	if (hdr->flags & cpu_to_le16(P54_HDR_FLAG_DATA_ALIGN))
 		header_len +=3D hdr->align[0];
=20
 	skb_pull(skb, header_len);
@@ -571,7 +574,7 @@ void p54_free_skb(struct ieee80211_hw *d
 	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 	kfree_skb(skb);
=20
-	if (freed >=3D priv->headroom + sizeof(struct p54_control_hdr) + 48 +
+	if (freed >=3D priv->headroom + sizeof(struct p54_hdr) + 48 +
 		     IEEE80211_MAX_RTS_THRESHOLD + priv->tailroom)
 		p54_wake_free_queues(dev);
 }
@@ -580,8 +583,8 @@ EXPORT_SYMBOL_GPL(p54_free_skb);
 static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff=
 *skb)
 {
 	struct p54_common *priv =3D dev->priv;
-	struct p54_control_hdr *hdr =3D (struct p54_control_hdr *) skb->data;
-	struct p54_frame_sent_hdr *payload =3D (struct p54_frame_sent_hdr *) =
hdr->data;
+	struct p54_hdr *hdr =3D (struct p54_hdr *) skb->data;
+	struct p54_frame_sent *payload =3D (struct p54_frame_sent *) hdr->dat=
a;
 	struct sk_buff *entry =3D (struct sk_buff *) priv->tx_queue.next;
 	u32 addr =3D le32_to_cpu(hdr->req_id) - priv->headroom;
 	struct memrecord *range =3D NULL;
@@ -593,8 +596,8 @@ static void p54_rx_frame_sent(struct iee
 	spin_lock_irqsave(&priv->tx_queue.lock, flags);
 	while (entry !=3D (struct sk_buff *)&priv->tx_queue) {
 		struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(entry);
-		struct p54_control_hdr *entry_hdr;
-		struct p54_tx_control_allocdata *entry_data;
+		struct p54_hdr *entry_hdr;
+		struct p54_tx_data *entry_data;
 		int pad =3D 0;
=20
 		range =3D (void *)info->rate_driver_data;
@@ -628,13 +631,13 @@ static void p54_rx_frame_sent(struct iee
 		BUILD_BUG_ON(offsetof(struct ieee80211_tx_info,
 				      status.ampdu_ack_len) !=3D 23);
=20
-		entry_hdr =3D (struct p54_control_hdr *) entry->data;
-		entry_data =3D (struct p54_tx_control_allocdata *) entry_hdr->data;
-		if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) !=3D 0)
+		entry_hdr =3D (struct p54_hdr *) entry->data;
+		entry_data =3D (struct p54_tx_data *) entry_hdr->data;
+		if (entry_hdr->flags & cpu_to_le16(P54_HDR_FLAG_DATA_ALIGN))
 			pad =3D entry_data->align[0];
=20
 		/* walk through the rates array and adjust the counts */
-		count =3D payload->retries;
+		count =3D payload->tries;
 		for (idx =3D 0; idx < 4; idx++) {
 			if (count >=3D info->status.rates[idx].count) {
 				count -=3D info->status.rates[idx].count;
@@ -662,7 +665,7 @@ static void p54_rx_frame_sent(struct iee
 	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
=20
 out:
-	if (freed >=3D priv->headroom + sizeof(struct p54_control_hdr) + 48 +
+	if (freed >=3D priv->headroom + sizeof(struct p54_hdr) + 48 +
 		     IEEE80211_MAX_RTS_THRESHOLD + priv->tailroom)
 		p54_wake_free_queues(dev);
 }
@@ -670,7 +673,7 @@ out:
 static void p54_rx_eeprom_readback(struct ieee80211_hw *dev,
 				   struct sk_buff *skb)
 {
-	struct p54_control_hdr *hdr =3D (struct p54_control_hdr *) skb->data;
+	struct p54_hdr *hdr =3D (struct p54_hdr *) skb->data;
 	struct p54_eeprom_lm86 *eeprom =3D (struct p54_eeprom_lm86 *) hdr->da=
ta;
 	struct p54_common *priv =3D dev->priv;
=20
@@ -685,7 +688,7 @@ static void p54_rx_eeprom_readback(struc
 static void p54_rx_stats(struct ieee80211_hw *dev, struct sk_buff *skb=
)
 {
 	struct p54_common *priv =3D dev->priv;
-	struct p54_control_hdr *hdr =3D (struct p54_control_hdr *) skb->data;
+	struct p54_hdr *hdr =3D (struct p54_hdr *) skb->data;
 	struct p54_statistics *stats =3D (struct p54_statistics *) hdr->data;
 	u32 tsf32 =3D le32_to_cpu(stats->tsf32);
=20
@@ -705,7 +708,7 @@ static void p54_rx_stats(struct ieee8021
=20
 static int p54_rx_control(struct ieee80211_hw *dev, struct sk_buff *sk=
b)
 {
-	struct p54_control_hdr *hdr =3D (struct p54_control_hdr *) skb->data;
+	struct p54_hdr *hdr =3D (struct p54_hdr *) skb->data;
=20
 	switch (le16_to_cpu(hdr->type)) {
 	case P54_CONTROL_TYPE_TXDONE:
@@ -750,7 +753,7 @@ EXPORT_SYMBOL_GPL(p54_rx);
  * allocated areas.
  */
 static int p54_assign_address(struct ieee80211_hw *dev, struct sk_buff=
 *skb,
-			       struct p54_control_hdr *data, u32 len)
+			       struct p54_hdr *data, u32 len)
 {
 	struct p54_common *priv =3D dev->priv;
 	struct sk_buff *entry =3D priv->tx_queue.next;
@@ -807,7 +810,7 @@ static int p54_assign_address(struct iee
 	__skb_queue_after(&priv->tx_queue, target_skb, skb);
 	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
=20
-	if (largest_hole < priv->headroom + sizeof(struct p54_control_hdr) +
+	if (largest_hole < priv->headroom + sizeof(struct p54_hdr) +
 			   48 + IEEE80211_MAX_RTS_THRESHOLD + priv->tailroom)
 		ieee80211_stop_queues(dev);
=20
@@ -819,7 +822,7 @@ static struct sk_buff *p54_alloc_skb(str
 		u16 hdr_flags, u16 len, u16 type, gfp_t memflags)
 {
 	struct p54_common *priv =3D dev->priv;
-	struct p54_control_hdr *hdr;
+	struct p54_hdr *hdr;
 	struct sk_buff *skb;
=20
 	skb =3D __dev_alloc_skb(len + priv->tx_hdr_len, memflags);
@@ -827,11 +830,11 @@ static struct sk_buff *p54_alloc_skb(str
 		return NULL;
 	skb_reserve(skb, priv->tx_hdr_len);
=20
-	hdr =3D (struct p54_control_hdr *) skb_put(skb, sizeof(*hdr));
-	hdr->magic1 =3D cpu_to_le16(hdr_flags);
+	hdr =3D (struct p54_hdr *) skb_put(skb, sizeof(*hdr));
+	hdr->flags =3D cpu_to_le16(hdr_flags);
 	hdr->len =3D cpu_to_le16(len - sizeof(*hdr));
 	hdr->type =3D cpu_to_le16(type);
-	hdr->retry1 =3D hdr->retry2 =3D 0;
+	hdr->tries =3D hdr->rts_tries =3D 0;
=20
 	if (unlikely(p54_assign_address(dev, skb, hdr, len))) {
 		kfree_skb(skb);
@@ -843,7 +846,7 @@ static struct sk_buff *p54_alloc_skb(str
 int p54_read_eeprom(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv =3D dev->priv;
-	struct p54_control_hdr *hdr =3D NULL;
+	struct p54_hdr *hdr =3D NULL;
 	struct p54_eeprom_lm86 *eeprom_hdr;
 	struct sk_buff *skb;
 	size_t eeprom_size =3D 0x2020, offset =3D 0, blocksize;
@@ -899,8 +902,8 @@ static int p54_tx(struct ieee80211_hw *d
 	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_queue_stats *current_queue;
 	struct p54_common *priv =3D dev->priv;
-	struct p54_control_hdr *hdr;
-	struct p54_tx_control_allocdata *txhdr;
+	struct p54_hdr *hdr;
+	struct p54_tx_data *txhdr;
 	size_t padding, len;
 	int i, j, ridx;
 	u8 rate;
@@ -920,17 +923,16 @@ static int p54_tx(struct ieee80211_hw *d
 	padding =3D (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr=
))) & 3;
 	len =3D skb->len;
=20
-	txhdr =3D (struct p54_tx_control_allocdata *)
-			skb_push(skb, sizeof(*txhdr) + padding);
-	hdr =3D (struct p54_control_hdr *) skb_push(skb, sizeof(*hdr));
+	txhdr =3D (struct p54_tx_data *) skb_push(skb, sizeof(*txhdr) + paddi=
ng);
+	hdr =3D (struct p54_hdr *) skb_push(skb, sizeof(*hdr));
=20
 	if (padding)
-		hdr->magic1 =3D cpu_to_le16(0x4010);
+		hdr->flags =3D cpu_to_le16(P54_HDR_FLAG_DATA_ALIGN);
 	else
-		hdr->magic1 =3D cpu_to_le16(0x0010);
+		hdr->flags =3D cpu_to_le16(0);
 	hdr->len =3D cpu_to_le16(len);
 	hdr->type =3D (info->flags & IEEE80211_TX_CTL_NO_ACK) ? 0 : cpu_to_le=
16(1);
-	hdr->retry1 =3D info->control.rates[0].count;
+	hdr->rts_tries =3D info->control.rates[0].count;
=20
 	/*
 	 * we register the rates in perfect order, and
@@ -996,16 +998,18 @@ static int p54_tx(struct ieee80211_hw *d
 			ridx++;
 		}
 	}
-	hdr->retry2 =3D ridx;
-
+	hdr->tries =3D ridx;
+	txhdr->crypt_offset =3D 0;
+	txhdr->rts_rate_idx =3D 0;
 	txhdr->key_type =3D 0;
 	txhdr->key_len =3D 0;
 	txhdr->hw_queue =3D skb_get_queue_mapping(skb) + 4;
+	txhdr->backlog =3D 32;
+	memset(txhdr->durations, 0, sizeof(txhdr->durations));
 	txhdr->tx_antenna =3D (info->antenna_sel_tx =3D=3D 0) ?
 		2 : info->antenna_sel_tx - 1;
 	txhdr->output_power =3D priv->output_power;
-	txhdr->cts_rate =3D (info->flags & IEEE80211_TX_CTL_NO_ACK) ?
-			  0 : cts_rate;
+	txhdr->cts_rate =3D cts_rate;
 	if (padding)
 		txhdr->align[0] =3D padding;
=20
@@ -1024,13 +1028,13 @@ static int p54_setup_mac(struct ieee8021
 	struct sk_buff *skb;
 	struct p54_setup_mac *setup;
=20
-	skb =3D p54_alloc_skb(dev, 0x8001, sizeof(struct p54_tx_control_hdr) =
+
-			    sizeof(*setup), P54_CONTROL_TYPE_SETUP,
+	skb =3D p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*setup)=
 +
+			    sizeof(struct p54_hdr), P54_CONTROL_TYPE_SETUP,
 			    GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
=20
-	setup =3D (struct p54_tx_control_filter *) skb_put(skb, sizeof(*filte=
r));
+	setup =3D (struct p54_setup_mac *) skb_put(skb, sizeof(*setup));
 	priv->mac_mode =3D mode;
 	setup->mac_mode =3D cpu_to_le16(mode);
 	memcpy(setup->mac_addr, priv->mac_addr, ETH_ALEN);
@@ -1069,19 +1073,19 @@ static int p54_set_freq(struct ieee80211
 {
 	struct p54_common *priv =3D dev->priv;
 	struct sk_buff *skb;
-	struct p54_tx_control_channel *chan;
+	struct p54_scan *chan;
 	unsigned int i;
-	size_t data_len =3D sizeof(struct p54_control_hdr) + sizeof(*chan);
 	void *entry;
=20
-	skb =3D p54_alloc_skb(dev, 0x8001, data_len,
-			    P54_CONTROL_TYPE_CHANNEL_CHANGE, GFP_ATOMIC);
+	skb =3D p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*chan) =
+
+			    sizeof(struct p54_hdr), P54_CONTROL_TYPE_SCAN,
+			    GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
=20
-	chan =3D (struct p54_tx_control_channel *) skb_put(skb, sizeof(*chan)=
);
+	chan =3D (struct p54_scan *) skb_put(skb, sizeof(*chan));
 	memset(chan->padding1, 0, sizeof(chan->padding1));
-	chan->flags =3D cpu_to_le16(0x1);
+	chan->mode =3D cpu_to_le16(P54_SCAN_EXIT);
 	chan->dwell =3D cpu_to_le16(0x0);
=20
 	for (i =3D 0; i < priv->iq_autocal_len; i++) {
@@ -1132,13 +1136,13 @@ static int p54_set_freq(struct ieee80211
 	}
=20
 	if (priv->fw_var < 0x500) {
-		data_len =3D P54_TX_CONTROL_CHANNEL_V1_LEN;
 		chan->v1.rssical_mul =3D cpu_to_le16(130);
 		chan->v1.rssical_add =3D cpu_to_le16(0xfe70);
 	} else {
 		chan->v2.rssical_mul =3D cpu_to_le16(130);
 		chan->v2.rssical_add =3D cpu_to_le16(0xfe70);
 		chan->v2.basic_rate_mask =3D cpu_to_le32(0x15f);
+		memset(chan->v2.rts_rates, 0, 8);
 	}
 	priv->tx(dev, skb, 1);
 	return 0;
@@ -1153,15 +1157,15 @@ static int p54_set_leds(struct ieee80211
 {
 	struct p54_common *priv =3D dev->priv;
 	struct sk_buff *skb;
-	struct p54_tx_control_led *led;
+	struct p54_led *led;
=20
-	skb =3D p54_alloc_skb(dev, 0x8001, sizeof(*led) +
-			sizeof(struct p54_control_hdr),
-			P54_CONTROL_TYPE_LED, GFP_ATOMIC);
+	skb =3D p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*led) +
+			sizeof(struct p54_hdr),	P54_CONTROL_TYPE_LED,
+			GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
=20
-	led =3D (struct p54_tx_control_led *)skb_put(skb, sizeof(*led));
+	led =3D (struct p54_led *)skb_put(skb, sizeof(*led));
 	led->mode =3D cpu_to_le16(mode);
 	led->led_permanent =3D cpu_to_le16(link);
 	led->led_temporary =3D cpu_to_le16(act);
@@ -1184,8 +1188,9 @@ static int p54_set_edcf(struct ieee80211
 	struct sk_buff *skb;
 	struct p54_edcf *edcf;
=20
-	skb =3D p54_alloc_skb(dev, 0x8001, sizeof(struct p54_control_hdr) +
-			sizeof(*edcf), P54_CONTROL_TYPE_DCFINIT, GFP_ATOMIC);
+	skb =3D p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*edcf) =
+
+			sizeof(struct p54_hdr), P54_CONTROL_TYPE_DCFINIT,
+			GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
=20
@@ -1212,11 +1217,9 @@ static int p54_init_stats(struct ieee802
 {
 	struct p54_common *priv =3D dev->priv;
=20
-	priv->cached_stats =3D p54_alloc_skb(dev, 0x8000,
-			sizeof(struct p54_control_hdr) +
-			sizeof(struct p54_statistics),
-			P54_CONTROL_TYPE_STAT_READBACK,
-			GFP_KERNEL);
+	priv->cached_stats =3D p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL,
+			sizeof(struct p54_hdr) + sizeof(struct p54_statistics),
+			P54_CONTROL_TYPE_STAT_READBACK, GFP_KERNEL);
 	if (!priv->cached_stats)
 			return -ENOMEM;
=20
@@ -1277,11 +1280,11 @@ static int p54_add_interface(struct ieee
=20
 	memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
=20
-	p54_setup_mac(dev, 0, NULL);
+	p54_setup_mac(dev, P54_FILTER_TYPE_NONE, NULL);
=20
 	switch (conf->type) {
 	case NL80211_IFTYPE_STATION:
-		p54_setup_mac(dev, 1, NULL);
+		p54_setup_mac(dev, P54_FILTER_TYPE_STATION, NULL);
 		break;
 	default:
 		BUG();	/* impossible */
@@ -1299,7 +1302,7 @@ static void p54_remove_interface(struct=20
 	struct p54_common *priv =3D dev->priv;
 	priv->mode =3D NL80211_IFTYPE_MONITOR;
 	memset(priv->mac_addr, 0, ETH_ALEN);
-	p54_setup_mac(dev, 0, NULL);
+	p54_setup_mac(dev, P54_FILTER_TYPE_NONE, NULL);
 }
=20
 static int p54_config(struct ieee80211_hw *dev, u32 changed)
@@ -1325,7 +1328,7 @@ static int p54_config_interface(struct i
 	struct p54_common *priv =3D dev->priv;
=20
 	mutex_lock(&priv->conf_mutex);
-	p54_setup_mac(dev, 0, conf->bssid);
+	p54_setup_mac(dev, P54_FILTER_TYPE_STATION, conf->bssid);
 	p54_set_leds(dev, 1, !is_multicast_ether_addr(conf->bssid), 0);
 	memcpy(priv->bssid, conf->bssid, ETH_ALEN);
 	mutex_unlock(&priv->conf_mutex);
@@ -1378,15 +1381,16 @@ static int p54_init_xbow_synth(struct ie
 {
 	struct p54_common *priv =3D dev->priv;
 	struct sk_buff *skb;
-	struct p54_tx_control_xbow_synth *xbow;
+	struct p54_xbow_synth *xbow;
=20
-	skb =3D p54_alloc_skb(dev, 0x8001, sizeof(struct p54_control_hdr) +
-			    sizeof(*xbow), P54_CONTROL_TYPE_XBOW_SYNTH_CFG,
+	skb =3D p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*xbow) =
+
+			    sizeof(struct p54_hdr),
+			    P54_CONTROL_TYPE_XBOW_SYNTH_CFG,
 			    GFP_KERNEL);
 	if (!skb)
 		return -ENOMEM;
=20
-	xbow =3D (struct p54_tx_control_xbow_synth *)skb_put(skb, sizeof(*xbo=
w));
+	xbow =3D (struct p54_xbow_synth *)skb_put(skb, sizeof(*xbow));
 	xbow->magic1 =3D cpu_to_le16(0x1);
 	xbow->magic2 =3D cpu_to_le16(0x2);
 	xbow->freq =3D cpu_to_le16(5390);
@@ -1504,8 +1508,8 @@ struct ieee80211_hw *p54_init_common(siz
 	 */
 	dev->max_rates =3D 4;
 	dev->max_rate_tries =3D 7;
-	dev->extra_tx_headroom =3D sizeof(struct p54_control_hdr) + 4 +
-				 sizeof(struct p54_tx_control_allocdata);
+	dev->extra_tx_headroom =3D sizeof(struct p54_hdr) + 4 +
+				 sizeof(struct p54_tx_data);
=20
 	mutex_init(&priv->conf_mutex);
 	init_completion(&priv->eeprom_comp);
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireles=
s/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-10-15 02:22:59.00000000=
0 +0200
+++ b/drivers/net/wireless/p54/p54common.h	2008-10-14 21:34:12.00000000=
0 +0200
@@ -33,6 +33,13 @@ struct bootrec_exp_if {
 	__le16 top_compat;
 } __attribute__((packed));
=20
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
@@ -40,7 +47,12 @@ struct bootrec_desc {
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
 	u8 padding2[4];
 	__le16 rx_mtu;
@@ -56,6 +68,34 @@ struct bootrec_desc {
 #define BR_CODE_END_OF_BRA		0xFF0000FF
 #define LEGACY_BR_CODE_END_OF_BRA	0xFFFFFFFF
=20
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
 /* PDA defines are Copyright (C) 2005 Nokia Corporation (taken from is=
lsm_pda.h) */
=20
 struct pda_entry {
@@ -182,36 +222,91 @@ struct p54_eeprom_lm86 {
 	u8 data[0];
 } __attribute__ ((packed));
=20
-struct p54_rx_hdr {
-	__le16 magic;
+enum p54_rx_decrypt_status {
+	P54_DECRYPT_NONE =3D 0,
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
=20
-struct p54_frame_sent_hdr {
+enum p54_trap_type {
+	P54_TRAP_SCAN =3D 0,
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
+	P54_TX_OK =3D 0,
+	P54_TX_FAILED,
+	P54_TX_PSM,
+	P54_TX_PSM_CANCELLED
+};
+
+struct p54_frame_sent {
 	u8 status;
-	u8 retries;
-	__le16 ack_rssi;
+	u8 tries;
+	u8 ack_rssi;
+	u8 quality;
 	__le16 seq;
-	u16 rate;
+	u8 antenna;
+	u8 padding;
 } __attribute__ ((packed));
=20
-struct p54_tx_control_allocdata {
+enum  p54_tx_data_crypt {
+	P54_CRYPTO_NONE =3D 0,
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
@@ -219,6 +314,16 @@ struct p54_tx_control_allocdata {
 	u8 align[0];
 } __attribute__ ((packed));
=20
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
 struct p54_setup_mac {
 	__le16 mac_mode;
 	u8 mac_addr[ETH_ALEN];
@@ -253,8 +358,16 @@ struct p54_setup_mac {
 	} __attribute__ ((packed));
 } __attribute__ ((packed));
=20
-struct p54_tx_control_channel {
-	__le16 flags;
+#define P54_SETUP_V1_LEN 40
+#define P54_SETUP_V2_LEN (sizeof(struct p54_setup_mac))
+
+#define P54_SCAN_EXIT	BIT(0)
+#define P54_SCAN_TRAP	BIT(1)
+#define P54_SCAN_ACTIVE BIT(2)
+#define P54_SCAN_FILTER BIT(3)
+
+struct p54_scan {
+	__le16 mode;
 	__le16 dwell;
 	u8 padding1[20];
 	struct pda_iq_autocal_entry iq_autocal;
@@ -277,17 +390,17 @@ struct p54_tx_control_channel {
=20
 		struct {
 			__le32 basic_rate_mask;
-			 u8 rts_rates[8];
+			u8 rts_rates[8];
 			__le16 rssical_mul;
 			__le16 rssical_add;
 		} v2 __attribute__ ((packed));
 	} __attribute__ ((packed));
 } __attribute__ ((packed));
=20
-#define P54_TX_CONTROL_CHANNEL_V1_LEN (sizeof(struct p54_tx_control_ch=
annel)-12)
-#define P54_TX_CONTROL_CHANNEL_V2_LEN (sizeof(struct p54_tx_control_ch=
annel))
+#define P54_SCAN_V1_LEN (sizeof(struct p54_scan)-12)
+#define P54_SCAN_V2_LEN (sizeof(struct p54_scan))
=20
-struct p54_tx_control_led {
+struct p54_led {
 	__le16 mode;
 	__le16 led_temporary;
 	__le16 led_permanent;
@@ -315,14 +428,103 @@ struct p54_statistics {
 	__le32 tsf32;
 	__le32 airtime;
 	__le32 noise;
-	__le32 unkn[10]; /* CCE / CCA / RADAR */
+	__le32 sample_noise[8];
+	__le32 sample_cca;
+	__le32 sample_tx;
 } __attribute__ ((packed));
=20
-struct p54_tx_control_xbow_synth {
+struct p54_xbow_synth {
 	__le16 magic1;
 	__le16 magic2;
 	__le16 freq;
 	u32 padding[5];
 } __attribute__ ((packed));
=20
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
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/=
p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-10-15 03:03:57.000000000 +020=
0
+++ b/drivers/net/wireless/p54/p54.h	2008-10-14 21:26:45.000000000 +020=
0
@@ -14,17 +14,17 @@
  * published by the Free Software Foundation.
  */
=20
-enum control_frame_types {
+enum p54_control_frame_types {
 	P54_CONTROL_TYPE_SETUP =3D 0,
-	P54_CONTROL_TYPE_CHANNEL_CHANGE,
-	P54_CONTROL_TYPE_FREQDONE,
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
@@ -37,15 +37,20 @@ enum control_frame_types {
 	P54_CONTROL_TYPE_XBOW_SYNTH_CFG,
 	P54_CONTROL_TYPE_CCE_QUIET,
 	P54_CONTROL_TYPE_PSM_STA_UNLOCK,
+	P54_CONTROL_TYPE_PCS,
+	P54_CONTROL_TYPE_BT_BALANCER =3D 28,
+	P54_CONTROL_TYPE_GROUP_ADDRESS_TABLE =3D 30,
+	P54_CONTROL_TYPE_ARPTABLE =3D 31,
+	P54_CONTROL_TYPE_BT_OPTIONS =3D 35
 };
=20
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
+	u8 rts_tries;
+	u8 tries;
 	u8 data[0];
 } __attribute__ ((packed));
=20
diff -Nurp a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p=
54/p54pci.c
--- a/drivers/net/wireless/p54/p54pci.c	2008-10-15 02:18:19.000000000 +=
0200
+++ b/drivers/net/wireless/p54/p54pci.c	2008-10-14 22:06:54.000000000 +=
0200
@@ -326,7 +326,7 @@ static void p54p_tx(struct ieee80211_hw=20
 				 PCI_DMA_TODEVICE);
 	desc =3D &ring_control->tx_data[i];
 	desc->host_addr =3D cpu_to_le32(mapping);
-	desc->device_addr =3D ((struct p54_control_hdr *)skb->data)->req_id;
+	desc->device_addr =3D ((struct p54_hdr *)skb->data)->req_id;
 	desc->len =3D cpu_to_le16(skb->len);
 	desc->flags =3D 0;
=20
diff -Nurp a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p=
54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c	2008-10-15 02:18:19.000000000 +=
0200
+++ b/drivers/net/wireless/p54/p54usb.c	2008-10-14 22:07:39.000000000 +=
0200
@@ -230,7 +230,7 @@ static void p54u_tx_3887(struct ieee8021
=20
 	usb_fill_bulk_urb(addr_urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
-			  &((struct p54_control_hdr *)skb->data)->req_id, 4,
+			  &((struct p54_hdr *)skb->data)->req_id, 4,
 			  p54u_tx_cb, dev);
 	usb_fill_bulk_urb(data_urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
@@ -262,7 +262,7 @@ static void p54u_tx_lm87(struct ieee8021
 	struct urb *data_urb;
 	struct lm87_tx_hdr *hdr;
 	__le32 checksum;
-	__le32 addr =3D ((struct p54_control_hdr *)skb->data)->req_id;
+	__le32 addr =3D ((struct p54_hdr *)skb->data)->req_id;
=20
 	data_urb =3D usb_alloc_urb(0, GFP_ATOMIC);
 	if (!data_urb)
@@ -313,8 +313,8 @@ static void p54u_tx_net2280(struct ieee8
=20
 	hdr =3D (void *)skb_push(skb, sizeof(*hdr));
 	memset(hdr, 0, sizeof(*hdr));
-	hdr->device_addr =3D ((struct p54_control_hdr *)skb->data)->req_id;
-	hdr->len =3D cpu_to_le16(skb->len + sizeof(struct p54_control_hdr));
+	hdr->device_addr =3D ((struct p54_hdr *)skb->data)->req_id;
+	hdr->len =3D cpu_to_le16(skb->len + sizeof(struct p54_hdr));
=20
 	usb_fill_bulk_urb(int_urb, priv->udev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DEV), reg, sizeof(*reg),
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
