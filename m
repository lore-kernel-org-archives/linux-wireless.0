Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55059 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab0FAIAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 04:00:11 -0400
Subject: Re: [RFC PATCHv2 1/1] mac80211: Add interface for driver to
 temporarily disable dynamic ps
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1275289547-7104-2-git-send-email-juuso.oikarinen@nokia.com>
References: <1275289547-7104-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1275289547-7104-2-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 10:00:33 +0200
Message-ID: <1275379233.3621.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-05-31 at 10:05 +0300, Juuso Oikarinen wrote:

>  /**
> + * ieee80211_disable_dyn_ps - force mac80211 to temporarily disable dynamic psm
> + *
> + * @vif: &struct ieee80211_vif pointer from the add_interface callback.

* @disable: ...

The name is also a bit odd since you can re-enable it, but I can't think
of a better name either.

> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -478,6 +478,24 @@ static void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
>  	}
>  }
>  
> +void ieee80211_disable_dyn_ps(struct ieee80211_vif *vif, bool disable)
> +{
> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> +	struct ieee80211_local *local = sdata->local;
> +
> +	WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION);
> +
> +	sdata->disable_dyn_ps = disable;
> +
> +	/* immediately go to psm */
> +	if (disable && timer_pending(&local->dynamic_ps_timer)) {
> +		ieee80211_queue_work(&local->hw,
> +				     &local->dynamic_ps_enable_work);
> +		del_timer_sync(&local->dynamic_ps_timer);
> +	}
> +}

The timer trickery seems weird, why not just queue the work and ignore
the timer?

> -	if (conf->dynamic_ps_timeout > 0 &&
> +	if (conf->dynamic_ps_timeout > 0 && !sdata->disable_dyn_ps &&

As we just discussed on IRC, it might be worthwhile to adjust
dynamic_ps_timeout to 0 instead in this case, so this and the RX and TX
paths need not be touched.

johannes

