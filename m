Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48316 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbaGUUID (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 16:08:03 -0400
Message-ID: <1405973274.32255.31.camel@jlt4.sipsolutions.net> (sfid-20140721_220807_620047_DD9B2272)
Subject: pull-request: mac80211-next 2014-07-21
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 21 Jul 2014 22:07:54 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-YlJ9kn9vRiT/8r3Nc3L6"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YlJ9kn9vRiT/8r3Nc3L6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Following your warning ... :-)

We have a lot of TDLS patches, among them a fix that should make hwsim
tests happy again. The rest, this time, is mostly small fixes.

Let me know if there are any issues.

johannes


The following changes since commit 97dc94f1d933c9df2c0b327066ea130c0e92083f=
:

  cfg80211: remove channel_switch combination check (2014-06-25 18:06:20 +0=
200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git HEA=
D

for you to fetch changes up to 08cf42e843f9a7e253502011c81677f61f7e5c42:

  mac80211: add support for Rx reordering offloading (2014-07-21 17:42:07 +=
0200)

----------------------------------------------------------------
Arik Nemtsov (14):
      mac80211: track TDLS initiator internally
      mac80211: fix error path for TDLS setup
      mac80211: consolidate TDLS IE treatment
      mac80211: split extra TDLS IEs in setup frames
      mac80211: avoid adding some IEs on TDLS setup failure packets
      mac80211: set TDLS capab to zero on failure frames
      mac80211: add QoS IE during TDLS setup start
      mac80211: add TDLS QoS param IE on setup-confirm
      mac80211: move TDLS data to mgd private part
      mac80211: support HT for TDLS stations
      mac80211: set Rx highest rate in ht_cap
      mac80211: disable VHT for TDLS
      cfg80211: fix TDLS setup with VHT peers
      mac80211: ignore frames between TDLS peers when operating as AP

Eytan Lifshitz (1):
      mac80211: remove useless NULL checks

Johannes Berg (1):
      mac80211: suppress unused variable warning without lockdep

Liad Kaufman (1):
      mac80211: make sure TDLS teardown packet is sent on time

Luciano Coelho (1):
      mac80211: remove redundant IEEE80211_STA_CSA_RECEIVED flag

Luis R. Rodriguez (1):
      wireless: fixup genregdb.awk for remove of antenna gain from wireless=
-regd

Max Stepanov (1):
      mac80211: fix a potential NULL access in ieee80211_crypto_hw_decrypt

Michal Kazior (2):
      mac80211: fix Rx reordering with RX_FLAG_AMSDU_MORE
      mac80211: add support for Rx reordering offloading

 include/linux/ieee80211.h  |  20 ++
 include/net/mac80211.h     |  34 ++++
 net/mac80211/agg-rx.c      | 110 ++++++++---
 net/mac80211/chan.c        |   2 +-
 net/mac80211/ht.c          |  10 +-
 net/mac80211/ibss.c        |  13 +-
 net/mac80211/ieee80211_i.h |  34 +++-
 net/mac80211/iface.c       |  31 ++-
 net/mac80211/key.c         |   3 -
 net/mac80211/mlme.c        |  22 +--
 net/mac80211/rx.c          |  65 +++++--
 net/mac80211/sta_info.h    |   8 +-
 net/mac80211/tdls.c        | 459 ++++++++++++++++++++++++++++++++++++++---=
----
 net/mac80211/util.c        |  15 ++
 net/mac80211/vht.c         |   4 +
 net/mac80211/wpa.c         |   2 +-
 net/wireless/Kconfig       |   6 +
 net/wireless/genregdb.awk  |  35 ++--
 net/wireless/nl80211.c     |   3 +-
 19 files changed, 707 insertions(+), 169 deletions(-)


--=-YlJ9kn9vRiT/8r3Nc3L6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJTzXMaAAoJEDBSmw7B7bqrcHwQALGzRQ6220kbXzDGdEECuFlN
DceL8BNw67qtYXYlKmu0wwPQdLeAK9wSczfoVXywERVz5/VEGg04C9K8zQN82rDs
IKzhhxnTp4mM4n2KzNicDoLyT6/NCmf+chC/pYGBbffzDUOwQTwEM48bswC0QBt5
JbeqQBYiKyg363n9f6gfPWMvJhtn6AwggdV44CCjVZ9IYvKmXQ4pt3tC0tFynET4
kzJMu2RxPMz+DxUuUTABgiYkXqMASWkgbS+n5VMiYqIQulcbrt7MnMHp0AlmtGWI
DURvwAkfV4wG4ry3E5qv7N1/Nx6sBB/Euth9XDbwRU8fjTMUo8WmGtHmoh6LTRaD
InouNcC5kCmO9lDkNbvlTk2JTS/YafRRqsCk3/tB2pRGkzYVke87km1yBzK1VrtU
5nJZFqcc0P/2Q5KHWe/wlSkw3LJkkVgFlkfqej+5vCBb/M1yOjJtA6A6hlW5MuHY
YGI+p4DQ9ON1ynawMfQpbmZFupt4F8eYIGgx2FlZBZ1rt7N3NbndQodZEIkcU4Rr
d/yQ9/4HqRR0cW77skgtYV0/JdUvD4HI7O2V25HDA+9cGYNWPAF4NhmxIOHKQvyt
flGgEkuWZlsCADt0C/+2wKcqOTiQghll7+0Beu5+uvFEleWSPZGT04AjVAob/BOq
lj4vWNGhuZ2Ql6e4ixpv
=Y86v
-----END PGP SIGNATURE-----

--=-YlJ9kn9vRiT/8r3Nc3L6--

