Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:42206 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753288AbaCXOzv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 10:55:51 -0400
Message-ID: <1395672943.4515.66.camel@dubbel> (sfid-20140324_155554_316450_6ED8E07D)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Mon, 24 Mar 2014 16:55:43 +0200
In-Reply-To: <1395408675-26013-5-git-send-email-michal.kazior@tieto.com>
References: <1394029623-21894-1-git-send-email-michal.kazior@tieto.com>
	 <1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
	 <1395408675-26013-5-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v2 4/4] mac80211: disconnect iface if CSA unexpectedly
 fails
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-21 at 14:31 +0100, Michal Kazior wrote:
> It doesn't make much sense to leave a cripled
> interface running.
> 
> As a side effect this will unblock tx queues with
> CSA reason immediately after failure instead of
> until after userspace requests interface to stop.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  net/mac80211/cfg.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 65768ef..64e152d 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -3088,7 +3088,7 @@ static int ieee80211_set_after_csa_beacon(struct ieee80211_sub_if_data *sdata,
>  	return 0;
>  }
>  
> -static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
> +static int ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
>  {
>  	struct ieee80211_local *local = sdata->local;
>  	u32 changed = 0;
> @@ -3100,7 +3100,7 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
>  	sdata->radar_required = sdata->csa_radar_required;
>  	err = ieee80211_vif_change_channel(sdata, &changed);
>  	if (WARN_ON(err < 0))
> -		return;
> +		return err;

Now you propagate the error up, do we still need the WARN_ON here?

[...]
> @@ -3123,6 +3125,7 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
>  		container_of(work, struct ieee80211_sub_if_data,
>  			     csa_finalize_work);
>  	struct ieee80211_local *local = sdata->local;
> +	int err;
>  
>  	sdata_lock(sdata);
>  	mutex_lock(&local->mtx);
> @@ -3134,7 +3137,13 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
>  	if (!ieee80211_sdata_running(sdata))
>  		goto unlock;
>  
> -	ieee80211_csa_finalize(sdata);
> +	err = ieee80211_csa_finalize(sdata);
> +	if (err) {
> +		sdata_info(sdata, "failed to finalize CSA, disconnecting\n");
> +		cfg80211_stop_iface(local->hw.wiphy, &sdata->wdev);
> +		goto unlock;
> +	}
> +

This is neat. :) Maybe it's possible to do the same thing in mlme.c and
get rid of the connection_drop_work?

--
Luca.

