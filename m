Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46466 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271Ab2GLKPg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 06:15:36 -0400
Message-ID: <1342088129.4531.16.camel@jlt3.sipsolutions.net> (sfid-20120712_121541_700966_1EAF6065)
Subject: pull-request: mac80211-next 2012-07-12
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 12 Jul 2012 12:15:29 +0200
In-Reply-To: <1341946090.4475.31.camel@jlt3.sipsolutions.net> (sfid-20120710_204821_128762_BC016001)
References: <1341946090.4475.31.camel@jlt3.sipsolutions.net>
	 (sfid-20120710_204821_128762_BC016001)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-WbR1orhJqeUhnAKtd1ZX"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WbR1orhJqeUhnAKtd1ZX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Here's a fixed pull request, please take this version. I've included the
fixed version of the API additions/updates for the P2P Device
abstraction, I still don't know if we'll get the actual code done in
time for 3.6 but I didn't want to hang on to these APIs for too long to
avoid conflicts.

I've also included some more fixes for the multi-channel and 60GHz work
as well as a few other fixes.

The "iterate monitor interfaces patch" is new over the previous version
of the pull request.

Thanks,
Johannes

The following changes since commit 4d6d0ae2a088e1e054ef6d96ceb1b41523291e71=
:

  mac80211_hwsim: add testmode code to stop/wake queues (2012-07-06 15:27:1=
5 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git=20

for you to fetch changes up to 685fb72b63faf09a767cc28332545f5830b91be8:

  mac80211: iterate the virtual monitor interface (2012-07-12 12:10:50 +020=
0)

----------------------------------------------------------------
Arik Nemtsov (1):
      mac80211: fix invalid band deref building preq IEs

Christian Lamparter (1):
      mac80211: request TX status for BlockAck Requests

Johannes Berg (19):
      mac80211: update BSS info on AC parameters change
      mac80211: remove unused assignment
      mac80211: remove ieee80211_key_removed
      nl80211: prepare for non-netdev wireless devs
      nl80211: add NL80211_FLAG_NEED_WDEV
      nl80211: retrieve interface data by wdev
      nl80211: don't assume wdev->netdev exists
      cfg80211: use wdev in mgmt-tx/ROC APIs
      cfg80211: use wireless_dev for interface management
      nl80211: send interface after creation
      nl80211: move scan API to wdev
      mac80211: make scan_sdata pointer usable with RCU
      mac80211: track scheduled scan virtual interface
      mac80211: redesign scan RX
      mac80211: optimize ieee80211_rx_status struct layout
      mac80211: add time synchronisation with BSS for assoc
      mac80211: restructure key selection
      cfg80211: fix locking and lockdep complaints
      mac80211: iterate the virtual monitor interface

Nicolas Cavallari (1):
      mac80211: tx: do not drop non-robust mgmt to non-MFP stas.

Sylvain Roger Rieunier (1):
      minstrel_ht: enable frame aggregation for fixed rate

Vladimir Kondratiev (1):
      cfg80211: fix oops due to unassigned set_monitor_enabled callback

 Documentation/DocBook/80211.tmpl                   |    1 -
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   58 +--
 drivers/net/wireless/ath/ath6kl/cfg80211.h         |    6 +-
 drivers/net/wireless/ath/ath6kl/core.c             |    8 +-
 drivers/net/wireless/ath/ath6kl/core.h             |    5 +
 drivers/net/wireless/ath/ath6kl/wmi.c              |   10 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    3 +-
 drivers/net/wireless/iwlegacy/common.c             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c            |    2 +-
 drivers/net/wireless/iwmc3200wifi/cfg80211.c       |    3 +-
 drivers/net/wireless/libertas/cfg.c                |    1 -
 drivers/net/wireless/mwifiex/cfg80211.c            |   27 +-
 drivers/net/wireless/mwifiex/main.c                |    4 +-
 drivers/net/wireless/mwifiex/main.h                |   10 +-
 drivers/net/wireless/orinoco/cfg.c                 |    2 +-
 drivers/net/wireless/rndis_wlan.c                  |    5 +-
 drivers/net/wireless/rt2x00/rt2x00config.c         |    2 +-
 include/linux/nl80211.h                            |    5 +
 include/net/cfg80211.h                             |   75 ++--
 include/net/mac80211.h                             |   40 +-
 net/mac80211/agg-tx.c                              |    3 +-
 net/mac80211/cfg.c                                 |   48 +--
 net/mac80211/debugfs.c                             |    2 -
 net/mac80211/ieee80211_i.h                         |   20 +-
 net/mac80211/iface.c                               |   44 ++-
 net/mac80211/key.c                                 |   20 -
 net/mac80211/main.c                                |    3 +-
 net/mac80211/mlme.c                                |   45 +--
 net/mac80211/offchannel.c                          |    6 +-
 net/mac80211/rc80211_minstrel_ht.c                 |    8 +-
 net/mac80211/rx.c                                  |   49 +--
 net/mac80211/scan.c                                |  116 +++---
 net/mac80211/status.c                              |    9 +-
 net/mac80211/trace.h                               |    6 +-
 net/mac80211/tx.c                                  |   25 +-
 net/mac80211/util.c                                |   11 +
 net/wireless/chan.c                                |    4 +-
 net/wireless/core.c                                |   27 +-
 net/wireless/core.h                                |   11 +-
 net/wireless/mlme.c                                |   34 +-
 net/wireless/nl80211.c                             |  383 ++++++++++++++--=
----
 net/wireless/nl80211.h                             |   16 +-
 net/wireless/scan.c                                |   24 +-
 net/wireless/sme.c                                 |   10 +-
 net/wireless/util.c                                |   17 +-
 45 files changed, 695 insertions(+), 515 deletions(-)


--=-WbR1orhJqeUhnAKtd1ZX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJP/qPCAAoJEDBSmw7B7bqrfogP/3TjUwMC2UbmgLfugDzeGaWw
UDq6CUDxd/frcDMN7xv7Kevfo5cBT5Ike6YzjvOd4jQ+S3JgCiV3+exV9gXGIVhM
Z/1k+tzSp0RanICDCDbMyZWTZU5ziPcS/gpvhLBldDo+dFCrYRyJ0ofZTl9UI41v
tGatZgGjM6MnKeuarvCsGWYNrVqZkLKlN8qUw1Md1sCdOj+gtZzvzLW1C3YKKS6q
3lKCEyVU4gmnu5sYgKWnHoWpVBQw3ssAqLGmEgzjzeK486yBYbFTEr7tCMvuL7xZ
RO7wfjK+9//zpLuhhkNZYGW/+YAj06t2mz96cs/K+TlXzsPTpDXTlwLfXsqlmsfk
qteWVb5ABTVGBuwen25RAqNs7dZnQtk3le7mkLapQ8/sZ3sCbtYXP58l13rEdbPg
eWq4TNyrjWgTwD3Yo6JUrMKdShrJ/92TmbBjTtF4WiaqEosOCbwV5gBPUhirh6CP
QFG58VL0o/9cshQmb9mgjVN273ZCArUYYtJJQsDwJnmB2gbpvEmZ3hW+WuVRY+gT
c9f1dCa3BLLTFxHoIKrDK3wDTZXpLDr0/ciw2QUWGHazn0BOXE0nNXI/PPFRt3rt
fcbFE0lx2ptnW3/lSijU3/qBd9jmTyzsRgKReK0JGlZIpcllpFRE9JZ6/wKTX0b0
mf4hsK6VXGkAm3p6j7Ox
=fc8R
-----END PGP SIGNATURE-----

--=-WbR1orhJqeUhnAKtd1ZX--

