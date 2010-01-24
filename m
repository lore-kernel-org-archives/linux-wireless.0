Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48748 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0AXLrz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 06:47:55 -0500
Subject: Re: hwtkip hangs on b43
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, kecsa@kutfo.hit.bme.hu,
	linux-wireless@vger.kernel.org
In-Reply-To: <201001241245.17176.mb@bu3sch.de>
References: <Pine.LNX.4.44.1001230942190.16120-100000@kutfo.hit.bme.hu>
	 <4B5BE16E.7080901@lwfinger.net> <1264332771.23766.24.camel@johannes.local>
	 <201001241245.17176.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8mT4b6c25q6OXGt2SgS8"
Date: Sun, 24 Jan 2010 12:47:52 +0100
Message-ID: <1264333672.23766.26.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8mT4b6c25q6OXGt2SgS8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-01-24 at 12:45 +0100, Michael Buesch wrote:
> On Sunday 24 January 2010 12:32:50 Johannes Berg wrote:
> > > >>> We can just remove the lock and add a comment explaining why it i=
s not locked...
> >=20
> > Mind you, it won't work on SDIO hardware since the callback cannot
> > sleep, contrary to what Kalle documented :(
>=20
> I don't understand. Why wouldn't SDIO be allowed to sleep?

Because this is called within the RX path code which does
rcu_read_lock() around it.

Really, somebody just needs to go and add key TODO in mac80211 to pick
up phase1 key changes and update them in the driver, that gets rid of
all the locking and atomic problems.

johannes

--=-8mT4b6c25q6OXGt2SgS8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLXDNkAAoJEODzc/N7+QmaFmMP/AtR6O8dDXkitZr6uIhmTAwV
u/1zsyvbH4RQnGjsf0ky+F2moReSzWrQwK08MU1knQrQGriZiKLKLxUhitFAb7JM
OdYYHcOGbw25Bi773QsozGviK7RWrXZ31C3y8lRZe1hBqQ5hco8K3isM8RWj2iei
kz69uyAATH/jyN07/LxYtH5E7FQ4l3oTuc0OcYw8FsuXhpCgKnYgCf7Q69j0Iu81
OMQkh5VG34OrclZFbZcV8Br7r5pF/3SLIDqmHfB+kbuLbxR3FpKdfEOQXzHX1cTG
2GcWIWCznEs43ISE4VdTQQU1M7uQEWLwvyZKJ1S3aDYX83PDo2cNLe5TJpNXC6aW
eid0VHXwG7HD47ztabgSl9bewDN9olGUQARzWRGTXfANA/KUAMD3dTxcDI82ZdiK
QRhx8UarjdKBirpFz1aVMp542lD5zbj5FITYAJHHBCSKucClk+JTobpPXXQHqNMh
qOzNL8YPokbbDng3np9npl4EID+hUb0C0GbakjIS+24aYhuYuyr958tYE9lE/RP3
7YoZEzXXVQ5OWSCnaRSJkp0sq1WsucXgbNhMUaGHETp/4zk2q1GkBINkgZ2FvxeP
jK957LNnIRU757dUKDYCnqt6AUVQoPqpVd2iES48/l8a9Q/3PWmIhA9krhEF9/hn
Q0NhqQB1YNGeL+J3JyiE
=gb9j
-----END PGP SIGNATURE-----

--=-8mT4b6c25q6OXGt2SgS8--

