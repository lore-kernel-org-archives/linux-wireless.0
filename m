Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:63098 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2LVEkR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2012 23:40:17 -0500
Received: by mail-vc0-f176.google.com with SMTP id fo13so5795041vcb.7
        for <linux-wireless@vger.kernel.org>; Fri, 21 Dec 2012 20:40:16 -0800 (PST)
Message-ID: <50D537EE.7030803@gmail.com> (sfid-20121222_054025_325690_CE76FF5F)
Date: Fri, 21 Dec 2012 23:32:46 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] mac80211/cfg80211: report monitor channel in wireless
 extensions
References: <1320778327.24797.36.camel@jlt3.sipsolutions.net>  (sfid-20111108_195213_970616_E8AF4017)  <1320778887.24797.38.camel@jlt3.sipsolutions.net>  (sfid-20111108_200133_998551_FF45D33D) <1320831021.3845.14.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320831021.3845.14.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/09/2011 04:30 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>

Johannes,

This patch has been great for us since it was added in 3.3_rc1, however,
it looks like there was some rewrite in 3.7_rc1 and this is no longer
functional.  I'm not really the guy that understands the code, but I'm
hoping you will have mercy on us again and maybe take a look? :-)

Thanks,
Zero

> 
> Just add API to get the channel & report it. Trivial really.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> So trivial it didn't even work ;-)
> 
>  include/net/cfg80211.h     |    5 +++++
>  net/mac80211/cfg.c         |    9 +++++++++
>  net/wireless/wext-compat.c |   12 ++++++++++++
>  3 files changed, 26 insertions(+)
> 
> --- a/include/net/cfg80211.h	2011-11-09 10:13:05.000000000 +0100
> +++ b/include/net/cfg80211.h	2011-11-09 10:27:47.000000000 +0100
> @@ -1342,6 +1342,9 @@ struct cfg80211_gtk_rekey_data {
>   *	doesn't verify much. Note, however, that the passed netdev may be
>   *	%NULL as well if the user requested changing the channel for the
>   *	device itself, or for a monitor interface.
> + * @get_channel: Get the current operating channel, should return %NULL if
> + *	there's no single defined operating channel if for example the
> + *	device implements channel hopping for multi-channel virtual interfaces.
>   *
>   * @scan: Request to do a scan. If returning zero, the scan request is given
>   *	the driver, and will be valid until passed to cfg80211_scan_done().
> @@ -1627,6 +1630,8 @@ struct cfg80211_ops {
>  
>  	int	(*probe_client)(struct wiphy *wiphy, struct net_device *dev,
>  				const u8 *peer, u64 *cookie);
> +
> +	struct ieee80211_channel *(*get_channel)(struct wiphy *wiphy);
>  };
>  
>  /*
> --- a/net/wireless/wext-compat.c	2011-11-09 10:07:35.000000000 +0100
> +++ b/net/wireless/wext-compat.c	2011-11-09 10:13:18.000000000 +0100
> @@ -819,12 +819,24 @@ static int cfg80211_wext_giwfreq(struct
>  				 struct iw_freq *freq, char *extra)
>  {
>  	struct wireless_dev *wdev = dev->ieee80211_ptr;
> +	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
> +	struct ieee80211_channel *chan;
>  
>  	switch (wdev->iftype) {
>  	case NL80211_IFTYPE_STATION:
>  		return cfg80211_mgd_wext_giwfreq(dev, info, freq, extra);
>  	case NL80211_IFTYPE_ADHOC:
>  		return cfg80211_ibss_wext_giwfreq(dev, info, freq, extra);
> +	case NL80211_IFTYPE_MONITOR:
> +		if (!rdev->ops->get_channel)
> +			return -EINVAL;
> +
> +		chan = rdev->ops->get_channel(wdev->wiphy);
> +		if (!chan)
> +			return -EINVAL;
> +		freq->m = chan->center_freq;
> +		freq->e = 6;
> +		return 0;
>  	default:
>  		if (!wdev->channel)
>  			return -EINVAL;
> --- a/net/mac80211/cfg.c	2011-11-09 10:10:56.000000000 +0100
> +++ b/net/mac80211/cfg.c	2011-11-09 10:29:40.000000000 +0100
> @@ -2579,6 +2579,14 @@ static int ieee80211_probe_client(struct
>  	return 0;
>  }
>  
> +static struct ieee80211_channel *
> +ieee80211_wiphy_get_channel(struct wiphy *wiphy)
> +{
> +	struct ieee80211_local *local = wiphy_priv(wiphy);
> +
> +	return local->oper_channel;
> +}
> +
>  struct cfg80211_ops mac80211_config_ops = {
>  	.add_virtual_intf = ieee80211_add_iface,
>  	.del_virtual_intf = ieee80211_del_iface,
> @@ -2645,4 +2653,5 @@ struct cfg80211_ops mac80211_config_ops
>  	.tdls_oper = ieee80211_tdls_oper,
>  	.tdls_mgmt = ieee80211_tdls_mgmt,
>  	.probe_client = ieee80211_probe_client,
> +	.get_channel = ieee80211_wiphy_get_channel,
>  };
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

