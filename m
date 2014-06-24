Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49332 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192AbaFXQW7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 12:22:59 -0400
Message-ID: <1403626964.10831.12.camel@jlt4.sipsolutions.net> (sfid-20140624_182313_006352_507DF583)
Subject: pull-request: mac80211-next 2014-06-24
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 24 Jun 2014 18:22:44 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-XLFqT13A1B+EG3jCwZl0"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XLFqT13A1B+EG3jCwZl0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Not so much (yet?), but here it goes ... I'm planning to pull in the CSA
work, of course.

The biggest thing here is probably Arik's TDLS rework, beyond that we
have smaller improvements and features like David's scanning IE thing,
Luca's queue work, some CSA work, etc. Also your PID rate control
removal, of course.

Let me know if any issues show up.

johannes

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f=
:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git HEA=
D

for you to fetch changes up to 79c3cc0d22358a383b1196aea869e620ec2faf37:

  mac80211: split sched scan IEs (2014-06-24 15:47:52 +0200)

----------------------------------------------------------------
Antonio Ospite (1):
      trivial: net/mac80211/mesh.c: fix typo s/Substract/Subtract/

Arik Nemtsov (10):
      mac80211: clarify TDLS Tx handling
      mac80211: set auth flags after other station info
      mac80211: cleanup TDLS state during failed setup
      cfg80211: pass TDLS initiator in tdls_mgmt operations
      mac80211: use TDLS initiator in tdls_mgmt operations
      mac80211: split tdls_mgmt function
      mac80211: implement proper Tx path flushing for TDLS
      mac80211: add API to request TDLS operation from userspace
      mac80211: make sure TDLS peer STA exists during setup
      mac80211: protect TDLS discovery session

Bob Copeland (1):
      mac80211: remove ignore_plink_timer flag

David Spinadel (2):
      mac80211: support more than one band in scan request
      mac80211: split sched scan IEs

Janusz Dziedzic (1):
      mac80211: allow tx via monitor iface when DFS

Johannes Berg (4):
      mac80211: fix station/driver powersave race
      mac80211: remove weak WEP IV accounting
      cfg80211: make ethtool the driver's responsibility
      mac80211_hwsim: clean up own address matching

John W. Linville (1):
      mac80211: remove PID rate control

Luciano Coelho (4):
      mac80211: don't stop all queues when flushing
      mac80211: introduce refcount for queue_stop_reasons
      mac80211: add functions to stop and wake all queues assigned to a vif
      mac80211: stop only the queues assigned to the vif during channel swi=
tch

Michal Kazior (2):
      mac80211: move csa counters from sdata to beacon/presp
      mac80211: use csa counter offsets instead of csa_active

Thomas Gleixner (2):
      mac80211: Use ktime_get_ts()
      net: Mac80211: Remove silly timespec dance

 MAINTAINERS                                 |  10 -
 drivers/net/wireless/at76c50x-usb.c         |   3 +-
 drivers/net/wireless/ath/ath10k/mac.c       |   3 +-
 drivers/net/wireless/cw1200/scan.c          |   3 +-
 drivers/net/wireless/cw1200/scan.h          |   2 +-
 drivers/net/wireless/iwlegacy/common.c      |   3 +-
 drivers/net/wireless/iwlegacy/common.h      |   2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |   3 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   5 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |   2 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c     |  27 +-
 drivers/net/wireless/mac80211_hwsim.c       |  69 ++--
 drivers/net/wireless/mwifiex/cfg80211.c     |   3 +-
 drivers/net/wireless/ti/wl1251/main.c       |   3 +-
 drivers/net/wireless/ti/wl12xx/scan.c       |  20 +-
 drivers/net/wireless/ti/wl12xx/scan.h       |   2 +-
 drivers/net/wireless/ti/wl18xx/scan.c       |  16 +-
 drivers/net/wireless/ti/wl18xx/scan.h       |   2 +-
 drivers/net/wireless/ti/wlcore/cmd.c        |  11 +-
 drivers/net/wireless/ti/wlcore/cmd.h        |   3 +-
 drivers/net/wireless/ti/wlcore/main.c       |   5 +-
 drivers/net/wireless/ti/wlcore/scan.h       |   2 +-
 drivers/net/wireless/ti/wlcore/wlcore.h     |   2 +-
 include/linux/ieee80211.h                   |   3 +
 include/net/cfg80211.h                      |  31 +-
 include/net/mac80211.h                      |  65 +++-
 include/uapi/linux/nl80211.h                |   5 +
 net/mac80211/Kconfig                        |  17 -
 net/mac80211/Makefile                       |   6 +-
 net/mac80211/agg-tx.c                       |   8 +-
 net/mac80211/cfg.c                          | 473 ++++--------------------=
---
 net/mac80211/debugfs_sta.c                  |   3 +-
 net/mac80211/driver-ops.h                   |  20 +-
 net/mac80211/ethtool.c                      | 244 ++++++++++++++
 net/mac80211/ibss.c                         |   2 +-
 net/mac80211/ieee80211_i.h                  |  57 +++-
 net/mac80211/iface.c                        |  13 +-
 net/mac80211/main.c                         |  10 +-
 net/mac80211/mesh.c                         |   4 +-
 net/mac80211/mesh_plink.c                   |  30 +-
 net/mac80211/mlme.c                         |  35 +-
 net/mac80211/offchannel.c                   |   6 +-
 net/mac80211/pm.c                           |   6 +-
 net/mac80211/rate.h                         |  13 -
 net/mac80211/rc80211_pid.h                  | 278 ----------------
 net/mac80211/rc80211_pid_algo.c             | 478 ------------------------=
----
 net/mac80211/rc80211_pid_debugfs.c          | 228 -------------
 net/mac80211/rx.c                           |   2 +
 net/mac80211/scan.c                         | 118 ++++---
 net/mac80211/sta_info.c                     | 201 ++++++++++--
 net/mac80211/sta_info.h                     |  13 +-
 net/mac80211/status.c                       |   7 +-
 net/mac80211/tdls.c                         | 293 +++++++++++++++--
 net/mac80211/trace.h                        |   7 +
 net/mac80211/tx.c                           | 170 +++++-----
 net/mac80211/util.c                         | 226 +++++++++----
 net/mac80211/wep.c                          |  20 --
 net/wireless/core.c                         |   3 -
 net/wireless/ethtool.c                      |  86 +----
 net/wireless/ethtool.h                      |   6 -
 net/wireless/nl80211.c                      |   4 +
 net/wireless/rdev-ops.h                     |  54 +---
 net/wireless/trace.h                        |  59 +---
 63 files changed, 1430 insertions(+), 2075 deletions(-)
 create mode 100644 net/mac80211/ethtool.c
 delete mode 100644 net/mac80211/rc80211_pid.h
 delete mode 100644 net/mac80211/rc80211_pid_algo.c
 delete mode 100644 net/mac80211/rc80211_pid_debugfs.c
 delete mode 100644 net/wireless/ethtool.h


--=-XLFqT13A1B+EG3jCwZl0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJTqaXUAAoJEDBSmw7B7bqr4rEP/3XKweVn6f9LHynuR+zNQaGQ
YaOfezyqsRtsYCmHGB24bTfhREVTlIebkg64Npjghutr93qBOpX1g/+Qagr1drkT
dpKznRdpX74xAFCBGTk0/ZR3T23y+ejE53UuIHic7bd8vwerxde841NRDNQ+MByE
e6yX/TFxrsrdjHMptspwCVCDX65JWwE4l0Ufar/Y+zmEN3pSTpQTqtUgEoWlpGXq
XBgI3Zn3T1sxt9ATGwIPk4jgEl3LJwtrdjB90axyGzs9/LG8qSZ8WD03usOXYAXO
kv1eHxuhZb0X1fk3bpwlGVPL/hWPmP5f3B1ayLyVXOBhNup6/xo0tfsJL0kYvyq8
qs/ymUrBZTpfAJiEBOMZb8vj/b8YyskQG6FO2N4qF35D1vvC85FHGW1VY/vhYIdK
SLRquITGjYah532ouhWLWgya4URRHFus+nzocZJmGfMz3RexNzkzvV4Kg/KU0lyK
hidqnsqGCgoTdWMTKIhIEy3H0+QKOfuUHqJLh8IzskFW3z6/1bsTSba5+9qD4Yf1
PCmOy7Nts7j2mOIBS6hwMlbT3Fe8zalDy6G1v0xCKzbDg/zGNCY9GXdtfuPf0mAk
p86T7q/8Ypj1GOfJxwm/XRhd8JDKPXEVZfy9GtTTnRL0NDpPKE4PRHdtEoxScLDD
ZNR9ZauyXrdZxokgtd70
=C3es
-----END PGP SIGNATURE-----

--=-XLFqT13A1B+EG3jCwZl0--

