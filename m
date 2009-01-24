Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:47921 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbZAXBPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 20:15:47 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: [RFC][PATCH v2] p54usb: rx refill revamp
Date: Sat, 24 Jan 2009 02:15:43 +0100
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <200901232245.15216.chunkeey@web.de> <497A4BBB.30809@gmail.com>
In-Reply-To: <497A4BBB.30809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901240215.44226.chunkeey@web.de> (sfid-20090124_021607_248005_EEF80B58)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 January 2009 23:59:07 Artur Skawina wrote:
> Christian Lamparter wrote:
> > This patch fixes a long standing issue in p54usb.
> > 
> > Under high memory pressure, dev_alloc_skb couldn't always allocate a 
> > replacement skb. In such situations, we had to free the associated urb.
> > And over the time all urbs were eventually gone altogether and 
> > obviously the device remained mute from then on.
> > 
> > Thanks go out to Artur Skawina for all the reviews, ideas and code! 
> > ---
> > Changes:
> > 	- remove workqueue check (now, the workqueue is always there!)
> > 	- added Artur's comments
> > 	- added Artur's ideas (use poison & unpoison, emergency refill etc...)
> > 	- handle urb->status error codes
> > 		So now it depends on the error-code if we resubmit the urb & skb,
> > 		or queue it in rx_refill_list and free it later.
> > 
> > I hope Artur, I could meet all of your demands this time.;-)
> 
> There never were any 'demands', I had to spend way too much time hunting
> that data corruption bug, and in the process had to learn more than i ever
> wanted about the driver ;) So responding to your rfc was the obvious thing
> to do; feel free to ignore any comments that you think aren't useful.
why? most/all of them turned out to be useful? ;-)

> I have absolutely no problem with doing the work myself, it's just that you
> were fixing bugs that affected my device faster than i was able to run tests;
> so i never got around to send patches. In fact, i'll be waiting until this
> patch goes in, before even starting to work on some other changes, some of
> which i've already mentioned (and others that, afaict, would require changes
> to the usb stack, don't ask ;))
Oh?! please fix urb_unpoison_anchored_urbs!
Unless I'm totally wrong, there's a logic bug in this function preventing the "unposioning" of the urbs.

(I guess you already saw it, or do you plan a different change?)
1) urb_poison_anchored_urbs gets called
	1) poison anchor structure
	2) poison & killing every single urb
2) the usb_hcd_giveback_urb is called
	1) >>unanchores<< the urb form anchor_list
	2) calles urb->complete (urb)
		3) p54u_rx_cb -here- but nothing interesting there
3) ... [time goes by]
4) urb_unpoison_anchored_urb is called
	1) unpoison the anchor structure
	2) tries to unpoison the anchored urbs... But there's not a single one in the anchor_list,
	     since step 2.1 (usb_hcd_giveback_urb) killed them off. 

> > +static void p54u_cancel_urbs(struct ieee80211_hw *dev)
> > +{
> > +	struct p54u_priv *priv = dev->priv;
> > +
> > +	usb_poison_anchored_urbs(&priv->submitted);
> > +	/*
> > +	 * By now every RX URB has either finished or been canceled;
> > +	 * the p54u_rx_cb() completion has placed it on the refill
> > +	 * list; any attempts to resubmit from p54u_rx_refill(),
> > +	 * which could still be scheduled to run, will fail.
> > +	 */
> > +	cancel_work_sync(&priv->rx_refill_work);
> > +
> > +	/*
> > +	 * Unpoison all URBs in the rx_refill_list, so they can be reused.
> > +	 */
> > +	p54u_unpoison_rx_refill_list(dev);
> 
> I'm curious why you keep the urbs around in the stopped state?
> The alloc/free/alloc sequence on init may not be that pretty, but
> is there some other reason?
well, in most cases the "stopped state" is very short and most wlan-adapters are always connected.
So, why throw them away when we need them again in a few seconds?
(usually wpa_supplicant/NM has the bad habit of doing a interface up/down dance... sometimes)

> > +	/*
> > +	 * Unpoison the anchor itself; the old URBs are already gone,
> > +	 * p54u_rx_cb() has moved them all to the refill list.
> > +	 * Prevents new URBs from being poisoned when anchored.
> > +	 */
> > +	usb_unpoison_anchored_urbs(&priv->submitted);
> > +}
> > +
> > +static int p54u_rx_refill(struct ieee80211_hw *dev)
> > +{
> > +	struct p54u_priv *priv = dev->priv;
> > +	struct urb *entry, *tmp;
> > +	unsigned long flags;
> > +	unsigned int refilled_urbs = 0;
> > +	int err = -EINVAL;
> > +
> > +	spin_lock_irqsave(&priv->rx_refill_lock, flags);


> > +	list_for_each_entry_safe(entry, tmp, &priv->rx_refill_list, urb_list) {
uhh, this should be list_for_each_entry_safe_continue ... (fixed)
> > +		struct p54u_rx_info *info;
> > +		struct sk_buff *skb;
> > +
> > +		list_del(&entry->urb_list);
> > +		spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
> >  		skb = __dev_alloc_skb(priv->common.rx_mtu + 32, GFP_KERNEL);
> > +
> > +		if (unlikely(!skb)) {
> > +			/*
> > +			 * In order to prevent a loop, we put the URB
> > +			 * back at the _front_ of the list, so we can
> > +			 * march on, in out-of-memory situations.
> > +			 */
> > +
> > +			spin_lock_irqsave(&priv->rx_refill_lock, flags);
> > +			list_add(&entry->urb_list, &priv->rx_refill_list);
> > +			err = -ENOMEM;
> > +			continue;
> >  		}
> >  
> >  		usb_fill_bulk_urb(entry, priv->udev,
> >  				  usb_rcvbulkpipe(priv->udev, P54U_PIPE_DATA),
> >  				  skb_tail_pointer(skb),
> >  				  priv->common.rx_mtu + 32, p54u_rx_cb, skb);
> > +
> >  		info = (struct p54u_rx_info *) skb->cb;
> >  		info->urb = entry;
> >  		info->dev = dev;
> >  
> >  		usb_anchor_urb(entry, &priv->submitted);
> > +		err = usb_submit_urb(entry, GFP_KERNEL);
> > +		if (err) {
> 
> Hmm, won't this path (ie the foreach loop) be executed many times when
> canceling the urbs? (that's why i was returning early on -EPERM in my
> patch, but have not actually checked if it's an issue. yet.)
well, we don't schedule the workqueue if we canceling the urbs now,
( that's what the urb->status switch is supposed to do/( or in this context )stop...)

Another maybe related thing: ( a bit above)
	 * In order to prevent a loop, we put the URB
	 * back at the _front_ of the list, so we can
	 * march on, in out-of-memory situations.

I guess this could be true for -EPERM as well?
As far as I know list_for_each_entry_* iterates until it hits (head)
and since we insert the -EPERM "urb" with list_add (_head),
we will never do more than 32 iterations?! (since list_add put the elements in (head)->next )

But if we cancel on -EPERM, we should bail out on -ENODEV
(or -ECONNRESET, what ever says that the device is unavailable ) as well...

> > +			/*
> > +			 * URB submission failed.
> > +			 * Free the associated skb and put the URB back into
> > +			 * the front of the refill list, so we can try our luck
> > +			 * next time.
> > +			 */
> > +
> >  			usb_unanchor_urb(entry);
> > +			kfree_skb(skb);
> > +			spin_lock_irqsave(&priv->rx_refill_lock, flags);
> > +			list_add(&entry->urb_list, &priv->rx_refill_list);
> > +		} else {
> > +			skb_queue_tail(&priv->rx_queue, skb);
> > +			refilled_urbs++;
> > +			spin_lock_irqsave(&priv->rx_refill_lock, flags);
> >  		}
> > +	}
> > +	spin_unlock_irqrestore(&priv->rx_refill_lock, flags);
> > +	return refilled_urbs ? 0 : err;
> > +}
> > +
> > +static int p54u_open(struct ieee80211_hw *dev)
> > +{
> > +	struct p54u_priv *priv = dev->priv;
> > +	int err;
> > +
> > +	err = p54u_rx_refill(dev);
> > +	if (err)
> > +		return err;
> > +
> > +	if (skb_queue_len(&priv->rx_queue) != 32) {
> > +		dev_err(&priv->udev->dev, "Not enough useable transfer buffers "
> > +			"available to initialize the device.");
> > +		p54u_cancel_urbs(dev);
> > +		return -ENOMEM;
> 
> Why 32 urbs?
Well, that's the firmware/hardware limit for all prism54 chips
(doesn't matter if usb/pci fullmac/softmac etc...)
all have 32 rx and tx slots in the "normal priority" queue/ring-buffer.

> And why should open() fail if, say, only 28 got successfully allocated?
> Shouldn't the device function nonetheless?
Well, what's the point of supporting a system that has problems finding 32 pages with GFP_KERNEL?
you know "one allocation on device init isn't worth avoiding."   :-p

Regards,
	Chr
