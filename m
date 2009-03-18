Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37768 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbZCRNgt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 09:36:49 -0400
Subject: Re: rt2x00 mesh support
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Antonio Marques <froz@icix.org>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200903181431.43048.IvDoorn@gmail.com> (sfid-20090318_143216_017913_36914372)
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org>
	 <200903181348.51609.IvDoorn@gmail.com>
	 <1237381972.5100.21.camel@johannes.local>
	 <200903181431.43048.IvDoorn@gmail.com>
	 (sfid-20090318_143216_017913_36914372)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EvPa+0pnroj2qWKWbsXe"
Date: Wed, 18 Mar 2009 14:36:13 +0100
Message-Id: <1237383373.5100.24.camel@johannes.local> (sfid-20090318_143651_955424_85D5D26D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EvPa+0pnroj2qWKWbsXe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-18 at 14:31 +0100, Ivo van Doorn wrote:

> > ->config() coming after it makes no sense either but we haven't even
> > tried to avoid that so far... In fact, it is perfectly legal for
> > ->config() to be called after ->config_interface() when, for example,
> > you change the channel. Not that I disagree -- we should be setting the
> > beacon interval before enabling beaconing...
>=20
> True, the problem however is that when enabling the radio it is possible/=
likely
> that a lot of settings will be lost. For rt2x00 we must reset almost all =
registers
> to make sure everything is set correctly again.

Yeah, that makes sense... I just don't know how to handle it.

> > What exactly is the problem here? The fact that we don't enable the
> > radio until after having configured beaconing? I'm not sure how to solv=
e
> > this, to be honest.
>=20
> Neither do I, perhaps we should make sure that a call to config() when
> the enabled_radio field has changed should trigger additional reconfigura=
tions
> as well. But I don't really like such a solution.. :(

We could do that, but there's no limit to what that would be, up to
requiring basically a call to __ieee80211_resume() (from pm.c)...

> Perhaps should check if a beacon was provided while the radio was off,
> and either request a new beacon or upload the previously provided beacon =
when
> the radio is being enabled.

I'm thinking that will be necessary, imagine we integrate rfkill in
mac80211 like we should, and set radio_enabled =3D false while being an
IBSS member?

OTOH, this problem hitting a number of drivers suggests we should find a
generic fix.

johannes

--=-EvPa+0pnroj2qWKWbsXe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJwPjLAAoJEKVg1VMiehFYWsUP+QHJD4ek734TN6dPqIfVgfnk
Hq2Gh86dhVPUX4bWzsCo+3l+N3kJE9EpdQUmw5+xwYz5RTEyJQWzJbFpmThEST6r
sGKq+E7Z7c42rVCDbwsZszRZX5rzC7KSCTk4BVGx2g/Dpu4EBpQnk9CdG3n4z/1F
LeRx6VYNg3AWoXUwf9GUwaTCMGY31NlucgYykQ1uES0bxPldJLOeh4/oNruDKw6b
0wx3mxzb+No4inOIS0AP0MVGSY2L5ZQhHDNrHhT0vM24D1PJFO7/6AX1t1sgTdvd
aoXjjIgqk4a0QQ/pBl4c1uTVFBq3BlRwSTddMoVwlQjowTMH9OffEO5ScaQGG+zV
aiuz1/Lw6a8/ve773JOhmmpYL31gENTwr3t3OxO5eupo+8MsOxl8GNwXWu6nG2kc
VL4XjXZqZnfeCo6kjRaxvD/QlIzmzXdmzdYsYmj33+SzTK/F7f9MByX5fDwTj2kj
cYy+EjUjUANfsyxi5zzDiba7aMjQUAZgkaPcGeei1yCG2senPfz6Pfrf4LxD67bf
/06L7y7DF0keGF1tjCJ5UhC1OmYF54GGjLrYAYBEkEgXjIyc2EbE/rWTBxwyGA2M
vq5+1btoOuhbI2aiN/V+CSssLHsadDY050IFq1Doxg2rYuwWWyLtgmsJENx6S6ke
uJgxthX/m0VYOjj9ELap
=FUr7
-----END PGP SIGNATURE-----

--=-EvPa+0pnroj2qWKWbsXe--

