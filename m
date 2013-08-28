Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59191 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3H1NQa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 09:16:30 -0400
Received: by mail-bk0-f46.google.com with SMTP id 6so2127551bkj.5
        for <linux-wireless@vger.kernel.org>; Wed, 28 Aug 2013 06:16:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <877gf6lay7.fsf@kamboji.qca.qualcomm.com>
References: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
	<1377507205-5386-1-git-send-email-michal.kazior@tieto.com>
	<1377507205-5386-5-git-send-email-michal.kazior@tieto.com>
	<87ioyrmx3u.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=ycKd0Z60wHTWHoq7hBz1W2iW+ahjVmc_nFLQmU7-1Bg@mail.gmail.com>
	<877gf6lay7.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 28 Aug 2013 15:16:29 +0200
Message-ID: <CA+BoTQnkMqL+wOm2R_NjPSFFyb8Y0BdA0hUF6KdGgBiBt9hpfQ@mail.gmail.com> (sfid-20130828_151634_173095_7C519CF6)
Subject: Re: [PATCH v2 4/4] ath10k: fix issues on non-preemptible systems
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 August 2013 06:02, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>> There's another solution that I had in mind. Instead of:
>>
>>   for (;;) { dequeue(z); process; }
>>
>> I did:
>>
>>   q = dequeue_all(z); for (;;) { dequeue(q); process; }
>>
>> I.e. move all queued stuff at the worker entry and move it out of the
>> global queue, that can, and will be, having more stuff queued while
>> the worker does its job).
>>
>> This way workers would exit/restart more often, but from what I tested
>> it didn't really solve the problem. Given enough traffic HTC worker
>> responsible for HTT TX gets overwhelmed eventually. You could try
>> limit how many frames a worker can process during one execution, but
>> how do you guess that? This starvation depends on how fast your CPU
>> is.
>
> I think we should come up with better ways to handle this. To have a
> quota (like you mention above) would be one option. Other option would
> be to have multiple queues and some sort of priorisation or fair
> queueing.

Having quota will not help here in any way. You can re-queue a worker
after each single frame and avoid WMI starvation, however you can
still starve the rest of the system (and that can lead to system reset
via watchdog). I'm also unsure about the overhead queueing a work may
have (on a uP system without preemption in might be negligible, but
what about other systems?), so you'd have to guess the quota size or
else you'd get increased latency/overhead and perhaps slower
performance.

I believe cond_resched is a solution, not a workaround. Slow systems
without preemption need this. I wonder how other drivers got around
it? Or perhaps none of the other drivers had to deal with really
insufficient number of CPU cycles versus lots of work.

We could perhaps move workers out of HTC and have a single TX worker
in core.c for both WMI and HTT that would prioritize WMI, before
trying HTT. This could help guarantee that all beacons (which go
through WMI) are sent in a timely fashion in response to SWBA event.
But that won't fix the overall system starvation.


> And most importantly of all, we should minimise the lenght of queue we
> have inside ath10k. I'm worried that we queue way too many packets
> within ath10k right now.

Felix pointed that out quite some time ago. I would agree but I'm
affraid you'll hurt performance if you decrease the queue depth. There
seems to be some kind of latency thing going on (either on host, or on
firmware/hardware, or both combined). I tried decreasing HTT TX ring
buffer from 2048 to 256. In result on AP135 UDP TX got trimmed at
~330mbps max. Stuffing more throughput even left some idle CPU cycles.
If you consider 3x3 devices that are supposed to get you 1.3gbps, then
you apparently need that 2048 depth.


Michał.
