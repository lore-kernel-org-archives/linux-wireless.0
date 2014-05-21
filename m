Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41125 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbaEUPbA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 11:31:00 -0400
Message-ID: <1400686243.4136.4.camel@jlt4.sipsolutions.net> (sfid-20140521_173105_517313_F2D2B9E8)
Subject: pull-request: mac80211-next 2014-05-21
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 21 May 2014 17:30:43 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-dcYgObdlZBLmMb8aXm+h"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dcYgObdlZBLmMb8aXm+h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Since the merge window is getting nearer, and I have a whole bunch of
stuff accumulated, here's a new -next merge request :-)

We have a whole bunch of work on CSA by Andrei, Luca and Michal, but
unfortunately it doesn't seem quite complete yet so it's still disabled.
There's some TDLS work from Arik, and the rest is mostly minor fixes and
cleanups.

Let me know if there are any problems.

Thanks,
johannes


The following changes since commit f55ee0834247c88cb6981cb11eb1870392878371=
:

  mac80211_hwsim: Advertise support for AP mode channel width changes (2014=
-04-28 18:11:59 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git HEA=
D

for you to fetch changes up to 4d3df547e836f9a75b8de2b788449823c8db1d6a:

  cfg80211: don't set reg timeout for user-handled hint (2014-05-21 09:15:1=
8 +0200)

----------------------------------------------------------------
Andrei Otcheretianski (6):
      cfg80211: Add API to update CSA counters in mgmt frames
      mac80211: Update CSA counters in mgmt frames
      cfg80211: Support multiple CSA counters
      mac80211: Support multiple CSA counters
      mac80211: Provide ieee80211_beacon_get_template API
      mac80211: Handle the CSA counters correctly

Antonio Quartulli (3):
      cfg80211: export expected throughput through get_station()
      mac80211: export the expected throughput
      cfg80211: implement cfg80211_get_station cfg80211 API

Arik Nemtsov (3):
      mac80211: set an external flag for TDLS stations
      mac80211: move TDLS code to another file
      cfg80211: don't set reg timeout for user-handled hint

Felix Fietkau (1):
      cfg80211: allow restricting supported dfs regions

Janusz Dziedzic (1):
      cfg80211: fix start_radar_detection issue

Johannes Berg (8):
      cfg80211: remove BUG_ON usage
      mac80211: remove BUG_ON usage
      mac80211: mark local variable __maybe_unused
      mac80211: handle failed restart/resume better
      mac80211: minstrel-ht: small clarifications
      cfg80211: constify MAC addresses in cfg80211 ops
      cfg80211: constify more pointers in the cfg80211 API
      cfg80211: constify wowlan/coalesce mask/pattern pointers

Loic Poulain (1):
      rfkill-gpio: Use gpio cansleep version

Luciano Coelho (5):
      cfg80211: fix docbook warning
      mac80211: fix sparse warning caused by __ieee80211_channel_switch()
      cfg80211: pass the actual iftype when calling cfg80211_chandef_dfs_re=
quired()
      cfg80211: add documentation for max_num_csa_counters
      mac80211: fix csa_counter_offs argument name in docbook

Michal Kazior (5):
      mac80211: fix CSA tx queue stopping
      mac80211: split CSA finalize function
      cfg80211: export interface stopping function
      mac80211: ignore cqm during csa
      mac80211: disconnect iface if CSA unexpectedly fails

 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   7 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |   2 +-
 drivers/net/wireless/ath/ath6kl/wmi.h              |   2 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        |   4 +-
 drivers/net/wireless/ath/wil6210/main.c            |   4 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |   2 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   6 +-
 drivers/net/wireless/libertas/cfg.c                |   7 +-
 drivers/net/wireless/libertas/defs.h               |   3 +-
 drivers/net/wireless/mwifiex/11n.h                 |   2 +-
 drivers/net/wireless/mwifiex/cfg80211.c            |  19 +-
 drivers/net/wireless/mwifiex/main.h                |  22 +-
 drivers/net/wireless/mwifiex/tdls.c                |  44 +-
 drivers/net/wireless/mwifiex/util.c                |   6 +-
 drivers/net/wireless/mwifiex/wmm.c                 |  10 +-
 drivers/net/wireless/mwifiex/wmm.h                 |   5 +-
 drivers/net/wireless/orinoco/hw.c                  |   4 +-
 drivers/net/wireless/orinoco/hw.h                  |   4 +-
 drivers/net/wireless/orinoco/wext.c                |   4 +-
 drivers/net/wireless/rndis_wlan.c                  |   4 +-
 drivers/net/wireless/ti/wlcore/main.c              |   2 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h          |   4 +-
 drivers/staging/wlan-ng/cfg80211.c                 |   4 +-
 include/net/cfg80211.h                             | 184 ++++---
 include/net/mac80211.h                             |  78 ++-
 include/uapi/linux/nl80211.h                       |  25 +-
 net/mac80211/Makefile                              |   3 +-
 net/mac80211/cfg.c                                 | 538 +++++++----------=
----
 net/mac80211/chan.c                                |   4 +-
 net/mac80211/driver-ops.h                          | 121 +++--
 net/mac80211/ibss.c                                |   2 +-
 net/mac80211/ieee80211_i.h                         |  17 +-
 net/mac80211/iface.c                               |   7 +
 net/mac80211/key.c                                 |   7 +-
 net/mac80211/main.c                                |   2 +
 net/mac80211/mesh.c                                |   2 +-
 net/mac80211/mesh_pathtbl.c                        |   6 +-
 net/mac80211/mesh_sync.c                           |   2 +-
 net/mac80211/mlme.c                                |  46 +-
 net/mac80211/rc80211_minstrel.c                    |  12 +
 net/mac80211/rc80211_minstrel_ht.c                 |  22 +-
 net/mac80211/scan.c                                |  15 +-
 net/mac80211/tdls.c                                | 325 +++++++++++++
 net/mac80211/trace.h                               |  32 ++
 net/mac80211/tx.c                                  | 189 ++++++--
 net/mac80211/util.c                                |  46 +-
 net/rfkill/rfkill-gpio.c                           |  19 +-
 net/wireless/ap.c                                  |   4 +-
 net/wireless/chan.c                                |   5 +-
 net/wireless/core.c                                |  67 ++-
 net/wireless/core.h                                |   7 +
 net/wireless/ibss.c                                |   2 +-
 net/wireless/mesh.c                                |   4 +-
 net/wireless/nl80211.c                             | 140 ++++--
 net/wireless/rdev-ops.h                            |   2 +-
 net/wireless/reg.c                                 |   3 +-
 net/wireless/sme.c                                 |   8 +-
 net/wireless/trace.h                               |  37 +-
 net/wireless/util.c                                |  38 +-
 59 files changed, 1469 insertions(+), 723 deletions(-)
 create mode 100644 net/mac80211/tdls.c


--=-dcYgObdlZBLmMb8aXm+h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJTfManAAoJEDBSmw7B7bqreloP/12UntWFkHpMIOK0wTkVWXHE
/2At+68Gz6m1245LPOIBUZ6H4POjQVRoydvrPECCdBNpurKml0b1ybPzC5ZKVxMF
pfWS/OmkjcpHFIh1ldmDc2MONq6x28FqlvlPtEWB/w2w2+ERVOk/vb4RARheEOAf
Af+QtkcwMR7lyXpdD35MCj0r/hr84p5J1Byrlr3dtOCSEl/AZDzEfs9/UjFLGUZB
8qY8KsxbNFRsW8xLBTxzB+aILj7xVeKVo1FFo8GC6qXHxnE21g93IRbsJvh93FTH
RgHZLc1icvUr99fkNGA3v/vE0A3bNS4VDy0KfTtOzBSa5LT0PnreJpZlG0lUcaTI
UNMk3L/ahfYWebuDOIrngkiwUZ1nWwmqmgDghMbR4tzF0MHTw9oo91mFMPjqZgMD
XIo/Usm81JJF2of4RxlmWSy1bUU0jhCOmHJoCg0cmEAKNJeMH+0h9vRxEBDe4v9M
ikHkpSylh7/KSPKshvCwsGf4I0aTSKa6GnwxP4bhEaUqvgpzXwHl9d0Ybk2tQnno
Bi+SJfPRZVOT2Ed1EWxcWOkLAXWRDg7RosguPluGLEk/Hkj1iwCx4z2nezYP7gFW
0hcBpc/rDa+x0sDFBTMiHYPacVmlrhheiMJo1Q6T0ulBVOlQ7mMtH7kS1VKPBZSr
61hVJrPLYLG33r2e5FnF
=Oq4r
-----END PGP SIGNATURE-----

--=-dcYgObdlZBLmMb8aXm+h--

