Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55904 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbYDEJJQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2008 05:09:16 -0400
Subject: Re: [PATCH RFT] b43: We need lots of regression testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de, Dan Williams <dcbw@redhat.com>
In-Reply-To: <1207364787.2115.16.camel@dv> (sfid-20080405_040635_154207_9EE40F90)
References: <200804041612.18840.mb@bu3sch.de>  <1207364787.2115.16.camel@dv>
	 (sfid-20080405_040635_154207_9EE40F90)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Bl3fEXUUEXxyyfW3RcRv"
Date: Sat, 05 Apr 2008 11:09:06 +0200
Message-Id: <1207386546.3860.5.camel@johannes.berg> (sfid-20080405_100928_594801_D1A6AF3A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Bl3fEXUUEXxyyfW3RcRv
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


> Another unrelated bug (sorry, testing often finds unrelated bugs) is
> that scanning with specific ESSID was returning non-matching APs.  I
> mean "iwlist wlan0 scan my_essid", which would still report many
> different ESSIDs.  It's inconvenient when the driver can sense 22 APs at
> once :)

Heh. I'm not sure what the desired behaviour is, if you do that scan
we'll give you everything we found but will scan actively for that
particular SSID. The man page (sigh) only says:

=EF=BB=BF              This command take optional arguments, however most d=
rivers  will
              ignore  those.  The  option essid is used to specify a scan o=
n a
              specific ESSID. The option last do not trigger a scan  and  r=
ead
              left-over scan results.

Which isn't quite clear, but seems to match what we do. Maybe iwlist
should filter it?

johannes

--=-Bl3fEXUUEXxyyfW3RcRv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/dBsaVg1VMiehFYAQJiKhAAubpkRnRKSWMAagr7jCdz82lvB/1HyDDD
AcLLtj7K7Cjn3clxfvfWxoER9t1XShx2Z8ZT0dc2Au2OBFMpT1IQk8IB4iF1GEin
U/M/bQ6MS4IUC6G2QXvqEOEP/uQIZir3yF1dguiSaBV19WOpZpyV7L2otzqqHTB0
M5L3PqexC2Oh0WeBKQmluyx3z28s6CwgEzupUEOYTiOByMLErm1ptMiFmHxvA4np
vavzXUM7MTaaeXKs6eyQwXHIktYlffi9qQ/x0U073MTRlOZyVPhHrwmZN5NoTMgL
pB5RHgH7GBkreT/rmuCIFzqAHpK6FxYA2DdS/YfQPx+KCT0hCVcnwXdB6AucV3pU
YGn+87gTs1gkHsiNQ84lqR9cIT08QYv48DfwZJRGt04wUMp51Zbpbe5Wj8KNPRx5
OBEdxIJCJgdW2P3tng95e7FHq4fgPOV+QDWkuwOMu8IYx8twYzSlaUIlR3TzgaRy
tYfQWKPZJ5KJm9NRkzZLU/fz3FMcHKbB0bRQJTEHZSRXOlyZDXinuPQ/2dx4fDRm
q39VaUvH3xAa64RS3CJeZmww9bL1/0rC0GZ/rhWvJyg9lIaF/Dd2+HUaAEtcmfqS
Xt8OxEl/Vil69SQclzyEn5fFGQSz7+7NMbqi+df5KrIlwVRj2s3EMt1vNU0fqlyg
8uLEgmCDk+A=
=8mez
-----END PGP SIGNATURE-----

--=-Bl3fEXUUEXxyyfW3RcRv--

