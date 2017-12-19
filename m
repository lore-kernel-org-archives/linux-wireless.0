Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35772 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933388AbdLSJxc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 04:53:32 -0500
Message-ID: <1513677210.26145.10.camel@sipsolutions.net> (sfid-20171219_105337_622327_2ACDEC26)
Subject: Re: [PATCH] mac80211: Fix setting TX power on monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter =?ISO-8859-1?Q?Gro=DFe?= <pegro@friiks.de>,
        linux-wireless@vger.kernel.org
Date: Tue, 19 Dec 2017 10:53:30 +0100
In-Reply-To: <20171213172946.19976-1-pegro@friiks.de>
References: <1512849236.26976.43.camel@sipsolutions.net>
         <20171213172946.19976-1-pegro@friiks.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Since monitor_sdata->vif.type is also NL80211_IFTYPE_MONITOR,
> the warning would still appear with the patch to cfg.c, so I excluded 
> that case from the WARN_ON_ONCE condition.
> 
> I hope that makes sense?!

Yeah, looks good.

>  	if (wdev) {
>  		sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
>  
> +		if (sdata->vif.type == NL80211_IFTYPE_MONITOR) {
> +			sdata = rtnl_dereference(local->monitor_sdata);
> +			if (!sdata)
> +				return -EOPNOTSUPP;
> +		}

This part makes perfect sense.

>  	mutex_lock(&local->iflist_mtx);
>  	list_for_each_entry(sdata, &local->interfaces, list) {
> +		if (sdata->vif.type == NL80211_IFTYPE_MONITOR) {
> +			has_monitor = true;
> +			continue;
> +		}
>  		sdata->user_power_level = local->user_power_level;
>  		if (txp_type != sdata->vif.bss_conf.txpower_type)
>  			update_txp_type = true;
>  		sdata->vif.bss_conf.txpower_type = txp_type;
>  	}
> -	list_for_each_entry(sdata, &local->interfaces, list)
> +	list_for_each_entry(sdata, &local->interfaces, list) {
> +		if (sdata->vif.type == NL80211_IFTYPE_MONITOR)
> +			continue;
>  		ieee80211_recalc_txpower(sdata, update_txp_type);
> +	}
>  	mutex_unlock(&local->iflist_mtx);
>  
> +	if (has_monitor) {
> +		sdata = rtnl_dereference(local->monitor_sdata);
> +		if (sdata) {
> +			sdata->user_power_level = local->user_power_level;
> +			if (txp_type != sdata->vif.bss_conf.txpower_type)
> +				update_txp_type = true;
> +			sdata->vif.bss_conf.txpower_type = txp_type;
> +
> +			ieee80211_recalc_txpower(sdata, update_txp_type);
> +		}
> +	}

But do we really need this? I think we can probably live with just not
having monitor handled here, i.e. only have the "if monitor continue;"
part?

johannes
