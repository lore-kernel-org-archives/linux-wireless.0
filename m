Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:56346 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbXHTAoh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 20:44:37 -0400
From: Chr <chunkeey@web.de>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: Recent linux-wireless git changes have broken my prism54pci card
Date: Mon, 20 Aug 2007 02:44:22 +0200
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
References: <46BFF10B.1090307@hhs.nl> <200708140025.56708.chunkeey@web.de> <46C1638C.7070704@hhs.nl>
In-Reply-To: <46C1638C.7070704@hhs.nl>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_mPOyG/9IgTLP8ct"
Message-Id: <200708200244.22841.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_mPOyG/9IgTLP8ct
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday, 14. August 2007, Hans de Goede wrote:

Hans,

Any updates? Or are you on holiday?

I've prepared a patch, which should theoretically lower the excessive retry count.

however I don't think it will magically solve anything...


OT: Michael/anyone else:

1. Do you know why the rate algorithm (rc80211_simple) starts with the lowest speed?
  or is this really only a p54 bug?
 
2. Is there any way to get a station aid (in ap mode) and dtim period
 without lots of castings or "new variables" in struct ieee80211_tx_control?
 I really need them for AP mode (yes, I have a "proof of concept" for it,
 the hardest thing was to compile hostapd ;-) ).

Thanks,
	Chr.



--Boundary-00=_mPOyG/9IgTLP8ct
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="p54-tx-status-is-not-always-necessary.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54-tx-status-is-not-always-necessary.diff"

diff -Nurp a/drivers/net/wireless/p54common.c b/drivers/net/wireless/p54common.c
--- a/drivers/net/wireless/p54common.c	2007-08-18 20:44:04.000000000 +0200
+++ b/drivers/net/wireless/p54common.c	2007-08-20 02:20:53.000000000 +0200
@@ -315,9 +315,11 @@ static void p54_rx_frame_sent(struct iee
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
@@ -339,15 +341,27 @@ static void p54_rx_frame_sent(struct iee
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
-			ieee80211_tx_status_irqsafe(dev, entry, &status);
+
+			if (status.control.flags & IEEE80211_TXCTL_REQ_TX_STATUS) {
+				entry_hdr = (struct p54_control_hdr *) entry->data;
+				entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
+				if (entry_hdr->magic1 == cpu_to_le16(0x4010))
+					pad = entry_data->align[0];
+				else
+					pad = 0;
+
+				if (!payload->status)
+					status.flags |= IEEE80211_TX_STATUS_ACK;
+				else
+					status.excessive_retries = 1;
+				status.retry_count = payload->retries - 1;
+				status.ack_signal = le16_to_cpu(payload->ack_rssi);
+				skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
+				ieee80211_tx_status_irqsafe(dev, entry, &status);
+			} else
+                                dev_kfree_skb_irq(entry);
+
 			break;
 		} else
 			last_addr = range->end_addr;

--Boundary-00=_mPOyG/9IgTLP8ct--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
