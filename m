Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:47541 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab3GSLpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jul 2013 07:45:13 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: prevent HTC from being used after stopping
References: <1374129193-3533-1-git-send-email-michal.kazior@tieto.com>
	<1374129193-3533-2-git-send-email-michal.kazior@tieto.com>
	<8761w64xr0.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQkD7U4KY5xq7YhTWz-qFP2f3NuQ=nHDZ2LgYaq+5M3pjg@mail.gmail.com>
Date: Fri, 19 Jul 2013 14:44:55 +0300
In-Reply-To: <CA+BoTQkD7U4KY5xq7YhTWz-qFP2f3NuQ=nHDZ2LgYaq+5M3pjg@mail.gmail.com>
	(Michal Kazior's message of "Fri, 19 Jul 2013 13:08:12 +0200")
Message-ID: <87siza3hag.fsf@kamboji.qca.qualcomm.com> (sfid-20130719_134517_346328_EEB65E2E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 19 July 2013 13:04, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> It was possible to submit new HTC commands
>>> after/while HTC stopped. This led to memory
>>> corruption in some rare cases.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>
>> [...]
>>
>>> @@ -957,7 +955,6 @@ void ath10k_htc_stop(struct ath10k_htc *htc)
>>>       }
>>>
>>>       ath10k_hif_stop(htc->ar);
>>> -     ath10k_htc_reset_endpoint_states(htc);
>>>  }
>>
>> Is this on purpose? I can't fit it to the description.
>
> You're right. I should've mentioned that in the commit message.
>
> This line is simply unnecessary. Do you prefer fixing the commit
> message accordingly or should I post it as a separate patch?

A separate patch, please. Makes it easier to bisect issues later on.

-- 
Kalle Valo
