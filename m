Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48907 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaC1NCA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 09:02:00 -0400
Message-ID: <1396011717.4175.20.camel@jlt4.sipsolutions.net> (sfid-20140328_140205_609318_9618C76E)
Subject: Re: [PATCH v2 3/7] mac80211: use chanctx reservation for AP CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Mar 2014 14:01:57 +0100
In-Reply-To: <1395409941-26303-4-git-send-email-michal.kazior@tieto.com> (sfid-20140321_145812_036753_6C8DF103)
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	 <1395409941-26303-1-git-send-email-michal.kazior@tieto.com>
	 <1395409941-26303-4-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140321_145812_036753_6C8DF103)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-21 at 14:52 +0100, Michal Kazior wrote:
> Channel switch finalization is now 2-step. First
> step is when driver calls csa_finish(), the other
> is when reservation is actually finalized (which
> be defered for in-place reservation).
> 
> This implies driver must not call csa_finish()
> more than once for each channel_switch request.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  net/mac80211/cfg.c  | 62 ++++++++++++++++++++++++++++++++++++-----------------
>  net/mac80211/chan.c | 11 +++++++++-
>  2 files changed, 52 insertions(+), 21 deletions(-)
> 
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 0c68269..ba544d3 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -3096,17 +3096,25 @@ static int ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
>  
>  	sdata_assert_lock(sdata);
>  	lockdep_assert_held(&local->mtx);
> +	lockdep_assert_held(&local->mtx);

duplicate
 
> -	sdata->radar_required = sdata->csa_radar_required;
> -	err = ieee80211_vif_change_channel(sdata, &changed);
> -	if (WARN_ON(err < 0))
> -		return err;
> +	/* using reservation isn't immediate as it may be deferred until later
> +	 * with multi-vif. once reservation is complete it will re-schedule the
> +	 * work with no reserved_chanctx so verify chandef to check if it
> +	 * completed successfully */

style issue here also


> -	if (num_chanctx > 1)
> -		return -EBUSY;
> +	err = ieee80211_vif_reserve_chanctx(sdata, &params->chandef,
> +					    chanctx->mode,
> +					    params->radar_required);
> +	if (err) {
> +		mutex_unlock(&local->chanctx_mtx);
> +		return err;
> +	}
>  
> -	/* don't allow another channel switch if one is already active. */
> -	if (sdata->vif.csa_active)
> -		return -EBUSY;
> +	/* if reservation is invalid then this will fail */
> +	err = ieee80211_check_combinations(sdata, NULL, chanctx->mode, 0);
> +	if (err) {
> +		ieee80211_vif_unreserve_chanctx(sdata);
> +		mutex_unlock(&local->chanctx_mtx);
> +		return err;
> +	}
>  
>  	err = ieee80211_set_csa_beacon(sdata, params, &changed);
> -	if (err)
> +	if (err) {
> +		ieee80211_vif_unreserve_chanctx(sdata);
> +		mutex_unlock(&local->chanctx_mtx);
>  		return err;
> +	}

All those error cases could be converted to 'goto' instead of
duplicating the unlock/unreserve.

johannes

