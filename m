Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40631 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903AbaD1Qao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2014 12:30:44 -0400
Message-ID: <1398702630.4132.9.camel@jlt4.sipsolutions.net> (sfid-20140428_183051_634236_AE261AD2)
Subject: pull-request: mac80211-next 2014-04-28
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 28 Apr 2014 18:30:30 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-jq22XkQA2sI9oxHDdtRQ"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jq22XkQA2sI9oxHDdtRQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Somehow it seems I got behind and should have sent this to you earlier,
but here it is now ...

In this round we have a large number of small features and improvements
from people too numerous to list here. The only really bit thing is
Micha=C5=82 and Luca's CSA work (including changing how interface combinati=
on
verification is done).

Let me know if there's any problem.

johannes


The following changes since commit cd6362befe4cc7bf589a5236d2a780af2d47bcc9=
:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next (2014-=
04-02 20:53:45 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to f55ee0834247c88cb6981cb11eb1870392878371:

  mac80211_hwsim: Advertise support for AP mode channel width changes (2014=
-04-28 18:11:59 +0200)

----------------------------------------------------------------
Arik Nemtsov (1):
      cfg80211: avoid freeing last_request while in flight

Bob Copeland (3):
      mac80211: mesh: use u16 return type for u16 getter
      mac80211: fix mesh_add_rsn_ie IE finding loop
      mac80211: mesh: always use the latest target_sn

David Spinadel (1):
      cfg80211: Add indoor only and GO concurrent channel attributes

Emmanuel Grumbach (1):
      mac80211: add vif to flush call

Ilan Peer (5):
      cfg80211: Add Kconfig option for cellular BS hints
      cfg80211: Enable GO operation on additional channels
      cfg80211: Add an option to hint indoor operation
      cfg80211: Enable GO operation on indoor channels
      cfg80211: Fix GO Concurrent relaxation on UNII-3

Jan-Simon M=C3=B6ller (1):
      mac80211: remove VLAIS usage from mac80211

Janusz Dziedzic (1):
      cfg80211: reg: set DFS CAC time in case of custom regd

Johannes Berg (3):
      cfg80211: allow userspace to take ownership of interfaces
      cfg80211: reject invalid IBSS BSSIDs in wext compat code
      cfg80211: ignore invalid BSSIDs when looking for BSSes

Jouni Malinen (4):
      mac80211: Allow HT capa override to add 40 MHz intolerant
      cfg80211: Dynamic channel bandwidth changes in AP mode
      mac80211: Support dynamic AP mode channel width changes
      mac80211_hwsim: Advertise support for AP mode channel width changes

Kalle Valo (1):
      cfg80211: update comment about WIPHY_FLAG_CUSTOM_REGULATORY

Luciano Coelho (9):
      cfg80211: refactor cfg80211_can_use_iftype_chan()
      cfg80211/mac80211: refactor cfg80211_chandef_dfs_required()
      cfg80211/mac80211: move interface counting for combination check to m=
ac80211
      cfg80211/mac80211: move combination check to mac80211 for ibss
      cfg80211/mac80211: move more combination checks to mac80211
      mac80211: split ieee80211_vif_change_channel in two
      mac80211: refactor ieee80211_assign/unassign_vif_chanctx into one
      mac80211: implement chanctx reservation
      mac80211: allow reservation of a running chanctx

Luis R. Rodriguez (1):
      cfg80211: fix processing world regdomain when non modular

Marek Kwaczynski (1):
      mac80211: add option to generate CCMP IVs only for mgmt frames

Michal Kazior (14):
      mac80211: protect AP VLAN list with local->mtx
      cfg80211: fix radar_detect combination checking
      cfg80211: allow drivers to iterate over matching combinations
      mac80211: add max channel calculation utility function
      mac80211: prevent chanctx overcommit
      mac80211: add support for radar detection for reservations
      mac80211: track assigned vifs in chanctx
      mac80211: track reserved vifs in chanctx
      mac80211: improve find_chanctx() for reservations
      mac80211: improve chanctx reservation lookup
      mac80211: split ieee80211_new_chanctx()
      mac80211: split ieee80211_free_chanctx()
      mac80211: fix racy usage of chanctx->refcount
      mac80211: compute chanctx refcount on-the-fly

Monam Agarwal (2):
      cfg80211: regulatory: use RCU_INIT_POINTER
      mac80211: use RCU_INIT_POINTER

Pawel Kulakowski (1):
      mac80211: Allow disabling LDPC

Rostislav Lisovy (3):
      mac80211: Update conf_is_ht() to work properly with 5/10MHz channels
      cfg80211: Add attributes describing prohibited channel bandwidth
      cfg80211: Use 5MHz bandwidth by default when checking usable channels

Zhao, Gang (11):
      cfg80211: slightly clean up of cfg80211_sme_connect()
      mac80211: fix some missing includes
      cfg80211: remove unused wiphy argument from cfg80211_wext_freq()
      mac80211: return bool instead of numbers in yes/no function
      mac80211: remove unnecessary BUG_ON()
      cfg80211: change registered device pointer name
      cfg80211: change wiphy_to_dev function name
      cfg80211: change return value of notifier function
      mac80211: change return value of notifier function
      mac80211: avoid calling useless channel context code
      mac80211: remove unnecessary assignment

 Documentation/DocBook/80211.tmpl                   |   1 +
 drivers/net/wireless/ath/ar5523/ar5523.c           |   3 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   3 +-
 drivers/net/wireless/ath/ath9k/main.c              |   3 +-
 drivers/net/wireless/ath/carl9170/main.c           |   4 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   3 +-
 drivers/net/wireless/cw1200/sta.c                  |   3 +-
 drivers/net/wireless/cw1200/sta.h                  |   3 +-
 drivers/net/wireless/iwlegacy/common.c             |   3 +-
 drivers/net/wireless/iwlegacy/common.h             |   3 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |   3 +-
 drivers/net/wireless/mac80211_hwsim.c              |   5 +-
 drivers/net/wireless/p54/main.c                    |   3 +-
 drivers/net/wireless/rt2x00/rt2x00.h               |   3 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |   3 +-
 drivers/net/wireless/rtlwifi/core.c                |   3 +-
 drivers/net/wireless/ti/wlcore/main.c              |   3 +-
 drivers/staging/rtl8821ae/core.c                   |  14 +-
 include/net/cfg80211.h                             |  86 ++-
 include/net/mac80211.h                             |  31 +-
 include/net/regulatory.h                           |   6 +
 include/uapi/linux/nl80211.h                       |  42 ++
 net/mac80211/aes_ccm.c                             |  37 +-
 net/mac80211/cfg.c                                 |  53 +-
 net/mac80211/chan.c                                | 614 +++++++++++++++++=
----
 net/mac80211/debugfs.c                             |   2 +-
 net/mac80211/debugfs.h                             |   2 +
 net/mac80211/debugfs_netdev.h                      |   2 +
 net/mac80211/driver-ops.h                          |   8 +-
 net/mac80211/ht.c                                  |  22 +-
 net/mac80211/ibss.c                                |  75 ++-
 net/mac80211/ieee80211_i.h                         |  33 +-
 net/mac80211/iface.c                               |  36 +-
 net/mac80211/main.c                                |   8 +-
 net/mac80211/mesh.c                                |  36 +-
 net/mac80211/mesh_hwmp.c                           |   5 +-
 net/mac80211/michael.h                             |   1 +
 net/mac80211/mlme.c                                |   4 +-
 net/mac80211/rx.c                                  |  19 +-
 net/mac80211/scan.c                                |  10 +-
 net/mac80211/sta_info.c                            |   3 +-
 net/mac80211/util.c                                | 145 ++++-
 net/mac80211/wpa.c                                 |   5 +-
 net/wireless/Kconfig                               |  37 ++
 net/wireless/chan.c                                | 176 +++++-
 net/wireless/core.c                                |  75 ++-
 net/wireless/core.h                                |  46 +-
 net/wireless/ethtool.c                             |  10 +-
 net/wireless/ibss.c                                |  41 +-
 net/wireless/mesh.c                                |  28 +-
 net/wireless/mlme.c                                |  38 +-
 net/wireless/nl80211.c                             | 499 +++++++++--------
 net/wireless/rdev-ops.h                            |  13 +
 net/wireless/reg.c                                 | 153 ++++-
 net/wireless/reg.h                                 |  18 +
 net/wireless/scan.c                                | 154 +++---
 net/wireless/sme.c                                 |  40 +-
 net/wireless/trace.h                               |  29 +-
 net/wireless/util.c                                | 171 +++---
 net/wireless/wext-compat.c                         |  40 +-
 net/wireless/wext-compat.h                         |   2 +-
 net/wireless/wext-sme.c                            |  12 +-
 62 files changed, 2051 insertions(+), 882 deletions(-)


--=-jq22XkQA2sI9oxHDdtRQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJTXoImAAoJEDBSmw7B7bqrDVwP/3DRQeGt4/k/RMV6bpY2pf1N
JzRdigNHn1NlfyBWf37rA5I6vvpg+jg/lJZUwx0Rk/bjC3nlTQu5xW/BraGDuSa0
rmMOdkD9tMjXnkijwPGQ3nF/aEKH6LeC1stlPqC31BBnwh2XBLw1GrFOYE9E9tR3
8GyoJHhkg6sCkZ+1/GSnkliRMWwBlfGLVwt9e7ptr+PIc84TeQe7OHZnoK4i0ckU
OReKsQwhRd0Qtkxad6MOz3qjB9fgh9Ue/B25EvpVv/b2kmmVENfH23nZXz6dnTMx
II6rBoj1HgqUP6Q7x6c8MCUfNzeGqnwgnpOjA6mG0bAMmpiEV1vritN1kmr06jJo
IPR0QNRP4OoO83Ey217sWNm6xQlodkYPTMQE4zEeNbYHRLIjlYarkI+EMWG+YSo3
jd3HFLQ14lvGlw3nX6OyIYSwWmKYv4seuge2Oz/QOFRXyVE0zzWgJHxAVSWxK9mj
fHsiGd0fnKh7ZjomLwNHIjyYaGdgOERN1w3UdSmB3QtRCo0U1YWYBU9w/9xveO/r
+KDWWVqxOmHmCFFayDS6nrNv3hZNiVbfijt53t3PMeTtQtumaUPekJY2pjTv79Nq
nMr2BHkFOmZ3SRz5JQwFNi02x7eAUMQHrYd4g0NIytK5EjDeygn353NzXgkqJId1
CvlAzKdfIKiJCxPDEumc
=sd56
-----END PGP SIGNATURE-----

--=-jq22XkQA2sI9oxHDdtRQ--

