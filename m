Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:59769 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607AbZLFUXI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 15:23:08 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 4/4] ath5k: Implement mac80211 callback set_coverage
Date: Sun, 6 Dec 2009 21:23:12 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org
References: <200912061820.26320.8an@praha12.net> <200912062000.26851.8an@praha12.net> <4B1C041A.3090708@openwrt.org>
In-Reply-To: <4B1C041A.3090708@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1371542.qHY93zc3G5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200912062123.13098.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1371542.qHY93zc3G5
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 6.12.2009 20:20 Felix Fietkau wrote:
> In 2.4 GHz, regular slot time is 20 usec, unless short slot is enabled.
> 2.4 GHz with short slot and 5 GHz both use 9 usec.
Yes, but where the short slot time gets enabled? According to the standard=
=20
(don't have the reference now) all stations in 802.11g network should switc=
h=20
to 20 usec slot time when 802.11b-only station connects. But I can't find=20
this anywhere in the driver, the only write to AR5K_DCU_GBL_IFS_SLOT is in=
=20
initvals.c - it seems it's not implemented yet.

After some more digging I found that the function ath5k_hw_clocktoh is wron=
g,=20
there are more possible clock rates than 40 and 80, this is in FreeBSD=20
driver:
                                     /* 11a Turbo  11b  11g  108g */
static const uint8_t CLOCK_RATE[]  =3D { 40,  80,   22,  44,   88  };

Now the values in initvals.c finally make sense:

	a/XR	aTurbo	b	g (DYN)	gTurbo
hex	0x168	0x1e0	0x1b8	0x18c	0x1e0
clocks	360	480	440	396	480
usec	9	6	20	9	6

Unfortunately I still don't know how to calculate the ACK timeout for=20
different slot time than 9. The formula in athctrl is
  2 * slot_time + 3
and I don't know where the '3' comes from. Any ideas?

Lukas Turek

--nextPart1371542.qHY93zc3G5
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLHBKxAAoJEEBjvk/UOfYwpj0P/1bbeNuuFLG88HsexOYCl6i5
ibBVOTBbUfFBbpmyOdOGkMeEijf3zz293e6632k94fbCqzi3opvkoH58Dx3Ua35R
vakMlvGzGfJbA4MAcZ3X8iuf8aGO3Kra0r/bE2s5aPiC0tgLWhZB39RnYWhMOVVZ
r889MwxPj6nO1VouXD3fFNoYe0unJITyEXMugoMj2o54OxxuKPR4CBIJuBKJHSUP
Qk9vUM/bRcIYKv/gGfGK1MvFXbRjFiIv89OfIi1G1R2nwkCxT2NCLd04qXI2xFua
iGIZR1+HxAMd5MCsUPtU0z3gTPbceWb/ujCvxqVmWmT0hjQGSJU1E6a2XXEjmFDg
Vxk0Kal4V3OAA8AsyBr/RDHFKZWUN+osvfXAV/Yhzt+ixMh+C/tiTLxH+BAsQrsG
RwavxCNxdX9qpDMTtgHxz7HrA8jse/XuxoFtSLVrQ8lJm0ud8oS5sd11VIL2m32o
LFtX+7DtQczP3JGcdvSHSp7pwbZqzwtSaYcPjhVRlfqgJRKlTuv2YHFGl5f+RqZY
Gl3FEADNujYeQhsT17stSPDEre3unIAIXkYeF9rcrIOe7ReCPbWnPnT/u9gGp9vf
ErlMIEO1Y6+WWuUTKcnGmbx3hJY/cWPGbagn81Zd1UYUmCalm0F4ZFF8hfTVpc8j
GSnPTwo9+oHIwp/dNav3
=jvYD
-----END PGP SIGNATURE-----

--nextPart1371542.qHY93zc3G5--
