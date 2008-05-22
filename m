Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbYEVTfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 15:35:52 -0400
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies -
	2.6.26-rc1 kernel
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Vincent C Jones <v.jones@networkingunlimited.com>,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <egrumbach@gmail.com>
In-Reply-To: <1211484612.28022.31.camel@localhost.localdomain>
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101156q4dc52c2bt47d2f6e51b611eea@mail.gmail.com>
	 <1210456110.3787.26.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101506p78c3eeb6q6e980ac4200fd56f@mail.gmail.com>
	 <1210474179.3787.31.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805120950mf983e97qac4cdfa2c84b6662@mail.gmail.com>
	 <1210617467.3792.4.camel@X61.DFGI.com>
	 <1ba2fa240805220953u746d3429q50faa1885104cadb@mail.gmail.com>
	 <1211478969.3698.56.camel@johannes.berg>
	 <1211481249.28022.15.camel@localhost.localdomain>
	 <1ba2fa240805221151q2e53b069n6658c6cd7d6f4ba0@mail.gmail.com>
	 (sfid-20080522_205154_739984_95576FF6)  <1211483568.3698.66.camel@johannes.berg>
	 <1211484612.28022.31.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Zbw2KU4naO2oYme28Idx"
Date: Thu, 22 May 2008 21:34:47 +0200
Message-Id: <1211484887.3698.75.camel@johannes.berg> (sfid-20080522_213602_903442_AD1E6AE8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Zbw2KU4naO2oYme28Idx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Fun. How about it we just make wpa supplicant ignore FREQ/channel
> > completely if it uses FREQ/frequency anyway?
>=20
> Can't because some drivers send channel and not frequency.  Yeah, we
> could fix all the drivers, but that doesn't help people running latest
> supplicant on older kernels.

Oh, good point. I guess the patch you posted is the only sane thing to
do then, and require that drivers that work in the 5 GHz band send
frequency (because there channel numbers need not be unique due to
802.11j's channelisation offset)

johannes

--=-Zbw2KU4naO2oYme28Idx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDXK1qVg1VMiehFYAQKI5A//WwjTIMxE4B4S7N3C4cOweR0058MptywK
8QxHHgWGrdIYRsqzoFeMIkFKSeoHxfi2B/qUQZ4MJxNOuuMgEAjvCtYoHFFWPbhv
bg2ctB7DSl3CpIr/vybCEfSJfwLfUk7t4vNp/cbS5EY0pd5KnfqOutHFw+va4cK5
2Byhz3jblAGx6GKzPAwCbhzA39mTQQmekJGs4p+8fOKV0PLj1SppGfZ7TErNN5TM
AeHtBjX4SO7iJLELXD0b6H/Kg774AS/3G9LKrEIUZar2tSYJBr4N0NhhYCYJv+jY
kzrEN9eGKw8fe4LT692jyc3SIMOHRqxXj8eSt7ylzBZcp8j+2K3f899Nu4JELJK8
dYuFjdq1o+g7GJfIVj9wuuiprOvFMf7X7PytSWJtwFh1Cr9sfwwbG2QxZLDZWOb1
l/vHjCsT9tgfGVXpcNmLog80nBuggJ9+YguGDknO4yeOlP3oRz7AN8oQQOmvEhkT
GUfjqGfBjlRrcrowKGY6UMY1hiXGTzYF0To8g1jVRVNGkLMoClQuX9Z3CmrLWwRL
9rzbuSnV+zKsfUzn99tMZyFpKKcWiQrgYafbLHtM1Md2amnNbXEdeCU6ymc/qwN2
4KQ1xnBeDbmTUeUvQEK0y7FTGzJt9DIobkGLR66Kl0Q1O2+UwTqo0xFa2m4SIjVj
tKvmMDG9Z9w=
=eTEn
-----END PGP SIGNATURE-----

--=-Zbw2KU4naO2oYme28Idx--

