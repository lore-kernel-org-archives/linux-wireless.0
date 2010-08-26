Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49363 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208Ab0HZDh5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 23:37:57 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Colin McCabe <cmccabe@alumni.cmu.edu>
Cc: Dan Carpenter <error27@gmail.com>,
	Mike Frysinger <vapier.adi@gmail.com>,
	libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <AANLkTikL8KUyaCsSy8yu0brUde5cGCRnfc74Ufs47jga@mail.gmail.com>
References: <20100824120743.GG29330@bicker>
	 <1282652121.2968.9.camel@localhost>
	 <AANLkTikL8KUyaCsSy8yu0brUde5cGCRnfc74Ufs47jga@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+hzUrnF623iOu1MFLGFe"
Date: Thu, 26 Aug 2010 04:37:37 +0100
Message-ID: <1282793857.22839.233.camel@localhost>
Mime-Version: 1.0
Subject: Re: [rfc patch] libertas: fix if_spi_prog_helper_firmware()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+hzUrnF623iOu1MFLGFe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-08-25 at 20:26 -0700, Colin McCabe wrote:
> On Tue, Aug 24, 2010 at 5:15 AM, Ben Hutchings <ben@decadent.org.uk> wrot=
e:
> > On Tue, 2010-08-24 at 14:07 +0200, Dan Carpenter wrote:
> >> The indenting is not correct here.  I don't have this hardware and I'm
> >> just guessing as to what was intended.  I think that if there is an
> >> error we should return an error code, but if there isn't an error we
> >> should return success directly without releasing the firmware.
> > [...]
> >
> > The driver doesn't use or refer to the firmware image once it's copied
> > into device RAM, so this just leaks the firmware.
> >
> > The driver *should* keep a reference so it can restore the firmware
> > after suspend/resume without filesystem access (which is likely to
> > deadlock).
>=20
> Well, if all you want to do is put the device into "deep sleep" mode,
> you will not need a firmware reload after waking it up.
[...]

I was thinking of system suspend/resume, which could remove all power
from the device.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-+hzUrnF623iOu1MFLGFe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATHXhgOe/yOyVhhEJAQJPgRAA1pJDZuimszaCM964jmuuk3eoKoxEvhn1
MqOAAsxG+L7YruyFDyqZr6XWCuKuXcj1GZsaBTxEACtoWSMFwpteukWu8HHcIA1E
8L3K0iWrxAG++HmXG7PI6R8KgO0SgqzHqOkEag6TVCWcLORcl3i4CHUAv6qWdbO5
v1w4m1xXxV8b52iga/EgEiXkTfb6exZq2dAcK4ogpLA5+dleeDLpZgsr55JeNRO0
0uRrmgKIy/jy2nR4KHYY4xLlO3nOeZcc9ZhV8iTJ4Z1T5VkwIiVUO+Oga3oA+Nxc
5Jz0gK20NsB2f+oP8r8KATwkj9eA6VHtjufFYJAPMPaig2Gr/zlvH0YmHdte+VPO
2TCl9E5vkx+ER4YCDkG1mj3fk37kR5rKScN7npPnIqguEx4B3RW7zfOxtIPeKBIm
2wD7UCSWYdV2t5S2JaCnvrzlsyCu65Dgt2NrRKhz2hL9LdGHE+srCEdQMKOnPahP
EI2lrVDX7pEp5vt6Mdqy6JosmuaFtItrAwGufcbPw6bntyV8BQHf/zRvcVx9TZdR
hB8kIKxU4V97V82nfC3/2sRJJKl+oZgHi8Str8TMEFPOBoPw+6nAUNr61tsHatl7
jn/tFEIYDotCUYTMbWb1YkUxQwNLmswmGUOSehtm+e8V9j9mtbrI21jLc09kwOYx
9y90Qh40cB0=
=KrU/
-----END PGP SIGNATURE-----

--=-+hzUrnF623iOu1MFLGFe--
