Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41394 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109Ab1EMHlX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 03:41:23 -0400
Received: by bwz15 with SMTP id 15so1914813bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 00:41:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305229737.12586.1027.camel@cumari>
References: <1305104068-32240-1-git-send-email-eliad@wizery.com>
	<1305104068-32240-5-git-send-email-eliad@wizery.com>
	<1305229737.12586.1027.camel@cumari>
Date: Fri, 13 May 2011 10:41:21 +0300
Message-ID: <BANLkTinuHS-QOG_d9VkX9tCCY4HRZqEFsQ@mail.gmail.com> (sfid-20110513_094127_478047_AC4D3FB9)
Subject: Re: [PATCH 4/7] wl12xx: prevent scheduling while suspending (WoW enabled)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 12, 2011 at 10:48 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Wed, 2011-05-11 at 11:54 +0300, Eliad Peller wrote:
>> When WoW is enabled, the interface will stay up and the chip will
>> be powered on, so we have to flush/cancel any remaining work, and
>> prevent the irq handler from scheduling a new work until the system
>> is resumed.
>>
>> Add 2 new flags:
>> * WL1271_FLAG_SUSPENDED - the system is (about to be) suspended.
>> * WL1271_FLAG_PENDING_WORK - there is a pending irq work which
>>    should be scheduled when the system is being resumed.
>>
>> In order to wake-up the system while getting an irq, we initialize
>> the device as wakeup device, and calling pm_wakeup_event() upon
>> getting the interrupt (while the system is about to be suspended)
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> [...]
>
>> +             if (run_irq_work) {
>> +                     wl1271_debug(DEBUG_MAC80211,
>> +                                  "run postponed irq_work directly");
>> +                     wl1271_irq(0, wl);
>> +                     wl1271_enable_interrupts(wl);
>
> Shouldn't this wl1271_enable_interrupts() be outside the if? Don't you
> want to enable interrupts again when there was no pending work?

by default, the interrupts are enabled (we need them in order to wake
up the device).
we disable them only after getting an interrupt and setting the
pending_work bit (see wl1271_hardirq())

>
>
>> diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
>> index 5b03fd5..bf2a6ad 100644
>> --- a/drivers/net/wireless/wl12xx/sdio.c
>> +++ b/drivers/net/wireless/wl12xx/sdio.c
>> @@ -72,6 +72,7 @@ static irqreturn_t wl1271_hardirq(int irq, void *cookie)
>>  {
>>       struct wl1271 *wl = cookie;
>>       unsigned long flags;
>> +     bool skip = false;
>>
>>       wl1271_debug(DEBUG_IRQ, "IRQ");
>>
>> @@ -82,8 +83,20 @@ static irqreturn_t wl1271_hardirq(int irq, void *cookie)
>>               complete(wl->elp_compl);
>>               wl->elp_compl = NULL;
>>       }
>> +
>> +     if (test_bit(WL1271_FLAG_SUSPENDED, &wl->flags)) {
>> +             /* don't enqueue a work right now. mark it as pending */
>> +             set_bit(WL1271_FLAG_PENDING_WORK, &wl->flags);
>> +             wl1271_debug(DEBUG_IRQ, "should not enqueue work");
>> +             disable_irq_nosync(wl->irq);
>> +             pm_wakeup_event(wl1271_sdio_wl_to_dev(wl), 0);
>> +             skip = true;
>> +     }
>>       spin_unlock_irqrestore(&wl->wl_lock, flags);
>>
>> +     if (skip)
>> +             return IRQ_HANDLED;
>> +
>>       return IRQ_WAKE_THREAD;
>>  }
>
> Could be nicer to just skip the skip variable (unintended pun
> intended ;).  You can do it like this:
>
> if (test_bit...) {
>        ...
>        spin_unlock_irqrestore();
>        return IRQ_HANDLED;
> }
> spin_unlock_irqrestore();
> return IRQ_WAKE_THREAD;
>
> Looks a bit nicer to me, but I don't mind if you prefer not skipping the
> skip. :)
>

well, i don't have a preference here how to handle the HANDLED case. ;)
so i'll change it if you prefer it that way.

thanks,
Eliad.
