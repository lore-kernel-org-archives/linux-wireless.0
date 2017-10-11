Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:45094 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756899AbdJKIpF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 04:45:05 -0400
Message-ID: <1507711498.1998.18.camel@sipsolutions.net> (sfid-20171011_104519_784439_FFD77093)
Subject: Re: [RFC 1/3] mac80211: Add TXQ scheduling API
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Wed, 11 Oct 2017 10:44:58 +0200
In-Reply-To: <87fuaq7ubo.fsf@toke.dk>
References: <20171010140208.1515-1-toke@toke.dk>
         <1507651555.26041.81.camel@sipsolutions.net> <87fuaq7ubo.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Well I was trying to do The Right Thing(tm), obviously ;)

:-)

> The driver_buffered field comes from the previous behaviour of ath9k:
> It would basically set the station_buffered flag if there was
> something in the retry queue at the time it goes to sleep. And on
> wakeup, it will reschedule the txq if it has anything in the retry
> queue. And, well, it just seemed odd that there was this duplicated
> logic in the driver and mac80211, if the driver could just signal to
> mac80211 to reschedule for it...

Ok. I'm not sure what ath9k does, but mac80211 makes a distinction
between "do I have something buffered" and "does the driver have
something buffered".

When the station wakes up it's pretty easy, we tell the driver and it
just has to send its own frames first.

But when we get a PS-Poll/U-APSD it's more complicated, and we have to
tell the driver "please release N frames you have buffered" or we may
have to tell it "please allow me to send N frames that I have buffered"
which is why we need the distinction of whether or not the driver has
something buffered.

Ultimately, with TXQs, I hope this distinction can go away because the
driver wouldn't buffer all by itself.

> But I guess I was really just getting ahead of myself there; so the
> right thing to do for now is to keep the old behaviour, and then fix
> it properly afterwards?

I guess that'd be easier.

> Yes, this makes sense. Each sleep period is pretty short, right? 

Not necessarily.

> I.e., we don't need to deal with interactions between CoDel and the
> queue being stopped for a long period of time?

I don't know enough about the possible interactions to answer that.
Sleep periods may be long, though typically if there's traffic for
stations then they want to retrieve that and will wake up relatively
soon, but "relatively soon" may still be on the order of hundreds of
milliseconds (or even seconds) because sometimes clients will only
listen to DTIM beacons (DTIM period * beacon interval), and e.g. with
WNM sleep mode it becomes even longer.

> > For the deliver-while-sleeping (PS-Poll/U-APSD) scenario, I think
> > the
> > driver should still pull frames, after calling something like
> > drv_release_buffered_frames(). We want this to be scheduled pretty
> > much
> > immediately, so we shouldn't just put the TXQ into the normal
> > rotation,
> > but otherwise it should work similarly - except limited to a
> > certain
> > number of frames [**].
> > In this case the driver probably needs to pull the frames using a
> > different function so that we can
> >  a) tag the packets properly (more-data, EOSP)
> >  b) generate nulldata as EOSP container where needed
> > Thus, it seems likely that we'll want a separate function, "pull
> > for PS
> > delivery" rather than the normal ieee80211_tx_dequeue().
> 
> I was envisioning that next_txq() could also make those kinds of
> decisions (i.e., preempt the normal scheduling algorithm when a
> "special" TXQ needs to be scheduled immediately). But not sure if
> that is enough for this case?

Hmm, not sure. We really want this to be scheduled pretty much
immediately because the other side will be waiting for the frames, and
if we don't get an answer out quickly it'll have to assume we're
broken. I don't know what the limit here is for our firmware, but we
should really get this out as soon as possible in this case.

johannes
