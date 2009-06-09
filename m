Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45945 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZFITJv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 15:09:51 -0400
Subject: Re: [PATCH] cfg80211: pass netdev to change_virtual_intf
From: Samuel Ortiz <samuel@sortiz.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1244574283.18481.29.camel@johannes.local>
References: <1244574283.18481.29.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 09 Jun 2009 21:11:54 +0200
Message-Id: <1244574714.2628.1.camel@sortiz-mobl>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-06-09 at 21:04 +0200, Johannes Berg wrote:
> If there was a reason I'm passing the ifidx I cannot
> remember it any more and don't see one now, so let's
> just pass the pointer itself.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
For the iwmc part:
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

> ---
>  drivers/net/wireless/iwmc3200wifi/cfg80211.c |    9 ++-------
>  include/net/cfg80211.h                       |    3 ++-
>  net/mac80211/cfg.c                           |    9 ++-------
>  net/wireless/nl80211.c                       |   12 +++++-------
>  net/wireless/wext-compat.c                   |    2 +-
>  5 files changed, 12 insertions(+), 23 deletions(-)
> 
> --- wireless-testing.orig/include/net/cfg80211.h	2009-06-09 20:56:03.000000000 +0200
> +++ wireless-testing/include/net/cfg80211.h	2009-06-09 20:56:47.000000000 +0200
> @@ -866,7 +866,8 @@ struct cfg80211_ops {
>  				    enum nl80211_iftype type, u32 *flags,
>  				    struct vif_params *params);
>  	int	(*del_virtual_intf)(struct wiphy *wiphy, int ifindex);
> -	int	(*change_virtual_intf)(struct wiphy *wiphy, int ifindex,
> +	int	(*change_virtual_intf)(struct wiphy *wiphy,
> +				       struct net_device *dev,
>  				       enum nl80211_iftype type, u32 *flags,
>  				       struct vif_params *params);
>  
> --- wireless-testing.orig/net/mac80211/cfg.c	2009-06-09 20:56:54.000000000 +0200
> +++ wireless-testing/net/mac80211/cfg.c	2009-06-09 20:57:06.000000000 +0200
> @@ -74,19 +74,14 @@ static int ieee80211_del_iface(struct wi
>  	return 0;
>  }
>  
> -static int ieee80211_change_iface(struct wiphy *wiphy, int ifindex,
> +static int ieee80211_change_iface(struct wiphy *wiphy,
> +				  struct net_device *dev,
>  				  enum nl80211_iftype type, u32 *flags,
>  				  struct vif_params *params)
>  {
> -	struct net_device *dev;
>  	struct ieee80211_sub_if_data *sdata;
>  	int ret;
>  
> -	/* we're under RTNL */
> -	dev = __dev_get_by_index(&init_net, ifindex);
> -	if (!dev)
> -		return -ENODEV;
> -
>  	if (!nl80211_type_check(type))
>  		return -EINVAL;
>  
> --- wireless-testing.orig/net/wireless/nl80211.c	2009-06-09 20:57:19.000000000 +0200
> +++ wireless-testing/net/wireless/nl80211.c	2009-06-09 21:02:33.000000000 +0200
> @@ -766,7 +766,7 @@ static int nl80211_set_interface(struct 
>  {
>  	struct cfg80211_registered_device *drv;
>  	struct vif_params params;
> -	int err, ifindex;
> +	int err;
>  	enum nl80211_iftype otype, ntype;
>  	struct net_device *dev;
>  	u32 _flags, *flags = NULL;
> @@ -780,9 +780,7 @@ static int nl80211_set_interface(struct 
>  	if (err)
>  		goto unlock_rtnl;
>  
> -	ifindex = dev->ifindex;
>  	otype = ntype = dev->ieee80211_ptr->iftype;
> -	dev_put(dev);
>  
>  	if (info->attrs[NL80211_ATTR_IFTYPE]) {
>  		ntype = nla_get_u32(info->attrs[NL80211_ATTR_IFTYPE]);
> @@ -825,20 +823,20 @@ static int nl80211_set_interface(struct 
>  	}
>  
>  	if (change)
> -		err = drv->ops->change_virtual_intf(&drv->wiphy, ifindex,
> +		err = drv->ops->change_virtual_intf(&drv->wiphy, dev,
>  						    ntype, flags, &params);
>  	else
>  		err = 0;
>  
> -	dev = __dev_get_by_index(&init_net, ifindex);
> -	WARN_ON(!dev || (!err && dev->ieee80211_ptr->iftype != ntype));
> +	WARN_ON(!err && dev->ieee80211_ptr->iftype != ntype);
>  
> -	if (dev && !err && (ntype != otype)) {
> +	if (!err && (ntype != otype)) {
>  		if (otype == NL80211_IFTYPE_ADHOC)
>  			cfg80211_clear_ibss(dev, false);
>  	}
>  
>   unlock:
> +	dev_put(dev);
>  	cfg80211_put_dev(drv);
>   unlock_rtnl:
>  	rtnl_unlock();
> --- wireless-testing.orig/net/wireless/wext-compat.c	2009-06-09 20:59:03.000000000 +0200
> +++ wireless-testing/net/wireless/wext-compat.c	2009-06-09 20:59:14.000000000 +0200
> @@ -103,7 +103,7 @@ int cfg80211_wext_siwmode(struct net_dev
>  
>  	memset(&vifparams, 0, sizeof(vifparams));
>  
> -	ret = rdev->ops->change_virtual_intf(wdev->wiphy, dev->ifindex, type,
> +	ret = rdev->ops->change_virtual_intf(wdev->wiphy, dev, type,
>  					     NULL, &vifparams);
>  	WARN_ON(!ret && wdev->iftype != type);
>  
> --- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/cfg80211.c	2009-06-09 20:59:44.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/iwmc3200wifi/cfg80211.c	2009-06-09 21:00:02.000000000 +0200
> @@ -167,20 +167,15 @@ int iwm_cfg80211_inform_bss(struct iwm_p
>  	return 0;
>  }
>  
> -static int iwm_cfg80211_change_iface(struct wiphy *wiphy, int ifindex,
> +static int iwm_cfg80211_change_iface(struct wiphy *wiphy,
> +				     struct net_device *ndev,
>  				     enum nl80211_iftype type, u32 *flags,
>  				     struct vif_params *params)
>  {
> -	struct net_device *ndev;
>  	struct wireless_dev *wdev;
>  	struct iwm_priv *iwm;
>  	u32 old_mode;
>  
> -	/* we're under RTNL */
> -	ndev = __dev_get_by_index(&init_net, ifindex);
> -	if (!ndev)
> -		return -ENODEV;
> -
>  	wdev = ndev->ieee80211_ptr;
>  	iwm = ndev_to_iwm(ndev);
>  	old_mode = iwm->conf.mode;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

