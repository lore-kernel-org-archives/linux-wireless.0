Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39066 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab0I2UAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 16:00:38 -0400
Subject: Re: [RFC v2] mac80211: fix rx monitor filter refcounters
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201009292157.04141.chunkeey@googlemail.com>
References: <201009281836.24529.chunkeey@googlemail.com>
	 <1285744218.3756.10.camel@jlt3.sipsolutions.net>
	 <201009292157.04141.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 22:00:39 +0200
Message-ID: <1285790439.3756.35.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-29 at 21:57 +0200, Christian Lamparter wrote:

> > > Is there a sane way to do that?
> > 
> > Is this not sane enough? Looks OK to me, even if it adds a bit of code.
> > 
> 
> It's about MONITOR_FLAG_COOK_FRAMES. This flag gives me headaches.
> I wish we could make this flag "const" and don't allow it be changed
> by iw dev wlanX set monitor. 

Ah. Then you can only specify it when creating an interface, right? Fine
with me, really.

> Another alternative would be to move
> the "sdata->u.mntr_flag -> fif_* processing" into
> ieee80211_configure_filter. 
> 
> or: 
> ---
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index c981604..1ffe266 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -68,9 +68,61 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
>  		 params && params->use_4addr >= 0)
>  		sdata->u.mgd.use_4addr = params->use_4addr;
>  
> -	if (sdata->vif.type == NL80211_IFTYPE_MONITOR && flags)
> +	if (sdata->vif.type == NL80211_IFTYPE_MONITOR && flags) {
> +		struct ieee80211_local *local = sdata->local;
> +		u32 changed_flags;
> +		u32 old_flags;
> +		u32 hw_reconf_flags = 0;
> +
> +		old_flags = sdata->u.mntr_flags;
> +		changed_flags = old_flags ^ *flags;
> +		if (!(old_flags & MONITOR_FLAG_COOK_FRAMES))
> +			ieee80211_adjust_monitor_flags(sdata, -1);
> +
> +		if (changed_flags & MONITOR_FLAG_COOK_FRAMES) {
> +			if (*flags & MONITOR_FLAG_COOK_FRAMES) {
> +				local->cooked_mntrs++;
> +				local->monitors--;

Yeah, that's kinda ugly. I'm fine with not allowing the cook flag to
change, seems like a pretty special case anyway. Or, we can allow it to
change, but only while the interface is down, right?

johannes

