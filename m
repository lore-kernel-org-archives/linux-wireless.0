Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:63122 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753436AbXGCNLm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 09:11:42 -0400
Message-ID: <468A4B0C.4080704@lwfinger.net>
Date: Tue, 03 Jul 2007 08:11:40 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V3] mac80211: Implementation of SIOCSIWRATE
References: <467c034d.Jst2WOCyrN+34hJl%Larry.Finger@lwfinger.net>
In-Reply-To: <467c034d.Jst2WOCyrN+34hJl%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> From: Mohamed Abbas <mabbas@linux.intel.com>
> 
> The WEXT ioctl SIOCSIWRATE is not implemented in mac80211. This patch
> adds the missing routine. It supports the 'auto' keyword, fixed rates,
> and the combination of 'auto' and a fixed rate to select an upper bound.
> 
> Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
>  ieee80211_ioctl.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 50 insertions(+), 1 deletion(-)
> 
> Index: wireless-dev/net/mac80211/ieee80211_ioctl.c
> ===================================================================
> --- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c
> +++ wireless-dev/net/mac80211/ieee80211_ioctl.c
> @@ -1880,6 +1880,44 @@ static int ieee80211_ioctl_giwscan(struc
>  }
>  
>  
> +static int ieee80211_ioctl_siwrate(struct net_device *dev,
> +				  struct iw_request_info *info,
> +				  struct iw_param *rate, char *extra)
> +{
> +	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> +	struct ieee80211_hw_mode *mode;
> +	int i;
> +	u32 target_rate = rate->value / 100000;
> +	struct ieee80211_sub_if_data *sdata;
> +
> +	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	if (!sdata->bss)
> +		return -ENODEV;
> +	mode = local->oper_hw_mode;
> +	/* target_rate = -1, rate->fixed = 0 means auto only, so use all rates
> +	 * target_rate = X, rate->fixed = 1 means only rate X
> +	 * target_rate = X, rate->fixed = 0 means all rates <= X */
> +	sdata->bss->max_ratectrl_rateidx = -1;
> +	sdata->bss->force_unicast_rateidx = -1;
> +	if (rate->value < 0)
> +		return 0;
> +	for (i=0; i< mode->num_rates; i++) {
> +		struct ieee80211_rate *rates = &mode->rates[i];
> +		int this_rate = rates->rate;
> +
> +		if (mode->mode == MODE_ATHEROS_TURBO ||
> +		    mode->mode == MODE_ATHEROS_TURBOG)
> +			this_rate *= 2;
> +		if (target_rate == this_rate) {
> +			sdata->bss->max_ratectrl_rateidx = i;
> +			if (rate->fixed)
> +				sdata->bss->force_unicast_rateidx = i;
> +			break;
> +		}
> +	}
> +	return 0;
> +}
> +
>  static int ieee80211_ioctl_giwrate(struct net_device *dev,
>  				  struct iw_request_info *info,
>  				  struct iw_param *rate, char *extra)
> @@ -3026,7 +3064,7 @@ static const iw_handler ieee80211_handle
>  	(iw_handler) NULL,				/* SIOCGIWNICKN */
>  	(iw_handler) NULL,				/* -- hole -- */
>  	(iw_handler) NULL,				/* -- hole -- */
> -	(iw_handler) NULL,				/* SIOCSIWRATE */
> +	(iw_handler) ieee80211_ioctl_siwrate,		/* SIOCSIWRATE */
>  	(iw_handler) ieee80211_ioctl_giwrate,		/* SIOCGIWRATE */
>  	(iw_handler) ieee80211_ioctl_siwrts,		/* SIOCSIWRTS */
>  	(iw_handler) ieee80211_ioctl_giwrts,		/* SIOCGIWRTS */
> 

Was this revision OK, or did I miss something?

Larry
