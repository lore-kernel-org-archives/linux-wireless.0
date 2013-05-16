Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59182 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3EPUxC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 16:53:02 -0400
Message-ID: <1368737568.8253.7.camel@jlt4.sipsolutions.net> (sfid-20130516_225307_272460_F85E13DB)
Subject: pull-request: mac80211 2013-05-16
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 16 May 2013 22:52:48 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-qC/qCbfmQLdCDpn99EDt"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qC/qCbfmQLdCDpn99EDt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Here's my first pull request for the 3.10 fixes stream. Unfortunately, a
fairly large number of these also had to be tagged for stable.

This is what I have:
 * a patch from Felix to fix RCU usage in his rate table code
 * a patch from Ilan to add the wdev id to some notifications so they
can
   actually be used by userspace
 * Sasha Levin found an issue in how hwsim handles devices
 * a fix for a bug in the wiphy_register() error path that's been there
forever
 * three fixes for WoWLAN
 * AP mode frame matching was erroneously giving frames to all virtual
AP
   interfaces (reported by Jouni)
 * a fix for HT handling in my CSA changes, found by Sujith
 * a fix for some locking simplifications gone wrong
 * Ben Greear found more cfg80211/mac80211 state confusion
 * and a fix for another bug found by Jouni: local state changes need to
be
   reported by mac80211 to cfg80211 so it disconnects properly.

Please pull. Thanks,
johannes



The following changes since commit 61f1598278876527314f5fc1d00cf0a4d525c1f7=
:

  Merge branch 'wireless' (2013-05-10 09:44:05 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to e248ad30204eff6559b4d2d94d49d9d46c08185a:

  cfg80211: fix sending WoWLAN TCP wakeup settings (2013-05-16 22:38:09 +02=
00)

----------------------------------------------------------------
Felix Fietkau (1):
      mac80211: fix spurious RCU warning and update documentation

Ilan Peer (1):
      nl80211: Add wdev identifier to some nl80211 notifications

Johannes Berg (9):
      cfg80211: fix wiphy_register error path
      cfg80211: fix WoWLAN wakeup tracing
      mac80211: fix IEEE80211_SDATA_DISCONNECT_RESUME
      mac80211: fix HT beacon-based channel switch handling
      mac80211: use just spin_lock() in ieee80211_get_tkip_p2k()
      mac80211: fix AP-mode frame matching
      cfg80211: fix interface down/disconnect state handling
      mac80211: report deauth to cfg80211 for local state change
      cfg80211: fix sending WoWLAN TCP wakeup settings

Sasha Levin (1):
      mac80211_hwsim: correctly register the platform driver

 drivers/net/wireless/mac80211_hwsim.c | 18 +++++------
 include/net/mac80211.h                | 12 ++++---
 net/mac80211/ieee80211_i.h            |  1 +
 net/mac80211/mlme.c                   | 61 +++++++++++++++++++++++++++++--=
----
 net/mac80211/rate.c                   |  9 +++++-
 net/mac80211/rx.c                     |  3 ++
 net/mac80211/tkip.c                   |  4 +--
 net/mac80211/util.c                   |  7 ++++
 net/wireless/core.c                   | 17 ++++++----
 net/wireless/nl80211.c                |  4 +++
 net/wireless/sme.c                    |  3 +-
 net/wireless/trace.h                  | 23 +++++++------
 12 files changed, 118 insertions(+), 44 deletions(-)


--=-qC/qCbfmQLdCDpn99EDt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRlUcgAAoJEDBSmw7B7bqrlUMP/2XyqDmH1AbY5ShQIV02sE9o
1m5/No9DcCZxutg4rPMcUyaA+QZPay8ERa/nOF7LvmUZEMYjUMCal/ygXKz7tb2x
Pz/xmOFp5JUGGTZSepm3r6qE1zumqDCMX1NGFX8ILPB6r60Ps1QJyHkW1kCQLPL7
Ptzc51EeYs7n7XDrrOmmLTbXORUWZ8nbraM9tKNJWgsxoYgr1/xHrQy6sk55Ip3j
KKuQmSXI7G2CYKJkhLw8dBY2narIqxhltS5jaEdBdsfw48cJC0DYU/TtjLiwyZKe
axPDe3Y27YQUlm1ESgeHovMUvlUUnrgEmkVYU/JkSPvfRZpcI0myooZ3udV2W5mm
iCFQ5KvC/B/+jb9VR/Amhzn8N+DXq3dWtUVhBqQ/4imsN75lHuaIW26pKZF1MZ1F
7ueKgtcrpsncqhWrn5YLyHAE0UKTqZOLyPjN78qwsE4PHWil2IWXKXKiOV/TomJB
zXoWjcRJWVFcowKBp/XU6SxV47IyfwqWbWX4uH6oKpzXQ66WjuUqTJFHcvAV6Z0x
lEQM+cozxfxrhyaPRnYWQPxakTE69G3Xx4MPjyUbF9cBdry6OR3aZa5d/mNCi/Gd
t/J+9CukfgqCupeFbIauveruLOWVE1ZLml/nS775GWZoQp7oJUx3s9V0CMqZPrXJ
8SOfoiAgDqrWIDFoDY7i
=/2tU
-----END PGP SIGNATURE-----

--=-qC/qCbfmQLdCDpn99EDt--

