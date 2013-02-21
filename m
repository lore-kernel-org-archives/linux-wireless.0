Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173019pub.verizon.net ([206.46.173.19]:61218 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab3BUOqu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 09:46:50 -0500
Received: from odin.tremily.us ([unknown] [72.68.84.219])
 by vms173019.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0MIK00H7HOXQNYA0@vms173019.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Thu, 21 Feb 2013 07:46:39 -0600 (CST)
Date: Thu, 21 Feb 2013 08:46:38 -0500
From: "W. Trevor King" <wking@tremily.us>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: rev-17 Broadcom core support in b43 and CONFIG_B43_BCMA_EXTRA
Message-id: <20130221134637.GA24350@odin.tremily.us> (sfid-20130221_154700_598100_B56BC287)
References: <20130221121722.GA23690@odin.tremily.us>
 <51261C0B.1040506@hauke-m.de>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
In-reply-to: <51261C0B.1040506@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 21, 2013 at 02:07:23PM +0100, Hauke Mehrtens wrote:
> On 02/21/2013 01:17 PM, W. Trevor King wrote:
> > I've been poking around in b43 and brcmsmac trying to wrap my head=20
> > around device detection.  Obviously, b43 and brcmsmac both support=20
> > some devices, and since 4f3d09d (b43: add option to avoid
> > duplicating device support with brcmsmac, 2012-01-11) overlapping
> > devices have been masked behind CONFIG_B43_BCMA_EXTRA.  At the time
> > of that commit, brcmsmac didn't support the r17 cores, but support
> > has since been added in 6f80f01 (brcmsmac: add support for cores
> > with revision 17, 2012-12-07).  Does that mean that b43 should move
> > the r17 core entry into the masked-by-CONFIG_B43_BCMA_EXTRA block?
>=20
> Yes you could move that core id into the CONFIG_B43_BCMA_EXTRA block,
> but this core was just found on Router SoCs and there you mostly want
> to use AP mode, which brcmsmac does not support.

So maybe a CONFIG_BRCM_BCMA_EXTRA to mask brcmsmac devices when b43 is
the recommended module?

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRJiU7AAoJEEUbTsx0l5OM/DsP/inUmlhp6kxVltR85WSbS4ga
BTHjDmXvZ1IRPXKiEHrkuN4fsFdieD26OpVBkGyY/vujnb9irk724Yv/Qr1phIs2
gWAa456uhHsGZ7jvrltu5NffXcKAbNFKeGQKgJ6P2zQwdVWLRr5WoM1GLWaLtRh/
rLR5hW3kNzebfUgHMJ0d+L0jIbBs8UsHOC+exLChrDt+AB8WDMuD0xou4ntKTdQ7
Hkt9IVBtA9ZWYAgomfWrQLJYF1lqF8jVeN176jHzdwCYiQ6URUNSSpYCxYN8PvX8
hyZDw5Z4ArBJrWvwBQwUJkOGGpsKyv2ezFEVtv3Jw+zVsgILZl1nkvzWbfiiyq1Y
c4DsPN+7GxEBx1mByaZUUdnotUOdaGJqDZ9Q6qfCCSweOs6DL8Ua+eviuQo21icV
Ffs3+bUZNWIi4AvHXnLhqt9AEv/MgAXVTtMKF1+yfUoUbm9wJl+peMO4ak+8G/Bk
aPXwActgrnqIcLBhA46yKjsRbv813sw1IfdAneEARP5Y1PSPaud6hEQSXG0OMHfH
AbzuFY6Hj3tJ8jlJ+xYLC9rDylq2dwKEKqzZVzTE4Uq3xVt91CW3GQn1f9/NhHm0
S7pnObcZfOCuRu1GVFiUmxWGcSkPtjHLcIixjrnFITyucGBb/dS/6jmbJuEAxZ4I
Y8tu+R8YqlvywrAqXPOc
=7EBh
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
