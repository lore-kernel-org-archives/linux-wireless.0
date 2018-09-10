Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:51286 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727674AbeIJQGN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 12:06:13 -0400
Message-ID: <1536577952.3224.58.camel@sipsolutions.net> (sfid-20180910_131244_687464_56B13903)
Subject: Re: [PATCH RFC v3 1/4] mac80211: Add TXQ scheduling API
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Date: Mon, 10 Sep 2018 13:12:32 +0200
In-Reply-To: <87k1ntlinf.fsf@toke.dk>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1>
         <153635897010.14170.2992498632345986102.stgit@alrua-x1>
         <1536566666.3224.24.camel@sipsolutions.net> <87k1ntlinf.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-09-10 at 13:02 +0200, Toke Høiland-Jørgensen wrote:
> 
> > Is there a case where it's allowed to call this while *not* empty? At
> > least for the drivers it seems not, so perhaps when called from the
> > driver it should WARN() here or so?
> 
> Yeah, mac80211 calls this on wake_txq, where it will often be scheduled
> already. And since that can happen while drivers schedule stuff, it
> could also be the case that a driver re-schedules a queue that is
> already scheduled.

Right, I kinda gathered that but was thinking more from a driver POV as
I was reviewing, makes sense.

> > I'm just a bit worried that drivers will get this a bit wrong, and
> > we'll never know, but things won't work properly in some weird way.
> 
> What, subtle bugs in the data path that causes hangs in hard-to-debug
> cases? Nah, that never happens ;)

Good :-P

Actually though, we can't put a warn on there, because the driver might
take a txq, then mac80211 puts it on the list due to a new packet, and
then the driver also returns it.


> > > +	txqi = list_first_entry(&local->active_txqs[ac],
> > > +				struct txq_info,
> > > +				schedule_order);
> > > +
> > > +	if (txqi->schedule_round == local->schedule_round[ac])
> > > +		txqi = NULL;
> > 
> > that assigment seems unnecessary? txqi defaults to NULL.
> 
> No, this is an 'undo' of the previous line. I.e., we get the first txqi,
> check if we've already seen it this round, and if we have, unset txqi so
> the function returns NULL (causing the driver to stop looping).

Err, yeah, obviously.

johannes
