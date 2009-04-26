Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52143 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbZDZIal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Apr 2009 04:30:41 -0400
Subject: Re: [PATCH] cfg80211: Remove unnecessary ksize() call
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <200904252228.55381.mb@bu3sch.de>
References: <200904252228.55381.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ztTvN5SOEp5yyCT6KTn2"
Date: Sun, 26 Apr 2009 10:30:31 +0200
Message-Id: <1240734631.17781.1.camel@johannes.local> (sfid-20090426_103046_523931_94BD4C73)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ztTvN5SOEp5yyCT6KTn2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-04-25 at 22:28 +0200, Michael Buesch wrote:
> This removes an unnecessary ksize() call. krealloc() will do this
> test internally and won't perform any allocation if the space is
> already sufficient to hold the data.
> So remove the redundant check.
>=20
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Good catch, thanks.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

> ---
>  net/wireless/scan.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>=20
> --- wireless-testing.orig/net/wireless/scan.c
> +++ wireless-testing/net/wireless/scan.c
> @@ -384,11 +384,9 @@ cfg80211_bss_update(struct cfg80211_regi
>  			} else {
>  				u8 *ies =3D found->pub.information_elements;
> =20
> -				if (found->ies_allocated) {
> -					if (ksize(ies) < ielen)
> -						ies =3D krealloc(ies, ielen,
> -							       GFP_ATOMIC);
> -				} else
> +				if (found->ies_allocated)
> +					ies =3D krealloc(ies, ielen, GFP_ATOMIC);
> +				else
>  					ies =3D kmalloc(ielen, GFP_ATOMIC);
> =20
>  				if (ies) {
>=20

--=-ztTvN5SOEp5yyCT6KTn2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ9BukAAoJEKVg1VMiehFYrdUP/j9Ej4iFYOKcPjAKLCje8ipP
d6GAF7hCKboUnLY4X3qGckVDb+6RIipIhwdoLPVcTCpY4KHTqJxlsNl9dJaO1Xhb
m/STL1/60Pibg0or8w9o/83sN36p1QslZNa+u/i5HWiVZwTTFXxoP8KxBj4paKV3
ilDPbOvUu2Yqnx5qlcVu9ya2PmQ56D0vYrc5KU4kHC8xAfdT29YBR7dCtwRIYa9j
o5LlVByHy/89G5VeEHbvhjmVDlY7aM0EU077ZhwbM+leBHmWVShkcbRjQCNkeykw
f5JvSpVmPJlaJn1gFnNWsG/zYGtoKrCWqZqjQy3RBlooXgRVDGMUBJ5DxKNNcg4B
L3UwwyUsYz1IwHvleoVYqsTNXChdwm7+mNyhfy8lW7C4X3Q737VOagFSk9oeMY0x
QWEbjjcz+B7rXoBTlLyQyQLbIjG+GTed8asR3MXbilmVA2l3VPkjaF92xN3F9dKD
gTQ7EAY7UlavLzHZRQPCeZ5PKpTZW+9Sm4c3Kp63jwDlrYsjY/aQnwGxRYV5/cSd
bTqaHFjWt9R88zd9YC1J9Ji275n1zkvRZOnyQb6S6Pmw6rOS7gKc4KhUcmwcWJYq
egIkRJ88V7jJQmFs/p98RzJCFQj5PDtIsCEJSXBkmloi0xnOHz5pB/xb7D8HFsbV
yqLxIdB2D4sD+W2zjeMx
=Vpr4
-----END PGP SIGNATURE-----

--=-ztTvN5SOEp5yyCT6KTn2--

