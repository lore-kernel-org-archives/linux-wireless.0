Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38273 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753181Ab1D3FEo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 01:04:44 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Cc: Wenceslao =?ISO-8859-1?Q?Gonz=E1lez-Vi=F1as?=
	<wens@fisica.unav.es>, 622842@bugs.debian.org,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20110429173944.10906p14p6bdid4w@webmail.unav.es>
References: <20110415070730.4178.6175.reportbug@calpurnia>
	 <20110415081334.GD1387@vostochny.stro.at>
	 <20110415161039.15535n2vg4igcykg@webmail.unav.es>
	 <20110429164822.62112d9at4vs5xa8@webmail.unav.es>
	 <1304088874.3105.57.camel@localhost>
	 <20110429173944.10906p14p6bdid4w@webmail.unav.es>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-rUVbvC7mhvdom5gMus0g"
Date: Sat, 30 Apr 2011 06:04:34 +0100
Message-ID: <1304139874.2833.29.camel@localhost> (sfid-20110430_070448_306192_AF638DB1)
Mime-Version: 1.0
Subject: brcm80211 not setting correct country code?
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rUVbvC7mhvdom5gMus0g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Wenceslao Gonz=C3=A1lez-Vi=C3=B1as wrote:
[...]
> [  330.205983] brcm80211: module is from the staging directory, the quali=
ty is unknown, you have been warned.
> [  330.212186] brcm80211 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -=
> IRQ 17
> [  330.212195] brcm80211 0000:03:00.0: setting latency timer to 64
> [  330.268237] Found chip type AI (0x13814313)
> [  330.271328] Changing max_res_mask to 0xffff
> [  330.271330] Changing min_res_mask to 0x200d
> [  330.277446] Applying 4313 WARs
> [  330.278330] wlc_bmac_attach:: deviceid 0x4727 nbands 1 board 0x51a mac=
addr: 88:25:2c:4e:9e:34
> [  330.283578] ieee80211 phy1: Selected rate control algorithm 'minstrel_=
ht'
> [  330.285363] wl_set_hint: Sending country code US to MAC80211
> [  330.285371] wl0: Broadcom BCM43xx 802.11 MAC80211 Driver (1.82.8.0) (C=
ompiled at 04:19:31 on Apr  7 2011)
> [  330.365121] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> ----------------------
>=20
> By the way, before I used 'modprobe cfg80211 ieee80211_regdom=3DEU' . =
=20
> Perhaps the problem comes from that and line (dmesg) 330.285363 ?  I =20
> need channel 13 ...
[...]

I asked where the device was purchased:

> In Spain (PC - City company). It is a Dell Inspiron M101z (service tag =
=20
> CHL0SM1) . BTW, in Windows 7, it worked perfectly. But I removed it =20
> installing Debian Wheezy.
[...]

I looked at the driver source code and there is certainly an attempt to
use a country code from NVRAM.  But maybe it hasn't actually been read
from NVRAM at the point this is done.  'US' seems to be the default if
the country code is blank.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-rUVbvC7mhvdom5gMus0g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATbuYXOe/yOyVhhEJAQqQyg/+LZmL4vgvI7SxgWAHQUE6eIxr+E/acdf+
c4bipbJn/+liOmFrkZJt258Mg3F2JKkapZZOvzfzZWUtBUm1oAUJorkDzENIF8BH
BMDBgX44mpGKHUaselrB0fECL+Ptu7Uk5SQUaFTmd7s/L3NyApUsW2PntZVkQ9sE
8qh7G8lLiiZa/GhcjM+zyQyXi8lGrHd+LjzQkAktpg90Zd0Am4UCRCsLq755eefy
KjxOBKgBlFY2nOcuHqFTRKOww+S+RSFb1V/QwQvAQ/E0Lz+I0oqAVi0PfykYDDpE
CP54lcTtxnAAxRW0MbuiPyyH90IR9Pt2/Q804wxpD4zwML4wazOxcvnbaY5C/Cq2
sJwFkK7NZtUrlqloamt9jtueiYQqYhEd5SiRWmRTHIII4jNVV8e/3PQnUaHi0pPb
ljaTg7z3w/pmzhOWfrnDAG8/x3xD01BR2QRenSSM6VIx5kj4MnlOxM2E0toh9mFs
FLqIDQwgVAsSBrEPixPKLpUHiTdZySwrF0JLOYwSM9Ukg3LEVoo2BOHNZQ5mGV4k
1p0Hdqbxe/kjxN0hJ++069Uvpjxtu/4HzEOYmEZykErNvo+/rH1IXQ2UE1b+FBgE
pN8LEqe/7JOuyHW2wvjFH/mKjK5rA6nIzCSUHek38qApXWGh+FcZO0/Gsh9Kvpyv
82x4ddVbeYc=
=Cn9x
-----END PGP SIGNATURE-----

--=-rUVbvC7mhvdom5gMus0g--
