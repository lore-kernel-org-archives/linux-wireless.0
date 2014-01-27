Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:48057 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbaA0TNt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 14:13:49 -0500
Message-ID: <52E6AF97.4040602@meshcoding.com> (sfid-20140127_201354_259169_E9E5F20F)
Date: Mon, 27 Jan 2014 20:12:23 +0100
From: Antonio Quartulli <antonio@meshcoding.com>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>, mail@fuerstflorian.de,
	ath9k-devel@lists.ath9k.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [ath9k-devel] [BUG] Atheros AR7010+AR9287: Scheduling while atomic:
 ksoftirqd/0/3/0x00000302
References: <trinity-b8018ef9-8037-4688-a363-2deb3aed68fc-1390501815918@3capp-1and1-bs02> <52E1712B.70202@rempel-privat.de>, <52E191B3.2070601@meshcoding.com>, <trinity-14f555a0-3945-448b-a908-b12f1cb532e3-1390546291559@3capp-1and1-bs03> <trinity-c1a620e7-f7e8-4bb0-b583-b36b6fa6bfd8-1390546555391@3capp-1and1-bs03> <52E6AD5C.3020005@rempel-privat.de>
In-Reply-To: <52E6AD5C.3020005@rempel-privat.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FV1GsER4V2setXQJqNXGrEWNXVVFTlKuS"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FV1GsER4V2setXQJqNXGrEWNXVVFTlKuS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 27/01/14 20:02, Oleksij Rempel wrote:
> Hi Johannes,
>=20
> i found this bug report with your response:
> https://bugzilla.redhat.com/show_bug.cgi?id=3D990955
> "I don't think adding a workqueue is a good idea because that would
> significantly delay the calls in many situations."
>=20
> The problem on ath9k_htc is that the call is already dramatically
> delayed. It will try to send WMI command over USB with delay of some
> _msec_ not usec. There are two options right now, use workqueue or do
> not support sta_rc_update.
>=20

Unfortunately not supporting sta_rc_update() means making adhoc mode
unusable.. :(


Cheers,


--=20
Antonio Quartulli


--FV1GsER4V2setXQJqNXGrEWNXVVFTlKuS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS5q+cAAoJEEKTMo6mOh1V4JQQAKCqzGq1Jr2DJaT+9G3DH3Jo
eGrGcbfPqH0Y9fYt/kDBq9NI2MrF4kNnhgdgwAtqnpTHl2V4kT3+QL77WVzpUbKJ
1NfdmowkSR6flBpdHKNTmM3W+JHqX6PDchzINsUJHpy4J44PiO1c8xKCVbL3REmI
urdlHEoW9lS9UpKSriXkOOwUtexKloa0zIV414dtN0AIxQVIktLf9k0mW0CH2cFS
wkf45PzVF/VZNLOcwjGdL8FXLYQb3NU3RBU/n4rjEu32wYaU6XvnEQSJT7eyn3ft
MbDNZ1jRL5LeJ33PTnt8ePjlPrnZkqP8x14q+Fppxr37N/ZcZFGfRO8EMeIjMkcE
RB8iFq7zg1COUH9k+iMYxCt6hja1k3Wpe9tpmr9jco/UQr5wrtUCtIxvVrKme003
L/zTw1nu27ab9aEKoqGx/6+w2o5gAjkzkvW+kqFEzzRr3lO2LnjsN6qk2+8K9CeV
AO/hciosbndAeqSNgYaU5ZHUjB5Md1mdQla0OGdIxSVlqBQJau92X3BcQur07kna
HS7rsxPMMliQ3m8uHB5orBB3ffpwqeM65Zoj7SRZjDevz0yegW8ct36+FzimcYMD
TqLJX4MBSktQkI6rVESIeQmXvNIJfsyl/cdSMiDw1SsbRGi11/IqRbm8zGMKJdq7
FSCNjNHH384OWJmplhIC
=NWWH
-----END PGP SIGNATURE-----

--FV1GsER4V2setXQJqNXGrEWNXVVFTlKuS--
