Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:46860 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbZDYOdV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 10:33:21 -0400
Date: Sat, 25 Apr 2009 10:32:25 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Greg KH <greg@kroah.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: [PATCH 6/8] drivers/staging/vt6655/device_main.c: Drop obsolete
	fsuid/fsgid accesses.
Message-ID: <20090425143225.GF11201@storm.local.network> (sfid-20090425_163323_297661_65310EA2)
References: <20090425001405.GB23173@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xkXJwpr35CY/Lc3I"
In-Reply-To: <20090425001405.GB23173@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--xkXJwpr35CY/Lc3I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

drivers/staging/vt6655/device_main.c: Drop obsolete fsuid/fsgid accesses.

Signed-off-by: Forest Bond <forest@alittletooquiet.net>
---
 drivers/staging/vt6655/device_main.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/=
device_main.c
index 0d6aec9..126ecef 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -3278,15 +3278,18 @@ int Config_FileOperation(PSDevice pDevice,BOOL fwri=
te,unsigned char *Parameter)
     UCHAR      tmpbuffer[20];
     struct file   *filp=3DNULL;
     mm_segment_t old_fs =3D get_fs();
-    int oldfsuid=3D0,oldfsgid=3D0;
+    //int oldfsuid=3D0,oldfsgid=3D0;
     int result=3D0;
=20
     set_fs (KERNEL_DS);
-//Make sure a caller can read or write power as root
-   oldfsuid=3Dcurrent->fsuid;
-   oldfsgid=3Dcurrent->fsgid;
-    current->fsuid =3D 0;
-    current->fsgid =3D 0;
+
+    /* Can't do this anymore, so we rely on correct filesystem permissions:
+    //Make sure a caller can read or write power as root
+    oldfsuid=3Dcurrent->cred->fsuid;
+    oldfsgid=3Dcurrent->cred->fsgid;
+    current->cred->fsuid =3D 0;
+    current->cred->fsgid =3D 0;
+    */
 =09
     //open file=20
       filp =3D filp_open(config_path, O_RDWR, 0);
@@ -3344,8 +3347,11 @@ error1:
=20
 error2:
   set_fs (old_fs);
-  current->fsuid=3Doldfsuid;
-  current->fsgid=3Doldfsgid;
+
+  /*
+  current->cred->fsuid=3Doldfsuid;
+  current->cred->fsgid=3Doldfsgid;
+  */
  =20
   return result;
 }
--=20
1.5.4.3


--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--xkXJwpr35CY/Lc3I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ8x75RO4fQQdv5AwRAnH4AJ49UTUh3yjyoZofFEWyho1SpMsqNwCdGeSm
zkrLSoR0q7aOOVQZ1jDrHT8=
=XT/S
-----END PGP SIGNATURE-----

--xkXJwpr35CY/Lc3I--
