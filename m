Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:58463 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaB1MRY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 07:17:24 -0500
Message-ID: <1393589841.13669.32.camel@dubbel> (sfid-20140228_131733_504191_127F557F)
Subject: Re: [RFC v2 3/4] mac80211: allow reservation of a running chanctx
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Date: Fri, 28 Feb 2014 14:17:21 +0200
In-Reply-To: <CA+BoTQ=yoYAcg8Jo2zoV76gmXe9UU1=wSi1CVWfwiRpqC7yr6w@mail.gmail.com>
References: <1393512081-31453-1-git-send-email-luca@coelho.fi>
	 <1393512081-31453-4-git-send-email-luca@coelho.fi>
	 <CA+BoTQ=yoYAcg8Jo2zoV76gmXe9UU1=wSi1CVWfwiRpqC7yr6w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-27 at 16:29 +0100, Michal Kazior wrote:
> On 27 February 2014 15:41, Luca Coelho <luca@coelho.fi> wrote:
> > From: Luciano Coelho <luciano.coelho@intel.com>
> >
> > With single-channel drivers, we need to be able to change a running
> > chanctx if we want to use chanctx reservation.  Not all drivers may be
> > able to do this, so add a flag that indicates support for it.
> >
> > Changing a running chanctx can also be used as an optimization in
> > multi-channel drivers when the context needs to be reserved for future
> > usage.
> 
> I think this can be generalized (not necessarily in this very patch).
> Since you've moved combination checks into mac80211 you can easily
> check how many channels you can have with current iftype setup. This
> means you can know beforehand if you can create a new chanctx or have
> to attempt a chanctx channel switch.

That's the idea.  I'm keeping both series separate, but when they get
applied, I will use the combinations check for chanctx reservation.


> > Introduce IEEE80211_CHANCTX_RESERVED chanctx mode to mark a channel as
> > reserved so nobody else can use it (since we know it's going to
> > change).  In the future, we may allow several vifs to use the same
> > reservation as long as they plan to use the chanctx on the same
> > future channel.
> 
> I don't really think you need a separate mode for that.
> 
> Since reserved_chanctx is protected by chanctx_mtx you can safely
> iterate over interfaces and check if any vif is reserving the same
> chanctx it is assigned to.

I think it's much simpler to keep this new mode.  Reserved channel
contexts are almost like exclusive contexts (as I was doing in my first
RFC), but not exactly the same, since they can be used for other
reservations.


> > @@ -622,7 +629,9 @@ int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata)
> >         if (WARN_ON(!sdata->reserved_chanctx))
> >                 return -EINVAL;
> >
> > -       if (--sdata->reserved_chanctx->refcount == 0)
> > +       if (sdata->reserved_chanctx->mode == IEEE80211_CHANCTX_RESERVED)
> > +               sdata->reserved_chanctx->mode = sdata->reserved_mode;
> > +       else if (--sdata->reserved_chanctx->refcount == 0)
> >                 ieee80211_free_chanctx(sdata->local, sdata->reserved_chanctx);
> >
> >         sdata->reserved_chanctx = NULL;
> > @@ -652,19 +661,42 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
> >         /* try to find another context with the chandef we want */
> >         new_ctx = ieee80211_find_chanctx(local, chandef,
> >                                          IEEE80211_CHANCTX_SHARED);
> > -       if (!new_ctx) {
> > -               /* create a new context */
> > +       if (new_ctx) {
> > +               /* reserve the existing compatible context */
> > +               sdata->reserved_chanctx = new_ctx;
> > +               new_ctx->refcount++;
> > +       } else if (curr_ctx->refcount == 1 &&
> > +                  (local->hw.flags & IEEE80211_HW_CHANGE_RUNNING_CHANCTX)) {
> > +               /* TODO: when implementing support for multiple
> > +                * interfaces switching at the same time, we may want
> > +                * other vifs to reserve it as well, as long as
> > +                * they're planning to switch to the same channel.  In
> > +                * that case, we probably have to save the future
> > +                * chandef and the reserved_mode in the context
> > +                * itself.
> > +                */
> 
> We already save the future chandef (csa_chandef). reserved_mode is not
> necessary as per my comment above. Again, if you guarantee csa_chandef
> to be set under chanctx_mtx you can safely iterate over interfaces and
> calculate compat chandef.

But the calculated "compat chandef" is not exactly what was required in
the first place.  In sdata->u.bss_conf.chandef we need to have the
chandef we want for *this* vif.  We need this to recalculate the
combined chandef if, for instance, another vif leaves our chanctx.

I think we should keep saving the reserved_chandef in sdata (the one
that was requested when making the reservation) and also save the future
chandef as a compat combination of all the reservations for that
chanctx.

You're right that we already have the future chandef.  I just added it
as "reserved_chandef" in the previous patch. ;) I'll reword this.

Thanks a lot for your reviews and comments!

--
Cheers,
Luca.

