Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60998 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZICH1L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 03:27:11 -0400
Subject: Re: [PATCH] cfg80211: clear cfg80211_inform_bss() from kmemleak
 reports
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1251958266-10692-1-git-send-email-lrodriguez@atheros.com>
References: <1251958266-10692-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+9yvJaL0W/agTYkG+fFE"
Date: Thu, 03 Sep 2009 09:26:31 +0200
Message-Id: <1251962791.3336.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+9yvJaL0W/agTYkG+fFE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-03 at 02:11 -0400, Luis R. Rodriguez wrote:
> This was giving false positives. We use eventually free this
> through kref_put(), things are not so obvious through
> cfg80211_bss_update().
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/wireless/scan.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index 19c5a9a..79f7a5d 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -495,6 +495,9 @@ cfg80211_inform_bss(struct wiphy *wiphy,
> =20
>  	kref_init(&res->ref);
> =20
> +	/* cfg80211_bss_update() eats up res - we ensure we free it there */
> +	kmemleak_ignore(res);
> +
>  	res =3D cfg80211_bss_update(wiphy_to_dev(wiphy), res, 0);
>  	if (!res)
>  		return NULL;

That's not making sense. cfg80211_bss_update() doesn't actually take a
reference, it adds a new one for itself and then we return one to the
caller. Why can it not track this?

Actually it looks like we do leak one in net/mac80211/ibss.c.

johannes

--=-+9yvJaL0W/agTYkG+fFE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKn2+hAAoJEODzc/N7+QmaJJcP+waRZoMq1thDsBh58t6ly6L+
vqus3RxdyUz8QIoTXbqM6GWFQA2AvRNL+CRCYr2B/IkjCDPACskRkIr217HzFNiT
GvvpiVmjLWZuUnge3Tk4bzP9pFHlg3FsqttJ1BTwAJw3NXZbDZ2AlJlp54doXvDi
gdogrNh6W5kToAd3c0c3mPhYNZfqhOuqsy19SmcUKNf7O1CIxadv+xdX0J8vncD+
KyzzTDb6l+T+c2X6t4T04dEWUu8xOa+r9u5wsEX073Dv3pp9VEFD8S/DCI1LPj30
v/XL0gU7Pa81VGC5wSBNg6tS3RrGEh84UkmgM/X7EnNRO9mDhFy42C/enh3HlfMy
TuP5EZsjOWGc8G+3QzUiINrkPFLDojdEGDEP9FEID32GzS/PwtIsiBAqVIJ+2zGY
HPxTv9CC6NTU3RkPNh5xO5zlZDVJK/UCmsQ4/y3+Y6cCQ7Jnvqd+apShhqPcgA+3
P6mJHac4fY375+gRWrif6b/cM1r/f1xl9OS6IE2groOVw8ajNC9o4mgALk6MEwof
IOpWTB0QuL8saXbZD9CRdFykG1x0LVl7A0Ygqd+2LOHz4qMKy1N9o7REmNI3H2vT
IuXYmFJPZSgNHdu5gCdHKyIxmMCh7s8q1j5HoR0XBjGry/pQJVxWFMEZsjp3TVEE
HEDzppFR+MVq50oCnHrR
=OZPL
-----END PGP SIGNATURE-----

--=-+9yvJaL0W/agTYkG+fFE--

