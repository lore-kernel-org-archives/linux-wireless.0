Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:59661 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbYHGPYd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 11:24:33 -0400
From: Chr <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] p54: Fix regression due to commit b19fa1f
Date: Thu, 7 Aug 2008 17:27:18 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
References: <489af6ed.hkTX0XTOTIkENssK%Larry.Finger@lwfinger.net> <1218115671.23048.174.camel@johannes.berg>
In-Reply-To: <1218115671.23048.174.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808071727.19129.chunkeey@web.de> (sfid-20080807_172437_996098_8F72622D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 07 August 2008 15:27:51 Johannes Berg wrote:
> > +			priv->tx_stats[le32_to_cpu(entry_data->frame_type - 4)].len--;
>
> Sorry for not catching this earlier, but this looks wrong, the -4 surely
> should be outside the endian conversion?

likely... let's do the job properly for once and for all.
--

This patch fixes not only the regression which has sneaked in
with commit b19fa1f, but also provides some extra code for
cts rates.

Signed-off-by: Christian Lamparter <chunkeey@web.de>

---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-08-07 16:11:43.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-08-07 17:24:49.000000000 +0200
@@ -413,12 +413,12 @@ static void p54_rx_frame_sent(struct iee
 			last_addr = range->end_addr;
 			__skb_unlink(entry, &priv->tx_queue);
 			memset(&info->status, 0, sizeof(info->status));
-			priv->tx_stats[skb_get_queue_mapping(skb)].len--;
 			entry_hdr = (struct p54_control_hdr *) entry->data;
 			entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
 			if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) != 0)
 				pad = entry_data->align[0];
 
+			priv->tx_stats[entry_data->hw_queue - 4].len--;
 			if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
 				if (!(payload->status & 0x01))
 					info->flags |= IEEE80211_TX_STAT_ACK;
@@ -555,7 +555,7 @@ static int p54_tx(struct ieee80211_hw *d
 	struct p54_control_hdr *hdr;
 	struct p54_tx_control_allocdata *txhdr;
 	size_t padding, len;
-	u8 rate;
+	u8 rate, cts_rate = 0x20;
 
 	current_queue = &priv->tx_stats[skb_get_queue_mapping(skb)];
 	if (unlikely(current_queue->len > current_queue->limit))
@@ -580,28 +580,26 @@ static int p54_tx(struct ieee80211_hw *d
 	hdr->type = (info->flags & IEEE80211_TX_CTL_NO_ACK) ? 0 : cpu_to_le16(1);
 	hdr->retry1 = hdr->retry2 = info->control.retry_limit;
 
-	memset(txhdr->wep_key, 0x0, 16);
-	txhdr->padding = 0;
-	txhdr->padding2 = 0;
-
 	/* TODO: add support for alternate retry TX rates */
 	rate = ieee80211_get_tx_rate(dev, info)->hw_value;
-	if (info->flags & IEEE80211_TX_CTL_SHORT_PREAMBLE)
+	if (info->flags & IEEE80211_TX_CTL_SHORT_PREAMBLE) {
 		rate |= 0x10;
-	if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS)
+		cts_rate |= 0x10;
+	} if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) {
 		rate |= 0x40;
-	else if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)
+		cts_rate |= ieee80211_get_rts_cts_rate(dev, info)->hw_value;
+	} else if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT) {
 		rate |= 0x20;
+		cts_rate |= ieee80211_get_rts_cts_rate(dev, info)->hw_value;
+	}
 	memset(txhdr->rateset, rate, 8);
-	txhdr->wep_key_present = 0;
-	txhdr->wep_key_len = 0;
-	txhdr->frame_type = cpu_to_le32(skb_get_queue_mapping(skb) + 4);
-	txhdr->magic4 = 0;
-	txhdr->antenna = (info->antenna_sel_tx == 0) ?
+	txhdr->key_type = 0;
+	txhdr->key_len = 0;
+	txhdr->hw_queue = skb_get_queue_mapping(skb) + 4;
+	txhdr->tx_antenna = (info->antenna_sel_tx == 0) ?
 		2 : info->antenna_sel_tx - 1;
 	txhdr->output_power = 0x7f; // HW Maximum
-	txhdr->magic5 = (info->flags & IEEE80211_TX_CTL_NO_ACK) ?
-		0 : ((rate > 0x3) ? cpu_to_le32(0x33) : cpu_to_le32(0x23));
+	txhdr->cts_rate = (info->flags & IEEE80211_TX_CTL_NO_ACK) ? 0 : cts_rate;
 	if (padding)
 		txhdr->align[0] = padding;
 
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-08-07 16:10:20.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.h	2008-08-07 16:24:10.000000000 +0200
@@ -183,16 +183,18 @@ struct p54_frame_sent_hdr {
 
 struct p54_tx_control_allocdata {
 	u8 rateset[8];
-	u16 padding;
-	u8 wep_key_present;
-	u8 wep_key_len;
-	u8 wep_key[16];
-	__le32 frame_type;
-	u32 padding2;
-	__le16 magic4;
-	u8 antenna;
+	u16:16;
+	u8 key_type;
+	u8 key_len;
+	u8 key[16];
+	u8 hw_queue;
+	u32:24;
+	u32:32;
+	u16:16;
+	u8 tx_antenna;
 	u8 output_power;
-	__le32 magic5;
+	u8 cts_rate;
+	u32:24;
 	u8 align[0];
 } __attribute__ ((packed));
 


