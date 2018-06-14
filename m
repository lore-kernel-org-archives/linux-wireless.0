Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:53120 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754660AbeFNSJD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 14:09:03 -0400
Date: Thu, 14 Jun 2018 20:08:11 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Wirz <spam@lukas-wirz.de>, linux-crypto@vger.kernel.org,
        b43-dev@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: [PATCH] hw_random: Always drop the RNG in hwrng_unregister()
Message-ID: <20180614200811.76401d95@wiggum> (sfid-20180614_200907_362327_7C33FA36)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/o9MEtdgag/F_5GhvuON5aV9"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/o9MEtdgag/F_5GhvuON5aV9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

enable_best_rng() is used in hwrng_unregister() to switch away from the
currently active RNG, if that is the one currently being removed.
However enable_best_rng() might fail, if the next RNG's init routine
fails. In that case enable_best_rng() will return an error code and
the currently active RNG will remain active.
After unregistering this might lead to crashes due to use-after-free.

Fix this by dropping the currently active RNG, if enable_best_rng()
failed. This will result in no RNG to be active, if the next-best
one failed to initialize.

This problem was introduced by 142a27f0a731ddcf467546960a5585970ca98e21


Reported-by: Wirz <spam@lukas-wirz.de>
Tested-by: Wirz <spam@lukas-wirz.de>
Signed-off-by: Michael B=C3=BCsch <m@bues.ch>
Cc: stable@vger.kernel.org

---

See this discussion for a crash in b43's hwrng caused by this problem:
https://www.spinics.net/lists/linux-wireless/msg173089.html



diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 91bb98c42a1c..aaf9e5afaad4 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -516,11 +516,18 @@ EXPORT_SYMBOL_GPL(hwrng_register);
=20
 void hwrng_unregister(struct hwrng *rng)
 {
+	int err;
+
 	mutex_lock(&rng_mutex);
=20
 	list_del(&rng->list);
-	if (current_rng =3D=3D rng)
-		enable_best_rng();
+	if (current_rng =3D=3D rng) {
+		err =3D enable_best_rng();
+		if (err) {
+			drop_current_rng();
+			cur_rng_set_by_user =3D 0;
+		}
+	}
=20
 	if (list_empty(&rng_list)) {
 		mutex_unlock(&rng_mutex);



--=20
Michael

--Sig_/o9MEtdgag/F_5GhvuON5aV9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIyBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlsirwsACgkQ9TK+HZCN
iw5T9w/4+1M/VDTJNOP7sEdhmZfMTp/NoSmvCH8FvmAXDkEonyR/G3TP+aesR4JW
dQ0nOOlqF6Op1tTh7CFg7fyRmXNRoDohVdrxfrnyWHGXNO7r7Lj2XfCDy4hsH34b
mp14uD0vBtHtG8xe8hr8wYlAMapD+Jxjo+LkcXJ6/DFaHe6qYX0jQxifzWx/rkMw
kjAoTqjpEYlTxKBqnVbx+9xandTli1URdz/QhurVYvq2cRsLx2iHkPioTZh49B4x
uwNvPUraIc6t8YG4wUBS1j32IjtBfT2pDrUfBOAnqnCKoMI1SDBJg4k7svFmTRZ/
B2TzybVNBQCFjnHwOy7MRTtQpcJL3Q9o/jrcxOwD3cA1ey9/6r0jwlEk2AVv0t/t
hNSUDyr5kyDbtqmkUf9zypQc+qMhAO14axNtlVXDF9NKwSyO3ernQIK06aVkNutq
924ozy1sLVZ5AjcXR0KG6/K0vjY83w9NOKVMBJu/hATVzvcPVImDvaMkgcVJzINj
5yLNDVfBMBczVQfZ/Ka6uTRqxLrsDtzlrWpTydS54q+lPAYwaRpboz8Lyud3B5Ub
EpXnDTbiCbTEoK+Tn6yblszQjUWqex13rwBXrYviE1oKybWUSsLM2WmosTRljI/v
V5PsGO5iAt5pvajPpFPlK7mxXI1FD3CEcYijhrKFBIwjhD+OPg==
=c2eY
-----END PGP SIGNATURE-----

--Sig_/o9MEtdgag/F_5GhvuON5aV9--
