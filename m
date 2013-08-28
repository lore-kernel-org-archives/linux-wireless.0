Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5935 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab3H1EC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 00:02:29 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] ath10k: fix issues on non-preemptible systems
References: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
	<1377507205-5386-1-git-send-email-michal.kazior@tieto.com>
	<1377507205-5386-5-git-send-email-michal.kazior@tieto.com>
	<87ioyrmx3u.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=ycKd0Z60wHTWHoq7hBz1W2iW+ahjVmc_nFLQmU7-1Bg@mail.gmail.com>
Date: Wed, 28 Aug 2013 07:02:24 +0300
In-Reply-To: <CA+BoTQ=ycKd0Z60wHTWHoq7hBz1W2iW+ahjVmc_nFLQmU7-1Bg@mail.gmail.com>
	(Michal Kazior's message of "Tue, 27 Aug 2013 09:30:29 +0200")
Message-ID: <877gf6lay7.fsf@kamboji.qca.qualcomm.com> (sfid-20130828_060232_451206_E67797FF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 27 August 2013 09:06, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>
>> I consider this more as a workaround as a real fix. Would NAPI be a
>> proper fix for issues like this?
>>
>> NAPI support was removed from mac80211 six months ago, but I guess we
>> could try to get it back if we have a good reason:
>>
>> http://marc.info/?l=linux-wireless&m=136204135907491
>
> Hmm. From what I understand NAPI is used for RX polling. My patch
> addresses mainly WMI/HTT TX starvation.

I thought I saw something related to NAPI on TX as well, but I can't
find it anymore.

> There's another solution that I had in mind. Instead of:
>
>   for (;;) { dequeue(z); process; }
>
> I did:
>
>   q = dequeue_all(z); for (;;) { dequeue(q); process; }
>
> I.e. move all queued stuff at the worker entry and move it out of the
> global queue, that can, and will be, having more stuff queued while
> the worker does its job).
>
> This way workers would exit/restart more often, but from what I tested
> it didn't really solve the problem. Given enough traffic HTC worker
> responsible for HTT TX gets overwhelmed eventually. You could try
> limit how many frames a worker can process during one execution, but
> how do you guess that? This starvation depends on how fast your CPU
> is.

I think we should come up with better ways to handle this. To have a
quota (like you mention above) would be one option. Other option would
be to have multiple queues and some sort of priorisation or fair
queueing.

And most importantly of all, we should minimise the lenght of queue we
have inside ath10k. I'm worried that we queue way too many packets
within ath10k right now.

> Thus I opted for sole cond_resched().

Yeah, this is a good workaround for the problem. But it would be good to
get bottom of this as well.

>>> +#ifndef CONFIG_PREEMPT
>>> +             cond_resched();
>>> +#endif
>>
>> Why the #ifndef? Why should we not call cond_resched() when PREEMPT is
>> enabled? Does something negative happen then?
>
> I think it should be okay. I saw the #ifndef thing in b43legacy and
> thought it simply makes sense (although it's unsightly).

For various reasons I would prefer to have cond_resched() without the
#ifndef, if possible.

-- 
Kalle Valo
