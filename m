Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:43226 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3IXG7s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 02:59:48 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath10k: replenish HTT RX buffers in a tasklet
References: <1379509691-19904-1-git-send-email-michal.kazior@tieto.com>
	<87r4cebuxm.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=Tg1Qv8qXqw8++hXiDsBXyeQKDjYesWdNg25ORMQJGRg@mail.gmail.com>
Date: Tue, 24 Sep 2013 09:59:38 +0300
In-Reply-To: <CA+BoTQ=Tg1Qv8qXqw8++hXiDsBXyeQKDjYesWdNg25ORMQJGRg@mail.gmail.com>
	(Michal Kazior's message of "Tue, 24 Sep 2013 08:51:59 +0200")
Message-ID: <87eh8ebt7p.fsf@kamboji.qca.qualcomm.com> (sfid-20130924_085951_349723_1E0B222C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 24 September 2013 08:22, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> This fixes system starvation when under heavy RX
>>> traffic. This problem could be observed on AP135
>>> and led to watchdog resetting the platform.
>>>
>>> Patch starves FW RX ring buffer by progressively
>>> replenishing buffers to auto-balance the RX
>>> handled to the host system.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>
>> Looks good to me. I suspect there is a better way to do this in long
>> term, but this looks like a viable short term solution.
>>
>> Does it decrease throughput in a noticeable way?
>
> I have yet to observe any regressions.

Good. If you think the patch should be applied please resend it as
"[PATCH]" so that I can apply it.

-- 
Kalle Valo
