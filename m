Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from flock1.newmail.ru ([82.204.219.207]:33172 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753176AbZAURrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 12:47:21 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: [PATCH] orinoco: convert to struct net_device_ops
Date: Wed, 21 Jan 2009 20:46:46 +0300
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1290244.EvLgf1T3Yt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200901212046.48426.arvidjaar@mail.ru> (sfid-20090121_184727_221865_C2B2ABE8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1290244.EvLgf1T3Yt
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Subject: [PATCH] orinoco: convert to struct net_device_ops
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

No functional changes; use new kernel interface for netdev methods.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

 drivers/net/wireless/orinoco/orinoco.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)


diff --git a/drivers/net/wireless/orinoco/orinoco.c=20
b/drivers/net/wireless/orinoco/orinoco.c
index 39eab39..d1207d0 100644
=2D-- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -3582,6 +3582,17 @@ static int orinoco_init(struct net_device *dev)
 	return err;
 }
=20
+static const struct net_device_ops orinoco_netdev_ops =3D {
+	.ndo_init		=3D orinoco_init,
+	.ndo_open		=3D orinoco_open,
+	.ndo_stop		=3D orinoco_stop,
+	.ndo_start_xmit		=3D orinoco_xmit,
+	.ndo_set_multicast_list	=3D orinoco_set_multicast_list,
+	.ndo_change_mtu		=3D orinoco_change_mtu,
+	.ndo_tx_timeout		=3D orinoco_tx_timeout,
+	.ndo_get_stats		=3D orinoco_get_stats,
+};
+
 struct net_device
 *alloc_orinocodev(int sizeof_card,
 		  struct device *device,
@@ -3604,27 +3615,20 @@ struct net_device
 	priv->dev =3D device;
=20
 	/* Setup / override net_device fields */
=2D	dev->init =3D orinoco_init;
=2D	dev->hard_start_xmit =3D orinoco_xmit;
=2D	dev->tx_timeout =3D orinoco_tx_timeout;
+	dev->netdev_ops =3D &orinoco_netdev_ops;
 	dev->watchdog_timeo =3D HZ; /* 1 second timeout */
=2D	dev->get_stats =3D orinoco_get_stats;
 	dev->ethtool_ops =3D &orinoco_ethtool_ops;
 	dev->wireless_handlers =3D (struct iw_handler_def *)&orinoco_handler_def;
 #ifdef WIRELESS_SPY
 	priv->wireless_data.spy_data =3D &priv->spy_data;
 	dev->wireless_data =3D &priv->wireless_data;
 #endif
=2D	dev->change_mtu =3D orinoco_change_mtu;
=2D	dev->set_multicast_list =3D orinoco_set_multicast_list;
 	/* we use the default eth_mac_addr for setting the MAC addr */
=20
 	/* Reserve space in skb for the SNAP header */
 	dev->hard_header_len +=3D ENCAPS_OVERHEAD;
=20
 	/* Set up default callbacks */
=2D	dev->open =3D orinoco_open;
=2D	dev->stop =3D orinoco_stop;
 	priv->hard_reset =3D hard_reset;
 	priv->stop_fw =3D stop_fw;
=20


--nextPart1290244.EvLgf1T3Yt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl3X4gACgkQR6LMutpd94w+zgCeI4KRxTvOjDbY3P0500+e0o8f
BTcAoMatTQoDaZZCShB6bLNHTjw7U2/a
=MT12
-----END PGP SIGNATURE-----

--nextPart1290244.EvLgf1T3Yt--
