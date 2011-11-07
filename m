Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41691 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab1KGR6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 12:58:54 -0500
Subject: Re: [PATCH] iw: fix regression in tx power validation
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320688191-24689-1-git-send-email-nbd@openwrt.org>
References: <1320688191-24689-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Nov 2011 18:58:51 +0100
Message-ID: <1320688731.3993.55.camel@jlt3.sipsolutions.net> (sfid-20111107_185857_770849_605DECBE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-07 at 18:49 +0100, Felix Fietkau wrote:
> Only bail out if the last character is *not* \0

Oops, thanks.

> ---
>  phy.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/phy.c b/phy.c
> index 91042b4..d9090fd 100644
> --- a/phy.c
> +++ b/phy.c
> @@ -293,7 +293,7 @@ static int handle_txpower(struct nl80211_state *state,
>  		}
>  
>  		mbm = strtol(argv[1], &endptr, 10);
> -		if (!*endptr)
> +		if (*endptr)
>  			return 2;
>  		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_TX_POWER_LEVEL, mbm);
>  	} else if (argc != 1)


