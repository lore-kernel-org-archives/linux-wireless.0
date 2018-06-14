Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:53062 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964831AbeFNQ1k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 12:27:40 -0400
Date: Thu, 14 Jun 2018 18:26:36 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Wirz <spam@lukas-wirz.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev@lists.infradead.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: Re: b43 crashes on rmmod (bcm4331)
Message-ID: <20180614182636.1b92d7df@wiggum> (sfid-20180614_182743_655478_8DB2053B)
In-Reply-To: <6bef30e0-9405-2ddd-d1eb-612b4d4e3382@lukas-wirz.de>
References: <75e4b424-4c75-5abd-1ef0-c2537d329b10@lukas-wirz.de>
        <d9896c10-87bb-8362-f302-8b1888c3421c@lukas-wirz.de>
        <20180609171159.59b5209c@wiggum>
        <6a78c68e-1062-5ad8-876c-f7d4c49ea492@lukas-wirz.de>
        <20180609220130.3ceb834f@wiggum>
        <e72be8db-77ba-408c-c5e5-351d722e09e8@lukas-wirz.de>
        <20180611224634.28ccd288@wiggum>
        <7d564b8b-2b71-73f6-3ae7-ede0187a4151@lukas-wirz.de>
        <20180613122751.2fe89737@wiggum>
        <538cd7b7-8d63-1795-7bfc-69231d2bf3c0@lukas-wirz.de>
        <20180613130905.420695e7@wiggum>
        <20180613140148.1b57a566@wiggum>
        <6b84a788-e11f-91db-309c-4ff79fdcad66@lukas-wirz.de>
        <20180613152812.5596b460@wiggum>
        <6bef30e0-9405-2ddd-d1eb-612b4d4e3382@lukas-wirz.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/7x_jL9AI874oYKgBZe0Sk.c"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/7x_jL9AI874oYKgBZe0Sk.c
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Jun 2018 12:47:19 +0300
Wirz <spam@lukas-wirz.de> wrote:

> >>>> You can edit drivers/net/wireless/broadcom/b43/Kconfig
> >>>> go to the section config B43_HWRNG
> >>>> and change 'default y' to 'default n'
> >>>>
> >>>> That should disable it.   =20
> >>>
> >>>
> >>>
> >>> Could you please also try the attached patch?
> >>> There seems to be a problem in hwrng core in that it does not disable
> >>> the current RNG, if the new RNG fails to initialize.
> >>> I don't know if that's the problem here, though.   =20
> >>
> >> Ok. Do I apply your patch to the first version that fails for me, and
> >> revert my change to Kconfig? =20
> >=20
> >=20
> > Yes, please test the patch with a version that would otherwise fail.
> > You can use 4.16 or the latest kernel for that. I created it with latest
> > linus' version. =20
>=20
> I tested both suggested cases.  When I disable B43_HWRNG by editing
> Kconfig, 'rmmod b43' succeeds in the first version where it previously
> failed.  When I apply your patch on top of an unmodified 4.16 it also
> succeeds.


Thank you _very_ much for testing.

I will submit this patch to the hw_random maintainers.

--=20
Michael

--Sig_/7x_jL9AI874oYKgBZe0Sk.c
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlsilzwACgkQ9TK+HZCN
iw7yfhAAm360ObKtBi4HOdxOjcWj077nhI6gPnpNStvX4wnrr4DS020IOhdIBWMN
RADCP6dj3hhZMOEx0fHvNSueIUu2TGmA4s2E62CTU/xWF1tfOnk8hgs7mwvSKe4M
xDBN1/60C7MEz6KPOJLPVc3TaO3vSX10nObefTDczXO8NI4W0U74mhoZ1qjcLs+I
xByfd8Q0dG2SBrS+GjA1sQ7Oo6AvQfnRR99h/yqLHRvY4Pl/yIHvj7W4oReUngRH
GaPUKHiLxol0SUoYwe+HGn5qS2d9nZLN2Mq0Ksxw/+TAgdt+zndnXzHO1L6+KISI
qUdjLJ9bAdelPHIdI8mJlaIYig5M+f75ANwD3z6zs0aBw+EuSnjQugXS53l0NnAH
ndZ1br6nQt8XvskTbpaJQQbLjOsGSOftqYF7wcBr5N1hgcbbQkMMTLakvh9KWk0r
EFTwYD1sj/hDRJIgqnCUNfcpff1UzfehTL9e+GFHDFfBWlo/Lebxd1fGw31ylvB2
FVW47F1v/9hwuvI4R0Qp6/Jnj+S6XHqinZ9Giapx1wW69ourUqgPIAqbqRGmSAaj
lrwStNKhHXY/saaGzlq5XpcQy7V1WaQqJPc3a//hOzJMX70WRNeXWa4c4MhcAdKE
YmYtuRb6FrtaRupRqfGXysL/2B9jRWD6N6TmVPcwOdaSV/Jxe5w=
=Z0fh
-----END PGP SIGNATURE-----

--Sig_/7x_jL9AI874oYKgBZe0Sk.c--
