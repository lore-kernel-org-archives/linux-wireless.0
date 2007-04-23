Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:60521 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753296AbXDWU6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 16:58:07 -0400
Message-ID: <462D1DD8.8060507@warmcat.com>
Date: Mon, 23 Apr 2007 21:58:00 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 03/13] mac80211: fix virtual interface related locking
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <20070423184812.7029.7682.stgit@magic.sourmilk.net>
In-Reply-To: <20070423184812.7029.7682.stgit@magic.sourmilk.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:

Hi Michael -

Couldn't get this to apply on current wireless-dev, and there is a 
trailing whitespace.  Maybe it's a problem with a script I concocted to 
extract the patch from saved Thunderbird 2.0 mails... ?  Is it just that 
wireless-dev changed inbetweentimes?

$ git pull
Already up-to-date.
$ guilt push
Applying patch..mac80211-Add-radiotap-support.patch
Patch applied.
$ guilt push
Applying patch..sync-with-radiotap-header-in-wireless-2.6.patch
Patch applied.
$ guilt push
Applying patch..mac80211-fix-virtual-interface-related-locking.patch
Adds trailing whitespace.
Context reduced to (1/1) to apply fragment at 30
error: patch failed: net/mac80211/ieee80211_cfg.c:45
error: net/mac80211/ieee80211_cfg.c: patch does not apply
To force apply this patch, use 'guilt push -f'
$

Failing chunk:

> diff --git a/net/mac80211/ieee80211_cfg.c b/net/mac80211/ieee80211_cfg.c
> index e370b4b..0069826 100644
> --- a/net/mac80211/ieee80211_cfg.c
> +++ b/net/mac80211/ieee80211_cfg.c
...
> @@ -45,16 +44,12 @@ static int ieee80211_add_iface(struct wiphy *wiphy, char *name,
>  		return -EINVAL;
>  	}
>  
> -	res = ieee80211_if_add(local->mdev, name, 0, &new_dev);
> -	if (res == 0)
> -		ieee80211_if_set_type(new_dev, itype);
> -	return res;
> +	return ieee80211_if_add(local->mdev, name, NULL, itype);
>  }


...

> diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
> index 2ff762d..502010e 100644
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
> +			struct ieee80211_sub_if_data *sdata = <<<<<<----- trailing space

-Andy
