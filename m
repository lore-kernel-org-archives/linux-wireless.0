Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:51462 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932468AbeFKUr1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Jun 2018 16:47:27 -0400
Date: Mon, 11 Jun 2018 22:46:34 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Wirz <spam@lukas-wirz.de>
Cc: b43-dev@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: b43 crashes on rmmod (bcm4331)
Message-ID: <20180611224634.28ccd288@wiggum> (sfid-20180611_224730_557419_06A64F55)
In-Reply-To: <e72be8db-77ba-408c-c5e5-351d722e09e8@lukas-wirz.de>
References: <75e4b424-4c75-5abd-1ef0-c2537d329b10@lukas-wirz.de>
        <d9896c10-87bb-8362-f302-8b1888c3421c@lukas-wirz.de>
        <20180609171159.59b5209c@wiggum>
        <6a78c68e-1062-5ad8-876c-f7d4c49ea492@lukas-wirz.de>
        <20180609220130.3ceb834f@wiggum>
        <e72be8db-77ba-408c-c5e5-351d722e09e8@lukas-wirz.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/ub0oWLgzP3cgDyb/AmsiE90"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/ub0oWLgzP3cgDyb/AmsiE90
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Jun 2018 23:09:06 +0300
Wirz <spam@lukas-wirz.de> wrote:

> the bisection leads to
>=20
> 142a27f0a731ddcf467546960a5585970ca98e21 is the first bad commit
> commit 142a27f0a731ddcf467546960a5585970ca98e21
> Author: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
> Date:   Fri Oct 27 22:34:04 2017 +0530
>=20
>     hwrng: core - Reset user selected rng by writing "" to rng_current
>=20
>     User is able to select a chosen rng by writing its name to rng_current
>     but there is no way to reset it without unbinding the rng. Let user
>     write "" to rng_current and delesect the chosen rng.
>=20
>     Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
>     reviewed-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>=20
> :040000 040000 f61e5cc501c99fb09bae5f203528b9f4c3479f8a
> 785262813cfb02c9606fd72274f0f7b44f2289d7 M	drivers


Thanks a lot for bisecting this.

This commit introduces a bug, if b43 is the only RNG in the system. But
that is unlikely on modern systems and it's fixed by
0e4b52942b1c76f89e0dcb829f72e123d0678f54, which is in 4.16.

Other than that I currently can't see why this crashes.

But the crash should go away, if you disable CONFIG_B43_HWRNG.
That's not a solution, but it may help, if you would like to get rid of
the crashes.
Could you please verify whether disabling CONFIG_B43_HWRNG avoids the
crash, just to make sure we are not after a red herring here?

Thanks.

--=20
Michael

--Sig_/ub0oWLgzP3cgDyb/AmsiE90
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlse36oACgkQ9TK+HZCN
iw4d7A/+PkESdIS6FwNL0LXgbZBCMyuID1ZtlycAcEaM2GTiLIHmtwlZi4HMen9f
5QRAtaMex6dvb3oMFFuPPw09ZNtFGyS7ebF/JQFTWQd1FYh52uZxkQVFhiHcC2xw
4o+K9BntgfFXx0o8B++7dNziCarH47puJagk1veHZ0IXRc0uYbBr4jh64/ndtlgx
GJEC6Hu5vl1tTLK0jELI9LxTuIV88dxWXGo1glIWrwmKU9C4eAhyCxM7mpcnSvNn
sKuaiR+gTBDs0Xppz7CaFCKSUuCVQngWM6akGl51xx0NAql2tPQfdPEvWatKzqyO
GanmLwGk3K75MRVWikSEY+hSH1kzBCO98Ar3K4LExlFx3gNAxobS9BefZjqhmtcj
+GeINa2IsSCwSy74HKaP1iuyP3VSrTgtzFq47zl+e/iifTJq2w4Mg7/MZ2/PXm3r
wlsZNkrGzISk5a7VHpHiMxdbyjtaIJGkcGBBZHKO44Cj7K9iV+0c7/NOYwKW950g
pPHMpMukVSRqhsHM7ZfH1PqxY4+LPsO9dnMlVC7TQSdgrhyn1eKp7cO7nkdqFET9
SSm3LKqF52gRt9frvlNdyyohNon8JtDjzWQzW664VPQKN5wDGMKDSxwGYoLBLFsr
Sb4b9Nfa8YIG9OEP5JP0ZKFv2sxdZGgWbwbfDkh440e1H8uyAhU=
=ssEF
-----END PGP SIGNATURE-----

--Sig_/ub0oWLgzP3cgDyb/AmsiE90--
