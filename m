Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36520 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbZGaQVy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 12:21:54 -0400
Subject: Re: [PATCH 002/002] [MAC80211] Increase timeouts for station
 polling
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1249057021.20593.5.camel@maxim-laptop>
References: <1249056817.20593.1.camel@maxim-laptop>
	 <1249057021.20593.5.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-cZ2D8AL+Jy1j9Gle8Eo/"
Date: Fri, 31 Jul 2009 18:21:33 +0200
Message-Id: <1249057293.25587.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cZ2D8AL+Jy1j9Gle8Eo/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-31 at 19:17 +0300, Maxim Levitsky wrote:
> >From 04976d22d45f26aa4b4dece5dd520e3347ac32d7 Mon Sep 17 00:00:00 2001
> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Date: Fri, 31 Jul 2009 18:54:23 +0300
> Subject: [PATCH] [MAC80211] Increase timeouts for station polling
>=20
> Do a probe request every 30 seconds, and wait for probe response, half a =
second
> This should lower the traffic that card sends, thus save power

Indeed. We just tested that :)

Acked-by: Johannes Berg <johannes@sipsolutions.net>

>=20
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  net/mac80211/mlme.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 1d8640a..e4bb590 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -42,13 +42,13 @@
>   * Time the connection can be idle before we probe
>   * it to see if we can still talk to the AP.
>   */
> -#define IEEE80211_CONNECTION_IDLE_TIME	(2 * HZ)
> +#define IEEE80211_CONNECTION_IDLE_TIME	(30 * HZ)
>  /*
>   * Time we wait for a probe response after sending
>   * a probe request because of beacon loss or for
>   * checking the connection still works.
>   */
> -#define IEEE80211_PROBE_WAIT		(HZ / 5)
> +#define IEEE80211_PROBE_WAIT		(HZ / 2)
> =20
>  #define TMR_RUNNING_TIMER	0
>  #define TMR_RUNNING_CHANSW	1


--=-cZ2D8AL+Jy1j9Gle8Eo/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcxoJAAoJEODzc/N7+QmaDFcP/0eGkcyToVUb0cuM3vfXBBVR
FG6M2Jl1b8fTe2Mpu5ql5X9T/XcxTm7xlE1eLWp+yuFvCVv9CGXMXO9q/fXIq7cb
TvkCvg+y1UliHuoxPNzjl+dId9sOTOD7Wpclta9ibW2ZijshIeoZPTGAoCYucEfX
GgP69Mxf1p+f5FnO2kQ5ucrD9lbwPEJ/dTvWX6P9y3IU61L5+fneYFGzccYUyvoJ
d8W2ZRZ2lUWX9Dv93EPxsj6t1M6pOQaR1nygwNbM0+f+oHXR97w0QzoMloT8cP+r
3DcFZEQVW6o9nKb3TV8TEiSTHWBZGqE3c3Gb8xiw7FT/kyVtvLSpC21npMiYtsII
w1S05X8/s11BucgWaTQbtELrFzEhfoo/ha5C2Ullxz6d1Soq/XtHUNZLAK7yCPw5
V6mGEbPkT89l3eOva7AvtbGUlr352dK64B/ck0WKWYbA3fw401FRjGp8VcOe8Wlh
LA2t95kQTzkm8ZhiY+2RTvvyQOQQ4nduSlkTDpVI9J1FNeTczyNP3Xk6tka7hpx8
kUTJIfnAxu77QvTfM70UWC1QVtvkoAs9ET3dPSctX3UFBQcIjuOSfMjRJY3aQcaQ
t7z9N7ZMW6Um1ECzQ3xF1k6KavnRjJOPQPAYB7Ol1r0Bsrb6YQHz3JGKzp4oV8gh
9J3sUNHnbHGEbbjIwcQ+
=XN/9
-----END PGP SIGNATURE-----

--=-cZ2D8AL+Jy1j9Gle8Eo/--

