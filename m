Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50982 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab0AWRrr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 12:47:47 -0500
Subject: Re: hwtkip hangs on b43
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: kecsa@kutfo.hit.bme.hu, linux-wireless@vger.kernel.org
In-Reply-To: <4B5B2FCF.2000005@lwfinger.net>
References: <Pine.LNX.4.44.1001230942190.16120-100000@kutfo.hit.bme.hu>
	 <4B5B2FCF.2000005@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-urvmKoHlp2g7PoPJoghw"
Date: Sat, 23 Jan 2010 18:47:42 +0100
Message-ID: <1264268862.23766.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-urvmKoHlp2g7PoPJoghw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-01-23 at 11:20 -0600, Larry Finger wrote:

> > This is a non-SMP non-preemtive kernel.  It looks like we are entering
> > b43_op_update_tkip_key() already holding the wl->mutex. We lock mutex i=
n
> > b43_interrupt_thread_handler().
> >
> > This problem is present in stable and also in compat-wireless-2010-01-2=
2
> > shapshot if I haven't missed something. As a quick and dirty fix I have
> > removed wl->mutex lock/unlock from b43_op_update_tkip_key(). Box surviv=
ed
> > one day (until now) and a ~3GB file transfer over WLAN using hwtkip in
> > this way.
>=20
> Your analysis seem to be correct. I tested with the following patch, whic=
h tests=20
> to see if the mutex is locked on entry. If not, it logs a message, locks =
the=20
> mutex and sets a flag to indicate that the mutex should be unlocked on ex=
it.=20
> This patch is not SMP-safe, but is merely for testing. The printk stateme=
nt has=20
> not triggered after about 1 hour of testing. I'll give it a bit more test=
ing=20
> before a final patch is submitted.
>=20
> Index: wireless-testing/drivers/net/wireless/b43/main.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/drivers/net/wireless/b43/main.c
> +++ wireless-testing/drivers/net/wireless/b43/main.c
> @@ -850,11 +850,16 @@ static void b43_op_update_tkip_key(struc
>   	struct b43_wl *wl =3D hw_to_b43_wl(hw);
>   	struct b43_wldev *dev;
>   	int index =3D keyconf->hw_key_idx;
> +	bool locked_here =3D 0;
>=20
>   	if (B43_WARN_ON(!modparam_hwtkip))
>   		return;
>=20
> -	mutex_lock(&wl->mutex);
> +	if (!mutex_is_locked(&wl->mutex)) {

I think this might be because update_tkip_key is called from within the
RX path, so it's probably not even safe to use mutexes to start with?

johannes

--=-urvmKoHlp2g7PoPJoghw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLWzY6AAoJEODzc/N7+QmaQPkP/RR65Tv1euSDO9mzJZ0oYOvx
jhMLsrft6sprZYB3yl7AVj5KkUs9z0zGihWB/rTF/LiV/W7EdKmNGnyvQS12zUz2
9d89DfAh7yWVdiZdd0/Gu6CS1aiJRyITObo+1qWkngOJ7W43SwLZfbu+oetttAhi
V2KP4lu47hFDCc3MeqhAbMDGTqj1mqNV3bevB80hVZamlOMiU+knhZCt6gE6LYtG
4ww/VbwTlhaHb3eB8CotgbCa82H9ZBxq/R76/MZbT41Ntk+Db2uSzQ4meBXyP0lC
IybA5CaUMwB0jQbbaScBJdajzdbixf5vO2GcuiBDd4SlRZS4SzQzm2AK0C5FlyV+
T4uCS98j/2M7GEF2Tll7lIQBq7Ic+SqCRqVrm7q3F7cXwdWDjqtMaXXlzFAAFA5f
yCGBS9046Rtn4t4WeCrc6AiDjtVVrNHq5arjXZl8n5BELJ8aJfLyBJxiqACbOc6+
LqmcUX+i4/O8NSqKFqMoTTqYETBu0DF8PMnKUYadikieET23EEc/JCfeS61oJrHZ
6/132KFoiP4FMmlhqGUP7NPeAhinY9VdU57Rd7ylgg14drnObIcmdLz97EZ6Bmyb
k4GUNHv+Ub22w1U5bzLWKF8XI3fos8RIxWYzTsP0ikaIvfBzgbVjMWEs6q77BsQ2
3d+SM2JGhFY1kjSyDFTg
=rFcm
-----END PGP SIGNATURE-----

--=-urvmKoHlp2g7PoPJoghw--

