Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52400 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707AbZJ0QHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 12:07:53 -0400
Subject: Re: [PATCH v2 1/3] mac80211: refactor dynamic power save check
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20091027153608.27827.70629.stgit@tikku>
References: <20091027153608.27827.70629.stgit@tikku>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Oct 2009 17:07:23 +0100
Message-ID: <1256659643.4237.20.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-10-27 at 17:36 +0200, Kalle Valo wrote:
> From: Kalle Valo <kalle.valo@nokia.com>
> 
> Refactor dynamic power save checks to a function of it's own for better
> readibility. No functional changes.
> 
> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> ---
> 
>  net/mac80211/tx.c |   24 +++++++++++++++++++++---
>  1 files changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index db4bda6..c59ed84 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1387,6 +1387,26 @@ static int ieee80211_skb_resize(struct ieee80211_local *local,
>  	return 0;
>  }
>  
> +static bool need_dynamic_ps(struct ieee80211_local *local)
> +{
> +	/* driver doesn't support power save */
> +	if (!(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
> +		return false;
> +
> +	/* dynamic power save disabled */
> +	if (local->hw.conf.dynamic_ps_timeout <= 0)
> +		return false;
> +
> +	/* we are scanning, don't enable power save */
> +	if (local->scanning)
> +		return false;
> +
> +	if (!local->ps_sdata)
> +		return false;
> +
> +	return true;
> +}
> +
>  static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
>  			   struct sk_buff *skb)
>  {
> @@ -1399,9 +1419,7 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
>  
>  	dev_hold(sdata->dev);
>  
> -	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
> -	    local->hw.conf.dynamic_ps_timeout > 0 &&
> -	    !(local->scanning) && local->ps_sdata) {
> +	if (need_dynamic_ps(local)) {
>  		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
>  			ieee80211_stop_queues_by_reason(&local->hw,
>  					IEEE80211_QUEUE_STOP_REASON_PS);
> 
> 


