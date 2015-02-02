Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42469 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374AbbBBNCl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 08:02:41 -0500
Message-ID: <1422882133.1930.10.camel@sipsolutions.net> (sfid-20150202_140245_786936_6E27E702)
Subject: Re: [PATCH] ath10k: Replace ioread with wmb for data sync
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Oh <poh@codeaurora.org>
Cc: Peter Oh <poh@qca.qualcomm.com>, linux-wireless@vger.kernel.org,
	Bob Copeland <me@bobcopeland.com>, ath10k@lists.infradead.org
Date: Mon, 02 Feb 2015 14:02:13 +0100
In-Reply-To: <54CC0B71.9050301@codeaurora.org>
References: <1422311118-11320-1-git-send-email-poh@qca.qualcomm.com>
	 <20150127213349.GA24933@localhost> <54C824DC.5080804@qca.qualcomm.com>
	 <20150128043005.GB24933@localhost> <54C875FD.3070101@qca.qualcomm.com>
	 (sfid-20150128_064104_435635_7E681844) <1422430643.1973.1.camel@sipsolutions.net>
	 <54CC0B71.9050301@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-30 at 14:53 -0800, Peter Oh wrote:

> I admit that I/O ordering and posted write are looked different in 
> theory and at glance since posted write could be related cache invalidate.
> But wmb are still related to both.
> As I addressed wmb uses dsb (in arm arch) and here is the description of 
> arm architecture.
> 
> * DSB drains write buffer.
> * DSB is architecturally defined to include all cache, TLB and branch 
> prediction maintenance operations as well as explicit memory operations
> 
> These are the reasons why I mentioned wmb does both.
> 
> * captured from ARMv7 Architecture Manual
> --- Notes ---
> Historically, this operation was referred to as Drain Write Buffer or 
> Data Write Barrier (DWB). From ARMv6, these
> names and the use of DWB were deprecated in favor of the new Data 
> Synchronization Barrier name and DSB
> abbreviation. DSB better reflects the functionality provided from ARMv6, 
> because DSB is architecturally defined
> to include all cache, TLB and branch prediction maintenance operations 
> as well as explicit memory operations
> 
> --- A DSB completes when: ---
> ? all explicit memory accesses that are observed by Pe before the DSB is 
> executed, are of the required access
> types, and are from observers in the same required shareability domain 
> as Pe, are complete for the set of
> observers in the required shareability domain.
> ? if the required accesses types of the DSB is reads and writes, all 
> cache and branch predictor maintenance
> operations issued by Pe before the DSB are complete for the required 
> shareability domain.
> ? if the required accesses types of the DSB is reads and writes, all TLB 
> maintenance operations issued by Pe
> before the DSB are complete for the required shareability domain.
> --------------

I cannot read from this in any way that it can post writes to the PCIe
bus. In fact, architecturally, I cannot think of any reason how it even
could do that from the CPU.

> Furthermore this is the comparison of the compiled assembly code between 
> ath10k_pci_read32 and wmb.
> 
> ath10k_pci_read32()
>       bac:    e5932008     ldr    r2, [r3, #8]
>       bb0:    f57ff04f     dsb    sy
>       bb4:    e2883d52     add    r3, r8, #5248    ; 0x1480
>       bb8:    e283303c     add    r3, r3, #60    ; 0x3c
>       bbc:    e593300c     ldr    r3, [r3, #12]
>       bc0:    e2833a09     add    r3, r3, #36864    ; 0x9000
> 
> wmb();
>       b9c:    f57ff04e     dsb    st
> 
> ath10k_pci_read32 does register operation except dsb and there is no 
> cache invalidate related commands.

I don't think this is relevant. The question is "what are you trying to
achieve".

> So that if wmb is not enough for the purpose then ath10k_pci_read32 is 
> also not enough for that.
> 
> Also refer the section "ACQUIRES VS I/O ACCESSES" in memory-barriers.txt.
> 
> It gives an example with PCI bridge and introduces readl as an 
> alternative method to mmiowb which weaker form of wmb.
> 
> Please give your opinion.

Again - the question is - what are you trying to achieve?

The code (as it is before your patch) implies that it's trying to make
sure that before it continues, any previous writes to the PCIe device's
registers are posted. The only way to ensure that is to do a read to the
registers, as the code does now.

What you're describing is something else entirely - you're describing a
way to make sure that some data was flushed out to DRAM from the CPU
caches.

These two things are not related in any way.

In an interrupt routine, it would make sense to ensure that the write
was posted (e.g. to mask interrupts, or to acknowledge them, or similar,
before the routine can be re-invoked.)

To me, flushing memory writes to DRAM makes less sense in an interrupt
handlers unless the device was somehow using DMA to coordinate
interrupts [1], which seems unlikely but I haven't checked.

Anyway - I have no particular interest in this discussion, I was merely
trying to help you out with this :) You can make whatever change you
want, of course :P

johannes

[1] incidentally, our device [iwlwifi] does in fact do something like
that, but it's read-only for the driver so no need for such a thing
either

