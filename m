Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39264 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab3H3LiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Aug 2013 07:38:08 -0400
Message-ID: <1377862685.16256.13.camel@jlt4.sipsolutions.net> (sfid-20130830_133812_405713_957E01B9)
Subject: Re: [PATCH] mac80211: implement STA CSA for drivers using channel
 contexts
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 30 Aug 2013 13:38:05 +0200
In-Reply-To: <CA+XVXfecHzDzWi1ayiigiQ-qMiun1DK7kYnbuizjiDEYakPM+w@mail.gmail.com> (sfid-20130825_151434_063942_E9752359)
References: <1376395438-24788-1-git-send-email-arik@wizery.com>
	 <1376568235.14084.12.camel@jlt4.sipsolutions.net>
	 <CA+XVXffREZsiLU_Gs646-akyW9XNcZEmQnQGsp4ihT92hP7LOw@mail.gmail.com>
	 <1376650616.15299.16.camel@jlt4.sipsolutions.net>
	 <CA+XVXfeVtaxqAgWQgSsiMw8uZ6uDmEwba+T8M9-YrUNBwxvshA@mail.gmail.com>
	 <1377266513.14021.37.camel@jlt4.sipsolutions.net>
	 <CA+XVXfecHzDzWi1ayiigiQ-qMiun1DK7kYnbuizjiDEYakPM+w@mail.gmail.com>
	 (sfid-20130825_151434_063942_E9752359)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-08-25 at 16:14 +0300, Arik Nemtsov wrote:

> >> The right thing for chan_switch drivers would be not to call hw_config()..
> >
> > chan_switch? or chanctx?
> 
> both. the hw_config(channel) is meaningless for chanctx drivers. The
> legacy code for op_chan_switch drivers didn't call hw_config() as
> well, assuming they'd already get notified internally by their op.

Right.

> >> The TI driver implements the chan_switch op and uses channel contexts.
> >
> > Huh, ok, that was a combination I didn't think was going to exist, since
> > the chanswitch API doesn't really tell you what channel context etc.
> > OTOH, it does give you the vif so you have the chanctx implicitly.
> 
> Yep, it's good enough. The driver gets the chandef from the vif.

Ok, fair enough.

> >> Note that with the above, the channel_contexts + software chan-switch
> >> drivers will still need the kind of code that I wrote. So it would
> >> just lead to replicated code. Or maybe you meant something else?
> >
> > We have too many possibilities I guess ... I think for MVM I want the
> > disconnect, not the channel context change in software. You're taking
> > that possibility away, hence my suggestion of a new hardware flag for it
> > or so.
> 
> I was thinking it's equivalent to to AP case - currently mac80211 is
> the dictator and simply changes the chandef once the lower drv
> completes the switch.

Yeah but the driver in this case has a choice to not supported it.

> Anyway IMHO the simplest approach to handle all the legacy stuff +
> chanctx it to keep the current patch as is, and add a mac80211 HW flag
> to support it, keeping the deauth option as default.
> That's what I think you're suggesting?

Yeah, that sounds about right.

> >> Also, where would you put csa_active = true (if at all) for a STA
> >> interface? Unlike AP, the trigger here is mac80211 code. So putting it
> >> there seemed appropriate.
> >
> > Yeah, I was really just trying to say that current chanctx drivers need
> > not really expect a chanctx to change channel unless they implement CSA,
> > but that currently means AP-CSA - basically what I just said above with
> > taking away the possibility of doing the deauth instead.
> 
> Let's keep the csa_active as I've used it, and just do a deauth when
> the csa-support HW flag is not given?

Works for me - I wasn't particularly worried about the csa_active
handling per se, but rather what it implied about the calls and driver
support etc.

johannes

