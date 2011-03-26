Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:51814 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751282Ab1CZLuy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Mar 2011 07:50:54 -0400
Subject: Re: Question about code in rc80211_pid_algo.c
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	wireless <linux-wireless@vger.kernel.org>,
	"Mark (The Wirie)" <mark@thewirie.com>
In-Reply-To: <4D8D5FEF.6010009@lwfinger.net>
References: <4D8D5FEF.6010009@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Qr92sfvyFOK6WUC5Ya7u"
Date: Sat, 26 Mar 2011 12:50:50 +0100
Message-ID: <1301140250.3807.5.camel@kea>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Qr92sfvyFOK6WUC5Ya7u
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Larry,

comments inline.

On Fri, 2011-03-25 at 22:39 -0500, Larry Finger wrote:
> Hi,
>=20
> I'm writing to you as the listed authors of the PID code in the mainline =
kernel.
>=20
> I am helping adapt the PID algorithm for an appliance that will use the R=
ealtek=20
> vendor driver and the ALFA AWUS036H device. The vendor driver's rate-cont=
rol=20
> mechanism is not very effective. As the target kernel for the appliance i=
s=20
> 2.6.21, we are not backporting mac80211 and the rtl8187 driver.
>=20
> The package is working quite well, but Mark, the project manager, brought=
 one=20
> section to my attention and I am forwarding it.
>=20
> In routine rate_control_pid_sample(), the percentage failure is calculate=
d, then=20
> if the rate has been changed, the code goes on to "update the rate behavi=
our=20
> info". At that point, the calculation is
>=20
>           tmp =3D (pf - spinfo->last_pf);
>           tmp =3D RC_PID_DO_ARITH_RIGHT_SHIFT(tmp, RC_PID_ARITH_SHIFT);
>=20
>  From our analysis of the code, both pf and last_pf must be in the range =
0-100,=20
> and the first statement results in tmp between -100 and 100. After the se=
cond=20
> line does an arithmetic right shift of 8, the resulting value will always=
 be=20
> zero. Did we miss something, or is this really a convoluted way to set "t=
mp" to=20
> zero?

I agree with your analysis, the code will effectively set tmp to zero. I
would consider this a bug :) The whole differences computation business
is Stefano's invention though. IIRC, his idea was that we should not
have a static ordering of rates, but rather learn the order of rates in
terms of achievable TX rate. I guess you really want to check with him
in order to find out what to do :)

Mattias


--=-Qr92sfvyFOK6WUC5Ya7u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEABECAAYFAk2N0xoACgkQwJO1cHm4WqZHYgCfUKyTXkzAxP2gTmuyI7hWmEhD
tuAAni0cfkt9eiyNvOTwrJmvhkgDetNr
=UYzY
-----END PGP SIGNATURE-----

--=-Qr92sfvyFOK6WUC5Ya7u--

