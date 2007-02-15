Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:35749 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161150AbXBOUPd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 15:15:33 -0500
Date: Thu, 15 Feb 2007 21:15:28 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: Simplify channel & mode configuration
Message-ID: <20070215211528.623e1c14@griffin.suse.cz>
In-Reply-To: <200702092343.54479.flamingice@sourmilk.net>
References: <200702092325.39994.flamingice@sourmilk.net>
	<200702092343.54479.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 9 Feb 2007 23:43:50 -0500, Michael Wu wrote:
> --- a/net/d80211/ieee80211.c
> +++ b/net/d80211/ieee80211.c
> @@ -2005,8 +2005,24 @@ int ieee80211_if_config_beacon(struct ne
>  int ieee80211_hw_config(struct ieee80211_local *local)
>  {
>  	struct ieee80211_hw_mode *mode;
> +	struct ieee80211_channel *chan;
>  	int ret = 0;
>  
> +	if (local->sta_scanning) {
> +		chan = local->scan_channel;
> +		mode = local->scan_hw_mode;
> +	} else {
> +		chan = local->oper_channel;
> +		mode = local->oper_hw_mode;
> +	}
> +
> +	local->hw.conf.channel = chan->chan;
> +	local->hw.conf.channel_val = chan->val;
> +	local->hw.conf.power_level = chan->power_level;
> +	local->hw.conf.freq = chan->freq;
> +	local->hw.conf.phymode = mode->mode;
> +	local->hw.conf.antenna_max = chan->antenna_max;

What about passing ieee80211_channel and ieee80211_hw_mode structures
instead of a ton of variables? (Just an idea, not a problem with the
patch.)

> +
>  #ifdef CONFIG_D80211_VERBOSE_DEBUG
>  	printk(KERN_DEBUG "HW CONFIG: channel=%d freq=%d "
>  	       "phymode=%d\n", local->hw.conf.channel, local->hw.conf.freq,
> @@ -2016,16 +2032,11 @@ int ieee80211_hw_config(struct ieee80211
>  	if (local->ops->config)
>  		ret = local->ops->config(local_to_hw(local), &local->hw.conf);
>  
> -	list_for_each_entry(mode, &local->modes_list, list) {
> -		if (mode->mode == local->hw.conf.phymode) {
> -			if (local->curr_rates != mode->rates)
> -				rate_control_clear(local);
> -			local->curr_rates = mode->rates;
> -			local->num_curr_rates = mode->num_rates;
> -			ieee80211_prepare_rates(local);
> -			break;
> -		}
> -	}
> +	if (local->curr_rates != mode->rates)
> +		rate_control_clear(local);
> +	local->curr_rates = mode->rates;
> +	local->num_curr_rates = mode->num_rates;
> +	ieee80211_prepare_rates(local);

This will trigger rate control reinitialization when scanning on abg
cards. It's needed but not obvious at first sight. Perhaps some comment
would be useful here? (Again, not a problem with the patch, just
something I realized looking at the patch and thinking why the hell do
we do the reinitialization here?)

> [...]
> --- a/net/d80211/ieee80211_ioctl.c
> +++ b/net/d80211/ieee80211_ioctl.c
> @@ -1828,20 +1828,18 @@ int ieee80211_ioctl_siwfreq(struct net_d
>  				if (set && mode->mode != local->next_mode)
>  					continue;
>  
> -				local->hw.conf.channel = chan->chan;
> -				local->hw.conf.channel_val = chan->val;
> -                                local->hw.conf.power_level = chan->power_level;
> -				local->hw.conf.freq = chan->freq;
> -				local->hw.conf.phymode = mode->mode;
> -                                local->hw.conf.antenna_max = chan->antenna_max;
> +				local->oper_channel = chan;
> +				local->oper_hw_mode = mode;
>  				set++;
>  			}
>  		}
>  	}
>  
>  	if (set) {
> -		local->sta_scanning = 0; /* Abort possible scan */
> -		return ieee80211_hw_config(local);
> +		if (local->sta_scanning)
> +			return 0;

A comment mentioning that correct channel will be chosen automatically
when the scan is finished would be useful, I think. No need to send a
new patch, though :-)

> +		else
> +			return ieee80211_hw_config(local);


-- 
Jiri Benc
SUSE Labs
