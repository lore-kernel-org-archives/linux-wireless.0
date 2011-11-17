Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from csmtp2.one.com ([91.198.169.22]:45448 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932198Ab1KQPkB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 10:40:01 -0500
Date: Thu, 17 Nov 2011 16:39:47 +0100
From: Daniel Kuehn <daniel@kuehn.se>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] Seeing as alot of ath9k devices is PCI/PCIe or their
 mini equivalent it makes sense to set ATH9K_PCI to y by default
Message-ID: <20111117163947.1749dfb1@Artemis> (sfid-20111117_164007_437323_BD3B5781)
In-Reply-To: <4EC524B1.2070200@openwrt.org>
References: <20111109235757.79821a20@Artemis>
	<4EC524B1.2070200@openwrt.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8AKf3r+1I_RuyP8x0Z79.y/"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/8AKf3r+1I_RuyP8x0Z79.y/
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Nov 2011 16:13:53 +0100
Gabor Juhos <juhosg@openwrt.org> wrote:

> 2011.11.09. 23:57 keltez=C3=A9ssel, Daniel Kuehn =C3=ADrta:
> > from: Daniel Kuehn <daniel@kuehn.se>
> >=20
> > Most ath9k devices are PCI/PCIe based, therefor making PCI/PCIe support
> > default y helps those porting a config from 2.6 kernel series
> > from getting "non-functional" wireless drivers with 3.x kernel series.
> >=20
> > Signed-off-by: Daniel Kuehn <daniel@kuehn.se>
>=20
> The option was enabled in the past but it has been removed a few months a=
go by
> the following commit:
>=20
> commit 64bd0821a3b66c3307d7a4ee5523e3e35ec2df0e
> Author: Tao Ma <boyu.mt@taobao.com>
> Date:   Wed May 25 09:44:05 2011 +0800
>=20
>     wireless: Default to 'n' for 2 new added devices in Kconfig.
>=20
>     We make oldconfig every time when a new kernel arrives, but
>     if we don't have such a device(I guess this is the most common
>     case for a new device), the default value should be 'n' so
>     that the kernel size we build doesn't grow up too much quickly.
>     For anyone who has the device, it is OK for them to turn it on
>     by themselves.
>=20
>     Cc: "John W. Linville" <linville@tuxdriver.com>
>     Cc: Johannes Berg <johannes@sipsolutions.net>
>     Signed-off-by: Tao Ma <boyu.mt@taobao.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
>=20
>=20
> In my opinion it should not be added again.

I agree with you there if it was removed before, maybe then only the help
section of ath9k should be changed to say that you have to enable either
PCI/PCIe or AHB support for it to work?

Because it doesn't seem to be possible to make it choose that option and st=
ill
make it removable IF ath9k is chosen.
It seems you either need to default it to y (with default y) or make it
unremovable if ath9k is selected (with select ATH9K_PCI for ATH9K).

>=20
> Regards,
> Gabor

Kind regards,
Daniel Kuehn

--Sig_/8AKf3r+1I_RuyP8x0Z79.y/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJOxSrJAAoJEOYWIJmjnr1S1lIQAJtx8VIT7hGSbc/Sur04vJ90
b9CV4CL5mkyGriVuLvfQvRVAjdEbR/d6wtI3cO2qou0CZnT6SJfvGqAg3nAgFdvU
q3tnF6ukmpL/BmzXsCmWc5wjeY/I6B+LPAoDE/NmAkV1GyxXPbJSeGgC68jwqdrk
spEMIohbRF1710OK+qAxPllbwXbG0XCIxWyIpAL7nFqJAU/cS8KjjTeBkbJL0Pz4
cmzDr/vOwCk10DvGYnMkuQ1RxFu4TC0v4SjXbhVFI1wQ7CPn7hRfV2m0yxFWWoxQ
+QEs8NrrmJvk1ip4JiEMPuYwn2c7DzdTLgIr/YIsG0OWeGnT3sF6JuNOHK1Q5Ddq
jyKLDm/aQY5BlFCDwnTF1GRAfRDQ9aEzdL6S5OWGLZaOtXP1eyh+L+Dcj9WGE/31
Iz9TaQHs8t9jK2naHeCZ1iSwaPoexdtfaYGB4morPNiKSWhcnQkY1nBtSwpM2D6+
XLv0oYL7uCYhUw0m+btCeOBjQo3A6JQ8hOCaF1lf+khGY5COtYYbadzVqvWllks/
6yVEWRrsf0IlSFd4G38j7aybUdrCCKEQwSAHn3+WFUb4wDa1VlwYGsx/oGUnvo4m
q0bmxvg1SSuwl5Lz2OvJ0Hh8sj+0VhhhuHMS5WctiLaQ/zwCHvuswgVz/ZS0gagA
c0lxz6gsCtsV80cFaoVe
=6MGN
-----END PGP SIGNATURE-----

--Sig_/8AKf3r+1I_RuyP8x0Z79.y/--
