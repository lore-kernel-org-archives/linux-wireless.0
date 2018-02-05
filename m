Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753501AbeBESda (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Feb 2018 13:33:30 -0500
Date: Mon, 5 Feb 2018 18:33:25 +0000
From: James Hogan <jhogan@kernel.org>
To: Adric Blake <promarbler14@gmail.com>
Cc: m@bues.ch, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Subject: Re: B43 driver no longer works in Linux 4.15 (bisected)
Message-ID: <20180205183324.GD8479@saruman> (sfid-20180205_193523_859259_E2F50AC6)
References: <CAE1jjefE1qjgcHMik36Na0OYoFON+kCi5cEDSq=y11HdsyPn0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mSxgbZZZvrAyzONB"
In-Reply-To: <CAE1jjefE1qjgcHMik36Na0OYoFON+kCi5cEDSq=y11HdsyPn0Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--mSxgbZZZvrAyzONB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Adric,

On Mon, Feb 05, 2018 at 01:23:31PM -0500, Adric Blake wrote:
> In the time between Linux 4.15-rc8 and -rc9, my wireless driver, b43,
> would no longer load automatically. When I modprobe the b43 (and ssb)
> modules, the device still didn't appear in NetworkManager. Comparing
> the kernel logs between working (4.14.16-lts) and nonworking (4.15)
> kernels reveals that there is zero output from the ssb module, and no
> devices recognized by the b43 driver:

=2E..

> I had my suspicions at this point, but I had a lull and decided to
> bisect it anyways.
> I bisected to this "first bad commit:"
>=20
> commit 58eae1416b804d900014d84feadda7195007cc30
> Author: James Hogan <jhogan@kernel.org>
> Date:   Mon Jan 15 21:17:14 2018 +0000
>=20
>     ssb: Disable PCI host for PCI_DRIVERS_GENERIC

Yes, really sorry about that and thanks for going to the effort of
bisecting. There is a patch here:
https://patchwork.kernel.org/patch/10185397/

which is applied to linux-next as commit
a9e6d44ddeccd3522670e641f1ed9b068e746ff7, and is tagged for stable,
though I've just noticed the stable email address is incorrect... I'll
make sure it gets applied to the 4.15 stable branch though as soon as
I notice its merged.

Thanks
James

--mSxgbZZZvrAyzONB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEd80NauSabkiESfLYbAtpk944dnoFAlp4o24ACgkQbAtpk944
dno8FRAArY2tBu53Uxf3QAGz3qXgGrDlYSq5AqCHBIqxqdWd7zYCD00L3c7wrI5Z
9rYqv1tUDYgRk+Fka37IlJ95Zeo6qdqltZ9xagcMTpHZalPox5eMz0JPRgwTXDMy
WlIi8z0Tx2jqWNUFYW5Z7M1iE3pdrEsJHczN9QSWQ5rU5So+a4W1b5PU/JaRNezD
7ewfhJ365LqXI47nU4FKogJbxQqJrBA7SlDGFiC4cYg7DC/a6PlyBciB5u8q1eDo
DTHacJpxS6PldKKzu10aZmIahC2DUblAUG+4TNh0XjUkdlf/7xoxzQkq8ekdVtjX
n0eTEaYyPCnm33TfGbE7GSCjGvMkZCYT4WqwO9Uc4DrK49O5cSThejskrBweg9ax
Am0MbnD4S/oZE/JxgXQe2tdwU9GysFnZMMBt8CNcvMBxEi8wiZgv5LCfLEoZYg6p
o5HD6se3ZgSrdZwT4uVgvPv5WLYDe1NqIj2OocqsawFOVyA+mRoisqyVpdQM/sy2
mynRKstq1kZkgeC+eRQhpatkYvIDRlueYnUW66BYUJA493HTSGaWs0KZqysGW6uI
3qVW2d2Yym1aEkme7s/tcoIks8WkOZxm+IhilwnuBvWK+OO7wVMbzakhur91adCg
eUtlir4xe8YAf3EiIz65P8UEHqqIIbAkhZyOHZO/00pDUWR4BjY=
=AoH/
-----END PGP SIGNATURE-----

--mSxgbZZZvrAyzONB--
