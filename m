Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:36355 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbaJHKu3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 06:50:29 -0400
Received: by mail-vc0-f176.google.com with SMTP id hq11so6339610vcb.21
        for <linux-wireless@vger.kernel.org>; Wed, 08 Oct 2014 03:50:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141008103312.GA25666@qca.qualcomm.com>
References: <1412759786-10567-1-git-send-email-rmanohar@qti.qualcomm.com>
	<CA+BoTQ=K=F5TodrmuaEaJfErFx1=BL-bmPDrAaeMLjjb8c3fJQ@mail.gmail.com>
	<20141008103312.GA25666@qca.qualcomm.com>
Date: Wed, 8 Oct 2014 12:50:28 +0200
Message-ID: <CA+BoTQmVsyuxjvc_s-BC6ZwRWk3ACG0CvDYHJRnZ7OqY6W1Upw@mail.gmail.com> (sfid-20141008_125035_351735_CD016EA1)
Subject: Re: [PATCH] ath10k: fix kernel panic while shutting down AP
From: Michal Kazior <michal.kazior@tieto.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 October 2014 12:33, Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
> On Wed, Oct 08, 2014 at 11:45:38AM +0200, Michal Kazior wrote:
>> On 8 October 2014 11:16, Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
>> > The commit "ath10k: workaround fw beaconing bug" is freeing
>> > DMA-coherent memory in irq context which is hitting BUG ON
>> > in ARM platforms. Fix this by moving dma_free out of spin
>> > lock.
>>
>> I hardly see how moving the freeing outside the spinlock is a fix.
>>
>>
>> > kernel BUG at mm/vmalloc.c:1512!
>> > Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM
>> > CPU: 0 PID: 722 Comm: hostapd Not tainted 3.14.0 #3
>> > task: dd58b840 ti: da6a6000 task.ti: da6a6000
>> > PC is at vunmap+0x24/0x34
>> > LR is at __arm_dma_free.isra.21+0x12c/0x190
>> > [<c02a97d0>] (vunmap) from [<c021f81c>] (__arm_dma_free.isra.21+0x12c/0x190)
>> > [<c021f81c>] (__arm_dma_free.isra.21) from [<bf3b2440>]
>> >                         (ath10k_mac_vif_beacon_free+0xf4/0x100 [ath10k_core])
>> > [<bf3b2440>] (ath10k_mac_vif_beacon_free [ath10k_core]) from [<bf3b2490>]
>> >                         (ath10k_remove_interface+0x44/0x1ec [ath10k_core])
>> > [<bf3b2490>] (ath10k_remove_interface [ath10k_core]) from [<bf3352e4>]
>> >                         (ieee80211_add_virtual_monitor+0x9d8/0x9f0 [mac80211])
>> > [<bf3352e4>] (ieee80211_add_virtual_monitor [mac80211]) from [<bf33530c>]
>> >                         (ieee80211_stop+0x10/0x18 [mac80211])
>> > [<bf33530c>] (ieee80211_stop [mac80211]) from [<c040d144>]
>> >                         (__dev_close_many+0x9c/0xcc)
>>
>>  1. How can even ieee80211_add_virtual_monitor() call
>> ath10k_remove_interface()? Upstream ath10k doesn't advertise
>> IEEE80211_HW_WANT_MONITOR_VIF. This call trace is either invalid,
>> you're not using upstream ath10k and/or have custom patches applied to
>> ath10k.
>>
> This is the backtrace captured on panic and we are getting the same
> backtrace consistently. I confirmed that add_virtual_monitor is not
> called for ath10k as it is not advertising. ath10k_remove_interface is
> called for master mode.
>
>>  2. How can ieee80211_stop() be called from an interrupt context
>> anyway? ieee80211_stop() calls ieee80211_do_stop() which calls
>> ieee80211_roc_purge() which tries to get a hold of local->mtx. This
>> implies ieee80211_stop() isn't design to be run in an interrupt
>> context to begin with so I don't see why ath10k should even care if
>> ath10k_remove_interface() is called in an interrupt context at this
>> point.
>>
> in_interrupt is counting soft and hard irqs. ieee80211_stop is not
> called from interrupt context. In ath10k, by aquiring spin_lock in
> ath10k_mac_vif_beacon_free is increasing soft irq count.
>
> In ARM arch, __arm_dma_free is calling vunmap which might sleep. So it
> can not be called within spin_lock.

Did you try using GFP_ATOMIC in the dma_alloc_coherent instead of
moving the spinlock?


>
> Similar to dma_alloc_coherent, dma_free_coherent can not be called under
> soft irq context.

The call trace points to ath10k_mac_vif_beacon_free() which doesn't
use dma_free_coherent() so why are you blaming it for the BUG_ON?

If anything the offender should be dma_unmap_single() but the thing is
beacon_buf is always allocated for AP/IBSS now which means
dma_unmap_single() is never called. For non-AP/IBSS both arvif->beacon
and arvif->beacon_buf are always NULL so neither
dma_alloc/free_coherent nor dma_map/unmap_single are called.


> PS: I am using upstream ath10k driver without private changes.

Interesting. Why is there ieee80211_add_virtual_monitor() calling
ath10k_remove_interface() then? This makes absolutely no sense.

Can you try checking what lines does the call trace point to in gdb?


Michał
