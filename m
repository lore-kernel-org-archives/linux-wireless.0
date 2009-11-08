Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50256 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbZKHO4B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 09:56:01 -0500
Subject: Re: ar9170 in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <4AF6D845.9000600@web.de>
References: <4AF6C7CD.7060108@web.de> <878wehf85v.fsf@purkki.valot.fi>
	 <4AF6CC02.8080204@web.de> <1257688870.29454.52.camel@johannes.local>
	 <4AF6D845.9000600@web.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SUXdQEZrSCb7e83ehxxt"
Date: Sun, 08 Nov 2009 15:56:03 +0100
Message-ID: <1257692163.29454.54.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SUXdQEZrSCb7e83ehxxt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-11-08 at 15:40 +0100, Jan Kiszka wrote:

> OK, confirmed with my cellphone: If I enable powersaving, it actually
> has troubles replying on arp requests.

Thing is that it just won't see the request.

> I kept it disabled as my previous AP setup (rt2500usb on a special
> 2.6.21 kernel) used to fail with powersaving as well. So the good news
> is that one can perfectly run with such a setup for multiple years, and
> I will continue to do so with ar9170 for now - but I also see your point.

Heh. Well most people don't know how to turn off PS on their cellphone,
and shouldn't have to either.

> OK, carrying that patch locally will not kill me. Hmm, is there a way in
> the 802.11 to tell a client to not apply powersaving in this cell - just
> in case?

No. PS client support is a feature that the standard requires from an
AP.

> And what can be done to resolve this issue for real? Does the legacy
> otus driver work fine in this regard? Or are we lacking more information
> about the hardware?

We just need to find a way to buffer multicast frames until after DTIM.
Given that we have the firmware sourcecode, it should be doable.

johannes

--=-SUXdQEZrSCb7e83ehxxt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK9tv/AAoJEODzc/N7+Qmale4QAKsIRh6pyGlmbjMLul7UFm0q
VU2a12yOluuV/LVm8bAjDGIq2JEZLTvGGeSAipQALm30ziatEdBnOkKEnmauEAU5
0/Y1//Q3NQYuW+v/ST90p6ze3NrCGSgUFHAdVVFUXense/mqUOlhafwKF/W7y7sF
S7K8MhoGDnBdGHTVlITE3/iMXJ28uBQ4i6WY5Suno1nHP+Z2bcMVMGLwmGsjuLAz
ulPOKUfdHtXd0RxydmzuVnhm4lacCerpvRuzp70y6wQNUU2F++rTHOvCO941AYVL
0XgK/JVWqccvawYaBcw3WiGsYc4UXLac+iNzeSfg3nFmxBZlIHiUN8hEb4WZXrRT
9fNjerwGWXaxJ0WV9UcFw0z0fACVYbLw30O8fS94KYuDj6jB0WD/dxzuca5Z07rY
222Tabf/wDW10BEYrPxREEtUh1aB6ou2AJrwwL4k0TBxq4rcYafyDEHX5u4WfZ+W
kb71PgK5N1/XB+IWA/FLoPBaC1Z533cR8a0H31OqfmWb4RzT6ueLx4OSY/ry03BU
HrQ1YfInirspiDmsBoLQfXuMDAo88SOSK0ePz3N6jE1mN09mA5/RK6uEZKFxvA4d
oVPHi8kQC73mwn/IQsIwmwBCztXNABvTDs0mZ4hY5lcZw2mhd0eCKreAli81dQK9
HAOZ6z3tzXIkdNxu99pg
=dMcC
-----END PGP SIGNATURE-----

--=-SUXdQEZrSCb7e83ehxxt--

