Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51135 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbYFDTGz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 15:06:55 -0400
Subject: Re: [mac80211] Implement EU regulatory domain
From: Johannes Berg <johannes@sipsolutions.net>
To: Tony Vroon <tony@linx.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1212605479.4235.1.camel@localhost>
References: <1212605479.4235.1.camel@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JX5jxoegZzkFY/Y/qlvo"
Date: Wed, 04 Jun 2008 21:05:24 +0200
Message-Id: <1212606324.14371.43.camel@johannes.berg> (sfid-20080604_210658_453842_6356D7D8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JX5jxoegZzkFY/Y/qlvo
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> =EF=BB=BFImplement missing EU regulatory domain for mac80211. Based on th=
e=20
> information in IEEE 802.11-2007 (specifically pages 1142, 1143 &
> 1148)=20
> and ETSI 301 893 (V1.4.1).
> With thanks to Johannes Berg.

Technically not mac80211 but cfg80211 ;)

> Signed-off-by: Tony Vroon <tony@linx.net>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> --- net/wireless/reg.c.orig     2008-06-04 16:29:54.000000000 +0100
> +++ net/wireless/reg.c  2008-06-04 19:25:34.000000000 +0100
> @@ -80,6 +80,23 @@
>                                      IEEE80211_CHAN_RADAR),
>  };
> =20
> +static const struct ieee80211_channel_range ieee80211_EU_channels[] =3D
> {
> +       /* IEEE 802.11b/g, channels 1..13 */
> +       RANGE_PWR(2412, 2472, 20, 6, 0),
> +       /* IEEE 802.11a, channel 36*/
> +       RANGE_PWR(5180, 5180, 23, 6, IEEE80211_CHAN_PASSIVE_SCAN),
> +       /* IEEE 802.11a, channel 40*/
> +       RANGE_PWR(5200, 5200, 23, 6, IEEE80211_CHAN_PASSIVE_SCAN),
> +       /* IEEE 802.11a, channel 44*/
> +       RANGE_PWR(5220, 5220, 23, 6, IEEE80211_CHAN_PASSIVE_SCAN),
> +       /* IEEE 802.11a, channels 48..64 */
> +       RANGE_PWR(5240, 5320, 23, 6, IEEE80211_CHAN_NO_IBSS |
> +                                    IEEE80211_CHAN_RADAR),
> +       /* IEEE 802.11a, channels 100..140 */
> +       RANGE_PWR(5500, 5700, 30, 6, IEEE80211_CHAN_NO_IBSS |
> +                                    IEEE80211_CHAN_RADAR),
> +};
> +
>  #define
> REGDOM(_code)                                                  \
>         {                                                               \
>                 .code =3D
> __stringify(_code),                             \
> @@ -90,6 +107,7 @@
>  static const struct ieee80211_regdomain ieee80211_regdoms[] =3D {
>         REGDOM(US),
>         REGDOM(JP),
> +       REGDOM(EU),
>  };

--=-JX5jxoegZzkFY/Y/qlvo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEbnc6Vg1VMiehFYAQIhVg/+IThvDfbwEaUW6bvxa5Wi51ypBJo44TM2
GFU0nx7SlavklOuTOhuomZNfl2YHicXPhLcnwRNZ21O8SKVJZPwrUwbV9taaH7gj
IFhEnKbv0UGi7wjRc/YsHyRj8G6rILlaH+U0Ysm2Aj/KLJVHm98mxeScLqCCwrOP
AP8VXMsIMOlMZ678EKCBYpRuzqycV3v0ckpjEsRPVF/ihQAXs8wh85HTN3kJm5Lg
kTEazZD9AztPjpxaTVEW6Cv3eT6OVA9kna/T4JvsLsD/+c5TyswC36TpJxRj0/Pa
isZfGmpJPqhdj+RmceVq9XmM7HlaiIGjtZQl1qxTWPZ+YlkSABMlQtQrIPHzgxHF
cY0mH+y4r7CS1OtLCVqGluwct0MuIrrCrxkaZBR+c37ZI6Xhz7VeWPscVGNs1fW+
ZlfCPECTD/5O2vthOZVlCjZh2/Xe0ZOZVNpxWRg9V9xK9GEu6zvvSNo4CJF3WncQ
hDhpRMuTef9wNJC17QMIJU22mpBwgzKjJqcceLbUuuCIJc5U5iTynk9xTUlPdOdJ
WTjbFqCrpma7WPdmbuhnXyqRad4iV2uP1d6Jrk3ErXrbZ73n8bmLujTg1uZQL8Ja
xflzwVuqZPsDC1Ko1PDdkaYY7M6mSHW5OAdgrO7A8W9bvv+w6MffB3RN+TVobMJ1
fKIY3OXRFKI=
=QFpt
-----END PGP SIGNATURE-----

--=-JX5jxoegZzkFY/Y/qlvo--

