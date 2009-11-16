Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53589 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbZKPR5j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 12:57:39 -0500
Subject: Re: [PATCH] mac80211: Do not queue Probe Request frames for
 station MLME
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20091116175408.GA6805@jm.kir.nu>
References: <20091116175408.GA6805@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-H15lQvsc86sPkwH9skMS"
Date: Mon, 16 Nov 2009 18:57:41 +0100
Message-ID: <1258394261.32159.31.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-H15lQvsc86sPkwH9skMS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-16 at 19:54 +0200, Jouni Malinen wrote:
> Cooked monitor interfaces cannot currently receive Probe Request
> frames when the interface is in station mode. However, we do not
> process Probe Request frames internally in the station MLME, so there
> is no point in queueing the frame here. Remove Probe Request frames
> from the queued frame list to allow cooked monitor interfaces to
> receive these frames.
>=20
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

It's also just unnecessary overhead to put them on the list and process
them by freeing :)

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

>=20
> ---
>  net/mac80211/mlme.c |    1 -
>  1 file changed, 1 deletion(-)
>=20
> --- uml.orig/net/mac80211/mlme.c	2009-11-13 16:58:27.000000000 +0200
> +++ uml/net/mac80211/mlme.c	2009-11-13 16:59:20.000000000 +0200
> @@ -1898,7 +1898,6 @@ ieee80211_rx_result ieee80211_sta_rx_mgm
>  	fc =3D le16_to_cpu(mgmt->frame_control);
> =20
>  	switch (fc & IEEE80211_FCTL_STYPE) {
> -	case IEEE80211_STYPE_PROBE_REQ:
>  	case IEEE80211_STYPE_PROBE_RESP:
>  	case IEEE80211_STYPE_BEACON:
>  	case IEEE80211_STYPE_AUTH:
>=20


--=-H15lQvsc86sPkwH9skMS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLAZKSAAoJEODzc/N7+QmaYs8P/i4FQpAu9CzX24Aspm4Ge+3x
Lvif3/ksfXbRolKQXAGP5H5Xvd43vNKwH5qIoiqZzNGfViesjQW1fZM82FoRUv9L
eHnW2kEEb1mW29DA+aKadxVIR7FGLOyi5OL8uF/uDLSbVvJfLg6KIqDcmZd+oAbt
8wAbo10DuKo8d/CcZho/3lMGaYFhbcx9OqaBxgIQ7IPTNhMbaz97OHVJKqNGVFhL
ibcJu9CB0uNNOs/ZoAGXrkjx1FJB88E3uGYdBPsnSHC3jm86Cn6oeCGDRyVU6HE7
G6NkZC8gNLtVYti+/zmLFxZzrgGSrlpoLc8mawIhX7uSQgHeMRA3XtnNI6/b8t9i
wiI+WGQGJpKYBwhQYMTaWfA6YSk2EebG1f2bfhCjd4hORULbHwrOqnWKKa+5XQ77
WFfD4wyUezIIAsOD1qSqpvx/GGylesEh3+8YN0eaN4oY3REyZjKlycHfWJvgS5oN
dB9GdFMtbLy1fDDP/JjCTqFK6r7WsnWVK012AvRXqNReielMv3AGHoYglK28eUel
oiPS/VECSC653uZ9xMm+3hM9Lx5AJCwP8dlTAHdrHt4aylXaGUKwLumJs2pml/td
/KVgb7d3FQgL8P40S+sI7ynGaLWlLuvDvOcoA8fQjK2OKKJePU0xYF4PLlk/lnfO
iRoyKUOMdwdhZMRHwwDa
=wPNF
-----END PGP SIGNATURE-----

--=-H15lQvsc86sPkwH9skMS--

