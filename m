Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35482 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753310AbeF2J0r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 05:26:47 -0400
Message-ID: <1530264405.3481.31.camel@sipsolutions.net> (sfid-20180629_112652_990870_275D2144)
Subject: Re: [PATCH 1/7] wireless: Change single cqm_config to rssi config
 list
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 29 Jun 2018 11:26:45 +0200
In-Reply-To: <1528886747-26342-2-git-send-email-tamizhr@codeaurora.org>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
         <1528886747-26342-2-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-06-13 at 16:15 +0530, Tamizh chelvam wrote:
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 5fbfe61..3e123a3 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -4139,7 +4139,7 @@ static inline struct wiphy *wiphy_new(const struct cfg80211_ops *ops,
>  struct cfg80211_conn;
>  struct cfg80211_internal_bss;
>  struct cfg80211_cached_keys;
> -struct cfg80211_cqm_config;
> +struct cfg80211_rssi_config;

I think something like rssi_mon_config would be better? Just _rssi_
could be interpreted in many ways.
 
> -	struct cfg80211_cqm_config *cqm_config;
> +	struct cfg80211_rssi_config *rssi_config;
> +	struct list_head rssi_config_list;

Why do you need both now? Perhaps instead you should allow a NULL/all-
ones MAC address for where you have the direct pointer now, and remove
that? You anyway need to pass something to the peer argument in

> -void cfg80211_cqm_config_free(struct wireless_dev *wdev)
> +void cfg80211_rssi_config_free(struct wireless_dev *wdev, const u8 *peer)

even when the pointer is used.

> -	kfree(wdev->cqm_config);
> -	wdev->cqm_config = NULL;
> +	struct cfg80211_rssi_config *rssi_config, *tmp;
> +
> +	if (list_empty(&wdev->rssi_config_list))
> +		goto free;
> +
> +	list_for_each_entry_safe(rssi_config, tmp, &wdev->rssi_config_list,
> +				 list) {
> +		if (peer && memcmp(rssi_config->addr, peer, ETH_ALEN))
> +			continue;
> +
> +		list_del(&rssi_config->list);
> +		kfree(rssi_config);
> +		if (list_empty(&wdev->rssi_config_list) || peer)
> +			goto out;
> +	}

That logic could use some comments if we even decide to keep it this
way.

NULL means "free all"?

What's the locking scheme for this? It's way more complex now so perhaps
stick ASSERT_RTNL() in there or so?

> @@ -10140,7 +10141,7 @@ static int cfg80211_cqm_rssi_update(struct cfg80211_registered_device *rdev,
>  	int err;
>  
>  	/* RSSI reporting disabled? */
> -	if (!wdev->cqm_config)
> +	if (!wdev->rssi_config)
>  		return rdev_set_cqm_rssi_range_config(rdev, dev, 0, 0);


So I guess the wdev->rssi_config is used for the case of "always use
this config for any AP you're connected to" or so - but maybe it'd be
better to track the AP as a station? Then again, I guess we can't force
userspace to change that.

> +static struct cfg80211_rssi_config *
> +cfg80211_get_rssi_config(struct wireless_dev *wdev, const s32 *thresholds,
> +			 int n_thresholds, u32 hysteresis, const u8 *peer)
> +{
> +	struct cfg80211_rssi_config *rssi_config;
> +
> +	if (!peer)
> +		return NULL;
> +
> +	if (list_empty(&wdev->rssi_config_list))
> +		goto new;
> +
> +	list_for_each_entry(rssi_config, &wdev->rssi_config_list, list) {
> +		if (!memcmp(rssi_config->addr, peer, ETH_ALEN))
> +			goto found;
> +	}
> +
> +new:
> +	rssi_config = kzalloc(sizeof(struct cfg80211_rssi_config) +
> +			      n_thresholds * sizeof(s32), GFP_KERNEL);
> +	list_add(&rssi_config->list, &wdev->rssi_config_list);

Why does "get" always imply "create"?

>  	wdev_lock(wdev);
>  	if (n_thresholds) {
> -		struct cfg80211_cqm_config *cqm_config;
> -
> -		cqm_config = kzalloc(sizeof(struct cfg80211_cqm_config) +
> -				     n_thresholds * sizeof(s32), GFP_KERNEL);
> -		if (!cqm_config) {
> +		wdev->rssi_config = cfg80211_get_rssi_config(
> +						wdev, thresholds,
> +						n_thresholds, hysteresis,
> +						wdev->current_bss->pub.bssid);

Here you link it to the BSSID anyway, but do we always have a
current_bss at this point?

johannes
