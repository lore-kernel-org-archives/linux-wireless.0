Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58167 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3GZIfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:35:38 -0400
Message-ID: <1374827732.8248.14.camel@jlt4.sipsolutions.net> (sfid-20130726_103543_847661_DE76F19B)
Subject: pull-request: mac80211-next 2013-07-26
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 26 Jul 2013 10:35:32 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-9sqWYkZc4UTnrZyY/Zpr"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9sqWYkZc4UTnrZyY/Zpr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

This is a more traditional pull request without patches since they've
all been to the list :-) First set of updates for mac80211-next.

The biggest change here is probably the initial 5/10 MHz support for
IBSS, the remaining patches are smaller features and some cleanups.

Let me know if there's any problem.

johannes


The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092=
:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to c82b5a74cc739385db6e4275fe504a0e9469bf01:

  mac80211: make active monitor injection work w/ HW queue (2013-07-16 09:5=
8:19 +0300)

----------------------------------------------------------------
Amitkumar Karwar (2):
      cfg80211/nl80211: rename packet pattern related structures and enums
      cfg80211/nl80211: Add packet coalesce support

Chun-Yeow Yeoh (1):
      mac80211: set forwarding in mesh capability info

Johannes Berg (6):
      wireless: indent kernel-doc with tabs
      mac80211: add per-chain signal information to radiotap
      mac80211_hwsim: use ieee80211_free_txskb
      mac80211_hwsim: claim uAPSD support
      mac80211_hwsim: claim active monitor support
      mac80211: make active monitor injection work w/ HW queue

Simon Wunderlich (14):
      nl80211: enable HT overrides for ibss
      mac80211: enable HT overrides for ibss
      nl80211: add scan width to bss and scan request structs
      mac80211/rc80211: add chandef to rate initialization
      mac80211: fix timing for 5 MHz and 10 MHz channels
      mac80211: add radiotap flag and handling for 5/10 MHz
      mac80211: select and adjust bitrates according to channel mode
      cfg80211/mac80211: get mandatory rates based on scan width
      cfg80211/mac80211: use reduced txpower for 5 and 10 MHz
      mac80211: allow scanning for 5/10 MHz channels in IBSS
      mac80211: return if IBSS chandef can not be used
      nl80211: allow 5 and 10 MHz channels for IBSS
      mac80211: fix regression when initializing ibss wmm params
      mac80211: fix off-by-one regression in ibss beacon generation

 drivers/net/wireless/ath/ath9k/main.c   |   2 +-
 drivers/net/wireless/ath/ath9k/rc.c     |   2 +
 drivers/net/wireless/iwlegacy/3945-rs.c |   1 +
 drivers/net/wireless/iwlegacy/4965-rs.c |   1 +
 drivers/net/wireless/iwlwifi/dvm/rs.c   |   3 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c   |   5 +-
 drivers/net/wireless/mac80211_hwsim.c   |  10 +-
 drivers/net/wireless/mwifiex/cfg80211.c |   3 +-
 drivers/net/wireless/rtlwifi/rc.c       |   1 +
 drivers/net/wireless/ti/wlcore/main.c   |  10 +-
 include/net/cfg80211.h                  | 164 +++++++++++++--
 include/net/ieee80211_radiotap.h        |   4 +
 include/net/mac80211.h                  |  30 +--
 include/uapi/linux/nl80211.h            | 153 ++++++++++++--
 net/mac80211/cfg.c                      |  45 ++--
 net/mac80211/ht.c                       |  53 +++--
 net/mac80211/ibss.c                     | 154 +++++++++++---
 net/mac80211/ieee80211_i.h              |  49 ++++-
 net/mac80211/iface.c                    |   2 +-
 net/mac80211/main.c                     |  15 +-
 net/mac80211/mesh.c                     |   7 +-
 net/mac80211/mesh_plink.c               |   2 +-
 net/mac80211/mlme.c                     |  98 +++++----
 net/mac80211/rate.c                     |  46 ++--
 net/mac80211/rate.h                     |  22 +-
 net/mac80211/rc80211_minstrel.c         |  33 ++-
 net/mac80211/rc80211_minstrel_ht.c      |  15 +-
 net/mac80211/rc80211_pid_algo.c         |   1 +
 net/mac80211/rx.c                       |  97 ++++++---
 net/mac80211/scan.c                     |  72 ++++++-
 net/mac80211/status.c                   |  18 +-
 net/mac80211/tx.c                       |  29 ++-
 net/mac80211/util.c                     | 216 +++++++++++++------
 net/wireless/core.c                     |   9 +
 net/wireless/core.h                     |   2 +
 net/wireless/mesh.c                     |   5 +-
 net/wireless/nl80211.c                  | 358 ++++++++++++++++++++++++++++=
++--
 net/wireless/nl80211.h                  |   2 +
 net/wireless/scan.c                     |  31 +--
 net/wireless/trace.h                    |  12 +-
 net/wireless/util.c                     |  14 +-
 41 files changed, 1406 insertions(+), 390 deletions(-)


--=-9sqWYkZc4UTnrZyY/Zpr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJR8jTUAAoJEDBSmw7B7bqrznwP/jYOTUrTsrKbUKzOtP3dVNv/
bdpmpXX8pLgnK673feO9Im+iWyL72fQW2w38PIxH+ou7aMy1h+7Y+XZQ91k3UOEe
WaWi/cdBIeIMwzGGKmWo4pEE1XLUGSnwcgRA4U4Ujz3TTuJYWkOf20wkebZ146xh
MRM2zL2twZpwSvhhVNZExBqqOnjqjYSF1wCVDAeA90CLb1k54uMomOJcFhAG5Rxu
nR3HXD6Jgmp45i6J8TbE4Eamiv8lIE62qpW+Pp4hp8ITt8Qnw69hctTeTN+R6tpz
VEfFYKuBHbobMhehstDK/HmqR2GqU/brjDPZJMuOMMzuZqOQycNO9R6ICiSSU+Bm
g7uacK1gLOCZke7rV4Dn9clpJu1LMb/8q1KdpQobFulmYeKXef3CC3iq16sR3jdV
ArFeiO2VFpdLWMFsU1YHcX+L70Uw8HJkG88n0I4h78uCi7wjStu/6umXLuX4uZxW
T03iwcVLXoxmMacP90S+YZBlU1LKCA50S2UKKwK5EWN/kpWYaeE5lw1W73wSVIE/
7VCL4AaaqQ6hF/4kvsHis8Z31LP5XNQt4oqm8RHugnjoItmd1KjF7MhhUIeUhC5Q
n/8Ogvkvw0vdwLwUw9ZIL2DbEXnYhwvNOtulIu4/CryeTdf+Bn2WkGpSatM8gbJ8
XiBFkibUkg4vxsEIAd3i
=qT0G
-----END PGP SIGNATURE-----

--=-9sqWYkZc4UTnrZyY/Zpr--

