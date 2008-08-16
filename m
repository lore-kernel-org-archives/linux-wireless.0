Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:34581 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbYHPCSk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2008 22:18:40 -0400
From: Chr <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] p54: Fix for TX sequence number problem that resulted from commit 741b4fbc44
Date: Sat, 16 Aug 2008 04:21:32 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net> <200808152034.46346.chunkeey@web.de> <48A6209E.1020904@lwfinger.net>
In-Reply-To: <48A6209E.1020904@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808160421.33375.chunkeey@web.de> (sfid-20080816_041844_100249_0E95699E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 16 August 2008 02:34:38 Larry Finger wrote:
> This one lasted for 4 hours. What was worse is that it crashed my
> computer with a 1 Hz blink of the Caps Lock light when it failed. I
> hadn't seen that before.

hmm,.... sounds like a bit of a old problem with the minipci card...
p54_rx_frame_sent walks in the tx_queue without holding the tx_queue.lock.

However, this problem is next to impossible to trigger in the current code.
So, a crash log from a serial console would be great?
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-08-13 20:50:03.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-08-16 03:44:37.000000000 +0200
@@ -391,7 +391,9 @@ static void p54_rx_frame_sent(struct iee
 	struct memrecord *range = NULL;
 	u32 freed = 0;
 	u32 last_addr = priv->rx_start;
+	unsigned long flags;
 
+	spin_lock_irqsave(&priv->tx_queue.lock, flags);
 	while (entry != (struct sk_buff *)&priv->tx_queue) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(entry);
 		range = (void *)info->driver_data;
@@ -412,6 +414,7 @@ static void p54_rx_frame_sent(struct iee
 
 			last_addr = range->end_addr;
 			__skb_unlink(entry, &priv->tx_queue);
+			spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 			memset(&info->status, 0, sizeof(info->status));
 			entry_hdr = (struct p54_control_hdr *) entry->data;
 			entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
@@ -428,13 +431,24 @@ static void p54_rx_frame_sent(struct iee
 			info->status.retry_count = payload->retries - 1;
 			info->status.ack_signal = le16_to_cpu(payload->ack_rssi);
 			skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
+			if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+				struct ieee80211_hdr *ieee80211hdr =
+					(struct ieee80211_hdr *) entry->data;
+
+				if (skb->len >= sizeof(*hdr))
+					ieee80211hdr->seq_ctrl |= payload->seq;
+				else
+					WARN_ON(1);
+			}
 			ieee80211_tx_status_irqsafe(dev, entry);
-			break;
+			goto out;
 		} else
 			last_addr = range->end_addr;
 		entry = entry->next;
 	}
+	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 
+out:
 	if (freed >= IEEE80211_MAX_RTS_THRESHOLD + 0x170 +
 	    sizeof(struct p54_control_hdr))
 		p54_wake_free_queues(dev);
@@ -553,7 +567,6 @@ static int p54_tx(struct ieee80211_hw *d
 	struct ieee80211_tx_queue_stats *current_queue;
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr;
-	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
 	struct p54_tx_control_allocdata *txhdr;
 	size_t padding, len;
 	u8 rate, cts_rate = 0x20;
@@ -604,19 +617,6 @@ static int p54_tx(struct ieee80211_hw *d
 	if (padding)
 		txhdr->align[0] = padding;
 
-	/* FIXME: The sequence that follows is needed for this driver to
-	 * work with mac80211 since "mac80211: fix TX sequence numbers".
-	 * As with the temporary code in rt2x00, changes will be needed
-	 * to get proper sequence numbers on beacons. In addition, this
-	 * patch places the sequence number in the hardware state, which
-	 * limits us to a single virtual state.
-	 */
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
-		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
-			priv->seqno += 0x10;
-		ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
-		ieee80211hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
-	}
 	/* modifies skb->cb and with it info, so must be last! */
 	p54_assign_address(dev, skb, hdr, skb->len);
 
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-08-13 20:50:30.000000000 +0200
+++ b/drivers/net/wireless/p54/p54.h	2008-08-15 19:38:10.000000000 +0200
@@ -52,7 +52,6 @@ struct p54_common {
 	int (*open)(struct ieee80211_hw *dev);
 	void (*stop)(struct ieee80211_hw *dev);
 	int mode;
-	u16 seqno;
 	struct mutex conf_mutex;
 	u8 mac_addr[ETH_ALEN];
 	u8 bssid[ETH_ALEN];

