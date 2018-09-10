Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:51574 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727269AbeIJQQj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 12:16:39 -0400
Message-ID: <1536578574.3224.65.camel@sipsolutions.net> (sfid-20180910_132337_641806_FD9452ED)
Subject: Re: [PATCH RFC v3 2/4] mac80211: Add airtime accounting and
 scheduling to TXQs
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Date: Mon, 10 Sep 2018 13:22:54 +0200
In-Reply-To: <87h8ixli4s.fsf@toke.dk>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1>
         <153635897061.14170.17999956909203163571.stgit@alrua-x1>
         <1536567496.3224.36.camel@sipsolutions.net> <87h8ixli4s.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-09-10 at 13:13 +0200, Toke Høiland-Jørgensen wrote:
> 
> Yeah, this is the API that would be used by drivers where the actual
> scheduling of TXQs is done by the hardware (i.e., ath10k in pull/push
> mode, and iwlwifi if I understand you correctly); whereas the next_txq()
> call is for drivers that do the scheduling in software (ath10k without
> pull/push, ath9k and mt76).
> 
> Basically, the way I envision this is the drivers doing something like:
> 
> function on_hw_notify(hw, txq) {
>   if (ieee80211_airtime_may_transmit(txq)) {
>      while (hw_has_space() && (pkt = ieee80211_tx_dequeue(hw, txq)))
>          push_to_hw(pkt);
> 
>      ieee80211_schedule_txq(txq);
>   }
> }

Right, we could do that in iwlwifi.

> > > +static bool ieee80211_txq_check_deficit(struct ieee80211_local *local,
> > > +					struct txq_info *txqi)
> > 
> > Maybe this should be called "has_deficit" or so - the polarity isn't
> > immediately clear to me.
> 
> Yup, I suck at naming; gotcha ;)

Common problem :-)

> The move to the end for check_deficit() is what replenishes the airtime
> deficit and ensures fairness. 

Ok, yeah, I guess I was reading mostly the first part ("does this have a
deficit") vs. the action on it.

> So that can loop several times in a single
> call to the function. 

That I don't understand, check_deficit() doesn't contain any loops? The
caller might, via "goto begin", but not sure what you're saying.

> The schedule_round counter is there to prevent the
> driver from looping indefinitely when doing `while (txq =
> ieee80211_next_txq())`. We'd generally want the deficit replenish to
> happen in any case; previously, the schedule_round type check was in the
> driver; moving it here is an attempt at simplifying the logic needed in
> the driver when using the API.

Right.

Anyway, maybe the naming should be different than "has_deficit" since
that would seem to imply some sort of "checker function" only.

Maybe the most readable thing would be to have an enum return value,
then the function name matters less.

> > Manipulating the list twice like this here seems slightly odd ...
> > perhaps move the list manipulation out of txq_check_deficit() entirely?
> > Clearly it's logically fine, but seems harder than necessary to
> > understand.
> > 
> > Also, if the check_deficit() function just returns a value, the renaming
> > I suggested is easier to accept :)
> 
> Yeah, maybe; it'll result in some duplication between next_txq() and
> txq_may_transmit() (to the point where I'm not sure if the separate
> check_deficit() function is really needed anymore), but it may be that
> that is actually easier to understand?

Well to be honest ... I hadn't even fully read check_deficit(), but the
naming didn't make it very clear what the contract between it and the
caller is. That's all I'm saying. As long as we clear up that contract a
bit, everything is fine with me.

What you're saying is that has_deficit() doesn't really work since it
actually does something in a few rounds there.

I guess I also got thrown off by "check" since that (to me) implies it's
just checked. Perhaps "adjust_deficit" would be better, and then you
could reverse polarity so that returning true indicates that something
was modified?

johannes
