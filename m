Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:33914 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbZAUXWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 18:22:20 -0500
Received: by ug-out-1314.google.com with SMTP id 39so432793ugf.37
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jan 2009 15:22:18 -0800 (PST)
Message-ID: <4977AE28.2080109@gmail.com> (sfid-20090122_002226_600646_98E333BA)
Date: Thu, 22 Jan 2009 00:22:16 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Artur Skawina <art.08.09@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [RFC][RFT][PATCH] p54usb: rx refill revamp
References: <200901211450.50880.chunkeey@web.de> <200901211924.54660.chunkeey@web.de> <4977785B.7020009@gmail.com> <200901212156.27152.chunkeey@web.de>
In-Reply-To: <200901212156.27152.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Wednesday 21 January 2009 20:32:43 Artur Skawina wrote:
>> Christian Lamparter wrote:
>>>> This patch makes the usb rx path alloc-less (except for the actual urb
>>>> submission call) which is good, but i wonder if we should try a GFP_NOWAIT
>>>> allocation, and only fallback if that one fails.
>>> Not necessary, we waste quite a lot memory by filling the rx ring with 32 useable packets.
>>> So there should be no shortage (anymore).
>> Not allocating-on-receive at all worries me a bit. Will test under load. (i already
>> had instrumented the cb, but the crashes prevented any useful testing).
> 
> no problem... I'll wait for your data before removing the RFC/RFT tags

That part is probably fine, and i'm just being paranoid. Ignore me.

>>> The net2280 tx path does at least three allocs, one tiny never-changing buffer
>>>> and two urbs, i'd like to get rid of all of them. 
>>> why? AFAIK kernel memory alloc already provides a good amount of (small) buffer caches,
>>> so why should stockpile them only for ourself?
>>>
>>> You know, 802.11b/g isn't exactly fast by any standards - heck even a 15 year old ethernet NIC
>>> is easily 5-6 times faster. So, "optimizations" are a bit useless when we have these bottlenecks. 
>> no, i don't expect it do much difference performance-wise; i don't want it to
>> fail under memory pressure. preallocating ~three small buffers isn't that bad ;)
> 
> well, the memory pressure is not sooo bad in a (prioritized) kernel thread.
> After all, the kernel reserves extra space for the kernel only and the OOM killer will become active as well...
> So unless you got a machine with 8mb (afaik that's the lowest limit linux boots now a days and is
> still useable!?) and a no/slowwwww swap, you'll have a really hard time to get any shortage of rx urbs at all.

TX, not RX. 
I'll try stealing^Hborrowing the urbs from the refill queue (fixing up
the rx code to allow for this first, of course).

>>> In fact, if you have more than one GHz in your box, you should let your CPU do the
>>> encryption/decryption instead of the 30Mhz ARM CPU.... 
>>> this will give you a better latency for next to nothing.
>> BTW i tested both w/ hw encryption and w/o and both worked; saw no difference
>> in throughput, but didn't benchmark yet.
>> And no, i don't have >1GHz, the target system has probably 1/4 of that available
>> when it's idle, and much less when it's under load. Also i'd like to be able to
>> connect the device to a small fanless brick and have it do it's work (if i can find
>> a usable 2.6-based one, that is).
> 
> well, the latency is usually about 0.1 - 0.2 msec better.
> However you'll get a big improvement if you change the MTU...
> As a ethernet device, the default is at 1500 octets, however the limit for WLAN is somewhere at 2274. 

Good to know. As most packets will go over a ~1500 link upstream anyway
i'd rather not pay the pmtu discovery cost ;)

>>>> The constant buffer is easy - we can just kmalloc a cacheline-sized chunk on init, and (re)use that.
>>> only a single constant buffer? are you sure that's a good idea, on dual cores?
>>> (Or is this a misunderstanding and you plan to have up to 32/64 constant buffers?)
>> why not? the content never changes, and will only be read by the usb host controller;
>> the cpu shouldn't even need to see it after the initial setup.
> Ok, I guess we're talking about different things here.
> Please, show me a patch, before it gets too confusing ;-)

ok, I was just saying that that all this:

>         reg = kmalloc(sizeof(*reg), GFP_ATOMIC);
>         if (!reg) {
>                 printk(KERN_INFO "tx_net2280 kmalloc(reg), txqlen = %d\n",
>                           skb_queue_len(&priv->common.tx_queue) );
>                 return;
>         }
> [...]
>         reg->port = cpu_to_le16(NET2280_DEV_U32);
>         reg->addr = cpu_to_le32(P54U_DEV_BASE);
>         reg->val = cpu_to_le32(ISL38XX_DEV_INT_DATA);

does not need to happen for every single tx-ed frame.


>>>>> +		if (usb_submit_urb(entry, GFP_ATOMIC)) {
>>>> GFP_KERNEL? [would need dropping rx_queue.lock earlier and retaking in the
>>>> (hopefully rare) error path]
>>> why not... I don't remember the real reason why I did this complicated lock, probably
>> You were already doing this for the skb allocation anyway ;)
> do you mean the old "init_urbs"? 

I meant that you were already dropping a spinlock around one allocation, so it
seemed odd to not to do that for the other call.


> Well the bits I've still in mind about the "complicated lock". Was something about
> a theroeticall race between p54u_rx_cb, the workqueue and free_urbs.
> 
> but of course, I've never seen a oops because of it.
>>> A updated patch is attached (as file)
>> Will test.
>> Are the free_urb/get_urb calls necessary? IOW why drop the reference
>> when preparing the urb, only to grab it again in the completion?
> 
> Oh,  I'm not arguing with Alan Stern about it:.
> http://lkml.org/lkml/2008/12/6/166

0) urb is allocated, refcount==1  # and placed on the refill list; p54u_init_urbs()
1) p54u_rx_refill()
2) urb is anchored   refcount==2  # p54u_rx_refill
3) submit_urb()      refcount==3  # in drivers/usb/core/hcd.c:usb_hcd_submit_urb
4) free_urb()        refcount==2
5) ... usb transfer happens ... refcount==2
6) urb is unanchored refcount==1  # in drivers/usb/core/hcd.c:usb_hcd_giveback_urb()
7) p54u_rx_cb()                   # completion is called
8) usb_get_urb(urb)  refcount==2  # unconditionally called in p54u_rx_cb()
9) p54u_rx_cb() returns
10) usb_put_urb()    refcount==1  # in drivers/usb/core/hcd.c:usb_hcd_giveback_urb()
11) urb sits on the refill list
12) goto 1.

IOW step 4 causes the refcount to temporarily drop to 1, but as you
never want the urb freed in the completion, step 8 grabs another reference,
and the refcount can never become 0.
(for the skb-reuse case, you anchor and resubmit in step 7 (rc==3),
then return from completion (rc==2) and restart at step 5.)

Unless i missed something (i'm only looking at the patch).

So if you omit steps 4 and 8 nothing changes, except that the refcount 
increases by one, in steps 5..7. 
The urbs are freed by p54u_free_rx_refill_list(), which drops the last ref;
(it would need to get them all though, IOW would have to call
usb_kill_anchored_urbs() _before_ p54u_free_rx_refill_list(). )


Oh, and I just realized urbs are getting lost in the 'unlikely(urb->status)'
case, both before your patch, and after.
A simple fix, with your new code, would be to place them on the refill list,
from where they will be eventually resubmitted.

artur
