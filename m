Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49089 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421AbYDCNTr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 09:19:47 -0400
Subject: Re: mac80211 -- My log files are filling up with: "wlan0: RX
	non-WEP frame, but expected encryption"
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <a44ae5cd0804030615n3c3e906ey1db4513802bdf01@mail.gmail.com> (sfid-20080403_141559_906325_954376AC)
References: <a44ae5cd0804021732s6ae5ed81ma5e229ae0faf4aaf@mail.gmail.com>
	 <1207226756.3636.66.camel@johannes.berg>
	 <a44ae5cd0804030615n3c3e906ey1db4513802bdf01@mail.gmail.com>
	 (sfid-20080403_141559_906325_954376AC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mmW7w7DICOCIdwK5FFsE"
Date: Thu, 03 Apr 2008 15:19:37 +0200
Message-Id: <1207228777.3636.74.camel@johannes.berg> (sfid-20080403_141951_556326_865B0302)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mmW7w7DICOCIdwK5FFsE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I tried to build iw, but got an error:
>=20
> # make
>  CC   iw.o
> /bin/sh: cgcc: not found
> make[1]: *** [iw.o] Error 127
> make: *** [check] Error 2
>=20
> After poking around, I found
> http://ftp.idilis.ro/mirrors/ftp.kernel.org/pub/software/devel/sparse/new=
s.html
> which seems to be where I can find the tool.
> I compiled, and (after setting $HOME to /usr) installed it.
> Now, when I try to compile iw, I get:

Doh. I thought I hacked the makefile to not require cgcc. Will remove
that hack and just mandate that people run 'make check' instead of
'make' or 'make all'.


> iw.c:9:11: error: unable to open 'netlink/genl/genl.h'

You need to install libnl development headers, your distro should ship
libnl-dev (debian's package for example) or similar, or you need libnl
from source: http://people.suug.ch/~tgr/libnl/ At least version -pre8 is
required.

johannes

--=-mmW7w7DICOCIdwK5FFsE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/TZaKVg1VMiehFYAQIgbA/+NGdbMWa/sAnX3l6zQSwM8hgdlbeGYZ46
POL3cCFqBjZqdIqYUH7O+LChGafJBkqUVzoFdo8GPiuANMDxjjeiDuygZ2Z6ZlyU
cCNghXTlpUhj754q9pqMy22DnI9UXVHcnmiQvxZ9LS2Jffwjxd22W3LpXDTKoWlf
+c/x2CyAhG/5nCQ5IvaMioOuChOX86p8PL6nNMlHHAYHV1faF/Xz0npm0eGqJXWV
mKpYE2KYvM/NfelC6swaAK30zL1t+E74ni5NvW5UGS7flMtvUV2+NFM7325AJ4eb
hgjsrEjbf/osarDXjuZI8L4UpV9LHD6cNybjZ2b9zpvf4Ajc2kS+Lq5+4YI+Zi0u
QnrPCqH3Dl2OfGCoZ0gF+3zzrj3tgaSrEKkTm9lWQoSLRa2wr23OdGH770xF69Zu
kUO0l4fDSo066xVRjzvyUC+vnpX1jlk/AIXhXYzPv23HrPo8zKQ/ITfKAkd7QPbJ
eS8xTCr8KqW6OGp1uZN/CnGr9aPc+2SA9pC3bMZMen7TsyLY0toGuoeARQ3WF/Tq
zLZSubcwhhz+AX1lm+mOr4zV2ad+HaY0jLTzI4QOLgpTc9UmM6RVxyM4N5NO+We+
Q6UqJ2Zpf2Em0SCfgZExTvxZ/b7hCVbh6nbrxQhPos50kGctUQ5FhJuHQhUGl9o2
DsJJBFD8d/c=
=HNt4
-----END PGP SIGNATURE-----

--=-mmW7w7DICOCIdwK5FFsE--

