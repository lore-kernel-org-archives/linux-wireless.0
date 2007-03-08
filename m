Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51060 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbXCHQpZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 11:45:25 -0500
Subject: Re: sparse using insane amounts of memory
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org, linux-sparse@vger.kernel.org
In-Reply-To: <1173371608.21465.12.camel@dv>
References: <1173319356.3546.54.camel@johannes.berg>
	 <1173371608.21465.12.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gy5OON78MuuNFRX/xO4L"
Date: Thu, 08 Mar 2007 17:45:14 +0100
Message-Id: <1173372315.3248.19.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gy5OON78MuuNFRX/xO4L
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-08 at 11:33 -0500, Pavel Roskin wrote:

> You forgot the version of sparse.

Good point. The commit is c4670dfcbe52b598e263c452762a66d22e636585.

>   I cannot reproduce the problem with
> the current sparse from git
> (git://git.kernel.org/pub/scm/linux/kernel/git/josh/sparse.git)

I just upgraded to 309f3805ddec9ab2f9c62da573586a7cf7c1f17a and still
observe that it uses a lot of memory.

> If you still have the problem, please remove rt2400pci.o and run:
>=20
> make CC=3D"gcc -save-temps -D__CHECKER__" KBUILD_NOCMDDEP=3D1
>=20
> rt2400pci.i will be found in the root of the build tree.  Please see if
> you have a problem with it.  If you do, please put it online and post
> the URL.

I ran=20

  make CC=3D"gcc -save-temps -D__CHECKER__" KBUILD_NOCMDDEP=3D1 M=3Ddrivers=
/net/wireless/mac80211/rt2x00/

and aborted when I got lots of errors, rt2400pci.i was created and has
about 26k lines. Running sparse on it (sparse rt2400pci.i) takes a lot
of memory too. I put the file up at
http://johannes.sipsolutions.net/files/rt2400pci.i

johannes

--=-gy5OON78MuuNFRX/xO4L
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF8D2a/ETPhpq3jKURAn6GAJwPeORchTuh9CGHfRGKq7sNcMyztACfQvKQ
yqjjKFBkh8Z7ZUNw9GmLSBo=
=ZU1/
-----END PGP SIGNATURE-----

--=-gy5OON78MuuNFRX/xO4L--

