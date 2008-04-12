Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:48425 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755630AbYDLRyy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Apr 2008 13:54:54 -0400
Received: from ironport-out-2.rz.rwth-aachen.de ([134.130.3.59])
 by mta-2.ms.rz.RWTH-Aachen.de
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JZ8008YZ4FH6680@mta-2.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Sat, 12 Apr 2008 19:54:53 +0200 (CEST)
Date: Sat, 12 Apr 2008 19:54:52 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
In-reply-to: <200804121246.44236.IvDoorn@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Message-id: <4800F76C.7000801@archlinux.org> (sfid-20080412_185459_927704_9BFD3D28)
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enigAE95A969D8BEA4D93C63DD9C
References: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br>
 <200804021932.26046.IvDoorn@gmail.com> <47FE8FAD.9020802@archlinux.org>
 <200804121246.44236.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAE95A969D8BEA4D93C63DD9C
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Ivo van Doorn schrieb:
>> Bad news again:
>>
>> With 2.6.25-rc8, rt2500pci is fast. When I apply this patch:
>> ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.25-rc8-=
git8.bz2
>> on top of rc8, then it is slow again. I can't make sense of it, maybe =

>> you can.
>=20
> Not really, looking at that patchset neither rt2x00 or mac80211 had any=
 patches
> that could influence packet flow.. :S
>=20
> Ivo

I compiled half a dozen kernels and now figured it out. This is the=20
patch that causes rt2500pci to be slow. If I revert it, it is fast again:=

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dco=
mmitdiff;h=3Dd43c7b37ad787173d08683f05eadeea0398fefdf

I'd love to see this fixed before 2.6.25 is released, as it's a=20
regression compared to -rc8.


--------------enigAE95A969D8BEA4D93C63DD9C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEAREIAAYFAkgA92wACgkQEda5KzHP/VBrggCgkWOgzjA057oFnq6kHgbOeckb
6PwAoM4ofCnRCnp/cKfNpYrvJgM2hr9h
=f2Eq
-----END PGP SIGNATURE-----

--------------enigAE95A969D8BEA4D93C63DD9C--
