Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46782 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302AbYE3Wyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 18:54:37 -0400
Subject: Re: suspend vs. b43
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200805310049.41782.rjw@sisk.pl>
References: <1212150713.4117.2.camel@johannes.berg>
	 <200805302319.34173.rjw@sisk.pl> <1212187090.20421.2.camel@johannes.berg>
	 <200805310049.41782.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1b3sMMnYaSRkNCrsikLB"
Date: Sat, 31 May 2008 00:54:33 +0200
Message-Id: <1212188073.20421.5.camel@johannes.berg> (sfid-20080531_005512_441449_6CD58ADC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1b3sMMnYaSRkNCrsikLB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-05-31 at 00:49 +0200, Rafael J. Wysocki wrote:
> On Saturday, 31 of May 2008, Johannes Berg wrote:
> >=20
> > > It hangs for me either at read_unlock_irqrestore() in b43_op_tx() or =
somewhere
> > > in ieee80211_tx() (at various places).
> >=20
> > Huh. Why is it even getting into the tx path? And even then, why does i=
t
> > hang at an unlock?
>=20
> Well, I saw that during hibernation, so it probably happened after creati=
ng the
> image, when devices were being resumed for image saving.

Yeah, like I said earlier to somebody. Still doesn't make much sense
here. I'll play with it next week, or you could try to put into
suspend() a call to ieee80211_stop_queues() and in resume
ieee80211_wake_queues(), maybe that fixes it? I probably won't have time
over the weekend to look more into it, sorry.

johannes

--=-1b3sMMnYaSRkNCrsikLB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASECFqKVg1VMiehFYAQKf5BAAxFDRYtXtVF8AOdFaTGiC9/Kt5o6jMvrT
TET3x8gNY9GcbVj1xHKMx7YAC4UmJmCEw/UDEOAYEsn9FIRy05Un3yi3NfsijDWs
LOICPQXitRXUWWzy5WOogbtHqag5yq6t8Z11zNjlJaLjc8adJ1MWwlRDaDcQlgPw
8ad46aYcZqSclabn0QCf5j5CXo93bNa5YmHuzVJ2WRkJRwS9vCgDFQaqUKYY32P8
60rh0z4aIE1TIB9YUdeWeELn+35jJ+fbLJT6YU0gxeqxBvYr2fBbf3XbPa8hGGU4
tlMtwKwYaE9O+jWGW3qJiFHoJKJcpK5Tgz6j+F3F3inQM4dculrhoLQIKtV+NjxK
PcgUpqjcjXrWR4bCWmqvwcCHY6MGs9eFzhaLsviJkfj9zGtuxoS6MjDit8MlXGge
F6T+Z+9kZYf+NxXWxWl/Fr6sAV3xSdrfoQcmZ9FCApOVSUufw5+CKt115Ejxdvsf
Q1A+3Qyw6SyVXA1Z18o8zTeW2q8QYUlEiW91+H31Hix46Jr/VsxpssVQxe0EcdJU
HS46eGJvrDbm+1H8So0krAVrCaAh4wOx9qnY7k1kWF2TKsZbfeyveoLdTmzTvkNa
0zI6zuKoCmBBq9EmXNFBpbPkYOMszOdheDd6gpbDZ8BtyVUxpAFyH23dz47YqWWl
NP0/YP8V1Nk=
=nlwr
-----END PGP SIGNATURE-----

--=-1b3sMMnYaSRkNCrsikLB--

