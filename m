Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38649 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab0GWGBl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 02:01:41 -0400
Subject: Re: [PATCH] mac80211: Don't set per-BSS QoS for monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <19529.9687.183293.284789@gargle.gargle.HOWL>
References: <19529.9687.183293.284789@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Jul 2010 08:01:08 +0200
Message-ID: <1279864868.3745.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-07-23 at 10:47 +0530, Sujith wrote:
> In AP mode, there is no need to notify the driver about QoS
> changes for the monitor interface that is created. The warning
> in ieee80211_bss_info_change_notify() would be hit otherwise.

Makes sense.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  net/mac80211/util.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 7947921..748387d 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -803,8 +803,12 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
>  
>  	/* after reinitialize QoS TX queues setting to default,
>  	 * disable QoS at all */
> -	sdata->vif.bss_conf.qos = sdata->vif.type != NL80211_IFTYPE_STATION;
> -	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_QOS);
> +
> +	if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
> +		sdata->vif.bss_conf.qos =
> +			sdata->vif.type != NL80211_IFTYPE_STATION;
> +		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_QOS);
> +	}
>  }
>  
>  void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,


