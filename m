Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:53512 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754215AbXDWUlO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 16:41:14 -0400
Date: Mon, 23 Apr 2007 22:41:16 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 03/13] mac80211: fix virtual interface related locking
Message-ID: <20070423224116.03d99954@griffin.suse.cz>
In-Reply-To: <20070423184812.7029.7682.stgit@magic.sourmilk.net>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
	<20070423184812.7029.7682.stgit@magic.sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 23 Apr 2007 14:48:13 -0400, Michael Wu wrote:
> This converts sub_if_lock to a rw lock and makes all code touching
> sub_if_list use it, grabs mdev's tx lock in set_multicast_list to
> synchronize multicast configuration, and simplifies some related code.
> 
> [...]
> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> [...]
> @@ -2148,6 +2148,7 @@ static void ieee80211_set_multicast_list(struct net_device *dev)
>  	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>  	unsigned short flags;
>  
> +	netif_tx_lock(local->mdev);

Shouldn't it be netif_tx_lock_bh?

>  	if (((dev->flags & IFF_ALLMULTI) != 0) ^ (sdata->allmulti != 0)) {
>  		if (sdata->allmulti) {
>  			sdata->allmulti = 0;
> @@ -2177,9 +2178,12 @@ static void ieee80211_set_multicast_list(struct net_device *dev)
>  			flags |= IFF_ALLMULTI;
>  		if (local->iff_promiscs)
>  			flags |= IFF_PROMISC;
> +		read_lock(&local->sub_if_lock);
>  		local->ops->set_multicast_list(local_to_hw(local), flags,
>  					      local->mc_count);

Would be nice to have documented that set_multicast_list is called in
atomic context.

> +		read_unlock(&local->sub_if_lock);
>  	}
> +	netif_tx_unlock(local->mdev);
>  }
>  
>  struct dev_mc_list *ieee80211_get_mc_list_item(struct ieee80211_hw *hw,
> @@ -2220,12 +2224,11 @@ static struct net_device_stats *ieee80211_get_stats(struct net_device *dev)
>  	return &(sdata->stats);
>  }
>  
> -void ieee80211_if_shutdown(struct net_device *dev)
> +static void ieee80211_if_shutdown(struct net_device *dev)
>  {
>  	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
>  	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>  
> -	ASSERT_RTNL();

As you already said, this is not necessary.

> [...]
> @@ -3871,6 +3884,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
>  		struct sk_buff *skb_new;
>  		u8 *bssid = ieee80211_get_bssid(hdr, skb->len - radiotap_len);
>  
> +		read_lock(&local->sub_if_lock);
>  		list_for_each_entry(sdata, &local->sub_if_list, list) {
>  			rx.u.rx.ra_match = 1;
>  			switch (sdata->type) {
> @@ -3906,10 +3920,9 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
>  					rx.u.rx.ra_match = 0;
>  				} else if (!sta)
>  					sta = rx.sta =
> -						ieee80211_ibss_add_sta(local->mdev,
> +						ieee80211_ibss_add_sta(sdata->dev,
>  								       skb, bssid,
>  								       hdr->addr2);
> -						/* FIXME: call with sdata->dev */
>  				break;
>  			case IEEE80211_IF_TYPE_AP:
>  				if (!bssid) {
> @@ -3964,6 +3977,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
>  						     &rx, sta);
>  		} else
>  			dev_kfree_skb(skb);
> +		read_unlock(&local->sub_if_lock);

Documenting that sub_if_lock cannot be taken under sta_bss_lock nor
under sta_lock would be nice.

local->ops->conf_tx and ->set_time are called under spinlock, are we ok with that?

> [...]
> --- a/net/mac80211/ieee80211_ioctl.c
> +++ b/net/mac80211/ieee80211_ioctl.c
> @@ -1003,23 +1003,30 @@ static int ieee80211_ioctl_add_if(struct net_device *dev,
>  		if (left < sizeof(struct hostapd_if_wds))
>  			return -EPROTO;
>  
> -		res = ieee80211_if_add(dev, param->u.if_info.name, 0, &new_dev);
> +		res = ieee80211_if_add(dev, param->u.if_info.name, &new_dev,
> +				       IEEE80211_IF_TYPE_WDS);
>  		if (res)
>  			return res;
> -		ieee80211_if_set_type(new_dev, IEEE80211_IF_TYPE_WDS);
>  		res = ieee80211_if_update_wds(new_dev, wds->remote_addr);
> -		if (res)
> -			__ieee80211_if_del(wdev_priv(dev->ieee80211_ptr),
> -					   IEEE80211_DEV_TO_SUB_IF(new_dev));
> +		if (unlikely(res)) {
> +			struct ieee80211_local *local =
> +				wdev_priv(dev->ieee80211_ptr);
> +			struct ieee80211_sub_if_data *sdata = 
> +				IEEE80211_DEV_TO_SUB_IF(new_dev);
> +			write_lock_bh(&local->sub_if_lock);
> +			list_del(&sdata->list);
> +			write_unlock_bh(&local->sub_if_lock);
> +			__ieee80211_if_del(local, sdata);
> +		}

A good candidate for a separate function :-) But it can be done later
when this is needed at some other place.

>  		return res;
>  	case HOSTAP_IF_VLAN:
>  		if (left < sizeof(struct hostapd_if_vlan))
>  			return -EPROTO;
>  
> -		res = ieee80211_if_add(dev, param->u.if_info.name, 0, &new_dev);
> +		res = ieee80211_if_add(dev, param->u.if_info.name, NULL,
> +				       IEEE80211_IF_TYPE_VLAN);
>  		if (res)
>  			return res;
> -		ieee80211_if_set_type(new_dev, IEEE80211_IF_TYPE_VLAN);
>  #if 0
>  		res = ieee80211_if_update_vlan(new_dev, vlan->id);
>  		if (res)

I know that the next few lines are commented out but please fix them as
well or remove the #ifed out code completely, otherwise we may be in
trouble later.

> [...]
> @@ -1093,36 +1098,34 @@ static int ieee80211_ioctl_update_if(struct net_device *dev,
>  		struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
>  		struct net_device *wds_dev = NULL;
>  		struct ieee80211_sub_if_data *sdata;
> +		int ret;
>  
>  		if (left < sizeof(struct ieee80211_if_wds))
>  			return -EPROTO;
>  
> +		read_lock(&local->sub_if_lock);
>  		list_for_each_entry(sdata, &local->sub_if_list, list) {
>  			if (strcmp(param->u.if_info.name,
>  				   sdata->dev->name) == 0) {
>  				wds_dev = sdata->dev;
> +				dev_hold(wds_dev);
>  				break;
>  			}
>  		}
> +		read_unlock(&local->sub_if_lock);
>  
>  		if (!wds_dev || sdata->type != IEEE80211_IF_TYPE_WDS)
>  			return -ENODEV;
>  
> -		return ieee80211_if_update_wds(wds_dev, wds->remote_addr);
> +		ret = ieee80211_if_update_wds(wds_dev, wds->remote_addr);
> +		dev_put(wds_dev);

This was the place with unnecessary dev_hold/dev_put you talked about,
right? Just wanted to show I'm paying attention :-)

> [...]
> @@ -2239,6 +2239,7 @@ static int ieee80211_ioctl_clear_keys(struct net_device *dev)
>  	struct sta_info *sta;
>  
>  	memset(addr, 0xff, ETH_ALEN);
> +	read_lock(&local->sub_if_lock);
>  	list_for_each_entry(sdata, &local->sub_if_list, list) {
>  		for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
>  			keyconf = NULL;
> @@ -2256,6 +2257,7 @@ static int ieee80211_ioctl_clear_keys(struct net_device *dev)
>  		}
>  		sdata->default_key = NULL;
>  	}
> +	read_unlock(&local->sub_if_lock);

Again, local->ops->set_key called under spinlock.

>  
>  	spin_lock_bh(&local->sta_lock);
>  	list_for_each_entry(sta, &local->sta_list, list) {
> @@ -2388,6 +2390,7 @@ static int ieee80211_ioctl_default_wep_only(struct ieee80211_local *local,
>  	struct ieee80211_sub_if_data *sdata;
>  
>  	local->default_wep_only = value;
> +	read_lock(&local->sub_if_lock);
>  	list_for_each_entry(sdata, &local->sub_if_list, list)
>  		for (i = 0; i < NUM_DEFAULT_KEYS; i++)
>  			if (value)
> @@ -2396,6 +2399,7 @@ static int ieee80211_ioctl_default_wep_only(struct ieee80211_local *local,
>  			else
>  				ieee80211_key_disable_hwaccel(local,
>  							      sdata->keys[i]);
> +	read_unlock(&local->sub_if_lock);
>  
>  	return 0;
>  }
> @@ -2406,7 +2410,7 @@ void ieee80211_update_default_wep_only(struct ieee80211_local *local)
>  	int i = 0;
>  	struct ieee80211_sub_if_data *sdata;
>  
> -	spin_lock_bh(&local->sub_if_lock);
> +	read_lock(&local->sub_if_lock);
>  	list_for_each_entry(sdata, &local->sub_if_list, list) {
>  
>  		if (sdata->dev == local->mdev)
> @@ -2415,7 +2419,7 @@ void ieee80211_update_default_wep_only(struct ieee80211_local *local)
>  		/* If there is an AP interface then depend on userspace to
>  		   set default_wep_only correctly. */
>  		if (sdata->type == IEEE80211_IF_TYPE_AP) {
> -			spin_unlock_bh(&local->sub_if_lock);
> +			read_unlock(&local->sub_if_lock);
>  			return;
>  		}
>  
> @@ -2427,7 +2431,7 @@ void ieee80211_update_default_wep_only(struct ieee80211_local *local)
>  	else
>  		ieee80211_ioctl_default_wep_only(local, 0);

Recursively taken lock. Ok, it's rwlock locked for reading, but I'd
still prefer not doing that.

>  
> -	spin_unlock_bh(&local->sub_if_lock);
> +	read_unlock(&local->sub_if_lock);
>  }
> [...]

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
