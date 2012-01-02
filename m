Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39035 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab2ABKjy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 05:39:54 -0500
Subject: Re: [PATCH v2 1/3] mac80211: check sta_apply_parameters() return
 value
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1325162501-7996-2-git-send-email-eliad@wizery.com> (sfid-20111229_134042_080500_86ED6831)
References: <1325162501-7996-1-git-send-email-eliad@wizery.com>
	 <1325162501-7996-2-git-send-email-eliad@wizery.com>
	 (sfid-20111229_134042_080500_86ED6831)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Jan 2012 11:39:48 +0100
Message-ID: <1325500788.3643.0.camel@jlt3.sipsolutions.net> (sfid-20120102_114013_491124_A6B6D451)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-29 at 14:41 +0200, Eliad Peller wrote:
> Bail out if sta_apply_parameters() returns an error.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>

Good catch,

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/cfg.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 662125d..1c5388d 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -1001,6 +1001,7 @@ static int ieee80211_change_station(struct wiphy *wiphy,
>  	struct ieee80211_local *local = wiphy_priv(wiphy);
>  	struct sta_info *sta;
>  	struct ieee80211_sub_if_data *vlansdata;
> +	int err;
>  
>  	mutex_lock(&local->sta_mtx);
>  
> @@ -1040,7 +1041,11 @@ static int ieee80211_change_station(struct wiphy *wiphy,
>  		ieee80211_send_layer2_update(sta);
>  	}
>  
> -	sta_apply_parameters(local, sta, params);
> +	err = sta_apply_parameters(local, sta, params);
> +	if (err) {
> +		mutex_unlock(&local->sta_mtx);
> +		return err;
> +	}
>  
>  	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) && params->supported_rates)
>  		rate_control_rate_init(sta);


