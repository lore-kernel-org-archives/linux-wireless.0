Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38850 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab3HPLBU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:01:20 -0400
Message-ID: <1376650872.15299.20.camel@jlt4.sipsolutions.net> (sfid-20130816_130124_194086_35107AC7)
Subject: pull-request: mac80211-next 2013-08-16
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 16 Aug 2013 13:01:12 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-lmdigHr6bhgf1HHkrKhd"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lmdigHr6bhgf1HHkrKhd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

And another set of patches for -next :-)

This time I have various improvements all over the place: IBSS, mesh,
testmode, AP client powersave handling, one of the rare rfkill patches
and some code cleanup.

Let me know if there's any problem.

johannes



The following changes since commit 73da7d5bab79ad7e16ff44d67c3fe8b9c0b33e5b=
:

  mac80211: add channel switch command and beacon callbacks (2013-08-01 18:=
30:33 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 27b3eb9c06a7193bdc9800cd00764a130343bc8a:

  mac80211: add APIs to allow keeping connections after WoWLAN (2013-08-16 =
12:58:43 +0200)

----------------------------------------------------------------
Antonio Quartulli (1):
      mac80211: ibss - do not scan if not needed when creating an IBSS

Chun-Yeow Yeoh (1):
      mac80211: allow lowest basic rate for unicast management for mesh

David Spinadel (2):
      cfg80211: add wdev to testmode cmd
      mac80211: add vif to testmode cmd

Johan Almbladh (1):
      mac80211: perform power save processing before decryption

Johannes Berg (4):
      wireless: make TU conversion macros available
      nl80211: clean up CQM settings code
      mac80211: add control port protocol TX control flag
      mac80211: add APIs to allow keeping connections after WoWLAN

Luis Henriques (1):
      net: rfkill: Do not ignore errors from regulator_enable()

Simon Wunderlich (2):
      mac80211: fix ieee80211_sta_process_chanswitch for 5/10 MHz channels
      mac80211: move ibss presp generation in own function

 Documentation/DocBook/80211.tmpl                   |   1 +
 drivers/net/wireless/ath/ath6kl/testmode.c         |   3 +-
 drivers/net/wireless/ath/ath6kl/testmode.h         |   7 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   4 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c              |   2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h        |   7 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.c      |   7 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c              |   9 +-
 drivers/net/wireless/mac80211_hwsim.c              |   1 +
 drivers/net/wireless/ti/wlcore/testmode.c          |   3 +-
 drivers/net/wireless/ti/wlcore/testmode.h          |   3 +-
 include/linux/ieee80211.h                          |   4 +
 include/net/cfg80211.h                             |   5 +-
 include/net/mac80211.h                             | 109 +++++-
 net/mac80211/cfg.c                                 |  15 +-
 net/mac80211/ibss.c                                | 196 ++++++----
 net/mac80211/ieee80211_i.h                         |   3 -
 net/mac80211/key.c                                 | 154 +++++++-
 net/mac80211/mlme.c                                |   9 +
 net/mac80211/rate.c                                |  23 +-
 net/mac80211/rc80211_minstrel_ht.c                 |   5 +-
 net/mac80211/rx.c                                  | 404 ++++++++++-------=
----
 net/mac80211/tx.c                                  |   8 +-
 net/mac80211/util.c                                |   2 +-
 net/rfkill/rfkill-regulator.c                      |   8 +-
 net/wireless/nl80211.c                             |  74 ++--
 net/wireless/rdev-ops.h                            |   5 +-
 net/wireless/trace.h                               |   8 +-
 28 files changed, 707 insertions(+), 372 deletions(-)


--=-lmdigHr6bhgf1HHkrKhd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSDgZ4AAoJEDBSmw7B7bqrNWAP/0I86joSFoHGyM+Cfc6U4YK7
KpyM/4Cy1D1pbgR3bsyTVkpjhB1ikajkX6SZSE+hLkfLSa+NtuJPX8Uu3bpi8f+S
Drc8DuE9mj/5VZ674pTXq2q5TX6zbz9FtRbgyjYEeL5LZm6FiDYUiy4WGTUZz+iz
9kmHt1vr/BesbLjbJA2WSA5AHPZQjOeiRbrqkgdgqMuejUKq9uOH8uIMGO3fdwPe
X4lfkUbErcpUBWp3frEqdmDrykHSdpWYbwL/sJl/dJTyzJ66jhA39L1MDnbVVCVY
zLSjrBgy8IVRGlJaTY5qORC9+tcnZ4eus7H2Mgc3R7jxdenFgPmsXsAKpVtdmZtv
mxVsbfvvZrx7xT8wrlz+b7GFLVsz8Uqohuo1hnptwo+WhrIoymyDDFKiAwXBw4/b
URDAG73GLtq00+35AzclOvfayH2DAiaIAd5pQ/8D0FQOrR0UJXWnHn2OW4TLi8H+
Ag5E1X0eGG3o2dPqd43kdYdzhyYF11QYn6tyTxtMfgvBKxxBqAYRYV55FVH2g/YA
+CB5HEB6t6jq1Rw4vBni4TlZIDNzlTy/KgcFcpWIFywhT5UHIltaKiyniLhov+Ez
0w93clLOC745yLsZa/bbu6V+dJaYTnTv1T60iwFYd1e3QkOev9YEIiDKjRO6ClWB
mQr942tlXQ0sgethN9g4
=qr9N
-----END PGP SIGNATURE-----

--=-lmdigHr6bhgf1HHkrKhd--

