Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:33007 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab3H0Hab convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 03:30:31 -0400
Received: by mail-bk0-f54.google.com with SMTP id mz12so1501141bkb.13
        for <linux-wireless@vger.kernel.org>; Tue, 27 Aug 2013 00:30:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ioyrmx3u.fsf@kamboji.qca.qualcomm.com>
References: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
	<1377507205-5386-1-git-send-email-michal.kazior@tieto.com>
	<1377507205-5386-5-git-send-email-michal.kazior@tieto.com>
	<87ioyrmx3u.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 27 Aug 2013 09:30:29 +0200
Message-ID: <CA+BoTQ=ycKd0Z60wHTWHoq7hBz1W2iW+ahjVmc_nFLQmU7-1Bg@mail.gmail.com> (sfid-20130827_093035_063579_CDACC005)
Subject: Re: [PATCH v2 4/4] ath10k: fix issues on non-preemptible systems
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 August 2013 09:06, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Workers may not call into a sleepable function
>> (e.g. mutex_lock). Since ath10k workers can run
>> for a very long time it is necessary to explicitly
>> allow process rescheduling in case there's no
>> preemption.
>>
>> This fixes some issues with system freezes, hangs,
>> watchdogs being triggered, userspace being
>> unresponsive on slow host machines under heavy
>> load.
>
> I consider this more as a workaround as a real fix. Would NAPI be a
> proper fix for issues like this?
>
> NAPI support was removed from mac80211 six months ago, but I guess we
> could try to get it back if we have a good reason:
>
> http://marc.info/?l=linux-wireless&m=136204135907491

Hmm. From what I understand NAPI is used for RX polling. My patch
addresses mainly WMI/HTT TX starvation.

There's another solution that I had in mind. Instead of:

  for (;;) { dequeue(z); process; }

I did:

  q = dequeue_all(z); for (;;) { dequeue(q); process; }

I.e. move all queued stuff at the worker entry and move it out of the
global queue, that can, and will be, having more stuff queued while
the worker does its job).

This way workers would exit/restart more often, but from what I tested
it didn't really solve the problem. Given enough traffic HTC worker
responsible for HTT TX gets overwhelmed eventually. You could try
limit how many frames a worker can process during one execution, but
how do you guess that? This starvation depends on how fast your CPU
is.

Thus I opted for sole cond_resched().


>> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
>> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
>> @@ -1229,6 +1229,10 @@ static void ath10k_htt_rx_work(struct work_struct *work)
>>                       break;
>>
>>               ath10k_htt_rx_process_skb(htt->ar, skb);
>> +
>> +#ifndef CONFIG_PREEMPT
>> +             cond_resched();
>> +#endif
>
> Why the #ifndef? Why should we not call cond_resched() when PREEMPT is
> enabled? Does something negative happen then?

I think it should be okay. I saw the #ifndef thing in b43legacy and
thought it simply makes sense (although it's unsightly).


Michał.
