Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:40584
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754300Ab3FDNnp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 09:43:45 -0400
Date: Tue, 4 Jun 2013 09:43:41 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets
Message-ID: <20130604134340.GA3813@shaftnet.org> (sfid-20130604_154402_723210_D714CC3B)
References: <20130604130955.GA13788@debian>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
In-Reply-To: <20130604130955.GA13788@debian>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 04, 2013 at 06:09:55AM -0700, Dan Carpenter wrote:
> The patch a910e4a94f69: "cw1200: add driver for the ST-E CW1100 &
> CW1200 WLAN chipsets" from May 24, 2013, has poor input validation
> so the user could write to arbitrary memory.

> Also I think this API looks like things which should be done with
> normal ioctls.  This driver only lets you load the firmware using a
> very ugly custom debugfs interface?

No, this is a debugging interface designed to interact with the=20
vendor-supplied testing tool and the passthrough API it requires.  The=20
vendor tool controls the device init sequence, including special=20
engineering firmware.

Support for the ETF hooks is optional, and even if compiled in has to be=20
explicitly enabled with a module parameter.

> drivers/net/wireless/cw1200/debug.c
>    454 =20
>    455          if (!count)
>    456                  goto done;
>    457 =20
>    458          if (copy_from_user(etf->buf + etf->written, user_buf + wr=
itten,
>    459                             count)) {
>=20
> "count" isn't capped so we could overwrite etf->written on the first
> write and then write to arbitrary memery on the second write.

Okay, that's easy enough to fix.  Thanks for pointing this out.

I'll try to robustify this rather ugly interface as much as possible. =20

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Delray Beach, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum viditur.

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRre8MPuLgii2759ARAjGaAKDY+wlBtk51HrS3tFlymBBA5fv4CACgy2Jr
Qs78mzju6e0WHGmnuHC28Z0=
=zQTF
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
