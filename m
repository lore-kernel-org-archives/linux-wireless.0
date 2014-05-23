Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:50123 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaEWJG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 05:06:27 -0400
Received: by mail-wi0-f171.google.com with SMTP id cc10so491668wib.4
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 02:06:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87bnuovq6x.fsf@kamboji.qca.qualcomm.com>
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
	<1400143324-14911-1-git-send-email-michal.kazior@tieto.com>
	<1400143324-14911-4-git-send-email-michal.kazior@tieto.com>
	<87oayovr1m.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQmJTsh3Kcwmqx19WAzoBhYrhkQaPT_S=JFVPptkVaaKyw@mail.gmail.com>
	<87bnuovq6x.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 23 May 2014 11:06:25 +0200
Message-ID: <CA+BoTQn_V5zGA18qGMNrWYy_-fBQzBi1=EmzMs=0SLvk1LBVJQ@mail.gmail.com> (sfid-20140523_110633_993738_661A8280)
Subject: Re: [PATCH v2 3/5] ath10k: drain tx before restarting hw
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 May 2014 10:45, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> On 23 May 2014 10:27, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>> Michal Kazior <michal.kazior@tieto.com> writes:
>>>
>>>> +static void ath10k_drain_tx(struct ath10k *ar)
>>>> +{
>>>> +     /* workers can hold conf_mutex -- avoid deadlock */
>>>> +     WARN_ON(lockdep_is_held(&ar->conf_mutex));
>>>
>>> If CONFIG_LOCKDEP is disabled this will fail with:
>>>
>>> drivers/net/wireless/ath/ath10k/mac.c:2301:2: error: implicit declaration of function 'lockdep_is_held' [-Werror=implicit-function-declaration]
>>>
>>> I wasn't able to come up with any other way than adding '#ifdef
>>> CONFIG_LOCKDEP' which is quite ugly. What should we do?
>>
>> I guess we could define lockdep_assert_not_held() in debug.h?
>
> Sure, but I still think it's a bit ugly. The right way to fix this would
> be to add it to include/lockdep.h, instead of adding custom checks to a
> driver.

Good point. I wonder if it's generic enough to justify.


> But does this check even make sense? There's nothing preventing
> to another thread to take lock just after the WARN_ON(), right?

There's nothing wrong with other thread holding it. Actually that's
the reason for this very check.

The point is to prevent ath10k_drain_tx() being called while caller
(current thread) holds conf_mutex. If it were to hold conf_mutex then
cancel_work_sync() can deadlock as both workers it tries to stop try
to get a hold of the lock too.


> Oh, and if we add it to debug.h we should name ath10k_assert_not_held().
> We should not use lockdep's namespace for anything inside ath10k.

Good point.


Michał
