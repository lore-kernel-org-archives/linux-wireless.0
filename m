Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56173 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2LUOdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2012 09:33:09 -0500
Message-ID: <1356100396.9580.10.camel@jlt4.sipsolutions.net> (sfid-20121221_153314_272784_F114D592)
Subject: Re: [PATCH v2 1/3] mac80211_hwsim: use hrtimer for beacon timers
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linville@tuxdriver.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com, j@wl.fi
Date: Fri, 21 Dec 2012 15:33:16 +0100
In-Reply-To: <1356029871-17794-1-git-send-email-thomas@cozybit.com> (sfid-20121220_195824_731125_DAECB6B9)
References: <1356029871-17794-1-git-send-email-thomas@cozybit.com>
	 (sfid-20121220_195824_731125_DAECB6B9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-20 at 10:57 -0800, Thomas Pedersen wrote:

> @@ -896,7 +897,8 @@ static void mac80211_hwsim_stop(struct ieee80211_hw *hw)
>  {
>  	struct mac80211_hwsim_data *data = hw->priv;
>  	data->started = false;
> -	del_timer(&data->beacon_timer);
> +	hrtimer_cancel(&data->beacon_timer);
> +	tasklet_kill(&data->bcn_tasklet);
>  	wiphy_debug(hw->wiphy, "%s\n", __func__);

Hm this seems odd, why is it stopped here rather than when beaconing is
stopped? Or does it do both?

> @@ -1084,12 +1096,12 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
>  
>  	if (changed & BSS_CHANGED_BEACON_INT) {
>  		wiphy_debug(hw->wiphy, "  BCNINT: %d\n", info->beacon_int);
> -		data->beacon_int = 1024 * info->beacon_int / 1000 * HZ / 1000;
> -		if (WARN_ON(!data->beacon_int))
> -			data->beacon_int = 1;
> -		if (data->started)
> -			mod_timer(&data->beacon_timer,
> -				  jiffies + data->beacon_int);
> +		data->beacon_int = ns_to_ktime(info->beacon_int * 1024 * 1000);
> +		if (WARN_ON(!ktime_to_ns(data->beacon_int)))
> +			data->beacon_int = ns_to_ktime(1000 * 1000);

Can that warning really happen? It seems it should be checking
info->beacon_int rather than data->beacon_int? Why convert back and
forth?

Also the default here seems very very small, that's like less than 1ms
beacon interval (not even in TU)?

johannes

