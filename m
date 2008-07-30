Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:25675 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbYG3NpD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 09:45:03 -0400
Received: by yx-out-2324.google.com with SMTP id 8so3198yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jul 2008 06:45:00 -0700 (PDT)
Message-ID: <1ba2fa240807300645j654a82b4rb813b71681dfab71@mail.gmail.com> (sfid-20080730_154509_779457_776E42CC)
Date: Wed, 30 Jul 2008 16:45:00 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi aggregation info
Cc: Friedrich.Beckmann@infineon.com, linux-wireless@vger.kernel.org,
	j@w1.fi
In-Reply-To: <1217423948.10489.121.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217337819.10489.57.camel@johannes.berg>
	 <1ba2fa240807290643l4192ca62ia4db9966501caf0b@mail.gmail.com>
	 <1217339170.10489.62.camel@johannes.berg>
	 <1ba2fa240807290706h70f89f68xf8fe7e672c0275ad@mail.gmail.com>
	 <1217341293.10489.73.camel@johannes.berg>
	 <1ba2fa240807290855p191eebesb1ecf2314031f688@mail.gmail.com>
	 <1217411631.10489.103.camel@johannes.berg>
	 <8469FC7DDCBE054D9653D8506E1FF0F001F1E7B606@mucse406.eu.infineon.com>
	 <1217423948.10489.121.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 30, 2008 at 4:19 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> from my understanding the reason for hardware aggregation
>> queues is not a different priority level as for the AC queues.
>> But there are two things that make hardware aggregation queues
>> reasonable:
>>
>> a) Packets which are aggregated must be in sequence and they
>> must belong to the same RA/TID. So if you mix packets which
>> belong to that aggregation process with packets which do no
>> not belong to that RA/TID, then you must either break the
>> aggregation process or you must somehow "jump" over the
>> packets to find suitable canditates for aggregation.
>
> Yes, I know this.
>
>> I think a random access to a queue makes it really
>> difficult to handle the hardware queues as it is done
>> today, because today it is assumed that packets are
>> dequeued in the order in that they are enqueued.
>>
>> Therefore it is more likely that you have to break the
>> aggregation process when you find a packet that does not
>> fit to the current aggregation process.
>
> Well other drivers would have to handle the aggregation in software,
> obviously, and only put the packets onto the queue once enough have been
> collected.
>
> I'm fairly do understand what's going on.
>
> How does the hardware make the scheduling decision between the regular
> and a-mpdu queue? If it sends out a bunch of aggregated frames whenever
> there are enough, how is that _not_ unfair to non-agg stations?
>
> The way I would implement it (and I guess atheros/broadcom do) is to
> queue up frames for a station like NAPI does: either for a certain time
> (low traffic, and ampdu will be disabled again) or until the txop window
> is full, and then queue all of them to the right fifo/hw queue. Which,
> in my software design, simply means deferring them a bit inside the
> driver. Or for your driver, sticking them into a separate queue. But if
> they don't come in via the same qdisc, I don't see how it can be fair.
> Please let's get the upper layer considerations before we talk about the
> implementation though. Do you not agree that giving an aggregation flow
> a separate qdisc is unfair within that AC?

I'm think your miss understanding is that HW FIFO != HW QUEUE.
HW FIFO takes gives fairness in level of AC.. HW QUEUE just piles up
packets for HW scheduler.
qdisc should be just provide simple buffering
Tomas
