Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42656 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752922AbcLOJzy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 04:55:54 -0500
Message-ID: <1481795682.2582.1.camel@sipsolutions.net> (sfid-20161215_105612_345803_FA210132)
Subject: Re: [PATCH v2] mac80211:  fix legacy and invalid rx-rate rpt
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Thu, 15 Dec 2016 10:54:42 +0100
In-Reply-To: <1481743838-20323-1-git-send-email-greearb@candelatech.com>
References: <1481743838-20323-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-12-14 at 11:30 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This fixes obtaining the rate info via sta_set_sinfo
> when the rx rate is invalid (for instance, on IBSS
> interface that has received no frames from one of its
> peers).
> 
> This also fixes a more general issue with rinfo->flags
> not being properly initialized for legacy rates.

I'd say this is a bug in the ethtool code - everything assumes (and
everything else makes sure) the whole sinfo struct is initialized to 0
before getting passed to this function.

> +static int sta_set_rate_info_rx(struct sta_info *sta, struct
> rate_info *rinfo)
>  {
>  	u16 rate = ACCESS_ONCE(sta_get_last_rx_stats(sta)-
> >last_rate);
> -
> -	if (rate == STA_STATS_RATE_INVALID)
> -		rinfo->flags = 0;
> -	else
> +	if (rate == STA_STATS_RATE_INVALID) {
> +		return -EINVAL;
> +	} else {
>  		sta_stats_decode_rate(sta->local, rate, rinfo);
> +		return 0;
> +	}

That's weird, I'll fix it.

Applied, with some fixupse.

johannes
