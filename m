Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56403 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2KQJEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 04:04:49 -0500
Message-ID: <1353143122.9543.15.camel@jlt4.sipsolutions.net> (sfid-20121117_100501_844683_26D9EB53)
Subject: Re: [RFC 04/14] mac80211: local link-specific mesh power mode logic
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>
Date: Sat, 17 Nov 2012 10:05:22 +0100
In-Reply-To: <1353134886-13256-5-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353134886-13256-5-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-16 at 22:47 -0800, Marco Porsch wrote:

(again, changelog entry)

> -	if (_chg_mesh_attr(NL80211_MESHCONF_POWER_MODE, mask))
> +	if (_chg_mesh_attr(NL80211_MESHCONF_POWER_MODE, mask)) {
>  		conf->power_mode = nconf->power_mode;
> +		ieee80211_local_ps_update(sdata);
> +	}

Hmm, ok, so this _chg_mesh_attr call didn't belong into the previous
patch, but only here.


> +/* mesh power save */
> +void ieee80211_local_ps_update(struct ieee80211_sub_if_data *sdata);
> +void ieee80211_set_local_ps_mode(struct sta_info *sta,
> +				 enum nl80211_mesh_power_mode pm, u32 delay);

Both function should have 'mesh' somewhere in the name, I think?

> +++ b/net/mac80211/mesh_plink.c
> @@ -24,6 +24,7 @@
>  #define dot11MeshConfirmTimeout(s) (s->u.mesh.mshcfg.dot11MeshConfirmTimeout)
>  #define dot11MeshHoldingTimeout(s) (s->u.mesh.mshcfg.dot11MeshHoldingTimeout)
>  #define dot11MeshMaxPeerLinks(s) (s->u.mesh.mshcfg.dot11MeshMaxPeerLinks)
> +#define default_ps_mode(s) (s->u.mesh.mshcfg.power_mode)

I wish these macros were just removed, can't you define an "ifmsh" (or
so, like elsewhere) variable and use "ifmsh->power_mode"?

> +	list_for_each_entry_rcu(sta, &sdata->local->sta_list, list) {

Ummm, no. You have to at least check the sdata.

> +static void ieee80211_local_ps_mode_timer(unsigned long data)

"sta" somewhere in the name?

> +/**
> + * ieee80211_set_local_ps_mode - set local PS mode towards a mesh STA

ditto

> +	if (delay) {
> +		/*
> +		 * after peering/authentication/scanning it is useful to delay
> +		 * the transition to a lower power mode to avoid frame losses
> +		 * also intended for per-link dynamic powersave
> +		 */
> +		sta->local_ps_mode_delayed = pm;
> +
> +		sta->local_ps_mode_timer.data = (unsigned long) sta;
> +		sta->local_ps_mode_timer.function =
> +				ieee80211_local_ps_mode_timer;
> +		mod_timer(&sta->local_ps_mode_timer,
> +			  jiffies + msecs_to_jiffies(delay));

I think you should set this up earlier (sta init?) and just use
mod_timer here.

johannes

