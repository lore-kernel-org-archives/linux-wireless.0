Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54654 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbZILO6g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2009 10:58:36 -0400
Subject: Re: A station can't reconnect after it wakes up
From: Johannes Berg <johannes@sipsolutions.net>
To: Igor Perminov <igor.perminov@inbox.ru>
Cc: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com,
	Jouni Malinen <j@w1.fi>, Artur Skawina <art.08.09@gmail.com>
In-Reply-To: <1252620184.26765.65.camel@sunlight>
References: <1248969930.29068.224.camel@sunlight>
	 <4A7318E6.3000004@gmail.com>  <1249312925.8515.187.camel@sunlight>
	 <1252620184.26765.65.camel@sunlight>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7d+dUDhZldZyjX21waxm"
Date: Sat, 12 Sep 2009 08:58:33 -0600
Message-Id: <1252767513.23427.26.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7d+dUDhZldZyjX21waxm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-09-11 at 02:03 +0400, Igor Perminov wrote:

> Jouni suggests to not buffer Auth/Assoc frames at all, independently of
> station's PS state.=20

Ok, works for me.

> I think, it isn't enough, because an AP should send
> a number of EAPOL Key frames after that, which are data frames and
> therefore will be buffered anyway.

That's not a problem though since the handshake will be in data frames
and synchronise the PS state on both ends via the sleep bit.

> I think mac80211 in AP mode should reset WLAN_STA_PS flag of the station
> (and purge frames having been buffered previously if any) on an event
> indicating beginning of authentication.
> The event may be one of the following:
> A) An Auth frame being received from the station.
> B) An Auth frame being sent to the station.
> C) A special API call from an application (hostapd), when it is
> receiving an Auth frame from the station and is beginning
> authentication/association.
>=20
> Johannes, what do you think of these approaches?

I think this is not necessary. Just make sure that auth/assoc frames
aren't buffered.

johannes

--=-7d+dUDhZldZyjX21waxm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKq7cWAAoJEODzc/N7+QmaHBkP/j8pBUmDbYCXVXNoYbmqTdFz
XkQCukmOU+fBzb3TNBT3e/pgCrvt+KQHGgYnaI41QWE4872m9gZNjfyShZxGIxUp
0g1N9S8FMfEQOfCn2DkItUFAo9IAtxuBRoNsf5bL/ahp0KlZc+kiKWX4u8Mzg0aI
qFZkf4rQkLXfy92GV3MJHF1jsN2QiIFpAz8cKf9ghx42xg9X37adPuAfugDWbdHF
68B0IM8ZHZPQMgUeLhT18ZLq2YzPEOFqbDtvUdEHlAXBA+kdq3Gt4FDz/c7dXA6z
KkA9PqYmuWhv7L0CVGp9UIju7ILYvjBWPq5W2S2+qH9pNuGtJk6FMQ9X0Gosf/Cv
Ldy4n91dL9D0WgvmtUwiMG543fGOlelNnj4K3OEKOtUYyKY0b7G7EtXN3a3Thd7T
c33/isiIxYNOsZZZEnNcCgTTVwluh2Q2/g3itHn2U8JhL7wI5zmnji34R8zAPRor
oG/qTjNSWW6WkkmBr+oaU2gHTTTd+TAOyHNEzWkfMiLFuNdqsJDHU4opzdhVc8Fa
Ekx0XjfvBkhhEjr5tQojBRfdoB+R7x5kz1z8KKFqg1wNTRGjS7fV1mmhpwIsFZYY
HxAyEEQ6jx/0D+CYcd3kh+zTIsck/OFqFDGXUslAsgW0dTjLZT5hnZSzEgixmH1r
ujMLvudgyCsmTg6lAIba
=UwfL
-----END PGP SIGNATURE-----

--=-7d+dUDhZldZyjX21waxm--

