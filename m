Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36047 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbaBUIkb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 03:40:31 -0500
Message-ID: <1392972028.4346.28.camel@jlt4.sipsolutions.net> (sfid-20140221_094034_518627_ED59CADB)
Subject: Re: [PATCH v3 5/7] cfg80211/mac80211: refactor
 cfg80211_chandef_dfs_required()
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Date: Fri, 21 Feb 2014 09:40:28 +0100
In-Reply-To: <1392906986-12275-6-git-send-email-luca@coelho.fi>
References: <1392906986-12275-1-git-send-email-luca@coelho.fi>
	 <1392906986-12275-6-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 16:36 +0200, Luciano Coelho wrote:

> +	radar_required = !!(err);

That's going a bit overboard - you really need only ... = err; for bool
variables :) 

>  	int width;
> -	int r;
> +	int ret;
>  
>  	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
>  		return -EINVAL;
>  
> -	width = cfg80211_chandef_get_width(chandef);
> -	if (width < 0)
> -		return -EINVAL;
> +	switch (iftype) {
> +	case NL80211_IFTYPE_UNSPECIFIED:
> +	case NL80211_IFTYPE_ADHOC:
> +	case NL80211_IFTYPE_AP:
> +	case NL80211_IFTYPE_P2P_GO:
> +	case NL80211_IFTYPE_MESH_POINT:
> +		width = cfg80211_chandef_get_width(chandef);
> +		if (width < 0)
> +			return -EINVAL;
>  
> -	r = cfg80211_get_chans_dfs_required(wiphy, chandef->center_freq1,
> -					    width);
> -	if (r)
> -		return r;
> +		ret = cfg80211_get_chans_dfs_required(wiphy,
> +						      chandef->center_freq1,
> +						      width);
> +		if (ret < 0)
> +			return ret;
> +		else if (ret > 0)
> +			return BIT(chandef->width);

What's with the width vs. chandef->width?

johannes

