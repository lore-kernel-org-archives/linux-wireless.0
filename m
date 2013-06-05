Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:60647
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751803Ab3FELNG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 07:13:06 -0400
Date: Wed, 5 Jun 2013 07:12:59 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: Kalle Valo <kvalo@adurom.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	linux-wireless@vger.kernel.org
Subject: Re: cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets
Message-ID: <20130605111258.GA15549@shaftnet.org> (sfid-20130605_131310_599794_3FA58D8B)
References: <20130604130955.GA13788@debian>
 <20130604134340.GA3813@shaftnet.org>
 <87d2s13rsm.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
In-Reply-To: <87d2s13rsm.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 05, 2013 at 11:06:33AM +0300, Kalle Valo wrote:
> > I'll try to robustify this rather ugly interface as much as possible. =
=20
>=20
> We have nl80211 testmode interface for just stuff like this. I recommend
> using that instead of debugfs.

When in the so-called etf_mode, the driver doesn't create a netdev.  It=20
doesn't probe the hardware; it doesn't even (automatically) load=20
firmware because it doesn't know what firmware to load.  The driver=20
becomes a (mostly very dumb) conduit for messages to/from userspace.

That userspace in turn is a thin daemon that listens on a TCP socket and=20
relays everything to/from a windows-only highly proprietary vendor tool. =
=20
Everything needed to initialize the hardware (even the dpll value), is=20
obtained via these messages.

There's no inherent reason why this daemon couldn't use nl80211 instead,=20
but IMO it's not worth the effort to rewrite the driver so it can bring=20
up a netdev that (cleanly) fails everything other than nl80211 testcmds. =
=20
After all, it'll still be an opaque binary interface whether it uses=20
nl80211, custom ioctls, or the existing debugfs interface.

If the existing debugfs interface is too ugly to stomach in the=20
mainline, we're better off just stripping it out and maintaining it as=20
an out-of-tree patch for the handful of users that need to use the=20
vendor tools -- In other words, folks bringing up new hardware designs=20
or obtaining FCC(etc) certification.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Delray Beach, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum viditur.

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRrx06PuLgii2759ARAg83AJ4yp+YliVb5n6Wgx5PZHhmPr8kmrgCfZBp/
ZYpwburuPnkyHqIyPmMOW+U=
=1ncT
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
