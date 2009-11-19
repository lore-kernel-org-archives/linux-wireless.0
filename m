Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:53566 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686AbZKSWJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 17:09:28 -0500
To: linville@tuxdriver.com
Subject: [PATCH] ath5k: Fix I/Q calibration
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
Cc: linux-wireless@vger.kernel.org
Date: Thu, 19 Nov 2009 23:02:02 +0100
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1998335.VECOoIYzg9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200911192302.05229.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1998335.VECOoIYzg9
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

The sign of correction coefficients was lost in the calculations, which
caused high packetloss in 802.11a mode after the results were applied.
=46ixed by removing unneccesary and broken AND with a bit mask.

Signed-off-by: Lukas Turek <8an@praha12.net>
=2D--
 drivers/net/wireless/ath/ath5k/phy.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/at=
h/ath5k/phy.c
index 8959907..6af0a73 100644
=2D-- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1399,7 +1399,7 @@ static int ath5k_hw_rf511x_calibrate(struct ath5k_hw =
*ah,
 	if (i_coffd =3D=3D 0 || q_coffd =3D=3D 0)
 		goto done;
=20
=2D	i_coff =3D ((-iq_corr) / i_coffd) & 0x3f;
+	i_coff =3D ((-iq_corr) / i_coffd);
=20
 	/* Boundary check */
 	if (i_coff > 31)
@@ -1407,7 +1407,7 @@ static int ath5k_hw_rf511x_calibrate(struct ath5k_hw =
*ah,
 	if (i_coff < -32)
 		i_coff =3D -32;
=20
=2D	q_coff =3D (((s32)i_pwr / q_coffd) - 128) & 0x1f;
+	q_coff =3D (((s32)i_pwr / q_coffd) - 128);
=20
 	/* Boundary check */
 	if (q_coff > 15)
=2D-=20
1.6.4.4

=2D-
Lukas Turek

--nextPart1998335.VECOoIYzg9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLBcBdAAoJEEBjvk/UOfYwJH4P/An9NMoB8QQipmn08B4iN7Nn
tOJsr51YKWWdqcnX+L86M3wklyUsvA3QlhgWC9agpdd6gljWQq1nc+5kna9PAklj
JbGJLQk9C9wcdaps0g4LqTKaxtbAGh+9gRH5eeaBIS7y3uDAcJkWIrHnWtQ0Gs47
NM8oNfrbn5RJQGfxhakiVkVVO06CcEqJlnZtjmV6QUPCqLDqO0SgnuAVMYrH6X+b
6i9RuSk+dH55zaJqazSsBpLzGOZzW9f2Mrm9fR9u9xt6BEL0T68ZJlpIAOhc5Ubu
mure5yUhMj8UZ4iA3Ywq/wX/qTYagu8Tm9qOh4XTyDaVjjBLF2KTsHVratkD5LgM
nK2w6lQJl3mkIRuisoNLzxwzriw+2UrtPMA7xxIPGBhJA74AhtLz5IryaUn6lWRR
KLrnpm7DRY50OqdrZjO5jmpYfliBjsc9OmY1YFaaCEQVf3AWqih+soD83sJ06zl0
bDgXtNq9RR1xnJ95xME8/w+k9caRjEunMYl56z0WdNlusSGbNS2gdyGKYKZCvCnY
UIMzxqy/JOn9fqC9D32z+xEhwFZQCaP3i+6ycdgJGpOEVOoo2w6BTvJPunja54Qq
DpGuIRfPCZ/1S7sSSIFrZvk+BkVz1BflEbkh4rqgKvwKUkXE4yDxKsOvTKEnM6S9
WFQ+dW9U8meuNrnewBaO
=Eas8
-----END PGP SIGNATURE-----

--nextPart1998335.VECOoIYzg9--
