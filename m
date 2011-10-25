Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933347Ab1JYN4g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 09:56:36 -0400
Date: Tue, 25 Oct 2011 15:56:48 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: use min rate as basic rate for buggy APs
Message-ID: <20111025135647.GB2231@redhat.com> (sfid-20111025_155640_062773_9FA3DE33)
References: <1319531194-26839-1-git-send-email-eliad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1319531194-26839-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 25, 2011 at 10:26:34AM +0200, Eliad Peller wrote:
> Some buggy APs (and even P2P_GO) don't advertise their
> basic rates in the association response.
> 
> In such case, use the min supported rate as the
> basic rate.

Can we do this in simpler way?

   if (unlikely(!basic_rates))
	basic_rates = BIT(ffs(rates) - 1);

Stanislaw

> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  net/mac80211/mlme.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 0e5d8da..064df37 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1482,6 +1482,7 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
>  	int i, j, err;
>  	bool have_higher_than_11mbit = false;
>  	u16 ap_ht_cap_flags;
> +	int min_rate = INT_MAX, min_rate_index = -1;
>  
>  	/* AssocResp and ReassocResp have identical structure */
>  
> @@ -1537,6 +1538,10 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
>  				rates |= BIT(j);
>  				if (is_basic)
>  					basic_rates |= BIT(j);
> +				if (rate < min_rate) {
> +					min_rate = rate;
> +					min_rate_index = j;
> +				}
>  				break;
>  			}
>  		}
> @@ -1554,11 +1559,22 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
>  				rates |= BIT(j);
>  				if (is_basic)
>  					basic_rates |= BIT(j);
> +				if (rate < min_rate) {
> +					min_rate = rate;
> +					min_rate_index = j;
> +				}
>  				break;
>  			}
>  		}
>  	}
>  
> +	/*
> +	 * some buggy APs don't advertise basic_rates. use the lowest
> +	 * supported rate instead.
> +	 */
> +	if (unlikely(!basic_rates) && min_rate_index >= 0)
> +		basic_rates = BIT(min_rate_index);
> +
>  	sta->sta.supp_rates[wk->chan->band] = rates;
>  	sdata->vif.bss_conf.basic_rates = basic_rates;
>  
> -- 
> 1.7.6.401.g6a319
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
