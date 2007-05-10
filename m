Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:14501 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754568AbXEJERb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 00:17:31 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V3] mac80211: Add support for SIOCGIWRATE ioctl to provide rate information
Date: Thu, 10 May 2007 00:16:41 -0400
Cc: Jiri Benc <jbenc@suse.cz>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
References: <463a8a92.jFmmjY4cDnfJeisJ%Larry.Finger@lwfinger.net>
In-Reply-To: <463a8a92.jFmmjY4cDnfJeisJ%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7511773.9UE4mGkFBZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705100016.45876.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart7511773.9UE4mGkFBZ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 03 May 2007 21:21, Larry Finger wrote:
> +static int ieee80211_ioctl_giwrate(struct net_device *dev,
> +				  struct iw_request_info *info,
> +				  struct iw_param *rate, char *extra)
> +{
> +	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> +	struct sta_info * sta;
> +	struct ieee80211_sub_if_data * sdata;
Eliminate the spaces between * and the variable name.

> +
> +	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> +	if (sdata->type =3D=3D IEEE80211_IF_TYPE_STA ||
> +	    sdata->type =3D=3D IEEE80211_IF_TYPE_IBSS)
> +		sta =3D sta_info_get(local, sdata->u.sta.bssid);
> +	else
> +		return -EOPNOTSUPP;
> +	if (!sta)
> +		return -ENODEV;
> +	rate->value =3D local->oper_hw_mode->rates[sta->txrate].rate * 100000;
The index from sta->txrate needs to be checked to make sure it is less than=
=20
mode->num_rates.

Also, this function is safe in adhoc mode.. but it most likely won't do=20
anything useful since all the sta entries have different addresses and it i=
s=20
likely that none of them are the same as the one in sdata->u.sta.bssid.

=2DMichael Wu

--nextPart7511773.9UE4mGkFBZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGQpytT3Oqt9AH4aERArU+AJ0XRb/fJI+B0VhG0BTEmI23XLmc9wCfRyPY
yRhri0bGYspq69IBiEwujxg=
=s+1g
-----END PGP SIGNATURE-----

--nextPart7511773.9UE4mGkFBZ--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
