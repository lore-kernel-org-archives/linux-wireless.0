Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:60360 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbZAUQEk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 11:04:40 -0500
Received: by ug-out-1314.google.com with SMTP id 39so370684ugf.37
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jan 2009 08:04:38 -0800 (PST)
Message-ID: <49774794.507@gmail.com> (sfid-20090121_170447_550692_599750D7)
Date: Wed, 21 Jan 2009 17:04:36 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC][RFT][PATCH] p54usb: rx refill revamp
References: <200901211450.50880.chunkeey@web.de>
In-Reply-To: <200901211450.50880.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> This patch fixes a long standing issue in p54usb.
> 
> Under high memory pressure, dev_alloc_skb couldn't always allocate a 
> replacement skb. In such situations, we had to free the associated urb.
> And over the time all urbs were eventually gone altogether and 
> obviously the device remained mute from then on.

Yes, that's one of the things that is (well, was) on my todo list after 
reading p54usb.c, so i obviously like the idea ;)

I'll write down some of the other things as they are related to this.
It will take at least a few days for me do do and properly test, hence
if you find the comments below useful i won't mind. ;)

This patch makes the usb rx path alloc-less (except for the actual urb
submission call) which is good, but i wonder if we should try a GFP_NOWAIT
allocation, and only fallback if that one fails. Was going to do some
measuring before implementing it, to see if starvation was a risk. Maybe
only alloc in irq if the rx queue shrinks too much.

The net2280 tx path does at least three allocs, one tiny never-changing buffer
and two urbs, i'd like to get rid of all of them. The constant buffer is
easy - we can just kmalloc a cacheline-sized chunk on init, and (re)use that.
As to the urbs, i originally wanted to put (at least one of) them in the skb
headroom. But the fact that the skb can be freed before the completions run 
makes that impossible. That leaves keeping them around on a list and reusing
them. And as if you maintain a list for the rx path it comes naturally to
reuse it for tx as well. (obviously if the list is empty we have to create a
new urb, but the common case should be zero allocations).


Do you have a git tree, or some kind of patch queue, with all the pending p54
patches? Working on top of wireless-testing makes it harder to test.
What was this patch made against?

artur

[a few comments inline below]

> +	if (p54_rx(dev, skb) == 0) {
> +		/*
> +		 * This skb can be reused.
> +		 * Undo all modifications and resubmit it.
> +		 */
>  
>  		if (priv->hw_type == P54U_NET2280)
>  			skb_push(skb, priv->common.tx_hdr_len);
>  		if (priv->common.fw_interface == FW_LM87) {
> @@ -129,14 +124,47 @@ static void p54u_rx_cb(struct urb *urb)
>  			WARN_ON(1);
>  			urb->transfer_buffer = skb_tail_pointer(skb);
>  		}
> +
> +		usb_anchor_urb(urb, &priv->submitted);
> +		if (usb_submit_urb(urb, GFP_ATOMIC) == 0) {
> +			skb_queue_tail(&priv->rx_queue, skb);
> +			return ;
> +		} else {
> +			usb_unanchor_urb(urb);
> +			dev_kfree_skb_irq(skb);
> +		}
>  	}
> +
> +	/*
> +	 * This skb CANNOT be reused.
> +	 * Put the now unused urb into a list and do the refilled later on in
> +	 * the less critical workqueue thread. 
> +	 * This eases the memory pressure and prevents latency spikes.
> +	 */
> +
> +	urb->transfer_buffer = NULL;
> +	urb->context = NULL;
> +
> +	spin_lock_irqsave(&priv->rx_refill_lock, flags);
> +	list_add_tail(&urb->urb_list, &priv->rx_refill_list);
> +	spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
> +
> +	/*
> +	 * Don't let the usb stack free the queued urb after this completion
> +	 * callback has finished.
> +	 */
> +	usb_get_urb(urb);
> +
> +	if (unlikely(!priv->common.hw->workqueue)) {
> +		/*
> +		 * Huh? mac80211 isn't fully initialized yet?
> +		 * Please check your system, something bad is going on.
> +		 */
> +		WARN_ON(1);
> +		return;
>  	}
> +
> +	queue_work(priv->common.hw->workqueue, &priv->rx_refill_work);
>  }
>  
>  static void p54u_tx_cb(struct urb *urb)
> @@ -150,58 +178,115 @@ static void p54u_tx_cb(struct urb *urb)
>  
>  static void p54u_tx_dummy_cb(struct urb *urb) { }
>  
> +static void p54u_rx_refill_free_list(struct ieee80211_hw *dev)

the name is a bit misleading...
s/p54u_rx_refill_free_list/p54u_free_rx_refill_list/ ?

> +{
> +	struct p54u_priv *priv = dev->priv;
> +	struct urb *entry, *tmp;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&priv->rx_refill_lock, flags);
> +	list_for_each_entry_safe(entry, tmp, &priv->rx_refill_list, urb_list) {
> +		list_del(&entry->urb_list);
> +		usb_free_urb(entry);
> +	}
> +	spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
> +}
> +
>  static void p54u_free_urbs(struct ieee80211_hw *dev)
>  {
>  	struct p54u_priv *priv = dev->priv;
> +
>  	usb_kill_anchored_urbs(&priv->submitted);
> +	cancel_work_sync(&priv->rx_refill_work);
> +	p54u_rx_refill_free_list(dev);
>  }
>  
> +static int p54u_rx_refill(struct ieee80211_hw *dev)
>  {
>  	struct p54u_priv *priv = dev->priv;
> +	struct urb* entry, *tmp;
> +	unsigned long flags, flags2;
>  
> +	spin_lock_irqsave(&priv->rx_refill_lock, flags);
> +	list_for_each_entry_safe(entry, tmp, &priv->rx_refill_list, urb_list) {
> +		struct p54u_rx_info *info;
> +		struct sk_buff *skb;
> +
> +		list_del(&entry->urb_list);
> +		spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
>  		skb = __dev_alloc_skb(priv->common.rx_mtu + 32, GFP_KERNEL);
> +
> +		if (unlikely(!skb)) {
> +			/*
> +			 * In order to prevent a loop, we put the urb
> +			 * back at the _front_ of the list, so we can
> +			 * march on, in out-of-memory situations.
> +			 */
> +
> +			spin_lock_irqsave(&priv->rx_refill_lock, flags);
> +			list_add(&entry->urb_list, &priv->rx_refill_list);
> +			continue;
>  		}
>  
>  		usb_fill_bulk_urb(entry, priv->udev,
>  				  usb_rcvbulkpipe(priv->udev, P54U_PIPE_DATA),
>  				  skb_tail_pointer(skb),
>  				  priv->common.rx_mtu + 32, p54u_rx_cb, skb);
> +
>  		info = (struct p54u_rx_info *) skb->cb;
>  		info->urb = entry;
>  		info->dev = dev;
> +		spin_lock_irqsave(&priv->rx_queue.lock, flags2);
> +		__skb_queue_tail(&priv->rx_queue, skb);
>  
>  		usb_anchor_urb(entry, &priv->submitted);
> +		if (usb_submit_urb(entry, GFP_ATOMIC)) {

GFP_KERNEL? [would need dropping rx_queue.lock earlier and retaking in the
(hopefully rare) error path]

> +			/*
> +			 * urb submittion failed.
> +			 * free the associated skb and put the urb back into 
> +			 * the front of the refill list, so we can 
> +			 * try our luck next time.
> +			 */
> +
> +			__skb_unlink(skb, &priv->rx_queue);
> +			spin_unlock_irqrestore(&priv->rx_queue.lock, flags);
> +			kfree_skb(skb);
> +			spin_lock_irqsave(&priv->rx_refill_lock, flags);
> +			list_add(&entry->urb_list, &priv->rx_refill_list);
> +			spin_unlock_irqrestore(&priv->rx_refill_lock, flags);

'entry' is now both anchored in priv->submitted and in the rx_refill_list.
also, a ref will be dropped by the free_urb() below.

>  		}
> +		spin_unlock_irqrestore(&priv->rx_queue.lock, flags2);
>  		usb_free_urb(entry);
> +		spin_lock_irqsave(&priv->rx_refill_lock, flags);
>  	}
> +	spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
>  	return 0;
> +}
