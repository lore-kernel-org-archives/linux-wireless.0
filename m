Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41824 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbcGLNXi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2016 09:23:38 -0400
Subject: Re: TCP performance regression in mac80211 triggered by the fq code
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
References: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name>
 <87shvfujl4.fsf@toke.dk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <4e942a0d-8a6a-e52d-c5c3-5ee4a54d59ae@nbd.name> (sfid-20160712_152342_230392_9EF5C670)
Date: Tue, 12 Jul 2016 15:23:36 +0200
MIME-Version: 1.0
In-Reply-To: <87shvfujl4.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-07-12 14:28, Toke Høiland-Jørgensen wrote:
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
> However, do see TCP flows take a while to ramp up when started from the
> AP - a short test gets ~70Mbps when run from one hop away and ~50Mbps
> when run from the AP. how long are you running the tests for?
Long enough to see that it's not ramping up.

> (I seem to recall the ramp-up issue to be there pre-patch as well,
> though).
> 
> As for why this would happen... There could be a bug in the dequeue code
> somewhere, but since you get better performance from sticking everything
> into one queue, my best guess would be that the client is choking on the
> interleaved packets? I.e. expending more CPU when it can't stick
> subsequent packets into the same TCP flow?
Could be. I'll see what the tests show when I push traffic through the
AP instead of from the AP.

- Felix

