Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41742 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbXLWKPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 05:15:13 -0500
Subject: Re: [PATCH 4/7] rc80211-pid: fix sta_info refcounting
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Mattias Nissler <mattias.nissler@gmx.de>
In-Reply-To: <20071223044357.0693c63a@morte> (sfid-20071223_034809_772408_E0BF0D14)
References: <20071223033633.710907923@polimi.it>
	 <20071223044357.0693c63a@morte> (sfid-20071223_034809_772408_E0BF0D14)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HIxaBTwZsRzQHOCPodAx"
Date: Sun, 23 Dec 2007 11:15:01 +0100
Message-Id: <1198404901.4058.4.camel@johannes.berg> (sfid-20071223_101526_228143_C6499F82)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HIxaBTwZsRzQHOCPodAx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sun, 2007-12-23 at 04:43 +0100, Stefano Brivio wrote:
> Fix a bug which caused uncorrect refcounting of PHYs in mac80211. Thanks =
to
> Johannes Berg for spotting this out.
>=20
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

Yup, this looks like the correct fix.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  rc80211_pid_algo.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> Index: wireless-2.6/net/mac80211/rc80211_pid_algo.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-2.6.orig/net/mac80211/rc80211_pid_algo.c
> +++ wireless-2.6/net/mac80211/rc80211_pid_algo.c
> @@ -254,7 +254,7 @@ static void rate_control_pid_tx_status(v
>  	/* Ignore all frames that were sent with a different rate than the rate
>  	 * we currently advise mac80211 to use. */
>  	if (status->control.rate !=3D &local->oper_hw_mode->rates[sta->txrate])
> -		return;
> +		goto ignore;
>=20
>  	spinfo =3D sta->rate_ctrl_priv;
>  	spinfo->tx_num_xmit++;
> @@ -295,6 +295,7 @@ static void rate_control_pid_tx_status(v
>  	if (time_after(jiffies, spinfo->last_sample + period))
>  		rate_control_pid_sample(pinfo, local, sta);
>=20
> +ignore:
>  	sta_info_put(sta);
>  }
>=20
>=20

--=-HIxaBTwZsRzQHOCPodAx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR241JKVg1VMiehFYAQJrCA/+OTnZyC852GridWcCPmfy3TWOXQpkMUmQ
Bz4QACr8U/8D9hJxCi6qe6xYtDoSJJSeLFQNdSybmF8wlotx9bYOQqaATQNvKI/o
5sR2bVr5i6UrqjOksNoznTLcKKTfW6llv6F9YFB4uuH7gr3fc2tVlSVmLzs0JTSW
M1yPvCkklVs1l3igMHc/52zoMLQcyi37dq/Zglz3kAT6q1FgX/isFaFe3oNGMdIG
c10KGK4mVd/MOYqJHbjSp02/7o9uTt2j6srWeqxnv7bxwBMXrlEN7MkR4i65bGgI
KsscK1jvrXo68gfg+rfbg0OHJGM9gKNiM89llKDTrcivAd68xcUgUMqvmcH7SQmj
YI+yn2mtXdYGy55P6tyd+w63T7MO3I2Tt3YVuOEvEKx+5L/r2wxDcQL98WeA0rls
fvSEIMxbFBsNPtXW2gcWYnzlB87/zk8tWUCvqBGys29wTp1JdbHG3TKJqSJv5QHB
Z17GLKxOqiDGcMJru7/J9ZIllAr7ob++WXLwprIscM5PlXbdC8eFuaK/HWg3294g
J3UfWWYwJZKzFzgpC/vfSZRrACWamXxUXd1d5vtS0y77jAxTtel0rwazclkX+yAt
wELTVmJt4tHHieVRJYvNImi8cUq2S+ri812Biq+nxqUDBp7gOQ8vJROmiov6ONbd
rVV56yauHWE=
=LvLO
-----END PGP SIGNATURE-----

--=-HIxaBTwZsRzQHOCPodAx--

