Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:51150 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932380AbdAFXbt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 18:31:49 -0500
Date: Fri, 6 Jan 2017 23:46:26 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Rahul Krishnan <mrahul.krishnan@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ssb: main.c: This patch removes unnecessary return
 statement using spatch tool
Message-ID: <20170106234626.24f5f6ad@wiggum> (sfid-20170107_003215_690444_0C8AC423)
In-Reply-To: <CACna6ryhvkSaHgU9igshnMjNg=wgeXd3p57VXxbr0ykoEtLH_g@mail.gmail.com>
References: <20170106152043.GA6383@rahul>
        <CACna6ryhvkSaHgU9igshnMjNg=wgeXd3p57VXxbr0ykoEtLH_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/eJ2l1kcRE525BF02wzCSLTD"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/eJ2l1kcRE525BF02wzCSLTD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> > @@ -1272,9 +1272,7 @@ u32 ssb_admatch_size(u32 adm)
> >         default:
> >                 SSB_WARN_ON(1);
> >         }
> > -       size =3D (1 << (size + 1));
> > -
> > -       return size;
> > +       return (1 << (size + 1));
> >  }
> >  EXPORT_SYMBOL(ssb_admatch_size); =20

I'm all for cleaning up code, but I don't really see how this
change improves the code.

--=20
Michael

--Sig_/eJ2l1kcRE525BF02wzCSLTD
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlhwHkIACgkQ9TK+HZCN
iw74Gg//S4K+vKFUUmJjgzuZkT88SBruzzMD7J9IRXyrvX0qmJ3VpjHygjvtHEfY
O+b4LGCqmadN1UFk6O4FYVUN5UnMXF20MptdMhN697iMPZbMMp5Bxsqypi8QcLC3
5/XV9mC8eBiNgWCNexbWEHI9+H4d5Osjt4A1vuRspsE5HC0wT56Bs/HTnakcDpkq
BwiyuiWbA0tYHAUOvHUvMBFUjnH6sllAsI9ZVQkI/O7572ycD2qV7SSGx4fXZMsL
1SqmPMxbXHgA4c5YlFmmwCJlsZaeaxiedl9Sb+BPpHpN4LBc20IMM0LRWOJFrL9o
HhrRbmJWqrXQeLmTKENLURNRbV1mMT2xHkTy4g/VIgIbsbd6tcrOUmU3TE9qx1Re
In9Pxy2OagakZ5NcgizwMSPznnVa5JHTjv1n22tE8nkjyNcycsR303s4JBRWRUGM
2EgwEPIQ28pk9I+tgad43HZFQTY4yG+MXz+hCKufIs5ofhmpAOM967J7gcE0GUVM
LwqB379MHnvPrCvLqFyy+RjlQ/Fa4em4YLULklQ5ja3h16vTCW0CcjE8zObY7U7b
e3wdZcDOObrDjMbkv060WiPn+MtAWF5E6LWeR89lDU7peOtLJo2k8HEGKJhVmU7Z
s/MyVRQ2gNqHLw1MOyRGo2l4WAgt9VGXXLpoqO4vdYcMjolWt4o=
=2Q7M
-----END PGP SIGNATURE-----

--Sig_/eJ2l1kcRE525BF02wzCSLTD--
