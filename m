Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:52310 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933657AbeFMK2I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 06:28:08 -0400
Date: Wed, 13 Jun 2018 12:27:51 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Wirz <spam@lukas-wirz.de>
Cc: b43-dev@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: b43 crashes on rmmod (bcm4331)
Message-ID: <20180613122751.2fe89737@wiggum> (sfid-20180613_122812_089913_5D0FD9F0)
In-Reply-To: <7d564b8b-2b71-73f6-3ae7-ede0187a4151@lukas-wirz.de>
References: <75e4b424-4c75-5abd-1ef0-c2537d329b10@lukas-wirz.de>
 <d9896c10-87bb-8362-f302-8b1888c3421c@lukas-wirz.de>
 <20180609171159.59b5209c@wiggum>
 <6a78c68e-1062-5ad8-876c-f7d4c49ea492@lukas-wirz.de>
 <20180609220130.3ceb834f@wiggum>
 <e72be8db-77ba-408c-c5e5-351d722e09e8@lukas-wirz.de>
 <20180611224634.28ccd288@wiggum>
 <7d564b8b-2b71-73f6-3ae7-ede0187a4151@lukas-wirz.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/5oQ/3xxVUX1suQb7qNC8KqQ"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/5oQ/3xxVUX1suQb7qNC8KqQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Jun 2018 12:25:16 +0300
Wirz <spam@lukas-wirz.de> wrote:

> > This commit introduces a bug, if b43 is the only RNG in the system. But
> > that is unlikely on modern systems and it's fixed by
> > 0e4b52942b1c76f89e0dcb829f72e123d0678f54, which is in 4.16.
> >=20
> > Other than that I currently can't see why this crashes.
> >=20
> > But the crash should go away, if you disable CONFIG_B43_HWRNG.
> > That's not a solution, but it may help, if you would like to get rid of
> > the crashes.
> > Could you please verify whether disabling CONFIG_B43_HWRNG avoids the
> > crash, just to make sure we are not after a red herring here? =20
>=20
> It seems the bug I'm seeing is separate from the one you are describing.
>  The 4.16 kernels that ship with debian testing crash for me as well.  I
> tested the 142a27f0a version with CONFIG_B43_HWRNG switched off
> (manually in the .config): it still crashes is the same way.  I also
> just verified that the version one before that really is good.


CONFIG_B43_HWRNG completely switches off hwrng support in b43.
I don't see how a change in hwrng core could still lead to a crash in
b43 with this option switched off.

What do you mean by "manually in the .config"?
Can you try to properly switch off the setting with make menuconfig and
then recompile everything from scratch (make clean)?

--=20
Michael

--Sig_/5oQ/3xxVUX1suQb7qNC8KqQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlsg8agACgkQ9TK+HZCN
iw5v5BAAxZMnA17J9AQRGAihxo3gSrYhllCRkuAbz9f9hNPcDUhgNTOR2HcMWZ/S
q2sNTK13y7/9EUdbMCoIRqOQUuCR1uwPOH7B7VZOpeEwsIy5mAnuD1drxWZP3M2u
zxjm9Cekhq2pILcxn4MVZMH6ppI8Gqhe+uDJWZQUHyURzaHTiRxyXuST9FskuUwh
RkHVvIVnjxSYguE8rPLnK9ZY1Rw23u+Uk7jQX68L8MF2h/OVSF5gtFxLsDcJPqjF
1IBdyakIysuP+hle0wfktt9FEF/L/RjPkkorKXekjI/ujIGWoE/Ygb6Ym0tzCOH0
1S3Ksb1cSgfjYI7hQtEh2iK3E9rZ5EBunDf1idE4L7++Di7e8u68RHojh1y52Z1U
qlILeblgTKRezICUrIL7UkitjY0PZOoEfvBrooN3Gn+N3a992eiIAoNQUpRf0kte
N9GIhrBbJfN9RYn9sDwn39+gMXJ7k4Ikc90sHzAD63gxCGc7no+vqq2qhalZ69K9
n5tn9chq+BF3VCFYDL8SXdilrdyKwd/7MW8nqW97lua6AQpyxc/a3kg+7I28h6uD
3ovk6Ya25e5Bn+VO09ACkXj8MuTLWuUBfBGwDJlfFsqghWiY5I/adLqohC7IQBJ7
dupzov3dLWI/H38YM23qeqqLvLRyPeaTa+GeKHjLWn+iANXjPzY=
=Mo2/
-----END PGP SIGNATURE-----

--Sig_/5oQ/3xxVUX1suQb7qNC8KqQ--
