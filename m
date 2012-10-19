Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54828 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab2JSN5k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 09:57:40 -0400
Message-ID: <1350655090.10678.6.camel@jlt4.sipsolutions.net> (sfid-20121019_155744_558962_0082606F)
Subject: pull-request: mac80211-next 2012-10-19
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 19 Oct 2012 15:58:10 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Zj7IF4gMbq3vC9EDCScq"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Zj7IF4gMbq3vC9EDCScq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Please pull my mac80211-next tree to get the first round of new features
for 3.8. We have:
 * finally, the mac80211 multi-channel work
 * scan improvements:
   - bg scan
   - scan flush
   - forced AP scan
 * cfg80211 tracing
 * a bit of new code to allow implementing SAE (secure authentication of
   equals) in managed mode

Along with a few random improvements, features and fixes.

Thanks to everyone who contributed :)

johannes

----

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37=
:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to d012a605108a482392be80710ea35f1db27c4aa9:

  mac80211: make client powersave independent of interface type (2012-10-19=
 15:43:51 +0200)

----------------------------------------------------------------
Amitkumar Karwar (1):
      cfg80211: code rearrangement to avoid forward declarations

Antonio Quartulli (1):
      nl/cfg80211: force scan using an AP vif if requested

Arend van Spriel (3):
      wireless: drivers: make use of WLAN_EID_VENDOR_SPECIFIC
      wireless: gelic: make use of WLAN_EID_VENDOR_SPECIFIC
      wireless: remove duplicate enum ieee80211_eid definitions

Ashok Nagarajan (1):
      mac80211: move out the non-statistics variable estab_plinks from mesh=
_stat

Beni Lev (2):
      cfg80211: add tracing to rdev-ops
      cfg80211: add cfg80211 exported function tracing

Hila Gonen (1):
      cfg80211: add wrappers for registered_device_ops

Johannes Berg (9):
      mac80211: check channel context methods
      mac80211: track whether to use channel contexts
      mac80211: use channel contexts
      mac80211: track needed RX chains for channel contexts
      mac80211: add channel context iterator
      wireless: use OR operation to set wiphy features
      mac80211: remove unimplemented mesh vendor sync
      mac80211: remove some unused code
      mac80211: use __printf attribute in debugfs

Jouni Malinen (4):
      mac80211: Take status code as parameter to ieee80211_send_auth
      mac80211: Add debug print on unexpect authentication state
      cfg80211: Allow user space to specify non-IEs to SAE Authentication
      mac80211: Allow station mode SAE to be implemented in user space

Mahesh Palivela (3):
      ieee80211: Rename VHT cap struct
      mac80211: VHT peer STA caps
      {nl,cfg}80211: Peer STA VHT caps

Marco Porsch (2):
      mac80211: fix copy-paste typo in Kconfig
      mac80211: make client powersave independent of interface type

Michal Kazior (4):
      mac80211: introduce channel context skeleton code
      mac80211: introduce new ieee80211_ops
      mac80211: use channel context notifications
      mac80211: reuse channels for channel contexts

Mohammed Shafi Shajakhan (1):
      mac80211: Use appropriate debug wrapper

Sam Leffler (4):
      {nl,cfg}80211: add a flags word to scan requests
      cfg80211: add scan flag to indicate its priority
      cfg80211: add support for flushing old scan results
      mac80211: add support for tx to abort low priority scan requests

Sujith Manoharan (2):
      mac80211: Notify new IBSS network creation
      cfg80211: Disallow HT/WEP in IBSS mode

 drivers/net/ethernet/toshiba/ps3_gelic_wireless.c  |    4 +-
 drivers/net/wireless/airo.c                        |    2 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |    4 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 +-
 drivers/net/wireless/hostap/hostap_80211_rx.c      |    2 +-
 drivers/net/wireless/ipw2x00/libipw_rx.c           |    6 +-
 drivers/net/wireless/libertas/mesh.c               |    2 +-
 drivers/net/wireless/mwifiex/cfg80211.c            |    4 +-
 drivers/net/wireless/mwifiex/scan.c                |   13 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c           |    4 +-
 drivers/net/wireless/orinoco/main.h                |    2 +-
 include/linux/ieee80211.h                          |   47 +-
 include/net/cfg80211.h                             |   14 +
 include/net/mac80211.h                             |  101 +-
 include/uapi/linux/nl80211.h                       |   48 +
 net/mac80211/Kconfig                               |    2 +-
 net/mac80211/Makefile                              |    1 +
 net/mac80211/cfg.c                                 |  284 +--
 net/mac80211/chan.c                                |  455 +++-
 net/mac80211/debugfs.h                             |    6 +-
 net/mac80211/debugfs_netdev.c                      |   10 +-
 net/mac80211/driver-ops.h                          |   65 +
 net/mac80211/ibss.c                                |   88 +-
 net/mac80211/ieee80211_i.h                         |  171 +-
 net/mac80211/iface.c                               |   44 +-
 net/mac80211/main.c                                |  105 +-
 net/mac80211/mesh.c                                |   43 +-
 net/mac80211/mesh.h                                |    4 +-
 net/mac80211/mesh_plink.c                          |   14 +-
 net/mac80211/mesh_sync.c                           |   55 +-
 net/mac80211/mlme.c                                |  218 +-
 net/mac80211/offchannel.c                          |    9 +-
 net/mac80211/pm.c                                  |    2 +
 net/mac80211/rate.h                                |   12 +-
 net/mac80211/rx.c                                  |   32 +-
 net/mac80211/scan.c                                |   29 +-
 net/mac80211/sta_info.c                            |   59 +-
 net/mac80211/status.c                              |   15 +-
 net/mac80211/trace.h                               |  112 +
 net/mac80211/tx.c                                  |  281 ++-
 net/mac80211/util.c                                |  143 +-
 net/mac80211/vht.c                                 |   35 +
 net/wireless/Makefile                              |    4 +-
 net/wireless/ap.c                                  |    3 +-
 net/wireless/chan.c                                |   16 +-
 net/wireless/core.c                                |   12 +-
 net/wireless/core.h                                |    6 +-
 net/wireless/ethtool.c                             |   15 +-
 net/wireless/ibss.c                                |    9 +-
 net/wireless/mesh.c                                |   11 +-
 net/wireless/mlme.c                                |   92 +-
 net/wireless/nl80211.c                             |  255 ++-
 net/wireless/rdev-ops.h                            |  861 ++++++++
 net/wireless/scan.c                                |  138 +-
 net/wireless/sme.c                                 |   12 +-
 net/wireless/sysfs.c                               |    5 +-
 net/wireless/trace.c                               |    7 +
 net/wireless/trace.h                               | 2286 ++++++++++++++++=
++++
 net/wireless/util.c                                |   14 +-
 net/wireless/wext-compat.c                         |   48 +-
 60 files changed, 5357 insertions(+), 986 deletions(-)
 create mode 100644 net/mac80211/vht.c
 create mode 100644 net/wireless/rdev-ops.h
 create mode 100644 net/wireless/trace.c
 create mode 100644 net/wireless/trace.h


--=-Zj7IF4gMbq3vC9EDCScq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQgVxyAAoJEDBSmw7B7bqrY0UQAIITeIBCqxT3MAn8OHeWRhcK
pdbt4BHmrmlN3kmyjQ1UhcyLWcBSG5G82yApG6xf7K6cayCa348ufZ1x6x/0xxNC
ZflYtG7tW5qVqaXY4qq7YllJXdVJvKQHWm0NZabkDxlV5sx2kXZwcj8a0vBgICgE
iuMLpOTMFpbAGOzGXpislOvxrzfkt6QEHIP9YN4MMVUV1srPVE/1mmQatxnGTK95
02X9GvjTFHlNVoy4K9S1pzMiwUmD24m5ZVTyy+5b+LZWUgSiMm8WkLHx4ssKsydz
bHcLkQZGXpZFke5a3u55mp/8DeWXDXLq+YHqvjplxLk5rTo/OK4N5UbIXiRBZedR
iww7K7wxbAKF/CtEe+AUiSH8M+/xppiCy82iKRoV4hqc+bMDHSMAlVRAnfZb5xxn
eCGUd4UFV0NpM25aRspfvbK6vwgDBmnYJdrd79HeGmju2s8nYcyokOgZ+3WIRokk
uiAWL3EXf1q5mj/jY4L1kJFeP0Ye5A4zcF4KxvlqmH0qD0Fdd3ICzu6e/Z4F4bSt
luJEqDi+XIWJuMFemkmcRHbjPEMcmKdjBCZD1BdtA6hqXzR5Q/+G57AJu+NoA+MD
jXoEKGFiSF0w30VWNXWy9+8so2veSc/kwYGJFQg94TNxADvqy/h8D6b5og1VBXp/
8HS7inemohd6IZKLop7x
=4ntj
-----END PGP SIGNATURE-----

--=-Zj7IF4gMbq3vC9EDCScq--

