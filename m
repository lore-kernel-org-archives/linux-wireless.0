Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55916 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbYDMHlo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2008 03:41:44 -0400
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas =?ISO-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Vladimir Koutny <vlado@ksp.sk>
In-Reply-To: <4800F76C.7000801@archlinux.org> (sfid-20080412_185459_927704_9BFD3D28)
References: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br>
	 <200804021932.26046.IvDoorn@gmail.com> <47FE8FAD.9020802@archlinux.org>
	 <200804121246.44236.IvDoorn@gmail.com>  <4800F76C.7000801@archlinux.org>
	 (sfid-20080412_185459_927704_9BFD3D28)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UaJxVFXebhK192yOQpSz"
Date: Sun, 13 Apr 2008 09:41:35 +0200
Message-Id: <1208072495.4111.10.camel@johannes.berg> (sfid-20080413_084148_084338_B7DE3981)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UaJxVFXebhK192yOQpSz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-04-12 at 19:54 +0200, Thomas B=C3=A4chler wrote:
> Ivo van Doorn schrieb:
> >> Bad news again:
> >>
> >> With 2.6.25-rc8, rt2500pci is fast. When I apply this patch:
> >> ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.25-rc8-=
git8.bz2
> >> on top of rc8, then it is slow again. I can't make sense of it, maybe=20
> >> you can.
> >=20
> > Not really, looking at that patchset neither rt2x00 or mac80211 had any=
 patches
> > that could influence packet flow.. :S
> >=20
> > Ivo
>=20
> I compiled half a dozen kernels and now figured it out. This is the=20
> patch that causes rt2500pci to be slow. If I revert it, it is fast again:
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dco=
mmitdiff;h=3Dd43c7b37ad787173d08683f05eadeea0398fefdf
>=20
> I'd love to see this fixed before 2.6.25 is released, as it's a=20
> regression compared to -rc8.

That's odd. But that patch looks a bit fishy now that I look at it, care
to try below change (manually, this isn't a patch)?

johannes

        bool use_protection =3D (erp_value & WLAN_ERP_USE_PROTECTION) !=3D =
0;
-       bool use_short_preamble =3D (erp_value & WLAN_ERP_BARKER_PREAMBLE) =
=3D=3D 0;
=EF=BB=BF=EF=BB=BF+       bool use_short_preamble =3D (erp_value & WLAN_ERP=
_BARKER_PREAMBLE) !=3D 0;
        DECLARE_MAC_BUF(mac);



--=-UaJxVFXebhK192yOQpSz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAG5LqVg1VMiehFYAQLeoxAAr2liXy2Le+5tHZRwcWWkKpFim4L7z6Rh
RnWJWJgpjaOW3f51jbE96hSELHqekS637qjhHQg5jbFRZed5oXSRxZwFq9NvVn2j
ZYRr2boYbzdyp/Hj73ahXn3QZsaYzQDTMbm9tcBB7LU1Rsr6/CDwJNr0SOQhSp1t
RghoKMoT4j/AKbGaQfdgl6toOcpXMU6CrWyW1zoX6kZ8KitSOT9djKWOcww20W+Y
eRlqYEesUOZch85kY1ClJDQKPQIk67+oTS4ey+U57HOJOVK6qZmoAoj5slhglWTR
12BQO5/58hTpsC24pGbnr+YYJ4g0V1qSNP6mfx1R2HZ0OcYxnEOCuxpLIkTyGEHf
kUfRDDMZjQxXQBn8H13KVukTGJF0bCz4giAdgz384lSJVe+VMCB4TRbr+Y4WzSsQ
ej4XQKs0x7REt5kg5wC0pGqZZbHioo3wdgCo/xU3fj9uVILzM/UgR0ZSsO5HsXnv
LwvEKOsWq7XW6x0iWUuPXp3YCviScUBIbc/ngt/1zQgz1Cue64Eu7ipfZg9fPdr/
m0AEgdHyhgRI3cjLuRtHIyjh6pQx7C+m1CKYqksrytdPeehZPDu7IVM8CBbMM5DY
hrRJ/V9KfsCkz5lbjpyjGg1zpLfQhD0PhPfy0NASVTDjWVS2wJ06pGLUG5IQD3qR
XufHIVAc0YU=
=Cjta
-----END PGP SIGNATURE-----

--=-UaJxVFXebhK192yOQpSz--

