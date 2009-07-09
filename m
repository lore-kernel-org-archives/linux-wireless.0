Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60789 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647AbZGILcl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 07:32:41 -0400
Subject: Re: [PATCH] cfg80211: fix NULL dereference in IBSS SIOCGIWAP
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1247129989-24989-1-git-send-email-yi.zhu@intel.com>
References: <1247129989-24989-1-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-iB9euoEHsk3zR9Mgn1JK"
Date: Thu, 09 Jul 2009 13:32:06 +0200
Message-Id: <1247139126.2144.17.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iB9euoEHsk3zR9Mgn1JK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-09 at 16:59 +0800, Zhu Yi wrote:
> This patch avoids memcpy from wdev->wext.ibss.bssid if it is NULL.
> This could happen if we SIOCGIWAP before SIOCSIWAP.

Indeed, thanks.

> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/wireless/ibss.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
> index 99ef936..cf3a7dc 100644
> --- a/net/wireless/ibss.c
> +++ b/net/wireless/ibss.c
> @@ -434,8 +434,11 @@ int cfg80211_ibss_wext_giwap(struct net_device *dev,
>  	wdev_lock(wdev);
>  	if (wdev->current_bss)
>  		memcpy(ap_addr->sa_data, wdev->current_bss->pub.bssid, ETH_ALEN);
> -	else
> +	else if (wdev->wext.ibss.bssid)
>  		memcpy(ap_addr->sa_data, wdev->wext.ibss.bssid, ETH_ALEN);
> +	else
> +		memset(ap_addr->sa_data, 0, ETH_ALEN);
> +
>  	wdev_unlock(wdev);
> =20
>  	return 0;

--=-iB9euoEHsk3zR9Mgn1JK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKVdUwAAoJEODzc/N7+Qma7EAQAIolwCwNM9HC2C0eqM6ecREx
RhRyW5xaXGQMIrdT53dqzhUElE90gjA0bR64HG6rTGDNRUZ4XiLo8EzxuD91d2EU
m9Gawg4vF7p1sZhuYUgMTqaDJtN8xDn218j9N+n6nyXd8Z9ABqO1qc+qZ1d/x2Dh
rEzXK7J35lm8hczSLq8ZtkMAgIRAZWbiiQOem5CLu6wfdkJwmMsu0yjEuI6cVClF
MjHU28aRoyg4OZxJ/UjVMbLNF+d6LOsUWcClCDqECI0BYNPj1tEL42PjT8DKtzQi
jklNlZiXQVhyn0TBdv5uKAtow/vRBGwjAHq7FEkvRB52311eiSLGwf9E92eWLc41
Bc1eBn0cujdXHU3FtQC4MQx/OY1WLtBoTWh6uyBe9aonpz/qpb/4N/EoI4G7Hd7/
iCgFpdlRnwn8F4nK9L/4P5K2tgVAiDzKVhJLVc4hsgfJoMf85CftjAGu1TDLNJLZ
mLS3QMX/04BH3rPLoIVNtG2OQ+Rwpz8GCqWEWj+adRRGSChit65lT9yEb9SMLEUi
iJ0YDOspOnNjVHAz5f8vceONuNwc+XQezgigMwGKYbZ3bsdaLV1xFh0lYEIinrdf
idLDcPh7TZ4ELyElY4ee0eaX1KIiI6ELsGZNKIaubU0Ac6ZrzA6Z8RQsI8QS2MQJ
izd3ovc6Ser96W/e3qav
=Bond
-----END PGP SIGNATURE-----

--=-iB9euoEHsk3zR9Mgn1JK--

