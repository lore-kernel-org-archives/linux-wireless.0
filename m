Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40653 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbZGGI4r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 04:56:47 -0400
Subject: Re: BUG REPORT: libertas causing kernel lockups
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	Alexander Barinov <alex.barinov@gmail.com>
In-Reply-To: <200907070859.39413.hs4233@mail.mn-solutions.de>
References: <20090704130346.01b2e869@dream>
	 <200907070859.39413.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HS30b5uopgeU+b3iilN9"
Date: Tue, 07 Jul 2009 10:56:47 +0200
Message-Id: <1246957007.4755.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HS30b5uopgeU+b3iilN9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-07 at 08:59 +0200, Holger Schurig wrote:
> > By executing 'cat /proc/net/wireless' I get the same bug:
>=20
> I haven't tested your exact but, but I've the following in my=20
> mind, back from about 1 year ago when I did lots of libertas and=20
> libertas_cs work:
>=20
> Access wireless stats made the libertas driver (in wext.c) issue=20
> a command towards the firmware in the hardware. I think it was=20
> the command to get the current SNR/RSSI/whatever.

Yes, but the patch that I quoted makes it allowable to sleep there, so
it must be something else. Is it maybe using the RTNL there? Or using
schedule_work() and then waiting for it or something that the work
triggers, which will deadlock on the RTNL if there's something in front
of it on the queue that needs the RTNL, because get_wireless_stats is
executed under RTNL? (lockdep couldn't find that particular case because
it knows nothing about completions)

johannes

--=-HS30b5uopgeU+b3iilN9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKUw3MAAoJEODzc/N7+QmaA+wQAMPZSCFw5wESuv7U3bQ7zH9/
I+bYYxiftupjya/o7KcS1dY48kX8ASavs2xKTzlrGazxliMw1Xx3etFaBrwK2TT7
VGL+hLlPORZPZ/Bj7yx0Sk6rU8MfTFhQnMFqMyiLaIwUNFMAP+nyq45lV4Pk/O0P
GTsSwXBTYVqP2ZHyA6iV2gbXTOR6AUKpTyNqZk9BMxJvpXMdDYyYU6TwonmDx1zo
sdbw6zynOBOLG/gD3tGX8S2mE5EwL74lgiftDEqbUgZ6iu4bW/zyKmPPMov7GZz0
5ZEJoFUjWIWj3MgZ+faUKNGNX8XVmkEnpp/i3zDWC/wx0BPHf7kTbjmhR9SIQPqj
Y8sWTSbfanTg3BCXu2FBW/Y4IbZrQuYT5+fnjViwW7CSwxrgqAU2XZOOYZuacmkj
pI85a8RCVQoCqX5Es+2WqnQeSz/TFVpqsL7cM4vITIGDC51+32Xw0VMIjfpree5m
hZ/3zm4tLszRQH2amjzCNtESPhZWKyr6WyvQt20ewUxTJ4M2d46TTcQhUykn2WHl
F4i8evKTiPpJNjTAmWUdc5XLj+/3QFrlFlkUcqkUam5nzlr4BczkjLLeCygTmSNt
k4Q4w9Ul1XcBBv37BIAbHYBL0SOfM/bJ5/H/0Ir/+ld89a/QJVPh3XFnpdhfY7El
MfK1i6w0/VHe2Ju4JoxU
=uDYp
-----END PGP SIGNATURE-----

--=-HS30b5uopgeU+b3iilN9--

