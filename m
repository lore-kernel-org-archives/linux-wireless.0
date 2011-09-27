Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47434 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab1I0Lz6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 07:55:58 -0400
Subject: Re: [PATCH 4/5] nl80211/mac80211: allow adding TDLS peers as
 stations
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
In-Reply-To: <1317034493-5300-5-git-send-email-arik@wizery.com> (sfid-20110926_125521_419653_B5DAD54E)
References: <1317034493-5300-1-git-send-email-arik@wizery.com>
	 <1317034493-5300-5-git-send-email-arik@wizery.com>
	 (sfid-20110926_125521_419653_B5DAD54E)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 13:55:53 +0200
Message-ID: <1317124553.4082.26.camel@jlt3.sipsolutions.net> (sfid-20110927_135601_483366_6EFD0AF7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-26 at 13:54 +0300, Arik Nemtsov wrote:

> @@ -811,6 +817,11 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
>  
>  	sta_apply_parameters(local, sta, params);
>  
> +	if (!(wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS) &&
> +	    (sta->flags & WLAN_STA_TDLS_PEER)) {
> +		return -ENOTSUPP;
> +	}

I think this should maybe also make sure that the interface is in
station mode? Otherwise it could get somewhat confusing. Also changes to
the TDLS flag probably shouldn't be allowed.

And this code might also be better in cfg80211, although this is only
with external management, right?

> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -2521,18 +2521,18 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
>  		break;
>  	case NL80211_IFTYPE_P2P_CLIENT:
>  	case NL80211_IFTYPE_STATION:
> -		/* disallow everything but AUTHORIZED flag */
> +		/* disallow things sta doesn't support */
>  		if (params.plink_action)
>  			err = -EINVAL;
>  		if (params.vlan)
>  			err = -EINVAL;
> -		if (params.supported_rates)
> -			err = -EINVAL;

Hmm. Should this be dependent on TLDS somehow?

>  		if (params.ht_capa)
>  			err = -EINVAL;
>  		if (params.listen_interval >= 0)
>  			err = -EINVAL;
> -		if (params.sta_flags_mask & ~BIT(NL80211_STA_FLAG_AUTHORIZED))
> +		if (params.sta_flags_mask &
> +				~(BIT(NL80211_STA_FLAG_AUTHORIZED) |
> +				  BIT(NL80211_STA_FLAG_TDLS_PEER)))

Why is the TDLS flag allowed to change?


> +	/*
> +	 * Managed stations can only add TDLS peers, and only when the
> +	 * wiphy supports it.
> +	 */
> +	if (dev->ieee80211_ptr->iftype == NL80211_IFTYPE_STATION &&
> +	    (!(params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)) ||
> +	     !(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS)))
>  		return -EINVAL;

If the device does full TDLS by itself I don't think we should be
allowed to add/remove stations?



Maybe you need to describe the command sequences a little bit somewhere.
I'm getting a bad feeling about adding stations without supported rates,
and this is only when we have external management etc.

Part of your argument for having the frame sending etc. in the kernel
was that then it's more like managed mode, but all the manual station
handling is very much unlike that.

I'm beginning to think that maybe it should be handled through the TDLS
operations instead, more implicitly?

johannes

