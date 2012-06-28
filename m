Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45267 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab2F1J1b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 05:27:31 -0400
Message-ID: <1340875646.4491.24.camel@jlt3.sipsolutions.net> (sfid-20120628_112735_069706_EE1E1990)
Subject: Re: [RFC v3] initial channel context implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 28 Jun 2012 11:27:26 +0200
In-Reply-To: <4FEC21DA.9040901@tieto.com>
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>
	      <1340718188.14634.47.camel@jlt3.sipsolutions.net>
	      <4FEAB698.5070309@tieto.com>
	     <1340784614.8305.8.camel@jlt3.sipsolutions.net>
	     <4FEADCAE.5080508@tieto.com>
	    <1340795424.11012.11.camel@jlt3.sipsolutions.net>
	    <4FEAFFF1.7080706@tieto.com>
	   <1340805730.11012.33.camel@jlt3.sipsolutions.net>
	   <4FEBF3D4.3030705@tieto.com>
	  <1340868682.4491.1.camel@jlt3.sipsolutions.net>
	  <4FEC0D9F.9030000@tieto.com>
	 <1340871180.4491.16.camel@jlt3.sipsolutions.net>
	 <4FEC21DA.9040901@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-28 at 11:20 +0200, Michal Kazior wrote:

> > Yes, makes sense. I forgot all about the TX code. I'm a little wary of
> > making the contexts mutable, even in this case, because a lot of code
> > uses local->oper_channel as well, and that is expected to really be the
> > operating channel all of the time, even if we're scanning at some point
> > in time.
> 
> Yeah. The other option (maintaining the immutability) is to iterate 
> through all interfaces and call ieee80211_vif_use_channel when switching 
> channel for single-channel operation. Or do you have something else in 
> mind maybe?

I don't think we should do that, we want to maintain chanctx.channel,
what today is oper_channel. But I guess I was just expressing myself
badly, seems below you understood it better :)

> > Luckily, tx.channel isn't actually used much, only for the band. So if
> > we tag the SKBs with the band earlier (info->band), maybe we don't need
> > to use hw.conf.channel as much there for tx.channel?
> >
> > Other uses where we do need the current channel are
> >   * ieee80211_build_probe_req
> >   * ieee80211_add_srates_ie/ieee80211_add_ext_srates_ie
> >   * __ieee80211_start_scan uses it but need not, could use oper_channel
> >     instead and the code never executes for multi-channel
> >   * ieee80211_set_tx_power() is interesting, may need to make it all
> >     per-sdata now through nl80211 etc.
> 
> What will drivers that don't support per-sdata tx_power do? Do all 
> multi-vif (not multi-channel) drivers support per-interface tx power?
> 
> I guess we'd have to manage:
>   a) common tx power value in ieee80211_local
>   b) provide a function that calculates the common value
>      so drivers may use it (and avoid code duplication)
>   c) ..or else drivers would need to implement the calculation on
>      their own

Yeah, good question. I'm not too worried about TX power though TBH, I
think it's fair to assume that if a driver supports multi-channel, it
supports per-channel TX power as well, if it even supports TX power
adjustment at all.


> >   * rate_idx_to_bitrate can use the sta's sdata's channel
> >   * ieee80211_change_bss can use the sdata's channel
> >   * debugfs stuff probably just moves to per-sdata files
> >   * ibss code all uses sdata channel
> >   * ieee80211_if_change_type ... probably just set basic_rates = 0
> >   * mesh can use sdata channel
> >   * mlme.c should use sdata channel, but there's the channel switch stuff
> >   * rate.h should use sta->sdata channel
> >
> > Much of this is actually means we have bugs today! Whenever we use
> > hw.conf.channel and should be using sdata channel soon, we should be
> > using local->oper_channel today!
> 
> Oh! Now I understand why you wanted to use channel contexts in place of 
> oper_channel. This makes sense.

:-)


> > Maybe it's worth fixing that first, and getting rid of *most* instances
> > of hw.conf.channel, so we have a clearer idea of which changes in what
> > ways?
> 
> Sounds like a good idea.

Do you want to take that up? I think it would be worth doing it in front
of all the other mac80211 patches (those are incomplete anyway in that
the new code doesn't get used), and then we can shake out any bugs here
before we switch over to multi-channel?

Or I can work on it too if you prefer.

johannes

