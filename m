Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:45601 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbZAUU4W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 15:56:22 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: [RFC][RFT][PATCH] p54usb: rx refill revamp
Date: Wed, 21 Jan 2009 21:56:27 +0100
Cc: linux-wireless@vger.kernel.org
References: <200901211450.50880.chunkeey@web.de> <200901211924.54660.chunkeey@web.de> <4977785B.7020009@gmail.com>
In-Reply-To: <4977785B.7020009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901212156.27152.chunkeey@web.de> (sfid-20090121_215627_223731_92DC8F28)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 21 January 2009 20:32:43 Artur Skawina wrote:
> Christian Lamparter wrote:
> >> This patch makes the usb rx path alloc-less (except for the actual urb
> >> submission call) which is good, but i wonder if we should try a GFP_NOWAIT
> >> allocation, and only fallback if that one fails.
> > Not necessary, we waste quite a lot memory by filling the rx ring with 32 useable packets.
> > So there should be no shortage (anymore).
> 
> Not allocating-on-receive at all worries me a bit. Will test under load. (i already
> had instrumented the cb, but the crashes prevented any useful testing).

no problem... I'll wait for your data before removing the RFC/RFT tags

> >> The net2280 tx path does at least three allocs, one tiny never-changing buffer
> >> and two urbs, i'd like to get rid of all of them. 
> > why? AFAIK kernel memory alloc already provides a good amount of (small) buffer caches,
> > so why should stockpile them only for ourself?
> > 
> > You know, 802.11b/g isn't exactly fast by any standards - heck even a 15 year old ethernet NIC
> > is easily 5-6 times faster. So, "optimizations" are a bit useless when we have these bottlenecks. 
> 
> no, i don't expect it do much difference performance-wise; i don't want it to
> fail under memory pressure. preallocating ~three small buffers isn't that bad ;)

well, the memory pressure is not sooo bad in a (prioritized) kernel thread.
After all, the kernel reserves extra space for the kernel only and the OOM killer will become active as well...
So unless you got a machine with 8mb (afaik that's the lowest limit linux boots now a days and is
still useable!?) and a no/slowwwww swap, you'll have a really hard time to get any shortage of rx urbs at all.

The only alternative, is to do it in a tasklet, however we can't use GFP_KERNEL there...

But let's wait for the results, "this is my theory" and it could be wrong (again). ;-) 
> > In fact, if you have more than one GHz in your box, you should let your CPU do the
> > encryption/decryption instead of the 30Mhz ARM CPU.... 
> > this will give you a better latency for next to nothing.
> BTW i tested both w/ hw encryption and w/o and both worked; saw no difference
> in throughput, but didn't benchmark yet.
> And no, i don't have >1GHz, the target system has probably 1/4 of that available
> when it's idle, and much less when it's under load. Also i'd like to be able to
> connect the device to a small fanless brick and have it do it's work (if i can find
> a usable 2.6-based one, that is).

well, the latency is usually about 0.1 - 0.2 msec better.
However you'll get a big improvement if you change the MTU...
As a ethernet device, the default is at 1500 octets, however the limit for WLAN is somewhere at 2274. 

> >> The constant buffer is easy - we can just kmalloc a cacheline-sized chunk on init, and (re)use that.
> > only a single constant buffer? are you sure that's a good idea, on dual cores?
> > (Or is this a misunderstanding and you plan to have up to 32/64 constant buffers?)
> 
> why not? the content never changes, and will only be read by the usb host controller;
> the cpu shouldn't even need to see it after the initial setup.
Ok, I guess we're talking about different things here.
Please, show me a patch, before it gets too confusing ;-)

> >> As to the urbs, i originally wanted to put (at least one of) them in the skb
> >> headroom. But the fact that the skb can be freed before the completions run   
> >> makes that impossible.
> > Not only that, but you'll shift the alloc stuff to mac80211, which uses GFP_ATOMIC to expand the head,
> > if it's necessary.
> 
> increasing the allocation by one struct urb wouldn't make much difference and
> avoid a kmalloc, but this doesn't matter as the lifetime of the skbs prohibits
> such scheme.
well, to flog a dead horse a bit more urb struct is 176 bytes on x64...
And as far as I know the "worst-case" is that mac80211 has to copy the 
whole packet to add more headroom, which eventually will trigger
more truesize bugs to appear?!! (don't know, maybe)

> >> Do you have a git tree, or some kind of patch queue, with all the pending p54 patches? 
> > No, In fact, Linville do all the accouting in wireless-testing :-D already.
> 
> ok, will pick them up from the list, last  time i checked they weren't in
> wireless-testing.
well, Linville just updated the tree... however the p54usb urb_zero_packet stuff isn't there yet?!

> >> Working on top of wireless-testing makes it harder to test. 
> >> What was this patch made against?
> > Strange? It should be apply cleanly on top of wireless-testing... well, give Linville some time to catch up ;-)
> 
> I just need to take in all of -rc?, which i wouldn't normally run on the
> production machine, and forward port a dozen+ local branches; and all of
> this just for one driver. Not a problem, it just means it takes a few days
> between tests.

hmm, you should be able to (re)use your old kernel... all you have to do, is to get a "clone" from /wireless-testing/
and run make M=wireless-testing/drivers/net/wireless/p54... that should do the trick and you have a pair of new
modules (if you build p54common & p54usb only), as long as no one changes the API.
 
> >>> +static void p54u_rx_refill_free_list(struct ieee80211_hw *dev)
> >> the name is a bit misleading...
> >> s/p54u_rx_refill_free_list/p54u_free_rx_refill_list/ ?
> > dunno, it's more a namespace thing( easier to copy, paste & remember).
> > but on the other hand, p54u_free_rx is better for the eyes.
> 
> rx_refill_free_list suggests that it, well, refills some list, while it
> does the exact opposite.
oh, p54u_rx_refill_ (pause) _free_list (the structure itself is called rx_refill_list as well)...
So yeah, we can bash over this as well...

> >>>>  		usb_anchor_urb(entry, &priv->submitted);
> >>> +		if (usb_submit_urb(entry, GFP_ATOMIC)) {
> >> GFP_KERNEL? [would need dropping rx_queue.lock earlier and retaking in the
> >> (hopefully rare) error path]
> > why not... I don't remember the real reason why I did this complicated lock, probably
> 
> You were already doing this for the skb allocation anyway ;)
do you mean the old "init_urbs"? 
Well the bits I've still in mind about the "complicated lock". Was something about
a theroeticall race between p54u_rx_cb, the workqueue and free_urbs.

but of course, I've never seen a oops because of it.
> 
> > A updated patch is attached (as file)
> 
> Will test.
> Are the free_urb/get_urb calls necessary? IOW why drop the reference
> when preparing the urb, only to grab it again in the completion?

Oh,  I'm not arguing with Alan Stern about it:.
http://lkml.org/lkml/2008/12/6/166

Regards,
	Chr
