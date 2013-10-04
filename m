Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:53238 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab3JDGh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 02:37:27 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: fix scheduling while atomic bug
References: <1380292567-2363-1-git-send-email-michal.kazior@tieto.com>
	<1380292567-2363-3-git-send-email-michal.kazior@tieto.com>
	<8761th6ja6.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQnjG9MnbPsLM-RtAwuGNp_ZAfbvwvR_zg1Ks0ZmUxAtrQ@mail.gmail.com>
Date: Fri, 4 Oct 2013 09:37:18 +0300
In-Reply-To: <CA+BoTQnjG9MnbPsLM-RtAwuGNp_ZAfbvwvR_zg1Ks0ZmUxAtrQ@mail.gmail.com>
	(Michal Kazior's message of "Wed, 2 Oct 2013 07:35:37 +0200")
Message-ID: <871u41y21t.fsf@kamboji.qca.qualcomm.com> (sfid-20131004_083736_851996_B6C1FDB9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 1 October 2013 18:35, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> Recent WMI/HTC changes broke WEP with multiple
>>> keys. If WMI had no HTC TX credits to submit
>>> command for default wep index update it would
>>> trigger a bug.
>>>
>>> This simply moves the wep key index update to a
>>> worker.
>>>
>>> The key update may happen some time after first
>>> frame with a different wep key has been sent (i.e.
>>> some frames will be sent with old key). This was
>>> the case before too as WMI commands were
>>> asynchronous.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>
>> This looks problematic. Basically you just delay sending the WMI
>> command, but there's no guarantee that we actually have free credits at
>> the time of transmission. So to me it looks like this fixes the issue
>> just by luck.
>
> One thing at a time.
>
> This patch fixes 'scheduling while atomic' bug that was introduced
> with recent HTC/WMI changes.

Ah, that's what you mean with "triggers a bug" in the commit log? Ok,
even though I consider this very ugly I guess it's alright as a short
term fix. But please describe the bug in more detail in the commit log,
at least mention that we are sleeping in an atomic context (or something
like that).


-- 
Kalle Valo
