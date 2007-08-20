Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:42546 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759704AbXHTWO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 18:14:29 -0400
From: Chr <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Recent linux-wireless git changes have broken my prism54pci card
Date: Tue, 21 Aug 2007 00:14:26 +0200
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
References: <46BFF10B.1090307@hhs.nl> <200708201351.45575.chunkeey@web.de> <1187612256.6090.104.camel@johannes.berg>
In-Reply-To: <1187612256.6090.104.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_CJhyGxRNOlnuDcc"
Message-Id: <200708210014.26242.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_CJhyGxRNOlnuDcc
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday, 20. August 2007, Johannes Berg wrote:
> On Mon, 2007-08-20 at 13:51 +0200, Chr wrote:
> 
> > "pyh2: not handling 0x02 type control frame" (could be the FW)
> 
> The driver, I assume.
No, it's really the firmware. I've "finally" tried the 2.4.12.0 and got the same messages... 
But, I didn't get them with 2.7.0.0 or 2.5.2.0.

Moreover, because of some "unknown reason" 2.4.12.0 does not work very well with
my isl3880 chip, I cannot tx/rx any QoS data frame... And probably, it's because the
feature is not supported by the firmware...  

I made two patches:

the p54-pull-padding.diff should finally fix the rate algorithm for "everyone" and as 
a bonus for developers: it adds a printk for the firmware revision p54 is using.
(If noone complains within a week, I'll write a official patch post for it...)

p54-remove-qos.diff (must be applied on top of p54-pull-padding.diff) is _only_ for
Hans...  It removes/reverts QoS/WME/WMM/IEEE802.11e features.

Thanks,
	Chr

    




--Boundary-00=_CJhyGxRNOlnuDcc
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="p54-pull-padding.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54-pull-padding.diff"

diff -Nurp a/drivers/net/wireless/p54common.c b/drivers/net/wireless/p54common.c
--- a/drivers/net/wireless/p54common.c	2007-08-18 20:44:04.000000000 +0200
+++ b/drivers/net/wireless/p54common.c	2007-08-20 23:06:46.000000000 +0200
@@ -48,6 +48,7 @@ void p54_parse_firmware(struct ieee80211
 	while (bootrec->data <= end_data &&
 	       (bootrec->data + le32_to_cpu(bootrec->len)) <= end_data) {
 		u32 code = le32_to_cpu(bootrec->code);
+		size_t len = le32_to_cpu(bootrec->len);
 		switch (code) {
 		case BR_CODE_COMPONENT_ID:
 			switch (be32_to_cpu(*bootrec->data)) {
@@ -69,6 +70,9 @@ void p54_parse_firmware(struct ieee80211
 			}
 			break;
 		case BR_CODE_COMPONENT_VERSION:
+			priv->fw_version = kmalloc(len * 4, GFP_KERNEL);
+			snprintf(priv->fw_version, len * 4, "%s", (char*)bootrec->data);
+			printk(KERN_INFO "p54: firmware version %s\n", priv->fw_version);
 			break;
 		case BR_CODE_DESCR:
 			priv->rx_start = le32_to_cpu(bootrec->data[1]);
@@ -86,7 +90,7 @@ void p54_parse_firmware(struct ieee80211
 		default:
 			break;
 		}
-		bootrec = (struct bootrec *)&bootrec->data[le32_to_cpu(bootrec->len)];
+		bootrec = (struct bootrec *)&bootrec->data[len];
 	}
 }
 EXPORT_SYMBOL_GPL(p54_parse_firmware);
@@ -315,9 +319,11 @@ static void p54_rx_frame_sent(struct iee
 	struct p54_control_hdr *hdr = (struct p54_control_hdr *) skb->data;
 	struct p54_frame_sent_hdr *payload = (struct p54_frame_sent_hdr *) hdr->data;
 	struct sk_buff *entry = (struct sk_buff *) priv->tx_queue.next;
+	struct p54_control_hdr *entry_hdr;
+	struct p54_tx_control_allocdata *entry_data;
 	u32 addr = le32_to_cpu(hdr->req_id) - 0x70;
 	struct memrecord *range = NULL;
-	u32 freed = 0;
+	u32 freed = 0, pad = 0;
 	u32 last_addr = priv->rx_start;
 
 	while (entry != (struct sk_buff *)&priv->tx_queue) {
@@ -339,15 +345,25 @@ static void p54_rx_frame_sent(struct iee
 			memcpy(&status.control, range->control,
 			       sizeof(status.control));
 			kfree(range->control);
-			if (!payload->status)
-				status.flags |= IEEE80211_TX_STATUS_ACK;
-			else
-				status.excessive_retries = 1;
-			status.retry_count = payload->retries - 1;
-			status.ack_signal = le16_to_cpu(payload->ack_rssi);
-			skb_pull(entry, sizeof(*hdr) + sizeof(struct p54_tx_control_allocdata));
 			priv->tx_stats.data[status.control.queue].len--;
+
+			entry_hdr = (struct p54_control_hdr *) entry->data;
+			entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
+			if (entry_hdr->magic1 & cpu_to_le16(0x4000))
+				pad = entry_data->align[0];
+			else 
+				pad = 0;
+			if (status.control.flags & IEEE80211_TXCTL_NO_ACK) {
+				if (!(payload->status & 0x01))
+					status.flags |= IEEE80211_TX_STATUS_ACK;
+				else
+					status.excessive_retries = 1;
+				status.retry_count = payload->retries - 1;
+				status.ack_signal = le16_to_cpu(payload->ack_rssi);
+			}
+			skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
 			ieee80211_tx_status_irqsafe(dev, entry, &status);
+
 			break;
 		} else
 			last_addr = range->end_addr;
@@ -486,6 +502,7 @@ static int p54_tx(struct ieee80211_hw *d
 		ieee80211_stop_queue(dev, control->queue);
 
 	padding = (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))) & 3;
+
 	len = skb->len;
 
 	control_copy = kmalloc(sizeof(*control), GFP_ATOMIC);
@@ -496,10 +513,12 @@ static int p54_tx(struct ieee80211_hw *d
 			skb_push(skb, sizeof(*txhdr) + padding);
 	hdr = (struct p54_control_hdr *) skb_push(skb, sizeof(*hdr));
 
-	if (padding)
-		hdr->magic1 = cpu_to_le16(0x4010);
-	else
-		hdr->magic1 = cpu_to_le16(0x0010);
+	if (padding) {
+		hdr->magic1 = cpu_to_le16(0x4000);
+		txhdr->align[0] = padding;
+	} else
+		hdr->magic1 = cpu_to_le16(0x0000);
+
 	hdr->len = cpu_to_le16(len);
 	hdr->type = (control->flags & IEEE80211_TXCTL_NO_ACK) ? 0 : cpu_to_le16(1);
 	hdr->retry1 = hdr->retry2 = control->retry_limit;
@@ -515,6 +534,9 @@ static int p54_tx(struct ieee80211_hw *d
 		rate |= 0x40;
 	else if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
 		rate |= 0x20;
+	else 
+		hdr->magic1 |= cpu_to_le16(0x0010);
+
 	memset(txhdr->rateset, rate, 8);
 	txhdr->wep_key_present = 0;
 	txhdr->wep_key_len = 0;
@@ -525,8 +547,6 @@ static int p54_tx(struct ieee80211_hw *d
 	txhdr->output_power = 0x7f; // HW Maximum
 	txhdr->magic5 = (control->flags & IEEE80211_TXCTL_NO_ACK) ?
 		0 : ((rate > 0x3) ? cpu_to_le32(0x33) : cpu_to_le32(0x23));
-	if (padding)
-		txhdr->align[0] = padding;
 
 	priv->tx(dev, hdr, skb->len, 0);
 	return 0;
@@ -938,6 +958,7 @@ void p54_free_common(struct ieee80211_hw
 	kfree(priv->output_limit);
 	kfree(priv->curve_data);
 	kfree(priv->cached_vdcf);
+	kfree(priv->fw_version);
 }
 EXPORT_SYMBOL_GPL(p54_free_common);
 
diff -Nurp a/drivers/net/wireless/p54.h b/drivers/net/wireless/p54.h
--- a/drivers/net/wireless/p54.h	2007-08-18 20:44:04.000000000 +0200
+++ b/drivers/net/wireless/p54.h	2007-08-20 23:05:45.000000000 +0200
@@ -60,6 +60,7 @@ struct p54_common {
 	struct pda_pa_curve_data *curve_data;
 	__le16 rxhw;
 	u8 version;
+	char *fw_version;
 	unsigned int tx_hdr_len;
 	void *cached_vdcf;
 	/* FIXME: this channels/modes/rates stuff sucks */

--Boundary-00=_CJhyGxRNOlnuDcc
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="p54-remove-qos.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54-remove-qos.diff"

diff -Nurp a/drivers/net/wireless/p54common.c b/drivers/net/wireless/p54common.c
--- a/drivers/net/wireless/p54common.c	2007-08-20 23:06:46.000000000 +0200
+++ b/drivers/net/wireless/p54common.c	2007-08-20 23:41:07.000000000 +0200
@@ -345,7 +345,7 @@ static void p54_rx_frame_sent(struct iee
 			memcpy(&status.control, range->control,
 			       sizeof(status.control));
 			kfree(range->control);
-			priv->tx_stats.data[status.control.queue].len--;
+			priv->tx_stats.data[0].len--;
 
 			entry_hdr = (struct p54_control_hdr *) entry->data;
 			entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
@@ -493,13 +493,13 @@ static int p54_tx(struct ieee80211_hw *d
 	size_t padding, len;
 	u8 rate;
 
-	current_queue = &priv->tx_stats.data[control->queue];
+	current_queue = &priv->tx_stats.data[0];
 	if (unlikely(current_queue->len > current_queue->limit))
 		return NETDEV_TX_BUSY;
 	current_queue->len++;
 	current_queue->count++;
 	if (current_queue->len == current_queue->limit)
-		ieee80211_stop_queue(dev, control->queue);
+		ieee80211_stop_queue(dev, 0);
 
 	padding = (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))) & 3;
 
@@ -540,7 +540,7 @@ static int p54_tx(struct ieee80211_hw *d
 	memset(txhdr->rateset, rate, 8);
 	txhdr->wep_key_present = 0;
 	txhdr->wep_key_len = 0;
-	txhdr->frame_type = cpu_to_le32(control->queue + 4);
+	txhdr->frame_type = 4;
 	txhdr->magic4 = 0;
 	txhdr->antenna = (control->antenna_sel_tx == 0) ?
 		2 : control->antenna_sel_tx - 1;
@@ -920,12 +920,9 @@ struct ieee80211_hw *p54_init_common(siz
 	dev->max_rssi = 100;
 
 	/* (hard) queue limits */
-	priv->tx_stats.data[0].limit = 3;
-	priv->tx_stats.data[1].limit = 4;
-	priv->tx_stats.data[2].limit = 3;
-	priv->tx_stats.data[3].limit = 1;
+	priv->tx_stats.data[0].limit = 4;
 
-	dev->queues = 4;
+	dev->queues = 1;
 	dev->extra_tx_headroom = sizeof(struct p54_control_hdr) + 4 +
 				 sizeof(struct p54_tx_control_allocdata);
 

--Boundary-00=_CJhyGxRNOlnuDcc--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
