Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:38581 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755794AbdJJSEt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 14:04:49 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/3] mac80211: Add TXQ scheduling API
In-Reply-To: <1507651555.26041.81.camel@sipsolutions.net>
References: <20171010140208.1515-1-toke@toke.dk> <1507651555.26041.81.camel@sipsolutions.net>
Date: Tue, 10 Oct 2017 20:04:43 +0200
Message-ID: <87fuaq7ubo.fsf@toke.dk> (sfid-20171010_201523_494445_411C4954)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> In particular, I'm not sure what the right thing to do in regards to
>> PS wakeup is...
>
> Can you explain what you were _trying_ to do?
>
> I don't like calling this "driver_buffered" because that's already a
> term for frames that are buffered in the driver ... :-)

Well I was trying to do The Right Thing(tm), obviously ;)

The driver_buffered field comes from the previous behaviour of ath9k: It
would basically set the station_buffered flag if there was something in
the retry queue at the time it goes to sleep. And on wakeup, it will
reschedule the txq if it has anything in the retry queue. And, well, it
just seemed odd that there was this duplicated logic in the driver and
mac80211, if the driver could just signal to mac80211 to reschedule for
it...

But I guess I was really just getting ahead of myself there; so the
right thing to do for now is to keep the old behaviour, and then fix it
properly afterwards?

> PS is complicated, we basically transmit, in the following order:
>  * filtered frames (tx_filtered)
>  * buffered frames (ps_tx_buf)
>  * regular frames
>
> This is when we _leave_ powersave. When we deliver frames while the
> station is sleeping (PS-Poll or U-APSD), they don't even go through the
> TXQ. They still come from this place, but currently go directly to the
> ->tx() method, which to me is actually pretty weird but that's what it
> is now.
>
> As I think I said in my other thread, we should probably eventually
> just get rid of ps_tx_buf entirely, instead just keeping the frames on
> the TXQ. Then, filtered can just be pushed onto txqi->frags [*], and we
> get rid of having that separately as well.
>
> Then, we've completely solved the wakeup scenario, we just start
> scheduling that TXQ normally again.

Yes, this makes sense. Each sleep period is pretty short, right? I.e.,
we don't need to deal with interactions between CoDel and the queue
being stopped for a long period of time?

> For the deliver-while-sleeping (PS-Poll/U-APSD) scenario, I think the
> driver should still pull frames, after calling something like
> drv_release_buffered_frames(). We want this to be scheduled pretty much
> immediately, so we shouldn't just put the TXQ into the normal rotation,
> but otherwise it should work similarly - except limited to a certain
> number of frames [**].
> In this case the driver probably needs to pull the frames using a
> different function so that we can
>  a) tag the packets properly (more-data, EOSP)
>  b) generate nulldata as EOSP container where needed
> Thus, it seems likely that we'll want a separate function, "pull for PS
> delivery" rather than the normal ieee80211_tx_dequeue().

I was envisioning that next_txq() could also make those kinds of
decisions (i.e., preempt the normal scheduling algorithm when a
"special" TXQ needs to be scheduled immediately). But not sure if that
is enough for this case?

-Toke
