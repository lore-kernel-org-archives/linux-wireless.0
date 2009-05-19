Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41892 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbZESUKS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 16:10:18 -0400
Subject: Re: [PATCH] mac80211: don't try to do anything on unchanged genIE
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1242760372.4797.70.camel@johannes.local>
References: <1242760372.4797.70.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/c8kVfktm6rNG9Qe4put"
Date: Tue, 19 May 2009 22:09:43 +0200
Message-Id: <1242763783.31350.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/c8kVfktm6rNG9Qe4put
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-19 at 21:12 +0200, Johannes Berg wrote:
> When the genIE hasn't changed there's no reason to kick
> the state machine since it won't be able to do anything
> new -- doing this decreases the useless work we do for
> reassociating because if we do kick the state machine
> it will try to find a usable BSS but there might not be
> one because wpa_supplicant will only change the BSSID
> a little later.
>=20
> In a sense this is a workaround for userspace behaviour,
> but on the other hand userspace cannot really keep track
> of what the kernel currently has for genIE since any
> process could have changed that while wpa_supplicant
> wasn't looking.
>=20
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/mac80211/mlme.c |    4 ++++
>  net/mac80211/wext.c |    5 +++--
>  2 files changed, 7 insertions(+), 2 deletions(-)
>=20
> --- wireless-testing.orig/net/mac80211/mlme.c	2009-05-19 21:01:09.9239128=
95 +0200
> +++ wireless-testing/net/mac80211/mlme.c	2009-05-19 21:01:37.662665272 +0=
200
> @@ -2496,6 +2496,10 @@ int ieee80211_sta_set_extra_ie(struct ie
>  {
>  	struct ieee80211_if_managed *ifmgd =3D &sdata->u.mgd;
> =20
> +	if (len =3D=3D ifmgd->extra_ie_len &&
> +	    !memcmp(ifmgd->extra_ie, ie, len))
> +		return -EALREADY;
> +

Oops, this is buggy when extra_ie is NULL.

johannes


--=-/c8kVfktm6rNG9Qe4put
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKExIDAAoJEODzc/N7+QmaurIQANOjLoQjdFo7tF3lW4TwHXSx
pWdg2ZaGyVKiL7IOg7sDybbEtqqvkvqCxLZSbFCFmcM0/Wj3G907pAtWLrRT/kI4
qOcvwSDnJqQdE+QsHJJIgpiDJb8utQPmRV+R5jLwnHOIZ95zsUuoDPG3caMPLubF
OGUomqbD/ICdl7WDIGWdatoG0NQqXF3JvnG+d0qjWlQsYiVozBq1tHI25QDiIksO
ZNa/0osyyaqRoWL3NO2g6E4O/h70en0FIwqM0QnAdqNLXIyXWGecvo9NLX+DNxqi
MXyiEGF5wu2rHd7FD6iUV1XaT99M9Ajyy/aRaFiNSxzDdQB9YRPLKmpy/yYNqvYq
9hqg5fR5V6hLFUjtUoG+NYwIWKni85NFDNXADvNq/QiftofUmrAsDP/xGyzJsSbI
nP4ojWB3M8H4QAyZY7X+7Sr+lG0NqNY6Y1yoofBzSbEkUkJb++7g//6hJcIHH1zJ
v6/xvbHi7sD1VHaXsLOv9qC2pvp9fgP4miztinKbBQ8z9b8IhpzwebVleTBdU+QG
sKE3nyCAA04qU0C9PkGv/OzLneYwyTSphhyVOBh92Tgj/94/TapgXPnDy1wnIHBX
01y1lhNwWHJKsTXMY8iQ+MAdB0E4Ty8FtoSSXAOxCDxDAltwrZcKa9LvJZJ962m4
krtS8kl0xHi91vnWIwwd
=3zhX
-----END PGP SIGNATURE-----

--=-/c8kVfktm6rNG9Qe4put--

