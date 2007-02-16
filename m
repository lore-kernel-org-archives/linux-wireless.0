Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946059AbXBPTIy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 14:08:54 -0500
Subject: Re: [PATCH 09/10] cfg80211: pending config
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>
In-Reply-To: <20070215144300.419560000@sipsolutions.net>
References: <20070215144241.847938000@sipsolutions.net>
	 <20070215144300.419560000@sipsolutions.net>
Content-Type: text/plain
Date: Fri, 16 Feb 2007 14:10:56 -0500
Message-Id: <1171653056.4153.38.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-02-15 at 15:42 +0100, Johannes Berg wrote:
> plain text document attachment (009-pending-config.patch)
> This introduces the pending config (not used yet) and by doing so
> fixes the memory leak in the wext compat code.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> 
> ---
>  include/net/cfg80211.h     |    4 ++-
>  include/net/wireless.h     |    3 ++
>  net/wireless/core.h        |    5 ----
>  net/wireless/nl80211.c     |    2 -
>  net/wireless/wext-compat.c |   46 +++++----------------------------------------
>  5 files changed, 13 insertions(+), 47 deletions(-)
> 
> --- wireless-dev.orig/include/net/wireless.h	2007-02-15 13:23:41.937940064 +0100
> +++ wireless-dev/include/net/wireless.h	2007-02-15 13:23:43.707940064 +0100
> @@ -45,6 +45,9 @@ struct wiphy {
>   */
>  struct wireless_dev {
>  	struct wiphy *wiphy;
> +
> +	/* private to the generic wireless code */
> +	struct cfg80211_config pending_config;
>  };
>  
>  /**
> --- wireless-dev.orig/include/net/cfg80211.h	2007-02-15 13:23:41.967940064 +0100
> +++ wireless-dev/include/net/cfg80211.h	2007-02-15 13:23:43.707940064 +0100
> @@ -11,6 +11,8 @@
>   * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
>   */
>  
> +#define SSID_MAX_LEN	32
> +

This has _got_ to be defined somewhere else in the stack?  Can we use
that define, or is it being moved to here?  Seems a shame to have it
more than one place.

On a side note, many many drivers need something like this, and many
many drivers redefine it internally.  Is there some header that all
drivers (even fullmac like airo, orinoco, atmel, and libertas) can get
this from?

>  /**
>   * struct cfg80211_config - description of a configuration (request)
>   */
> @@ -19,7 +21,7 @@ struct cfg80211_config {
>  	u32 valid;
>  
>  	s8 ssid_len;
> -	u8 *ssid;
> +	u8 ssid[SSID_MAX_LEN];
>  
>  	u16 network_id;
>  	s32 rx_sensitivity;
> --- wireless-dev.orig/net/wireless/core.h	2007-02-15 13:23:42.037940064 +0100
> +++ wireless-dev/net/wireless/core.h	2007-02-15 13:23:43.707940064 +0100
> @@ -24,11 +24,6 @@ struct cfg80211_registered_device {
>  	/* wiphy index, internal only */
>  	int idx;
>  
> -#ifdef CONFIG_CFG80211_WEXT_COMPAT
> -	/* wext compat */
> -	struct cfg80211_config *wext_pending_config;
> -#endif
> -
>  	/* must be last because of the way we do wiphy_priv(),
>  	 * and it should at least be aligned to NETDEV_ALIGN */
>  	struct wiphy wiphy __attribute__((__aligned__(NETDEV_ALIGN)));
> --- wireless-dev.orig/net/wireless/nl80211.c	2007-02-15 13:23:42.137940064 +0100
> +++ wireless-dev/net/wireless/nl80211.c	2007-02-15 13:23:43.717940064 +0100
> @@ -389,8 +389,8 @@ static int nl80211_configure(struct sk_b
>  
>  	attr = info->attrs[NL80211_ATTR_SSID];
>  	if (attr) {
> -		config.ssid = nla_data(attr);
>  		config.ssid_len = nla_len(attr);
> +		memcpy(config.ssid, nla_data(attr), config.ssid_len);
>  	}
>  
>  	attr = info->attrs[NL80211_ATTR_NETWORK_ID];
> --- wireless-dev.orig/net/wireless/wext-compat.c	2007-02-15 13:23:42.207940064 +0100
> +++ wireless-dev/net/wireless/wext-compat.c	2007-02-15 13:23:43.717940064 +0100
> @@ -10,26 +10,16 @@
>   *
>   * Theory of operation, so to speak:
>   *
> - * To implement compatibility, I added a new field to struct net_device
> - * that contains the pending configuration structure. This is dynamically
> - * allocated when needed and freed when committed.
> - *
>   * Commit is done some time after the last parameter was changed
>   * (with each parameter change simply (re-)schedule a timer) or
>   * if explicitly asked for. This is probably not what most people
>   * would expect, but perfectly fine in the WE API.
>   *
> - * NB: we leak memory if the user
> - *      - changes some settings
> - *      - quickly rmmod's the module so that the net device is destroyed
> - * Since only root can do it and I don't see a way to hook into
> - * the net device's destruction... tough.
> - *
> - * NB2: Note that each of the wrappers should check if the cfg80211
> + * NB: Note that each of the wrappers should check if the cfg80211
>   * user provides the command, and for configure() it must also check
>   * if that parameter can be set or not via get_config_valid()
>   *
> - * NB3: It's really bad that we can't report an error from the timer-
> + * NB2: It's really bad that we can't report an error from the timer-
>   * based commit... Hopefully get_config_valid() can catch everything?

Well, we'd have two choices; first, a netlink notification that the
config was unsuccessful, or second a WEXT SIOCSIWAP event of
00:00:00:xxx for WE compat.  Why wouldn't one of those work?

Dan

>   *
>   * see set_essid for an example
> @@ -67,17 +57,9 @@ static void cfg80211_wx_start_commit_tim
>  	 * as well as taking the rtnl lock (due to wext)! */
>  }
>  
> -static struct cfg80211_config *cfg80211_ensure_pending_cfg(
> -	struct cfg80211_registered_device *drv)
> +static struct cfg80211_config *get_pending_cfg(struct net_device *dev)
>  {
> -	struct cfg80211_config *cfg = drv->wext_pending_config;
> -	if (!cfg)
> -		cfg = kmalloc(sizeof(*cfg)+32, GFP_KERNEL);
> -	if (cfg) {
> -		cfg->ssid = (char*)cfg + sizeof(*cfg);
> -		drv->wext_pending_config = cfg;
> -	}
> -	return cfg;
> +	return &dev->ieee80211_ptr->pending_config;
>  }
>  
>  static int cfg80211_wx_set_commit(struct cfg80211_registered_device *drv,
> @@ -86,20 +68,8 @@ static int cfg80211_wx_set_commit(struct
>  				  union iwreq_data *data,
>  				  char *extra)
>  {
> -	int err;
> -
> -	if (!drv->wext_pending_config) {
> -		err = 0;
> -		goto out;
> -	}
> -
> -	err = drv->ops->configure(&drv->wiphy, net_dev,
> -				  drv->wext_pending_config);
> -
> -	kfree(drv->wext_pending_config);
> -	drv->wext_pending_config = NULL;
> +	int err = -EOPNOTSUPP;
>  
> - out:
>  	return err;
>  }
>  
> @@ -317,11 +287,7 @@ static int cfg80211_wx_set_essid(struct 
>  			& CFG80211_CFG_VALID_SSID))
>  		goto out;
>  
> -	cfg = cfg80211_ensure_pending_cfg(drv);
> -	if (!cfg) {
> -		err = -ENOMEM;
> -		goto out;
> -	}
> +	cfg = get_pending_cfg(net_dev);
>  
>  	memcpy(cfg->ssid, extra, data->essid.length);
>  	cfg->ssid_len = data->essid.length;
> 
> --
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

