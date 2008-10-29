Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx39.mail.ru ([194.67.23.35]:59932 "EHLO mx39.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbYJ2PTc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 11:19:32 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.28-rc2: new PCMCIA device instance after resume - orinoco can't download firmware
Date: Wed, 29 Oct 2008 18:19:16 +0300
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-wireless@vger.kernel.org, linux-pcmcia@lists.infradead.org,
	orinoco-devel@lists.sourceforge.net
References: <200810282219.51492.arvidjaar@mail.ru> <200810290643.54707.arvidjaar@mail.ru> <200810291318.05373.rjw@sisk.pl>
In-Reply-To: <200810291318.05373.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2835088.z0b08dBglv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200810291819.20848.arvidjaar@mail.ru> (sfid-20081029_161936_782813_C333C7E7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2835088.z0b08dBglv
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 29 October 2008, Rafael J. Wysocki wrote:
>=20
> > Do you have any idea what could it be? Original message is here:
> > http://marc.info/?l=3Dlinux-wireless&m=3D122522165719760&w=3D2
>=20
> This probably is a result of the fact that we don't include firmware blobs
> into modular drivers any more.  Please try to compile your driver directly
> into the kernel and enable CONFIG_FIRMWARE_IN_KERNEL.
>=20
> If this helps, we'll know what the problem is.
>=20

Ehh ... you miss the point. The problem is NOT missing firmware (I have
already been running with external firmware just fine in 2.6.27). The
problem is that during resume instead of simply resume *existing*
device/driver instance PCMCIA suddenly decides to re-discover the *same*
device yet another again.

This is not supposed to happen. I do not see any changes in
drivers/pcmcia that could be responsible for it - so I suspect there could
be some overall power management changes.

And personally I'd rather turned on debugging options; bisecting will
take ages here. I need some advice which options to turn on.

--nextPart2835088.z0b08dBglv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkIfvUACgkQR6LMutpd94yBdgCfSdwmDsbFgjyoj3TNsy/jTEnJ
MNoAnAsqNfNVzC5D6UcqTuqROmMwHj7+
=6pNb
-----END PGP SIGNATURE-----

--nextPart2835088.z0b08dBglv--
