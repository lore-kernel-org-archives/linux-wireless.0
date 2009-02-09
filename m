Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53507 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZBIKoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 05:44:17 -0500
Subject: Re: [PATCH 3/3] mac80211: Modul. mesh path prot: Skeleton Module
From: Johannes Berg <johannes@sipsolutions.net>
To: Florian Sesser <flomaillist@cosetrain.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <944d8e06a2b02e5ae6d612fb435d540958023ff9.1234118418.git.flomaillist@cosetrain.com> (sfid-20090208_205238_672681_BE3F6B7E)
References: <498F36B7.40806@cosetrain.com>
	 <31341041c003f9a10f7ef791dc74748c0ba6b46f.1234118418.git.flomaillist@cosetrain.com>
	 <897787d59c53459e0bff3a6829ac470f6ed2e84e.1234118418.git.flomaillist@cosetrain.com>
	 <944d8e06a2b02e5ae6d612fb435d540958023ff9.1234118418.git.flomaillist@cosetrain.com>
	 (sfid-20090208_205238_672681_BE3F6B7E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-L1eS2qi4cTX9JCl/mSMm"
Date: Mon, 09 Feb 2009 11:44:11 +0100
Message-Id: <1234176251.4175.222.camel@johannes.local> (sfid-20090209_114421_519861_EC6F62FE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-L1eS2qi4cTX9JCl/mSMm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-02-08 at 20:52 +0100, Florian Sesser wrote:
> Modularize mesh path selection protocol.
>=20
> This patch provides a skeleton module, which registers itself
> upon being loaded into the kernel, but does not really do path
> selection.
>=20
> Make a mesh device use this module by insmodding it and
> issuing:
> iw dev <mesh-dev> set mesh_param mesh_path_selection_protocol_id 000F0F0F
> (of course after patching IW).

00-0F-0F   (hex)                Real ID Technology Co., Ltd.
000F0F     (base 16)            Real ID Technology Co., Ltd.
                                9F Hanmi B/D 192-19
                                Nonhyeon-Dong
                                Gangnam-Gu Seoul 135-010
                                KOREA, REPUBLIC OF

Have you asked them about using their OUI?

> Signed-off-by: Florian Sesser <flomaillist@cosetrain.com>
> ---
>  net/mac80211/Kconfig       |   19 +++++++++--
>  net/mac80211/Makefile      |    2 +
>  net/mac80211/mesh_pptest.c |   81 ++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 99 insertions(+), 3 deletions(-)
>  create mode 100644 net/mac80211/mesh_pptest.c
>=20
> diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
> index 60c1616..e635f15 100644
> --- a/net/mac80211/Kconfig
> +++ b/net/mac80211/Kconfig
> @@ -65,10 +65,23 @@ config MAC80211_MESH
>  	bool "Enable mac80211 mesh networking (pre-802.11s) support"
>  	depends on MAC80211 && EXPERIMENTAL
>  	---help---
> -	 This options enables support of Draft 802.11s mesh networking.
> -	 The implementation is based on Draft 1.08 of the Mesh Networking
> -	 amendment. For more information visit http://o11s.org/.
> +	  This options enables support of Draft 802.11s mesh networking.
> +	  The implementation is based on Draft 1.08 of the Mesh Networking
> +	  amendment. For more information visit http://o11s.org/.
> =20
> +	  Includes the HWMP Mesh path selection protocol, as that
> +	  is a requirement of the (Draft) standard.
> +
> +config MAC80211_MESH_PP_TEST
> +	tristate "80211s: Path selection protocol test module"
> +	default n
> +	depends on MAC80211_MESH && MAC80211 && EXPERIMENTAL && m

&& m ???

johannes

--=-L1eS2qi4cTX9JCl/mSMm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJkAj2AAoJEKVg1VMiehFYyZMP/AxMQLmMq00jdWEO9NzkBUcO
4PzKIbcAKyxxfS3J8nwgj5MTxvLg6vzj1RchEaXGkim8uEw8gM51GU8OSeqTykW5
j6CErp91l5/BpAf4+H9p9YV1FPh6mBdtE9aBWCrmmskjsi1/qBYzDIBvCP/zdALZ
E4oPVKi9qR8evsZ3BQEUR5y5YD6fMC+KMQOzacSvjigi5TXgAoXsVXnUOAdofYyO
PVQEOUUNSOE1NaB8ZgybS0xm/hBqytpVIQiiZVt6qHniISb3Rha/M484mL/S/cQD
S3Vgoxx6jWTPKaMDQHaWhBsTrrxVjyPmRH9TlFD6uq+10lXZpFhToaHSiZV3g4oU
erRoEk/bnRJ8w/xBAE4xDr/FEa9kjJgUYwbItM50Bth+KCOxbSkzwUPISYpxIlOA
Y2clu8c7e9HljBvnIt27nMq64m/OFEVooOGP04CJlZZdOgLqdntwlaYlYUFppqlC
8P0w9U63jmW+k1CcNWjlhcZu+oRUXUtX3jr2uhruGL7RJjiVpugPSwBJHZpA4uEJ
rTg1R6REVOk39Jrozzwui26bNBz+620hRXqjsWMmS38v4gUCPwR2aoIGT7Gpbrwn
ZcswIroUv+xSS3hR8o5GFG6AoZ4NuiLFDafEX9EnXZEjWoq9zcG1Ol1tqMx0aaDO
RPGgYUDaeBE0L0zn7Wri
=AXXF
-----END PGP SIGNATURE-----

--=-L1eS2qi4cTX9JCl/mSMm--

