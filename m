Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:40664 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbZAUTcs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 14:32:48 -0500
Received: by ewy13 with SMTP id 13so1782292ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jan 2009 11:32:46 -0800 (PST)
Message-ID: <4977785B.7020009@gmail.com> (sfid-20090121_203250_994777_C5654F4A)
Date: Wed, 21 Jan 2009 20:32:43 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Artur Skawina <art.08.09@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [RFC][RFT][PATCH] p54usb: rx refill revamp
References: <200901211450.50880.chunkeey@web.de> <49774794.507@gmail.com> <200901211924.54660.chunkeey@web.de>
In-Reply-To: <200901211924.54660.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
>> This patch makes the usb rx path alloc-less (except for the actual urb
>> submission call) which is good, but i wonder if we should try a GFP_NOWAIT
>> allocation, and only fallback if that one fails.
> Not necessary, we waste quite a lot memory by filling the rx ring with 32 useable packets.
> So there should be no shortage (anymore).

Not allocating-on-receive at all worries me a bit. Will test under load. (i already
had instrumented the cb, but the crashes prevented any useful testing).

>> The net2280 tx path does at least three allocs, one tiny never-changing buffer
>> and two urbs, i'd like to get rid of all of them. 
> why? AFAIK kernel memory alloc already provides a good amount of (small) buffer caches,
> so why should stockpile them only for ourself?
> 
> You know, 802.11b/g isn't exactly fast by any standards - heck even a 15 year old ethernet NIC
> is easily 5-6 times faster. So, "optimizations" are a bit useless when we have these bottlenecks. 

no, i don't expect it do much difference performance-wise; i don't want it to
fail under memory pressure. preallocating ~three small buffers isn't that bad ;)

> In fact, if you have more than one GHz in your box, you should let your CPU do the
> encryption/decryption instead of the 30Mhz ARM CPU.... 
> this will give you a better latency for next to nothing.

BTW i tested both w/ hw encryption and w/o and both worked; saw no difference
in throughput, but didn't benchmark yet.
And no, i don't have >1GHz, the target system has probably 1/4 of that available
when it's idle, and much less when it's under load. Also i'd like to be able to
connect the device to a small fanless brick and have it do it's work (if i can find
a usable 2.6-based one, that is).

>> The constant buffer is easy - we can just kmalloc a cacheline-sized chunk on init, and (re)use that.
> only a single constant buffer? are you sure that's a good idea, on dual cores?
> (Or is this a misunderstanding and you plan to have up to 32/64 constant buffers?)

why not? the content never changes, and will only be read by the usb host controller;
the cpu shouldn't even need to see it after the initial setup.

>> As to the urbs, i originally wanted to put (at least one of) them in the skb
>> headroom. But the fact that the skb can be freed before the completions run   
>> makes that impossible.
> Not only that, but you'll shift the alloc stuff to mac80211, which uses GFP_ATOMIC to expand the head,
> if it's necessary.

increasing the allocation by one struct urb wouldn't make much difference and
avoid a kmalloc, but this doesn't matter as the lifetime of the skbs prohibits
such scheme.

>> Do you have a git tree, or some kind of patch queue, with all the pending p54 patches? 
> No, In fact, Linville do all the accouting in wireless-testing :-D already.

ok, will pick them up from the list, last  time i checked they weren't in
wireless-testing.

>> Working on top of wireless-testing makes it harder to test. 
>> What was this patch made against?
> Strange? It should be apply cleanly on top of wireless-testing... well, give Linville some time to catch up ;-)

I just need to take in all of -rc?, which i wouldn't normally run on the
production machine, and forward port a dozen+ local branches; and all of
this just for one driver. Not a problem, it just means it takes a few days
between tests.

>>> +static void p54u_rx_refill_free_list(struct ieee80211_hw *dev)
>> the name is a bit misleading...
>> s/p54u_rx_refill_free_list/p54u_free_rx_refill_list/ ?
> dunno, it's more a namespace thing( easier to copy, paste & remember).
> but on the other hand, p54u_free_rx is better for the eyes.

rx_refill_free_list suggests that it, well, refills some list, while it
does the exact opposite.

>>>>  		usb_anchor_urb(entry, &priv->submitted);
>>> +		if (usb_submit_urb(entry, GFP_ATOMIC)) {
>> GFP_KERNEL? [would need dropping rx_queue.lock earlier and retaking in the
>> (hopefully rare) error path]
> why not... I don't remember the real reason why I did this complicated lock, probably

You were already doing this for the skb allocation anyway ;)

> A updated patch is attached (as file)

Will test.
Are the free_urb/get_urb calls necessary? IOW why drop the reference
when preparing the urb, only to grab it again in the completion? 
p54u_free_rx_refill_list() is what frees them anyway.

artur
