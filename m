Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45318 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524AbZKWJiH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 04:38:07 -0500
Subject: Re: Question about mac80211 callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4B09EF44.3050804@lwfinger.net>
References: <4B09EF44.3050804@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AD8J7uCoLXMsqb1+0gGi"
Date: Mon, 23 Nov 2009 10:38:10 +0100
Message-ID: <1258969090.7094.133.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AD8J7uCoLXMsqb1+0gGi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Larry,

> I tried to figure this out from the code, but I kept getting lost.
>=20
> When a computer goes into hibernation, which of the mac80211 callback rou=
tines
> are called, and which ones on the following resume?=20

mac80211 will be called via cfg80211, and will run __ieee80211_suspend()
which calls a whole bunch of driver things. This is _before_ the
driver's suspend() callback runs.

Then, after the driver's resume() callback runs, we go into
ieee80211_reconfig() in mac80211.

You can find the interaction with the PM subsystem in
net/wireless/sysfs.c.

> The problem arises due to
> the problem in Bug #14267.=20

Wrong bug number?

johannes


--=-AD8J7uCoLXMsqb1+0gGi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLClf+AAoJEODzc/N7+Qmaz5cQAIdy23fHxB5/Opq5GAB7oXyO
kuA1Zi6g4e42Ah0WtMBnkIF3Q/OU11r3Ug4hgQ1Rminf8rPeJLk/jyHWDiOLlfIj
zDsmNgYoMzKpwCYCYFANsGPM0Br+IHxe/U20LgVVr+lK0MtYHj4/tZp4tqj4QCTe
GcziDfnY4DC7OnGZxkROxiRulmWqND9EkAqh9RtXiv8yklcGV2coTYEGyzuMhvwZ
3iSdvvRb8asXDyz4XhfjSrJk+p4X8DTlMgC/mvOwvdDkvDvrMg/ZpJQWw9dW0HzY
FW0xxQ/s84U4TXNzdSy9h6m+WoYSpGUVx4zPiWEjIpCpzKcHPzcYcffxXK3wPIGb
/hJps/imdHHHDTTQmCiX8b+8aKxflAbmHm6tI0CasqH+xuvijEgZ0NKtz4NUOqPz
vqb3oM3CvZ0hcem33v0GVIeNmSjFpZHLAKgdq0JiBcaLs0VL6ZLvEhmM9Hs4TZOr
WXx3SqHhhPncIbkgwHLlyK3spfnk+HW/vvrhlibuo4ab46oSwAAz7wJOUUwL5yVZ
MunV6Ug5uPHjc9ZNy4lJvuPoVMw5Ctt0jn1JVmi1rhG5A2B0YCFmpWYROO7TkKUd
aiqrW0yN67Mu/qQeJjcWDhuxRwfeFKfppCUEyU+rjnECumR38LZvBsO0zSWJzJaw
AdSVeiKbleYwaWU/9JLu
=6uSq
-----END PGP SIGNATURE-----

--=-AD8J7uCoLXMsqb1+0gGi--

