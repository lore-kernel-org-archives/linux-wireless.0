Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56711 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZFKUGd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 16:06:33 -0400
Subject: Re: [PATCH] mac80211 : fix a race with update_tkip_key
From: Johannes Berg <johannes@sipsolutions.net>
To: gregor kowski <gregor.kowski@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <83a869cd0906101242w2ae8480cle69abd19a9d87112@mail.gmail.com>
References: <83a869cd0906071445i13a5398y5e94ea3d91123c3b@mail.gmail.com>
	 <83a869cd0906071449u4ae8832bu168322ae4a7cd2a3@mail.gmail.com>
	 <1244442549.11006.2.camel@johannes.local>
	 <83a869cd0906081051h2e82bba2q731be9f84bc1846a@mail.gmail.com>
	 <1244556179.4672.11.camel@johannes.local>
	 <83a869cd0906091048k68616c11k16fa98403aa770b@mail.gmail.com>
	 <1244569926.18481.27.camel@johannes.local>
	 <83a869cd0906101242w2ae8480cle69abd19a9d87112@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sCV90nbmKy31LLyW/qsP"
Date: Thu, 11 Jun 2009 22:07:16 +0200
Message-Id: <1244750836.29447.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sCV90nbmKy31LLyW/qsP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-10 at 21:42 +0200, gregor kowski wrote:

>  	if (only_iv) {
>  		res =3D TKIP_DECRYPT_OK;
> -		key->u.tkip.rx[queue].initialized =3D 1;
> +		key->u.tkip.rx[queue].initialized =3D 2;
>  		goto done;

Please change this variable to an enum with proper states.

> -		if (key->local->ops->update_tkip_key &&
> -			key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
> -			u8 bcast[ETH_ALEN] =3D
> -				{0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
> -			u8 *sta_addr =3D key->sta->sta.addr;
> -
> -			if (is_multicast_ether_addr(ra))
> -				sta_addr =3D bcast;
> -
> -			key->local->ops->update_tkip_key(
> -				local_to_hw(key->local), &key->conf,
> -				sta_addr, iv32, key->u.tkip.rx[queue].p1k);
> -		}
> +	}
> +	/* initialized =3D=3D 2 means we already call update_tkip_key */
> +	if (key->local->ops->update_tkip_key &&
> +		key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
> +		key->u.tkip.rx[queue].initialized !=3D 2) {

and please indent only to after if ( here, like this:

	if (key->... &&
	    key->flags & ...
	    key->...) {
		u8 bcast[...]...

johannes

--=-sCV90nbmKy31LLyW/qsP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKMWPxAAoJEODzc/N7+Qmay5UQAMNgqcy1rNa0Qj9U8GmxkdxU
kjP19GCduKxP0LX7Xs9uQsKTFlu63DKTZF9OXi+XvsyEcWoEVI38fwiTES6sWhrt
FWSysgPrixNszpjhnO6DKWb+bOMDYOh1UN+AMXpULX3KlAoMaxZQ0rMiBuk9B06q
edFv+U/QbXC50sMzgbeZPuKuPi3+04xpLXym0uqIDBorzaSshMDs7Su1ryjeGa+U
qPAZfngueR1VVNOywh8DQfarsOa7WVFbFsneMAvzSoXW8ux5hy/UCJQSsrXbKjHh
H/O1NI/ohzYT6zfxG79bIyRPVCyUlDuy05NQxHBcZ81HrLvbKcO04yWWXKknhd8W
OpLNstjmSb9wNuPf/eNg9SyunMBXeRBDwBxFwA7H3Ac4eEZn3f2yVKTIWZ4nqP14
9cmUkvipPBThUG/evLITxNDLtne3WsGnxtzzuQU1g0llaZNeLf6BIazMpDR64Nnt
jFhBFwsjAb/uOZlDr9F2fOxq89EwEQRarPCqYehslghr7cxCjlwuUj5wdcVuQuwL
jgh7frsyeptqf8xU6443XIfthKm7QcE7JIj9DQLotLZ4bVC6rn+3DrTrBwBZ/Br4
qpq7GIZKOJyh97coKYdz2WGcV9rMx3KYH4/sRaOF5ZdqFdAje8mgFURs5zIZ5GcP
HYHkOC9eiOHYdW2l0awv
=tsYa
-----END PGP SIGNATURE-----

--=-sCV90nbmKy31LLyW/qsP--

