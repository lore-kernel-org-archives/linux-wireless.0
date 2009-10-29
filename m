Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52194 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbZJ2NaE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 09:30:04 -0400
Subject: Re: ath5k AP issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, Luis Rodriguez <mcgrof@gmail.com>,
	Bob Copeland <me@bobcopeland.com>
In-Reply-To: <200910291330.26172.mb@bu3sch.de>
References: <200910291330.26172.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0HVQOqz/WFyu8Wn/jHof"
Date: Thu, 29 Oct 2009 14:29:36 +0100
Message-ID: <1256822976.3865.111.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0HVQOqz/WFyu8Wn/jHof
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-29 at 13:30 +0100, Michael Buesch wrote:
> Attached is a wireshark log. Let me explain what you see in there:
>=20
> I have an ath5k AP and the powersaving n810 device as STA.
> What I try to do is ping the n810. You can see that at the start of the l=
og.
>=20
> Packet #31 is a ping to the n810. #42, too. and so on...

It's not a ping, it's an ARP. The problem is that the TIM IE never
indicates multicast traffic although multicast traffic is being sent.
But in later packets you can see that it's not buffered correctly at all
-- soemtimes it's sent after DTIM count 1 beacons.

johannes

--=-0HVQOqz/WFyu8Wn/jHof
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK6Zi8AAoJEODzc/N7+QmaDw4QAIVp/ODdjfo/v2hU8tBxXEM7
38tEJn7CNlUy9tHUE0IDwjDYC8ztxW/oehATE+rPEvWDZ0m/N0dySnebcqlJ3AuB
Io5lMxgvH8gLLBXj1zCdE9eMw4WWUCD0aFyNid3sIuMarkm5Ccdhft1DeMqxw2E2
LX84aOLFN04wsXGs9ajVqxB4PsopqIXyBC8HBV+sD/NXu5xuzh5xCn2Nn5lvoeXl
k2F8q2zgi5c3a3DK4tgpptvLotHZMAW8lss7QkVqtVRZp8ZLZLrW9Fw7HbqEQz20
00Iy9NrJBnh7TdmLf28D3nQwBziltndzAqQ+qTqC8CN/Q0gGwdRaX3808BKt8GuK
B3lYdD+AcVIZfkMyoPxGH3lhHaY+qtWqKgT1JCiqF0lBtoBYgfyFwjZuvybf7GCl
apBA9vjSdk2lx36OL7lUXAU6NzMQlf91YIZXMZc3SznwZKaJQ3YxtxFS/i02G9p1
RA9/zpIaVd43R12O00tlMLMXxeMT9LaQeVYwDLqso86QtVBc3Q7tssKyTXfmy+Oi
hof/0N4TrWXKS1LPjAkh7e8eM8U9oZpGobkmPouFt7AbTjXreQkN+qCbHgB3r884
g5cSnDOvMkXLHj+2bE9uaMspWOA8GoxVg0skOWKNdnDJq4ufQdgE4uyT2N0lom+T
eo5kDhQwmpAiKpsLz1Jc
=/sSm
-----END PGP SIGNATURE-----

--=-0HVQOqz/WFyu8Wn/jHof--

