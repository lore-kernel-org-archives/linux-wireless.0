Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.klingt.org ([86.59.21.178]:50447 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757582Ab0KLQD4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 11:03:56 -0500
From: Tim Blechmann <tim@klingt.org>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: rt61pci issue
Date: Fri, 12 Nov 2010 17:03:48 +0100
Cc: linux-wireless@vger.kernel.org
References: <ibgpgg$a5m$1@dough.gmane.org> <201011121449.27414.helmut.schaa@googlemail.com>
In-Reply-To: <201011121449.27414.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1560168.1nHHKyXj6D";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201011121703.51017.tim@klingt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1560168.1nHHKyXj6D
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> > cat /proc/interrupts |grep 16\: && sleep 1 && cat /proc/interrupts | gr=
ep=20
16\:
> >   16:          0    5140126          0          0   IO-APIC-fasteoi
> >=20
> > uhci_hcd:usb3, ahci, 0000:08:00.0
> >=20
> >   16:          0    5140357          0          0   IO-APIC-fasteoi
> >=20
> > uhci_hcd:usb3, ahci, 0000:08:00.0
>=20
> Ehm, one more thing: are you sure irq 16 is used for rt61pci. At least
> that part of /proc/interrupts suggests that irq 16 is somehow USB related.
>=20
> Could you check which irq is assigned to rt61pci?
> Can you reproduce the hangs without rt61pci as well?

it is irq 16: 0000:08:00.0
from lspci:
08:00.0 Network controller: RaLink RT2561/RT61 rev B 802.11g

the audio dropouts are somehow in sync with the network access. i actually=
=20
changed one thing today, increasing the timer frequency from 100 to 1000 hz=
, and=20
after 8 hours of uptime, the machine still works nicely. i will try to comp=
ile a=20
100hz kernel with your patch, but since from my experience, it takes some t=
ime=20
to show the behavior and i haven't found a way to trigger it consistently, =
it=20
may take some time ...

thanks, tim

=2D-=20
tim@klingt.org
http://tim.klingt.org

After one look at this planet any visitor from outer space would say
"I want to see the manager."
  William S. Burroughs

--nextPart1560168.1nHHKyXj6D
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzdZWQACgkQg0On+TFEWzxE9gCfY/DXbapn3rF4iICyszJukmi6
JVQAn2T2Q8wjp9eVq7x2xM7vGY6KBWWu
=/ikS
-----END PGP SIGNATURE-----

--nextPart1560168.1nHHKyXj6D--
