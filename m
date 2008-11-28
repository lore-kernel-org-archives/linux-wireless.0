Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42313 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbYK1WLL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 17:11:11 -0500
Subject: Re: [RFC v3 1/4] mac80211: enable IEEE80211_CONF_PS only when
	associated
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1227901784-5325-2-git-send-email-kalle.valo@nokia.com> (sfid-20081128_205002_114359_21347A04)
References: <1227901784-5325-1-git-send-email-kalle.valo@nokia.com>
	 <1227901784-5325-2-git-send-email-kalle.valo@nokia.com>
	 (sfid-20081128_205002_114359_21347A04)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yj+pYLNLvxnLiUMxac3M"
Date: Fri, 28 Nov 2008 23:11:03 +0100
Message-Id: <1227910263.3543.0.camel@johannes.berg> (sfid-20081128_231116_486324_C5BC77AD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yj+pYLNLvxnLiUMxac3M
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-28 at 21:49 +0200, Kalle Valo wrote:

> @@ -953,25 +953,44 @@ static int ieee80211_ioctl_siwpower(struct net_devi=
ce *dev,
>  				    struct iw_param *wrq,
>  				    char *extra)
>  {
> +	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
>  	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> +	struct ieee80211_if_sta *ifsta =3D &sdata->u.sta;
>  	struct ieee80211_conf *conf =3D &local->hw.conf;
> +	int ret =3D 0;
> +	bool ps;
> =20
>  	if (wrq->disabled) {
> -		conf->flags &=3D ~IEEE80211_CONF_PS;
> -		return ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
> +		ps =3D false;
> +		goto set;
>  	}
> =20
>  	switch (wrq->flags & IW_POWER_MODE) {
>  	case IW_POWER_ON:       /* If not specified */
>  	case IW_POWER_MODE:     /* If set all mask */
>  	case IW_POWER_ALL_R:    /* If explicitely state all */
> -		conf->flags |=3D IEEE80211_CONF_PS;
> +		ps =3D true;
>  		break;
>  	default:                /* Otherwise we don't support it */
>  		return -EINVAL;
>  	}
> =20
> -	return ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
> +	if (ps =3D=3D local->powersave)
> +		return ret;
> +
> +set:
> +	local->powersave =3D ps;
> +
> +	if (ifsta->flags && IEEE80211_STA_ASSOCIATED) {

This really needs to check you're actually in STA mode.

johannes

--=-yj+pYLNLvxnLiUMxac3M
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJMGxzAAoJEKVg1VMiehFYe+oQAJGvpvRuSYEIuVyImHT+2/N8
EX3brLnva6+Im0otxab5ZiXXR/ejx9TEfoG7kUZmdlmO8GDLI21k0at2RhN8lSv7
EUu010mvgcHhazh2ZuXS1FCTThIinIfTmmQ06Nse9yNW6EhK4W2ARGaksFfogLF+
Rg9CgoTGP8ybxQ9UAger5CHV9OqwdVmfYbxTr+ymtXM2N2ffaT5kUFnMxQp7n/Ob
XZgpnZRLWQ3G/6b2cwC2aqXQaA7/iUEtpXRpkIARoanWhw6q/D3bQulmV0MYtHK1
AcGnrbXMfYi7sOfaWUiClE30/13Fhk55uWmhPAYYg9Z7eNBZU37PmV0enfcsB6xw
bX6CkUD6oiNnqi1Q5Vdlsj+80b6Xkg5vpHiuAAy9xN0Bq7retRfOcXj/kJTVQzKI
WV4v8+ThqyzrU21LpxdASkqMvb+ss0UJt3VyKzhfLHCey9YlwuQM4O2cZx21cG1e
UpPu9Ns4L7CHzhkmAN0SMGP391Xfk8vbDpoWxF8e7L7Fj9DUzG+B8pSkjMuPTC2P
r/vNGjz4psDI5JCltfy0aka/cXmyRhjeMdfzE58vHdU+UoKCxJRokkFwJtUTId/7
sCjMLYs02l1WQ2O0AciOqgAiIahvnBbFjkwjiH/xyEfVeUxihidNw2fXCu1NS9mT
o+sutETVnE3Qfmd4uuo3
=JKkj
-----END PGP SIGNATURE-----

--=-yj+pYLNLvxnLiUMxac3M--

