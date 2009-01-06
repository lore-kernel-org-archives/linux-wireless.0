Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46734 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbZAFNP5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 08:15:57 -0500
Subject: Re: [PATCH] Fixed BSSID step 1: Disallow to set multicast BSSID
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <20090106014135.302730@gmx.net> (sfid-20090106_024205_979845_6893AA18)
References: <20090106014135.302730@gmx.net>
	 (sfid-20090106_024205_979845_6893AA18)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5FUS2dzn1RSa55rOw0YW"
Date: Tue, 06 Jan 2009 14:16:45 +0100
Message-Id: <1231247805.3503.13.camel@johannes> (sfid-20090106_141603_170042_FA62EC8A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5FUS2dzn1RSa55rOw0YW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-06 at 02:41 +0100, Alina Friedrichsen wrote:
> Okay, here is the first of the five patches. After applying all of them y=
ou should be able to build/join huge city mesh networks (e.g. with the OLSR=
 protocol) with the most of the mac80211 wireless drivers by setting a fixe=
d BSSID in the ad hoc mode. (If you found no other bug/problem.) This was n=
ot specified in the original standard, but is a widely used de facto standa=
rd.
>=20
> The first patch now completely disallow to set multicast MAC addresses as=
 BSSID. The behavior before was really strange.
>=20
> Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>

These look ok to me, with proper changelogs. Thanks. You should have
made the subjects

[PATCH 1/5] mac80211: Disallow ...

etc. and also line-wrapped the changelogs, since these are fed directly
into git normally.

> diff -urN compat-wireless-2009-01-05.orig/net/mac80211/mlme.c compat-wire=
less-2009-01-05.work/net/mac80211/mlme.c
> --- compat-wireless-2009-01-05.orig/net/mac80211/mlme.c	2009-01-06 01:38:=
05.000000000 +0100
> +++ compat-wireless-2009-01-05/net/mac80211/mlme.c	2009-01-06 01:47:41.00=
0000000 +0100
> @@ -2576,11 +2576,16 @@
>  {
>  	struct ieee80211_if_sta *ifsta;
>  	int res;
> +	bool valid;
> =20
>  	ifsta =3D &sdata->u.sta;
> +	valid =3D is_valid_ether_addr(bssid);
> =20
>  	if (memcmp(ifsta->bssid, bssid, ETH_ALEN) !=3D 0) {
> -		memcpy(ifsta->bssid, bssid, ETH_ALEN);
> +		if(valid)
> +			memcpy(ifsta->bssid, bssid, ETH_ALEN);
> +		else
> +			memset(ifsta->bssid, 0, ETH_ALEN);
>  		res =3D 0;
>  		/*
>  		 * Hack! See also ieee80211_sta_set_ssid.
> @@ -2594,7 +2599,7 @@
>  		}
>  	}
> =20
> -	if (is_valid_ether_addr(bssid))
> +	if (valid)
>  		ifsta->flags |=3D IEEE80211_STA_BSSID_SET;
>  	else
>  		ifsta->flags &=3D ~IEEE80211_STA_BSSID_SET;
>=20

--=-5FUS2dzn1RSa55rOw0YW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJY1m6AAoJEKVg1VMiehFYQIwP/11yySw7qyJWZ7c4idtnQyS1
xb5Iup6x+ddKXChruZ1e90PSRRkE9sBE0JCoyapbn/AoytkmUMllH70Bb2Sai49V
pZJCupQpuhGgDDt6Cl7frwAu/Bry0OLe6EosZ3/cfSoom6p4+v/EZkJ2+8xGlwiZ
yO6J9OQUDREZNsbcNmcj7k1Nvu6QuZWEcXcigUvsJ5MMIFoi5RpV7ackrZ7UcwRT
ywCKV9f8UuzejRfc9DN+vZ05Psj/i7OaiVHGvFCxQQRpW62d1gYiQxM2xwpsw222
xWJTyPehLMMlicHxBGpW8h3E5NydXNa7BW6wRD08RyYeLYrvV60KC08iAzIVy0oa
+NFs56pqBeIYFEoJ5yujJTPVOjRfxsLzgectWdaNK043We9P4SbbiL9ATVMvCviW
GDXIRJx/Mz5yMElc+gN6Rb1MTRumM/ugFLitGuibFF4lf2IBQJFlCl3CaUHRf9xn
hwDp7Qu8ZkVIpsWzi1hTBXUmm+8P3QV5TWzRH+Ya+o/ttpMw9f2jAVSeKHKxZ2cK
Btt4436MHdXyD4dmmwdOS7lObUCFmUd2rc/4AhuKbN/hzqpXYmhi/X1/TRbhHGu+
1O6NeuOwjubS9dfwyN5fsTYaXuvGvCIoRwNF2kt5lXUWNsko5y1oIYy8blyyM2QX
u7lYXJ9wqIoxKqB3ICRp
=q63V
-----END PGP SIGNATURE-----

--=-5FUS2dzn1RSa55rOw0YW--

