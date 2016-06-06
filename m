Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:33971 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbcFFR27 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2016 13:28:59 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Tim Shepard <shep@alum.mit.edu>
Cc: linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org
Subject: Re: [RFC/RFT 2/5] ath9k: use mac80211 intermediate software queues
References: <E1b9kkn-0000h7-00@www.xplot.org>
Date: Mon, 06 Jun 2016 19:28:53 +0200
In-Reply-To: <E1b9kkn-0000h7-00@www.xplot.org> (Tim Shepard's message of "Sun,
	05 Jun 2016 22:59:01 -0400")
Message-ID: <87shwqql9m.fsf@toke.dk> (sfid-20160606_192904_114104_0F72C82B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tim Shepard <shep@alum.mit.edu> writes:

> OK, makes sense. But you left it called txq in mac80211. So someone
> reading the mac80211 code and ath9k at the same time (to understand
> the whole stack) winds up with txq meaning different things, including
> in places in ath9k where it has to reference a field in a structure
> defined by mac80211's header files to point to one of its txqs.

Yeah, realise there's a problem here. I was coming at it from the ath9k
side, so to speak, and having the variable txq suddenly be something
else was confusing.
>
>> As for the first point, I think it would be easier if you did not call
>> the mac80211 queues 'txq' but something else ('swq' like I did, perhaps;
>> I also considered 'imq' for intermediate queue). This will at least make
>> it clear at a glance that it is something different than 'txq' was
>> previously.
>
> I'm not the one who called them txq.

I was referring to the variable names, not the struct name. Having
'txq->foo' suddenly be something else is what ticked me off.

> That was Felix's patch. He also wrote the mt76 driver and in that
> driver txq consistently means the mac80211 intermediate queue and not
> a driver internal queue or a hardware queue. So I was trying to
> converge ath9k to be more like the one and only example I had of a
> driver that uses the intermediate queue.

Well, that is certainly an argument for going ahead with the renaming.
Hmm, would posting the renaming as a proper proposed patch explaining
the reasoning be a way to get some feedback on whether this would be a
tractable way forward (and also of keeping the delta against mainline
lower)?

> Thanks. I've gotten no other feedback that suggests anyone else has
> read the code. So I very much appreciate it.

You're very welcome; your patch made it possible for me to get straight
to hacking on the parts that I wanted to, without having to first figure
out how to best interface with the mac80211 stuff. Very helpful :)

> Yes, I didn't like that side effect either, but (at least for my first
> attempt) wanted to leave the old transmit path working, in particular
> because I couldn't see how to get all the chanctx stuff working right
> without leaving the old driver-internal queues in place. (I'm not even
> sure what I would have to do to test the driver with
> CONFIG_ATH9K_CHANNEL_CONTEXT turned on. I did test that it compiles
> without error when CONFIG_ATH9K_CHANNEL_CONTEXT=y before I released my
> v2 patch, and I tried to understand it enough to avoid breaking
> anything. (My v1 patch broke compilation when
> CONFIG_ATH9K_CHANNEL_CONTEXT=y as some robot notified me after I
> posted it.)

Right. Well I have been cheerfully ignoring the chanctx stuff so far.
What does that do?

> I looked for a way to ask mac80211 if there are any packets left in
> the intermediate queue without dequeueing a packet and I failed to
> find such an interface. I guess I should have submitted a patch to add
> that to mac80211. Or maybe there's a way to refactor the aggregation
> code in ath9k so that it can cleanly work with the existing
> ieee80211_tx_dequeue() without having to add another interface to
> mac80211, but I didn't figure it out. It would have been a bigger
> patch to ath9k, and require more thinking when reading the patch to
> see if it works (assuming pre-patch ath9k works).

Well code actually building the aggregates is not the problem, I think.
That just loops on while(ath_tid_has_buffered()) which is pretty
straight forward to turn into a dequeue + checking for NULL. It's the
aggr_{sleep,wakup,resume} that's conditioning txq wakeup on
ath_tid_has_buffered() that's the main problem I guess. What would
happen if that was changed to just unconditionally schedule the tid on
wakeup?

But maybe having an ieee80211_tx_peek() function would be useful in any
case? It seems that there's an internal data structure in mac80211
(struct txq_info) that keeps a byte count for that queue, so exporting
that would be trivial...

> I'm now working on figuring out the right way to fix my bug in the <=
> v2 patch where I fail to respect the hwq_max_pending values on the new
> transmit path, and I plan to post a v3 patch when I get that done.

What's the symptom of this? As I said I haven't noticed anything, but it
might be worth looking out for.

-Toke
