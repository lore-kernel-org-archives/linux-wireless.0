Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:15888 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbYHFWbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 18:31:51 -0400
Received: by rv-out-0506.google.com with SMTP id k40so143094rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 15:31:50 -0700 (PDT)
Message-ID: <1ba2fa240808061531i9b71df5l21475455d8115f3f@mail.gmail.com> (sfid-20080807_003155_208486_E9BB9854)
Date: Thu, 7 Aug 2008 01:31:50 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi aggregation info
Cc: Friedrich.Beckmann@infineon.com, linux-wireless@vger.kernel.org,
	j@w1.fi
In-Reply-To: <1217595279.8621.38.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217431179.10489.134.camel@johannes.berg>
	 <1ba2fa240807300908x5489e3f8g54ff83e7e5912c0b@mail.gmail.com>
	 <1217509511.10489.140.camel@johannes.berg>
	 <1ba2fa240807311114t3e1b4fb3oe6643fbe28f2c2ac@mail.gmail.com>
	 <1217528597.10489.150.camel@johannes.berg>
	 <1ba2fa240807311216u1a45cf22j219046ab357b0910@mail.gmail.com>
	 <1217592554.8621.23.camel@johannes.berg>
	 <1ba2fa240808010540g660cdaa9p1158a27061e3fcd@mail.gmail.com>
	 <1217595279.8621.38.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 1, 2008 at 3:54 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2008-08-01 at 15:40 +0300, Tomas Winkler wrote:
>> > Right. So why are you saying we should have a separate qdisc for it?
>>
>> I need a sw queue for it.
>
> Sure, you need to buffer packets, but that's a whole different beast.

So this is the most important point of this conversation... What do
you call this beast!
What I'm trying to say all the way along I don't need qdisc per se I
need like 80% of it.
So it was already implemented in qdisc so it was utilized.
I'm not aware of anything else that is already implemented but you can
always open my eyes and I'm not trying to be cynical.

>
>> >> The aggregation need to be taken from single stream as
>> >> explained before,
>> >
>> > I think we simply agree on that. Which brings me back to my original
>> > point: to provide fairness within that stream we shouldn't have separate
>> > qdiscs for agg/non-agg parts of the stream.
>>
>> You agree on the fact that it's a seperate stream but you still
>> doesn't want separate queue for it....
>
> Actually, no, I don't think it's a separate stream, I think aggregation
> frames are taken from the AC stream. I thought you meant that.

This is really theoretical question. Wireless has defined 4 AC stream
for simplicity
so you map 2 TIDs out of 8 into 4 AC stream. One possible view
of aggregation you don't map TID into AC stream but run it along to
get more fine grained.
Otherwise why don't we do <AC, RA> but <TID,RA> . Just a possible
view. after all it's mapped back to AC.


>> Not scheduling mean not string to prioritize streams in SW. I guess it means RR.
>
> But that's entirely user dependent if we allow actual qdiscs.

True but there is s always some sane default.

>
>
> If you want to draw up scenarios here, how about this one:
>
> From an AP perspective, assume three streams for the same TID for three
> stations. No aggregation involved. Say they all receive a fixed bitrate
> video stream. Assume you need all the airtime to transmit the three
> video streams when all stations are fairly close. Now one of them is
> further away and is a bit slower than the others. This will lead to
> contention, right? So now, frames will queue up in the AC queue for this
> TID, penalising all three stations. Do you agree so far?

You are looking at the wrong point. All stations got fair amount of
air space according AC and TXOP but then number of bytes that are
transmitted is different. While the slow station will use this time to
transfer packet on low rate with many retries faster station will fill
it with many bytes at high rates.I hope it's clear that fixed rate
video stream is not implies wireless rate.
I believe the upper level in this case will take flow control decision
and release packet pressure on the slow station.

> Now, enter aggregation. The way I think of it (and Jouni seems to agree)
> is that the spec intended for aggregation to be a mechanism to reduce
> the required airtime by making the transmission more efficient with less
> space.
Exactly, but if you don't have mechanism to fill up the TXOP
efficiently such as have packets ready in a separate queue it just
won't fly.

-------
I suggest to start at some more productive point.
So what is important is that we agree on one thing that we need sw
queue/buffer (forget qdisc for now) for aggregation queue and the
question is how to implement it efficiently  and how to resolve
cleanly the lack of requeueing in the new MQ. .
-------
Thanks
Tomas
