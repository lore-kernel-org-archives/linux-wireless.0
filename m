Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:34572 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbbDZINg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Apr 2015 04:13:36 -0400
Received: by iget9 with SMTP id t9so51855444ige.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Apr 2015 01:13:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1429872119.1852.39.camel@sipsolutions.net>
References: <1426143210-25635-5-git-send-email-emmanuel.grumbach@intel.com>
	<1429606392-7776-1-git-send-email-andrei.otcheretianski@intel.com>
	<1429872119.1852.39.camel@sipsolutions.net>
Date: Sun, 26 Apr 2015 11:13:35 +0300
Message-ID: <CAKk+41n4qfmxVZrS03=1qas1FmEc4nmVjLEJ9LDuNCw+sVoffQ@mail.gmail.com> (sfid-20150426_101351_704885_2AB91EEB)
Subject: Re: [PATCH v2 5/7] mac80211: Adjust chan_ctx when assigning reserved vif
From: Andrei Otcheretianski <andrei.otc@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 24, 2015 at 1:41 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Tue, 2015-04-21 at 11:53 +0300, andrei.otc@gmail.com wrote:
> > From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> >
> > When a vif is assigned to a reserved channel context (during CSA, for example)
>
> This .. doesn't make much sense. vifs aren't assigned to channel
> contexts, it's the other way around. I guess I'll rewrite that to "When
> a vif starts using a reserved  channel context (...)"
>

OK, thanks for clarification.

> > the width of this chanctx should be adjusted to be the maximum between the
> > reserved chandef and all the chandefs of other assigned vifs.
>
> This is not what you do - you don't take anything in the chanctx into
> account. ieee80211_chanctx_non_reserved_chandef() just recalculates the
> required chanctx, and you're fixing the code to actually apply the
> recalculated value.
>

sdata->reserved_chandef  is passed to
ieee80211_chanctx_non_reserved_chandef, so it takes the reservation
into account when the required chandef is recalculated.
This is what I tried to say here. I'll rephrase to make it more clear.

> > Not doing so would result in using chanctx with narrower width than actually
> > required. Fix this by calling ieee80211_change_chanctx with the widest common
> > chandef. This both changes the chanctx's width and recalcs min_def.
>
> This seems possible, yeah.
>
>
> >         chandef = ieee80211_chanctx_non_reserved_chandef(local, new_ctx,
> >                                 &sdata->reserved_chandef);
>
> >       if (WARN_ON(!chandef))
> >               return -EINVAL;
> >
> > +     ieee80211_change_chanctx(local, new_ctx, chandef);
> > +
> >       vif_chsw[0].vif = &sdata->vif;
> >       vif_chsw[0].old_ctx = &old_ctx->conf;
> >       vif_chsw[0].new_ctx = &new_ctx->conf;
> [...]
> >       ieee80211_vif_update_chandef(sdata, &sdata->reserved_chandef);
>
> Hmm. (added more context)
>
> The code here seems to be wrong though. It shouldn't overwrite
> reserved_chandef, or it shouldn't call ieee80211_vif_update_chandef()
> with it, as the vif's bss_conf.chandef should represent what *this* vif
> wants/needs, while you're now putting there what the *combination*
> requires in the chandef.
>
> That's clearly wrong - please submit a new patch that fixes all the
> issues in these functions.

I don't see any issue here.  sdata->reserved_chandef isn't overwritten
and it is what sdata really needs.

>
> johannes
>
