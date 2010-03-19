Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52403 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751953Ab0CSBQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 21:16:03 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Cyril Brulebois <kibi@debian.org>, 574526@bugs.debian.org
In-Reply-To: <20100318200535.5639.6476.reportbug@bowmore>
References: <20100318200535.5639.6476.reportbug@bowmore>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6rIPjC1p8J7lPV0VP8/c"
Date: Fri, 19 Mar 2010 01:15:58 +0000
Message-ID: <1268961358.18314.43.camel@localhost>
Mime-Version: 1.0
Subject: Re: Bug#574526: linux-image-2.6.32-4-amd64: iwlagn flood in dmesg:
 free more than tfds_in_queue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6rIPjC1p8J7lPV0VP8/c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-03-18 at 21:05 +0100, Cyril Brulebois wrote:
> Package: linux-2.6
> Version: 2.6.32-10
> Severity: normal
>=20
> Hi,
>=20
> it looks like the following upstream commits lead to those repeated
> messages, as soon as there's some traffic on the wireless network:
> | [ 3538.284491] iwlagn 0000:02:00.0: free more than tfds_in_queue (1:2)
> | [ 3538.285838] iwlagn 0000:02:00.0: free more than tfds_in_queue (1:2)
> | [ 3538.286666] iwlagn 0000:02:00.0: free more than tfds_in_queue (1:2)
> | [ 3538.298152] iwlagn 0000:02:00.0: free more than tfds_in_queue (0:2)
> | [ 3538.299241] iwlagn 0000:02:00.0: free more than tfds_in_queue (1:2)
>=20
> master   : a120e912eb51e347f36c71b60a1d13af74d30e83
> 2.6.32.y : 44af042e42f2231579ea8ef7586d3789d198f609
>=20
> | $ git show v2.6.32.9-12-g44af042
> | commit 44af042e42f2231579ea8ef7586d3789d198f609
> | Author: Stanislaw Gruszka <sgruszka@redhat.com>
> | Date:   Fri Feb 19 15:47:33 2010 -0800
> |=20
> |     iwlwifi: sanity check before counting number of tfds can be free
[...]

Stanislaw, do you understand how this is going wrong?  Do you have a
fix?

Ben.

--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-6rIPjC1p8J7lPV0VP8/c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS6LQTee/yOyVhhEJAQK3mA//WRrC/RriliQc22NheKAn36C0YMAqTOQX
4wVVPDg/DB4+C118Dd4sZVkkhEuCj0H7OjcuHAitK84GGchIv19a8kfM8JqCTAhT
fpzZv9D1145AHiMfUJsWgyFHdJNyoRrFf4YAummJhGqcNLSzYbmTc7sEqVlyK/e4
vo5Qum5jf+BIa8K6lguDr0QczyAko127czLsrbbgS31PElyv/+bEsInI4hGlAffr
bne6B8De6U+8O45NM+EvPBv2WMqF31QyMWxq+7w/te65EUu+i1Hrte651gEcgOcG
ofB1Wsb3D7PW2yntodgAl9SFaEXamP8xR5oC0P4z7BZ5SnGbnckOqHunNkWO0jsk
fTOKgqrF21jC4oIPA34UiJazZCcCtfF1oEISYlRPe9nOa7bpirXQOVzJVky+uFw9
luhQJ/CKYT/NkjhChDv8bOwsUDRLzXA5MlATgpIy2np/3osMqigwZ4hRXvOrsN6g
Z/FtDFelK1BgKaqsIojX4mqaPw1sXX1LNA21FUgBpXfYqqTU2eKUP/MyYHDYq5XS
Uw8JmyXBta3BTymyeGmh3P6IqQeBORP8/PRvKcrgvNLSuQedi/ppphH7AORxKqYv
Xc5oi0ad16l+YcyiH61lrDMSR0LIPLGJ7UAopTo60vA7x2V5VGsnEKtvsahiQTwY
1tXyuT+uYTY=
=hnlc
-----END PGP SIGNATURE-----

--=-6rIPjC1p8J7lPV0VP8/c--
