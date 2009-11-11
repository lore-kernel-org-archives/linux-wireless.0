Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51071 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbZKKKvM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 05:51:12 -0500
Subject: Re: [RFC, v3] cfg80211: first stab at channel survey
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200911101723.11304.holgerschurig@gmail.com>
References: <200911101723.11304.holgerschurig@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-macalIVbzCq7qQj8Wc+I"
Date: Wed, 11 Nov 2009 11:50:45 +0100
Message-ID: <1257936645.7037.89.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-macalIVbzCq7qQj8Wc+I
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-10 at 17:23 +0100, Holger Schurig wrote:
> This patch implements the NL80211_CMD_GET_SURVEY command and an get_surve=
y()
> ops that a driver can implement. The goal of this command is to allow a
> driver to report back channel survey data (e.g. channel noise, channel
> occupation) back to cfg80211 and thus via nl80211 to user-space.
>=20
> In future, they will either be a survey-trigger command --- or the existi=
ng
> scan-trigger command will be enhanced. However, the get_survey() operatio=
n
> is usable even in absence of this: a driver can report the channel noise =
in
> mBm with the implemented mechanism.
>=20
> get_survey() is currently modelled like get_key(). I hope that's right.

I don't think this last sentence is true any more?

> struct survey_info is modelled like struct station_info. This allows diff=
erent
> drivers to fill in different fields.

Guess the details don't really belong into the commit log anyway.

Anyway, apart from the two things we talked about on IRC (error codes
and missing "cb->args[0] =3D ifidx;") it looks good, thanks.

johannes

--=-macalIVbzCq7qQj8Wc+I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK+pcCAAoJEODzc/N7+Qmah1UQAKJ50MLfWqwOFsVx2BQJt2An
U18pfio25G0c9ypsQ28fUtnEMoifd4ct2PcEs/V6WjMHrQbWIr4e/Vgoo4JvfY0r
lvPDVchvsflW+dfxQsLPWmk7RM8jpCM4G+HqthPAaNaXvOWIk2JxQmETvKmEMzDa
EoQWHR82E8RjlLTpGZ9dmeQs7Ek+chA73sNmc32jsHT/rMhbOJNBNIhA72maA8JQ
4Lmz3GOfNa0M6MpA0xF61V0To2ZyHSzt7VWTNT11f3tX3GAzKKkavsQyjO7fb/AZ
sfLUXWbszuj5ZjEiIMUUq6aT9v5RoQJjiQwHkfMUKC+3yXsaJ1nPuJVXacaP4ALT
BrqPE6bgetZQWkuruLvwSYhKOAa9HF6tSHJxE08/JICmsn8jMvdpCcGli8YCU2tn
s7LGZ9y5rFiz2y+oWG3V8HlIixHcjDcQ9DzKdM27MKbH5TChjJ44lmGcSXgtQZ4b
qltDst+l76SNGk8Y1zwkaTYSWGwOEe/6Dz1uTkr2qpyfhzdVDGn2NGkXgMxdRPAC
vTCnson9YmIIRha7uBRwpcbDithT9O0jmN4Hp8vUjRvahtLuy74zq4qF5q/NNysX
arVCl27d+SHF1Q4fEd4tfn5s2xq4wRVCKD1mqVS2X7uOPIfKCXE0DhfcEgkCqtex
HK9oNJWKmoccYWXuROoH
=Wzhp
-----END PGP SIGNATURE-----

--=-macalIVbzCq7qQj8Wc+I--

