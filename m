Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46314 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbYL2MN7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 07:13:59 -0500
Subject: Re: [PATCH] ath9k: Enable dynamic power save in ath9k.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1230552660.3116.33.camel@johannes> (sfid-20081229_131046_790819_4EFBD29E)
References: <20081229235300.GA8458@myhost.users.atheros.com>
	 (sfid-20081229_112105_235618_A8D12202)  <1230552660.3116.33.camel@johannes>
	 (sfid-20081229_131046_790819_4EFBD29E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aCvABm0Hs8nxAMxqEhSg"
Date: Mon, 29 Dec 2008 13:14:21 +0100
Message-Id: <1230552861.3116.34.camel@johannes> (sfid-20081229_131406_901595_3870840D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aCvABm0Hs8nxAMxqEhSg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-29 at 13:11 +0100, Johannes Berg wrote:
> On Mon, 2008-12-29 at 15:53 -0800, Vivek Natarajan wrote:
>=20
> > +#define ATH9K_PS_WAKEUP(sc)						      \
> > +	do {								      \
> > +		if (!atomic_read(&sc->ps_usecount) && 			      \
> > +		   (ah->ah_powerMode !=3D  ATH9K_PM_AWAKE)) {		      \
> > +			ah->ah_restoreMode =3D ah->ah_powerMode;		      \
> > +			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);	      \
> > +		}							      \
> > +		atomic_inc(&sc->ps_usecount);				      \
> > +	} while (0);

Also, this seems racy, shouldn't it use something like if
(atomic_inc_return() =3D=3D 1) ?

johannes

--=-aCvABm0Hs8nxAMxqEhSg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJWL8bAAoJEKVg1VMiehFYRFkP/3AlbA9x/i0R9dfRby+1Nucv
FKmfQ0pL0hhRy5NSSbkTv1uvdWhz8TzBbZFFamGHZRNQSsF8Ua8RZspyAuzV1d7b
eCXamJScKN1qCeARIVSDUJMuPZgZKHaEOwC5DSwjBoYiorlnXdxp2+XbGdQE4DHZ
y8jhFV0aGpsgNd2cLf63n/J9ldP7LSDuK0ywXkdP9xK5ty+zSYDmyA0n7FoVrkxZ
L5PFtKJTDeclsnQno2RBDeXma6RvJw+xS6MDvWBM9NFfWb7u4n+9zXG6bikXXTAV
2zp2olcjcx46j/Bl/lxm0Swg8p7t6lpn8p1q3TlSiQKcEj1z9gPKPvm4/w26Frzv
yZY5M1QfqKdWpRa6iAR+ROCqL+AlAmAeSmwehIDsLNDrj7N04s1L30owbR8TMkuz
1ARoPJeKeSfXvWyIdOectY7VFnr5RK/MASTIlzTLdMd5mqYzcjw4WoTx9KrkNGOf
MfQfOaas4CuJ48CUztTurtWqqQFUBHGz1AV+9jiGGqSuw+Qei7mUwBN+yRpqLzoi
70FvMqHznKngye9kyCO6nJtlSGo2AAPLWYgeUAUVTSj1NGf5fIL1BamEEC7qB+6B
9zHEdlhhO5bBCr/N+WhiIrDSx8Vo54spgjkTHAfFiobprIntE/1gwAcbgyJMOtaY
0bs4VtDCf0t/NKZ/DVRo
=g0gp
-----END PGP SIGNATURE-----

--=-aCvABm0Hs8nxAMxqEhSg--

