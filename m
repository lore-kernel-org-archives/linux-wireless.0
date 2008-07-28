Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:7649 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYG1NAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 09:00:12 -0400
Received: by an-out-0708.google.com with SMTP id d40so904313and.103
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 06:00:11 -0700 (PDT)
Message-ID: <40f31dec0807280600u2841a710uf935de604d9bcfc8@mail.gmail.com> (sfid-20080728_150022_721621_1C55FB5C)
Date: Mon, 28 Jul 2008 16:00:10 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 6/12] ath5k: Reorder calibration calls during reset and update hw_set_power
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com
In-Reply-To: <4885F42F.9050503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080720034126.GF7440@makis> <4885F42F.9050503@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/7/22 Jiri Slaby <jirislaby@gmail.com>:
> On 07/20/2008 05:41 AM, Nick Kossifidis wrote:
>>
>>  * Update ath5k_hw_reset and add some more documentation about PHY
>> calibration
>>  * Fix ath5k_hw_set_power to use AR5K_SLEEP_CTL_SLE_ALLOW for Network
>> sleep
>>  * Preserve sleep duration field while setting AR5K_SLEEP_CTL and reduce
>> delays & checks for register's status (got this from decompiling & dumps, it
>> works for me but it needs testing)
>>
>>  Changes-licensed-under: ISC
>>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>>
>> ---
>> diff --git a/drivers/net/wireless/ath5k/hw.c
>> b/drivers/net/wireless/ath5k/hw.c
>> index cab1a8a..4fb048c 100644
>> --- a/drivers/net/wireless/ath5k/hw.c
>> +++ b/drivers/net/wireless/ath5k/hw.c
>
> [...]
>>
>> @@ -1461,6 +1496,7 @@ int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah,
>> unsigned int queue)
>>                  /* Stop queue */
>>                ath5k_hw_reg_write(ah, tx_queue, AR5K_CR);
>> +               ath5k_hw_reg_read(ah, AR5K_CR);
>
> This one was in my patch already.
>

Sorry, i just got that from decompiling/tracing registers and put it
there, i didn't noticed that you had already fixed it (your patches
were mostly for base.c, i didn't notice your changes in hw.c)...

>>        } else {
>>                /*
>>                 * Schedule TX disable and wait until queue is empty
>> @@ -1705,6 +1741,7 @@ enum ath5k_int ath5k_hw_set_intr(struct ath5k_hw
>> *ah, enum ath5k_int new_mask)
>
> Adding from the code:
>        /*
>         * Disable card interrupts to prevent any race conditions
>>
>>         * (they will be re-enabled afterwards).
>>         */
>>        ath5k_hw_reg_write(ah, AR5K_IER_DISABLE, AR5K_IER);
>> +       ath5k_hw_reg_read(ah, AR5K_IER);
>
> Is this first flush needed? Writes cannot be reordered, they are just
> asynchronous and flushed below. What race is this against? The interrupt
> might be processed (or pending) at this moment on other processor anyway.
>

I think i also got that from decompiling, i'll check it out but i
guess patch can go in until then, the whole series also adds RF2425
support and many people want that (mostly eeepc users).

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
