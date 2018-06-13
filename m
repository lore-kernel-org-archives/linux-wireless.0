Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:52368 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934677AbeFMLKQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 07:10:16 -0400
Date: Wed, 13 Jun 2018 13:09:05 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Wirz <spam@lukas-wirz.de>
Cc: b43-dev@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: b43 crashes on rmmod (bcm4331)
Message-ID: <20180613130905.420695e7@wiggum> (sfid-20180613_131021_252218_C8D25ABF)
In-Reply-To: <538cd7b7-8d63-1795-7bfc-69231d2bf3c0@lukas-wirz.de>
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
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/aFAYiKsyXD.Aj3CusE9N.y6"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/aFAYiKsyXD.Aj3CusE9N.y6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Jun 2018 14:01:53 +0300
Wirz <spam@lukas-wirz.de> wrote:

> > CONFIG_B43_HWRNG completely switches off hwrng support in b43.
> > I don't see how a change in hwrng core could still lead to a crash in
> > b43 with this option switched off.
> >=20
> > What do you mean by "manually in the .config"? =20
>=20
> What I meant is, that I have outcommented the line 'CONFIG_B43_HWRNG=3Dy'
> in .config.
>=20
> > Can you try to properly switch off the setting with make menuconfig and
> > then recompile everything from scratch (make clean)? =20
>=20
> I was intending to do that before, but I cannot find the option for
> that.  Searching for b43_hwrng in menuconfig only shows the dependencies
> of that option, and the Kconfig file where it is defined, but not the
> path in menuconfig.  Do I indirectly set CONFIG_B43_HWRNG through the
> parameters it depends on?  I'm sorry, but this is obviously above my
> level of expertise ...

Whoops, sorry. You are right. This is an automatic config option.
That also means your manual editing of .config would be overridden.

You can edit drivers/net/wireless/broadcom/b43/Kconfig
go to the section config B43_HWRNG
and change 'default y' to 'default n'

That should disable it.

--=20
Michael

--Sig_/aFAYiKsyXD.Aj3CusE9N.y6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlsg+1EACgkQ9TK+HZCN
iw5xvxAAn0UzFSvV03w4RIX9UUQaHCyXUZTZgHd+yAPKqOu9x76L2igQiWS0BkQT
FcxcPLOD4VVwuzO1fdLjfIntV0v2wL14tga2eHbkVd53jTF+1Da45G16c++ZNcQm
CG9m+a1e5GNJ7Fi9yVY4KZMQs7LY590MQV4t8ipGmieMcxo8QxDI+WasH79rAPqQ
WLsuitrm3DsKCtVbM9HaouhaUnMBOHtTYxiBUvTQCWfowU5z9J2ObmOmLMCvIzbc
/ih+9M5ePIh58Xs0GTc2yJHkWCSqhlezyTlVh/v0K+5HjtYuJl3/7Cij0The2RTn
rJOEQ3VbhO6sTXf07CejMSXaDfV4gOJ7BTExvhFxiKxcdra1pFvX2eS4bVLJLhws
W4ZMSiiZ7RNoPRf6tCvSkMuEDe57AQ1zTTt+YuIrPFlXLk1x3KkIMUxvv0/9jNEM
zZRYkKFKRmASyKQx8TwhoNytCfPCq1rZSG6DAD2Lux2GzTL62/QrqpmIs209fPxn
4v/4gj8K5gPz+95TNhLmnBc+cLyb3TkvbLUM9V0jH1ZHB7e0pDgtoxwrSS6ftAMX
0V6cSqE09E1qXX0FWUglhDHbuMsjHVZBiSS4XhFoffoV6u9gICFkuGpwWkfu7pYU
PUVlo1avvVkxdbcWFyP0CyFxlP67FQm0LqPHy6Bs83hDKdPnbjs=
=0i30
-----END PGP SIGNATURE-----

--Sig_/aFAYiKsyXD.Aj3CusE9N.y6--
