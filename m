Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:44419 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751776AbdJKOGq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 10:06:46 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/3] mac80211: Add TXQ scheduling API
In-Reply-To: <1507711498.1998.18.camel@sipsolutions.net>
References: <20171010140208.1515-1-toke@toke.dk> <1507651555.26041.81.camel@sipsolutions.net> <87fuaq7ubo.fsf@toke.dk> <1507711498.1998.18.camel@sipsolutions.net>
Date: Wed, 11 Oct 2017 16:06:41 +0200
Message-ID: <87tvz5pymm.fsf@toke.dk> (sfid-20171011_160744_727358_62455488)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> Well I was trying to do The Right Thing(tm), obviously ;)
>
> :-)
>
>> The driver_buffered field comes from the previous behaviour of ath9k:
>> It would basically set the station_buffered flag if there was
>> something in the retry queue at the time it goes to sleep. And on
>> wakeup, it will reschedule the txq if it has anything in the retry
>> queue. And, well, it just seemed odd that there was this duplicated
>> logic in the driver and mac80211, if the driver could just signal to
>> mac80211 to reschedule for it...
>
> Ok. I'm not sure what ath9k does, but mac80211 makes a distinction
> between "do I have something buffered" and "does the driver have
> something buffered".
>
> When the station wakes up it's pretty easy, we tell the driver and it
> just has to send its own frames first.
>
> But when we get a PS-Poll/U-APSD it's more complicated, and we have to
> tell the driver "please release N frames you have buffered" or we may
> have to tell it "please allow me to send N frames that I have buffered"
> which is why we need the distinction of whether or not the driver has
> something buffered.
>
> Ultimately, with TXQs, I hope this distinction can go away because the
> driver wouldn't buffer all by itself.

Yes, that would be good. Okay, I'll keep PS buffering the way it works
now.

>> But I guess I was really just getting ahead of myself there; so the
>> right thing to do for now is to keep the old behaviour, and then fix
>> it properly afterwards?
>
> I guess that'd be easier.
>
>> Yes, this makes sense. Each sleep period is pretty short, right? 
>
> Not necessarily.
>
>> I.e., we don't need to deal with interactions between CoDel and the
>> queue being stopped for a long period of time?
>
> I don't know enough about the possible interactions to answer that.
> Sleep periods may be long, though typically if there's traffic for
> stations then they want to retrieve that and will wake up relatively
> soon, but "relatively soon" may still be on the order of hundreds of
> milliseconds (or even seconds) because sometimes clients will only
> listen to DTIM beacons (DTIM period * beacon interval), and e.g. with
> WNM sleep mode it becomes even longer.

Ah. Right. Well, guess we'll have to cross that bridge once we get
there. Not sure what the right thing to do from the point of view of an
AQM in this instance. But at least making sure it doesn't drop the
packet at the head of every queue at wakeup would probably be good.

>> I was envisioning that next_txq() could also make those kinds of
>> decisions (i.e., preempt the normal scheduling algorithm when a
>> "special" TXQ needs to be scheduled immediately). But not sure if
>> that is enough for this case?
>
> Hmm, not sure. We really want this to be scheduled pretty much
> immediately because the other side will be waiting for the frames, and
> if we don't get an answer out quickly it'll have to assume we're
> broken. I don't know what the limit here is for our firmware, but we
> should really get this out as soon as possible in this case.

OK. But presumably it can't preempt packets already pushed to the
hardware, right? So telling the driver to immediately schedule a packet,
and making sure that the txq it gets from next_txq() is the right one
should do the trick? But I guess it's a bit of a roundabout way, which
may not be worth it to avoid an extra callback...

-Toke
