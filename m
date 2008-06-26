Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp23.orange.fr ([193.252.22.126]:26404 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbYFZRja (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 13:39:30 -0400
Date: Thu, 26 Jun 2008 19:40:58 +0200
From: Samuel Ortiz <samuel@sortiz.org>
To: Miguel =?iso-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>,
	linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com
Subject: Re: [PATCH 1/2] mac80211: add power management support
Message-ID: <20080626174058.GA3063@sortiz.org> (sfid-20080626_193936_173843_18D3DDB5)
Reply-To: Samuel Ortiz <samuel@sortiz.org>
References: <200711161929.36283.mboton.lkml@gmail.com> <200711161953.26801.mboton.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <200711161953.26801.mboton.lkml@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Fri, Nov 16, 2007 at 07:53:26PM +0100, Miguel Bot=F3n wrote:
> Ok, the previous patch had a little error.
>=20
> --
>=20
> This patch adds power management support in mac80211.
Sorry for being late to the game, but would a similar patch against you=
r
-next-2.6 tree be considered for inclusion ?

Cheers,
Samuel.


> This allows us to enable power management through the "iwconfig <devi=
ce> power=20
> <off/on>" command.
> The code is based on "mac80211-10.0.0" but it is a little bit modifie=
d.
>=20
> Signed-off-by: Miguel Bot=F3n <mboton@gmail.com>
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 5fcc4c1..c82b6fa 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -452,6 +452,8 @@ struct ieee80211_conf {
>  	u8 antenna_max;
>  	u8 antenna_sel_tx;
>  	u8 antenna_sel_rx;
> +
> +	u8 power_management_enable;     /* flag to enable/disable power man=
agement=20
> */
>  };
> =20
>  /**
> diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_=
ioctl.c
> index 6caa3ec..f5eebec 100644
> --- a/net/mac80211/ieee80211_ioctl.c
> +++ b/net/mac80211/ieee80211_ioctl.c
> @@ -674,6 +687,51 @@ static int ieee80211_ioctl_giwtxpower(struct net=
_device=20
> *dev,
>  	return 0;
>  }
> =20
> +static int ieee80211_ioctl_siwpower(struct net_device *dev,
> +				    struct iw_request_info *info,
> +				    union iwreq_data *wrqu,
> +				    char *extra)
> +{
> +	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> +	struct ieee80211_conf *conf =3D &local->hw.conf;
> +
> +	if (wrqu->power.disabled) {
> +		conf->power_management_enable =3D 0;
> +		if (ieee80211_hw_config(local))
> +			return -EINVAL;
> +		return 0;
> +	}
> +
> +	switch (wrqu->power.flags & IW_POWER_MODE) {
> +	case IW_POWER_ON:       /* If not specified */
> +	case IW_POWER_MODE:     /* If set all mask */
> +	case IW_POWER_ALL_R:    /* If explicitely state all */
> +		break;
> +	default:                /* Otherwise we don't support it */
> +		return -EINVAL;
> +	}
> +
> +	conf->power_management_enable =3D 1;
> +
> +	if (ieee80211_hw_config(local))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int ieee80211_ioctl_giwpower(struct net_device *dev,
> +				    struct iw_request_info *info,
> +				    union iwreq_data *wrqu,
> +				    char *extra)
> +{
> +	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> +	struct ieee80211_conf *conf =3D &local->hw.conf;
> +
> +	wrqu->power.disabled =3D !conf->power_management_enable;
> +
> +	return 0;
> +}
> +
>  static int ieee80211_ioctl_siwrts(struct net_device *dev,
>  				  struct iw_request_info *info,
>  				  struct iw_param *rts, char *extra)
> @@ -1111,8 +1166,8 @@ static const iw_handler ieee80211_handler[] =3D
>  	(iw_handler) ieee80211_ioctl_giwretry,		/* SIOCGIWRETRY */
>  	(iw_handler) ieee80211_ioctl_siwencode,		/* SIOCSIWENCODE */
>  	(iw_handler) ieee80211_ioctl_giwencode,		/* SIOCGIWENCODE */
> -	(iw_handler) NULL,				/* SIOCSIWPOWER */
> -	(iw_handler) NULL,				/* SIOCGIWPOWER */
> +	(iw_handler) ieee80211_ioctl_siwpower,		/* SIOCSIWPOWER */
> +	(iw_handler) ieee80211_ioctl_giwpower,		/* SIOCGIWPOWER */
>  	(iw_handler) NULL,				/* -- hole -- */
>  	(iw_handler) NULL,				/* -- hole -- */
>  	(iw_handler) ieee80211_ioctl_siwgenie,		/* SIOCSIWGENIE */
>=20
> --=20
> 	Miguel Bot=F3n
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
