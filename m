Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39211 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab3HWOB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 10:01:57 -0400
Message-ID: <1377266513.14021.37.camel@jlt4.sipsolutions.net> (sfid-20130823_160200_256654_BB9E536A)
Subject: Re: [PATCH] mac80211: implement STA CSA for drivers using channel
 contexts
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 23 Aug 2013 16:01:53 +0200
In-Reply-To: <CA+XVXfeVtaxqAgWQgSsiMw8uZ6uDmEwba+T8M9-YrUNBwxvshA@mail.gmail.com> (sfid-20130816_220955_402953_03B9C8BB)
References: <1376395438-24788-1-git-send-email-arik@wizery.com>
	 <1376568235.14084.12.camel@jlt4.sipsolutions.net>
	 <CA+XVXffREZsiLU_Gs646-akyW9XNcZEmQnQGsp4ihT92hP7LOw@mail.gmail.com>
	 <1376650616.15299.16.camel@jlt4.sipsolutions.net>
	 <CA+XVXfeVtaxqAgWQgSsiMw8uZ6uDmEwba+T8M9-YrUNBwxvshA@mail.gmail.com>
	 (sfid-20130816_220955_402953_03B9C8BB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-16 at 23:09 +0300, Arik Nemtsov wrote:

> > Well, it can't. If you look carefully then the old chan_switch op
> > behaviour is to let the driver switch, not switch in software
> > afterwards.
> 
> The right thing for chan_switch drivers would be not to call hw_config()..

chan_switch? or chanctx?

> > Yeah but it's (currently) meant for interfaces controlling the CSA (i.e.
> > AP only right now) ... so I really think we need to make this
> > controllable, I think that when we want to implement it for Intel MVM
> > firmware then we'll let the firmware control the switch timing, etc.
> > None of this can even be done today or with your patch.
> 
> The TI driver implements the chan_switch op and uses channel contexts.

Huh, ok, that was a combination I didn't think was going to exist, since
the chanswitch API doesn't really tell you what channel context etc.
OTOH, it does give you the vif so you have the chanctx implicitly.

> If I catch your drift you would rather these kind of drivers (which
> include MVM) use a new API exposed by mac80211 to complete the channel
> switch. This API would basically be ieee80211_vif_change_channel(). Do
> we still need to touch the cfg80211 chandef definition in ifmgd?

That's what I was thinking, yes.

> The above is maybe cleaner, but it's functionally equivalent to the
> solution today - the low level driver decides when the channel switch
> is completed, and ieee80211_chswitch_work() is called, which does the
> right thing for all cases.

Right ... I guess that works.

> Note that with the above, the channel_contexts + software chan-switch
> drivers will still need the kind of code that I wrote. So it would
> just lead to replicated code. Or maybe you meant something else?

We have too many possibilities I guess ... I think for MVM I want the
disconnect, not the channel context change in software. You're taking
that possibility away, hence my suggestion of a new hardware flag for it
or so.

> Also, where would you put csa_active = true (if at all) for a STA
> interface? Unlike AP, the trigger here is mac80211 code. So putting it
> there seemed appropriate.

Yeah, I was really just trying to say that current chanctx drivers need
not really expect a chanctx to change channel unless they implement CSA,
but that currently means AP-CSA - basically what I just said above with
taking away the possibility of doing the deauth instead.

johannes

