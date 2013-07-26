Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58169 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab3GZIfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:35:43 -0400
Message-ID: <1374827740.8248.15.camel@jlt4.sipsolutions.net> (sfid-20130726_103547_059837_EC3771F9)
Subject: pull-request: mac80211-next 2013-07-26
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 26 Jul 2013 10:35:40 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-E/ww8XO+amP7gxIzQ2bW"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-E/ww8XO+amP7gxIzQ2bW
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


--=-E/ww8XO+amP7gxIzQ2bW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJR8jTcAAoJEDBSmw7B7bqrK7cQAJw5POR3RaYXGHONYUhKGTwa
sowXp0XFSQnvzyruMvW1yi229gCM7FvFdLPbmb8g8tZRZoZpkowLwal04XSorWeW
x0yrLAQ1PdgZBM5O1H4KMIKLTvrt5szvGsHAzkYUUTx7fOFnZa2Xaw/fYXItvLbD
dTPtmNDdUvQDqAI3DJOUt8WiQGN2KAeS3llUaPI3Tr7743QkEt1QVDKykh2HZXJv
3R/cEGApe2zBaVKQq6jb0qwvHYg4OlXFjuPi28x0PNFXfpkmWTNpocnb0USZyJ7y
yQeA54iTneUaujff21atMb8MF7zfQazB/JsTG9D1A0HDvLaClpVM7HSAqLG54IA3
gdGa9IJSua49QJoCuJlJY8Wyv07LejiHKIktaqdoulhcB0JgLgeO7M4B0ybwsrUw
eczb565U/8OwR5HbBELZazIYjBoNV/yyY44VU78ER5D0Sk9Rbc511HqCQZWFkpUY
NBBey1MUnpA3sfjjQ77ThAHVRB2D2WgCO8sNwFaD05KklcveJHVbrvLyHZGLG8bB
rFCdDigF9GtRhsvbZ0hiFlRazalKHvdnlKhlu4rf2ZAupX9AYgM+IOmiPT9yTfqx
z3utH1qDQ3BsLK+G4nZTcgeqrlX5lqvRWhxfzCZFv6hW57EniiGkEWyLK6NoNT9f
Htng+j9IEv1vS1A998cA
=p5DL
-----END PGP SIGNATURE-----

--=-E/ww8XO+amP7gxIzQ2bW--

