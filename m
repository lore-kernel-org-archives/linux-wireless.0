Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9875 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaEWIpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 04:45:32 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] ath10k: drain tx before restarting hw
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
	<1400143324-14911-1-git-send-email-michal.kazior@tieto.com>
	<1400143324-14911-4-git-send-email-michal.kazior@tieto.com>
	<87oayovr1m.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQmJTsh3Kcwmqx19WAzoBhYrhkQaPT_S=JFVPptkVaaKyw@mail.gmail.com>
Date: Fri, 23 May 2014 11:45:26 +0300
In-Reply-To: <CA+BoTQmJTsh3Kcwmqx19WAzoBhYrhkQaPT_S=JFVPptkVaaKyw@mail.gmail.com>
	(Michal Kazior's message of "Fri, 23 May 2014 10:38:20 +0200")
Message-ID: <87bnuovq6x.fsf@kamboji.qca.qualcomm.com> (sfid-20140523_104544_156634_B9A6FB59)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 23 May 2014 10:27, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> +static void ath10k_drain_tx(struct ath10k *ar)
>>> +{
>>> +     /* workers can hold conf_mutex -- avoid deadlock */
>>> +     WARN_ON(lockdep_is_held(&ar->conf_mutex));
>>
>> If CONFIG_LOCKDEP is disabled this will fail with:
>>
>> drivers/net/wireless/ath/ath10k/mac.c:2301:2: error: implicit declaration of function 'lockdep_is_held' [-Werror=implicit-function-declaration]
>>
>> I wasn't able to come up with any other way than adding '#ifdef
>> CONFIG_LOCKDEP' which is quite ugly. What should we do?
>
> I guess we could define lockdep_assert_not_held() in debug.h?

Sure, but I still think it's a bit ugly. The right way to fix this would
be to add it to include/lockdep.h, instead of adding custom checks to a
driver. But does this check even make sense? There's nothing preventing
to another thread to take lock just after the WARN_ON(), right?

Oh, and if we add it to debug.h we should name ath10k_assert_not_held().
We should not use lockdep's namespace for anything inside ath10k.

-- 
Kalle Valo
