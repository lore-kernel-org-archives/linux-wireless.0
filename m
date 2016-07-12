Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:46235 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbcGLM2O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2016 08:28:14 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: Re: TCP performance regression in mac80211 triggered by the fq code
References: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name>
Date: Tue, 12 Jul 2016 14:28:07 +0200
In-Reply-To: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name> (Felix Fietkau's
	message of "Tue, 12 Jul 2016 12:09:24 +0200")
Message-ID: <87shvfujl4.fsf@toke.dk> (sfid-20160712_142818_031004_CF729438)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> Hi,
>
> With Toke's ath9k txq patch I've noticed a pretty nasty performance
> regression when running local iperf on an AP (running the txq stuff) to
> a wireless client.
>
> Here's some things that I found:
> - when I use only one TCP stream I get around 90-110 Mbit/s
> - when running multiple TCP streams, I get only 35-40 Mbit/s total
> - fairness between TCP streams looks completely fine
> - there's no big queue buildup, the code never actually drops any packets
> - if I put a hack in the fq code to force the hash to a constant value
> (effectively disabling fq without disabling codel), the problem
> disappears and even multiple streams get proper performance.
>
> Please let me know if you have any ideas.

Hmm, I see two TCP streams get about the same aggregate throughput as
one, both when started from the AP and when started one hop away.
However, do see TCP flows take a while to ramp up when started from the
AP - a short test gets ~70Mbps when run from one hop away and ~50Mbps
when run from the AP. how long are you running the tests for?

(I seem to recall the ramp-up issue to be there pre-patch as well,
though).

As for why this would happen... There could be a bug in the dequeue code
somewhere, but since you get better performance from sticking everything
into one queue, my best guess would be that the client is choking on the
interleaved packets? I.e. expending more CPU when it can't stick
subsequent packets into the same TCP flow?

-Toke
