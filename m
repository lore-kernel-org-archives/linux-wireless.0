Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:35853 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYJQAWR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2008 20:22:17 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Warning from mac80211 with p54usb
Date: Fri, 17 Oct 2008 02:26:28 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
References: <48F7D0D2.6090604@lwfinger.net>
In-Reply-To: <48F7D0D2.6090604@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200810170226.28774.chunkeey@web.de> (sfid-20081017_022221_125732_C0F4A45A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 17 October 2008 01:40:02 Larry Finger wrote:

Hi!

> Many thanks for the renaming of the firmware for p54usb. With this change, I can
> keep an old version of the firmware (2.5.8.0.arm) named isl3887usb_bare and a
> new one (2.13.1.0.arm.1) named isl3887usb in /lib/firmware and run the trees
> from Linus and wireless-testing without messing with the firmware.
> 
> I have discovered one anomaly that shows up with firmware 2.5.8.0.arm. If the
> USB device is unplugged and replugged, mac80211 will log the warning from
> net/mac80211/main.c:234 because p54_config() returns an error. The source of the
> error is p54_assign_address(), where target_skb is NULL. That happens because
> priv->rx_end - last_addr is 32 whereas the value of len is 160 - thus target_skb
> never gets set.
hmm, either p54_assign_address, p54_free_skb & p54_rx_frame_sent have a
major flaw, or simple the device ran out of "free" memory.

Now, normally this won't happen very often since the "window" is about 32kb,
which should be really enough. So, the question is why doesn't the firmware 
notify the driver to free up space again... so the window fills up, until
everything collapse.

> 
> I have not seen this problem with firmware 2.13.1.arm.1, nor does it occur if
> the driver is removed before the USB device is replugged.
Well, I avoid 2.5.8.0 firmware. It reports "LM86", so technically it should made
for the first generation USB devices and not for the ISL3887 chip.

> If you have any suggestions regarding debugging, please let me know.
I've attached a debug function that could help to take a look inside the memory
management. what does it look like when put p54_dump_txqueue into 
p54_start/p54_stop or p54_add_interface and replug your device?

or... something totally different. p54_rx_frame_sent could be culprit,
maybe we should check if the printk
>
 	goto out;
 }
+ printk(KERN_ERR "p54: leaked frame %p\n", entry);
 spin_unlock_irqrestore(&priv->tx_queue.lock, flags);

 out:
<
get's triggered.

Regards,
	Chr
---
static void p54_dump_txqueue(struct ieee80211_hw *dev)
{
	struct p54_common *priv = dev->priv;
	struct sk_buff *skb = priv->tx_queue.next;
	struct ieee80211_tx_info *info;
	struct memrecord *range;
	unsigned long flags;
	u32 last_addr = priv->rx_start, free = 0, total_free = 0;
	u32 queue_len, biggest_free_hole = 0;

	spin_lock_irqsave(&priv->tx_queue.lock, flags);

	queue_len = skb_queue_len(&priv->tx_queue);

	printk(KERN_DEBUG "%s: Tx queue entries: %d\n",
	       wiphy_name(dev->wiphy), queue_len);

	while (queue_len--) {
		info = IEEE80211_SKB_CB(skb);
		range = (void *)info->rate_driver_data;
		free = range->start_addr - last_addr;
		if (free > biggest_free_hole)
			biggest_free_hole = free;
		total_free += free;
		printk(KERN_DEBUG "\tentry: %p (range: [%x-%x]=(%x) free:%x)\n",
			skb, range->start_addr, range->end_addr,
			range->end_addr - range->start_addr, free);
		last_addr = range->end_addr;
		skb = skb->next;
	}
	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);

	free = priv->rx_end - last_addr;
	if (free > biggest_free_hole)
		biggest_free_hole = free;

	total_free += free;
	printk(KERN_DEBUG "\tlast entry: (range: [%x-%x] free: %d)\n",
			last_addr, priv->rx_end, free);
	printk(KERN_DEBUG "\ttotal_free:%d bytes, biggest free hole:%d bytes\n",
		total_free, biggest_free_hole);
}
