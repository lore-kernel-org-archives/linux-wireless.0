Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:38463 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaEZJTj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 05:19:39 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Avery Pennarun <apenwarr@gmail.com>
Subject: Re: [PATCH 2/3] ath10k: revert incomplete scatter-gather pci tx
References: <1400158139-13836-1-git-send-email-michal.kazior@tieto.com>
	<1400158139-13836-3-git-send-email-michal.kazior@tieto.com>
	<87fvjytht6.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQkfZbzy62xZV0tcPw1xu8B-rioVVags3z+DJMGxMB-jFQ@mail.gmail.com>
Date: Mon, 26 May 2014 12:19:31 +0300
In-Reply-To: <CA+BoTQkfZbzy62xZV0tcPw1xu8B-rioVVags3z+DJMGxMB-jFQ@mail.gmail.com>
	(Michal Kazior's message of "Mon, 26 May 2014 07:37:13 +0200")
Message-ID: <877g58ucbg.fsf@kamboji.qca.qualcomm.com> (sfid-20140526_111943_194516_3831A830)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 25 May 2014 09:53, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> This prevents leaving incomplete scatter-gather
>>> transfer on CE rings which can lead firmware to
>>> crash.
>>>
>>> Reported-By: Avery Pennarun <apenwarr@gmail.com>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>
>> The title is a bit misleading as usually the commit log with the word
>> revert means that the commit is reverting another git commit. Maybe
>> something like this is better:
>>
>> ath10k: drop incomplete scatter-gather pci tx transfers
>
> Good point. I was actually thinking 'abort' .. 'properly'.

Sounds good to me.

>>> +err:
>>> +     for (; i > 0; i--)
>>
>> Isn't this just a fancy way to say 'while (i-- > 0)'?
>
> Not really. More like do { .. } while (--i > 0), no? First iteration
> must use unmodified `i`.

Ok, I missed that. Then the for loop is good here.

-- 
Kalle Valo
