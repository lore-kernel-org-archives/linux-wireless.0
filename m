Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:35075 "EHLO
	mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbcGRWCk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 18:02:40 -0400
Received: by mail-it0-f45.google.com with SMTP id u186so79150453ita.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jul 2016 15:02:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87d1mar50e.fsf@toke.dk>
References: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name>
 <87shvfujl4.fsf@toke.dk> <87d1mar50e.fsf@toke.dk>
From: Dave Taht <dave.taht@gmail.com>
Date: Mon, 18 Jul 2016 15:02:38 -0700
Message-ID: <CAA93jw4JUS=yO4VP0diKzBYXt_4tWoSrFOwgOpPGrauN-47OHw@mail.gmail.com> (sfid-20160719_000243_890471_8DB1FD3F)
Subject: Re: TCP performance regression in mac80211 triggered by the fq code
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: Felix Fietkau <nbd@nbd.name>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just to add another datapoint, the "rack" optimization for tcp entered
the kernel recently. It has some "interesting" timing/batching
sensitive behaviors. While the TSO case is described, the packet
aggregation case seems similar, and is not.

https://www.ietf.org/proceedings/96/slides/slides-96-tcpm-3.pdf


10 Jan 2016

https://kernelnewbies.org/Linux_4.4#head-2583c31a65e6592bef9af426a78940078df7f630

The draft was significantly updated this month.

https://tools.ietf.org/html/draft-cheng-tcpm-rack-01
 -- Andrew Shewmaker

On Mon, Jul 18, 2016 at 2:49 PM, Toke Høiland-Jørgensen <toke@toke.dk> wrote:
> Toke Høiland-Jørgensen <toke@toke.dk> writes:
>
>> Felix Fietkau <nbd@nbd.name> writes:
>>
>>> Hi,
>>>
>>> With Toke's ath9k txq patch I've noticed a pretty nasty performance
>>> regression when running local iperf on an AP (running the txq stuff) to
>>> a wireless client.
>>>
>>> Here's some things that I found:
>>> - when I use only one TCP stream I get around 90-110 Mbit/s
>>> - when running multiple TCP streams, I get only 35-40 Mbit/s total
>>> - fairness between TCP streams looks completely fine
>>> - there's no big queue buildup, the code never actually drops any packets
>>> - if I put a hack in the fq code to force the hash to a constant value
>>> (effectively disabling fq without disabling codel), the problem
>>> disappears and even multiple streams get proper performance.
>>>
>>> Please let me know if you have any ideas.
>>
>> Hmm, I see two TCP streams get about the same aggregate throughput as
>> one, both when started from the AP and when started one hop away.
>
> So while I have still not been able to reproduce the issue you
> described, I have seen something else that is at least puzzling, and may
> or may not be related:
>
> When monitoring the output of /sys/kernel/debug/ieee80211/phy0/aqm I see
> that all stations have their queues empty all the way to zero several
> times per second. This is a bit puzzling; the queue should be kept under
> control, but really shouldn't empty completely. I figure this might also
> be the reason why you're seeing degraded performance...
>
> Since the stats output doesn't include a counter for drops, I haven't
> gotten any further with figuring out if it's CoDel that's being too
> aggressive, or what is happening. But will probably add that in and take
> another look.
>
> -Toke
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Dave Täht
Let's go make home routers and wifi faster! With better software!
http://blog.cerowrt.org
