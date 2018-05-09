Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53582 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935325AbeEIVds (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 17:33:48 -0400
Message-ID: <1525901625.6910.33.camel@sipsolutions.net> (sfid-20180509_233351_812858_80B5FAE6)
Subject: Re: [PATCH 3/3] net: Dynamically allocate struct station_info
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
Date: Wed, 09 May 2018 23:33:45 +0200
In-Reply-To: <152586802515.18089.12700714478750075562.stgit@alrua-kau> (sfid-20180509_141355_857728_4EC9B802)
References: <152586802501.18089.2502272945272741154.stgit@alrua-kau>
         <152586802515.18089.12700714478750075562.stgit@alrua-kau>
         (sfid-20180509_141355_857728_4EC9B802)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> WARN_ON is used where the function has no way to signal errors to the
> caller.

There isn't really much point in that - failing allocations are already
*very* noisy. Please respin with that removed (and then I guess you can
fix the Fixes: too)

You didn't actually do that in this patch though :-)

johannes

> +	bool filled;
>  	int ret;
>  
>  	/* if the user specified a customised value for this interface, then
> @@ -102,7 +103,17 @@ static u32 batadv_v_elp_get_throughput(struct batadv_hardif_neigh_node *neigh)
>  		if (!real_netdev)
>  			goto default_throughput;
>  
> -		ret = cfg80211_get_station(real_netdev, neigh->addr, &sinfo);
> +		sinfo = kzalloc(sizeof(*sinfo), GFP_KERNEL);
> +		if (!sinfo)
> +			goto default_throughput;
> +
> +		ret = cfg80211_get_station(real_netdev, neigh->addr, sinfo);
> +
> +		/* just save these here instead of having complex free logic below */
> +		throughput = sinfo.expected_throughput / 100;
> +		filled = !!(sinfo.filled & BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT));

It's bool so you don't need the !!(...) :-)

johannes
