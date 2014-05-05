Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41113 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429AbaEENsl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 09:48:41 -0400
Message-ID: <1399297696.22235.15.camel@jlt4.sipsolutions.net> (sfid-20140505_154854_425575_375F22ED)
Subject: pull-request: mac80211 2014-05-05
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 05 May 2014 15:48:16 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-07ZJCtQH14fKTwgS9jZ8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-07ZJCtQH14fKTwgS9jZ8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

I've been collecting more fixes, but not that much showed up :-)

Here are a few small fixes for the current cycle: radiotap TX flags were
wrong (fix by Bob), Chun-Yeow fixes an SMPS issue with mesh interfaces,
Eliad fixes a locking bug and a cfg80211 state problem and finally
Henning sent me a fix for IBSS rate information.

Please let me know if there are any issues.

Thanks,
johannes

The following changes since commit 764152ff66f4a8be1f9d7981e542ffdaa5bd7aff=
:

  mac80211: exclude AP_VLAN interfaces from tx power calculation (2014-04-1=
1 09:37:41 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git HEAD

for you to fetch changes up to e669ba2d06c6195662601956454ac959892f0762:

  mac80211: fix nested rtnl locking on ieee80211_reconfig (2014-05-05 15:14=
:58 +0200)

----------------------------------------------------------------
Bob Copeland (1):
      mac80211: fixup radiotap tx flags for RTS/CTS

Chun-Yeow Yeoh (1):
      mac80211: avoid handling of SMPS for mesh

Eliad Peller (3):
      cfg80211: free sme on connection failures
      cfg80211: add cfg80211_sched_scan_stopped_rtnl
      mac80211: fix nested rtnl locking on ieee80211_reconfig

Henning Rogge (1):
      mac80211: Fix mac80211 station info rx bitrate for IBSS mode

 include/net/cfg80211.h  | 12 ++++++++++++
 net/mac80211/rx.c       |  3 ++-
 net/mac80211/sta_info.c |  3 ++-
 net/mac80211/status.c   |  5 ++---
 net/mac80211/util.c     |  2 +-
 net/wireless/scan.c     | 12 ++++++++++--
 net/wireless/sme.c      |  2 +-
 7 files changed, 30 insertions(+), 9 deletions(-)


--=-07ZJCtQH14fKTwgS9jZ8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIbBAABCAAGBQJTZ5agAAoJEDBSmw7B7bqrP1MP9iF6U3MUNZnUMCfZzTa9JDuy
y3b2CGaqbhACuekg5cnBxV8QR06UYT1liQzQbn6Tpi5kcnxONAaeD05XBx3ellNI
DA7Mt7MyUBBSdWR4mfTg0K8dCDhRI3aF9BOPKJxoTDoQYFcuYSZur4unP5vbTVxj
VNeRZyj3b99SVM70tMVyEp5opL2ILdWp0jM05NoGKw90XDf9XjznLz7zwAWwNTe5
Q6RJD2c0R692gduvBGc8SNhf4d8p4/Dn0SYEBQ1FQinwSBxWczZyy/PWFxVM5RBs
DFcxQdIPFGk6uBC3m0C8i3Ij/ywfXssPfqddVUtEAC7ZW3IWMnSBME4UIOs5dYnp
Cn2insHY7C0RaqJb5v7HDx96H9qg/3eXQAXD9zZybFkT6kH0ikdvMlHsrFKxc4Iy
URl6cq5myel6QaO7B6omVDq9p5yexy6+GgtlRT/qP6Gehm85kPz/6EHBFK9ss8r5
bmiQj84LfSoyyt4UTqD3Kqv3GkzR4mlyVND3ynaoNnRecSTQJEStrG6AX+3QIvmQ
vrWZIYK6TSMThgMKlnWTZRVl5XkGpkLhLaHJ2GJgusPoOcHHT1r/0jGr+xPBC+03
+6lYT29mZTzL2OO/jY1bfPiAi7YJR8+6E98znTb92J9Z0VgiDyzMd1JdjUaFaBlB
pxvi0lCalmtI0JP3/wM=
=HNxC
-----END PGP SIGNATURE-----

--=-07ZJCtQH14fKTwgS9jZ8--

