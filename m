Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx34.mail.ru ([194.67.23.200]:34792 "EHLO mx34.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321AbYJZIVo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2008 04:21:44 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] orinoco: reload firmware on resume
Date: Sun, 26 Oct 2008 12:21:30 +0400
Cc: orinoco-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3969387.ihi6mhYcUl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200810261121.39445.arvidjaar@mail.ru> (sfid-20081026_092157_064792_40AE4ED1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3969387.ihi6mhYcUl
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=46rom: Andrey Borzenkov <arvidjaar@mail.ru>
Date: Sun, 12 Oct 2008 20:15:43 +0400
Subject: [PATCH 1/2] orinoco: reload firmware on resume

On resume card state is likely lost so we have to reload firmware
again.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
Acked-by: David Kilroy <kilroyd@googlemail.com>
=2D--

Resend against current wireless-testing

 drivers/net/wireless/orinoco.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index e0512e4..860803e 100644
=2D-- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -2301,6 +2301,11 @@ int orinoco_reinit_firmware(struct net_device *dev)
 	int err;
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
=2D-=20
1.6.0.2


--nextPart3969387.ihi6mhYcUl
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkEKIsACgkQR6LMutpd94ybnwCeJs3xWFXH4ML4P1jt458cc+Ku
5kEAoM/expuqHXuoOUooDJRk2R259tSW
=ypPS
-----END PGP SIGNATURE-----

--nextPart3969387.ihi6mhYcUl--
