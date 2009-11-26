Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:50990 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbZKZRxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 12:53:48 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [RFC] API for setting ACK timeout
Date: Thu, 26 Nov 2009 18:53:53 +0100
Cc: linux-wireless@vger.kernel.org
References: <200911261826.08576.8an@praha12.net> <69e28c910911260932n4bc3e82du33a28ad9a5e8482@mail.gmail.com>
In-Reply-To: <69e28c910911260932n4bc3e82du33a28ad9a5e8482@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart19998932.W4Lsflvyde";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200911261853.53572.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart19998932.W4Lsflvyde
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 26.11.2009 18:32 G=C3=A1bor Stefanik wrote:
> Why not instead allow setting ACK timeout directly, e.g. in
> milliseconds? (Similar to how signal strength is almost always
> returned in dBm, even though the devices themselves use all kinds of
> units.)

Because the timeout does not depend on the distance only, the calculation=20
involves at least the transmit duration of an ACK frame, and sometimes more=
,=20
depending on the hardware (in one of them I saw they added DIFS to the=20
timeout, forgot which one).

And on Atheros hardware there are three values that depend on link distance=
:=20
ACK timeout, CTS timeout and slot time.

So the equivalent of dBm here is the link distance, not ACK timeout.

Lukas Turek

--nextPart19998932.W4Lsflvyde
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLDsCxAAoJEEBjvk/UOfYw7wIP/0/OhAmdRJIAsbqCQdM1M7EH
etw7gflbM2EnL+XR0VQtkLjXkSBZcbgxRwoHuXoO6i2vCPI+j5izTJ30FJHNwb6n
9wGsogY06i/Pu2StAT3+vcvgN6aiOkfejUaFbq+BTskbz2Dl9vJ3Rb9PB3XKMXAa
sX8RbVEsb9dsBh/hFBNZxizUgOY42F3v02jR/jJ/jAr8ewGgsRbElY8hpyVTvX54
H7/EUNUNLuAwGIySrKrOem4qRMTY/K9mxRip7N4VdZnLp5ZN9PViA+odxiA95ukz
10NZliIBQ3i00dmnhdRSHcyKc/505o3Y9/Sk1X7WMGqWYik2CLllXi7jWu/L+9HP
GQZ40xzjvAWepTewPtS3rzwVGP/W+E4UAszhiOCaoJgx9wzq2TmQFHVFQTwEo0s2
4iIsU0mwPehmmsPG87/llHraKHmt9tpK8DXlglE7ipGsp9eZcyGp8F99qMOiG5vm
GW8uGOX2tQ5AtGTnMUUmWJ9NN3ziNA7jjDJzv+kCtDmLsmidluJn+NONUF/3XC6E
i7nNwa8tCvPEKWFvwuqFX8mX7KLjJJHZIovbAgwoWv0oKKl9Mq6xfiAUAbMW6nMJ
fhd8TyQthnkwEiBvSz1pGCuIcruN5L0LcTFqRz+5ze8a33FXzX/4a1Y3wkw4RhzZ
C6+CErWsvAZxMRDvjeKR
=fSTI
-----END PGP SIGNATURE-----

--nextPart19998932.W4Lsflvyde--
