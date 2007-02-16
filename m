Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:57881 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932510AbXBPRP7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 12:15:59 -0500
Date: Fri, 16 Feb 2007 18:15:55 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: Support automatic channel/BSSID/SSID  configuration
Message-ID: <20070216181555.71c440bd@griffin.suse.cz>
In-Reply-To: <200702110326.21623.flamingice@sourmilk.net>
References: <200702110326.21623.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 11 Feb 2007 03:26:17 -0500, Michael Wu wrote:
> [...]
> --- a/net/d80211/ieee80211_ioctl.c
> +++ b/net/d80211/ieee80211_ioctl.c
> [...]
> @@ -1887,7 +1903,12 @@ static int ieee80211_ioctl_siwessid(stru
>  			sdata->u.sta.ssid_len = len;
>  			return 0;
>  		}
> -		return ieee80211_sta_set_ssid(dev, ssid, len);
> +		sdata->u.sta.auto_ssid_sel = !data->flags;

Shouldn't be just some bit tested here?

> +		ret = ieee80211_sta_set_ssid(dev, ssid, len);
> +		if (ret)
> +			return ret;
> +		ieee80211_sta_req_auth(dev, &sdata->u.sta);
> +		return 0;
>  	}
>  
>  	if (sdata->type == IEEE80211_IF_TYPE_AP) {
> @@ -1943,12 +1964,24 @@ static int ieee80211_ioctl_siwap(struct
>  	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>  	if (sdata->type == IEEE80211_IF_TYPE_STA ||
>  	    sdata->type == IEEE80211_IF_TYPE_IBSS) {
> +		int ret;
>  		if (local->user_space_mlme) {
>  			memcpy(sdata->u.sta.bssid, (u8 *) &ap_addr->sa_data,
>  			       ETH_ALEN);
>  			return 0;
>  		}
> -		return ieee80211_sta_set_bssid(dev, (u8 *) &ap_addr->sa_data);
> +		if (is_zero_ether_addr((u8 *) &ap_addr->sa_data)) {
> +			sdata->u.sta.auto_bssid_sel = 1;
> +			sdata->u.sta.auto_channel_sel = 1;
> +		} else if (is_broadcast_ether_addr((u8 *) &ap_addr->sa_data))
> +			sdata->u.sta.auto_bssid_sel = 1;
> +		else
> +			sdata->u.sta.auto_bssid_sel = 0;
> +		ret = ieee80211_sta_set_bssid(dev, (u8 *) &ap_addr->sa_data);

u.sta.bssid_set is set in ieee80211_sta_set_bssid only and solely based
on sa_data address containing all zeros. Shouldn't it be set on
broadcast address too?

> +		if (ret)
> +			return ret;
> +		ieee80211_sta_req_auth(dev, &sdata->u.sta);
> +		return 0;
>  	} else if (sdata->type == IEEE80211_IF_TYPE_WDS) {
>  		if (memcmp(sdata->u.wds.remote_addr, (u8 *) &ap_addr->sa_data,
>  			   ETH_ALEN) == 0)
> diff --git a/net/d80211/ieee80211_sta.c b/net/d80211/ieee80211_sta.c
> index 0b56135..78d5cf5 100644
> --- a/net/d80211/ieee80211_sta.c
> +++ b/net/d80211/ieee80211_sta.c
> [...]
> @@ -1924,8 +1925,9 @@ void ieee80211_sta_work(struct work_stru
>  	}
>  
>  	if (test_and_clear_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request)) {
> -		ifsta->state = IEEE80211_AUTHENTICATE;
> -		ieee80211_sta_reset_auth(dev, ifsta);
> +		if (ieee80211_sta_config_auth(dev, ifsta))
> +			return;
> +		clear_bit(IEEE80211_STA_REQ_RUN, &ifsta->request);

Shouldn't we return immediatelly or something when a scan was requested
by ieee80211_sta_config_auth?

>  	} else if (!test_and_clear_bit(IEEE80211_STA_REQ_RUN, &ifsta->request))
>  		return;
>  
> [...]
> +static int ieee80211_sta_config_auth(struct net_device *dev,
> +				     struct ieee80211_if_sta *ifsta)
> +{
> +	struct ieee80211_local *local = dev->ieee80211_ptr;
> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	struct ieee80211_sta_bss *bss, *selected = NULL;
> +	int top_rssi = 0, freq;
> +
> +	if (!ifsta->auto_channel_sel && !ifsta->auto_bssid_sel &&
> +	    !ifsta->auto_ssid_sel) {
> +		ifsta->state = IEEE80211_AUTHENTICATE;
> +		ieee80211_sta_reset_auth(dev, ifsta);
> +		return 0;
> +	}
> +
> +	spin_lock_bh(&local->sta_bss_lock);
> +	freq = local->oper_channel->freq;
> +	list_for_each_entry(bss, &local->sta_bss_list, list) {
> +		if (!(bss->capability & WLAN_CAPABILITY_ESS))
> +			continue;
> +
> +		if (!!(bss->capability & WLAN_CAPABILITY_PRIVACY) ^
> +		    !!sdata->default_key)
> +			continue;
> +
> +		if (!ifsta->auto_channel_sel && bss->freq != freq)
> +			continue;
> +
> +		if (!ifsta->auto_bssid_sel &&
> +		    memcmp(bss->bssid, ifsta->bssid, ETH_ALEN))
> +			continue;
> +
> +		if (!ifsta->auto_ssid_sel &&
> +		    !ieee80211_sta_match_ssid(ifsta, bss->ssid, bss->ssid_len))
> +			continue;
> +
> +		if (top_rssi < bss->rssi)
> +			selected = bss;
> +	}

Seems like you forget to update top_rssi.

> +
> +	if (selected) {
> +		atomic_inc(&selected->users);
> +		spin_unlock_bh(&local->sta_bss_lock);
> +
> +		ieee80211_set_channel(local, -1, selected->freq);
> +		if (!ifsta->ssid_set)
> +			ieee80211_sta_set_ssid(dev, selected->ssid,
> +					       selected->ssid_len);
> +		ieee80211_sta_set_bssid(dev, selected->bssid);
> +		ieee80211_rx_bss_put(dev, selected);
> +		ifsta->state = IEEE80211_AUTHENTICATE;
> +		ieee80211_sta_reset_auth(dev, ifsta);
> +		return 0;
> +	} else {
> +		spin_unlock_bh(&local->sta_bss_lock);
> +		if (ifsta->state != IEEE80211_AUTHENTICATE) {
> +			ieee80211_sta_start_scan(dev, NULL, 0);;
> +			ifsta->state = IEEE80211_AUTHENTICATE;
> +			set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
> +		} else
> +			ifsta->state = IEEE80211_DISABLED;
> +	}

if (selected)
	atomic_inc(...);
spin_unlock(...);
if (selected) {
	...

I'd consider less error prone.


Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
