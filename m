Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:37937 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758780AbXHWOnq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 10:43:46 -0400
From: Chr <chunkeey@web.de>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: Recent linux-wireless git changes have broken my prism54pci card
Date: Thu, 23 Aug 2007 16:43:43 +0200
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
References: <46BFF10B.1090307@hhs.nl> <200708201351.45575.chunkeey@web.de> <46CD6E5F.9040601@hhs.nl>
In-Reply-To: <46CD6E5F.9040601@hhs.nl>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_f0ZzGBTMXx8oh/S"
Message-Id: <200708231643.43741.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_f0ZzGBTMXx8oh/S
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday, 23. August 2007, Hans de Goede wrote:
> 
> I'm afraid that my reception quality varies wildly. I don't know why, I'll try 
> to configure a different channel on the AP the next time I do some testing.
> 
Ok, maybe someone has cooked a meal in a microwave oven, or
something like that...
 
> 
> Replying to other mail in one go:
> 
> Chr wrote:
>  > I made two patches:
>  >
>  > the p54-pull-padding.diff should finally fix the rate algorithm for 
> "everyone" and as
>  > a bonus for developers: it adds a printk for the firmware revision p54 is using.
>  >
> 
> Cool I'll give this a try tonight, I really wanted to try it sooner, but ...
> 
k, I'll wait ;-)

BTW: There's already a newer version of it... see attachment.

> 
> Hmm, could this be made conditionally on the firmware revision perhaps? I don't 
> like having to patch my kernel every update, and more importantly, my card is a 
> pretty popular el cheapo sitecom, which are stacked by the dozen by every 
> computershop in town, so it would be nice if this worked out of the box.
> 
Of course! This patch is just a "test" patch, because you never know if it's "this" or "that"...
Probably, it's only necessary to hardcode "txhdr->frame_type = 4;" in p54_tx again. 

> I'll try to see if 2.5.2.0 will work with my card, I think I've tried before 
> but you never know, will 2.5.2.0 be good enough for the QoS/WME/WMM/IEEE802.11e 
> features?

AFAIK Michael uses this revision too and he would not have merged the QoS patch, if it
was completly unusable or faulty... So I think 2.5.2 will be fine, if it works with your card.
(However, 2.7.0.0 is recommend, because it's one of the few FWs for which we have
additional debugging and testing facilities...)

> Maybe it would be an idea to dump the eeprom from the driver with the 2.4.12.0 
> firmware, and then fake the eeprom in the driver using newer firmware to see if 
> the eeprom reading is the only problem with newer firmware and my card ?

Hmm, I don't think that the firmware somehow changes the eeprom.

Thanks,
	Chr.

--Boundary-00=_f0ZzGBTMXx8oh/S
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="p54-pull-padding.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54-pull-padding.diff"

diff -Nurp a/drivers/net/wireless/p54common.c b/drivers/net/wireless/p54common.c
--- a/drivers/net/wireless/p54common.c	2007-08-18 20:44:04.000000000 +0200
+++ b/drivers/net/wireless/p54common.c	2007-08-23 15:50:12.000000000 +0200
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
@@ -339,15 +345,26 @@ static void p54_rx_frame_sent(struct iee
 			memcpy(&status.control, range->control,
 			       sizeof(status.control));
 			kfree(range->control);
-			if (!payload->status)
-				status.flags |= IEEE80211_TX_STATUS_ACK;
-			else
-				status.excessive_retries = 1;
+			priv->tx_stats.data[status.control.queue].len--;
+
+			entry_hdr = (struct p54_control_hdr *) entry->data;
+			entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
+			if (entry_hdr->magic1 & cpu_to_le16(0x4000))
+				pad = entry_data->align[0];
+			else 
+				pad = 0;
+
+			if (!status.control.flags & IEEE80211_TXCTL_NO_ACK) {
+				if (!(payload->status & 0x01))
+					status.flags |= IEEE80211_TX_STATUS_ACK;
+				else
+					status.excessive_retries = 1;
+			}
 			status.retry_count = payload->retries - 1;
 			status.ack_signal = le16_to_cpu(payload->ack_rssi);
-			skb_pull(entry, sizeof(*hdr) + sizeof(struct p54_tx_control_allocdata));
-			priv->tx_stats.data[status.control.queue].len--;
+			skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
 			ieee80211_tx_status_irqsafe(dev, entry, &status);
+
 			break;
 		} else
 			last_addr = range->end_addr;
@@ -486,6 +503,7 @@ static int p54_tx(struct ieee80211_hw *d
 		ieee80211_stop_queue(dev, control->queue);
 
 	padding = (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))) & 3;
+
 	len = skb->len;
 
 	control_copy = kmalloc(sizeof(*control), GFP_ATOMIC);
@@ -496,10 +514,12 @@ static int p54_tx(struct ieee80211_hw *d
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
@@ -515,6 +535,9 @@ static int p54_tx(struct ieee80211_hw *d
 		rate |= 0x40;
 	else if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
 		rate |= 0x20;
+	else 
+		hdr->magic1 |= cpu_to_le16(0x0010);
+
 	memset(txhdr->rateset, rate, 8);
 	txhdr->wep_key_present = 0;
 	txhdr->wep_key_len = 0;
@@ -525,8 +548,6 @@ static int p54_tx(struct ieee80211_hw *d
 	txhdr->output_power = 0x7f; // HW Maximum
 	txhdr->magic5 = (control->flags & IEEE80211_TXCTL_NO_ACK) ?
 		0 : ((rate > 0x3) ? cpu_to_le32(0x33) : cpu_to_le32(0x23));
-	if (padding)
-		txhdr->align[0] = padding;
 
 	priv->tx(dev, hdr, skb->len, 0);
 	return 0;
@@ -938,6 +959,7 @@ void p54_free_common(struct ieee80211_hw
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

--Boundary-00=_f0ZzGBTMXx8oh/S--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
