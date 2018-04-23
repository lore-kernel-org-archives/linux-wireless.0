Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:33157 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751356AbeDWHly (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 03:41:54 -0400
Date: Sun, 22 Apr 2018 21:41:50 -1000
From: Joey Pabalinas <joeypabalinas@gmail.com>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Joey Pabalinas <joeypabalinas@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: New sparse warning from min_t(): expression using sizeof(void)
Message-ID: <20180423074150.cc4nrr4ogfql43fx@gmail.com> (sfid-20180423_094223_872743_E00D9E1A)
References: <87a7txf15w.fsf@kamboji.qca.qualcomm.com>
 <20180421082444.i4eyw2zxl6tipt6i@gmail.com>
 <87604ley7t.fsf@kamboji.qca.qualcomm.com>
 <4777fb12da0a71e030cc7b0cf47d5391be2a3efd.camel@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tdqvskbjew4jxvmc"
In-Reply-To: <4777fb12da0a71e030cc7b0cf47d5391be2a3efd.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--tdqvskbjew4jxvmc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 23, 2018 at 09:20:14AM +0300, Luciano Coelho wrote:
> Thanks, this solves the problem for me, but I'm still getting a lot of
> this:
>=20
> ./include/linux/mm.h:533:24: warning: constant 0xffffc90000000000 is so b=
ig it is unsigned long
>=20
> Is there a patch in sparse to solve this one as well? Or is this an
> actual error that must be fixed in mm.h?

This is definitely a valid warning in the general case (integer promotion
rules can cause *incredibly* difficult to find bugs if you overlook them,
so it's very useful to get a warning when a promotion occurs implicitly to
integer constants).

In this case though, you are comparing it against `unsigned long addr`
which is exactly the same type, so there's no bug.

It could possibly be argued that in:

> arch/x86/include/asm/pgtable_64_types.h:122: # define VMALLOC_START __VMA=
LLOC_BASE_L4
> arch/x86/include/asm/pgtable_64_types.h:108: #define __VMALLOC_BASE_L4 0x=
ffffc90000000000

__VMALLOC_BASE_L4 would be better written as 0xffffc90000000000UL, which wo=
uld
indeed shut up sparse.

--=20
Cheers,
Joey Pabalinas

--tdqvskbjew4jxvmc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEKlZXrihdNOcUPZTNruvLfWhyVBkFAlrdjj4ACgkQruvLfWhy
VBl2SRAA1ZhpBw7wGVNBK2AUmd+nP2L4xMOO9ypDVbe71AB4mvxNiE1oN/VveiOO
YDSXAxmQgwpIgiExUcgZYXqLC1RWa7wiuGXg9c8aP6up3hci70vVxanu9teng25O
OS8sKULzrg9v5sekC2mka4lncHgnrk0jLyM6wd5PQfEaV73ekPJpg/UkZSGYEjCQ
NCUjOoHq1v8G/kpAxOpSzkK/n2Fnd/BGxEqX8aWqhiu+7Z4hkwnpGkBGYNCDbICL
Qh618wFPsfZkg2uSgpNGLSjsVmooKRT4RJoQk0xpsWbk4e1U0xI5VWcqoFbkew+i
4TNW7R8sf0iOTy2Bm9rJClkp6niq5WUgGm0XvuwxeDgkDpWkgaK6THvxCgPoo6mn
9I+1g07WuQV01H1oSbwwsb6ZIcE6Bb1XmkGDPBaPFh5knk86OGZQeyvMcrXcL9ir
zi95T3LIA5T3WJE56//pyBwATqXGX9Qoymvjdvyb+feuH3YJ8AtRtljWWJlYlpiw
br9cVu9yO2kDgy8a2YeNHLsH/V98lQbtnCp/n3gWOQCGNbKjDk/uyK9UfoDL8th2
i+xkAQz3ZvnEnJuSpZWolQ/KH9FtIdi4Ajh3+YrOgW44y3XsXfv1tHvsDwz1lPRD
H/QW85wrV6CEQhsTOPFHi1jQWesFke3q5bgae4qTTAvlj5R8E/M=
=9+LS
-----END PGP SIGNATURE-----

--tdqvskbjew4jxvmc--
