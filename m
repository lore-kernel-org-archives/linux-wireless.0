Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44782 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932630Ab3BKW2W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 17:28:22 -0500
Message-ID: <1360621691.8738.60.camel@jlt4.sipsolutions.net> (sfid-20130211_232827_556330_C84B9E0E)
Subject: pull-request: mac80211-next 2012-02-11
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 23:28:11 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-TPgCT9HlW66E10ZuDtOV"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TPgCT9HlW66E10ZuDtOV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

I think I have enough changes for a new pull request ...

This time, I have relatively large number of fixes in various areas of
the code (a memory leak in regulatory, an RX race in mac80211, the new
radar checking caused a P2P device problem, some mesh issues with
stations, an older bug in tracing and for kernel-doc) as well as a
number of small new features. The biggest (in the diffstat) is my work
on hidden SSID tracking.

Please pull and/or let me know of issues.

Thanks,
johannes

-----

The following changes since commit 8708aac79e4572ba673d7a21e94ddca9f3abb7fc=
:

  rtlwifi: rtl8192cu: Add new USB ID (2013-02-08 14:51:43 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 9c35d7d2368f54313b988a01c408e5cf863ffd9e:

  mac80211: Add flushes before going off-channel (2013-02-11 22:52:21 +0100=
)

----------------------------------------------------------------
Alexander Bondar (1):
      mac80211: add vif debugfs driver callbacks

Christian Lamparter (1):
      mac80211: protect rx-path with spinlock

Emanuel Taube (1):
      mac80211: Add the DS Params for mesh to every band

Felix Fietkau (2):
      mac80211/minstrel_ht: show the number of retries for each rate in deb=
ugfs
      mac80211/minstrel_ht: remove the sampling bypass check for the lowest=
 rate

Ilan Peer (1):
      cfg80211: fix radar check for P2P_DEVICE

Johannes Berg (14):
      Merge remote-tracking branch 'wireless-next/master' into HEAD
      cfg80211: pass wiphy to cfg80211_ref_bss/put_bss
      wireless: fix kernel-doc
      mac80211: fix AP beacon loss messages
      mac80211: fix chandef tracing bug
      mac80211: explicitly copy channels to VLANs where needed
      cfg80211: track hidden SSID networks properly
      cfg80211: remove scan ies NULL check
      cfg80211: move TSF into IEs
      mac80211: introduce beacon-only timing data
      mac80211: remove dynamic PS driver interface
      mac80211: remove IEEE80211_HW_SCAN_WHILE_IDLE
      mac80211: simplify idle handling
      mac80211: remove unused code to mark AP station authenticated

Larry Finger (1):
      cfg80211: Fix memory leak

Seth Forshee (2):
      mac80211: Fix tx queue handling during scans
      mac80211: Add flushes before going off-channel

Thomas Pedersen (2):
      mac80211: stop plink timer only on mesh interfaces
      mac80211: fix mesh sta teardown

 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   4 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |   2 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        |   2 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |   2 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   4 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |   3 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |   1 -
 drivers/net/wireless/libertas/cfg.c                |   8 +-
 drivers/net/wireless/mwifiex/cfg80211.c            |   2 +-
 drivers/net/wireless/mwifiex/scan.c                |   2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c           |  11 +-
 drivers/net/wireless/orinoco/scan.c                |   4 +-
 drivers/net/wireless/rndis_wlan.c                  |   4 +-
 drivers/net/wireless/ti/wl1251/event.c             |   6 +-
 drivers/net/wireless/ti/wl1251/main.c              |  24 +-
 drivers/net/wireless/ti/wlcore/main.c              |   1 -
 drivers/staging/wlan-ng/cfg80211.c                 |   2 +-
 include/net/cfg80211.h                             |  38 ++-
 include/net/mac80211.h                             |  80 +++---
 net/mac80211/cfg.c                                 |   5 +-
 net/mac80211/chan.c                                |  65 +++--
 net/mac80211/debugfs.c                             |   2 -
 net/mac80211/driver-ops.h                          |  37 +++
 net/mac80211/ibss.c                                |  26 +-
 net/mac80211/ieee80211_i.h                         |  19 +-
 net/mac80211/iface.c                               | 106 ++------
 net/mac80211/main.c                                |  17 +-
 net/mac80211/mesh.c                                |  38 ++-
 net/mac80211/mesh.h                                |   3 +-
 net/mac80211/mesh_plink.c                          |  11 +-
 net/mac80211/mlme.c                                | 160 ++++++-----
 net/mac80211/offchannel.c                          |  35 ++-
 net/mac80211/rc80211_minstrel_ht.c                 |   4 -
 net/mac80211/rc80211_minstrel_ht_debugfs.c         |  11 +-
 net/mac80211/rx.c                                  |  81 +++---
 net/mac80211/scan.c                                |  20 +-
 net/mac80211/sta_info.c                            |   9 +-
 net/mac80211/sta_info.h                            |   1 +
 net/mac80211/trace.h                               |   4 +-
 net/mac80211/tx.c                                  |  15 ++
 net/wireless/core.c                                |   2 +-
 net/wireless/core.h                                |   4 +-
 net/wireless/ibss.c                                |   4 +-
 net/wireless/mlme.c                                |  14 +-
 net/wireless/nl80211.c                             |  27 +-
 net/wireless/reg.c                                 |   9 +-
 net/wireless/scan.c                                | 295 ++++++++++++++++-=
----
 net/wireless/sme.c                                 |  16 +-
 net/wireless/util.c                                |   2 +-
 49 files changed, 720 insertions(+), 522 deletions(-)


--=-TPgCT9HlW66E10ZuDtOV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRGXB8AAoJEDBSmw7B7bqrO5sQAMMO2ZoPbdUfQaS3WB5aBzkd
5YAxPDuSowMac49fAaVJZ9vX/gr4ozPAXDsbrIJYiOV+WcnKtY2IuH4x2BVJHCYI
qSGrslmVTGDocjtUmVggPJarM0znNmrBtbGnimO1ZeY602VllqHkD6fr2ZXiTi7H
rTlKrQLloB4fr14nj8S877PN/JDDZB/GMQXz9QfzrdOref9oB/OcX2PLCkFqboc7
mArdCcfrb/TYBZZDMJGmGMgZ3jwCy7OtTbHQVAn7iMYFsz6EEwM+l1cbBonxhqWx
KVK/JUH6DlwBvlTKFNR4nY8KM8aGmJeus2qRJq1071WfZOQ2VQ/K8K/XIpkugOhP
gEnadhie5WWN/RantN4+5LlE36wGArW3aEqtrokgeellY9UqG+XGzPwYvfy0lR+u
fyk6bzxrsqu8NO8nGHq6M7mCfelYyoZk66fXB610827n8cgRnYxht/a86ELzSLFs
LYpMbzjdv7kQcgioM4Xek7YWQJDovQfhWyorZxjJnxckzvFZexLQHBRKkwx4X+fO
2BGMQAYla1B/FB5p57QAlalYI0tfvS4kkJJyXhZGN5poEzLwinWCyKZrhDGQeinI
MnR5gDW/JMeRuwRqK2yhX6Ltcfk8ESNIw0NwrRLHN3vzYLdOjkU1o1sG1bBaVOcZ
g9OtAlf9BWVZb+pTd0T1
=Uxyl
-----END PGP SIGNATURE-----

--=-TPgCT9HlW66E10ZuDtOV--

