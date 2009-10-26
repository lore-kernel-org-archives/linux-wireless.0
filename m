Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52255 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbZJZHQj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 03:16:39 -0400
Subject: libertas sdio firmware
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-nuCy2/5Kax8+UPKmAzTE"
Date: Mon, 26 Oct 2009 08:16:38 +0100
Message-ID: <1256541398.28230.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nuCy2/5Kax8+UPKmAzTE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Was just looking at the libertas driver and noticed that the SPI part
loads firmware as such:

snprintf(helper_fw, IF_SPI_FW_NAME_MAX, "libertas/gspi%d_hlp.bin", ...
etc.

while the SDIO part just uses
ret =3D request_firmware(&fw, card->helper, &card->func->dev);

which ends up requesting sd8686_helper.bin instead of
libertas/sd8686_helper.bin, as far as I can tell. That means the
linux-firmware git repo won't work out of the box, I think?

johannes

--=-nuCy2/5Kax8+UPKmAzTE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK5UzSAAoJEODzc/N7+QmaKoQQALysHRl9GJe2eqssqkDbUPse
oRPzYc6qJ/B2yDmbFucikoPiPKbU1OfEhPug5G/Rmm8J2aBSXgk0i88fVmE++lY0
N5ZWpr3XnkmA6oAqqw0QBf0ylKchnaYI1T406mit/eUbOu8TQTnLHko1YLnTbKlo
L/inncJaFs79tlKZqVt0OrWUlOH1qlVAhkieB+jrWuR5f04TSeHITOdTs8GUOsub
/Lt/KdKM1h2HvgqZVfJ8bqS8dukwn3PTy0d6Q44SJtMaTpowhNMms79yFAE22+2q
ADlPNcWbiGIjeFV0EirsO365HOVmykMWpr8RI44kzqegr/mXf4OoaONy+RbW/KpY
Su56qU7dfOJ6LnYAW9M+z9cW0YqKTGLIBYMgbiEz7SBJDg6N1LQVS5u7DnzVMNRt
hvIWQLDh3Sqi3oHFFTO8gbvtvMaPjDY3j/b/5g0ivxkrKBgohBerMYssw/C6dWx8
UmS9g+B+NlCKTipl/B70t/fa6geamwG35nZTz98CU+Kp3iga/EEa6dTmokhW7OYV
mHW2VKKts2riNS97xJcy7g8pNm8EczpAbLJiE/SzKsRsU+od1BHnvc0ZZovozJVS
q3K4s3vRTB5DjrzhPTslAWRFVXxHbYoMdCE6iPsYovXo2uc1PTp5VU/1XKNiAErm
uGADiXqpv3XGQ8ik2jNZ
=JxI0
-----END PGP SIGNATURE-----

--=-nuCy2/5Kax8+UPKmAzTE--

