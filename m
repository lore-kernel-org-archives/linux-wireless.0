Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38799 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760404AbZBYW1G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 17:27:06 -0500
To: Alina Friedrichsen <x-alina@gmx.net>
Subject: Re: [PATCH] mac80211: Implement commit in wireless extensions
MIME-Version: 1.0
Date: Wed, 25 Feb 2009 23:27:01 +0100
From: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20090225215631.289250@gmx.net> (sfid-20090225_225703_350502_23B11EFA)
References: <20090225215631.289250@gmx.net> (sfid-20090225_225703_350502_23B11EFA)
Message-ID: <d38edefd935f0aa5c8cca9aee1cf1d7b@localhost>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 25 Feb 2009 22:56:31 +0100, "Alina Friedrichsen" <x-alina@gmx.net>
wrote:
> This implements commit in wireless extensions for completeness and maybe
it
> could be useful for debugging to initiate a new rejoining process without
> changing the config.

I don't think that we should do this -- "completeness" for wext is a bad
argument and for debugging you can also do the other things.

> I not so familiar with nl80211 at the moment, so I want add it to nl80211
> in a second patch.

No, you won't. nl80211 shall not require such hacks.

johannes

> Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
> ---
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index ecbc8e0..7f00c70 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -920,6 +920,7 @@ static inline int ieee80211_bssid_match(const u8
> *raddr, const u8 *addr)
>  
>  int ieee80211_hw_config(struct ieee80211_local *local, u32 changed);
>  int ieee80211_if_config(struct ieee80211_sub_if_data *sdata, u32
changed);
> +int ieee80211_commit(struct ieee80211_sub_if_data *sdata);
>  void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx);
>  void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data
*sdata,
>  				      u32 changed);
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index f38db4d..1b2d598 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -294,6 +294,20 @@ int ieee80211_hw_config(struct ieee80211_local
*local,
> u32 changed)
>  	return ret;
>  }
>  
> +void ieee80211_commit(struct ieee80211_sub_if_data *sdata)
> +{
> +	switch (sdata->vif.type) {
> +	case NL80211_IFTYPE_ADHOC:
> +		ieee80211_ibss_commit(sdata);
> +		break;
> +	case NL80211_IFTYPE_STATION:
> +		ieee80211_sta_commit(sdata);
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
>  void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data
*sdata,
>  				      u32 changed)
>  {
> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> index f6924fc..1ac0516 100644
> --- a/net/mac80211/wext.c
> +++ b/net/mac80211/wext.c
> @@ -121,6 +121,15 @@ static int ieee80211_set_encryption(struct
> ieee80211_sub_if_data *sdata, u8 *sta
>  	return err;
>  }
>  
> +static int ieee80211_ioctl_commit(struct net_device *dev,
> +				  struct iw_request_info *info,
> +				  struct iw_point *data, char *extra)
> +{
> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	ieee80211_commit(sdata);
> +	return 0;
> +}
> +
>  static int ieee80211_ioctl_siwgenie(struct net_device *dev,
>  				    struct iw_request_info *info,
>  				    struct iw_point *data, char *extra)
> @@ -1035,7 +1044,7 @@ static int ieee80211_ioctl_siwencodeext(struct
> net_device *dev,
>  
>  static const iw_handler ieee80211_handler[] =
>  {
> -	(iw_handler) NULL,				/* SIOCSIWCOMMIT */
> +	(iw_handler) ieee80211_ioctl_commit,		/* SIOCSIWCOMMIT */
>  	(iw_handler) cfg80211_wext_giwname,		/* SIOCGIWNAME */
>  	(iw_handler) NULL,				/* SIOCSIWNWID */
>  	(iw_handler) NULL,				/* SIOCGIWNWID */
