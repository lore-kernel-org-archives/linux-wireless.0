Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from flock1.newmail.ru ([82.204.219.207]:41346 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750904AbYJIQAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 12:00:30 -0400
From: Andrey Borzenkov <arvidjaar@newmail.ru>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: rc9 + orinoco WPA patchset: BUG: scheduling while atomic loading firmware with PCMCIA adapter
Date: Thu, 9 Oct 2008 19:59:53 +0400
Cc: orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, linux-pcmcia@lists.infradead.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200810091722.56812.arvidjaar@newmail.ru> <20081009133125.GW25780@parisc-linux.org>
In-Reply-To: <20081009133125.GW25780@parisc-linux.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart38241674.49egKP3mVG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200810091959.54987.arvidjaar@newmail.ru> (sfid-20081009_180038_324192_90516EF6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart38241674.49egKP3mVG
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 09 October 2008, Matthew Wilcox wrote:
>=20
> On Thu, Oct 09, 2008 at 05:22:55PM +0400, Andrey Borzenkov wrote:
> > After loading orinoco and "inserting" adapter I get either BUG with
> > endless loop (attached) or kernel panic on NULL pointer dereference
> > (was not able capture). Adapter works fine with wlags49 driver.
>=20
> It looks like you've fallen off the bottom of the kernel stack.  Do you
> have 4k stacks enabled in your config?
>=20

You are right. Using 8K stacks load and runs fine. Hmm ... not nice
from it :p

--nextPart38241674.49egKP3mVG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjuKnoACgkQR6LMutpd94zyZwCgjue5AtOk7/Yk+zjWvjTk27ef
z6wAn2OsgNDzMS2SfmRgpy6ASBzjEexZ
=HPpY
-----END PGP SIGNATURE-----

--nextPart38241674.49egKP3mVG--
