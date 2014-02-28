Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:55585 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaB1Lsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 06:48:45 -0500
Message-ID: <1393588121.13669.22.camel@dubbel> (sfid-20140228_124851_635028_C99C04D1)
Subject: Re: [RFC v2 2/4] mac80211: implement chanctx reservation
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Date: Fri, 28 Feb 2014 13:48:41 +0200
In-Reply-To: <CA+BoTQkKCXvWPMPmFCbhXdfq4k4oOd2iiZwqWcbTu0EOT_0wbg@mail.gmail.com>
References: <1393512081-31453-1-git-send-email-luca@coelho.fi>
	 <1393512081-31453-3-git-send-email-luca@coelho.fi>
	 <CA+BoTQkKCXvWPMPmFCbhXdfq4k4oOd2iiZwqWcbTu0EOT_0wbg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-27 at 16:16 +0100, Michal Kazior wrote:
> On 27 February 2014 15:41, Luca Coelho <luca@coelho.fi> wrote:
> > From: Luciano Coelho <luciano.coelho@intel.com>
> >
> > In order to support channel switch with multiple vifs and multiple
> > contexts, we implement a concept of channel context reservation.  This
> > allows us to reserve a channel context to be used later.
> >
> > The reservation functionality is not tied directly to channel switch
> > and may be used in other situations (eg. reserving a channel context
> > during IBSS join).
> >
> > When reserving the context, the following algorithm is used:
> >
> > 1) try to find an existing context that matches our future chandef and
> >    reserve it if it exists;
> 
> > 2) otherwise, check if we're the only vif in the current context, in
> >    which case we can just change our current context.  To prevent
> >    other vifs from joining this context in the meantime, we mark it as
> >    exclusive.  This is an optimization to avoid using extra contexts
> >    when not necessary and requires the driver to support changing a
> >    context on-the-fly;
> 
> This commit part is out of date (you've moved this into a separate patch).

Good point, I'll fix this part.


> 
> > @@ -611,6 +614,142 @@ int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
> >         return ret;
> >  }
> >
> > +int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata)
> > +{
> > +
> > +       lockdep_assert_held(&sdata->local->chanctx_mtx);
> 
> Empty line :-)

Oops!


> > +       if (sdata->vif.bss_conf.chandef.width != ctx->conf.def.width)
> > +               local_changed |= BSS_CHANGED_BANDWIDTH;
> > +
> > +       sdata->vif.bss_conf.chandef = ctx->conf.def;
> 
> I think you should be simply using sdata->csa_chandef here. What's the
> point of setting the csa_chandef during reservation otherwise?

Yes, this is wrong.


> csa_chandef should probably be renamed to reserved_chandef for consistency.

I don't want to mess with CSA in this patch.  I'll leave the csa_chandef
as it is.  But you're right, I should use the "future" chandef, which
I'll add as reserved_chandef.



> > +       /* unref our reservation before assigning */
> > +       ctx->refcount--;
> > +       sdata->reserved_chanctx = NULL;
> > +       ret = ieee80211_assign_vif_chanctx(sdata, ctx);
> > +       if (ret) {
> > +               /* if assign fails refcount stays the same */
> > +               if (ctx->refcount == 0)
> > +                       ieee80211_free_chanctx(local, ctx);
> > +               goto out;
> > +       }
> > +
> > +       ieee80211_wake_queues_by_reason(&sdata->local->hw,
> > +                                       IEEE80211_MAX_QUEUE_MAP,
> > +                                       IEEE80211_QUEUE_STOP_REASON_CHANCTX);
> 
> If you fail to assign chanctx you don't wake queues back. Is this intended?

This was not intended, it was a mistake. :) I'll fix it.


> > diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> > index 8603dfb..998fbbb 100644
> > --- a/net/mac80211/ieee80211_i.h
> > +++ b/net/mac80211/ieee80211_i.h
> > @@ -756,6 +756,8 @@ struct ieee80211_sub_if_data {
> >         bool csa_radar_required;
> >         struct cfg80211_chan_def csa_chandef;
> >
> > +       struct ieee80211_chanctx *reserved_chanctx;
> > +
> 
> It's a good idea to document this is protected by chanctx_mtx (and not
> wdev.mtx).

Good idea.

--
Luca.

