Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.108.102.1]:44584 "EHLO parez.praha12.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbZLUP2n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 10:28:43 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH 4/5] ath5k: Reimplement clock rate to usec  conversion
Date: Mon, 21 Dec 2009 16:28:35 +0100
Cc: =?utf-8?q?=E6=B5=B7=E8=97=BB=E6=95=AC=E4=B9=8B?=
	<tkaiso@thinktube.com>, johannes@sipsolutions.net,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
References: <1260899813-17585-1-git-send-email-8an@praha12.net> <200912211340.51229.8an@praha12.net> <b6c5339f0912210708wa538055s74a7054eef0e77b6@mail.gmail.com>
In-Reply-To: <b6c5339f0912210708wa538055s74a7054eef0e77b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1301682.1xmrgCyQrj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200912211628.39169.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1301682.1xmrgCyQrj
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 21.12.2009 16:08 Bob Copeland wrote:
> I reviewed the patch, looks fine to me. =C2=A0The ATH hal uses a lookup
> table to keep it inline but I don't think we have a convenient
> index available to do the same.
Yes, HAL uses a lookup table for mode -> clocks coversion, but before that =
can=20
be used it has to convert channel flags to mode, and that's a sequence of i=
fs=20
too (see function ath_hal_chan2wmode).

If performance mattered, we could store the mode index somwhere. But it=20
doesn't, the conversion is only needed when setting ACK timeout and slot=20
time - which is, for most users, never done and defaults from initvals.c ar=
e=20
used instead.

Lukas Turek

--nextPart1301682.1xmrgCyQrj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLL5QnAAoJEEBjvk/UOfYw8mcQALoZt2YYsJvbgqMid6nTvJwC
Z3kDjHzqnOtkG580ZRVZMmLHIEAUpyfPPuA5gPlN5S95Up+MXBKWMHRqekcgBCHu
SMVjKoDhu7XwbOwv/bWUa2lqocfemCehV38no1TJEpwY4QE5wKoq6do4qI6Z1Hvp
tmW5DB+C8kQc9oaJS6d7gIBno5dp3nqgFPF8qULCBBgftybFDD0s0AKBFG3SbLc7
yu0dkuewFdtWK+7tU3vnzmEwCwr/iFM4K5NxbNbJjiB1wykKZqQ/An31t+UTjs1v
RY9wCkZbnfJPpN/nWiIC4TCa5Kq6tw42LJyDlEbCyj2oM2uBHlzk9LZHKL/bCa0V
UMvTFQ9XBcuJ/aBwbM6w/UKru+FiUOcUWqAKf0S4OLiF/E4zN5RJOGXw23pSx687
u4B6JiMqH11xiSvvIqz/cUhohkjg2AEXuw5IW6xM4HZUaUkfhjSEY7vdUDWuMDFX
v3VoxOCsy/LT3MccRhjVl/OQpfBzwnvpvxl/mn0kvNNMDRYAUHYYn5ZBupk+zuNn
+FE7Vbx/1JuT0m377ZBs5Iy930MTFvvngAKlAJ6fienRdcBLrHBxHGOcPb28ebhG
NeKhlN7zwNY9+Q9Ce03oiqWvd5GgiFXcP19wn8blhy4tlZpB12+a/p1O53W4eZce
In4mC6HJ/3pXpJcFve9s
=Fn9H
-----END PGP SIGNATURE-----

--nextPart1301682.1xmrgCyQrj--
