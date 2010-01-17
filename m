Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48330 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753515Ab0AQWtR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 17:49:17 -0500
Subject: Re: [PATCH 1/2] mac80211: fix sign error in pid controller
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stefano.brivio@polimi.it
In-Reply-To: <1263670613-10864-2-git-send-email-me@bobcopeland.com>
References: <1263670613-10864-1-git-send-email-me@bobcopeland.com>
	 <1263670613-10864-2-git-send-email-me@bobcopeland.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-r6kybQc1CPEXyARfAvOZ"
Date: Sun, 17 Jan 2010 23:49:13 +0100
Message-ID: <1263768553.3402.9.camel@kea>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-r6kybQc1CPEXyARfAvOZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-01-16 at 14:36 -0500, Bob Copeland wrote:
> While testing the pid rate controller in mac80211_hwsim, I noticed
> that once the controller reached 54 Mbit rates, it would fail to
> lower the rate when necessary.  The debug log shows:
>=20
> 1945 186786 pf_sample 50 3534 3577 50
>=20
> My interpretation is that the fixed point scaling of the target
> error value (pf) is incorrect: the error value of 50 compared to
> a target of 14 case should result in a scaling value of
> (14-50) =3D -36 * 256 or -9216, but instead it is (14 * 256)-50, or
> 3534.
>=20
> Correct this by doing fixed point scaling after subtraction.
>=20
> Cc: stefano.brivio@polimi.it
> Cc: mattias.nissler@gmx.de
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

I took a quick look and found that you're right. pf is an unscaled
value, so we should subtract it before scaling.

Acked-by: Mattias Nissler <mattias.nissler@gmx.de>

> ---
>=20
> Mattias / Stefano, please advise if I missed something.
>=20
>  net/mac80211/rc80211_pid_algo.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_a=
lgo.c
> index 699d3ed..29bc4c5 100644
> --- a/net/mac80211/rc80211_pid_algo.c
> +++ b/net/mac80211/rc80211_pid_algo.c
> @@ -190,7 +190,7 @@ static void rate_control_pid_sample(struct rc_pid_inf=
o *pinfo,
>  	rate_control_pid_normalize(pinfo, sband->n_bitrates);
> =20
>  	/* Compute the proportional, integral and derivative errors. */
> -	err_prop =3D (pinfo->target << RC_PID_ARITH_SHIFT) - pf;
> +	err_prop =3D (pinfo->target - pf) << RC_PID_ARITH_SHIFT;
> =20
>  	err_avg =3D spinfo->err_avg_sc >> pinfo->smoothing_shift;
>  	spinfo->err_avg_sc =3D spinfo->err_avg_sc - err_avg + err_prop;


--=-r6kybQc1CPEXyARfAvOZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEABECAAYFAktTk+gACgkQwJO1cHm4WqZi2wCdFDq77ozayGUMmm31kOw6bE5A
Y6kAn0alterZgyyh1VZSdxckuonVRhL8
=Kxjx
-----END PGP SIGNATURE-----

--=-r6kybQc1CPEXyARfAvOZ--

