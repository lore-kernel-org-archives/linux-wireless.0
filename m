Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38837 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab3HPK5B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 06:57:01 -0400
Message-ID: <1376650616.15299.16.camel@jlt4.sipsolutions.net> (sfid-20130816_125706_100150_6BE10701)
Subject: Re: [PATCH] mac80211: implement STA CSA for drivers using channel
 contexts
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 16 Aug 2013 12:56:56 +0200
In-Reply-To: <CA+XVXffREZsiLU_Gs646-akyW9XNcZEmQnQGsp4ihT92hP7LOw@mail.gmail.com> (sfid-20130815_180720_936295_010E9810)
References: <1376395438-24788-1-git-send-email-arik@wizery.com>
	 <1376568235.14084.12.camel@jlt4.sipsolutions.net>
	 <CA+XVXffREZsiLU_Gs646-akyW9XNcZEmQnQGsp4ihT92hP7LOw@mail.gmail.com>
	 (sfid-20130815_180720_936295_010E9810)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-08-15 at 19:07 +0300, Arik Nemtsov wrote:
> On Thu, Aug 15, 2013 at 3:03 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >> @@ -2872,6 +2872,11 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
> >>       if (WARN_ON(err < 0))
> >>               return;
> >>
> >> +     if (!local->use_chanctx) {
> >> +             local->_oper_chandef = local->csa_chandef;
> >> +             ieee80211_hw_config(local, 0);
> >> +     }
> >
> > I don't really understand this part - I think you should add some
> > documentation or something?
> 
> Basically I removed this chunk of code from
> ieee80211_vif_change_channel() and put it here - a bit later in the AP
> CSA flow.
> I don't think it does any harm.

Well, technically not, but I'm trying to reduce the places that touch
the old non-chanctx stuff, not increase them :-)

> >> @@ -453,11 +453,6 @@ int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
> >>       chanctx_changed |= IEEE80211_CHANCTX_CHANGE_CHANNEL;
> >>       drv_change_chanctx(local, ctx, chanctx_changed);
> >>
> >> -     if (!local->use_chanctx) {
> >> -             local->_oper_chandef = *chandef;
> >> -             ieee80211_hw_config(local, 0);
> >> -     }
> >
> > I really don't like it either - this was here so that no other code
> > really needed to be worried about non-chanctx drivers.
> 
> Well right now ieee80211_chswitch_work() takes care of it, and does
> something a bit different there to accommodate the legacy behavior -
> if the chan_switch op is defined, ieee80211_hw_config is not called.
> Would you prefer that ieee80211_vif_change_channel() handle all this,
> checking interface type to do the right thing?

Well, it can't. If you look carefully then the old chan_switch op
behaviour is to let the driver switch, not switch in software
afterwards.

> I only added it since the current implementation of
> ieee80211_vif_change_channel() bails if it's false. That said, I'm not
> sure what's wrong here. This setting is per-vif.

Yeah but it's (currently) meant for interfaces controlling the CSA (i.e.
AP only right now) ... so I really think we need to make this
controllable, I think that when we want to implement it for Intel MVM
firmware then we'll let the firmware control the switch timing, etc.
None of this can even be done today or with your patch.

johannes

