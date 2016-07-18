Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:45722 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbcGRVtc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 17:49:32 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: Re: TCP performance regression in mac80211 triggered by the fq code
References: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name>
	<87shvfujl4.fsf@toke.dk>
Date: Mon, 18 Jul 2016 23:49:21 +0200
In-Reply-To: <87shvfujl4.fsf@toke.dk> ("Toke =?utf-8?Q?H=C3=B8iland-J?=
	=?utf-8?Q?=C3=B8rgensen=22's?= message of
	"Tue, 12 Jul 2016 14:28:07 +0200")
Message-ID: <87d1mar50e.fsf@toke.dk> (sfid-20160718_234936_022756_F11A0021)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Toke Høiland-Jørgensen <toke@toke.dk> writes:

> Felix Fietkau <nbd@nbd.name> writes:
>
>> Hi,
>>
>> With Toke's ath9k txq patch I've noticed a pretty nasty performance
>> regression when running local iperf on an AP (running the txq stuff) to
>> a wireless client.
>>
>> Here's some things that I found:
>> - when I use only one TCP stream I get around 90-110 Mbit/s
>> - when running multiple TCP streams, I get only 35-40 Mbit/s total
>> - fairness between TCP streams looks completely fine
>> - there's no big queue buildup, the code never actually drops any packets
>> - if I put a hack in the fq code to force the hash to a constant value
>> (effectively disabling fq without disabling codel), the problem
>> disappears and even multiple streams get proper performance.
>>
>> Please let me know if you have any ideas.
>
> Hmm, I see two TCP streams get about the same aggregate throughput as
> one, both when started from the AP and when started one hop away.

So while I have still not been able to reproduce the issue you
described, I have seen something else that is at least puzzling, and may
or may not be related:

When monitoring the output of /sys/kernel/debug/ieee80211/phy0/aqm I see
that all stations have their queues empty all the way to zero several
times per second. This is a bit puzzling; the queue should be kept under
control, but really shouldn't empty completely. I figure this might also
be the reason why you're seeing degraded performance...

Since the stats output doesn't include a counter for drops, I haven't
gotten any further with figuring out if it's CoDel that's being too
aggressive, or what is happening. But will probably add that in and take
another look.

-Toke
