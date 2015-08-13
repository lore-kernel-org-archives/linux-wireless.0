Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47865 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbbHMMBG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 08:01:06 -0400
Message-ID: <1439467263.2114.26.camel@sipsolutions.net> (sfid-20150813_140109_986682_47529277)
Subject: Re: [PATCH 3/5] mac80211: Create STA when transmitting to unknown
 station in OCB mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>,
	linux-wireless@vger.kernel.org
Date: Thu, 13 Aug 2015 14:01:03 +0200
In-Reply-To: <1438783353-5685-1-git-send-email-bertold.vandenbergh@esat.kuleuven.be>
References: <1438783353-5685-1-git-send-email-bertold.vandenbergh@esat.kuleuven.be>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-08-05 at 16:02 +0200, Bertold Van den Bergh wrote:
> Create a new STA when requested to unicast a frame to an unknown 
> station.
> This is needed to make ratecontrol work in the case where data is 
> sent
> from sta A to B and sta B never replies. Currently, sta B will stay 
> unknown
> to mac80211 and the default rate will always be used.
> 
> Signed-off-by: Bertold Van den Bergh <
> bertold.vandenbergh@esat.kuleuven.be>
> ---
>  net/mac80211/tx.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 84e0e8c..eb8dba6 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1209,6 +1209,10 @@ ieee80211_tx_prepare(struct 
> ieee80211_sub_if_data *sdata,
>  	} else
>  		tx->flags |= IEEE80211_TX_UNICAST;
>  
> +	if ((sdata->vif.type == NL80211_IFTYPE_OCB) && (!tx->sta) &&
> +	    (tx->flags & IEEE80211_TX_UNICAST))
> +		ieee80211_ocb_rx_no_sta(sdata, NULL, hdr->addr1, 0);

It seems that this could be in a place that's already OCB specific,
perhaps earlier.

Also, it seems you should then actually use the station and assign it
to tx->sta, and rename the function to be more indicative of what it's
doing now.

And code-style wise - you don't need all those parentheses.

johannes
