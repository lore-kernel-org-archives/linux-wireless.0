Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:51678 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727727AbeIJQUO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 12:20:14 -0400
Message-ID: <1536578789.3224.69.camel@sipsolutions.net> (sfid-20180910_132646_173656_BEBE9ED6)
Subject: Re: [PATCH RFC v3 0/4] Move TXQ scheduling into mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Date: Mon, 10 Sep 2018 13:26:29 +0200
In-Reply-To: <878t49lhy8.fsf@toke.dk>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1>
         <1536565926.3224.15.camel@sipsolutions.net> <878t49lhy8.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-09-10 at 13:17 +0200, Toke Høiland-Jørgensen wrote:

> > > - I did not add any locking around next_txq(); the driver is still supposed
> > >   to maintain a lock that prevents two threads from trying to schedule the
> > >   same AC at the same time. This is what drivers already do, so I figured it
> > >   was easier to just keep it that way rather than do it in mac80211.
> > 
> > I'll look at this in the code, but from a maintainer perspective I'm
> > somewhat worried that this will lead to issues that are really the
> > driver's fault, but surface in mac80211. I don't know how easy it
> > would be to catch that.
> 
> Yeah, I get what you mean. The alternative would be to have a
> ieee80211_start_schedule(ac) and ieee80211_end_schedule(ac), which
> basically just takes a lock. 

And I guess start would increment the schedule number, which is now
dependent on first

> Would mean we could get rid of the 'first'
> parameter for next_txq(), so might not be such a bad idea;

Right, that's what I meant.

> and if the
> driver has its own locking the extra locking in mac80211 would just be
> an always-uncontested spinlock, which shouldn't be much overhead, right?

It may still bounce around CPUs if you call this from other places, but
I suspect that wouldn't be the biggest issue. There are a lot of
calculations going on too...

johannes
