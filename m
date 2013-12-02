Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39666 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab3LBQMD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 11:12:03 -0500
Message-ID: <1386000716.20277.11.camel@jlt4.sipsolutions.net> (sfid-20131202_171209_603718_DDDB2B18)
Subject: pull-request: mac80211-next 2013-12-01
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 02 Dec 2013 17:11:56 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-p46C2rAyY2QAaNaHmpH4"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-p46C2rAyY2QAaNaHmpH4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

First pull request for -next ... This round looks a bit quieter, but
we'll see.

I have various improvements/cleanups/fixes all over, but the shortlog
shows that Luis's regulatory work and mesh work from the cozybit folks
are the biggest ones, along with the CSA fixes.

Let me know if there are any issues.

johannes

The following changes since commit 6b732323c1e1ced5c76350bfef2cc8c233f9dcb9=
:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/bl=
uetooth/bluetooth (2013-11-05 15:58:21 -0500)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to ddcc347b70f298f9d624cd0e250581d831d915fb:

  mac80211: fix rx_nss calculation for drivers with hw rc (2013-12-02 15:42=
:16 +0100)

----------------------------------------------------------------
Andrei Otcheretianski (1):
      cfg80211: aggregate mgmt_tx parameters into a struct

Arik Nemtsov (1):
      nl80211: better document NL80211_CMD_TDLS_MGMT

Avri Altman (1):
      mac80211: update ht flag if bss configuration changed

Bob Copeland (10):
      mac80211: fix off-by-one in llid check.
      mac80211: hold sta->lock across plink switch statements
      mac80211: mesh: factor out common plink close/estab code
      mac80211: mesh_plink: group basic fitness checks
      mac80211: mesh: rewrite rssi_threshold_check in C
      mac80211: mesh_plink: collapse the two switch statements together
      mac80211: mesh_plink: don't ignore holding timer
      mac80211: return -ENOMEM in mesh_plink_frame_tx
      mac80211: remove unused mesh_mgmt_ies_add() prototype
      mac80211: mesh: only get tsf if we need it

Chun-Yeow Yeoh (3):
      mac80211: use put_unaligned_le16 for precedence value in mesh
      mac80211: use put_unaligned_le16 in mesh_plink_frame_tx
      mac80211: use put_unaligned_le in mesh when necessary

Eliad Peller (1):
      mac80211: add min required channel definition field

Eyal Shapira (1):
      mac80211: enable easier manipulation of VHT beamforming caps

Felix Fietkau (1):
      cfg80211: fix reporting 5/10 MHz support to user space

Janusz Dziedzic (7):
      mac80211_hwsim: use debugfs_remove_recursive
      mac80211_hwsim: Add iface comb for DFS
      mac80211_hwsim: VHT add 160MHz width support
      cfg80211: add helper functions for start/end freq
      cfg80211: DFS check chandef usable before CAC
      cfg80211/mac80211: DFS setup chandef for cac event
      cfg80211: allow beaconing after DFS CAC

Johannes Berg (6):
      mac80211: remove useless tests for array
      cfg80211: add missing break in cfg80211_get_chan_state()
      cfg80211: don't allow drivers to unset NL80211_FEATURE_SCAN_FLUSH
      mac80211: verify ieee80211_key_replace() arguments
      mac80211_hwsim: use CLOCK_MONOTONIC_RAW
      mac80211: remove sta_info_flush() from interface teardown

Karl Beldan (5):
      mac80211: do not compute offset from ssn in Rx AMPDU reordering buffe=
r
      mac80211_hwsim: claim CCK support for HT clients
      mac80211: minstrel_ht: replace some occurences of MCS_GROUP_RATES
      mac80211: minstrels: spare numerous useless calls to get_random_bytes
      mac80211: minstrel_ht: do not sample unsupported rates

Luciano Coelho (1):
      mac80211: move csa_chandef to sdata

Luis R. Rodriguez (29):
      cfg80211: consolidate passive-scan and no-ibss flags
      cfg80211: force WIPHY_FLAG_CUSTOM_REGULATORY on wiphy_apply_custom_re=
gulatory()
      cfg80211: remove second argument from reg_process_hint()
      cfg80211: add function helpers to genregdb.awk
      cfg80211: fix parsing when db.txt ends on a rule
      cfg80211: enforce disabling channels by custom or strict settings
      cfg80211: check regulatory request alpha2 early
      cfg80211: processing core regulatory hints on its own
      cfg80211: process user regulatory requests on its own
      cfg80211: process driver regulatory requests on its own
      cfg80211: process country IE regulatory requests on their own
      cfg80211: process non country IE conflicting first
      cfg80211: add helper for kfree'ing last_request
      cfg80211: add helper for kfree'ing and assigning last_request
      cfg80211: add helper for calling CRDA
      cfg80211: allow only the core to request to update the world regdom
      cfg80211: move core reg_notfier() check to source
      cfg80211: pass the last_request to __set_regdom()
      cfg80211: set core regulatory updates on its own
      cfg80211: set user regulatory updates on its own
      cfg80211: set driver regulatory updates on its own
      cfg80211: rename __set_regdom() to reg_set_rd_country_ie()
      cfg80211: move regulatory flags to their own variable
      cfg80211: add flags to define country IE processing rules
      cfg80211: add an option to disable processing country IEs
      cfg80211: use enum nl80211_dfs_regions for dfs_region everywhere
      cfg80211: intersection dfs regions when intersecting regdomains
      cfg80211: distinguish unset DFS region from unknown
      cfg80211: replace print_dfs_region() with reg_dfs_region_str() helper

Matti Gottlieb (1):
      mac80211: Tx frame latency statistics

Max Stepanov (1):
      mac80211: add generic cipher scheme support

Michal Kazior (1):
      mac80211: fix rx_nss calculation for drivers with hw rc

Simon Wunderlich (5):
      cfg80211: protect beacon changing functions with wdev-lock
      mac80211: modify beacon using sdata/wdev-lock, not rtnl lock
      cfg80211/mac80211/ath6kl: acquire wdev lock outside ch_switch_notify
      mac80211: don't cancel csa finalize work within stop_ap
      mac80211: don't leak next beacon when csa is aborted

Thomas Pedersen (7):
      mac80211: consolidate calls to plink_frame_tx
      mac80211: factor peering frame processing into own function
      mac80211: consolidate rcu unlocks in plink frame rx
      mac80211: assign sta plid early
      mac80211: factor out peering FSM
      mac80211: factor out plink event gathering
      mac80211: clean up mesh local link ID generation

 Documentation/networking/regulatory.txt            |   4 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   4 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  11 +-
 drivers/net/wireless/ath/regd.c                    |  52 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |   2 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  19 +-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  |  35 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  66 +-
 drivers/net/wireless/cw1200/scan.c                 |  10 +-
 drivers/net/wireless/ipw2x00/ipw2100.c             |   4 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |   8 +-
 drivers/net/wireless/iwlegacy/3945-mac.c           |   8 +-
 drivers/net/wireless/iwlegacy/4965-mac.c           |   8 +-
 drivers/net/wireless/iwlegacy/common.c             |   4 +-
 drivers/net/wireless/iwlegacy/debug.c              |   8 +-
 drivers/net/wireless/iwlwifi/dvm/debugfs.c         |   8 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |   6 +-
 drivers/net/wireless/iwlwifi/dvm/scan.c            |   2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c    |   4 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c       |   4 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |   6 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c            |   4 +-
 drivers/net/wireless/mac80211_hwsim.c              | 101 ++-
 drivers/net/wireless/mwifiex/cfg80211.c            |  25 +-
 drivers/net/wireless/mwifiex/scan.c                |   4 +-
 drivers/net/wireless/rtlwifi/regd.c                |  54 +-
 drivers/net/wireless/ti/wl12xx/scan.c              |   2 +-
 drivers/net/wireless/ti/wlcore/cmd.c               |   2 +-
 drivers/net/wireless/ti/wlcore/main.c              |   3 +-
 drivers/net/wireless/ti/wlcore/scan.c              |  12 +-
 include/linux/ieee80211.h                          |   8 +-
 include/net/cfg80211.h                             |  76 +-
 include/net/mac80211.h                             |  40 +
 include/net/regulatory.h                           |  80 +-
 include/uapi/linux/nl80211.h                       |  47 +-
 net/mac80211/cfg.c                                 | 123 ++--
 net/mac80211/chan.c                                | 141 +++-
 net/mac80211/debugfs.c                             | 168 +++++
 net/mac80211/debugfs_sta.c                         | 134 ++++
 net/mac80211/ibss.c                                |   6 +-
 net/mac80211/ieee80211_i.h                         |  43 +-
 net/mac80211/iface.c                               |  14 +-
 net/mac80211/key.c                                 |  62 +-
 net/mac80211/key.h                                 |  13 +-
 net/mac80211/main.c                                | 147 ++--
 net/mac80211/mesh.c                                |   7 +-
 net/mac80211/mesh.h                                |   6 +-
 net/mac80211/mesh_hwmp.c                           |  91 +--
 net/mac80211/mesh_pathtbl.c                        |   7 +-
 net/mac80211/mesh_plink.c                          | 708 +++++++++--------=
-
 net/mac80211/mesh_ps.c                             |   3 +-
 net/mac80211/mesh_sync.c                           |  28 +-
 net/mac80211/mlme.c                                |  43 +-
 net/mac80211/rate.h                                |   4 +-
 net/mac80211/rc80211_minstrel.c                    |   3 +-
 net/mac80211/rc80211_minstrel_ht.c                 |  22 +-
 net/mac80211/rc80211_minstrel_ht_debugfs.c         |   3 +-
 net/mac80211/rx.c                                  |  88 ++-
 net/mac80211/scan.c                                |  10 +-
 net/mac80211/sta_info.c                            |  40 +-
 net/mac80211/sta_info.h                            |  38 +-
 net/mac80211/status.c                              |  78 ++
 net/mac80211/trace.h                               |  21 +-
 net/mac80211/tx.c                                  |  41 +-
 net/mac80211/util.c                                |  95 ++-
 net/mac80211/vht.c                                 |   7 +-
 net/mac80211/wpa.c                                 | 116 +++
 net/mac80211/wpa.h                                 |   2 +
 net/wireless/chan.c                                | 203 +++++-
 net/wireless/core.c                                |   6 +-
 net/wireless/core.h                                |  18 +-
 net/wireless/genregdb.awk                          |  45 +-
 net/wireless/ibss.c                                |   4 +-
 net/wireless/mesh.c                                |   3 +-
 net/wireless/mlme.c                                |  20 +-
 net/wireless/nl80211.c                             | 107 +--
 net/wireless/nl80211.h                             |   2 +-
 net/wireless/rdev-ops.h                            |  12 +-
 net/wireless/reg.c                                 | 802 ++++++++++++-----=
----
 net/wireless/reg.h                                 |   3 +-
 net/wireless/trace.h                               |  15 +-
 81 files changed, 2897 insertions(+), 1386 deletions(-)


--=-p46C2rAyY2QAaNaHmpH4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSnLFMAAoJEDBSmw7B7bqrjyIP/34BpuJda84NIhdlmKww8x0o
M8y9/QDJ56ZrvElHIV8CHTWYIPSGRrabDcAr0IIT5/4fhAYYDQG+UD0sjcp4p12+
K+yi5XzaG5d81VnO4+6lrpv2LYPJQnbTaF2Ih+zIb3qOBDIrYkMMBUul4HFsC4wY
AV3DzP8NU7dGvDBYhtEG+TfM5sq4QL+nI3qAq10yqSeOzn/WAgyO/iA69MO28w95
NA9RMil/xGzl31f6cGOMj6oCearZ2FqTsmI+MtxxPpE9+/KElPk4Xhv/MX1rpP6P
Kbrj4UezbTXF2XPmrMQaojLI/qyqT0UZCHCR7enu9H0mIg8hn4O0Hikvtzj6VhyE
YM/CgUKuwQMHV0qlJdYVD+HrnKCNoJvseM0SxcliEpYEfPfCW3XCs3/PGOZBPkaG
dptOytnw2mu0ALc+qUvI/nG3cZYJvmFMRN7o6eynGsc4kV6IoRDljBS99tAcHQdp
ylu6Gws1mYe+V09uCYFRZgQW999y421ZvM7J/NatZ+61e1P3hOziCukR9RW/ag1u
ZFn1ha2g0Adr1aIqcJAjYZzI8mMLL1lvt63WKEwiJO2Dm6s8XOHmmWAQ7OA6G2kE
hj4L65PXB9iujr5ztK4IsQG/B9MO0N28gTKAtRYXROjQ/WWGsGehxVfn+HdR8AcK
E7cUKB+vWmJuSW0KwSSK
=4aS+
-----END PGP SIGNATURE-----

--=-p46C2rAyY2QAaNaHmpH4--

