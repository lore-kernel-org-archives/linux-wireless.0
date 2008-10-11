Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44975 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbYJKX6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 19:58:14 -0400
Subject: [RFT] p54: implement MRR
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>, Chr <chunkeey@web.de>
In-Reply-To: <1223769359.3581.5.camel@johannes.berg> (sfid-20081012_015633_680320_8FD05EB0)
References: <1223682964.29811.13.camel@johannes.berg>
	 (sfid-20081011_015617_239108_FC7ED5DA)  <1223769359.3581.5.camel@johannes.berg>
	 (sfid-20081012_015633_680320_8FD05EB0)
Content-Type: text/plain
Date: Sun, 12 Oct 2008 01:58:10 +0200
Message-Id: <1223769491.3581.8.camel@johannes.berg> (sfid-20081012_015818_541064_B75F451C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements multi-rate retry in p54. With lots of help
and testing from Christian.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Christian Lamparter <chunkeey@web.de>
---
 drivers/net/wireless/p54/p54common.c |   96 ++++++++++++++++++++++++++---------
 1 file changed, 74 insertions(+), 22 deletions(-)

--- everything.orig/drivers/net/wireless/p54/p54common.c	2008-10-12 00:40:33.000000000 +0200
+++ everything/drivers/net/wireless/p54/p54common.c	2008-10-12 01:10:31.000000000 +0200
@@ -1,9 +1,9 @@
-
 /*
  * Common code for mac80211 Prism54 drivers
  *
  * Copyright (c) 2006, Michael Wu <flamingice@sourmilk.net>
  * Copyright (c) 2007, Christian Lamparter <chunkeey@web.de>
+ * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
  *
  * Based on the islsm (softmac prism54) driver, which is:
  * Copyright 2004-2006 Jean-Baptiste Note <jbnote@gmail.com>, et al.
@@ -552,6 +552,7 @@ static void p54_rx_frame_sent(struct iee
 	u32 freed = 0;
 	u32 last_addr = priv->rx_start;
 	unsigned long flags;
+	int count, idx;
 
 	spin_lock_irqsave(&priv->tx_queue.lock, flags);
 	while (entry != (struct sk_buff *)&priv->tx_queue) {
@@ -576,18 +577,39 @@ static void p54_rx_frame_sent(struct iee
 			__skb_unlink(entry, &priv->tx_queue);
 			spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 
-			ieee80211_tx_info_clear_status(info);
+			/*
+			 * Clear manually, ieee80211_tx_info_clear_status would
+			 * clear the counts too and we need them.
+			 */
+			memset(&info->status.ampdu_ack_len, 0,
+			       sizeof(struct ieee80211_tx_info) -
+			       offsetof(struct ieee80211_tx_info, status.ampdu_ack_len));
+			BUILD_BUG_ON(offsetof(struct ieee80211_tx_info,
+			                      status.ampdu_ack_len) != 23);
+
 			entry_hdr = (struct p54_control_hdr *) entry->data;
 			entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
 			if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) != 0)
 				pad = entry_data->align[0];
 
-			priv->tx_stats[entry_data->hw_queue].len--;
-			if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
-				if (!(payload->status & 0x01))
-					info->flags |= IEEE80211_TX_STAT_ACK;
+			/* walk through the rates array and adjust the counts */
+			count = payload->retries;
+			for (idx = 0; idx < IEEE80211_TX_MAX_RATES; idx++) {
+				if (count >= info->status.rates[idx].count) {
+					count -= info->status.rates[idx].count;
+				} else if (count > 0) {
+					info->status.rates[idx].count = count;
+					count = 0;
+				} else {
+					info->status.rates[idx].idx = -1;
+					info->status.rates[idx].count = 0;
+				}
 			}
-			info->status.rates[0].count = payload->retries;
+
+			priv->tx_stats[entry_data->hw_queue].len--;
+			if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
+			    !(payload->status & 0x01))
+				info->flags |= IEEE80211_TX_STAT_ACK;
 			info->status.ack_signal = p54_rssi_to_dbm(dev,
 					le16_to_cpu(payload->ack_rssi));
 			skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
@@ -810,6 +832,7 @@ static int p54_tx(struct ieee80211_hw *d
 	struct p54_control_hdr *hdr;
 	struct p54_tx_control_allocdata *txhdr;
 	size_t padding, len;
+	int i, j, ridx;
 	u8 rate;
 	u8 cts_rate = 0x20;
 	u8 rc_flags;
@@ -835,23 +858,42 @@ static int p54_tx(struct ieee80211_hw *d
 		hdr->magic1 = cpu_to_le16(0x0010);
 	hdr->len = cpu_to_le16(len);
 	hdr->type = (info->flags & IEEE80211_TX_CTL_NO_ACK) ? 0 : cpu_to_le16(1);
-	hdr->retry1 = hdr->retry2 = info->control.rates[0].count;
+	hdr->retry1 = info->control.rates[0].count;
+
+	/*
+	 * we register the rates in perfect order, and
+	 * RTS/CTS won't happen on 5 GHz
+	 */
+	cts_rate = info->control.rts_cts_rate_idx;
 
-	/* TODO: add support for alternate retry TX rates */
-	rate = ieee80211_get_tx_rate(dev, info)->hw_value;
-	rc_flags = info->control.rates[0].flags;
-	if (rc_flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE) {
-		rate |= 0x10;
-		cts_rate |= 0x10;
-	}
-	if (rc_flags & IEEE80211_TX_RC_USE_RTS_CTS) {
-		rate |= 0x40;
-		cts_rate |= ieee80211_get_rts_cts_rate(dev, info)->hw_value;
-	} else if (rc_flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
-		rate |= 0x20;
-		cts_rate |= ieee80211_get_rts_cts_rate(dev, info)->hw_value;
+	/* simply use the first 8 tries it asked us to do */
+	memset(&txhdr->rateset, 0, sizeof(txhdr->rateset));
+	ridx = 0;
+	for (i = 0; i < IEEE80211_TX_MAX_RATES && ridx < 8; i++) {
+		if (info->control.rates[i].idx < 0)
+			break;
+
+		/* we register the rates in perfect order */
+		rate = info->control.rates[i].idx;
+		if (info->band == IEEE80211_BAND_5GHZ)
+			rate += 4;
+
+		rc_flags = info->control.rates[i].flags;
+		if (rc_flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE) {
+			rate |= 0x10;
+			cts_rate |= 0x10;
+		}
+		if (rc_flags & IEEE80211_TX_RC_USE_RTS_CTS)
+			rate |= 0x40;
+		else if (rc_flags & IEEE80211_TX_RC_USE_CTS_PROTECT)
+			rate |= 0x20;
+		for (j = 0; j < info->control.rates[i].count && ridx < 8; j++) {
+			txhdr->rateset[ridx] = rate;
+			ridx++;
+		}
 	}
-	memset(txhdr->rateset, rate, 8);
+	hdr->retry2 = ridx;
+
 	txhdr->key_type = 0;
 	txhdr->key_len = 0;
 	txhdr->hw_queue = skb_get_queue_mapping(skb) + 4;
@@ -1401,6 +1443,16 @@ struct ieee80211_hw *p54_init_common(siz
 	priv->tx_stats[4].limit = 5;
 	dev->queues = 1;
 	priv->noise = -94;
+	/*
+	 * We support at most 8 tries no matter which rate they're at,
+	 * we cannot support max_rates * max_rate_tries as we set it
+	 * here, but setting it correctly to 4/2 or so would limit us
+	 * artificially if the RC algorithm wants just two rates, so
+	 * let's say the max of rates and three tries each, and clip
+	 * it to a total of 8.
+	 */
+	dev->max_rates = IEEE80211_TX_MAX_RATES;
+	dev->max_rate_tries = 3;
 	dev->extra_tx_headroom = sizeof(struct p54_control_hdr) + 4 +
 				 sizeof(struct p54_tx_control_allocdata);
 


