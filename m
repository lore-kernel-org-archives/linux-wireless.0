Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42627 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3CTNYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 09:24:52 -0400
Message-ID: <1363785882.8224.3.camel@jlt4.sipsolutions.net> (sfid-20130320_142456_355871_C9197975)
Subject: pull-request: mac80211-next 2013-03-20
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 Mar 2013 14:24:42 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-gpliQ5y7LFii5opOJOAz"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gpliQ5y7LFii5opOJOAz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

I have accumulated a bunch of changes for -next as well.

Here I have a bunch of minstrel fixes from Felix, per-interface
multicast filtering from Alex, set_tim debouncing from Ilan,
per-interface debugfs cleanups from Stanislaw, an error return fix from
Wei and a number of small improvements and fixes that I made myself.

Let me know if there's any problem.

johannes


The following changes since commit 87f59c70ce6d1abeaaf97594835be29f746b81a0=
:

  mac80211: init mesh timer for user authed STAs (2013-03-06 16:36:14 +0100=
)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to f00f188f8212fec9976394976c4fd5d4a3bc4dcf:

  cfg80211: fix error return code in cfg80211_init() (2013-03-20 14:09:56 +=
0100)

----------------------------------------------------------------
Alexander Bondar (1):
      mac80211: add driver callback for per-interface multicast filter

Felix Fietkau (3):
      mac80211/minstrel_ht: improve rate selection stability
      mac80211/minstrel_ht: avoid useless sampling of high-probability slow=
er rates
      mac80211/minstrel_ht: do not sample actively used rates

Ilan Peer (1):
      mac80211: Call drv_set_tim only if there is a change

Johannes Berg (10):
      mac80211: provide race-free 64-bit traffic counters
      mac80211: provide ieee80211_sta_eosp()
      mac80211: clean up key freeing a bit
      mac80211: remove underscores from some key functions
      mac80211: batch key free synchronize_net()
      mac80211: remove a few set but unused variables
      mac80211: pass queue bitmap to flush operation
      mac80211: stop queues temporarily for flushing
      mac80211_hwsim: assign CAB queue properly on interface type change
      cfg80211: fix potential connection work crash

Stanislaw Gruszka (2):
      mac80211: move sdata debugfs dir to vif
      mac80211: remove vif debugfs driver callbacks

Wei Yongjun (1):
      cfg80211: fix error return code in cfg80211_init()

 Documentation/DocBook/80211.tmpl                   |   2 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |   2 +-
 drivers/net/wireless/ath/ath9k/main.c              |   2 +-
 drivers/net/wireless/ath/carl9170/main.c           |   2 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   2 +-
 drivers/net/wireless/iwlegacy/common.c             |   3 +-
 drivers/net/wireless/iwlegacy/common.h             |   2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |   2 +-
 drivers/net/wireless/mac80211_hwsim.c              |   8 +-
 drivers/net/wireless/p54/main.c                    |   2 +-
 drivers/net/wireless/rt2x00/rt2x00.h               |   2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |   2 +-
 drivers/net/wireless/rtlwifi/core.c                |   2 +-
 drivers/net/wireless/ti/wlcore/main.c              |   2 +-
 include/net/mac80211.h                             |  68 ++++++-----
 net/mac80211/cfg.c                                 |  29 +++--
 net/mac80211/debugfs_key.c                         |  10 +-
 net/mac80211/debugfs_netdev.c                      |  22 ++--
 net/mac80211/driver-ops.h                          |  60 ++++------
 net/mac80211/ieee80211_i.h                         |  11 +-
 net/mac80211/iface.c                               |  17 ++-
 net/mac80211/key.c                                 | 129 +++++++++++++++--=
----
 net/mac80211/key.h                                 |  15 +--
 net/mac80211/main.c                                |  22 +---
 net/mac80211/mesh.c                                |   5 +-
 net/mac80211/mlme.c                                |  12 +-
 net/mac80211/offchannel.c                          |   8 +-
 net/mac80211/pm.c                                  |   6 +-
 net/mac80211/rc80211_minstrel_ht.c                 |  24 +++-
 net/mac80211/scan.c                                |   7 +-
 net/mac80211/sta_info.c                            |  45 +++----
 net/mac80211/sta_info.h                            |   9 +-
 net/mac80211/trace.h                               |  35 +++++-
 net/mac80211/tx.c                                  |   8 +-
 net/mac80211/util.c                                |  48 ++++++--
 net/wireless/core.c                                |   4 +-
 net/wireless/sme.c                                 |   2 +-
 37 files changed, 374 insertions(+), 257 deletions(-)


--=-gpliQ5y7LFii5opOJOAz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRSbiaAAoJEDBSmw7B7bqrixQP/0pX9dHKZMzcgLJatOuK5oxN
ZxB2No8Z1RepND8SktoDJMN6shcVQoaHF05Nri5BVqoiz3CIbI3hhh/miMmnki4b
ngNU/msf6VXrIh3TmyRph45As0Mzv/vebPiTCpiEDC8w1p6bwfNMH1aodFWl+LhI
kB/NLEa2AMUUBVDdrnLxYOY2cSHdbsP4TWsyHtGU9Uwgff/x5Cs4qEqXgNbvZENj
gWFwuRj+ZDkmCPmCnuKjzQ4875ur+P9Fp3WW87p08+Qod8Otvrxb3DJnE9CAnpmh
R44xQQK9n4V9CNu4BiFDSITTVlNYW0r7efVYH2vVb9xXcm9fVEuI3glkfZ7LnNtu
fcUwzy+d1uNVpoDNxPBJZQoiBSIgH5APwZrNPN4I6w724YjcujCBLsHVckaYlHQx
HJ+bABUXuAlVy2jDRQJaCWxlxqc4K45s4u+6MRDjTIp9fBcRIGi9IoDnhhTKoBiA
JLtG3oYsyjf9LHuqApuxxdpXHcNi23CmHU3xRqNj7oGaV6PRF1B4asKKkBKq/6PX
cLAOH2GwFMtjttUwc1lg2HncbSzV0x4wokTgHl5PKwRMafxgxMaAEgQysdoW5mC8
a7OSmx7XmgsO59E5FqsU4HH1KE4MWdKLchF9bPNVa0xFvSZZarwVPRdubctQRdux
eGUYI6/m7mo5uk/ELp3T
=+xRQ
-----END PGP SIGNATURE-----

--=-gpliQ5y7LFii5opOJOAz--

