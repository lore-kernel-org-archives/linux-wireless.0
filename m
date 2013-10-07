Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56444 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab3JGJwF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 05:52:05 -0400
Message-ID: <1381139513.13586.15.camel@jlt4.sipsolutions.net> (sfid-20131007_115209_719258_290303B2)
Subject: pull-request: mac80211-next 2013-10-07
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 07 Oct 2013 11:51:53 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-5XvhmJmb4ZyEP8rc5Uuf"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5XvhmJmb4ZyEP8rc5Uuf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

First pull request for new features - sorry it's so late.

We have an assortment of cleanups and new features, of which the biggest
one is probably the channel-switch support in IBSS. Nothing else really
stands out much.

Let me know if there's any problem.

johannes


The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f=
:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 7578d57520f51093f590d68e16965e2714e69747:

  mac80211: implement STA CSA for drivers using channel contexts (2013-10-0=
2 18:18:23 +0200)

----------------------------------------------------------------
Arik Nemtsov (1):
      mac80211: implement STA CSA for drivers using channel contexts

Eliad Peller (2):
      mac80211: fix some snprintf misuses
      ieee80211: fix vht cap definitions

Fred Zhou (2):
      mac80211: use exact-size allocation for authentication frame
      mac80211: improve default WMM parameter setting

Janusz Dziedzic (1):
      cfg80211: parse dfs region for internal regdb option

Johannes Berg (4):
      mac80211: add ieee80211_iterate_active_interfaces_rtnl()
      mac80211: use ERR_CAST()
      mac80211: add explicit IBSS driver operations
      regulatory: enable channels 52-64 and 100-144 for world roaming

Lorenzo Bianconi (2):
      mac80211: add fixed_rate management to minstrel rc
      mac80211: do not override fixed_rate_idx in minstrel_ht_update_stats

Michal Kazior (1):
      mac80211: support reporting A-MSDU subframes individually

Sergey Ryazanov (1):
      mac80211: Remove superfluous is_multicast_ether_addr() call

Simon Wunderlich (7):
      cfg80211: export cfg80211_chandef_dfs_required
      mac80211: split off channel switch parsing function
      mac80211: split off ibss disconnect
      mac80211: add support for CSA in IBSS mode
      mac80211: send a CSA action frame when changing channel
      nl80211: enable IBSS support for channel switch announcements
      nl80211: allow CAC only if no operation is going on

Stanislaw Gruszka (1):
      mac80211: change beacon/connection polling

cedric Voncken (1):
      cfg80211: vlan priority handling in WMM

 include/linux/ieee80211.h          |   4 +-
 include/net/cfg80211.h             |   9 +
 include/net/mac80211.h             |  42 +++
 net/mac80211/cfg.c                 |  92 ++++--
 net/mac80211/chan.c                |   5 -
 net/mac80211/debugfs.c             |  55 ++--
 net/mac80211/driver-ops.h          |  27 ++
 net/mac80211/ibss.c                | 608 +++++++++++++++++++++++++++++++--=
----
 net/mac80211/ieee80211_i.h         |  30 +-
 net/mac80211/iface.c               |   4 +
 net/mac80211/key.c                 |   2 +-
 net/mac80211/mlme.c                | 334 +++++---------------
 net/mac80211/rc80211_minstrel.c    |  14 +
 net/mac80211/rc80211_minstrel_ht.c |  23 +-
 net/mac80211/rc80211_pid_debugfs.c |  26 +-
 net/mac80211/rx.c                  |  39 ++-
 net/mac80211/scan.c                |   3 +-
 net/mac80211/spectmgmt.c           | 162 ++++++++++
 net/mac80211/trace.h               |  35 +++
 net/mac80211/tx.c                  |  39 ++-
 net/mac80211/util.c                | 162 ++++++----
 net/mac80211/vht.c                 |   4 +-
 net/wireless/chan.c                |   1 +
 net/wireless/core.h                |   9 -
 net/wireless/debugfs.c             |  24 +-
 net/wireless/genregdb.awk          |   6 +
 net/wireless/nl80211.c             |  52 +++-
 net/wireless/reg.c                 |  14 +-
 net/wireless/util.c                |   9 +
 29 files changed, 1290 insertions(+), 544 deletions(-)


--=-5XvhmJmb4ZyEP8rc5Uuf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSUoQ5AAoJEDBSmw7B7bqrWlAQAMEHzj59hyf0g0B7ABvk6RII
WJtLmMsdhZqolUx60+04uq9jkzzRE8JUB9JfzxDSEjDnSFGfTDOOFSjKgsu2oJoe
b5kGzdNh4R+6i7lmlzo8MkzfaYmOfor4EatqZLzgKKfKJjgCX1fcY4NGsV5x9bR2
e1AG/a9cGmZSkowxhIgaSUX3U/41ShQylc7zsMeVMnxU1aeyhgdlPNVRDCvTqY9G
PsIq0RU+n/kEDO7pxsR0iA57BKniPXTSXJxNoM6ZZHxR/gF3LJfZBTwxcCxiwLlc
e/b4s7lhcIlf4BPuTRFOwvBsPUBbSNQDOM5MBAr9xGHhiJvYImdU1VQpOanyFz4h
CG3Az+V34XtMZIz+PV96nl6zitPS9/c6kqdHRCtqNErlwIiWNGMWk1C3/irO4ItY
5ZpLpbmyGLkPmMlCNqhaL8/MSpCPI65EvNDUgp1yNRfqVP7DNBJDNsf/4MaKmxSM
IkanLEgouFoJHPxg9vV76OJs/MvS0kRbWIgnKgmyrPJCluWL45qE40fJcNFETUPD
SJuuuReF8KKAvzP/hWnACxbYy3lPCB2DVB9FYNcjxiL6LW9LMzmnOMSHdrVj80J0
Y7bljSoXI+7MdyCTRBAiJXUuI93uXDhm8bFeZSu7mEV3PKOwWjFC3PzMx8QL9ePT
FmCanavTgwnG2GjxPEha
=xr4d
-----END PGP SIGNATURE-----

--=-5XvhmJmb4ZyEP8rc5Uuf--

