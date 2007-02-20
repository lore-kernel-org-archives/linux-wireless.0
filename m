Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:30811 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161071AbXBTXOR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Feb 2007 18:14:17 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] d80211: Fix ieee80211_ptr check
Date: Tue, 20 Feb 2007 18:13:54 -0500
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6663935.yXXaduvpZi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702201813.58453.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart6663935.yXXaduvpZi
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

d80211: Fix ieee80211_ptr check

dev->ieee80211_ptr can no longer be directly compared to check if a virtual
interface belongs to a master device.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 net/d80211/ieee80211.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
index adce657..70eb9be 100644
=2D-- a/net/d80211/ieee80211.c
+++ b/net/d80211/ieee80211.c
@@ -1093,7 +1093,8 @@ __ieee80211_tx_prepare(struct ieee80211_
 static int inline is_ieee80211_device(struct net_device *dev,
 				      struct net_device *master)
 {
=2D	return (dev->ieee80211_ptr =3D=3D master->ieee80211_ptr);
+	return (wdev_priv(dev->ieee80211_ptr) =3D=3D
+		wdev_priv(master->ieee80211_ptr));
 }
=20
 /* Device in tx->dev has a reference added; use dev_put(tx->dev) when

--nextPart6663935.yXXaduvpZi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF24C2T3Oqt9AH4aERAoqWAJsGHqEhpnF11x2cL/IXvXMNojGm4gCgoPcQ
9JHGaI8zCEdk/NAJ8XEkLIY=
=glRQ
-----END PGP SIGNATURE-----

--nextPart6663935.yXXaduvpZi--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
