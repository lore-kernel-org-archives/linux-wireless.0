Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46001 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab3DVO0Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 10:26:16 -0400
Message-ID: <1366640761.8637.30.camel@jlt4.sipsolutions.net> (sfid-20130422_162620_225694_3C2DA0BA)
Subject: pull-request: mac80211-next 2013-04-22
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 22 Apr 2013 16:26:01 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-yumjUp27kIeQWOpwI3c3"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yumjUp27kIeQWOpwI3c3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

One more and probably last pull request for -next. Still pretty big,
mostly because I had some catching up to do wrt. merging.

This time I have a relatively large number of fixes and small
improvements, the most important one being Bob's RCU fix. The two big
things are Felix's work on rate scaling tables (with a big thanks to
Karl too) and my own work on CSA handling to finally properly handle HT
(and some VHT.)

Oh, I merged wireless-next once to resolve some conflicts.

Please pull.

Thanks,
johannes

The following changes since commit 9b383672452bb1097124c76fcb4903e0021f6baf=
:

  b43: use bcma_pmu_spuravoid_pllupdate() (2013-04-12 15:29:14 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 1eb32179f0593051e7536378a879f5bdd108416a:

  mac80211_hwsim: handle IEEE80211_HW_SUPPORTS_RC_TABLE (2013-04-22 16:19:1=
6 +0200)

----------------------------------------------------------------
Alexander Bondar (2):
      mac80211: remove warning from ieee80211_beacon_loss
      mac80211: indicate admission control in TX queue parameters

Arend van Spriel (1):
      cfg80211: introduce critical protocol indication from user-space

Bob Copeland (1):
      mac80211: use synchronize_rcu() with rcu_barrier()

Felix Fietkau (5):
      mac80211: fix and optimize MCS mask handling
      mac80211: fix CTS protection handling
      mac80211: improve the rate control API
      mac80211/minstrel_ht: use the new rate control API
      mac80211/minstrel: use the new rate control API

Johannes Berg (16):
      mac80211: always advertise STBC/MCSes even if no AP support
      wireless: regulatory: fix channel disabling race condition
      mac80211: use second center_freq segment only in 80+80
      mac80211: unify CSA action frame/beacon processing
      cfg80211: add ieee80211_operating_class_to_band
      mac80211: support extended channel switch
      mac80211: support secondary channel offset in CSA
      mac80211: handle extended channel switch announcement
      mac80211: parse VHT channel switch IEs
      mac80211: handle wide bandwidth channel switch
      mac80211: fix station entry leak/warning while suspending
      mac80211: fix P2P-Device management frame RX
      nl80211: allow using wdev identifiers to get scan results
      Merge remote-tracking branch 'wireless-next/master' into mac80211-nex=
t
      cfg80211: fix P2P-Device stop locking
      cfg80211: invert P2P-Device vs. netdev check ordering

Karl Beldan (10):
      mac80211: always pick a basic rate to tx RTS/CTS for pre-HT rates
      mac80211: fix rate control tx handler for VHT rates
      mac80211: adjust initial chandefs assignments in ieee80211_register_h=
w
      mac80211: VHT off-by-one NSS
      mac80211_hwsim: handle VHT rates in rx_status
      mac80211: cosmetics for minstrel_debugfs
      mac80211: optimize minstrel_ewma
      mac80211: minstrel_ht: pick only supported rates for sta and group ma=
x*rates
      mac80211: minstrel_ht: initialize rates selection
      mac80211_hwsim: handle IEEE80211_HW_SUPPORTS_RC_TABLE

Marek Puzyniak (2):
      mac80211: clear SSID when stopping AP
      mac80211: provide SSID in IBSS mode

Martin Pitt (1):
      mac80211_hwsim: Register and bind to driver

Simon Wunderlich (1):
      mac80211: fix recalc_radar hwconf sync problem

Thomas Pedersen (3):
      mac80211: unset FC retry bit in mesh fwding path
      mac80211: stringify another plink state
      mac80211: fix ieee80211_queue_stopped()

Wei Yongjun (1):
      rfkill: fix error return code in rfkill_gpio_probe()

 drivers/net/wireless/iwlegacy/4965-mac.c    |  32 ++-
 drivers/net/wireless/iwlegacy/4965.c        |   2 +-
 drivers/net/wireless/iwlwifi/dvm/devices.c  |  10 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |  20 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c     |   2 +-
 drivers/net/wireless/mac80211_hwsim.c       |  69 +++++-
 drivers/net/wireless/ti/wl12xx/cmd.c        |   2 +-
 drivers/net/wireless/ti/wl18xx/cmd.c        |   6 +-
 include/linux/ieee80211.h                   |  43 +++-
 include/net/cfg80211.h                      |  34 +++
 include/net/mac80211.h                      |  90 +++++++-
 include/uapi/linux/nl80211.h                |  39 ++++
 net/mac80211/cfg.c                          |  15 ++
 net/mac80211/chan.c                         |  43 +++-
 net/mac80211/ibss.c                         |   6 +-
 net/mac80211/ieee80211_i.h                  |  18 +-
 net/mac80211/iface.c                        |   5 +-
 net/mac80211/main.c                         |  23 +-
 net/mac80211/mesh.c                         |   4 +-
 net/mac80211/mesh_hwmp.c                    |   2 +-
 net/mac80211/mesh_plink.c                   |   6 +-
 net/mac80211/mlme.c                         | 334 +++++++++++++++++++-----=
----
 net/mac80211/pm.c                           |   3 +-
 net/mac80211/rate.c                         | 324 ++++++++++++++++++++++--=
---
 net/mac80211/rc80211_minstrel.c             | 206 +++++++++--------
 net/mac80211/rc80211_minstrel.h             |   7 +-
 net/mac80211/rc80211_minstrel_debugfs.c     |   4 +-
 net/mac80211/rc80211_minstrel_ht.c          | 172 ++++++++------
 net/mac80211/rc80211_minstrel_ht.h          |   2 +
 net/mac80211/rx.c                           |  24 +-
 net/mac80211/scan.c                         |   2 +-
 net/mac80211/trace.h                        |   8 +-
 net/mac80211/tx.c                           | 142 ++++--------
 net/mac80211/util.c                         |  54 ++++-
 net/rfkill/rfkill-gpio.c                    |   7 +-
 net/wireless/core.h                         |   3 +
 net/wireless/mlme.c                         |   5 +
 net/wireless/nl80211.c                      | 285 +++++++++++++++++-------
 net/wireless/rdev-ops.h                     |  24 +-
 net/wireless/reg.c                          |   2 +-
 net/wireless/trace.h                        |  35 +++
 net/wireless/util.c                         |  28 ++-
 42 files changed, 1526 insertions(+), 616 deletions(-)


--=-yumjUp27kIeQWOpwI3c3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRdUh5AAoJEDBSmw7B7bqr9YgP/j0xLALFwYPJXkoW3FIN1Vd5
v1MFbgJXCOZbTPI6cgQ1N8+hrNIV+p+hl5iijeCb5T9pHuVsSYdB69dLrCfCA/YB
NxnlcdcVf74XtAcwZWxIwHRavVZBk63/HMWtjXPZ/pPvYIAubVkIDhaoQjceiZkE
TOPzKKrepMUfuNkRnC+aHjdLnZLn6mU6cN73Rccf44iObwDyVXvyu3mO2G/4mIZH
wcgJvJz8xdY88/HUeavh7J/mW8OQrdqt36pANmmHnbdpM17IxmLqqpJnStjIwWZE
/s4xEhiQ1UvcKOams3DHZUZNQzHgukFVZh1Mrej9GP5cV+bCqpkur57iPPkX3+d8
6SByJPJCeaejjKZ0q9EEItrYEeY/fki2zArc+SO0fgkHaVAWlp9CA8aGUXFHdp2u
AUyyHc652MiyKzUC37C1X0HmrKDhUmcdCV5E0Qx5POAa0rMRWUMwcSi+E78kVCaa
/y7EdaAwBvTBKkM8ZnYVn+ksshleNVi8Yu96F3PvyqgAC5QxrWkGY2TXy66hoY7w
Xn894oZF2+CwVrGAYZ6e0S76lN/VPiSbo12pBL7WTllzX4aD53P/bvcC5M2i3gYy
B4/7umafnGOUX/WWAlNgI/ShMXDisUXw9Imenq8HFMs/3c1JuylSjz69zw0RiBqh
WRN5O/dz98m4FfjTDprQ
=YHPT
-----END PGP SIGNATURE-----

--=-yumjUp27kIeQWOpwI3c3--

