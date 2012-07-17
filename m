Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38185 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab2GQKd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 06:33:27 -0400
Message-ID: <1342521203.8139.3.camel@jlt3.sipsolutions.net> (sfid-20120717_123330_855671_29C3F812)
Subject: pull-request: mac80211-next 2012-07-17
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 17 Jul 2012 12:33:23 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Pb+Px/tWvxeivFiK0SXv"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Pb+Px/tWvxeivFiK0SXv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please pull my mac80211-next tree.

I've included a number of fixes for work that went into the tree before,
in particular for the cfg80211 channel tracking again. I've also
included Luis's regulatory certification series.

Thanks!

johannes



The following changes since commit 685fb72b63faf09a767cc28332545f5830b91be8=
:

  mac80211: iterate the virtual monitor interface (2012-07-12 12:10:50 +020=
0)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 88bc40e8c3d3bca7d26c756bb0b823d4abad3355:

  mac80211: go out of PS before sending disassoc (2012-07-17 12:17:42 +0200=
)

----------------------------------------------------------------
Alan Cox (1):
      mac80211: fix use after free

Eliad Peller (1):
      mac80211: go out of PS before sending disassoc

Felix Fietkau (1):
      cfg80211: ignore channel state for stopped AP/mesh interfaces

Johannes Berg (5):
      nl80211: allow enabling WoWLAN without triggers
      Revert "mac80211: refactor virtual monitor code"
      cfg80211/mac80211: re-add get_channel operation
      cfg80211: reduce monitor interface tracking
      nl80211: add wdev ID as u64 as it should

Kalle Valo (1):
      cfg80211: fix set_regdom() to cancel requests with same alpha2

Luis R. Rodriguez (5):
      cfg80211: add CONFIG_CFG80211_CERTIFICATION_ONUS
      cfg80211: add cellular base station regulatory hint support
      cfg80211: rename reg_device_remove() to wiphy_regulatory_deregister()
      cfg80211: make regulatory_update() static
      cfg80211: remove regulatory_update()

Nicolas Cavallari (1):
      mac80211: fix tx-mgmt cookie value being left uninitialized

Thomas Huehn (1):
      mac80211_hwsim: fix race condition with sta/vif pointers

Thomas Pedersen (1):
      cfg80211: support TX error rate CQM

 drivers/net/wireless/mac80211_hwsim.c |    5 --
 include/linux/nl80211.h               |   48 ++++++++++
 include/net/cfg80211.h                |   32 ++++++-
 include/net/regulatory.h              |    5 ++
 net/mac80211/cfg.c                    |   13 +--
 net/mac80211/ieee80211_i.h            |    4 -
 net/mac80211/iface.c                  |   16 +++-
 net/mac80211/mlme.c                   |   17 ++--
 net/mac80211/offchannel.c             |    6 +-
 net/wireless/Kconfig                  |   21 +++++
 net/wireless/chan.c                   |   20 ++---
 net/wireless/core.c                   |   58 ++----------
 net/wireless/core.h                   |    3 -
 net/wireless/mlme.c                   |   13 +++
 net/wireless/nl80211.c                |  156 ++++++++++++++++++++++++++++-=
----
 net/wireless/nl80211.h                |    5 ++
 net/wireless/reg.c                    |  130 +++++++++++++++++++++++----
 net/wireless/reg.h                    |    8 +-
 net/wireless/wext-compat.c            |    9 +-
 19 files changed, 432 insertions(+), 137 deletions(-)


--=-Pb+Px/tWvxeivFiK0SXv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQBT9zAAoJEDBSmw7B7bqrvvsP/2YtGEhjyuCT3k+dS4pUSqGd
ekJT1nRoVEawbUnNNGoRwV9adsjD1S+v1rXguLkhm41W1J67dWkIixxcLUdQxC2R
Zz5Wn892AfIlJsl9NJKIbJ6Uce4t/5UWYBde3A2xFb7AYtIZrsPbOFAWM+ag8GlE
Qw8QMnfMgQXQqOVPQEDkQVcdQ0bNN3MN+OsZ4zY84Y22iGwex794Xw4ZjnfY9vJY
r6smF6nU/Hhww/1YnH8XL8sGywluhQPq8n4pbS8Ye8h9tPVfjGctpnbEz6YEVjWk
dB+t5Jv3/6grAc88kDUgyrtmi/MAUcupS1fb/JInST3G7Adm/xsyajlb97vWXCXD
jLjpTP5CEcJZ7FD0Wr6T+cunlAVdr9yw01Iw61vGfKIcdkOGKdwU7JHiLWU1IjO5
LuyLZAjy0PYQfncYoXirLH0Fh+Zi1JQ6kK8+935/mIvtuz38GheTx90RB1lqUFC1
lCfg0eVq3L+LNJlJ5IqgKA0v66BMjb1uW1hYe09bPZYVPG0k10S8UWavq4CM4X/V
+eIz8VxfBMdL0E3k2vTU3fN1F6kc4l8pW8Ex4LLcVNdHqUp4zdgQhEBWWCUEI7kV
/15T/a1QOy+DeIdfC90jc22DNYtxRlFNhEbq57snfI3XI4P4n/jLyIS7zq0/08Zl
aRkLLemTs2ti86QM5Teq
=QVUZ
-----END PGP SIGNATURE-----

--=-Pb+Px/tWvxeivFiK0SXv--

