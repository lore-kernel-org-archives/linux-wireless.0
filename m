Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:33463 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750892AbcIIJvq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 05:51:46 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Felix Fietkau <nbd@nbd.name>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org,
        Michal Kazior <michal.kazior@tieto.com>,
        Dave Taht <dave@taht.net>
Subject: Re: [RFC] mac80211: Dynamically set CoDel parameters per station.
References: <20160908195915.31478-1-toke@toke.dk>
        <2663e4fb-bcdf-a872-f5ab-fac3bb5344c1@nbd.name>
Date: Fri, 09 Sep 2016 11:51:40 +0200
In-Reply-To: <2663e4fb-bcdf-a872-f5ab-fac3bb5344c1@nbd.name> (Felix Fietkau's
        message of "Thu, 8 Sep 2016 22:18:37 +0200")
Message-ID: <87h99ph043.fsf@toke.dk> (sfid-20160909_115150_555949_FD13C1A8)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> On 2016-09-08 21:59, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> CoDel can be too aggressive if a station sends at a very low rate. This
>> gets worse the more stations are present, as each station gets more
>> bursty the longer the round-robin scheduling between stations takes.
>>=20
>> This is an attempt to dynamically adjust CoDel parameters per station.
>> It takes a rather simple approach and uses a simple binary designation
>> of a station as 'slow' if it has expected throughput less than eight
>> Mbps (i.e. the lowest couple of rates). In this case, CoDel is set to be
>> more lenient by adjusting its target to 50 ms and interval to 300 ms.
>> There's a built-in hysteresis so a station cannot flip between slow and
>> fast more than once every two seconds.
>>=20
>> In this version the check is performed every time a packet is enqueued
>> to the intermediate queues; and the overhead of doing this is alleviated
>> a bit by caching the result and by the above-mentioned hysteresis. It
>> can probably be smarter about both when and how to do the scaling, but
>> this seems to alleviate some of the starvation I've seen with very slow
>> stations.
> Since this is not dealing properly with firmware rate control anyway,
> I'd suggest calling the update from rate_control_set_rates in order to
> avoid putting more stuff into the tx hot path.

Yeah, I wasn't expecting that to stay in the TX path, but was not
familiar enough with minstrel to know where a good place would be.
Thanks for the pointer.

> You could add a separate code path to allow firmware rate control
> devices to provide a hint at a convenient point in time.

There's already a get_expected_throughput() driver hook; but no drivers
seem to be using it? But I assume you mean a hook the other way, i.e.
export a function where the driver can tell mac80211 "my expected
throughput changed, please update"?

-Toke
