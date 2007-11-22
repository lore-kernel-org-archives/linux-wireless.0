Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42581 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbXKVNFz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 08:05:55 -0500
Subject: Re: mac80211 regression: doesn't associate automatically
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <200711220912.10452.hs4233@mail.mn-solutions.de> (sfid-20071122_081201_818890_5F650412)
References: <200711220912.10452.hs4233@mail.mn-solutions.de>
	 (sfid-20071122_081201_818890_5F650412)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1X0sTqpWvdYp2X43pjlC"
Date: Thu, 22 Nov 2007 14:05:52 +0100
Message-Id: <1195736752.6323.97.camel@johannes.berg> (sfid-20071122_130603_064761_F5A24ECD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1X0sTqpWvdYp2X43pjlC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

First off, let me state that I don't think this is a regression.

> $ iwconfig eth1 essid BLAHMUMPF
> HW CONFIG: channel=3D1 freq=3D2412 phymode=3D2
[...]

As you can see, it doesn't find anything that matches the current
configuration.

> $ iwconfig eth1 key s:11111
> b43-phy0 debug: Using hardware based encryption for keyidx: 0, mac: ff:ff=
:ff:ff:ff:ff

You've now enabled a key, but not told it to associate using that key.

> As you can see, I'm not associated. However, this sequence used
> to work with non-mac80211 based WLAN drivers. However, I can actually
> associate if I reverse the essid/key, e.g. first set the key, then
> the ssid.

Can't say that matters since wext is actually sufficiently undefined to
allow both behaviours. :) I'm strongly against changing the behaviour in
mac80211 because wext is sufficiently undefined that once we accept one
of these things we'll have a HUGE mess of code because all sorts of wext
ioctls affect possible association etc.

> Note that the same happens if I let Debian manage the card. An excerpt
> from my /etc/network/interfaces shows:

That sucks, I guess debian's scripts need to be fixed.

johannes

--=-1X0sTqpWvdYp2X43pjlC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0V+r6Vg1VMiehFYAQIJZRAAvYP7ymPpmmEkQl2bmPdCy/MgaJ83wbpx
zrFNy3RfYfBaGik6fRnsZnG/Y0sqLoGlj0MVB16eGt35L+1bAmcWWxWc8/Rjuslm
SdL2Hjm0Vm8tabdM3FzwSPxGLg4wX/Xi6swYxIwokAKyrNy8VMypHtREkOCQGfX6
KPlHBYRoJXm+YxUBVqxPyrpPHbJacZXxQfavNvoIJEp/QGkfTurQkCZg/AjVKRbF
rIoxUTexofnvfxuWE2ilhxpMBRhumg0tOa8LsInEvfcMJumCrgdM7/2z7fE93tib
aJsM1fjU8rdT8xbA2g1sdKdLW3IDJ2WSq2NjIOxBJwyXVChZY+PBZCxtou2mcMnt
PhS6nHWOCv8w1hkdCl+TE3w6/VjHibtyrdYdX2EwYI4pxb3u8m5i7+ladNalGChT
Xi/Rq1XWFw3vFdJYAdg7mSLntah7bBrnTgy6zMKem2+5H8VPJbcOMNfaEW2R+BRu
HqBgAXV+T4kaIZ8bxYz/ltymKzBg5axs7JcFBc0dGrjHs5jqc6OpWWJeKmbkbeVc
G3EP3oFsXroC876AxYrM0otuhOxTnEryPRyoRdyfMqR2xUgTkbpqpr1pSRj29MxI
sEGe/WHJwnIuntxuQqSXjBE6ksJq7V18do7e4KojSt7xbf9eErVmG7J1Qs8Gqyfj
kAu3WOpIIto=
=7nV1
-----END PGP SIGNATURE-----

--=-1X0sTqpWvdYp2X43pjlC--

