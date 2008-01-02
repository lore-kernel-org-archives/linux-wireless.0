Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54510 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYABOEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 09:04:49 -0500
Subject: Re: [PATCH] mac80211: better rate control algorithm selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <20071230231120.GB16557@uranus.ravnborg.org>
References: <1198253375.16241.76.camel@johannes.berg>
	 <20071230231120.GB16557@uranus.ravnborg.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yk5lRaAUM3SFdWGA1X0h"
Date: Wed, 02 Jan 2008 15:04:26 +0100
Message-Id: <1199282666.4172.85.camel@johannes.berg> (sfid-20080102_140453_456103_3DC68126)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yk5lRaAUM3SFdWGA1X0h
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Sam,

Thanks for your reply.

> MAC80211_RC_PID build-in =3D>
>     rc80211_pid_algo as build-in
>     rc80211_pid_debugfs as build-in if CONFIG_MAC80211_DEBUGFS equals y (=
is enabled)
>=20
> MAC80211_RC_PID module =3D>
>    rc80211_pid.o as a module=20
>    rc80211_pid_algo.o and rc80211_pid_debugfs.o are ignored

Well, 'ignored' may be too strong since rc80211_pid.o is built from the
latter two objects.

> # If RC algorithm in build-in
> rate-rc-y :=3D rc80211_pid_algo.o
> rate-rc-$(CONFIG_MAC80211_DEBUGFS) +=3D rc80211_pid_debugfs.o
>=20
> # If RC algorithm is modular
> rate-rc-m :=3D rc80211_pid.o

I don't think that will work since the system won't know how to build
rc80211_pid.o. I have another patch inspired by yours which is much
better than my first, just need to test it.

johannes

--=-yk5lRaAUM3SFdWGA1X0h
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3uZ6aVg1VMiehFYAQJZKA/+JK+6S7BMiJiFM4iDWwW5u3wr9Pzw/EYO
pvb6Fhn7UT61JBaUc+CqV46lIQtIlNheSlXpUEpCbH8Z27EvlibqCvtq1g3P3zeE
og2NunZKJ4Q7L3wrTQBsbI6W+a9DXozlhFaU1eLTfopLM0/SQAph1PbLGF7ef/+b
o+Bjl/r1Sgaz6AzlfBpNIkxDJnetC6RwvIbfkUrSa8drHyZlS5MiXxEnmuOY3SgD
/9PNIk6YXQFpdI5gH+1Ntpt/ZIj2dmDImI6HUfz/yWdcYw0Ni1seR/2OflquOO/R
YB5rO0V2LSZEuex9R0TcYTP/fVPwlsVLeun5QH7n8nfpFE6/MzXm9FL+G5zLysUZ
TtG3YLWggkTVcmGyUqlXURbSXMFNpqH3X3caH6rQ8QGTNaUa4gB3MCOW5LNciIYt
SCIvWn/xvN4KXsMSayiU7gAQr0UXVe3NlyukKtxXk60k3Is1Mi/4xZ59bkJ8298H
hfK1CP2bVvSNZREk09Z8AEWQYc6ZaAZUd8nQBHex3J77M/dKIlWz7jwGmeZ8m1kU
arAiEsVdtrnq1GmObOYUIS8FpcR5R/wDtzehABNw1All/3pRLYjZBr6CHsT/mMus
aCwkdtjz2S1YpABweaosialKQAXDjMOGzs0poeE2YCZpSyQyyY4km3XxlQt3vL/q
Ta+iTkszeuA=
=FcEn
-----END PGP SIGNATURE-----

--=-yk5lRaAUM3SFdWGA1X0h--

