Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:18341 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbaCJIGQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 04:06:16 -0400
Message-ID: <1394437040.18265.1.camel@dubbel> (sfid-20140310_090621_519255_D9D520C4)
Subject: Re: [PATCH v6 3/3] mac80211: allow reservation of a running chanctx
From: Luciano Coelho <luciano.coelho@intel.com>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michal Kazior <michal.kazior@tieto.com>, sw@simonwunderlich.de,
	andrei.otcheretianski@intel.com
In-Reply-To: <CAB3XZEe+-sdGfMupP7x0fKHCfevCtZDY7UrF6rRyL3==pnZf5Q@mail.gmail.com>
References: <1394376039-9644-1-git-send-email-luciano.coelho@intel.com>
	 <1394376039-9644-4-git-send-email-luciano.coelho@intel.com>
	 <CAB3XZEe+-sdGfMupP7x0fKHCfevCtZDY7UrF6rRyL3==pnZf5Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Mar 2014 09:37:20 +0200
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-03-09 at 17:13 +0200, Eliad Peller wrote:
> On Sun, Mar 9, 2014 at 4:40 PM, Luciano Coelho <luciano.coelho@intel.com> wrote:
> > With single-channel drivers, we need to be able to change a running
> > chanctx if we want to use chanctx reservation.  Not all drivers may be
> > able to do this, so add a flag that indicates support for it.
> >
> > Changing a running chanctx can also be used as an optimization in
> > multi-channel drivers when the context needs to be reserved for future
> > usage.
> >
> > Introduce IEEE80211_CHANCTX_RESERVED chanctx mode to mark a channel as
> > reserved so nobody else can use it (since we know it's going to
> > change).  In the future, we may allow several vifs to use the same
> > reservation as long as they plan to use the chanctx on the same
> > future channel.
> >
> > Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> > ---
> [...]
> 
> > @@ -177,7 +198,12 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
> >         list_for_each_entry(ctx, &local->chanctx_list, list) {
> >                 const struct cfg80211_chan_def *compat;
> >
> > -               if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE)
> > +               /* We don't support chanctx reservation for multiple
> > +                * vifs yet, so don't allow reserved chanctxs to be
> > +                * reused.
> > +                */
> > +               if ((ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE) ||
> > +                   ieee80211_chanctx_is_reserved(local, ctx))
> >                         continue;
> >
> i'm not sure that's correct.
> you might want to find a chanctx in order to use it, not only for
> reservation. any reason to reject it in this case?

At the moment we don't support multi-vifs switching at the same time, so
we don't allow anyone else to use a chanctx while it's reserved.

--
Luca.

