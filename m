Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:50126 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753062AbeFIPMT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Jun 2018 11:12:19 -0400
Date: Sat, 9 Jun 2018 17:11:59 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Wirz <spam@lukas-wirz.de>
Cc: b43-dev@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: b43 crashes on rmmod (bcm4331)
Message-ID: <20180609171159.59b5209c@wiggum> (sfid-20180609_171458_741127_D9BDD8EF)
In-Reply-To: <d9896c10-87bb-8362-f302-8b1888c3421c@lukas-wirz.de>
References: <75e4b424-4c75-5abd-1ef0-c2537d329b10@lukas-wirz.de>
 <d9896c10-87bb-8362-f302-8b1888c3421c@lukas-wirz.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/D9eheoKCRTHXOX/1gJI+wXY"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/D9eheoKCRTHXOX/1gJI+wXY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 9 Jun 2018 15:08:24 +0300
Wirz <spam@lukas-wirz.de> wrote:

> The regression I reported a few weeks ago for 4.15, exists also in 4.16.
>  That is, with a bcm4331/ht-phy b43 can be loaded and used without
> problems, but the driver crashes when it gets unloaded (making a hard
> reset of the machine necessary).  This problem has been introduced
> between 4.14 and 4.15.

Thanks for your report.

I just checked the diff between 4.14 and 4.15 for b43 and bcma. It's
pretty small and there's no obvious candidate to me that could cause
such a regression.
This might be a change outside of b43 and bcma that triggered this
behavior.

Is is possible for you to create a git bisect to find the change that
actually broke this?
That would be really helpful.

--=20
Michael

--Sig_/D9eheoKCRTHXOX/1gJI+wXY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlsb7j8ACgkQ9TK+HZCN
iw7+5Q//e+wJ+aMXLtwNhgIbDnbP9qsGe7lQK/0J5qdXjcbxdI59HmUb5P640AZv
j7yzEIFl/UrzWuj88ZTdAp6BX1Rs+jFyowiiPQGLQyPUh5hfVV6AIpfqf4AiA5T/
GrOIpDcb64hDvET1T3i0bH4rXr0s4glsLnqNcvGpjOeiw6TWS/BJyIqCek7nySCK
5NXMYe4t/01KytKYbVj9fPX7O1J2AuyzHGkm8W9Tej9UsAhe5s+QNA13qRp7yhSQ
jWWF3dnqIm1itH04RUKjvDYtbJO49F5fmC24SK79OWMZks+YwLwSCl4A+rD/1+vq
gtVAtNWVhLVU8Vm/JbIuHY0EwFtHzuNscsdoezgeadILDzggUbsyl47pQRuz+f0o
wOciapHiN5nvUSn0LodBDEkvx6ggvbkfZSiTQri4V9Bpa6OiGKfrSmc2/IHv3PPA
sSFRPHeStHuXIGDfKaE5CTbiQ/2GkT8Wmk7lD1OEFRy09Lf1t0N2JqnWxZwDTxRy
fL7LErGwqYj56CWR3vXYO/2boWTjDs5WaIBc5R8UDkt7Z/FyU8iNa++9UK5P/0vY
fwx/YCGYWORCEpXCL4oZkUVxpixLvJHzDSMWmz6tbap1bHDYow2Hebk1qYSCuwS5
T+SJ3MgQrYLwh23ubbT9sWi/jKWIUxesSOr/Jc+/j/eumN13BXE=
=XKHB
-----END PGP SIGNATURE-----

--Sig_/D9eheoKCRTHXOX/1gJI+wXY--
