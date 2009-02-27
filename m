Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:52986 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbZB0OAt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 09:00:49 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Alina Friedrichsen" <x-alina@gmx.net>
Subject: Re: [PATCH v2] mac80211: Implement commit in wireless extensions
Date: Fri, 27 Feb 2009 14:58:29 +0100
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
References: <20090226232149.51510@gmx.net>
In-Reply-To: <20090226232149.51510@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200902271458.29509.mb@bu3sch.de> (sfid-20090227_150053_090816_2A928335)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 27 February 2009 00:21:49 Alina Friedrichsen wrote:
> This implements commit in wireless extensions for completeness and maybe it could be useful for debugging to initiate a new rejoining process without changing the config.
> 
> I not so familiar with nl80211 at the moment, so I want add it to nl80211 in a second patch.
> 
> Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
> ---
> Version 2: Fix bad header.
> 
> Hope we can find a compromise in the conception.

The WEXT commit function is one of the worst WEXT functions.
And this patch even abuses it even more. Commit is meant to commit _pending_ changes.
It is _not_ meant to re-apply existing changes.
But as we never have pending changes in mac80211, the commit function doesn't make
any sense for mac80211.

I vote for dropping this patch entirely, as it just adds an abusive implementation
of a crap API.

If you want to re-apply some settings, please do this from userspace entirely.
You don't need kernel support for this.

> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index ecbc8e0..7f00c70 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -920,6 +920,7 @@ static inline int ieee80211_bssid_match(const u8 *raddr, const u8 *addr)
>  
>  int ieee80211_hw_config(struct ieee80211_local *local, u32 changed);
>  int ieee80211_if_config(struct ieee80211_sub_if_data *sdata, u32 changed);
> +void ieee80211_commit(struct ieee80211_sub_if_data *sdata);
>  void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx);
>  void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
>  				      u32 changed);
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index f38db4d..1b2d598 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -294,6 +294,20 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
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
>  void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
>  				      u32 changed)
>  {
> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> index f6924fc..1ac0516 100644
> --- a/net/mac80211/wext.c
> +++ b/net/mac80211/wext.c
> @@ -121,6 +121,15 @@ static int ieee80211_set_encryption(struct ieee80211_sub_if_data *sdata, u8 *sta
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
> @@ -1035,7 +1044,7 @@ static int ieee80211_ioctl_siwencodeext(struct net_device *dev,
>  
>  static const iw_handler ieee80211_handler[] =
>  {
> -	(iw_handler) NULL,				/* SIOCSIWCOMMIT */
> +	(iw_handler) ieee80211_ioctl_commit,		/* SIOCSIWCOMMIT */
>  	(iw_handler) cfg80211_wext_giwname,		/* SIOCGIWNAME */
>  	(iw_handler) NULL,				/* SIOCSIWNWID */
>  	(iw_handler) NULL,				/* SIOCGIWNWID */
> 



-- 
Greetings, Michael.
