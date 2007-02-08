Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:40320 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423388AbXBHTCJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Feb 2007 14:02:09 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: [PATCH] d80211: use default flags on virtual interfaces
Date: Thu, 8 Feb 2007 14:01:35 -0500
Cc: "Jon Smirl" <jonsmirl@gmail.com>, linux-wireless@vger.kernel.org
References: <9e4733910702061846y3117ff20g9bf234b25cb91116@mail.gmail.com>
In-Reply-To: <9e4733910702061846y3117ff20g9bf234b25cb91116@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2690725.YtdeWuIFtD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702081401.39530.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2690725.YtdeWuIFtD
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

d80211: use default flags on virtual interfaces

There is no need to set dev->flags on virtual interfaces
during registration.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 net/d80211/ieee80211_iface.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/d80211/ieee80211_iface.c b/net/d80211/ieee80211_iface.c
index 3b2d259..342ad2a 100644
=2D-- a/net/d80211/ieee80211_iface.c
+++ b/net/d80211/ieee80211_iface.c
@@ -75,7 +75,6 @@ int ieee80211_if_add(struct net_device *
 	ndev->irq =3D dev->irq;
 	ndev->mem_start =3D dev->mem_start;
 	ndev->mem_end =3D dev->mem_end;
=2D	ndev->flags =3D dev->flags & IFF_MULTICAST;
 	SET_NETDEV_DEV(ndev, local->hw.dev);
=20
 	sdata =3D IEEE80211_DEV_TO_SUB_IF(ndev);

--nextPart2690725.YtdeWuIFtD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFy3OTT3Oqt9AH4aERAm+oAJ9oXx4TGLGYfprNdMUTbGrSaFg+kwCgiV5Q
OULKkqFG5rB7pVUdqDb4+OU=
=kXpo
-----END PGP SIGNATURE-----

--nextPart2690725.YtdeWuIFtD--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
