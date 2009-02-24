Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53225 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbZBXOXt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 09:23:49 -0500
Subject: Re: [PATCH] ath9k: Add module parameter to disable hardware crypto
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090224140625.GA30004@jm.kir.nu>
References: <20090224114201.GB21933@jm.kir.nu>
	 <1235483347.4320.7.camel@johannes.local> <20090224140625.GA30004@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RDZ0YC8Jg41YBfxHnjJM"
Date: Tue, 24 Feb 2009 06:23:09 -0800
Message-Id: <1235485389.4320.12.camel@johannes.local> (sfid-20090224_152351_973612_98F93CDE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RDZ0YC8Jg41YBfxHnjJM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-02-24 at 16:06 +0200, Jouni Malinen wrote:
> On Tue, Feb 24, 2009 at 05:49:07AM -0800, Johannes Berg wrote:
> > On Tue, 2009-02-24 at 13:42 +0200, Jouni Malinen wrote:
> > > In
> > > addition, this allows management frame protection to be tested with
> > > older hardware revisions.
> >=20
> > This is odd, shouldn't older revisions refuse the hw key setup and use
> > software anyway? Or are they unable to distinguish between management
> > and data frames and thus it all goes wrong?
>=20
> The exact behavior depends on the hardware revision, but some older
> versions would likely end up using the Data frame rules for decrypting
> the management frames and as such, would require software workaround
> that re-encrypt the frame using Data frame rules and then make the frame
> go the normal software decryption. While this is possible to implement,
> I have not bothered to do so yet and don't know how much interest there
> would be for such a feature at this point. This would also require some
> new APIs from mac80211 to allow re-use of CCMP code.

Ok, that makes sense, I probably wouldn't bother implementing that
either. I know Broadcom doesn't touch management frames, they explicitly
check for that before running crypto stuff on a frame. :)

johannes

--=-RDZ0YC8Jg41YBfxHnjJM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJpALLAAoJEKVg1VMiehFYWn4P/04hBYAfsv9CU88qFj5QBe7Q
xN6EBghPVnbc3zwIk8IiDPM8B51WJC66Uw/qT7xVJ5Mj4wlKR7tBtc2da23M81tH
ElQVIu9JISUuoSAeKqBnTO1ELZNTJijYLXBkFgfYH+ioTMTjZZacZx6UQVLfnrbi
BY0z3aV568BSUVsPJ13In0o+ZmPMJYTqNv0SoOztqkhkI+1xWtBcz/PC5yVujXjU
BJU3h8rp7Bj71xCW05bN1Bdcz/2VXB6yfvQKSwsggm00feSWWPEfDKPxfAS+Y/DG
bfnoPPWKND7Z/tyzfpEsLghYojKOjKDy4OZbxX/EB+i5QT6+VTtfLMj0fWrey3ZN
4BbP2sPa683qjRupq8dyONGdmTiY4Pjqkk3GOuWq7nV1x3p4HAzQGS1r0oTsbWhu
CIbT/3AGKQZqTerWwnolc5GXuBb8Mtb3fkaxDtjNw+yB8oxQeeT1sL15rkBIdFKy
d8PFp99j3wlMko9EoKwOzVmN2g3CjJDmq1m/bWTXNgpf4XEeGaKn6VIR/J0GOX20
sy9rNzn/6e6CofvOUwcV+USYAzS12IMPGkhRumsssTp6wo3QizShb/d8ztvgSYxk
oIGtIFxefO6Oo3ii3c5C42GQ3xqhwBTHtGT4dsdlTBXcrSm0sUtK22ZwDAu4sqAb
INFBwttUqQoZ6+yAMPpr
=3wuU
-----END PGP SIGNATURE-----

--=-RDZ0YC8Jg41YBfxHnjJM--

