Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42553 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347AbYEHXR5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 19:17:57 -0400
Subject: Re: iwlwifi and tx info in skb->cb
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240805081616l3f49d770pefd517076a06b3ef@mail.gmail.com> (sfid-20080509_011511_095937_36DE1999)
References: <1210197711.3547.1.camel@johannes.berg>
	 <1ba2fa240805071629i6c7336f6y61a7c9690820ef5e@mail.gmail.com>
	 <1210203054.3547.12.camel@johannes.berg>
	 <1ba2fa240805071721i3d1e3258s1e8c024c4cae9239@mail.gmail.com>
	 <1210255522.3547.48.camel@johannes.berg>
	 <1ba2fa240805081507j7cf991ffo5bae443b0b77a39e@mail.gmail.com>
	 <1210284656.3547.76.camel@johannes.berg>
	 <1ba2fa240805081528t45d7810cjfd553bf99daff096@mail.gmail.com>
	 <1210285845.3547.81.camel@johannes.berg>
	 <1ba2fa240805081616l3f49d770pefd517076a06b3ef@mail.gmail.com>
	 (sfid-20080509_011511_095937_36DE1999)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8CqGywhiHa6EfSEB9D9H"
Date: Fri, 09 May 2008 01:17:42 +0200
Message-Id: <1210288662.3547.85.camel@johannes.berg> (sfid-20080509_011655_234582_DBEBB846)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8CqGywhiHa6EfSEB9D9H
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  That's not really related to wireless at all, if you want to do
> >  zero-copy IO then you need to checksum when the stuff hits the wire
> >  which means out of hardware buffers, which some hardware (including
> >  802.11) doesn't support so you need to copy, nothing wireless specific
> >  here :)
> >
>=20
> The FCS/CRS checksum of the wireless packet is performed in the HW but
> why should I care about IP layer?

Because the data you're sending is sent via TCP?

> >  Anyway, with the changes davem and I are making to actually save the
> >  *extra* copy we should be doing well. That's where you want to look fo=
r
> >  improvements.
>=20
> This is just for the bridging case, isn't it?

No, this is for TCP and everything else too.

If you don't believe me, read the thread, I don't want to re-iterate it
all.

johannes

--=-8CqGywhiHa6EfSEB9D9H
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCOKFaVg1VMiehFYAQIUMxAAhZTVeFVCJL3WbGKquQfXXxXvtqlcpvvc
NFB97QgjMQNT7+bhjhkNQGHS7DFJ2KsDREAzWOJqv0BdBSQBc3ts6PhXPte5A0Xd
ZAAd8osEhC/gfHAAiXCZ8OiOaucAck+yr0pWfGiBk1ZNmkYChKKbRhw2Y0iPli8A
/RD5xAlts1Smgyf6i0+noUpzRWJ0+Yor4fkagWJ4/xkzROsVp8F2WSW8pKrh3/Yj
oqvB0iazbOZFKnR2SDKeOtj8s1WFZa46w29CSPSfibGQn9vcmn2l+pFRnRvUYKK/
xl313ezed3Ui4Dzz3YNcl/ta0nI/r2InXjd+A2CCCpNR8iEzUQLif5kfo86oFdH7
4Ln/f4t9Y+daPoAbwzp6IwhLNcwAXWTCNXhDocHOYhSdXsdpYFsklJf7UQGK25Qk
7n1e02a2rpMrl7cZHivuqxyB91fU7LCMyWqC6RUpxA7fSq8B5kp6Bh0OWwnj8r9z
hhruf75HqJMebgXoxo6ooZrlSJ0B1IAbOP+7FD51LhALi/efVAOkLEM/0F93vtNn
iErXsU8965atbMvKMUlxI49MylRZuhObyfv4aPlXP27JEkIBvyIZQK780Rbn9Og0
ulwSmZuNLmlnlYbOE/xrk136vOpzNf3h0fqL6wJq9HYY1OQzLCu1GsHRY8AE52N4
VBJux0M/XfY=
=gNID
-----END PGP SIGNATURE-----

--=-8CqGywhiHa6EfSEB9D9H--

