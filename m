Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:36916 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764716AbXH1Teq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 15:34:46 -0400
From: Chr <chunkeey@web.de>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: Recent linux-wireless git changes have broken my prism54pci card
Date: Tue, 28 Aug 2007 21:32:59 +0200
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
References: <46BFF10B.1090307@hhs.nl> <200708240100.17820.chunkeey@web.de> <46CEA8A2.3040906@hhs.nl>
In-Reply-To: <46CEA8A2.3040906@hhs.nl>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_rhH1GLgpYfGknhf"
Message-Id: <200708282132.59474.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_rhH1GLgpYfGknhf
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday, 24. August 2007, Hans de Goede wrote:
> Chr wrote:
> 
> Its a Sitecom WL-140 V2 (small letters at the bottom right of the front of the 
> box) aka the Sitecom Nitro XM 140G+
> 
> Note I think that the V2 is important to get the same one as mine, otherwise 
> you probably get an older fullmac version (if they still sell that anyware).
> 

Here we are:

series:
p54-pull-padding2.diff
p54-support-older-firmwares.diff

Signed-off will follow on friday/saturday... Michael, any complains?

Regards,
	Chr.

--Boundary-00=_rhH1GLgpYfGknhf
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="p54-pull-padding2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54-pull-padding2.diff"

diff -Nurp a/drivers/net/wireless/p54common.c b/drivers/net/wireless/p54common.c
--- a/drivers/net/wireless/p54common.c	2007-08-18 20:44:04.000000000 +0200
+++ b/drivers/net/wireless/p54common.c	2007-08-28 21:08:00.000000000 +0200
@@ -283,12 +283,13 @@ static void p54_rx_data(struct ieee80211
 	struct ieee80211_rx_status rx_status = {0};
 	u16 freq = le16_to_cpu(hdr->freq);
 
-	rx_status.ssi = hdr->rssi;	/* TODO: check this */
+	rx_status.ssi = hdr->rssi;
 	rx_status.rate = hdr->rate & 0x1f; /* report short preambles & CCK too */
 	rx_status.channel = freq == 2484 ? 14 : (freq - 2407)/5;
 	rx_status.freq = freq;
 	rx_status.phymode = MODE_IEEE80211G;
 	rx_status.antenna = hdr->antenna;
+	rx_status.mactime = le64_to_cpu(hdr->timestamp);
 
 	skb_pull(skb, sizeof(*hdr));
 	skb_trim(skb, le16_to_cpu(hdr->len));
@@ -324,6 +325,9 @@ static void p54_rx_frame_sent(struct iee
 		range = (struct memrecord *)&entry->cb;
 		if (range->start_addr == addr) {
 			struct ieee80211_tx_status status = {{0}};
+			struct p54_control_hdr *entry_hdr;
+			struct p54_tx_control_allocdata *entry_data;
+			int pad = 0;
 
 			if (entry->next != (struct sk_buff *)&priv->tx_queue)
 				freed = ((struct memrecord *)&entry->next->cb)->start_addr - last_addr;
@@ -339,14 +343,22 @@ static void p54_rx_frame_sent(struct iee
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
+			if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) != 0)
+				pad = entry_data->align[0];
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
 			break;
 		} else
@@ -897,7 +909,7 @@ struct ieee80211_hw *p54_init_common(siz
 		    IEEE80211_HW_DATA_NULLFUNC_ACK; /* TODO: check */
 		    /* IEEE80211_HW_MONITOR_DURING_OPER FIXME: check */
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
-	dev->max_rssi = 100;
+	dev->max_rssi = 127;
 
 	/* (hard) queue limits */
 	priv->tx_stats.data[0].limit = 3;
diff -Nurp a/drivers/net/wireless/p54common.h b/drivers/net/wireless/p54common.h
--- a/drivers/net/wireless/p54common.h	2007-08-18 20:44:04.000000000 +0200
+++ b/drivers/net/wireless/p54common.h	2007-08-28 19:53:13.000000000 +0200
@@ -168,7 +168,7 @@ struct p54_rx_hdr {
 	u8 antenna;
 	u8 rate;
 	u8 rssi;
-	u8 padding;
+	u8 quality;
 	u16 unknown2;
 	__le64 timestamp;
 	u8 data[0];

--Boundary-00=_rhH1GLgpYfGknhf
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="p54-support-older-firmwares.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54-support-older-firmwares.diff"

diff -Nurp a/drivers/net/wireless/p54common.c b/drivers/net/wireless/p54common.c
--- a/drivers/net/wireless/p54common.c	2007-08-28 21:08:00.000000000 +0200
+++ b/drivers/net/wireless/p54common.c	2007-08-28 21:11:06.000000000 +0200
@@ -30,9 +30,12 @@ MODULE_ALIAS("prism54common");
 void p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 {
 	struct p54_common *priv = dev->priv;
+	struct bootrec_exp_if *exp_if;
 	struct bootrec *bootrec;
 	u32 *data = (u32 *)fw->data;
 	u32 *end_data = (u32 *)fw->data + (fw->size >> 2);
+	size_t len;
+	int i;
 
 	if (priv->rx_start)
 		return;
@@ -46,7 +49,7 @@ void p54_parse_firmware(struct ieee80211
 	bootrec = (struct bootrec *) data;
 
 	while (bootrec->data <= end_data &&
-	       (bootrec->data + le32_to_cpu(bootrec->len)) <= end_data) {
+	       (bootrec->data + (len = le32_to_cpu(bootrec->len))) <= end_data) {
 		u32 code = le32_to_cpu(bootrec->code);
 		switch (code) {
 		case BR_CODE_COMPONENT_ID:
@@ -69,6 +72,11 @@ void p54_parse_firmware(struct ieee80211
 			}
 			break;
 		case BR_CODE_COMPONENT_VERSION:
+			priv->fw_version = kmalloc(len * 4, GFP_KERNEL);
+			if (!priv->fw_version)
+				return ;
+			snprintf(priv->fw_version, len * 4, "%s",
+				(unsigned char*)bootrec->data);
 			break;
 		case BR_CODE_DESCR:
 			priv->rx_start = le32_to_cpu(bootrec->data[1]);
@@ -76,6 +84,10 @@ void p54_parse_firmware(struct ieee80211
 			priv->rx_end = le32_to_cpu(bootrec->data[2]) - 0x3500;
 			break;
 		case BR_CODE_EXPOSED_IF:
+			exp_if = (struct bootrec_exp_if *) bootrec->data;
+			for (i = 0; i < (len * sizeof(*exp_if) / 4); i++)
+				if (exp_if[i].if_id == 0x1a)
+					priv->fw_variant = le16_to_cpu(exp_if[i].variant);
 			break;
 		case BR_CODE_DEPENDENT_IF:
 			break;
@@ -86,8 +98,25 @@ void p54_parse_firmware(struct ieee80211
 		default:
 			break;
 		}
-		bootrec = (struct bootrec *)&bootrec->data[le32_to_cpu(bootrec->len)];
+		bootrec = (struct bootrec *)&bootrec->data[len];
+	}
+
+	if (priv->fw_version)
+		printk(KERN_INFO "p54: Rev %s - Softmac protocol %x\n",
+			priv->fw_version, priv->fw_variant);
+		
+	/* Firmware supports QoS, enable it! */
+	if (priv->fw_variant >= 0x300) {
+		/* queue limits */
+		priv->tx_stats.data[0].limit = 3;
+		priv->tx_stats.data[1].limit = 4;
+		priv->tx_stats.data[2].limit = 3;
+		priv->tx_stats.data[3].limit = 1;
+		
+		dev->queues = 4;
 	}
+
+
 }
 EXPORT_SYMBOL_GPL(p54_parse_firmware);
 
@@ -911,13 +940,9 @@ struct ieee80211_hw *p54_init_common(siz
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
 	dev->max_rssi = 127;
 
-	/* (hard) queue limits */
-	priv->tx_stats.data[0].limit = 3;
-	priv->tx_stats.data[1].limit = 4;
-	priv->tx_stats.data[2].limit = 3;
-	priv->tx_stats.data[3].limit = 1;
+	priv->tx_stats.data[0].limit = 10;
+	dev->queues = 1;
 
-	dev->queues = 4;
 	dev->extra_tx_headroom = sizeof(struct p54_control_hdr) + 4 +
 				 sizeof(struct p54_tx_control_allocdata);
 
@@ -950,6 +975,7 @@ void p54_free_common(struct ieee80211_hw
 	kfree(priv->output_limit);
 	kfree(priv->curve_data);
 	kfree(priv->cached_vdcf);
+	kfree(priv->fw_version);
 }
 EXPORT_SYMBOL_GPL(p54_free_common);
 
diff -Nurp a/drivers/net/wireless/p54.h b/drivers/net/wireless/p54.h
--- a/drivers/net/wireless/p54.h	2007-08-28 12:00:54.000000000 +0200
+++ b/drivers/net/wireless/p54.h	2007-08-28 20:17:37.000000000 +0200
@@ -62,6 +62,8 @@ struct p54_common {
 	u8 version;
 	unsigned int tx_hdr_len;
 	void *cached_vdcf;
+	u8 *fw_version;
+	__le16 fw_variant;
 	/* FIXME: this channels/modes/rates stuff sucks */
 	struct ieee80211_channel channels[14];
 	struct ieee80211_rate rates[12];

--Boundary-00=_rhH1GLgpYfGknhf--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
