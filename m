Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:32926 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbaCEPVE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 10:21:04 -0500
Message-ID: <1394032852.5275.41.camel@jlt4.sipsolutions.net> (sfid-20140305_162201_656146_ADEAC357)
Subject: pull-request: mac80211 2014-03-05
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 05 Mar 2014 16:20:52 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-vM/U7ipzyrbKR5GMLVBj"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vM/U7ipzyrbKR5GMLVBj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

We have some more fixes...

Here I have a fix from Eliad for the minimal channel width calculation
in the mac80211 code which lead to monitor mode not working at all for
drivers using that. One of my fixes is for an issue noticed by Michal,
we clear an already cleared value but do it without locking, so just
remove that. The other is for a data leak - we leak two bytes of kernel
memory out over the air in QoS NULL frames because those don't get a
sequence number assigned in the TX path.

Please let me know if there's any problem.

johannes


The following changes since commit cb664981607a6b5b3d670ad57bbda893b2528d96=
:

  mac80211: fix association to 20/40 MHz VHT networks (2014-02-27 20:53:01 =
+0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 864a6040f395464003af8dd0d8ca86fed19866d4:

  mac80211: clear sequence/fragment number in QoS-null frames (2014-03-05 1=
5:49:54 +0100)

----------------------------------------------------------------
Eliad Peller (1):
      mac80211: consider virtual mon when calculating min_def

Johannes Berg (2):
      cfg80211: remove racy beacon_interval assignment
      mac80211: clear sequence/fragment number in QoS-null frames

 net/mac80211/chan.c     | 6 ++++++
 net/mac80211/mesh_ps.c  | 1 +
 net/mac80211/sta_info.c | 1 +
 net/wireless/core.c     | 2 --
 4 files changed, 8 insertions(+), 2 deletions(-)


--=-vM/U7ipzyrbKR5GMLVBj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJTF0DUAAoJEDBSmw7B7bqrH8sQAKgEpQRISoaYmm42cuXlqru3
gBVB/NZgI328p2CY92iewI/lrl1bKGcWUsA4IWsuQjybJyEkt0OlIFiFW3aUHYQY
UvVLYdAat5w0NjqtA0jTz0590hn8X7/Rh6Dh/zBz2ZuYFQZFaekm4QEDyuRzoJns
XN908Y3c0FIeqN6h4FtA8wJ4w0+293tqVGM78ssJrGQz2v14o+Ny0HI/bMd/TjpB
x+JtPjBWSupM1RJWY8LDRd0WFTiVSzrpuLpkMXZPjakpmIo/sTr4OCkCQ4Lh40lW
ZcDPhPrIufIcgwbo+tlXoCKrJl2wwcZSHoqBkaeSipI9jBrbDL5sxYzTJVkKGDiZ
atGH9kOanv2hkUtbFW3j5v5uf0BfnOCJY6BSW/OXNdF14XgR9AyT8DtTSrKStS02
ykhtmwBLu6mfg251fZjS2qIwyBV6bHKMAcgCd4JymsT3wQe9IFfi2EOWFr7ehrAU
SPqB/2yl2vH5xhq54ss3oj4ojGsTtkFqDkIy+u6HNY5DT5ZnB20t5nIUu0lhlUAg
wS4/bJDKW7cOWobABxv2894NMmiUDy0/PJHImYvAx7G/if8WAEk5isFK26UytnNO
HjFoDfiHVLSox3EGFe/0ingdvloRWkmO6b3nBnjRbexyLaRP45/BigV4UwnU9aGL
0v5CpSEZTeyBg+M+RsWD
=70Wh
-----END PGP SIGNATURE-----

--=-vM/U7ipzyrbKR5GMLVBj--

