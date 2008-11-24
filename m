Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34335 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYKXLpD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 06:45:03 -0500
Subject: Re: [PATCH 2/2] zd1211rw: enable an AP that can't support fully PS
	clients (wireless-testing).
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org, j@w1.fi,
	Daniel Drake <dsd@gentoo.org>
In-Reply-To: <eb3ff54b0811240338t7b11a1bam669f1ffa841a5e87@mail.gmail.com> (sfid-20081124_123853_670351_EFA6C16E)
References: <eb3ff54b0811232344t665fe6abp9ca2be85cfcbd855@mail.gmail.com>
	 <1227522918.3599.63.camel@johannes.berg>
	 <eb3ff54b0811240309u31944469xa444ee25f8ac8496@mail.gmail.com>
	 <1227525694.3599.95.camel@johannes.berg>
	 <eb3ff54b0811240338t7b11a1bam669f1ffa841a5e87@mail.gmail.com>
	 (sfid-20081124_123853_670351_EFA6C16E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-X1HO4ovhHEz7diyVvgEH"
Date: Mon, 24 Nov 2008 12:44:58 +0100
Message-Id: <1227527098.3599.98.camel@johannes.berg> (sfid-20081124_124507_760596_4AC3D8B9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-X1HO4ovhHEz7diyVvgEH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-24 at 13:38 +0200, Rami Rosen wrote:
> Hello,
>   I indeed intend to fix the driver to do the buffering and use
> _get_buffered_bc() (and also add sequence numbering, which is easier).
> It will take time to fix it and to test it with hostapd and clients.
>=20
> When it will be ready, the only thing which will be needed is
> to remove the "hw->wiphy->ap_ps_challenged =3D true" from
> zd_mac_alloc_hw() in zd_mac.c. The other changes in the driver should
> of course stay (adding handling of NL80211_IFTYPE_AP).
>=20
> As far as I understand, the zd1211rw is not the only one which does
> not support buffering; (and I assume there will be other such drivers
> without this support in the future); so it seems to me that the
> nl80211 patch, which enable users who would prefer to have an AP that
> can't support fully PS clients, rather than not having an AP at all,
> is a good enough reason for the nl80211 patch.
>=20
> Using Linux as an access point with a standard and a wide range of
> commodity wireless drivers seems really a nice and important feature.

Well, I'd rather have the nl80211/cfg80211 part only when we find out
that it's absolutely necessary. I don't see a problem in waiting now
until you either figure out how to fix zd1211 or determine that it's not
possible at all.

johannes

--=-X1HO4ovhHEz7diyVvgEH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJKpO2AAoJEKVg1VMiehFYGvIP/jvZrrUMgacYyRXIIvb3vYz5
MRJhzIky+QPduTjF0LyUxg/Q8tmYyk+SA3c63BENHjVcR8dWVT6a4T2T3EjmJsnb
oUhq5t6IC4LH9PZklHP0I/rgE4HwFaOfniIimgZUEMsNCBKiCBE+MpV2Xp9HXaRn
UBRNPZ72ledyciJv0qMyvoZBxXDoOMiNwNXk3XfcZTTiPfwnHhJzLnc5c1XZVryb
xUG1tfOCiwglCI4wLeOl8q7cZ7WLNM5BbPiLuro+XZd9t/LeB46/iTRnrLLFAdlY
yEa/wFU+Bzhp/dEQ6ZaAw+VXll9lDX/U6ua0xK7QVS6u4Y/t2nSlcaULKftA2XnT
sWof3IfyOe+QE/kAcWo+420enASWwDM+TgPyzdVZ9MOc2IMZUexXvzwBjh8hs1/D
uDQncdPvr5U1uAPrgvMCH29SBBLOdogs/neGDxnIVWyWjQiPz3S3YCuo6hnXapIB
vLH2WsAncfj02/KN9yGBPQfjEfl1LNDJqWpctk+U8obEgfR6toa5jPjnipOClc7H
LP8lTkaDqtOfVst/SVha/W9soTW9WlN+h4X+QQlrTgqFI/NPX+pQEcxYVhr9y2G0
IYyQz4b+Jw6zYwbxEvjgetjU8Yie5LCmRQX8Tm0q2PBC3zje0M+kYD7Hf4zAHeKy
KMi1vq0WOYI4o7ghf3Y/
=Ni+U
-----END PGP SIGNATURE-----

--=-X1HO4ovhHEz7diyVvgEH--

