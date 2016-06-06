Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:33363 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbcFFE0B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2016 00:26:01 -0400
Received: by mail-oi0-f50.google.com with SMTP id k23so208784687oih.0
        for <linux-wireless@vger.kernel.org>; Sun, 05 Jun 2016 21:26:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <E1b9kkn-0000h7-00@www.xplot.org>
References: <87fustrpmz.fsf@toke.dk> <E1b9kkn-0000h7-00@www.xplot.org>
From: Dave Taht <dave.taht@gmail.com>
Date: Sun, 5 Jun 2016 21:26:00 -0700
Message-ID: <CAA93jw4bwvzfOVqVAzAYJO1tmrpqEV3-=EjChgWdF-6qRhB+3Q@mail.gmail.com> (sfid-20160606_062624_923281_8EF88C9B)
Subject: Re: [RFC/RFT 2/5] ath9k: use mac80211 intermediate software queues
To: Tim Shepard <shep@alum.mit.edu>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 5, 2016 at 7:59 PM, Tim Shepard <shep@alum.mit.edu> wrote:
>
>
>> > Huh.  I wonder why you did that?  Is it really better to call the
>> > ieee80211_txq a swq and call the ath9k hardware queue a txq?  I
>> > thought doing the renaming made for more readable and much more
>> > maintainable code (where searching for text strings produced much
>> > cleaner results when trying to track down all references).
>>
>> Well, the immediate reason was that at the time I just spent two weeks
>> figuring out how ath9k worked and what the different concepts were, and
>> suddenly they start to mean something different. The txq->hwq renaming
>> would probably make sense in itself, but suddenly the same variable
>> (txq) meant something different, which was quite confusing. So I found
>> it was easier to change your patch to not require the renaming.
>>
>> A secondary reason was to keep the patch delta as small as possible. I'm
>> definitely not the right person to make that call, but I found the
>> global renaming somewhat intrusive.
>>
>
> OK, makes sense.  But you left it called txq in mac80211.   So someone
> reading the mac80211 code and ath9k at the same time (to understand
> the whole stack) winds up with txq meaning different things, including
> in places in ath9k where it has to reference a field in a structure
> defined by mac80211's header files to point to one of its txqs.
>
>> As for the first point, I think it would be easier if you did not call
>> the mac80211 queues 'txq' but something else ('swq' like I did, perhaps;
>> I also considered 'imq' for intermediate queue). This will at least make
>> it clear at a glance that it is something different than 'txq' was
>> previously.
>
> I'm not the one who called them txq.  That was Felix's patch.
> He also wrote the mt76 driver and in that driver txq consistently
> means the mac80211 intermediate queue and not a driver internal queue
> or a hardware queue.  So I was trying to converge ath9k to be more
> like the one and only example I had of a driver that uses the
> intermediate queue.

Well, finding a common and minimally invasive (re)naming scheme would be good.

>
>> > I am grateful to learn that someone has read my patched version of
>> > ath9k at least enough to do this rework. Any comments on the actual
>> > work?
>>
>> Well, it seems to work well enough (haven't noticed the pending_frames
>> issue, but on the other hand I haven't been looking very hard). However,
>> it does fell like somewhat of a temporary solution. Having another
>> intermediate queue in the driver (tid->i_q) and having a side-effect in
>> ath_tid_has_buffered() seems a bit iffy to me. Wouldn't the 'right' way
>> to do it be to have ath_tid_has_buffered() ask the mac layer if it has
>> any frames queued, and then have ath_tx_get_tid_subframe() basically
>> translate straight to a call to ieee80211_tx_dequeue() (taking into
>> account the retry queue)? Not sure if that covers all code paths, but
>> the current approach seems like it has one too many layers of queues?
>>
>> Haven't given the above a lot of thought, but since you asked... :)
>
> Thanks.  I've gotten no other feedback that suggests anyone else has
> read the code.  So I very much appreciate it.

I not only read it but tested it extensively against the ath9k stock,
ath10k stock, ath10k -michal's fqmac 3.5 patches, and your ath9k
patches...

After losing my temper at the impact of channel scans...

( https://plus.google.com/u/0/107942175615993706558/posts/WA915Pt4SRN
), I got told how to get rid of them for testing, and started redoing
the work when I got back from vacation. The reductions in latency
without a decline in throughput were wonderful vs stock in all cases.

The latency reductions at lower rates and speed of response to rate
changes was not what I'd hoped for, but given all the other pieces
flying in loose formation (like the need for an airtime fair scheduler
also), I'm still pretty happy.

http://blog.cerowrt.org/flent/nmfixed/20mbit_not_entirely_convinced_weve_won_completely.svg

http://blog.cerowrt.org/flent/nmfixed/160_vs_80_half_delay.svg

(More plots and data in that directory and in the channel_scan directory.)

At the moment however I plan to pause until cleaner patch sets arrive....

> Yes, I didn't like that side effect either, but (at least for my first
> attempt) wanted to leave the old transmit path working, in particular
> because I couldn't see how to get all the chanctx stuff working right
> without leaving the old driver-internal queues in place.  (I'm not
> even sure what I would have to do to test the driver with
> CONFIG_ATH9K_CHANNEL_CONTEXT turned on.  I did test that it compiles
> without error when CONFIG_ATH9K_CHANNEL_CONTEXT=y before I released my
> v2 patch, and I tried to understand it enough to avoid breaking
> anything.  (My v1 patch broke compilation when
> CONFIG_ATH9K_CHANNEL_CONTEXT=y as some robot notified me after I
> posted it.)
>
> I looked for a way to ask mac80211 if there are any packets left in
> the intermediate queue without dequeueing a packet and I failed to
> find such an interface.

qdisc->peek like function? A bitmap that says these stations have data
outstanding?

>  I guess I should have submitted a patch to
> add that to mac80211.  Or maybe there's a way to refactor the
> aggregation code in ath9k so that it can cleanly work with the
> existing ieee80211_tx_dequeue() without having to add another
> interface to mac80211, but I didn't figure it out.  It would have been
> a bigger patch to ath9k, and require more thinking when reading the
> patch to see if it works (assuming pre-patch ath9k works).
>
> My current approach was an attempt to get it working.  Yes, the code
> looks like it has another layer of queues, but at run time there's
> only one packet at a time on the internal queue that packets wind up
> on from the mac80211 intermediate queue and by putting it on that
> queue it can interface to the same code that pulls from that queue or
> the previously existing queues (which the chanctx code seems to
> require remain around without major surgery).
>
> I thought about first patching ath9k to remove all the chanctx stuff
> just to have a simpler starting point to work on, but I wouldn't
> expect that patch to ever be accepted upstream (assuming that somebody
> somewhere is getting useful stuff from the chanctx stuff).
>
> Again, thanks for looking at this patch.
>
> I'm now working on figuring out the right way to fix my bug in
> the <= v2 patch where I fail to respect the hwq_max_pending
> values on the new transmit path, and I plan to post a v3 patch
> when I get that done.
>
>                         -Tim Shepard
>                          shep@alum.mit.edu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Dave Täht
Let's go make home routers and wifi faster! With better software!
http://blog.cerowrt.org
