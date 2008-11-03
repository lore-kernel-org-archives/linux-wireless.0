Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32773 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYKCH0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 02:26:14 -0500
Subject: Re: 2.6.28-rc2-wl: network lockups with iwl3945
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <87iqr5ri67.fsf@nokia.com> (sfid-20081102_212342_548781_60CD5960)
References: <871vxuh70u.fsf@nokia.com>  <87iqr5ri67.fsf@nokia.com>
	 (sfid-20081102_212342_548781_60CD5960)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PHI80mHhM41maYeopWlt"
Date: Mon, 03 Nov 2008 08:26:13 +0100
Message-Id: <1225697173.3619.23.camel@johannes.berg> (sfid-20081103_082616_830701_A3667E66)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PHI80mHhM41maYeopWlt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-11-02 at 22:23 +0200, Kalle Valo wrote:
> Kalle Valo <kalle.valo@nokia.com> writes:
>=20
> > I have now seen twice a network related lockup with 2.6.28-rc2-wl
> > (wireless-testing commit d80fe004), once yesterday and once this
> > morning. I'm guessing that it's somehow wireless related, most
> > probably a deadlock somewhere.=20
>=20
> I can now easily reproduce this. First run wpa_supplicant and let it
> associate:
>=20
> $ sudo ./wpa_supplicant -i wlan0 -c valo.conf
>=20
> Then suspend:
>=20
> $ sudo sh -c 'echo mem > /sys/power/state'
>=20
> Wake the laptop by pressing Fn key and run ip link:
>=20
> $ ip link
>=20
> And that's it, ip will never return. And even shutdown won't work
> after this, I need to use sysrq+b to boot the laptop. So this is a
> serious regression in wireless-testing.

I think this has been fixed for iwlagn recently, but I guess iwl3945
will always be forgotten ;)

johannes

--=-PHI80mHhM41maYeopWlt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJDqeSAAoJEKVg1VMiehFYgO8P/iRcH+Ufe8tHs+so8geiWAbB
c2xr2+XK0BPoQu/goO6weQTHYHRpapvFw4uMJTTX0tjZq2k2UFIJmk2rKCETYaUv
S8Kt1n3oaXqtWyN3qsya454SYTmvUNtFm1/+menC1YhOaHtNbuI1Ua6ZAB7wcT+k
U951rDDHv9WJeh03M9lwzdHqo15mHlHMgMBRWI93oK0uZFlpwyKsyXfQlqXngCgf
lvDlm3XV/HworYy8ux8QRvlbeUpMPw6cCwrMHl/T8qWW/rFDrLBCZwyTfaVmfPwR
7vVUMeNhZSjSHl0ZK2X0TCoYLIEG5Z3Tdk2Dk4hHnD9fHs+HlOuUqzhDUewxPP0x
q6eci/ZI4J7bRV6P0UljOEPz9+ztNmnhC9NUCGX7ZmPaRMTDhUs6IVka8F4b7vIl
wPJyavTbIZXwCmue2cv48JjIgI+rGqwHiH2TgorTNFGW44JXkyjNOdDpl7nlk68X
yPw/2uJoecXnB3SJGBxZHPsViDa2cnJaJ++zAamaGcb5Ds4kWGK9euftWB8uu78Z
6WrmJd43TLCFXVNXMb/v2qvM+UOBpnNkjIDtV4xYE+aAPuTrO+k7TqabyLfdyRpj
fxePf5FoYz8XC/fTqX+ta2g4wUHpCikHtwB+UFlzTa75D9q1wvL/hhyWDa/FvVNQ
muY8njC0zo8X60vg468Q
=JbF7
-----END PGP SIGNATURE-----

--=-PHI80mHhM41maYeopWlt--

