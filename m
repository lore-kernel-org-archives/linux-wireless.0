Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50864 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758847Ab2FUIzT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 04:55:19 -0400
Message-ID: <1340268911.4489.15.camel@jlt3.sipsolutions.net> (sfid-20120621_105526_748522_63F73485)
Subject: pull-request: mac80211-next 2012-06-21
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 21 Jun 2012 10:55:11 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-wsTB9+VtaMidjiaGKPTW"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wsTB9+VtaMidjiaGKPTW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please pull as below. Note that ra.kernel.org wasn't responding to my
push this morning so I've pushed to my git.sipsolutions.net tree
instead, if ra.kernel.org recovers you should find the same contents
there in my mac80211-next tree as well.

I've included
 * a few fixes for the new remain-on-channel framework
 * a fix from Felix for a regression due to the new channel handling
 * a bunch of mesh improvements/features from the Chun-Yeow
 * the IBSS auth frame handling patches from Will Hawkins to enable
   handling them in userspace for SAE
 * some refactoring I did myself in nl80211 that paves the way for
   having non-netdev virtual wireless devices

as well as a bunch of other small improvements all over the place.

johannes



The following changes since commit 934b9d1ed71cca5a220ec13e3f76d6aebf5183da=
:

  wl18xx: avoid some -Wformat warnings (2012-06-08 14:24:53 -0400)

are available in the git repository at:

  git://git.sipsolutions.net/mac80211-next.git for-john

for you to fetch changes up to 0f6b3f597daab2254614e2773e322e73fb1b6f4b:

  mac80211: fix double-start of remain-on-channel (2012-06-20 20:12:12 +020=
0)

----------------------------------------------------------------
Arik Nemtsov (2):
      mac80211: stop Rx during HW reconfig
      mac80211: set only VO as a U-APSD enabled AC

Avinash Patil (1):
      ieee80211: definitions for Microsoft Vendor OUI and WPA OUI type

Chun-Yeow Yeoh (9):
      cfg80211: add missing kernel-doc for mesh configuration structure
      {nl,cfg,mac}80211: fix the coding style related to mesh parameters
      {nl,cfg,mac}80211: implement dot11MeshHWMProotInterval and dot11MeshH=
WMPactivePathToRootTimeout
      mac80211: implement the proactive PREQ generation
      mac80211: implement the proactive PREP generation
      mac80211: invoke the timer only with correct dot11MeshHWMPRootMode va=
lue
      {nl,cfg,mac}80211: implement dot11MeshHWMPconfirmationInterval
      mac80211: fix the assignment of mesh element TTL
      mac80211: fix and improve mesh RANN processing

Eyal Shapira (1):
      mac80211: fix cleanup if driver suspend callback fails

Felix Fietkau (1):
      cfg80211: fix regression in multi-vif AP start

Javier Cardona (2):
      mac80211: Remove unused variable
      mac80211: Rename stainfo variable for the more common sta

Johannes Berg (10):
      mac80211: remove unneeded ieee80211_run_deferred_scan()
      mac80211: allow cancelling dependent ROCs
      nl80211: fix sched scan match attribute name
      cfg80211/nl80211: fix kernel-doc
      cfg80211: make some functions static
      nl80211: refactor __cfg80211_rdev_from_info
      nl80211: fix netns separation
      nl80211: change __cfg80211_rdev_from_info
      nl80211: use __cfg80211_rdev_from_attrs for testmode
      mac80211: fix double-start of remain-on-channel

Luciano Coelho (2):
      mac80211: initialize sta pointer to avoid false-positive warning
      mac80211: use the correct capability info in ieee80211_set_associated=
()

Pontus Fuchs (1):
      mac80211: Disallow changing chan type on monitor when CHAN_MODE_FIXED

Rajkumar Manoharan (1):
      mac80211: cleanup offchannel_ps_enable argument

Will Hawkins (3):
      mac80211: Track auth frame registrations on IBSS ifaces
      mac80211: send auth in IBSS only if userspace isn't handling it
      mac80211: Allow userspace to register for auth frames in IBSS

Yoni Divinsky (1):
      mac80211: save wmm_acm per sdata

 include/linux/ieee80211.h     |   50 +++++++-
 include/linux/nl80211.h       |  150 ++++++++++++++--------
 include/net/cfg80211.h        |   92 +++++++++++---
 net/mac80211/cfg.c            |   75 ++++++++---
 net/mac80211/debugfs_netdev.c |   43 ++++---
 net/mac80211/ibss.c           |    2 +-
 net/mac80211/ieee80211_i.h    |   19 ++-
 net/mac80211/iface.c          |    2 +-
 net/mac80211/main.c           |   11 +-
 net/mac80211/mesh.c           |   12 +-
 net/mac80211/mesh.h           |    4 +-
 net/mac80211/mesh_hwmp.c      |  126 ++++++++++++++-----
 net/mac80211/mlme.c           |   16 +--
 net/mac80211/offchannel.c     |   20 ++-
 net/mac80211/pm.c             |   10 ++
 net/mac80211/rx.c             |    6 +-
 net/mac80211/util.c           |    3 +
 net/mac80211/wme.c            |   11 +-
 net/mac80211/wme.h            |    2 +-
 net/wireless/core.c           |   63 ----------
 net/wireless/core.h           |   26 ----
 net/wireless/mesh.c           |    6 +
 net/wireless/nl80211.c        |  273 +++++++++++++++++++++++++++++++------=
----
 23 files changed, 688 insertions(+), 334 deletions(-)


--=-wsTB9+VtaMidjiaGKPTW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJP4uFvAAoJEDBSmw7B7bqrjG0P/3l2/d4FsmcHO9cQHh+sV96m
l6I+ccklZwdg5aYst9y5f0m4VpbSyMz0cFUqvXhjf2xd4YCa7z+oJy32PDZQkeXY
PqVI421wYF3VlvDc4bo7gTkuj4XgyyS6xXMZbpEqtaWd1UUHmSv9OkHg/29sh5nw
Wmy3Znj37QX/nxlpF1K9r7rcf+1JFcDqfsPDZBotzOLk7nsOPJot2IpuaswJidGT
5Abg7OGiablOCZwQ31cRaOmxu2vehoFV8pi4scDjdXgfaHk3FTj2hZRa5cqQIaZ2
4K0rwZ1trsbN3wWkOC7kPWGjJ/dzkm5u1rG+/DQGJh0BtJ93xXiTSEyP7ToSd9OW
svz2f2oba5mST83Tyg8HnlsN/OlKovPOxwJhswZTvU01DkWyntX4RWVR/Wu/uNdk
q9ip7atVcyrfUDWr2vP6ISG1IVcdHJKQebpi5jbntr8i0FjhRemH1Zv9No/2Q5NM
FC8t1UGF27JCC1w/gi4uwZ/8KAhywlp72hORoS3NM1eOw2LaM+BrmuPvICkxaRsH
dv99G2fQEE0K0Cf7/JhpBqEpQP/FPrELc3t51YfSYxBNW6UWo81M5JgGRXE/7trz
hf0YS9cPjaOzVK5gSr/a14FNQYR4v1uSXO8Df3BgugBCJvpay9uQSSH32b88br9h
uM74cdu13Pz14MJ+46Od
=yopy
-----END PGP SIGNATURE-----

--=-wsTB9+VtaMidjiaGKPTW--

