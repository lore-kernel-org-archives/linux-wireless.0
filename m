Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40551 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZKIN1i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 08:27:38 -0500
Subject: Re: [PATCH 11/21] mac80211: add WLAN_EID_RANN
From: Johannes Berg <johannes@sipsolutions.net>
To: Rui Paulo <rpaulo@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Javier Cardona <javier@cozybit.com>
In-Reply-To: <B2865F30-1886-4985-AB76-2AAB769530F4@gmail.com>
References: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
	 <1257770381-7680-12-git-send-email-rpaulo@gmail.com>
	 <1257771552.29454.171.camel@johannes.local>
	 <B2865F30-1886-4985-AB76-2AAB769530F4@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ikUkolSsxaIVjmjSNHga"
Date: Mon, 09 Nov 2009 14:27:39 +0100
Message-ID: <1257773259.29454.175.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ikUkolSsxaIVjmjSNHga
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

> > On Mon, 2009-11-09 at 12:39 +0000, Rui Paulo wrote:
> >> Process the RX of RANN information elements.
> >
> > That commit log is not really right.
>=20
> You're right. Is "Parse the RANN information element" a better one?

You're not really parsing them either ... Maybe "add code to find RANN
IE" or something? Doesn't matter that much. For all I care 11 and 12
could be collapsed into one patch.

> > I'd definitely prefer if here you added a 17-byte long struct that
> > explains the layout of the IE, and then used that in patch 12. Also =20
> > it's
> > probably useful to check the length directly in =20
> > ieee802_11_parse_elems.
>=20
> I prefer structures describing the IE layout too, but I was following =20
> the mesh code on this. If structure layouts are preferable, then there =20
> are 4 mesh IEs that should probably be changed.

Yeah, but I think at least one of them had a problem with struct
description because it was kinda variable. Not sure if that's still the
case though.

> Regarding to the length check, I was also following the way the mesh =20
> code does it. Again, if we want to change RANN, we should probably =20
> also change PREQ, PREP and PERR.

True too.

But you were just adding a new one, so I figured I could ask you to make
the new one nicer, but couldn't really ask you to fix the old ones :) If
you want to, I'd welcome it.

johannes

--=-ikUkolSsxaIVjmjSNHga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK+BjIAAoJEODzc/N7+QmapjEP/2k1UtWiPRhevmPiyOPOcjKa
78wGL+GF40c111+9p3BeK3ZYRPIMR36FQt7KcpihcnsePSLsl5p868UZ1aQscSHq
sG/jrkALJAqmalrWfEObtBmDHKiXlQgNJYe0QYQazs/QYR/Kmywr2sZC+PsiBkLG
7DgS/mfnygD9A6pceK381xFCROaoLHNK1ygRZdhDOFTYm62grQePS93KmagSV2ux
61xLnOqpIuiH1TsQzdXqa/NzNCCC1ZpUVhCIkDeNt2dm9sWMhZk02pbciLWGHq1B
Fh+1i0cZPTkAN9HjtUjaagNQMVguoNIPd4Zd4wCi0ozN2yHAvYqOY9Afi1AYvpv7
HuLy96GBDH/pIcrOcI2YvHdOxi9iL60X9OqIwcGj7TotUr2pGhArqwaBPOdhxIEJ
S4a5RwuI6qa41u/IoMhsM7+B4cBoRBn6d1afVg5w0kAFLgS+if1m+7kiQtaPKKyf
fENNrWNc53rm0MYDny9rPxcvKZecJ/9e3mArVP5tb06s19zB8QlkZCuRyxVOJom/
Foj4ECZ5SXFAmmDntrmYTFOq3wgCeDYjl9AcwMZGjPrXTcOPj2g1WdDSwzaWrICn
rkPITYQFZDVQZ4W1RmRRNIe3HfcWrN9ARuDRHsjE26BWIImtnIbatX2G5ZurvIhO
iPKog1PSpEomkbysd2hp
=l2Qm
-----END PGP SIGNATURE-----

--=-ikUkolSsxaIVjmjSNHga--

