Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50122 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbXKWMs6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 07:48:58 -0500
Subject: Re: mac80211 regression: doesn't associate automatically
From: Johannes Berg <johannes@sipsolutions.net>
To: Will Dyson <will.dyson@gmail.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <8e6f94720711221232p16b90daaya5fe3550729b49c8@mail.gmail.com> (sfid-20071122_203227_131129_9DDF5C70)
References: <200711220912.10452.hs4233@mail.mn-solutions.de>
	 <200711221605.55506.hs4233@mail.mn-solutions.de>
	 <1195746110.4149.23.camel@johannes.berg>
	 <200711221719.40412.hs4233@mail.mn-solutions.de>
	 <8e6f94720711221232p16b90daaya5fe3550729b49c8@mail.gmail.com>
	 (sfid-20071122_203227_131129_9DDF5C70)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rr6CD2ZVUgdiI9ZO72uV"
Date: Fri, 23 Nov 2007 13:48:36 +0100
Message-Id: <1195822116.4149.116.camel@johannes.berg> (sfid-20071123_124902_057102_760A24F6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rr6CD2ZVUgdiI9ZO72uV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> It doesn't look like it should be so hard to make setting the key
> trigger association. And I don't think that if we allow setting the
> key to trigger association, that it obligates us to reassociate on
> every other event that could effect it. As you said, wext spec is
> silent on this matter.
>=20
> It does seem silly to set the key after the essid, but unless it
> really hurts elsewhere, we can be liberal in what we accept.
>=20
> My (probably wrong, compile-tested only, for review only) patch to
> implement this:

I don't think this can work because when say wpa_supplicant changes the
key the last thing we want is to have that cause a reconsideration of
which AP we're associated with. Or even a disassoc/reassoc cycle.

> I know it is word-wrapped by Gmail. Sorry, I'm late to a family event as-=
is.
>=20
> diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioct=
l.c
> index 503b64a..6ce79e4 100644
> --- a/net/mac80211/ieee80211_ioctl.c
> +++ b/net/mac80211/ieee80211_ioctl.c
> @@ -839,6 +839,7 @@ static int ieee80211_ioctl_siwencode(struct net_devic=
e *dev,
>  	int idx, i, alg =3D ALG_WEP;
>  	u8 bcaddr[ETH_ALEN] =3D { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
>  	int remove =3D 0;
> +	int ret;
>=20
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
>=20
> @@ -864,11 +865,16 @@ static int ieee80211_ioctl_siwencode(struct
> net_device *dev,
>  		return 0;
>  	}
>=20
> -	return ieee80211_set_encryption(
> +	ret =3D ieee80211_set_encryption(
>  		dev, bcaddr,
>  		idx, alg, remove,
>  		!sdata->default_key,
>  		keybuf, erq->length);
> +	if (ret)
> +		return ret;
> +
> +	ieee80211_sta_req_auth(dev, &sdata->u.sta);
> +	return 0;
>  }
>=20
>=20
> @@ -1015,6 +1021,7 @@ static int ieee80211_ioctl_siwencodeext(struct
> net_device *dev,
>  	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
>  	struct iw_encode_ext *ext =3D (struct iw_encode_ext *) extra;
>  	int uninitialized_var(alg), idx, i, remove =3D 0;
> +	int ret;
>=20
>  	switch (ext->alg) {
>  	case IW_ENCODE_ALG_NONE:
> @@ -1052,11 +1059,16 @@ static int ieee80211_ioctl_siwencodeext(struct
> net_device *dev,
>  	} else
>  		idx--;
>=20
> -	return ieee80211_set_encryption(dev, ext->addr.sa_data, idx, alg,
> +	ret =3D ieee80211_set_encryption(dev, ext->addr.sa_data, idx, alg,
>  					remove,
>  					ext->ext_flags &
>  					IW_ENCODE_EXT_SET_TX_KEY,
>  					ext->key, ext->key_len);
> +	if (ret)
> +		return ret;
> +
> +	ieee80211_sta_req_auth(dev, &sdata->u.sta);
> +	return 0;
>  }
>=20

--=-rr6CD2ZVUgdiI9ZO72uV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0bMI6Vg1VMiehFYAQJC+hAAwU3UttDCat0qVMnh4E7OGu4tEox6BusY
DMUAueUlA+/Sz/9com0/VZJRj+uTvUvHMKojcpPGubnnPwgRbXHhJNcVY9atTSEo
yr6qdaoS0Om40dDZIMTMHtqZji7YJPWjCIeLpQzhiRKL3KuXrncPTB3pv6PORnGE
32Dbskrdsry+pU8bd5fBfOxwAGO+mTWsrmzi8jU+2W7jLiHC4YDb4npO0RyhA1Wh
UiaJK7N8ToIhXbkww3UzGYNJQrDsjBw2EZISnnguMxsSLTfPA3RUDNeQfAPxILLJ
/8FbdZbMWTDrHPof7pCwa9sGlWCzoBELuYtwwGxDVQrtWLv7YYpSQ3rYaHyTrCKn
4/U4CwY7JnqsKkNNRVvkQpvwOVxt8rATS6vgKrsg4BmKgKC6LYwrvhFkhCeiuMUG
vx02G2G41qILVZELrG0/WGAltr/2jaEvhMq9hnFPnnRGZ1mrX1Wtx9J0XNxGLWm4
KjzJ0am8qRFShuzsWOfSMP6+tsb2Hq0100cEt8PwiXHNg6TMmOMHYJzsTyohsoSW
jkWOmGS+ll44c4Sx0/Vs1J2anZOsGsdQzuqdkdq95PLn5F9187bXG3QldiTdpNwp
G+ieuLAAzzNTNUQaxaL20/moizZtSobR0Ed6g6k0BuGlt+se5c/jbFZBL4TPyRJp
y2o5oy3nT/M=
=OHUv
-----END PGP SIGNATURE-----

--=-rr6CD2ZVUgdiI9ZO72uV--

