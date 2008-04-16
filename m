Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57279 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbYDPSxy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 14:53:54 -0400
Subject: Re: [PATCH v2] b43: Add fastpath to b43_mac_suspend()
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <200804152113.36990.mb@bu3sch.de> (sfid-20080415_201423_021212_CF6674C8)
References: <200804152113.36990.mb@bu3sch.de>
	 (sfid-20080415_201423_021212_CF6674C8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pgfghnvpXdr3gQYCrgI0"
Date: Wed, 16 Apr 2008 20:36:39 +0200
Message-Id: <1208370999.11676.60.camel@johannes.berg> (sfid-20080416_195415_307278_99DF06A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pgfghnvpXdr3gQYCrgI0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-04-15 at 21:13 +0200, Michael Buesch wrote:
> This adds a fastpath for the common workloads to the
> MAC suspend flushing.


> @@ -2340,12 +2340,20 @@ static void b43_mac_suspend(struct b43_w
>  		b43_power_saving_ctl_bits(dev, B43_PS_AWAKE);
>  		b43_write32(dev, B43_MMIO_MACCTL,
>  			    b43_read32(dev, B43_MMIO_MACCTL)
>  			    & ~B43_MACCTL_ENABLED);
>  		/* force pci to flush the write */
>  		b43_read32(dev, B43_MMIO_MACCTL);
> +		/* Finally wait for the microcode to flush the fifos. */

That comment is wrong, the ucode won't flush the FIFOs, it'll just go to
sleep. If you want it to flush FIFOs you have to set a flush request bit
somewhere (mac command I think), but you don't actually, you just don't
want to have it processing stuff.

johannes

--=-pgfghnvpXdr3gQYCrgI0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAZHNqVg1VMiehFYAQKilA//cqTqgNndAuKzglHIWgl+5c6v81RaWC2T
6hEes4Hn7i28ojK2+hh28rLDkwbgdlzg4L0Srri6noP7gxfm/Iey/jmtstEMABUi
kPRriVY5bvLVdWAA+mivuSFDVKGageV/RZ537bhLhwARAPy+HOgXt4+t6L8EAVwE
XHIoA2X4VZ2sZLxFSvLxysw0Kni2Uo9Yb913+7Dv3LeJzt+PN7eYt1DO/vHF2NK6
4aje/ZBKRXjztsRDn0TpbKNDhnD3R0BZXdLKtv2PMa+NdWFIvk+oGzoYTbyMBXWh
Adh58WrYXatqpn2Ysng7yYWw1gtVRMU9Pfqk5h4YpPWr/ZYexYrX+jeyiOcpbWmB
NLrg+9TVD9LpemGvUVzqdfiktLdpe/z784dyC1oJ0rh3TeiPS21FjPNUyCCjwHtU
oT+dv3WTxsgKouOituY0GflIH415Q3dqgM6nnPWl2bZGilpmPdJgpnG3pJwH7NLk
WFH9GUf9eOitrQbkU2f6+j9i+naHWgEoYVmDNgJLqp+Pke331XnWFBAfER/+B/+P
Q3Uk3GiyPh+raJLQtMupbEB1oqewr/HP7B4iTtsjAL6pcNpaTBSHb2XWYGhMfEYe
L7ArfDAyCoGAYjs6EgWsRjW9QXParhF8C770dsvx1o4OnnnTFP96F8HsLlcKX8ux
5fPvSyBmajE=
=iNMV
-----END PGP SIGNATURE-----

--=-pgfghnvpXdr3gQYCrgI0--

