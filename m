Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39001 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZA1NA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 08:00:28 -0500
Subject: Re: [RFC PATCH v2 2/2] mac80211: use ps-poll when dynamic power
	save  mode is disabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, vivek.natraj@gmail.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240901280346v6b4000b9m74eef26aabf86419@mail.gmail.com> (sfid-20090128_124617_777892_C2EE32D5)
References: <20090122114240.31443.18218.stgit@tikku>
	 <20090122114546.31443.79387.stgit@tikku>
	 <1ba2fa240901231528m21f13c1m43721f1d673e7cc7@mail.gmail.com>
	 <874ozj964m.fsf@litku.valot.fi>
	 <1ba2fa240901280346v6b4000b9m74eef26aabf86419@mail.gmail.com>
	 (sfid-20090128_124617_777892_C2EE32D5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dYyaNy5Ik5Nv/mFRgXTB"
Date: Wed, 28 Jan 2009 14:00:24 +0100
Message-Id: <1233147624.4071.1.camel@johannes.local> (sfid-20090128_140032_396423_A72706FD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dYyaNy5Ik5Nv/mFRgXTB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Just for the record, and I was still planning to reply to your other
mail, not trying to hijack this thread at all.

> I would suggest to expose to user space non-unit index of power save
> aggressiveness which can be mapped to different methods such as
> PS-Poll, dynamic power save or iwlwifi firmware implementation by
> other more reach configurable interface

I **completely** disagree on this. The non-unit index is a **horrible**
thing because it says **nothing** of interest to the user. The only
approach the user can then take is try which value will give him the
desired behaviour, and it will differ across all hardware combinations.
Therefore, it's completely _useless_.

What we really need to do is tie into the pm_qos framework and make
latency guarantees.

johannes

--=-dYyaNy5Ik5Nv/mFRgXTB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgFbmAAoJEKVg1VMiehFYTu4QAKV/HJ80DsXiNpvXGmSUj8Vo
OCTGnKObj7MhfE7ven6PGBJblvFz08REi1nxjAOl4MVWedTFKxov7Tb/8ked5y9s
iWRARk0Sx7eYkDiDl2GPEe9ku69wqb+Oy+5QqgGkQa6EDGsihy5AszKrgp+1IXcw
ogO2ryaC6JqpB9x28T6nBNIPobK8qL+/ZUjKArkX3wEpeKUBcFVU93DbedMech9s
8G9GUe4An0jxNFEmY9ePghNDrhD7GpfBRYJo1EWkD2ra9eVdM+ff+NHBXxtkcEc2
hLdRuk5Bp14ArFKXe4k5xNmAWUdVKoK2b0hFm3d0kSyaI6g14v0gxxNLFGv2rDjZ
a1Vwn65zeuHiv0I14TllJnpOGmaiEzTYu575IYoQWOt/uEGwUB5bpaq2B53z0Fjl
BKoK0bzaY1DwMTWOmMnn0tm3c/9sU8E+tLfabo+oxbzGgyDV1TKfbclDxfoilKBF
k5Q8r4ijeI0/rCsYEW0n9XHloxPyankYet244tV1mpkDtgVI9a8DIxlb3ED5/cTQ
pX7la+08AtTDSG4d6DB43Kdbk9/NoxCXcqNZ/5S7eFni5fpD/nLb2DZ/xOTSpdQu
YQ3nXkh1MNhnELvLWR9tkCKoJd4zHwpiRH72wNrruIttwMa7KjZMr9b5eH4RXULX
mNwmzh1b2tXDJdfvI/mI
=n273
-----END PGP SIGNATURE-----

--=-dYyaNy5Ik5Nv/mFRgXTB--

