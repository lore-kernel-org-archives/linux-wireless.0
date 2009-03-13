Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jabberwock.vm.bytemark.co.uk ([80.68.92.224]:57099 "EHLO
	jabberwock.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759789AbZCMWPl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 18:15:41 -0400
Message-ID: <49BAD5A8.4040406@f2s.com> (sfid-20090313_231546_866584_3B0EE51B)
Date: Fri, 13 Mar 2009 21:52:40 +0000
From: Max Bowsher <maxb@f2s.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
CC: linux-wireless@vger.kernel.org
Subject: [PATCH] compat-2.6: Fix admin-update.sh creating spurious include/linux/unaligned/unaligned/
 directory
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDCDF0A3BC156BB2F71050DDF"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDCDF0A3BC156BB2F71050DDF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I noticed that if compat-wireless-2.6's admin-update.sh is run twice in
a row without cleaning, it erroneously copies the
include/linux/unaligned/* files into an
include/linux/unaligned/unaligned/ directory.

Patch below making trivial changes to the script to avoid this.

Thanks,
Max.

If admin-update.sh was run twice without an admin-clean.sh, a spurious
additional /unaligned/ path component was created.
---
 scripts/admin-update.sh |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 8eeef89..b40a5d6 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -67,6 +67,7 @@ DRIVER_FILES=3D"$DRIVER_FILES mac80211_hwsim.c"
 DRIVER_FILES=3D"$DRIVER_FILES at76c50x-usb.c at76c50x-usb.h"

 mkdir -p include/linux/ include/net/ include/linux/usb \
+	include/linux/unaligned \
 	net/mac80211/ net/wireless/ \
 	drivers/ssb/ \
 	drivers/net/usb/ \
@@ -139,7 +140,7 @@ cp $GIT_TREE/$DIR/Makefile $DIR

 DIR=3D"include/linux/unaligned"
 echo "Copying $GIT_TREE/$DIR/*"
-cp -a $GIT_TREE/$DIR $DIR
+cp $GIT_TREE/$DIR/* $DIR


 # Compat stuff
--=20
1.6.0.4



--------------enigDCDF0A3BC156BB2F71050DDF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkm61a8ACgkQfFNSmcDyxYD7bQCfWiAWc/T9y9hdh420ojCijECL
GW8AoNaYK+jFOQtDDM3Z0uaMr81Q4/si
=2868
-----END PGP SIGNATURE-----

--------------enigDCDF0A3BC156BB2F71050DDF--
