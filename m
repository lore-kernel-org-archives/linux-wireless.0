Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41802 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab1KKLyT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 06:54:19 -0500
Message-ID: <1321012453.2548.37.camel@edumazet-laptop> (sfid-20111111_125431_563183_076EDFC5)
Subject: Re: creating netdev queues on the fly?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dave Taht <dave.taht@gmail.com>
Cc: Denys Fedoryshchenko <denys@wbc.net.sa>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andrew McGregor <andrewmcgr@gmail.com>
Date: Fri, 11 Nov 2011 12:54:13 +0100
In-Reply-To: <CAA93jw7n1jYiWrnHOF0Zmzd0cVtadNhPSCpP5YqEdq_Q9opw5A@mail.gmail.com>
References: <1320933501.3967.68.camel@jlt3.sipsolutions.net>
	 <CAGXE3d-_RFgW_zwfX2vTBe1psXmgoBFO5pd5cAgtYo=Jwpddhw@mail.gmail.com>
	 <7be02f26a67fac4c7448a74f1f17aa01@visp.net.lb>
	 <CAA93jw7ECQegWj6rpd48sbmDQUjorCYzXANXJSj0baHtxzC7EA@mail.gmail.com>
	 <1321009374.2548.31.camel@edumazet-laptop>
	 <CAA93jw7n1jYiWrnHOF0Zmzd0cVtadNhPSCpP5YqEdq_Q9opw5A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le vendredi 11 novembre 2011 à 12:42 +0100, Dave Taht a écrit :

> More elegant to be sure. But for N you kind of need to do ewma between
> aggregated transmission groups.
> 

I speak at Class/Qdisc level. If each transmission group has its own
class [ I believe it should ], it should fit.


> I still don't 'get' how we can split out a stream based on a
> stationid, toss it in a queue to be further scheduled (my choice would
> be QFQ, btw), and then sanely de-schedule a burst of packets for that
> destination appropriate for that station's aggregation level and
> transmit rate using existing tc methods.
> 

Right now its not possible since we dont have a feedback once a packet
is dequeued from qdisc. But it should be doable.

> I liked the callback idea discussed earlier for implementing a
> 'grouper' of this sort.
> 
> That said I'm strongly encouraged by the dialog thus far on this thread.
> 

...

> and I assume that you are either making this syntax up or coding
> faster than emailing in some tree somewhere...
> 

That because I prefer discussing on this before starting coding once
general idea is accepted.

Note this delay idea is not new, it already was mentioned on netdev some
months ago.



