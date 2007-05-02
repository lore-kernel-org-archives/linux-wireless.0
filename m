Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:34571 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993248AbXEBObw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2007 10:31:52 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] mac80211: Add support for SIOCGIWRATE ioctl to provide rate information
Date: Wed, 2 May 2007 10:31:32 -0400
Cc: Jiri Benc <jbenc@suse.cz>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
References: <46389ff5.oRExYGz42A2aZRmj%Larry.Finger@lwfinger.net>
In-Reply-To: <46389ff5.oRExYGz42A2aZRmj%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3971499.cWLTUyXQF6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705021031.40728.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3971499.cWLTUyXQF6
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 02 May 2007 10:28, Larry Finger wrote:
> +static int ieee80211_ioctl_giwrate(struct net_device *dev,
> +				  struct iw_request_info *info,
> +				  struct iw_param *rate, char *extra)
> +{
> +	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> +	struct sta_info * sta;
> +	struct ieee80211_sub_if_data * sdata;
> +
> +	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	sta = sta_info_get(local, sdata->u.sta.bssid);
> +	if (!sta)
> +		return -ENODEV;
> +	rate->value = local->oper_hw_mode->rates[sta->txrate].rate * 100000;
> +	return 0;
> +}
> +
Memory leak. You need a sta_info_put.

-Michael Wu

--nextPart3971499.cWLTUyXQF6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGOKDMT3Oqt9AH4aERAiuDAJwMExNhdn2DIgY8tMR4P3iNVAY+OACgrsR/
Rtw2Nmd3EERVJwFJ1+tCyJc=
=rFxd
-----END PGP SIGNATURE-----

--nextPart3971499.cWLTUyXQF6--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
