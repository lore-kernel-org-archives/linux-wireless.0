Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:49263 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbbA3Wxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 17:53:50 -0500
Message-ID: <54CC0B71.9050301@codeaurora.org> (sfid-20150130_235353_807459_519549D9)
Date: Fri, 30 Jan 2015 14:53:37 -0800
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Peter Oh <poh@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
	ath10k@lists.infradead.org
Subject: Re: [PATCH] ath10k: Replace ioread with wmb for data sync
References: <1422311118-11320-1-git-send-email-poh@qca.qualcomm.com> <20150127213349.GA24933@localhost> <54C824DC.5080804@qca.qualcomm.com> <20150128043005.GB24933@localhost> <54C875FD.3070101@qca.qualcomm.com> (sfid-20150128_064104_435635_7E681844) <1422430643.1973.1.camel@sipsolutions.net>
In-Reply-To: <1422430643.1973.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 01/27/2015 11:37 PM, Johannes Berg wrote:
> On Tue, 2015-01-27 at 21:39 -0800, Peter Oh wrote:
>
>>> Ok, sure, but I/O ordering two different writes, and ensuring device
>>> has seen a posted write, are related but different things, no?
>> yes, they are different and wmb guarantees both.
> No, wmb() doesn't. I'd be very surprised if it had any side effect on
> the PCI bus even on ARM. Read Documentation/memory-barriers.txt.
>
> And to understand (PCI) posted writes, wikipedia helps:
> http://en.wikipedia.org/wiki/Posted_write
I admit that I/O ordering and posted write are looked different in 
theory and at glance since posted write could be related cache invalidate.
But wmb are still related to both.
As I addressed wmb uses dsb (in arm arch) and here is the description of 
arm architecture.

* DSB drains write buffer.
* DSB is architecturally defined to include all cache, TLB and branch 
prediction maintenance operations as well as explicit memory operations

These are the reasons why I mentioned wmb does both.

* captured from ARMv7 Architecture Manual
--- Notes ---
Historically, this operation was referred to as Drain Write Buffer or 
Data Write Barrier (DWB). From ARMv6, these
names and the use of DWB were deprecated in favor of the new Data 
Synchronization Barrier name and DSB
abbreviation. DSB better reflects the functionality provided from ARMv6, 
because DSB is architecturally defined
to include all cache, TLB and branch prediction maintenance operations 
as well as explicit memory operations

--- A DSB completes when: ---
? all explicit memory accesses that are observed by Pe before the DSB is 
executed, are of the required access
types, and are from observers in the same required shareability domain 
as Pe, are complete for the set of
observers in the required shareability domain.
? if the required accesses types of the DSB is reads and writes, all 
cache and branch predictor maintenance
operations issued by Pe before the DSB are complete for the required 
shareability domain.
? if the required accesses types of the DSB is reads and writes, all TLB 
maintenance operations issued by Pe
before the DSB are complete for the required shareability domain.
--------------

Furthermore this is the comparison of the compiled assembly code between 
ath10k_pci_read32 and wmb.

ath10k_pci_read32()
      bac:    e5932008     ldr    r2, [r3, #8]
      bb0:    f57ff04f     dsb    sy
      bb4:    e2883d52     add    r3, r8, #5248    ; 0x1480
      bb8:    e283303c     add    r3, r3, #60    ; 0x3c
      bbc:    e593300c     ldr    r3, [r3, #12]
      bc0:    e2833a09     add    r3, r3, #36864    ; 0x9000

wmb();
      b9c:    f57ff04e     dsb    st

ath10k_pci_read32 does register operation except dsb and there is no 
cache invalidate related commands.

So that if wmb is not enough for the purpose then ath10k_pci_read32 is 
also not enough for that.

Also refer the section "ACQUIRES VS I/O ACCESSES" in memory-barriers.txt.

It gives an example with PCI bridge and introduces readl as an 
alternative method to mmiowb which weaker form of wmb.

Please give your opinion.
> johannes
>
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
Regards,
Peter
