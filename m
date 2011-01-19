Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41876 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab1ASBjU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 20:39:20 -0500
Received: by iwn9 with SMTP id 9so285906iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jan 2011 17:39:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D363FBA.3000207@candelatech.com>
References: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
 <1291690135-4535-2-git-send-email-lrodriguez@atheros.com> <4D363FBA.3000207@candelatech.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 18 Jan 2011 17:38:59 -0800
Message-ID: <AANLkTi=cWF0UrHG2DXoYp1NLP6F179A6pQ3P-tLFBNTg@mail.gmail.com>
Subject: Re: [PATCH 1/5] ath9k: warn when we get a ATH9K_INT_TIM_TIMER and are idle
To: Ben Greear <greearb@candelatech.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, amod.bodas@atheros.com,
	pstew@google.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 18, 2011 at 5:34 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 12/06/2010 06:48 PM, Luis R. Rodriguez wrote:
>>
>> We should not be idle when we get the ATH9K_INT_TIM_TIMER,
>> otherwise we wake up the chip and that throws off the idle
>> state, the driver needs to be in full sleep when idle and
>> nothing should turn it awake without turning it back to
>> full sleep again. If we leave the chip idle and suspend,
>> upon resume the device will become unusable and we get:
>>
>> ath: Starting driver with initial channel: 5745 MHz
>> ath: timeout (100000 us) on reg 0x7000: 0xdeadbeef&  0x00000003 !=
>> 0x00000000
>>
>> Cc: Paul Stewart<pstew@google.com>
>> Cc: Amod Bodas<amod.bodas@atheros.com>
>> signed-off-by: Luis R. Rodriguez<lrodriguez@atheros.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/main.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/main.c
>> b/drivers/net/wireless/ath/ath9k/main.c
>> index f026a03..fd27ec9 100644
>> --- a/drivers/net/wireless/ath/ath9k/main.c
>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>> @@ -770,6 +770,7 @@ irqreturn_t ath_isr(int irq, void *dev)
>>                if (status&  ATH9K_INT_TIM_TIMER) {
>>                        /* Clear RxAbort bit so that we can
>>                         * receive frames */
>> +                       WARN_ON(sc->ps_idle);
>>                        ath9k_setpower(sc, ATH9K_PM_AWAKE);
>>                        ath9k_hw_setrxabort(sc->sc_ah, 0);
>>                        sc->ps_flags |= PS_WAIT_FOR_BEACON;
>
> Looks like this patch never made it in.
>
> Should it be in, or should I just drop it from my queue?
>

Eh, it shouldn't happen and if we warn we should use the new debugging
warn once thingy you added. I never saw that trigger so probably we
can just ignore it.

  Luis
