Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:51061 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbaJHMQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 08:16:20 -0400
Received: by mail-vc0-f171.google.com with SMTP id hy10so6535970vcb.2
        for <linux-wireless@vger.kernel.org>; Wed, 08 Oct 2014 05:16:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141008110842.GC25666@qca.qualcomm.com>
References: <1412759786-10567-1-git-send-email-rmanohar@qti.qualcomm.com>
	<CA+BoTQ=K=F5TodrmuaEaJfErFx1=BL-bmPDrAaeMLjjb8c3fJQ@mail.gmail.com>
	<20141008103312.GA25666@qca.qualcomm.com>
	<CA+BoTQmVsyuxjvc_s-BC6ZwRWk3ACG0CvDYHJRnZ7OqY6W1Upw@mail.gmail.com>
	<20141008110842.GC25666@qca.qualcomm.com>
Date: Wed, 8 Oct 2014 14:16:18 +0200
Message-ID: <CA+BoTQ=BuSrkBxkbsShZM=Zh8uqye5u0HydpfM9roubgi0-4tQ@mail.gmail.com> (sfid-20141008_141623_740154_5E684C98)
Subject: Re: [PATCH] ath10k: fix kernel panic while shutting down AP
From: Michal Kazior <michal.kazior@tieto.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 October 2014 13:08, Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
> On Wed, Oct 08, 2014 at 12:50:28PM +0200, Michal Kazior wrote:
>> On 8 October 2014 12:33, Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
>> > On Wed, Oct 08, 2014 at 11:45:38AM +0200, Michal Kazior wrote:
>> >> On 8 October 2014 11:16, Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
>> >> > The commit "ath10k: workaround fw beaconing bug" is freeing
>> >> > DMA-coherent memory in irq context which is hitting BUG ON
>> >> > in ARM platforms. Fix this by moving dma_free out of spin
>> >> > lock.
>> >>
>> >> I hardly see how moving the freeing outside the spinlock is a fix.
>> >>
>> >>
>> >> > kernel BUG at mm/vmalloc.c:1512!
>> >> > Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM
>> >> > CPU: 0 PID: 722 Comm: hostapd Not tainted 3.14.0 #3
>> >> > task: dd58b840 ti: da6a6000 task.ti: da6a6000
>> >> > PC is at vunmap+0x24/0x34
>> >> > LR is at __arm_dma_free.isra.21+0x12c/0x190
>> >> > [<c02a97d0>] (vunmap) from [<c021f81c>] (__arm_dma_free.isra.21+0x12c/0x190)
>> >> > [<c021f81c>] (__arm_dma_free.isra.21) from [<bf3b2440>]
>> >> >                         (ath10k_mac_vif_beacon_free+0xf4/0x100 [ath10k_core])
>> >> > [<bf3b2440>] (ath10k_mac_vif_beacon_free [ath10k_core]) from [<bf3b2490>]
>> >> >                         (ath10k_remove_interface+0x44/0x1ec [ath10k_core])
>> >> > [<bf3b2490>] (ath10k_remove_interface [ath10k_core]) from [<bf3352e4>]
>> >> >                         (ieee80211_add_virtual_monitor+0x9d8/0x9f0 [mac80211])
>> >> > [<bf3352e4>] (ieee80211_add_virtual_monitor [mac80211]) from [<bf33530c>]
>> >> >                         (ieee80211_stop+0x10/0x18 [mac80211])
>> >> > [<bf33530c>] (ieee80211_stop [mac80211]) from [<c040d144>]
>> >> >                         (__dev_close_many+0x9c/0xcc)
>> >>
>> >>  1. How can even ieee80211_add_virtual_monitor() call
>> >> ath10k_remove_interface()? Upstream ath10k doesn't advertise
>> >> IEEE80211_HW_WANT_MONITOR_VIF. This call trace is either invalid,
>> >> you're not using upstream ath10k and/or have custom patches applied to
>> >> ath10k.
>> >>
>> > This is the backtrace captured on panic and we are getting the same
>> > backtrace consistently. I confirmed that add_virtual_monitor is not
>> > called for ath10k as it is not advertising. ath10k_remove_interface is
>> > called for master mode.
>> >
>> >>  2. How can ieee80211_stop() be called from an interrupt context
>> >> anyway? ieee80211_stop() calls ieee80211_do_stop() which calls
>> >> ieee80211_roc_purge() which tries to get a hold of local->mtx. This
>> >> implies ieee80211_stop() isn't design to be run in an interrupt
>> >> context to begin with so I don't see why ath10k should even care if
>> >> ath10k_remove_interface() is called in an interrupt context at this
>> >> point.
>> >>
>> > in_interrupt is counting soft and hard irqs. ieee80211_stop is not
>> > called from interrupt context. In ath10k, by aquiring spin_lock in
>> > ath10k_mac_vif_beacon_free is increasing soft irq count.
>> >
>> > In ARM arch, __arm_dma_free is calling vunmap which might sleep. So it
>> > can not be called within spin_lock.
>>
>> Did you try using GFP_ATOMIC in the dma_alloc_coherent instead of
>> moving the spinlock?
>>
> Nope. The problem is while freeing dma memory not during allocation.
> dma_free_coherent won't take any GFP_* flags.

My thinking was GFP_ given to dma_alloc_coherent could impact
behaviour of dma_free_coherent (e.g. different kind of pages is
allocated so different kind of freeing will be involved) but I may be
wrong.

Can you give it a try, please?


>> > Similar to dma_alloc_coherent, dma_free_coherent can not be called under
>> > soft irq context.
>>
>> The call trace points to ath10k_mac_vif_beacon_free() which doesn't
>> use dma_free_coherent() so why are you blaming it for the BUG_ON?
>>
> I agree the calltrace is a bogus. ath10k_mac_vif_beacon_cleanup is
> calling dma_free_coherent.

The call trace without additional comment in the commit log (stating
the fact that the call trace is inaccurate for some reason) is
confusing.


>> If anything the offender should be dma_unmap_single() but the thing is
>> beacon_buf is always allocated for AP/IBSS now which means
>> dma_unmap_single() is never called. For non-AP/IBSS both arvif->beacon
>> and arvif->beacon_buf are always NULL so neither
>> dma_alloc/free_coherent nor dma_map/unmap_single are called.
>>
> Agree. We need one more check in ath10k_mac_vif_beacon_free. But here
> the problem is dma_free_coherent is being called from soft irq context
> which is not allowed (BUG_ON noted in ARM arch).
>
> After moving dma_free_coherent out of spinlock, the kernel
> BUG at mm/vmalloc.c:1512 is never hit.

It seems there's a bit of branching in the arm dma code. Maybe it's
possible to fix this problem in ath10k differently (vide the gfp
idea).


Michał
