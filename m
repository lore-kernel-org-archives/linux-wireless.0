Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57045 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab3AQWNt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 17:13:49 -0500
Message-ID: <1358460849.4653.11.camel@jlt4.sipsolutions.net> (sfid-20130117_231356_271701_9C24E560)
Subject: pull-request: mac80211-next 2013-01-17
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 17 Jan 2013 23:14:09 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-FUfH/Lv7qgi5ngaAUTp4"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FUfH/Lv7qgi5ngaAUTp4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Another pull request for mac80211-next. This time, I have a number of
things, the patches are mostly self-explanatory. There are a few fixes
from Felix and myself, and random cleanups & improvements. The biggest
thing is the partial patchset from Marco preparing for mesh powersave.

Thanks,
johannes


The following changes since commit 2d31986764926630a6df72123a5e217219b32594=
:

  regulatory: fix restore_regulatory_settings (2013-01-09 12:19:52 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 5a32aff37a02ebc959837f08d09ac8ba65d4f1b0:

  mac80211: split out chandef tracing macros (2013-01-16 23:57:51 +0100)

----------------------------------------------------------------
Arend van Spriel (1):
      nl80211: allow user-space to set address for P2P_DEVICE

Chun-Yeow Yeoh (1):
      mac80211: allow disable power save in mesh

Felix Fietkau (1):
      wireless: fix regulatory HT40 allowed check

Johannes Berg (4):
      mac80211: fix HT40 connections
      mac80211: fix resume from WoWLAN
      mac80211: call restart complete at wowlan resume time
      mac80211: split out chandef tracing macros

Jouni Malinen (1):
      cfg80211: Allow use_mfp to be specified with the connect command

Luis R. Rodriguez (1):
      wireless: make the reg_notifier() void

Marco Porsch (5):
      nl80211: add range checks to mesh parameters
      mac80211: update mesh peer link counter during userspace peering
      mac80211: move add_tim to subfunction
      {cfg,nl,mac}80211: set beacon interval and DTIM period on mesh join
      {cfg,nl}80211: mesh power mode primitives and userspace access

Simon Wunderlich (1):
      cfg80211: check radar interface combinations

Yacine Belkadi (1):
      {cfg,mac}80211.h: fix some kernel-doc warnings

 drivers/net/wireless/ath/ath5k/base.c             |   5 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c        |  16 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c     |   8 +-
 drivers/net/wireless/ath/ath9k/init.c             |   9 +-
 drivers/net/wireless/ath/carl9170/main.c          |   6 +-
 drivers/net/wireless/ath/regd.c                   |  18 +-
 drivers/net/wireless/ath/regd.h                   |  10 +-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c |   6 +-
 drivers/net/wireless/libertas/cfg.c               |  33 ++--
 drivers/net/wireless/libertas/cfg.h               |   3 -
 drivers/net/wireless/mwifiex/cfg80211.c           |   6 +-
 drivers/net/wireless/rtlwifi/regd.c               |  20 +--
 drivers/net/wireless/rtlwifi/regd.h               |   6 +-
 drivers/net/wireless/ti/wlcore/main.c             |   6 +-
 include/net/cfg80211.h                            | 196 ++++++++++++++----=
----
 include/net/mac80211.h                            |  79 +++++++--
 include/uapi/linux/nl80211.h                      |  56 ++++++-
 net/mac80211/cfg.c                                |  28 +++-
 net/mac80211/mesh.c                               |   1 -
 net/mac80211/mesh.h                               |  16 +-
 net/mac80211/mesh_plink.c                         |  14 --
 net/mac80211/mlme.c                               |   4 +-
 net/mac80211/trace.h                              |  24 ++-
 net/mac80211/tx.c                                 |  47 +++---
 net/mac80211/util.c                               |   9 +-
 net/wireless/core.c                               |  12 +-
 net/wireless/core.h                               |   7 +-
 net/wireless/mesh.c                               |   8 +
 net/wireless/nl80211.c                            | 156 +++++++++++++----
 net/wireless/reg.c                                |   4 +-
 net/wireless/sme.c                                |   3 +-
 net/wireless/util.c                               |  41 ++++-
 32 files changed, 583 insertions(+), 274 deletions(-)


--=-FUfH/Lv7qgi5ngaAUTp4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQ+HexAAoJEDBSmw7B7bqr9L8P/1/2aGmIS84JgNwADXkAU/VA
hO4uzwNbQBbXLvHV4bDmxLux6NylbDxRIRSlTMUU3Zg+9q9c3OXf39KL7tL3CTCj
p02MnZZ5wBnwq7zouv7LvTfBVK2AQcdPwkASniibTh+/4eRudRofPvEGFogaXE1g
PvAHiMKfRcPJl3BEItW9KZnzYW93O7V4ot0X7gweu7v7mY/u4GiJPUnk1ly5O1Ld
WeywKe8F9diqyveA4By4JDDSXNqo5kcPNl9qnBrKXxwyRRNfzS09WXZ/Qrft2Xs5
CI6KsTizt4LzwQBNpxgpcuU6n4LgPYGobT3Qkv37ygrkpKy7t81V7yujSDWZj6ru
3iY/tl1OjiYT5mBSTX/LxVt+wo9IM5MEQwwhHRq08E4wjbyjjYQYfKPY7XKNJJ3U
P1UaKl2FjJn7xCvWf6rEh63xYXGRSfM2n5lTHEG90PiPqyqJR7/9stJSbAFDifjk
Z6QGBItbp4EcCQxozvLZh3dQcYTDsui/cmNeEvxD9SNXG0M0Ty1cAkZ7/SKPTCf0
G3wRnwkFfqug21LcCb/lo/qxGkwub+L2w/UeHJ5GKojNJClKzMtpDMFOV5mtO30A
JkRJjcHAw8IXaZh6QX6ZRCer2Wd/MW2NlDIuU2PTeTNGLGSBDKDUh68TWk3YtE5L
i7Jxm9BMIcifASGVjU69
=iHve
-----END PGP SIGNATURE-----

--=-FUfH/Lv7qgi5ngaAUTp4--

