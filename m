Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51162 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbcGFNXw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 09:23:52 -0400
Subject: Re: [PATCH] ath9k: Switch to using mac80211 intermediate software
 queues.
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
	Tim Shepard <shep@alum.mit.edu>
References: <E1bJYSp-0001M8-00@www.xplot.org> <87lh1hnvn6.fsf@toke.dk>
Cc: linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <2c4c9821-fea6-fc95-f6a3-cf95e703cce6@nbd.name> (sfid-20160706_152356_300414_6BCEA665)
Date: Wed, 6 Jul 2016 15:23:49 +0200
MIME-Version: 1.0
In-Reply-To: <87lh1hnvn6.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-07-04 19:46, Toke Høiland-Jørgensen wrote:
> Tim Shepard <shep@alum.mit.edu> writes:
> 
>> Thanks for unconfusing me a couple weeks ago, and cluing me into how
>> the limit on ->pending_frames is not really relevant for the data
>> packets that go through the new intermediate queues.
>>
>> But I'm not sure if this would allow us to remove the limit on
>> pending_frames because even though normal data packets would not
>> normally build up that many packets, there are other packet types
>> which bypass the intermediate queues and are transmitted directly
>> (also in most cases bypassing the ath9k internal queues in the way
>> ath9k worked before we patched it to use the mac80211 intermediate
>> queues).
> 
> Yes, but, well, since they're not queued they are not going to overflow
> anything. The aggregation building logic stops at two queued aggregates,
> so the default limit of 123 packets is never going to be hit when the
> queue is moved into the mac80211 layer. So keeping the knobs around only
> helps people who purposefully want to cripple their ability to do
> aggregation; and it won't be doing what it promises (limiting qlen),
> since that is now moved out of the driver. So IMO, removing the knobs is
> the right thing to do. I have already updated my patch to do so, which
> I'll send as a v2 once the other bits are resolved.
I agree.

>> Earlier Felix said:
>>
>>> Channel context based queue handling can be dealt with by
>>> stopping/starting relevant queues on channel context changes.
>>
>> But I don't see how to handle the case here where packets get passed
>> to the driver with ath_tx_start() and wind up in the scenario above.
> 
> Well, presumably the upper layers won't try to transmit anything through
> the old TX path if the start/stop logic is implemented properly. The
> chanctx code already seems to call the ieee80211_{start,stop}_queue()
> functions when changing context, so not sure what else is needed. Guess
> I'll go see if I can provoke an actual triggering of the bug, unless
> Felix elaborates on what he means before I get around to it (poke,
> Felix? :)).
Then I guess the logic in ath_tx_start was a leftover from a time before
some queue related rework happened to the chanctx code.
In that case you can simply remove the chanctx related software queueing
stuff from ath_tx_start.

- Felix
