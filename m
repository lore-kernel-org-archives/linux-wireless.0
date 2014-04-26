Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39235 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716AbaDZU7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2014 16:59:17 -0400
Message-ID: <1398545944.7767.226.camel@deadeye.wl.decadent.org.uk> (sfid-20140426_231015_694927_D3A6BCE9)
Subject: [PATCH] rtl8192cu: Fix unbalanced irq enable in error path of
 rtl92cu_hw_init()
From: Ben Hutchings <ben@decadent.org.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	stable <stable@vger.kernel.org>
Date: Sat, 26 Apr 2014 21:59:04 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-YufWzz+q9HgJhj8aHdbR"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YufWzz+q9HgJhj8aHdbR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Fixes: a53268be0cb9 ('rtlwifi: rtl8192cu: Fix too long disable of IRQs')
Cc: stable@vger.kernel.org
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wire=
less/rtlwifi/rtl8192cu/hw.c
index 68b5c7e..07cb06d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1001,7 +1001,7 @@ int rtl92cu_hw_init(struct ieee80211_hw *hw)
 	err =3D _rtl92cu_init_mac(hw);
 	if (err) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "init mac failed!\n");
-		return err;
+		goto exit;
 	}
 	err =3D rtl92c_download_fw(hw);
 	if (err) {

--=20
Ben Hutchings
The most exhausting thing in life is being insincere. - Anne Morrow Lindber=
g

--=-YufWzz+q9HgJhj8aHdbR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAU1weGOe/yOyVhhEJAQr78A//fhmopCnsyt30Xr6y0wwBi3mG0PWWdO4e
ejGBdzzjXdJxdAlIh+Vf0otUBezY/x20KRuJBF3wZI3zPVrXXgbQJUEOybKjP0v1
DC6vOAsk1qnB/4KpqGyNC726cd61GhpEMsaxS+eMEJsDl/GX1R2X2YYjjJ45Ut3w
T0Cn0uwP2ivjV9BKp8aB9ST4crOu0garcT/UK450lK2GrOgYDSPNfL4dpW+YKJrg
RjYUm+FM3DDpe+hFTFjYk7vlDaQjBdMd0sQcBEz25p9/8e9XjSxT9NoINTtMsoaO
1YdbiAvgxnHluHLn5ILCMrcQNhSHvnF82/N9e7ptRty+icKaG6Y0biW52sb8r7J/
VE8NdhYBnHzss3uV58EkaQRevdtaAf/N/I7Nlbt0rsh9AjbC+ZDHpTZyAleJw5kK
cVflnX/RZYT1xn98oxOHKBKx5dI5uiy2X5Q+if4/otbLnxwbMRKJWDC8rhq9X1MQ
WsELcu8/OQrQ+tdAdIf9j9mP24GIUahiqeydGqzoZ7amcwrRI9Vl0Sh+0tJNIJag
a6mjOH7YhQtEEOPR5tpIgdeEh28EkOnm6VGvxudJzKfj3bUKcWlbIJ2dCD4H9q+m
VPNPR/SDdpvvFvdzHAnky47tOFTYoOCz3R2Zb0G8AKnBykN9hFucjDv2H1RgE9nr
4dG+U/XguM8=
=RI8d
-----END PGP SIGNATURE-----

--=-YufWzz+q9HgJhj8aHdbR--
