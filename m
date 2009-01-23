Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:24880 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570AbZAWW7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 17:59:14 -0500
Received: by nf-out-0910.google.com with SMTP id d3so866715nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 14:59:11 -0800 (PST)
Message-ID: <497A4BBB.30809@gmail.com> (sfid-20090123_235917_313198_D63A95DC)
Date: Fri, 23 Jan 2009 23:59:07 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org,
	Artur Skawina <art.08.09@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC][PATCH v2] p54usb: rx refill revamp
References: <200901232245.15216.chunkeey@web.de>
In-Reply-To: <200901232245.15216.chunkeey@web.de>
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
> 
> Thanks go out to Artur Skawina for all the reviews, ideas and code! 
> ---
> Changes:
> 	- remove workqueue check (now, the workqueue is always there!)
> 	- added Artur's comments
> 	- added Artur's ideas (use poison & unpoison, emergency refill etc...)
> 	- handle urb->status error codes
> 		So now it depends on the error-code if we resubmit the urb & skb,
> 		or queue it in rx_refill_list and free it later.
> 
> I hope Artur, I could meet all of your demands this time.;-)

There never were any 'demands', I had to spend way too much time hunting
that data corruption bug, and in the process had to learn more than i ever
wanted about the driver ;) So responding to your rfc was the obvious thing
to do; feel free to ignore any comments that you think aren't useful.
I have absolutely no problem with doing the work myself, it's just that you
were fixing bugs that affected my device faster than i was able to run tests;
so i never got around to send patches. In fact, i'll be waiting until this
patch goes in, before even starting to work on some other changes, some of
which i've already mentioned (and others that, afaict, would require changes
to the usb stack, don't ask ;))

This patch reorganizes the code so much, i'll have to read it in context
later, this time only a few comments/questions, i hope you don't mind :)

> +static void p54u_cancel_urbs(struct ieee80211_hw *dev)
> +{
> +	struct p54u_priv *priv = dev->priv;
> +
> +	usb_poison_anchored_urbs(&priv->submitted);
> +	/*
> +	 * By now every RX URB has either finished or been canceled;
> +	 * the p54u_rx_cb() completion has placed it on the refill
> +	 * list; any attempts to resubmit from p54u_rx_refill(),
> +	 * which could still be scheduled to run, will fail.
> +	 */
> +	cancel_work_sync(&priv->rx_refill_work);
> +
> +	/*
> +	 * Unpoison all URBs in the rx_refill_list, so they can be reused.
> +	 */
> +	p54u_unpoison_rx_refill_list(dev);

I'm curious why you keep the urbs around in the stopped state?
The alloc/free/alloc sequence on init may not be that pretty, but
is there some other reason?

> +	/*
> +	 * Unpoison the anchor itself; the old URBs are already gone,
> +	 * p54u_rx_cb() has moved them all to the refill list.
> +	 * Prevents new URBs from being poisoned when anchored.
> +	 */
> +	usb_unpoison_anchored_urbs(&priv->submitted);
> +}
> +
> +static int p54u_rx_refill(struct ieee80211_hw *dev)
> +{
> +	struct p54u_priv *priv = dev->priv;
> +	struct urb *entry, *tmp;
> +	unsigned long flags;
> +	unsigned int refilled_urbs = 0;
> +	int err = -EINVAL;
> +
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
> +			 * In order to prevent a loop, we put the URB
> +			 * back at the _front_ of the list, so we can
> +			 * march on, in out-of-memory situations.
> +			 */
> +
> +			spin_lock_irqsave(&priv->rx_refill_lock, flags);
> +			list_add(&entry->urb_list, &priv->rx_refill_list);
> +			err = -ENOMEM;
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
>  
>  		usb_anchor_urb(entry, &priv->submitted);
> +		err = usb_submit_urb(entry, GFP_KERNEL);
> +		if (err) {

Hmm, won't this path (ie the foreach loop) be executed many times when
canceling the urbs? (that's why i was returning early on -EPERM in my
patch, but have not actually checked if it's an issue. yet.)

> +			/*
> +			 * URB submission failed.
> +			 * Free the associated skb and put the URB back into
> +			 * the front of the refill list, so we can try our luck
> +			 * next time.
> +			 */
> +
>  			usb_unanchor_urb(entry);
> +			kfree_skb(skb);
> +			spin_lock_irqsave(&priv->rx_refill_lock, flags);
> +			list_add(&entry->urb_list, &priv->rx_refill_list);
> +		} else {
> +			skb_queue_tail(&priv->rx_queue, skb);
> +			refilled_urbs++;
> +			spin_lock_irqsave(&priv->rx_refill_lock, flags);
>  		}
> +	}
> +	spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
> +	return refilled_urbs ? 0 : err;
> +}
> +
> +static int p54u_open(struct ieee80211_hw *dev)
> +{
> +	struct p54u_priv *priv = dev->priv;
> +	int err;
> +
> +	err = p54u_rx_refill(dev);
> +	if (err)
> +		return err;
> +
> +	if (skb_queue_len(&priv->rx_queue) != 32) {
> +		dev_err(&priv->udev->dev, "Not enough useable transfer buffers "
> +			"available to initialize the device.");
> +		p54u_cancel_urbs(dev);
> +		return -ENOMEM;

Why 32 urbs?
And why should open() fail if, say, only 28 got successfully allocated?
Shouldn't the device function nonetheless?

artur
