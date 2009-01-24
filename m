Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:39759 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbZAXESL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 23:18:11 -0500
Received: by nf-out-0910.google.com with SMTP id d3so880981nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 20:18:09 -0800 (PST)
Message-ID: <497A967F.2010900@gmail.com> (sfid-20090124_051856_563418_B7F8C42D)
Date: Sat, 24 Jan 2009 05:18:07 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Artur Skawina <art.08.09@gmail.com>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC][PATCH v2] p54usb: rx refill revamp
References: <200901232245.15216.chunkeey@web.de> <497A4BBB.30809@gmail.com> <200901240215.44226.chunkeey@web.de>
In-Reply-To: <200901240215.44226.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> 1) urb_poison_anchored_urbs gets called
> 	1) poison anchor structure
> 	2) poison & killing every single urb
> 2) the usb_hcd_giveback_urb is called
> 	1) >>unanchores<< the urb form anchor_list
> 	2) calles urb->complete (urb)
> 		3) p54u_rx_cb -here- but nothing interesting there
> 3) ... [time goes by]
> 4) urb_unpoison_anchored_urb is called
> 	1) unpoison the anchor structure
> 	2) tries to unpoison the anchored urbs... But there's not a single one in the anchor_list,
> 	     since step 2.1 (usb_hcd_giveback_urb) killed them off. 

I assume that's just how it's supposed to be. You could always anchor
the urbs to another anchor in the completion_. Or free any buffers and
drop the last ref before leaving the completion. (in fact, the former
is basically what you're doing, just using a list instead)

>> I'm curious why you keep the urbs around in the stopped state?
> well, in most cases the "stopped state" is very short and most wlan-adapters are always connected.
> So, why throw them away when we need them again in a few seconds?
> (usually wpa_supplicant/NM has the bad habit of doing a interface up/down dance... sometimes)

ok. (i don't know about most wlans being always up, but it seems a
reasonable compromise. still, that's 100k+ wasted ram in the down
state.)

> well, we don't schedule the workqueue if we canceling the urbs now,
> ( that's what the urb->status switch is supposed to do/( or in this context )stop...)

yep, noticed that later, see below.

> Another maybe related thing: ( a bit above)
> 	 * In order to prevent a loop, we put the URB
> 	 * back at the _front_ of the list, so we can
> 	 * march on, in out-of-memory situations.
> 
> I guess this could be true for -EPERM as well?
> As far as I know list_for_each_entry_* iterates until it hits (head)
> and since we insert the -EPERM "urb" with list_add (_head),
> we will never do more than 32 iterations?! (since list_add put the elements in (head)->next )
> 
> But if we cancel on -EPERM, we should bail out on -ENODEV
> (or -ECONNRESET, what ever says that the device is unavailable ) as well...

I'm not sure I follow.. Ah, the only reason I bailed out on -EPERM
is that usb_submit_urb() will return -EPERM for poisoned urbs and
i didn't want to retry this call for every other urb as they would
all fail. Each try involves a useless skb alloc and free...
[My version schedules the work for every urb, even the poisoned ones]

>>> +	if (skb_queue_len(&priv->rx_queue) != 32) {
>>> +		dev_err(&priv->udev->dev, "Not enough useable transfer buffers "
>>> +			"available to initialize the device.");
>>> +		return -ENOMEM;
>> Why 32 urbs?
> Well, that's the firmware/hardware limit for all prism54 chips
> (doesn't matter if usb/pci fullmac/softmac etc...)
> all have 32 rx and tx slots in the "normal priority" queue/ring-buffer.
> 
>> And why should open() fail if, say, only 28 got successfully allocated?
>> Shouldn't the device function nonetheless?
> Well, what's the point of supporting a system that has problems finding 32 pages with GFP_KERNEL?
> you know "one allocation on device init isn't worth avoiding."   :-p

ok. that's not something this patch changes anyway ;)


I looked at your v2 briefly yesterday and even wrote a reply, but
didn't send it. I really liked your v1 much better, the new version
makes the code much harder to follow, and still can stall the device
after a few consecutive urb completion or submission (this is new)
errors happen. Uhm, i probably should shut up now ;)

Thanks for doing all this work,

artur
