Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:48404 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaJMI3W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 04:29:22 -0400
Received: by mail-wg0-f49.google.com with SMTP id x12so8094850wgg.20
        for <linux-wireless@vger.kernel.org>; Mon, 13 Oct 2014 01:29:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <877g049yhe.fsf@kamboji.qca.qualcomm.com>
References: <1412847527-25983-1-git-send-email-michal.kazior@tieto.com>
	<1412847527-25983-4-git-send-email-michal.kazior@tieto.com>
	<877g049yhe.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 13 Oct 2014 10:29:21 +0200
Message-ID: <CA+BoTQ=kKvKz5P-Buk3nOA+2f9SaJgXze7HsE0_1ARuBvU3+aw@mail.gmail.com> (sfid-20141013_102926_099663_E6AFC62F)
Subject: Re: [PATCH 3/3] ath10k: speed up hw recovery
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 October 2014 10:15, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> In some cases hw recovery was taking an absurdly
>> long time due to ath10k waiting for things that
>> would never really complete.
>>
>> Instead of waiting for inevitable timeouts poke
>> all completions and wakequeues and check if it's
>> still worth waiting.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> --- a/drivers/net/wireless/ath/ath10k/core.c
>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>> @@ -685,6 +685,20 @@ static void ath10k_core_restart(struct work_struct *work)
>>  {
>>       struct ath10k *ar = container_of(work, struct ath10k, restart_work);
>>
>> +     set_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
>> +     barrier();
>
> Please document why the barrier is needed.

Okay. It's just to make sure compiler doesn't re-order it (so that
following complete/wake_ups will be called _after_ the bit is set).


>> --- a/drivers/net/wireless/ath/ath10k/core.h
>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>> @@ -371,6 +371,11 @@ enum ath10k_dev_flags {
>>       /* Indicates that ath10k device is during CAC phase of DFS */
>>       ATH10K_CAC_RUNNING,
>>       ATH10K_FLAG_CORE_REGISTERED,
>> +
>> +     /* Device has crashed and needs to restart. This indicates any pending
>> +      * waiters should immediately cancel instead of waiting for a time out.
>> +      */
>> +     ATH10K_FLAG_CRASH_FLUSH,
>>  };
>
> Instead of a dev flag, should this actually be a new state to enum
> ath10k_state? The reason I ask, I don't see how we would use this flag
> with other states than with ATH10K_STATE_ON. Or is this needed because
> of locking?

Locking.

Reading/writing ar->state requires conf_mutex. The problem is waitiers
might be holding it so you wouldn't even be able to tell the waiters
to not wait anymore.

A long term idea might involve removing conf_mutex though but I recall
there's a couple of problems with that when I looked at it.


Michał
