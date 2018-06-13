Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:53471 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754462AbeFMJZu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 05:25:50 -0400
Subject: Re: b43 crashes on rmmod (bcm4331)
To: =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>
Cc: b43-dev@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <75e4b424-4c75-5abd-1ef0-c2537d329b10@lukas-wirz.de>
 <d9896c10-87bb-8362-f302-8b1888c3421c@lukas-wirz.de>
 <20180609171159.59b5209c@wiggum>
 <6a78c68e-1062-5ad8-876c-f7d4c49ea492@lukas-wirz.de>
 <20180609220130.3ceb834f@wiggum>
 <e72be8db-77ba-408c-c5e5-351d722e09e8@lukas-wirz.de>
 <20180611224634.28ccd288@wiggum>
From: Wirz <spam@lukas-wirz.de>
Message-ID: <7d564b8b-2b71-73f6-3ae7-ede0187a4151@lukas-wirz.de> (sfid-20180613_112554_619283_018CB33B)
Date: Wed, 13 Jun 2018 12:25:16 +0300
MIME-Version: 1.0
In-Reply-To: <20180611224634.28ccd288@wiggum>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="626Bw3exMVx6buUZUV9SZNWmOzjQ26BKt"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--626Bw3exMVx6buUZUV9SZNWmOzjQ26BKt
Content-Type: multipart/mixed; boundary="mPVJdAh4BWeSzqTj3L7BK1Vk72MexYB17";
 protected-headers="v1"
From: Wirz <spam@lukas-wirz.de>
To: =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>
Cc: b43-dev@lists.infradead.org,
 linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <7d564b8b-2b71-73f6-3ae7-ede0187a4151@lukas-wirz.de>
Subject: Re: b43 crashes on rmmod (bcm4331)
References: <75e4b424-4c75-5abd-1ef0-c2537d329b10@lukas-wirz.de>
 <d9896c10-87bb-8362-f302-8b1888c3421c@lukas-wirz.de>
 <20180609171159.59b5209c@wiggum>
 <6a78c68e-1062-5ad8-876c-f7d4c49ea492@lukas-wirz.de>
 <20180609220130.3ceb834f@wiggum>
 <e72be8db-77ba-408c-c5e5-351d722e09e8@lukas-wirz.de>
 <20180611224634.28ccd288@wiggum>
In-Reply-To: <20180611224634.28ccd288@wiggum>

--mPVJdAh4BWeSzqTj3L7BK1Vk72MexYB17
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

On 11/06/18 23:46, Michael B=C3=BCsch wrote:
> On Mon, 11 Jun 2018 23:09:06 +0300
> Wirz <spam@lukas-wirz.de> wrote:
>=20
>> the bisection leads to
>>
>> 142a27f0a731ddcf467546960a5585970ca98e21 is the first bad commit
>> commit 142a27f0a731ddcf467546960a5585970ca98e21
>> Author: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
>> Date:   Fri Oct 27 22:34:04 2017 +0530
>>
>>     hwrng: core - Reset user selected rng by writing "" to rng_current=

>>
>>     User is able to select a chosen rng by writing its name to rng_cur=
rent
>>     but there is no way to reset it without unbinding the rng. Let use=
r
>>     write "" to rng_current and delesect the chosen rng.
>>
>>     Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.=
com>
>>     reviewed-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
>>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>>
>> :040000 040000 f61e5cc501c99fb09bae5f203528b9f4c3479f8a
>> 785262813cfb02c9606fd72274f0f7b44f2289d7 M	drivers
>=20
>=20
> Thanks a lot for bisecting this.
>=20
> This commit introduces a bug, if b43 is the only RNG in the system. But=

> that is unlikely on modern systems and it's fixed by
> 0e4b52942b1c76f89e0dcb829f72e123d0678f54, which is in 4.16.
>=20
> Other than that I currently can't see why this crashes.
>=20
> But the crash should go away, if you disable CONFIG_B43_HWRNG.
> That's not a solution, but it may help, if you would like to get rid of=

> the crashes.
> Could you please verify whether disabling CONFIG_B43_HWRNG avoids the
> crash, just to make sure we are not after a red herring here?

It seems the bug I'm seeing is separate from the one you are describing.
 The 4.16 kernels that ship with debian testing crash for me as well.  I
tested the 142a27f0a version with CONFIG_B43_HWRNG switched off
(manually in the .config): it still crashes is the same way.  I also
just verified that the version one before that really is good.

cheers, lukas

--=20
Do not believe the naysayers who say it cannot be done.


--mPVJdAh4BWeSzqTj3L7BK1Vk72MexYB17--

--626Bw3exMVx6buUZUV9SZNWmOzjQ26BKt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQQfsLWbEt//FEFwBMDWbaSYbwIjLQUCWyDjCAAKCRDWbaSYbwIj
LaP+AJ9kjlSXPlQtypZs0nADvbANJ0ob9wCfSSgBojBcTC93z4X0nrVvGSLM8SQ=
=y57V
-----END PGP SIGNATURE-----

--626Bw3exMVx6buUZUV9SZNWmOzjQ26BKt--
