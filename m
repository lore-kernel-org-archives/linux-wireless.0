Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59674 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbYJFQ42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 12:56:28 -0400
Subject: Re: Crash with 2.6.27-rc6 with iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
	Zhu Yi <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <43e72e890810060952p6a9a7ae5i30bdda28f1a9fab8@mail.gmail.com> (sfid-20081006_185305_022497_32408FE5)
References: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com>
	 <1221123779.2513.88.camel@debian.sh.intel.com>
	 <1221184060.11498.3.camel@californication>
	 <1221185432.6695.0.camel@californication>
	 <1223296221.15196.6.camel@johannes.berg>
	 <1223296592.11272.163.camel@violet.holtmann.net>
	 <1223296783.15196.13.camel@johannes.berg>
	 <43e72e890810060952p6a9a7ae5i30bdda28f1a9fab8@mail.gmail.com>
	 (sfid-20081006_185305_022497_32408FE5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-P/lEQCnENRYrn2o0GIg9"
Date: Mon, 06 Oct 2008 18:55:54 +0200
Message-Id: <1223312155.15196.43.camel@johannes.berg> (sfid-20081006_185631_596418_C328105C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-P/lEQCnENRYrn2o0GIg9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 09:52 -0700, Luis R. Rodriguez wrote:

> > I have a different interpretation of the original issue, since afaik th=
e
> > value it was doing a BUG_ON on is a value that is only passed in by the
> > driver and copied by the ucode to the response, hence it shouldn't
> > actually crash unless the driver is passing bogus stuff in or, as it
> > seems to be the case here, the DMA programming is completely fucked and
> > the ucode just goes to write to random memory locations.
>=20
> Seems like a good enough argument to call for it to be opened up.

But there's a chance that the DMA programming being fucked up will make
it scribble over your filesystem buffers. So it's surely safer to
BUG_ON.

johannes

--=-P/lEQCnENRYrn2o0GIg9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6kMXAAoJEKVg1VMiehFYHA4QAIernGWAksUAbcrDbwxncel8
IKOpaJ7obogTVDXjSDFkX097J0c6icRoK3quUcnqJsFJRng2/rUC3ZN1iCyLxy9W
YpSGzor618Q3XEEIQ4WKKsvecdoKyFLgogLItvlkMfvcihvC5YS+TAfjcI/VShP5
ZsbiwNofi/9uwUh7WqxImIkfLhPm0+SX0QTE1DvqrgYL9nWgpBTdBzoJslUfA+hc
u8/hv18+3RozBlo/UxyXdoxK0x+0upGazJGl1yTKLzOrKtvru96dtjkhr4q7Fxba
Hh9BC7/NiU8Cc1naD7dxVvo+M9D57zXLm7gKIVUTzUJ9p1FgM8aRm/0hBplLUw9b
0gNRxEOflH5DHlC+odeQZxp6Ib2vs8BxlYt8M8ZWtcpo8yT09wZdhZqNMDVDXFFK
NYMoZ7j9eqU/ySif5TBIaVCvu4bmm2+ieNtVyJLo1W/nXWJ0dsm7fjjf+5zILRxK
J9Gvbtp11RZjHO3xwdCw9egHF6yhWh196Y4xjDuZPfbngytix1EJ0hnvwTtcDJVQ
AGojDk4+vgjWVNxj14gGwA83XZd6byg8yWqSwtDM+jWI52hsz8eLcO/PNiyl9kjY
3kYJzKKEJKpsRXS9mc9XNkbuO6PaCauenKqxZWs7EKaARiKI2c1MU/5Ue7lR1mcI
JT+s/isoF0VqYjZ1MsAb
=V7Mb
-----END PGP SIGNATURE-----

--=-P/lEQCnENRYrn2o0GIg9--

