Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41523 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab2LCUna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 15:43:30 -0500
Message-ID: <1354567428.9717.18.camel@jlt4.sipsolutions.net> (sfid-20121203_214333_353271_AC19B200)
Subject: pull-request: mac80211-next 2012-12-03
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Dec 2012 21:43:48 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-QhIo8xsyAyLm8yv8ZqYL"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QhIo8xsyAyLm8yv8ZqYL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Linus tagged -rc8, so maybe I have a chance of getting a few more things
into -next :-)

If you think there's any chance this might make it still, please pull my
mac80211-next tree (per below). This contains a relatively large number
of fixes to the previous code, as well as a few small features:
 * VHT association in mac80211
 * some new debugfs files
 * P2P GO powersave configuration
 * masked MAC address verification

The biggest patch is probably the BSS struct changes to use RCU for
their IE buffers to fix potential races. I've not tagged this for stable
because it's pretty invasive and nobody has ever seen any bugs in this
area as far as I know.

johannes

----

The following changes since commit ec816087e8978b74c1bd5fae0e335dd97d964e9f=
:

  cfg80211: fix some tracing output issues (2012-11-26 12:48:17 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to da29d2a5780d80857773d7776b7603a449b0b6e0:

  cfg80211: fix channel error on mesh join (2012-12-03 11:24:49 +0100)

----------------------------------------------------------------
Antonio Quartulli (1):
      mac80211: allow userspace registration for probe requests in IBSS

Dan Carpenter (1):
      mac80211: fix potential NULL dereference

Helmut Schaa (2):
      mac80211: reject setting masked mac addresses
      mac80211: don't reinit rate control when mesh sta exists

Johannes Berg (13):
      cfg80211: rework chandef checking and export it
      mac80211: support VHT association
      mac80211: support (partial) VHT radiotap information
      nl80211: support P2P GO powersave configuration
      mac80211: support P2P GO powersave configuration
      nl80211: remove unnecessary checks
      cfg80211: don't BUG_ON BSS struct issues
      cfg80211: fix whitespace in scan handling
      cfg80211: fix cmp_hidden_bss
      mac80211: make ieee80211_build_preq_ies safer
      mac80211: remove probe response temporary buffer allocation
      cfg80211: fix BSS struct IE access races
      mac80211: simplify loop in minstrel_ht

Mahesh Palivela (1):
      cfg80211: Remove unused VHT chan code

Marco Porsch (2):
      mac80211: fix for mesh sync to indicate TBTT adjustment
      cfg80211: fix channel error on mesh join

Saravana (4):
      mac80211: add debugfs file for last ack signal
      mac80211: add debugfs file for current tx rate
      mac80211: re-organize the rx rate calculation logic
      mac80211: add debugfs file for last rx rate

Simon Wunderlich (3):
      nl80211: Fix HT_IBSS feature check in ibss_join
      mac80211: Fix typo in mac80211.h
      mac80211: return if CSA is not handle

 drivers/net/wireless/libertas/cfg.c      |   9 +-
 drivers/net/wireless/mac80211_hwsim.c    |   7 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c |  35 ++-
 drivers/net/wireless/ti/wl1251/main.c    |   4 +-
 drivers/net/wireless/ti/wlcore/cmd.c     |   4 +-
 include/linux/ieee80211.h                |  15 +
 include/net/cfg80211.h                   |  69 +++--
 include/net/ieee80211_radiotap.h         |  24 ++
 include/net/mac80211.h                   |  12 +-
 include/uapi/linux/nl80211.h             |  16 ++
 net/mac80211/cfg.c                       |  77 ++++--
 net/mac80211/debugfs_sta.c               |  36 +++
 net/mac80211/ieee80211_i.h               |   5 +-
 net/mac80211/iface.c                     |  45 +++
 net/mac80211/main.c                      |   5 +-
 net/mac80211/mesh_plink.c                |   3 +-
 net/mac80211/mesh_sync.c                 |   4 +
 net/mac80211/mlme.c                      | 431 ++++++++++++++++++++++-----=
--
 net/mac80211/rc80211_minstrel_ht.c       |   8 +-
 net/mac80211/rx.c                        |  42 ++-
 net/mac80211/scan.c                      |  21 +-
 net/mac80211/sta_info.h                  |   4 +
 net/mac80211/status.c                    |   3 +
 net/mac80211/tx.c                        |   9 +-
 net/mac80211/util.c                      |  58 ++--
 net/wireless/chan.c                      |  92 +++++--
 net/wireless/core.h                      |   8 -
 net/wireless/mesh.c                      |   3 +-
 net/wireless/nl80211.c                   | 155 ++++++-----
 net/wireless/reg.c                       |   2 +-
 net/wireless/reg.h                       |   2 +-
 net/wireless/scan.c                      | 452 +++++++++++++++------------=
----
 net/wireless/sme.c                       |  13 +-
 net/wireless/util.c                      |   9 +-
 net/wireless/wext-sme.c                  |   8 +-
 35 files changed, 1139 insertions(+), 551 deletions(-)


--=-QhIo8xsyAyLm8yv8ZqYL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQvQ8EAAoJEDBSmw7B7bqrIdAP/1WeKdD8NxwmFXxlvyJjHhz0
HJGeEKGCLmxh28RKKKb1hvLEnRaalPDcja7EyAJt7BOn0kjkT9APOOa5QHIqHOCP
5mvDqGn4PvbbzmYAExPddrfnKhhliq98BQjfi0fmmDzOjvKX/1DY+Vlhnb7JBMGm
2hmTt6rKp3KnwHNeWUmaKnJKZ4wQdiyMwjQIVrbwTrFh9kU6JZgM0hrEZqdhe2bV
owoQcqrDrw7xgGhmdxgmT5ZDCeCzT2/uIsMx/ktXaXOREvHVmwtvcrM2RLvQOenR
+2Mg9p9x6DLJRnTA4+E5KUejX1OyYICb0A75JNiCxvEr76pS2lBnxbB8faneWmW/
8OclGoszje6pqgfCs1hma5J7QkKpPIfXnXhkHb7lGg0EWyuJjsvBWjXSklK34ZAP
cfdRTDYkt4MFXdbCqanebhEdk4ni3z4HajA1m7revut/QLf+srgActeV2ZyT6TWi
SgqeRqSltEiH7iuS887UaUfa0KkVjb8mMapQb7L6HAZZdCWmuqCUAVymWhMaib1I
/c4R3GV8Ui5bvwM4YCZHV7xEo6gFR/2YYktEH2qPzajDSarhRgSeJchifg1xt3pw
6EN1X7wfgBv5T8Zpxag1UhZCz3tho+zsipO0R/D6Ph+NUQc04ZAtf7eMDH/orTkt
WqPEnIdb38/6l1KfvFu4
=CXBi
-----END PGP SIGNATURE-----

--=-QhIo8xsyAyLm8yv8ZqYL--

