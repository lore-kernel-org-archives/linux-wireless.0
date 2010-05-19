Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49881 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab0ESHzk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 03:55:40 -0400
Subject: Re: [PATCH] mac80211: Remove deprecated sta_notify commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <19443.32502.791626.492686@gargle.gargle.HOWL>
References: <19443.32502.791626.492686@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 09:55:35 +0200
Message-ID: <1274255735.3874.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-05-19 at 11:32 +0530, Sujith wrote:
> STA_NOTIFY_ADD and STA_NOTIFY_REMOVE have no users anymore,
> and station addition/removal are indicated to drivers
> using sta_add() and sta_remove(), which can sleep.

Thanks!

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  include/net/mac80211.h    |    6 +-----
>  net/mac80211/driver-ops.h |    6 ------
>  2 files changed, 1 insertions(+), 11 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 389e86a..981d9b4 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -881,16 +881,12 @@ struct ieee80211_sta {
>   * enum sta_notify_cmd - sta notify command
>   *
>   * Used with the sta_notify() callback in &struct ieee80211_ops, this
> - * indicates addition and removal of a station to station table,
> - * or if a associated station made a power state transition.
> + * indicates if an associated station made a power state transition.
>   *
> - * @STA_NOTIFY_ADD: (DEPRECATED) a station was added to the station table
> - * @STA_NOTIFY_REMOVE: (DEPRECATED) a station being removed from the station table
>   * @STA_NOTIFY_SLEEP: a station is now sleeping
>   * @STA_NOTIFY_AWAKE: a sleeping station woke up
>   */
>  enum sta_notify_cmd {
> -	STA_NOTIFY_ADD, STA_NOTIFY_REMOVE,
>  	STA_NOTIFY_SLEEP, STA_NOTIFY_AWAKE,
>  };
>  
> diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
> index 5662bb5..14a3b3c 100644
> --- a/net/mac80211/driver-ops.h
> +++ b/net/mac80211/driver-ops.h
> @@ -254,9 +254,6 @@ static inline int drv_sta_add(struct ieee80211_local *local,
>  
>  	if (local->ops->sta_add)
>  		ret = local->ops->sta_add(&local->hw, &sdata->vif, sta);
> -	else if (local->ops->sta_notify)
> -		local->ops->sta_notify(&local->hw, &sdata->vif,
> -					STA_NOTIFY_ADD, sta);
>  
>  	trace_drv_sta_add(local, sdata, sta, ret);
>  
> @@ -271,9 +268,6 @@ static inline void drv_sta_remove(struct ieee80211_local *local,
>  
>  	if (local->ops->sta_remove)
>  		local->ops->sta_remove(&local->hw, &sdata->vif, sta);
> -	else if (local->ops->sta_notify)
> -		local->ops->sta_notify(&local->hw, &sdata->vif,
> -					STA_NOTIFY_REMOVE, sta);
>  
>  	trace_drv_sta_remove(local, sdata, sta);
>  }


