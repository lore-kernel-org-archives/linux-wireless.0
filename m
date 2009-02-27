Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:36354 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174AbZB0OEz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 09:04:55 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Alina Friedrichsen" <x-alina@gmx.net>
Subject: Re: [PATCH v2] mac80211: Call commit() on channel setting
Date: Fri, 27 Feb 2009 15:03:13 +0100
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
References: <20090226234307.51520@gmx.net>
In-Reply-To: <20090226234307.51520@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200902271503.13308.mb@bu3sch.de> (sfid-20090227_150458_168163_DB6EBEB5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 27 February 2009 00:43:07 Alina Friedrichsen wrote:
> This calls commit() on all logical interfaces of a physical interface, if the channel of it is changed. Before it works as it should, I must fix the joining process of STA and IBSS a little, which I will make tomorrow.


Could you explain what commit is supposed to to after the channel switch?
To me it's not clear what the difference in functionality is.
What do you expect to happen on the commit call after the channel change.

> Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
> ---
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index c43129e..015062e 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -1173,11 +1173,19 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
>  				 enum nl80211_channel_type channel_type)
>  {
>  	struct ieee80211_local *local = wiphy_priv(wiphy);
> +	struct ieee80211_sub_if_data *sdata;
> +	int ret;
>  
>  	local->oper_channel = chan;
>  	local->oper_channel_type = channel_type;
>  
> -	return ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
> +	ret = ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
> +
> +	list_for_each_entry(sdata, &local->interfaces, list) {
> +		ieee80211_commit(sdata);
> +	}

Why do you commit, even if channel change failed?

> +
> +	return ret;
>  }
>  
>  static int set_mgmt_extra_ie_sta(struct ieee80211_sub_if_data *sdata,
> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> index 1ac0516..dce1618 100644
> --- a/net/mac80211/wext.c
> +++ b/net/mac80211/wext.c
> @@ -157,7 +157,10 @@ static int ieee80211_ioctl_siwfreq(struct net_device *dev,
>  				   struct iw_request_info *info,
>  				   struct iw_freq *freq, char *extra)
>  {
> +	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
>  	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	struct ieee80211_sub_if_data *nsdata;
> +	int ret;
>  
>  	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
>  		sdata->u.ibss.flags &= ~IEEE80211_IBSS_AUTO_CHANNEL_SEL;
> @@ -173,19 +176,25 @@ static int ieee80211_ioctl_siwfreq(struct net_device *dev,
>  			else if (sdata->vif.type == NL80211_IFTYPE_STATION)
>  				sdata->u.mgd.flags |=
>  					IEEE80211_STA_AUTO_CHANNEL_SEL;
> -			return 0;
> +			ret = 0;
>  		} else
> -			return ieee80211_set_freq(sdata,
> +			ret = ieee80211_set_freq(sdata,
>  				ieee80211_channel_to_frequency(freq->m));
>  	} else {
>  		int i, div = 1000000;
>  		for (i = 0; i < freq->e; i++)
>  			div /= 10;
>  		if (div > 0)
> -			return ieee80211_set_freq(sdata, freq->m / div);
> +			ret = ieee80211_set_freq(sdata, freq->m / div);
>  		else
> -			return -EINVAL;
> +			ret = -EINVAL;
>  	}
> +
> +	list_for_each_entry(nsdata, &local->interfaces, list) {
> +		ieee80211_commit(nsdata);
> +	}

dito.

> +
> +	return ret;
>  }
>  
>  
> 



-- 
Greetings, Michael.
