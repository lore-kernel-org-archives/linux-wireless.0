Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36189 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758401Ab2FZHm5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 03:42:57 -0400
Message-ID: <1340696564.4662.12.camel@jlt3.sipsolutions.net> (sfid-20120626_094306_807856_799EAD6D)
Subject: pull-request: mac80211-next 2012-06-26
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 26 Jun 2012 09:42:44 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-h1wINCAs8TxNVVB+eSLJ"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-h1wINCAs8TxNVVB+eSLJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please pull as below. I'm including various small patches and my
debugging cleanups, including optional debug tracing.

johannes


The following changes since commit 0f6b3f597daab2254614e2773e322e73fb1b6f4b=
:

  mac80211: fix double-start of remain-on-channel (2012-06-20 20:12:12 +020=
0)

are available in the git repository at:

  git://git.sipsolutions.net/mac80211-next.git for-john

for you to fetch changes up to 371a255e863857f988a91a3850d6feeaa4f3c536:

  mac80211: make ieee80211_check_concurrent_iface netdev-independent (2012-=
06-26 09:37:25 +0200)

----------------------------------------------------------------
Avinash Patil (1):
      ieee80211: more OUI type definitions for WLAN_OUI_MICROSOFT

Johannes Berg (9):
      mac80211: remove TKIP debug
      mac80211: two small verbose debug cleanups
      mac80211: pass sdata to some RX functions
      mac80211: clean up debugging
      mac80211: rename driver-trace file
      mac80211: trace debug messages
      mac80211_hwsim: fix smatch/sparse complaints
      mac80211: remove unused function
      mac80211: make ieee80211_check_concurrent_iface netdev-independent

Thomas Pedersen (1):
      nl80211: specify RSSI threshold in scheduled scan

Victor Goldenshtein (1):
      mac80211: add command to get current rssi

 drivers/net/wireless/mac80211_hwsim.c    |   10 +-
 include/linux/ieee80211.h                |    2 +
 include/linux/nl80211.h                  |    6 +
 include/net/cfg80211.h                   |    2 +
 include/net/mac80211.h                   |   29 +----
 net/mac80211/Kconfig                     |   56 ++++++---
 net/mac80211/Makefile                    |    6 +-
 net/mac80211/agg-rx.c                    |   34 ++---
 net/mac80211/agg-tx.c                    |   72 ++++++-----
 net/mac80211/cfg.c                       |   30 ++---
 net/mac80211/debug.h                     |  170 +++++++++++++++++++++++++
 net/mac80211/debugfs_netdev.c            |    5 +-
 net/mac80211/driver-ops.h                |   17 ++-
 net/mac80211/driver-trace.c              |    9 --
 net/mac80211/ht.c                        |   10 +-
 net/mac80211/ibss.c                      |   89 +++++++------
 net/mac80211/ieee80211_i.h               |    1 +
 net/mac80211/iface.c                     |   21 +---
 net/mac80211/key.c                       |    4 +-
 net/mac80211/mesh.c                      |    4 -
 net/mac80211/mesh_hwmp.c                 |   42 +++----
 net/mac80211/mesh_pathtbl.c              |   30 ++---
 net/mac80211/mesh_plink.c                |   61 ++++-----
 net/mac80211/mesh_sync.c                 |   47 +++----
 net/mac80211/mlme.c                      |  203 ++++++++++++++------------=
----
 net/mac80211/offchannel.c                |    1 -
 net/mac80211/rx.c                        |   71 ++++-------
 net/mac80211/sta_info.c                  |   44 +++----
 net/mac80211/status.c                    |   11 +-
 net/mac80211/tkip.c                      |   43 +------
 net/mac80211/trace.c                     |   75 +++++++++++
 net/mac80211/{driver-trace.h =3D> trace.h} |   67 +++++++++-
 net/mac80211/tx.c                        |   49 +++-----
 net/wireless/nl80211.c                   |    9 +-
 34 files changed, 768 insertions(+), 562 deletions(-)
 create mode 100644 net/mac80211/debug.h
 delete mode 100644 net/mac80211/driver-trace.c
 create mode 100644 net/mac80211/trace.c
 rename net/mac80211/{driver-trace.h =3D> trace.h} (96%)


--=-h1wINCAs8TxNVVB+eSLJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJP6Wf0AAoJEDBSmw7B7bqrxXwQALwLppDTwoqAQpGMOLNmIy/A
K2AOuAvyl9yovBhVFDEMasoG/nDAd+lrEN6T01pXko0zZyqBKThtD7E56+apT1to
90B60o8vLvBibGASgC1bwiUyt6NANZhfolWUQ6hNrP9xEpkTVjJbPHY8PaX5uMok
ITChQ6LZ6HyIDQXEZTYfqmtRqt1Fl5R8TrBfQYlR52rDuBAstlwIWUx22InCtZNl
pt8oxkEUEcufervQ6JW6Ewxu0/yXqcc3yntDNj9Wpey52rxWuV+9CFXIvd3XA2km
/nebPURxInp5aCRr3/G9iteD8aAVQiW+nYdIgrAk/R6oSf9G/4c/d8qO+8kqo4+1
Tr+wZoGlPm7W34+22BN2MvEukIE8fnBUHuuCaD6RbH+TfM1JX87BaMKXeCXOocmD
6PQzSc1sfhN80UPbvQWOsRfE5NcqQVUspOLgZVWdQ6BAl2Ezt9IfWrNVmVtxeW/E
I3ax9xwxlxs6JeRnDTmQC/K7HfS/GEWGMc5ZstWLNBPiH/bY8UnSnCdMxD7ZCdFM
XE0U/ucnAF1qbFs9HOUxKpdMOM2NR+R1y59D36MXvzq9lwsExN6ecs3P0ynln2LW
nxE8VJK6WmtMsoNikAfA2nzix1mKnOoJ5XvmJ5uRWBKl91PpworJWAF33CqCmJDR
MVuTqxyYR37h9dUq3FCG
=jBxL
-----END PGP SIGNATURE-----

--=-h1wINCAs8TxNVVB+eSLJ--

