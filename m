Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59612 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbYKVULA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 15:11:00 -0500
Subject: Re: [PATCH] nl80211: Change max TX power to be in mBm instead of
	dBm
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081122200031.GB8265@jm.kir.nu>
References: <20081122200031.GB8265@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1I1aoLs8YFyRaUFHqjNW"
Date: Sat, 22 Nov 2008 21:10:52 +0100
Message-Id: <1227384652.3599.29.camel@johannes.berg> (sfid-20081122_211103_601600_6B4A4A67)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1I1aoLs8YFyRaUFHqjNW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-22 at 22:00 +0200, Jouni Malinen wrote:
> In order to be consistent with NL80211_ATTR_POWER_RULE_MAX_EIRP,
> change NL80211_FREQUENCY_ATTR_MAX_TX_POWER to use mBm and U32 instead
> of dBm and U8. This is a userspace interface change, but the previous
> version had not yet been pushed upstream and there are no userspace
> programs using this yet, so there is justification to get this change in
> as long as it goes in before the previous version gets out.

Thanks.

> Signed-off-by: Jouni Malinen <j@w1.fi>
>=20
>=20
> Index: wireless-testing/include/linux/nl80211.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/include/linux/nl80211.h	2008-11-22 21:22:06.000=
000000 +0200
> +++ wireless-testing/include/linux/nl80211.h	2008-11-22 21:22:54.00000000=
0 +0200
> @@ -508,7 +508,8 @@
>   *	on this channel in current regulatory domain.
>   * @NL80211_FREQUENCY_ATTR_RADAR: Radar detection is mandatory
>   *	on this channel in current regulatory domain.
> - * @NL80211_FREQUENCY_ATTR_MAX_TX_POWER: Maximum transmission power in d=
Bm.
> + * @NL80211_FREQUENCY_ATTR_MAX_TX_POWER: Maximum transmission power in m=
Bm
> + *	(100 * dBm).
>   */
>  enum nl80211_frequency_attr {
>  	__NL80211_FREQUENCY_ATTR_INVALID,
> Index: wireless-testing/net/wireless/nl80211.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/net/wireless/nl80211.c	2008-11-22 21:23:10.0000=
00000 +0200
> +++ wireless-testing/net/wireless/nl80211.c	2008-11-22 21:23:51.000000000=
 +0200
> @@ -198,8 +198,8 @@
>  			if (chan->flags & IEEE80211_CHAN_RADAR)
>  				NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_RADAR);
> =20
> -			NLA_PUT_U8(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
> -				   chan->max_power);
> +			NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
> +				    DBM_TO_MBM(chan->max_power));
> =20
>  			nla_nest_end(msg, nl_freq);
>  		}
>=20

--=-1I1aoLs8YFyRaUFHqjNW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJKGdIAAoJEKVg1VMiehFYxt8P/3qUXUHdFx+v/CCRmA3IA5Ka
9cuv3EO4KjvdfpMl9IUbMkTMNhwYJj7uuv7gA68Rm0dGkfiPy7JsuU7A8b7EB4QD
fM9RFbVpBqPMsVUD+jI2cIxiKrPy6q8wb+dbohQqf6zrHdj/UbdFKH6eSYDY9Wpj
lxwGL3dFW1/8mP6tNWV2FjXXwOKtVRDJK/wAcsRMoJLnnuVwzDPuwIHYJkpkPzhU
AaCVDWE5ApZfWqf4QSS1u6WaV8kSwKXQ/lk6sb2anMAN6UbEQcI79LxBBjZ3EpEY
Swib+VG+FqphUkgXScyPtvP7iBKuJP/sFnTHq7Yv0myes+IlsWKDhmCmNCKln6/G
wU1H1JEnNvujlkQ4DMG0OeFRzRh13N2XgNCH/OMUyxYHOcm8e9IvqMICuztaGsaz
80tegmIVc+f+Yuk6FnDnRM5IQJaa9XbG/Zp/IBz7aaY+WxbrlFMLdAhdGQrSV8sz
7lQsZmIvFxJSLCzuMUrZQRsNQN0BBEwTDL87j8Qi23+dZU901sNfGO1iatePCd51
vL43ortyWX0WE+cR16GOzfee4L1qFt6813RvnNqPtNt0DdM3eM99HBNm9Nz/pE3+
jUCJhbKFgpAJoV11qdRM9Qp+DZQVBsu5zMywylNVoNY225W81NZUjNwOauvfJJdp
T59u6neXpvVgkMBrx8ME
=rxP1
-----END PGP SIGNATURE-----

--=-1I1aoLs8YFyRaUFHqjNW--

