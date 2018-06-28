Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([203.11.71.1]:52089 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751100AbeF1E7Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jun 2018 00:59:16 -0400
Date: Thu, 28 Jun 2018 14:59:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Wilcox <willy@infradead.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: linux-next: manual merge of the xarray tree with the
 wireless-drivers-next tree
Message-ID: <20180628145900.4ca1e648@canb.auug.org.au> (sfid-20180628_065931_010759_000443E4)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/w0UTs=DoWUojtQpEhHHC5tx"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/w0UTs=DoWUojtQpEhHHC5tx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xarray tree got a conflict in:

  lib/Kconfig.debug

between commit:

  0e2dc70e3d0d ("bitfield: add tests")

from the wireless-drivers-next tree and commit:

  d968f529e39f ("xarray: Add XArray load operation")

from the xarray tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc lib/Kconfig.debug
index f2be7503f87c,df1ea92d924c..000000000000
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@@ -1802,13 -1802,9 +1802,16 @@@ config TEST_BITMA
 =20
  	  If unsure, say N.
 =20
 +config TEST_BITFIELD
 +	tristate "Test bitfield functions at runtime"
 +	help
 +	  Enable this option to test the bitfield functions at boot.
 +
 +	  If unsure, say N.
 +
+ config TEST_XARRAY
+ 	tristate "Test the XArray code at runtime"
+=20
  config TEST_UUID
  	tristate "Test functions located in the uuid module at runtime"
 =20

--Sig_/w0UTs=DoWUojtQpEhHHC5tx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAls0axQACgkQAVBC80lX
0Gxt7wf+NCxfGPR4S0spDyVUqdi2K48ZHk3jqA+yYRzhX025g0bRG1in3ZO7H74n
AIFM5rgATSQPlGuXa4qgZzzKhRHvDAPYf4LuFL3M/Usqa3M187AVt6cgFZBf78QA
oD6ypzvECVpShj5tZQihwdEegBxib9ZdQOXu+8m6VFMaZiPVeCsNQ5nOh7q7zyR5
RpzUbTbEwAB6K8fZuW2Y/HomKyJruhkMbJ1CCBSi6eGQhKAuh+A5OMdQ8AXxfIAG
1Cg83FHhb/az1YwyzQQHLr3mVyFee54SXTyLmzbw2QKcluH6QEHQ4Hw1A7Szzv2+
Nf88LhwOs0NorXjVw4iCrwioOqAKVQ==
=AT++
-----END PGP SIGNATURE-----

--Sig_/w0UTs=DoWUojtQpEhHHC5tx--
