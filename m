Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40158 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315Ab3CSUdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 16:33:50 -0400
Message-ID: <1363725222.8336.27.camel@jlt4.sipsolutions.net> (sfid-20130319_213354_223107_B9AD0D9B)
Subject: Re: [RFC 3/3] mac80211: P2P add NOA settings
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: Janusz.Dziedzic@tieto.com, linux-wireless@vger.kernel.org
Date: Tue, 19 Mar 2013 21:33:42 +0100
In-Reply-To: <CAFED-jndqjMFjNLBadFV1W9+5QZJF649BhFKy5zSjw3pnSQh1w@mail.gmail.com> (sfid-20130319_163844_201066_D1B1CD5A)
References: <3078A9B976EF864C8DDD0C499FFD07912FA1693F2A@EXMB01.eu.tieto.com>
	 <1363361717.8656.18.camel@jlt4.sipsolutions.net>
	 <CAFED-jmGRNFDHBvZQV=t7ETQa=yk4bZMjt1N8KckKweDLZE3uA@mail.gmail.com>
	 <1363638107.8260.24.camel@jlt4.sipsolutions.net>
	 <CAFED-jndqjMFjNLBadFV1W9+5QZJF649BhFKy5zSjw3pnSQh1w@mail.gmail.com>
	 (sfid-20130319_163844_201066_D1B1CD5A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-19 at 16:38 +0100, Janusz Dziedzic wrote:

> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -960,8 +960,12 @@ static int ieee80211_start_ap(struct wiphy
> *wiphy, struct net_device *dev,
>  	sdata->vif.bss_conf.hidden_ssid =
>  		(params->hidden_ssid != NL80211_HIDDEN_SSID_NOT_IN_USE);
> 
> -	sdata->vif.bss_conf.p2p_ctwindow = params->p2p_ctwindow;
> -	sdata->vif.bss_conf.p2p_oppps = params->p2p_opp_ps;
> +	sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow =
> +						params->p2p_ctwindow & 0x7F;
> +	if (params->p2p_opp_ps)
> +		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow |= BIT(7);
> +	else
> +		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow &= ~BIT(7);

That else branch isn't really needed.

> @@ -1956,12 +1960,17 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
>  	}
> 
>  	if (params->p2p_ctwindow >= 0) {
> -		sdata->vif.bss_conf.p2p_ctwindow = params->p2p_ctwindow;
> +		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow &= ~0x7f;
> +		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow |=
> +						params->p2p_ctwindow & 0x7f;

You have this BIT(7) and 0x7f a lot now, I think you should add
constants next to the struct definition and use them everywhere.

Otherwise looks fine, thanks for fixing my bugs too :-)

One more thing -- you need to update the iwlwifi/mvm driver that uses
this already. I'd prefer to also use the constants I asked for above
there.

johannes

