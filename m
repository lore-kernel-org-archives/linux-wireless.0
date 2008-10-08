Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52788 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbYJHICI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 04:02:08 -0400
Subject: Re: [PATCH] iwlwifi: get rid of IWL_{GET,SET}_BITS crap
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Christoph Hellwig <hch@infradead.org>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
In-Reply-To: <1ba2fa240810071346n506b8f1clffaebb7f1f72a10f@mail.gmail.com> (sfid-20081007_224644_429441_1A1EADC6)
References: <1223311803.15196.36.camel@johannes.berg>
	 <20081007071529.GA5010@infradead.org> <20081007131615.GR3448@tuxdriver.com>
	 <1ba2fa240810070703j471faa30mce3678febf3c20e8@mail.gmail.com>
	 <1223398724.7328.45.camel@johannes.berg>
	 <1ba2fa240810071228m52a60861r5558529426b9b487@mail.gmail.com>
	 <1223408085.3618.2.camel@johannes.berg>
	 <1223408342.3618.7.camel@johannes.berg>
	 <1ba2fa240810071306sb282e06h9d29ea2c36f5c3d5@mail.gmail.com>
	 <1223410226.3618.13.camel@johannes.berg>
	 <1ba2fa240810071346n506b8f1clffaebb7f1f72a10f@mail.gmail.com>
	 (sfid-20081007_224644_429441_1A1EADC6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8F2GxlogSnhALiRIXvMv"
Date: Wed, 08 Oct 2008 10:02:03 +0200
Message-Id: <1223452923.3618.25.camel@johannes.berg> (sfid-20081008_100212_635073_D028939D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8F2GxlogSnhALiRIXvMv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-07 at 22:46 +0200, Tomas Winkler wrote:
> >> > bytes (with nibbles): | . | . | . | . | . | . || . | . | . | . | . |=
 . |
> >> >                      | addr 1          |len1 || addr 2          |len=
2 |
> >> > your forced layout:   |               |                |            =
   |
> >> > my layout:            |               |       ||               |    =
   |
> >> >
> >> > Note how this actually matches the border between the border between=
 the
> >> > two descriptors, the || border.
> >>
> >> Your layout put addr2 (which is 32 bit) sits on 16 bit boundary
> >
> > So? Yours makes it need two words, which is even less efficient to
> > access. And since the struct is packed, on those architectures that
> > don't do unaligned accesses efficiently won't need any put_unaligned
> > either.
> >
> > Also, keep in mind that address 2 is _never_ used at all anyway

> This is not correct we always use first 2 pointers. First for tx command
> second for the actual packet.

Ok so you use two. Writing three words in total. I strongly suggest that
you have WAY more trouble in iwlwifi than an imagined performance issue
coming from a corrected and understandable struct layout.

> > because
> > we don't and cannot do fragmented frames due to the lack of IP
> > checksumming in hardware, as I and davem have tried to explain to you
> > multiple times already.
>=20
> This is bad side of current Linux implementation

Look, we've tried to explain it to you so many times that it simply is
not possible to enable fragment collection without IP checksumming in
hardware that I don't know what to tell you. This may sound offensive,
but are you really too stupid to understand it?

johannes

--=-8F2GxlogSnhALiRIXvMv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7Gj4AAoJEKVg1VMiehFYc0IQAKa9Lb4+uwUCnkJ9t+MHjK43
3dBuKznXOXABL6i+A33VgdLSU0FfAfoEuUaLtVWaUOLjMiL+CeK6FmD4w7VfG2af
TUS9r1YCtJX8UHamRPuHYPFCK/mMmJuXD0wHkdpLeAj2deTcdGbq/iv4XiwddLnM
DvscKHmGOwUoVEbyvJZEr72RkOYGcX/FUj/WZKT5pmbIjYaW9SdVuscyzC3BA/87
UzY9hvHwpfVqCbHLs+TTOQ7FtS3O9HE5WO+zoPXw5RWcULuPkgsFNAMxgvffAAmF
tpCln0RAnZ4R1QeqTEGuuPb/ZwUao/5nZUtQNmV2tQBRzk/6CC83wHbEU6CohukB
cMS5jfNFJcXns7RNAz5pMGESFHWSKK/GK0waRwqfQxS46/eNyDzO/IppshE8NekS
oExkeN/MEcArzSyC940ge1EiOtUQgdu8IfdYCIerPW8yyD/CKNKHln8gZf8Lfjoz
Un7VC/fo/6nqNGcoqQoG7FXxJdGygu2+2GaVSmqxOBMbUfFY3DnsFA2Em5V5fHFm
J0N3Dtn1y2c4kM6KXIYulNR7A28gUJ7Nq1PFmClbL+JTBm/JdIZ/dbw4JLhX9rX3
v6AUv29Glaevyo1ED6NlCazK6Y+0v2IColDsywofWXvjS5BHEjDMWGWoXkJ+Oso0
a/v3S+OmRbfhBxBWF2co
=Gicb
-----END PGP SIGNATURE-----

--=-8F2GxlogSnhALiRIXvMv--

