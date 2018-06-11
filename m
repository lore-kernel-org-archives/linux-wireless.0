Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:40313 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754208AbeFKUJh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Jun 2018 16:09:37 -0400
Subject: Re: b43 crashes on rmmod (bcm4331)
To: =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>
Cc: b43-dev@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <75e4b424-4c75-5abd-1ef0-c2537d329b10@lukas-wirz.de>
 <d9896c10-87bb-8362-f302-8b1888c3421c@lukas-wirz.de>
 <20180609171159.59b5209c@wiggum>
 <6a78c68e-1062-5ad8-876c-f7d4c49ea492@lukas-wirz.de>
 <20180609220130.3ceb834f@wiggum>
From: Wirz <spam@lukas-wirz.de>
Message-ID: <e72be8db-77ba-408c-c5e5-351d722e09e8@lukas-wirz.de> (sfid-20180611_220941_341909_275395FE)
Date: Mon, 11 Jun 2018 23:09:06 +0300
MIME-Version: 1.0
In-Reply-To: <20180609220130.3ceb834f@wiggum>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="KpAAykwaxsPToDFwjBcanaYMz9D0WyZ1R"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KpAAykwaxsPToDFwjBcanaYMz9D0WyZ1R
Content-Type: multipart/mixed; boundary="cn3NTPKMl3lUpnbHx4FjunJkkuLXiFfcy";
 protected-headers="v1"
From: Wirz <spam@lukas-wirz.de>
To: =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>
Cc: b43-dev@lists.infradead.org,
 linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <e72be8db-77ba-408c-c5e5-351d722e09e8@lukas-wirz.de>
Subject: Re: b43 crashes on rmmod (bcm4331)
References: <75e4b424-4c75-5abd-1ef0-c2537d329b10@lukas-wirz.de>
 <d9896c10-87bb-8362-f302-8b1888c3421c@lukas-wirz.de>
 <20180609171159.59b5209c@wiggum>
 <6a78c68e-1062-5ad8-876c-f7d4c49ea492@lukas-wirz.de>
 <20180609220130.3ceb834f@wiggum>
In-Reply-To: <20180609220130.3ceb834f@wiggum>

--cn3NTPKMl3lUpnbHx4FjunJkkuLXiFfcy
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi,

>>> Is is possible for you to create a git bisect to find the change that=

>>> actually broke this?
>>> That would be really helpful. =20
>>
>> I can try that.  What is the most efficient way to unload/recompile/lo=
ad
>> a single module without rebooting the machine too often?  And it'll be=
 a
>> lot of hard resets ...
>=20
> A git bisect is really only possible in the full kernel tree.
> But it won't take a lot of steps to get a result, because you already
> narrowed it down to 4.14-4.15. It might take 10 iterations or so (git
> will tell you). Due to incremental builds that can be done pretty
> quickly. As the whole kernel is searched for a change, a reboot is
> usually needed after each iteration step.

Ah, yes.  I had for a moment thought I might get away with recompiling
just the b43 module, but that does not work of course.

I did the bisection, it was 13 steps.  My metric was to say 'modprobe
b43; rmmod b43'.  If the rmmod returns it's good, otherwise bad.  (I
booted every kernel only once, so I hope there is no randomness
involved.)  In the latter case the machine had to be hard-reset.  Also,
in the latter case 'lsmod | grep b43' returns after the failed rmmod:

b43                   348160  -1
ssb                    49152  1 b43
mac80211              688128  1 b43
cfg80211              540672  2 b43,mac80211
bcma                   49152  1 b43
led_class              16384  4 b43,applesmc,sdhci,input_leds

the bisection leads to

142a27f0a731ddcf467546960a5585970ca98e21 is the first bad commit
commit 142a27f0a731ddcf467546960a5585970ca98e21
Author: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Date:   Fri Oct 27 22:34:04 2017 +0530

    hwrng: core - Reset user selected rng by writing "" to rng_current

    User is able to select a chosen rng by writing its name to rng_curren=
t
    but there is no way to reset it without unbinding the rng. Let user
    write "" to rng_current and delesect the chosen rng.

    Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com=
>
    reviewed-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

:040000 040000 f61e5cc501c99fb09bae5f203528b9f4c3479f8a
785262813cfb02c9606fd72274f0f7b44f2289d7 M	drivers


cheers, lukas


--=20
Do not believe the naysayers who say it cannot be done.


--cn3NTPKMl3lUpnbHx4FjunJkkuLXiFfcy--

--KpAAykwaxsPToDFwjBcanaYMz9D0WyZ1R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQQfsLWbEt//FEFwBMDWbaSYbwIjLQUCWx7W6wAKCRDWbaSYbwIj
LXwxAJ4vutlXTKog+TEcbW6b5ZvDkB+7LgCgjBx6CNMgUeKWpCraJksfVTKWfNk=
=yNil
-----END PGP SIGNATURE-----

--KpAAykwaxsPToDFwjBcanaYMz9D0WyZ1R--
