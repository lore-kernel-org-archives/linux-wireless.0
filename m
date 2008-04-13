Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:33081 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753605AbYDMIcD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2008 04:32:03 -0400
Received: from ironport-out-2.rz.rwth-aachen.de ([134.130.3.59])
 by mta-1.ms.rz.RWTH-Aachen.de
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JZ9005P091C2BC0@mta-1.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Sun, 13 Apr 2008 10:32:00 +0200 (CEST)
Date: Sun, 13 Apr 2008 10:31:59 +0200
From: =?UTF-8?B?VGhvbWFzIELDpGNobGVy?= <thomas@archlinux.org>
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
In-reply-to: <1208074049.4111.18.camel@johannes.berg>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?UTF-8?B?VGhvbWFzIELDpGNobGVy?= <thomas@archlinux.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Vladimir Koutny <vlado@ksp.sk>
Message-id: <4801C4FF.5060606@archlinux.org> (sfid-20080413_093212_722704_BD0F2438)
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enigCA4319B262AB72E5671FD8F0
References: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br>
 <200804021932.26046.IvDoorn@gmail.com> <47FE8FAD.9020802@archlinux.org>
 <200804121246.44236.IvDoorn@gmail.com> <4800F76C.7000801@archlinux.org>
 <1208072495.4111.10.camel@johannes.berg>
 <1208074049.4111.18.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCA4319B262AB72E5671FD8F0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Johannes Berg schrieb:
>>> I compiled half a dozen kernels and now figured it out. This is the=20
>>> patch that causes rt2500pci to be slow. If I revert it, it is fast ag=
ain:
>>> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commitdiff;h=3Dd43c7b37ad787173d08683f05eadeea0398fefdf
>=20
>> That's odd. But that patch looks a bit fishy now that I look at it, ca=
re
>> to try below change (manually, this isn't a patch)?
>>
>> johannes
>>
>>         bool use_protection =3D (erp_value & WLAN_ERP_USE_PROTECTION) =
!=3D 0;
>> -       bool use_short_preamble =3D (erp_value & WLAN_ERP_BARKER_PREAM=
BLE) =3D=3D 0;
>> =EF=BB=BF=EF=BB=BF+       bool use_short_preamble =3D (erp_value & WLA=
N_ERP_BARKER_PREAMBLE) !=3D 0;
>>         DECLARE_MAC_BUF(mac);
>=20
> No, wait, I'm confused, the original patch is correct. As far as I can
> tell, the code there is correct. The bug in that code was actually
> introduced by me based on the wrong thinking I just did again.

I figured as much from the original commit message. So rt2500pci works=20
properly when the use_short_preamble has the wrong value, and breaks=20
when it has the right one.
By the way, 2.6.25-rc8 was the first time that rt2500pci was ever fast=20
enough to be usable at all for me, so the bug you introduced seemed to=20
be the fix for my speed problems (which is odd). My guess is that=20
rt2500pci treats use_short_preamble wrong.


--------------enigCA4319B262AB72E5671FD8F0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEAREIAAYFAkgBxP8ACgkQEda5KzHP/VBmEACggIeHQqoQ+4eQOHMuNx4lRKqM
vYYAniLr0TIGGEDQPFh/Eb+2iG9RJKU3
=GGxl
-----END PGP SIGNATURE-----

--------------enigCA4319B262AB72E5671FD8F0--
