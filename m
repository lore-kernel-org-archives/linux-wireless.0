Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54207 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab0AWSxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 13:53:52 -0500
Subject: Re: hwtkip hangs on b43
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, kecsa@kutfo.hit.bme.hu,
	linux-wireless@vger.kernel.org
In-Reply-To: <201001231919.32466.mb@bu3sch.de>
References: <Pine.LNX.4.44.1001230942190.16120-100000@kutfo.hit.bme.hu>
	 <4B5B2FCF.2000005@lwfinger.net> <1264268862.23766.0.camel@johannes.local>
	 <201001231919.32466.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-RHZofO1DUM0CdkN97JBn"
Date: Sat, 23 Jan 2010 19:53:48 +0100
Message-ID: <1264272828.23766.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RHZofO1DUM0CdkN97JBn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-01-23 at 19:19 +0100, Michael Buesch wrote:

> > > -	mutex_lock(&wl->mutex);
> > > +	if (!mutex_is_locked(&wl->mutex)) {
> >=20
> > I think this might be because update_tkip_key is called from within the
> > RX path, so it's probably not even safe to use mutexes to start with?
>=20
> Well, if mac80211 does a callback into the driver on behalf of a driver c=
all,
> that is broken design. It would break for all locks, not just mutexes.

Yes, but

> We should probably switch back to ieee80211_rx_irqsafe to workaround thes=
e
> circular locking problems.

Actually you can't, because you can't acquire the mutex here since we're
in an atomic section. So relying on it being already locked is probably
safer. However, you can't actually sleep anyway...

the proper fix would be to delay the call in mac80211 to a work.

johannes


--=-RHZofO1DUM0CdkN97JBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLW0W4AAoJEODzc/N7+Qma9r4P/3u4ZH1S33UGi/Ox/tEGaV12
cVnKyDmehZNYjDzv3pBQs0LqhVeI9LPE/EmF6GWRjbRG6LWLxsOvgbQJ464hiJ4g
QGuBWDAEXJ4JNI1yfwx2Egy4l5spg0buzkaqhZrVMww4/yutFWyhqcQoc66HK1qn
jKA9RWnwBxeiO9ZIYzcrUWklxItD+YoBcyIx0sjoGDZHR5qJDAYWA8ORye/TI0rV
cQl+cQs0G0sjbw5dBaliPZYCfrDMuXKzwzrMg04QFbRI2GjewtH+WI9Q0j+GHNvP
BLzU+EewLBW161ZuNYAsnx9gCmV0gGRNHfSA23k2J/LI6RS8j+HTU1OkARN+1xGq
MozvUL9xK/RqzZQI0vXBqpCqiBNp++UV3VX95P3vuYrsK70eUe47kTInQsX6kOjk
A9hE6o1tVZv7bUMn5AOMi8g4RiSIIZoGR/jUVK2k4f4dVC5zHhOP3vuezvWmXbWo
LgMc51PgBCCvBOZCNtu5WQ7N+/5T//yeWotkaUwBnEfmyCbxjh0QAi4gh/iEDlpl
ZO8aMsRo1LkNUg7f3VZIXcd6HikLyNSwT0U9MS9f3n112EEfcihjyz0lYugji1vR
KUo23Wuk5bhtt6MnX/y+feQxV5cK4XxPLMV8uq5HHzpeQsQgEB3KGvf5lJWcZi8Y
j9dMxZ352xBX0JirzcJ7
=jvuK
-----END PGP SIGNATURE-----

--=-RHZofO1DUM0CdkN97JBn--

