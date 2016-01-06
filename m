Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42541 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbcAFLLD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2016 06:11:03 -0500
Message-ID: <1452078660.2541.7.camel@sipsolutions.net> (sfid-20160106_121122_103069_8550436B)
Subject: Re: [PATCH] iw:Fix memory leak if nla_put fails
From: Johannes Berg <johannes@sipsolutions.net>
To: Rahul Jain <rahul.jain@samsung.com>
Cc: linux-wireless@vger.kernel.org,
	Amit Khatri <amit.khatri@samsung.com>
Date: Wed, 06 Jan 2016 12:11:00 +0100
In-Reply-To: <1448617041-20120-1-git-send-email-rahul.jain@samsung.com>
References: <1448617041-20120-1-git-send-email-rahul.jain@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-11-27 at 15:07 +0530, Rahul Jain wrote:
> 
> @@ -124,7 +124,8 @@ static int handle_coalesce_enable(struct
> nl80211_state *state,
>  					nla_nest_end(msg, nl_pat);
>  					free(mask);
>  					free(pat);
> -
> +					pat = NULL;
> +					mask = NULL;

I'd prefer to keep the blank line.

> +	if (pat)
> +		free(pat);

free(NULL) is valid and a no-op.

> -			NLA_PUT(msg, NL80211_WOWLAN_TCP_WAKE_MASK,
> -				DIV_ROUND_UP(patlen, 8), mask);
> -			NLA_PUT(msg,
> NL80211_WOWLAN_TCP_WAKE_PAYLOAD,
> -				patlen, pat);
> +			if (nla_put(msg,
> NL80211_WOWLAN_TCP_WAKE_MASK,
> +				DIV_ROUND_UP(patlen, 8), mask) < 0)
> {
> +				free(mask);
> +				free(pat);
> +				mask = NULL;
> +				pat = NULL;
> +				goto nla_put_failure;
> +			}
> +			if (nla_put(msg,
> NL80211_WOWLAN_TCP_WAKE_PAYLOAD,
> +				patlen, pat) < 0){
> +				free(pat);
> +				free(mask);
> +				pat = NULL;
> +				mask = NULL;
> +				goto nla_put_failure;
> +			}

I don't understand - you also updated the nla_put_failure label to free
it.

>  			free(mask);
>  			free(pat);

seems like you need NULL here though.

johannes
