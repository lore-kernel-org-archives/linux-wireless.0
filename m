Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39102 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213AbaCSUdU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 16:33:20 -0400
Message-ID: <1395261190.4142.34.camel@jlt4.sipsolutions.net> (sfid-20140319_213328_580356_7A86B38B)
Subject: pull-request: mac80211-next 2014-03-19
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 19 Mar 2014 21:33:10 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-DOAyawVIYJLn7KF7bVPq"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DOAyawVIYJLn7KF7bVPq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Following your announcement, I figured I should get some code to you
still, if only because I'm lazy and don't want to disentangle the code I
already have later to break it up into fixes and features ...

This has a whole bunch of bugfixes for things that went into -next
previously as well as some other bugfixes I didn't want to rush into
3.14 at this point. The rest of it is some cleanups and a few small
features, the biggest of which is probably Janusz's regulatory DFS CAC
time code.

Please let me know if there's any problem.

johannes

---

The following changes since commit 6658ab80fd4ef940fc2366ddb66690a15ea69c18=
:

  mac80211: ibss: handle cfg80211_chandef_dfs_required() error codes (2014-=
02-21 09:37:46 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 73fb08e24ae840bc518facc2c605dd6bb3751fec:

  cfg80211: remove macro ASSERT_RDEV_LOCK(rdev) (2014-03-19 21:29:58 +0100)

----------------------------------------------------------------
Alexander Bondar (1):
      mac80211: release sched_scan_sdata when stopping sched scan

Chun-Yeow Yeoh (1):
      mac80211: add missing update on rx status VHT flag

Eliad Peller (1):
      mac80211: add status_driver_data array to ieee80211_tx_info

Emmanuel Grumbach (2):
      cfg80211/mac80211: ignore signal if the frame was heard on wrong chan=
nel
      mac80211: set beamforming bit in radiotap

Ilan Peer (1):
      cfg80211: send stop AP event only due to internal reason

Janusz Dziedzic (3):
      cfg80211: regulatory: allow user to set world regdomain
      cfg80211: regulatory: allow getting DFS CAC time from userspace
      cfg80211: DFS get CAC time from regulatory database

Johannes Berg (4):
      cfg80211: regulatory: simplify uevent sending
      mac80211: fix potential use-after-free
      mac80211: verify deauthentication and return error on failure
      mac80211: fix suspend vs. authentication race

Luis R. Rodriguez (1):
      cfg80211: allow reprocessing of pending requests

Michael Braun (1):
      mac80211: fix WPA with VLAN on AP side with ps-sta again

Michal Kazior (1):
      mac80211: refactor channel switch function

Vladimir Kondratiev (1):
      wireless: max MSDU size for DMG networks

Zhao, Gang (3):
      cfg80211: make __cfg80211_join_ibss() static
      cfg80211: remove unnecessary check
      cfg80211: remove macro ASSERT_RDEV_LOCK(rdev)

 include/linux/ieee80211.h    |   4 ++
 include/net/cfg80211.h       |  23 ++++----
 include/net/mac80211.h       |   6 ++-
 include/net/regulatory.h     |  21 +++++---
 include/uapi/linux/nl80211.h |   6 +++
 net/mac80211/cfg.c           | 121 ++++++++++++++++++++++++---------------=
----
 net/mac80211/ibss.c          |  12 +----
 net/mac80211/ieee80211_i.h   |   1 +
 net/mac80211/mlme.c          |  70 ++++++++++++++++---------
 net/mac80211/pm.c            |  14 +++--
 net/mac80211/rx.c            |   3 ++
 net/mac80211/scan.c          |   6 ++-
 net/mac80211/tx.c            |   2 +-
 net/wireless/ap.c            |   9 ++--
 net/wireless/chan.c          |  56 ++++++++++++++++++++
 net/wireless/core.c          |   2 +-
 net/wireless/core.h          |  10 ++--
 net/wireless/genregdb.awk    |   8 ++-
 net/wireless/ibss.c          |   8 +--
 net/wireless/mlme.c          |   2 +-
 net/wireless/nl80211.c       |  24 +++++++--
 net/wireless/reg.c           |  86 +++++++++++++++---------------
 net/wireless/reg.h           |   1 -
 net/wireless/scan.c          |  31 ++++++-----
 net/wireless/sme.c           |   1 -
 net/wireless/util.c          |   5 +-
 net/wireless/wext-sme.c      |   2 +-
 27 files changed, 339 insertions(+), 195 deletions(-)


--=-DOAyawVIYJLn7KF7bVPq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJTKf8GAAoJEDBSmw7B7bqr3SkP/jn9vhqEWSbpludJv1Ep7+FN
xe7cZPVBAD8QJhJ7hpY1RPfhbwU8koYEDD8Ukt+FF0ed4X31Sbc/MvHBS1IzYMpw
XdEU1YLZXjAwNdsnqNpGu2AAdWLEB+Bfzci+wLrAry8ycjiOTBmM6sK2Y3nDKLJ2
yi5J/mTsdAJJUtDDWWlm7xQSCJlwWHiJFCcywsk1w/eTPyvPs5ZixZgfwzN5cb2+
G8a4BDCJgutfefudg+sZh0h0wMBPBz0F/V+zF9v2JzksDQhaU56rZIFa45zwIeqf
rKDvcLD+c6+CaW6LRILpLKDbSvbkAyCBfkG3fOXZg2LZNxzIAa9QrNsqIIfmLCgJ
ohHGEzNHQDGohAdyfs9KLvOLdI0bbJP7z+jAie9/K6rMlLChe9Q1j4/N2lOZ9r6x
0uVUV+goV4JtvK9F9jxk0YvE2aAFLXHX8F8AR6yp/ykAxRFgFnPbgf3YTS6zJEx5
RsSH9quKl6moUYQaNt5gaQwBrUxyMjsxtTAj3PAGx66Euz+N+orYOYEFWFLwiCnn
zlC18AcSeCYAfb9DEWJf9VrKjOGSFPZr3ZXL61sECoR8tVWeD/5GjK/ppwa4WKPL
db0AgTdS0VhmsJvKvpuwDIoDam7bELfekvnCVhIX3RTFhQZaMywpk/Nh7rAzlk9l
fKzWpQwo34+jbCU2GY4J
=9mlW
-----END PGP SIGNATURE-----

--=-DOAyawVIYJLn7KF7bVPq--

