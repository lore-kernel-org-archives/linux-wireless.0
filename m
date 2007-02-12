Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:25447 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932881AbXBLDOF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 22:14:05 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Michael Buesch <mb@bu3sch.de>
Subject: [PATCH] bcm43xx-d80211: update to new statistics reporting API
Date: Sun, 11 Feb 2007 22:13:29 -0500
Cc: linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2664391.qfmHJqWRIa";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702112213.29648.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2664391.qfmHJqWRIa
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

bcm43xx-d80211: update to new statistics reporting API

This patch updates bcm43xx-d80211 to the new statistics reporting API.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c=20
b/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c
index 9f4d51d..054ea09 100644
=2D-- a/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c
+++ b/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c
@@ -3560,7 +3560,9 @@ static int bcm43xx_wireless_init(struct
 		    IEEE80211_HW_MONITOR_DURING_OPER |
 		    IEEE80211_HW_DEVICE_HIDES_WEP |
 		    IEEE80211_HW_WEP_INCLUDE_IV;
=2D	hw->maxssi =3D BCM43xx_RX_MAX_SSI;
+	hw->max_rssi =3D -110;
+	hw->max_signal =3D BCM43xx_RX_MAX_SSI;
+	hw->max_noise =3D -110;
 	hw->queues =3D 1;
 	hw->dev =3D &dev->dev;
 	if (is_valid_ether_addr(sprom->r1.et1mac)) {

--nextPart2664391.qfmHJqWRIa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFz9tZT3Oqt9AH4aERAoE0AJ9R8tZsFsS3PfRbmF3YN1FQ+/bW5QCbBb7N
mDQPLYRFJJ0N3AXNhoq7wcM=
=leYK
-----END PGP SIGNATURE-----

--nextPart2664391.qfmHJqWRIa--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
