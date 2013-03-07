Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52988 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab3CGJus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 04:50:48 -0500
Message-ID: <1362649836.8694.9.camel@jlt4.sipsolutions.net> (sfid-20130307_105057_869184_9F02D98F)
Subject: pull-request: mac80211-next 2013-03-07
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 07 Mar 2013 10:50:36 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-fuVTHKcfbSi1ccdio5I7"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fuVTHKcfbSi1ccdio5I7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

First mac80211-next pull request, and I already have quite a bit of work
in there ...

First, I merged mac80211/master to avoid some conflicts. This brings in
a bunch of fixes you're already familiar with. For real -next material,
I have a whole bunch of minstrel work, minstrel_ht from Felix and legacy
minstrel from Thomas (Huehn). The other Thomas (Pedersen) did a number
of changes in mesh to allow userspace peering management even when the
mesh isn't secured. Stanislaw changes suspend/resume to always
disconnect the networks. This is typically already done by
network-manager so won't make a huge difference for most users, but
fixes a number problems, particularly with USB drivers that can easily
disconnect while suspended. Ilan has a small change to allow mac80211
drivers to differentiate remain-on-channel reasons, and Jouni extends
nl80211 to allow fast roaming with full-MAC devices. I have a fairly
large number of patches as well, many of them fairly simple cleanups,
but also allowing split wiphy dumps and adding back the full wiphy
information in nl80211, station entry change checking and more VHT work
including VHT capability overrides (mostly for testing purposes).

Let me know if there are any issues.

johannes

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8=
:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 87f59c70ce6d1abeaaf97594835be29f746b81a0:

  mac80211: init mesh timer for user authed STAs (2013-03-06 16:36:14 +0100=
)

----------------------------------------------------------------
Ben Greear (2):
      mac80211: stop timers before canceling work items
      mac80211: Fix crash due to un-canceled work-items

Chun-Yeow Yeoh (1):
      mac80211: fix the problem of forwarding from DS to DS in Mesh

Felix Fietkau (10):
      mac80211: fix idle handling in monitor mode
      mac80211: fix monitor mode channel reporting
      mac80211: another fix for idle handling in monitor mode
      ieee80211: mark 802.11 related structs as being 2-byte aligned
      mac80211/minstrel_ht: improve accuracy of throughput metric at high d=
ata rates
      mac80211/minstrel_ht: improve max_prob_rate selection
      minstrel_ht: increase sampling frequency
      mac80211/minstrel_ht: increase sampling frequency of some slower rate=
s
      mac80211/minstrel_ht: fix spacing between sample attempts
      mac80211/minstrel_ht: disable multiple consecutive sample attempts

Ilan Peer (1):
      mac80211: Allow drivers to differentiate between ROC types

Johannes Berg (35):
      mac80211: fix tim_lock locking
      nl80211: remove radar information
      nl80211: remove TCP WoWLAN information
      nl80211: remove channel width and extended capa advertising
      mac80211: really fix monitor mode channel reporting
      nl80211: increase wiphy dump size dynamically
      mac80211: fix VHT MCS calculation
      Merge remote-tracking branch 'mac80211/master' into HEAD
      cfg80211: clean up mesh plink station change API
      cfg80211: constify station parameter pointers
      cfg80211: clean up station WME attribute parsing
      cfg80211: unify station WME parsing
      cfg80211: comprehensively check station changes
      mac80211: clarify alignment comment
      nl80211: allow splitting wiphy information in dumps
      nl80211: conditionally add back radar information
      nl80211: conditionally add back TCP WoWLAN information
      wireless: move sequence number arithmetic to ieee80211.h
      nl80211: re-add channel width and extended capa advertising
      cfg80211: move exported event functions into nl80211
      wireless: remove unused VHT MCS defines
      cfg80211: add ability to override VHT capabilities
      mac80211: support VHT capability overrides
      cfg80211: refactor association parameters
      cfg80211: prohibit zero keepalive interval
      mac80211: remove IEEE80211_KEY_FLAG_WMM_STA
      mac80211: defer tailroom counter manipulation when roaming
      mac80211: flush keys when stopping AP
      mac80211: simplify AP interface stop
      mac80211: don't apply HT overrides to TDLS peers
      mac80211: fix HT capability overrides for AP station
      mac80211: restrict peer's VHT capabilities to own
      mac80211: add VHT capabilities station debugfs file
      cfg80211: enable TDLS on P2P client interfaces
      regulatory: allow VHT channels in world roaming

Jouni Malinen (1):
      cfg80211: Extend support for IEEE 802.11r Fast BSS Transition

Marco Porsch (1):
      mac80211: fix oops on mesh PS broadcast forwarding

Sachin Kamat (1):
      net: rfkill: Fix sparse warning in rfkill-regulator.c

Seth Forshee (1):
      mac80211: Ensure off-channel frames don't get queued

Stanislaw Gruszka (7):
      mac80211: remove napi
      cfg80211/mac80211: disconnect on suspend
      mac80211: cleanup generic suspend/resume procedures
      mac80211: cleanup suspend/resume on managed mode
      mac80211: cleanup suspend/resume on ibss mode
      mac80211: cleanup suspend/resume on mesh mode
      mac80211: merge reconfig assign chanctx code

Thomas Huehn (7):
      mac80211: merge EWMA calculation of minstrel_ht and minstrel
      mac80211: merge value scaling macros of minstrel_ht and minstrel
      mac80211: add documentation and verbose variable names in
      mac80211: extend minstrel's rate sampling to avoid unsampled rates
      mac80211: add lowest rate into minstrel's random rate sampling table
      mac80211: treat minstrel success probabilities below 10% as implausib=
le
      mac80211: improve minstrels rate sorting by means of throughput & pro=
bability

Thomas Pedersen (6):
      nl80211: explicit userspace MPM
      cfg80211: rename mesh station types
      mac80211: support userspace MPM
      nl80211: user_mpm overrides auto_open_plinks
      mac80211: disallow changing auto_open_plinks
      mac80211: init mesh timer for user authed STAs

 drivers/net/wireless/ath/ath6kl/cfg80211.c  |    8 +-
 drivers/net/wireless/iwlegacy/3945.h        |    4 -
 drivers/net/wireless/iwlegacy/4965-mac.c    |   13 +-
 drivers/net/wireless/iwlegacy/common.h      |    4 -
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |    3 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c       |   11 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h    |    3 -
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    7 +-
 drivers/net/wireless/iwlwifi/mvm/sta.c      |    4 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c       |    2 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c      |    2 +-
 drivers/net/wireless/mac80211_hwsim.c       |    3 +-
 drivers/net/wireless/rtlwifi/wifi.h         |    3 -
 drivers/net/wireless/ti/wlcore/main.c       |    3 +-
 include/linux/ieee80211.h                   |   52 +-
 include/net/cfg80211.h                      |  126 +-
 include/net/mac80211.h                      |   29 +-
 include/uapi/linux/nl80211.h                |  117 +-
 net/mac80211/cfg.c                          |  162 ++-
 net/mac80211/debugfs_sta.c                  |   31 +
 net/mac80211/driver-ops.h                   |    7 +-
 net/mac80211/ht.c                           |   52 +-
 net/mac80211/ibss.c                         |   29 +-
 net/mac80211/ieee80211_i.h                  |   26 +-
 net/mac80211/iface.c                        |   22 +-
 net/mac80211/key.c                          |  103 +-
 net/mac80211/key.h                          |    5 +-
 net/mac80211/main.c                         |   55 +-
 net/mac80211/mesh.c                         |   59 +-
 net/mac80211/mesh.h                         |   12 -
 net/mac80211/mesh_plink.c                   |   37 +-
 net/mac80211/mlme.c                         |  110 +-
 net/mac80211/offchannel.c                   |    2 +-
 net/mac80211/pm.c                           |  117 +-
 net/mac80211/rc80211_minstrel.c             |  204 +--
 net/mac80211/rc80211_minstrel.h             |   31 +-
 net/mac80211/rc80211_minstrel_debugfs.c     |   12 +-
 net/mac80211/rc80211_minstrel_ht.c          |   79 +-
 net/mac80211/rc80211_minstrel_ht.h          |    6 +-
 net/mac80211/rx.c                           |   61 +-
 net/mac80211/sta_info.c                     |   11 +-
 net/mac80211/sta_info.h                     |    2 -
 net/mac80211/trace.h                        |   11 +-
 net/mac80211/tx.c                           |   80 +-
 net/mac80211/util.c                         |   73 +-
 net/mac80211/vht.c                          |  212 ++-
 net/rfkill/rfkill-regulator.c               |    2 +-
 net/wireless/ap.c                           |   62 -
 net/wireless/core.c                         |   76 +-
 net/wireless/core.h                         |   22 +-
 net/wireless/mesh.c                         |   15 +-
 net/wireless/mlme.c                         |  230 +---
 net/wireless/nl80211.c                      | 1845 +++++++++++++++++------=
----
 net/wireless/nl80211.h                      |   68 -
 net/wireless/rdev-ops.h                     |   20 +-
 net/wireless/reg.c                          |    6 +-
 net/wireless/sme.c                          |   26 +-
 net/wireless/sysfs.c                        |   25 +-
 net/wireless/trace.h                        |   46 +
 59 files changed, 2537 insertions(+), 1911 deletions(-)


--=-fuVTHKcfbSi1ccdio5I7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJROGLsAAoJEDBSmw7B7bqr+8IQALY4bZJw7Ihroh6yz4LV5NlA
7iKbh90sasUw8q6XIZFsBQPfruRyocgB+TxcRvMNScQvabgTkaTu/OSSgVdO32JC
ljrWAspxHsB+60p4Hw0Nq2TLjsHE/QGA7DTTG19wnE8LJFuR5ndNAdRQniwOAUNx
BAOUAL+pSmIiC/UDDjhWgQ86Frod9EoA3Sq5NyFDyVGgmcyF4NPt/ZmsmDuZ51HG
q6iio3ZP+sfzLHuFuuMHfqUNvj4HYZViIsG05OH0Gqlfv27t7F2gUD6s6uIJjzs7
eaggp5+3yv+vCSuE+aCe84cSnIKegiKNhm8lIpOZ9g3EzmKCtaajFyhUiWEUBX0c
dAD4EhMMeEI3PmlJqIalbDz/HLtsZXEznXr/FaIw/YEyx9+lIlfr/pe/2QrYSlhn
ohdL2a4tkebSM8OVHlO47f+0aQzqihIbwiuYRTO2dL8Z8esFHtfF03S7kqs+lvgN
FXUb61pYdvLzO6PNBd8hMAJuJX7Nx2DB0j+T95I/oa08CwnIi1jej2zQbVwTY2rC
mDaa6v9ZAyu33Ggl7ClMot4sJzrqtV1AiHX9i97/7ynGZBdgSA3xFQ6g12Z1VvFj
QkURiq3eVmCHFUO643HEbUYXt2B0olyFIFA79/vhtKlHBBpHSMsNb2cRQ2VYhSQt
U4xg78Q6Ml2T/t0zC3PS
=i0lb
-----END PGP SIGNATURE-----

--=-fuVTHKcfbSi1ccdio5I7--

