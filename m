Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34123 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832Ab1KJRAU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 12:00:20 -0500
Message-ID: <1320944415.10042.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> (sfid-20111110_180027_677301_11CA0FA6)
Subject: Re: creating netdev queues on the fly?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 10 Nov 2011 18:00:15 +0100
In-Reply-To: <1320942369.3967.127.camel@jlt3.sipsolutions.net>
References: <1320933501.3967.68.camel@jlt3.sipsolutions.net>
	 <1320935713.2310.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 (sfid-20111110_153533_082549_9B566EB4) <1320942369.3967.127.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le jeudi 10 novembre 2011 à 17:26 +0100, Johannes Berg a écrit :
> On Thu, 2011-11-10 at 15:35 +0100, Eric Dumazet wrote:
> 
> > > So to get to my question: What if we could create netdev queues on the
> > > fly?
> 
> > In term of qdisc management I believe its a bit complex if we start to
> > dynamically add netdev queues :)
> 
> Yeah I was thinking that would be the problematic part.
> 
> > My first idea would be to extend Qdisc management so that a device can
> > callback qdisc when a frame is finaly delivered / consumed / discarded.
> > 
> > We currently only have qdisc->enqueue() and qdisc->dequeue(), we could
> > add qdisc->deliver_callback(skb)
> > 
> > You keep devices as they are, with a netdevqueue per hardware queue.
> > 
> > Then, using a Qdisc like existing ones, but with a limit of
> > outstanding(given to device but not yet consumed) packets per class.
> > 
> > external tc classifier would deliver a hash/index depending on remote
> > station.
> 
> So basically you'd have a class for each station? Or a class for each
> station/AC? That's a lot of classes rather than queues, are they
> pre-allocated, or does it not matter? Overall that sounds like a good
> approach.

They could be statically allocated in a stochastic fashion (Sorry, SFQ
is one of my favorite qdisc, very light in memory/cpu and yet powerful)

net/sched/sch_sfq.c

Of course, HFSC / DRR are considered more flexible, but eat _much_ more
memory.

http://people.netfilter.org/kaber/shaping

You declare a hash divisor of 1024 to map one station to one class
(Might have hash collision of course...)

Each active slot contains a local queue to one remote station.
Each queue can be pfifo or whatever smart qdisc (sfq, or a more flexible
qdisc)

Then you use a filter to select the appropriate class :

tc filter add dev ${dev} protocol all pref 1 parent $handle handle 1 \
	flow hash keys remote_station divisor 1024



