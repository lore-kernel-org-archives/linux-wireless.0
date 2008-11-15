Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx30.mail.ru ([194.67.23.238]:32508 "EHLO mx30.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508AbYKOOP2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2008 09:15:28 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: orinoco-devel@lists.sourceforge.net
Subject: [PATCH] orinoco: indicate it is using dBm in wireless_stats and spy
Date: Sat, 15 Nov 2008 17:15:09 +0300
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2488795.h9qR7HVprG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200811151715.17150.arvidjaar@mail.ru> (sfid-20081115_151724_990052_7E194AC5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2488795.h9qR7HVprG
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Subject: [PATCH] orinoco: indicate it is using dBm in wireless_stats and spy
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

Since WE7 /proc/net/wireless checks whether level and noise  are in dBm
and shows them accordingly. Indicate that we return signal and noice
levels in dBm.

Before:
Inter-| sta-|   Quality        |   Discarded packets               | Missed=
 | WE
 face | tus | link level noise |  nwid  crypt   frag  retry   misc | beacon=
 | 22
  eth1: 0000   65.  219.  165.       0      0    148     41      0        0

After:
Inter-| sta-|   Quality        |   Discarded packets               | Missed=
 | WE
 face | tus | link level noise |  nwid  crypt   frag  retry   misc | beacon=
 | 22
  eth1: 0000   65.  -37.  -91.       0      0      0      0      0        0

While at it, replace raw numbers with appropriate macro.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

 drivers/net/wireless/orinoco.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index bc4f5a2..5038b76 100644
=2D-- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -821,7 +821,7 @@ static struct iw_statistics *orinoco_get_wireless_stats=
(struct net_device *dev)
 			wstats->qual.qual =3D (int)le16_to_cpu(cq.qual);
 			wstats->qual.level =3D (int)le16_to_cpu(cq.signal) - 0x95;
 			wstats->qual.noise =3D (int)le16_to_cpu(cq.noise) - 0x95;
=2D			wstats->qual.updated =3D 7;
+			wstats->qual.updated =3D IW_QUAL_ALL_UPDATED | IW_QUAL_DBM;
 		}
 	}
=20
@@ -1179,7 +1179,7 @@ static inline void orinoco_spy_gather(struct net_devi=
ce *dev, u_char *mac,
 	wstats.level =3D level - 0x95;
 	wstats.noise =3D noise - 0x95;
 	wstats.qual =3D (level > noise) ? (level - noise) : 0;
=2D	wstats.updated =3D 7;
+	wstats.updated =3D IW_QUAL_ALL_UPDATED | IW_QUAL_DBM;
 	/* Update spy records */
 	wireless_spy_update(dev, mac, &wstats);
 }

--nextPart2488795.h9qR7HVprG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkke2W4ACgkQR6LMutpd94w5sgCdF8VQD4TL55ja3027mbAp4cEQ
uIMAn2P0sMLV6yZfB74SUTF4Ola6j/sc
=XF5/
-----END PGP SIGNATURE-----

--nextPart2488795.h9qR7HVprG--
