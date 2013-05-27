Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51614 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268Ab3E0IuU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 04:50:20 -0400
Message-ID: <1369644617.8229.9.camel@jlt4.sipsolutions.net> (sfid-20130527_105034_565223_1140479D)
Subject: Re: [PATCH 2/3] mac80211: support active monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 May 2013 10:50:17 +0200
In-Reply-To: <1369577107-87931-2-git-send-email-nbd@openwrt.org>
References: <1369577107-87931-1-git-send-email-nbd@openwrt.org>
	 <1369577107-87931-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-05-26 at 16:05 +0200, Felix Fietkau wrote:

>  	if (WARN_ON(sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
>  		    (sdata->vif.type == NL80211_IFTYPE_MONITOR &&
> -		     !(local->hw.flags & IEEE80211_HW_WANT_MONITOR_VIF))))
> +		     !(local->hw.flags & IEEE80211_HW_WANT_MONITOR_VIF) &&
> +			 !(sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE))))
>  		return -EINVAL;

bad indentation

> +++ b/net/mac80211/iface.c
> @@ -209,9 +209,11 @@ static int ieee80211_change_mac(struct net_device *dev, void *addr)
>  	if (ieee80211_sdata_running(sdata))
>  		return -EBUSY;
>  
> -	ret = ieee80211_verify_mac(sdata->local, sa->sa_data);
> -	if (ret)
> -		return ret;
> +	if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
> +		ret = ieee80211_verify_mac(sdata->local, sa->sa_data);
> +		if (ret)
> +			return ret;
> +	}

I'm not convinced this makes sense, why would you want to have a monitor
with an invalid address? I'd rather not allow that, having e.g. a
multicast address that is ACK'ing frames would be very very strange.
 
> @@ -479,9 +481,13 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
>  	case NL80211_IFTYPE_AP:
>  		sdata->bss = &sdata->u.ap;
>  		break;
> +	case NL80211_IFTYPE_MONITOR:
> +		if ((sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE) &&
> +		    !(local->hw.flags & IEEE80211_HW_SUPPORTS_ACTIVE_MONITOR))
> +			return -EOPNOTSUPP;

How can you even get here? Shouldn't you just disallow setting the flag
unless it's supported?

> -		if (local->monitors == 0 && local->open_count == 0) {
> +		if (sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE) {
> +			res = drv_add_interface(local, sdata);
> +			if (res)
> +				goto err_stop;
> +
> +			local->active_mntrs++;

Did I miss something, or don't you use the counter?

johannes

