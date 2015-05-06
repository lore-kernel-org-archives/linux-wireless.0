Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57562 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbbEFMuc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2015 08:50:32 -0400
Message-ID: <1430916630.1954.2.camel@sipsolutions.net> (sfid-20150506_145043_862367_3AAA1B67)
Subject: Re: [PATCH v2 5/7] mac80211: Adjust chan_ctx when assigning
 reserved vif
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrei Otcheretianski <andrei.otc@gmail.com>
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Wed, 06 May 2015 14:50:30 +0200
In-Reply-To: <CAKk+41n4qfmxVZrS03=1qas1FmEc4nmVjLEJ9LDuNCw+sVoffQ@mail.gmail.com> (sfid-20150426_101336_836315_A82B3342)
References: <1426143210-25635-5-git-send-email-emmanuel.grumbach@intel.com>
	 <1429606392-7776-1-git-send-email-andrei.otcheretianski@intel.com>
	 <1429872119.1852.39.camel@sipsolutions.net>
	 <CAKk+41n4qfmxVZrS03=1qas1FmEc4nmVjLEJ9LDuNCw+sVoffQ@mail.gmail.com>
	 (sfid-20150426_101336_836315_A82B3342)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-04-26 at 11:13 +0300, Andrei Otcheretianski wrote:

> sdata->reserved_chandef  is passed to
> ieee80211_chanctx_non_reserved_chandef, so it takes the reservation
> into account when the required chandef is recalculated.
> This is what I tried to say here. I'll rephrase to make it more clear.

Ok, thanks.

> > > Not doing so would result in using chanctx with narrower width than actually
> > > required. Fix this by calling ieee80211_change_chanctx with the widest common
> > > chandef. This both changes the chanctx's width and recalcs min_def.
> >
> > This seems possible, yeah.
> >
> >
> > >         chandef = ieee80211_chanctx_non_reserved_chandef(local, new_ctx,
> > >                                 &sdata->reserved_chandef);
> >
> > >       if (WARN_ON(!chandef))
> > >               return -EINVAL;
> > >
> > > +     ieee80211_change_chanctx(local, new_ctx, chandef);
> > > +
> > >       vif_chsw[0].vif = &sdata->vif;
> > >       vif_chsw[0].old_ctx = &old_ctx->conf;
> > >       vif_chsw[0].new_ctx = &new_ctx->conf;
> > [...]
> > >       ieee80211_vif_update_chandef(sdata, &sdata->reserved_chandef);
> >
> > Hmm. (added more context)
> >
> > The code here seems to be wrong though. It shouldn't overwrite
> > reserved_chandef, or it shouldn't call ieee80211_vif_update_chandef()
> > with it, as the vif's bss_conf.chandef should represent what *this* vif
> > wants/needs, while you're now putting there what the *combination*
> > requires in the chandef.
> >
> > That's clearly wrong - please submit a new patch that fixes all the
> > issues in these functions.
> 
> I don't see any issue here.  sdata->reserved_chandef isn't overwritten
> and it is what sdata really needs.

Yes, good point, sorry. I confused the pointer assignments with struct
assignments.

johannes

