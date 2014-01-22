Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39962 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaAVJBH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 04:01:07 -0500
Message-ID: <1390381261.4334.12.camel@jlt4.sipsolutions.net> (sfid-20140122_100112_105782_C9F9F055)
Subject: Re: [PATCH 2/2] mac80211: implement multi-interface CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Date: Wed, 22 Jan 2014 10:01:01 +0100
In-Reply-To: <CA+BoTQ==WJPJV=t8=_CZAD5qyW3igAtaOcUz9hNCcvUPYH+jdA@mail.gmail.com> (sfid-20140122_095414_681765_24CF21EF)
References: <1390228033-19162-1-git-send-email-michal.kazior@tieto.com>
	 <1390228033-19162-3-git-send-email-michal.kazior@tieto.com>
	 <1390318236.6199.45.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ==WJPJV=t8=_CZAD5qyW3igAtaOcUz9hNCcvUPYH+jdA@mail.gmail.com>
	 (sfid-20140122_095414_681765_24CF21EF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 09:54 +0100, Michal Kazior wrote:

> >> A new worker is introduced: csa_complete_work
> >> which is used to account per-interface countdowns
> >> and issue the actual channel switch after last
> >> interface completes its CSA.
> >
> > Not sure I understand this part, don't they all have the same countdown,
> > and should finish at the same time?
> 
> Keep in mind you get cfg80211_csa_settings array for the channel
> switch each having it's own csa beacon count. I can try to refactor
> the code a little bit though.

Can't we just prohibit that though? That seems pretty much useless,
although if the interfaces actually have different beacon intervals (if
such a thing is permitted?) then it would be necessary to do more
difficult calculations ...

> >> +static int ieee80211_ap_beacon_presp_backup(struct ieee80211_sub_if_data *sdata)
> >
> > I'm beginning to think it's time to create a new file
> > net/mac80211/ap.c :-)
> >
> > What's the backup/restore used for anyway?
> 
> Hmm.. Now that I think about it this might not be really worth it. The
> fact is, if you're in CSA it means you don't want to remain on a given
> channel so there's actually little to no point restoring old beacon
> for that channel.
> 
> Can I just bss_conf->enable_beacon=false && notify_bss_info_changed()?
> That would just stop beaconing and avoid TXing on the old channel.

I can't really comment on that. I guess you don't want to stick to the
old channel either way, although if you're doing CSA for a non-radar
reason (e.g. P2P) you might be OK with that? But it seems like a rare
corner case that maybe doesn't need all that much attention?

> Maybe nl80211 should have a csa-completed event (like scan), so it can
> return success/failure/status so userspace can actually take action if
> CSA fails for some reason in mid-way?

Maybe? Not sure what it would do? The error case would be more like this
"oops, AP stopped" event that we've been discussing, no? I still need to
do that ...

> >>       lockdep_assert_held(&local->mtx);
> >> +     lockdep_assert_held(&local->chanctx_mtx);
> >>
> >> -     /* should never be called if not performing a channel switch. */
> >> -     if (WARN_ON(!sdata->vif.csa_active))
> >> -             return -EINVAL;
> >> +     list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> >
> > _rcu doesn't seem right.
> 
> Hmm. Taking iflist_mtx right here is impossible (deadlock). Some
> refactoring would need to be done here so that it is taken before
> chanctx_mtx, but after local->mtx at the same time.

Isn't it under RTNL anyway though?

> > But then again this whole function, iterating interfaces rather than
> > channel contexts etc. is terrible IMHO. This seems to pretty much turn
> > chanctx support upside down, making the channel context structures not
> > be the first-class citizens I think we want them to be.
> 
> chanctx aren't aware what interfaces they are assigned to now.

That's true, so maybe you just need to explain this chandef thing
better? I don't really see the utility (admittedly without actually
checking carefully in the code where you need it)

> > I'd say Luca's approach has more future, as it makes channel context
> > support native. With this, I don't even see how you *could* later add
> > real channel context support. A function like this, that essentially
> > assumes exactly a single chanctx that might be doing CSA and similar
> > seems to make that rather difficult.
> 
> I'm not really aware of Luca's work.

I guess he should post it :)

> >> -     sdata->vif.bss_conf.chandef = *chandef;
> >> -     ctx->conf.def = *chandef;
> >> +     /* multi-channel is not supported, multi-vif is */
> >> +     if (num_chanctx > 1)
> >> +             return NULL;
> >
> > This is essentially the same thing, but written as a chanctx function?
> 
> I'm not following. Same thing as what?

It's rather similar to the chandef function above and I'm not sure I
understand where the differences are needed.

> > In any case, unless I'm missing some bigger picture this seems like a
> > really hacky way to add things, basically ignoring all the channel
> > context work. Since I care more about channel contexts, maybe we should
> > merge support for channel context CSA before we try to do the multi
> > thing.
> 
> This is, I assume, Luca's work you're talking about here again. What's
> the progress on this? Any time estimates?

I think he has patches but they break the non-chanctx case right now...

johannes

