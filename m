Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56168 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752855AbeB1SFG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 13:05:06 -0500
Subject: Re: [RFC] ath10k: Attempt to work around napi_synchronize hang.
To: =?UTF-8?Q?Micha=c5=82_Kazior?= <kazikcz@gmail.com>
References: <1519780965-15292-1-git-send-email-greearb@candelatech.com>
 <CABvG-CU1jf4xN+LZdkdejqr67Mcs-JdvGrvHnh0pB2VSJjJZzQ@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <95ddec98-2613-7e6d-3ec8-d47d1aa527db@candelatech.com> (sfid-20180228_190510_494575_CEDE89C3)
Date: Wed, 28 Feb 2018 10:05:04 -0800
MIME-Version: 1.0
In-Reply-To: <CABvG-CU1jf4xN+LZdkdejqr67Mcs-JdvGrvHnh0pB2VSJjJZzQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/28/2018 09:31 AM, Michał Kazior wrote:
> On 28 February 2018 at 02:22,  <greearb@candelatech.com> wrote:
> [...]
>> @@ -2086,8 +2087,28 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
>>         ath10k_pci_irq_disable(ar);
>>         ath10k_pci_irq_sync(ar);
>>         ath10k_pci_flush(ar);
>> -       napi_synchronize(&ar->napi);
>> -       napi_disable(&ar->napi);
>> +
>> +       /* Calling napi_disable twice in a row (w/out starting it and/or without
>> +        * having NAPI active leads to deadlock because napi_disable sets
>> +        * NAPI_STATE_SCHED and NAPI_STATE_NPSVC when it returns, as far as I
>> +        * can tell.  So, guard this call to napi_disable.  I believe the
>> +        * failure case is something like this:
>> +        * rmmod ath10k_pci ath10k_core
>> +        *   Firmware crashes before hif_stop is called by the rmmod path
>> +        *   The crash handling logic calls hif_stop
>> +         *   Then rmmod gets around to calling hif_stop, but spins endlessly
>> +        *   in napi_synchronize.
>> +        *
>> +        *  I think one way this could happen is that ath10k_stop checks
>> +        *  for state != ATH10K_STATE_OFF, but STATE_RESTARTING is also
>> +        *  a possibility.  That might be how we can have hif_stop called twice
>> +        *  without a hif_start in between. --Ben
>> +        */
>> +       if (ar->napi_enabled) {
>> +               napi_synchronize(&ar->napi);
>> +               napi_disable(&ar->napi);
>> +               ar->napi_enabled = false;
>> +       }
>
> Looking at the code and your comment the described fail case seems
> legit. I would consider tuning ath10k_stop() so that it calls
> ath10k_halt() only if ar->state != OFF & ar->state != RESTARTING
> though. Or did you try already?

I did not try tuning ath10k_stop().  The code in this area is quite complex,
and in my opinion trying to keep the start/stop calls exactly matched without
individual 'has_started' flags seems ripe for bugs.

> While your approach will probably work it won't prevent other non-NAPI
> bad things from happening. Even if there's nothing today it might
> creep up in the future. And you'd need to update ahb.c too.

I'll update ahb.c to match.

Thanks,
Ben

>
>
> Michał
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
