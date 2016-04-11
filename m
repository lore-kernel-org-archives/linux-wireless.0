Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:35798 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbcDKAMS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2016 20:12:18 -0400
Received: by mail-oi0-f52.google.com with SMTP id p188so189712019oih.2
        for <linux-wireless@vger.kernel.org>; Sun, 10 Apr 2016 17:12:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN8YU5OqKhqaucUs04Xe3wT8D1_p3B8miWKDQLv-aGakr12ZWA@mail.gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com> <4920ab8faf66e456a1fad1e79607d15a04cbb029.1458262312.git.julian.calaby@gmail.com>
 <CAN8YU5OqKhqaucUs04Xe3wT8D1_p3B8miWKDQLv-aGakr12ZWA@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 11 Apr 2016 10:11:58 +1000
Message-ID: <CAGRGNgVLLq60dffQaGVKDfOLOHeqd9ULfimxZX1wpgQAfPbZNQ@mail.gmail.com> (sfid-20160411_021222_305085_1D2D8E0B)
Subject: Re: [PATCH MOREWORK 14/19] rtl818x_pci: Fix a memory leak in rtl8180_init_rx_ring
To: Andrea Merello <andrea.merello@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Jia-Ju Bai <baijiaju1990@163.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrea,

On Sat, Apr 9, 2016 at 4:56 AM, Andrea Merello <andrea.merello@gmail.com> wrote:
>
> On Fri, Mar 18, 2016 at 3:27 AM, Julian Calaby <julian.calaby@gmail.com>
> wrote:
>> From: Jia-Ju Bai <baijiaju1990@163.com>
>>
>> When dev_alloc_skb or pci_dma_mapping_error in rtl8180_init_rx_ring fails,
>> the memory allocated by pci_zalloc_consistent is not freed.
>>
>> This patch fixes the bug by adding pci_free_consistent
>> in error handling code.
>>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
>> Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
>>
>> ---
>>
>> Could someone else please review this?
>
> This patch does address one leak, but the piece of code it changes is
> totally leaky and IMHO it probably needs to be reworked more deeply, maybe
> in a single shot. This is why I didn't acked the patch.

Ugh.

I can't work on this as I don't have hardware to test it with, could
you (or someone who does) please have a good look at this section of
the Realtek drivers (I see a lot of this pattern repeated in them) and
craft (a) patch(es) to fix this properly?

> BTW if you feel that this could be better than nothing, please feel free to
> apply it :).

IMHO this patch makes things better in that there's less options for a
leak, however I marked this as "morework" as it clearly doesn't solve
the _entire_ problem.

I feel it should be applied as it does make it better, however this
isn't my driver and I'd appreciate a nod of approval from someone who
knows it better than I do.

>> In particular, immediately after the call to pci_zalloc_coherent(), it
>> fails if the result is null or if '(unsigned long)result & 0xFF'.
>>
>> Is the second arm of the or statement possible, and if so, should we be
>> pci_free_coherent()ing the result there too?
>
> I honestly don't know if the coherent allocator is supposed to always return
> page-aligned memory areas (I'm assuming a page wouldn't be smaller than 256
> bytes); AFAIK no one ever hit that.
>
> If there are cases/archs where it can  really happen, then allocating an
> oversized memory area, and providing to the HW an aligned pointer inside
> that area, may be the way to go (IIRC calling pci_set_consistent_dma_mask()
> with 0xFFFFFF00 does not provides any benefit, but again, I'm not sure).

I believe that calling *_set_*_dma_mask() is how it's supposed to be
done. If this isn't working, then that's a bug elsewhere. IMHO drivers
should be able to say "we need a DMA address like *this*" and it's the
PCI / DMA code's responsibility to either provide a compatible one or
fail. Drivers shouldn't be working around bugs in the services they
use.

> Either way, If we do that, or if we can trust that it does never really
> happen, then we can drop the check (or maybe just change it in a BUG_ON()
> just to be paranoid).

A WARN_ON() and failing gracefully would be the ideal way to do this
IMHO, however it really shouldn't be necessary.

> To address your question - if we let this check stay there - then of course
> we need to take care of freeing the memory whenever the allocator succeeds
> but that check fails.

I'll craft a followup patch to add a WARN_ON(), free the memory and
fail in this case.

>> I've had a quick scout around and this check seems to be particular to
>> realtek drivers.
>
> The HW needs DMA rings to be 256-byte aligned. I never tried to see what
> happens if we break the rule, but I suspect that the HW will attempt DMAs to
> bad addresses (actually masked with 0xFFFFFF00); If that's the case, then we
> really need to avoid this..

I guess if we got an address like 0x.....048 then we could arguably
just tell the hardware we start at 0x.....100, however that's a
terrible solution. This really needs to be addressed at the "source"
i.e. informing the allocator what our requirements are and if it
doesn't produce correct results, fixing it, not working around it in
the driver.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
