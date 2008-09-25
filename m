Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57594 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbYIYE3n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 00:29:43 -0400
Subject: Re: Crash with 2.6.27-rc6 with iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Ian Schram <ischram@telenet.be>
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48DAC681.9010305@telenet.be>
References: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com>
	 (sfid-20080911_100535_000722_EE099914) <1222287287.4257.49.camel@johannes.berg>
	 <48DAC681.9010305@telenet.be>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FHdQTOAFlZ9d6ddXmk99"
Date: Thu, 25 Sep 2008 06:28:51 +0200
Message-Id: <1222316931.10563.7.camel@johannes.berg> (sfid-20080925_062947_844100_429512F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FHdQTOAFlZ9d6ddXmk99
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-25 at 01:00 +0200, Ian Schram wrote:

> > Incidentally, if this really is the same bug I have, you might want to
> > remove the iwlagn module completely, even loading it once is a bad
> > thing, it has started to corrupt things here entirely by making DMA go
> > to random locations.
>=20
> with the release of -rc7 i was starting to wonder what had happened to th=
is bug,
> i'm not affected by it(other hardware) but from what i gather it's a seri=
ous problem?
>=20
> i have always wondered what people affected by this find if they revert t=
he
> "memory allocation optimization" patch
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dco=
mmit;h=3Dda99c4b6c25964b90c79f19beccda208df1a865a
>=20
> apologies if this is a too random stab in the dark, just sounds like we m=
ight want to fix this
> before .27. And since there seems to be no git bisects that pinpoint the =
problem ..
> i figured i might as well send this.

I haven't really pondered bisecting since it happens for me with iwl5000
hardware which wasn't supported before... Because this bug was affecting
my machine quite a bit I've now removed the wireless card from it for
the time being. I still think it should be easy to reproduce by using a
machine with a good amount of memory (I have 6.5G) and enabling
CONFIG_SLUB_DEBUG, which seems to have at least some part in it.

johannes

--=-FHdQTOAFlZ9d6ddXmk99
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI2xN/AAoJEKVg1VMiehFYZhoQALUFNodZJ2L5/UKAA4CMJ0PO
zzLWYCDC6mbH5i8OZt0NetcNn4qIwYZ7TG5GhbbxQY0onsSjS6rgmE8C2OzAD/Tc
7N2GeHKlOpidbPnDeYBXn8LxktDo5wjGswbW8Aatmt3ZmnCZlCPgHDvjpEPMoGwd
eKxr9w9WKtIvcg2yqwsG2gpOERfO8QbNShHdLjmbn3tXVD7IFqOlnzB59lKF+OnB
3gIkciKwU2GCEfsxI86gCIPhwwkTR5ja0VYQeJk0YSIPpJva38Bb3cNFHTwOFCjJ
NtWhcfm1RKjpS0rs6MNxISkHjBZ5QTxIXhF1Xzfsu0ns6bwoAn9cvFaos4lnRDcx
pu1Vsd8iXlq+D+ztxbIFesC8iayj2KfKElrva9DAkDPn4XTEKQ/4rvLAY3TrEXlW
TF6r0ulYm/WT9XjiFyVmVRm7seCBOwOh8fcn+vBM12Jcv+cSbDdBQv80vzeFFqTk
5JOOGUKpAqzQyWWQhJYyWT6fX+5yUzqG5AruW+ozsmRwTL1xXbFgapOO2Q/32xp+
MsQ9cg3ZW/edtl0uK3z/leD+bpQPHKsjpDln8aA6POiGW3rhnTlz4UZeYMy5Jih8
sBImN5+jGEgsjc1OLNC53yMiM4ubgszsFkjxDjFHTYboeUINRYCBq6hgPXv/bKd+
KdvPUHYmuQ36c5WDqUUU
=E7u+
-----END PGP SIGNATURE-----

--=-FHdQTOAFlZ9d6ddXmk99--

