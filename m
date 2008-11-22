Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58622 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758763AbYKVR7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 12:59:52 -0500
Subject: Re: ieee80211_wep_encrypt_data_fix_unaligned_access.patch
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivan Kuten <ivan.kuten@promwad.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <eaf88bcfcb5b61c24cf1b8b682c5ff3c@promwad.com> (sfid-20081121_234653_121082_4B762D50)
References: <eaf88bcfcb5b61c24cf1b8b682c5ff3c@promwad.com>
	 (sfid-20081121_234653_121082_4B762D50)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cYqZBFeY063sDLhG0daU"
Date: Sat, 22 Nov 2008 18:59:48 +0100
Message-Id: <1227376788.3599.24.camel@johannes.berg> (sfid-20081122_185954_462483_A4AD4E71)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cYqZBFeY063sDLhG0daU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-22 at 00:46 +0200, Ivan Kuten wrote:
> Hello,=20
>=20
> Please review the following patch which is supposed to fix unaligned acce=
ss
> on Blackfin architecture.

any other architecture too...

> In function net/mac80211/wep.c ieee80211_wep_encrypt_data:
> __le32 *icv;
> icv =3D (__le32 *)(data + data_len);=20
>=20
> after the operation above icv pointer may become unaligned.=20
> The patch below fixes this issue:
>=20
>=20
> --- linux-2.6.28-rc3/net/mac80211/wep.c 2008-11-20 00:04:58.000000000 -05=
00
> +++ linux-2.6.86-rc3.new/net/mac80211/wep.c     2008-11-22
> 00:37:53.000000000 -0500
> @@ -123,10 +123,10 @@
>  {
>         struct blkcipher_desc desc =3D { .tfm =3D tfm };
>         struct scatterlist sg;
> -       __le32 *icv;
> +       __le32 icv;
>=20
> -       icv =3D (__le32 *)(data + data_len);
> -       *icv =3D cpu_to_le32(~crc32_le(~0, data, data_len));
> +       icv =3D cpu_to_le32(~crc32_le(~0, data, data_len));
> +       put_unaligned(icv, (__le32 *)(data + data_len));
>=20

looks fine, you just need to send a proper changelog and s-o-b

johannes

--=-cYqZBFeY063sDLhG0daU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJKEiPAAoJEKVg1VMiehFY67YQAJtxNY8rKRnKV7RWHS40pKyw
o9+xG1+uwtO1LWr6VUuFwUBBNeXpIiFxNUO3zQ7vLRW5VTuDkaCzv23zRa/5cdlY
kM6qB4LKJkGDv770zz2BWIJCHI/R7TAX57+UaMHngkJR2wzHt0w6IcVJlKv5n9yp
rm732LFbtR99K1vSEXRs998KT8+0XdftoEnGmNSNz86bT6p4s2exEJCG4hL0MABe
zWt+WI1WuTRdapCEmtWnYuluF/X3zuzmU8rPmWWCnBfXj+rJhe6zBBxDhVTtUVew
X+iy6aNfMgL2ypI9mPblbb+w2FJJekIwKg3w3+pw/Fj7SaFTg4j6REn6x6SL4Yce
YFtUflV/rqEMbHVAlhqB4oSgCCO025K2CiOB0d7eDNgo+nkNGJhfXo65+baeWnZx
cYHms0rJsemdtSKkVy0yVNIQOwWSl/fs9TVh6gh5RWs+RORN6BWhkhA5afUg4iAs
lYWjjSxf5IYnea8dyN6x3gwqgfdwdQN10bd5YiA10Qg3qBDZyE0lenuPpoGKzAkj
/yPWMvg0imdn9MH0ed9a7PNJ3VUxZ+4LHKn/Y6CefcsWY2wEmsVAkj+ivjcBbmDA
vc7oq0DslDl7iqMYKc3XBcUs46RXPy45zfH+rGIpsaXoJNBF0tPWz8KXfJsNqAHe
XOt4d8DR1+M11WdpBjUO
=LogK
-----END PGP SIGNATURE-----

--=-cYqZBFeY063sDLhG0daU--

