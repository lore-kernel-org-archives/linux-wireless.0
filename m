Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39481 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbYKSAs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2008 19:48:56 -0500
Subject: Re: [PATCH/RFT] iwlagn: fix RX skb alignment
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	reinette chatre <reinette.chatre@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, Zhu Yi <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240811180613g48c94199s67e4334e89282e76@mail.gmail.com> (sfid-20081118_151342_814259_8B7C1A9E)
References: <1226969241.4014.24.camel@johannes.berg>
	 <1227001390.4014.43.camel@johannes.berg>
	 <1ba2fa240811180613g48c94199s67e4334e89282e76@mail.gmail.com>
	 (sfid-20081118_151342_814259_8B7C1A9E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UvE9g64ABGAo0XzzTLsp"
Date: Wed, 19 Nov 2008 01:48:13 +0100
Message-Id: <1227055693.4014.95.camel@johannes.berg> (sfid-20081119_014901_096262_3E57F0C1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UvE9g64ABGAo0XzzTLsp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[dropping a few CCs]

On Tue, 2008-11-18 at 16:13 +0200, Tomas Winkler wrote:

> There are other places with alignment requirement in the driver we
> probably need to address as well.

Indeed. One would seem to be the buffer list itself, which also needs to
fit within a 40-bit mask with 256 alignment (rxq->bd), the rb_stts needs
16-byte alignment which probably is always satisfied, but I'm not sure,
you'll need to research the alignment guarantees.

Another, different, question: I don't see where the driver tells the
hardware how large the buffers are it allocated. Can you point me to
that? You can switch 4k/8k ampdu but I don't see where you tell the
hardware.

johannes

--=-UvE9g64ABGAo0XzzTLsp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJI2JKAAoJEKVg1VMiehFYjg8QAK5Bszr6O1au9TAf/gSczR6q
c8CzTkbzhPSEh/Zq1Otl3q2075tBMLOQDh3aou8inWIEtHESdAgKqnk2UlrXptAP
53E3L8zV4YuitQzxfiQEmJqO+jpEfuQeytlANG+Kuo3cjieSuUc1FF7RdMik/Es7
XkV0/lenI64hmjl7vLRfcm2zL42xKBkwpssJxgFIhCyU6F3r1QLphNDWZOoRbfxk
3Esr9ASOBriGTRDFPe1goLAZRvtFBbGq2tFwes92hGFZGMk/prL60t9JYV5OZG3O
CAW1LanOYz27LcAKlTrIXgZQemZaMT2Snbimowhb/ihshwWj6S6q9gDuub4W3Yf8
cZoX1umH32OgAnbrg6P2Dc/hU+B/jarrj5ke47f8Y0k5T4n92Tqdn91Az0+IXmoy
+SlOleeIFGRoITqSv/tKbOe4B0gqZzwuew6ebr3WrEBwvtkNwJV+p8lA/2RKe8TS
OL99HR7qwz5njoLRahJpia6KmEfmVVTSJEkvHGd/NaexE1XS+0DyAAvVrfU5r3nM
oSN6N5d8CIVPksA9S8NYTKXcv0ijiOWGLzEJUsckF30EOOSwdnBC6Fu9DoccEJeU
6oh5NGIcxDeXo8JQMSCNgD1OOuJULc8MsncRTWTSdZEOrKQR7y7N3CDJPLEFU9Cx
f/9fnSKIsF73ErC7YP6S
=cFtL
-----END PGP SIGNATURE-----

--=-UvE9g64ABGAo0XzzTLsp--

