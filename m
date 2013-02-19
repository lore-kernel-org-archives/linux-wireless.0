Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:41583 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700Ab3BSNkh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 08:40:37 -0500
Date: Tue, 19 Feb 2013 14:40:28 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Georgiewskiy Yuriy <bottleman@icf.org.ru>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@lists.open80211s.org
Subject: Re: improve operational ANI in Mesh mode
Message-ID: <20130219134028.GA26332@pandem0nium> (sfid-20130219_144042_567716_E0BEABF1)
References: <alpine.DEB.2.02.1302160630580.4293@icf.org.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
In-Reply-To: <alpine.DEB.2.02.1302160630580.4293@icf.org.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Georgiewskiy,

On Sat, Feb 16, 2013 at 06:43:16AM +0400, Georgiewskiy Yuriy wrote:
>=20
> Hi, in our setups we experience pure ANI operational in mesh mode
> VS AP mode, after debuffing and digging in ANI code i find what ANI
> in AP mode work in limited mode, i try this mode with mesh and seems
> getting same good operation as in AP mode, i am not familiar with ANI
> may be there is another better way to fix this issue?

We sometimes see some problems too where we suspect ANI, but we are not
and it's hard to reproduce. Our mesh networks are IBSS mode based, not
802.11s mesh, so I wonder if we can apply your findings to IBSS mode too.

Can you describe how your setup looks like, and what difference your patches
make? Did you experience some problem which was easily reproducable?
Also, do you plan to send a proper patch?

Thanks,
	Simon

>=20
> changes what i made:
>=20
> diff -ruN compat-drivers-3.7.6-1/drivers/net/wireless/ath/ath9k/ani.c com=
pat-drivers-3.7.6-1-new/drivers/net/wireless/ath/ath9k/ani.c
> --- compat-drivers-3.7.6-1/drivers/net/wireless/ath/ath9k/ani.c	2013-02-1=
1 04:23:53.000000000 +0400
> +++ compat-drivers-3.7.6-1-new/drivers/net/wireless/ath/ath9k/ani.c	2013-=
02-16 05:03:46.640746411 +0400
> @@ -303,7 +303,8 @@
>  	ah->stats.ast_ani_reset++;
>=20
>  	/* only allow a subset of functions in AP mode */
> -	if (ah->opmode =3D=3D NL80211_IFTYPE_AP) {
> +	if (ah->opmode =3D=3D NL80211_IFTYPE_AP || ah->opmode =3D=3D NL80211_IF=
TYPE_MESH_POINT) {
> +		ath_dbg(common, ANI, "only allow a subset of functions in AP or MESH m=
ode");
>  		if (IS_CHAN_2GHZ(chan)) {
>  			ah->ani_function =3D (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
>  					    ATH9K_ANI_FIRSTEP_LEVEL);
> @@ -323,7 +324,8 @@
>=20
>  	if (is_scanning ||
>  	    (ah->opmode !=3D NL80211_IFTYPE_STATION &&
> -	     ah->opmode !=3D NL80211_IFTYPE_ADHOC)) {
> +	     ah->opmode !=3D NL80211_IFTYPE_ADHOC && +	     ah->opmode !=3D
> NL80211_IFTYPE_MESH_POINT)) {
>  		/*
>  		 * If we're scanning or in AP mode, the defaults (ini)
>  		 * should be in place. For an AP we assume the historical
>=20
>=20
>=20
> C =D1=83=D0=B2=D0=B0=D0=B6=D0=B5=D0=BD=D0=B8=D0=B5=D0=BC                 =
      With Best Regards
> =D0=93=D0=B5=D0=BE=D1=80=D0=B3=D0=B8=D0=B5=D0=B2=D1=81=D0=BA=D0=B8=D0=B9 =
=D0=AE=D1=80=D0=B8=D0=B9.                Georgiewskiy Yuriy
> +7 4872 711666                    +7 4872 711666
> =D1=84=D0=B0=D0=BA=D1=81 +7 4872 711143               fax +7 4872 711143
> =D0=9A=D0=BE=D0=BC=D0=BF=D0=B0=D0=BD=D0=B8=D1=8F =D0=9E=D0=9E=D0=9E "=D0=
=90=D0=B9 =D0=A2=D0=B8 =D0=A1=D0=B5=D1=80=D0=B2=D0=B8=D1=81"       IT Servi=
ce Ltd
> http://nkoort.ru                  http://nkoort.ru
> JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
> YG129-RIPE                        YG129-RIPE


--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEjgMwACgkQrzg/fFk7axbfzQCeKb108dNn4j4Je18D7XUrfbM1
koMAoNlHYqWpmR6/dWv1bjVhtNSEg7tN
=bh18
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
