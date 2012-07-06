Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50936 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344Ab2GFO26 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 10:28:58 -0400
Message-ID: <1341584931.16893.9.camel@jlt3.sipsolutions.net> (sfid-20120706_162903_240788_43373523)
Subject: pull-request: mac80211-next 2012-07-06
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 06 Jul 2012 16:28:51 +0200
In-Reply-To: <1341475446.4455.15.camel@jlt3.sipsolutions.net> (sfid-20120705_100419_947130_25BFF425)
References: <1341475446.4455.15.camel@jlt3.sipsolutions.net>
	 (sfid-20120705_100419_947130_25BFF425)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-gP8l+zkScbX4mnWUlxOq"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gP8l+zkScbX4mnWUlxOq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

> Please pull these changes. The most important thing is the locking
> regression (deadlock) fix for one of Michal's recent patches.
>=20
> I have a pending fix for the queue-related crash Larry reported, but I'm
> waiting for him to test it again. If you haven't pulled by then, I'll
> update this pull request to include that (and the hwsim test I used.)

Here's the promised update, I additionally have the fix, 60 GHz bitrate
support, Eliad's patch that he had erroneously labelled for 3.5 and the
debugfs symlink fix.

kernel.org doesn't seem to have sync'ed yet as I just pushed so you may
have to pull from the master server via ssh, or wait a little bit.

Thanks,
johannes


------

The following changes since commit ba0afa2f22e1e3f332e45460f99328025d44564e=
:

  mac80211: include VHT capability IE in probe requests (2012-07-02 15:13:0=
9 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 4d6d0ae2a088e1e054ef6d96ceb1b41523291e71:

  mac80211_hwsim: add testmode code to stop/wake queues (2012-07-06 15:27:1=
5 +0200)

----------------------------------------------------------------
Eliad Peller (1):
      mac80211: always set in_reconfig=3Dfalse on wakeup

Johannes Berg (7):
      mac80211: remove tx_frags driver callback
      mac80211_hwsim: fix NUM_BANDS usage
      mac80211: add TX prepare API
      cfg80211: fix locking regression in monitor channel tracking
      mac80211: fix debugfs default key links
      mac80211: fix crash with single-queue drivers
      mac80211_hwsim: add testmode code to stop/wake queues

Thomas Huehn (1):
      mac80211: reduce IEEE80211_TX_MAX_RATES

Vladimir Kondratiev (2):
      {nl,cfg}80211: support high bitrates
      cfg80211: bitrate calculation for 60g

 drivers/net/wireless/ath/carl9170/tx.c |    6 ++--
 drivers/net/wireless/mac80211_hwsim.c  |   12 ++++++--
 drivers/net/wireless/p54/txrx.c        |    6 ++--
 include/linux/nl80211.h                |    9 ++++++
 include/net/cfg80211.h                 |    4 ++-
 include/net/mac80211.h                 |   38 ++++++++++++------------
 net/mac80211/debugfs_key.c             |   16 ++++++----
 net/mac80211/driver-ops.h              |   22 +++++++++-----
 net/mac80211/main.c                    |    2 +-
 net/mac80211/mlme.c                    |    8 +++++
 net/mac80211/trace.h                   |    7 +++++
 net/mac80211/tx.c                      |   10 ++-----
 net/mac80211/util.c                    |   14 +++++++--
 net/wireless/core.c                    |    8 ++---
 net/wireless/core.h                    |    4 ++-
 net/wireless/nl80211.c                 |    9 ++++--
 net/wireless/util.c                    |   51 ++++++++++++++++++++++++++++=
+++-
 17 files changed, 163 insertions(+), 63 deletions(-)


--=-gP8l+zkScbX4mnWUlxOq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJP9vYkAAoJEDBSmw7B7bqrImYP/iEYLILnKo/Q4FUmGMLoJQHK
W46jsVyel3Zb2qvP1EL4e3tbF2xPUaLon+4nm381SpU71DIU1YPEJfEnzdChyq4t
kFXzU1MLa/ltzNl2jvpDnZqOJPk1FkrbQwtKCzV88gbWZ+exGlA7XvfGIQ4q0wgK
iJMRS1XXm5NSeJBR9RJGMdUnJohKBW8RBIe8OeNdf0s9GYkXlpZyp10HpAVFVp8G
+fquPwZ6aViF20t5C6arAXTVxQYK2GVknvQxRANpEBhc2d9dmQjQ540ntYeHh0/G
7XQyJ/tV691OWnGSJYipVr/fwRjlTbo8/vxt+DOUJ3R9je7UFWk3C+cAGOx5Uk7X
VQ7Kef9OZ25OFeGnpLFnTqBKpW4/c6mnQs+m+lE1KVBp2HQ3CEqruurhex1qjdTc
RKUP5emEAFsKPuiReVaVX6W2m7PWgu34OBbtspaCi0VKTl3geO4OPxXV3fKN8u3v
TZYppC3y17yhh8SZI9APtNEgKjy0ZQKOH1CZQsN1lClipljBP6kg7uzpMbxgdIfx
aKGsafFaICVlpL+eIZcwhQBj9sNR/Od4br1TyA/WGCsaEMLePNq8XtCIG6FOoKKN
VjenyMVRRvPnb5f6wIVMQ2EdaLXAWElaTIYxm8r3XrHV83Vok5mzbHAIz6f3Jaka
BQKnc58P6kjLXJvkuoYF
=87gt
-----END PGP SIGNATURE-----

--=-gP8l+zkScbX4mnWUlxOq--

