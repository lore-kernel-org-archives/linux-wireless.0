Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55380 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbZBIMOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 07:14:34 -0500
Subject: Re: [PATCH 3/3] mac80211: Modul. mesh path prot: Skeleton Module
From: Johannes Berg <johannes@sipsolutions.net>
To: Florian Sesser <flomaillist@cosetrain.com>
Cc: linux-wireless@vger.kernel.org, Benedikt Elser <elser@in.tum.de>
In-Reply-To: <49901A58.4030403@cosetrain.com>
References: <498F36B7.40806@cosetrain.com>
	 <31341041c003f9a10f7ef791dc74748c0ba6b46f.1234118418.git.flomaillist@cosetrain.com>
	 <897787d59c53459e0bff3a6829ac470f6ed2e84e.1234118418.git.flomaillist@cosetrain.com>
	 <944d8e06a2b02e5ae6d612fb435d540958023ff9.1234118418.git.flomaillist@cosetrain.com>
	 (sfid-20090208_205238_672681_BE3F6B7E) <1234176251.4175.222.camel@johannes.local>
	 <49901A58.4030403@cosetrain.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-u5XxiMS7YEdpgy9ajnEN"
Date: Mon, 09 Feb 2009 13:14:28 +0100
Message-Id: <1234181668.4175.233.camel@johannes.local> (sfid-20090209_131438_630123_414EF629)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-u5XxiMS7YEdpgy9ajnEN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> Johannes, thanks for all of your comments! I will need some time to work
> through them, though, please be patient.
>=20
> Johannes Berg wrote:
> > 00-0F-0F   (hex)                Real ID Technology Co., Ltd.
> > 000F0F     (base 16)            Real ID Technology Co., Ltd.
> >                                 9F Hanmi B/D 192-19
> >                                 Nonhyeon-Dong
> >                                 Gangnam-Gu Seoul 135-010
> >                                 KOREA, REPUBLIC OF
> >=20
> > Have you asked them about using their OUI?
>=20
> Nah, sorry about that - I didn't get 0x000FACFF meant 'null' in the
> first place,=20

Actually I was looking at Draft 2.0 - 2.08/09 seems to have this
updated. And no, I don't really have access to the documents.

> and since I don't have access to an OUI yet, I selected
> this value by random. I still hope nobody seriously wants my skeleton
> module in the kernel code though.

Heh, right.

> BTW... do you know which OUI in that case (at devel time, this is an
> university project, afaik the university does not have an OUI I can use)
> makes sense for stuff like that? I believe there is a reserved range,
> but I don't know for what reason it's reserved, and if I should use it
> to avoid misunderstandings.

I don't think there is a reserved OUI.

> [do you really think I should to copy the style of rate control? i don't
> like it at all. they have KBs of (IMHO) not very useful code instead of
> keeping it to the point? Even in the Kconfig. Please correct me if I got
> this wrong.]

Depends what you mean by that? I think you should force one algorithm to
be built in -- just like rate control. I also think you should take a
look at abstracting the API like rate control to not expose so many
internal data structures. Alternatively, just don't make them kernel
modules but require building the algorithms into mac80211.ko anyway.

> I know that, as I'm pretty new to kernel coding. Should I get me some
> mentor from the kernel mentors project, or are you willing to correct my
> stupid beginner mistakes all the time?

Seems fine at this point, I take it you've looked through
http://wireless.kernel.org/en/developers/Documentation/SubmittingPatches
and the links at the bottom of that page. Also
Documentation/CodingStyle, and checkpatch etc. but that seemed fairly
clean this time around, so I guess you did.

What I didn't like about your patches was (1) the cramped style with so
few empty lines, and (2) the API issue I mentioned.

> Also: As you still haven't said anything about my ops struct, I deem you
> think I have made a somewhat reasonable selection here?

Not sure what to say there -- you don't really have a choice which
functions to make virtual. The timer thing seems a little odd, either
the algorithm should do everything or nothing, imho.

I don't think it's necessary to split this into an ops and a
registration struct though.

johannes

--=-u5XxiMS7YEdpgy9ajnEN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJkB4cAAoJEKVg1VMiehFY2zsQAJ7tfQJfHTfmaOkxuJR8jYsG
dVegVP6g6e8y9CY+Ie94QaWtuixghz6ww70lynKA9Zs+c34RlFvP05cCyB7BrDwm
cKA/E2HV07LsONQhba0/MA7QRRDYPdpPXkbtN3ftzTk46zACgqwXc1+EV4+DCzS+
pGrLGX7uJk9TNRqCbqDSvGZq4An6DPw41fYsjkMaIe/1VVBkMgd+xhujY6OxWHy6
Qs9GpAelg7GaLqUyQc7F63NrAnnYwo6STZbe1AdThWC1noB+KiwhAU4SGDuEonRi
eoMtpl8Lk0+PLFG/FreH9FqgPR2x1FI4xd44pzRLuPSV/IH4GmIiBrk5Sqi4GEpk
jIcunSisptIEXiAfbYADT6uhlcYyIJd+hL6ecrrD+5Z+yGorX2JMnIRfb6HQ5NoN
94a8FCw4ffLjpDFolmmfqI8W0WCGj9XRVlzOZNtGfXUu+PaeXy6Mhrhj8MxCyHB7
N4H0CIGEDy9N/19ThAlOkZfLYPFIF3arl5auwaalKucoUi1uB4AEKbWthWEhjoZz
WAGmrriT+RrQ3KJm3sfi3iBGaZuEAuAebG832eZmDSVPB8hOhzvjUqNDlevtRnI7
ulWbzJKItF7kVKHVyr8AJeVhhLM6HszrgFc0btjWVNyF9/pcfLQzTcoq9juva9xs
JxZHJs7ADPsCdDctAsW3
=K9Oo
-----END PGP SIGNATURE-----

--=-u5XxiMS7YEdpgy9ajnEN--

