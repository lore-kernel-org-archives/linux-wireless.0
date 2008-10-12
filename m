Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx39.mail.ru ([194.67.23.35]:63165 "EHLO mx39.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbYJLMgj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Oct 2008 08:36:39 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Dave <kilroyd@googlemail.com>
Subject: Re: [PATCH 1/2] orinoco: reload firmware on resume
Date: Sun, 12 Oct 2008 16:36:32 +0400
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200810111816.26370.arvidjaar@mail.ru> <48F0E58F.6000900@gmail.com>
In-Reply-To: <48F0E58F.6000900@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1443118.T3mVs5FPmo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200810121636.34373.arvidjaar@mail.ru> (sfid-20081012_143644_166600_DB732FAE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1443118.T3mVs5FPmo
Content-Type: multipart/mixed;
  boundary="Boundary-01=_S9e8IcaGX9sVbsr"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_S9e8IcaGX9sVbsr
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 11 October 2008, Dave wrote:
> > -	int err;
> > +	int err =3D 0;
>=20

=46ixed version attached.

--Boundary-01=_S9e8IcaGX9sVbsr
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="01-orinoco-reload-firmware-on-resume"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="01-orinoco-reload-firmware-on-resume"

Subject: [PATCH] orinoco: reload firmware on resume
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

On resume card state is likely lost so we have to reload firmware
again.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

 drivers/net/wireless/orinoco.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)


diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 3053605..7284ff5 100644
=2D-- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -2317,6 +2317,11 @@ int orinoco_reinit_firmware(struct net_device *dev)
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
@@ -2942,12 +2947,6 @@ static void orinoco_reset(struct work_struct *work)
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

--Boundary-01=_S9e8IcaGX9sVbsr--

--nextPart1443118.T3mVs5FPmo
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjx71IACgkQR6LMutpd94z0OQCgnbhO6Hn5+6AJIz72ryPenAWC
whMAoKbEYncMoi6HXAkNihYkZ5DSb4FM
=R1XW
-----END PGP SIGNATURE-----

--nextPart1443118.T3mVs5FPmo--
