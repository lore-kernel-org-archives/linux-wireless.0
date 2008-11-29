Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32988 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYK2JuN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 04:50:13 -0500
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>
Cc: Michael Buesch <mb@bu3sch.de>
In-Reply-To: <49310454.60906@hotmail.com>
References: <4902DEBB.3050205@hotmail.com>
	 <BAY104-DAV1D226EA8FB16BE36E3C84991A0@phx.gbl>
	 <BAY104-DAV671C2C6DE8B2A05AD785E99040@phx.gbl>
	 <200811282344.29293.mb@bu3sch.de>  <49310454.60906@hotmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-K+FISofwku+G0Du3I9q2"
Date: Sat, 29 Nov 2008 10:50:04 +0100
Message-Id: <1227952204.3542.3.camel@johannes.berg> (sfid-20081129_105026_373207_77799907)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-K+FISofwku+G0Du3I9q2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-29 at 19:59 +1100, Shaddy Baddah wrote:

> net/mac80211/tx.c:1304:		if (memcmp(odev->dev_addr, hdr->addr4,=20
> ETH_ALEN) !=3D 0)
>=20
> I would have thought it would use compare_ether_addr() if we could=20
> safely assume alignment.

You're looking at the TX path, that's irrelevant :)

>  In any case, say that alignment was always the=20
> intention... then can't we just use memcmp() as a hack (not being=20
> derogatory. Just that it would turn into a hack in deference to using=20
> compare_ether_addr()) consistent with hacks like the above? Even in the=20
> interim until a program to iron out alignment is set in place?

No, the IP stack assumes alignment. Besides, zd1211 actually enforces
the alignment before passing the skb off to mac80211.

johannes

--=-K+FISofwku+G0Du3I9q2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJMRBFAAoJEKVg1VMiehFYoAwQAJwTOzR+H652Ct7cobTh6+4S
8jk8EzinDQXrh4SB131C1ioEe+5eXRmV6OEa5FuN70wXm150/jxdjxqDDxS6Q+KH
8YZrWFxvBa+970g3rCN8eWMmIuw+fPm7YxFd/ChIkMCKeiR3JoTVgCnQ1FOzTdGA
5veD/CsT6vu5+GCrUxxlCxd1rXwrlJBbbERhmUDIp5BM56Xw1cHWav/1CmhG+2EF
WZmgrQwwz9ByyJ5kHJXBPoaPkjQWbAf7agJWfgNsq6qpJoIG5lnBPP6XQ5iuISqY
klFmsDYCeXJ0/r14aOzpDaSIqyu9ynyZ6v7QcvlO4Qbgi4ENt8rRIDWXbRH/2pxk
ZOKTcPr+DHC7KlBru7zLvk1qKl6wF4EyBT9S3EcpM/oKMfNc0SesmlJmeWeLMa+h
Qxp9jD9fip4v5DumybcpizKNSvgt09NXuGSCBURNuS7JdIOKNm5eUCT4wX/bEmGq
uVB9pg72c2ilKwYszrjqeNNT9e/kcpspvW6e68YL4E5qMiBrbMP0kQGTAU+Jm8nk
6dbHxBuqqO7bAjrCdLPJsnLXqa+9hJ2VogLWvpo9LH0r/H9r3rOZGAM3Div++nb4
EIXyUwVTuszPyVcvelf2mE0Zx8g05i2aT8i0Z1Z/gscyKrz5uqsSrQmyyyFyqlpO
OPKI6NavvvnlExxezx63
=pCac
-----END PGP SIGNATURE-----

--=-K+FISofwku+G0Du3I9q2--

