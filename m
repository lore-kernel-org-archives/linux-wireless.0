Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47992 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbXJIR2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 13:28:53 -0400
Subject: Re: [Rt2400-devel] Mode selection in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: rt2400-devel@lists.sourceforge.net,
	Adam Baker <linux@baker-net.org.uk>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200710091932.45235.IvDoorn@gmail.com> (sfid-20071009_181627_253740_981E824E)
References: <200710052319.10600.linux@baker-net.org.uk>
	 <200710091627.44276.IvDoorn@gmail.com>
	 <1191949526.4013.34.camel@johannes.berg>
	 <200710091932.45235.IvDoorn@gmail.com>
	 (sfid-20071009_181627_253740_981E824E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-21lWLp7Vkgf5Hjeu/jG+"
Date: Tue, 09 Oct 2007 19:29:33 +0200
Message-Id: <1191950973.4013.45.camel@johannes.berg> (sfid-20071009_182858_180624_28A2121F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-21lWLp7Vkgf5Hjeu/jG+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-09 at 19:32 +0200, Ivo van Doorn wrote:

> Well that is my point, if the documentation is correct then rt2500usb
> has 2 locations to initialize the IFS. So it would always be set and the =
question
> would be what the impact would be to set the IFS per packet only.
> But that is something I need to test with just some experiments.

Well, it's not too strange that it has two places since there's the SIFS
too which is needed for ACK/CTS timing, these packets aren't sent from
the host so you can't have those timings in a per-packet descriptor.

> This means that the device would be able to operate correctly for
> 802.11B even with the 802.11G timing initialization. Because according
> to the way the legacy driver is setup, working in 802.11G while working
> with the CCK rates would be possible.
> This also means associating to 802.11B AP's while in 802.11G mode.
> So we might be making a big deal out of something while the source
> of the problem is very simple:  The legacy driver code is just wrong. ;)

Well, no, if you have a pure 802.11B AP then you have to use the 11B
slot timing, if you have a G AP then it'll tell you which timing to use
(I think)

johannes

--=-21lWLp7Vkgf5Hjeu/jG+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwu6fKVg1VMiehFYAQJmBRAAkle+gHuGtzS4STDGDg5gBGnqwJSLtsPj
2RGi/mzmuMq0W49AjkCzWZPFx0D1+57ukWyBp2zUtHBd7tla/tlymRG+UWMZqOa/
ONnEi0z029jQT9CZG4oT8DXYTXlTh5jiNcQFMiBAfex0DG3sbLIZ7Ndx/4oml7oS
ITfyLOEM/Sx4YWJFsXvjiKkRbcJgXepJESX2dlrVeRYfUuLQg00FtYqI4EmDD1PU
21UY8h0GuZAvmTJLGNJ6CjwDJODXCwQwJ/r9P1BsIDFaJJN4+xpv9lqrT2xgycgK
V9y1XxdrkbkUJ36HlXtkj3tgCk/geR9n/LlCYQOh7t3qoiKPILR7lkXIKRZSOtlJ
JVvTjRzNBYdpSmd5tuFS81CGHJxImlK+U31Ki4j+szsw8NBovzF08yotu6xKYl4N
30qdkwQ7SotjZ/znSnBT5XWxQ8BzjWqPHr6rr5JjtnBflDYkNuf2q5FymE17pSbI
DcWWUeJjEZH1IGdmofoi+MRPghv7mhwxCk1EuRcB+9hgdYT5FlQHT5fIlQNAUnK4
R7qqsc3DbG7lMC9OuiDXxAwAtPptjOJyodiduhz1q2AVJTMos0zLJhblcRIToyh6
h+3hPTFxW31KzozODI89+8XGxwuy5chRE0Y8MumQG6QvG/j8m7PTdTG1W8cNxbXq
LammYA22DwM=
=Vjnt
-----END PGP SIGNATURE-----

--=-21lWLp7Vkgf5Hjeu/jG+--

