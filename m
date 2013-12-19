Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54960 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3LSU1j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Dec 2013 15:27:39 -0500
Message-ID: <1387484847.4298.21.camel@jlt4.sipsolutions.net> (sfid-20131219_212742_979202_5C9119E5)
Subject: pull-request: mac80211-next 2013-12-19
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 19 Dec 2013 21:27:27 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-kTqFDSMDp5ExkutggnXQ"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kTqFDSMDp5ExkutggnXQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Yeah, I know what you're going to say ... but here are some (locking)
fixes for mac80211-next that people may want to use over the
holidays :-)

Felix adds some helper functions for P2P NoA software tracking, Joe
fixes alignment (but as this apparently never caused issues I didn't
send it to 3.13), Kyeyoon/Jouni add QoS-mapping support (a Hotspot 2.0
feature), Weilong fixed a bunch of checkpatch errors and I get to play
fire-fighter or so and clean up other people's locking issues. I also
added nl80211 vendor-specific events, as we'd discussed at the wireless
summit.

Let me know if there's any problem; however, with this, I'm going on
vacation until January 6th. I'll check in to see if there are any
important issues that need my attention, but I don't expect to send you
any more pull requests this year.

johannes
---
The following changes since commit 204e35a91c4b3327b7239d7687fbd4923edbbf08=
:

  nl80211: add VHT support for set_bitrate_mask (2013-12-16 16:05:17 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 32db6b54dfba38aa8fa4072b2a3fc6425139166a:

  mac80211: Add support for QoS mapping (2013-12-19 16:30:58 +0100)

----------------------------------------------------------------
Felix Fietkau (1):
      mac80211: add helper functions for tracking P2P NoA state

Joe Perches (1):
      mac80211: align struct ps_data.tim to unsigned long

Johannes Berg (4):
      mac80211: make ieee80211_recalc_radar_chanctx static
      mac80211: remove unnecessary iflist_mtx locking
      mac80211: fix iflist_mtx/mtx locking in radar detection
      nl80211: support vendor-specific events

Kyeyoon Park (2):
      cfg80211: Add support for QoS mapping
      mac80211: Add support for QoS mapping

Weilong Chen (1):
      mac80211: fix checkpatch errors

 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   2 +-
 drivers/net/wireless/mwifiex/main.c                |   2 +-
 include/net/cfg80211.h                             | 118 ++++++++++++++-
 include/net/mac80211.h                             |  47 ++++++
 include/uapi/linux/nl80211.h                       |  17 +++
 net/mac80211/aes_cmac.c                            |   2 +-
 net/mac80211/aes_cmac.h                            |   2 +-
 net/mac80211/cfg.c                                 |  54 ++++++-
 net/mac80211/chan.c                                |  67 ++++-----
 net/mac80211/ibss.c                                |   7 +
 net/mac80211/ieee80211_i.h                         |  11 +-
 net/mac80211/iface.c                               |   8 +-
 net/mac80211/mlme.c                                |  25 +++-
 net/mac80211/rc80211_minstrel.c                    |   8 +-
 net/mac80211/rc80211_minstrel_ht.c                 |   2 +-
 net/mac80211/tkip.c                                |   2 +-
 net/mac80211/trace.h                               |   2 +-
 net/mac80211/tx.c                                  |   4 +-
 net/mac80211/util.c                                | 150 +++++++++++++++++=
+-
 net/mac80211/wme.c                                 |   7 +-
 net/wireless/ap.c                                  |   1 +
 net/wireless/ibss.c                                |   2 +
 net/wireless/mesh.c                                |   1 +
 net/wireless/nl80211.c                             | 160 +++++++++++++++++=
+---
 net/wireless/rdev-ops.h                            |  15 ++
 net/wireless/sme.c                                 |   2 +
 net/wireless/trace.h                               |  40 ++++++
 net/wireless/util.c                                |  19 ++-
 28 files changed, 687 insertions(+), 90 deletions(-)


--=-kTqFDSMDp5ExkutggnXQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSs1avAAoJEDBSmw7B7bqraHQQAIEIgZbmIdBrEePG+1vvMEGP
5OxOnedudRf3PZTXMt/QL80RU/LA55BmquFLSpg1GcB6P50QcGRyCVAMnqDWpaZR
sJsCvw5hIvGgkeo1ErfR/TmvKL56C9WfIal4lJYyadZfxUXD0KLO514YHBI/AQ7O
OV5uRoUZ6T8eD4rxJL6cH+3dZ/5HSzWfDL/UcJA5uzKpWaGT+00rQnC5yzrRvoW+
Su0TXolbhGpYGW2Z5k4R5/7VIRosGJ497uToQAAjf3pOW91sBgBQXxRzf5cqTBRd
Gs843sLb4N+PfQ9kgIQNXjH1PAZpCb2YTvZLUfsGHxVNH1X1qBiTyVGsB3+NdTJV
DKysl2Iirgx3BcnGepg7TP/birb07BRgj2rMNsLZPuDxz9qF0UEsKWtFaWDQjwEG
CAwNmx5CGper+j2v/caw4gedFAd7iqlNVBcAQInPjlZ4F0ayRu0Xd6ADtWp6LFjI
NIE+ouG1RMzHe+TbDi+OIvIFhXplEoMqHrABf2lJH9xe9RKOGo++rRnF+friRZq0
LHfUJpD0SkffYp21JEHHf3WMdhM8Rc70j6jd4Ld1xK4l7jlIoKqJ4HmFvR3bFTjt
1uaBzof+nS2igsVx6kLbYrryx5yLYhdCtfDbed6cdP/Z6oStfCocUkyvF8k2ocQs
037rRSIm9YjSCKsYpG9S
=BYFT
-----END PGP SIGNATURE-----

--=-kTqFDSMDp5ExkutggnXQ--

