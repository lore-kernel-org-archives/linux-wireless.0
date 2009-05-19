Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42970 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbZESOx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 10:53:27 -0400
Subject: Re: [PATCH 7/7] mac80211: Do not override AID in the duration field
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090519140240.851596601@atheros.com>
References: <20090519140137.708996030@atheros.com>
	 <20090519140240.851596601@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qpcmdTCCjHEng6wXsWiS"
Date: Tue, 19 May 2009 16:52:50 +0200
Message-Id: <1242744770.4797.26.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qpcmdTCCjHEng6wXsWiS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-19 at 17:01 +0300, Jouni Malinen wrote:
> plain text document attachment (mac80211-pspoll-aid.patch)
> When updating the duration field for TX frames, skip the update for
> PS-Poll frames that use this field for other purposes (AID).
>=20
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
>=20
> ---
>  net/mac80211/tx.c |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> --- wireless-testing.orig/net/mac80211/tx.c	2009-05-19 16:32:25.000000000=
 +0300
> +++ wireless-testing/net/mac80211/tx.c	2009-05-19 16:32:42.000000000 +030=
0
> @@ -872,6 +872,8 @@ ieee80211_tx_h_calculate_duration(struct
> =20
>  	do {
>  		hdr =3D (void *) skb->data;
> +		if (ieee80211_is_pspoll(hdr->frame_control))
> +			continue; /* must not overwrite AID */

unlikely()? Also, you can 'break' instead of 'continue' or actually put
this in front of the loop since the frame cannot be fragmented.

johannes

--=-qpcmdTCCjHEng6wXsWiS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKEse8AAoJEODzc/N7+QmaodUQANGERCkgStfRSd5R5ShBiDGc
2ny7lr0P2PJ0MrUfwJAI4q94qMyWHwrE4nX7xfDHTM95bi5E8io0DOiVqvAajH2O
Vf9hUYH7/OHILWq5DVdW9+hKZztFbJ7T2vZz7LBdpcmtkoVWCfOFFd9TL0rN1DsH
ZIOKOguEDy6QPbkDtZ/21hHX8uizW8+nyK2L9oHeYw1Df+Foec0o1SniHUXulinu
M6hU2PcWhg7jzLpczfYUnImJbfWtJwQkjosorKrYPTevpCR9PE5+YeXLYSM9LO9H
ykm50UWsIXfouNHPs32Fy4yvZ7wRdKw9lWDrPs1oEQ4ToBg8nZyRljmAz+z914og
SaZWI73iKUGO93Ov3z6g0FWqR2DZwMyr6t5Wgi3NjXFbvMW3u6xoMiDjReznENn+
I8fCJ8dNBJkau8uosLAB4ePPD2yWI3j5F9sWvK5gmztQLMBqUk5i5+6XD8jkNkE+
rvoG2/yWHaiG3LC6mC+5SELTFYM0anf5hkNIruuc2jkFXS5U1XZvURTHa+NMoDFR
6e7viD8UiV74pJ57YxmWKr+AD3An4IyjzjlsGztakvIjd2yUMit4UgovaC5i0aZp
3cb58Pt/hfLbxiVVZ7K6ZLRKe8J6RJ44NisxJLG3hJYAbbstQU0bGPoMdAF3CpZz
I1BWf8Y4XEoHUZbF2mHR
=MGi1
-----END PGP SIGNATURE-----

--=-qpcmdTCCjHEng6wXsWiS--

