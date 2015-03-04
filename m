Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:44459 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbbCDVBi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 16:01:38 -0500
Date: Thu, 5 Mar 2015 08:01:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Jim Davis <jim.epost@gmail.com>,
	linux-next <linux-next@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>, zajec5@gmail.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: randconfig build error with next-20150303, in
 drivers/bcma/driver_pcie2.c
Message-ID: <20150305080130.41b132ee@canb.auug.org.au> (sfid-20150304_220218_162317_8363D4CC)
In-Reply-To: <87d24o7s2j.fsf@kamboji.qca.qualcomm.com>
References: <CA+r1Zhio+Kp30y4DHS0SW20PjZrAY3PZLXjskykpa8CY0tcrMA@mail.gmail.com>
	<87d24o7s2j.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/tZzRD4dyQxyIGUsmw3FDJ2p"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/tZzRD4dyQxyIGUsmw3FDJ2p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

On Wed, 04 Mar 2015 16:31:00 +0200 Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Jim Davis <jim.epost@gmail.com> writes:
>=20
> > Building with the attached random configuration file,
> >
> > drivers/bcma/driver_pcie2.c: In function 'bcma_core_pcie2_up':
> > drivers/bcma/driver_pcie2.c:196:2: error: implicit declaration of
> > function 'pcie_set_readrq' [-Werror=3Dimplicit-function-declaration]
> >   err =3D pcie_set_readrq(dev, pcie2->reqsize);
> >   ^
>=20
> This should fix it:
>=20
> bcma: add missing includes
>=20
> https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.=
git/commit/?id=3D2264fc857decd45798368f46861d9aecac23546f

However, that commit is in next-20150304 and we still get the error
(see, for example,
http://kisskb.ellerman.id.au/kisskb/buildresult/12376688/).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/tZzRD4dyQxyIGUsmw3FDJ2p
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJU93KvAAoJEMDTa8Ir7ZwVzSgP/3EMAyofmCM9HmpsPrLbsXmx
JTPvqnfNYuszMCh05oX3KD8r/tyqtrn3HyqZRYULm9mzJMlU2kz4FCucfufkjmQK
TgPN9AROf8PpXtZwNSG2rKCkT7h/xju37GavfhOOdfEkZ5h+gEnvf8Yo4e+tOQkb
m0oTI8TVO+aPkjls4A7z9iJXVbVRxKBZ5ye2ndBUHuBrHRwiZkaMLqPx8r4hwmhP
APQYaX19F+LV6SaFiLhs2IYrOWIh4r0lPVKTxNNbpWBQEGzSdmoDhHuUk9Yt42k0
OnfYomjsPJFt5P/6V2TitOPwmx9JA9y6pVi4wPF60PYs+5ZemKkEKfbQkqIFXik4
FiocNj1QwicsnQgkJn27rGIGHog6oYGDn0+/WnpF2mfAJ4cOD1kjk/roUizsT2oq
tCboAd1CT0MfGYrgb8llt+os2eXMVyMjEvW/IzIyVtYdWipvJKN8V8B6dvj6BHhA
vswyfjkF4EenhA9WMr2o1IPyq9XGaM7frARq2G094HWzLaH1gxKPfw5k9RaMxOQk
l9YVJzCwPb0BZ5xoDBL07G7wj0BVmbPMAQ8EG5cHvGmvr4Z21NKTqkw2m70vX0F/
Qn50BTK376vIfwVd47wsglH6WHyBkXDfb6ApA/Jm181JBD+2Z/pF0gm5ZY51Os7d
uJ8K9YhngmnkJ957DlET
=zthJ
-----END PGP SIGNATURE-----

--Sig_/tZzRD4dyQxyIGUsmw3FDJ2p--
