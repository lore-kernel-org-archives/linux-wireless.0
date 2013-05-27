Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52268 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350Ab3E0Mmx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 08:42:53 -0400
Message-ID: <1369658569.14740.11.camel@jlt4.sipsolutions.net> (sfid-20130527_144301_831846_51777608)
Subject: pull-request: mac80211-next 2013-05-27
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 May 2013 14:42:49 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Oq7ccjOElft4AgYvq4+1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Oq7ccjOElft4AgYvq4+1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

I also have a bunch of new things for cfg80211/mac80211. Just like with
iwlwifi, I had to merge my mac80211 tree, so this pulled in some more
changes that looks spurious. Again, a better looking shortlog all the
way at the end.

The biggest change this time is my cfg80211 locking and MLME/SME work,
cleaning up locking there by greatly reducing the number of different
useless locks. Other than that, some relatively minor things.

Please let me know of any problems.

johannes


The following changes since commit f722406faae2d073cc1d01063d1123c35425939e=
:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 0dd83174762ff46356824217e69daf374f794ba4:

  cfg80211: make WoWLAN configuration available to drivers (2013-05-27 14:3=
7:00 +0200)

----------------------------------------------------------------
Alexander Bondar (1):
      mac80211: enable power save only if DTIM period is available

Amitkumar Karwar (1):
      mwifiex: fix memory leak issue when driver unload

Ashok Nagarajan (2):
      mac80211: Move mesh estab_plinks outside mesh_stats debug group
      {cfg,mac}80211: move mandatory rates calculation to cfg80211

Bing Zhao (1):
      mwifiex: clear is_suspended flag when interrupt is received early

Colleen Twitty (2):
      cfg80211: Userspace may inform kernel of mesh auth method.
      mac80211: enable Auth Protocol Identifier on mesh config.

Daniel Drake (1):
      mwifiex: fix setting of multicast filter

David S. Miller (1):
      Merge branch 'wireless'

Felix Fietkau (5):
      ath9k: fix key allocation error handling for powersave keys
      mac80211: fix spurious RCU warning and update documentation
      cfg80211: add support for per-chain signal strength reporting
      mac80211: add support for per-chain signal strength reporting
      cfg80211: fix reporting 64-bit station info tx bytes

Ilan Peer (1):
      nl80211: Add wdev identifier to some nl80211 notifications

Johannes Berg (30):
      cfg80211: fix wiphy_register error path
      cfg80211: fix WoWLAN wakeup tracing
      mac80211: fix IEEE80211_SDATA_DISCONNECT_RESUME
      mac80211: fix HT beacon-based channel switch handling
      mac80211: use just spin_lock() in ieee80211_get_tkip_p2k()
      mac80211: fix AP-mode frame matching
      cfg80211: fix interface down/disconnect state handling
      mac80211: report deauth to cfg80211 for local state change
      cfg80211: fix sending WoWLAN TCP wakeup settings
      mac80211: fix HT beacon-based channel switch handling
      wireless: move crypto constants to ieee80211.h
      mac80211: write memcpy differently for smatch
      cfg80211: use C99 initialisers to simplify code a bit
      cfg80211: check wdev->netdev in connection work
      mac80211: fix queue handling crash
      iwlwifi: mvm: remove P2P_DEVICE support
      mac80211_hwsim: remove P2P_DEVICE support
      mac80211: assign AP_VLAN hw queues correctly
      mac80211: close AP_VLAN interfaces before unregistering all
      Merge remote-tracking branch 'mac80211/master' into mac80211-next
      cfg80211: move cfg80211_get_dev_from_ifindex under wext
      cfg80211: use atomic_t for wiphy counter
      cfg80211: vastly simplify locking
      cfg80211/mac80211: use cfg80211 wdev mutex in mac80211
      cfg80211: simplify and correct P2P-Device scan check
      regulatory: use RCU in regulatory_hint_11d()
      regulatory: remove reg_mutex
      cfg80211: remove some locked wrappers from mlme API
      cfg80211: remove some locked wrappers from sme API
      cfg80211: make WoWLAN configuration available to drivers

John W. Linville (1):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless i=
nto for-davem

Jouni Malinen (1):
      cfg80211: Allow TDLS peer AID to be configured for VHT

Marcel Holtmann (1):
      nl80211: Add generic netlink module alias for cfg80211/nl80211

Oleksij Rempel (1):
      mac80211: add STBC flag for radiotap

Robert P. J. Day (1):
      wireless: fix kerneldoc content in *80211.h files.

Sasha Levin (1):
      mac80211_hwsim: correctly register the platform driver

Stanislaw Gruszka (3):
      ath5k: do not reschedule tx_complete_work on stop
      iwl4965: workaround connection regression on passive channel
      mac80211: fix direct probe auth

Sujith Manoharan (2):
      ath9k: Fix beacon reconfiguration
      ath9k: Update initvals for AR9565

Thommy Jakobsson (1):
      B43: Handle DMA RX descriptor underrun

Vladimir Kondratiev (1):
      cfg80211: add 60GHz regulatory class

 Documentation/DocBook/80211.tmpl                   |   2 -
 drivers/net/wireless/ath/ath5k/base.c              |   5 +
 .../net/wireless/ath/ath9k/ar9565_1p0_initvals.h   | 138 +++----
 drivers/net/wireless/ath/ath9k/main.c              |  10 +-
 drivers/net/wireless/b43/dma.c                     |  19 +
 drivers/net/wireless/b43/dma.h                     |   4 +-
 drivers/net/wireless/b43/main.c                    |  43 +--
 drivers/net/wireless/iwlegacy/4965-mac.c           |   3 +-
 drivers/net/wireless/iwlegacy/commands.h           |   8 -
 drivers/net/wireless/iwlwifi/dvm/commands.h        |   8 -
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |  14 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c             |   6 +-
 drivers/net/wireless/mac80211_hwsim.c              |  22 +-
 drivers/net/wireless/mwifiex/cfg80211.c            |   3 -
 drivers/net/wireless/mwifiex/cmdevt.c              |   1 +
 drivers/net/wireless/mwifiex/main.c                |   1 +
 drivers/net/wireless/mwifiex/sta_ioctl.c           |  21 +-
 include/linux/ieee80211.h                          |   9 +
 include/net/cfg80211.h                             |  86 +++--
 include/net/ieee80211_radiotap.h                   |   7 +
 include/net/mac80211.h                             |  26 +-
 include/uapi/linux/nl80211.h                       |  20 +
 net/mac80211/aes_ccm.c                             |   6 +-
 net/mac80211/cfg.c                                 |  20 +-
 net/mac80211/debugfs_netdev.c                      |  15 +-
 net/mac80211/ht.c                                  |   4 +-
 net/mac80211/ibss.c                                |  49 ++-
 net/mac80211/ieee80211_i.h                         |  29 +-
 net/mac80211/iface.c                               |  18 +-
 net/mac80211/key.c                                 |  24 +-
 net/mac80211/key.h                                 |  15 +-
 net/mac80211/main.c                                |   4 +-
 net/mac80211/mesh.c                                |  38 +-
 net/mac80211/mesh_plink.c                          |   7 +-
 net/mac80211/mlme.c                                | 410 +++++++++--------=
----
 net/mac80211/rate.c                                |   9 +-
 net/mac80211/rx.c                                  |  33 +-
 net/mac80211/sta_info.c                            |   2 +
 net/mac80211/sta_info.h                            |   5 +
 net/mac80211/tkip.c                                |   4 +-
 net/mac80211/util.c                                |  37 +-
 net/mac80211/wep.c                                 |  48 +--
 net/mac80211/wpa.c                                 |  68 ++--
 net/wireless/core.c                                | 235 +++---------
 net/wireless/core.h                                |  91 +----
 net/wireless/debugfs.c                             |   4 +-
 net/wireless/ibss.c                                |  10 +-
 net/wireless/mesh.c                                |   3 +-
 net/wireless/mlme.c                                | 216 +++--------
 net/wireless/nl80211.c                             | 346 ++++++++---------
 net/wireless/reg.c                                 | 136 +++----
 net/wireless/scan.c                                |  47 ++-
 net/wireless/sme.c                                 | 113 ++----
 net/wireless/sysfs.c                               |   4 +-
 net/wireless/trace.h                               |  27 +-
 net/wireless/util.c                                |  39 +-
 net/wireless/wext-compat.c                         |  22 +-
 net/wireless/wext-sme.c                            |  41 +--
 58 files changed, 1130 insertions(+), 1505 deletions(-)




better shortlog, from rc1 merged with wireless/master:

Alexander Bondar (1):
      mac80211: enable power save only if DTIM period is available

Ashok Nagarajan (2):
      mac80211: Move mesh estab_plinks outside mesh_stats debug group
      {cfg,mac}80211: move mandatory rates calculation to cfg80211

Colleen Twitty (2):
      cfg80211: Userspace may inform kernel of mesh auth method.
      mac80211: enable Auth Protocol Identifier on mesh config.

Felix Fietkau (2):
      cfg80211: add support for per-chain signal strength reporting
      mac80211: add support for per-chain signal strength reporting

Johannes Berg (19):
      mac80211: fix HT beacon-based channel switch handling
      wireless: move crypto constants to ieee80211.h
      mac80211: write memcpy differently for smatch
      cfg80211: use C99 initialisers to simplify code a bit
      iwlwifi: mvm: remove P2P_DEVICE support
      mac80211_hwsim: remove P2P_DEVICE support
      mac80211: assign AP_VLAN hw queues correctly
      mac80211: close AP_VLAN interfaces before unregistering all
      Merge remote-tracking branch 'mac80211/master' into mac80211-next
      cfg80211: move cfg80211_get_dev_from_ifindex under wext
      cfg80211: use atomic_t for wiphy counter
      cfg80211: vastly simplify locking
      cfg80211/mac80211: use cfg80211 wdev mutex in mac80211
      cfg80211: simplify and correct P2P-Device scan check
      regulatory: use RCU in regulatory_hint_11d()
      regulatory: remove reg_mutex
      cfg80211: remove some locked wrappers from mlme API
      cfg80211: remove some locked wrappers from sme API
      cfg80211: make WoWLAN configuration available to drivers

Jouni Malinen (1):
      cfg80211: Allow TDLS peer AID to be configured for VHT

Marcel Holtmann (1):
      nl80211: Add generic netlink module alias for cfg80211/nl80211

Oleksij Rempel (1):
      mac80211: add STBC flag for radiotap

Robert P. J. Day (1):
      wireless: fix kerneldoc content in *80211.h files.

Vladimir Kondratiev (1):
      cfg80211: add 60GHz regulatory class


--=-Oq7ccjOElft4AgYvq4+1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRo1TJAAoJEDBSmw7B7bqr9FgP/A6Fer9JhToWj2Ld1dPhsEO9
w767qCTCWl6wiyYaZOOWlYlnjAqXx5QQGtaTHK77vn2Zf+hEj7+QP8NO8np3nu+f
JFmlJdpgjVT//S7JIbLHylIWKqYd9Sr6LgRO75xlykCebUce57uv091Dx6/oMwBu
mzPnHnL9zrOvnITzRPGEWCVF59otp7sIKzf+5b66dzkBH2AFz6b55wahxPmaA3cD
RgTZGgv3AydMJZq4iy2pwFqToig4fVz7FFAiEJUG43PZp+jx2oy+RX5cdMeVeEa3
hFqEUHnRVItwHYzDTeNn7yBaxiiJtSJo4yfujgz3n/puYqJMIuOITYPLlVUgzVpi
EwGjZB+mbzadyt/dUgL76DlOEseP7uz4Wwu3DXDkM/9tst3Oh5AXi0Wkyh75jPNa
8dEN3KPzCGVeL+3L/3CTb1SuOKR55VjfkVbCGkoM6Q54m8pLhOYf2kWgGKsAqA/0
u8PsAfmwYoLpVdXdmQGB+CKUfvnNoGPy06Cs5GiHDyNvj9m4FVFF+OmjqjlNo/Ip
PtJ8I46B5yKZYS5MgmVyHqs5uh45sNK+5UDprQAXOpj/HbY9UixBm1unvtG2HOd7
UqAHJTz4IBAfnw7IhMbp6y7nEJQfmFKxMYyLkUDMcz4BVFHBzbLCORaGGj86wUqz
4n27d6QPdZpdumiOGQkd
=zsu3
-----END PGP SIGNATURE-----

--=-Oq7ccjOElft4AgYvq4+1--

