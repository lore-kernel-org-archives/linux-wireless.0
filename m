Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:20481 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754014AbXDMOUQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2007 10:20:16 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] eeprom_93cx6: do not assume zeroed buffer
Date: Fri, 13 Apr 2007 10:17:17 -0400
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Andrea Merello <andreamrl@tiscali.it>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart11651608.HygmggYRyD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704131017.22525.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart11651608.HygmggYRyD
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

eeprom_93cx6: do not assume zeroed buffer

=46rom: Michael Wu <flamingice@sourmilk.net>

eeprom_93cx6_read_bits assumes u16 *data is already zeroed. This removes
that assumption.

Thanks to Andrea Merello <andreamrl@tiscali.it> for discovering this issue.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 drivers/misc/eeprom_93cx6.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/eeprom_93cx6.c b/drivers/misc/eeprom_93cx6.c
index e5d016b..a948ddc 100644
=2D-- a/drivers/misc/eeprom_93cx6.c
+++ b/drivers/misc/eeprom_93cx6.c
@@ -127,6 +127,7 @@ static void eeprom_93cx6_read_bits(struct eeprom_93cx6=
=20
*eeprom,
 	u16 *data, const u16 count)
 {
 	unsigned int i;
+	u16 buf =3D 0;
=20
 	eeprom->register_read(eeprom);
=20
@@ -153,10 +154,12 @@ static void eeprom_93cx6_read_bits(struct eeprom_93cx=
6=20
*eeprom,
 		 * Read if the bit has been set.
 		 */
 		if (eeprom->reg_data_out)
=2D			*data |=3D (1 << (i - 1));
+			buf |=3D (1 << (i - 1));
=20
 		eeprom_93cx6_pulse_low(eeprom);
 	}
+
+	*data =3D buf;
 }
=20
 static void eeprom_93cx6_ewen(struct eeprom_93cx6 *eeprom)

--nextPart11651608.HygmggYRyD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGH5DyT3Oqt9AH4aERAqsQAJ9E2xP0zQEQ58laW5qEWma9AHdjNQCcDAtY
qGxu62jKVPXiechmo/KYIPY=
=f13t
-----END PGP SIGNATURE-----

--nextPart11651608.HygmggYRyD--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
