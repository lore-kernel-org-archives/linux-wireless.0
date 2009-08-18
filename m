Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36859 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbZHRH1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 03:27:48 -0400
Subject: Re: [PATCH 09/29] mwl8k: remove usage of deprecated radio_enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090818035220.GN18639@mail.wantstofly.org>
References: <20090818035220.GN18639@mail.wantstofly.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1KSUSnKiNNWQREPU3amo"
Date: Tue, 18 Aug 2009 09:27:46 +0200
Message-Id: <1250580466.30538.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1KSUSnKiNNWQREPU3amo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-08-18 at 05:52 +0200, Lennert Buytenhek wrote:
> Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
> ---
>  drivers/net/wireless/mwl8k.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
> index 9f54204..3a201a2 100644
> --- a/drivers/net/wireless/mwl8k.c
> +++ b/drivers/net/wireless/mwl8k.c
> @@ -2935,7 +2935,7 @@ static int mwl8k_config_wt(struct work_struct *wt)
>  	struct mwl8k_priv *priv =3D hw->priv;
>  	int rc =3D 0;
> =20
> -	if (!conf->radio_enabled) {
> +	if (conf->flags & IEEE80211_CONF_IDLE) {

Ok, I thought about doing this but wasn't sure it would work -- you can
still accept channel changing commands while the radio is off, for
instance?

Anyway, this clashes with the removal of this chunk of code, which
should then just not happen.

johannes

--=-1KSUSnKiNNWQREPU3amo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKilfuAAoJEODzc/N7+QmaO20QAMNSZGRPvvRF0pyVCOKqN3mQ
B3QIa0zTJB5ShwDgWGZ4Ab18nnGNxpb8oj3DDgxrd3ATJp8B7Q6k+hlhUUKtcrqh
pPZqSyv4ZFCgsBB8Ea+AZ7d2NnIdOvYefMvY86jRA3zmp1WhgS0FOdcG4Yh1Hxgv
RtPyYR7YKG2YtH7I8yBulJQTa8uUgvRTN1tzYOPsT68GDvsAkZQwv8OgRmswDXJI
+PC3NeqVq38fs3awsCDlO/QW4JaNS7MPOIT7itp2Poen7bYx0WVh4t5D2hce37Ya
Ff+0coSm90njXVXMmHP01iUI1fBq0SnWbVIeK0ci8Jglel2/j2qmKAUgQBnBCFuO
gcex0/qM5YgNes4Ma7g6EdLbzILT6OcD/zCYzo/cOEFTO8gPKaETp8CvKmVKayt2
Npncqeumj1toQQzxixxUES1ofXuVdIpOBeJ66XE+QVxqy4+tlz6+34uEezKs+j7U
FJCbU4IGpdO2MV/czV5huh8PGY80U3NZ2GX0XsUBWvIaiSelGy/iHAvkrckCyIHy
oDVQzOB6W925NoJ+f2Vv4Cewpbd1v+Z08++sZJcxNfWpRWsBqUzKS+25YAvo0+A5
68YJVlt8NdswyFJHDnyysxcyRv2Qa8Jb7E0wlMw6aVYdTax76Ul5GC5W9blumQfx
Phjn2lwTMvXcAlGhv0Hb
=Ia0E
-----END PGP SIGNATURE-----

--=-1KSUSnKiNNWQREPU3amo--

