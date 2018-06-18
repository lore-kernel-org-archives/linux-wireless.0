Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([203.11.71.1]:46861 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752651AbeFRBaF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Jun 2018 21:30:05 -0400
Date: Mon, 18 Jun 2018 11:29:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Johannes Berg <johannes@sipsolutions.net>,
        Wireless <linux-wireless@vger.kernel.org>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: linux-next: manual merge of the mac80211-next tree with Linus' tree
Message-ID: <20180618112943.4ceadf24@canb.auug.org.au> (sfid-20180618_033043_828694_C0FF372F)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/T4UnYjLzyJs=UM7dPDwrnvl"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/T4UnYjLzyJs=UM7dPDwrnvl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mac80211-next tree got a conflict in:

  net/mac80211/scan.c

between commit:

  6396bb221514 ("treewide: kzalloc() -> kcalloc()")

from Linus' tree and commit:

  b9771d41aee7 ("mac80211: support scan features for improved scan privacy")

from the mac80211-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/mac80211/scan.c
index 2e917a6d239d,ae77d1c12856..000000000000
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@@ -1157,7 -1197,10 +1197,10 @@@ int __ieee80211_request_sched_scan_star
  		}
  	}
 =20
+ 	if (req->flags & NL80211_SCAN_FLAG_MIN_PREQ_CONTENT)
+ 		flags |=3D IEEE80211_PROBE_FLAG_MIN_CONTENT;
+=20
 -	ie =3D kzalloc(num_bands * iebufsz, GFP_KERNEL);
 +	ie =3D kcalloc(iebufsz, num_bands, GFP_KERNEL);
  	if (!ie) {
  		ret =3D -ENOMEM;
  		goto out;

--Sig_/T4UnYjLzyJs=UM7dPDwrnvl
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlsnCwcACgkQAVBC80lX
0GyqXgf9He+f7tztUphMYK0BvO1ZXCa9ZTbKoUvzy973dn07ZgaJFAgF5dbwcr+9
8XvLxHWbzUEwXYUSxTqZIQQdqFEnBlSeY58sxKoBYCOzQCWHH8CdZTnKEwAoZrDX
LYBtLob2E1UTHQoCti7Mtf3Pd6SuuPsLkmxnGEVuKFcA16tu7H/n62Cw3Y2FpiXx
+tQrMpIX16D9YYbwnFw7QEdzaqphZV4Rvf019CHCVHElKMFZBR5W6P0wXKD8nAX/
Mn9DapfLBrvqs/X7ShYZZcVWoSrZ7uvqnyC9o+JTx/I1518lTJy9hU9wL6vQRsIy
2xLfbvPxnxhYPivIAUklSzF676UzJA==
=6zxy
-----END PGP SIGNATURE-----

--Sig_/T4UnYjLzyJs=UM7dPDwrnvl--
