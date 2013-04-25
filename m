Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:49398 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759095Ab3DYTse convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Apr 2013 15:48:34 -0400
Received: by mail-qc0-f178.google.com with SMTP id d10so1708968qca.23
        for <linux-wireless@vger.kernel.org>; Thu, 25 Apr 2013 12:48:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9E057145@SC-VEXCH1.marvell.com>
References: <CAMLZHHRpPghm0tWTksFiD-zxUUM1dSbgPbj6doMck1jqv-yokw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9DAD431B@SC-VEXCH1.marvell.com>
	<CAMLZHHRcTgQ66fucR09SEyjCCRiZixigM=cDwnfKB5yWYk4PQw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9DDAB9CC@SC-VEXCH1.marvell.com>
	<CAMLZHHTe+9D_XwYHFMbu8bRAD7OHNgf8_0+44ZhM+AwSnwLZBw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E057145@SC-VEXCH1.marvell.com>
Date: Thu, 25 Apr 2013 13:48:33 -0600
Message-ID: <CAMLZHHS_fBABvx1rGSs2zwv3RredXHh5ChrN7Nwz8ofuL8Vmyg@mail.gmail.com> (sfid-20130425_214839_775605_DCC29AC1)
Subject: Re: mwifiex frequent "not allowed while suspended" crash on resume
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Rhodes <jrhodes@marvell.com>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 18, 2013 at 1:20 PM, Bing Zhao <bzhao@marvell.com> wrote:
> Hi Daniel,
>
>> > Normally TX is blocked until resume handler is called and host sleep handshake between driver and
>> firmware is done.
>>
>> Where is the code that makes such synchronization happen?
>
> If a data packet is received unexpectedly during suspended, driver blocks it and displays a message "not allowed while suspended".

I think we have enough evidence to show that the handling of this
condition is rather broken and breaks future communication with the
card.

I also don't regard such behaviour as "blocking" since when the data
packet fails to be handled, it is not blocked and processed later, it
is discarded.

If blocking is desired (sounds sensible) I would expect the packet not
to reach the mwifiex_sdio layer at all, until it has flagged itself as
ready to continue handling such packets.

> Earlier you mentioned that doing netif attach/detach in suspend/resume would work around this problem.
> It reminders me that previously we set carrier off in suspend so that kernel won't send data packets to driver. That carrier-off code was removed in recent commit 1499d9f to fix a missing ping response issue right after resume. Perhaps it's worth a revisit to this change.

I am confident that this bug also existed before that change, but it
might indeed have made it more likely now.

Regarding the attach/detach possibility, I would say the open question
is: does this issue expose a bug in the mwifiex logic for handling TX
etc? If so, that bug should be fixed. On the other hand, if the
mwifiex logic is *designed* under the idea that no TX will ever happen
at these moments, then putting netif_attach/detatch in the right place
is an OK solution. I have looked at the mwifiex code and history but I
haven't been able to determine what the design here is supposed to be.

>> > Does the TX happen before "hs_deactivated" event?
>>
>> hard_start_xmit is called approximately 1ms after hs_deactivated arrives.
>
> When hs_deactivated event arrives, 'is_suspended' flag must have been cleared already. The tx packets should be allowed to send freely. I don't know why the message "not allowed while suspended" is fired in this case.
> There could be a race condition somewhere though. Could you please send a complete dynamic_debug enabled log showing all the sequence?

I assume the code you are referring to is in mwifiex_sdio_resume():

        adapter->is_suspended = false;

        /* Disable Host Sleep */
        mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
                          MWIFIEX_ASYNC_CMD);

i.e. the cancel_hs() call results in the hs_deactivated event
arriving, at which point we are free to transmit.

The order of events in this code makes me uneasy. You suggested
earlier that is_suspended is the flag that indicates from the
mwifiex_sdio layer "I'm ready to transmit again". But is it really OK
to transmit before the host sleep is cancelled, as the above ordering
suggests?

In this particular case, as you can see in the dynamic debug logs, it
looks like the whole situation is confused here due to the arrival of
an interrupt which causes mwifiex to take an early exit from the host
sleep.

http://dev.laptop.org/~dsd/20130425/mwifiex-earlytx.log

>>
>> > I'm thinking of releasing IRQ in driver suspend handler and re-claim the IRQ in resume. Of course
>> it needs some changes in sdio_release_irq to skip SDIO_CCCR_IENx disabling, otherwise host may not be
>> woken up by SDIO DAT1.
>> >
>> > Attached is the sample code, not tested.
>>
>> That patch breaks wake-on-LAN, the suspended system simply doesn't
>> respond to incoming packets.
>
> Could you confirm that you saw this message on suspend?
>
> "SDIO: KEEP IRQ ON for ..."

No, that message doesn't appear.
I can't quite grasp what you're trying to do in that patch. Where does
mwifiex even set MMC_PM_WAKE_SDIO_IRQ?

Admittedly we are using a slightly different suspend routine that
predates the upstream mwifiex implementation. But I hadn't noticed any
interesting differences until now. We do set MMC_PM_WAKE_SDIO_IRQ,
after your patch it looks like this:

/* Enable the Host Sleep */
hs_actived = mwifiex_enable_hs(adapter);
if (hs_actived) {
sdio_claim_host(card->func);
sdio_release_irq(func);
sdio_release_host(card->func);
pr_info("cmd: suspend with MMC_PM_KEEP_POWER|MMC_PM_WAKE_SDIO_IRQ\n");
ret = sdio_set_host_pm_flags(func,
    MMC_PM_KEEP_POWER|
    MMC_PM_WAKE_SDIO_IRQ);
}

This one hunk had to be applied by hand, but I thought I stuck to the
same approach as in the patch: release the irq before calling
set_host_pm_flags.

But the logic in the patch suggests that you would expect the
WAKE_SDIO_IRQ flag to be set before sdio_release_irq() is called,
triggering the "KEEP IRQ ON" message that you're looking for.

Thanks
Daniel
