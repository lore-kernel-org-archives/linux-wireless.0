Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:56540 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbbHNFK0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2015 01:10:26 -0400
Message-ID: <55CD7828.8020904@rempel-privat.de> (sfid-20150814_071030_818381_979FBE45)
Date: Fri, 14 Aug 2015 07:10:00 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: ath9k-devel@venema.h4ckr.net, dan.carpenter@oracle.com,
	Sujith.Manoharan@atheros.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org
CC: Oleksij Rempel <external.Oleksij.Rempel@de.bosch.com>
Subject: Re: [ath9k-devel] [PATCH] ath9k_htc: do ani shortcalibratio if we
 got -ETIMEDOUT
References: <20150811214324.GA30816@mwanda> <1439490098-12479-1-git-send-email-linux@rempel-privat.de>
In-Reply-To: <1439490098-12479-1-git-send-email-linux@rempel-privat.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pLbmhmc38cIVCbhALck6tPoPa3KooQsJQ"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pLbmhmc38cIVCbhALck6tPoPa3KooQsJQ
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Opps wrong email address. I'll resend the patch

Am 13.08.2015 um 20:21 schrieb Oleksij Rempel:
> From: Oleksij Rempel <external.Oleksij.Rempel@de.bosch.com>
>=20
> current code will handle -ETIMEDOUT as success which is probalbly wrong=
=2E
>=20
> According to this comment I assume it is safe to handle -ETIMEDOUT as f=
alse:
> drivers/net/wireless/ath/ath9k/calib.c
> 290         /*
> 291          * We timed out waiting for the noisefloor to load, probabl=
y due to an
> 292          * in-progress rx. Simply return here and allow the load pl=
enty of time
> 293          * to complete before the next calibration interval.  We ne=
ed to avoid
> 294          * trying to load -50 (which happens below) while the previ=
ous load is
> 295          * still in progress as this can cause rx deafness. Instead=
 by returning
> 296          * here, the baseband nf cal will just be capped by our pre=
sent
> 297          * noisefloor until the next calibration timer.
> 298          */
>=20
> Since no other error wariants are present, this patch is checking only
> for (ret <=3D 0).
>=20
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Oleksij Rempel <external.Oleksij.Rempel@de.bosch.com>
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/ne=
t/wireless/ath/ath9k/htc_drv_main.c
> index dab1323..172a9ff 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> @@ -794,8 +794,11 @@ void ath9k_htc_ani_work(struct work_struct *work)
>  		common->ani.longcal_timer =3D timestamp;
>  	}
> =20
> -	/* Short calibration applies only while caldone is false */
> -	if (!common->ani.caldone) {
> +	/*
> +	 * Short calibration applies only while caldone
> +	 * is false or -ETIMEDOUT
> +	 */
> +	if (common->ani.caldone <=3D 0) {
>  		if ((timestamp - common->ani.shortcal_timer) >=3D
>  		    short_cal_interval) {
>  			shortcal =3D true;
> @@ -844,7 +847,11 @@ set_timer:
>  	*/
>  	cal_interval =3D ATH_LONG_CALINTERVAL;
>  	cal_interval =3D min(cal_interval, (u32)ATH_ANI_POLLINTERVAL);
> -	if (!common->ani.caldone)
> +	/*
> +	 * Short calibration applies only while caldone
> +	 * is false or -ETIMEDOUT
> +	 */
> +	if (common->ani.caldone <=3D 0)
>  		cal_interval =3D min(cal_interval, (u32)short_cal_interval);
> =20
>  	ieee80211_queue_delayed_work(common->hw, &priv->ani_work,
>=20


--=20
Regards,
Oleksij


--pLbmhmc38cIVCbhALck6tPoPa3KooQsJQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlXNeDAACgkQHwImuRkmbWnJHQD+LtCtNAHiRw34V8pkN0WVzSwJ
4/hy291npxgBjiDHbi0A/iplkGfftbWtLhtg891zyseW+0sZr+U1niPDj1GRRDAX
=s+Re
-----END PGP SIGNATURE-----

--pLbmhmc38cIVCbhALck6tPoPa3KooQsJQ--
