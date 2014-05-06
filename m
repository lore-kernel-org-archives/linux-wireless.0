Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45502 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849AbaEFOFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2014 10:05:51 -0400
Message-ID: <1399385141.4218.37.camel@jlt4.sipsolutions.net> (sfid-20140506_160554_344639_964BB851)
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>,
	Simon Wunderlich <sw@simonwunderlich.de>
Date: Tue, 06 May 2014 16:05:41 +0200
In-Reply-To: <CA+BoTQk1upg7yGK-QWoz8QhMeRzLBY60Lk=eUN=iQLaF2pUhQQ@mail.gmail.com> (sfid-20140506_144718_658608_A2433FAF)
References: <1397050174-26121-14-git-send-email-michal.kazior@tieto.com>
	 <1398849681-3606-1-git-send-email-michal.kazior@tieto.com>
	 <1399372915.4218.17.camel@jlt4.sipsolutions.net>
	 <CA+BoTQk1upg7yGK-QWoz8QhMeRzLBY60Lk=eUN=iQLaF2pUhQQ@mail.gmail.com>
	 (sfid-20140506_144718_658608_A2433FAF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-05-06 at 14:47 +0200, Michal Kazior wrote:

> > So I finally got around to discussing this with Luca and getting a
> > better understanding of what we have right now and where we're going to
> > this. Unfortunately (for you :) ) I don't think we're quite on the right
> > track between what we have and what you (and others) are doing here and
> > what we'll want.
> 
> Yay! :-)

I'm guessing you're excited I finally looked at it - not that I said it
wasn't what I wanted ;-)

Sorry about that though - I'll try to be better, now that I understand
CSA. It was exactly what I was afraid of, that I'd actually have to go
sit down for a day to understand it first :-)

> So.. is my understanding correct that my patch itself stands with the
> exception of the hunk you cited that would need to be reworked to use
> the new suggested API instead of the unassign/assign trickery?

Yes. The rest of your patch is pretty small though :)

> If I consider non-chanctx drivers we would need to do:
>   if (!local->chanctx) { del_chanctx(); add_chanctx(); } else {
> switch_vif_chanctx(); }

Not sure - we still need to do the right book-keeping inside mac80211 to
remove/add the chanctx around (after) the new driver operation, that
might in itself do enough. Depends on how the code is structured, I
guess. But yeah, something will probably be needed.

> Btw. Do you intend the new switch_vif_chanctx() to take over
> unassign_vif_chanctx() too?

It has to, yeah. There are two cases for the new op - the ones you
called "use_reserved_incompat" and "use_reserved_compat".

For the former, our driver will behave as though you'd called

 unassign_vif_chanctx(vif, old)
 delete_chanctx(old)
 add_chanctx(new)
 assign_vif_chanctx(vif, new)

[though other drivers may behave differently]

For the latter, drivers will behave as though you'd called

 unassign_vif_chanctx(vif, old)
 assign_vif_chanctx(vif, new)

[but depending on how the driver operates it'll be able to do this in a
single atomic step, similar to how mac80211 never goes through NULL in
either of these cases for the vif chanctx pointer]


> > Separately, I think due to the complexities involved in the driver
> > implementation we'll probably need a bitmap indicating which interface
> > types are supported (this is not something we do today, and this would
> > be broken in iwlwifi for sure.)
> 
> Care to elaborate?

It's a separate issue really - but sure: the iwlwifi firmware API will
likely not allow doing such trickery in the IBSS case, so we should have
a bitmap of supported interface types (e.g. BIT(NL80211_IFTYPE_STATION)
| ...) for the channel switch operation.

> > As a result, I'm going to drop this patch, which likely also means your
> > other 5-patch series won't apply?
> 
> Yeah (although it's probably possible to transplant part of the patch
> so the other 5 can apply).

I'll review the others now.

johannes

