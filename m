Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58881 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895Ab3BOIw3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 03:52:29 -0500
Message-ID: <1360918340.8622.1.camel@jlt4.sipsolutions.net> (sfid-20130215_095232_893020_739CA17B)
Subject: pull-request: mac80211-next 2012-02-15
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 15 Feb 2013 09:52:20 +0100
In-Reply-To: <1360874926.8210.28.camel@jlt4.sipsolutions.net> (sfid-20130214_214900_321564_63A6FD06)
References: <1360874926.8210.28.camel@jlt4.sipsolutions.net>
	 (sfid-20130214_214900_321564_63A6FD06)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-D9CoEfWBTe9qZK7FkZV3"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-D9CoEfWBTe9qZK7FkZV3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Sorry the resend/rebase -- Fengguang Wu's build testing found a
kernel-doc error ... (I guess I should run that myself)

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

johannes


The following changes since commit 9c35d7d2368f54313b988a01c408e5cf863ffd9e=
:

  mac80211: Add flushes before going off-channel (2013-02-11 22:52:21 +0100=
)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 93c78c5debeb9c7101ecc73347d4730c26a98c05:

  mac80211_hwsim: ask mac80211 to reserve space for chanctx.drv_priv (2013-=
02-15 09:41:45 +0100)

----------------------------------------------------------------
Amitkumar Karwar (2):
      nl80211: minor correction in sample wowlan mask calculation
      nl80211: add packet offset information for wowlan pattern

Emmanuel Grumbach (1):
      mac80211: allow driver to be stateless wrt. SMSP requests

Felix Fietkau (1):
      mac80211/minstrel_ht: add support for using CCK rates

Johannes Berg (30):
      cfg80211: configuration for WoWLAN over TCP
      mac80211: fix auth/assoc timeout handling
      mac80211: don't call bss_info_changed on p2p-device/monitor
      mac80211: always unblock CSA queue stop when disconnecting
      mac80211: don't pick up WPA vendor IE
      mac80211: use spin_lock_bh() for tim_lock
      mac80211: use spin_lock_bh() for TKIP lock
      Merge remote-tracking branch 'mac80211/master' into HEAD
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

Karl Beldan (1):
      mac80211_hwsim: ask mac80211 to reserve space for chanctx.drv_priv

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
 drivers/net/wireless/mac80211_hwsim.c        |   1 +
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
 65 files changed, 3167 insertions(+), 836 deletions(-)


--=-D9CoEfWBTe9qZK7FkZV3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRHfdEAAoJEDBSmw7B7bqr5dIP/1gd+JYNf8FAyWZj1B87JoG6
653L0A/OyuU9ppzRMmIOM5jQiOQo26dfVU3sPVpOTKXSvDwvUhGa0E0dJ67EY0Gk
cDYJMgOyvVSUWCPdTr5A/0W5ZU0jwQDImMeVHYX+JtOTtbX0ckPoONI11mpyuLvZ
qDL9dYCaOPh8ikIDYPh3TDMTcE3Ac26D5datxRlyYEf33WK/EICeRl06w3ksTT7O
62bucO5IT2xybtQiIxMaLvRlHab8PDD1S6H8+NaxsFIcAPPN5JnM4e91q4xg346J
iXAfurof9n5+iSTr++9EzFENKXIgdoX29Qh49/8oLHP1Ya9NL2lPxx0CsDbRYjqm
w7z64ciz/NVSZ+rFI+gBYL2F6pQWNE2Ta68rXDx70o27i8TpQzuqCTElsM6RGnN0
yJypktx4k7G6MAZzb+kbo9gb7FvkfwFHz/GvqjZf7jkpXtUbVkIKlpluIsbWto83
19xjy5fnoPcD1IqAzDK7+jAPa6DuUu6og7XU9V0k4EEo8NBSwVinWnyRRrLTyBst
+zrNScemmoxfFLOOFdAqhRhhppqaC4HgJpbRqa7neAStCQrzHMPgy7h+A1wi9ONZ
XlYeB6PCWx5KJRmDJ2qJ8GgdCrZVbLztURilCTFWcj2UcYDZ9/OT5EllScNLNytz
+5Xwx8GcO9BiEPBClDX9
=hlKP
-----END PGP SIGNATURE-----

--=-D9CoEfWBTe9qZK7FkZV3--

