Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50530 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbYLIQwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 11:52:21 -0500
Subject: Re: [PATCH] ath9k: remove fragmentation workaround again
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>
In-Reply-To: <20081209163939.GA7947@jm.kir.nu>
References: <1228821974.22164.201.camel@johannes.berg>
	 <20081209163939.GA7947@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nsW1Uw/gaD4C/nBPB8IG"
Date: Tue, 09 Dec 2008 17:51:25 +0100
Message-Id: <1228841485.1029.16.camel@johannes.berg> (sfid-20081209_175224_736831_3B608D04)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nsW1Uw/gaD4C/nBPB8IG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-09 at 18:39 +0200, Jouni Malinen wrote:
> On Tue, Dec 09, 2008 at 12:26:14PM +0100, Johannes Berg wrote:
> > Looking at the RC algorithm this is no longer necessary.
>=20
> > Untested, but the error that used to happen will no longer happen since
> > now the sub-structure is assigned by the driver, in rate_driver_data,
> > per fragment.
>=20
> Thanks! Based on a quick test, fragmentation was working with this
> patch. I never tested the old issue, so I'm not sure what exactly was
> failing, but anyway, I do see fragments in a sniffer log and the device
> did not crash ;-).

Heh, well, the broken rc algorithm would end up with a double-free and
slub/slab/slob being very unhappy.

johannes

--=-nsW1Uw/gaD4C/nBPB8IG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPqIJAAoJEKVg1VMiehFYoG8P/RSMn91Cky23SahIDogvbtMR
hZHAZMm9ckmtD8N8IqOL3SfXzIWFwlhhS0+fUGXf4iK4/2ZOqjxD1Z7/4GdTz+tx
vZG1nxB8myWxGalc4abyUBXjiAx/TLCjpHJWX9PKyDqvTG9kA3mBNn+z3mSk7oKK
hZQzcZixbluqcqncO4vnv75lU4GGNDpY8RgqFnwAFSlY28mR05hHctO+2Dxe4EQi
V9ACsbM9bD+x8VCj7FKp2MhOHbmd5OCcIVaiKT/GGlpDnZYolRa4gTuZlphDJYa4
JUrPEylyCKHoEg7CAPb4SMmmiIZVtTWrLvatmZmyyoXF5sEJlMyiF/bUW5tZ3lJh
+LyD7gZ+wxGe3/jEb+hlOyJxEK/0bMwCs5N6rIrA8VSNuTIbM8YswAL3JQamcwUi
ZFlHocX937dbb9OczR4Rq/XuhCpCk1XOe5Eqlkehtm3Epd/HuTBAnZ7wizN6Ecqi
Aj4kUCrjwk6jPlj1vQKQenZkXPRo9B43vL6TGG6E8l/IqaFNVtP6rOCoXIyUXn9n
Q5Br2wOUqO4Yv4sjiW7chXOROTf4+pInG03nwDzo8TYrzzzhBnTILTk2cfzKx96+
VJFBLs2uTLuQI5Uz15stBY7Lg3iWplPZWJY4S+BzwHln7czDoVqgVMBz9zQ+ih6j
/LUhOa5eOLmcPBTwk1fY
=FbNK
-----END PGP SIGNATURE-----

--=-nsW1Uw/gaD4C/nBPB8IG--

