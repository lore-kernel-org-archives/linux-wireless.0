Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33437 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbZD3V2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 17:28:20 -0400
Subject: Re: [PATCH] mac80211: fix PS vs. scan race
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1240434171.30082.21.camel@johannes.local> (sfid-20090422_230332_838939_0838D463)
References: <1240434171.30082.21.camel@johannes.local>
	 (sfid-20090422_230332_838939_0838D463)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FHUCsCV7IfuzVmD/htFk"
Date: Thu, 30 Apr 2009 23:27:44 +0200
Message-Id: <1241126864.12388.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FHUCsCV7IfuzVmD/htFk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-04-22 at 23:02 +0200, Johannes Berg wrote:
> When somebody changes the PS parameters while scanning
> is in progress, we enable PS -- during the scan. This
> is clearly not desirable, and we can just abort enabling
> PS when scanning since when the scan finishes it will
> be taken care of.

John, did this fall through the cracks? I see you included a patch from
today but not this :)

johannes

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/mac80211/mlme.c |    7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> --- wireless-testing.orig/net/mac80211/mlme.c	2009-04-22 22:57:45.0000000=
00 +0200
> +++ wireless-testing/net/mac80211/mlme.c	2009-04-22 22:58:56.000000000 +0=
200
> @@ -487,6 +487,13 @@ static void ieee80211_enable_ps(struct i
>  {
>  	struct ieee80211_conf *conf =3D &local->hw.conf;
> =20
> +	/*
> +	 * If we are scanning right now then the parameters will
> +	 * take effect when scan finishes.
> +	 */
> +	if (local->hw_scanning || local->sw_scanning)
> +		return;
> +
>  	if (conf->dynamic_ps_timeout > 0 &&
>  	    !(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)) {
>  		mod_timer(&local->dynamic_ps_timer, jiffies +
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-FHUCsCV7IfuzVmD/htFk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ+hfMAAoJEKVg1VMiehFYSl8P/AosTO66qi/n4+3n2U2w+zpu
Ea4AMre2qSLJycu1b/n5+XpvOh+DqeJSzv+uSSU5SrtHeR+zC8w9pILrUKhbtpMu
KJXRN8/rYzFsf8J637mBo5kjXYb+8vYzAonHjbwFaUQalRziJ7rVTjOwmWcGi/OK
F/vEYsW4nWnbhzOLZc+c6HkMo2Kl6NI+ki6BXCLSSNipPadmk3DekDmOUPwYPbbJ
z/5AqXhP7j/duhzp5lPpPWkZbVBlWzzzcpin0u+q9RyfzKxAJoPgHTbwKiNlmqh9
hPLhj/+mNev4p4lod+YFdg+nYMeG3CTB2tj41jB0hLjHHoZevTwjttE25MkbvqpY
sO67tS3/XoMmLtyTcyYpd0Sm1QPMOPL6NTKrTp8rFeyCr5phl860lzeySUikhe1j
N9pKn5nNDJYeXEiRndU4tBaSfHU5WRcsa4qdK3WElwsIRihHs2Kju4lykCwHe74l
TTCm5tGSTtheqSHe/tfXd7LbGluXd4uFSj4SPIFFAJJgKNWLIeT4lhgQ6kE98Vh3
s4YBcKDmz565kcRQ20XZX9xl9pZzkELAlVFjWqp+1sJjHZBOCebQaq3+tBvW9X8Q
fBfmhqseWrTIA0kluD4XGntb/1JdLYvDe1/pCXoZ+p3a2Q7k05mNq241LhixJeo+
gur3ov2SSVtog36J11mw
=VSTx
-----END PGP SIGNATURE-----

--=-FHUCsCV7IfuzVmD/htFk--

