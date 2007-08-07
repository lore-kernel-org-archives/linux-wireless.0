Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:38928
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbXHGSOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 14:14:48 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] mac80211: Add SIOCGIWTXPOWER routine
Date: Tue, 7 Aug 2007 20:13:58 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <46b8b531.h17+wXhw0v8LOFD/%Larry.Finger@lwfinger.net>
In-Reply-To: <46b8b531.h17+wXhw0v8LOFD/%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708072013.58508.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 07 August 2007 20:08:49 Larry Finger wrote:
> The wireless extensions ioctl's implemented in mac80211 do not include
> SIOCGIWTXPOWER. This patch adds the necessary code.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Index: wireless-dev/net/mac80211/ieee80211_ioctl.c
> ===================================================================
> --- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c
> +++ wireless-dev/net/mac80211/ieee80211_ioctl.c
> @@ -1925,6 +1925,20 @@ static int ieee80211_ioctl_giwrate(struc
>  	return 0;
>  }
>  
> +static int ieee80211_ioctl_giwtxpower(struct net_device *dev,
> +				   struct iw_request_info *info,
> +				   union iwreq_data *data, char *extra)
> +{
> +	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> +
> +	data->txpower.fixed = 1;
> +	data->txpower.disabled = 0;
> +	data->txpower.value = local->hw.conf.power_level;
> +	data->txpower.flags = IW_TXPOW_DBM;
> +
> +	return 0;
> +}
> +
>  static int ieee80211_ioctl_siwrts(struct net_device *dev,
>  				  struct iw_request_info *info,
>  				  struct iw_param *rts, char *extra)
> @@ -2881,7 +2895,7 @@ static const iw_handler ieee80211_handle
>  	(iw_handler) ieee80211_ioctl_siwfrag,		/* SIOCSIWFRAG */
>  	(iw_handler) ieee80211_ioctl_giwfrag,		/* SIOCGIWFRAG */
>  	(iw_handler) NULL,				/* SIOCSIWTXPOW */
> -	(iw_handler) NULL,				/* SIOCGIWTXPOW */
> +	(iw_handler) ieee80211_ioctl_giwtxpower,	/* SIOCGIWTXPOW */
>  	(iw_handler) ieee80211_ioctl_siwretry,		/* SIOCSIWRETRY */
>  	(iw_handler) ieee80211_ioctl_giwretry,		/* SIOCGIWRETRY */
>  	(iw_handler) ieee80211_ioctl_siwencode,		/* SIOCSIWENCODE */

Looks good.

Acked-by: Michael Buesch <mb@bu3sch.de>

-- 
Greetings Michael.
