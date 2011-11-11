Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63547 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab1KKLDE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 06:03:04 -0500
Message-ID: <1321009374.2548.31.camel@edumazet-laptop> (sfid-20111111_120314_702313_BBEDD8E7)
Subject: Re: creating netdev queues on the fly?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dave Taht <dave.taht@gmail.com>
Cc: Denys Fedoryshchenko <denys@wbc.net.sa>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 11 Nov 2011 12:02:54 +0100
In-Reply-To: <CAA93jw7ECQegWj6rpd48sbmDQUjorCYzXANXJSj0baHtxzC7EA@mail.gmail.com>
References: <1320933501.3967.68.camel@jlt3.sipsolutions.net>
	 <CAGXE3d-_RFgW_zwfX2vTBe1psXmgoBFO5pd5cAgtYo=Jwpddhw@mail.gmail.com>
	 <7be02f26a67fac4c7448a74f1f17aa01@visp.net.lb>
	 <CAA93jw7ECQegWj6rpd48sbmDQUjorCYzXANXJSj0baHtxzC7EA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le jeudi 10 novembre 2011 à 16:25 +0100, Dave Taht a écrit :



> Two notes:
> 
> 1) Getting 'time' from the kernel is expensive. And: System time wanders.
> 
> mac80211 Wifi devices however do export a get_tsf function which could
> be used as a relative-to-the-queue clock - and we actually don't need
> accuracy down to the level of get_tsf (25ns)
> 


getting 'time' from kernel is not that expensive, depending on
resolution you need. We are not going to use timestamps from devices !

If ms resolution is enough (say you want to drop packets if they stay
more than 100ms in qdisc), jiffies is a single memory read.

If needing us or ns resolution, psched_get_time() uses ktime_get(), and
is used in CBQ, HTB, HFSC, TBF, so if it was expensive we would have big
problem right now :)

2) You need to get a timestamp on entry to the first queue and check
> against the allowable latency on exit from the last. So to construct a
> tc chain you'd want a tfifo (timestamp on entry), fifot (check
> timestamp against limit on dequeue), and for the simplest of
> applications : tfifot (timestamp on entry, check on exit)

That would be not very practical.

I would see a new Qdisc/Class property, like the rate estimator, that we
can attach to any Qdisc/Class with a new tc option.

Even without any limit enforcing (might be Random Early Detection by the
way), it could be used to get a Queue Delay estimation, using EWMA

avqdelay = avqdelay*(1-W) + qdelay*W;
W = 2^(-ewma_log);

tc [ qdisc | class] add [...] [est 1sec 8sec] [delayest ewma_log ] ..

tc -s -d qdisc ...
qdisc htb 1: root refcnt 2 r2q 10 default 1 direct_packets_stat 0 ver 3.17
 Sent 3596219 bytes 2567 pkt (dropped 238, overlimits 3797 requeues 0) 
 rate 2557Kbit 215pps backlog 0b 0p requeues 0 
 delay 91ms



tc [ qdisc | class] add [...] [est 1sec 8sec] [delaylimit max ] ..

tc -s -d qdisc ...
qdisc htb 1: root refcnt 2 r2q 10 default 1 direct_packets_stat 0 ver 3.17
 Sent 3596219 bytes 2567 pkt (dropped 238, overlimits 3797 requeues 0) 
 rate 2557Kbit 215pps backlog 0b 0p requeues 0 
 delay 91ms delaylimit 100ms (dropped 12)



