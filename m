Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39617 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab2GJSsQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 14:48:16 -0400
Message-ID: <1341946090.4475.31.camel@jlt3.sipsolutions.net> (sfid-20120710_204821_128762_BC016001)
Subject: pull-request: mac80211-next 2012-07-10
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 10 Jul 2012 20:48:10 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Z0LGp7zTaNyAdl2KzzMg"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Z0LGp7zTaNyAdl2KzzMg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please pull some more patches. I've included the first round of API
additions/updates for the P2P Device abstraction, I don't know if we'll
get the actual code done in time for 3.6 but I didn't want to hang on to
these APIs for too long to avoid conflicts.

I've also included some more fixes for the multi-channel and 60GHz work
as well as a few other fixes.

Thanks,
johannes


The following changes since commit 4d6d0ae2a088e1e054ef6d96ceb1b41523291e71=
:

  mac80211_hwsim: add testmode code to stop/wake queues (2012-07-06 15:27:1=
5 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to a9f9f43341bc5c8d2bd2ef8034fdd1789d5e0b19:

  cfg80211: fix locking and lockdep complaints (2012-07-10 19:40:34 +0200)

----------------------------------------------------------------
Arik Nemtsov (1):
      mac80211: fix invalid band deref building preq IEs

Christian Lamparter (1):
      mac80211: request TX status for BlockAck Requests

Johannes Berg (18):
      mac80211: update BSS info on AC parameters change
      mac80211: remove unused assignment
      mac80211: remove ieee80211_key_removed
      nl80211: prepare for non-netdev wireless devs
      nl80211: add NL80211_FLAG_NEED_WDEV
      nl80211: retrieve interface data by wdev
      nl80211: don't assume wdev->netdev exists
      cfg80211: use wdev in mgmt-tx/ROC APIs
      cfg80211: use wireless_dev for interface management
      nl80211: send interface after creation
      nl80211: move scan API to wdev
      mac80211: make scan_sdata pointer usable with RCU
      mac80211: track scheduled scan virtual interface
      mac80211: redesign scan RX
      mac80211: optimize ieee80211_rx_status struct layout
      mac80211: add time synchronisation with BSS for assoc
      mac80211: restructure key selection
      cfg80211: fix locking and lockdep complaints

Nicolas Cavallari (1):
      mac80211: tx: do not drop non-robust mgmt to non-MFP stas.

Sylvain Roger Rieunier (1):
      minstrel_ht: enable frame aggregation for fixed rate

Vladimir Kondratiev (1):
      cfg80211: fix oops due to unassigned set_monitor_enabled callback

 Documentation/DocBook/80211.tmpl                   |    1 -
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   58 +--
 drivers/net/wireless/ath/ath6kl/cfg80211.h         |    6 +-
 drivers/net/wireless/ath/ath6kl/core.c             |    8 +-
 drivers/net/wireless/ath/ath6kl/core.h             |    5 +
 drivers/net/wireless/ath/ath6kl/wmi.c              |   10 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    3 +-
 drivers/net/wireless/iwlegacy/common.c             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c            |    2 +-
 drivers/net/wireless/iwmc3200wifi/cfg80211.c       |    3 +-
 drivers/net/wireless/libertas/cfg.c                |    1 -
 drivers/net/wireless/mwifiex/cfg80211.c            |   27 +-
 drivers/net/wireless/mwifiex/main.c                |    4 +-
 drivers/net/wireless/mwifiex/main.h                |   10 +-
 drivers/net/wireless/orinoco/cfg.c                 |    2 +-
 drivers/net/wireless/rndis_wlan.c                  |    5 +-
 drivers/net/wireless/rt2x00/rt2x00config.c         |    2 +-
 include/linux/nl80211.h                            |    5 +
 include/net/cfg80211.h                             |   75 ++--
 include/net/mac80211.h                             |   40 +--
 net/mac80211/agg-tx.c                              |    3 +-
 net/mac80211/cfg.c                                 |   48 +--
 net/mac80211/debugfs.c                             |    2 -
 net/mac80211/ieee80211_i.h                         |   20 +-
 net/mac80211/iface.c                               |   15 +-
 net/mac80211/key.c                                 |   20 --
 net/mac80211/main.c                                |    3 +-
 net/mac80211/mlme.c                                |   45 +--
 net/mac80211/offchannel.c                          |    6 +-
 net/mac80211/rc80211_minstrel_ht.c                 |    8 +-
 net/mac80211/rx.c                                  |   49 +--
 net/mac80211/scan.c                                |  116 +++---
 net/mac80211/status.c                              |    9 +-
 net/mac80211/trace.h                               |    6 +-
 net/mac80211/tx.c                                  |   25 +-
 net/mac80211/util.c                                |    2 +
 net/wireless/chan.c                                |    4 +-
 net/wireless/core.c                                |   27 +-
 net/wireless/core.h                                |   11 +-
 net/wireless/mlme.c                                |   34 +-
 net/wireless/nl80211.c                             |  373 ++++++++++++++--=
----
 net/wireless/nl80211.h                             |   16 +-
 net/wireless/scan.c                                |   24 +-
 net/wireless/sme.c                                 |   10 +-
 net/wireless/util.c                                |   17 +-
 45 files changed, 657 insertions(+), 505 deletions(-)


--=-Z0LGp7zTaNyAdl2KzzMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJP/HjqAAoJEDBSmw7B7bqrXewP/0rIBF429XZ6+S3mG0vk9/nU
NG8g4BcJTI6CL77jCWFzyUgYET6xaBDclKAxmAbPaZ1GifTJSBvb3JRUSzyO0Rqw
vEXanZ/UpEL6gz8oEvHkvMlOV7mWSpYXXS5N0Hfr/q/UFPHwBA4yADwAxN8xneXu
LcrFOZ9v4+0UxclK/KEXUffy5T+ssnGHU88OBik96H2YXC/O9yUvqeajvw9IIR77
SYNxteUZdNoUZrhY+k5iWhdU0teAMny0lGeDcKBjGBAkoJZvTPJv6eWowj6edyr1
gjLeHElseG+DNFbm3jWxz+rUFvt064PlqtomEtT9XQdkGjs4lZgLZLG952LVq5+Y
1VYRNzJlRKc/rr6BvMW/xduV0zdKUdJ3CSluNZnZHFE0vsidkoeyVOzxDo/+oIPO
aiu1ns3J3jGbjL3Dg8TMinriV+mrToe5HSY8hkOWROlprHXSqSjT/DFg997HIv/f
1ZNk/gkqkob8l9Zk0793fKiWHABfoIzRR/TzySfF9uus48dV45GvTUcnrWkAlj3q
dWrSTFOJsw09bOb7IM2XsW1vUoC5SU7ZH630kJJMHrEyUSVZR0JdJFJlKitGOOSi
htn5igcWGKHp5zGibNyFYxQLAFt9sfM/rm+30yYX05OrBY2kdqfnnGAORQTKzETo
LDGrFjCs40VPjxvZvPy4
=6gLO
-----END PGP SIGNATURE-----

--=-Z0LGp7zTaNyAdl2KzzMg--

