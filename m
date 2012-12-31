Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:52542 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab2LaIqq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Dec 2012 03:46:46 -0500
Date: Mon, 31 Dec 2012 09:46:39 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	nbd@openwrt.org, jonbither@gmail.com, kgiori@qca.qualcomm.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [RFCv2] Add spectral scan support for Atheros AR92xx/AR93xx
Message-ID: <20121231084639.GB23038@pandem0nium> (sfid-20121231_094657_422674_8DDC5036)
References: <1354811768-4414-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <20121213140753.GA26868@pandem0nium>
 <50D04EC9.2040805@neratec.com>
 <CAJ-VmonRjawqBY+F_-in3sSTpen=KaW9FNrG=140q38NtFCJbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
In-Reply-To: <CAJ-VmonRjawqBY+F_-in3sSTpen=KaW9FNrG=140q38NtFCJbw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Adrian,

On Sun, Dec 30, 2012 at 09:33:06PM -0800, Adrian Chadd wrote:
> Hi,
>=20
> I'm just going through and hacking on this now for FreeBSD (and
> userland decoding, rather than kernel side decoding.)

Cool!

>=20
> Your frame length logic is OK for the short spectral scan reports, but
> not useful for the longer aggregate reports (short_rpt=3D0 IIRC.)

Yeah, I've always used short_rpt=3D1 AFAIR.=20
>=20
> Here there's >1 FFT report in a frame, _and_ it could be corrupted,
> _and_ it could be short.

That sounds like a lot of fun :P

>=20
> I'm just writing a userland library now to start parsing and
> correcting these. It's likely that I can use your logic for the short
> spectral reports, but I won't be able to use them for the longer
> aggregate reports. We'll need to find some other way to determine that
> they've been corrupted and just toss/correct as appropriate.
>=20
> Thanks for digging into this!

Before asking questions, I'll wait for your userland lib and see what
it does. I've seen some longer frames as well occasionally when starting
to play with spectral, but didn't care too much as I didn't know how to
handle it. Anyway, I prefer hiding the corrupt and messy part and only
pass "clean data" to userspace, at least with the Linux implementation.

If you have some code handling and/or correct these long dataframes, I'd
be happy to integrate it if possible.=20

Thanks!
	Simon

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDhUO8ACgkQrzg/fFk7axZyggCfZjtZCLeV46eCPpxgc5AXvHYB
Fy4An1FvaD+dTQEd3hSVVl9+p/31/3xK
=efBg
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--
