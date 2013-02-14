Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56855 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758953Ab3BNUs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 15:48:56 -0500
Message-ID: <1360874926.8210.28.camel@jlt4.sipsolutions.net> (sfid-20130214_214900_321564_63A6FD06)
Subject: pull-request: mac80211-next 2012-02-14
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 14 Feb 2013 21:48:46 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-CuuJRQ87GKTdeYFzs2/F"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CuuJRQ87GKTdeYFzs2/F
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

I know it's quick, but lots of things are in flight ...

Please pull to get
 * radar detection work from Simon
 * mesh improvements from Thomas
 * a connection monitoring/powersave fix from Wojciech
 * TDLS-related station management work from Jouni
 * VLAN crypto fixes from Michael Braun
 * CCK support in minstrel_ht from Felix
 * an SMPS (not SMSP, oops) related improvement in mac80211 (Emmanuel)
 * some WoWLAN work from Amitkumar Karwar: pattern match offset and a
   documentation fix
 * some WoWLAN work from myself (TCP connection wakeup feature API)
 * and a lot of VHT (and some HT) work (also from myself)

And a number of more random cleanups/fixes. I merged mac80211/master to
avoid a merge problem there.


It'd be nice if this could still go in, but I can also separate out the
fixes for 3.9 if it doesn't.

Thanks,
johannes


The following changes since commit 9c35d7d2368f54313b988a01c408e5cf863ffd9e=
:

  mac80211: Add flushes before going off-channel (2013-02-11 22:52:21 +0100=
)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 68c4ad7886d00537f3b2382ac52bc351d50b05f1:

  mac80211: prevent spurious HT/VHT downgrade message (2013-02-14 21:24:44 =
+0100)

----------------------------------------------------------------
Amitkumar Karwar (2):
      nl80211: minor correction in sample wowlan mask calculation
      nl80211: add packet offset information for wowlan pattern

Cong Ding (1):
      mac80211: fix error in sizeof() usage

Dan Carpenter (1):
      cfg80211: off by one in ieee80211_bss()

Emmanuel Grumbach (1):
      mac80211: allow driver to be stateless wrt. SMSP requests

Felix Fietkau (1):
      mac80211/minstrel_ht: add support for using CCK rates

Johannes Berg (32):
      mac80211: fix managed mode channel context use
      mac80211: fix channel selection bug
      cfg80211: configuration for WoWLAN over TCP
      mac80211: fix auth/assoc timeout handling
      mac80211: don't call bss_info_changed on p2p-device/monitor
      mac80211: always unblock CSA queue stop when disconnecting
      mac80211: don't pick up WPA vendor IE
      mac80211: use spin_lock_bh() for tim_lock
      mac80211: use spin_lock_bh() for TKIP lock
      Merge remote-tracking branch 'mac80211/master' into mac80211-next
      mac80211: pass station to ieee80211_vht_cap_ie_to_sta_vht_cap
      mac80211: stop toggling IEEE80211_HT_CAP_SUP_WIDTH_20_40
      wireless: define operating mode action frame
      mac80211: track number of spatial streams
      mac80211: handle VHT operating mode notification
      mac80211: init HT TX data before rate control
      mac80211: fix HT/VHT disable flags
      mac80211: fix ieee80211_change_chandef name
      mac80211: handle operating mode notif in beacon/assoc response
      mac80211: disable HT/VHT if AP has no HT/VHT capability
      mac80211: clean up channel use in ieee80211_config_ht_tx
      mac80211: add ieee80211_vif_change_bandwidth
      mac80211: move ieee80211_determine_chantype function
      mac80211: properly track HT/VHT operation changes
      cfg80211: allow drivers to selectively disable 80/160 MHz
      nl80211: advertise HT/VHT channel limitations
      mac80211: constify IE parsing
      mac80211: stop modifying HT SMPS capability
      cfg80211: advertise extended capabilities to userspace
      mac80211: advertise operating mode notification capability
      nl80211: renumber NL80211_FEATURE_FULL_AP_CLIENT_STATE
      mac80211: prevent spurious HT/VHT downgrade message

Jouni Malinen (2):
      cfg80211: Pass station (extended) capability info to kernel
      cfg80211: Pass TDLS peer's QoS/HT/VHT information during set_station

Luciano Coelho (1):
      cfg80211: check vendor IE length to avoid overrun

Michael Braun (2):
      mac80211: free ps->bc_buf skbs on vlan device stop
      mac80211: fix WPA with VLAN on AP side with ps-sta

Simon Wunderlich (2):
      nl80211/cfg80211: add radar detection command/event
      mac80211: add radar detection command/event

Thomas Pedersen (3):
      mac80211: consolidate MBSS change notification
      mac80211: cache mesh beacon
      mac80211: generate mesh probe responses

Wojciech Dubowik (1):
      mac80211: fix ieee80211_sta_tx_notify for nullfunc

 drivers/net/wireless/ath/ath9k/rc.c          |   2 +-
 drivers/net/wireless/iwlegacy/4965-rs.c      |   3 +-
 drivers/net/wireless/iwlegacy/common.c       |  16 +-
 drivers/net/wireless/iwlwifi/dvm/agn.h       |   2 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c        |  12 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c       |  36 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c        |  30 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c    |   5 +-
 drivers/net/wireless/rtlwifi/base.c          |   7 +-
 drivers/net/wireless/rtlwifi/rc.c            |   5 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c  |   6 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |   3 +-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c  |   3 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c |   3 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c  |   3 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c |   3 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c  |   3 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c |   3 +-
 drivers/net/wireless/ti/wl18xx/main.c        |   2 +-
 include/linux/ieee80211.h                    |  42 +-
 include/net/cfg80211.h                       | 136 ++++-
 include/net/mac80211.h                       |  52 +-
 include/uapi/linux/nl80211.h                 | 239 ++++++++-
 net/mac80211/cfg.c                           |  80 ++-
 net/mac80211/chan.c                          |  98 +++-
 net/mac80211/driver-ops.h                    |  17 +-
 net/mac80211/ht.c                            | 110 ++--
 net/mac80211/ibss.c                          |  23 +-
 net/mac80211/ieee80211_i.h                   | 121 +++--
 net/mac80211/iface.c                         |  26 +
 net/mac80211/main.c                          |  25 +-
 net/mac80211/mesh.c                          | 216 +++++++-
 net/mac80211/mesh.h                          |  26 +-
 net/mac80211/mesh_hwmp.c                     |  42 +-
 net/mac80211/mesh_pathtbl.c                  |  11 +-
 net/mac80211/mesh_plink.c                    |  41 +-
 net/mac80211/mesh_ps.c                       |  27 +-
 net/mac80211/mlme.c                          | 737 ++++++++++++++++-------=
----
 net/mac80211/pm.c                            |   2 +
 net/mac80211/rate.h                          |   2 +
 net/mac80211/rc80211_minstrel.c              |  29 ++
 net/mac80211/rc80211_minstrel.h              |   2 +
 net/mac80211/rc80211_minstrel_ht.c           | 177 +++++--
 net/mac80211/rc80211_minstrel_ht.h           |   5 +-
 net/mac80211/rc80211_minstrel_ht_debugfs.c   | 109 ++--
 net/mac80211/rx.c                            |  73 ++-
 net/mac80211/scan.c                          |   3 +
 net/mac80211/sta_info.c                      |   9 +-
 net/mac80211/sta_info.h                      |   8 +-
 net/mac80211/tkip.c                          |  10 +-
 net/mac80211/trace.h                         |  19 +
 net/mac80211/tx.c                            |  70 +--
 net/mac80211/util.c                          |  62 ++-
 net/mac80211/vht.c                           | 172 ++++++-
 net/mac80211/wpa.c                           |   5 +-
 net/wireless/chan.c                          | 142 +++++-
 net/wireless/core.c                          |   6 +-
 net/wireless/core.h                          |  31 ++
 net/wireless/mlme.c                          | 120 +++++
 net/wireless/nl80211.c                       | 643 +++++++++++++++++++++--
 net/wireless/nl80211.h                       |   7 +
 net/wireless/reg.c                           |  11 +
 net/wireless/scan.c                          |  24 +-
 net/wireless/trace.h                         |  45 ++
 64 files changed, 3166 insertions(+), 836 deletions(-)


--=-CuuJRQ87GKTdeYFzs2/F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRHU2uAAoJEDBSmw7B7bqrMZ4P/jk+tEjb51/g4SvlL/YWPAOD
WO9IvoURONt8gVlCdsNpc+u0LmxVOsgfbuQGLXsrde6H4nyAN0e3QOxlpYlE0ko5
Pg/iITfbXDjIxbNif9EcSVfqLqxRvahUqWi0cTnn9fbe8xJu9kgzeoQ0PfMhNez5
utEfvGx8I2O0zlmo9v7PGzCyYuINn9km8/xkl0ogjb6zDJf/kG8GjzTGk4rAxYsi
GSDg5u1MMKPKmJAkuDQ01x5jevAL2+KpmH296pf3vRRQWJjfHtK7pVUx7vvrP4fa
nxmPsmx+RNWIRjie3Ho2QXK/g7cmmE7YtS989chgzbfexes+nEscap5tfilinQHZ
ix2srtVm4ByRC+1W9ZFCAjYPrmoSQXkz/NUczal0Zj5EVIPtuaTenFrGPFAysqKZ
xhqc1tVCsrLvgZ7V2MDfqlwPulCncAPfjOrlvs4TZhzNteqgwQelwK2IfKydM8JU
R7Wqbh70GVzjCjT73WR59h0jpFl2indau84wEDJ0tBViu8XYnwvOZe7jb9DqTlXI
pu61+yu/z0ms1KBZsPoGWG4fEfA66LH9pHOARr43asKXTNE4cwZJfIWlFFjdk0i3
qYQx+nGk3/JRkHCXWO2B6Tkl/wRVVjxnBNzl25IVQFD8D5mLGLrpm9TmzVbrfrwd
HIOYqY58V2HJuwoYTh9Z
=opvq
-----END PGP SIGNATURE-----

--=-CuuJRQ87GKTdeYFzs2/F--

