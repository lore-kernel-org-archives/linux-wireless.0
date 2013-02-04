Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43869 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab3BDSKq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 13:10:46 -0500
Message-ID: <1360001465.17993.30.camel@jlt4.sipsolutions.net> (sfid-20130204_191056_397270_06E2176E)
Subject: pull-request: mac80211-next 2013-02-04
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 04 Feb 2013 19:11:05 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-10sq7ftgcd+9oPcJ9j3P"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-10sq7ftgcd+9oPcJ9j3P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

I've accumulated a bunch of patches again, so here's a new pull request
for mac80211-next.

The biggest change I have is undoubtedly Marco's mesh powersave
implementation. Beyond that, I have a patch from Emmanuel to modify the
DTIM period API in mac80211, scan improvements and a removal of some
previous workaround code from Stanislaw, dynamic short slot time from
Thomas and 64-bit station byte counters from Vladimir. I also made a
number of changes myself, some related to WoWLAN, some auth/deauth
improvements and most of them BSS list cleanups.

Let me know if there are any problems.

Thanks,
johannes

The following changes since commit 9ebea3829fac7505e0cd2642fbd13cfa9c038831=
:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/li=
nville/wireless (2013-01-28 13:54:03 -0500)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 3f52b7e328c526fa7a592af9bf5772c591ed38a4:

  mac80211: mesh power save basics (2013-02-04 18:57:47 +0100)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      mac80211: inform the driver about update of dtim_period

Johannes Berg (22):
      Merge remote-tracking branch 'wireless-next/master' into HEAD
      cfg80211: add SME state to warning in __cfg80211_mlme_disassoc
      cfg80211/mac80211: support reporting wakeup reason
      mac80211: remove assoc data "sent_assoc"
      mac80211: remove last_probe_resp from bss
      mac80211: remove unused mesh data from bss
      cfg80211: remove free_priv BSS API
      mac80211: start auth/assoc timeout on frame status
      mac80211: send deauth when connection is lost
      mac80211: always allow calling ieee80211_connection_loss()
      cfg80211: refactor hidden SSID finding
      cfg80211: fix BSS list hidden SSID lookup
      cfg80211: simplify mesh BSS comparison
      cfg80211: remove unused cfg80211_get_mesh
      mac80211: remove unused SSID from BSS
      cfg80211: fix BSS IE allocation comment
      cfg80211: move locking into cfg80211_bss_age
      mac80211: allow transmitting deauth with tainted key
      mac80211: send deauth if connection was lost during suspend
      cfg80211: use lockdep to assert lock is held
      cfg80211: remove a local variable
      cfg80211: wrap BSS kref

Marco Porsch (1):
      mac80211: mesh power save basics

Stanislaw Gruszka (2):
      mac80211: remove IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
      mac80211: improve latency and throughput while software scanning

Thomas Pedersen (1):
      mac80211: dynamic short slot time for MBSSs

Vladimir Kondratiev (1):
      cfg80211: expand per-station byte counters to 64bit

 drivers/net/wireless/ath/carl9170/main.c           |   2 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   5 +-
 drivers/net/wireless/iwlegacy/4965-mac.c           |   2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |   3 +-
 drivers/net/wireless/ti/wlcore/main.c              |   3 +-
 include/linux/ieee80211.h                          |  13 +-
 include/net/cfg80211.h                             | 102 +++-
 include/net/mac80211.h                             |  71 ++-
 include/uapi/linux/nl80211.h                       |  86 ++-
 net/mac80211/Kconfig                               |  11 +
 net/mac80211/Makefile                              |   3 +-
 net/mac80211/agg-rx.c                              |  14 +-
 net/mac80211/agg-tx.c                              |  61 ++-
 net/mac80211/cfg.c                                 |  27 +-
 net/mac80211/debug.h                               |  10 +
 net/mac80211/debugfs.c                             |   4 +-
 net/mac80211/debugfs_netdev.c                      |   5 +
 net/mac80211/debugfs_sta.c                         |   5 +-
 net/mac80211/driver-ops.h                          |  36 +-
 net/mac80211/ibss.c                                |   4 +-
 net/mac80211/ieee80211_i.h                         |  61 +--
 net/mac80211/iface.c                               |   3 -
 net/mac80211/key.c                                 |   5 +-
 net/mac80211/main.c                                |  64 ++-
 net/mac80211/mesh.c                                |  36 +-
 net/mac80211/mesh.h                                |  17 +
 net/mac80211/mesh_hwmp.c                           |   7 +
 net/mac80211/mesh_pathtbl.c                        |   1 +
 net/mac80211/mesh_plink.c                          | 226 ++++++--
 net/mac80211/mesh_ps.c                             | 585 +++++++++++++++++=
++++
 net/mac80211/mlme.c                                | 231 +++++---
 net/mac80211/pm.c                                  |  10 +
 net/mac80211/rx.c                                  |   7 +
 net/mac80211/scan.c                                |  47 +-
 net/mac80211/sta_info.c                            |  25 +-
 net/mac80211/sta_info.h                            |  11 +
 net/mac80211/status.c                              |  25 +-
 net/mac80211/trace.h                               |  53 +-
 net/mac80211/tx.c                                  |  42 +-
 net/mac80211/util.c                                |  20 +-
 net/mac80211/wme.c                                 |  13 +-
 net/wireless/core.c                                |   5 +
 net/wireless/mlme.c                                |   2 +-
 net/wireless/nl80211.c                             | 229 +++++++-
 net/wireless/rdev-ops.h                            |  12 +
 net/wireless/scan.c                                | 355 +++++--------
 net/wireless/sysfs.c                               |   2 -
 net/wireless/trace.h                               |  53 ++
 net/wireless/util.c                                |   3 +-
 49 files changed, 2001 insertions(+), 616 deletions(-)
 create mode 100644 net/mac80211/mesh_ps.c


--=-10sq7ftgcd+9oPcJ9j3P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRD/m5AAoJEDBSmw7B7bqrvmwQALwaV5EezHxd8ms/01vwnS8y
r48F27UmjlfFKFAJ7Wgczjnux/aS0X9cbzybEWV3t1rI+KHnz6Ob+5SLt1/YimaB
ZGmiVv6HtgTx2iz4rPNrLy1faWtEICkh6Y6vMZ+kcoSbV0F9GtPot6TWo7bnPnWy
0Hx+ETcspuyKaiPVMr2OZ1wCFQLgMgpz6s2oM87Z02Fxrylu/3zROUeQMbA2x9s1
cyAXfPsngFbVH5FMSPKtyrYUNqdgUVtAcaTne3J/ALfUyUXdgnXTzrS5gR00KlKP
jyh90ioKL8yN+nxaAnJjXR8U2I8VEXnJ7VQjQIcDtT7fM0RWY3RslzT8lOKfvEoB
Jj4X2hQi4PB23tKoUXpZ7uBy08d503pyxsmVtoIPm3uGJIa2DhDlMqZOlJBvuadf
5BrAQOnUFjHsx6WxyqWKrrhmHPk/LZaohz6q38Qm3aizCSIiT1u0NyFsZXdTlfpt
+NWNhNCFHRM4mkhQZHokUMHYK4NOtFfHOqaGI2rt2FwIDacOpdx5oaBo7af/AvKa
eSOovSFpm52ki8bQxt+/9zJVb2/l7spxCX0q27K2M0Jhtnf4cnnekp+ArZ2Ad9yb
1wQAd9LxLdtD10+94gKtgJTDZQaezURJMSTISVK5tBWUxINnDgGmDfHqEdKM42CF
Ed34SPFSENvQtvE6qH1o
=hAKO
-----END PGP SIGNATURE-----

--=-10sq7ftgcd+9oPcJ9j3P--

