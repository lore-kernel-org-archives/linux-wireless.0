Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50339 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab2F2N4n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 09:56:43 -0400
Message-ID: <1340978200.4472.2.camel@jlt3.sipsolutions.net> (sfid-20120629_155647_011809_A2E60DE4)
Subject: Re: [PATCH v2] mac80211: correct size the argument to kzalloc in
 minstrel_ht
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>, franzschrober@yahoo.de,
	julian.calaby@gmail.com, nbd@openwrt.org
Date: Fri, 29 Jun 2012 15:56:40 +0200
In-Reply-To: <1340976387-80206-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1340976387-80206-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-29 at 06:26 -0700, Thomas Huehn wrote:
> msp has type struct minstrel_ht_sta_priv not struct minstrel_ht_sta.
> 
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

I guess it worked anyway because the allocations are usually rounded up.

> ---
> Use suggested coding style. Thx to Schrober.
> ---
>  net/mac80211/rc80211_minstrel_ht.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
> index 2d1acc6..1ca8f2b 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -809,11 +809,11 @@ minstrel_ht_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
>  			max_rates = sband->n_bitrates;
>  	}
>  
> -	msp = kzalloc(sizeof(struct minstrel_ht_sta), gfp);
> +	msp = kzalloc(sizeof(*msp), gfp);
>  	if (!msp)
>  		return NULL;
>  
> -	msp->ratelist = kzalloc(sizeof(struct minstrel_rate) * max_rates, gfp);
> +	msp->ratelist = kzalloc(sizeof(*msp->ratelist) * max_rates, gfp);
>  	if (!msp->ratelist)
>  		goto error;
>  


