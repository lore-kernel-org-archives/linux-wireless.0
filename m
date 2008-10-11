Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx34.mail.ru ([194.67.23.200]:12588 "EHLO mx34.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbYJKOQb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 10:16:31 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] orinoco: reload firmware on resume
Date: Sat, 11 Oct 2008 18:16:25 +0400
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5832335.gG2tU8qoRE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200810111816.26370.arvidjaar@mail.ru> (sfid-20081011_161636_841150_74888F14)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart5832335.gG2tU8qoRE
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On resume card state is likely lost so we have to reload firmware
again.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

This is non-functional without second patch. Currently you simply
have no way to load request firmware from user space in ->resume.

 drivers/net/wireless/orinoco.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)


diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 1f9dcc4..76c480b 100644
=2D-- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -2298,9 +2298,14 @@ int orinoco_reinit_firmware(struct net_device *dev)
 {
 	struct orinoco_private *priv =3D netdev_priv(dev);
 	struct hermes *hw =3D &priv->hw;
=2D	int err;
+	int err =3D 0;
=20
 	err =3D hermes_init(hw);
+	if (priv->do_fw_download && !err) {
+		err =3D orinoco_download(priv);
+		if (err)
+			priv->do_fw_download =3D 0;
+	}
 	if (!err)
 		err =3D orinoco_allocate_fid(dev);
=20
@@ -2926,12 +2931,6 @@ static void orinoco_reset(struct work_struct *work)
 		}
 	}
=20
=2D	if (priv->do_fw_download) {
=2D		err =3D orinoco_download(priv);
=2D		if (err)
=2D			priv->do_fw_download =3D 0;
=2D	}
=2D
 	err =3D orinoco_reinit_firmware(dev);
 	if (err) {
 		printk(KERN_ERR "%s: orinoco_reset: Error %d re-initializing firmware\n",

--nextPart5832335.gG2tU8qoRE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjwtToACgkQR6LMutpd94zVlACfbb0HANwuRSn4BtvMxMyUyAwf
tcsAn2YXjaVrA88CaBlUpy4up1mjhsNe
=ai7+
-----END PGP SIGNATURE-----

--nextPart5832335.gG2tU8qoRE--
