Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f195.google.com ([209.85.213.195]:36038 "EHLO
	mail-ig0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933521AbcDLVOI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 17:14:08 -0400
Received: by mail-ig0-f195.google.com with SMTP id kb1so4104011igb.3
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2016 14:14:07 -0700 (PDT)
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <CAGRGNgVLLq60dffQaGVKDfOLOHeqd9ULfimxZX1wpgQAfPbZNQ@mail.gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com> <4920ab8faf66e456a1fad1e79607d15a04cbb029.1458262312.git.julian.calaby@gmail.com>
 <CAN8YU5OqKhqaucUs04Xe3wT8D1_p3B8miWKDQLv-aGakr12ZWA@mail.gmail.com> <CAGRGNgVLLq60dffQaGVKDfOLOHeqd9ULfimxZX1wpgQAfPbZNQ@mail.gmail.com>
From: Andrea Merello <andrea.merello@gmail.com>
Date: Tue, 12 Apr 2016 23:13:42 +0200
Message-ID: <CAN8YU5PpNHBXpbvBnTfHQTArz-39M5vZEQgOLYqeRnRg5fkOVA@mail.gmail.com> (sfid-20160412_231434_470252_3913F711)
Subject: Re: [PATCH MOREWORK 14/19] rtl818x_pci: Fix a memory leak in rtl8180_init_rx_ring
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Jia-Ju Bai <baijiaju1990@163.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 11, 2016 at 2:11 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Hi Andrea,
>
> On Sat, Apr 9, 2016 at 4:56 AM, Andrea Merello <andrea.merello@gmail.com> wrote:
>>
>> On Fri, Mar 18, 2016 at 3:27 AM, Julian Calaby <julian.calaby@gmail.com>
>> wrote:
>>> From: Jia-Ju Bai <baijiaju1990@163.com>
>>>
>>> When dev_alloc_skb or pci_dma_mapping_error in rtl8180_init_rx_ring fails,
>>> the memory allocated by pci_zalloc_consistent is not freed.
>>>
>>> This patch fixes the bug by adding pci_free_consistent
>>> in error handling code.
>>>
>>> Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
>>> Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
>>>
>>> ---
>>>
>>> Could someone else please review this?
>>
>> This patch does address one leak, but the piece of code it changes is
>> totally leaky and IMHO it probably needs to be reworked more deeply, maybe
>> in a single shot. This is why I didn't acked the patch.
>
> Ugh.
>
> I can't work on this as I don't have hardware to test it with, could
> you (or someone who does) please have a good look at this section of
> the Realtek drivers (I see a lot of this pattern repeated in them) and
> craft (a) patch(es) to fix this properly?

On my TODO list. BTW Unfortunately I have a huge TODO list, and my
WiFi test box is currently unusable, so it will probably not happen
very soon on my side :(

>> BTW if you feel that this could be better than nothing, please feel free to
>> apply it :).
>
> IMHO this patch makes things better in that there's less options for a
> leak, however I marked this as "morework" as it clearly doesn't solve
> the _entire_ problem.
>
> I feel it should be applied as it does make it better, however this
> isn't my driver and I'd appreciate a nod of approval from someone who
> knows it better than I do.

I don't consider myself one that should finally decide about what to
merge into the Kernel, BTW I don't see any drawback in merging it.

>>> In particular, immediately after the call to pci_zalloc_coherent(), it
>>> fails if the result is null or if '(unsigned long)result & 0xFF'.
>>>
>>> Is the second arm of the or statement possible, and if so, should we be
>>> pci_free_coherent()ing the result there too?
>>
>> I honestly don't know if the coherent allocator is supposed to always return
>> page-aligned memory areas (I'm assuming a page wouldn't be smaller than 256
>> bytes); AFAIK no one ever hit that.
>>
>> If there are cases/archs where it can  really happen, then allocating an
>> oversized memory area, and providing to the HW an aligned pointer inside
>> that area, may be the way to go (IIRC calling pci_set_consistent_dma_mask()
>> with 0xFFFFFF00 does not provides any benefit, but again, I'm not sure).
>
> I believe that calling *_set_*_dma_mask() is how it's supposed to be
> done. If this isn't working, then that's a bug elsewhere. IMHO drivers
> should be able to say "we need a DMA address like *this*" and it's the
> PCI / DMA code's responsibility to either provide a compatible one or
> fail. Drivers shouldn't be working around bugs in the services they
> use.
>

I didn't meant it didn't worked.. I never thought *_set_*_dma_mask()
to be buggy.. (and Indeed I think I never saw a unaligned DMA alloc
either with or without it).

Well, to make it short: IIRC, I used it in my very first version of
the driver, but it has been changed in the rewritten version that is
in-kernel right now. At that time IIRC I ended up in thinking that
*_set_*_dma_mask() was just meant (due to its semantic, no bug..) only
for the purpose of restricting allocations to lower memory (for boards
that cannot address full memory size), while it wouldn't care about
LSBs. I don't remember if I was told about this, or if I looked into
the kernel code (maybe I did some mistake). BTW if you know that it is
intended to works as you said (and that indeed seems absolutely
reasonable to me, given that it takes a "mask" parameter), then it's
obviously the way to go.

After a quick grep in the kernel, it seems that there is at least one
driver that actually specifies a "weird" mask like ours..

>> Either way, If we do that, or if we can trust that it does never really
>> happen, then we can drop the check (or maybe just change it in a BUG_ON()
>> just to be paranoid).
>
> A WARN_ON() and failing gracefully would be the ideal way to do this
> IMHO, however it really shouldn't be necessary.
>
>> To address your question - if we let this check stay there - then of course
>> we need to take care of freeing the memory whenever the allocator succeeds
>> but that check fails.
>
> I'll craft a followup patch to add a WARN_ON(), free the memory and
> fail in this case.

Ok, thank you.

>>> I've had a quick scout around and this check seems to be particular to
>>> realtek drivers.
>>
>> The HW needs DMA rings to be 256-byte aligned. I never tried to see what
>> happens if we break the rule, but I suspect that the HW will attempt DMAs to
>> bad addresses (actually masked with 0xFFFFFF00); If that's the case, then we
>> really need to avoid this..
>
> I guess if we got an address like 0x.....048 then we could arguably
> just tell the hardware we start at 0x.....100, however that's a
> terrible solution. This really needs to be addressed at the "source"
> i.e. informing the allocator what our requirements are and if it
> doesn't produce correct results, fixing it, not working around it in
> the driver.

Yes, of course. If there is a way to ask for this, then I completely
agree with you.. I never intended to workaround any allocator bug :)

> Thanks,
>
> --
> Julian Calaby
>
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
