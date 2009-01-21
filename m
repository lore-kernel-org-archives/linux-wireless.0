Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from flock1.newmail.ru ([82.204.219.207]:47192 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752718AbZAUSzj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 13:55:39 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: [PATCH] orinoco: trivial cleanup in alloc_orinocodev
Date: Wed, 21 Jan 2009 21:55:29 +0300
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10025835.W8SQ1yIznC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200901212155.32754.arvidjaar@mail.ru> (sfid-20090121_195550_388146_87D089BA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart10025835.W8SQ1yIznC
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Subject: [PATCH] orinoco: trivial cleanup in alloc_orinocodev
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

Remove extra space; remove redundant cast

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

This is on top of previous patch for struct net_device_ops.

 drivers/net/wireless/orinoco/orinoco.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/net/wireless/orinoco/orinoco.c=20
b/drivers/net/wireless/orinoco/orinoco.c
index d1207d0..497f324 100644
=2D-- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -3603,7 +3603,7 @@ struct net_device
 	struct orinoco_private *priv;
=20
 	dev =3D alloc_etherdev(sizeof(struct orinoco_private) + sizeof_card);
=2D	if (! dev)
+	if (!dev)
 		return NULL;
 	priv =3D netdev_priv(dev);
 	priv->ndev =3D dev;
@@ -3618,7 +3618,7 @@ struct net_device
 	dev->netdev_ops =3D &orinoco_netdev_ops;
 	dev->watchdog_timeo =3D HZ; /* 1 second timeout */
 	dev->ethtool_ops =3D &orinoco_ethtool_ops;
=2D	dev->wireless_handlers =3D (struct iw_handler_def *)&orinoco_handler_de=
f;
+	dev->wireless_handlers =3D &orinoco_handler_def;
 #ifdef WIRELESS_SPY
 	priv->wireless_data.spy_data =3D &priv->spy_data;
 	dev->wireless_data =3D &priv->wireless_data;


--nextPart10025835.W8SQ1yIznC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl3b6QACgkQR6LMutpd94xY2QCfZFRxE+77ZV6vl2A8lxu60Y8L
V/oAn1RMDhxCKaitVtfrln+y4yVJY9AG
=rkvQ
-----END PGP SIGNATURE-----

--nextPart10025835.W8SQ1yIznC--
