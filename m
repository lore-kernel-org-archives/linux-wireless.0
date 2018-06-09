Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:50348 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753449AbeFIUCl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Jun 2018 16:02:41 -0400
Date: Sat, 9 Jun 2018 22:01:30 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Wirz <spam@lukas-wirz.de>
Cc: b43-dev@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: b43 crashes on rmmod (bcm4331)
Message-ID: <20180609220130.3ceb834f@wiggum> (sfid-20180609_220244_869458_E964F42E)
In-Reply-To: <6a78c68e-1062-5ad8-876c-f7d4c49ea492@lukas-wirz.de>
References: <75e4b424-4c75-5abd-1ef0-c2537d329b10@lukas-wirz.de>
        <d9896c10-87bb-8362-f302-8b1888c3421c@lukas-wirz.de>
        <20180609171159.59b5209c@wiggum>
        <6a78c68e-1062-5ad8-876c-f7d4c49ea492@lukas-wirz.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/mgEmzvzjbh2z+x1l_7N0bJv"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/mgEmzvzjbh2z+x1l_7N0bJv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 9 Jun 2018 22:46:58 +0300
Wirz <spam@lukas-wirz.de> wrote:

> > Is is possible for you to create a git bisect to find the change that
> > actually broke this?
> > That would be really helpful. =20
>=20
> I can try that.  What is the most efficient way to unload/recompile/load
> a single module without rebooting the machine too often?  And it'll be a
> lot of hard resets ...



A git bisect is really only possible in the full kernel tree.
But it won't take a lot of steps to get a result, because you already
narrowed it down to 4.14-4.15. It might take 10 iterations or so (git
will tell you). Due to incremental builds that can be done pretty
quickly. As the whole kernel is searched for a change, a reboot is
usually needed after each iteration step.

There are a couple of howtos on the web regarding git bisect:
https://duckduckgo.com/?q=3Dgit+bisect+kernel


--=20
Michael

--Sig_/mgEmzvzjbh2z+x1l_7N0bJv
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlscMhsACgkQ9TK+HZCN
iw5tcA//f2OlAyDgMPBGgPDZvWRe5gxe8jI6TAG5WMcWZMdXzx344G5zL6rZHoCp
5BLE9lh3VZZjh4t3HP8mFVhoaDMsoT1osPu0dlaLFnQPjzDHLCRLlbYtAoj9ewSm
k30ua+WY52MLaH/Yj8MstAFzVZNh3c9J0JDV3ECq9G0w503wIMAV7Y2S2vFqxw4s
FT14gBpKFLU0aJ4DiD6lWVeYnQ3ixBvjSpatMspEkmpWS3YBww6JDL2WU7N4nvnD
4J1PiUqdmPfjTbcRuZg9xBV4TNYlVvaN3JuYe79zrsAqEU8PSIQiqyv0uvxo+62R
Od2DCX6HgMnIEMMaPLBjqg9UNx+G1ZTHctk4iMCU9L/Mq5ja59poV7SAwOJ7j1on
o5XHqP5VCmpP8u0dkOVUHDK4DIXqyUi3liHVxvDBQ2Eda1hi+GPmzjjjxb5rQnlr
nth7yjgJ8kliWWJ+a7t0MhRyh2kPKIiKgRKTFA2vgbcwZ7jHPew7FQXHpTTtRMO0
Qmttm8gua2a0NS5pir6AdsTlHelHtoNOugBFiVjx+i+oaLnC0FpqhVrzlu4jn6RY
k1yGTYsBhZM3M9Zwt38b6hY/JSTB9uR5RAYTV5VKew6JhpBcEdWeP4JR888bLam+
9X0kOXNiFbfV4x/RS8GjAi8eDwWA3hC2oym70LEtrQ217rMTBFA=
=EQD5
-----END PGP SIGNATURE-----

--Sig_/mgEmzvzjbh2z+x1l_7N0bJv--
