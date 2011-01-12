Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50283 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287Ab1ALMxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 07:53:24 -0500
Subject: Re: [PATCH] mac80211: use maximum number of a-msdu frames as
 default in BA RX
From: Johannes Berg <johannes@sipsolutions.net>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org, stable@kernel.org
In-Reply-To: <1294836681-21712-1-git-send-email-coelho@ti.com>
References: <1294836681-21712-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 13:54:04 +0100
Message-ID: <1294836844.3639.26.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-12 at 14:51 +0200, coelho@ti.com wrote:
> From: Luciano Coelho <coelho@ti.com>
> 
> When the buffer size is set to zero in the block ack parameter set
> field, we should use the maximum supported number of subframes.  The
> existing code was bogus and was doing some unnecessary calculations
> that lead to wrong values.
> 
> Thanks Johannes for helping me figure this one out.
> 
> Cc: stable@kernel.org
> Cc: Johannes Berg <johannes@sipsolutions.net>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

It'd be easier for stable if you reordered with the other patch, I
think, but I guess it's easy enough to fix up.

Also some older stable versions might have this code in a different
file, but I'm not sure how to handle that.

johannes

> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
>  net/mac80211/agg-rx.c |    9 ++-------
>  1 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
> index 002db5e..ed3ee93 100644
> --- a/net/mac80211/agg-rx.c
> +++ b/net/mac80211/agg-rx.c
> @@ -231,13 +231,8 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
>  		goto end_no_lock;
>  	}
>  	/* determine default buffer size */
> -	if (buf_size == 0) {
> -		struct ieee80211_supported_band *sband;
> -
> -		sband = local->hw.wiphy->bands[conf->channel->band];
> -		buf_size = IEEE80211_MIN_AMPDU_BUF;
> -		buf_size = buf_size << sband->ht_cap.ampdu_factor;
> -	}
> +	if (buf_size == 0)
> +		buf_size = IEEE80211_MAX_AMPDU_BUF;
>  
>  	/* make sure the size doesn't exceed the maximum supported by the hw */
>  	if (buf_size > local->hw.max_rx_aggregation_subframes)


