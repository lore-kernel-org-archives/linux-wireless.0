Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33736 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab1KKLmz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 06:42:55 -0500
MIME-Version: 1.0
In-Reply-To: <1321009374.2548.31.camel@edumazet-laptop>
References: <1320933501.3967.68.camel@jlt3.sipsolutions.net>
	<CAGXE3d-_RFgW_zwfX2vTBe1psXmgoBFO5pd5cAgtYo=Jwpddhw@mail.gmail.com>
	<7be02f26a67fac4c7448a74f1f17aa01@visp.net.lb>
	<CAA93jw7ECQegWj6rpd48sbmDQUjorCYzXANXJSj0baHtxzC7EA@mail.gmail.com>
	<1321009374.2548.31.camel@edumazet-laptop>
Date: Fri, 11 Nov 2011 12:42:54 +0100
Message-ID: <CAA93jw7n1jYiWrnHOF0Zmzd0cVtadNhPSCpP5YqEdq_Q9opw5A@mail.gmail.com> (sfid-20111111_124305_895090_3FF102E9)
Subject: Re: creating netdev queues on the fly?
From: Dave Taht <dave.taht@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Denys Fedoryshchenko <denys@wbc.net.sa>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andrew McGregor <andrewmcgr@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 11, 2011 at 12:02 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 10 novembre 2011 à 16:25 +0100, Dave Taht a écrit :
>
>
>
>> Two notes:
>>
>> 1) Getting 'time' from the kernel is expensive. And: System time wanders.
>>
>> mac80211 Wifi devices however do export a get_tsf function which could
>> be used as a relative-to-the-queue clock - and we actually don't need
>> accuracy down to the level of get_tsf (25ns)
>>
>
>
> getting 'time' from kernel is not that expensive, depending on
> resolution you need. We are not going to use timestamps from devices !

Wireless keeps track of time via a TSF function.

http://en.wikipedia.org/wiki/Timing_Synchronization_Function_%28TSF%29

TSF wanders forward based on an election process from broadcast beacons,
the presentation below contains animations and the like that describe
how it works

http://www.cse.ohio-state.edu/~lai/788-Au05/2-scalibility.ppt

Further it copes with life in terms of TU. One tu is 1024us.

Now, whether any of that is truly relevant to how to do packet
scheduling well on wireless, is a good question. TU is fairly
fundamental to the minstrel algorithm. It bothers me to have anything
resembling a beat frequency.

>
> If ms resolution is enough (say you want to drop packets if they stay
> more than 100ms in qdisc), jiffies is a single memory read.

The intended properties of the hardware queues are 10 ms VO, 100 ms
VI, and some_sane_number_relative_to_real_bandwidth for BE and BK.

The software queues should make similar assumptions, although for
voice traffic, being able to drop and 'pull forward' the next packet
in a stream should it exceed time in queue would be good, and you
could go with 30 ms in queue with that level of jitter.

>
> If needing us or ns resolution, psched_get_time() uses ktime_get(), and
> is used in CBQ, HTB, HFSC, TBF, so if it was expensive we would have big
> problem right now :)
>
> 2) You need to get a timestamp on entry to the first queue and check
>> against the allowable latency on exit from the last. So to construct a
>> tc chain you'd want a tfifo (timestamp on entry), fifot (check
>> timestamp against limit on dequeue), and for the simplest of
>> applications : tfifot (timestamp on entry, check on exit)
>
> That would be not very practical.
>
> I would see a new Qdisc/Class property, like the rate estimator, that we
> can attach to any Qdisc/Class with a new tc option.
>
> Even without any limit enforcing (might be Random Early Detection by the
> way), it could be used to get a Queue Delay estimation, using EWMA
>
> avqdelay = avqdelay*(1-W) + qdelay*W;
> W = 2^(-ewma_log);
>
> tc [ qdisc | class] add [...] [est 1sec 8sec] [delayest ewma_log ] ..

More elegant to be sure. But for N you kind of need to do ewma between
aggregated transmission groups.

>
> tc -s -d qdisc ...
> qdisc htb 1: root refcnt 2 r2q 10 default 1 direct_packets_stat 0 ver 3.17
>  Sent 3596219 bytes 2567 pkt (dropped 238, overlimits 3797 requeues 0)
>  rate 2557Kbit 215pps backlog 0b 0p requeues 0
>  delay 91ms

I still don't 'get' how we can split out a stream based on a
stationid, toss it in a queue to be further scheduled (my choice would
be QFQ, btw), and then sanely de-schedule a burst of packets for that
destination appropriate for that station's aggregation level and
transmit rate using existing tc methods.

I liked the callback idea discussed earlier for implementing a
'grouper' of this sort.

That said I'm strongly encouraged by the dialog thus far on this thread.

>
>
>
> tc [ qdisc | class] add [...] [est 1sec 8sec] [delaylimit max ] ..
>
> tc -s -d qdisc ...
> qdisc htb 1: root refcnt 2 r2q 10 default 1 direct_packets_stat 0 ver 3.17
>  Sent 3596219 bytes 2567 pkt (dropped 238, overlimits 3797 requeues 0)
>  rate 2557Kbit 215pps backlog 0b 0p requeues 0
>  delay 91ms delaylimit 100ms (dropped 12)

and I assume that you are either making this syntax up or coding
faster than emailing in some tree somewhere...

>
>
>
>



-- 
Dave Täht
SKYPE: davetaht
US Tel: 1-239-829-5608
FR Tel: 0638645374
http://www.bufferbloat.net
